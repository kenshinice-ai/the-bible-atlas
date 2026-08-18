import { createHash } from "node:crypto";
import { mkdir, writeFile } from "node:fs/promises";
import { join, resolve } from "node:path";
import pg from "pg";

/**
 * Deterministic illuminated-overview generator for the Bible Atlas.
 *
 * Renders an original, label-free backdrop from the atlas's own data: the real
 * coordinates of its places, the real waypoint order of its routes, and the era
 * colours already stored on the chapters. Nothing is traced from an existing
 * map or image, no font is embedded, and the same database state always yields
 * a byte-identical SVG, so the asset carries a stable checksum.
 *
 * It is deliberately decorative rather than cartographic: the Leaflet layer
 * remains the only surface that makes positional claims. The frame borrows the
 * grammar of a manuscript map — rhumb lines, a vine border, a wind rose — to
 * say "this is a made object", not "this is a survey".
 *
 * Usage:
 *   DATABASE_URL=postgresql:///literary_atlas npx tsx scripts/generate_bible_overview.ts
 */
const ROOT = resolve(process.env.ATLAS_PROJECT_ROOT ?? process.cwd());
const DATABASE_URL = process.env.DATABASE_URL ?? "postgresql://llmacbookpro@localhost:5432/literary_atlas";
const WORK_ID = "10000000-0000-4000-8000-000000000005";
const OUT_DIR = join(ROOT, "apps/web/public/media/bible");
const OUT_SVG = join(OUT_DIR, "atlas-overview-v1.svg");
const MANIFEST_DIR = join(ROOT, "docs/generated");
const MANIFEST = join(MANIFEST_DIR, "bible-atlas-overview-v1.manifest.json");
const VERSION = "bible-illuminated-overview-svg-v1";

const W = 1200;
const H = 420;
const PAD = 34;

const fixed = (value: number): string => (Math.round(value * 100) / 100).toString();

/** mulberry32 seeded by a constant: texture varies across the page, not runs. */
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

type Place = { slug: string; lng: number; lat: number; weight: number; accent: string | null };
type Route = { slug: string; points: { lng: number; lat: number }[] };

async function main(): Promise<void> {
  const pool = new pg.Pool({ connectionString: DATABASE_URL });
  try {
    const placeRows = await pool.query<{ slug: string; lng: string; lat: string; weight: string; accent: string | null }>(
      `SELECT l.slug, ST_X(l.geom::geometry) AS lng, ST_Y(l.geom::geometry) AS lat,
              (SELECT count(*) FROM event_locations el WHERE el.location_id=l.id) AS weight,
              (SELECT ch.accent_color FROM event_locations el JOIN events e ON e.id=el.event_id
                 JOIN chapters ch ON ch.id=e.chapter_id WHERE el.location_id=l.id
                ORDER BY e.sequence LIMIT 1) AS accent
         FROM locations l
        WHERE l.work_id=$1 AND l.geom IS NOT NULL
        ORDER BY l.sort_order, l.slug`, [WORK_ID]);
    const routeRows = await pool.query<{ slug: string; lng: string; lat: string; position: number }>(
      `SELECT r.slug, ST_X(l.geom::geometry) AS lng, ST_Y(l.geom::geometry) AS lat, rw.position
         FROM routes r JOIN route_waypoints rw ON rw.route_id=r.id JOIN locations l ON l.id=rw.location_id
        WHERE r.work_id=$1 AND l.geom IS NOT NULL
        ORDER BY r.sort_order, r.slug, rw.position`, [WORK_ID]);

    const places: Place[] = placeRows.rows.map((row) => ({
      slug: row.slug, lng: Number(row.lng), lat: Number(row.lat), weight: Number(row.weight), accent: row.accent,
    }));
    if (places.length < 10) throw new Error(`only ${places.length} located places; refusing to render an empty master`);

    const routes = new Map<string, Route>();
    for (const row of routeRows.rows) {
      const route = routes.get(row.slug) ?? { slug: row.slug, points: [] };
      route.points.push({ lng: Number(row.lng), lat: Number(row.lat) });
      routes.set(row.slug, route);
    }

    // Equirectangular fit over the atlas's own extent, so the composition
    // follows the data rather than a fixed idea of where the Bible happened.
    const lngs = places.map((place) => place.lng);
    const lats = places.map((place) => place.lat);
    const minLng = Math.min(...lngs); const maxLng = Math.max(...lngs);
    const minLat = Math.min(...lats); const maxLat = Math.max(...lats);
    const X = (lng: number): number => PAD + ((lng - minLng) / (maxLng - minLng)) * (W - PAD * 2);
    const Y = (lat: number): number => PAD + ((maxLat - lat) / (maxLat - minLat)) * (H - PAD * 2);

    const svg = render(places, [...routes.values()], X, Y);
    const checksum = createHash("sha256").update(svg).digest("hex");
    await mkdir(OUT_DIR, { recursive: true });
    await mkdir(MANIFEST_DIR, { recursive: true });
    await writeFile(OUT_SVG, svg, "utf8");
    await writeFile(MANIFEST, `${JSON.stringify({
      asset: "/media/bible/atlas-overview-v1.svg",
      generator: "scripts/generate_bible_overview.ts",
      generatorVersion: VERSION,
      interpretationClass: "artistic_interpretation",
      disclosure: "Original procedural artwork generated from this atlas's own place and route records. Decorative backdrop; positional claims belong to the interactive map layer only.",
      viewBox: `0 0 ${W} ${H}`,
      inputs: { locatedPlaces: places.length, routes: routes.size, extent: { minLng, maxLng, minLat, maxLat } },
      bytes: Buffer.byteLength(svg, "utf8"),
      sha256: checksum,
    }, null, 2)}\n`, "utf8");
    console.log(`Bible overview written: ${places.length} places, ${routes.size} routes, ${Buffer.byteLength(svg, "utf8")} bytes`);
    console.log(`SHA-256 ${checksum}`);
  } finally {
    await pool.end();
  }
}

