import { createHash } from "node:crypto";
import { mkdir, readFile, writeFile } from "node:fs/promises";
import { request as httpsRequest } from "node:https";
import { join, resolve } from "node:path";
import pg from "pg";

/**
 * Import the first Gustave Doré batch for the Bible Atlas (track A2).
 *
 * Doré's 1866 Bible is the one image set that covers this atlas end to end in a
 * single hand: one artist, one technique, one date, and a rights position that
 * is not in doubt — he died in 1883, so the engravings are public domain
 * everywhere. That makes it possible to add depictions in batches without
 * relitigating rights per file.
 *
 * The importer is fail-closed. A file is only bundled when Commons reports an
 * explicitly public-domain licence, and every row carries the file page, the
 * original URL, the licence URL, the author, bilingual alt text, a retrieval
 * timestamp and a SHA-256 of the exact bytes written to disk.
 *
 * Editorial boundary, restated in every row: a nineteenth-century engraving is
 * evidence of how the story was pictured in 1866, not of what anyone looked
 * like. Every asset lands as `illustrative`.
 *
 * The New Testament batch — and specifically whether this atlas should carry
 * figural depictions of Jesus at all, given that its emblem system deliberately
 * avoids drawing him — is left open for the liturgical design review.
 *
 * Usage:
 *   DATABASE_URL=postgresql:///literary_atlas npx tsx scripts/import_bible_dore_media.ts
 */
const ROOT = resolve(process.env.ATLAS_PROJECT_ROOT ?? process.cwd());
const DATABASE_URL = process.env.DATABASE_URL ?? "postgresql://llmacbookpro@localhost:5432/literary_atlas";
const WORK_ID = "10000000-0000-4000-8000-000000000005";
const API_URL = "https://commons.wikimedia.org/w/api.php";
const USER_AGENT = "LiteraryAtlas/3.1 bible-dore-import (contact: repository-maintainer)";
const MEDIA_DIR = join(ROOT, "apps/web/public/media/bible/dore");
const OUT_SEED = join(ROOT, "db/seeds/071_bible_dore_media.sql");
const RETRIEVED_AT = process.env.MEDIA_RETRIEVED_AT ?? "2026-08-18T00:00:00Z";
const PD_LICENSE_URL = "https://creativecommons.org/publicdomain/mark/1.0/";

type EntityKind = "character" | "event";

interface DoreItem {
  slug: string;
  kind: EntityKind;
  entity: string;
  file: string;
  altZh: string;
  altEn: string;
  titleZh: string;
  titleEn: string;
}

