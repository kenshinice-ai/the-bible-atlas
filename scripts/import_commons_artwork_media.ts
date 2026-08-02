import { createHash } from "node:crypto";
import { mkdir, readFile, readdir, writeFile } from "node:fs/promises";
import { extname, join, resolve } from "node:path";
import pg from "pg";

/**
 * Import one rights-audited Wikimedia Commons image for every European art
 * history artwork.  The script deliberately produces a checked-in SQL seed
 * and bundled thumbnails rather than making production depend on a live
 * third-party image URL.
 *
 * Usage:
 *   DATABASE_URL=postgresql:///literary_atlas_artwork_media_20260802 \
 *   npx tsx scripts/import_commons_artwork_media.ts
 *
 * The importer fails closed for bundled images: no local file is emitted
 * unless Commons returns a matching image with an explicitly recognised Public
 * Domain or Creative Commons licence. A small, explicit external-link list is
 * allowed for works whose image rights are not cleared; those rows never
 * render a copied image and point readers to the provider page instead.
 */

const WORK_SLUG = "european-art-history";
const WORK_ID = "10000000-0000-4000-8000-000000000009";
const API_URL = "https://commons.wikimedia.org/w/api.php";
const ROOT = resolve(process.env.ATLAS_PROJECT_ROOT ?? process.cwd());
const outSeed = resolve(process.env.MEDIA_SEED_OUT ?? join(ROOT, "db/seeds/054_european_artwork_media.sql"));
const mediaDir = resolve(process.env.MEDIA_DIR ?? join(ROOT, "apps/web/public/media/artworks"));
const retrievedAt = process.env.MEDIA_RETRIEVED_AT ?? "2026-08-02T00:00:00Z";
const cachePath = resolve(process.env.MEDIA_CACHE ?? "/tmp/literary-atlas-commons-media-cache.json");
const expectedArtworks = Number(process.env.MEDIA_EXPECTED_ARTWORKS ?? "96");
const onlyUnlinked = process.env.MEDIA_ONLY_UNLINKED === "1";

/** Search aliases for titles whose Commons category is more reliable than a
 * free-text title search (for example, Van Gogh's Google Art Project scan). */
const SEARCH_OVERRIDES: Record<string, string> = {
  "starry-night": "Vincent van Gogh - Starry Night - Google Art Project.jpg",
  primavera: "Sandro Botticelli - La Primavera - Google Art Project.jpg",
  "adoration-of-magi-botticelli": "Sandro Botticelli - Adorazione dei Magi - Google Art Project.jpg",
  pieta: "Michelangelo's Pietà Saint Peter's Basilica Vatican City.jpg",
  "sistine-madonna": "Raphael - Sistine Madonna.jpg",
  "self-portrait-1500": "Albrecht Dürer - 1500 self-portrait (High resolution and detail).jpg",
  "third-of-may": "El Tres de Mayo, by Francisco de Goya, from Prado in Google Earth.jpg",
  "saturn-devouring-son": "Francisco de Goya, Saturno devorando a su hijo (1819-1823).jpg",
  "little-dancer": "Edgar Degas, Little Dancer Aged Fourteen, 1878-1881, NGA 110292.jpg",
  "sunday-afternoon": "Georges Seurat - A Sunday on La Grande Jatte -- 1884 - Google Art Project.jpg",
  "red-studio": "L'Atelier rouge, par Henri Matisse.jpg",
  "spirit-of-dead-watching": "Paul Gauguin - Manao Tupapau (The Spirit of the Dead Watching) - MFA 54.1607.jpg",
};

const EXTERNAL_FALLBACKS: Record<string, { url: string; author: string }> = {
  "portuguese-braque": { url: "https://www.georgesbraque.org/the-portuguese.jsp", author: "Georges Braque" },
  "violin-and-candlestick": { url: "https://www.georgesbraque.org/violin-and-candlestick.jsp", author: "Georges Braque" },
};

/** Candidates that passed the licence/artist checks but represented a copy,
 * study, replica, derivative or different work during the R9/R10 audit.
 * Keep them external-only rather than presenting a near match as the work. */
