import { createHash } from "node:crypto";
import { mkdir, readFile, writeFile } from "node:fs/promises";
import { join, resolve } from "node:path";
import pg from "pg";
import {
  BIBLE_WORK_ID, BOOK_NAMES, CHAPTER_EMBLEMS, CHARACTER_EMBLEMS, CHARACTER_QUOTES,
  EVENT_SCRIPTURE_REFS, MUSIC_LINKS, MUSIC_WORK_ID, OSIS_TO_API,
} from "./data/bible_art_music_data.js";

/**
 * Builder for seeds 068–070 (Bible art/music upgrade).
 *
 * The interesting part is not the SQL: it is that every scripture reference and
 * every quoted excerpt is checked against a public-domain text before it is
 * allowed into the seed. A reference must resolve to verses that exist, and an
 * excerpt must be a literal contiguous substring of the retrieved verse — the
 * same containment rule the Shanhaijing corpus applies to its occurrence
 * quotes. A quote that cannot be proved this way never reaches the database
 * with `source_verified`, and a mistyped reference stops the build.
 *
 * Usage:
 *   DATABASE_URL=postgresql:///literary_atlas npx tsx scripts/generate_bible_art_music.ts
 */
const ROOT = resolve(process.env.ATLAS_PROJECT_ROOT ?? process.cwd());
const DATABASE_URL = process.env.DATABASE_URL ?? "postgresql://llmacbookpro@localhost:5432/literary_atlas";
const CACHE_DIR = resolve(process.env.SCRIPTURE_CACHE_DIR ?? join(ROOT, ".cache/scripture"));
const API_BASE = "https://bible-api.com/data";
const RETRIEVED_AT = process.env.SCRIPTURE_RETRIEVED_AT ?? "2026-08-18T00:00:00Z";

