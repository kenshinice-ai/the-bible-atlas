import { useMemo, useRef, useState } from "react";
import { colorForEvent } from "../hierarchy";
import { formatEventTime, formatYear, referenceLabel, t } from "../i18n";
import type { SelectedEntity, TimelineMode } from "../state";
import type { Atlas, AtlasEvent, Locale } from "../types";

interface Props {
  atlases: Atlas[];
  activeAtlas: Atlas;
  locale: Locale;
  mode: TimelineMode;
  range: { start: number; end: number };
  defaultRange: { start: number; end: number };
  until: number | null;
  chapter: string | null;
  events: readonly AtlasEvent[];
  selected: SelectedEntity | null;
  onMode: (mode: TimelineMode) => void;
  onRange: (start: number | null, end: number | null) => void;
  onNarrative: (sequence: number | null) => void;
  onChapter: (chapter: string | null) => void;
  onSelect: (entity: SelectedEntity) => void;
}

const VIEW_WIDTH = 1000;
const PLOT_LEFT = 46;
const PLOT_RIGHT = 968;
const AXIS_Y = 118;
const LANE_HEIGHT = 19;
const LANES = 6;
const VIEW_HEIGHT = AXIS_Y + 10 + LANES * LANE_HEIGHT + 8;

function bucketSize(span: number): number {
  if (span > 2400) return 200;
  if (span > 1200) return 100;
  if (span > 400) return 50;
  if (span > 120) return 10;
  if (span > 40) return 5;
  return 1;
}
function bucketStart(year: number, size: number): number { return year > 0 ? Math.floor((year - 1) / size) * size + 1 : Math.floor(year / size) * size; }
function activate(event: React.KeyboardEvent<SVGGElement>, action: () => void) { if (event.key === "Enter" || event.key === " ") { event.preventDefault(); action(); } }

/** Rough pixel width of a label in viewBox units, used for collision packing. */
function labelWidth(text: string): number {
  let width = 0;
  for (const character of text) width += character.charCodeAt(0) > 0x2e80 ? 11.5 : 7;
  return width + 12;
}

/**
 * Historical and narrative timeline.
 *
 * Three things changed in v4: the window comes from the work's own chronology
 * instead of a hardcoded 3000 BCE – 2026 CE span, eras are drawn as bands so a
 * long work reads as chapters rather than a scatter of dots, and labels are
 * packed into lanes with collision checks instead of overprinting each other.
 */
