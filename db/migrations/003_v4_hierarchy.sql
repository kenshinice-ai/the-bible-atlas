BEGIN;

-- v4 introduces the hierarchy that lets zoom replace hard entity caps:
--   work -> chapter (era) -> character group -> individual
-- Chapters already exist as a structural grouping for events but carried no
-- bilingual name and no era bounds, so they could not be rendered. Character
-- groups are new and give the relationship graph a middle tier to collapse to.

CREATE TYPE character_group_type AS ENUM ('family', 'dynasty', 'circle', 'tribe', 'institution', 'other');

ALTER TABLE chapters
  ADD COLUMN era_start_year integer,
  ADD COLUMN era_end_year integer,
  ADD COLUMN accent_color text NOT NULL DEFAULT '#8b72cf',
  ADD CONSTRAINT chapters_era_start_nonzero CHECK (era_start_year IS NULL OR era_start_year <> 0),
  ADD CONSTRAINT chapters_era_end_nonzero CHECK (era_end_year IS NULL OR era_end_year <> 0),
  ADD CONSTRAINT chapters_era_order CHECK (era_start_year IS NULL OR era_end_year IS NULL OR era_end_year >= era_start_year),
  ADD CONSTRAINT chapters_accent_format CHECK (accent_color ~ '^#[0-9A-Fa-f]{6}$');

CREATE TABLE chapter_translations (
  chapter_id uuid NOT NULL REFERENCES chapters(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  title text NOT NULL,
  summary text NOT NULL DEFAULT '',
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (chapter_id, locale)
);

-- Existing chapters predate bilingual titles. Backfill from the reference label
-- so no previously visible structure disappears after this migration.
INSERT INTO chapter_translations(chapter_id, locale, title, summary, status)
SELECT c.id, l.locale, c.reference_label, '', 'published'
FROM chapters c CROSS JOIN (VALUES ('zh-CN'::locale_code), ('en'::locale_code)) AS l(locale)
ON CONFLICT DO NOTHING;

-- Derive era bounds from the events each chapter already owns; explicit values
-- in later seeds override these.
UPDATE chapters c SET
  era_start_year = sub.start_year,
  era_end_year = sub.end_year
FROM (
  SELECT e.chapter_id,
    min(e.historical_start_year) AS start_year,
    max(COALESCE(e.historical_end_year, e.historical_start_year)) AS end_year
  FROM events e WHERE e.chapter_id IS NOT NULL GROUP BY e.chapter_id
) sub
WHERE sub.chapter_id = c.id AND sub.start_year IS NOT NULL AND sub.start_year <> 0 AND sub.end_year <> 0;

CREATE TABLE character_groups (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL CHECK (slug ~ '^[a-z0-9-]+$'),
  group_type character_group_type NOT NULL DEFAULT 'other',
  sort_order integer NOT NULL DEFAULT 0,
  anchor_character_id uuid REFERENCES characters(id) ON DELETE SET NULL,
  accent_color text NOT NULL DEFAULT '#8b72cf' CHECK (accent_color ~ '^#[0-9A-Fa-f]{6}$'),
  UNIQUE (work_id, slug)
);

CREATE TABLE character_group_translations (
  group_id uuid NOT NULL REFERENCES character_groups(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  name text NOT NULL,
  summary text NOT NULL DEFAULT '',
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (group_id, locale)
);

CREATE TABLE character_group_members (
  group_id uuid NOT NULL REFERENCES character_groups(id) ON DELETE CASCADE,
  character_id uuid NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  membership_role text NOT NULL DEFAULT '',
  PRIMARY KEY (group_id, character_id)
);

-- Source titles were the last visible strings with no translation table, so a
-- zh-CN reader saw English book names in the citation list.
CREATE TABLE source_translations (
  source_id uuid NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  title text NOT NULL,
  citation text NOT NULL DEFAULT '',
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (source_id, locale)
);

INSERT INTO source_translations(source_id, locale, title, citation, status)
SELECT s.id, l.locale, s.title, s.citation, 'published'
FROM sources s CROSS JOIN (VALUES ('zh-CN'::locale_code), ('en'::locale_code)) AS l(locale)
ON CONFLICT DO NOTHING;

CREATE INDEX events_chapter_idx ON events(chapter_id, sequence);
CREATE INDEX chapters_work_sequence_idx ON chapters(work_id, sequence);
CREATE INDEX character_group_members_character_idx ON character_group_members(character_id);

INSERT INTO schema_migrations(version) VALUES ('003_v4_hierarchy');
COMMIT;
