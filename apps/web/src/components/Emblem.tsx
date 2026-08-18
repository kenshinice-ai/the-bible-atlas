import { useId } from "react";
import type { AtlasCharacterEmblem } from "../types";

/**
 * Deterministic vector emblems.
 *
 * The atlas has no portraits and cannot have any: nothing in it was drawn from
 * life. So a person is identified the way European heraldry and saints'
 * attributes identify one — by a sign the text or a long tradition already
 * attached to them. A curated emblem carries its own attestation level; anyone
 * without one falls back to a procedural device seeded by their slug, so the
 * whole cast is legible without inventing symbolism for people who have none.
 *
 * Everything here is pure geometry keyed on data. No raster asset is loaded,
 * the same input always yields the same drawing, and the whole system costs
 * bytes of code rather than megabytes of images.
 */

const GROUNDS: Record<string, { field: string; edge: string; ink: string }> = {
  gold: { field: "#3c2f14", edge: "#d9b25a", ink: "#f0d290" },
  ink: { field: "#1d2229", edge: "#5d6b7a", ink: "#cfd8e3" },
  vellum: { field: "#33291d", edge: "#8a7350", ink: "#e8dcc0" },
  sky: { field: "#1b2a3a", edge: "#5b7f9d", ink: "#cfe3f2" },
};

/** mulberry32 over the slug: art varies per person, never per render. */
function prng(seedText: string): () => number {
  let seed = 0;
  for (const character of seedText) seed = Math.imul(seed ^ character.codePointAt(0)!, 2654435761) >>> 0;
  return () => {
    seed = (seed + 0x6d2b79f5) >>> 0;
    let value = seed;
    value = Math.imul(value ^ (value >>> 15), value | 1);
    value ^= value + Math.imul(value ^ (value >>> 7), value | 61);
    return ((value ^ (value >>> 14)) >>> 0) / 4294967296;
  };
}

const round = (value: number): string => (Math.round(value * 100) / 100).toString();

/**
 * One glyph per curated symbol. Each is drawn inside a 48×48 box centred on
 * (24, 24) and stroked in the emblem's ink colour, so a glyph never has to know
 * which era or ground it will sit on.
 */
