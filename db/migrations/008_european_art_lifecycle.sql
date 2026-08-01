BEGIN;

ALTER TYPE work_category ADD VALUE IF NOT EXISTS 'art_history';
ALTER TYPE linked_entity_kind ADD VALUE IF NOT EXISTS 'artist';
ALTER TYPE linked_entity_kind ADD VALUE IF NOT EXISTS 'artwork';
ALTER TYPE linked_entity_kind ADD VALUE IF NOT EXISTS 'movement';
ALTER TYPE linked_entity_kind ADD VALUE IF NOT EXISTS 'institution';

ALTER TABLE artists
  ADD COLUMN artist_kind text NOT NULL DEFAULT 'person',
  ADD COLUMN importance smallint NOT NULL DEFAULT 3,
  ADD CONSTRAINT artists_kind_check CHECK (artist_kind IN ('person','workshop','collective','anonymous_master','school')),
  ADD CONSTRAINT artists_importance_check CHECK (importance BETWEEN 1 AND 5),
  ADD CONSTRAINT artists_birth_year_nonzero CHECK (birth_year IS NULL OR birth_year <> 0),
  ADD CONSTRAINT artists_death_year_nonzero CHECK (death_year IS NULL OR death_year <> 0),
  ADD CONSTRAINT artists_life_order CHECK (birth_year IS NULL OR death_year IS NULL OR death_year >= birth_year),
  ADD CONSTRAINT artists_id_work_unique UNIQUE (id, work_id);

ALTER TABLE movements
  ADD CONSTRAINT movements_year_order CHECK (start_year IS NULL OR end_year IS NULL OR end_year >= start_year),
  ADD CONSTRAINT movements_id_work_unique UNIQUE (id, work_id);

ALTER TABLE events
  ADD CONSTRAINT events_id_work_unique UNIQUE (id, work_id);

ALTER TABLE artworks
  ADD COLUMN creation_time_type event_time_type NOT NULL DEFAULT 'unknown',
  ADD COLUMN attribution_confidence text NOT NULL DEFAULT 'high',
  ADD COLUMN dimensions text NOT NULL DEFAULT '',
  ADD COLUMN copyright_status text NOT NULL DEFAULT 'metadata_only',
  ADD CONSTRAINT artworks_attribution_confidence_check CHECK (attribution_confidence IN ('high','medium','low','unknown')),
  ADD CONSTRAINT artworks_id_work_unique UNIQUE (id, work_id);

CREATE TABLE historical_place_names (
  location_id uuid NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
  language_code text NOT NULL,
  script_code text NOT NULL DEFAULT '',
  name text NOT NULL,
  start_year integer,
  end_year integer,
  source_id uuid REFERENCES sources(id) ON DELETE SET NULL,
  confidence text NOT NULL DEFAULT 'medium' CHECK (confidence IN ('high','medium','low')),
  PRIMARY KEY (location_id, language_code, name),
  CHECK (end_year IS NULL OR start_year IS NULL OR end_year >= start_year)
);

CREATE TABLE artwork_event_links (
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  artwork_id uuid NOT NULL,
  event_id uuid NOT NULL,
  role text NOT NULL CHECK (role IN ('commissioned','produced','completed','exhibited','acquired','relocated','restored','stolen','recovered','destroyed','restituted')),
  PRIMARY KEY (artwork_id, event_id, role),
  FOREIGN KEY (artwork_id, work_id) REFERENCES artworks(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (event_id, work_id) REFERENCES events(id, work_id) ON DELETE CASCADE
);

CREATE TABLE artist_event_links (
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  artist_id uuid NOT NULL,
  event_id uuid NOT NULL,
  role text NOT NULL,
  PRIMARY KEY (artist_id, event_id, role),
  FOREIGN KEY (artist_id, work_id) REFERENCES artists(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (event_id, work_id) REFERENCES events(id, work_id) ON DELETE CASCADE
);

CREATE TABLE artist_relations (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  from_artist_id uuid NOT NULL,
  to_artist_id uuid NOT NULL,
  relation_type text NOT NULL,
  strength smallint NOT NULL DEFAULT 3 CHECK (strength BETWEEN 1 AND 5),
  UNIQUE (work_id, from_artist_id, to_artist_id, relation_type),
  FOREIGN KEY (from_artist_id, work_id) REFERENCES artists(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (to_artist_id, work_id) REFERENCES artists(id, work_id) ON DELETE CASCADE,
  CHECK (from_artist_id <> to_artist_id)
);
CREATE TABLE artist_relation_translations (
  relation_id uuid NOT NULL REFERENCES artist_relations(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  label text NOT NULL,
  summary text NOT NULL DEFAULT '',
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (relation_id, locale)
);

CREATE INDEX artwork_event_links_event_idx ON artwork_event_links(event_id);
CREATE INDEX artist_event_links_event_idx ON artist_event_links(event_id);
CREATE INDEX historical_place_names_period_idx ON historical_place_names(location_id, start_year, end_year);

INSERT INTO schema_migrations(version) VALUES ('008_european_art_lifecycle');
COMMIT;
