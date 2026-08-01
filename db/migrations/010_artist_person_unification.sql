BEGIN;

-- Art-history artists are people first. Keep the specialist `artists` row for
-- artwork/movement metadata, but give every person a canonical `characters`
-- row so the existing event, place, source and relationship graph can be
-- reused without copying a second identity into the UI.
ALTER TABLE artists
  ADD COLUMN character_id uuid REFERENCES characters(id) ON DELETE SET NULL;

CREATE UNIQUE INDEX artists_character_id_unique
  ON artists(character_id)
  WHERE character_id IS NOT NULL;

ALTER TABLE artist_translations
  ADD COLUMN full_name text NOT NULL DEFAULT '',
  ADD COLUMN aliases text[] NOT NULL DEFAULT '{}',
  ADD COLUMN formal_titles text[] NOT NULL DEFAULT '{}';

COMMENT ON COLUMN artists.character_id IS
  'Canonical people row used by shared event/location/source/relationship chains.';
COMMENT ON COLUMN artist_translations.full_name IS
  'Complete historical name; name remains the concise catalogue label.';
COMMENT ON COLUMN artist_translations.formal_titles IS
  'Documented rank, order, court style or honorific; empty when none is established.';

INSERT INTO schema_migrations(version) VALUES ('010_artist_person_unification');
COMMIT;
