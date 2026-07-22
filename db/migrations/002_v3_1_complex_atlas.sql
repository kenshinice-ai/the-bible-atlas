BEGIN;

CREATE TYPE work_category AS ENUM ('historical_document', 'historical_fiction', 'realist_fiction', 'fantasy', 'mythic_epic');
CREATE TYPE person_gender AS ENUM ('male', 'female', 'unknown', 'na');
CREATE TYPE age_stage AS ENUM ('child', 'youth', 'adult', 'elder', 'unknown');
CREATE TYPE person_role_type AS ENUM ('protagonist', 'antagonist', 'supporting', 'narrator', 'historical', 'collective', 'supernatural');
CREATE TYPE person_reality_type AS ENUM ('historical', 'fictional', 'fictionalised_historical', 'unknown');
CREATE TYPE event_time_type AS ENUM ('exact', 'approximate', 'range', 'relative', 'fictional_calendar', 'unknown');
CREATE TYPE calendar_system AS ENUM ('gregorian', 'julian', 'fictional', 'unknown');
CREATE TYPE literary_event_type AS ENUM ('birth', 'death', 'meeting', 'journey', 'battle', 'trial', 'imprisonment', 'escape', 'marriage', 'betrayal', 'discovery', 'political', 'social', 'religious', 'migration', 'other');
CREATE TYPE confidence_level AS ENUM ('high', 'medium', 'low');
CREATE TYPE location_type AS ENUM ('country', 'region', 'city', 'district', 'street', 'building', 'landmark', 'prison', 'station', 'port', 'battlefield', 'residence', 'school', 'religious_site', 'fictional_place', 'route_node');
CREATE TYPE coordinate_accuracy AS ENUM ('exact', 'approximate', 'city_centroid', 'inferred', 'fictional');
CREATE TYPE relationship_direction AS ENUM ('bidirectional', 'source_to_target', 'target_to_source');
CREATE TYPE relationship_sentiment AS ENUM ('positive', 'negative', 'mixed', 'neutral');
CREATE TYPE relationship_status AS ENUM ('active', 'ended', 'changed', 'unknown');
CREATE TYPE source_type AS ENUM ('primary_text', 'scholarly', 'historical', 'reference', 'map', 'image');
CREATE TYPE chronology_kind AS ENUM ('historical', 'narrative', 'fictional');
CREATE TYPE linked_entity_kind AS ENUM ('work', 'character', 'event', 'location', 'route', 'relationship');

ALTER TABLE works DROP CONSTRAINT IF EXISTS works_check;
ALTER TABLE works
  ADD COLUMN category work_category NOT NULL DEFAULT 'realist_fiction',
  ADD COLUMN origin_region text NOT NULL DEFAULT 'unknown',
  ADD COLUMN chronology_start_year integer,
  ADD COLUMN chronology_end_year integer,
  ADD COLUMN theme_color text NOT NULL DEFAULT '#8b72cf',
  ADD COLUMN theme_color_dark text NOT NULL DEFAULT '#493b77',
  ADD COLUMN theme_color_light text NOT NULL DEFAULT '#d8ccff',
  ADD CONSTRAINT works_chronology_years_nonzero CHECK (chronology_start_year IS NULL OR chronology_start_year <> 0),
  ADD CONSTRAINT works_chronology_end_nonzero CHECK (chronology_end_year IS NULL OR chronology_end_year <> 0),
  ADD CONSTRAINT works_chronology_order CHECK (chronology_start_year IS NULL OR chronology_end_year IS NULL OR chronology_end_year >= chronology_start_year),
  ADD CONSTRAINT works_theme_color_format CHECK (theme_color ~ '^#[0-9A-Fa-f]{6}$' AND theme_color_dark ~ '^#[0-9A-Fa-f]{6}$' AND theme_color_light ~ '^#[0-9A-Fa-f]{6}$');

