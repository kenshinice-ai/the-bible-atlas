import { createHash } from "node:crypto";
import { readFile, readdir } from "node:fs/promises";
import { join, relative, resolve } from "node:path";
import pg from "pg";

/**
 * Verify every bundled Bible visual asset against PostgreSQL and the checked-in
 * media directory. The verifier is fail-closed: a missing link, unclassified
 * depiction, incomplete provenance, or checksum mismatch prevents the media set
 * from being treated as a shippable contract.
 *
 * This started as a frozen three-item list for the 2026-08-09 pilot. It is now
 * driven by the database instead, because a hardcoded list stops being a check
 * the moment a batch lands: it either blocks the batch or gets edited to match
 * it. What stays hardcoded is the *policy* — which licences are acceptable,
 * which provenance fields must be present, which roles a Bible asset may take —
 * plus an explicit allowlist for generated art that has no upstream rights
 * holder, so an unexplained file in the media tree still fails the run.
 */
const WORK_ID = "10000000-0000-4000-8000-000000000005";
const ROOT = resolve(process.env.ATLAS_PROJECT_ROOT ?? process.cwd());
const MEDIA_ROOT = resolve(process.env.MEDIA_DIR ?? join(ROOT, "apps/web/public/media/bible"));
const ACCEPTED_LICENSE = /^(?:Public domain|CC0|CC BY(?:-SA)? \d+(?:\.\d+)?)$/u;
const PD_MARK = "https://creativecommons.org/publicdomain/mark/1.0/";
const ALLOWED_ROLES = new Set(["character_depiction", "place_view", "event_scene", "map"]);
const ALLOWED_STATUSES = new Set(["illustrative", "documentary", "cartographic"]);

/**
 * Assets this atlas generated itself. They carry a manifest checksum rather
 * than a Commons file page, so they are checked against that manifest instead
 * of against the rights contract.
 */
const GENERATED_ASSETS: readonly { file: string; manifest: string }[] = [
  { file: "atlas-overview-v1.svg", manifest: "docs/generated/bible-atlas-overview-v1.manifest.json" },
];

