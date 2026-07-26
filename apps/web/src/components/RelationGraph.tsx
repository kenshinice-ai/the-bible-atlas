import { forceCenter, forceCollide, forceLink, forceManyBody, forceSimulation, forceX, forceY, type Simulation } from "d3-force";
import { select } from "d3-selection";
import { zoom as d3zoom, zoomIdentity, type D3ZoomEvent, type ZoomBehavior, type ZoomTransform } from "d3-zoom";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { buildGraph, type GraphEdge, type GraphNode } from "../hierarchy";
import { label, t } from "../i18n";
import { ZOOM_LEVELS, type SelectedEntity, type ZoomLevel } from "../state";
import type { Atlas, AtlasCharacter, AtlasRelation, Locale } from "../types";

interface Props {
  atlas: Atlas;
  locale: Locale;
  characters: readonly AtlasCharacter[];
  relations: readonly AtlasRelation[];
  zoomLevel: ZoomLevel;
  selected: SelectedEntity | null;
  onZoomLevel: (level: ZoomLevel) => void;
  onSelect: (entity: SelectedEntity) => void;
  onChapter: (chapter: string | null) => void;
}

const EDGE_COLOR: Record<GraphEdge["sentiment"], string> = { positive: "#5fbf9c", negative: "#e0656f", mixed: "#d9a55f", neutral: "#8B8FA3" };

/**
 * Canvas scale ↔ hierarchy tier.
 *
 * Zooming *is* the level-of-detail control: scrolling out collapses people
 * into groups and then into eras; scrolling in expands them again. v4.1
 * replaces the old fixed per-tier scales with fit-based logic — every tier
 * *enters* fitted and centred regardless of how many nodes it holds, and the
 * wheel switches tier at multiples of that fitted baseline (in past 1.9×,
 * out past 0.5×), so the thresholds adapt to the data instead of assuming
 * a layout extent.
 */
const TIERS: readonly ZoomLevel[] = ["era", "group", "major", "all"];
const DRILL_IN_FACTOR = 1.9;
const DRILL_OUT_FACTOR = 0.5;

type ViewIntent =
  | { kind: "fit" }
  | { kind: "drill"; x: number; y: number }
  | { kind: "wheel-in" }
  | { kind: "keep" };

function easeCubicOut(t: number): number { return 1 - (1 - t) ** 3; }

/** The transform that shows every node with padding, centred in the canvas. */
function fitTransformFor(nodes: readonly GraphNode[], width: number, height: number): ZoomTransform {
  const placed = nodes.filter((node) => node.x !== undefined && node.y !== undefined);
  if (placed.length === 0) return zoomIdentity.translate(width / 2, height / 2);
  let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
  for (const node of placed) {
    const radius = radiusFor(node);
    minX = Math.min(minX, node.x! - radius); maxX = Math.max(maxX, node.x! + radius);
    minY = Math.min(minY, node.y! - radius); maxY = Math.max(maxY, node.y! + radius);
  }
  const padding = 48;
  const k = Math.max(0.15, Math.min(3.5,
    Math.min((width - padding * 2) / Math.max(1, maxX - minX), (height - padding * 2) / Math.max(1, maxY - minY))));
  return zoomIdentity.translate(width / 2 - ((minX + maxX) / 2) * k, height / 2 - ((minY + maxY) / 2) * k).scale(k);
}

function radiusFor(node: GraphNode): number {
  if (node.kind === "era") return 16 + Math.sqrt(node.weight) * 3.4;
  if (node.kind === "group") return 13 + Math.sqrt(node.weight) * 3;
  return 6 + node.importance * 1.8 + Math.sqrt(node.weight) * 1.4;
}

