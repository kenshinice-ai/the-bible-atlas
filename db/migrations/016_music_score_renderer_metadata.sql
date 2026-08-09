BEGIN;

ALTER TABLE score_generation_manifests
  ADD COLUMN renderer_version text NOT NULL DEFAULT 'unknown';

INSERT INTO schema_migrations(version) VALUES ('016_music_score_renderer_metadata');
COMMIT;