UPDATE works SET
  category = CASE slug
    WHEN 'a-tale-of-two-cities' THEN 'historical_fiction'::work_category
    WHEN 'the-diary-of-a-young-girl' THEN 'historical_document'::work_category
    WHEN 'the-hobbit' THEN 'fantasy'::work_category
    ELSE 'realist_fiction'::work_category END,
  origin_region = CASE slug
    WHEN 'a-tale-of-two-cities' THEN 'Europe'
    WHEN 'the-diary-of-a-young-girl' THEN 'Europe'
    WHEN 'the-alchemist' THEN 'Europe / North Africa'
    ELSE 'Middle-earth' END,
  theme_color = CASE slug WHEN 'a-tale-of-two-cities' THEN '#b64f5f' WHEN 'the-diary-of-a-young-girl' THEN '#d69a45' WHEN 'the-alchemist' THEN '#2f9f91' ELSE '#8b72cf' END,
  theme_color_dark = CASE slug WHEN 'a-tale-of-two-cities' THEN '#682b37' WHEN 'the-diary-of-a-young-girl' THEN '#76511f' WHEN 'the-alchemist' THEN '#175951' ELSE '#493b77' END,
  theme_color_light = CASE slug WHEN 'a-tale-of-two-cities' THEN '#f4b7c0' WHEN 'the-diary-of-a-young-girl' THEN '#f5d29c' WHEN 'the-alchemist' THEN '#9fe1d8' ELSE '#d8ccff' END;

ALTER TABLE character_translations
  ADD COLUMN aliases text[] NOT NULL DEFAULT '{}',
  ADD COLUMN detail text NOT NULL DEFAULT '',
  ADD COLUMN motivation text NOT NULL DEFAULT '';

ALTER TABLE location_translations
  ADD COLUMN aliases text[] NOT NULL DEFAULT '{}',
  ADD COLUMN detail text NOT NULL DEFAULT '',
  ADD COLUMN literary_significance text NOT NULL DEFAULT '',
  ADD COLUMN historical_background text NOT NULL DEFAULT '',
  ADD COLUMN modern_status text NOT NULL DEFAULT '',
  ADD COLUMN historical_region_name text NOT NULL DEFAULT '';

ALTER TABLE locations
  ADD COLUMN location_type location_type NOT NULL DEFAULT 'city',
  ADD COLUMN coordinate_accuracy coordinate_accuracy NOT NULL DEFAULT 'city_centroid',
  ADD COLUMN preferred_zoom smallint NOT NULL DEFAULT 10,
  ADD COLUMN modern_country_code char(2),
  ADD COLUMN is_inferred boolean NOT NULL DEFAULT false,
  ADD COLUMN still_exists boolean,
  ADD CONSTRAINT locations_zoom_range CHECK (preferred_zoom BETWEEN 2 AND 18);

UPDATE locations SET
  location_type = CASE WHEN layer='fictional' THEN 'fictional_place'::location_type ELSE 'city'::location_type END,
  coordinate_accuracy = CASE WHEN layer='fictional' THEN 'fictional'::coordinate_accuracy ELSE 'city_centroid'::coordinate_accuracy END,
  preferred_zoom = CASE WHEN layer='fictional' THEN 8 ELSE 10 END;

ALTER TABLE locations ADD CONSTRAINT locations_accuracy_matches_layer CHECK ((layer='fictional' AND coordinate_accuracy='fictional') OR (layer='real' AND coordinate_accuracy<>'fictional'));

ALTER TABLE characters
  ADD COLUMN gender person_gender NOT NULL DEFAULT 'unknown',
  ADD COLUMN age_stage age_stage NOT NULL DEFAULT 'unknown',
  ADD COLUMN role_type person_role_type NOT NULL DEFAULT 'supporting',
  ADD COLUMN reality_type person_reality_type NOT NULL DEFAULT 'fictional',
  ADD COLUMN birth_year integer,
  ADD COLUMN death_year integer,
  ADD COLUMN birth_place_id uuid REFERENCES locations(id) ON DELETE SET NULL,
  ADD COLUMN death_place_id uuid REFERENCES locations(id) ON DELETE SET NULL,
  ADD COLUMN icon_variant text NOT NULL DEFAULT 'person',
  ADD COLUMN importance smallint NOT NULL DEFAULT 3,
  ADD CONSTRAINT characters_birth_year_nonzero CHECK (birth_year IS NULL OR birth_year <> 0),
  ADD CONSTRAINT characters_death_year_nonzero CHECK (death_year IS NULL OR death_year <> 0),
  ADD CONSTRAINT characters_life_order CHECK (birth_year IS NULL OR death_year IS NULL OR death_year >= birth_year),
  ADD CONSTRAINT characters_importance_range CHECK (importance BETWEEN 1 AND 5);