/** Curated batch one: Hebrew Bible narratives with an entity already in the atlas. */
const BATCH: readonly DoreItem[] = [
  { slug: "eve-created", kind: "character", entity: "eve", file: "002.The Creation of Eve.jpg", titleZh: "夏娃的受造", titleEn: "The Creation of Eve", altZh: "多雷版画《夏娃的受造》（创世记 2:21–23）；艺术性诠释，不是历史肖像", altEn: "Doré engraving The Creation of Eve (Genesis 2:21–23); artistic depiction, not a historical portrait" },
  { slug: "driven-out-of-eden", kind: "event", entity: "expulsion-from-eden", file: "003.Adam and Eve Are Driven out of Eden.jpg", titleZh: "亚当夏娃被逐出伊甸园", titleEn: "Adam and Eve Are Driven out of Eden", altZh: "多雷版画《亚当夏娃被逐出伊甸园》（创世记 3:22–24）；叙事场景示意，不是现场记录", altEn: "Doré engraving Adam and Eve Are Driven out of Eden (Genesis 3:22–24); a narrative scene, not an eyewitness record" },
  { slug: "rebekah-at-the-well", kind: "character", entity: "rebekah", file: "018.Eliezer and Rebekah at the Well.jpg", titleZh: "以利以谢与利百加在井旁", titleEn: "Eliezer and Rebekah at the Well", altZh: "多雷版画《以利以谢与利百加在井旁》（创世记 24:15–20）；艺术性诠释，不是历史肖像", altEn: "Doré engraving Eliezer and Rebekah at the Well (Genesis 24:15–20); artistic depiction, not a historical portrait" },
  { slug: "jacobs-dream", kind: "event", entity: "jacobs-dream-at-bethel", file: "021.Jacob's Dream.jpg", titleZh: "雅各的梦", titleEn: "Jacob's Dream", altZh: "多雷版画《雅各的梦》（创世记 28:10–22）；叙事场景示意，不是现场记录", altEn: "Doré engraving Jacob's Dream (Genesis 28:10–22); a narrative scene, not an eyewitness record" },
  { slug: "jacob-wrestles", kind: "character", entity: "jacob", file: "024.Jacob Wrestles with the Angel.jpg", titleZh: "雅各与天使摔跤", titleEn: "Jacob Wrestles with the Angel", altZh: "多雷版画《雅各与天使摔跤》（创世记 32:24–30）；艺术性诠释，不是历史肖像", altEn: "Doré engraving Jacob Wrestles with the Angel (Genesis 32:24–30); artistic depiction, not a historical portrait" },
  { slug: "joseph-reveals-himself", kind: "character", entity: "joseph-son-of-jacob", file: "028.Joseph Reveals Himself to His Brothers.jpg", titleZh: "约瑟与弟兄相认", titleEn: "Joseph Reveals Himself to His Brothers", altZh: "多雷版画《约瑟与弟兄相认》（创世记 45:1–4）；艺术性诠释，不是历史肖像", altEn: "Doré engraving Joseph Reveals Himself to His Brothers (Genesis 45:1–4); artistic depiction, not a historical portrait" },
  { slug: "giving-of-the-law", kind: "event", entity: "ten-commandments-given", file: "038.The Giving of the Law on Mount Sinai.jpg", titleZh: "西奈山颁布律法", titleEn: "The Giving of the Law on Mount Sinai", altZh: "多雷版画《西奈山颁布律法》（出埃及记 20:1–17）；叙事场景示意，不是现场记录", altEn: "Doré engraving The Giving of the Law on Mount Sinai (Exodus 20:1–17); a narrative scene, not an eyewitness record" },
  { slug: "moses-comes-down", kind: "character", entity: "moses", file: "039.Moses Comes Down from Mount Sinai.jpg", titleZh: "摩西下西奈山", titleEn: "Moses Comes Down from Mount Sinai", altZh: "多雷版画《摩西下西奈山》（出埃及记 34:29）；艺术性诠释，不是历史肖像", altEn: "Doré engraving Moses Comes Down from Mount Sinai (Exodus 34:29); artistic depiction, not a historical portrait" },
  { slug: "crossing-the-jordan", kind: "event", entity: "crossing-the-jordan", file: "044. The Israelites Cross the Jordan River.jpg", titleZh: "以色列人过约旦河", titleEn: "The Israelites Cross the Jordan River", altZh: "多雷版画《以色列人过约旦河》（约书亚记 3:14–17）；叙事场景示意，不是现场记录", altEn: "Doré engraving The Israelites Cross the Jordan River (Joshua 3:14–17); a narrative scene, not an eyewitness record" },
  { slug: "jael-kills-sisera", kind: "character", entity: "jael", file: "052.Jael Kills Sisera.jpg", titleZh: "雅亿杀西西拉", titleEn: "Jael Kills Sisera", altZh: "多雷版画《雅亿杀西西拉》（士师记 4:21）；艺术性诠释，不是历史肖像", altEn: "Doré engraving Jael Kills Sisera (Judges 4:21); artistic depiction, not a historical portrait" },
  { slug: "gideon-chooses-three-hundred", kind: "character", entity: "gideon", file: "054.Gideon Chooses 300 Soldiers.jpg", titleZh: "基甸挑选三百人", titleEn: "Gideon Chooses 300 Soldiers", altZh: "多雷版画《基甸挑选三百人》（士师记 7:5–7）；艺术性诠释，不是历史肖像", altEn: "Doré engraving Gideon Chooses 300 Soldiers (Judges 7:5–7); artistic depiction, not a historical portrait" },
  { slug: "death-of-samson", kind: "character", entity: "samson", file: "064.The Death of Samson.jpg", titleZh: "参孙之死", titleEn: "The Death of Samson", altZh: "多雷版画《参孙之死》（士师记 16:29–30）；艺术性诠释，不是历史肖像", altEn: "Doré engraving The Death of Samson (Judges 16:29–30); artistic depiction, not a historical portrait" },
  { slug: "ruth-and-boaz", kind: "character", entity: "ruth", file: "069.Ruth and Boaz.jpg", titleZh: "路得与波阿斯", titleEn: "Ruth and Boaz", altZh: "多雷版画《路得与波阿斯》（路得记 2）；艺术性诠释，不是历史肖像", altEn: "Doré engraving Ruth and Boaz (Ruth 2); artistic depiction, not a historical portrait" },
  { slug: "david-slays-goliath", kind: "character", entity: "david", file: "071A.David Slays Goliath.jpg", titleZh: "大卫击杀歌利亚", titleEn: "David Slays Goliath", altZh: "多雷版画《大卫击杀歌利亚》（撒母耳记上 17）；艺术性诠释，不是历史肖像", altEn: "Doré engraving David Slays Goliath (1 Samuel 17); artistic depiction, not a historical portrait" },
  { slug: "saul-and-the-witch-of-endor", kind: "character", entity: "saul", file: "075.Saul and the Witch of Endor.jpg", titleZh: "扫罗与隐多珥的女巫", titleEn: "Saul and the Witch of Endor", altZh: "多雷版画《扫罗与隐多珥的女巫》（撒母耳记上 28）；艺术性诠释，不是历史肖像", altEn: "Doré engraving Saul and the Witch of Endor (1 Samuel 28); artistic depiction, not a historical portrait" },
  { slug: "judgment-of-solomon", kind: "character", entity: "solomon", file: "084.The Judgment of Solomon.jpg", titleZh: "所罗门的判断", titleEn: "The Judgment of Solomon", altZh: "多雷版画《所罗门的判断》（列王纪上 3:16–28）；艺术性诠释，不是历史肖像", altEn: "Doré engraving The Judgment of Solomon (1 Kings 3:16–28); artistic depiction, not a historical portrait" },
  { slug: "elijah-ascends", kind: "character", entity: "elijah", file: "095.Elijah Ascends to Heaven in a Chariot of Fire.jpg", titleZh: "以利亚乘火车升天", titleEn: "Elijah Ascends to Heaven in a Chariot of Fire", altZh: "多雷版画《以利亚乘火车升天》（列王纪下 2:11）；艺术性诠释，不是历史肖像", altEn: "Doré engraving Elijah Ascends to Heaven in a Chariot of Fire (2 Kings 2:11); artistic depiction, not a historical portrait" },
  { slug: "death-of-jezebel", kind: "character", entity: "jezebel", file: "097.The Death of Jezebel.jpg", titleZh: "耶洗别之死", titleEn: "The Death of Jezebel", altZh: "多雷版画《耶洗别之死》（列王纪下 9:30–37）；艺术性诠释，不是历史肖像", altEn: "Doré engraving The Death of Jezebel (2 Kings 9:30–37); artistic depiction, not a historical portrait" },
  { slug: "rebuilding-the-temple", kind: "event", entity: "temple-foundation-laid", file: "105.The Rebuilding of the Temple Is Begun.jpg", titleZh: "重建圣殿动工", titleEn: "The Rebuilding of the Temple Is Begun", altZh: "多雷版画《重建圣殿动工》（以斯拉记 3:10–13）；叙事场景示意，不是现场记录", altEn: "Doré engraving The Rebuilding of the Temple Is Begun (Ezra 3:10–13); a narrative scene, not an eyewitness record" },
  { slug: "nehemiah-views-the-ruins", kind: "character", entity: "nehemiah", file: "108.Nehemiah Views the Ruins of Jerusalem's Walls.jpg", titleZh: "尼希米察看耶路撒冷城墙的废墟", titleEn: "Nehemiah Views the Ruins of Jerusalem's Walls", altZh: "多雷版画《尼希米察看耶路撒冷城墙的废墟》（尼希米记 2:11–16）；艺术性诠释，不是历史肖像", altEn: "Doré engraving Nehemiah Views the Ruins of Jerusalem's Walls (Nehemiah 2:11–16); artistic depiction, not a historical portrait" },
  { slug: "esther-before-the-king", kind: "character", entity: "esther", file: "115.Esther Before the King.jpg", titleZh: "以斯帖见王", titleEn: "Esther Before the King", altZh: "多雷版画《以斯帖见王》（以斯帖记 5:1–2）；艺术性诠释，不是历史肖像", altEn: "Doré engraving Esther Before the King (Esther 5:1–2); artistic depiction, not a historical portrait" },
  { slug: "prophet-isaiah", kind: "character", entity: "isaiah", file: "120.The Prophet Isaiah.jpg", titleZh: "先知以赛亚", titleEn: "The Prophet Isaiah", altZh: "多雷版画《先知以赛亚》；艺术性诠释，不是历史肖像", altEn: "Doré engraving The Prophet Isaiah; artistic depiction, not a historical portrait" },
  { slug: "prophet-jeremiah", kind: "character", entity: "jeremiah", file: "123.The Prophet Jeremiah.jpg", titleZh: "先知耶利米", titleEn: "The Prophet Jeremiah", altZh: "多雷版画《先知耶利米》；艺术性诠释，不是历史肖像", altEn: "Doré engraving The Prophet Jeremiah; artistic depiction, not a historical portrait" },
  { slug: "daniel-in-the-lions-den", kind: "character", entity: "daniel", file: "131.Daniel in the Lions' Den.jpg", titleZh: "但以理在狮子坑中", titleEn: "Daniel in the Lions' Den", altZh: "多雷版画《但以理在狮子坑中》（但以理书 6）；艺术性诠释，不是历史肖像", altEn: "Doré engraving Daniel in the Lions' Den (Daniel 6); artistic depiction, not a historical portrait" },
  { slug: "jonah-and-the-fish", kind: "character", entity: "jonah", file: "137.Jonah Is Spewed Forth by the Whale.jpg", titleZh: "大鱼把约拿吐出", titleEn: "Jonah Is Spewed Forth by the Whale", altZh: "多雷版画《大鱼把约拿吐出》（约拿书 2:10）；艺术性诠释，不是历史肖像", altEn: "Doré engraving Jonah Is Spewed Forth by the Whale (Jonah 2:10); artistic depiction, not a historical portrait" },
];

