import { createHash } from "node:crypto";
import { readFile, readdir } from "node:fs/promises";
import { join, resolve } from "node:path";
import pg from "pg";

/**
 * Verify the deliberately small Bible visual pilot against PostgreSQL and the
 * checked-in static media directory. The verifier is fail-closed: a missing
 * link, unclassified depiction, incomplete provenance, or checksum mismatch
 * prevents the pilot from being treated as a reusable media contract.
 */
const WORK_ID = "10000000-0000-4000-8000-000000000005";
const ROOT = resolve(process.env.ATLAS_PROJECT_ROOT ?? process.cwd());
const MEDIA_ROOT = resolve(process.env.MEDIA_DIR ?? join(ROOT, "apps/web/public/media/bible"));
const ACCEPTED_LICENSE = /^(?:Public domain|CC0|CC BY(?:-SA)? \d+(?:\.\d+)?)$/u;

type PilotExpectation = {
  entityKey: string;
  assetUrl: string;
  filename: string;
  mediaRole: "character_depiction" | "place_view" | "event_scene";
  depictionStatus: "illustrative" | "documentary";
  sourcePageUrl: string;
  checksum: string;
};

const EXPECTATIONS: readonly PilotExpectation[] = [
  {
    entityKey: "character:abraham",
    assetUrl: "/media/bible/abraham-three-angels.jpg",
    filename: "abraham-three-angels.jpg",
    mediaRole: "character_depiction",
    depictionStatus: "illustrative",
    sourcePageUrl: "https://commons.wikimedia.org/wiki/File:012.Abraham_and_the_Three_Angels.jpg",
    checksum: "d74dd373bb21dc1ec47388a9ecc3f1836d9222872a29e16b06502c69651e074c",
  },
  {
    entityKey: "event:flood-narrative-ends-at-ararat",
    assetUrl: "/media/bible/great-flood.jpg",
    filename: "great-flood.jpg",
    mediaRole: "event_scene",
    depictionStatus: "illustrative",
    sourcePageUrl: "https://commons.wikimedia.org/wiki/File:007.The_Great_Flood.jpg",
    checksum: "26e9529764d6b1cff500fb9cae92dd4585a96d98e7ae4a999c51e0fc86ef0dd4",
  },
  {
    entityKey: "location:jerusalem",
    assetUrl: "/media/bible/jerusalem-western-wall.jpg",
    filename: "jerusalem-western-wall.jpg",
    mediaRole: "place_view",
    depictionStatus: "documentary",
    sourcePageUrl: "https://commons.wikimedia.org/wiki/File:Jerusalem_Western_Wall_BW_1.JPG",
    checksum: "2c2df9fe51ddbe2846e17bc06782ed4327dce8d5c199a60c8bef4ff81c839f30",
  },
];

type MediaRow = {
  mediaId: string;
  entityKind: "character" | "event" | "location";
  entitySlug: string;
  mediaKind: "image" | "external_link";
  usageMode: "bundled" | "remote" | "external_link";
  licenseStatus: "verified" | "pending" | "rejected" | "unknown";
  mediaRole: PilotExpectation["mediaRole"] | "artwork" | "map" | "other";
  depictionStatus: PilotExpectation["depictionStatus"] | "cartographic" | "unknown";
  licenseUrl: string | null;
  sourcePageUrl: string | null;
  originalUrl: string | null;
  assetSource: string;
  license: string;
  author: string;
  assetUrl: string;
  attribution: string;
  altZh: string;
  altEn: string;
  sourceId: string | null;
  sourceType: string | null;
  zhSourceCount: number;
  enSourceCount: number;
};

function fail(message: string): never {
  throw new Error(`Bible visual media verification failed: ${message}`);
}

