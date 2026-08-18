import type pg from "pg";

type Database = Pick<pg.Pool, "query">;

/**
 * Bible art/music layer: symbolic identity, verse-level provenance, verified
 * public-domain speech, and reception links into the music atlas.
 *
 * Cross-work links are resolved here rather than returned as raw ids. The Bible
 * payload never carries the music atlas, so a drawer that wants to play
 * Palestrina alongside Jerusalem needs the composition title, the composer and
 * one playable fragment inlined — otherwise the client would have to fetch a
 * second, much larger atlas just to render a card.
 */
export async function loadBibleArtMusic(db: Database, workId: string, requestedLocale: string, fallbackLocale: string) {
  const args = [workId, requestedLocale, fallbackLocale];
  const [characterEmblems, chapterEmblems, scriptureRefs, quotes, crossWorkMusic] = await Promise.all([
    db.query(`SELECT c.slug AS "characterSlug",e.symbol_key AS "symbolKey",e.ring_key AS "ringKey",e.ground_key AS "groundKey",e.attestation,
      COALESCE(t.symbol_name,f.symbol_name) AS "symbolName",COALESCE(t.symbol_meaning,f.symbol_meaning) AS "symbolMeaning",
      COALESCE(t.attribution_note,f.attribution_note) AS "attributionNote"
      FROM character_emblems e JOIN characters c ON c.id=e.character_id
      LEFT JOIN character_emblem_translations t ON t.character_id=e.character_id AND t.locale=$2 AND t.status='published'
      LEFT JOIN character_emblem_translations f ON f.character_id=e.character_id AND f.locale=$3 AND f.status='published'
      WHERE e.work_id=$1 AND (t.symbol_name IS NOT NULL OR f.symbol_name IS NOT NULL) ORDER BY e.sort_order`, args),

    db.query(`SELECT ch.slug AS "chapterSlug",e.symbol_key AS "symbolKey",
      COALESCE(t.symbol_name,f.symbol_name) AS "symbolName",COALESCE(t.symbol_meaning,f.symbol_meaning) AS "symbolMeaning"
      FROM chapter_emblems e JOIN chapters ch ON ch.id=e.chapter_id
      LEFT JOIN chapter_emblem_translations t ON t.chapter_id=e.chapter_id AND t.locale=$2 AND t.status='published'
      LEFT JOIN chapter_emblem_translations f ON f.chapter_id=e.chapter_id AND f.locale=$3 AND f.status='published'
      WHERE e.work_id=$1 AND (t.symbol_name IS NOT NULL OR f.symbol_name IS NOT NULL) ORDER BY e.sort_order`, args),

    db.query(`SELECT r.id,e.slug AS "eventSlug",r.osis_ref AS "osisRef",r.book_osis AS "bookOsis",
      r.chapter_number AS "chapterNumber",r.verse_start AS "verseStart",r.verse_end AS "verseEnd",r.ref_role AS "refRole"
      FROM event_scripture_refs r JOIN events e ON e.id=r.event_id
      WHERE r.work_id=$1 ORDER BY r.sort_order`, [workId]),

    // Only verse-verified, published translations are exposed. A quote that has
    // not been proved against a public-domain text stays out of the payload
    // rather than shipping with a quiet caveat nobody reads.
    db.query(`SELECT q.id,c.slug AS "characterSlug",e.slug AS "eventSlug",q.osis_ref AS "osisRef",
      q.speech_kind AS "speechKind",q.importance,
      COALESCE(t.quote_text,f.quote_text) AS "quoteText",COALESCE(t.reference_label,f.reference_label) AS "referenceLabel",
      COALESCE(t.context_note,f.context_note,'') AS "contextNote",COALESCE(t.translation_edition,f.translation_edition) AS "translationEdition",
      COALESCE(t.script_variant,f.script_variant) AS "scriptVariant",COALESCE(t.verified_source_url,f.verified_source_url) AS "verifiedSourceUrl",
      -- Almost every saying is a cut from a longer verse. Whether it is an
      -- excerpt is derivable from the stored verse, so derive it rather than
      -- asking an editor to remember to tick a box.
      (COALESCE(t.quote_text,f.quote_text) <> btrim(COALESCE(t.source_verse_text,f.source_verse_text))) AS "isExcerpt",
      CASE WHEN t.quote_text IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",
      (t.quote_text IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus"
      FROM character_quotes q JOIN characters c ON c.id=q.character_id LEFT JOIN events e ON e.id=q.event_id
      LEFT JOIN character_quote_translations t ON t.quote_id=q.id AND t.locale=$2 AND t.status='published' AND t.text_status='source_verified'
      LEFT JOIN character_quote_translations f ON f.quote_id=q.id AND f.locale=$3 AND f.status='published' AND f.text_status='source_verified'
      WHERE q.work_id=$1 AND (t.quote_text IS NOT NULL OR f.quote_text IS NOT NULL)
      ORDER BY q.importance DESC,q.sort_order`, args),

    db.query(`SELECT l.id,l.from_entity_kind AS "fromEntityKind",
      COALESCE(fc.slug,fe.slug,fl.slug) AS "fromSlug",l.link_type AS "linkType",l.confidence,
      COALESCE(lt.label,lf.label) AS label,COALESCE(lt.basis_note,lf.basis_note) AS "basisNote",
      tw.slug AS "targetWorkSlug",co.slug AS "compositionSlug",
      COALESCE(ct.title,cf.title) AS "compositionTitle",
      co.composition_start_year AS "compositionYear",
      COALESCE(pt.name,pf.name,'') AS "composerName",
      frag.slug AS "fragmentSlug",frag.audio_asset_path AS "audioAssetPath",frag.svg_asset_path AS "svgAssetPath",
      frag.duration_seconds AS "durationSeconds",
      COALESCE(ft.playback_disclaimer,ff.playback_disclaimer,'') AS "playbackDisclaimer"
      FROM cross_work_links l
      JOIN works tw ON tw.id=l.to_work_id
      LEFT JOIN characters fc ON l.from_entity_kind='character' AND fc.id=l.from_entity_id
      LEFT JOIN events fe ON l.from_entity_kind='event' AND fe.id=l.from_entity_id
      LEFT JOIN locations fl ON l.from_entity_kind='location' AND fl.id=l.from_entity_id
      JOIN compositions co ON co.id=l.to_entity_id AND l.to_entity_kind='composition'
      LEFT JOIN composition_translations ct ON ct.composition_id=co.id AND ct.locale=$2 AND ct.status='published'
      LEFT JOIN composition_translations cf ON cf.composition_id=co.id AND cf.locale=$3 AND cf.status='published'
      LEFT JOIN characters pc ON pc.id=co.primary_composer_character_id
      LEFT JOIN character_translations pt ON pt.character_id=pc.id AND pt.locale=$2 AND pt.status='published'
      LEFT JOIN character_translations pf ON pf.character_id=pc.id AND pf.locale=$3 AND pf.status='published'
      LEFT JOIN LATERAL (
        SELECT sf.slug,sf.audio_asset_path,sf.svg_asset_path,sf.duration_seconds,sf.id
          FROM score_fragments sf
         WHERE sf.composition_id=co.id AND sf.rights_status='verified' AND sf.audio_asset_path IS NOT NULL
         ORDER BY sf.sort_order LIMIT 1
      ) frag ON true
      LEFT JOIN score_fragment_translations ft ON ft.fragment_id=frag.id AND ft.locale=$2 AND ft.status='published'
      LEFT JOIN score_fragment_translations ff ON ff.fragment_id=frag.id AND ff.locale=$3 AND ff.status='published'
      LEFT JOIN cross_work_link_translations lt ON lt.link_id=l.id AND lt.locale=$2 AND lt.status='published'
      LEFT JOIN cross_work_link_translations lf ON lf.link_id=l.id AND lf.locale=$3 AND lf.status='published'
      WHERE l.from_work_id=$1 AND (lt.label IS NOT NULL OR lf.label IS NOT NULL)
      ORDER BY l.sort_order`, args),
  ]);
  return {
    characterEmblems: characterEmblems.rows,
    chapterEmblems: chapterEmblems.rows,
    scriptureRefs: scriptureRefs.rows,
    quotes: quotes.rows,
    crossWorkMusic: crossWorkMusic.rows,
  };
}
