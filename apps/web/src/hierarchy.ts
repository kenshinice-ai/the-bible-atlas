import { relationVisibleAtSequence, type ExploreState, type ZoomLevel } from "./state";
import { referenceLabel } from "./i18n";
import type { Atlas, AtlasCharacter, AtlasEvent, AtlasLocation, AtlasRelation, Locale } from "./types";

/**
 * Derives every view's data from one in-memory atlas index.
 *
 * The zoom hierarchy (era → group → key people → everyone) is computed here
 * rather than fetched per tier, so changing zoom is instant and the same filter
 * set drives the map, the timeline, the lists and the graph at once. That shared
 * derivation is what lets the work carry an unbounded number of entities: no
 * single view ever renders more than its tier's worth.
 */

export interface Filters {
  chapter: string | null;
  until: number | null;
  rangeStart: number;
  rangeEnd: number;
  timelineMode: "history" | "narrative";
  query: string;
}

export function filtersFrom(state: ExploreState, range: { start: number; end: number }): Filters {
  return { chapter: state.chapter, until: state.until, rangeStart: range.start, rangeEnd: range.end, timelineMode: state.timelineMode, query: state.query.trim().toLocaleLowerCase() };
}

export function isFiltered(filters: Filters, defaults: { start: number; end: number }): boolean {
  return Boolean(filters.chapter) || filters.until !== null || filters.query !== "" ||
    filters.rangeStart !== defaults.start || filters.rangeEnd !== defaults.end;
}

/**
 * The one place event visibility is decided. Every panel reads this, which is
 * why dragging the timeline now also dims the map and the graph.
 */
export function visibleEvents(atlas: Atlas, filters: Filters): AtlasEvent[] {
  return atlas.events.filter((event) => {
    if (filters.chapter && event.chapterSlug !== filters.chapter) return false;
    if (filters.until !== null && event.sequence > filters.until) return false;
    if (filters.timelineMode === "history") {
      // Undated events have no place on a historical axis, but hiding them
      // entirely would silently drop the primeval era, so they stay visible and
      // are surfaced separately by the timeline.
      const year = event.historicalStartYear;
      if (year !== null && (year < filters.rangeStart || year > filters.rangeEnd)) return false;
    }
    return true;
  });
}

export function matchesQuery(haystack: readonly (string | null | undefined)[], query: string): boolean {
  if (!query) return true;
  return haystack.some((value) => value?.toLocaleLowerCase().includes(query));
}

export function visibleCharacters(atlas: Atlas, filters: Filters, eventSlugs: ReadonlySet<string>): AtlasCharacter[] {
  return atlas.characters.filter((person) => {
    if (filters.chapter && person.chapterSlug !== filters.chapter && !person.eventSlugs.some((slug) => eventSlugs.has(slug))) return false;
    if (filters.until !== null && person.firstSequence !== null && person.firstSequence > filters.until) return false;
    return matchesQuery([person.name, person.summary, ...person.aliases], filters.query);
  });
}

export function visibleLocations(atlas: Atlas, filters: Filters, eventSlugs: ReadonlySet<string>): AtlasLocation[] {
  return atlas.locations.filter((place) => {
    if (place.eventSlugs.length > 0 && !place.eventSlugs.some((slug) => eventSlugs.has(slug))) return false;
    return matchesQuery([place.name, place.summary, ...place.aliases], filters.query);
  });
}

export function visibleRelations(atlas: Atlas, filters: Filters, characterSlugs: ReadonlySet<string>): AtlasRelation[] {
  const cutoff = filters.until;
  return atlas.relations.filter((relation) => {
    if (!characterSlugs.has(relation.fromSlug) || !characterSlugs.has(relation.toSlug)) return false;
    if (cutoff !== null && !relationVisibleAtSequence(relation, atlas.events, cutoff)) return false;
    return true;
  });
}

// ---------------------------------------------------------------------------
// Graph tiers
// ---------------------------------------------------------------------------

export type NodeKind = "era" | "group" | "person";

export interface GraphNode {
  id: string;
  kind: NodeKind;
  label: string;
  sublabel: string;
  color: string;
  /** Drives radius; a count of members or of incident relations. */
  weight: number;
  /** Character slugs this node stands for, used for drill-down and selection. */
  members: string[];
  /** Slug of the underlying entity: chapter slug, group slug or character slug. */
  slug: string;
  importance: number;
  x?: number; y?: number; vx?: number; vy?: number; fx?: number | null; fy?: number | null;
}

