import { createHash } from "node:crypto";
import { readFile, readdir } from "node:fs/promises";
import { join, resolve } from "node:path";
import pg from "pg";

/**
 * Verify the R8 artwork-media contract against a real PostgreSQL database and
 * the checked-in static media directory. This is intentionally fail-closed:
 * a missing file, unverifiable licence, stale asset, or incomplete bilingual
 * provenance makes the command exit non-zero.
 *
 * Usage:
 *   DATABASE_URL=postgresql:///literary_atlas_artwork_media_20260802 \
 *   npx tsx scripts/verify_artwork_media.ts
 */

const WORK_ID = "10000000-0000-4000-8000-000000000009";
const ROOT = resolve(process.env.ATLAS_PROJECT_ROOT ?? process.cwd());
const MEDIA_ROOT = resolve(process.env.MEDIA_DIR ?? join(ROOT, "apps/web/public/media/artworks"));
const EXPECTED_ARTWORKS = 96;
const EXPECTED_BUNDLED = 94;
const EXPECTED_EXTERNAL = 2;
const ACCEPTED_LICENSE = /^(?:Public domain|CC0|CC BY(?:-SA)? \d+(?:\.\d+)?)$/u;

type MediaRow = {
  artworkId: string;
  artworkSlug: string;
  mediaId: string;
  mediaKind: "image" | "external_link";
  usageMode: "bundled" | "remote" | "external_link";
  licenseStatus: "verified" | "pending" | "rejected" | "unknown";
  license: string;
  licenseUrl: string | null;
  sourcePageUrl: string | null;
  originalUrl: string | null;
  assetUrl: string;
  author: string;
  attribution: string;
  altZh: string;
  altEn: string;
  sourceId: string | null;
  sourceType: string | null;
  zhSourceCount: number;
  enSourceCount: number;
  artworkSourceCount: number;
};

function fail(message: string): never {
  throw new Error(`artwork media verification failed: ${message}`);
}

