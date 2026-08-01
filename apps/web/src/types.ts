import { z } from "zod";

export const LocaleSchema = z.enum(["zh-CN", "en"]);
export type Locale = z.infer<typeof LocaleSchema>;
export const MapLayerSchema = z.enum(["real", "fictional"]);
export const WorkCategorySchema = z.enum(["historical_document", "historical_fiction", "realist_fiction", "fantasy", "mythic_epic", "art_history"]);
export const TimeTypeSchema = z.enum(["exact", "approximate", "range", "relative", "fictional_calendar", "unknown"]);
// Mirrors the location_type enum in the database. It is strict on purpose — an
// unknown value fails the whole atlas parse rather than rendering a raw string
// — so widening it in db/migrations means widening it here in the same change.
export const LocationTypeSchema = z.enum(["country", "region", "city", "district", "street", "building", "landmark", "prison", "station", "port", "battlefield", "residence", "school", "religious_site", "fictional_place", "route_node", "planet", "moon", "space_station"]);
export const EntityTypeSchema = z.enum(["work", "character", "event", "location", "route", "relationship", "artist", "artwork", "movement", "institution"]);

const TranslationMetaSchema = z.object({ resolvedLocale: LocaleSchema, fallbackUsed: z.boolean(), translationStatus: z.enum(["draft", "reviewed", "published"]) });
const WorkCoreSchema = z.object({
  slug: z.string(), authorName: z.string(), publicationYear: z.number().nullable().optional(), contentMode: z.enum(["documented_record", "literary_narrative"]), mapLayer: MapLayerSchema,
  category: WorkCategorySchema, originRegion: z.string(), chronologyStartYear: z.number().nullable(), chronologyEndYear: z.number().nullable(),
  themeColor: z.string(), themeColorDark: z.string(), themeColorLight: z.string(), title: z.string(), summary: z.string(),
}).and(TranslationMetaSchema);

export const WorksResponseSchema = z.object({
  locale: LocaleSchema,
  items: z.array(WorkCoreSchema.and(z.object({ alternateTitle: z.string().nullable(), characterCount: z.number(), eventCount: z.number(), locationCount: z.number(), artistCount: z.number().optional(), artworkCount: z.number().optional(), movementCount: z.number().optional() }))),
});

const CharacterSchema = z.object({
  id: z.string().uuid(), slug: z.string(), gender: z.enum(["male", "female", "unknown", "na"]), ageStage: z.enum(["child", "youth", "adult", "elder", "unknown"]),
  roleType: z.enum(["protagonist", "antagonist", "supporting", "narrator", "historical", "collective", "supernatural"]),
  realityType: z.enum(["historical", "fictional", "fictionalised_historical", "unknown"]),
  birthYear: z.number().nullable(), deathYear: z.number().nullable(), birthPlaceSlug: z.string().nullable(), deathPlaceSlug: z.string().nullable(),
  iconVariant: z.string(), importance: z.number(), artistSlug: z.string().nullable(), name: z.string(), summary: z.string(), aliases: z.array(z.string()), detail: z.string(), motivation: z.string(),
  eventSlugs: z.array(z.string()), locationSlugs: z.array(z.string()), sourceTitles: z.array(z.string()),
  // v4 hierarchy: which era a person first appears in, and which groups collapse them.
  groupSlugs: z.array(z.string()), chapterSlug: z.string().nullable(),
  firstSequence: z.number().nullable(), lastSequence: z.number().nullable(),
}).and(TranslationMetaSchema);

const LocationSchema = z.object({
  id: z.string().uuid(), slug: z.string(), layer: MapLayerSchema, locationType: LocationTypeSchema,
  coordinateAccuracy: z.enum(["exact", "approximate", "city_centroid", "inferred", "fictional"]),
  preferredZoom: z.number(), modernCountryCode: z.string().nullable(), isInferred: z.boolean(), stillExists: z.boolean().nullable(),
  lng: z.coerce.number().nullable(), lat: z.coerce.number().nullable(), canvasX: z.coerce.number().nullable(), canvasY: z.coerce.number().nullable(),
  name: z.string(), summary: z.string(), aliases: z.array(z.string()), detail: z.string(), literarySignificance: z.string(),
  historicalBackground: z.string(), modernStatus: z.string(), historicalRegionName: z.string(),
  characterSlugs: z.array(z.string()), eventSlugs: z.array(z.string()), routeSlugs: z.array(z.string()),
  firstSequence: z.number().nullable(), lastSequence: z.number().nullable(), firstYear: z.number().nullable(), lastYear: z.number().nullable(),
}).and(TranslationMetaSchema);

