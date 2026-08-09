import { createHash } from "node:crypto";
import { readFile, readdir } from "node:fs/promises";
import { resolve } from "node:path";
import pg from "pg";

const root = resolve(import.meta.dirname, "..");
const mediaRoot = resolve(root, "apps/web/public/media/music");
const expectedCount = 56;

type Manifest = {
  fragment: string;
  generatorVersion: string;
  renderer: string;
  synthesisProfile: string;
  sampleRate: number;
  channels: number;
  bitDepth: number;
  outputFormat: string;
  durationSeconds: number;
  checksums: Record<"mei" | "svg" | "timing" | "audio", string>;
};

function assert(condition: unknown, message: string): asserts condition {
  if (!condition) throw new Error(message);
}

function sha256(buffer: Buffer): string {
  return createHash("sha256").update(buffer).digest("hex");
}

function noteIds(text: string, fragment: string): string[] {
  return Array.from(text.matchAll(new RegExp(`${fragment}-note-[0-9]+`, "gu")), (match) => match[0]);
}

const directories = {
  mei: ["scores", "mei"],
  svg: ["scores", "svg"],
  timing: ["timing", "json"],
  audio: ["audio", "wav"],
  manifest: ["manifests", "json"],
} as const;

async function main() {
const seed058 = await readFile(resolve(root, "db/seeds/058_european_classical_music_score_fragments.sql"), "utf8");
const seed059 = await readFile(resolve(root, "db/seeds/059_european_classical_music_verovio_refresh.sql"), "utf8");
const seed061 = await readFile(resolve(root, "db/seeds/061_european_classical_music_phase2_score_fragments.sql"), "utf8");
const seed062 = await readFile(resolve(root, "db/seeds/062_european_classical_music_phase2_verovio_refresh.sql"), "utf8");

for (const [kind, [directory, extension]] of Object.entries(directories)) {
  const files = (await readdir(resolve(mediaRoot, directory))).filter((file) => file.endsWith(`.${extension}`));
  assert(files.length === expectedCount, `${kind}: expected ${expectedCount} files, found ${files.length}`);
}

const manifestFiles = (await readdir(resolve(mediaRoot, "manifests"))).filter((file) => file.endsWith(".json")).sort();
const manifests = new Map<string, Manifest>();
let totalAudioBytes = 0;

for (const filename of manifestFiles) {
  const manifest = JSON.parse(await readFile(resolve(mediaRoot, "manifests", filename), "utf8")) as Manifest;
  assert(filename === `${manifest.fragment}.json`, `manifest filename mismatch: ${filename}`);
  assert(manifest.generatorVersion === "atlas-music-study-v2", `${manifest.fragment}: old generator version`);
  assert(/^Verovio 6[.]/u.test(manifest.renderer), `${manifest.fragment}: SVG renderer is not Verovio 6.x`);
  assert(manifest.sampleRate === 22050 && manifest.channels === 1 && manifest.bitDepth === 16 && manifest.outputFormat === "wav", `${manifest.fragment}: invalid audio profile`);
  assert(manifest.durationSeconds >= 8 && manifest.durationSeconds <= 30, `${manifest.fragment}: duration outside 8–30 seconds`);

  const buffers = {
    mei: await readFile(resolve(mediaRoot, "scores", `${manifest.fragment}.mei`)),
    svg: await readFile(resolve(mediaRoot, "scores", `${manifest.fragment}.svg`)),
    timing: await readFile(resolve(mediaRoot, "timing", `${manifest.fragment}.json`)),
    audio: await readFile(resolve(mediaRoot, "audio", `${manifest.fragment}.wav`)),
  };
  totalAudioBytes += buffers.audio.length;
  for (const kind of ["mei", "svg", "timing", "audio"] as const) {
    assert(sha256(buffers[kind]) === manifest.checksums[kind], `${manifest.fragment}: ${kind} checksum mismatch`);
  }

  const mei = buffers.mei.toString("utf8");
  const svg = buffers.svg.toString("utf8");
  const timing = JSON.parse(buffers.timing.toString("utf8")) as { durationSeconds: number; notes: Array<{ id: string }> };
  assert(svg.includes("Engraved by Verovio"), `${manifest.fragment}: SVG lacks Verovio provenance`);
  const meiIds = [...new Set(noteIds(mei, manifest.fragment))].sort();
  const svgIds = [...new Set(noteIds(svg, manifest.fragment))].sort();
  const timingIds = [...new Set(timing.notes.map((note) => note.id))].sort();
  assert(meiIds.length === 16, `${manifest.fragment}: expected 16 MEI note ids`);
  assert(JSON.stringify(svgIds) === JSON.stringify(meiIds), `${manifest.fragment}: Verovio SVG note ids differ from MEI`);
  assert(JSON.stringify(timingIds) === JSON.stringify(meiIds), `${manifest.fragment}: timing note ids differ from MEI`);
  assert(Math.abs(timing.durationSeconds - manifest.durationSeconds) < 0.001, `${manifest.fragment}: timing/manifest duration mismatch`);

  assert(buffers.audio.toString("ascii", 0, 4) === "RIFF" && buffers.audio.toString("ascii", 8, 12) === "WAVE", `${manifest.fragment}: invalid WAV header`);
  const channels = buffers.audio.readUInt16LE(22);
  const sampleRate = buffers.audio.readUInt32LE(24);
  const bitDepth = buffers.audio.readUInt16LE(34);
  const dataBytes = buffers.audio.readUInt32LE(40);
  const wavDuration = dataBytes / (sampleRate * channels * (bitDepth / 8));
  assert(channels === 1 && sampleRate === 22050 && bitDepth === 16, `${manifest.fragment}: WAV format mismatch`);
  assert(Math.abs(wavDuration - manifest.durationSeconds) < 0.01, `${manifest.fragment}: WAV duration mismatch`);

  for (const checksum of Object.values(manifest.checksums)) {
    const foundationSeed = seed058.includes(manifest.fragment) && seed058.includes(checksum) && seed059.includes(checksum);
    const phase2Seed = seed061.includes(manifest.fragment) && seed061.includes(checksum) && seed062.includes(checksum);
    assert(foundationSeed || phase2Seed, `${manifest.fragment}: checksum missing from its SQL seed pair`);
  }
  manifests.set(manifest.fragment, manifest);
}

assert(totalAudioBytes <= 40 * 1024 * 1024, `audio budget exceeded: ${totalAudioBytes}`);

if (process.env.DATABASE_URL) {
  const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });
  try {
    const counts = await pool.query<{ metric: string; count: number }>(`
      SELECT 'people' metric,count(*)::int FROM music_person_profiles
      UNION ALL SELECT 'compositions',count(*)::int FROM compositions
      UNION ALL SELECT 'styles',count(*)::int FROM music_styles
      UNION ALL SELECT 'instruments',count(*)::int FROM instruments
      UNION ALL SELECT 'institutions',count(*)::int FROM music_institutions
      UNION ALL SELECT 'fragments',count(*)::int FROM score_fragments
      UNION ALL SELECT 'events',count(*)::int FROM events WHERE work_id='10000000-0000-4000-8000-000000000010'
      UNION ALL SELECT 'relations',count(*)::int FROM character_relations WHERE work_id='10000000-0000-4000-8000-000000000010'
      UNION ALL SELECT 'routes',count(*)::int FROM routes WHERE work_id='10000000-0000-4000-8000-000000000010'
      UNION ALL SELECT 'learningUnits',count(*)::int FROM music_learning_units WHERE work_id='10000000-0000-4000-8000-000000000010'
      UNION ALL SELECT 'crossWorkLinks',count(*)::int FROM music_cross_work_link_audit
    `);
    const expected = { people: 72, compositions: 120, styles: 32, instruments: 36, institutions: 24, fragments: 56, events: 180, relations: 160, routes: 12, learningUnits: 12, crossWorkLinks: 0 };
    for (const row of counts.rows) {
      assert(row.count === expected[row.metric as keyof typeof expected], `${row.metric}: database count ${row.count} is incorrect`);
    }

    const rows = await pool.query<{
      slug: string; mei: string; svg: string; timing: string; audio: string;
      generator: string; renderer: string; sampleRate: number; channels: number; bitDepth: number; outputFormat: string;
    }>(`
      SELECT sf.slug,gm.mei_checksum_sha256 mei,gm.svg_checksum_sha256 svg,
        gm.timing_checksum_sha256 timing,gm.audio_checksum_sha256 audio,
        gm.generator_version generator,gm.renderer_version renderer,
        gm.sample_rate AS "sampleRate",gm.channels,gm.bit_depth AS "bitDepth",gm.output_format AS "outputFormat"
      FROM score_fragments sf JOIN score_generation_manifests gm ON gm.fragment_id=sf.id
      WHERE sf.work_id='10000000-0000-4000-8000-000000000010'
      ORDER BY sf.sort_order
    `);
    assert(rows.rows.length === expectedCount, `database: expected ${expectedCount} manifests`);
    for (const row of rows.rows) {
      const manifest = manifests.get(row.slug);
      assert(manifest, `database: unknown fragment ${row.slug}`);
      assert(row.mei === manifest.checksums.mei && row.svg === manifest.checksums.svg && row.timing === manifest.checksums.timing && row.audio === manifest.checksums.audio, `${row.slug}: database checksum mismatch`);
      assert(row.generator === manifest.generatorVersion && row.renderer === manifest.renderer, `${row.slug}: database generator metadata mismatch`);
      assert(row.sampleRate === 22050 && row.channels === 1 && row.bitDepth === 16 && row.outputFormat === "wav", `${row.slug}: database audio profile mismatch`);
    }
  } finally {
    await pool.end();
  }
}

console.log(`European classical music assets: PASS (${manifests.size} complete fragment bundles, ${(totalAudioBytes / 1024 / 1024).toFixed(1)} MiB audio)`);
}

main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
