import { createHash } from "node:crypto";
import { mkdir, writeFile } from "node:fs/promises";
import { resolve } from "node:path";
import createVerovioModule from "verovio/wasm";
import { VerovioToolkit } from "verovio/esm";
import { COMPOSITIONS, SCORE_FRAGMENTS, assertFoundationCounts } from "./european_music_foundation_data.ts";

assertFoundationCounts();

const root = resolve(import.meta.dirname, "..");
const publicRoot = resolve(root, "apps/web/public");
const scoreDir = resolve(publicRoot, "media/music/scores");
const timingDir = resolve(publicRoot, "media/music/timing");
const audioDir = resolve(publicRoot, "media/music/audio");
const manifestDir = resolve(publicRoot, "media/music/manifests");
const seedPath = resolve(root, "db/seeds/058_european_classical_music_score_fragments.sql");
const refreshSeedPath = resolve(root, "db/seeds/059_european_classical_music_verovio_refresh.sql");
const workId = "10000000-0000-4000-8000-000000000010";
const sourceId = uuid("source", "source-music-atlas-editorial");
const generatedAt = "2026-08-04T00:00:00.000Z";
const sampleRate = 22050;
const verovioModule = await createVerovioModule();
const versionProbe = new VerovioToolkit(verovioModule);
const rendererVersion = `Verovio ${versionProbe.getVersion()}`;

await Promise.all([scoreDir, timingDir, audioDir, manifestDir].map((directory) => mkdir(directory, { recursive: true })));

function uuid(kind, slug) {
  const hex = createHash("sha256").update(`european-classical-music-history:${kind}:${slug}`).digest("hex").slice(0, 32).split("");
  hex[12] = "4";
  hex[16] = ["8", "9", "a", "b"][Number.parseInt(hex[16], 16) % 4];
  const value = hex.join("");
  return `${value.slice(0, 8)}-${value.slice(8, 12)}-${value.slice(12, 16)}-${value.slice(16, 20)}-${value.slice(20)}`;
}

function q(value) {
  if (value === null || value === undefined) return "NULL";
  if (typeof value === "number") return String(value);
  return `'${String(value).replaceAll("'", "''")}'`;
}

function sha256(buffer) {
  return createHash("sha256").update(buffer).digest("hex");
}

function midiToName(midi) {
  const names = ["c", "c", "d", "e", "e", "f", "f", "g", "a", "a", "b", "b"];
  const accid = [null, "s", null, "f", null, null, "s", null, "f", null, "f", null][midi % 12];
  return { pname: names[midi % 12], accid, oct: Math.floor(midi / 12) - 1 };
}

const patternNotes = {
  chant: [60, 62, 64, 65, 67, 65, 64, 62, 60, 62, 64, 67, 65, 64, 62, 60],
  organum: [48, 55, 50, 57, 52, 59, 53, 60, 55, 62, 53, 60, 52, 59, 50, 57],
  polyphony: [60, 64, 62, 65, 64, 67, 65, 69, 67, 71, 69, 72, 71, 69, 67, 65],
  dance: [60, 60, 67, 67, 69, 67, 65, 64, 62, 62, 69, 69, 71, 69, 67, 65],
  continuo: [48, 55, 52, 57, 53, 60, 55, 62, 57, 64, 55, 62, 53, 60, 52, 59],
  classical: [60, 60, 67, 65, 64, 64, 62, 60, 67, 67, 69, 71, 72, 71, 69, 67],
  romantic: [60, 63, 67, 68, 67, 63, 60, 58, 56, 60, 63, 65, 63, 60, 58, 56],
  modern: [60, 61, 67, 66, 62, 69, 63, 70, 64, 71, 65, 72, 66, 73, 67, 74],
};

const patternTempo = { chant: 60, organum: 72, polyphony: 76, dance: 104, continuo: 88, classical: 96, romantic: 72, modern: 84 };
const patternLabel = {
  chant: ["自由流动的单线旋律", "flowing monophonic line"],
  organum: ["持续音与复调层次", "sustained tone and polyphonic layers"],
  polyphony: ["模仿式线条", "imitative linear motion"],
  dance: ["规则脉动与舞曲重音", "regular pulse and dance accents"],
  continuo: ["低音支点与进行", "bass support and sequential motion"],
  classical: ["对称乐句与清晰终止", "balanced phrase and clear cadence"],
  romantic: ["延展旋律与和声张力", "expanded melody and harmonic tension"],
  modern: ["非对称音程与音色化线条", "asymmetric intervals and timbral line"],
};

