import { useEffect, useMemo, useRef, useState } from "react";
import { getAtlas, getWorks } from "./api";
import { AtlasMap } from "./components/AtlasMap";
import { EntityDrawer } from "./components/EntityDrawer";
import { EntityList } from "./components/EntityList";
import { GlobalSearch } from "./components/GlobalSearch";
import { RelationGraph } from "./components/RelationGraph";
import { TimelineRibbon } from "./components/TimelineRibbon";
import { WorkControlCenter } from "./components/WorkControlCenter";
import { ERA_EPIGRAPHS, FOOTER_EPIGRAPH, LOADING_EPIGRAPHS, WELCOME_EPIGRAPH, type Epigraph } from "./epigraphs";
import { filtersFrom, isFiltered, visibleCharacters, visibleEvents, visibleLocations, visibleRelations } from "./hierarchy";
import { formatYear, label, t } from "./i18n";
import {
  BIBLE_ONLY, parseAtlasState, resolveRange, serializeAtlasState, validateWorkSelection,
  type ExploreState, type MapContentLayer, type SelectedEntity, type SelectionMode, type SelectionSource, type Tab, type TimelineMode, type ZoomLevel,
} from "./state";
import { type Atlas, type Locale, type WorksResponse } from "./types";

function tabForEntity(entity: SelectedEntity): Tab {
  return entity.type === "character" ? "characters"
    : entity.type === "event" ? "events"
      : entity.type === "location" ? "locations"
        : entity.type === "route" ? "routes"
          : entity.type === "relationship" ? "relations" : "events";
}

const TABS: readonly Tab[] = ["characters", "events", "locations", "routes", "relations"];

/**
 * A scripture epigraph as a typographic event: quotation plus attribution,
 * one complete language at a time (no bilingual interleaving).
 */
function EpigraphBlock({ epigraph, locale, className = "epigraph" }: { epigraph: Epigraph; locale: Locale; className?: string }) {
  return <figure className={className}>
    {locale === "zh-CN"
      ? <>
        <blockquote>「{epigraph.zh}」</blockquote>
        <cite>——{epigraph.zhRef}{t("epigraphSourceSuffix", locale)}</cite>
      </>
      : <>
        <blockquote lang="en">“{epigraph.en}”</blockquote>
        <cite>— {epigraph.enRef} {t("epigraphSourceSuffix", locale)}</cite>
      </>}
  </figure>;
}

