BEGIN;

CREATE TYPE artwork_status AS ENUM ('confirmed', 'attributed', 'workshop', 'lost', 'destroyed', 'unknown');

CREATE TABLE artists (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL,
  birth_year integer,
  death_year integer,
  birth_location_id uuid REFERENCES locations(id) ON DELETE SET NULL,
  death_location_id uuid REFERENCES locations(id) ON DELETE SET NULL,
  chapter_id uuid REFERENCES chapters(id) ON DELETE SET NULL,
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE(work_id, slug)
);
CREATE TABLE artist_translations (
  artist_id uuid NOT NULL REFERENCES artists(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  name text NOT NULL,
  summary text NOT NULL,
  modern_status text NOT NULL DEFAULT '',
  period_titles text[] NOT NULL DEFAULT '{}',
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (artist_id, locale)
);

CREATE TABLE movements (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL,
  chapter_id uuid REFERENCES chapters(id) ON DELETE SET NULL,
  start_year integer,
  end_year integer,
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE(work_id, slug)
);
CREATE TABLE movement_translations (
  movement_id uuid NOT NULL REFERENCES movements(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  name text NOT NULL,
  summary text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (movement_id, locale)
);

CREATE TABLE artworks (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL,
  primary_artist_id uuid REFERENCES artists(id) ON DELETE SET NULL,
  chapter_id uuid REFERENCES chapters(id) ON DELETE SET NULL,
  creation_start_year integer,
  creation_end_year integer,
  medium text NOT NULL DEFAULT '',
  status artwork_status NOT NULL DEFAULT 'confirmed',
  creation_location_id uuid REFERENCES locations(id) ON DELETE SET NULL,
  current_location_id uuid REFERENCES locations(id) ON DELETE SET NULL,
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE(work_id, slug),
  CHECK (creation_end_year IS NULL OR creation_start_year IS NULL OR creation_end_year >= creation_start_year)
);
CREATE TABLE artwork_translations (
  artwork_id uuid NOT NULL REFERENCES artworks(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  title text NOT NULL,
  summary text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (artwork_id, locale)
);

CREATE TABLE artist_artworks (
  artist_id uuid NOT NULL REFERENCES artists(id) ON DELETE CASCADE,
  artwork_id uuid NOT NULL REFERENCES artworks(id) ON DELETE CASCADE,
  role text NOT NULL DEFAULT 'creator',
  PRIMARY KEY (artist_id, artwork_id)
);
CREATE TABLE artist_movements (
  artist_id uuid NOT NULL REFERENCES artists(id) ON DELETE CASCADE,
  movement_id uuid NOT NULL REFERENCES movements(id) ON DELETE CASCADE,
  PRIMARY KEY (artist_id, movement_id)
);
CREATE TABLE artwork_movements (
  artwork_id uuid NOT NULL REFERENCES artworks(id) ON DELETE CASCADE,
  movement_id uuid NOT NULL REFERENCES movements(id) ON DELETE CASCADE,
  PRIMARY KEY (artwork_id, movement_id)
);
CREATE TABLE artist_locations (
  artist_id uuid NOT NULL REFERENCES artists(id) ON DELETE CASCADE,
  location_id uuid NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
  role text NOT NULL,
  PRIMARY KEY (artist_id, location_id, role)
);
CREATE TABLE art_institutions (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL,
  location_id uuid NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
  institution_type text NOT NULL,
  founded_year integer,
  closed_year integer,
  UNIQUE(work_id, slug)
);
CREATE TABLE art_institution_translations (
  institution_id uuid NOT NULL REFERENCES art_institutions(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  name text NOT NULL,
  summary text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (institution_id, locale)
);
CREATE TABLE artist_institutions (
  artist_id uuid NOT NULL REFERENCES artists(id) ON DELETE CASCADE,
  institution_id uuid NOT NULL REFERENCES art_institutions(id) ON DELETE CASCADE,
  role text NOT NULL,
  PRIMARY KEY (artist_id, institution_id, role)
);

CREATE INDEX artist_translation_search_idx ON artist_translations USING gin ((name || ' ' || summary || ' ' || modern_status) gin_trgm_ops);
CREATE INDEX artwork_translation_search_idx ON artwork_translations USING gin ((title || ' ' || summary) gin_trgm_ops);
CREATE INDEX movement_translation_search_idx ON movement_translations USING gin ((name || ' ' || summary) gin_trgm_ops);

INSERT INTO schema_migrations(version) VALUES ('005_european_art');
COMMIT;