type MediaRow = {
  mediaId: string;
  entityKind: "character" | "event" | "location";
  entitySlug: string | null;
  mediaKind: string;
  usageMode: string;
  licenseStatus: string;
  mediaRole: string;
  depictionStatus: string;
  licenseUrl: string | null;
  sourcePageUrl: string | null;
  originalUrl: string | null;
  retrievedAt: Date | null;
  checksum: string | null;
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

/** Every file under the media root, as paths relative to it. */
async function walk(directory: string): Promise<string[]> {
  const entries = await readdir(directory, { withFileTypes: true });
  const files: string[] = [];
  for (const entry of entries) {
    const full = join(directory, entry.name);
    if (entry.isDirectory()) files.push(...await walk(full));
    else files.push(relative(MEDIA_ROOT, full));
  }
  return files;
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
        ma.source_page_url AS "sourcePageUrl",ma.original_url AS "originalUrl",ma.retrieved_at AS "retrievedAt",
        ma.checksum_sha256 AS checksum,ma.asset_source AS "assetSource",
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
       ORDER BY ma.asset_url`,
      [WORK_ID],
    );
    if (result.rows.length === 0) fail("no Bible visual media are linked at all");

    const seenFiles = new Set<string>();
    const seenMedia = new Set<string>();
    for (const row of result.rows) {
      const where = `${row.entityKind}:${row.entitySlug ?? "?"} (${row.assetUrl})`;
      if (!row.entitySlug) fail(`${where} links to an entity that does not belong to this work`);
      if (seenMedia.has(row.mediaId)) fail(`media asset ${row.mediaId} is linked more than once`);
      seenMedia.add(row.mediaId);
      if (row.mediaKind !== "image" || row.usageMode !== "bundled" || row.licenseStatus !== "verified") fail(`${where} is not image/bundled/verified`);
      if (!ALLOWED_ROLES.has(row.mediaRole) || !ALLOWED_STATUSES.has(row.depictionStatus)) fail(`${where} has an unclassified visual context (${row.mediaRole}/${row.depictionStatus})`);
      if (row.mediaRole === "character_depiction" && row.depictionStatus !== "illustrative") fail(`${where} presents a character depiction as something other than illustrative`);
      if (!ACCEPTED_LICENSE.test(row.license)) fail(`${where} has non-whitelisted licence ${row.license}`);
      if (row.license === "Public domain" && row.licenseUrl !== PD_MARK) fail(`${where} has no explicit public-domain licence URL`);
      if (!row.licenseUrl?.startsWith("https://")) fail(`${where} has no HTTPS licence URL`);
      if (!row.sourcePageUrl?.startsWith("https://commons.wikimedia.org/wiki/File:")) fail(`${where} has no Commons file page`);
      if (!row.originalUrl?.startsWith("https://upload.wikimedia.org/")) fail(`${where} has no upstream file URL`);
      if (row.assetSource !== "Wikimedia Commons" || row.sourceType !== "image" || !row.sourceId) fail(`${where} has incomplete source provenance`);
      if (row.zhSourceCount !== 1 || row.enSourceCount !== 1) fail(`${where} source translations are not bilingual/published`);
      if (!row.author.trim() || !row.attribution.trim() || !row.altZh.trim() || !row.altEn.trim()) fail(`${where} has empty author, attribution, or alt text`);
      if (!row.retrievedAt) fail(`${where} has no retrieval timestamp`);
      if (!row.checksum || !/^[0-9a-f]{64}$/u.test(row.checksum)) fail(`${where} has no SHA-256`);

      const relativePath = row.assetUrl.slice("/media/bible/".length);
      if (!/^(?:[A-Za-z0-9._-]+\/)?[A-Za-z0-9._-]+$/u.test(relativePath)) fail(`${where} has an unsafe media path`);
      const bytes = await readFile(join(MEDIA_ROOT, relativePath)).catch(() => null);
      if (!bytes || bytes.length < 4096) fail(`${where} local file is missing or unexpectedly small`);
      if (createHash("sha256").update(bytes).digest("hex") !== row.checksum) fail(`${where} checksum differs from the retrieved asset`);
      seenFiles.add(relativePath);
    }

    // Generated artwork: no upstream rights holder, so the manifest is the
    // contract. A drifted checksum here means the committed art no longer
    // matches what the generator produced from the database.
    for (const generated of GENERATED_ASSETS) {
      const manifest = JSON.parse(await readFile(join(ROOT, generated.manifest), "utf8")) as { sha256?: string; generatorVersion?: string };
      const bytes = await readFile(join(MEDIA_ROOT, generated.file)).catch(() => null);
      if (!bytes) fail(`generated asset ${generated.file} is missing`);
      if (!manifest.sha256 || !manifest.generatorVersion) fail(`${generated.manifest} does not record a checksum and generator version`);
      if (createHash("sha256").update(bytes).digest("hex") !== manifest.sha256) fail(`${generated.file} does not match ${generated.manifest}`);
      seenFiles.add(generated.file);
    }

    const onDisk = new Set(await walk(MEDIA_ROOT));
    const stale = [...onDisk].filter((file) => !seenFiles.has(file));
    const missing = [...seenFiles].filter((file) => !onDisk.has(file));
    if (stale.length > 0 || missing.length > 0) fail(`media directory mismatch; stale=${stale.join(",") || "none"}, missing=${missing.join(",") || "none"}`);

    const byRole = new Map<string, number>();
    for (const row of result.rows) byRole.set(row.mediaRole, (byRole.get(row.mediaRole) ?? 0) + 1);
    const roles = [...byRole].sort().map(([role, count]) => `${role} ${count}`).join(", ");
    console.log(`Bible visual media verified: ${result.rows.length} bundled rights-audited images (${roles})`);
    console.log(`Bible media directory verified: ${onDisk.size} files with matching SHA-256 checksums, including ${GENERATED_ASSETS.length} generated asset(s)`);
  } finally {
    await pool.end();
  }
}

main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : error);
  process.exitCode = 1;
});