function makeMei(slug, title, notes) {
  const measures = [];
  for (let measure = 0; measure < 4; measure += 1) {
    const noteXml = notes.slice(measure * 4, measure * 4 + 4).map((midi, index) => {
      const note = midiToName(midi);
      const accidental = note.accid ? ` accid="${note.accid}"` : "";
      return `<note xml:id="${slug}-note-${measure * 4 + index + 1}" pname="${note.pname}" oct="${note.oct}" dur="4"${accidental}/>`;
    }).join("");
    measures.push(`<measure n="${measure + 1}"><staff n="1"><layer n="1">${noteXml}</layer></staff></measure>`);
  }
  return `<?xml version="1.0" encoding="UTF-8"?>
<mei xmlns="http://www.music-encoding.org/ns/mei" meiversion="5.1">
  <meiHead><fileDesc><titleStmt><title>${escapeXml(title)}</title></titleStmt><pubStmt><p>European Classical Music History Atlas editorial study</p></pubStmt></fileDesc></meiHead>
  <music><body><mdiv><score>
    <scoreDef meter.count="4" meter.unit="4"><staffGrp><staffDef n="1" lines="5" clef.shape="G" clef.line="2"/></staffGrp></scoreDef>
    <section>${measures.join("")}</section>
  </score></mdiv></body></music>
</mei>
`;
}

function escapeXml(value) {
  return value.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
}

function makeSvg(mei, slug) {
  const toolkit = new VerovioToolkit(verovioModule);
  toolkit.setOptions({
    pageWidth: 1080,
    pageHeight: 360,
    scale: 45,
    adjustPageHeight: true,
    breaks: "none",
    footer: "none",
    header: "none",
    svgViewBox: true,
    svgRemoveXlink: true,
    xmlIdChecksum: true,
  });
  if (!toolkit.loadData(mei)) throw new Error(`Verovio could not load ${slug}.mei`);
  if (toolkit.getPageCount() !== 1) throw new Error(`Expected one Verovio page for ${slug}`);
  const svg = toolkit.renderToSVG(1);
  if (!svg.includes(`id="${slug}-note-1"`)) throw new Error(`Verovio did not preserve note xml:id values for ${slug}`);
  return `${svg.trim()}\n`;
}

function makeTiming(slug, tempo, notes) {
  const secondsPerBeat = 60 / tempo;
  return {
    fragment: slug,
    tempoBpm: tempo,
    durationSeconds: Number((notes.length * secondsPerBeat).toFixed(3)),
    notes: notes.map((midi, index) => ({
      id: `${slug}-note-${index + 1}`,
      midi,
      start: Number((index * secondsPerBeat).toFixed(3)),
      end: Number(((index + 0.92) * secondsPerBeat).toFixed(3)),
    })),
  };
}

function makeWav(notes, tempo, pattern) {
  const secondsPerBeat = 60 / tempo;
  const duration = notes.length * secondsPerBeat;
  const sampleCount = Math.ceil(duration * sampleRate);
  const pcm = new Int16Array(sampleCount);
  const harmonics = pattern === "modern" ? [1, 0.35, 0.18] : pattern === "chant" ? [1, 0.12] : [1, 0.24, 0.08];
  for (let index = 0; index < notes.length; index += 1) {
    const start = Math.floor(index * secondsPerBeat * sampleRate);
    const end = Math.min(sampleCount, Math.floor((index + 0.94) * secondsPerBeat * sampleRate));
    const frequency = 440 * 2 ** ((notes[index] - 69) / 12);
    for (let sample = start; sample < end; sample += 1) {
      const local = (sample - start) / sampleRate;
      const noteDuration = (end - start) / sampleRate;
      const attack = Math.min(1, local / 0.025);
      const release = Math.min(1, Math.max(0, (noteDuration - local) / 0.08));
      const envelope = attack * release * 0.48;
      let value = 0;
      harmonics.forEach((weight, harmonic) => { value += Math.sin(2 * Math.PI * frequency * (harmonic + 1) * local) * weight; });
      const mixed = pcm[sample] / 32767 + value * envelope / harmonics.reduce((sum, value) => sum + value, 0);
      pcm[sample] = Math.max(-32767, Math.min(32767, Math.round(mixed * 32767)));
    }
  }
  const dataBytes = pcm.length * 2;
  const buffer = Buffer.alloc(44 + dataBytes);
  buffer.write("RIFF", 0);
  buffer.writeUInt32LE(36 + dataBytes, 4);
  buffer.write("WAVE", 8);
  buffer.write("fmt ", 12);
  buffer.writeUInt32LE(16, 16);
  buffer.writeUInt16LE(1, 20);
  buffer.writeUInt16LE(1, 22);
  buffer.writeUInt32LE(sampleRate, 24);
  buffer.writeUInt32LE(sampleRate * 2, 28);
  buffer.writeUInt16LE(2, 32);
  buffer.writeUInt16LE(16, 34);
  buffer.write("data", 36);
  buffer.writeUInt32LE(dataBytes, 40);
  for (let index = 0; index < pcm.length; index += 1) buffer.writeInt16LE(pcm[index], 44 + index * 2);
  return buffer;
}

