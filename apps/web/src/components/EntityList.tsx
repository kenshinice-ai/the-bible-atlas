import { useVirtualizer } from "@tanstack/react-virtual";
import { useRef } from "react";
import { colorForCharacter, colorForEvent } from "../hierarchy";
import { formatEventTime, label, t } from "../i18n";
import type { SelectedEntity, Tab } from "../state";
import type { Atlas, AtlasArtist, AtlasArtwork, AtlasCharacter, AtlasComposition, AtlasEvent, AtlasInstrument, AtlasLocation, AtlasMovement, AtlasRoute, AtlasScoreFragment, Locale } from "../types";

type Row =
  | { kind: "characters"; item: AtlasCharacter }
  | { kind: "events"; item: AtlasEvent }
  | { kind: "locations"; item: AtlasLocation }
  | { kind: "routes"; item: AtlasRoute }
  | { kind: "artists"; item: AtlasArtist }
  | { kind: "artworks"; item: AtlasArtwork }
  | { kind: "movements"; item: AtlasMovement }
  | { kind: "compositions"; item: AtlasComposition }
  | { kind: "instruments"; item: AtlasInstrument }
  | { kind: "scoreFragments"; item: AtlasScoreFragment };

interface Props {
  atlas: Atlas;
  tab: Exclude<Tab, "relations">;
  locale: Locale;
  characters: readonly AtlasCharacter[];
  events: readonly AtlasEvent[];
  locations: readonly AtlasLocation[];
  routes: readonly AtlasRoute[];
  artists: readonly AtlasArtist[];
  artworks: readonly AtlasArtwork[];
  movements: readonly AtlasMovement[];
  compositions: readonly AtlasComposition[];
  instruments: readonly AtlasInstrument[];
  scoreFragments: readonly AtlasScoreFragment[];
  selected: SelectedEntity | null;
  onSelect: (entity: SelectedEntity) => void;
}

function activate(event: React.KeyboardEvent<HTMLElement>, action: () => void) {
  if (event.key === "Enter" || event.key === " ") { event.preventDefault(); action(); }
}

/**
 * Windowed entity list.
 *
 * The lists have to stay usable when a work carries thousands of entities, so
 * only the rows in view are mounted. Row heights are measured rather than
 * assumed, because event summaries wrap to different depths.
 */
export function EntityList({ atlas, tab, locale, characters, events, locations, routes, artists, artworks, movements, compositions, instruments, scoreFragments, selected, onSelect }: Props) {
  const scrollRef = useRef<HTMLDivElement | null>(null);

  const rows: Row[] =
    tab === "characters" ? characters.map((item) => ({ kind: "characters", item }))
      : tab === "artists" ? artists.map((item) => ({ kind: "artists", item }))
        : tab === "artworks" ? artworks.map((item) => ({ kind: "artworks", item }))
          : tab === "movements" ? movements.map((item) => ({ kind: "movements", item }))
            : tab === "compositions" ? compositions.map((item) => ({ kind: "compositions", item }))
              : tab === "instruments" ? instruments.map((item) => ({ kind: "instruments", item }))
              : tab === "scoreFragments" ? scoreFragments.map((item) => ({ kind: "scoreFragments", item }))
            : tab === "events" ? events.map((item) => ({ kind: "events", item }))
        : tab === "locations" ? locations.map((item) => ({ kind: "locations", item }))
          : routes.map((item) => ({ kind: "routes", item }));

  const virtualizer = useVirtualizer({
    count: rows.length,
    getScrollElement: () => scrollRef.current,
    estimateSize: () => 116,
    overscan: 8,
    getItemKey: (index) => {
      const row = rows[index]!;
      return `${row.kind}:${"slug" in row.item ? row.item.slug : String(index)}`;
    },
  });

  if (rows.length === 0) return <div className="cards"><p className="empty">{t("emptyList", locale)}</p></div>;

  return <div className="cards" ref={scrollRef}>
    <div className="virtual-canvas" style={{ height: virtualizer.getTotalSize() }}>
      {virtualizer.getVirtualItems().map((virtualRow) => {
        const row = rows[virtualRow.index]!;
        return <div
          key={virtualRow.key}
          ref={virtualizer.measureElement}
          data-index={virtualRow.index}
          className="virtual-row"
          style={{ transform: `translateY(${virtualRow.start}px)` }}
        >
          {renderRow(row, atlas, locale, selected, onSelect)}
        </div>;
      })}
    </div>
  </div>;
}

