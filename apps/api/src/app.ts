import cors from "cors";
import express, { type NextFunction, type Request, type Response } from "express";
import type pg from "pg";
import { ZodError, z } from "zod";
import { resolveLocale, supportedLocales } from "./locale.js";

const SlugSchema = z.string().regex(/^[a-z0-9-]+$/);
const SearchSchema = z.object({ q: z.string().trim().min(2).max(100), locale: z.string().optional() });
type Database = Pick<pg.Pool, "query">;

/** Build the HTTP application around an injected database for testability. */
export function createApp(db: Database) {
  const app = express();
  app.use(cors());
  app.use(express.json({ limit: "100kb" }));

  app.get("/health", async (_request, response, next) => {
    try { await db.query("SELECT 1"); response.json({ status: "ok", version: "3.1.0" }); } catch (error) { next(error); }
  });

  app.get("/api/locales", (_request, response) => response.json({ locales: supportedLocales, defaultLocale: "zh-CN", fallbackPolicy: "requested published translation, then the work default locale; never silently substitute" }));

  app.get("/api/works", async (request, response, next) => {
    try {
      const locale = resolveLocale(request.query.locale);
      const result = await db.query(`
        SELECT w.slug,w.author_name AS "authorName",w.publication_year AS "publicationYear",w.content_mode AS "contentMode",w.map_layer AS "mapLayer",
          COALESCE(req.title,fb.title) AS title,COALESCE(req.summary,fb.summary) AS summary,
          CASE WHEN req.title IS NULL THEN w.default_locale ELSE $1::locale_code END AS "resolvedLocale",(req.title IS NULL) AS "fallbackUsed",
          COALESCE(req.status,fb.status) AS "translationStatus"
        FROM works w
        LEFT JOIN work_translations req ON req.work_id=w.id AND req.locale=$1 AND req.status='published'
        LEFT JOIN work_translations fb ON fb.work_id=w.id AND fb.locale=w.default_locale AND fb.status='published'
        WHERE req.title IS NOT NULL OR fb.title IS NOT NULL ORDER BY w.launch_rank`, [locale.requestedLocale]);
      response.json({ locale: locale.requestedLocale, items: result.rows });
    } catch (error) { next(error); }
  });

  app.get("/api/works/:slug/atlas", async (request, response, next) => {
    try {
      const slug = SlugSchema.parse(request.params.slug);
      const { requestedLocale } = resolveLocale(request.query.locale);
      const workResult = await db.query(`SELECT w.id,w.slug,w.author_name AS "authorName",w.content_mode AS "contentMode",w.map_layer AS "mapLayer",w.default_locale,
        COALESCE(t.title,f.title) title,COALESCE(t.summary,f.summary) summary,CASE WHEN t.title IS NULL THEN w.default_locale ELSE $2::locale_code END AS "resolvedLocale",(t.title IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus"
        FROM works w LEFT JOIN work_translations t ON t.work_id=w.id AND t.locale=$2 AND t.status='published' LEFT JOIN work_translations f ON f.work_id=w.id AND f.locale=w.default_locale AND f.status='published' WHERE w.slug=$1`, [slug, requestedLocale]);
      const work = workResult.rows[0] as Record<string, unknown> | undefined;
      if (!work) { response.status(404).json({ error: { code: "WORK_NOT_FOUND", message: `Unknown work: ${slug}` } }); return; }
      const workId = z.string().uuid().parse(work.id);
      const [characters, locations, events, routes, relations, sources] = await Promise.all([
        db.query(`SELECT c.slug,COALESCE(t.name,f.name) name,COALESCE(t.summary,f.summary) summary,
          CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
          COALESCE((SELECT json_agg(linked_event.slug ORDER BY linked_event.sequence) FROM event_characters ec JOIN events linked_event ON linked_event.id=ec.event_id WHERE ec.character_id=c.id),'[]'::json) AS "eventSlugs"
          FROM characters c LEFT JOIN character_translations t ON t.character_id=c.id AND t.locale=$2 AND t.status='published' LEFT JOIN character_translations f ON f.character_id=c.id AND f.locale=$3 AND f.status='published'
          WHERE c.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) ORDER BY c.sort_order`, [workId,requestedLocale,work.default_locale]),
        db.query(`SELECT l.slug,l.layer,ST_X(l.geom::geometry) lng,ST_Y(l.geom::geometry) lat,l.canvas_x::float "canvasX",l.canvas_y::float "canvasY",COALESCE(t.name,f.name) name,COALESCE(t.summary,f.summary) summary,
          CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus"
          FROM locations l LEFT JOIN location_translations t ON t.location_id=l.id AND t.locale=$2 AND t.status='published' LEFT JOIN location_translations f ON f.location_id=l.id AND f.locale=$3 AND f.status='published'
          WHERE l.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) ORDER BY l.sort_order`, [workId,requestedLocale,work.default_locale]),
        db.query(`SELECT e.slug,e.start_date::text AS "startDate",e.end_date::text AS "endDate",e.sequence,e.reality,COALESCE(t.title,f.title) title,COALESCE(t.summary,f.summary) summary,
          CASE WHEN t.title IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.title IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
          COALESCE(json_agg(DISTINCT l.slug) FILTER(WHERE l.slug IS NOT NULL),'[]') "locationSlugs",COALESCE(json_agg(DISTINCT s.title) FILTER(WHERE s.title IS NOT NULL),'[]') "sourceTitles"
          FROM events e LEFT JOIN event_translations t ON t.event_id=e.id AND t.locale=$2 AND t.status='published' LEFT JOIN event_translations f ON f.event_id=e.id AND f.locale=$3 AND f.status='published'
          LEFT JOIN event_locations el ON el.event_id=e.id LEFT JOIN locations l ON l.id=el.location_id LEFT JOIN event_sources es ON es.event_id=e.id LEFT JOIN sources s ON s.id=es.source_id
          WHERE e.work_id=$1 AND (t.title IS NOT NULL OR f.title IS NOT NULL) GROUP BY e.id,t.title,t.summary,t.status,f.title,f.summary,f.status ORDER BY e.sequence`, [workId,requestedLocale,work.default_locale]),
        db.query(`SELECT r.id,r.slug,r.layer,r.certainty,COALESCE(t.name,f.name) name,COALESCE(t.summary,f.summary) summary,
          CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
          COALESCE(json_agg(json_build_object('position',rw.position,'locationSlug',l.slug) ORDER BY rw.position) FILTER(WHERE rw.location_id IS NOT NULL),'[]') waypoints
          FROM routes r LEFT JOIN route_translations t ON t.route_id=r.id AND t.locale=$2 AND t.status='published' LEFT JOIN route_translations f ON f.route_id=r.id AND f.locale=$3 AND f.status='published'
          LEFT JOIN route_waypoints rw ON rw.route_id=r.id LEFT JOIN locations l ON l.id=rw.location_id
          WHERE r.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) GROUP BY r.id,t.name,t.summary,t.status,f.name,f.summary,f.status ORDER BY r.sort_order`, [workId,requestedLocale,work.default_locale]),
        db.query(`SELECT fc.slug "fromSlug",tc.slug "toSlug",r.relation_type "relationType",COALESCE(t.label,f.label) label,
          CASE WHEN t.label IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.label IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus"
          FROM character_relations r JOIN characters fc ON fc.id=r.from_character_id JOIN characters tc ON tc.id=r.to_character_id
          LEFT JOIN relation_translations t ON t.relation_id=r.id AND t.locale=$2 AND t.status='published' LEFT JOIN relation_translations f ON f.relation_id=r.id AND f.locale=$3 AND f.status='published'
          WHERE r.work_id=$1 AND (t.label IS NOT NULL OR f.label IS NOT NULL)`, [workId,requestedLocale,work.default_locale]),
        db.query(`SELECT title,url,citation,evidence_grade "evidenceGrade" FROM sources WHERE work_id=$1 ORDER BY evidence_grade`, [workId])
      ]);
      response.json({ requestedLocale, work, characters:characters.rows, locations:locations.rows, events:events.rows, routes:routes.rows, relations:relations.rows, sources:sources.rows });
    } catch (error) { next(error); }
  });

  app.get("/api/search", async (request, response, next) => {
    try {
      const parsed = SearchSchema.parse(request.query);
      const { requestedLocale } = resolveLocale(parsed.locale);
      const result = await db.query(`SELECT kind,slug,label,work_slug AS "workSlug",$1::locale_code AS "resolvedLocale",false AS "fallbackUsed",'published'::translation_status AS "translationStatus" FROM (
        SELECT 'work' kind,w.slug,wt.title label,w.slug work_slug FROM work_translations wt JOIN works w ON w.id=wt.work_id WHERE wt.locale=$1 AND wt.status='published' AND (wt.title||' '||wt.summary) ILIKE '%'||$2||'%'
        UNION ALL SELECT 'character',c.slug,ct.name,w.slug FROM character_translations ct JOIN characters c ON c.id=ct.character_id JOIN works w ON w.id=c.work_id WHERE ct.locale=$1 AND ct.status='published' AND (ct.name||' '||ct.summary) ILIKE '%'||$2||'%'
        UNION ALL SELECT 'event',e.slug,et.title,w.slug FROM event_translations et JOIN events e ON e.id=et.event_id JOIN works w ON w.id=e.work_id WHERE et.locale=$1 AND et.status='published' AND (et.title||' '||et.summary) ILIKE '%'||$2||'%'
        UNION ALL SELECT 'location',l.slug,lt.name,w.slug FROM location_translations lt JOIN locations l ON l.id=lt.location_id JOIN works w ON w.id=l.work_id WHERE lt.locale=$1 AND lt.status='published' AND (lt.name||' '||lt.summary) ILIKE '%'||$2||'%') s LIMIT 50`, [requestedLocale,parsed.q]);
      response.json({ locale: requestedLocale, query: parsed.q, items: result.rows });
    } catch (error) { next(error); }
  });

  app.use((_request, response) => response.status(404).json({ error: { code: "NOT_FOUND", message: "Route not found" } }));
  app.use((error: unknown, _request: Request, response: Response, _next: NextFunction) => {
    if (error instanceof ZodError) { response.status(400).json({ error: { code: "INVALID_REQUEST", message: "Request validation failed", details: error.issues } }); return; }
    console.error(error);
    response.status(500).json({ error: { code: "INTERNAL_ERROR", message: "The server could not complete the request" } });
  });
  return app;
}