const sqlRows = [];
const translationRows = [];
const annotationRows = [];
const annotationTranslationRows = [];
const manifestRows = [];
let totalAudioBytes = 0;

for (const [sortOrder, fragment] of SCORE_FRAGMENTS.entries()) {
  const composition = COMPOSITIONS.find((item) => item.slug === fragment.composition);
  if (!composition) throw new Error(`Unknown composition for score fragment: ${fragment.composition}`);
  const notes = patternNotes[fragment.pattern];
  const tempo = patternTempo[fragment.pattern];
  const timing = makeTiming(fragment.slug, tempo, notes);
  const title = `${composition.en} · ${patternLabel[fragment.pattern][1]}`;
  const mei = Buffer.from(makeMei(fragment.slug, title, notes));
  const svg = Buffer.from(makeSvg(mei.toString(), fragment.slug));
  const timingBuffer = Buffer.from(`${JSON.stringify(timing, null, 2)}\n`);
  const wav = makeWav(notes, tempo, fragment.pattern);
  totalAudioBytes += wav.length;

  const meiPath = `/media/music/scores/${fragment.slug}.mei`;
  const svgPath = `/media/music/scores/${fragment.slug}.svg`;
  const timingPath = `/media/music/timing/${fragment.slug}.json`;
  const audioPath = `/media/music/audio/${fragment.slug}.wav`;
  const manifestPath = `/media/music/manifests/${fragment.slug}.json`;
  const manifest = {
    fragment: fragment.slug,
    composition: fragment.composition,
    generatorVersion: "atlas-music-study-v2",
    renderer: rendererVersion,
    synthesisProfile: `neutral-${fragment.pattern}-v1`,
    generatedAt,
    sampleRate,
    channels: 1,
    bitDepth: 16,
    outputFormat: "wav",
    durationSeconds: timing.durationSeconds,
    checksums: { mei: sha256(mei), svg: sha256(svg), timing: sha256(timingBuffer), audio: sha256(wav) },
  };
  const manifestBuffer = Buffer.from(`${JSON.stringify(manifest, null, 2)}\n`);

  await Promise.all([
    writeFile(resolve(scoreDir, `${fragment.slug}.mei`), mei),
    writeFile(resolve(scoreDir, `${fragment.slug}.svg`), svg),
    writeFile(resolve(timingDir, `${fragment.slug}.json`), timingBuffer),
    writeFile(resolve(audioDir, `${fragment.slug}.wav`), wav),
    writeFile(resolve(manifestDir, `${fragment.slug}.json`), manifestBuffer),
  ]);

  const fragmentId = uuid("score-fragment", fragment.slug);
  sqlRows.push([
    q(fragmentId), q(workId), q(uuid("composition", fragment.composition)), q(fragment.slug),
    fragment.measures[0], fragment.measures[1], q(fragment.pattern === "chant" ? "neume" : ["organum", "polyphony"].includes(fragment.pattern) ? "mensural" : "common"),
    q(meiPath), q(svgPath), q(timingPath), q(audioPath), timing.durationSeconds, tempo, q("editorial_learning"), q("verified"), q(sourceId), sortOrder + 1,
  ]);
  translationRows.push(
    [q(fragmentId), q("zh-CN"), q(`${composition.zh} · ${patternLabel[fragment.pattern][0]}`), q("四小节代表性分析片段。"), q(`本片段以${patternLabel[fragment.pattern][0]}为教学重点，乐谱与声音均由同一组 note data 生成。`), q("学习用自产合成音，不代表历史演奏、真实乐器音色或权威速度。"), q("published")],
    [q(fragmentId), q("en"), q(title), q("A four-measure representative analytical study."), q(`This excerpt focuses on ${patternLabel[fragment.pattern][1]}; notation and audio are generated from the same note data.`), q("Project-generated learning audio; it does not represent historical performance, authentic instrument timbre, or an authoritative tempo."), q("published")],
  );
  for (let annotationIndex = 0; annotationIndex < 2; annotationIndex += 1) {
    const annotationId = uuid("score-annotation", `${fragment.slug}-${annotationIndex + 1}`);
    annotationRows.push([q(annotationId), q(fragmentId), q(`${fragment.slug}-note-${annotationIndex * 8 + 1}`), annotationIndex * 8, annotationIndex * 8 + 4, q(annotationIndex === 0 ? "opening_gesture" : "continuation"), annotationIndex + 1]);
    annotationTranslationRows.push(
      [q(annotationId), q("zh-CN"), q(annotationIndex === 0 ? "开头动机" : "后半延展"), q(annotationIndex === 0 ? "观察片段如何建立最初的音程和脉动。" : "观察后半段如何延展或改变最初材料。"), q("published")],
      [q(annotationId), q("en"), q(annotationIndex === 0 ? "Opening gesture" : "Second-half continuation"), q(annotationIndex === 0 ? "Observe how the excerpt establishes its initial interval and pulse." : "Observe how the second half extends or changes the opening material."), q("published")],
    );
  }
  manifestRows.push([
    q(fragmentId), q(manifest.checksums.mei), q(manifest.checksums.svg), q(manifest.checksums.timing), q(manifest.checksums.audio),
    q(manifest.generatorVersion), q(manifest.renderer), q(manifest.synthesisProfile), sampleRate, 1, 16, q("wav"), q(generatedAt), q(manifestPath),
  ]);
}

