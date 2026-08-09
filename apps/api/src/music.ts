import type pg from "pg";

type Database = Pick<pg.Pool, "query">;

const sourceTitle = "COALESCE(st.title,sf.title,s.title)";
const sourceJoin = (alias: string) => `LEFT JOIN source_translations st ON st.source_id=${alias}.id AND st.locale=$2 AND st.status='published'
  LEFT JOIN source_translations sf ON sf.source_id=${alias}.id AND sf.locale=$3 AND sf.status='published'`;

/** Load the music-history specialist layer without duplicating canonical people. */
export async function loadMusicAtlas(db: Database, workId: string, requestedLocale: string, fallbackLocale: string) {
  const args = [workId, requestedLocale, fallbackLocale];
  const [musicPeople, compositions, musicStyles, instruments, musicInstitutions, scoreFragments, learningUnits] = await Promise.all([
    db.query(`SELECT c.slug AS "characterSlug",p.primary_role AS "primaryRole",ch.slug AS "chapterSlug",
      COALESCE((SELECT json_agg(r.role ORDER BY r.role) FROM music_person_roles r WHERE r.character_id=p.character_id AND r.work_id=$1),'[]'::json) AS "roleCodes",
      COALESCE((SELECT json_agg(DISTINCT co.slug) FROM composition_contributors cc JOIN compositions co ON co.id=cc.composition_id WHERE cc.character_id=p.character_id AND co.work_id=$1),'[]'::json) AS "compositionSlugs",
      COALESCE((SELECT json_agg(DISTINCT ms.slug) FROM music_person_styles mps JOIN music_styles ms ON ms.id=mps.style_id WHERE mps.character_id=p.character_id AND mps.work_id=$1),'[]'::json) AS "styleSlugs",
      COALESCE((SELECT json_agg(DISTINCT i.slug) FROM music_person_instruments mpi JOIN instruments i ON i.id=mpi.instrument_id WHERE mpi.character_id=p.character_id AND mpi.work_id=$1),'[]'::json) AS "instrumentSlugs",
      COALESCE((SELECT json_agg(DISTINCT mi.slug) FROM music_person_institutions mpi JOIN music_institutions mi ON mi.id=mpi.institution_id WHERE mpi.character_id=p.character_id AND mpi.work_id=$1),'[]'::json) AS "institutionSlugs",
      COALESCE((SELECT json_agg(DISTINCT e.slug ORDER BY e.slug) FROM music_person_event_links mpe JOIN events e ON e.id=mpe.event_id WHERE mpe.character_id=p.character_id AND mpe.work_id=$1),'[]'::json) AS "eventSlugs",
      COALESCE((SELECT json_agg(${sourceTitle} ORDER BY ${sourceTitle}) FROM character_sources cs JOIN sources s ON s.id=cs.source_id ${sourceJoin("s")} WHERE cs.character_id=p.character_id AND s.work_id=$1),'[]'::json) AS "sourceTitles"
      FROM music_person_profiles p JOIN characters c ON c.id=p.character_id LEFT JOIN chapters ch ON ch.id=p.chapter_id
      WHERE p.work_id=$1 ORDER BY p.sort_order`, args),

    db.query(`SELECT co.id,co.slug,pc.slug AS "primaryComposerSlug",ch.slug AS "chapterSlug",
      co.composition_start_year AS "compositionStartYear",co.composition_end_year AS "compositionEndYear",co.composition_time_type AS "compositionTimeType",
      co.confidence,co.catalogue_number AS "catalogueNumber",co.genre,co.form,co.key_signature AS "keySignature",co.approx_duration_seconds AS "approxDurationSeconds",co.text_language AS "textLanguage",co.work_status AS "workStatus",
      COALESCE(t.title,f.title) title,COALESCE(t.alternate_titles,f.alternate_titles,'{}') AS "alternateTitles",
      COALESCE(t.summary,f.summary) summary,COALESCE(t.description,f.description,'') description,
      CASE WHEN t.title IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.title IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
      COALESCE((SELECT json_agg(DISTINCT c.slug) FROM composition_contributors cc JOIN characters c ON c.id=cc.character_id WHERE cc.composition_id=co.id AND cc.work_id=$1),'[]'::json) AS "contributorSlugs",
      COALESCE((SELECT json_agg(json_build_object('slug',c.slug,'role',cc.role) ORDER BY cc.sort_order,c.slug) FROM composition_contributors cc JOIN characters c ON c.id=cc.character_id WHERE cc.composition_id=co.id AND cc.work_id=$1),'[]'::json) AS contributors,
      COALESCE((SELECT json_agg(DISTINCT s.slug) FROM composition_styles cs JOIN music_styles s ON s.id=cs.style_id WHERE cs.composition_id=co.id AND cs.work_id=$1),'[]'::json) AS "styleSlugs",
      COALESCE((SELECT json_agg(DISTINCT i.slug) FROM composition_instruments ci JOIN instruments i ON i.id=ci.instrument_id WHERE ci.composition_id=co.id AND ci.work_id=$1),'[]'::json) AS "instrumentSlugs",
      COALESCE((SELECT json_agg(DISTINCT i.slug) FROM composition_institutions ci JOIN music_institutions i ON i.id=ci.institution_id WHERE ci.composition_id=co.id AND ci.work_id=$1),'[]'::json) AS "institutionSlugs",
      COALESCE((SELECT json_agg(DISTINCT e.slug ORDER BY e.slug) FROM composition_event_links ce JOIN events e ON e.id=ce.event_id WHERE ce.composition_id=co.id AND ce.work_id=$1),'[]'::json) AS "eventSlugs",
      COALESCE((SELECT json_agg(sf.slug ORDER BY sf.sort_order) FROM score_fragments sf WHERE sf.composition_id=co.id AND sf.work_id=$1),'[]'::json) AS "scoreFragmentSlugs",
      COALESCE((SELECT json_agg(${sourceTitle} ORDER BY ${sourceTitle}) FROM composition_sources cs JOIN sources s ON s.id=cs.source_id ${sourceJoin("s")} WHERE cs.composition_id=co.id AND s.work_id=$1),'[]'::json) AS "sourceTitles"
      FROM compositions co LEFT JOIN characters pc ON pc.id=co.primary_composer_character_id LEFT JOIN chapters ch ON ch.id=co.chapter_id
      LEFT JOIN composition_translations t ON t.composition_id=co.id AND t.locale=$2 AND t.status='published'
      LEFT JOIN composition_translations f ON f.composition_id=co.id AND f.locale=$3 AND f.status='published'
      WHERE co.work_id=$1 AND (t.title IS NOT NULL OR f.title IS NOT NULL) ORDER BY co.sort_order`, args),

    db.query(`SELECT ms.id,ms.slug,ms.style_kind AS "styleKind",ch.slug AS "chapterSlug",ms.start_year AS "startYear",ms.end_year AS "endYear",
      COALESCE(t.name,f.name) name,COALESCE(t.summary,f.summary) summary,
      CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
      COALESCE((SELECT json_agg(DISTINCT c.slug) FROM music_person_styles ps JOIN characters c ON c.id=ps.character_id WHERE ps.style_id=ms.id AND ps.work_id=$1),'[]'::json) AS "characterSlugs",
      COALESCE((SELECT json_agg(DISTINCT co.slug) FROM composition_styles cs JOIN compositions co ON co.id=cs.composition_id WHERE cs.style_id=ms.id AND cs.work_id=$1),'[]'::json) AS "compositionSlugs",
      COALESCE((SELECT json_agg(${sourceTitle} ORDER BY ${sourceTitle}) FROM music_style_sources mss JOIN sources s ON s.id=mss.source_id ${sourceJoin("s")} WHERE mss.style_id=ms.id AND s.work_id=$1),'[]'::json) AS "sourceTitles"
      FROM music_styles ms LEFT JOIN chapters ch ON ch.id=ms.chapter_id
      LEFT JOIN music_style_translations t ON t.style_id=ms.id AND t.locale=$2 AND t.status='published'
      LEFT JOIN music_style_translations f ON f.style_id=ms.id AND f.locale=$3 AND f.status='published'
      WHERE ms.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) ORDER BY ms.sort_order`, args),

    db.query(`SELECT i.id,i.slug,i.family,i.hornbostel_sachs_code AS "hornbostelSachsCode",i.mimo_term AS "mimoTerm",
      i.start_year AS "startYear",i.end_year AS "endYear",i.transposition,i.range_low AS "rangeLow",i.range_high AS "rangeHigh",
      COALESCE(t.name,f.name) name,COALESCE(t.aliases,f.aliases,'{}') aliases,COALESCE(t.summary,f.summary) summary,
      CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
      COALESCE((SELECT json_agg(DISTINCT c.slug) FROM music_person_instruments pi JOIN characters c ON c.id=pi.character_id WHERE pi.instrument_id=i.id AND pi.work_id=$1),'[]'::json) AS "characterSlugs",
      COALESCE((SELECT json_agg(DISTINCT co.slug) FROM composition_instruments ci JOIN compositions co ON co.id=ci.composition_id WHERE ci.instrument_id=i.id AND ci.work_id=$1),'[]'::json) AS "compositionSlugs",
      COALESCE((SELECT json_agg(${sourceTitle} ORDER BY ${sourceTitle}) FROM instrument_sources ins JOIN sources s ON s.id=ins.source_id ${sourceJoin("s")} WHERE ins.instrument_id=i.id AND s.work_id=$1),'[]'::json) AS "sourceTitles"
      FROM instruments i LEFT JOIN instrument_translations t ON t.instrument_id=i.id AND t.locale=$2 AND t.status='published'
      LEFT JOIN instrument_translations f ON f.instrument_id=i.id AND f.locale=$3 AND f.status='published'
      WHERE i.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) ORDER BY i.sort_order`, args),

    db.query(`SELECT i.id,i.slug,l.slug AS "locationSlug",i.institution_type AS "institutionType",i.founded_year AS "foundedYear",i.closed_year AS "closedYear",
      COALESCE(t.name,f.name) name,COALESCE(t.summary,f.summary) summary,
      CASE WHEN t.name IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.name IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
      COALESCE((SELECT json_agg(DISTINCT c.slug) FROM music_person_institutions pi JOIN characters c ON c.id=pi.character_id WHERE pi.institution_id=i.id AND pi.work_id=$1),'[]'::json) AS "characterSlugs",
      COALESCE((SELECT json_agg(DISTINCT co.slug) FROM composition_institutions ci JOIN compositions co ON co.id=ci.composition_id WHERE ci.institution_id=i.id AND ci.work_id=$1),'[]'::json) AS "compositionSlugs",
      COALESCE((SELECT json_agg(${sourceTitle} ORDER BY ${sourceTitle}) FROM music_institution_sources mis JOIN sources s ON s.id=mis.source_id ${sourceJoin("s")} WHERE mis.institution_id=i.id AND s.work_id=$1),'[]'::json) AS "sourceTitles"
      FROM music_institutions i JOIN locations l ON l.id=i.location_id
      LEFT JOIN music_institution_translations t ON t.institution_id=i.id AND t.locale=$2 AND t.status='published'
      LEFT JOIN music_institution_translations f ON f.institution_id=i.id AND f.locale=$3 AND f.status='published'
      WHERE i.work_id=$1 AND (t.name IS NOT NULL OR f.name IS NOT NULL) ORDER BY i.sort_order`, args),

    db.query(`SELECT frag.id,frag.slug,co.slug AS "compositionSlug",frag.start_measure AS "startMeasure",frag.end_measure AS "endMeasure",
      frag.notation_kind AS "notationKind",frag.mei_asset_path AS "meiAssetPath",frag.svg_asset_path AS "svgAssetPath",frag.timing_asset_path AS "timingAssetPath",
      CASE WHEN frag.rights_status='verified' THEN frag.audio_asset_path ELSE NULL END AS "audioAssetPath",
      frag.duration_seconds AS "durationSeconds",frag.tempo_bpm AS "tempoBpm",frag.tempo_basis AS "tempoBasis",frag.rights_status AS "rightsStatus",
      COALESCE(t.title,f.title) title,COALESCE(t.summary,f.summary) summary,COALESCE(t.analysis_note,f.analysis_note,'') AS "analysisNote",
      COALESCE(t.playback_disclaimer,f.playback_disclaimer,'') AS "playbackDisclaimer",
      CASE WHEN t.title IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.title IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
      COALESCE((SELECT json_agg(json_build_object('id',a.id,'targetXmlId',a.target_xml_id,'startBeat',a.start_beat,'endBeat',a.end_beat,'annotationType',a.annotation_type,'label',COALESCE(at.label,af.label,''),'explanation',COALESCE(at.explanation,af.explanation,'')) ORDER BY a.sort_order)
        FROM score_annotations a LEFT JOIN score_annotation_translations at ON at.annotation_id=a.id AND at.locale=$2 AND at.status='published'
        LEFT JOIN score_annotation_translations af ON af.annotation_id=a.id AND af.locale=$3 AND af.status='published' WHERE a.fragment_id=frag.id),'[]'::json) AS annotations,
      json_build_array(${sourceTitle}) AS "sourceTitles"
      FROM score_fragments frag JOIN compositions co ON co.id=frag.composition_id JOIN sources s ON s.id=frag.source_id ${sourceJoin("s")}
      LEFT JOIN score_fragment_translations t ON t.fragment_id=frag.id AND t.locale=$2 AND t.status='published'
      LEFT JOIN score_fragment_translations f ON f.fragment_id=frag.id AND f.locale=$3 AND f.status='published'
      WHERE frag.work_id=$1 AND (t.title IS NOT NULL OR f.title IS NOT NULL) ORDER BY frag.sort_order`, args),

    db.query(`SELECT u.id,u.slug,u.unit_kind AS "unitKind",u.difficulty,u.target_minutes AS "targetMinutes",
      COALESCE(t.title,f.title) title,COALESCE(t.summary,f.summary) summary,COALESCE(t.objective,f.objective) objective,
      CASE WHEN t.title IS NULL THEN $3::locale_code ELSE $2::locale_code END AS "resolvedLocale",(t.title IS NULL) AS "fallbackUsed",COALESCE(t.status,f.status) AS "translationStatus",
      COALESCE((SELECT json_agg(c.slug ORDER BY uc.sort_order,c.slug) FROM music_learning_unit_compositions uc JOIN compositions c ON c.id=uc.composition_id WHERE uc.unit_id=u.id AND uc.work_id=$1),'[]'::json) AS "compositionSlugs",
      COALESCE((SELECT json_agg(sf.slug ORDER BY uf.sort_order,sf.slug) FROM music_learning_unit_fragments uf JOIN score_fragments sf ON sf.id=uf.fragment_id WHERE uf.unit_id=u.id AND uf.work_id=$1),'[]'::json) AS "scoreFragmentSlugs"
      FROM music_learning_units u
      LEFT JOIN music_learning_unit_translations t ON t.unit_id=u.id AND t.locale=$2 AND t.status='published'
      LEFT JOIN music_learning_unit_translations f ON f.unit_id=u.id AND f.locale=$3 AND f.status='published'
      WHERE u.work_id=$1 AND (t.title IS NOT NULL OR f.title IS NOT NULL) ORDER BY u.sort_order`, args),
  ]);
  return {
    musicPeople: musicPeople.rows,
    compositions: compositions.rows,
    musicStyles: musicStyles.rows,
    instruments: instruments.rows,
    musicInstitutions: musicInstitutions.rows,
    scoreFragments: scoreFragments.rows,
    musicLearningUnits: learningUnits.rows,
  };
}
