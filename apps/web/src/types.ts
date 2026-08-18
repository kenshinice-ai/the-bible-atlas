import { z } from "zod";

export const LocaleSchema = z.enum(["zh-CN", "en"]);
export type Locale = z.infer<typeof LocaleSchema>;
export const MapLayerSchema = z.enum(["real", "fictional"]);
export const WorkCategorySchema = z.enum(["historical_document", "historical_fiction", "realist_fiction", "fantasy", "mythic_epic", "art_history", "music_history", "mythography"]);
export const TimeTypeSchema = z.enum(["exact", "approximate", "range", "relative", "fictional_calendar", "unknown"]);
export const LocationTypeSchema = z.enum(["country", "region", "city", "district", "street", "building", "landmark", "prison", "station", "port", "battlefield", "residence", "school", "religious_site", "fictional_place", "route_node", "planet", "moon", "space_station"]);
export const EntityTypeSchema = z.enum(["work", "character", "event", "location", "route", "relationship", "artist", "artwork", "movement", "institution", "composition", "music_style", "instrument", "music_institution", "score_fragment", "creature", "passage", "textual_place"]);

const TranslationMetaSchema = z.object({ resolvedLocale: LocaleSchema, fallbackUsed: z.boolean(), translationStatus: z.enum(["draft", "reviewed", "published"]) });
const WorkCoreSchema = z.object({
  slug: z.string(), authorName: z.string(), publicationYear: z.number().nullable().optional(), contentMode: z.enum(["documented_record", "literary_narrative"]), mapLayer: MapLayerSchema,
  category: WorkCategorySchema, originRegion: z.string(), chronologyStartYear: z.number().nullable(), chronologyEndYear: z.number().nullable(),
  themeColor: z.string(), themeColorDark: z.string(), themeColorLight: z.string(), title: z.string(), summary: z.string(),
}).and(TranslationMetaSchema);

export const WorksResponseSchema = z.object({
  locale: LocaleSchema,
  items: z.array(WorkCoreSchema.and(z.object({
    alternateTitle: z.string().nullable(), characterCount: z.number(), eventCount: z.number(), locationCount: z.number(),
    artistCount: z.number().optional(), artworkCount: z.number().optional(), movementCount: z.number().optional(),
    compositionCount: z.number().optional(), musicStyleCount: z.number().optional(), instrumentCount: z.number().optional(),
    musicInstitutionCount: z.number().optional(), scoreFragmentCount: z.number().optional(),
    uniqueCreatureConceptCount: z.number().optional(), textualOccurrenceCount: z.number().optional(),
    corpusCoverage: z.object({ reviewed: z.number(), total: z.number() }).optional(),
    textualPlaceCount: z.number().optional(),
  }))),
});