function glyph(symbol: string, ink: string): React.ReactNode {
  const stroke = { fill: "none", stroke: ink, strokeWidth: 1.7, strokeLinecap: "round" as const, strokeLinejoin: "round" as const };
  const solid = { fill: ink, stroke: "none" };
  switch (symbol) {
    case "starfield": {
      const stars: readonly [number, number, number][] = [[24, 13, 5], [14, 25, 3], [34, 26, 3.4], [20, 34, 2.4], [30, 35, 2]];
      return <g {...solid}>{stars.map(([x, y, r]) => {
        const inner = r * 0.32;
        return <path key={`${x}-${y}`} d={`M${x} ${y - r} L${x + inner} ${y - inner} L${x + r} ${y} L${x + inner} ${y + inner} L${x} ${y + r} L${x - inner} ${y + inner} L${x - r} ${y} L${x - inner} ${y - inner} Z`} />;
      })}</g>;
    }
    case "tablets":
      return <g {...stroke}><path d="M15 34V19a4 4 0 0 1 4-4h1v19zM33 34V19a4 4 0 0 0-4-4h-1v19z" /><path d="M13 34h22" /><path d="M17 22h2M17 26h2M29 22h2M29 26h2" /></g>;
    case "harp":
      return <g {...stroke}><path d="M17 35c0-9 3-16 11-21" /><path d="M17 35h13" /><path d="M28 14c4 6 5 13 2 21" /><path d="M21 33V21M24 33V19M27 33V18" /></g>;
    case "chi-rho":
      return <g {...stroke}><path d="M24 36V15" /><path d="M24 15a6 6 0 0 1 0 12h-0.5" /><path d="M15 33l14-14M33 33L23 23" /></g>;
    case "sword-scroll":
      return <g {...stroke}><path d="M20 35V15l-2-3 2-2 2 2-2 3" /><path d="M16 20h8" /><path d="M28 14h6a3 3 0 0 1 0 6h-6z" /><path d="M28 14v20h6a3 3 0 0 0 0-6h-6" /></g>;
    case "keys":
      return <g {...stroke}><circle cx="18" cy="17" r="4" /><path d="M20 20l9 12M25 27l-3 3M28 31l-3 3" /><circle cx="32" cy="17" r="3.4" /><path d="M31 20l-7 10" /></g>;
    case "eagle":
      return <g {...stroke}><path d="M24 34V19" /><path d="M24 19l-11-5c1 6 4 10 11 12M24 19l11-5c-1 6-4 10-11 12" /><path d="M24 19l-3-4h6z" /><path d="M22 34h4" /></g>;
    case "lily":
      return <g {...stroke}><path d="M24 35V18" /><path d="M24 20c-4-3-7-1-8 3 4 2 7 0 8-3zM24 20c4-3 7-1 8 3-4 2-7 0-8-3z" /><path d="M24 18c-2-4 0-7 0-7s2 3 0 7z" /><path d="M18 35h12" /></g>;
    case "ark":
      return <g {...stroke}><path d="M12 26h24l-4 8H16z" /><path d="M17 26v-6h14v6" /><path d="M22 20v-4h4v4" /><path d="M12 30c3 2 5 2 8 0s5-2 8 0 5 2 8 0" /></g>;
    case "ladder":
      return <g {...stroke}><path d="M18 36L22 12M28 36L32 12" /><path d="M19.4 30h9.2M20.4 24h9.2M21.4 18h9.2" /></g>;
    case "striped-coat":
      return <g {...stroke}><path d="M18 15l6 3 6-3 5 4-3 4v13H16V26l-3-4z" /><path d="M20 24h8M20 28h8M20 32h8" /></g>;
    case "budding-rod":
      return <g {...stroke}><path d="M24 36V13" /><path d="M24 22c-5 0-7-3-7-6 4 0 7 2 7 6zM24 26c5 0 7-3 7-6-4 0-7 2-7 6z" /><circle cx="24" cy="13" r="2.4" /></g>;
    case "crown":
      return <g {...stroke}><path d="M14 31l-2-13 7 6 5-9 5 9 7-6-2 13z" /><path d="M14 34h20" /></g>;
    case "fish":
      return <g {...stroke}><path d="M13 24c5-7 16-7 21 0-5 7-16 7-21 0z" /><path d="M34 24l4-5v10z" /><circle cx="19" cy="23" r="1.2" fill={ink} /></g>;
    case "ram":
      return <g {...stroke}><path d="M24 18c-3 0-5 2-5 5s2 6 5 6 5-3 5-6-2-5-5-5z" /><path d="M19 20c-4-1-6 2-5 5s4 4 5 2M29 20c4-1 6 2 5 5s-4 4-5 2" /><path d="M22 33h4" /></g>;
    case "pitcher":
      return <g {...stroke}><path d="M19 18h10l2 6c0 6-2 10-7 10s-7-4-7-10z" /><path d="M31 22c3 0 4 2 4 4s-1 4-4 4" /><path d="M18 18h12" /></g>;
    case "timbrel":
      return <g {...stroke}><circle cx="24" cy="24" r="9" /><circle cx="24" cy="24" r="5.4" /><path d="M15.6 20l3 1M32.4 20l-3 1M15.6 28l3-1M32.4 28l-3-1" /></g>;
    case "palm":
      return <g {...stroke}><path d="M24 36V20" /><path d="M24 20c-5-4-10-3-12 1 5 1 9 1 12-1zM24 20c5-4 10-3 12 1-5 1-9 1-12-1zM24 20c-1-6 2-9 5-9-1 5-2 8-5 9z" /></g>;
    case "fleece":
      return <g {...stroke}><path d="M15 27a4 4 0 0 1 2-7 5 5 0 0 1 9-2 5 5 0 0 1 7 5 4 4 0 0 1-1 7z" /><path d="M16 27l1 6M24 28v6M32 27l-1 6" /></g>;
    case "broken-pillars":
      return <g {...stroke}><path d="M15 34V24l2-2M15 20v-6h6v6M33 34V24l-2-2M33 20v-6h-6v6" /><path d="M12 36h10M26 36h10" /><path d="M22 21l4 4M26 21l-4 4" /></g>;
    case "sheaf":
      return <g {...stroke}><path d="M24 35V16M19 33c-2-6-1-12 2-16M29 33c2-6 1-12-2-16" /><path d="M16 26h16" /></g>;
    case "shofar":
      return <g {...stroke}><path d="M13 28c6 4 14 4 20-2 3-3 3-6 1-8-2 3-5 5-9 5" /><path d="M13 28c-1-2 0-4 2-4" /></g>;
    case "horn-of-oil":
      return <g {...stroke}><path d="M32 16c-8 1-14 6-16 13 7 1 13-3 16-9" /><path d="M32 16c2 2 2 5 0 7" /><path d="M18 32c-1 2-1 3 0 4" /></g>;
    case "spear":
      return <g {...stroke}><path d="M24 36V17" /><path d="M24 11l3 6h-6z" /><path d="M20 20h8" /></g>;
    case "bow":
      return <g {...stroke}><path d="M17 12c8 4 8 20 0 24" /><path d="M17 12L17 36" /><path d="M14 24h18M28 20l4 4-4 4" /></g>;
    case "fire-chariot":
      return <g {...stroke}><circle cx="20" cy="31" r="4.5" /><path d="M15 27h14l3-6H18z" /><path d="M30 27c3-4 4-8 2-12-3 3-6 4-8 3" /><path d="M20 31h1" /></g>;
    case "mantle":
      return <g {...stroke}><path d="M17 14c2 4 12 4 14 0l4 6-3 3v11H16V23l-3-3z" /><path d="M24 18v16" /></g>;
    case "coal":
      return <g {...stroke}><path d="M18 30a6 6 0 0 1 12 0 6 6 0 0 1-12 0z" /><path d="M24 24c-3-3-2-7 0-9 1 3 4 4 3 9" /><path d="M14 34h20" /></g>;
    case "yoke":
      return <g {...stroke}><path d="M13 20h22" /><path d="M16 20v5a3 3 0 0 0 6 0v-5M26 20v5a3 3 0 0 0 6 0v-5" /><path d="M24 20v-5" /></g>;
    case "lion":
      return <g {...stroke}><circle cx="24" cy="24" r="7" /><path d="M24 13v3M24 32v3M13 24h3M32 24h3M16.3 16.3l2.1 2.1M29.6 29.6l2.1 2.1M31.7 16.3l-2.1 2.1M18.4 29.6l-2.1 2.1" /><path d="M21 23v1M27 23v1M21 27c2 1.5 4 1.5 6 0" /></g>;
    case "scepter":
      return <g {...stroke}><path d="M20 36L30 16" /><circle cx="31" cy="14" r="3" /><path d="M23 30l6-3" /></g>;
    case "trowel":
      return <g {...stroke}><path d="M24 34l-7-11h14z" /><path d="M24 23v-6M22 17h4" /><path d="M13 14h22" /></g>;
    case "reed-cross":
      return <g {...stroke}><path d="M24 37V11" /><path d="M17 19h14" /><path d="M24 11c-2-1-2-3 0-4 2 1 2 3 0 4z" /></g>;
    case "tree":
      return <g {...stroke}><path d="M24 36V22" /><circle cx="24" cy="18" r="8" /><path d="M24 26l-5-5M24 24l5-5" /></g>;
    case "tent-peg":
      return <g {...stroke}><path d="M22 12h8l-2 5h-4z" /><path d="M24 17v18l2-3" /><path d="M12 22l7-3 2 4-7 3z" /><path d="M12 22l-2 4" /></g>;
    case "vineyard":
      return <g {...stroke}><path d="M24 13v6" /><path d="M24 19c-4 0-6 2-6 5M24 19c4 0 6 2 6 5" /><g {...solid}>{[[18, 26], [24, 25], [30, 26], [21, 31], [27, 31], [24, 36]].map(([x, y]) => <circle key={`${x}-${y}`} cx={x} cy={y} r="2.3" />)}</g></g>;
    case "living-branch":
      return <g {...stroke}><path d="M24 37c0-9 1-15 4-20" /><path d="M26 25c-4 1-7-1-8-5 4-1 7 1 8 5zM27 21c4-1 6-4 5-8-4 1-6 4-5 8zM24 31c-4 0-6-2-6-6 4 0 6 2 6 6z" /><circle cx="29" cy="14" r="1.6" fill={ink} /></g>;
    case "tent":
      return <g {...stroke}><path d="M12 34L24 14l12 20z" /><path d="M24 34V22" /><path d="M20 34c0-5 2-8 4-10 2 2 4 5 4 10" /></g>;
    case "crook":
      return <g {...stroke}><path d="M22 37V21a6 6 0 0 1 12 0" /><path d="M14 30h6" /></g>;
    case "statue":
      return <g {...stroke}><path d="M20 12h8v8h-8z" /><path d="M21 20h6v9h-6z" /><path d="M22 29h4v6h-4z" /><path d="M16 37h16" /></g>;
    case "jar":
      return <g {...stroke}><path d="M20 15h8v3l3 5c0 8-3 11-7 11s-7-3-7-11l3-5z" /><path d="M18 24h12" /></g>;
    case "coins":
      return <g {...stroke}><circle cx="19" cy="28" r="5" /><circle cx="29" cy="28" r="5" /><circle cx="24" cy="19" r="5" /></g>;
    case "basin":
      return <g {...stroke}><path d="M13 24h22c0 7-4 11-11 11s-11-4-11-11z" /><path d="M20 20c0-3 4-3 4-6M27 20c0-2 2-3 2-5" /></g>;
    case "radiance":
      return <g {...stroke}><circle cx="24" cy="24" r="6" /><path d="M24 9v6M24 33v6M9 24h6M33 24h6M13.4 13.4l4.2 4.2M30.4 30.4l4.2 4.2M34.6 13.4l-4.2 4.2M17.6 30.4l-4.2 4.2" /></g>;
    case "flame":
      return <g {...stroke}><path d="M24 37c-5 0-8-3-8-8 0-6 5-8 5-14 5 3 5 6 4 9 2-1 3-3 3-5 3 3 4 7 4 10 0 5-3 8-8 8z" /></g>;
    case "flame-tongues":
      return <g {...stroke}><path d="M18 32c-2-2-2-5 0-8 1 2 3 2 3 5 0 2-1 3-3 3zM30 32c-2-2-2-5 0-8 1 2 3 2 3 5 0 2-1 3-3 3zM24 24c-2-3-2-6 0-9 1 3 3 3 3 6 0 2-1 3-3 3z" /><path d="M14 37h20" /></g>;
    case "split-crown":
      return <g {...stroke}><path d="M12 31l-1-12 6 5 4-8v15zM36 31l1-12-6 5-4-8v15z" /><path d="M12 34h9M27 34h9" /></g>;
    case "broken-wall":
      return <g {...stroke}><path d="M12 36V22h8v-5h4v9M36 36V22h-6v-7h-3" /><path d="M12 29h8M28 29h8" /><path d="M24 26l3 4-2 3" /></g>;
    case "ship":
      return <g {...stroke}><path d="M12 29h24l-4 7H16z" /><path d="M24 29V12" /><path d="M24 14c5 2 7 5 7 9h-7zM24 16c-4 1-6 4-6 7h6" /></g>;
    default:
      return null;
  }
}