const EventSchema = z.object({
  id: z.string().uuid(), slug: z.string(), startDate: z.string().nullable(), endDate: z.string().nullable(), sequence: z.number(),
  reality: z.enum(["verified_historical", "reported_historical", "fictional_narrative", "fictional_with_historical_context", "legendary_or_mythic", "symbolic_or_dream", "contested"]),
  eventType: z.string(), timeType: TimeTypeSchema, calendarSystem: z.enum(["gregorian", "julian", "fictional", "unknown"]),
  historicalStartYear: z.number().nullable(), historicalEndYear: z.number().nullable(), startMonth: z.number().nullable(), startDay: z.number().nullable(),
  confidence: z.enum(["high", "medium", "low"]), parentEventSlug: z.string().nullable(), chapterSlug: z.string().nullable(),
  title: z.string(), summary: z.string(), detail: z.string(), significance: z.string(), timeLabel: z.string(),
  locationSlugs: z.array(z.string()), characterSlugs: z.array(z.string()), sourceTitles: z.array(z.string()), routeSlugs: z.array(z.string()),
}).and(TranslationMetaSchema);

const RouteSchema = z.object({
  id: z.string().uuid(), slug: z.string(), layer: MapLayerSchema, certainty: z.enum(["documented", "text_explicit", "inferred"]),
  name: z.string(), summary: z.string(),
  waypoints: z.array(z.object({ position: z.number(), locationSlug: z.string(), eventSlug: z.string().nullable() })),
}).and(TranslationMetaSchema);

const RelationSchema = z.object({
  id: z.string().uuid(), fromSlug: z.string(), toSlug: z.string(), relationType: z.string(),
  direction: z.enum(["bidirectional", "source_to_target", "target_to_source"]), sentiment: z.enum(["positive", "negative", "mixed", "neutral"]),
  strength: z.number(), status: z.enum(["active", "ended", "changed", "unknown"]),
  startEventSlug: z.string().nullable(), endEventSlug: z.string().nullable(), label: z.string(), summary: z.string(), sourceTitles: z.array(z.string()),
}).and(TranslationMetaSchema);

const ArtistSchema = z.object({
  id: z.string().uuid(), slug: z.string(), characterSlug: z.string().nullable(), artistKind: z.enum(["person", "workshop", "collective", "anonymous_master", "school"]),
  birthYear: z.number().nullable(), deathYear: z.number().nullable(), birthPlaceSlug: z.string().nullable(), deathPlaceSlug: z.string().nullable(),
  importance: z.number(), name: z.string(), fullName: z.string(), aliases: z.array(z.string()), formalTitles: z.array(z.string()), summary: z.string(), modernStatus: z.string(), periodTitles: z.array(z.string()),
  chapterSlug: z.string().nullable(), artworkSlugs: z.array(z.string()), movementSlugs: z.array(z.string()), eventSlugs: z.array(z.string()), locationSlugs: z.array(z.string()), sourceTitles: z.array(z.string()),
}).and(TranslationMetaSchema);

const ArtworkSchema = z.object({
  id: z.string().uuid(), slug: z.string(), primaryArtistSlug: z.string().nullable(), chapterSlug: z.string().nullable(),
  creationStartYear: z.number().nullable(), creationEndYear: z.number().nullable(), creationTimeType: TimeTypeSchema, medium: z.string(), dimensions: z.string(),
  status: z.enum(["confirmed", "attributed", "workshop", "lost", "destroyed", "unknown"]), attributionConfidence: z.enum(["high", "medium", "low", "unknown"]), copyrightStatus: z.string(),
  creationLocationSlug: z.string().nullable(), currentLocationSlug: z.string().nullable(), title: z.string(), summary: z.string(),
  artistSlugs: z.array(z.string()), movementSlugs: z.array(z.string()), eventSlugs: z.array(z.string()), sourceTitles: z.array(z.string()),
}).and(TranslationMetaSchema);

const MovementSchema = z.object({
  id: z.string().uuid(), slug: z.string(), chapterSlug: z.string().nullable(), startYear: z.number().nullable(), endYear: z.number().nullable(),
  name: z.string(), summary: z.string(), artistSlugs: z.array(z.string()), artworkSlugs: z.array(z.string()), sourceTitles: z.array(z.string()),
}).and(TranslationMetaSchema);