export interface GraphEdge {
  id: string;
  source: string | GraphNode;
  target: string | GraphNode;
  weight: number;
  sentiment: "positive" | "negative" | "mixed" | "neutral";
  label: string;
  kind: "relation" | "succession";
  relationIds: string[];
}

export interface GraphModel { nodes: GraphNode[]; edges: GraphEdge[]; hiddenCount: number }

const SENTIMENT_RANK = { negative: 0, mixed: 1, neutral: 2, positive: 3 } as const;

function mergeSentiment(values: readonly GraphEdge["sentiment"][]): GraphEdge["sentiment"] {
  if (values.length === 0) return "neutral";
  if (values.includes("negative") && values.includes("positive")) return "mixed";
  return values.reduce((best, value) => (SENTIMENT_RANK[value] < SENTIMENT_RANK[best] ? value : best), values[0]!);
}

/**
 * Collapse the relationship network to the requested tier.
 *
 * `era` and `group` aggregate many relations into one weighted edge, so the
 * screen holds tens of nodes instead of hundreds. `major` filters by importance;
 * `all` shows every visible person. Zooming the canvas moves between tiers.
 */
export function buildGraph(
  atlas: Atlas,
  level: ZoomLevel,
  characters: readonly AtlasCharacter[],
  relations: readonly AtlasRelation[],
  focusSlug: string | null,
  locale: Locale = "en",
): GraphModel {
  const byCharacter = new Map(characters.map((person) => [person.slug, person]));

  if (level === "era") {
    const used = new Map<string, GraphNode>();
    for (const chapter of atlas.chapters) {
      const members = characters.filter((person) => person.chapterSlug === chapter.slug).map((person) => person.slug);
      if (members.length === 0) continue;
      used.set(chapter.slug, {
        id: `era:${chapter.slug}`, kind: "era", slug: chapter.slug, label: chapter.title,
        sublabel: referenceLabel(chapter.referenceLabel, locale), color: chapter.accentColor, weight: members.length, members, importance: 5,
      });
    }
    const edges = new Map<string, GraphEdge>();
    // Chronological spine: consecutive eras are always connected, so the
    // collapsed view reads as one narrative rather than isolated islands.
    const ordered = atlas.chapters.filter((chapter) => used.has(chapter.slug));
    for (let index = 1; index < ordered.length; index += 1) {
      const from = ordered[index - 1]!; const to = ordered[index]!;
      edges.set(`succ:${from.slug}:${to.slug}`, {
        id: `succ:${from.slug}:${to.slug}`, source: `era:${from.slug}`, target: `era:${to.slug}`,
        weight: 1, sentiment: "neutral", label: "", kind: "succession", relationIds: [],
      });
    }
    for (const relation of relations) {
      const from = byCharacter.get(relation.fromSlug)?.chapterSlug;
      const to = byCharacter.get(relation.toSlug)?.chapterSlug;
      if (!from || !to || from === to || !used.has(from) || !used.has(to)) continue;
      const key = from < to ? `era:${from}|era:${to}` : `era:${to}|era:${from}`;
      const existing = edges.get(key);
      if (existing) { existing.weight += 1; existing.relationIds.push(relation.id); existing.sentiment = mergeSentiment([existing.sentiment, relation.sentiment]); continue; }
      edges.set(key, { id: key, source: `era:${from}`, target: `era:${to}`, weight: 1, sentiment: relation.sentiment, label: "", kind: "relation", relationIds: [relation.id] });
    }
    return { nodes: [...used.values()], edges: [...edges.values()], hiddenCount: characters.length - [...used.values()].reduce((sum, node) => sum + node.members.length, 0) };
  }

  if (level === "group") {
    const used = new Map<string, GraphNode>();
    const groupOf = new Map<string, string>();
    for (const group of atlas.groups) {
      const members = group.characterSlugs.filter((slug) => byCharacter.has(slug));
      if (members.length === 0) continue;
      used.set(group.slug, {
        id: `group:${group.slug}`, kind: "group", slug: group.slug, label: group.name,
        sublabel: group.summary, color: group.accentColor, weight: members.length, members, importance: 4,
      });
      for (const slug of members) if (!groupOf.has(slug)) groupOf.set(slug, group.slug);
    }
    const edges = new Map<string, GraphEdge>();
    for (const relation of relations) {
      const from = groupOf.get(relation.fromSlug); const to = groupOf.get(relation.toSlug);
      if (!from || !to || from === to) continue;
      const key = from < to ? `group:${from}|group:${to}` : `group:${to}|group:${from}`;
      const existing = edges.get(key);
      if (existing) { existing.weight += 1; existing.relationIds.push(relation.id); existing.sentiment = mergeSentiment([existing.sentiment, relation.sentiment]); continue; }
      edges.set(key, { id: key, source: `group:${from}`, target: `group:${to}`, weight: 1, sentiment: relation.sentiment, label: "", kind: "relation", relationIds: [relation.id] });
    }
    return { nodes: [...used.values()], edges: [...edges.values()], hiddenCount: 0 };
  }

  const floor = level === "major" ? 4 : 1;
  const focusNeighbours = new Set<string>();
  if (focusSlug) {
    focusNeighbours.add(focusSlug);
    for (const relation of relations) {
      if (relation.fromSlug === focusSlug) focusNeighbours.add(relation.toSlug);
      if (relation.toSlug === focusSlug) focusNeighbours.add(relation.fromSlug);
    }
  }
  const people = characters.filter((person) => person.importance >= floor || focusNeighbours.has(person.slug));
  const visible = new Set(people.map((person) => person.slug));
  const nodes = people.map<GraphNode>((person) => ({
    id: `person:${person.slug}`, kind: "person", slug: person.slug, label: person.name,
    sublabel: person.summary, color: colorForCharacter(atlas, person), weight: 1, members: [person.slug], importance: person.importance,
  }));
  const weight = new Map<string, number>();
  const edges: GraphEdge[] = [];
  for (const relation of relations) {
    if (!visible.has(relation.fromSlug) || !visible.has(relation.toSlug)) continue;
    edges.push({
      id: relation.id, source: `person:${relation.fromSlug}`, target: `person:${relation.toSlug}`,
      weight: relation.strength, sentiment: relation.sentiment, label: relation.label, kind: "relation", relationIds: [relation.id],
    });
    weight.set(relation.fromSlug, (weight.get(relation.fromSlug) ?? 0) + 1);
    weight.set(relation.toSlug, (weight.get(relation.toSlug) ?? 0) + 1);
  }
  for (const node of nodes) node.weight = 1 + (weight.get(node.slug) ?? 0);
  return { nodes, edges, hiddenCount: characters.length - nodes.length };
}

