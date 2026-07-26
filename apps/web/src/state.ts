import { EntityTypeSchema, LocaleSchema, type Atlas, type EntityType, type Locale } from "./types";

export type Tab = "characters" | "events" | "locations" | "routes" | "relations";
export type SelectionMode = "single" | "multi";
export type MapLayer = "real" | "fictional";
export type SelectionSource = "map" | "timeline" | "list" | "graph" | "search" | "url";
export type TimelineMode = "history" | "narrative";
export type MapContentLayer = "places" | "routes" | "landmarks";

/**
 * The zoom tier shared by the graph, the map and the timeline. Replacing hard
 * entity caps with a tier means a screen never has to draw more than the tier's
 * worth of objects, however large the work grows.
 */
export type ZoomLevel = "era" | "group" | "major" | "all";
export const ZOOM_LEVELS: readonly ZoomLevel[] = ["era", "group", "major", "all"];

export interface SelectedEntity { type: EntityType; id: string; workSlug: string }

export interface ExploreState {
  locale: Locale;
  mode: SelectionMode;
  works: string[];
  active: string;
  tab: Tab;
  selectedEntity: SelectedEntity | null;
  selectionSource: SelectionSource;
  /** Narrative cutoff. `null` means the whole narrative — no sentinel numbers. */
  until: number | null;
  timelineMode: TimelineMode;
  /** `null` means "derive from the work's own chronology" rather than a fixed span. */
  rangeStart: number | null;
  rangeEnd: number | null;
  mapLayers: MapContentLayer[];
  zoomLevel: ZoomLevel;
  /** Era (chapter) filter, applied to every panel at once. */
  chapter: string | null;
  /** Free-text filter for the entity lists. */
  query: string;
}

/**
 * Bible-only front-end lock (sacred rebrand P0). Data and multi-work code
 * paths stay intact so the rollback cost is zero; the parser simply refuses
 * to leave the Bible.
 */
export const BIBLE_ONLY = true;
const BIBLE_SLUG = "the-bible";

export const MAX_SELECTED_WORKS = 5;
export const FALLBACK_RANGE = { start: -3000, end: 2026 } as const;
const tabs = new Set<Tab>(["characters", "events", "locations", "routes", "relations"]);
const mapLayerValues = new Set<MapContentLayer>(["places", "routes", "landmarks"]);
const zoomValues = new Set<ZoomLevel>(ZOOM_LEVELS);

function parseEntity(value: string | null, legacy: string | null): SelectedEntity | null {
  if (value) {
    const [rawType, workSlug, ...idParts] = value.split(":");
    const type = EntityTypeSchema.safeParse(rawType);
    const id = idParts.join(":");
    if (type.success && workSlug && id) return { type: type.data, workSlug, id };
  }
  if (legacy) { const split = legacy.indexOf(":"); if (split > 0) return { type: "location", workSlug: legacy.slice(0, split), id: legacy.slice(split + 1) }; }
  return null;
}

function optionalYear(raw: string | null): number | null {
  if (raw === null) return null;
  const value = Number(raw);
  return Number.isInteger(value) && value !== 0 ? value : null;
}

/** Parse shareable Explore State while preserving documented v3.0/v3.1 links. */
export function parseAtlasState(search: string): ExploreState {
  const q = new URLSearchParams(search);
  const tabValue = q.get("tab");
  const legacyWork = q.get("work");
  const requestedMode: SelectionMode = q.get("mode") === "multi" || q.get("mode") === "compare" ? "multi" : "single";
  // Under BIBLE_ONLY, old multi-work deep links are silently normalized to the
  // Bible instead of erroring — the URL's works/primary/mode are ignored.
  const mode: SelectionMode = BIBLE_ONLY ? "single" : requestedMode;
  const requestedWorks = (q.get("works")?.split(",") ?? (legacyWork ? [legacyWork] : [])).filter(Boolean);
  const works = requestedWorks.slice(0, requestedMode === "multi" ? MAX_SELECTED_WORKS : 1);
  const normalizedWorks = BIBLE_ONLY ? [BIBLE_SLUG] : works.length > 0 ? works : [BIBLE_SLUG];
  const requestedActive = q.get("active") ?? q.get("primary");
  const requestedLayers = (q.get("layers")?.split(",") ?? ["places", "routes", "landmarks"]).filter((item): item is MapContentLayer => mapLayerValues.has(item as MapContentLayer));
  const untilRaw = q.get("until");
  const untilValue = untilRaw === null ? null : Number(untilRaw);
  const zoomRaw = q.get("zoom");
  // v3.1 wrote `until=999` as "show everything"; keep reading it, stop writing it.
  const until = untilValue !== null && Number.isInteger(untilValue) && untilValue > 0 && untilValue !== 999 ? untilValue : null;
  const rangeStart = optionalYear(q.get("from"));
  const rangeEnd = optionalYear(q.get("to"));
  return {
    // English is the default presentation language; Chinese stays one tap away.
    locale: LocaleSchema.catch("en").parse(q.get("locale") ?? (q.get("lang") === "zh-CN" ? "zh-CN" : "en")),
    mode,
    works: normalizedWorks,
    active: requestedActive && normalizedWorks.includes(requestedActive) ? requestedActive : normalizedWorks[0]!,
    tab: tabValue && tabs.has(tabValue as Tab) ? (tabValue as Tab) : "events",
    selectedEntity: parseEntity(q.get("entity"), q.get("selected")),
    selectionSource: "url",
    until,
    timelineMode: q.get("timeline") === "narrative" ? "narrative" : "history",
    rangeStart,
    rangeEnd: rangeEnd !== null && rangeStart !== null && rangeEnd < rangeStart ? null : rangeEnd,
    mapLayers: requestedLayers.length > 0 ? requestedLayers : ["places", "routes", "landmarks"],
    zoomLevel: zoomRaw && zoomValues.has(zoomRaw as ZoomLevel) ? (zoomRaw as ZoomLevel) : "group",
    chapter: q.get("era"),
    query: q.get("q") ?? "",
  };
}

