import { createHash } from "node:crypto";
import { readFile } from "node:fs/promises";
import { join, resolve } from "node:path";
import pg from "pg";

/**
 * Fail-closed verifier for the Bible art/music layer
 * (docs/BIBLE_ART_MUSIC_UPGRADE_PLAN_2026-08-18.md).
 *
 * The checks that matter here are the ones that protect claims the product
 * makes to a reader:
 *
 *   - an emblem says "tradition marks this person this way", so every emblem
 *     must name its attestation level and carry bilingual published prose;
 *   - a scripture reference says "you can check this", so every reference must
 *     be structurally resolvable and consistent with its own OSIS string;
 *   - a quote says "these are the words", so no quote may reach a reader
 *     without a public-domain edition, a retrievable source, and proof that the
 *     shown excerpt is literally contained in the verse it cites;
 *   - a music link says "this piece sets that passage", so it must resolve to
 *     a real composition in another work with a playable, rights-verified
 *     fragment behind it.
 */
const ROOT = resolve(process.env.ATLAS_PROJECT_ROOT ?? process.cwd());
const BIBLE = "10000000-0000-4000-8000-000000000005";
const MUSIC = "10000000-0000-4000-8000-000000000010";
const OVERVIEW_MANIFEST = join(ROOT, "docs/generated/bible-atlas-overview-v1.manifest.json");
const OVERVIEW_ASSET = join(ROOT, "apps/web/public/media/bible/atlas-overview-v1.svg");
const PD_EDITIONS = new Set(["CUV-1919", "WEB"]);
const OSIS_REF = /^[1-4]?[A-Za-z]+\.\d+(?:\.\d+(?:-[1-4]?[A-Za-z]+\.\d+\.\d+)?)?$/u;

const problems: string[] = [];
const check = (condition: boolean, message: string): void => { if (!condition) problems.push(message); };