async function main(): Promise<void> {
  const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });
  try {
    const count = await pool.query<{ count: string }>(
      "SELECT count(*)::text AS count FROM artworks WHERE work_id=$1",
      [WORK_ID],
    );
    if (Number(count.rows[0]?.count ?? 0) !== EXPECTED_ARTWORKS) fail(`expected ${EXPECTED_ARTWORKS} artworks, found ${count.rows[0]?.count ?? "none"}`);

    const result = await pool.query<MediaRow>(
      `SELECT aw.id AS "artworkId", aw.slug AS "artworkSlug", ma.id AS "mediaId",
        ma.media_kind AS "mediaKind", ma.usage_mode AS "usageMode", ma.license_status AS "licenseStatus",
        ma.asset_licence AS license, ma.license_url AS "licenseUrl", ma.source_page_url AS "sourcePageUrl",
        ma.original_url AS "originalUrl", ma.asset_url AS "assetUrl", ma.asset_author AS author,
        ma.attribution_text AS attribution, ma.alt_text_zh AS "altZh", ma.alt_text_en AS "altEn",
        ma.source_id AS "sourceId", s.source_type AS "sourceType",
        (SELECT count(*)::int FROM source_translations st WHERE st.source_id=ma.source_id AND st.locale='zh-CN' AND st.status='published') AS "zhSourceCount",
        (SELECT count(*)::int FROM source_translations st WHERE st.source_id=ma.source_id AND st.locale='en' AND st.status='published') AS "enSourceCount",
        (SELECT count(*)::int FROM artwork_sources aws WHERE aws.artwork_id=aw.id AND aws.source_id=ma.source_id) AS "artworkSourceCount"
       FROM artworks aw
       LEFT JOIN media_links ml ON ml.entity_kind='artwork' AND ml.entity_id=aw.id
       LEFT JOIN media_assets ma ON ma.id=ml.media_id
       LEFT JOIN sources s ON s.id=ma.source_id
       WHERE aw.work_id=$1
       ORDER BY aw.sort_order`,
      [WORK_ID],
    );
    if (result.rows.length !== EXPECTED_ARTWORKS) fail(`expected one media link per artwork, found ${result.rows.length} rows`);
    if (result.rows.some((row) => !row.mediaId)) fail(`artwork ${result.rows.find((row) => !row.mediaId)?.artworkSlug ?? "unknown"} has no media asset`);
    const mediaIds = new Set(result.rows.map((row) => row.mediaId));
    if (mediaIds.size !== EXPECTED_ARTWORKS) fail(`media asset ids are not one-to-one (${mediaIds.size} unique for ${EXPECTED_ARTWORKS} artworks)`);

    const bundled = result.rows.filter((row) => row.mediaKind === "image");
    const external = result.rows.filter((row) => row.mediaKind === "external_link");
    if (bundled.length !== EXPECTED_BUNDLED || external.length !== EXPECTED_EXTERNAL) {
      fail(`expected ${EXPECTED_BUNDLED} bundled images and ${EXPECTED_EXTERNAL} external references, found ${bundled.length}/${external.length}`);
    }

    const expectedFiles = new Set<string>();
    for (const row of result.rows) {
      if (!row.sourceId || row.sourceType !== "image") fail(`${row.artworkSlug} has incomplete image source linkage`);
      if (row.zhSourceCount !== 1 || row.enSourceCount !== 1) fail(`${row.artworkSlug} source is not bilingual/published`);
      if (row.artworkSourceCount !== 1) fail(`${row.artworkSlug} is missing artwork_sources provenance`);
      if (!row.sourcePageUrl?.startsWith("https://") || !row.originalUrl?.startsWith("https://")) fail(`${row.artworkSlug} has non-HTTPS provenance URLs`);
      if (!row.author.trim() || !row.attribution.trim() || !row.altZh.trim() || !row.altEn.trim()) fail(`${row.artworkSlug} has empty author, attribution, or alt text`);

      if (row.mediaKind === "image") {
        if (row.usageMode !== "bundled" || row.licenseStatus !== "verified") fail(`${row.artworkSlug} image is not bundled/verified`);
        if (!ACCEPTED_LICENSE.test(row.license)) fail(`${row.artworkSlug} has non-whitelisted licence ${row.license}`);
        if (!row.licenseUrl?.startsWith("https://")) fail(`${row.artworkSlug} has no HTTPS licence URL`);
        if (!row.assetUrl.startsWith("/media/artworks/")) fail(`${row.artworkSlug} is not a local bundled URL`);
        const filename = row.assetUrl.slice("/media/artworks/".length);
        if (!/^[A-Za-z0-9._-]+$/u.test(filename)) fail(`${row.artworkSlug} has unsafe media filename ${filename}`);
        expectedFiles.add(filename);
        const filePath = join(MEDIA_ROOT, filename);
        const bytes = await readFile(filePath).catch(() => null);
        if (!bytes || bytes.length < 1024) fail(`${row.artworkSlug} local file is missing or unexpectedly small`);
        const checksum = createHash("sha256").update(bytes).digest("hex");
        const checksumFromSeed = await pool.query<{ checksum: string | null }>("SELECT checksum_sha256 AS checksum FROM media_assets WHERE id=$1", [row.mediaId]);
        if (checksum !== checksumFromSeed.rows[0]?.checksum) fail(`${row.artworkSlug} local checksum does not match media_assets`);
      } else {
        if (row.usageMode !== "external_link" || row.licenseStatus !== "pending") fail(`${row.artworkSlug} external reference has incorrect usage/licence status`);
        if (!row.assetUrl.startsWith("https://") || !row.attribution.includes("no image redistribution")) fail(`${row.artworkSlug} external reference is not clearly non-redistributable`);
        if (row.licenseUrl !== null) fail(`${row.artworkSlug} external reference must not claim a bundled licence`);
      }
    }

    const actualFiles = new Set(await readdir(MEDIA_ROOT));
    const stale = [...actualFiles].filter((file) => !expectedFiles.has(file));
    const missing = [...expectedFiles].filter((file) => !actualFiles.has(file));
    if (stale.length > 0 || missing.length > 0) fail(`media directory mismatch; stale=${stale.join(",") || "none"}, missing=${missing.join(",") || "none"}`);

    console.log(`artwork media verified: ${EXPECTED_ARTWORKS} artworks, ${bundled.length} bundled Commons images, ${external.length} external-only references`);
    console.log(`media directory verified: ${actualFiles.size} files with matching SHA-256 checksums`);
  } finally {
    await pool.end();
  }
}

main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : error);
  process.exitCode = 1;
});
