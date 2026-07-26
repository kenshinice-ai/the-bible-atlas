import { describe, expect, it } from "vitest";
import { formatYear } from "./i18n";
import { historicalSortValue, parseAtlasState, relationVisibleAtSequence, serializeAtlasState, validateWorkSelection, zoomForLocation } from "./state";

describe("v4 Explore State deep links", () => {
  it("restores five works, a primary work, typed entity, and timeline", () => {
    const state = parseAtlasState("?locale=en&mode=compare&works=a,b,c,d,e&primary=c&tab=relations&entity=character:c:moses&timeline=history&from=-1400&to=100");
    expect(state).toMatchObject({
      locale: "en", mode: "multi", works: ["a", "b", "c", "d", "e"], active: "c", tab: "relations",
      selectedEntity: { type: "character", workSlug: "c", id: "moses" }, timelineMode: "history", rangeStart: -1400, rangeEnd: 100,
    });
  });
  it("caps a malformed sixth work without silently replacing the first five", () =>
    expect(parseAtlasState("?mode=multi&works=a,b,c,d,e,f").works).toEqual(["a", "b", "c", "d", "e"]));
  it("keeps only one work in single mode", () => expect(parseAtlasState("?mode=single&works=a,b").works).toEqual(["a"]));
  it("defaults to the Bible when no work is requested", () => expect(parseAtlasState("").works).toEqual(["the-bible"]));
  it("restores a legacy location selection", () =>
    expect(parseAtlasState("?work=a&selected=a:london").selectedEntity).toEqual({ type: "location", workSlug: "a", id: "london" }));
  it("reads the v3.1 sentinel until=999 as 'no narrative cutoff'", () => expect(parseAtlasState("?until=999").until).toBeNull());
  it("restores era, query and zoom tier", () => {
    const state = parseAtlasState("?era=torah&q=moses&zoom=all");
    expect(state).toMatchObject({ chapter: "torah", query: "moses", zoomLevel: "all" });
  });
  it("round trips the shareable state", () => {
    const state = parseAtlasState("?mode=multi&works=a,b&active=b&entity=route:b:r1&tab=routes&layers=places,routes&timeline=narrative&until=4&era=torah&q=x&zoom=major");
    expect(parseAtlasState(serializeAtlasState(state))).toEqual(state);
  });
});

describe("selection and complex chronology helpers", () => {
  const catalog: Array<{ slug: string; mapLayer: "real" | "fictional" }> = [
    ...["a", "b", "c", "d", "e"].map((slug) => ({ slug, mapLayer: "real" as const })),
    { slug: "fiction", mapLayer: "fictional" },
  ];
  it("accepts five same-layer works", () => expect(validateWorkSelection(catalog, "multi", ["a", "b", "c", "d", "e"])).toBeNull());
  it("rejects a sixth work", () => expect(validateWorkSelection(catalog, "multi", ["a", "b", "c", "d", "e", "missing"])).toBe("too_many"));
  it("rejects mixed real and fictional layers", () => expect(validateWorkSelection(catalog, "multi", ["a", "fiction"])).toBe("mixed_layers"));
  it("sorts BCE before CE and keeps unknown last", () =>
    expect([-4, null, -1300, 62].sort((a, b) => historicalSortValue(a) - historicalSortValue(b))).toEqual([-1300, -4, 62, null]));
  it("formats BCE without a false year zero", () => expect(formatYear(-1300, "en")).toBe("1300 BCE"));
  it("labels the BCE/CE boundary instead of inventing year zero", () => expect(formatYear(0, "en")).toBe("BCE/CE boundary"));
  it("uses building and regional zoom levels when no preference is valid", () => {
    expect(zoomForLocation("building", 99)).toBe(15);
    expect(zoomForLocation("region", 0)).toBe(7);
  });
  it("filters relationship lifecycle by narrative sequence", () => {
    const events = [{ slug: "start", sequence: 2 }, { slug: "end", sequence: 5 }];
    const relation = { startEventSlug: "start", endEventSlug: "end" };
    expect(relationVisibleAtSequence(relation, events, 1)).toBe(false);
    expect(relationVisibleAtSequence(relation, events, 3)).toBe(true);
    expect(relationVisibleAtSequence(relation, events, 6)).toBe(false);
  });
});