export function RelationGraph({ atlas, locale, characters, relations, zoomLevel, selected, onZoomLevel, onSelect, onChapter }: Props) {
  const wrapRef = useRef<HTMLDivElement | null>(null);
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const simulationRef = useRef<Simulation<GraphNode, GraphEdge> | null>(null);
  const transformRef = useRef<ZoomTransform>(zoomIdentity);
  const zoomRef = useRef<ZoomBehavior<HTMLCanvasElement, unknown> | null>(null);
  /** The fitted scale of the current tier; wheel thresholds are relative to it. */
  const baselineKRef = useRef(1);
  const intentRef = useRef<ViewIntent>({ kind: "fit" });
  const animationRef = useRef<number | null>(null);
  const zoomLevelRef = useRef(zoomLevel);
  /** A gesture after the last programmatic fit means the user owns the camera. */
  const gestureSinceFitRef = useRef(false);
  const [size, setSize] = useState({ width: 640, height: 460 });
  const sizeRef = useRef(size);
  useEffect(() => { sizeRef.current = size; }, [size]);
  const [hover, setHover] = useState<{ node: GraphNode; x: number; y: number } | null>(null);
  const [asTable, setAsTable] = useState(false);
  const dragRef = useRef<{ node: GraphNode; startX: number; startY: number; moved: boolean } | null>(null);
  const pressRef = useRef<{ x: number; y: number } | null>(null);
  const nodeAtRef = useRef<(clientX: number, clientY: number) => GraphNode | null>(() => null);

  const focusSlug = selected?.type === "character" ? selected.id : null;
  const model = useMemo(
    () => buildGraph(atlas, zoomLevel, characters, relations, focusSlug),
    [atlas, zoomLevel, characters, relations, focusSlug],
  );

  // Keep node positions across tier changes so expanding a group does not
  // teleport everything; nodes that already exist resume from where they were.
  const positions = useRef(new Map<string, { x: number; y: number }>());

  useEffect(() => { zoomLevelRef.current = zoomLevel; }, [zoomLevel]);

  /** Route every programmatic viewport move through d3 so its state stays true. */
  const applyTransform = useCallback((next: ZoomTransform) => {
    const canvas = canvasRef.current;
    const behaviour = zoomRef.current;
    transformRef.current = next;
    if (canvas && behaviour) select(canvas).call(behaviour.transform, next);
  }, []);

  /** Ease the viewport to a target transform; user gestures cancel it. */
  const animateTo = useCallback((target: ZoomTransform, duration = 280) => {
    if (animationRef.current !== null) cancelAnimationFrame(animationRef.current);
    const from = transformRef.current;
    if (duration <= 0 || window.matchMedia("(prefers-reduced-motion: reduce)").matches) { applyTransform(target); return; }
    const started = performance.now();
    const step = (now: number) => {
      const progress = easeCubicOut(Math.min(1, (now - started) / duration));
      applyTransform(zoomIdentity
        .translate(from.x + (target.x - from.x) * progress, from.y + (target.y - from.y) * progress)
        .scale(from.k + (target.k - from.k) * progress));
      animationRef.current = progress < 1 ? requestAnimationFrame(step) : null;
    };
    animationRef.current = requestAnimationFrame(step);
  }, [applyTransform]);

  useEffect(() => {
    const element = wrapRef.current;
    if (!element) return;
    const observer = new ResizeObserver((entries) => {
      const box = entries[0]?.contentRect;
      if (box) setSize({ width: Math.max(320, box.width), height: Math.max(360, box.height) });
    });
    observer.observe(element);
    return () => observer.disconnect();
  }, []);

  const draw = useCallback(() => {
    const canvas = canvasRef.current;
    const context = canvas?.getContext("2d");
    if (!canvas || !context) return;
    const ratio = window.devicePixelRatio || 1;
    const { width, height } = size;
    if (canvas.width !== width * ratio || canvas.height !== height * ratio) {
      canvas.width = width * ratio; canvas.height = height * ratio;
      canvas.style.width = `${width}px`; canvas.style.height = `${height}px`;
    }
    const transform = transformRef.current;
    context.save();
    context.setTransform(ratio, 0, 0, ratio, 0, 0);
    context.clearRect(0, 0, width, height);
    context.translate(transform.x, transform.y);
    context.scale(transform.k, transform.k);

    const selectedIds = new Set<string>();
    if (selected?.type === "character") selectedIds.add(`person:${selected.id}`);
    const hoveredId = hover?.node.id ?? null;
    const highlighted = new Set<string>();
    if (hoveredId || selectedIds.size > 0) {
      for (const edge of model.edges) {
        const sourceId = typeof edge.source === "string" ? edge.source : edge.source.id;
        const targetId = typeof edge.target === "string" ? edge.target : edge.target.id;
        if (sourceId === hoveredId || targetId === hoveredId || selectedIds.has(sourceId) || selectedIds.has(targetId)) {
          highlighted.add(sourceId); highlighted.add(targetId);
        }
      }
    }
    const dimming = highlighted.size > 0;

    for (const edge of model.edges) {
      const source = edge.source as GraphNode; const target = edge.target as GraphNode;
      if (source.x === undefined || target.x === undefined) continue;
      const sourceId = source.id; const targetId = target.id;
      const active = highlighted.has(sourceId) && highlighted.has(targetId);
      context.beginPath();
      context.moveTo(source.x!, source.y!);
      context.lineTo(target.x!, target.y!);
      context.strokeStyle = edge.kind === "succession" ? "#3A4560" : EDGE_COLOR[edge.sentiment];
      context.globalAlpha = dimming ? (active ? 0.95 : 0.08) : (edge.kind === "succession" ? 0.35 : 0.5);
      context.lineWidth = (edge.kind === "succession" ? 1.2 : 0.7 + Math.min(4, edge.weight) * 0.5) / Math.max(1, transform.k * 0.55);
      if (edge.sentiment === "negative") context.setLineDash([5 / transform.k, 4 / transform.k]); else context.setLineDash([]);
      context.stroke();
      context.setLineDash([]);
      // Edge labels are the single biggest source of clutter, so they only
      // appear at the finest tier and only for the edges under the cursor.
      if (zoomLevel === "all" && active && edge.label && transform.k > 2) {
        const midX = (source.x! + target.x!) / 2; const midY = (source.y! + target.y!) / 2;
        context.globalAlpha = 1;
        context.font = `${11 / transform.k}px system-ui, sans-serif`;
        context.textAlign = "center"; context.textBaseline = "middle";
        const metrics = context.measureText(edge.label);
        context.fillStyle = "#0B1120dd";
        context.fillRect(midX - metrics.width / 2 - 3 / transform.k, midY - 7 / transform.k, metrics.width + 6 / transform.k, 14 / transform.k);
        context.fillStyle = "#EDE9E0";
        context.fillText(edge.label, midX, midY);
      }
    }

    for (const node of model.nodes) {
      if (node.x === undefined || node.y === undefined) continue;
      const radius = radiusFor(node);
      const active = !dimming || highlighted.has(node.id);
      const isSelected = selectedIds.has(node.id);
      context.globalAlpha = active ? 1 : 0.16;
      context.beginPath();
      context.arc(node.x, node.y, radius, 0, Math.PI * 2);
      context.fillStyle = node.color;
      context.fill();
      context.lineWidth = (isSelected ? 3.2 : 1.4) / Math.max(1, transform.k * 0.6);
      context.strokeStyle = isSelected ? "#F5C15D" : "#0B1120";
      context.stroke();
      // A quiet halo marks the node under the cursor without repainting it.
      if (node.id === hoveredId) {
        context.beginPath();
        context.arc(node.x, node.y, radius + 5 / Math.max(1, transform.k * 0.7), 0, Math.PI * 2);
        context.strokeStyle = "rgba(245, 193, 93, 0.55)";
        context.lineWidth = 2 / Math.max(1, transform.k * 0.7);
        context.stroke();
      }
      // Labels scale inversely with zoom so text stays legible at every tier
      // rather than shrinking to the 2.8px it used to render at.
      const fontSize = Math.max(10, (node.kind === "person" ? 12 : 14) / transform.k);
      const showLabel = node.kind !== "person" || transform.k > 1.4 || node.importance >= 4 || isSelected || node.id === hoveredId;
      if (showLabel && active) {
        context.font = `${node.kind === "person" ? "" : "600 "}${fontSize}px system-ui, "PingFang SC", sans-serif`;
        context.textAlign = "center"; context.textBaseline = "top";
        context.fillStyle = "#0B1120";
        context.lineWidth = 3 / transform.k;
        context.strokeStyle = "#0B1120cc";
        context.strokeText(node.label, node.x, node.y + radius + 3 / transform.k);
        context.fillStyle = "#EDE9E0";
        context.fillText(node.label, node.x, node.y + radius + 3 / transform.k);
      }
      if (node.kind !== "person" && active) {
        context.font = `600 ${Math.max(9, 11 / transform.k)}px system-ui, sans-serif`;
        context.textAlign = "center"; context.textBaseline = "middle";
        context.fillStyle = "#0B1120";
        context.fillText(String(node.weight), node.x, node.y);
      }
    }
    context.restore();
  }, [hover, model, selected, size, zoomLevel]);

  useEffect(() => {
    // Spatial continuity across tiers: a node that has never been on screen
    // starts where its parent tier last stood (people fan out of their group,
    // groups out of their era) instead of teleporting in from the origin.
    const parentPosition = (node: GraphNode): { x: number; y: number } | undefined => {
      if (node.kind === "person") {
        const group = atlas.groups.find((item) => item.characterSlugs.includes(node.slug));
        const fromGroup = group && positions.current.get(`group:${group.slug}`);
        if (fromGroup) return fromGroup;
        const chapter = atlas.characters.find((item) => item.slug === node.slug)?.chapterSlug;
        return chapter ? positions.current.get(`era:${chapter}`) : undefined;
      }
      if (node.kind === "group") {
        const anchor = atlas.groups.find((item) => item.slug === node.slug)?.characterSlugs[0];
        const chapter = anchor ? atlas.characters.find((item) => item.slug === anchor)?.chapterSlug : null;
        return chapter ? positions.current.get(`era:${chapter}`) : undefined;
      }
      return undefined;
    };
    for (const [index, node] of model.nodes.entries()) {
      const remembered = positions.current.get(node.id);
      if (remembered) { node.x = remembered.x; node.y = remembered.y; continue; }
      const origin = parentPosition(node);
      if (origin) {
        const angle = (index / Math.max(1, model.nodes.length)) * Math.PI * 2;
        node.x = origin.x + Math.cos(angle) * 14;
        node.y = origin.y + Math.sin(angle) * 14;
      }
    }
    const simulation = forceSimulation<GraphNode, GraphEdge>(model.nodes)
      .force("link", forceLink<GraphNode, GraphEdge>(model.edges).id((node) => node.id).distance((edge) => (edge.kind === "succession" ? 130 : 70 + 90 / (1 + edge.weight))).strength((edge) => (edge.kind === "succession" ? 0.55 : 0.25)))
      .force("charge", forceManyBody<GraphNode>().strength((node) => -140 - radiusFor(node) * 10))
      .force("collide", forceCollide<GraphNode>().radius((node) => radiusFor(node) + 12))
      .force("center", forceCenter(0, 0))
      .force("x", forceX(0).strength(0.035))
      .force("y", forceY(0).strength(0.05))
      .alpha(0.9)
      .alphaDecay(0.035);
    simulation.on("tick", () => {
      for (const node of model.nodes) if (node.x !== undefined && node.y !== undefined) positions.current.set(node.id, { x: node.x, y: node.y });
      draw();
    });
    simulationRef.current = simulation;
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    // Pre-settle far enough that the layout's real extent is known, so the
    // viewport policy below fits to where nodes will be, not where they spawn.
    simulation.tick(reduce ? 160 : Math.min(90, 30 + model.nodes.length));
    if (reduce) simulation.stop();
    draw();

    // Viewport policy on model change — the "most reasonable" centring logic:
    // enter a tier fitted and centred; drill towards the clicked parent; keep
    // the viewport still when only filters changed or a wheel gesture is mid-dive.
    const intent = intentRef.current;
    intentRef.current = { kind: "keep" };
    const fitted = fitTransformFor(model.nodes, sizeRef.current.width, sizeRef.current.height);
    if (intent.kind === "fit" || intent.kind === "drill") gestureSinceFitRef.current = false;
    // The layout keeps relaxing after the pre-tick, so once it settles, ease the
    // frame around wherever the nodes ended up — unless the user took the camera.
    if (intent.kind === "fit") {
      simulation.on("end", () => {
        if (!gestureSinceFitRef.current) {
          const settled = fitTransformFor(model.nodes, sizeRef.current.width, sizeRef.current.height);
          baselineKRef.current = settled.k;
          animateTo(settled, 240);
        }
      });
    }
    if (intent.kind === "fit") {
      animateTo(fitted);
      baselineKRef.current = fitted.k;
    } else if (intent.kind === "drill") {
      // Same scale as a full fit, but centred where the user drilled.
      const next = zoomIdentity
        .translate(sizeRef.current.width / 2 - intent.x * fitted.k, sizeRef.current.height / 2 - intent.y * fitted.k)
        .scale(fitted.k);
      animateTo(next);
      baselineKRef.current = fitted.k;
    } else if (intent.kind === "wheel-in") {
      // The gesture already put the viewport where the user wants it; the finer
      // tier simply materialises in place. Re-baseline so the next threshold
      // needs another deliberate zoom.
      baselineKRef.current = transformRef.current.k;
    } else {
      // Filters or data changed under the same tier: hold the camera still but
      // keep the wheel thresholds meaningful for the new extent.
      baselineKRef.current = Math.min(transformRef.current.k, fitted.k);
    }

    return () => { simulation.stop(); };
  }, [animateTo, draw, model]);

  useEffect(() => { draw(); }, [draw, size]);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const behaviour = d3zoom<HTMLCanvasElement, unknown>()
      .scaleExtent([0.12, 8])
      // A press that lands on a node starts a node drag, not a pan.
      .filter((event: MouseEvent | TouchEvent | WheelEvent) => {
        if (event.type === "wheel") return true;
        if ("button" in event && event.button !== 0) return false;
        const source = "touches" in event ? event.touches[0] : (event as MouseEvent);
        return !source || nodeAtRef.current(source.clientX, source.clientY) === null;
      })
      .on("zoom", (event: D3ZoomEvent<HTMLCanvasElement, unknown>) => {
        transformRef.current = event.transform;
        draw();
        // Programmatic moves (animateTo) also land here; only real gestures
        // may cancel animations or trip the tier thresholds.
        if (!event.sourceEvent) return;
        gestureSinceFitRef.current = true;
        if (animationRef.current !== null) { cancelAnimationFrame(animationRef.current); animationRef.current = null; }
        const tierIndex = TIERS.indexOf(zoomLevelRef.current);
        const magnification = event.transform.k / Math.max(0.01, baselineKRef.current);
        if (magnification > DRILL_IN_FACTOR && tierIndex < TIERS.length - 1) {
          intentRef.current = { kind: "wheel-in" };
          onZoomLevel(TIERS[tierIndex + 1]!);
        } else if (magnification < DRILL_OUT_FACTOR && tierIndex > 0) {
          // Zooming out asks for the overview, so the coarser tier arrives fitted.
          intentRef.current = { kind: "fit" };
          onZoomLevel(TIERS[tierIndex - 1]!);
        }
      });
    zoomRef.current = behaviour;
    const selection = select(canvas);
    selection.call(behaviour);
    selection.call(behaviour.transform, transformRef.current.translate(0, 0));
    return () => { selection.on(".zoom", null); };
  }, [draw, onZoomLevel]);

  const toGraphSpace = useCallback((clientX: number, clientY: number): { x: number; y: number } | null => {
    const canvas = canvasRef.current;
    if (!canvas) return null;
    const rect = canvas.getBoundingClientRect();
    const transform = transformRef.current;
    return { x: (clientX - rect.left - transform.x) / transform.k, y: (clientY - rect.top - transform.y) / transform.k };
  }, []);

  const nodeAt = useCallback((clientX: number, clientY: number): GraphNode | null => {
    const point = toGraphSpace(clientX, clientY);
    if (!point) return null;
    let best: GraphNode | null = null;
    let bestDistance = Infinity;
    for (const node of model.nodes) {
      if (node.x === undefined || node.y === undefined) continue;
      const distance = Math.hypot(node.x - point.x, node.y - point.y);
      if (distance < radiusFor(node) + 4 && distance < bestDistance) { best = node; bestDistance = distance; }
    }
    return best;
  }, [model.nodes, toGraphSpace]);

  /** Nearest clickable relation edge, so a line is a target and not just paint. */
  const edgeAt = useCallback((clientX: number, clientY: number): GraphEdge | null => {
    const point = toGraphSpace(clientX, clientY);
    if (!point) return null;
    const threshold = 6 / Math.max(1, transformRef.current.k * 0.7);
    let best: GraphEdge | null = null;
    let bestDistance = threshold;
    for (const edge of model.edges) {
      if (edge.kind !== "relation") continue;
      const source = edge.source as GraphNode; const target = edge.target as GraphNode;
      if (source.x === undefined || target.x === undefined) continue;
      const dx = target.x! - source.x!; const dy = target.y! - source.y!;
      const lengthSq = dx * dx + dy * dy;
      const along = lengthSq === 0 ? 0 : Math.max(0, Math.min(1, ((point.x - source.x!) * dx + (point.y - source.y!) * dy) / lengthSq));
      const distance = Math.hypot(point.x - (source.x! + along * dx), point.y - (source.y! + along * dy));
      if (distance < bestDistance) { best = edge; bestDistance = distance; }
    }
    return best;
  }, [model.edges, toGraphSpace]);

  useEffect(() => { nodeAtRef.current = nodeAt; }, [nodeAt]);

  function resetView() {
    for (const node of model.nodes) { node.fx = null; node.fy = null; }
    const simulation = simulationRef.current;
    if (simulation) { simulation.alpha(0.5).restart(); simulation.tick(60); }
    baselineKRef.current = fitTransformFor(model.nodes, sizeRef.current.width, sizeRef.current.height).k;
    animateTo(fitTransformFor(model.nodes, sizeRef.current.width, sizeRef.current.height));
  }

  function changeTier(level: ZoomLevel) {
    if (level === zoomLevel) { animateTo(fitTransformFor(model.nodes, sizeRef.current.width, sizeRef.current.height)); return; }
    intentRef.current = { kind: "fit" };
    onZoomLevel(level);
  }

  function activate(node: GraphNode) {
    // Drilling down keeps the story spatial: the finer tier opens centred on
    // the node that was clicked, whose children fan out from that same spot.
    if (node.kind === "era") {
      if (node.x !== undefined && node.y !== undefined) intentRef.current = { kind: "drill", x: node.x, y: node.y };
      onChapter(node.slug);
      onZoomLevel("group");
      return;
    }
    if (node.kind === "group") {
      if (node.x !== undefined && node.y !== undefined) intentRef.current = { kind: "drill", x: node.x, y: node.y };
      onZoomLevel("major");
      const anchor = atlas.groups.find((group) => group.slug === node.slug)?.anchorCharacterSlug;
      if (anchor) onSelect({ type: "character", workSlug: atlas.work.slug, id: anchor });
      return;
    }
    onSelect({ type: "character", workSlug: atlas.work.slug, id: node.slug });
  }

  // A selection arriving from the list, search or drawer pans the camera to the
  // person; a click inside the canvas is already under the cursor and only gets
  // a gentle correction if the node sits near the edge of the view.
  useEffect(() => {
    if (!focusSlug) return;
    const node = model.nodes.find((item) => item.id === `person:${focusSlug}`);
    if (!node || node.x === undefined || node.y === undefined) return;
    const { width, height } = sizeRef.current;
    const transform = transformRef.current;
    const screenX = node.x * transform.k + transform.x;
    const screenY = node.y * transform.k + transform.y;
    const margin = 0.18;
    const offCentre = screenX < width * margin || screenX > width * (1 - margin) || screenY < height * margin || screenY > height * (1 - margin);
    if (!offCentre) return;
    animateTo(zoomIdentity.translate(width / 2 - node.x * transform.k, height / 2 - node.y * transform.k).scale(transform.k));
  }, [animateTo, focusSlug, model.nodes]);

  const adjacency = useMemo(() => relations.map((relation) => ({
    relation,
    from: characters.find((person) => person.slug === relation.fromSlug),
    to: characters.find((person) => person.slug === relation.toSlug),
  })).filter((row) => row.from && row.to), [characters, relations]);

  return <section className="relation-graph">
    <div className="graph-toolbar">
      <div className="graph-tiers" role="group" aria-label={t("graphZoomHint", locale)}>
        {ZOOM_LEVELS.map((level) => <button
          key={level}
          type="button"
          className={level === zoomLevel ? "active" : ""}
          aria-pressed={level === zoomLevel}
          onClick={() => changeTier(level)}
        >{t(level === "era" ? "graphLevelEra" : level === "group" ? "graphLevelGroup" : level === "major" ? "graphLevelMajor" : "graphLevelAll", locale)}</button>)}
      </div>
      <p className="graph-count">{model.nodes.length} {t("nodes", locale)} · {model.edges.filter((edge) => edge.kind !== "succession").length} {t("edges", locale)}</p>
      <button type="button" className="graph-mode" onClick={() => setAsTable(!asTable)} aria-pressed={asTable}>
        {asTable ? t("graphAsGraph", locale) : t("graphAsTable", locale)}
      </button>
      {!asTable && <button type="button" className="graph-reset" onClick={resetView}>{t("graphReset", locale)}</button>}
    </div>

    {asTable
      ? <div className="adjacency-scroll">
        {/* A node-link diagram cannot be read by keyboard or screen reader, so the
            same relationships are always available as a sortable, focusable table. */}
        <table className="adjacency">
          <caption>{t("relations", locale)} · {adjacency.length}</caption>
          <thead><tr>
            <th scope="col">{t("adjacencyFrom", locale)}</th>
            <th scope="col">{t("adjacencyKind", locale)}</th>
            <th scope="col">{t("adjacencyTo", locale)}</th>
            <th scope="col">{t("adjacencySentiment", locale)}</th>
            <th scope="col">{t("adjacencyStrength", locale)}</th>
          </tr></thead>
          <tbody>
            {adjacency.map(({ relation, from, to }) => <tr key={relation.id}>
              <td><button type="button" onClick={() => onSelect({ type: "character", workSlug: atlas.work.slug, id: relation.fromSlug })}>{from!.name}</button></td>
              <td><button type="button" onClick={() => onSelect({ type: "relationship", workSlug: atlas.work.slug, id: relation.id })}>{relation.label}</button></td>
              <td><button type="button" onClick={() => onSelect({ type: "character", workSlug: atlas.work.slug, id: relation.toSlug })}>{to!.name}</button></td>
              <td><span className={`sentiment-chip ${relation.sentiment}`}>{label(relation.sentiment, locale)}</span></td>
              <td>{relation.strength}/5</td>
            </tr>)}
          </tbody>
        </table>
      </div>
      : <div className="graph-canvas-wrap" ref={wrapRef}>
        <canvas
          ref={canvasRef}
          className="graph-canvas"
          role="img"
          aria-label={`${model.nodes.length} ${t("nodes", locale)}, ${model.edges.length} ${t("edges", locale)}`}
          onPointerDown={(event) => {
            if (event.button !== 0) return;
            pressRef.current = { x: event.clientX, y: event.clientY };
            const node = nodeAt(event.clientX, event.clientY);
            if (!node) return;
            event.currentTarget.setPointerCapture(event.pointerId);
            dragRef.current = { node, startX: event.clientX, startY: event.clientY, moved: false };
          }}
          onPointerMove={(event) => {
            const drag = dragRef.current;
            const rect = event.currentTarget.getBoundingClientRect();
            if (drag) {
              if (Math.hypot(event.clientX - drag.startX, event.clientY - drag.startY) > 3) drag.moved = true;
              if (drag.moved) {
                const point = toGraphSpace(event.clientX, event.clientY);
                if (point) { drag.node.fx = point.x; drag.node.fy = point.y; }
                simulationRef.current?.alphaTarget(0.22).restart();
                setHover(null);
              }
              return;
            }
            const node = nodeAt(event.clientX, event.clientY);
            event.currentTarget.style.cursor = node ? "pointer" : edgeAt(event.clientX, event.clientY) ? "pointer" : "grab";
            setHover(node ? { node, x: event.clientX - rect.left, y: event.clientY - rect.top } : null);
          }}
          onPointerUp={(event) => {
            const drag = dragRef.current;
            dragRef.current = null;
            if (drag) {
              simulationRef.current?.alphaTarget(0);
              // A press without movement is a click; a real drag leaves the node pinned.
              if (!drag.moved) { drag.node.fx = null; drag.node.fy = null; activate(drag.node); }
              return;
            }
            // Empty-space release: only a stationary press (not a pan) selects the relation under it.
            const press = pressRef.current;
            pressRef.current = null;
            if (!press || Math.hypot(event.clientX - press.x, event.clientY - press.y) > 3) return;
            const edge = edgeAt(event.clientX, event.clientY);
            if (edge && edge.relationIds.length > 0) onSelect({ type: "relationship", workSlug: atlas.work.slug, id: edge.relationIds[0]! });
          }}
          onDoubleClick={(event) => {
            const node = nodeAt(event.clientX, event.clientY);
            if (node) { node.fx = null; node.fy = null; simulationRef.current?.alpha(0.3).restart(); }
          }}
          onMouseLeave={() => setHover(null)}
        />
        {hover && <div className="graph-tooltip" style={{ left: hover.x + 14, top: hover.y + 14 }}>
          <strong>{hover.node.label}</strong>
          {hover.node.sublabel && <p>{hover.node.sublabel}</p>}
          {hover.node.kind !== "person" && <small>{hover.node.weight} · {t("characters", locale)}</small>}
        </div>}
        <p className="graph-hint">{t("graphZoomHint", locale)} · {t("dragHint", locale)}</p>
        <ul className="graph-legend" aria-hidden="true">
          {(["positive", "negative", "mixed", "neutral"] as const).map((sentiment) => <li key={sentiment} className={sentiment}><i />{label(sentiment, locale)}</li>)}
        </ul>
      </div>}
    {!asTable && model.hiddenCount > 0 && <p className="hidden-note">
      {model.hiddenCount} {t("hiddenAtTier", locale)}
      {zoomLevel !== "all" && <button type="button" onClick={() => changeTier("all")}>{t("showEveryone", locale)}</button>}
    </p>}
  </section>;
}
