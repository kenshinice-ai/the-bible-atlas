BEGIN;
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TYPE locale_code AS ENUM ('zh-CN', 'en');
CREATE TYPE translation_status AS ENUM ('draft', 'reviewed', 'published');
CREATE TYPE content_mode AS ENUM ('documented_record', 'literary_narrative');
CREATE TYPE world_layer AS ENUM ('real', 'fictional');
CREATE TYPE event_reality AS ENUM ('verified_historical', 'reported_historical', 'fictional_narrative', 'fictional_with_historical_context', 'legendary_or_mythic', 'symbolic_or_dream', 'contested');
CREATE TYPE route_certainty AS ENUM ('documented', 'text_explicit', 'inferred');

CREATE TABLE schema_migrations(version text PRIMARY KEY, applied_at timestamptz NOT NULL DEFAULT now());
INSERT INTO schema_migrations(version) VALUES ('001_initial');

CREATE TABLE works (
  id uuid PRIMARY KEY,
  slug text NOT NULL UNIQUE CHECK (slug ~ '^[a-z0-9-]+$'),
  author_name text NOT NULL,
  publication_year integer,
  content_mode content_mode NOT NULL,
  map_layer world_layer NOT NULL,
  default_locale locale_code NOT NULL DEFAULT 'en',
  launch_rank integer NOT NULL UNIQUE,
  mode_reason text NOT NULL,
  CHECK (map_layer = 'real' OR slug = 'the-hobbit')
);
CREATE TABLE work_translations (
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  title text NOT NULL,
  summary text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (work_id, locale)
);

CREATE TABLE characters (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE(work_id, slug)
);
CREATE TABLE character_translations (
  character_id uuid NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  name text NOT NULL,
  summary text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY(character_id, locale)
);

CREATE TABLE locations (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL,
  layer world_layer NOT NULL,
  geom geography(Point, 4326),
  canvas_x numeric(6,3),
  canvas_y numeric(6,3),
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE(work_id, slug),
  CHECK ((layer='real' AND geom IS NOT NULL AND canvas_x IS NULL AND canvas_y IS NULL) OR (layer='fictional' AND geom IS NULL AND canvas_x BETWEEN 0 AND 100 AND canvas_y BETWEEN 0 AND 100))
);
CREATE TABLE location_translations (
  location_id uuid NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  name text NOT NULL,
  summary text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY(location_id, locale)
);

CREATE TABLE events (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL,
  start_date date,
  end_date date,
  sequence integer NOT NULL,
  reality event_reality NOT NULL,
  UNIQUE(work_id, slug),
  CHECK(end_date IS NULL OR start_date IS NULL OR end_date >= start_date)
);
CREATE TABLE event_translations (
  event_id uuid NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  title text NOT NULL,
  summary text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY(event_id, locale)
);
CREATE TABLE event_characters (
  event_id uuid NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  character_id uuid NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  role text NOT NULL,
  PRIMARY KEY(event_id, character_id)
);
CREATE TABLE event_locations (
  event_id uuid NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  location_id uuid NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
  PRIMARY KEY(event_id, location_id)
);
CREATE TABLE character_relations (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  from_character_id uuid NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  to_character_id uuid NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  relation_type text NOT NULL,
  UNIQUE(work_id, from_character_id, to_character_id, relation_type),
  CHECK(from_character_id <> to_character_id)
);
CREATE TABLE relation_translations (
  relation_id uuid NOT NULL REFERENCES character_relations(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  label text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY(relation_id, locale)
);

CREATE TABLE routes (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL,
  layer world_layer NOT NULL,
  certainty route_certainty NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE(work_id, slug)
);
CREATE TABLE route_translations (
  route_id uuid NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  name text NOT NULL,
  summary text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY(route_id, locale)
);
CREATE TABLE route_waypoints (
  route_id uuid NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
  location_id uuid NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
  position integer NOT NULL CHECK(position >= 0),
  event_id uuid REFERENCES events(id) ON DELETE SET NULL,
  PRIMARY KEY(route_id, position)
);

CREATE TABLE sources (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  title text NOT NULL,
  url text,
  citation text NOT NULL,
  evidence_grade text NOT NULL CHECK(evidence_grade IN ('primary', 'scholarly', 'reference'))
);
CREATE TABLE event_sources(event_id uuid NOT NULL REFERENCES events(id) ON DELETE CASCADE, source_id uuid NOT NULL REFERENCES sources(id) ON DELETE CASCADE, PRIMARY KEY(event_id, source_id));

CREATE INDEX work_translation_search_idx ON work_translations USING gin ((title || ' ' || summary) gin_trgm_ops);
CREATE INDEX character_translation_search_idx ON character_translations USING gin ((name || ' ' || summary) gin_trgm_ops);
CREATE INDEX event_translation_search_idx ON event_translations USING gin ((title || ' ' || summary) gin_trgm_ops);
CREATE INDEX location_translation_search_idx ON location_translations USING gin ((name || ' ' || summary) gin_trgm_ops);
CREATE INDEX locations_geom_idx ON locations USING gist(geom);
COMMIT;
