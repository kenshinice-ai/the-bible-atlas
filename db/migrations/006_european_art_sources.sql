BEGIN;
CREATE TABLE artist_sources (
  artist_id uuid NOT NULL REFERENCES artists(id) ON DELETE CASCADE,
  source_id uuid NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  PRIMARY KEY (artist_id, source_id)
);
CREATE TABLE artwork_sources (
  artwork_id uuid NOT NULL REFERENCES artworks(id) ON DELETE CASCADE,
  source_id uuid NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  PRIMARY KEY (artwork_id, source_id)
);
CREATE TABLE movement_sources (
  movement_id uuid NOT NULL REFERENCES movements(id) ON DELETE CASCADE,
  source_id uuid NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  PRIMARY KEY (movement_id, source_id)
);
CREATE TABLE institution_sources (
  institution_id uuid NOT NULL REFERENCES art_institutions(id) ON DELETE CASCADE,
  source_id uuid NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  PRIMARY KEY (institution_id, source_id)
);
INSERT INTO schema_migrations(version) VALUES ('006_european_art_sources');
COMMIT;