const FORCE_EXTERNAL_SLUGS = new Set([
  "book-of-kells",
  "assumption-virgin-titian",
  "supper-at-emmaus-caravaggio",
  "surrender-of-breda",
  "apollo-and-daphne",
  "pierrot-watteau",
  "triumph-of-venus-boucher",
  "death-of-marat",
  "fighting-temeraire",
  "apotheosis-of-homer",
  "raft-of-medusa",
  "newton-blake",
  "judith-i-klimt",
  "guernica",
  "three-musicians-picasso",
  "bicycle-wheel",
  "fountain-duchamp",
  "white-on-white",
  "persistence-of-memory",
  "metamorphosis-narcissus",
  "joy-of-life",
]);

type ArtworkRow = {
  id: string;
  slug: string;
  titleEn: string;
  titleZh: string;
  artistEn: string;
  artistZh: string;
};

type ExtMetadata = Record<string, { value?: string } | undefined>;
type CommonsCandidate = {
  title: string;
  descriptionUrl: string;
  originalUrl: string;
  thumbUrl: string;
  licenseLabel: string;
  licenseUrl: string;
  author: string;
  score: number;
  mediaKind: "image" | "external_link";
  usageMode: "bundled" | "external_link";
  licenseStatus: "verified" | "pending";
};

type ImportedArtwork = ArtworkRow & CommonsCandidate & {
  filename: string;
  checksumSha256: string;
};

type CommonsPayload = {
  query?: {
    pages?: Record<string, {
      title?: string;
      imageinfo?: Array<{ thumburl?: string; url?: string; descriptionurl?: string; extmetadata?: ExtMetadata }>;
    }>;
  };
};

function externalSearchFallback(artwork: ArtworkRow): CommonsCandidate {
  const search = new URL("https://commons.wikimedia.org/w/index.php");
  search.searchParams.set("search", `${artwork.titleEn} ${artwork.artistEn}`);
  search.searchParams.set("title", "Special:MediaSearch");
  search.searchParams.set("type", "image");
  return {
    title: `${artwork.titleEn} — external media search`,
    descriptionUrl: search.toString(),
    originalUrl: search.toString(),
    thumbUrl: "",
    licenseLabel: "Provider terms apply; no redistribution",
    licenseUrl: "",
    author: artwork.artistEn || "Unknown author",
    score: 100,
    mediaKind: "external_link",
    usageMode: "external_link",
    licenseStatus: "pending",
  };
}

const sleep = (milliseconds: number) => new Promise((resolvePromise) => setTimeout(resolvePromise, milliseconds));

