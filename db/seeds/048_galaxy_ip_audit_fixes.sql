BEGIN;

-- IP audit corrections (docs/IP_AUDIT.md, 2026-07-27).
--
-- The audit's quotation scan found nine Chinese fields using 「」. Six were
-- ordinary emphasis around a concept; three wrapped a character's words:
--
--   obi-wan-tells-luke-of-his-father   「被维达害死了」
--   mace-windu-confronts-palpatine     「我可以教你」
--   relation Mundi → Anakin            「心中有恐惧」
--
-- Those three read as quoted dialogue, which this project's own rule forbids
-- in entry text (db/seeds/galaxy-seed-spec.md §7). They are rewritten here as
-- reported speech.
--
-- The other six are removed as well, not because they were wrong but because
-- "no 「」 anywhere in entry text" is a check a machine can keep returning
-- zero on, where "only the non-dialogue ones" needs a human to re-judge every
-- instance forever. The cheap invariant is worth more than the six brackets.

UPDATE event_translations t SET
  detail = replace(t.detail, '影片让欧比旺说父亲「被维达害死了」', '影片让欧比旺说父亲死于维达之手')
FROM events e WHERE e.id=t.event_id AND e.slug='obi-wan-tells-luke-of-his-father' AND t.locale='zh-CN';

UPDATE event_translations t SET
  significance = replace(t.significance, '而是那句「我可以教你」', '而是那个愿意教他的承诺')
FROM events e WHERE e.id=t.event_id AND e.slug='mace-windu-confronts-palpatine' AND t.locale='zh-CN';

UPDATE relation_translations t SET
  summary = replace(t.summary, '委员会以「心中有恐惧」为由拒绝收训。', '委员会认定他心中有恐惧,以此为由拒绝收训。')
WHERE t.relation_id='78000000-0000-4000-8001-000000000016' AND t.locale='zh-CN';

-- Concept emphasis: drop the brackets, keep the words.
UPDATE event_translations t SET
  significance = replace(t.significance, '对「传承」给出的定义', '对传承给出的定义')
FROM events e WHERE e.id=t.event_id AND e.slug='yoda-returns-to-luke' AND t.locale='zh-CN';

UPDATE event_translations t SET
  detail = replace(t.detail, '卢克的第一次「相信」', '卢克的第一次相信')
FROM events e WHERE e.id=t.event_id AND e.slug='the-trench-run' AND t.locale='zh-CN';

UPDATE event_translations t SET
  significance = replace(t.significance, '第一次「来不及」', '第一次来不及')
FROM events e WHERE e.id=t.event_id AND e.slug='duel-of-the-generators' AND t.locale='zh-CN';

UPDATE event_translations t SET
  significance = replace(t.significance, '即将「获得」一支', '即将得到一支')
FROM events e WHERE e.id=t.event_id AND e.slug='the-clone-army-discovered' AND t.locale='zh-CN';

UPDATE event_translations t SET
  detail = replace(t.detail, '第一次「预见到却救不了」', '第一次预见到却救不了')
FROM events e WHERE e.id=t.event_id AND e.slug='shmi-skywalker-dies' AND t.locale='zh-CN';

UPDATE relation_translations t SET
  summary = replace(t.summary, '拒绝了「像父亲那样」这条路', '拒绝了走上父亲那条路')
WHERE t.relation_id='78000000-0000-4000-8003-000000000003' AND t.locale='zh-CN';

COMMIT;
