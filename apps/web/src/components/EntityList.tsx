import { useVirtualizer } from "@tanstack/react-virtual";
import { useRef } from "react";
import { colorForCharacter, colorForEvent } from "../hierarchy";
import { formatEventTime, label, t } from "../i18n";
import type { SelectedEntity, Tab } from "../state";
import type { Atlas, AtlasCharacter, AtlasEvent, AtlasLocation, AtlasRoute, Locale } from "../types";

type Row =
  | { kind: "characters"; item: AtlasCharacter }
  | { kind: "events"; item: AtlasEvent }
  | { kind: "locations"; item: AtlasLocation }
  | { kind: "routes"; item: AtlasRoute };

interface Props {
  atlas: Atlas;
  tab: Exclude<Tab, "relations">;
  locale: Locale;
  characters: readonly AtlasCharacter[];
  events: readonly AtlasEvent[];
  locations: readonly AtlasLocation[];
  routes: readonly AtlasRoute[];
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
export function EntityList({ atlas, tab, locale, characters, events, locations, routes, selected, onSelect }: Props) {
  const scrollRef = useRef<HTMLDivElement | null>(null);

  const rows: Row[] =
    tab === "characters" ? characters.map((item) => ({ kind: "characters", item }))
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