/** Serialize all navigation state needed for refresh and share restoration. */
export function serializeAtlasState(state: ExploreState): string {
  const q = new URLSearchParams({
    locale: state.locale, mode: state.mode, works: state.works.join(","), active: state.active,
    tab: state.tab, timeline: state.timelineMode, layers: state.mapLayers.join(","), zoom: state.zoomLevel,
  });
  if (state.selectedEntity) q.set("entity", `${state.selectedEntity.type}:${state.selectedEntity.workSlug}:${state.selectedEntity.id}`);
  if (state.until !== null) q.set("until", String(state.until));
  if (state.rangeStart !== null) q.set("from", String(state.rangeStart));
  if (state.rangeEnd !== null) q.set("to", String(state.rangeEnd));
  if (state.chapter) q.set("era", state.chapter);
  if (state.query) q.set("q", state.query);
  return `?${q}`;
}

export type SelectionIssue = "too_many" | "mixed_layers" | "unknown_work";
export function validateWorkSelection(catalog: readonly { slug: string; mapLayer: MapLayer }[], mode: SelectionMode, selected: readonly string[]): SelectionIssue | null {
  if (selected.length === 0 || selected.length > (mode === "multi" ? MAX_SELECTED_WORKS : 1)) return "too_many";
  const selectedWorks = selected.map((slug) => catalog.find((work) => work.slug === slug));
  if (selectedWorks.some((work) => work === undefined)) return "unknown_work";
  if (new Set(selectedWorks.map((work) => work!.mapLayer)).size > 1) return "mixed_layers";
  return null;
}

export function historicalSortValue(year: number | null): number { return year ?? Number.POSITIVE_INFINITY; }

export function zoomForLocation(type: string, preferred: number): number {
  const defaults: Record<string, number> = { country: 5, region: 7, city: 10, district: 13, street: 15, building: 15, landmark: 15, prison: 15, station: 15, port: 13, battlefield: 12, residence: 15, school: 15, religious_site: 15, fictional_place: 8, route_node: 12 };
  return Number.isFinite(preferred) && preferred >= 2 && preferred <= 18 ? preferred : (defaults[type] ?? 10);
}

export function relationVisibleAtSequence(
  relation: { startEventSlug: string | null; endEventSlug: string | null },
  events: readonly { slug: string; sequence: number }[],
  sequence: number,
): boolean {
  const start = relation.startEventSlug ? events.find((event) => event.slug === relation.startEventSlug)?.sequence : undefined;
  const end = relation.endEventSlug ? events.find((event) => event.slug === relation.endEventSlug)?.sequence : undefined;
  return (start === undefined || start <= sequence) && (end === undefined || end >= sequence);
}

/**
 * The visible historical window. `null` bounds mean "use this work's own
 * chronology", which is what stops a Bible whose events end in 96 CE from being
 * squeezed into the left third of a hardcoded 3000 BCE – 2026 CE axis.
 */
export function resolveRange(state: ExploreState, atlases: readonly Atlas[]): { start: number; end: number } {
  if (state.rangeStart !== null && state.rangeEnd !== null) return { start: state.rangeStart, end: state.rangeEnd };
  const years = atlases.flatMap((atlas) => {
    const chronology = atlas.chronologies.find((item) => item.kind === "historical" && item.isDefault) ?? atlas.chronologies.find((item) => item.kind === "historical");
    const bounds = [chronology?.startYear, chronology?.endYear, atlas.work.chronologyStartYear, atlas.work.chronologyEndYear];
    const eventYears = atlas.events.flatMap((event) => [event.historicalStartYear, event.historicalEndYear]);
    return [...bounds, ...eventYears].filter((value): value is number => typeof value === "number");
  });
  if (years.length === 0) return { start: state.rangeStart ?? FALLBACK_RANGE.start, end: state.rangeEnd ?? FALLBACK_RANGE.end };
  const min = Math.min(...years);
  const max = Math.max(...years);
  // A little breathing room so the first and last events are not on the axis ends.
  const pad = Math.max(20, Math.round((max - min) * 0.04));
  const start = state.rangeStart ?? (min - pad === 0 ? -1 : min - pad);
  const end = state.rangeEnd ?? (max + pad === 0 ? 1 : max + pad);
  return start < end ? { start, end } : { start: min, end: max };
}