/** Andrew's monotone chain, so the land outline follows the data, not a guess. */
function convexHull(points: readonly [number, number][]): [number, number][] {
  const sorted = [...points].sort((left, right) => left[0] - right[0] || left[1] - right[1]);
  const cross = (o: [number, number], a: [number, number], b: [number, number]): number =>
    (a[0] - o[0]) * (b[1] - o[1]) - (a[1] - o[1]) * (b[0] - o[0]);
  const build = (input: readonly [number, number][]): [number, number][] => {
    const chain: [number, number][] = [];
    for (const point of input) {
      while (chain.length >= 2 && cross(chain[chain.length - 2]!, chain[chain.length - 1]!, point) <= 0) chain.pop();
      chain.push(point);
    }
    chain.pop();
    return chain;
  };
  return [...build(sorted), ...build([...sorted].reverse())];
}

/**
 * A closed Catmull-Rom path through the hull, pushed outward so the coastline
 * sits around the settlements rather than clipping through them.
 */
function smoothClosedPath(hull: readonly [number, number][], outset: number): string {
  if (hull.length < 3) return "";
  const cx = hull.reduce((total, point) => total + point[0], 0) / hull.length;
  const cy = hull.reduce((total, point) => total + point[1], 0) / hull.length;
  const grown: [number, number][] = hull.map(([x, y]) => {
    const dx = x - cx;
    const dy = y - cy;
    const length = Math.hypot(dx, dy) || 1;
    return [x + (dx / length) * outset, y + (dy / length) * outset];
  });
  const at = (index: number): [number, number] => grown[((index % grown.length) + grown.length) % grown.length]!;
  const segments: string[] = [`M${fixed(at(0)[0])} ${fixed(at(0)[1])}`];
  for (let index = 0; index < grown.length; index += 1) {
    const p0 = at(index - 1);
    const p1 = at(index);
    const p2 = at(index + 1);
    const p3 = at(index + 2);
    const c1: [number, number] = [p1[0] + (p2[0] - p0[0]) / 6, p1[1] + (p2[1] - p0[1]) / 6];
    const c2: [number, number] = [p2[0] - (p3[0] - p1[0]) / 6, p2[1] - (p3[1] - p1[1]) / 6];
    segments.push(`C${fixed(c1[0])} ${fixed(c1[1])} ${fixed(c2[0])} ${fixed(c2[1])} ${fixed(p2[0])} ${fixed(p2[1])}`);
  }
  return `${segments.join(" ")} Z`;
}