const CharacterSchema = z.object({
  id: z.string().uuid(), slug: z.string(), gender: z.enum(["male", "female", "unknown", "na"]), ageStage: z.enum(["child", "youth", "adult", "elder", "unknown"]),
  roleType: z.enum(["protagonist", "antagonist", "supporting", "narrator", "historical", "collective", "supernatural"]),
  realityType: z.enum(["historical", "fictional", "fictionalised_historical", "unknown"]),
  birthYear: z.number().nullable(), deathYear: z.number().nullable(), birthPlaceSlug: z.string().nullable(), deathPlaceSlug: z.string().nullable(),
  iconVariant: z.string(), importance: z.number(), artistSlug: z.string().nullable(), name: z.string(), summary: z.string(), aliases: z.array(z.string()), detail: z.string(), motivation: z.string(),
  eventSlugs: z.array(z.string()), locationSlugs: z.array(z.string()), sourceTitles: z.array(z.string()), groupSlugs: z.array(z.string()), chapterSlug: z.string().nullable(),
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
  name: z.string(), summary: z.string(), waypoints: z.array(z.object({ position: z.number(), locationSlug: z.string(), eventSlug: z.string().nullable() })),
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
  creationLocationSlug: z.string().nullable(), currentLocationSlug: z.string().nullable(), title: z.string(), summary: z.string(), description: z.string().default(""),
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

const MusicPersonSchema = z.object({
  characterSlug: z.string(), primaryRole: z.string(), roleCodes: z.array(z.string()), chapterSlug: z.string().nullable(),
  compositionSlugs: z.array(z.string()), styleSlugs: z.array(z.string()), instrumentSlugs: z.array(z.string()),
  institutionSlugs: z.array(z.string()), eventSlugs: z.array(z.string()), sourceTitles: z.array(z.string()),
});

const CompositionSchema = z.object({
  id: z.string().uuid(), slug: z.string(), primaryComposerSlug: z.string().nullable(), chapterSlug: z.string().nullable(),
  compositionStartYear: z.number().nullable(), compositionEndYear: z.number().nullable(), compositionTimeType: TimeTypeSchema,
  confidence: z.enum(["high", "medium", "low"]), catalogueNumber: z.string(), genre: z.string(), form: z.string(),
  keySignature: z.string(), approxDurationSeconds: z.number().nullable(), textLanguage: z.string(), workStatus: z.enum(["confirmed", "sketch", "fragment", "lost", "arrangement", "contested", "unknown"]),
  title: z.string(), alternateTitles: z.array(z.string()), summary: z.string(), description: z.string(),
  contributorSlugs: z.array(z.string()), contributors: z.array(z.object({ slug: z.string(), role: z.string() })), styleSlugs: z.array(z.string()), instrumentSlugs: z.array(z.string()),
  institutionSlugs: z.array(z.string()), eventSlugs: z.array(z.string()), scoreFragmentSlugs: z.array(z.string()), sourceTitles: z.array(z.string()),
}).and(TranslationMetaSchema);

const MusicStyleSchema = z.object({
  id: z.string().uuid(), slug: z.string(), styleKind: z.string(), chapterSlug: z.string().nullable(),
  startYear: z.number().nullable(), endYear: z.number().nullable(), name: z.string(), summary: z.string(),
  characterSlugs: z.array(z.string()), compositionSlugs: z.array(z.string()), sourceTitles: z.array(z.string()),
}).and(TranslationMetaSchema);

const InstrumentSchema = z.object({
  id: z.string().uuid(), slug: z.string(), family: z.string(), hornbostelSachsCode: z.string(), mimoTerm: z.string(),
  startYear: z.number().nullable(), endYear: z.number().nullable(), transposition: z.string(), rangeLow: z.string(), rangeHigh: z.string(),
  name: z.string(), aliases: z.array(z.string()), summary: z.string(), characterSlugs: z.array(z.string()),
  compositionSlugs: z.array(z.string()), sourceTitles: z.array(z.string()),
}).and(TranslationMetaSchema);

const MusicInstitutionSchema = z.object({
  id: z.string().uuid(), slug: z.string(), locationSlug: z.string(), institutionType: z.string(),
  foundedYear: z.number().nullable(), closedYear: z.number().nullable(), name: z.string(), summary: z.string(),
  characterSlugs: z.array(z.string()), compositionSlugs: z.array(z.string()), sourceTitles: z.array(z.string()),
}).and(TranslationMetaSchema);

const ScoreAnnotationSchema = z.object({
  id: z.string().uuid(), targetXmlId: z.string().nullable(), startBeat: z.coerce.number().nullable(), endBeat: z.coerce.number().nullable(),
  annotationType: z.string(), label: z.string(), explanation: z.string(),
});

const ScoreFragmentSchema = z.object({
  id: z.string().uuid(), slug: z.string(), compositionSlug: z.string(), startMeasure: z.number(), endMeasure: z.number(),
  notationKind: z.enum(["common", "mensural", "neume", "mixed"]), meiAssetPath: z.string(), svgAssetPath: z.string(), timingAssetPath: z.string(),
  audioAssetPath: z.string().nullable(), durationSeconds: z.coerce.number(), tempoBpm: z.coerce.number().nullable(),
  tempoBasis: z.enum(["source_marking", "editorial_learning", "unknown"]), rightsStatus: z.enum(["verified", "pending", "rejected", "unknown"]),
  title: z.string(), summary: z.string(), analysisNote: z.string(), playbackDisclaimer: z.string(),
  annotations: z.array(ScoreAnnotationSchema), sourceTitles: z.array(z.string()),
}).and(TranslationMetaSchema);

const MusicLearningUnitSchema = z.object({
  id: z.string().uuid(), slug: z.string(), unitKind: z.enum(["listening", "score_reading", "comparison", "route"]),
  difficulty: z.enum(["introductory", "intermediate", "advanced"]), targetMinutes: z.number(), title: z.string(), summary: z.string(), objective: z.string(),
  compositionSlugs: z.array(z.string()), scoreFragmentSlugs: z.array(z.string()),
}).and(TranslationMetaSchema);

const SourceSchema = z.object({ id: z.string().uuid(), title: z.string(), url: z.string().nullable(), citation: z.string(), evidenceGrade: z.string(), sourceType: z.enum(["primary_text", "scholarly", "historical", "reference", "map", "image", "score", "instrument_catalog"]) });
const ChronologySchema = z.object({ id: z.string().uuid(), kind: z.enum(["historical", "narrative", "fictional"]), label: z.string(), startYear: z.number().nullable(), endYear: z.number().nullable(), calendarSystem: z.enum(["gregorian", "julian", "fictional", "unknown"]), isDefault: z.boolean() });
const MediaRoleSchema = z.enum(["character_depiction", "place_view", "event_scene", "artwork", "map", "other"]);
const MediaDepictionStatusSchema = z.enum(["illustrative", "documentary", "cartographic", "unknown"]);
export type MediaRole = z.infer<typeof MediaRoleSchema>;
export type DepictionStatus = z.infer<typeof MediaDepictionStatusSchema>;
const MediaSchema = z.object({
  id: z.string().uuid(), entityKind: EntityTypeSchema, entityId: z.string().uuid(),
  mediaKind: z.enum(["image", "external_link"]), usageMode: z.enum(["bundled", "remote", "external_link"]),
  licenseStatus: z.enum(["verified", "pending", "rejected", "unknown"]), licenseUrl: z.string().url().nullable(),
  sourcePageUrl: z.string().url().nullable(), originalUrl: z.string().url().nullable(),
  assetSource: z.string(), assetLicence: z.string(), assetAuthor: z.string(), assetUrl: z.string(), attributionText: z.string(), altText: z.string(),
  mediaRole: MediaRoleSchema, depictionStatus: MediaDepictionStatusSchema,
});

const ChapterSchema = z.object({
  id: z.string().uuid(), slug: z.string(), sequence: z.number(), referenceLabel: z.string(),
  eraStartYear: z.number().nullable(), eraEndYear: z.number().nullable(), accentColor: z.string(),
  title: z.string(), summary: z.string(), eventCount: z.number(), firstSequence: z.number().nullable(), lastSequence: z.number().nullable(),
});

const GroupSchema = z.object({
  id: z.string().uuid(), slug: z.string(), groupType: z.enum(["family", "dynasty", "circle", "tribe", "institution", "other", "school", "court", "conservatory", "ensemble", "national_tradition", "city_network"]),
  sortOrder: z.number(), accentColor: z.string(), anchorCharacterSlug: z.string().nullable(),
  name: z.string(), summary: z.string(), characterSlugs: z.array(z.string()),
});

/**
 * Bible art/music layer. An emblem is a symbolic identity — a claim about which
 * sign tradition attaches to a person — and never a likeness; `attestation`
 * says whether the sign comes from the text, the liturgy, or later art.
 */
export const EmblemSymbolSchema = z.string().regex(/^[a-z0-9-]+$/u);
const CharacterEmblemSchema = z.object({
  characterSlug: z.string(), symbolKey: EmblemSymbolSchema,
  ringKey: z.enum(["plain", "braided", "rayed", "thorned", "waved", "chained"]),
  groundKey: z.enum(["era", "gold", "ink", "vellum", "sky"]),
  attestation: z.enum(["scriptural", "liturgical", "iconographic"]),
  symbolName: z.string(), symbolMeaning: z.string(), attributionNote: z.string(),
});

const ChapterEmblemSchema = z.object({
  chapterSlug: z.string(), symbolKey: EmblemSymbolSchema, symbolName: z.string(), symbolMeaning: z.string(),
});

const ScriptureRefSchema = z.object({
  id: z.string().uuid(), eventSlug: z.string(), osisRef: z.string(), bookOsis: z.string(),
  chapterNumber: z.number(), verseStart: z.number().nullable(), verseEnd: z.number().nullable(),
  refRole: z.enum(["primary", "parallel", "background"]),
});

const CharacterQuoteSchema = z.object({
  id: z.string().uuid(), characterSlug: z.string(), eventSlug: z.string().nullable(), osisRef: z.string(),
  speechKind: z.enum(["declaration", "prayer", "praise", "blessing", "lament", "command", "confession", "admission", "objection", "prophecy", "question"]),
  importance: z.number(), quoteText: z.string(), referenceLabel: z.string(), contextNote: z.string(),
  translationEdition: z.enum(["CUV-1919", "WEB"]), scriptVariant: z.enum(["na", "han-traditional"]),
  verifiedSourceUrl: z.string().url().nullable(), isExcerpt: z.boolean(),
}).and(TranslationMetaSchema);

const CrossWorkMusicSchema = z.object({
  id: z.string().uuid(), fromEntityKind: z.enum(["character", "event", "location"]), fromSlug: z.string(),
  linkType: z.enum(["musical_setting", "musical_reception"]), confidence: z.enum(["high", "medium", "low"]),
  label: z.string(), basisNote: z.string(), targetWorkSlug: z.string(),
  compositionSlug: z.string(), compositionTitle: z.string(), compositionYear: z.number().nullable(), composerName: z.string(),
  fragmentSlug: z.string().nullable(), audioAssetPath: z.string().nullable(), svgAssetPath: z.string().nullable(),
  durationSeconds: z.coerce.number().nullable(), playbackDisclaimer: z.string(),
});

const ShanhaijingSectionSchema = z.object({
  id: z.string().uuid(), slug: z.string(), sequence: z.number(), referenceLabel: z.string(),
  title: z.string(), summary: z.string(), reviewStatus: z.enum(["draft", "reviewed", "published"]),
});

const ShanhaijingPassageSchema = z.object({
  id: z.string().uuid(), slug: z.string(), referenceKey: z.string(), sequence: z.number(), sectionSlug: z.string(),
  textZh: z.string(), sourceUrl: z.string().url(), checksumSha256: z.string().regex(/^[0-9a-f]{64}$/u),
  reviewStatus: z.enum(["draft", "reviewed", "published"]), title: z.string(), summary: z.string(), editorialNote: z.string(),
  creatureSlugs: z.array(z.string()), placeSlugs: z.array(z.string()),
}).and(TranslationMetaSchema);

const ShanhaijingTaxonomySchema = z.object({
  axis: z.string(), term: z.string(), confidence: z.enum(["high", "medium", "low", "unknown"]), evidenceNote: z.string(),
});

const ShanhaijingCreatureSchema = z.object({
  id: z.string().uuid(), slug: z.string(), conceptStatus: z.enum(["resolved", "provisional", "disputed", "superseded"]),
  importance: z.number(), iconKey: z.string(), name: z.string(), aliases: z.array(z.string()), summary: z.string(), detail: z.string(),
  passageSlugs: z.array(z.string()), placeSlugs: z.array(z.string()), taxonomy: z.array(ShanhaijingTaxonomySchema),
}).and(TranslationMetaSchema);

const ShanhaijingOccurrenceSchema = z.object({
  id: z.string().uuid(), creatureSlug: z.string(), passageSlug: z.string(), placeSlug: z.string().nullable(),
  surfaceForm: z.string(), quoteZh: z.string(), occurrenceOrder: z.number(),
  sourceAttestation: z.enum(["text_direct", "commentary", "research", "none"]),
  interpretationClass: z.enum(["transcription", "editorial_summary", "scholarly_hypothesis", "artistic_interpretation"]),
  confidence: z.enum(["high", "medium", "low", "unknown"]), evidenceNote: z.string(),
  reviewStatus: z.enum(["draft", "reviewed", "published"]),
});

const ShanhaijingPlaceSchema = z.object({
  id: z.string().uuid(), slug: z.string(),
  placeKind: z.enum(["mountain", "mountain_range", "river", "water_source", "marsh", "sea", "region", "route_node", "unknown"]),
  layoutX: z.coerce.number(), layoutY: z.coerce.number(), layoutSpace: z.string(),
  reviewStatus: z.enum(["draft", "reviewed", "published"]), name: z.string(), aliases: z.array(z.string()), summary: z.string(),
  passageSlugs: z.array(z.string()), creatureSlugs: z.array(z.string()),
}).and(TranslationMetaSchema);

const ShanhaijingTopologyEdgeSchema = z.object({
  id: z.string().uuid(), fromSlug: z.string(), toSlug: z.string(), passageSlug: z.string(),
  relationKind: z.enum(["next_in_route", "distance_direction", "source_of", "flows_into", "surrounds", "passes_through", "adjacent_to", "unresolved_relation"]),
  directionText: z.string(), distanceValue: z.coerce.number().nullable(), distanceUnit: z.string(), sequence: z.number(),
  interpretationClass: z.enum(["transcription", "editorial_summary", "scholarly_hypothesis", "artistic_interpretation"]),
  conflictStatus: z.enum(["none", "disputed", "unresolved"]), reviewStatus: z.enum(["draft", "reviewed", "published"]),
});

const ShanhaijingOverviewSchema = z.object({
  id: z.string().uuid(), slug: z.string(),
  status: z.enum(["planned", "blocked_missing_api_key", "generated", "reviewed", "published", "withdrawn"]),
  interpretationClass: z.literal("artistic_interpretation"), coordinateSpace: z.string(), assetUrl: z.string().nullable(),
  promptPath: z.string(), promptSha256: z.string().regex(/^[0-9a-f]{64}$/u),
  title: z.string(), description: z.string(), disclosure: z.string(),
});

const ShanhaijingDomainSchema = z.object({
  sections: z.array(ShanhaijingSectionSchema),
  passages: z.array(ShanhaijingPassageSchema),
  creatures: z.array(ShanhaijingCreatureSchema),
  occurrences: z.array(ShanhaijingOccurrenceSchema),
  places: z.array(ShanhaijingPlaceSchema),
  topologyEdges: z.array(ShanhaijingTopologyEdgeSchema),
  artisticOverview: ShanhaijingOverviewSchema.nullable(),
  coverage: z.object({
    passagesTotal: z.number(), passagesReviewed: z.number(),
    passagesWithRequestedLocale: z.number(), passagesWithFallbackLocale: z.number(),
    creatureConcepts: z.number(), textualOccurrences: z.number(),
  }),
});

export const AtlasResponseSchema = z.object({
  requestedLocale: LocaleSchema, detail: z.enum(["lite", "full"]),
  work: WorkCoreSchema.and(z.object({ id: z.string().uuid(), default_locale: LocaleSchema })),
  characters: z.array(CharacterSchema), locations: z.array(LocationSchema), events: z.array(EventSchema), routes: z.array(RouteSchema),
  relations: z.array(RelationSchema), sources: z.array(SourceSchema), chronologies: z.array(ChronologySchema), media: z.array(MediaSchema),
  chapters: z.array(ChapterSchema), groups: z.array(GroupSchema),
  artists: z.array(ArtistSchema).default([]), artworks: z.array(ArtworkSchema).default([]), movements: z.array(MovementSchema).default([]), institutions: z.array(InstitutionSchema).default([]),
  musicPeople: z.array(MusicPersonSchema).default([]), compositions: z.array(CompositionSchema).default([]),
  musicStyles: z.array(MusicStyleSchema).default([]), instruments: z.array(InstrumentSchema).default([]),
  musicInstitutions: z.array(MusicInstitutionSchema).default([]), scoreFragments: z.array(ScoreFragmentSchema).default([]), musicLearningUnits: z.array(MusicLearningUnitSchema).default([]),
  characterEmblems: z.array(CharacterEmblemSchema).default([]), chapterEmblems: z.array(ChapterEmblemSchema).default([]),
  scriptureRefs: z.array(ScriptureRefSchema).default([]), quotes: z.array(CharacterQuoteSchema).default([]),
  crossWorkMusic: z.array(CrossWorkMusicSchema).default([]),
  shanhaijing: ShanhaijingDomainSchema.nullable().default(null),
});

export const EntityDetailSchema = z.object({ requestedLocale: LocaleSchema, kind: z.string(), slug: z.string(), fields: z.record(z.string(), z.string()) });
export const SearchResponseSchema = z.object({
  locale: LocaleSchema, query: z.string(),
  items: z.array(z.object({ kind: z.enum(["work", "character", "event", "location", "artist", "artwork", "movement", "institution", "composition", "music_style", "instrument", "music_institution", "score_fragment", "creature", "passage", "textual_place"]), slug: z.string(), label: z.string(), context: z.string().nullable(), workSlug: z.string() })),
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
export type AtlasMedia = Atlas["media"][number];
export type AtlasArtist = Atlas["artists"][number];
export type AtlasArtwork = Atlas["artworks"][number];
export type AtlasMovement = Atlas["movements"][number];
export type AtlasInstitution = Atlas["institutions"][number];
export type AtlasMusicPerson = Atlas["musicPeople"][number];
export type AtlasComposition = Atlas["compositions"][number];
export type AtlasMusicStyle = Atlas["musicStyles"][number];
export type AtlasInstrument = Atlas["instruments"][number];
export type AtlasMusicInstitution = Atlas["musicInstitutions"][number];
export type AtlasScoreFragment = Atlas["scoreFragments"][number];
export type AtlasMusicLearningUnit = Atlas["musicLearningUnits"][number];
export type AtlasCharacterEmblem = Atlas["characterEmblems"][number];
export type AtlasChapterEmblem = Atlas["chapterEmblems"][number];
export type AtlasScriptureRef = Atlas["scriptureRefs"][number];
export type AtlasQuote = Atlas["quotes"][number];
export type AtlasCrossWorkMusic = Atlas["crossWorkMusic"][number];
export type ShanhaijingDomain = NonNullable<Atlas["shanhaijing"]>;
export type ShanhaijingCreature = ShanhaijingDomain["creatures"][number];
export type ShanhaijingPassage = ShanhaijingDomain["passages"][number];
export type ShanhaijingPlace = ShanhaijingDomain["places"][number];
export type ShanhaijingOccurrence = ShanhaijingDomain["occurrences"][number];
export type ShanhaijingTopologyEdge = ShanhaijingDomain["topologyEdges"][number];
export type EntityDetail = z.infer<typeof EntityDetailSchema>;
export type SearchResponse = z.infer<typeof SearchResponseSchema>;
export type EntityType = z.infer<typeof EntityTypeSchema>;