const InstitutionSchema = z.object({
  id: z.string().uuid(), slug: z.string(), locationSlug: z.string(), institutionType: z.string(), foundedYear: z.number().nullable(), closedYear: z.number().nullable(),
  name: z.string(), summary: z.string(), artistSlugs: z.array(z.string()), sourceTitles: z.array(z.string()),
}).and(TranslationMetaSchema);

const SourceSchema = z.object({ id: z.string().uuid(), title: z.string(), url: z.string().nullable(), citation: z.string(), evidenceGrade: z.string(), sourceType: z.enum(["primary_text", "scholarly", "historical", "reference", "map", "image"]) });
const ChronologySchema = z.object({ id: z.string().uuid(), kind: z.enum(["historical", "narrative", "fictional"]), label: z.string(), startYear: z.number().nullable(), endYear: z.number().nullable(), calendarSystem: z.enum(["gregorian", "julian", "fictional", "unknown"]), isDefault: z.boolean() });
const MediaSchema = z.object({ id: z.string().uuid(), entityKind: EntityTypeSchema, entityId: z.string().uuid(), assetSource: z.string(), assetLicence: z.string(), assetAuthor: z.string(), assetUrl: z.string().url(), attributionText: z.string(), altText: z.string() });

/** Era tier of the zoom hierarchy. */
const ChapterSchema = z.object({
  id: z.string().uuid(), slug: z.string(), sequence: z.number(), referenceLabel: z.string(),
  eraStartYear: z.number().nullable(), eraEndYear: z.number().nullable(), accentColor: z.string(),
  title: z.string(), summary: z.string(), eventCount: z.number(), firstSequence: z.number().nullable(), lastSequence: z.number().nullable(),
});

/** Group tier of the zoom hierarchy. */
const GroupSchema = z.object({
  id: z.string().uuid(), slug: z.string(), groupType: z.enum(["family", "dynasty", "circle", "tribe", "institution", "other"]),
  sortOrder: z.number(), accentColor: z.string(), anchorCharacterSlug: z.string().nullable(),
  name: z.string(), summary: z.string(), characterSlugs: z.array(z.string()),
});

export const AtlasResponseSchema = z.object({
  requestedLocale: LocaleSchema, detail: z.enum(["lite", "full"]),
  work: WorkCoreSchema.and(z.object({ id: z.string().uuid(), default_locale: LocaleSchema })),
  characters: z.array(CharacterSchema), locations: z.array(LocationSchema), events: z.array(EventSchema), routes: z.array(RouteSchema),
  relations: z.array(RelationSchema), sources: z.array(SourceSchema), chronologies: z.array(ChronologySchema), media: z.array(MediaSchema),
  chapters: z.array(ChapterSchema), groups: z.array(GroupSchema),
  artists: z.array(ArtistSchema).default([]), artworks: z.array(ArtworkSchema).default([]), movements: z.array(MovementSchema).default([]), institutions: z.array(InstitutionSchema).default([]),
});

export const EntityDetailSchema = z.object({
  requestedLocale: LocaleSchema, kind: z.string(), slug: z.string(),
  fields: z.record(z.string(), z.string()),
});

export const SearchResponseSchema = z.object({
  locale: LocaleSchema, query: z.string(),
  items: z.array(z.object({ kind: z.enum(["work", "character", "event", "location", "artist", "artwork", "movement", "institution"]), slug: z.string(), label: z.string(), context: z.string().nullable(), workSlug: z.string() })),
});

export type WorksResponse = z.infer<typeof WorksResponseSchema>;
export type WorkSummary = WorksResponse["items"][number];
export type Atlas = z.infer<typeof AtlasResponseSchema>;
export type AtlasCharacter = Atlas["characters"][number];
export type AtlasEvent = Atlas["events"][number];
export type AtlasLocation = Atlas["locations"][number];
export type AtlasRoute = Atlas["routes"][number];
export type AtlasRelation = Atlas["relations"][number];
export type AtlasChapter = Atlas["chapters"][number];
export type AtlasGroup = Atlas["groups"][number];
export type AtlasArtist = Atlas["artists"][number];
export type AtlasArtwork = Atlas["artworks"][number];
export type AtlasMovement = Atlas["movements"][number];
export type AtlasInstitution = Atlas["institutions"][number];
export type EntityDetail = z.infer<typeof EntityDetailSchema>;
export type SearchResponse = z.infer<typeof SearchResponseSchema>;
export type EntityType = z.infer<typeof EntityTypeSchema>;