UPDATE characters SET
  role_type = CASE WHEN sort_order <= 2 THEN 'protagonist'::person_role_type ELSE 'supporting'::person_role_type END,
  reality_type = CASE WHEN work_id=(SELECT id FROM works WHERE slug='the-diary-of-a-young-girl') THEN 'historical'::person_reality_type ELSE 'fictional'::person_reality_type END;

ALTER TABLE events
  ADD COLUMN event_type literary_event_type NOT NULL DEFAULT 'other',
  ADD COLUMN time_type event_time_type NOT NULL DEFAULT 'unknown',
  ADD COLUMN calendar_system calendar_system NOT NULL DEFAULT 'unknown',
  ADD COLUMN historical_start_year integer,
  ADD COLUMN historical_end_year integer,
  ADD COLUMN start_month smallint,
  ADD COLUMN start_day smallint,
  ADD COLUMN parent_event_id uuid REFERENCES events(id) ON DELETE SET NULL,
  ADD COLUMN confidence confidence_level NOT NULL DEFAULT 'medium',
  ADD CONSTRAINT events_historical_start_nonzero CHECK (historical_start_year IS NULL OR historical_start_year <> 0),
  ADD CONSTRAINT events_historical_end_nonzero CHECK (historical_end_year IS NULL OR historical_end_year <> 0),
  ADD CONSTRAINT events_historical_order CHECK (historical_start_year IS NULL OR historical_end_year IS NULL OR historical_end_year >= historical_start_year),
  ADD CONSTRAINT events_month_range CHECK (start_month IS NULL OR start_month BETWEEN 1 AND 12),
  ADD CONSTRAINT events_day_range CHECK (start_day IS NULL OR start_day BETWEEN 1 AND 31);

UPDATE events SET
  historical_start_year = EXTRACT(YEAR FROM start_date)::integer,
  historical_end_year = EXTRACT(YEAR FROM COALESCE(end_date,start_date))::integer,
  start_month = EXTRACT(MONTH FROM start_date)::integer,
  start_day = EXTRACT(DAY FROM start_date)::integer,
  time_type = CASE WHEN start_date IS NULL THEN 'unknown'::event_time_type ELSE 'exact'::event_time_type END,
  calendar_system = CASE WHEN start_date IS NULL THEN 'unknown'::calendar_system ELSE 'gregorian'::calendar_system END,
  confidence = CASE WHEN reality='verified_historical' THEN 'high'::confidence_level ELSE 'medium'::confidence_level END;

ALTER TABLE event_translations
  ADD COLUMN detail text NOT NULL DEFAULT '',
  ADD COLUMN significance text NOT NULL DEFAULT '',
  ADD COLUMN time_label text NOT NULL DEFAULT '';

ALTER TABLE event_characters
  ADD COLUMN participant_order integer NOT NULL DEFAULT 0,
  ADD COLUMN is_primary boolean NOT NULL DEFAULT true,
  ADD CONSTRAINT event_character_order_nonnegative CHECK (participant_order >= 0);

ALTER TABLE event_locations
  ADD COLUMN role text NOT NULL DEFAULT 'primary',
  ADD COLUMN position integer NOT NULL DEFAULT 0,
  ADD CONSTRAINT event_location_position_nonnegative CHECK (position >= 0);

