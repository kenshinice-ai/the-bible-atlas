BEGIN;

-- Migration 014 used a doubled backslash in PostgreSQL regular expressions.
-- With standard_conforming_strings enabled that matches a literal backslash,
-- so valid same-origin asset paths were rejected. Use `[.]` to make the file
-- extension match unambiguous and portable.
ALTER TABLE score_fragments
  DROP CONSTRAINT score_fragments_mei_asset_path_check,
  DROP CONSTRAINT score_fragments_svg_asset_path_check,
  DROP CONSTRAINT score_fragments_timing_asset_path_check,
  DROP CONSTRAINT score_fragments_audio_asset_path_check,
  ADD CONSTRAINT score_fragments_mei_asset_path_check
    CHECK (mei_asset_path ~ '^/media/music/scores/[a-z0-9-]+[.]mei$'),
  ADD CONSTRAINT score_fragments_svg_asset_path_check
    CHECK (svg_asset_path ~ '^/media/music/scores/[a-z0-9-]+[.]svg$'),
  ADD CONSTRAINT score_fragments_timing_asset_path_check
    CHECK (timing_asset_path ~ '^/media/music/timing/[a-z0-9-]+[.]json$'),
  ADD CONSTRAINT score_fragments_audio_asset_path_check
    CHECK (audio_asset_path ~ '^/media/music/audio/[a-z0-9-]+[.]wav$');

ALTER TABLE score_generation_manifests
  DROP CONSTRAINT score_generation_manifests_manifest_path_check,
  ADD CONSTRAINT score_generation_manifests_manifest_path_check
    CHECK (manifest_path ~ '^/media/music/manifests/[a-z0-9-]+[.]json$');

INSERT INTO schema_migrations(version) VALUES ('015_music_score_asset_path_fix');
COMMIT;