/** Border treatment. Heraldic differencing: same charge, different border. */
function ring(ringKey: string, edge: string): React.ReactNode {
  const stroke = { fill: "none", stroke: edge, strokeLinecap: "round" as const, strokeLinejoin: "round" as const };
  if (ringKey === "braided") {
    const arcs = Array.from({ length: 12 }, (_, index) => {
      const angle = (index / 12) * Math.PI * 2;
      const next = ((index + 1) / 12) * Math.PI * 2;
      const point = (a: number, r: number) => `${round(24 + Math.cos(a) * r)} ${round(24 + Math.sin(a) * r)}`;
      return `M${point(angle, 21)} Q${point((angle + next) / 2, 23.4)} ${point(next, 21)}`;
    }).join(" ");
    return <path d={arcs} {...stroke} strokeWidth={1.3} />;
  }
  if (ringKey === "rayed") {
    const rays = Array.from({ length: 24 }, (_, index) => {
      const angle = (index / 24) * Math.PI * 2;
      const inner = 20.6;
      const outer = index % 2 === 0 ? 23.2 : 22;
      return `M${round(24 + Math.cos(angle) * inner)} ${round(24 + Math.sin(angle) * inner)} L${round(24 + Math.cos(angle) * outer)} ${round(24 + Math.sin(angle) * outer)}`;
    }).join(" ");
    return <><circle cx="24" cy="24" r="20.4" {...stroke} strokeWidth={1.1} /><path d={rays} {...stroke} strokeWidth={1} /></>;
  }
  if (ringKey === "thorned") {
    const thorns = Array.from({ length: 16 }, (_, index) => {
      const angle = (index / 16) * Math.PI * 2;
      const tip = angle + 0.12;
      return `M${round(24 + Math.cos(angle) * 21)} ${round(24 + Math.sin(angle) * 21)} L${round(24 + Math.cos(tip) * 23.6)} ${round(24 + Math.sin(tip) * 23.6)}`;
    }).join(" ");
    return <><circle cx="24" cy="24" r="21" {...stroke} strokeWidth={1.2} /><path d={thorns} {...stroke} strokeWidth={1} /></>;
  }
  if (ringKey === "waved") {
    const waves = Array.from({ length: 16 }, (_, index) => {
      const angle = (index / 16) * Math.PI * 2;
      const next = ((index + 1) / 16) * Math.PI * 2;
      const radius = index % 2 === 0 ? 22.6 : 20.6;
      const point = (a: number, r: number) => `${round(24 + Math.cos(a) * r)} ${round(24 + Math.sin(a) * r)}`;
      return `M${point(angle, 21.6)} Q${point((angle + next) / 2, radius)} ${point(next, 21.6)}`;
    }).join(" ");
    return <path d={waves} {...stroke} strokeWidth={1.2} />;
  }
  if (ringKey === "chained") {
    return <><circle cx="24" cy="24" r="21.4" {...stroke} strokeWidth={1.1} />
      {Array.from({ length: 10 }, (_, index) => {
        const angle = (index / 10) * Math.PI * 2;
        return <ellipse key={index} cx={round(24 + Math.cos(angle) * 21.4)} cy={round(24 + Math.sin(angle) * 21.4)} rx="2.5" ry="1.5"
          transform={`rotate(${round((angle * 180) / Math.PI + 90)} ${round(24 + Math.cos(angle) * 21.4)} ${round(24 + Math.sin(angle) * 21.4)})`} {...stroke} strokeWidth={1} />;
      })}</>;
  }
  return <circle cx="24" cy="24" r="21.4" {...stroke} strokeWidth={1.4} />;
}

