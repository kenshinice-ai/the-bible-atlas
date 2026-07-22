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

  app.get("/api/locales", (_request, response) => response.json({
    locales: supportedLocales,
    defaultLocale: "zh-CN",
    fallbackPolicy: "requested published translation, then the work default locale; never silently substitute",
  }));

  app.get("/api/works", async (request, response, next) => {
    try {
      const locale = resolveLocale(request.query.locale);
      const result = await db.query(`
        SELECT w.slug,w.author_name AS "authorName",w.publication_year AS "publicationYear",w.content_mode AS "contentMode",w.map_layer AS "mapLayer",
          w.category,w.origin_region AS "originRegion",w.chronology_start_year AS "chronologyStartYear",w.chronology_end_year AS "chronologyEndYear",
          w.theme_color AS "themeColor",w.theme_color_dark AS "themeColorDark",w.theme_color_light AS "themeColorLight",
          COALESCE(req.title,fb.title) AS title,COALESCE(req.summary,fb.summary) AS summary,alt.title AS "alternateTitle",
          CASE WHEN req.title IS NULL THEN w.default_locale ELSE $1::locale_code END AS "resolvedLocale",(req.title IS NULL) AS "fallbackUsed",
          COALESCE(req.status,fb.status) AS "translationStatus",
          (SELECT count(*)::int FROM characters c WHERE c.work_id=w.id) AS "characterCount",
          (SELECT count(*)::int FROM events e WHERE e.work_id=w.id) AS "eventCount",
          (SELECT count(*)::int FROM locations l WHERE l.work_id=w.id) AS "locationCount"
        FROM works w
        LEFT JOIN work_translations req ON req.work_id=w.id AND req.locale=$1 AND req.status='published'
        LEFT JOIN work_translations fb ON fb.work_id=w.id AND fb.locale=w.default_locale AND fb.status='published'
        LEFT JOIN work_translations alt ON alt.work_id=w.id AND alt.locale=CASE WHEN $1='zh-CN' THEN 'en'::locale_code ELSE 'zh-CN'::locale_code END AND alt.status='published'
        WHERE req.title IS NOT NULL OR fb.title IS NOT NULL ORDER BY w.launch_rank`, [locale.requestedLocale]);
      response.json({ locale: locale.requestedLocale, items: result.rows });
    } catch (error) { next(error); }
  });

  app.get("/api/works/:slug/atlas", async (request, response, next) => {
    try {
      const slug = SlugSchema.parse(request.params.slug);
      const { requestedLocale } = resolveLocale(request.query.locale);
      const workResult = await db.query(`SELECT w.id,w.slug,w.author_name AS "authorName",w.publication_year AS "publicationYear",w.content_mode AS "contentMode",w.map_layer AS "mapLayer",w.default_locale,
        w.category,w.origin_region AS "originRegion",w.chronology_start_year AS "chronologyStartYear",w.chronology_end_year AS "chronologyEndYear",w.theme_color AS "themeColor",w.theme_color_dark AS "themeColorDark",w.theme_color_light AS "themeColorLight",
        COALESCE(t.title,f.title) title,COALESCE(t.summary,f.summary) summary,CASE WHEN t.title IS NULL THEN w.default_locale ELSE $2::locale_code END AS "resolvedLocale",(t.title IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus"
        FROM works w LEFT JOIN work_translations t ON t.work_id=w.id AND t.locale=$2 AND t.status='published' LEFT JOIN work_translations f ON f.work_id=w.id AND f.locale=w.default_locale AND f.status='published' WHERE w.slug=$1`, [slug, requestedLocale]);
      const work = workResult.rows[0] as Record<string, unknown> | undefined;
      if (!work) { response.status(404).json({ error: { code: "WORK_NOT_FOUND", message: `Unknown work: ${slug}` } }); return; }
      const workId = z.string().uuid().parse(work.id);
      const fallbackLocale=z.enum(supportedLocales).parse(work.default_locale);

      const [characters, locations, events, routes, relations, sources, chronologies, media] = await Promise.all([
        db.query(`SELECT c.id,c.slug,c.gender,c.age_stage AS "ageStage",c.role_type AS "roleType",c.reality_type AS "realityType",c.birth_year AS "birthYear",c.death_year AS "deathYear",c.icon_variant AS "iconVariant",c.importance,
          bp.slug AS "birthPlaceSlug",dp.slug AS "deathPlaceSlug",COALESCE(t.name,f.name) name,COALESCE(t.summary,f.summary) summary,COALESCE(t.aliases,f.aliases,'{}') aliases,COALESCE(t.detail,f.detail,'') detail,COALESCE(t.motivation,f.motivation,'') motivation,
          CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
          COALESCE((SELECT json_agg(linked_event.slug ORDER BY linked_event.sequence) FROM event_characters ec JOIN events linked_event ON linked_event.id=ec.event_id WHERE ec.character_id=c.id),'[]'::json) AS "eventSlugs",
          COALESCE((SELECT json_agg(l.slug ORDER BY cl.is_primary DESC,l.sort_order) FROM character_locations cl JOIN locations l ON l.id=cl.location_id WHERE cl.character_id=c.id),'[]'::json) AS "locationSlugs",
          COALESCE((SELECT json_agg(s.title ORDER BY s.title) FROM character_sources cs JOIN sources s ON s.id=cs.source_id WHERE cs.character_id=c.id),'[]'::json) AS "sourceTitles"
          FROM characters c LEFT JOIN locations bp ON bp.id=c.birth_place_id LEFT JOIN locations dp ON dp.id=c.death_place_id
          LEFT JOIN character_translations t ON t.character_id=c.id AND t.locale=$2 AND t.status='published' LEFT JOIN character_translations f ON f.character_id=c.id AND f.locale=$3 AND f.status='published'
          WHERE c.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) ORDER BY c.importance DESC,c.sort_order`, [workId,requestedLocale,fallbackLocale]),
        db.query(`SELECT l.id,l.slug,l.layer,l.location_type AS "locationType",l.coordinate_accuracy AS "coordinateAccuracy",l.preferred_zoom AS "preferredZoom",l.modern_country_code AS "modernCountryCode",l.is_inferred AS "isInferred",l.still_exists AS "stillExists",
          ST_X(l.geom::geometry) lng,ST_Y(l.geom::geometry) lat,l.canvas_x::float AS "canvasX",l.canvas_y::float AS "canvasY",COALESCE(t.name,f.name) name,COALESCE(t.summary,f.summary) summary,COALESCE(t.aliases,f.aliases,'{}') aliases,COALESCE(t.detail,f.detail,'') detail,
          COALESCE(t.literary_significance,f.literary_significance,'') AS "literarySignificance",COALESCE(t.historical_background,f.historical_background,'') AS "historicalBackground",COALESCE(t.modern_status,f.modern_status,'') AS "modernStatus",COALESCE(t.historical_region_name,f.historical_region_name,'') AS "historicalRegionName",
          CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
          COALESCE((SELECT json_agg(c.slug ORDER BY c.importance DESC,c.sort_order) FROM character_locations cl JOIN characters c ON c.id=cl.character_id WHERE cl.location_id=l.id),'[]'::json) AS "characterSlugs",
          COALESCE((SELECT json_agg(e.slug ORDER BY e.sequence) FROM event_locations el JOIN events e ON e.id=el.event_id WHERE el.location_id=l.id),'[]'::json) AS "eventSlugs",
          COALESCE((SELECT json_agg(DISTINCT r.slug) FROM route_waypoints rw JOIN routes r ON r.id=rw.route_id WHERE rw.location_id=l.id),'[]'::json) AS "routeSlugs"
          FROM locations l LEFT JOIN location_translations t ON t.location_id=l.id AND t.locale=$2 AND t.status='published' LEFT JOIN location_translations f ON f.location_id=l.id AND f.locale=$3 AND f.status='published'
          WHERE l.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) ORDER BY l.sort_order`, [workId,requestedLocale,fallbackLocale]),
        db.query(`SELECT e.id,e.slug,e.start_date::text AS "startDate",e.end_date::text AS "endDate",e.sequence,e.reality,e.event_type AS "eventType",e.time_type AS "timeType",e.calendar_system AS "calendarSystem",e.historical_start_year AS "historicalStartYear",e.historical_end_year AS "historicalEndYear",e.start_month AS "startMonth",e.start_day AS "startDay",e.confidence,parent.slug AS "parentEventSlug",
          COALESCE(t.title,f.title) title,COALESCE(t.summary,f.summary) summary,COALESCE(t.detail,f.detail,'') detail,COALESCE(t.significance,f.significance,'') significance,COALESCE(t.time_label,f.time_label,'') AS "timeLabel",
          CASE WHEN t.title IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.title IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
          COALESCE((SELECT json_agg(l.slug ORDER BY el.position,l.sort_order) FROM event_locations el JOIN locations l ON l.id=el.location_id WHERE el.event_id=e.id),'[]'::json) AS "locationSlugs",
          COALESCE((SELECT json_agg(c.slug ORDER BY ec.participant_order,c.importance DESC) FROM event_characters ec JOIN characters c ON c.id=ec.character_id WHERE ec.event_id=e.id),'[]'::json) AS "characterSlugs",
          COALESCE((SELECT json_agg(s.title ORDER BY s.title) FROM event_sources es JOIN sources s ON s.id=es.source_id WHERE es.event_id=e.id),'[]'::json) AS "sourceTitles",
          COALESCE((SELECT json_agg(DISTINCT r.slug) FROM route_waypoints rw JOIN routes r ON r.id=rw.route_id WHERE rw.event_id=e.id),'[]'::json) AS "routeSlugs"
          FROM events e LEFT JOIN events parent ON parent.id=e.parent_event_id LEFT JOIN event_translations t ON t.event_id=e.id AND t.locale=$2 AND t.status='published' LEFT JOIN event_translations f ON f.event_id=e.id AND f.locale=$3 AND f.status='published'
          WHERE e.work_id=$1 AND (t.title IS NOT NULL OR f.title IS NOT NULL) ORDER BY e.sequence`, [workId,requestedLocale,fallbackLocale]),
        db.query(`SELECT r.id,r.slug,r.layer,r.certainty,COALESCE(t.name,f.name) name,COALESCE(t.summary,f.summary) summary,
          CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
          COALESCE(json_agg(json_build_object('position',rw.position,'locationSlug',l.slug,'eventSlug',e.slug) ORDER BY rw.position) FILTER(WHERE rw.location_id IS NOT NULL),'[]') waypoints
          FROM routes r LEFT JOIN route_translations t ON t.route_id=r.id AND t.locale=$2 AND t.status='published' LEFT JOIN route_translations f ON f.route_id=r.id AND f.locale=$3 AND f.status='published'
          LEFT JOIN route_waypoints rw ON rw.route_id=r.id LEFT JOIN locations l ON l.id=rw.location_id LEFT JOIN events e ON e.id=rw.event_id
          WHERE r.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) GROUP BY r.id,t.name,t.summary,t.status,f.name,f.summary,f.status ORDER BY r.sort_order`, [workId,requestedLocale,fallbackLocale]),
        db.query(`SELECT r.id,fc.slug AS "fromSlug",tc.slug AS "toSlug",r.relation_type AS "relationType",r.direction,r.sentiment,r.strength,r.status,se.slug AS "startEventSlug",ee.slug AS "endEventSlug",COALESCE(t.label,f.label) label,COALESCE(t.summary,f.summary,'') summary,
          CASE WHEN t.label IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.label IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
          COALESCE((SELECT json_agg(s.title ORDER BY s.title) FROM relation_sources rs JOIN sources s ON s.id=rs.source_id WHERE rs.relation_id=r.id),'[]'::json) AS "sourceTitles"
          FROM character_relations r JOIN characters fc ON fc.id=r.from_character_id JOIN characters tc ON tc.id=r.to_character_id LEFT JOIN events se ON se.id=r.start_event_id LEFT JOIN events ee ON ee.id=r.end_event_id
          LEFT JOIN relation_translations t ON t.relation_id=r.id AND t.locale=$2 AND t.status='published' LEFT JOIN relation_translations f ON f.relation_id=r.id AND f.locale=$3 AND f.status='published'
          WHERE r.work_id=$1 AND (t.label IS NOT NULL OR f.label IS NOT NULL) ORDER BY r.strength DESC,r.id`, [workId,requestedLocale,fallbackLocale]),
        db.query(`SELECT id,title,url,citation,evidence_grade AS "evidenceGrade",source_type AS "sourceType" FROM sources WHERE work_id=$1 ORDER BY evidence_grade,title`, [workId]),
        db.query(`SELECT id,kind,label,start_year AS "startYear",end_year AS "endYear",calendar_system AS "calendarSystem",is_default AS "isDefault" FROM work_chronologies WHERE work_id=$1 ORDER BY is_default DESC,kind`, [workId]),
        db.query(`SELECT ma.id,ml.entity_kind AS "entityKind",ml.entity_id AS "entityId",ma.asset_source AS "assetSource",ma.asset_licence AS "assetLicence",ma.asset_author AS "assetAuthor",ma.asset_url AS "assetUrl",ma.attribution_text AS "attributionText",CASE WHEN $2='zh-CN' THEN ma.alt_text_zh ELSE ma.alt_text_en END AS "altText"
          FROM media_assets ma JOIN media_links ml ON ml.media_id=ma.id WHERE ml.entity_id=$1 OR ml.entity_id IN (SELECT id FROM characters WHERE work_id=$1 UNION SELECT id FROM events WHERE work_id=$1 UNION SELECT id FROM locations WHERE work_id=$1 UNION SELECT id FROM routes WHERE work_id=$1 UNION SELECT id FROM character_relations WHERE work_id=$1) ORDER BY ml.sort_order`, [workId,requestedLocale]),
      ]);
      response.json({ requestedLocale, work, characters:characters.rows, locations:locations.rows, events:events.rows, routes:routes.rows, relations:relations.rows, sources:sources.rows, chronologies:chronologies.rows, media:media.rows });
    } catch (error) { next(error); }
  });

  app.get("/api/search", async (request, response, next) => {
    try {
      const parsed = SearchSchema.parse(request.query);
      const { requestedLocale } = resolveLocale(parsed.locale);
      const result = await db.query(`SELECT kind,slug,label,work_slug AS "workSlug",$1::locale_code AS "resolvedLocale",false AS "fallbackUsed",'published'::translation_status AS "translationStatus" FROM (
        SELECT 'work' kind,w.slug,wt.title label,w.slug work_slug FROM work_translations wt JOIN works w ON w.id=wt.work_id WHERE wt.locale=$1 AND wt.status='published' AND (wt.title||' '||wt.summary||' '||w.author_name||' '||w.origin_region||' '||w.category::text) ILIKE '%'||$2||'%'
        UNION ALL SELECT 'character',c.slug,ct.name,w.slug FROM character_translations ct JOIN characters c ON c.id=ct.character_id JOIN works w ON w.id=c.work_id WHERE ct.locale=$1 AND ct.status='published' AND (ct.name||' '||ct.summary||' '||array_to_string(ct.aliases,' ')) ILIKE '%'||$2||'%'
        UNION ALL SELECT 'event',e.slug,et.title,w.slug FROM event_translations et JOIN events e ON e.id=et.event_id JOIN works w ON w.id=e.work_id WHERE et.locale=$1 AND et.status='published' AND (et.title||' '||et.summary||' '||et.detail) ILIKE '%'||$2||'%'
        UNION ALL SELECT 'location',l.slug,lt.name,w.slug FROM location_translations lt JOIN locations l ON l.id=lt.location_id JOIN works w ON w.id=l.work_id WHERE lt.locale=$1 AND lt.status='published' AND (lt.name||' '||lt.summary||' '||array_to_string(lt.aliases,' ')) ILIKE '%'||$2||'%') s LIMIT 50`, [requestedLocale,parsed.q]);
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
