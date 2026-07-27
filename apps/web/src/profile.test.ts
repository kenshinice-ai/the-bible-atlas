import { describe, expect, it } from "vitest";
import { ERA_EPIGRAPHS, SETS_BY_PROFILE } from "./epigraphs";
import { formatYear, missingLabels } from "./i18n";
import { PROFILE_META } from "./profile-meta";
import { PROFILES } from "./profile";

/**
 * Every enum value the API can put in front of a reader, i.e. every value that
 * reaches `label()` from a component. Anything absent from the ENUMS table
 * degrades to a de-underscored English string, which in the zh-CN interface is
 * a visible defect — the whole point of `missingLabels()`, which until this
 * test existed was asserted nowhere despite its doc comment saying otherwise.
 *
 * Sourced from the CREATE TYPE statements in db/migrations plus the two
 * free-text columns (characters.icon_variant, character_relations.relation_type)
 * whose values are set by seeds. Adding a value to either means adding it here.
 */
const DISPLAYED_ENUM_VALUES = [
  // work_category, source_type, route_certainty
  "historical_document", "historical_fiction", "realist_fiction", "fantasy", "mythic_epic",
  "primary_text", "scholarly", "historical", "reference", "map", "image",
  "documented", "text_explicit", "inferred",
  // person_gender, age_stage, person_role_type, person_reality_type
  "male", "female", "unknown", "na",
  "child", "youth", "adult", "elder",
  "protagonist", "antagonist", "supporting", "narrator", "collective", "supernatural",
  "fictional", "fictionalised_historical",
  // literary_event_type, event_reality, confidence_level
  "birth", "death", "meeting", "journey", "battle", "trial", "imprisonment", "escape",
  "marriage", "betrayal", "discovery", "political", "social", "religious", "migration", "other",
  "verified_historical", "reported_historical", "fictional_narrative",
  "fictional_with_historical_context", "legendary_or_mythic", "symbolic_or_dream", "contested",
  "high", "medium", "low",
  // location_type, coordinate_accuracy
  "country", "region", "city", "district", "street", "building", "landmark", "prison",
  "station", "port", "battlefield", "residence", "school", "religious_site",
  "fictional_place", "route_node", "planet", "moon", "space_station",
  "exact", "approximate", "city_centroid",
  // relationship_direction / sentiment / status, character_group_type
  "bidirectional", "source_to_target", "target_to_source",
  "positive", "negative", "mixed", "neutral",
  "active", "ended", "changed",
  "family", "dynasty", "circle", "tribe", "institution",
  // characters.icon_variant
  "patriarch", "matriarch", "king", "queen", "prophet", "priest", "judge", "disciple",
  "missionary", "ruler", "soldier", "teacher", "lawgiver", "person",
  "jedi", "sith", "droid", "pilot", "senator", "smuggler", "bounty_hunter",
  // character_relations.relation_type
  "spouse", "sibling", "ally", "adversary", "mentor", "romantic", "liege", "double",
] as const;

describe("bilingual enum coverage", () => {
  it("has a Chinese and English label for every value the API can display", () =>
    expect(missingLabels(DISPLAYED_ENUM_VALUES)).toEqual([]));
});

describe("deployment profiles", () => {
  it("gives every profile its own page metadata, so no build ships another atlas's description", () =>
    expect(Object.keys(PROFILE_META).sort()).toEqual(Object.keys(PROFILES).sort()));

  it("gives every profile its own epigraph set", () =>
    expect(Object.keys(SETS_BY_PROFILE).sort()).toEqual(Object.keys(PROFILES).sort()));

  it("states the unofficial relationship in the galaxy profile's own copy", () => {
    expect(PROFILES.galaxy?.title[1]).toBe("The Galactic Force Atlas");
    expect(PROFILES.galaxy?.tagline[1].toLowerCase()).toContain("unofficial");
    // Landing point 1 of the trademark disclaimer; landing point 2 is the
    // footer note. The IP audit checks for both.
    expect(PROFILE_META.galaxy?.description).toContain("Lucasfilm");
  });

  it("locks the galaxy build to one work, so it has no work picker to hide", () => {
    expect(PROFILES.galaxy?.works).toEqual(["skywalker-saga"]);
    expect(PROFILES.galaxy?.mode).toBe("single");
  });

  it("keeps a house epigraph for each of the twelve galaxy eras", () => {
    // Era epigraphs are keyed by chapter slug and fall back silently when a key
    // is missing, so the key list is asserted rather than merely counted.
    expect(Object.keys(SETS_BY_PROFILE.galaxy!.era)).toEqual([
      "naboo-crisis", "clone-wars", "order-66-and-imperial-rise", "dark-times",
      "rebel-alliance-rising", "yavin-campaign", "hoth-and-exile", "endor-and-the-fall",
      "new-republic", "first-order-rising", "last-jedi", "skywalker-reborn",
    ]);
  });

  it("resolves the active epigraph set from the build's profile", () =>
    // No VITE_WORK_PROFILE under test, so the Bible profile is active.
    expect(ERA_EPIGRAPHS["primeval"]?.enRef).toBe("Genesis 1:1"));
});

describe("era-relative year labels", () => {
  const galaxy = PROFILES.galaxy!.yearLabels!;

  it("counts negative years back from the work's own epoch", () => {
    expect(formatYear(-22, "en", galaxy)).toBe("22 BBY");
    expect(formatYear(-22, "zh-CN", galaxy)).toBe("雅汶战役前 22 年");
  });

  it("counts positive years forward from it", () => {
    expect(formatYear(3, "en", galaxy)).toBe("3 ABY");
    expect(formatYear(3, "zh-CN", galaxy)).toBe("雅汶战役后 3 年");
  });

  it("leaves BCE/CE atlases untouched when a profile declares no labels", () => {
    expect(PROFILES.bible?.yearLabels).toBeUndefined();
    expect(formatYear(-1300, "en")).toBe("1300 BCE");
    expect(formatYear(62, "en")).toBe("62 CE");
  });
});