interface Props {
  /** Slug of the person or era; also the seed for the procedural fallback. */
  slug: string;
  /** Curated emblem, when this person has one. */
  emblem?: AtlasCharacterEmblem | { symbolKey: string; ringKey?: string; groundKey?: string } | undefined;
  /** Era accent colour, used when the emblem's ground is `era`. */
  accent: string;
  size?: number | undefined;
  title?: string | undefined;
}

/**
 * The procedural fallback. Rather than an empty circle, an uncurated person
 * gets a device built from their slug: a segmented ring and a small charge that
 * reads as belonging to the same visual family without asserting any meaning.
 */
function fallbackDevice(slug: string, ink: string): React.ReactNode {
  const random = prng(slug);
  const segments = 5 + Math.floor(random() * 4);
  const radius = 7 + random() * 3;
  const rotation = random() * 360;
  const points = Array.from({ length: segments }, (_, index) => {
    const angle = (index / segments) * Math.PI * 2 - Math.PI / 2;
    return `${round(24 + Math.cos(angle) * radius)} ${round(24 + Math.sin(angle) * radius)}`;
  }).join(" L");
  return <g fill="none" stroke={ink} strokeWidth={1.5} strokeLinejoin="round" opacity={0.85} transform={`rotate(${round(rotation)} 24 24)`}>
    <path d={`M${points} Z`} />
    <circle cx="24" cy="24" r={round(radius * 0.42)} />
  </g>;
}

