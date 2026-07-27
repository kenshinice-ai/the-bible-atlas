import { mkdir, writeFile } from "node:fs/promises";
import { resolve } from "node:path";

/**
 * Bake the read-only API into static JSON (deployment plan C).
 *
 * The atlas is baked with detail=full so the front end needs no per-entity
 * detail endpoint: the drawers fall back to the prose already in the atlas.
 * Output goes to apps/web/public/data/, which Vite copies verbatim into dist/,
 * so `vite build` after a bake produces a fully self-contained site.
 *
 * Usage: API must be running (default http://localhost:4000).
 *   npx tsx src/bake-static.ts [--api http://localhost:4000] [--out ../web/public/data]
 */

const args = process.argv.slice(2);
function argValue(flag: string, fallback: string): string {
  const index = args.indexOf(flag);
  return index >= 0 && args[index + 1] ? args[index + 1]! : fallback;
}

const apiBase = argValue("--api", process.env.BAKE_API_URL ?? "http://localhost:4000");
const outDir = resolve(import.meta.dirname, argValue("--out", "../../web/public/data"));
const locales = ["en", "zh-CN"] as const;
// Which works to bake; a profile build passes its own list (comma-separated).
const workSlugs = argValue("--works", "the-bible").split(",").filter(Boolean);

async function fetchJson(path: string): Promise<unknown> {
  const response = await fetch(`${apiBase}${path}`);
  if (!response.ok) throw new Error(`${path} -> HTTP ${response.status}`);
  return response.json();
}

async function bake(): Promise<void> {
  await mkdir(outDir, { recursive: true });
  let files = 0;
  let bytes = 0;
  const write = async (name: string, payload: unknown) => {
    const body = JSON.stringify(payload);
    await writeFile(resolve(outDir, name), body);
    files += 1;
    bytes += Buffer.byteLength(body);
    console.log(`bake: ${name} (${(Buffer.byteLength(body) / 1024).toFixed(1)} KB)`);
  };

  for (const locale of locales) {
    await write(`works.${locale}.json`, await fetchJson(`/api/works?locale=${encodeURIComponent(locale)}`));
    for (const slug of workSlugs) {
      await write(
        `atlas.${slug}.${locale}.json`,
        await fetchJson(`/api/works/${slug}/atlas?locale=${encodeURIComponent(locale)}&detail=full`),
      );
    }
  }
  console.log(`bake: done — ${files} files, ${(bytes / 1024 / 1024).toFixed(2)} MB raw (pre-gzip)`);
}

bake().catch((error: unknown) => {
  console.error("bake failed:", error instanceof Error ? error.message : error);
  console.error("Is the API running? Start it first (see docs/DEPLOYMENT.md quick start).");
  process.exit(1);
});
