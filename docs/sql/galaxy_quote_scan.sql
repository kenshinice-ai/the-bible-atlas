-- Galaxy atlas: quotation scan (docs/IP_AUDIT.md §3).
--
-- Entry text must contain no quotation marks of any kind. The rule this
-- enforces is "no film dialogue presented as a quotation in entry text", but
-- it is written as the broader "no quote marks at all" because that is a
-- condition a machine can keep returning zero on, where the narrower rule
-- needs a person to re-judge every instance.
--
-- Quoted material belongs in exactly one place: the epigraph slots in
-- apps/web/src/epigraphs.ts, which carry their own quota (<=3 quotations,
-- <=15 words each, attributed, registered in that file's header comment).
--
-- Must return zero rows. Run after any seed that touches galaxy text.

\set W '10000000-0000-4000-8000-000000000008'

SELECT 'event' AS kind, e.slug, t.locale
FROM events e JOIN event_translations t ON t.event_id = e.id
WHERE e.work_id = :'W'
  AND (t.title || t.summary || t.detail || t.significance) ~ '["“”「」『』]'
UNION ALL
SELECT 'character', c.slug, t.locale
FROM characters c JOIN character_translations t ON t.character_id = c.id
WHERE c.work_id = :'W'
  AND (t.name || t.summary || t.detail || t.motivation) ~ '["“”「」『』]'
UNION ALL
SELECT 'location', l.slug, t.locale
FROM locations l JOIN location_translations t ON t.location_id = l.id
WHERE l.work_id = :'W'
  AND (t.name || t.summary) ~ '["“”「」『』]'
UNION ALL
SELECT 'relation', r.id::text, t.locale
FROM character_relations r JOIN relation_translations t ON t.relation_id = r.id
WHERE r.work_id = :'W'
  AND (t.label || t.summary) ~ '["“”「」『』]'
ORDER BY 1, 2;