async function main(): Promise<void> {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) throw new Error("DATABASE_URL is required");
  const pool = new pg.Pool({ connectionString: databaseUrl });
  try {
    // ---- emblems ---------------------------------------------------------
    const emblems = await pool.query<{
      slug: string; symbolKey: string; attestation: string; locales: string; names: string; notes: string;
    }>(`SELECT c.slug, e.symbol_key AS "symbolKey", e.attestation,
          (SELECT count(*)::text FROM character_emblem_translations t WHERE t.character_id=e.character_id AND t.status='published') AS locales,
          (SELECT count(*)::text FROM character_emblem_translations t WHERE t.character_id=e.character_id AND btrim(t.symbol_name)='') AS names,
          (SELECT count(*)::text FROM character_emblem_translations t WHERE t.character_id=e.character_id AND btrim(t.attribution_note)='') AS notes
        FROM character_emblems e JOIN characters c ON c.id=e.character_id
        WHERE e.work_id=$1 ORDER BY c.slug`, [BIBLE]);
    check(emblems.rows.length > 0, "no character emblems are loaded");
    for (const row of emblems.rows) {
      check(Number(row.locales) === 2, `emblem ${row.slug} is not published in both locales`);
      check(Number(row.names) === 0 && Number(row.notes) === 0, `emblem ${row.slug} has an empty symbol name or attribution note`);
      check(["scriptural", "liturgical", "iconographic"].includes(row.attestation), `emblem ${row.slug} has an unknown attestation level`);
    }
    // A symbol shared by two people is fine heraldically only if the emblems
    // are differenced; identical symbol + ring + ground would be unreadable.
    const collisions = await pool.query<{ signature: string; slugs: string }>(
      `SELECT e.symbol_key||'/'||e.ring_key||'/'||e.ground_key AS signature, string_agg(c.slug,',' ORDER BY c.slug) AS slugs
         FROM character_emblems e JOIN characters c ON c.id=e.character_id
        WHERE e.work_id=$1 GROUP BY 1 HAVING count(*)>1`, [BIBLE]);
    for (const row of collisions.rows) problems.push(`emblem signature ${row.signature} is shared without differencing by ${row.slugs}`);

    const eraEmblems = await pool.query<{ slug: string; locales: string }>(
      `SELECT ch.slug, (SELECT count(*)::text FROM chapter_emblem_translations t WHERE t.chapter_id=e.chapter_id AND t.status='published') AS locales
         FROM chapter_emblems e JOIN chapters ch ON ch.id=e.chapter_id WHERE e.work_id=$1 ORDER BY ch.slug`, [BIBLE]);
    const eraCount = await pool.query<{ count: string }>(`SELECT count(*)::text FROM chapters WHERE work_id=$1`, [BIBLE]);
    check(eraEmblems.rows.length === Number(eraCount.rows[0]!.count), `era emblems cover ${eraEmblems.rows.length} of ${eraCount.rows[0]!.count} eras`);
    for (const row of eraEmblems.rows) check(Number(row.locales) === 2, `era emblem ${row.slug} is not published in both locales`);

    // ---- scripture references -------------------------------------------
    const refs = await pool.query<{
      eventSlug: string; osisRef: string; bookOsis: string; chapterNumber: number; verseStart: number | null; verseEnd: number | null; refRole: string;
    }>(`SELECT e.slug AS "eventSlug", r.osis_ref AS "osisRef", r.book_osis AS "bookOsis", r.chapter_number AS "chapterNumber",
          r.verse_start AS "verseStart", r.verse_end AS "verseEnd", r.ref_role AS "refRole"
        FROM event_scripture_refs r JOIN events e ON e.id=r.event_id
        WHERE r.work_id=$1 ORDER BY r.sort_order`, [BIBLE]);
    check(refs.rows.length > 0, "no scripture references are loaded");
    for (const row of refs.rows) {
      check(OSIS_REF.test(row.osisRef), `scripture ref ${row.osisRef} is not a usable OSIS reference`);
      // The structured columns exist so the UI never has to parse the string;
      // if they disagree with it, one of the two is lying to a reader.
      const [start] = row.osisRef.split("-");
      const parts = start!.split(".");
      check(parts[0] === row.bookOsis, `scripture ref ${row.osisRef} (${row.eventSlug}) disagrees with its book column`);
      check(Number(parts[1]) === row.chapterNumber, `scripture ref ${row.osisRef} (${row.eventSlug}) disagrees with its chapter column`);
      if (row.verseStart !== null && row.verseEnd !== null) {
        check(row.verseEnd >= row.verseStart, `scripture ref ${row.osisRef} (${row.eventSlug}) ends before it starts`);
      }
      check(["primary", "parallel", "background"].includes(row.refRole), `scripture ref ${row.osisRef} has an unknown role`);
    }
    const orphanEvents = await pool.query<{ count: string }>(
      `SELECT count(*)::text FROM event_scripture_refs r JOIN events e ON e.id=r.event_id WHERE r.work_id=$1 AND e.work_id<>$1`, [BIBLE]);
    check(orphanEvents.rows[0]!.count === "0", "a scripture reference points at an event from another work");

    // ---- quotes ----------------------------------------------------------
    // 「表白」 first reads as declaring romantic love in current Chinese; a
    // confession of faith is 「认信」. The label lives in the web bundle, so the
    // check lives here: a regression would be silent otherwise.
    const speechLabels = await readFile(join(ROOT, "apps/web/src/i18n.ts"), "utf8");
    check(/confession: \["认信"/u.test(speechLabels), "the zh-CN label for `confession` is not 认信");
    check(!/confession: \["表白"/u.test(speechLabels), "`confession` is labelled 表白, which reads as a declaration of love");

    const quotes = await pool.query<{
      characterSlug: string; osisRef: string; locale: string; quoteText: string; edition: string; scriptVariant: string;
      textStatus: string; textSha: string; verseText: string; verseSha: string; sourceUrl: string | null; verifiedAt: Date | null;
      status: string; referenceLabel: string;
    }>(`SELECT c.slug AS "characterSlug", q.osis_ref AS "osisRef", t.locale, t.quote_text AS "quoteText",
          t.translation_edition AS edition, t.script_variant AS "scriptVariant", t.text_status AS "textStatus",
          t.text_sha256 AS "textSha", t.source_verse_text AS "verseText", t.source_verse_sha256 AS "verseSha",
          t.verified_source_url AS "sourceUrl", t.verified_at AS "verifiedAt", t.status, t.reference_label AS "referenceLabel"
        FROM character_quotes q JOIN characters c ON c.id=q.character_id
        JOIN character_quote_translations t ON t.quote_id=q.id
        WHERE q.work_id=$1 ORDER BY c.slug, q.osis_ref, t.locale`, [BIBLE]);
    check(quotes.rows.length > 0, "no quotes are loaded");
    const byQuote = new Map<string, number>();
    for (const row of quotes.rows) {
      const where = `quote ${row.characterSlug} ${row.osisRef} (${row.locale})`;
      byQuote.set(`${row.characterSlug}:${row.osisRef}`, (byQuote.get(`${row.characterSlug}:${row.osisRef}`) ?? 0) + 1);
      check(PD_EDITIONS.has(row.edition), `${where} cites a non-public-domain edition ${row.edition}`);
      check(row.status === "published", `${where} is not published`);
      check(row.referenceLabel.trim().length > 0, `${where} has no human-readable reference label`);
      check(createHash("sha256").update(row.quoteText).digest("hex") === row.textSha, `${where} checksum does not match its own text`);
      check(row.textStatus === "source_verified", `${where} has not been checked against a public-domain source`);
      if (row.textStatus !== "source_verified") continue;
      check(Boolean(row.sourceUrl?.startsWith("https://")), `${where} claims verification without an HTTPS source`);
      check(row.verifiedAt !== null, `${where} claims verification without a timestamp`);
      check(createHash("sha256").update(row.verseText).digest("hex") === row.verseSha, `${where} retrieved-verse checksum does not match`);
      // The containment rule: what a reader sees must be inside what was
      // fetched, ignoring the CUV's inline 〔…〕 apparatus, which is a critical
      // mark printed among the words rather than part of the translation.
      check(row.verseText.replace(/〔[^〕]*〕/gu, "").includes(row.quoteText), `${where} excerpt is not contained in the verse that was retrieved`);
      if (row.locale === "zh-CN") check(row.scriptVariant === "han-traditional", `${where} does not declare the CUV's published script`);
    }
    for (const [key, count] of byQuote) check(count === 2, `quote ${key} is not present in both locales (${count})`);

    // ---- cross-work music links -----------------------------------------
    const links = await pool.query<{
      fromKind: string; fromSlug: string | null; linkType: string; composition: string; fragments: string; locales: string; basisEmpty: string;
    }>(`SELECT l.from_entity_kind AS "fromKind", COALESCE(c.slug,e.slug,lo.slug) AS "fromSlug", l.link_type AS "linkType",
          co.slug AS composition,
          (SELECT count(*)::text FROM score_fragments f WHERE f.composition_id=co.id AND f.rights_status='verified' AND f.audio_asset_path IS NOT NULL) AS fragments,
          (SELECT count(*)::text FROM cross_work_link_translations t WHERE t.link_id=l.id AND t.status='published') AS locales,
          (SELECT count(*)::text FROM cross_work_link_translations t WHERE t.link_id=l.id AND btrim(t.basis_note)='') AS "basisEmpty"
        FROM cross_work_links l
        JOIN compositions co ON co.id=l.to_entity_id
        LEFT JOIN characters c ON l.from_entity_kind='character' AND c.id=l.from_entity_id
        LEFT JOIN events e ON l.from_entity_kind='event' AND e.id=l.from_entity_id
        LEFT JOIN locations lo ON l.from_entity_kind='location' AND lo.id=l.from_entity_id
        WHERE l.from_work_id=$1 AND l.to_work_id=$2 ORDER BY l.sort_order`, [BIBLE, MUSIC]);
    check(links.rows.length > 0, "no cross-work music links are loaded");
    for (const row of links.rows) {
      const where = `music link ${row.fromKind}:${row.fromSlug ?? "?"} -> ${row.composition}`;
      check(row.fromSlug !== null, `${where} starts from an entity outside the Bible work`);
      check(Number(row.fragments) > 0, `${where} has no rights-verified playable fragment behind it`);
      check(Number(row.locales) === 2, `${where} is not published in both locales`);
      check(Number(row.basisEmpty) === 0, `${where} has an empty basis note; a reception claim needs a stated reason`);
      check(["musical_setting", "musical_reception"].includes(row.linkType), `${where} has an unknown link type`);
    }

    // ---- generated overview ---------------------------------------------
    const manifest = JSON.parse(await readFile(OVERVIEW_MANIFEST, "utf8")) as { sha256?: string; generatorVersion?: string; inputs?: { locatedPlaces?: number } };
    const svg = await readFile(OVERVIEW_ASSET);
    check(createHash("sha256").update(svg).digest("hex") === manifest.sha256, "the illuminated overview does not match its manifest checksum");
    check(Boolean(manifest.generatorVersion), "the illuminated overview manifest records no generator version");
    const located = await pool.query<{ count: string }>(`SELECT count(*)::text FROM locations WHERE work_id=$1 AND geom IS NOT NULL`, [BIBLE]);
    check(manifest.inputs?.locatedPlaces === Number(located.rows[0]!.count),
      `the illuminated overview was generated from ${manifest.inputs?.locatedPlaces} places but the database now has ${located.rows[0]!.count}`);

    if (problems.length > 0) {
      console.error(`Bible art/music verification failed; ${problems.length} problem(s):`);
      for (const problem of problems) console.error(`  - ${problem}`);
      process.exitCode = 1;
      return;
    }
    console.log(`Bible emblems verified: ${emblems.rows.length} person emblems + ${eraEmblems.rows.length} era emblems, bilingual and attested`);
    console.log(`Bible scripture verified: ${refs.rows.length} references consistent with their OSIS strings`);
    console.log(`Bible quotes verified: ${byQuote.size} sayings, ${quotes.rows.length} translations, all excerpts contained in a retrieved public-domain verse`);
    console.log(`Bible music links verified: ${links.rows.length} reception links, each backed by a playable rights-verified fragment`);
    console.log(`Bible illuminated overview verified against ${manifest.generatorVersion}`);
  } finally {
    await pool.end();
  }
}

main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : error);
  process.exitCode = 1;
});