const sha256 = (text: string): string => createHash("sha256").update(text).digest("hex");
const q = (value: string): string => `'${value.replace(/'/gu, "''")}'`;
/** Deterministic UUID from a seed string, matching the seeds' pg_temp helper. */
function stableUuid(seed: string): string {
  const hex = createHash("md5").update(seed).digest("hex");
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-4${hex.slice(13, 16)}-8${hex.slice(17, 20)}-${hex.slice(20, 32)}`;
}

type Verse = { verse: number; text: string };
const chapterCache = new Map<string, Verse[]>();

/** Collapse the source's line breaks so an excerpt can be matched literally. */
const normalize = (text: string): string => text.replace(/\s+/gu, " ").trim();

/**
 * Drop the CUV's inline critical apparatus before testing containment.
 * 〔…〕 holds an alternative rendering the 1919 editors printed inside the
 * verse; it is a critical mark, not translated text, so quoting across it is
 * legitimate. Matching the raw string instead would truncate John 1:29 at
 * "Behold, the Lamb of God" for Chinese readers only.
 */
const withoutApparatus = (text: string): string => text.replace(/〔[^〕]*〕/gu, "");

const sleep = (ms: number): Promise<void> => new Promise((done) => setTimeout(done, ms));

/** The public verse API rate-limits; retrieval is slow on purpose and cached. */
async function fetchChapter(url: string): Promise<unknown> {
  for (let attempt = 1; attempt <= 6; attempt += 1) {
    const response = await fetch(url);
    if (response.ok) return response.json();
    if (response.status !== 429 && response.status < 500) throw new Error(`${url} returned HTTP ${response.status}`);
    const wait = 2000 * 2 ** (attempt - 1);
    console.log(`  ${url} -> HTTP ${response.status}; retrying in ${wait / 1000}s`);
    await sleep(wait);
  }
  throw new Error(`${url} kept failing after 6 attempts`);
}

async function loadChapter(translation: "web" | "cuv", apiBook: string, chapter: number): Promise<Verse[]> {
  const key = `${translation}-${apiBook}-${chapter}`;
  const cached = chapterCache.get(key);
  if (cached) return cached;
  const file = join(CACHE_DIR, `${key}.json`);
  const onDisk = await readFile(file, "utf8").catch(() => null);
  let payload: { verses?: { verse: number; text: string }[] };
  if (onDisk) payload = JSON.parse(onDisk) as typeof payload;
  else {
    const url = `${API_BASE}/${translation}/${apiBook}/${chapter}`;
    payload = (await fetchChapter(url)) as typeof payload;
    await mkdir(CACHE_DIR, { recursive: true });
    await writeFile(file, JSON.stringify(payload), "utf8");
    await sleep(1200);
  }
  const verses = (payload.verses ?? []).map((row) => ({ verse: row.verse, text: normalize(row.text) }));
  if (verses.length === 0) throw new Error(`no verses for ${key}`);
  chapterCache.set(key, verses);
  return verses;
}

function verseUrl(translation: "web" | "cuv", apiBook: string, chapter: number, verse: number): string {
  return `${API_BASE}/${translation}/${apiBook}/${chapter}/${verse}`;
}

type ParsedRef = { book: string; chapter: number; verseStart: number | null; verseEnd: number | null };

function parseOsis(osis: string): ParsedRef {
  const [start, end] = osis.split("-");
  const startParts = start!.split(".");
  const book = startParts[0]!;
  const chapter = Number(startParts[1]);
  const verseStart = startParts[2] === undefined ? null : Number(startParts[2]);
  let verseEnd = verseStart;
  if (end !== undefined) {
    const endParts = end.split(".");
    if (endParts[0] !== book) throw new Error(`${osis} spans two books; the contract expects one`);
    if (Number(endParts[1]) !== chapter) throw new Error(`${osis} spans two chapters; split it into two references`);
    verseEnd = Number(endParts[2]);
  }
  if (!Number.isInteger(chapter) || chapter < 1) throw new Error(`${osis} has an unusable chapter`);
  return { book, chapter, verseStart, verseEnd };
}

const failures: string[] = [];

async function main(): Promise<void> {
  const pool = new pg.Pool({ connectionString: DATABASE_URL });
  try {
    const idOf = async (table: string, workId: string): Promise<Map<string, string>> => {
      const rows = await pool.query<{ slug: string; id: string }>(`SELECT slug,id FROM ${table} WHERE work_id=$1`, [workId]);
      return new Map(rows.rows.map((row) => [row.slug, row.id]));
    };
    const [characters, events, locations, chapters, compositions] = await Promise.all([
      idOf("characters", BIBLE_WORK_ID), idOf("events", BIBLE_WORK_ID), idOf("locations", BIBLE_WORK_ID),
      idOf("chapters", BIBLE_WORK_ID), idOf("compositions", MUSIC_WORK_ID),
    ]);
    const fragmentRows = await pool.query<{ composition_slug: string; count: string }>(
      `SELECT c.slug AS composition_slug, count(*) AS count FROM score_fragments f
         JOIN compositions c ON c.id=f.composition_id
        WHERE f.work_id=$1 AND f.audio_asset_path IS NOT NULL GROUP BY c.slug`, [MUSIC_WORK_ID]);
    const playable = new Set(fragmentRows.rows.map((row) => row.composition_slug));

    // ---- 068 emblems -----------------------------------------------------
    const emblemSql: string[] = [
      "BEGIN;", "",
      "-- Bible emblems (plan docs/BIBLE_ART_MUSIC_UPGRADE_PLAN_2026-08-18.md, track A1/D2).",
      "-- Generated by scripts/generate_bible_art_music.ts. Symbolic identity only:",
      "-- no row here claims to record what anyone looked like.", "",
    ];
    for (const [index, emblem] of CHARACTER_EMBLEMS.entries()) {
      const id = characters.get(emblem.character);
      if (!id) { failures.push(`emblem: unknown character ${emblem.character}`); continue; }
      emblemSql.push(
        `INSERT INTO character_emblems(character_id,work_id,symbol_key,ring_key,ground_key,attestation,sort_order) VALUES`,
        `  ('${id}','${BIBLE_WORK_ID}',${q(emblem.symbol)},${q(emblem.ring)},${q(emblem.ground)},${q(emblem.attestation)},${index + 1})`,
        `ON CONFLICT (character_id) DO UPDATE SET symbol_key=EXCLUDED.symbol_key,ring_key=EXCLUDED.ring_key,ground_key=EXCLUDED.ground_key,attestation=EXCLUDED.attestation,sort_order=EXCLUDED.sort_order;`,
        `INSERT INTO character_emblem_translations(character_id,locale,symbol_name,symbol_meaning,attribution_note,status) VALUES`,
        `  ('${id}','zh-CN',${q(emblem.nameZh)},${q(emblem.meaningZh)},${q(emblem.noteZh)},'published'),`,
        `  ('${id}','en',${q(emblem.nameEn)},${q(emblem.meaningEn)},${q(emblem.noteEn)},'published')`,
        `ON CONFLICT (character_id,locale) DO UPDATE SET symbol_name=EXCLUDED.symbol_name,symbol_meaning=EXCLUDED.symbol_meaning,attribution_note=EXCLUDED.attribution_note,status=EXCLUDED.status;`,
        "",
      );
    }
    for (const [index, emblem] of CHAPTER_EMBLEMS.entries()) {
      const id = chapters.get(emblem.chapter);
      if (!id) { failures.push(`era emblem: unknown chapter ${emblem.chapter}`); continue; }
      emblemSql.push(
        `INSERT INTO chapter_emblems(chapter_id,work_id,symbol_key,sort_order) VALUES ('${id}','${BIBLE_WORK_ID}',${q(emblem.symbol)},${index + 1})`,
        `ON CONFLICT (chapter_id) DO UPDATE SET symbol_key=EXCLUDED.symbol_key,sort_order=EXCLUDED.sort_order;`,
        `INSERT INTO chapter_emblem_translations(chapter_id,locale,symbol_name,symbol_meaning,status) VALUES`,
        `  ('${id}','zh-CN',${q(emblem.nameZh)},${q(emblem.meaningZh)},'published'),`,
        `  ('${id}','en',${q(emblem.nameEn)},${q(emblem.meaningEn)},'published')`,
        `ON CONFLICT (chapter_id,locale) DO UPDATE SET symbol_name=EXCLUDED.symbol_name,symbol_meaning=EXCLUDED.symbol_meaning,status=EXCLUDED.status;`,
        "",
      );
    }
    emblemSql.push("COMMIT;");

    // ---- 069 scripture references and quotes ------------------------------
    const scriptureSql: string[] = [
      "BEGIN;", "",
      "-- Bible scripture references and quotes (track B1/B2).",
      "-- Generated by scripts/generate_bible_art_music.ts. Every reference below",
      "-- resolved against a public-domain text at build time, and every excerpt",
      "-- was proved to be a literal substring of the verse it cites.", "",
    ];
    for (const [index, ref] of EVENT_SCRIPTURE_REFS.entries()) {
      const eventId = events.get(ref.event);
      if (!eventId) { failures.push(`scripture ref: unknown event ${ref.event}`); continue; }
      const parsed = parseOsis(ref.osis);
      const apiBook = OSIS_TO_API[parsed.book];
      if (!apiBook) { failures.push(`scripture ref: no API book id for ${parsed.book}`); continue; }
      const verses = await loadChapter("web", apiBook, parsed.chapter);
      const available = new Set(verses.map((verse) => verse.verse));
      for (const verse of [parsed.verseStart, parsed.verseEnd]) {
        if (verse !== null && !available.has(verse)) failures.push(`scripture ref ${ref.osis} (${ref.event}): verse ${verse} does not exist in the source chapter`);
      }
      const id = stableUuid(`bible:scripture-ref:${ref.event}:${ref.osis}`);
      scriptureSql.push(
        `INSERT INTO event_scripture_refs(id,event_id,work_id,osis_ref,book_osis,chapter_number,verse_start,verse_end,ref_role,sort_order) VALUES`,
        `  ('${id}','${eventId}','${BIBLE_WORK_ID}',${q(ref.osis)},${q(parsed.book)},${parsed.chapter},${parsed.verseStart ?? "NULL"},${parsed.verseEnd ?? "NULL"},${q(ref.role)},${index + 1})`,
        `ON CONFLICT (id) DO UPDATE SET osis_ref=EXCLUDED.osis_ref,book_osis=EXCLUDED.book_osis,chapter_number=EXCLUDED.chapter_number,verse_start=EXCLUDED.verse_start,verse_end=EXCLUDED.verse_end,ref_role=EXCLUDED.ref_role,sort_order=EXCLUDED.sort_order;`,
        "",
      );
    }

    let verifiedQuotes = 0;
    for (const [index, quote] of CHARACTER_QUOTES.entries()) {
      const characterId = characters.get(quote.character);
      if (!characterId) { failures.push(`quote: unknown character ${quote.character}`); continue; }
      const parsed = parseOsis(quote.osis);
      const apiBook = OSIS_TO_API[parsed.book];
      const book = BOOK_NAMES[parsed.book];
      if (!apiBook || !book) { failures.push(`quote: no book mapping for ${parsed.book}`); continue; }
      if (parsed.verseStart === null) { failures.push(`quote ${quote.osis} must name a verse`); continue; }

      const rendered: { locale: "zh-CN" | "en"; text: string; edition: string; script: string; verse: string; url: string; label: string; context: string }[] = [];
      for (const [locale, translation, excerpt] of [["zh-CN", "cuv", quote.zh], ["en", "web", quote.en]] as const) {
        const verses = await loadChapter(translation, apiBook, parsed.chapter);
        const row = verses.find((item) => item.verse === parsed.verseStart);
        if (!row) { failures.push(`quote ${quote.osis} (${locale}): verse missing from source`); continue; }
        if (!withoutApparatus(row.text).includes(excerpt)) {
          failures.push(`quote ${quote.osis} (${locale}) excerpt is not contained in the source verse.\n    excerpt: ${excerpt}\n    verse:   ${row.text}`);
          continue;
        }
        rendered.push({
          locale, text: excerpt,
          edition: translation === "cuv" ? "CUV-1919" : "WEB",
          script: translation === "cuv" ? "han-traditional" : "na",
          verse: row.text,
          url: verseUrl(translation, apiBook, parsed.chapter, parsed.verseStart),
          label: locale === "zh-CN"
            ? `${book.zh} ${parsed.chapter}:${parsed.verseStart}`
            : `${book.en} ${parsed.chapter}:${parsed.verseStart}`,
          context: locale === "zh-CN" ? quote.contextZh : quote.contextEn,
        });
      }
      if (rendered.length !== 2) continue;
      verifiedQuotes += 1;

      const id = stableUuid(`bible:quote:${quote.character}:${quote.osis}`);
      const eventId = quote.event ? events.get(quote.event) : undefined;
      if (quote.event && !eventId) failures.push(`quote ${quote.osis}: unknown event ${quote.event}`);
      scriptureSql.push(
        `INSERT INTO character_quotes(id,character_id,work_id,event_id,osis_ref,speech_kind,importance,sort_order) VALUES`,
        `  ('${id}','${characterId}','${BIBLE_WORK_ID}',${eventId ? `'${eventId}'` : "NULL"},${q(quote.osis)},${q(quote.kind)},${quote.importance},${index + 1})`,
        `ON CONFLICT (id) DO UPDATE SET event_id=EXCLUDED.event_id,osis_ref=EXCLUDED.osis_ref,speech_kind=EXCLUDED.speech_kind,importance=EXCLUDED.importance,sort_order=EXCLUDED.sort_order;`,
        `INSERT INTO character_quote_translations(quote_id,locale,quote_text,reference_label,context_note,translation_edition,script_variant,text_status,text_sha256,source_verse_text,source_verse_sha256,verified_source_url,verified_at,status) VALUES`,
        ...rendered.map((item, position) =>
          `  ('${id}',${q(item.locale)},${q(item.text)},${q(item.label)},${q(item.context)},${q(item.edition)},${q(item.script)},'source_verified',${q(sha256(item.text))},${q(item.verse)},${q(sha256(item.verse))},${q(item.url)},'${RETRIEVED_AT}'::timestamptz,'published')${position === rendered.length - 1 ? "" : ","}`),
        `ON CONFLICT (quote_id,locale) DO UPDATE SET quote_text=EXCLUDED.quote_text,reference_label=EXCLUDED.reference_label,context_note=EXCLUDED.context_note,translation_edition=EXCLUDED.translation_edition,script_variant=EXCLUDED.script_variant,text_status=EXCLUDED.text_status,text_sha256=EXCLUDED.text_sha256,source_verse_text=EXCLUDED.source_verse_text,source_verse_sha256=EXCLUDED.source_verse_sha256,verified_source_url=EXCLUDED.verified_source_url,verified_at=EXCLUDED.verified_at,status=EXCLUDED.status;`,
        "",
      );
    }
    scriptureSql.push("COMMIT;");

    // ---- 070 cross-work music links --------------------------------------
    const musicSql: string[] = [
      "BEGIN;", "",
      "-- Bible ↔ European classical music reception links (track C1).",
      "-- Generated by scripts/generate_bible_art_music.ts. No new audio is added:",
      "-- these point at score fragments the music atlas already renders and",
      "-- synthesises, which stay labelled as study audio, not historical sound.", "",
    ];
    for (const [index, link] of MUSIC_LINKS.entries()) {
      const source = link.fromKind === "character" ? characters : link.fromKind === "event" ? events : locations;
      const fromId = source.get(link.from);
      const toId = compositions.get(link.composition);
      if (!fromId) { failures.push(`music link: unknown ${link.fromKind} ${link.from}`); continue; }
      if (!toId) { failures.push(`music link: unknown composition ${link.composition}`); continue; }
      if (!playable.has(link.composition)) { failures.push(`music link: composition ${link.composition} has no playable fragment`); continue; }
      const id = stableUuid(`bible:music-link:${link.from}:${link.composition}`);
      musicSql.push(
        `INSERT INTO cross_work_links(id,from_work_id,from_entity_kind,from_entity_id,to_work_id,to_entity_kind,to_entity_id,link_type,confidence,sort_order) VALUES`,
        `  ('${id}','${BIBLE_WORK_ID}',${q(link.fromKind)},'${fromId}','${MUSIC_WORK_ID}','composition','${toId}',${q(link.linkType)},'high',${index + 1})`,
        `ON CONFLICT (id) DO UPDATE SET link_type=EXCLUDED.link_type,confidence=EXCLUDED.confidence,sort_order=EXCLUDED.sort_order;`,
        `INSERT INTO cross_work_link_translations(link_id,locale,label,basis_note,status) VALUES`,
        `  ('${id}','zh-CN',${q(link.labelZh)},${q(link.basisZh)},'published'),`,
        `  ('${id}','en',${q(link.labelEn)},${q(link.basisEn)},'published')`,
        `ON CONFLICT (link_id,locale) DO UPDATE SET label=EXCLUDED.label,basis_note=EXCLUDED.basis_note,status=EXCLUDED.status;`,
        "",
      );
    }
    musicSql.push("COMMIT;");

    if (failures.length > 0) {
      console.error(`Refusing to emit seeds; ${failures.length} editorial checks failed:`);
      for (const failure of failures) console.error(`  - ${failure}`);
      process.exitCode = 1;
      return;
    }

    await writeFile(join(ROOT, "db/seeds/068_bible_emblems.sql"), `${emblemSql.join("\n")}\n`, "utf8");
    await writeFile(join(ROOT, "db/seeds/069_bible_scripture_and_quotes.sql"), `${scriptureSql.join("\n")}\n`, "utf8");
    await writeFile(join(ROOT, "db/seeds/070_bible_music_cross_links.sql"), `${musicSql.join("\n")}\n`, "utf8");
    console.log(`Emitted 068 (${CHARACTER_EMBLEMS.length} person emblems + ${CHAPTER_EMBLEMS.length} era emblems)`);
    console.log(`Emitted 069 (${EVENT_SCRIPTURE_REFS.length} scripture references, ${verifiedQuotes} verse-verified quotes)`);
    console.log(`Emitted 070 (${MUSIC_LINKS.length} cross-work music links)`);
  } finally {
    await pool.end();
  }
}

main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : error);
  process.exitCode = 1;
});