async function main(): Promise<void> {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) fail("DATABASE_URL is required");
  const pool = new pg.Pool({ connectionString: databaseUrl });
  try {
    const result = await pool.query<MediaRow>(
      `SELECT ma.id AS "mediaId",ml.entity_kind AS "entityKind",
        COALESCE(c.slug,e.slug,l.slug) AS "entitySlug",
        ma.media_kind AS "mediaKind",ma.usage_mode AS "usageMode",ma.license_status AS "licenseStatus",
        ma.media_role AS "mediaRole",ma.depiction_status AS "depictionStatus",ma.license_url AS "licenseUrl",
        ma.source_page_url AS "sourcePageUrl",ma.original_url AS "originalUrl",ma.asset_source AS "assetSource",
        ma.asset_licence AS license,ma.asset_author AS author,ma.asset_url AS "assetUrl",
        ma.attribution_text AS attribution,ma.alt_text_zh AS "altZh",ma.alt_text_en AS "altEn",
        ma.source_id AS "sourceId",s.source_type AS "sourceType",
        (SELECT count(*)::int FROM source_translations st WHERE st.source_id=ma.source_id AND st.locale='zh-CN' AND st.status='published') AS "zhSourceCount",
        (SELECT count(*)::int FROM source_translations st WHERE st.source_id=ma.source_id AND st.locale='en' AND st.status='published') AS "enSourceCount"
       FROM media_assets ma
       JOIN media_links ml ON ml.media_id=ma.id
       LEFT JOIN characters c ON ml.entity_kind='character' AND c.id=ml.entity_id
       LEFT JOIN events e ON ml.entity_kind='event' AND e.id=ml.entity_id
       LEFT JOIN locations l ON ml.entity_kind='location' AND l.id=ml.entity_id
       LEFT JOIN sources s ON s.id=ma.source_id
       WHERE s.work_id=$1 AND ma.asset_url LIKE '/media/bible/%'
       ORDER BY ml.entity_kind,ml.entity_id`,
      [WORK_ID],
    );
    if (result.rows.length !== EXPECTATIONS.length) fail(`expected ${EXPECTATIONS.length} pilot links, found ${result.rows.length}`);

    const expectedByEntity = new Map(EXPECTATIONS.map((item) => [item.entityKey, item]));
    const actualFiles = new Set<string>();
    const mediaIds = new Set<string>();
    for (const row of result.rows) {
      const expectation = expectedByEntity.get(`${row.entityKind}:${row.entitySlug}`);
      if (!expectation) fail(`unexpected pilot entity ${row.entityKind}:${row.entitySlug}`);
      if (mediaIds.has(row.mediaId)) fail(`media asset ${row.mediaId} is linked more than once in the pilot`);
      mediaIds.add(row.mediaId);
      if (row.mediaKind !== "image" || row.usageMode !== "bundled" || row.licenseStatus !== "verified") fail(`${expectation.entityKey} is not image/bundled/verified`);
      if (row.mediaRole !== expectation.mediaRole || row.depictionStatus !== expectation.depictionStatus) fail(`${expectation.entityKey} has an incorrect visual context`);
      if (row.license !== "Public domain" || !ACCEPTED_LICENSE.test(row.license)) fail(`${expectation.entityKey} has non-whitelisted licence ${row.license}`);
      if (!row.licenseUrl?.startsWith("https://") || row.licenseUrl !== "https://creativecommons.org/publicdomain/mark/1.0/") fail(`${expectation.entityKey} has no explicit HTTPS public-domain licence URL`);
      if (row.sourcePageUrl !== expectation.sourcePageUrl || !row.originalUrl?.startsWith("https://upload.wikimedia.org/")) fail(`${expectation.entityKey} has incomplete HTTPS provenance URLs`);
      if (row.assetSource !== "Wikimedia Commons" || row.sourceType !== "image" || !row.sourceId) fail(`${expectation.entityKey} has incomplete source provenance`);
      if (row.zhSourceCount !== 1 || row.enSourceCount !== 1) fail(`${expectation.entityKey} source translations are not bilingual/published`);
      if (!row.author.trim() || !row.attribution.trim() || !row.altZh.trim() || !row.altEn.trim()) fail(`${expectation.entityKey} has empty author, attribution, or alt text`);
      if (row.assetUrl !== expectation.assetUrl) fail(`${expectation.entityKey} has unexpected asset URL ${row.assetUrl}`);

      const fileName = row.assetUrl.slice("/media/bible/".length);
      if (fileName !== expectation.filename || !/^[A-Za-z0-9._-]+$/u.test(fileName)) fail(`${expectation.entityKey} has an unsafe media filename`);
      actualFiles.add(fileName);
      const bytes = await readFile(join(MEDIA_ROOT, fileName)).catch(() => null);
      if (!bytes || bytes.length < 1024) fail(`${expectation.entityKey} local file is missing or unexpectedly small`);
      const checksum = createHash("sha256").update(bytes).digest("hex");
      if (checksum !== expectation.checksum) fail(`${expectation.entityKey} checksum differs from the retrieved pilot asset`);
    }

    const expectedFiles = new Set(EXPECTATIONS.map((item) => item.filename));
    const directoryFiles = new Set(await readdir(MEDIA_ROOT));
    const stale = [...directoryFiles].filter((file) => !expectedFiles.has(file));
    const missing = [...expectedFiles].filter((file) => !directoryFiles.has(file));
    if (stale.length > 0 || missing.length > 0 || actualFiles.size !== expectedFiles.size) fail(`media directory mismatch; stale=${stale.join(",") || "none"}, missing=${missing.join(",") || "none"}`);
    console.log(`Bible visual media verified: ${result.rows.length} bundled public-domain images across character, event, and location contexts`);
    console.log(`Bible media directory verified: ${directoryFiles.size} files with matching SHA-256 checksums`);
  } finally {
    await pool.end();
  }
}

main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : error);
  process.exitCode = 1;
});