if (totalAudioBytes > 40 * 1024 * 1024) throw new Error(`Audio budget exceeded: ${totalAudioBytes} bytes`);

function values(rows) {
  return rows.map((row) => `(${row.join(",")})`).join(",\n");
}

const sql = `BEGIN;

INSERT INTO score_fragments(id,work_id,composition_id,slug,start_measure,end_measure,notation_kind,mei_asset_path,svg_asset_path,timing_asset_path,audio_asset_path,duration_seconds,tempo_bpm,tempo_basis,rights_status,source_id,sort_order) VALUES
${values(sqlRows)}
ON CONFLICT DO NOTHING;

INSERT INTO score_fragment_translations(fragment_id,locale,title,summary,analysis_note,playback_disclaimer,status) VALUES
${values(translationRows)}
ON CONFLICT DO NOTHING;

INSERT INTO score_annotations(id,fragment_id,target_xml_id,start_beat,end_beat,annotation_type,sort_order) VALUES
${values(annotationRows)}
ON CONFLICT DO NOTHING;

INSERT INTO score_annotation_translations(annotation_id,locale,label,explanation,status) VALUES
${values(annotationTranslationRows)}
ON CONFLICT DO NOTHING;

INSERT INTO score_generation_manifests(fragment_id,mei_checksum_sha256,svg_checksum_sha256,timing_checksum_sha256,audio_checksum_sha256,generator_version,renderer_version,synthesis_profile,sample_rate,channels,bit_depth,output_format,generated_at,manifest_path) VALUES
${values(manifestRows)}
ON CONFLICT DO NOTHING;

COMMIT;
`;

await writeFile(seedPath, sql);
const refreshSql = `BEGIN;

INSERT INTO score_generation_manifests(fragment_id,mei_checksum_sha256,svg_checksum_sha256,timing_checksum_sha256,audio_checksum_sha256,generator_version,renderer_version,synthesis_profile,sample_rate,channels,bit_depth,output_format,generated_at,manifest_path) VALUES
${values(manifestRows)}
ON CONFLICT (fragment_id) DO UPDATE SET
  mei_checksum_sha256=EXCLUDED.mei_checksum_sha256,
  svg_checksum_sha256=EXCLUDED.svg_checksum_sha256,
  timing_checksum_sha256=EXCLUDED.timing_checksum_sha256,
  audio_checksum_sha256=EXCLUDED.audio_checksum_sha256,
  generator_version=EXCLUDED.generator_version,
  renderer_version=EXCLUDED.renderer_version,
  synthesis_profile=EXCLUDED.synthesis_profile,
  sample_rate=EXCLUDED.sample_rate,
  channels=EXCLUDED.channels,
  bit_depth=EXCLUDED.bit_depth,
  output_format=EXCLUDED.output_format,
  generated_at=EXCLUDED.generated_at,
  manifest_path=EXCLUDED.manifest_path;

COMMIT;
`;
await writeFile(refreshSeedPath, refreshSql);
console.log(`generated ${SCORE_FRAGMENTS.length} score/audio fragments`);
console.log(`renderer: ${rendererVersion}`);
console.log(`audio bytes: ${totalAudioBytes}`);
console.log(`seed: ${seedPath}`);
console.log(`refresh seed: ${refreshSeedPath}`);