export function Emblem({ slug, emblem, accent, size = 44, title }: Props) {
  const groundKey = emblem?.groundKey ?? "era";
  const palette = GROUNDS[groundKey] ?? { field: accent, edge: accent, ink: "#f4ecd8" };
  const field = groundKey === "era" ? accent : palette.field;
  const edge = groundKey === "era" ? "#f4ecd8" : palette.edge;
  const ink = groundKey === "era" ? "#f8f2e2" : palette.ink;
  const drawn = emblem ? glyph(emblem.symbolKey, ink) : null;
  // The same person's emblem can appear in the list and the drawer at once, so
  // the gradient id has to be unique per instance, not per slug.
  const gradientId = `emblem-${useId().replace(/[^a-zA-Z0-9-]/gu, "")}`;
  return <span className="emblem" style={{ width: size, height: size }}>
    <svg viewBox="0 0 48 48" width={size} height={size} role={title ? "img" : undefined} aria-label={title} aria-hidden={title ? undefined : true}>
      <defs>
        <radialGradient id={gradientId} cx="0.4" cy="0.32" r="0.78">
          <stop offset="0" stopColor={field} stopOpacity="0.95" />
          <stop offset="1" stopColor={field} stopOpacity="0.55" />
        </radialGradient>
      </defs>
      <circle cx="24" cy="24" r="22" fill={`url(#${gradientId})`} />
      {ring(emblem?.ringKey ?? "plain", edge)}
      {drawn ?? fallbackDevice(slug, ink)}
    </svg>
  </span>;
}