function renderRow(row: Row, atlas: Atlas, locale: Locale, selected: SelectedEntity | null, onSelect: Props["onSelect"]) {
  const workSlug = atlas.work.slug;

  if (row.kind === "characters") {
    const person = row.item;
    const era = atlas.chapters.find((item) => item.slug === person.chapterSlug);
    const isSelected = selected?.type === "character" && selected.id === person.slug;
    const choose = () => onSelect({ type: "character", workSlug, id: person.slug });
    return <article role="button" tabIndex={0} className={isSelected ? "card selected" : "card"} onClick={choose} onKeyDown={(event) => activate(event, choose)}>
      <span className={`mini-person ${person.gender}`} style={{ borderColor: colorForCharacter(atlas, person) }} aria-hidden="true" />
      <h3>{person.name}<i className="importance" aria-hidden="true">{"●".repeat(person.importance)}</i></h3>
      <p>{person.summary}</p>
      <small>{label(person.iconVariant, locale)} · {label(person.roleType, locale)}{era ? ` · ${era.title}` : ""} · {person.eventSlugs.length} {t("events", locale)}</small>
    </article>;
  }

  if (row.kind === "artists") {
    const artist = row.item;
    const era = atlas.chapters.find((item) => item.slug === artist.chapterSlug);
    const isSelected = selected?.type === "artist" && selected.id === artist.slug;
    const choose = () => onSelect({ type: "artist", workSlug, id: artist.slug });
    return <article role="button" tabIndex={0} className={isSelected ? "card selected" : "card"} onClick={choose} onKeyDown={(event) => activate(event, choose)}>
      <span className="mini-person" aria-hidden="true" /><h3>{artist.name}</h3><p>{artist.summary}</p>
      <small>{label(artist.artistKind, locale)}{era ? ` · ${era.title}` : ""} · {artist.artworkSlugs.length} {t("artworks", locale)}</small>
    </article>;
  }

  if (row.kind === "artworks") {
    const artwork = row.item;
    const era = atlas.chapters.find((item) => item.slug === artwork.chapterSlug);
    const isSelected = selected?.type === "artwork" && selected.id === artwork.slug;
    const choose = () => onSelect({ type: "artwork", workSlug, id: artwork.slug });
    return <article role="button" tabIndex={0} className={isSelected ? "card selected" : "card"} onClick={choose} onKeyDown={(event) => activate(event, choose)}>
      <span className="sequence" aria-hidden="true" /><h3>{artwork.title}</h3><p>{artwork.summary}</p>
      <small>{artwork.creationStartYear ?? "?"}{artwork.creationEndYear && artwork.creationEndYear !== artwork.creationStartYear ? `–${artwork.creationEndYear}` : ""} · {artwork.medium}{era ? ` · ${era.title}` : ""}</small>
    </article>;
  }

  if (row.kind === "movements") {
    const movement = row.item;
    const isSelected = selected?.type === "movement" && selected.id === movement.slug;
    const choose = () => onSelect({ type: "movement", workSlug, id: movement.slug });
    return <article role="button" tabIndex={0} className={isSelected ? "card selected" : "card"} onClick={choose} onKeyDown={(event) => activate(event, choose)}>
      <h3>{movement.name}</h3><p>{movement.summary}</p><small>{movement.startYear ?? "?"}–{movement.endYear ?? "?"} · {movement.artistSlugs.length} {t("artists", locale)}</small>
    </article>;
  }

  if (row.kind === "compositions") {
    const composition = row.item;
    const era = atlas.chapters.find((item) => item.slug === composition.chapterSlug);
    const composer = atlas.characters.find((item) => item.slug === composition.primaryComposerSlug);
    const isSelected = selected?.type === "composition" && selected.id === composition.slug;
    const choose = () => onSelect({ type: "composition", workSlug, id: composition.slug });
    return <article role="button" tabIndex={0} className={isSelected ? "card selected" : "card"} onClick={choose} onKeyDown={(event) => activate(event, choose)}>
      <span className="sequence" aria-hidden="true" />
      <h3>{composition.title}</h3><p>{composition.summary}</p>
      <small>{composition.compositionStartYear ?? "?"}{composer ? ` · ${composer.name}` : ""}{era ? ` · ${era.title}` : ""} · {composition.scoreFragmentSlugs.length} {locale === "zh-CN" ? "乐谱片段" : "score excerpts"}</small>
    </article>;
  }

  if (row.kind === "instruments") {
    const instrument = row.item;
    const isSelected = selected?.type === "instrument" && selected.id === instrument.slug;
    const choose = () => onSelect({ type: "instrument", workSlug, id: instrument.slug });
    return <article role="button" tabIndex={0} className={isSelected ? "card selected" : "card"} onClick={choose} onKeyDown={(event) => activate(event, choose)}>
      <span className="place-type type-building" aria-hidden="true" />
      <h3>{instrument.name}</h3><p>{instrument.summary}</p>
      <small>{label(instrument.family, locale)}{instrument.hornbostelSachsCode ? ` · H–S ${instrument.hornbostelSachsCode}` : ""} · {instrument.compositionSlugs.length} {locale === "zh-CN" ? "部相关曲目" : "related works"}</small>
    </article>;
  }

  if (row.kind === "scoreFragments") {
    const fragment = row.item;
    const isSelected = selected?.type === "score_fragment" && selected.id === fragment.slug;
    const choose = () => onSelect({ type: "score_fragment", workSlug, id: fragment.slug });
    return <article role="button" tabIndex={0} className={isSelected ? "card selected" : "card"} onClick={choose} onKeyDown={(event) => activate(event, choose)}>
      <span className="sequence" aria-hidden="true" />
      <h3>{fragment.title}</h3><p>{fragment.analysisNote || fragment.summary}</p>
      <small>{label(fragment.notationKind, locale)} · {fragment.durationSeconds.toFixed(1)}s · {fragment.rightsStatus === "verified" ? (locale === "zh-CN" ? "可播放" : "playable") : label(fragment.rightsStatus, locale)}</small>
    </article>;
  }

  if (row.kind === "events") {
    const event = row.item;
    const era = atlas.chapters.find((item) => item.slug === event.chapterSlug);
    const isSelected = selected?.type === "event" && selected.id === event.slug;
    const choose = () => onSelect({ type: "event", workSlug, id: event.slug });
    return <article role="button" tabIndex={0} className={isSelected ? "card selected" : "card"} onClick={choose} onKeyDown={(keyEvent) => activate(keyEvent, choose)}>
      <span className={`sequence ${event.timeType}`} style={{ borderColor: colorForEvent(atlas, event) }}>{event.sequence}</span>
      <h3>{event.title}</h3>
      <p>{event.summary}</p>
      <small>
        {formatEventTime(event, locale)}
        {era ? ` · ${era.title}` : ""}
        {" · "}<span className={`confidence ${event.confidence}`}>{label(event.confidence, locale)}</span>
        {" · "}{event.sourceTitles.length > 0 ? event.sourceTitles[0] : label(event.reality, locale)}
      </small>
    </article>;
  }

  if (row.kind === "locations") {
    const place = row.item;
    const isSelected = selected?.type === "location" && selected.id === place.slug;
    const choose = () => onSelect({ type: "location", workSlug, id: place.slug });
    return <article role="button" tabIndex={0} className={isSelected ? "card selected" : "card"} onClick={choose} onKeyDown={(event) => activate(event, choose)}>
      <span className={`place-type type-${place.locationType}${place.isInferred ? " inferred" : ""}`} aria-hidden="true" />
      <h3>{place.name}</h3>
      <p>{place.summary}</p>
      <small>{label(place.locationType, locale)} · {label(place.coordinateAccuracy, locale)} · {place.eventSlugs.length} {t("events", locale)}</small>
    </article>;
  }

  const route = row.item;
  const isSelected = selected?.type === "route" && selected.id === route.slug;
  const choose = () => onSelect({ type: "route", workSlug, id: route.slug });
  return <article role="button" tabIndex={0} className={isSelected ? "card selected" : "card"} onClick={choose} onKeyDown={(event) => activate(event, choose)}>
    <h3>{route.name}</h3>
    <p>{route.summary}</p>
    <small>{label(route.certainty, locale)} · {route.waypoints.length} {t("waypoints", locale)}</small>
  </article>;
}
