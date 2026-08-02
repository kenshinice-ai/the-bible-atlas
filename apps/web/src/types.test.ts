import { describe, expect, it } from "vitest";
import { AtlasResponseSchema } from "./types";

const meta = { resolvedLocale: "zh-CN", fallbackUsed: false, translationStatus: "published" } as const;
const work = { id: "10000000-0000-4000-8000-000000000005", slug: "the-bible", authorName: "Various authors and traditions", publicationYear: null, contentMode: "documented_record", mapLayer: "real", category: "mythic_epic", originRegion: "Ancient Near East", chronologyStartYear: -2100, chronologyEndYear: 62, themeColor: "#c9972e", themeColorDark: "#6c4a13", themeColorLight: "#f3d78b", title: "圣经", summary: "摘要", default_locale: "en", ...meta };
const fixture = {
  requestedLocale: "zh-CN",
  detail: "lite",
  work,
  characters: [{ id: "21000000-0000-4000-8000-000000000005", slug: "moses", gender: "male", ageStage: "elder", roleType: "protagonist", realityType: "fictionalised_historical", birthYear: -1400, deathYear: -1200, birthPlaceSlug: "nile-delta", deathPlaceSlug: null, iconVariant: "lawgiver", importance: 5, artistSlug: null, name: "摩西", summary: "摘要", aliases: [], detail: "详情", motivation: "动机", eventSlugs: ["exodus"], locationSlugs: ["nile-delta"], sourceTitles: ["Exodus"], groupSlugs: ["israel-tribe"], chapterSlug: "torah", firstSequence: 4, lastSequence: 4, ...meta }],
  locations: [{ id: "31000000-0000-4000-8000-000000000004", slug: "nile-delta", layer: "real", locationType: "region", coordinateAccuracy: "approximate", preferredZoom: 7, modernCountryCode: "EG", isInferred: true, stillExists: true, lng: 31.1, lat: 30.8, canvasX: null, canvasY: null, name: "尼罗河三角洲", summary: "摘要", aliases: ["埃及"], detail: "详情", literarySignificance: "意义", historicalBackground: "背景", modernStatus: "现状", historicalRegionName: "古埃及", characterSlugs: ["moses"], eventSlugs: ["exodus"], routeSlugs: ["exodus-route"], firstSequence: 4, lastSequence: 4, firstYear: -1300, lastYear: -1200, ...meta }],
  events: [{ id: "41000000-0000-4000-8000-000000000004", slug: "exodus", startDate: null, endDate: null, sequence: 4, reality: "contested", eventType: "migration", timeType: "range", calendarSystem: "unknown", historicalStartYear: -1300, historicalEndYear: -1200, startMonth: null, startDay: null, confidence: "low", parentEventSlug: null, chapterSlug: "torah", title: "离开埃及", summary: "摘要", detail: "详情", significance: "意义", timeLabel: "约公元前 1300–1200 年", locationSlugs: ["nile-delta"], characterSlugs: ["moses"], sourceTitles: ["Exodus"], routeSlugs: ["exodus-route"], ...meta }],
  routes: [{ id: "61000000-0000-4000-8000-000000000002", slug: "exodus-route", layer: "real", certainty: "inferred", name: "路线", summary: "摘要", waypoints: [{ position: 0, locationSlug: "nile-delta", eventSlug: "exodus" }], ...meta }],
  relations: [{ id: "71000000-0000-4000-8000-000000000006", fromSlug: "moses", toSlug: "aaron", relationType: "family", direction: "bidirectional", sentiment: "positive", strength: 5, status: "active", startEventSlug: null, endEventSlug: null, label: "兄弟", summary: "摘要", sourceTitles: ["Exodus"], ...meta }],
  sources: [{ id: "51000000-0000-4000-8000-000000000002", title: "Exodus", url: null, citation: "Exodus 1–24", evidenceGrade: "primary", sourceType: "primary_text" }],
  chronologies: [{ id: "91000000-0000-4000-8000-000000000001", kind: "historical", label: "Sample", startYear: -2100, endYear: 62, calendarSystem: "unknown", isDefault: true }],
  media: [],
  chapters: [{ id: "81000000-0000-4000-8000-000000000001", slug: "torah", sequence: 1, referenceLabel: "Torah", eraStartYear: -2100, eraEndYear: -1200, accentColor: "#c9972e", title: "摩西五经", summary: "摘要", eventCount: 1, firstSequence: 4, lastSequence: 4 }],
  groups: [{ id: "82000000-0000-4000-8000-000000000001", slug: "israel-tribe", groupType: "tribe", sortOrder: 1, accentColor: "#c9972e", anchorCharacterSlug: "moses", name: "以色列支派", summary: "摘要", characterSlugs: ["moses"] }],
};

describe("v4 atlas runtime contract", () => {
  it("accepts explicit complex chronology, identity, geography, hierarchy, and relation metadata", () =>
    expect(AtlasResponseSchema.parse(fixture).events[0]?.timeType).toBe("range"));
  it("carries the era and group tiers of the zoom hierarchy", () => {
    const atlas = AtlasResponseSchema.parse(fixture);
    expect(atlas.chapters[0]?.slug).toBe("torah");
    expect(atlas.groups[0]?.characterSlugs).toEqual(["moses"]);
    expect(atlas.characters[0]?.chapterSlug).toBe("torah");
  });
  it("rejects a silent entity fallback", () => {
    const invalid = structuredClone(fixture) as Record<string, unknown>;
    const locations = invalid.locations as Array<Record<string, unknown>>;
    delete locations[0]?.fallbackUsed;
    expect(AtlasResponseSchema.safeParse(invalid).success).toBe(false);
  });
  it("rejects an approximate event encoded without time type", () => {
    const invalid = structuredClone(fixture) as typeof fixture;
    delete (invalid.events[0] as Partial<(typeof invalid.events)[0]>).timeType;
    expect(AtlasResponseSchema.safeParse(invalid).success).toBe(false);
  });
  it("accepts bundled artwork images and explicit external references", () => {
    const media = [
      { id: "a1000000-0000-4000-8000-000000000001", entityKind: "artwork", entityId: "b1000000-0000-4000-8000-000000000001", mediaKind: "image", usageMode: "bundled", licenseStatus: "verified", licenseUrl: "https://creativecommons.org/publicdomain/zero/1.0/", sourcePageUrl: "https://commons.wikimedia.org/wiki/File:Example.jpg", originalUrl: "https://upload.wikimedia.org/example.jpg", assetSource: "Wikimedia Commons", assetLicence: "CC0", assetAuthor: "Example", assetUrl: "/media/artworks/example.jpg", attributionText: "Example / Wikimedia Commons / CC0", altText: "示例作品（Example）" },
      { id: "a1000000-0000-4000-8000-000000000002", entityKind: "artwork", entityId: "b1000000-0000-4000-8000-000000000002", mediaKind: "external_link", usageMode: "external_link", licenseStatus: "pending", licenseUrl: null, sourcePageUrl: "https://example.org/work", originalUrl: "https://example.org/work", assetSource: "Provider", assetLicence: "Provider terms apply; no redistribution", assetAuthor: "Example", assetUrl: "https://example.org/work", attributionText: "Example / external reference only / no image redistribution", altText: "外部作品（Example）" },
    ] as const;
    const atlas = AtlasResponseSchema.parse({ ...fixture, media });
    expect(atlas.media.map((item) => item.mediaKind)).toEqual(["image", "external_link"]);
  });
});
