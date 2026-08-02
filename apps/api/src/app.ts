import cors from "cors";
import express, { type NextFunction, type Request, type Response } from "express";
import type pg from "pg";
import { ZodError, z } from "zod";
import { resolveLocale, supportedLocales } from "./locale.js";

const SlugSchema = z.string().regex(/^[a-z0-9-]+$/);
const SearchSchema = z.object({ q: z.string().trim().min(2).max(100), locale: z.string().optional() });
const DetailSchema = z.enum(["lite", "full"]).catch("lite");
const EntityKindSchema = z.enum(["character", "event", "location", "route", "relationship", "artist", "artwork", "movement", "institution"]);
type Database = Pick<pg.Pool, "query">;

/**
 * v4 splits the atlas into an index payload and per-entity detail. The index has
 * to stay small enough to hold every entity of a work at once — that is what
 * removes the need for entity-count caps — so the long prose columns are only
 * sent when a caller explicitly asks for them or opens one entity.
 */
const LONG_TEXT = {
  character: ["detail", "motivation"],
  location: ["detail", "literary_significance", "historical_background", "modern_status"],
  event: ["detail", "significance"],
} as const;

function textColumn(table: "character" | "location" | "event", column: string, alias: string, detail: "lite" | "full"): string {
  const omit = detail === "lite" && (LONG_TEXT[table] as readonly string[]).includes(column);
  return omit ? `'' AS "${alias}"` : `COALESCE(t.${column},f.${column},'') AS "${alias}"`;
}

/**
 * Build the HTTP application around an injected database for testability.
 * `corsOrigin` defaults to `*` for local development; production sets
 * CORS_ORIGIN to the site origin (comma-separated list allowed).
 */
