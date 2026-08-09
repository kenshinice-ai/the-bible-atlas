BEGIN;

ALTER TYPE work_category ADD VALUE IF NOT EXISTS 'music_history';

ALTER TYPE literary_event_type ADD VALUE IF NOT EXISTS 'composition';
ALTER TYPE literary_event_type ADD VALUE IF NOT EXISTS 'commission';
ALTER TYPE literary_event_type ADD VALUE IF NOT EXISTS 'premiere';
ALTER TYPE literary_event_type ADD VALUE IF NOT EXISTS 'performance';
ALTER TYPE literary_event_type ADD VALUE IF NOT EXISTS 'publication';
ALTER TYPE literary_event_type ADD VALUE IF NOT EXISTS 'revision';
ALTER TYPE literary_event_type ADD VALUE IF NOT EXISTS 'appointment';
ALTER TYPE literary_event_type ADD VALUE IF NOT EXISTS 'institution_founding';
ALTER TYPE literary_event_type ADD VALUE IF NOT EXISTS 'instrument_innovation';
ALTER TYPE literary_event_type ADD VALUE IF NOT EXISTS 'musical_debate';
ALTER TYPE literary_event_type ADD VALUE IF NOT EXISTS 'festival';
ALTER TYPE literary_event_type ADD VALUE IF NOT EXISTS 'recording';
ALTER TYPE literary_event_type ADD VALUE IF NOT EXISTS 'revival';

ALTER TYPE character_group_type ADD VALUE IF NOT EXISTS 'school';
ALTER TYPE character_group_type ADD VALUE IF NOT EXISTS 'court';
ALTER TYPE character_group_type ADD VALUE IF NOT EXISTS 'conservatory';
ALTER TYPE character_group_type ADD VALUE IF NOT EXISTS 'ensemble';
ALTER TYPE character_group_type ADD VALUE IF NOT EXISTS 'national_tradition';
ALTER TYPE character_group_type ADD VALUE IF NOT EXISTS 'city_network';

ALTER TYPE source_type ADD VALUE IF NOT EXISTS 'score';
ALTER TYPE source_type ADD VALUE IF NOT EXISTS 'instrument_catalog';

ALTER TYPE linked_entity_kind ADD VALUE IF NOT EXISTS 'composition';
ALTER TYPE linked_entity_kind ADD VALUE IF NOT EXISTS 'music_style';
ALTER TYPE linked_entity_kind ADD VALUE IF NOT EXISTS 'instrument';
ALTER TYPE linked_entity_kind ADD VALUE IF NOT EXISTS 'music_institution';
ALTER TYPE linked_entity_kind ADD VALUE IF NOT EXISTS 'score_fragment';

ALTER TABLE characters
  ADD CONSTRAINT characters_id_work_unique UNIQUE (id, work_id);
ALTER TABLE chapters
  ADD CONSTRAINT chapters_id_work_unique UNIQUE (id, work_id);
ALTER TABLE locations
  ADD CONSTRAINT locations_id_work_unique UNIQUE (id, work_id);
ALTER TABLE sources
  ADD CONSTRAINT sources_id_work_unique UNIQUE (id, work_id);
ALTER TABLE character_relations
  ADD CONSTRAINT character_relations_id_work_unique UNIQUE (id, work_id);

