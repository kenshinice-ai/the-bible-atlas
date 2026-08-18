BEGIN;

-- A media file can be reusable without being an authoritative portrait or
-- eyewitness record. Keep that editorial distinction in the data contract so
-- the UI can explain what an image is doing in an atlas.
CREATE TYPE media_role AS ENUM ('character_depiction', 'place_view', 'event_scene', 'artwork', 'map', 'other');
CREATE TYPE media_depiction_status AS ENUM ('illustrative', 'documentary', 'cartographic', 'unknown');

ALTER TABLE media_assets
  ADD COLUMN media_role media_role NOT NULL DEFAULT 'artwork',
  ADD COLUMN depiction_status media_depiction_status NOT NULL DEFAULT 'illustrative';

COMMENT ON COLUMN media_assets.media_role IS 'Editorial role of the media link: a character depiction is not an authoritative portrait.';
COMMENT ON COLUMN media_assets.depiction_status IS 'Whether the image is illustrative, documentary, cartographic, or not classified.';

CREATE INDEX media_assets_visual_context_idx ON media_assets(media_role, depiction_status);

INSERT INTO schema_migrations(version) VALUES ('019_media_visual_context');
COMMIT;