export function createApp(db: Database, corsOrigin: string = process.env.CORS_ORIGIN ?? "*") {
  const app = express();
  const origins = corsOrigin.split(",").map((origin) => origin.trim()).filter(Boolean);
  app.use(cors(origins.length === 0 || origins.includes("*") ? {} : { origin: origins }));
  app.use(express.json({ limit: "100kb" }));

  app.get("/health", async (_request, response, next) => {
    try { await db.query("SELECT 1"); response.json({ status: "ok", version: "4.0.0" }); } catch (error) { next(error); }
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
          (SELECT count(*)::int FROM locations l WHERE l.work_id=w.id) AS "locationCount",
          (SELECT count(*)::int FROM artists a WHERE a.work_id=w.id) AS "artistCount",
          (SELECT count(*)::int FROM artworks aw WHERE aw.work_id=w.id) AS "artworkCount",
          (SELECT count(*)::int FROM movements m WHERE m.work_id=w.id) AS "movementCount"
        FROM works w
        LEFT JOIN work_translations req ON req.work_id=w.id AND req.locale=$1 AND req.status='published'
        LEFT JOIN work_translations fb ON fb.work_id=w.id AND fb.locale=w.default_locale AND fb.status='published'
        LEFT JOIN work_translations alt ON alt.work_id=w.id AND alt.locale=CASE WHEN $1='zh-CN' THEN 'en'::locale_code ELSE 'zh-CN'::locale_code END AND alt.status='published'
        WHERE req.title IS NOT NULL OR fb.title IS NOT NULL ORDER BY w.launch_rank`, [locale.requestedLocale]);
      response.json({ locale: locale.requestedLocale, items: result.rows });
    } catch (error) { next(error); }
  });

  async function loadWork(slug: string, requestedLocale: string) {
    const result = await db.query(`SELECT w.id,w.slug,w.author_name AS "authorName",w.publication_year AS "publicationYear",w.content_mode AS "contentMode",w.map_layer AS "mapLayer",w.default_locale,
      w.category,w.origin_region AS "originRegion",w.chronology_start_year AS "chronologyStartYear",w.chronology_end_year AS "chronologyEndYear",w.theme_color AS "themeColor",w.theme_color_dark AS "themeColorDark",w.theme_color_light AS "themeColorLight",
      COALESCE(t.title,f.title) title,COALESCE(t.summary,f.summary) summary,CASE WHEN t.title IS NULL THEN w.default_locale ELSE $2::locale_code END AS "resolvedLocale",(t.title IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus"
      FROM works w LEFT JOIN work_translations t ON t.work_id=w.id AND t.locale=$2 AND t.status='published' LEFT JOIN work_translations f ON f.work_id=w.id AND f.locale=w.default_locale AND f.status='published' WHERE w.slug=$1`, [slug, requestedLocale]);
    return result.rows[0] as Record<string, unknown> | undefined;
  }

  // Localised source titles; sources are the last strings that used to leak English
  // into a zh-CN reading, so every join below goes through source_translations.
  const sourceTitle = `COALESCE(st.title,sf.title,s.title)`;
  const sourceJoin = (alias: string) => `LEFT JOIN source_translations st ON st.source_id=${alias}.id AND st.locale=$2 AND st.status='published'
    LEFT JOIN source_translations sf ON sf.source_id=${alias}.id AND sf.locale=$3 AND sf.status='published'`;

  app.get("/api/works/:slug/atlas", async (request, response, next) => {
    try {
      const slug = SlugSchema.parse(request.params.slug);
      const detail = DetailSchema.parse(request.query.detail);
      const { requestedLocale } = resolveLocale(request.query.locale);
      const work = await loadWork(slug, requestedLocale);
      if (!work) { response.status(404).json({ error: { code: "WORK_NOT_FOUND", message: `Unknown work: ${slug}` } }); return; }
      const workId = z.string().uuid().parse(work.id);
      const fallbackLocale = z.enum(supportedLocales).parse(work.default_locale);
      const args = [workId, requestedLocale, fallbackLocale];

      const [characters, locations, events, routes, relations, sources, chronologies, media, chapters, groups] = await Promise.all([
        db.query(`SELECT c.id,c.slug,c.gender,c.age_stage AS "ageStage",c.role_type AS "roleType",c.reality_type AS "realityType",c.birth_year AS "birthYear",c.death_year AS "deathYear",c.icon_variant AS "iconVariant",c.importance,
          (SELECT a.slug FROM artists a WHERE a.character_id=c.id) AS "artistSlug",
          bp.slug AS "birthPlaceSlug",dp.slug AS "deathPlaceSlug",COALESCE(t.name,f.name) name,COALESCE(t.summary,f.summary) summary,COALESCE(t.aliases,f.aliases,'{}') aliases,
          ${textColumn("character", "detail", "detail", detail)},${textColumn("character", "motivation", "motivation", detail)},
          CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
          COALESCE((SELECT json_agg(linked_event.slug ORDER BY linked_event.sequence) FROM event_characters ec JOIN events linked_event ON linked_event.id=ec.event_id WHERE ec.character_id=c.id),'[]'::json) AS "eventSlugs",
          COALESCE((SELECT json_agg(l.slug ORDER BY cl.is_primary DESC,l.sort_order) FROM character_locations cl JOIN locations l ON l.id=cl.location_id WHERE cl.character_id=c.id),'[]'::json) AS "locationSlugs",
          COALESCE((SELECT json_agg(${sourceTitle} ORDER BY ${sourceTitle}) FROM character_sources cs JOIN sources s ON s.id=cs.source_id ${sourceJoin("s")} WHERE cs.character_id=c.id),'[]'::json) AS "sourceTitles",
          COALESCE((SELECT json_agg(g.slug ORDER BY g.sort_order) FROM character_group_members m JOIN character_groups g ON g.id=m.group_id WHERE m.character_id=c.id),'[]'::json) AS "groupSlugs",
          (SELECT ch.slug FROM event_characters ec JOIN events e ON e.id=ec.event_id JOIN chapters ch ON ch.id=e.chapter_id WHERE ec.character_id=c.id ORDER BY e.sequence LIMIT 1) AS "chapterSlug",
          (SELECT min(e.sequence) FROM event_characters ec JOIN events e ON e.id=ec.event_id WHERE ec.character_id=c.id) AS "firstSequence",
          (SELECT max(e.sequence) FROM event_characters ec JOIN events e ON e.id=ec.event_id WHERE ec.character_id=c.id) AS "lastSequence"
          FROM characters c LEFT JOIN locations bp ON bp.id=c.birth_place_id LEFT JOIN locations dp ON dp.id=c.death_place_id
          LEFT JOIN character_translations t ON t.character_id=c.id AND t.locale=$2 AND t.status='published' LEFT JOIN character_translations f ON f.character_id=c.id AND f.locale=$3 AND f.status='published'
          WHERE c.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) ORDER BY c.importance DESC,c.sort_order`, args),
        db.query(`SELECT l.id,l.slug,l.layer,l.location_type AS "locationType",l.coordinate_accuracy AS "coordinateAccuracy",l.preferred_zoom AS "preferredZoom",l.modern_country_code AS "modernCountryCode",l.is_inferred AS "isInferred",l.still_exists AS "stillExists",
          ST_X(l.geom::geometry) lng,ST_Y(l.geom::geometry) lat,l.canvas_x::float AS "canvasX",l.canvas_y::float AS "canvasY",COALESCE(t.name,f.name) name,COALESCE(t.summary,f.summary) summary,COALESCE(t.aliases,f.aliases,'{}') aliases,
          ${textColumn("location", "detail", "detail", detail)},${textColumn("location", "literary_significance", "literarySignificance", detail)},
          ${textColumn("location", "historical_background", "historicalBackground", detail)},${textColumn("location", "modern_status", "modernStatus", detail)},
          COALESCE(t.historical_region_name,f.historical_region_name,'') AS "historicalRegionName",
          CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
          COALESCE((SELECT json_agg(c.slug ORDER BY c.importance DESC,c.sort_order) FROM character_locations cl JOIN characters c ON c.id=cl.character_id WHERE cl.location_id=l.id),'[]'::json) AS "characterSlugs",
          COALESCE((SELECT json_agg(e.slug ORDER BY e.sequence) FROM event_locations el JOIN events e ON e.id=el.event_id WHERE el.location_id=l.id),'[]'::json) AS "eventSlugs",
          COALESCE((SELECT json_agg(DISTINCT r.slug) FROM route_waypoints rw JOIN routes r ON r.id=rw.route_id WHERE rw.location_id=l.id),'[]'::json) AS "routeSlugs",
          (SELECT min(e.sequence) FROM event_locations el JOIN events e ON e.id=el.event_id WHERE el.location_id=l.id) AS "firstSequence",
          (SELECT max(e.sequence) FROM event_locations el JOIN events e ON e.id=el.event_id WHERE el.location_id=l.id) AS "lastSequence",
          (SELECT min(e.historical_start_year) FROM event_locations el JOIN events e ON e.id=el.event_id WHERE el.location_id=l.id) AS "firstYear",
          (SELECT max(COALESCE(e.historical_end_year,e.historical_start_year)) FROM event_locations el JOIN events e ON e.id=el.event_id WHERE el.location_id=l.id) AS "lastYear"
          FROM locations l LEFT JOIN location_translations t ON t.location_id=l.id AND t.locale=$2 AND t.status='published' LEFT JOIN location_translations f ON f.location_id=l.id AND f.locale=$3 AND f.status='published'
          WHERE l.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) ORDER BY l.sort_order`, args),
        db.query(`SELECT e.id,e.slug,e.start_date::text AS "startDate",e.end_date::text AS "endDate",e.sequence,e.reality,e.event_type AS "eventType",e.time_type AS "timeType",e.calendar_system AS "calendarSystem",e.historical_start_year AS "historicalStartYear",e.historical_end_year AS "historicalEndYear",e.start_month AS "startMonth",e.start_day AS "startDay",e.confidence,parent.slug AS "parentEventSlug",ch.slug AS "chapterSlug",
          COALESCE(t.title,f.title) title,COALESCE(t.summary,f.summary) summary,
          ${textColumn("event", "detail", "detail", detail)},${textColumn("event", "significance", "significance", detail)},
          COALESCE(t.time_label,f.time_label,'') AS "timeLabel",
          CASE WHEN t.title IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.title IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
          COALESCE((SELECT json_agg(l.slug ORDER BY el.position,l.sort_order) FROM event_locations el JOIN locations l ON l.id=el.location_id WHERE el.event_id=e.id),'[]'::json) AS "locationSlugs",
          COALESCE((SELECT json_agg(c.slug ORDER BY ec.participant_order,c.importance DESC) FROM event_characters ec JOIN characters c ON c.id=ec.character_id WHERE ec.event_id=e.id),'[]'::json) AS "characterSlugs",
          COALESCE((SELECT json_agg(${sourceTitle} ORDER BY ${sourceTitle}) FROM event_sources es JOIN sources s ON s.id=es.source_id ${sourceJoin("s")} WHERE es.event_id=e.id),'[]'::json) AS "sourceTitles",
          COALESCE((SELECT json_agg(DISTINCT r.slug) FROM route_waypoints rw JOIN routes r ON r.id=rw.route_id WHERE rw.event_id=e.id),'[]'::json) AS "routeSlugs"
          FROM events e LEFT JOIN events parent ON parent.id=e.parent_event_id LEFT JOIN chapters ch ON ch.id=e.chapter_id
          LEFT JOIN event_translations t ON t.event_id=e.id AND t.locale=$2 AND t.status='published' LEFT JOIN event_translations f ON f.event_id=e.id AND f.locale=$3 AND f.status='published'
          WHERE e.work_id=$1 AND (t.title IS NOT NULL OR f.title IS NOT NULL) ORDER BY e.sequence`, args),
        db.query(`SELECT r.id,r.slug,r.layer,r.certainty,COALESCE(t.name,f.name) name,COALESCE(t.summary,f.summary) summary,
          CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
          COALESCE(json_agg(json_build_object('position',rw.position,'locationSlug',l.slug,'eventSlug',e.slug) ORDER BY rw.position) FILTER(WHERE rw.location_id IS NOT NULL),'[]') waypoints
          FROM routes r LEFT JOIN route_translations t ON t.route_id=r.id AND t.locale=$2 AND t.status='published' LEFT JOIN route_translations f ON f.route_id=r.id AND f.locale=$3 AND f.status='published'
          LEFT JOIN route_waypoints rw ON rw.route_id=r.id LEFT JOIN locations l ON l.id=rw.location_id LEFT JOIN events e ON e.id=rw.event_id
          WHERE r.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) GROUP BY r.id,t.name,t.summary,t.status,f.name,f.summary,f.status ORDER BY r.sort_order`, args),
        db.query(`SELECT r.id,fc.slug AS "fromSlug",tc.slug AS "toSlug",r.relation_type AS "relationType",r.direction,r.sentiment,r.strength,r.status,se.slug AS "startEventSlug",ee.slug AS "endEventSlug",COALESCE(t.label,f.label) label,COALESCE(t.summary,f.summary,'') summary,
          CASE WHEN t.label IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.label IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
          COALESCE((SELECT json_agg(${sourceTitle} ORDER BY ${sourceTitle}) FROM relation_sources rs JOIN sources s ON s.id=rs.source_id ${sourceJoin("s")} WHERE rs.relation_id=r.id),'[]'::json) AS "sourceTitles"
          FROM character_relations r JOIN characters fc ON fc.id=r.from_character_id JOIN characters tc ON tc.id=r.to_character_id LEFT JOIN events se ON se.id=r.start_event_id LEFT JOIN events ee ON ee.id=r.end_event_id
          LEFT JOIN relation_translations t ON t.relation_id=r.id AND t.locale=$2 AND t.status='published' LEFT JOIN relation_translations f ON f.relation_id=r.id AND f.locale=$3 AND f.status='published'
          WHERE r.work_id=$1 AND (t.label IS NOT NULL OR f.label IS NOT NULL) ORDER BY r.strength DESC,r.id`, args),
        db.query(`SELECT s.id,${sourceTitle} AS title,s.url,COALESCE(st.citation,sf.citation,s.citation) AS citation,s.evidence_grade AS "evidenceGrade",s.source_type AS "sourceType"
          FROM sources s ${sourceJoin("s")} WHERE s.work_id=$1 ORDER BY s.evidence_grade,1`, args),
        db.query(`SELECT id,kind,label,start_year AS "startYear",end_year AS "endYear",calendar_system AS "calendarSystem",is_default AS "isDefault" FROM work_chronologies WHERE work_id=$1 ORDER BY is_default DESC,kind`, [workId]),
        db.query(`SELECT ma.id,ml.entity_kind AS "entityKind",ml.entity_id AS "entityId",ma.media_kind AS "mediaKind",ma.usage_mode AS "usageMode",ma.license_status AS "licenseStatus",ma.license_url AS "licenseUrl",ma.source_page_url AS "sourcePageUrl",ma.original_url AS "originalUrl",ma.asset_source AS "assetSource",ma.asset_licence AS "assetLicence",ma.asset_author AS "assetAuthor",ma.asset_url AS "assetUrl",ma.attribution_text AS "attributionText",CASE WHEN $2='zh-CN' THEN ma.alt_text_zh ELSE ma.alt_text_en END AS "altText"
          FROM media_assets ma JOIN media_links ml ON ml.media_id=ma.id WHERE ml.entity_id IN (SELECT id FROM characters WHERE work_id=$1 UNION SELECT id FROM events WHERE work_id=$1 UNION SELECT id FROM locations WHERE work_id=$1 UNION SELECT id FROM routes WHERE work_id=$1 UNION SELECT id FROM character_relations WHERE work_id=$1 UNION SELECT id FROM artists WHERE work_id=$1 UNION SELECT id FROM artworks WHERE work_id=$1 UNION SELECT id FROM movements WHERE work_id=$1 UNION SELECT id FROM art_institutions WHERE work_id=$1) ORDER BY ml.sort_order`, [workId, requestedLocale]),
        // Chapters are the era tier of the zoom hierarchy: they carry bilingual
        // names, a colour and year bounds, and every event belongs to exactly one.
        db.query(`SELECT ch.id,ch.slug,ch.sequence,ch.reference_label AS "referenceLabel",ch.era_start_year AS "eraStartYear",ch.era_end_year AS "eraEndYear",ch.accent_color AS "accentColor",
          COALESCE(t.title,f.title,ch.reference_label) title,COALESCE(t.summary,f.summary,'') summary,
          (SELECT count(*)::int FROM events e WHERE e.chapter_id=ch.id) AS "eventCount",
          (SELECT min(e.sequence) FROM events e WHERE e.chapter_id=ch.id) AS "firstSequence",
          (SELECT max(e.sequence) FROM events e WHERE e.chapter_id=ch.id) AS "lastSequence"
          FROM chapters ch LEFT JOIN chapter_translations t ON t.chapter_id=ch.id AND t.locale=$2 AND t.status='published'
          LEFT JOIN chapter_translations f ON f.chapter_id=ch.id AND f.locale=$3 AND f.status='published'
          WHERE ch.work_id=$1 ORDER BY ch.sequence`, args),
        db.query(`SELECT g.id,g.slug,g.group_type AS "groupType",g.sort_order AS "sortOrder",g.accent_color AS "accentColor",ac.slug AS "anchorCharacterSlug",
          COALESCE(t.name,f.name,g.slug) name,COALESCE(t.summary,f.summary,'') summary,
          COALESCE((SELECT json_agg(c.slug ORDER BY c.importance DESC,c.sort_order) FROM character_group_members m JOIN characters c ON c.id=m.character_id WHERE m.group_id=g.id),'[]'::json) AS "characterSlugs"
          FROM character_groups g LEFT JOIN characters ac ON ac.id=g.anchor_character_id
          LEFT JOIN character_group_translations t ON t.group_id=g.id AND t.locale=$2 AND t.status='published'
          LEFT JOIN character_group_translations f ON f.group_id=g.id AND f.locale=$3 AND f.status='published'
          WHERE g.work_id=$1 ORDER BY g.sort_order`, args),
      ]);
      const [artists, artworks, movements, institutions] = await Promise.all([
        db.query(`SELECT a.id,a.slug,ac.slug AS "characterSlug",a.artist_kind AS "artistKind",a.birth_year AS "birthYear",a.death_year AS "deathYear",a.importance,bp.slug AS "birthPlaceSlug",dp.slug AS "deathPlaceSlug",COALESCE(t.name,f.name) name,COALESCE(t.full_name,t.name,f.full_name,f.name) AS "fullName",COALESCE(t.aliases,f.aliases,'{}') AS aliases,COALESCE(t.formal_titles,f.formal_titles,'{}') AS "formalTitles",COALESCE(t.summary,f.summary) summary,COALESCE(t.modern_status,f.modern_status,'') AS "modernStatus",COALESCE(t.period_titles,f.period_titles,'{}') AS "periodTitles",(SELECT ch.slug FROM chapters ch WHERE ch.id=a.chapter_id) AS "chapterSlug",CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
          COALESCE((SELECT json_agg(DISTINCT aw.slug) FROM artist_artworks aa JOIN artworks aw ON aw.id=aa.artwork_id WHERE aa.artist_id=a.id),'[]'::json) AS "artworkSlugs",COALESCE((SELECT json_agg(DISTINCT m.slug) FROM artist_movements am JOIN movements m ON m.id=am.movement_id WHERE am.artist_id=a.id),'[]'::json) AS "movementSlugs",COALESCE((SELECT json_agg(e.slug ORDER BY e.sequence) FROM artist_event_links ae JOIN events e ON e.id=ae.event_id WHERE ae.artist_id=a.id),'[]'::json) AS "eventSlugs",COALESCE((SELECT json_agg(DISTINCT l.slug) FROM artist_locations al JOIN locations l ON l.id=al.location_id WHERE al.artist_id=a.id),'[]'::json) AS "locationSlugs",COALESCE((SELECT json_agg(${sourceTitle} ORDER BY ${sourceTitle}) FROM artist_sources asrc JOIN sources s ON s.id=asrc.source_id ${sourceJoin("s")} WHERE asrc.artist_id=a.id),'[]'::json) AS "sourceTitles"
          FROM artists a LEFT JOIN characters ac ON ac.id=a.character_id LEFT JOIN locations bp ON bp.id=a.birth_location_id LEFT JOIN locations dp ON dp.id=a.death_location_id LEFT JOIN artist_translations t ON t.artist_id=a.id AND t.locale=$2 AND t.status='published' LEFT JOIN artist_translations f ON f.artist_id=a.id AND f.locale=$3 AND f.status='published' WHERE a.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) ORDER BY a.importance DESC,a.sort_order`, args),
        db.query(`SELECT aw.id,aw.slug,pa.slug AS "primaryArtistSlug",(SELECT ch.slug FROM chapters ch WHERE ch.id=aw.chapter_id) AS "chapterSlug",aw.creation_start_year AS "creationStartYear",aw.creation_end_year AS "creationEndYear",aw.creation_time_type AS "creationTimeType",aw.medium,aw.dimensions,aw.status,aw.attribution_confidence AS "attributionConfidence",aw.copyright_status AS "copyrightStatus",cl.slug AS "creationLocationSlug",cur.slug AS "currentLocationSlug",COALESCE(t.title,f.title) title,COALESCE(t.summary,f.summary) summary,COALESCE(t.description,f.description,'') description,CASE WHEN t.title IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.title IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",COALESCE((SELECT json_agg(DISTINCT a.slug) FROM artist_artworks aa JOIN artists a ON a.id=aa.artist_id WHERE aa.artwork_id=aw.id),'[]'::json) AS "artistSlugs",COALESCE((SELECT json_agg(DISTINCT m.slug) FROM artwork_movements am JOIN movements m ON m.id=am.movement_id WHERE am.artwork_id=aw.id),'[]'::json) AS "movementSlugs",COALESCE((SELECT json_agg(e.slug ORDER BY e.sequence) FROM artwork_event_links ae JOIN events e ON e.id=ae.event_id WHERE ae.artwork_id=aw.id),'[]'::json) AS "eventSlugs",COALESCE((SELECT json_agg(${sourceTitle} ORDER BY ${sourceTitle}) FROM artwork_sources aws JOIN sources s ON s.id=aws.source_id ${sourceJoin("s")} WHERE aws.artwork_id=aw.id),'[]'::json) AS "sourceTitles" FROM artworks aw LEFT JOIN artists pa ON pa.id=aw.primary_artist_id LEFT JOIN locations cl ON cl.id=aw.creation_location_id LEFT JOIN locations cur ON cur.id=aw.current_location_id LEFT JOIN artwork_translations t ON t.artwork_id=aw.id AND t.locale=$2 AND t.status='published' LEFT JOIN artwork_translations f ON f.artwork_id=aw.id AND f.locale=$3 AND f.status='published' WHERE aw.work_id=$1 AND (t.title IS NOT NULL OR f.title IS NOT NULL) ORDER BY aw.sort_order`, args),
        db.query(`SELECT m.id,m.slug,m.chapter_id, (SELECT ch.slug FROM chapters ch WHERE ch.id=m.chapter_id) AS "chapterSlug",m.start_year AS "startYear",m.end_year AS "endYear",COALESCE(t.name,f.name) name,COALESCE(t.summary,f.summary) summary,CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",COALESCE((SELECT json_agg(DISTINCT a.slug) FROM artist_movements am JOIN artists a ON a.id=am.artist_id WHERE am.movement_id=m.id),'[]'::json) AS "artistSlugs",COALESCE((SELECT json_agg(DISTINCT aw.slug) FROM artwork_movements am JOIN artworks aw ON aw.id=am.artwork_id WHERE am.movement_id=m.id),'[]'::json) AS "artworkSlugs",COALESCE((SELECT json_agg(${sourceTitle} ORDER BY ${sourceTitle}) FROM movement_sources ms JOIN sources s ON s.id=ms.source_id ${sourceJoin("s")} WHERE ms.movement_id=m.id),'[]'::json) AS "sourceTitles" FROM movements m LEFT JOIN movement_translations t ON t.movement_id=m.id AND t.locale=$2 AND t.status='published' LEFT JOIN movement_translations f ON f.movement_id=m.id AND f.locale=$3 AND f.status='published' WHERE m.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) ORDER BY m.sort_order`, args),
        db.query(`SELECT i.id,i.slug,i.location_id AS "locationId",i.institution_type AS "institutionType",i.founded_year AS "foundedYear",i.closed_year AS "closedYear",l.slug AS "locationSlug",COALESCE(t.name,f.name) name,COALESCE(t.summary,f.summary) summary,CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",COALESCE((SELECT json_agg(DISTINCT a.slug) FROM artist_institutions ai JOIN artists a ON a.id=ai.artist_id WHERE ai.institution_id=i.id),'[]'::json) AS "artistSlugs",COALESCE((SELECT json_agg(${sourceTitle} ORDER BY ${sourceTitle}) FROM institution_sources isrc JOIN sources s ON s.id=isrc.source_id ${sourceJoin("s")} WHERE isrc.institution_id=i.id),'[]'::json) AS "sourceTitles" FROM art_institutions i JOIN locations l ON l.id=i.location_id LEFT JOIN art_institution_translations t ON t.institution_id=i.id AND t.locale=$2 AND t.status='published' LEFT JOIN art_institution_translations f ON f.institution_id=i.id AND f.locale=$3 AND f.status='published' WHERE i.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) ORDER BY i.slug`, args),
      ]);
      response.json({
        requestedLocale, detail, work,
        characters: characters.rows, locations: locations.rows, events: events.rows, routes: routes.rows,
        relations: relations.rows, sources: sources.rows, chronologies: chronologies.rows, media: media.rows,
        chapters: chapters.rows, groups: groups.rows, artists: artists.rows, artworks: artworks.rows, movements: movements.rows, institutions: institutions.rows,
      });
    } catch (error) { next(error); }
  });

  /** Full prose for a single entity, fetched only when a drawer opens. */
  app.get("/api/works/:slug/entities/:kind/:entitySlug", async (request, response, next) => {
    try {
      const slug = SlugSchema.parse(request.params.slug);
      const kind = EntityKindSchema.parse(request.params.kind);
      const { requestedLocale } = resolveLocale(request.query.locale);
      const work = await loadWork(slug, requestedLocale);
      if (!work) { response.status(404).json({ error: { code: "WORK_NOT_FOUND", message: `Unknown work: ${slug}` } }); return; }
      const workId = z.string().uuid().parse(work.id);
      const fallbackLocale = z.enum(supportedLocales).parse(work.default_locale);

      let row: Record<string, unknown> | undefined;
      if (kind === "relationship") {
        const id = z.string().uuid().safeParse(request.params.entitySlug);
        if (!id.success) { response.status(400).json({ error: { code: "INVALID_REQUEST", message: "Relationship detail requires a UUID" } }); return; }
        const result = await db.query(`SELECT COALESCE(t.summary,f.summary,'') AS summary FROM character_relations r
          LEFT JOIN relation_translations t ON t.relation_id=r.id AND t.locale=$2 AND t.status='published'
          LEFT JOIN relation_translations f ON f.relation_id=r.id AND f.locale=$3 AND f.status='published'
          WHERE r.id=$4 AND r.work_id=$1`, [workId, requestedLocale, fallbackLocale, id.data]);
        row = result.rows[0];
      } else {
        const entitySlug = SlugSchema.parse(request.params.entitySlug);
        const args = [workId, requestedLocale, fallbackLocale, entitySlug];
        const queries: Record<string, string> = {
          character: `SELECT COALESCE(t.detail,f.detail,'') detail,COALESCE(t.motivation,f.motivation,'') motivation FROM characters c
            LEFT JOIN character_translations t ON t.character_id=c.id AND t.locale=$2 AND t.status='published'
            LEFT JOIN character_translations f ON f.character_id=c.id AND f.locale=$3 AND f.status='published' WHERE c.work_id=$1 AND c.slug=$4`,
          event: `SELECT COALESCE(t.detail,f.detail,'') detail,COALESCE(t.significance,f.significance,'') significance FROM events e
            LEFT JOIN event_translations t ON t.event_id=e.id AND t.locale=$2 AND t.status='published'
            LEFT JOIN event_translations f ON f.event_id=e.id AND f.locale=$3 AND f.status='published' WHERE e.work_id=$1 AND e.slug=$4`,
          location: `SELECT COALESCE(t.detail,f.detail,'') detail,COALESCE(t.literary_significance,f.literary_significance,'') AS "literarySignificance",
            COALESCE(t.historical_background,f.historical_background,'') AS "historicalBackground",COALESCE(t.modern_status,f.modern_status,'') AS "modernStatus" FROM locations l
            LEFT JOIN location_translations t ON t.location_id=l.id AND t.locale=$2 AND t.status='published'
            LEFT JOIN location_translations f ON f.location_id=l.id AND f.locale=$3 AND f.status='published' WHERE l.work_id=$1 AND l.slug=$4`,
          route: `SELECT COALESCE(t.summary,f.summary,'') summary FROM routes r
            LEFT JOIN route_translations t ON t.route_id=r.id AND t.locale=$2 AND t.status='published'
            LEFT JOIN route_translations f ON f.route_id=r.id AND f.locale=$3 AND f.status='published' WHERE r.work_id=$1 AND r.slug=$4`,
          artist: `SELECT COALESCE(t.full_name,t.name,f.full_name,f.name,'') AS "fullName",COALESCE(array_to_string(t.aliases,' · '),array_to_string(f.aliases,' · '),'') AS aliases,COALESCE(array_to_string(t.formal_titles,' · '),array_to_string(f.formal_titles,' · '),'') AS "formalTitles",COALESCE(t.modern_status,f.modern_status,'') AS "modernStatus",COALESCE(array_to_string(t.period_titles,' · '),array_to_string(f.period_titles,' · '),'') AS "periodTitles" FROM artists a LEFT JOIN artist_translations t ON t.artist_id=a.id AND t.locale=$2 AND t.status='published' LEFT JOIN artist_translations f ON f.artist_id=a.id AND f.locale=$3 AND f.status='published' WHERE a.work_id=$1 AND a.slug=$4`,
          artwork: `SELECT aw.medium,aw.dimensions,aw.copyright_status AS "copyrightStatus" FROM artworks aw WHERE aw.work_id=$1 AND aw.slug=$4`,
          movement: `SELECT m.start_year::text AS "startYear",m.end_year::text AS "endYear" FROM movements m WHERE m.work_id=$1 AND m.slug=$4`,
          institution: `SELECT i.institution_type AS "institutionType",i.founded_year::text AS "foundedYear",i.closed_year::text AS "closedYear" FROM art_institutions i WHERE i.work_id=$1 AND i.slug=$4`,
        };
        const result = await db.query(queries[kind]!, args);
        row = result.rows[0];
      }
      if (!row) { response.status(404).json({ error: { code: "ENTITY_NOT_FOUND", message: `Unknown ${kind}: ${request.params.entitySlug}` } }); return; }
      response.json({ requestedLocale, kind, slug: request.params.entitySlug, fields: row });
    } catch (error) { next(error); }
  });

  app.get("/api/search", async (request, response, next) => {
    try {
      const parsed = SearchSchema.parse(request.query);
      const { requestedLocale } = resolveLocale(parsed.locale);
      const result = await db.query(`SELECT kind,slug,label,context,work_slug AS "workSlug",$1::locale_code AS "resolvedLocale",false AS "fallbackUsed",'published'::translation_status AS "translationStatus" FROM (
        SELECT 'work' kind,w.slug,wt.title label,w.author_name context,w.slug work_slug FROM work_translations wt JOIN works w ON w.id=wt.work_id WHERE wt.locale=$1 AND wt.status='published' AND (wt.title||' '||wt.summary||' '||w.author_name||' '||w.origin_region||' '||w.category::text) ILIKE '%'||$2||'%'
        UNION ALL SELECT 'character',c.slug,ct.name,ct.summary,w.slug FROM character_translations ct JOIN characters c ON c.id=ct.character_id JOIN works w ON w.id=c.work_id WHERE ct.locale=$1 AND ct.status='published' AND (ct.name||' '||ct.summary||' '||array_to_string(ct.aliases,' ')) ILIKE '%'||$2||'%'
        UNION ALL SELECT 'event',e.slug,et.title,et.summary,w.slug FROM event_translations et JOIN events e ON e.id=et.event_id JOIN works w ON w.id=e.work_id WHERE et.locale=$1 AND et.status='published' AND (et.title||' '||et.summary||' '||et.detail) ILIKE '%'||$2||'%'
        UNION ALL SELECT 'location',l.slug,lt.name,lt.summary,w.slug FROM location_translations lt JOIN locations l ON l.id=lt.location_id JOIN works w ON w.id=l.work_id WHERE lt.locale=$1 AND lt.status='published' AND (lt.name||' '||lt.summary||' '||array_to_string(lt.aliases,' ')) ILIKE '%'||$2||'%'
        UNION ALL SELECT 'artist',a.slug,COALESCE(at.full_name,at.name),at.summary,w.slug FROM artist_translations at JOIN artists a ON a.id=at.artist_id JOIN works w ON w.id=a.work_id WHERE w.category <> 'art_history' AND at.locale=$1 AND at.status='published' AND (COALESCE(at.full_name,at.name)||' '||at.name||' '||at.summary||' '||at.modern_status||' '||array_to_string(at.period_titles,' ')||' '||array_to_string(at.aliases,' ')) ILIKE '%'||$2||'%'
        UNION ALL SELECT 'artwork',aw.slug,wt.title,wt.summary,w.slug FROM artwork_translations wt JOIN artworks aw ON aw.id=wt.artwork_id JOIN works w ON w.id=aw.work_id WHERE wt.locale=$1 AND wt.status='published' AND (wt.title||' '||wt.summary||' '||wt.description||' '||aw.medium) ILIKE '%'||$2||'%'
        UNION ALL SELECT 'movement',m.slug,mt.name,mt.summary,w.slug FROM movement_translations mt JOIN movements m ON m.id=mt.movement_id JOIN works w ON w.id=m.work_id WHERE mt.locale=$1 AND mt.status='published' AND (mt.name||' '||mt.summary) ILIKE '%'||$2||'%'
        UNION ALL SELECT 'institution',i.slug,it.name,it.summary,w.slug FROM art_institution_translations it JOIN art_institutions i ON i.id=it.institution_id JOIN works w ON w.id=i.work_id WHERE it.locale=$1 AND it.status='published' AND (it.name||' '||it.summary) ILIKE '%'||$2||'%') s LIMIT 200`, [requestedLocale, parsed.q]);
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