function render(places: readonly Place[], routes: readonly Route[], X: (lng: number) => number, Y: (lat: number) => number): string {
  const random = prng("bible-illuminated-overview-v1");
  const parts: string[] = [];
  parts.push(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${W} ${H}" preserveAspectRatio="xMidYMid slice" role="img" aria-hidden="true">`);
  parts.push("<defs>");
  parts.push('<linearGradient id="vellum" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#1a2033"/><stop offset=".55" stop-color="#141a2c"/><stop offset="1" stop-color="#0d1220"/></linearGradient>');
  parts.push('<radialGradient id="glow" cx=".5" cy=".5" r=".5"><stop offset="0" stop-color="#f5c15d" stop-opacity=".55"/><stop offset="1" stop-color="#f5c15d" stop-opacity="0"/></radialGradient>');
  parts.push('<linearGradient id="routeInk" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#f5c15d" stop-opacity=".42"/><stop offset="1" stop-color="#d97706" stop-opacity=".18"/></linearGradient>');
  parts.push('<filter id="soften" x="-30%" y="-30%" width="160%" height="160%"><feGaussianBlur stdDeviation="6"/></filter>');
  parts.push('<filter id="tooth"><feTurbulence type="fractalNoise" baseFrequency=".85" numOctaves="2" seed="11" stitchTiles="stitch"/><feColorMatrix type="matrix" values="0 0 0 0 0.95 0 0 0 0 0.88 0 0 0 0 0.72 0 0 0 .045 0"/></filter>');
  parts.push(`<clipPath id="frameClip"><rect x="${PAD - 12}" y="${PAD - 12}" width="${W - (PAD - 12) * 2}" height="${H - (PAD - 12) * 2}" rx="14"/></clipPath>`);
  parts.push("</defs>");
  parts.push(`<rect width="${W}" height="${H}" fill="url(#vellum)"/>`);

  // Portolan rhumb lines from a wind rose. The rose sits in open water rather
  // than on the atlas centroid: centred, it landed on Jerusalem and read as an
  // explosion over the densest part of the map.
  const hubX = PAD + 118;
  const hubY = H - PAD - 78;
  const rhumbs: string[] = [];
  for (let index = 0; index < 32; index += 1) {
    const angle = (index / 32) * Math.PI * 2;
    rhumbs.push(`M${fixed(hubX)} ${fixed(hubY)} L${fixed(hubX + Math.cos(angle) * 1400)} ${fixed(hubY + Math.sin(angle) * 1400)}`);
  }
  parts.push(`<g clip-path="url(#frameClip)"><path d="${rhumbs.join(" ")}" fill="none" stroke="#5b7f9d" stroke-opacity=".13" stroke-width="0.7"/></g>`);

  // Water: soft bands across the whole field, evoking the sea the routes cross.
  for (let band = 0; band < 7; band += 1) {
    const y = 60 + band * 52 + random() * 8;
    const segments: string[] = [];
    for (let x = -20; x < W + 40; x += 46) {
      segments.push(`M${fixed(x)} ${fixed(y)} q${fixed(11 + random() * 4)} ${fixed(-4 - random() * 3)} ${fixed(23)} 0`);
    }
    parts.push(`<path d="${segments.join(" ")}" fill="none" stroke="#5b7f9d" stroke-opacity="${fixed(0.05 + random() * 0.05)}" stroke-width="1"/>`);
  }

  // The inhabited land, as a smoothed hull around every located place. Without
  // it the picture reads as a star chart; with it, the same points read as a
  // coastline — which is what a reader of an atlas expects to be looking at.
  const hull = smoothClosedPath(convexHull(places.map((place) => [X(place.lng), Y(place.lat)] as [number, number])), 26);
  parts.push(`<path d="${hull}" fill="#8a744d" fill-opacity=".10" filter="url(#soften)"/>`);
  parts.push(`<path d="${hull}" fill="none" stroke="#d9b25a" stroke-opacity=".30" stroke-width="1.6"/>`);
  parts.push(`<path d="${hull}" fill="none" stroke="#d9b25a" stroke-opacity=".12" stroke-width="0.9" transform="translate(0 7) scale(1 0.985)"/>`);

  // Routes as pilgrim paths: the real waypoint order, drawn with a hand-drawn bow.
  for (const route of routes) {
    if (route.points.length < 2) continue;
    const path: string[] = [];
    route.points.forEach((point, index) => {
      const x = X(point.lng);
      const y = Y(point.lat);
      if (index === 0) { path.push(`M${fixed(x)} ${fixed(y)}`); return; }
      const previous = route.points[index - 1]!;
      const px = X(previous.lng);
      const py = Y(previous.lat);
      const bow = (random() - 0.5) * 26;
      path.push(`Q${fixed((px + x) / 2 + bow)} ${fixed((py + y) / 2 - Math.abs(bow) * 0.6)} ${fixed(x)} ${fixed(y)}`);
    });
    parts.push(`<path d="${path.join(" ")}" fill="none" stroke="url(#routeInk)" stroke-width="1.2" stroke-linecap="round" stroke-dasharray="4 7"/>`);
  }

  // Places: a halo scaled by how much the narrative happens there, tinted by the
  // era of that place's earliest event, so the picture carries the timeline.
  //
  // The scale is logarithmic and the halos are small. Jerusalem carries an order
  // of magnitude more events than anywhere else, and on a linear scale its halo
  // swallowed the entire Levant into one bright smear.
  const maxWeight = Math.max(...places.map((place) => place.weight), 1);
  const scaleOf = (weight: number): number => Math.log1p(weight) / Math.log1p(maxWeight);
  for (const place of places) {
    const x = X(place.lng);
    const y = Y(place.lat);
    const scale = scaleOf(place.weight);
    const accent = place.accent ?? "#B5A588";
    parts.push(`<circle cx="${fixed(x)}" cy="${fixed(y)}" r="${fixed(5 + scale * 11)}" fill="url(#glow)" opacity="${fixed(0.10 + scale * 0.13)}"/>`);
    parts.push(`<circle cx="${fixed(x)}" cy="${fixed(y)}" r="${fixed(1.3 + scale * 1.9)}" fill="${accent}" opacity=".9"/>`);
    if (scale > 0.72) {
      parts.push(`<circle cx="${fixed(x)}" cy="${fixed(y)}" r="${fixed(5.5 + scale * 3)}" fill="none" stroke="${accent}" stroke-opacity=".45" stroke-width="0.8"/>`);
    }
  }

  // Wind rose over the centroid.
  const rosePoints: string[] = [];
  for (let index = 0; index < 8; index += 1) {
    const angle = (index / 8) * Math.PI * 2 - Math.PI / 2;
    const long = index % 2 === 0 ? 26 : 15;
    const side = angle + Math.PI / 8;
    rosePoints.push(`M${fixed(hubX)} ${fixed(hubY)} L${fixed(hubX + Math.cos(angle) * long)} ${fixed(hubY + Math.sin(angle) * long)} L${fixed(hubX + Math.cos(side) * 5)} ${fixed(hubY + Math.sin(side) * 5)} Z`);
  }
  parts.push(`<path d="${rosePoints.join(" ")}" fill="#f5c15d" fill-opacity=".22" stroke="#f5c15d" stroke-opacity=".4" stroke-width="0.7"/>`);
  parts.push(`<circle cx="${fixed(hubX)}" cy="${fixed(hubY)}" r="3.2" fill="none" stroke="#f5c15d" stroke-opacity=".5" stroke-width="1"/>`);

  // Manuscript frame: double rule plus an acanthus vine on the long edges.
  parts.push(`<rect x="${PAD - 14}" y="${PAD - 14}" width="${W - (PAD - 14) * 2}" height="${H - (PAD - 14) * 2}" rx="16" fill="none" stroke="#d9b25a" stroke-opacity=".34" stroke-width="1.6"/>`);
  parts.push(`<rect x="${PAD - 8}" y="${PAD - 8}" width="${W - (PAD - 8) * 2}" height="${H - (PAD - 8) * 2}" rx="12" fill="none" stroke="#d9b25a" stroke-opacity=".16" stroke-width="0.9"/>`);
  const leaves: string[] = [];
  for (let x = PAD + 6; x < W - PAD; x += 42) {
    const lift = 5 + random() * 3;
    leaves.push(`M${fixed(x)} ${fixed(PAD - 14)} q${fixed(10)} ${fixed(-lift)} ${fixed(20)} 0 q${fixed(-10)} ${fixed(lift)} ${fixed(-20)} 0z`);
    leaves.push(`M${fixed(x)} ${fixed(H - PAD + 14)} q${fixed(10)} ${fixed(lift)} ${fixed(20)} 0 q${fixed(-10)} ${fixed(-lift)} ${fixed(-20)} 0z`);
  }
  parts.push(`<path d="${leaves.join(" ")}" fill="#d9b25a" fill-opacity=".18"/>`);
  parts.push(`<rect width="${W}" height="${H}" filter="url(#tooth)" opacity=".55"/>`);
  parts.push("</svg>");
  return `${parts.join("\n")}\n`;
}

main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : error);
  process.exitCode = 1;
});