export default function App() {
  const [explore, setExplore] = useState<ExploreState>(() => parseAtlasState(location.search));
  const [works, setWorks] = useState<WorksResponse["items"]>([]);
  const [atlases, setAtlases] = useState<Atlas[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [selectionError, setSelectionError] = useState<string | null>(null);
  const [copied, setCopied] = useState(false);
  const [loading, setLoading] = useState(true);
  const atlasCache = useRef(new Map<string, Atlas>());
  const locale = explore.locale;

  function commit(next: ExploreState, push = false) {
    if (push) history.pushState(null, "", serializeAtlasState(next));
    setExplore(next);
  }

  useEffect(() => {
    const restore = () => setExplore(parseAtlasState(location.search));
    window.addEventListener("popstate", restore);
    return () => window.removeEventListener("popstate", restore);
  }, []);

  useEffect(() => {
    if (!explore.selectedEntity) return;
    const dismissOutside = (event: PointerEvent) => {
      const drawer = document.querySelector(".entity-drawer");
      if (event.target instanceof Element && event.target.closest("button,a,input,select,summary,label,canvas,[role='button'],.browser,.map-shell,.timeline,.global-search")) return;
      if (event.target instanceof Node && drawer && !drawer.contains(event.target)) setExplore((current) => ({ ...current, selectedEntity: null }));
    };
    const dismissWithKeyboard = (event: KeyboardEvent) => { if (event.key === "Escape") setExplore((current) => ({ ...current, selectedEntity: null })); };
    document.addEventListener("pointerdown", dismissOutside);
    document.addEventListener("keydown", dismissWithKeyboard);
    return () => { document.removeEventListener("pointerdown", dismissOutside); document.removeEventListener("keydown", dismissWithKeyboard); };
  }, [explore.selectedEntity]);

  useEffect(() => { history.replaceState(null, "", serializeAtlasState(explore)); }, [explore]);

  useEffect(() => {
    let current = true;
    setError(null);
    void getWorks(locale)
      .then((response) => { if (current) setWorks(response.items); })
      .catch((cause: unknown) => { if (current) setError(cause instanceof Error ? cause.message : String(cause)); });
    return () => { current = false; };
  }, [locale]);

  useEffect(() => {
    let current = true;
    if (works.length === 0) return () => { current = false; };
    const issue = validateWorkSelection(works, explore.mode, explore.works);
    if (issue) {
      const message = issue === "mixed_layers" ? t("mixedLayers", locale) : issue === "unknown_work" ? t("unknownWork", locale) : t("limitReached", locale);
      setAtlases([]); setSelectionError(message); setError(message); setLoading(false);
      return () => { current = false; };
    }
    setSelectionError(null); setError(null); setLoading(true);
    const load = async (slug: string) => {
      const key = `${locale}:${slug}`;
      const cached = atlasCache.current.get(key);
      if (cached) return cached;
      const atlas = await getAtlas(slug, locale);
      atlasCache.current.set(key, atlas);
      return atlas;
    };
    void Promise.all(explore.works.map(load))
      .then((items) => { if (current) { setAtlases(items); setLoading(false); } })
      .catch((cause: unknown) => { if (current) { setError(cause instanceof Error ? cause.message : String(cause)); setLoading(false); } });
    return () => { current = false; };
  }, [locale, explore.mode, explore.works, works]);

  const activeAtlas = atlases.find((atlas) => atlas.work.slug === explore.active) ?? atlases[0] ?? null;

  // One derivation feeds every panel, which is why moving the timeline now also
  // changes the map, the lists and the graph instead of only the event list.
  const defaultRange = useMemo(() => resolveRange({ ...explore, rangeStart: null, rangeEnd: null }, atlases), [atlases, explore]);
  const range = useMemo(() => resolveRange(explore, atlases), [atlases, explore]);
  const filters = useMemo(() => filtersFrom(explore, range), [explore, range]);

  const derived = useMemo(() => {
    if (!activeAtlas) return null;
    const events = visibleEvents(activeAtlas, filters);
    const eventSlugs = new Set(events.map((event) => event.slug));
    const characters = visibleCharacters(activeAtlas, filters, eventSlugs);
    const characterSlugs = new Set(characters.map((person) => person.slug));
    const locations = visibleLocations(activeAtlas, filters, eventSlugs);
    const relations = visibleRelations(activeAtlas, filters, characterSlugs);
    const routes = activeAtlas.routes.filter((route) => route.waypoints.some((waypoint) => eventSlugs.has(waypoint.eventSlug ?? "") || locations.some((place) => place.slug === waypoint.locationSlug)));
    return { events, eventSlugs, characters, characterSlugs, locations, relations, routes, locationSlugs: new Set(locations.map((place) => place.slug)) };
  }, [activeAtlas, filters]);

  const selectedAtlas = explore.selectedEntity ? atlases.find((atlas) => atlas.work.slug === explore.selectedEntity?.workSlug) : null;
  const filtersActive = isFiltered(filters, defaultRange);

  function changeMode(mode: SelectionMode) {
    setSelectionError(null);
    commit({ ...explore, mode, works: mode === "single" ? [explore.active] : explore.works, selectedEntity: null, selectionSource: "list" }, true);
  }

  function chooseWork(slug: string) {
    setSelectionError(null);
    const reset = { selectedEntity: null, until: null, chapter: null, rangeStart: null, rangeEnd: null, query: "" } as const;
    if (explore.mode === "single") { commit({ ...explore, works: [slug], active: slug, ...reset }, true); return; }
    if (explore.works.includes(slug)) {
      if (explore.works.length === 1) { setSelectionError(t("keepOne", locale)); return; }
      const remaining = explore.works.filter((item) => item !== slug);
      commit({ ...explore, works: remaining, active: explore.active === slug ? remaining[0]! : explore.active, selectedEntity: explore.selectedEntity?.workSlug === slug ? null : explore.selectedEntity }, true);
      return;
    }
    if (explore.works.length >= 5) { setSelectionError(t("limitReached", locale)); return; }
    const currentLayer = works.find((item) => item.slug === explore.works[0])?.mapLayer;
    const candidateLayer = works.find((item) => item.slug === slug)?.mapLayer;
    if (currentLayer && candidateLayer && currentLayer !== candidateLayer) { setSelectionError(t("mixedLayers", locale)); return; }
    commit({ ...explore, works: [...explore.works, slug], active: slug, ...reset }, true);
  }

  /**
   * Selecting an event no longer rewrites the narrative cutoff. In v3.1 it did,
   * which silently hid every later event from the list the user had just clicked.
   */
  function selectEntity(entity: SelectedEntity, source: SelectionSource) {
    commit({ ...explore, active: entity.workSlug, selectedEntity: entity, selectionSource: source, tab: tabForEntity(entity) }, true);
  }

  function setTab(tab: Tab) { commit({ ...explore, tab }, true); }
  function toggleLayer(layer: MapContentLayer) {
    const mapLayers = explore.mapLayers.includes(layer) ? explore.mapLayers.filter((item) => item !== layer) : [...explore.mapLayers, layer];
    commit({ ...explore, mapLayers });
  }
  function setTimelineMode(timelineMode: TimelineMode) { commit({ ...explore, timelineMode }, true); }
  function setZoomLevel(zoomLevel: ZoomLevel) { if (zoomLevel !== explore.zoomLevel) commit({ ...explore, zoomLevel }); }
  function setChapter(chapter: string | null) { commit({ ...explore, chapter, tab: explore.tab === "relations" ? "relations" : explore.tab }, true); }
  function clearFilters() { commit({ ...explore, chapter: null, until: null, rangeStart: null, rangeEnd: null, query: "" }, true); }

  const activeChapter = activeAtlas?.chapters.find((item) => item.slug === explore.chapter) ?? null;

  return <main className={explore.selectedEntity ? "has-drawer" : undefined}>
    <header className="topbar">
      <div className="brand">
        <p className="eyebrow">{t("tagline", locale)}</p>
        <h1>{t("title", locale)}</h1>
      </div>
      <div className="controls">
        <GlobalSearch
          locale={locale}
          activeWork={explore.active}
          onSelectEntity={(entity) => selectEntity(entity, "search")}
          onSelectWork={chooseWork}
        />
        {!BIBLE_ONLY && <WorkControlCenter
          works={works} selected={explore.works} active={explore.active} mode={explore.mode} locale={locale} error={selectionError}
          onMode={changeMode} onToggle={chooseWork}
          onActive={(active) => commit({ ...explore, active, selectedEntity: null, until: null, chapter: null }, true)}
        />}
        <div className="locale" role="group" aria-label="language">
          <button className={locale === "zh-CN" ? "active" : ""} aria-pressed={locale === "zh-CN"} onClick={() => commit({ ...explore, locale: "zh-CN" }, true)}>中文</button>
          <button className={locale === "en" ? "active" : ""} aria-pressed={locale === "en"} onClick={() => commit({ ...explore, locale: "en" }, true)}>EN</button>
        </div>
      </div>
    </header>

    {error ? <section className="error" role="alert"><strong>{t("error", locale)}</strong><p>{error}</p></section>
      : loading || !activeAtlas || !derived ? <Skeleton locale={locale} />
        : <>
          {!BIBLE_ONLY && atlases.length > 1 && <section className="compare-bar">
            <span>{t("primary", locale)}:</span>
            {atlases.map((atlas) => <button
              key={atlas.work.slug}
              style={{ borderColor: atlas.work.themeColor }}
              className={atlas.work.slug === activeAtlas.work.slug ? "active" : ""}
              onClick={() => commit({ ...explore, active: atlas.work.slug, selectedEntity: null, until: null, chapter: null }, true)}
            ><i style={{ background: atlas.work.themeColor }} />{atlas.work.title}</button>)}
            <p>{t("multiHint", locale)}</p>
          </section>}

          <section className="hero" style={{ borderColor: activeAtlas.work.themeColor }}>
            <div>
              <span className={`badge ${activeAtlas.work.category}`}>{label(activeAtlas.work.category, locale)}</span>
              <h2>{activeAtlas.work.title}</h2>
              <p>{activeAtlas.work.summary}</p>
              <small>
                {activeAtlas.work.originRegion}
                {" · "}{formatYear(defaultRange.start, locale)} – {formatYear(defaultRange.end, locale)}
                {" · "}{activeAtlas.characters.length} {t("characters", locale)}
                {" · "}{activeAtlas.events.length} {t("events", locale)}
                {" · "}{activeAtlas.locations.length} {t("locations", locale)}
                {" · "}{activeAtlas.chapters.length} {t("eraBands", locale)}
              </small>
            </div>
            <button className="copy" onClick={() => void navigator.clipboard.writeText(location.href).then(() => { setCopied(true); setTimeout(() => setCopied(false), 1500); })}>
              {copied ? t("copied", locale) : t("copy", locale)}
            </button>
          </section>

          {/* Scripture epigraph: the selected era's verse, or the welcome verse
              (Psalm 119:18) while no era is chosen. */}
          <EpigraphBlock
            key={explore.chapter ?? "welcome"}
            epigraph={(explore.chapter !== null ? ERA_EPIGRAPHS[explore.chapter] : undefined) ?? WELCOME_EPIGRAPH}
            locale={locale}
          />

          {/* Era rail: the top tier of the hierarchy, and the fastest way to cut a
              136-event work down to one readable chapter. */}
          <nav className="era-rail" aria-label={t("filterByEra", locale)}>
            <button type="button" className={explore.chapter === null ? "active" : ""} onClick={() => setChapter(null)}>{t("allEras", locale)}</button>
            {activeAtlas.chapters.map((chapter) => <button
              key={chapter.slug}
              type="button"
              className={explore.chapter === chapter.slug ? "active" : ""}
              style={{ "--era": chapter.accentColor } as React.CSSProperties}
              aria-pressed={explore.chapter === chapter.slug}
              ref={(element) => {
                // Keep the active era chip in view when selection comes from
                // the timeline, the graph or a deep link rather than the rail.
                if (element && explore.chapter === chapter.slug) element.scrollIntoView({ block: "nearest", inline: "nearest", behavior: window.matchMedia("(prefers-reduced-motion: reduce)").matches ? "auto" : "smooth" });
              }}
              onClick={() => setChapter(explore.chapter === chapter.slug ? null : chapter.slug)}
            >
              <i />{chapter.title}<small>{chapter.eventCount}</small>
            </button>)}
          </nav>

          {filtersActive && <div className="filter-bar" role="status">
            <strong>{t("activeFilters", locale)}:</strong>
            {activeChapter && <span className="filter-chip">{activeChapter.title}</span>}
            {explore.until !== null && <span className="filter-chip">{t("narrativeUpTo", locale)} #{explore.until}</span>}
            {(explore.rangeStart !== null || explore.rangeEnd !== null) && <span className="filter-chip">{formatYear(range.start, locale)} – {formatYear(range.end, locale)}</span>}
            {explore.query && <span className="filter-chip">“{explore.query}”</span>}
            <span className="filter-count">{derived.events.length} / {activeAtlas.events.length} {t("events", locale)} · {derived.characters.length} / {activeAtlas.characters.length} {t("characters", locale)}</span>
            <button type="button" onClick={clearFilters}>{t("clearFilters", locale)}</button>
          </div>}

          <section className="workspace">
            <div className="map-shell">
              <AtlasMap
                atlases={atlases}
                visibleLocationSlugs={derived.locationSlugs}
                visibleEventSlugs={derived.eventSlugs}
                selectedEntity={explore.selectedEntity}
                selectionSource={explore.selectionSource}
                mapLayers={explore.mapLayers}
                zoomLevel={explore.zoomLevel}
                locale={locale}
                onSelect={selectEntity}
                onToggleLayer={toggleLayer}
              />
            </div>

            <aside className="browser">
              <nav aria-label="panels">
                {TABS.map((key) => <button key={key} className={explore.tab === key ? "active" : ""} aria-pressed={explore.tab === key} onClick={() => setTab(key)}>
                  {t(key, locale)}
                  <b>{key === "characters" ? derived.characters.length : key === "events" ? derived.events.length : key === "locations" ? derived.locations.length : key === "routes" ? derived.routes.length : derived.relations.length}</b>
                </button>)}
              </nav>

              <div className="list-filter">
                <input
                  type="search"
                  value={explore.query}
                  aria-label={t("searchEverything", locale)}
                  placeholder={t("searchEverything", locale)}
                  onChange={(event) => commit({ ...explore, query: event.target.value })}
                />
              </div>

              {explore.tab === "relations"
                ? <RelationGraph
                  atlas={activeAtlas}
                  locale={locale}
                  characters={derived.characters}
                  relations={derived.relations}
                  zoomLevel={explore.zoomLevel}
                  selected={explore.selectedEntity}
                  onZoomLevel={setZoomLevel}
                  onSelect={(entity) => selectEntity(entity, "graph")}
                  onChapter={setChapter}
                />
                : <EntityList
                  key={explore.tab}
                  atlas={activeAtlas}
                  tab={explore.tab}
                  locale={locale}
                  characters={derived.characters}
                  events={derived.events}
                  locations={derived.locations}
                  routes={derived.routes}
                  selected={explore.selectedEntity}
                  onSelect={(entity) => selectEntity(entity, "list")}
                />}
            </aside>
          </section>

          <TimelineRibbon
            atlases={atlases}
            activeAtlas={activeAtlas}
            locale={locale}
            mode={explore.timelineMode}
            range={range}
            defaultRange={defaultRange}
            until={explore.until}
            chapter={explore.chapter}
            events={derived.events}
            selected={explore.selectedEntity}
            onMode={setTimelineMode}
            onRange={(rangeStart, rangeEnd) => commit({ ...explore, rangeStart, rangeEnd, timelineMode: "history" })}
            onNarrative={(until) => commit({ ...explore, until, timelineMode: "narrative" })}
            onChapter={setChapter}
            onSelect={(entity) => selectEntity(entity, "timeline")}
          />

          {activeAtlas.sources.length > 0 && <footer>
            <h2>{t("sources", locale)}</h2>
            <p>{t("dataNote", locale)}</p>
            <EpigraphBlock epigraph={FOOTER_EPIGRAPH} locale={locale} />
            <p><small>{t("scriptureNote", locale)}</small></p>
            <div className="source-grid">
              {activeAtlas.sources.map((source) => <details key={source.id}>
                <summary>{source.url ? <a href={source.url} target="_blank" rel="noreferrer">{source.title}</a> : source.title} · {label(source.sourceType, locale)} · {label(source.evidenceGrade, locale)}</summary>
                <p>{source.citation}</p>
              </details>)}
            </div>
          </footer>}

          {selectedAtlas && explore.selectedEntity && <EntityDrawer
            atlas={selectedAtlas}
            entity={explore.selectedEntity}
            locale={locale}
            onClose={() => commit({ ...explore, selectedEntity: null })}
            onSelect={selectEntity}
            onTab={setTab}
            onChapter={setChapter}
          />}
        </>}
  </main>;
}

function Skeleton({ locale }: { locale: ReturnType<typeof parseAtlasState>["locale"] }) {
  const [verseIndex, setVerseIndex] = useState(0);
  useEffect(() => {
    // Waiting verses rotate every 4s; under prefers-reduced-motion the first
    // verse simply stays.
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
    const timer = window.setInterval(() => setVerseIndex((index) => (index + 1) % LOADING_EPIGRAPHS.length), 4000);
    return () => window.clearInterval(timer);
  }, []);
  return <div className="skeleton" role="status" aria-live="polite">
    <span className="sr-only">{t("loading", locale)}…</span>
    <EpigraphBlock epigraph={LOADING_EPIGRAPHS[verseIndex] ?? LOADING_EPIGRAPHS[0]!} locale={locale} className="epigraph skeleton-epigraph" />
    <div className="skeleton-hero" />
    <div className="skeleton-workspace">
      <div className="skeleton-map" />
      <div className="skeleton-list">{Array.from({ length: 5 }, (_, index) => <div key={index} className="skeleton-card" />)}</div>
    </div>
    <div className="skeleton-timeline" />
  </div>;
}