ALTER TABLE character_relations
  ADD COLUMN direction relationship_direction NOT NULL DEFAULT 'bidirectional',
  ADD COLUMN sentiment relationship_sentiment NOT NULL DEFAULT 'neutral',
  ADD COLUMN strength smallint NOT NULL DEFAULT 3,
  ADD COLUMN status relationship_status NOT NULL DEFAULT 'unknown',
  ADD COLUMN start_event_id uuid REFERENCES events(id) ON DELETE SET NULL,
  ADD COLUMN end_event_id uuid REFERENCES events(id) ON DELETE SET NULL,
  ADD CONSTRAINT relations_strength_range CHECK (strength BETWEEN 1 AND 5),
  ADD CONSTRAINT relations_lifecycle_distinct CHECK (start_event_id IS NULL OR end_event_id IS NULL OR start_event_id <> end_event_id);

ALTER TABLE relation_translations ADD COLUMN summary text NOT NULL DEFAULT '';
ALTER TABLE sources ADD COLUMN source_type source_type NOT NULL DEFAULT 'reference';

CREATE TABLE character_locations (
  character_id uuid NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  location_id uuid NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
  first_event_id uuid REFERENCES events(id) ON DELETE SET NULL,
  last_event_id uuid REFERENCES events(id) ON DELETE SET NULL,
  is_primary boolean NOT NULL DEFAULT false,
  PRIMARY KEY(character_id, location_id)
);

CREATE TABLE character_sources (
  character_id uuid NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  source_id uuid NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  PRIMARY KEY(character_id, source_id)
);

CREATE TABLE relation_sources (
  relation_id uuid NOT NULL REFERENCES character_relations(id) ON DELETE CASCADE,
  source_id uuid NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  PRIMARY KEY(relation_id, source_id)
);

CREATE TABLE chapters (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL,
  sequence integer NOT NULL CHECK(sequence > 0),
  reference_label text NOT NULL,
  UNIQUE(work_id, slug),
  UNIQUE(work_id, sequence)
);

ALTER TABLE events ADD COLUMN chapter_id uuid REFERENCES chapters(id) ON DELETE SET NULL;

CREATE TABLE work_chronologies (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  kind chronology_kind NOT NULL,
  label text NOT NULL,
  start_year integer,
  end_year integer,
  calendar_system calendar_system NOT NULL DEFAULT 'unknown',
  is_default boolean NOT NULL DEFAULT false,
  CHECK(start_year IS NULL OR start_year <> 0),
  CHECK(end_year IS NULL OR end_year <> 0),
  CHECK(start_year IS NULL OR end_year IS NULL OR end_year >= start_year),
  UNIQUE(work_id, kind, label)
);

CREATE TABLE media_assets (
  id uuid PRIMARY KEY,
  source_id uuid REFERENCES sources(id) ON DELETE SET NULL,
  asset_source text NOT NULL,
  asset_licence text NOT NULL,
  asset_author text NOT NULL,
  asset_url text NOT NULL,
  attribution_text text NOT NULL,
  alt_text_zh text NOT NULL,
  alt_text_en text NOT NULL,
  CHECK(asset_url ~ '^https?://')
);

CREATE TABLE media_links (
  media_id uuid NOT NULL REFERENCES media_assets(id) ON DELETE CASCADE,
  entity_kind linked_entity_kind NOT NULL,
  entity_id uuid NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  PRIMARY KEY(media_id, entity_kind, entity_id)
);

CREATE TABLE seed_history (
  version text PRIMARY KEY,
  applied_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO seed_history(version)
SELECT '001_four_works'
WHERE EXISTS (SELECT 1 FROM works WHERE slug='a-tale-of-two-cities')
ON CONFLICT DO NOTHING;

CREATE INDEX characters_work_role_idx ON characters(work_id, role_type, importance DESC);
CREATE INDEX events_historical_year_idx ON events(historical_start_year, historical_end_year);
CREATE INDEX events_work_time_idx ON events(work_id, time_type, sequence);
CREATE INDEX locations_work_type_idx ON locations(work_id, location_type);
CREATE INDEX character_locations_location_idx ON character_locations(location_id);
CREATE INDEX relation_lifecycle_idx ON character_relations(work_id, start_event_id, end_event_id);
CREATE INDEX media_links_entity_idx ON media_links(entity_kind, entity_id);

INSERT INTO schema_migrations(version) VALUES ('002_v3_1_complex_atlas');
COMMIT;
