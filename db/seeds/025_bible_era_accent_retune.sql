BEGIN;

-- P1: era accent colours retuned for contrast (sacred-rebrand-plan §4.3).
-- The hue arc is kept deliberately — dust → gold-ochre → crimson → purple →
-- sky-blue → olive reads Genesis-to-Acts — but lightness rises so every colour
-- measures ≥4.75:1 against the #1C1917 era-band label ink and ≥4.5:1 against
-- the #0F172A panel. Idempotent: plain slug-keyed UPDATEs.

UPDATE chapters SET accent_color = v.color
FROM (VALUES
  ('primeval','#B5A588'),('patriarchs','#D9A441'),('exodus-and-sinai','#D18E3F'),
  ('wilderness-and-conquest','#C67F45'),('judges','#BE7350'),('united-monarchy','#CF6B67'),
  ('divided-kingdoms','#CE7080'),('prophetic-narrative','#BC7492'),('judah-and-exile','#A277AC'),
  ('return-and-restoration','#8B7EC0'),('gospels','#7189CC'),('acts','#5E9CC0'),
  ('pauline-mission','#57AB9C')
) AS v(slug, color)
WHERE chapters.slug = v.slug
  AND chapters.work_id = '10000000-0000-4000-8000-000000000005';

COMMIT;