const q = (value: string): string => `'${value.replace(/'/gu, "''")}'`;
const stableUuid = (seed: string): string => {
  const hex = createHash("md5").update(seed).digest("hex");
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-4${hex.slice(13, 16)}-8${hex.slice(17, 20)}-${hex.slice(20, 32)}`;
};
const sleep = (ms: number): Promise<void> => new Promise((done) => setTimeout(done, ms));

/** Commons decorates its URLs with campaign tracking; store the clean file URL. */
const cleanUrl = (url: string): string => {
  const parsed = new URL(url);
  parsed.search = "";
  return parsed.toString();
};

interface ExtMetadata { [key: string]: { value: string } | undefined }

/**
 * One request. Uses node:https rather than global fetch because undici's
 * connection setup times out against Wikimedia's hosts on this network while a
 * plain IPv4 HTTPS request succeeds; the batch is not worth losing to that.
 */
function httpsGet(url: string, depth = 0): Promise<{ status: number; body: Buffer }> {
  return new Promise((settle, reject) => {
    if (depth > 4) { reject(new Error(`too many redirects for ${url}`)); return; }
    const target = new URL(url);
    const request = httpsRequest({
      host: target.host, path: `${target.pathname}${target.search}`, family: 4, timeout: 45000,
      // Wikimedia's edge is markedly happier with an explicit, uncompressed,
      // non-keep-alive request than with the defaults; without these headers
      // the same URLs stall or answer 429.
      headers: { "user-agent": USER_AGENT, accept: "*/*", "accept-encoding": "identity", connection: "close" },
    }, (response) => {
      const status = response.statusCode ?? 0;
      const location = response.headers.location;
      if (status >= 300 && status < 400 && location) {
        response.resume();
        httpsGet(new URL(location, url).toString(), depth + 1).then(settle, reject);
        return;
      }
      const chunks: Buffer[] = [];
      response.on("data", (chunk: Buffer) => chunks.push(chunk));
      response.on("end", () => settle({ status, body: Buffer.concat(chunks) }));
      response.on("error", reject);
    });
    request.on("timeout", () => { request.destroy(new Error("request timed out")); });
    request.on("error", reject);
    request.end();
  });
}

/** Commons throttles bursts; back off rather than dropping items from a batch. */
async function politeFetch(url: string | URL, what: string): Promise<Buffer> {
  for (let attempt = 1; attempt <= 6; attempt += 1) {
    const wait = 3000 * 2 ** (attempt - 1);
    let result: { status: number; body: Buffer };
    try {
      result = await httpsGet(url.toString());
    } catch (error) {
      // A dropped connection mid-batch is throttling by another name; treat it
      // like a 429 rather than losing the items already downloaded.
      console.log(`  ${what} -> ${error instanceof Error ? error.message : "network error"}; retrying in ${wait / 1000}s`);
      await new Promise((done) => setTimeout(done, wait));
      continue;
    }
    if (result.status >= 200 && result.status < 300) return result.body;
    if (result.status !== 429 && result.status < 500) throw new Error(`${what} returned HTTP ${result.status}`);
    console.log(`  ${what} -> HTTP ${result.status}; retrying in ${wait / 1000}s`);
    await new Promise((done) => setTimeout(done, wait));
  }
  throw new Error(`${what} kept failing after 6 attempts`);
}

async function commonsInfo(file: string): Promise<{ thumbUrl: string; originalUrl: string; descriptionUrl: string; licence: string; author: string }> {
  const url = new URL(API_URL);
  url.searchParams.set("action", "query");
  url.searchParams.set("format", "json");
  url.searchParams.set("titles", `File:${file}`);
  url.searchParams.set("prop", "imageinfo");
  url.searchParams.set("iiprop", "url|extmetadata");
  url.searchParams.set("iiurlwidth", "960");
  const payload = JSON.parse((await politeFetch(url, `Commons API for ${file}`)).toString("utf8")) as {
    query?: { pages?: Record<string, { missing?: string; imageinfo?: { thumburl?: string; url?: string; descriptionurl?: string; extmetadata?: ExtMetadata }[] }> };
  };
  const page = Object.values(payload.query?.pages ?? {})[0];
  if (!page || page.missing !== undefined) throw new Error(`Commons has no file page for ${file}`);
  const info = page.imageinfo?.[0];
  if (!info?.thumburl || !info.url || !info.descriptionurl) throw new Error(`${file} has no usable image info`);
  const metadata = info.extmetadata ?? {};
  const licence = metadata.LicenseShortName?.value ?? "";
  if (!/^public domain$/iu.test(licence.trim())) throw new Error(`${file} is not explicitly public domain (licence: ${licence || "none"})`);
  const rawArtist = metadata.Artist?.value ?? "";
  const author = /Gustave Dor/iu.test(rawArtist) ? "Gustave Doré" : "";
  if (!author) throw new Error(`${file} is not attributed to Gustave Doré (artist field: ${rawArtist.slice(0, 80)})`);
  return { thumbUrl: info.thumburl, originalUrl: cleanUrl(info.url), descriptionUrl: info.descriptionurl, licence: "Public domain", author };
}

async function main(): Promise<void> {
  const pool = new pg.Pool({ connectionString: DATABASE_URL });
  try {
    const characters = await pool.query<{ slug: string }>(`SELECT slug FROM characters WHERE work_id=$1`, [WORK_ID]);
    const events = await pool.query<{ slug: string }>(`SELECT slug FROM events WHERE work_id=$1`, [WORK_ID]);
    const knownCharacters = new Set(characters.rows.map((row) => row.slug));
    const knownEvents = new Set(events.rows.map((row) => row.slug));

    await mkdir(MEDIA_DIR, { recursive: true });
    const statements: string[] = [
      "BEGIN;", "",
      "-- Bible depiction batch one: Gustave Doré, 1866 (track A2).",
      "-- Generated by scripts/import_bible_dore_media.ts. Every asset is a",
      "-- nineteenth-century artistic depiction, never a historical portrait or an",
      "-- eyewitness record, and is stored as `illustrative` to say so in the data.",
      "",
    ];
    let bundled = 0;

    for (const item of BATCH) {
      const known = item.kind === "character" ? knownCharacters : knownEvents;
      if (!known.has(item.entity)) throw new Error(`${item.slug}: unknown ${item.kind} ${item.entity}`);
      const info = await commonsInfo(item.file);
      const filename = `${item.slug}.jpg`;
      // Resume support: Wikimedia throttles hard enough that a batch this size
      // rarely completes in one pass, and re-downloading what is already on
      // disk is both slower and ruder than reusing it.
      const existing = await readFile(join(MEDIA_DIR, filename)).catch(() => null);
      const bytes = existing && existing.length >= 4096
        ? existing
        : await politeFetch(info.thumbUrl, `${item.file} thumbnail`);
      if (bytes.length < 4096) throw new Error(`${item.file} thumbnail is implausibly small (${bytes.length} bytes)`);
      if (!existing) await writeFile(join(MEDIA_DIR, filename), bytes);
      const checksum = createHash("sha256").update(bytes).digest("hex");
      const assetUrl = `/media/bible/dore/${filename}`;
      const sourceId = stableUuid(`source:commons:bible:dore:${item.slug}`);
      const mediaId = stableUuid(`media:commons:bible:dore:${item.slug}`);
      const attribution = `Gustave Doré / Wikimedia Commons / Public domain`;
      const citationZh = `作者：Gustave Doré（1866）；许可：Public domain；人物与场景为艺术性诠释，不是历史肖像或现场记录；图片文件页：${info.descriptionUrl}`;
      const citationEn = `Author: Gustave Doré (1866); licence: Public domain; the image is an artistic depiction, not a historical portrait or eyewitness record; file page: ${info.descriptionUrl}`;
      const role = item.kind === "character" ? "character_depiction" : "event_scene";
      const linkTable = item.kind === "character" ? "characters" : "events";

      statements.push(
        `INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type) VALUES`,
        `  ('${sourceId}','${WORK_ID}',${q(`Wikimedia Commons: ${item.titleEn}`)},${q(info.descriptionUrl)},${q(citationEn)},'reference','image')`,
        `ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,url=EXCLUDED.url,citation=EXCLUDED.citation,evidence_grade=EXCLUDED.evidence_grade,source_type=EXCLUDED.source_type;`,
        `INSERT INTO source_translations(source_id,locale,title,citation,status) VALUES`,
        `  ('${sourceId}','zh-CN',${q(`Wikimedia Commons：${item.titleZh}`)},${q(citationZh)},'published'),`,
        `  ('${sourceId}','en',${q(`Wikimedia Commons: ${item.titleEn}`)},${q(citationEn)},'published')`,
        `ON CONFLICT (source_id,locale) DO UPDATE SET title=EXCLUDED.title,citation=EXCLUDED.citation,status=EXCLUDED.status;`,
        `INSERT INTO media_assets(id,source_id,asset_source,asset_licence,asset_author,asset_url,attribution_text,alt_text_zh,alt_text_en,media_kind,usage_mode,license_status,license_url,source_page_url,original_url,retrieved_at,checksum_sha256,media_role,depiction_status) VALUES`,
        `  ('${mediaId}','${sourceId}','Wikimedia Commons','Public domain',${q(info.author)},${q(assetUrl)},${q(attribution)},${q(item.altZh)},${q(item.altEn)},'image','bundled','verified',${q(PD_LICENSE_URL)},${q(info.descriptionUrl)},${q(info.originalUrl)},'${RETRIEVED_AT}'::timestamptz,${q(checksum)},'${role}','illustrative')`,
        `ON CONFLICT (id) DO UPDATE SET source_id=EXCLUDED.source_id,asset_source=EXCLUDED.asset_source,asset_licence=EXCLUDED.asset_licence,asset_author=EXCLUDED.asset_author,asset_url=EXCLUDED.asset_url,attribution_text=EXCLUDED.attribution_text,alt_text_zh=EXCLUDED.alt_text_zh,alt_text_en=EXCLUDED.alt_text_en,media_kind=EXCLUDED.media_kind,usage_mode=EXCLUDED.usage_mode,license_status=EXCLUDED.license_status,license_url=EXCLUDED.license_url,source_page_url=EXCLUDED.source_page_url,original_url=EXCLUDED.original_url,retrieved_at=EXCLUDED.retrieved_at,checksum_sha256=EXCLUDED.checksum_sha256,media_role=EXCLUDED.media_role,depiction_status=EXCLUDED.depiction_status;`,
        `INSERT INTO media_links(media_id,entity_kind,entity_id,sort_order)`,
        `SELECT '${mediaId}','${item.kind}',x.id,${bundled + 1} FROM ${linkTable} x WHERE x.work_id='${WORK_ID}' AND x.slug=${q(item.entity)}`,
        `ON CONFLICT DO NOTHING;`,
        "",
      );
      bundled += 1;
      console.log(`  ${item.slug}: ${bytes.length} bytes, ${checksum.slice(0, 12)}…${existing ? " (already on disk)" : ""}`);
      await sleep(existing ? 250 : 3000);
    }

    statements.push("COMMIT;");
    await writeFile(OUT_SEED, `${statements.join("\n")}\n`, "utf8");
    console.log(`Doré batch one: ${bundled} public-domain engravings bundled under /media/bible/dore/`);
  } finally {
    await pool.end();
  }
}

main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : error);
  process.exitCode = 1;
});