function cleanHtml(value: string | undefined): string {
  return (value ?? "")
    .replace(/<[^>]*>/gu, " ")
    .replace(/&nbsp;/gu, " ")
    .replace(/&amp;/gu, "&")
    .replace(/&quot;/gu, '"')
    .replace(/&#39;/gu, "'")
    .replace(/&#x27;/giu, "'")
    .replace(/\s+/gu, " ")
    .trim();
}

/** Commons Artist metadata can contain a full attribution instruction block;
 * keep the named author concise while preserving the licence URL and source
 * page as the authoritative attribution record. */
function conciseAuthor(value: string | undefined): string {
  const cleaned = cleanHtml(value);
  const concise = cleaned.split(/\s+(?:You are free to use|If you use this work|This image is not)\b/iu, 1)[0]?.trim();
  return concise || "";
}

function normalise(value: string | null | undefined): string {
  return (value ?? "").normalize("NFKD").replace(/[\u0300-\u036f]/gu, "").toLowerCase();
}

function tokens(value: string): string[] {
  return normalise(value).match(/[a-z0-9]+/gu) ?? [];
}

function artistIdentityToken(artistName: string): string {
  const ignored = new Set(["artist", "da", "de", "der", "di", "elder", "le", "of", "saint", "the", "unknown", "van", "von", "younger"]);
  return tokens(artistName).filter((token) => token.length > 2 && !ignored.has(token)).at(-1) ?? "";
}

function candidateMentionsArtist(artwork: ArtworkRow, candidateText: string): boolean {
  const identity = artistIdentityToken(artwork.artistEn);
  return !identity || normalise(candidateText).includes(identity);
}

function quoteSql(value: string): string {
  return `'${value.replaceAll("'", "''")}'`;
}

function licenceFor(metadata: ExtMetadata): { label: string; url: string } | null {
  const shortName = cleanHtml(metadata.LicenseShortName?.value);
  const usageTerms = cleanHtml(metadata.UsageTerms?.value);
  const categories = cleanHtml(metadata.Categories?.value);
  const raw = `${shortName} ${usageTerms} ${categories}`.toLowerCase();
  if (/\b(?:nc|non[- ]commercial|nd|no[- ]derivatives|all rights reserved|fair use)\b/iu.test(raw)) return null;

  const ccMatch = raw.match(/cc\s*by(?:-sa)?(?:\s|-)?([0-9.]+)/iu);
  if (ccMatch) {
    const shareAlike = /cc\s*by[- ]?sa/iu.test(raw);
    const version = ccMatch[1] ?? "4.0";
    return {
      label: `CC BY${shareAlike ? "-SA" : ""} ${version}`,
      url: `https://creativecommons.org/licenses/by${shareAlike ? "-sa" : ""}/${version}/`,
    };
  }
  if (/\bcc0\b/iu.test(raw)) return { label: "CC0", url: "https://creativecommons.org/publicdomain/zero/1.0/" };
  if (/public domain|\bpd[- ]|cc[- ]pd[- ]mark/iu.test(raw)) {
    return { label: shortName || "Public domain", url: "https://commons.wikimedia.org/wiki/Commons:Copyright_tags" };
  }
  return null;
}

function candidateScore(artwork: ArtworkRow, candidateTitle: string, metadata: ExtMetadata): number {
  const haystack = normalise(`${candidateTitle} ${metadata.ObjectName?.value ?? ""} ${metadata.Categories?.value ?? ""}`);
  const candidateName = normalise(candidateTitle);
  const titleTokens = tokens(artwork.titleEn).filter((token) => token.length > 2 && !["the", "a", "an", "of", "in", "on", "at", "and", "with", "from", "to"].includes(token));
  const artistTokens = tokens(artwork.artistEn).filter((token) => token.length > 2 && !["the", "of", "da", "de", "van"].includes(token));
  let score = 0;
  for (const token of titleTokens) if (haystack.includes(token)) score += 3;
  for (const token of artistTokens) if (haystack.includes(token)) score += 4;
  if (titleTokens.length > 1 && titleTokens.every((token) => candidateName.includes(token))) score += 16;
  if (titleTokens.length === 1 && titleTokens[0] && candidateName.includes(titleTokens[0])) score += 12;
  if (titleTokens.length > 1 && titleTokens.every((token) => haystack.includes(token))) score += 8;
  const surname = artistTokens.at(-1);
  if (surname && candidateName.includes(surname)) score += 8;
  if (/\b(detail|crop|fragment|panel|study|sketch|reconstruction|diagram)\b/iu.test(candidateName)) score -= 8;
  if (/\.(?:pdf|djvu)(?:$|\s)/iu.test(candidateName)) score -= 40;
  return score;
}

async function fetchCommonsJson(url: URL, artworkSlug: string): Promise<CommonsPayload> {
  for (let attempt = 0; attempt < 4; attempt += 1) {
    try {
      const response = await fetch(url, { headers: { "user-agent": "LiteraryAtlas/3.1 artwork-media-import (contact: repository-maintainer)" } });
      if (response.ok) return await response.json() as CommonsPayload;
      if (response.status !== 429 && response.status < 500) throw new Error(`Commons API ${response.status} for ${artworkSlug}`);
      const retryAfter = Number(response.headers.get("retry-after") ?? "0");
      const wait = Math.max(retryAfter * 1000, 5000 * (attempt + 1));
      console.warn(`Commons API ${response.status} for ${artworkSlug}; waiting ${wait}ms before retry ${attempt + 1}/3`);
      await sleep(wait);
    } catch (error: unknown) {
      if (attempt === 3) throw error;
      const wait = 5000 * (attempt + 1);
      console.warn(`Commons API network error for ${artworkSlug}; waiting ${wait}ms before retry ${attempt + 1}/3`);
      await sleep(wait);
    }
  }
  throw new Error(`Commons API retries exhausted for ${artworkSlug}`);
}

function candidateFromPage(artwork: ArtworkRow, page: { title?: string; imageinfo?: Array<{ thumburl?: string; url?: string; descriptionurl?: string; extmetadata?: ExtMetadata }> }): CommonsCandidate | null {
  const info = page.imageinfo?.[0];
  if (!page.title || !info?.thumburl || !info.url || !info.descriptionurl || /\.(?:pdf|djvu)(?:$|\s)/iu.test(page.title)) return null;
  const metadata = info.extmetadata ?? {};
  const identityText = `${page.title} ${metadata.Artist?.value ?? ""} ${metadata.Credit?.value ?? ""} ${metadata.ObjectName?.value ?? ""} ${metadata.Categories?.value ?? ""}`;
  if (!candidateMentionsArtist(artwork, identityText)) return null;
  const licence = licenceFor(metadata);
  if (!licence) return null;
  const author = conciseAuthor(metadata.Artist?.value) || conciseAuthor(metadata.Credit?.value) || "Unknown author";
  return { title: page.title, descriptionUrl: info.descriptionurl, originalUrl: info.url, thumbUrl: info.thumburl, licenseLabel: licence.label, licenseUrl: licence.url, author, score: candidateScore(artwork, page.title, metadata), mediaKind: "image", usageMode: "bundled", licenseStatus: "verified" };
}

async function commonsCandidates(artwork: ArtworkRow): Promise<CommonsCandidate[]> {
  if (FORCE_EXTERNAL_SLUGS.has(artwork.slug)) return [externalSearchFallback(artwork)];
  const external = EXTERNAL_FALLBACKS[artwork.slug];
  if (external) return [{ title: `${artwork.titleEn} — external provider page`, descriptionUrl: external.url, originalUrl: external.url, thumbUrl: "", licenseLabel: "Provider terms apply; no redistribution", licenseUrl: "", author: external.author, score: 100, mediaKind: "external_link", usageMode: "external_link", licenseStatus: "pending" }];
  const override = SEARCH_OVERRIDES[artwork.slug];
  if (override) {
    const directUrl = new URL(API_URL);
    directUrl.searchParams.set("action", "query");
    directUrl.searchParams.set("titles", `File:${override}`);
    directUrl.searchParams.set("prop", "imageinfo");
    directUrl.searchParams.set("iiprop", "url|extmetadata");
    directUrl.searchParams.set("iiurlwidth", "960");
    directUrl.searchParams.set("format", "json");
    const directPayload = await fetchCommonsJson(directUrl, artwork.slug);
    const directCandidate = candidateFromPage(artwork, Object.values(directPayload.query?.pages ?? {})[0] ?? {});
    if (directCandidate) return [{ ...directCandidate, score: Math.max(100, directCandidate.score) }];
  }
  const queries = [
    ...(SEARCH_OVERRIDES[artwork.slug] ? [`File:${SEARCH_OVERRIDES[artwork.slug]}`] : []),
    `intitle:${artwork.titleEn} ${artwork.artistEn}`,
    `File:${artwork.titleEn} ${artwork.artistEn}`,
    `File:${artwork.artistEn} ${artwork.titleEn}`,
    `File:${artwork.titleEn}`,
  ];
  const byPage = new Map<string, CommonsCandidate>();
  for (const query of queries) {
    const url = new URL(API_URL);
    url.searchParams.set("action", "query");
    url.searchParams.set("generator", "search");
    url.searchParams.set("gsrsearch", query);
    url.searchParams.set("gsrnamespace", "6");
    url.searchParams.set("gsrlimit", "10");
    url.searchParams.set("prop", "imageinfo");
    url.searchParams.set("iiprop", "url|extmetadata");
    url.searchParams.set("iiurlwidth", "960");
    url.searchParams.set("format", "json");
    const payload = await fetchCommonsJson(url, artwork.slug);
    for (const page of Object.values(payload.query?.pages ?? {})) {
      const candidate = candidateFromPage(artwork, page);
      if (candidate) byPage.set(candidate.descriptionUrl, candidate);
    }
    const best = [...byPage.values()].sort((left, right) => right.score - left.score)[0];
    if (best && best.score >= 18) break;
    await sleep(700);
  }
  return [...byPage.values()].sort((left, right) => right.score - left.score || left.title.localeCompare(right.title));
}

function extensionFor(contentType: string, sourceUrl: string): string {
  const normalisedType = contentType.toLowerCase().split(";", 1)[0];
  if (normalisedType === "image/png") return ".png";
  if (normalisedType === "image/webp") return ".webp";
  if (normalisedType === "image/svg+xml") return ".svg";
  if (normalisedType === "image/jpeg" || normalisedType === "image/jpg") return ".jpg";
  const extension = extname(new URL(sourceUrl).pathname).toLowerCase();
  return [".jpg", ".jpeg", ".png", ".webp", ".svg"].includes(extension) ? (extension === ".jpeg" ? ".jpg" : extension) : ".jpg";
}

async function download(candidate: CommonsCandidate, artwork: ArtworkRow, reuseExisting: boolean): Promise<{ filename: string; checksumSha256: string }> {
  const existingFilename = reuseExisting
    ? (await readdir(mediaDir)).find((filename) => filename.startsWith(`${artwork.slug}.`))
    : undefined;
  if (existingFilename) {
    const existing = await readFile(join(mediaDir, existingFilename));
    return { filename: existingFilename, checksumSha256: createHash("sha256").update(existing).digest("hex") };
  }
  for (let attempt = 0; attempt < 4; attempt += 1) {
    try {
      const response = await fetch(candidate.thumbUrl, { headers: { "user-agent": "LiteraryAtlas/3.1 artwork-media-import" } });
      if (!response.ok) {
        if (response.status !== 429 && response.status < 500) throw new Error(`Commons image ${response.status} for ${artwork.slug}`);
        throw new Error(`retryable Commons image ${response.status}`);
      }
      const contentType = response.headers.get("content-type") ?? "";
      if (!contentType.toLowerCase().startsWith("image/")) throw new Error(`Commons image for ${artwork.slug} returned ${contentType || "no content type"}`);
      const bytes = Buffer.from(await response.arrayBuffer());
      if (bytes.length < 1024) throw new Error(`Commons image for ${artwork.slug} is unexpectedly small (${bytes.length} bytes)`);
      const filename = `${artwork.slug}${extensionFor(contentType, candidate.thumbUrl)}`;
      await writeFile(join(mediaDir, filename), bytes, { flag: process.env.MEDIA_ALLOW_OVERWRITE === "1" ? "w" : "wx" }).catch(async (error: unknown) => {
        if (!(error instanceof Error) || !("code" in error) || error.code !== "EEXIST") throw error;
        const existing = await import("node:fs/promises").then(({ readFile }) => readFile(join(mediaDir, filename)));
        if (!existing.equals(bytes)) throw new Error(`Refusing to overwrite changed media file ${filename}`);
      });
      return { filename, checksumSha256: createHash("sha256").update(bytes).digest("hex") };
    } catch (error: unknown) {
      if (attempt === 3) throw error;
      const wait = 5000 * (attempt + 1);
      console.warn(`Commons image network error for ${artwork.slug}; waiting ${wait}ms before retry ${attempt + 1}/3`);
      await sleep(wait);
    }
  }
  throw new Error(`Commons image retries exhausted for ${artwork.slug}`);
}

function sqlFor(items: ImportedArtwork[]): string {
  const lines: string[] = [
    "BEGIN;",
    "",
    "-- R9/R10: one rights-audited artwork media record per newly expanded artwork (bundled Commons image or explicit external reference).",
    "-- Generated by scripts/import_commons_artwork_media.ts; do not hand-edit URLs or attribution.",
    "CREATE OR REPLACE FUNCTION pg_temp.stable_uuid(seed text) RETURNS uuid",
    "LANGUAGE sql IMMUTABLE AS $fn$",
    "  SELECT (substr(md5(seed),1,8)||'-'||substr(md5(seed),9,4)||'-4'||substr(md5(seed),14,3)||'-8'||substr(md5(seed),18,3)||'-'||substr(md5(seed),21))::uuid",
    "$fn$;",
    "",
  ];
  for (const item of items) {
    const external = item.mediaKind === "external_link";
    const author = conciseAuthor(item.author) || "Unknown author";
    const sourceId = "pg_temp.stable_uuid(" + quoteSql(`source:commons:${item.slug}`) + ")";
    const mediaId = "pg_temp.stable_uuid(" + quoteSql(`media:commons:${item.slug}`) + ")";
    const assetSource = external
      ? item.descriptionUrl.includes("georgesbraque.org") ? "Georges Braque official reference" : "External provider reference"
      : "Wikimedia Commons";
    const sourceTitleZh = external ? `外部馆藏参考：${item.titleZh}` : `Wikimedia Commons：${item.titleZh}`;
    const sourceTitleEn = external ? `External reference: ${item.titleEn}` : `Wikimedia Commons: ${item.titleEn}`;
    const citationZh = external ? `作者：${author}；本页不复制图片，遵循来源站点条款：${item.descriptionUrl}` : `作者：${author}；许可：${item.licenseLabel}；图片文件页：${item.descriptionUrl}`;
    const citationEn = external ? `Artist: ${author}; image is not redistributed; see provider terms: ${item.descriptionUrl}` : `Author: ${author}; licence: ${item.licenseLabel}; file page: ${item.descriptionUrl}`;
    const attribution = external ? `${author} / external reference only / no image redistribution` : `${author} / Wikimedia Commons / ${item.licenseLabel}`;
    const altZh = `${item.titleZh}（${item.artistZh}）`;
    const altEn = `${item.titleEn} by ${item.artistEn}`;
    const assetUrl = external ? item.originalUrl : `/media/artworks/${item.filename}`;
    const licenseUrl = item.licenseUrl ? quoteSql(item.licenseUrl) : "NULL";
    const retrieved = external ? "NULL" : `${quoteSql(retrievedAt)}::timestamptz`;
    const checksum = item.checksumSha256 ? quoteSql(item.checksumSha256) : "NULL";
    lines.push(
      `INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type) VALUES (${sourceId},${quoteSql(WORK_ID)},${quoteSql(sourceTitleEn)},${quoteSql(item.descriptionUrl)},${quoteSql(citationEn)},'reference','image') ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,url=EXCLUDED.url,citation=EXCLUDED.citation,evidence_grade=EXCLUDED.evidence_grade,source_type=EXCLUDED.source_type;`,
      `INSERT INTO source_translations(source_id,locale,title,citation,status) VALUES (${sourceId},'zh-CN',${quoteSql(sourceTitleZh)},${quoteSql(citationZh)},'published'),(${sourceId},'en',${quoteSql(sourceTitleEn)},${quoteSql(citationEn)},'published') ON CONFLICT (source_id,locale) DO UPDATE SET title=EXCLUDED.title,citation=EXCLUDED.citation,status=EXCLUDED.status;`,
      `INSERT INTO artwork_sources(artwork_id,source_id) VALUES (${quoteSql(item.id)},${sourceId}) ON CONFLICT DO NOTHING;`,
      `INSERT INTO media_assets(id,source_id,asset_source,asset_licence,asset_author,asset_url,attribution_text,alt_text_zh,alt_text_en,media_kind,usage_mode,license_status,license_url,source_page_url,original_url,retrieved_at,checksum_sha256) VALUES (${mediaId},${sourceId},${quoteSql(assetSource)},${quoteSql(item.licenseLabel)},${quoteSql(author)},${quoteSql(assetUrl)},${quoteSql(attribution)},${quoteSql(altZh)},${quoteSql(altEn)},${quoteSql(item.mediaKind)},${quoteSql(item.usageMode)},${quoteSql(item.licenseStatus)},${licenseUrl},${quoteSql(item.descriptionUrl)},${quoteSql(item.originalUrl)},${retrieved},${checksum}) ON CONFLICT (id) DO UPDATE SET source_id=EXCLUDED.source_id,asset_source=EXCLUDED.asset_source,asset_licence=EXCLUDED.asset_licence,asset_author=EXCLUDED.asset_author,asset_url=EXCLUDED.asset_url,attribution_text=EXCLUDED.attribution_text,alt_text_zh=EXCLUDED.alt_text_zh,alt_text_en=EXCLUDED.alt_text_en,media_kind=EXCLUDED.media_kind,usage_mode=EXCLUDED.usage_mode,license_status=EXCLUDED.license_status,license_url=EXCLUDED.license_url,source_page_url=EXCLUDED.source_page_url,original_url=EXCLUDED.original_url,retrieved_at=EXCLUDED.retrieved_at,checksum_sha256=EXCLUDED.checksum_sha256;`,
      `INSERT INTO media_links(media_id,entity_kind,entity_id,sort_order) VALUES (${mediaId},'artwork',${quoteSql(item.id)},0) ON CONFLICT (media_id,entity_kind,entity_id) DO UPDATE SET sort_order=EXCLUDED.sort_order;`,
      "",
    );
  }
  lines.push("COMMIT;", "");
  return lines.join("\n");
}

async function main(): Promise<void> {
  await mkdir(mediaDir, { recursive: true });
  let selectionCache: Record<string, CommonsCandidate> = {};
  try {
    selectionCache = JSON.parse(await readFile(cachePath, "utf8")) as Record<string, CommonsCandidate>;
  } catch (error: unknown) {
    if (!(error instanceof Error) || !("code" in error) || error.code !== "ENOENT") throw error;
  }
  const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });
  try {
    const result = await pool.query<ArtworkRow>(
      `SELECT aw.id,aw.slug,COALESCE(en.title,zh.title) AS "titleEn",COALESCE(zh.title,en.title) AS "titleZh",
        COALESCE(aen.name,aen.full_name,az.name,'Unknown artist') AS "artistEn",
        COALESCE(az.name,az.full_name,aen.name,'佚名') AS "artistZh"
       FROM artworks aw
       LEFT JOIN artwork_translations en ON en.artwork_id=aw.id AND en.locale='en' AND en.status='published'
       LEFT JOIN artwork_translations zh ON zh.artwork_id=aw.id AND zh.locale='zh-CN' AND zh.status='published'
       LEFT JOIN artists a ON a.id=aw.primary_artist_id
       LEFT JOIN artist_translations aen ON aen.artist_id=a.id AND aen.locale='en' AND aen.status='published'
       LEFT JOIN artist_translations az ON az.artist_id=a.id AND az.locale='zh-CN' AND az.status='published'
       WHERE aw.work_id=$1
         AND ($2::boolean=false OR NOT EXISTS (
           SELECT 1 FROM media_links ml WHERE ml.entity_kind='artwork' AND ml.entity_id=aw.id
         ))
       ORDER BY aw.sort_order`,
      [WORK_ID, onlyUnlinked],
    );
    if (result.rows.length !== expectedArtworks) throw new Error(`Expected ${expectedArtworks} art-history artworks, found ${result.rows.length}`);
    const imported: ImportedArtwork[] = [];
    for (const artwork of result.rows) {
      const cached = selectionCache[artwork.slug];
      const reuseCache = process.env.MEDIA_REUSE_CACHE === "1";
      const cachedIdentityIsSafe = !FORCE_EXTERNAL_SLUGS.has(artwork.slug)
        && (cached?.mediaKind === "external_link" || (cached ? candidateMentionsArtist(artwork, `${cached.title} ${cached.author}`) : false));
      const reuseCachedSelection = Boolean(cached && cachedIdentityIsSafe && (reuseCache || (!SEARCH_OVERRIDES[artwork.slug] && !EXTERNAL_FALLBACKS[artwork.slug])));
      let candidates: CommonsCandidate[];
      try {
        candidates = reuseCachedSelection && cached ? [cached] : await commonsCandidates(artwork);
      } catch (error: unknown) {
        console.warn(`Open image lookup failed for ${artwork.slug}; using explicit external reference: ${error instanceof Error ? error.message : error}`);
        candidates = [externalSearchFallback(artwork)];
      }
      let selected = candidates[0];
      if (!selected || selected.score < 18) {
        const details = candidates.slice(0, 5).map((candidate) => `${candidate.score}:${candidate.title}`).join(" | ");
        console.warn(`No sufficiently matched open image for ${artwork.slug}; using explicit external reference. Candidates: ${details || "none"}`);
        selected = externalSearchFallback(artwork);
      }
      let file = { filename: "", checksumSha256: "" };
      if (selected.mediaKind !== "external_link") {
        try {
          file = await download(selected, artwork, reuseCachedSelection);
        } catch (error: unknown) {
          console.warn(`Open image download failed for ${artwork.slug}; using explicit external reference: ${error instanceof Error ? error.message : error}`);
          selected = externalSearchFallback(artwork);
        }
      }
      selectionCache[artwork.slug] = selected;
      await writeFile(cachePath, JSON.stringify(selectionCache, null, 2), "utf8");
      imported.push({ ...artwork, ...selected, ...file });
      console.log(`media: ${artwork.slug} <- ${selected.title} (${selected.licenseLabel}, score ${selected.score})`);
    }
    await writeFile(outSeed, sqlFor(imported), "utf8");
    console.log(`media: wrote ${imported.length} seed rows to ${outSeed}`);
    console.log(`media: bundled ${imported.filter((item) => item.mediaKind === "image").length} images under ${mediaDir}; external-only references ${imported.filter((item) => item.mediaKind === "external_link").length}`);
  } finally {
    await pool.end();
  }
}

main().catch((error: unknown) => {
  console.error("media import failed:", error instanceof Error ? error.message : error);
  process.exitCode = 1;
});
