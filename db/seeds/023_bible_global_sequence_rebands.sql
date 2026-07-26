BEGIN;

-- =========================================================================
-- 023_bible_global_sequence_rebands.sql
-- Global narrative ordering for the Bible after the full-expansion seeds.
--
-- Era seed files (010, 013, 017, 021, …) band their own era's events into
-- K*1000+1 … K*1000+999, but eras that have not been expanded yet still sit
-- at their original 1–136 sequences, which would sort them *before* every
-- banded era. This pass rebands every Bible event by (era sequence, current
-- in-era order), so the whole work reads in canonical order regardless of
-- how many eras have been expanded. Relative order within an era is
-- preserved, so re-running after future expansions stays safe.
-- =========================================================================

WITH ordered AS (
  SELECT e.id, ch.sequence AS era, ROW_NUMBER() OVER (PARTITION BY e.chapter_id ORDER BY e.sequence, e.slug) AS rn
  FROM events e
  JOIN chapters ch ON ch.id = e.chapter_id
  WHERE e.work_id = '10000000-0000-4000-8000-000000000005'
)
UPDATE events e
SET sequence = o.era * 1000 + o.rn * 2 - 1
FROM ordered o
WHERE o.id = e.id;

COMMIT;