/** Colour a person by the era they first appear in, so the graph reads chronologically. */
export function colorForCharacter(atlas: Atlas, person: AtlasCharacter): string {
  const chapter = atlas.chapters.find((item) => item.slug === person.chapterSlug);
  if (chapter) return chapter.accentColor;
  const group = atlas.groups.find((item) => item.slug === person.groupSlugs[0]);
  return group?.accentColor ?? atlas.work.themeColor;
}

export function colorForEvent(atlas: Atlas, event: AtlasEvent): string {
  return atlas.chapters.find((item) => item.slug === event.chapterSlug)?.accentColor ?? atlas.work.themeColor;
}

/** The era a place sits in, taken from its earliest linked event. */
export function chapterForLocation(atlas: Atlas, place: AtlasLocation): string | null {
  const first = place.eventSlugs[0];
  return atlas.events.find((event) => event.slug === first)?.chapterSlug ?? null;
}

/** Ordered stops of one person's life, used for the map trajectory overlay. */
export function trajectoryFor(atlas: Atlas, personSlug: string): AtlasLocation[] {
  const person = atlas.characters.find((item) => item.slug === personSlug);
  if (!person) return [];
  const byLocation = new Map(atlas.locations.map((place) => [place.slug, place]));
  const ordered: AtlasLocation[] = [];
  const seen = new Set<string>();
  const push = (slug: string | null | undefined) => {
    if (!slug || seen.has(slug)) return;
    const place = byLocation.get(slug);
    if (!place || place.lat === null || place.lng === null) return;
    seen.add(slug); ordered.push(place);
  };
  push(person.birthPlaceSlug);
  for (const eventSlug of person.eventSlugs) {
    const event = atlas.events.find((item) => item.slug === eventSlug);
    for (const slug of event?.locationSlugs ?? []) push(slug);
  }
  push(person.deathPlaceSlug);
  return ordered;
}