export function TimelineRibbon(props: Props) {
  const { atlases, activeAtlas, locale, mode, range, defaultRange, until, chapter, events, selected } = props;
  const svgRef = useRef<SVGSVGElement | null>(null);
  const [brush, setBrush] = useState<{ from: number; to: number } | null>(null);
  const [showAllUndated, setShowAllUndated] = useState(false);

  const dated = useMemo(() => events.filter((event) => event.historicalStartYear !== null), [events]);
  const undated = useMemo(() => events.filter((event) => event.historicalStartYear === null), [events]);
  const maxSequence = Math.max(1, ...activeAtlas.events.map((event) => event.sequence));

  const min = mode === "history" ? range.start : 1;
  const max = mode === "history" ? range.end : maxSequence;
  const span = Math.max(max - min, 1);
  const toX = (value: number) => PLOT_LEFT + ((value - min) / span) * (PLOT_RIGHT - PLOT_LEFT);
  const fromX = (x: number) => min + ((x - PLOT_LEFT) / (PLOT_RIGHT - PLOT_LEFT)) * span;

  const plotted = mode === "history" ? dated : events;

  const buckets = useMemo(() => {
    const size = mode === "history" ? bucketSize(span) : Math.max(1, Math.round(span / 40));
    const map = new Map<number, AtlasEvent[]>();
    for (const event of plotted) {
      const value = mode === "history" ? event.historicalStartYear! : event.sequence;
      if (value < min || value > max) continue;
      const start = mode === "history" ? bucketStart(value, size) : Math.floor((value - 1) / size) * size + 1;
      map.set(start, [...(map.get(start) ?? []), event]);
    }
    return [...map].sort((a, b) => a[0] - b[0]).map(([start, items]) => ({ start, end: start + size - 1, events: items }));
  }, [max, min, mode, plotted, span]);
  const maxDensity = Math.max(1, ...buckets.map((bucket) => bucket.events.length));

  /** Pack event labels into lanes; anything that cannot fit keeps its dot only. */
  const placed = useMemo(() => {
    const lanes: number[][] = Array.from({ length: LANES }, () => []);
    const ordered = [...plotted].sort((a, b) => {
      const av = mode === "history" ? a.historicalStartYear! : a.sequence;
      const bv = mode === "history" ? b.historicalStartYear! : b.sequence;
      return av - bv;
    });
    return ordered.map((event) => {
      const value = mode === "history" ? event.historicalStartYear! : event.sequence;
      const x = toX(value);
      if (x < PLOT_LEFT - 4 || x > PLOT_RIGHT + 4) return { event, x, lane: -1 };
      const width = labelWidth(event.title);
      for (let lane = 0; lane < LANES; lane += 1) {
        const occupied = lanes[lane]!;
        const last = occupied[occupied.length - 1] ?? -Infinity;
        if (x - width / 2 > last + 6) { occupied.push(x + width / 2); return { event, x, lane }; }
      }
      return { event, x, lane: -1 };
    });
    // toX depends on min/max/span which are already dependencies of this memo.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [max, min, mode, plotted, span]);

  const labelledCount = placed.filter((item) => item.lane >= 0).length;

  const eraBands = useMemo(() => {
    if (mode !== "history") {
      return activeAtlas.chapters
        .filter((item) => item.firstSequence !== null && item.lastSequence !== null)
        .map((item) => ({ chapter: item, x1: toX(item.firstSequence!), x2: toX(item.lastSequence!) }));
    }
    return activeAtlas.chapters
      .filter((item) => item.eraStartYear !== null && item.eraEndYear !== null)
      .map((item) => ({ chapter: item, x1: toX(Math.max(item.eraStartYear!, min)), x2: toX(Math.min(item.eraEndYear!, max)) }))
      .filter((band) => band.x2 > PLOT_LEFT && band.x1 < PLOT_RIGHT);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeAtlas.chapters, max, min, mode, span]);

  // Pick the smallest "nice" step that keeps the axis under ~14 labels, so the
  // tick count adapts to any span instead of being cut off at a fixed dozen.
  const ticks = useMemo(() => {
    const steps = [1, 2, 5, 10, 20, 25, 50, 100, 200, 250, 500, 1000, 2000];
    const size = steps.find((step) => span / step <= 14) ?? Math.ceil(span / 14);
    const values: number[] = [];
    for (let value = Math.ceil(min / size) * size; value <= max; value += size) { if (value !== 0) values.push(value); }
    return values;
  }, [max, min, span]);

  function pointerX(event: React.PointerEvent<SVGRectElement>): number {
    const svg = svgRef.current;
    if (!svg) return PLOT_LEFT;
    const rect = svg.getBoundingClientRect();
    return PLOT_LEFT + Math.min(PLOT_RIGHT - PLOT_LEFT, Math.max(0, ((event.clientX - rect.left) / rect.width) * VIEW_WIDTH - PLOT_LEFT));
  }

  function commitBrush(current: { from: number; to: number } | null) {
    setBrush(null);
    if (!current || Math.abs(current.to - current.from) < 8) return;
    const a = Math.round(fromX(Math.min(current.from, current.to)));
    const b = Math.round(fromX(Math.max(current.from, current.to)));
    if (mode === "history") props.onRange(a === 0 ? -1 : a, b === 0 ? 1 : b);
    else props.onNarrative(Math.max(1, Math.min(maxSequence, b)));
  }

  const isDefaultRange = range.start === defaultRange.start && range.end === defaultRange.end;

  return <section className="timeline" aria-label={t("timeline", locale)}>
    <header className="timeline-head">
      <div>
        <p className="eyebrow">{mode === "history" ? `${formatYear(range.start, locale)} — ${formatYear(range.end, locale)}` : `1 — ${maxSequence}`}</p>
        <h2>{t("timeline", locale)}</h2>
      </div>
      <div className="timeline-modes" role="group">
        <button type="button" className={mode === "history" ? "active" : ""} aria-pressed={mode === "history"} onClick={() => props.onMode("history")}>{t("historyMode", locale)}</button>
        <button type="button" className={mode === "narrative" ? "active" : ""} aria-pressed={mode === "narrative"} onClick={() => props.onMode("narrative")}>{t("narrativeMode", locale)}</button>
      </div>
      <div className="timeline-actions">
        {mode === "history" && <button type="button" disabled={isDefaultRange} onClick={() => props.onRange(null, null)}>{t("fullRange", locale)}</button>}
        {mode === "narrative" && <button type="button" disabled={until === null} onClick={() => props.onNarrative(null)}>{t("showAllNarrative", locale)}</button>}
        <output>{mode === "history"
          ? `${t("showing", locale)} ${dated.length} ${t("datedEvents", locale)} · ${undated.length} ${t("undated", locale)} / ${activeAtlas.events.length} ${t("events", locale)}`
          : `${t("showing", locale)} ${events.length} / ${activeAtlas.events.length} ${t("events", locale)}`}</output>
      </div>
    </header>

    <p className="timeline-hint">{t("brushHint", locale)}</p>

    <div className="timeline-scroll" tabIndex={0}>
      <svg ref={svgRef} viewBox={`0 0 ${VIEW_WIDTH} ${VIEW_HEIGHT}`} role="img" aria-label={`${events.length} ${t("events", locale)}`}>
        {/* Era bands turn a long work into readable chapters instead of one flat scatter. */}
        {eraBands.map(({ chapter: band, x1, x2 }) => {
          const selectedBand = chapter === band.slug;
          return <g key={band.slug} className={`era-band${selectedBand ? " selected" : ""}`} role="button" tabIndex={0}
            onClick={() => props.onChapter(selectedBand ? null : band.slug)}
            onKeyDown={(event) => activate(event, () => props.onChapter(selectedBand ? null : band.slug))}>
            <rect x={x1} y={10} width={Math.max(2, x2 - x1)} height={16} rx={4} fill={band.accentColor} opacity={selectedBand ? 0.95 : 0.45} />
            {x2 - x1 > 46 && <text x={(x1 + x2) / 2} y={22} textAnchor="middle" className="era-label">{band.title}</text>}
            <title>{band.title} · {referenceLabel(band.referenceLabel, locale)}</title>
          </g>;
        })}

        {buckets.map((bucket) => {
          const left = toX(bucket.start);
          const right = toX(Math.min(bucket.end, max));
          const height = 52 * (bucket.events.length / maxDensity);
          const choose = () => { if (mode === "history") props.onRange(bucket.start === 0 ? -1 : bucket.start, bucket.end === 0 ? 1 : bucket.end); };
          return <g key={bucket.start} className="density" role="button" tabIndex={0} onClick={choose} onKeyDown={(event) => activate(event, choose)}>
            <rect x={left} y={AXIS_Y - 8 - height} width={Math.max(3, right - left - 1)} height={height} rx={2} fill={colorForEvent(activeAtlas, bucket.events[0]!)} />
            <title>{bucket.events.length} · {mode === "history" ? formatYear(bucket.start, locale) : `#${bucket.start}`}</title>
          </g>;
        })}

        <line x1={PLOT_LEFT} y1={AXIS_Y} x2={PLOT_RIGHT} y2={AXIS_Y} className="axis" />
        {ticks.map((value) => <g key={value} className="tick">
          <line x1={toX(value)} y1={AXIS_Y - 4} x2={toX(value)} y2={AXIS_Y + 4} />
          <text x={toX(value)} y={AXIS_Y - 8} textAnchor="middle">{mode === "history" ? formatYear(value, locale) : `#${value}`}</text>
        </g>)}

        {placed.map(({ event, x, lane }) => {
          const uncertain = event.timeType !== "exact";
          const isSelected = selected?.type === "event" && selected.id === event.slug;
          const muted = until !== null && event.sequence > until;
          const y = AXIS_Y + 8 + Math.max(0, lane) * LANE_HEIGHT;
          const choose = () => props.onSelect({ type: "event", workSlug: activeAtlas.work.slug, id: event.slug });
          return <g key={`${activeAtlas.work.slug}:${event.slug}`}
            className={`timeline-node ${uncertain ? "uncertain" : "exact"}${muted ? " muted" : ""}${isSelected ? " selected" : ""}`}
            role="button" tabIndex={0} onClick={choose} onKeyDown={(keyEvent) => activate(keyEvent, choose)}>
            <line x1={x} y1={AXIS_Y} x2={x} y2={y - 5} className="stem" />
            <circle cx={x} cy={y} r={isSelected ? 6 : 4.5} style={{ fill: uncertain ? "#171a26" : colorForEvent(activeAtlas, event), stroke: colorForEvent(activeAtlas, event) }} />
            {lane >= 0 && <text x={x + 8} y={y + 4} className="node-label">{event.title}</text>}
            <title>{event.title} · {formatEventTime(event, locale)}</title>
          </g>;
        })}

        {brush && <rect className="brush" x={Math.min(brush.from, brush.to)} y={6} width={Math.abs(brush.to - brush.from)} height={AXIS_Y - 6} />}
        <rect
          className="brush-surface"
          x={PLOT_LEFT} y={6} width={PLOT_RIGHT - PLOT_LEFT} height={AXIS_Y - 6}
          onPointerDown={(event) => { event.currentTarget.setPointerCapture(event.pointerId); const x = pointerX(event); setBrush({ from: x, to: x }); }}
          onPointerMove={(event) => { if (brush) setBrush({ from: brush.from, to: pointerX(event) }); }}
          onPointerUp={(event) => { const next = brush ? { from: brush.from, to: pointerX(event) } : null; commitBrush(next); }}
          onPointerCancel={() => setBrush(null)}
        />
      </svg>
    </div>

    {atlases.length > 1 && <p className="timeline-note">{t("multiHint", locale)}</p>}
    {labelledCount < plotted.length && <p className="timeline-note">{t("showing", locale)} {labelledCount} / {plotted.length} {t("events", locale)} — {t("brushHint", locale)}</p>}
    {mode === "history" && undated.length > 0 && <div className="undated">
      <strong>{t("undated", locale)} · {undated.length}</strong>
      <p>{t("undatedNote", locale)}</p>
      <div className="undated-chips">
        {/* A single era can carry dozens of undated events (primeval alone has ~50),
            so the list stays folded until asked; the ribbon must not scroll the page. */}
        {(showAllUndated ? undated : undated.slice(0, 12)).map((event) => <button key={event.slug} type="button" onClick={() => props.onSelect({ type: "event", workSlug: activeAtlas.work.slug, id: event.slug })}>{event.title}</button>)}
        {undated.length > 12 && <button type="button" className="undated-toggle" aria-expanded={showAllUndated} onClick={() => setShowAllUndated(!showAllUndated)}>
          {showAllUndated ? t("collapse", locale) : `${t("showAll", locale)} (${undated.length})`}
        </button>}
      </div>
    </div>}
  </section>;
}
