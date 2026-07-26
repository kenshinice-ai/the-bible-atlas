BEGIN;

-- The era-expansion seeds (010–022) inserted character_relations without
-- relation_translations, and the API only returns a relation once a published
-- label exists — so 170 of the Bible's 272 relations were invisible in the UI.
-- Backfill a baseline bilingual label from the relation type; richer per-pair
-- labels can replace these in a later content pass (the WHERE NOT EXISTS guard
-- makes this seed safe to re-run and keeps it from touching curated rows).

INSERT INTO relation_translations(relation_id, locale, label, summary, status)
SELECT r.id, v.locale::locale_code,
       CASE r.relation_type
         WHEN 'family' THEN CASE v.locale WHEN 'zh-CN' THEN '亲属' ELSE 'Family' END
         WHEN 'spouse' THEN CASE v.locale WHEN 'zh-CN' THEN '配偶' ELSE 'Spouse' END
         WHEN 'sibling' THEN CASE v.locale WHEN 'zh-CN' THEN '兄弟姐妹' ELSE 'Siblings' END
         WHEN 'ally' THEN CASE v.locale WHEN 'zh-CN' THEN '同盟' ELSE 'Ally' END
         WHEN 'adversary' THEN CASE v.locale WHEN 'zh-CN' THEN '对立' ELSE 'Adversary' END
         WHEN 'mentor' THEN CASE v.locale WHEN 'zh-CN' THEN '师承' ELSE 'Mentor' END
         WHEN 'romantic' THEN CASE v.locale WHEN 'zh-CN' THEN '情感' ELSE 'Romantic' END
         ELSE CASE v.locale WHEN 'zh-CN' THEN '相关' ELSE 'Related' END
       END,
       '', 'published'
FROM character_relations r
CROSS JOIN (VALUES ('zh-CN'), ('en')) AS v(locale)
WHERE r.work_id = '10000000-0000-4000-8000-000000000005'
  AND NOT EXISTS (
    SELECT 1 FROM relation_translations t
    WHERE t.relation_id = r.id AND t.locale = v.locale::locale_code
  );

COMMIT;