CREATE TABLE music_person_profiles (
  character_id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  primary_role text NOT NULL CHECK (primary_role IN (
    'composer','performer','conductor','theorist','librettist',
    'patron','publisher','instrument_maker','educator','critic'
  )),
  chapter_id uuid,
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE (character_id, work_id),
  FOREIGN KEY (character_id, work_id) REFERENCES characters(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (chapter_id, work_id) REFERENCES chapters(id, work_id) ON DELETE SET NULL
);

CREATE TABLE music_person_roles (
  character_id uuid NOT NULL,
  work_id uuid NOT NULL,
  role text NOT NULL CHECK (role IN (
    'composer','performer','conductor','theorist','librettist',
    'patron','publisher','instrument_maker','educator','critic'
  )),
  PRIMARY KEY (character_id, role),
  FOREIGN KEY (character_id, work_id) REFERENCES music_person_profiles(character_id, work_id) ON DELETE CASCADE
);

CREATE TABLE compositions (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL CHECK (slug ~ '^[a-z0-9-]+$'),
  primary_composer_character_id uuid,
  chapter_id uuid,
  composition_start_year integer,
  composition_end_year integer,
  composition_time_type event_time_type NOT NULL DEFAULT 'unknown',
  confidence confidence_level NOT NULL DEFAULT 'medium',
  catalogue_number text NOT NULL DEFAULT '',
  genre text NOT NULL DEFAULT '',
  form text NOT NULL DEFAULT '',
  key_signature text NOT NULL DEFAULT '',
  approx_duration_seconds integer,
  text_language text NOT NULL DEFAULT '',
  work_status text NOT NULL DEFAULT 'confirmed' CHECK (work_status IN (
    'confirmed','sketch','fragment','lost','arrangement','contested','unknown'
  )),
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE (work_id, slug),
  UNIQUE (id, work_id),
  CHECK (composition_start_year IS NULL OR composition_start_year <> 0),
  CHECK (composition_end_year IS NULL OR composition_end_year <> 0),
  CHECK (composition_end_year IS NULL OR composition_start_year IS NULL OR composition_end_year >= composition_start_year),
  CHECK (approx_duration_seconds IS NULL OR approx_duration_seconds > 0),
  FOREIGN KEY (primary_composer_character_id, work_id) REFERENCES music_person_profiles(character_id, work_id) ON DELETE SET NULL,
  FOREIGN KEY (chapter_id, work_id) REFERENCES chapters(id, work_id) ON DELETE SET NULL
);

CREATE TABLE composition_translations (
  composition_id uuid NOT NULL REFERENCES compositions(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  title text NOT NULL,
  alternate_titles text[] NOT NULL DEFAULT '{}',
  summary text NOT NULL,
  description text NOT NULL DEFAULT '',
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (composition_id, locale)
);

CREATE TABLE composition_contributors (
  composition_id uuid NOT NULL,
  character_id uuid NOT NULL,
  work_id uuid NOT NULL,
  role text NOT NULL CHECK (role IN (
    'composer','co_composer','librettist','arranger','orchestrator',
    'editor','translator','dedicatee','premiere_performer','premiere_conductor'
  )),
  sort_order integer NOT NULL DEFAULT 0,
  PRIMARY KEY (composition_id, character_id, role),
  FOREIGN KEY (composition_id, work_id) REFERENCES compositions(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (character_id, work_id) REFERENCES characters(id, work_id) ON DELETE CASCADE
);

CREATE TABLE composition_sources (
  composition_id uuid NOT NULL REFERENCES compositions(id) ON DELETE CASCADE,
  source_id uuid NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  PRIMARY KEY (composition_id, source_id)
);

CREATE TABLE composition_event_links (
  composition_id uuid NOT NULL,
  event_id uuid NOT NULL,
  work_id uuid NOT NULL,
  role text NOT NULL CHECK (role IN (
    'commissioned','sketched','composed','completed','premiered','published',
    'revised','arranged','performed','revived','recorded'
  )),
  PRIMARY KEY (composition_id, event_id, role),
  FOREIGN KEY (composition_id, work_id) REFERENCES compositions(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (event_id, work_id) REFERENCES events(id, work_id) ON DELETE CASCADE
);

CREATE TABLE music_person_event_links (
  character_id uuid NOT NULL,
  event_id uuid NOT NULL,
  work_id uuid NOT NULL,
  role text NOT NULL,
  PRIMARY KEY (character_id, event_id, role),
  FOREIGN KEY (character_id, work_id) REFERENCES music_person_profiles(character_id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (event_id, work_id) REFERENCES events(id, work_id) ON DELETE CASCADE
);

CREATE TABLE music_styles (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL CHECK (slug ~ '^[a-z0-9-]+$'),
  style_kind text NOT NULL CHECK (style_kind IN (
    'historical_style','school','national_tradition','genre','form','technique'
  )),
  chapter_id uuid,
  start_year integer,
  end_year integer,
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE (work_id, slug),
  UNIQUE (id, work_id),
  CHECK (start_year IS NULL OR start_year <> 0),
  CHECK (end_year IS NULL OR end_year <> 0),
  CHECK (end_year IS NULL OR start_year IS NULL OR end_year >= start_year),
  FOREIGN KEY (chapter_id, work_id) REFERENCES chapters(id, work_id) ON DELETE SET NULL
);

CREATE TABLE music_style_translations (
  style_id uuid NOT NULL REFERENCES music_styles(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  name text NOT NULL,
  summary text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (style_id, locale)
);

CREATE TABLE music_person_styles (
  character_id uuid NOT NULL,
  style_id uuid NOT NULL,
  work_id uuid NOT NULL,
  PRIMARY KEY (character_id, style_id),
  FOREIGN KEY (character_id, work_id) REFERENCES music_person_profiles(character_id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (style_id, work_id) REFERENCES music_styles(id, work_id) ON DELETE CASCADE
);

CREATE TABLE composition_styles (
  composition_id uuid NOT NULL,
  style_id uuid NOT NULL,
  work_id uuid NOT NULL,
  PRIMARY KEY (composition_id, style_id),
  FOREIGN KEY (composition_id, work_id) REFERENCES compositions(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (style_id, work_id) REFERENCES music_styles(id, work_id) ON DELETE CASCADE
);

CREATE TABLE music_style_sources (
  style_id uuid NOT NULL REFERENCES music_styles(id) ON DELETE CASCADE,
  source_id uuid NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  PRIMARY KEY (style_id, source_id)
);

CREATE TABLE instruments (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL CHECK (slug ~ '^[a-z0-9-]+$'),
  family text NOT NULL CHECK (family IN (
    'strings','woodwinds','brass','percussion','keyboards',
    'plucked_and_early','voice','mechanical_and_electronic'
  )),
  hornbostel_sachs_code text NOT NULL DEFAULT '',
  mimo_term text NOT NULL DEFAULT '',
  parent_instrument_id uuid,
  start_year integer,
  end_year integer,
  transposition text NOT NULL DEFAULT '',
  range_low text NOT NULL DEFAULT '',
  range_high text NOT NULL DEFAULT '',
  construction_summary text NOT NULL DEFAULT '',
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE (work_id, slug),
  UNIQUE (id, work_id),
  CHECK (start_year IS NULL OR start_year <> 0),
  CHECK (end_year IS NULL OR end_year <> 0),
  CHECK (end_year IS NULL OR start_year IS NULL OR end_year >= start_year),
  FOREIGN KEY (parent_instrument_id, work_id) REFERENCES instruments(id, work_id) ON DELETE SET NULL
);

CREATE TABLE instrument_translations (
  instrument_id uuid NOT NULL REFERENCES instruments(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  name text NOT NULL,
  aliases text[] NOT NULL DEFAULT '{}',
  summary text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (instrument_id, locale)
);

CREATE TABLE instrument_variant_relations (
  from_instrument_id uuid NOT NULL,
  to_instrument_id uuid NOT NULL,
  work_id uuid NOT NULL,
  relation_type text NOT NULL CHECK (relation_type IN (
    'developed_from','regional_variant_of','coexisted_with','revived_as','construction_influence'
  )),
  PRIMARY KEY (from_instrument_id, to_instrument_id, relation_type),
  FOREIGN KEY (from_instrument_id, work_id) REFERENCES instruments(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (to_instrument_id, work_id) REFERENCES instruments(id, work_id) ON DELETE CASCADE,
  CHECK (from_instrument_id <> to_instrument_id)
);

CREATE TABLE music_person_instruments (
  character_id uuid NOT NULL,
  instrument_id uuid NOT NULL,
  work_id uuid NOT NULL,
  role text NOT NULL DEFAULT 'associated',
  PRIMARY KEY (character_id, instrument_id, role),
  FOREIGN KEY (character_id, work_id) REFERENCES music_person_profiles(character_id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (instrument_id, work_id) REFERENCES instruments(id, work_id) ON DELETE CASCADE
);

CREATE TABLE composition_instruments (
  composition_id uuid NOT NULL,
  instrument_id uuid NOT NULL,
  work_id uuid NOT NULL,
  role text NOT NULL DEFAULT 'ensemble',
  PRIMARY KEY (composition_id, instrument_id, role),
  FOREIGN KEY (composition_id, work_id) REFERENCES compositions(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (instrument_id, work_id) REFERENCES instruments(id, work_id) ON DELETE CASCADE
);

CREATE TABLE instrument_sources (
  instrument_id uuid NOT NULL REFERENCES instruments(id) ON DELETE CASCADE,
  source_id uuid NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  PRIMARY KEY (instrument_id, source_id)
);

CREATE TABLE music_institutions (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL CHECK (slug ~ '^[a-z0-9-]+$'),
  location_id uuid NOT NULL,
  institution_type text NOT NULL CHECK (institution_type IN (
    'court','church','opera_house','concert_hall','conservatory',
    'ensemble','publisher','workshop','festival','archive','institution'
  )),
  founded_year integer,
  closed_year integer,
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE (work_id, slug),
  UNIQUE (id, work_id),
  CHECK (founded_year IS NULL OR founded_year <> 0),
  CHECK (closed_year IS NULL OR closed_year <> 0),
  CHECK (closed_year IS NULL OR founded_year IS NULL OR closed_year >= founded_year),
  FOREIGN KEY (location_id, work_id) REFERENCES locations(id, work_id) ON DELETE CASCADE
);

CREATE TABLE music_institution_translations (
  institution_id uuid NOT NULL REFERENCES music_institutions(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  name text NOT NULL,
  summary text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (institution_id, locale)
);

CREATE TABLE music_person_institutions (
  character_id uuid NOT NULL,
  institution_id uuid NOT NULL,
  work_id uuid NOT NULL,
  role text NOT NULL,
  PRIMARY KEY (character_id, institution_id, role),
  FOREIGN KEY (character_id, work_id) REFERENCES music_person_profiles(character_id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (institution_id, work_id) REFERENCES music_institutions(id, work_id) ON DELETE CASCADE
);

CREATE TABLE composition_institutions (
  composition_id uuid NOT NULL,
  institution_id uuid NOT NULL,
  work_id uuid NOT NULL,
  role text NOT NULL,
  PRIMARY KEY (composition_id, institution_id, role),
  FOREIGN KEY (composition_id, work_id) REFERENCES compositions(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (institution_id, work_id) REFERENCES music_institutions(id, work_id) ON DELETE CASCADE
);

CREATE TABLE music_institution_sources (
  institution_id uuid NOT NULL REFERENCES music_institutions(id) ON DELETE CASCADE,
  source_id uuid NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  PRIMARY KEY (institution_id, source_id)
);

CREATE TABLE relation_contexts (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  relation_id uuid NOT NULL,
  composition_id uuid,
  event_id uuid,
  institution_id uuid,
  context_role text NOT NULL,
  source_id uuid NOT NULL,
  FOREIGN KEY (relation_id, work_id) REFERENCES character_relations(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (composition_id, work_id) REFERENCES compositions(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (event_id, work_id) REFERENCES events(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (institution_id, work_id) REFERENCES music_institutions(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (source_id, work_id) REFERENCES sources(id, work_id) ON DELETE CASCADE,
  CHECK (num_nonnulls(composition_id, event_id, institution_id) >= 1)
);

CREATE INDEX music_person_profiles_work_idx ON music_person_profiles(work_id, primary_role, sort_order);
CREATE INDEX compositions_work_chapter_idx ON compositions(work_id, chapter_id, sort_order);
CREATE INDEX composition_translation_search_idx ON composition_translations USING gin ((title || ' ' || summary || ' ' || description) gin_trgm_ops);
CREATE INDEX music_style_translation_search_idx ON music_style_translations USING gin ((name || ' ' || summary) gin_trgm_ops);
CREATE INDEX instrument_translation_search_idx ON instrument_translations USING gin ((name || ' ' || summary) gin_trgm_ops);
CREATE INDEX music_institution_translation_search_idx ON music_institution_translations USING gin ((name || ' ' || summary) gin_trgm_ops);
CREATE INDEX composition_event_links_event_idx ON composition_event_links(event_id);
CREATE INDEX relation_contexts_relation_idx ON relation_contexts(relation_id);

INSERT INTO schema_migrations(version) VALUES ('013_european_classical_music');
COMMIT;
