BEGIN;

-- Media links were introduced before the art-history tables and originally
-- accepted only the shared literary entities.  Keep the same polymorphic
-- contract, but explicitly include the art-history entity kinds so an artwork
-- can carry a first-class image or a rights-safe external reference.
ALTER TYPE linked_entity_kind ADD VALUE IF NOT EXISTS 'artist';
ALTER TYPE linked_entity_kind ADD VALUE IF NOT EXISTS 'artwork';
ALTER TYPE linked_entity_kind ADD VALUE IF NOT EXISTS 'movement';
ALTER TYPE linked_entity_kind ADD VALUE IF NOT EXISTS 'institution';

CREATE TYPE media_kind AS ENUM ('image', 'external_link');
CREATE TYPE media_usage_mode AS ENUM ('bundled', 'remote', 'external_link');
CREATE TYPE media_license_status AS ENUM ('verified', 'pending', 'rejected', 'unknown');

ALTER TABLE media_assets
  ADD COLUMN media_kind media_kind NOT NULL DEFAULT 'image',
  ADD COLUMN usage_mode media_usage_mode NOT NULL DEFAULT 'remote',
  ADD COLUMN license_status media_license_status NOT NULL DEFAULT 'unknown',
  ADD COLUMN license_url text,
  ADD COLUMN source_page_url text,
  ADD COLUMN original_url text,
  ADD COLUMN retrieved_at timestamptz,
  ADD COLUMN checksum_sha256 text;

ALTER TABLE media_assets
  DROP CONSTRAINT media_assets_asset_url_check,
  ADD CONSTRAINT media_assets_asset_url_check
    CHECK (
      (usage_mode = 'bundled' AND asset_url ~ '^/media/[A-Za-z0-9._/-]+$') OR
      (usage_mode <> 'bundled' AND asset_url ~ '^https?://')
    ),
  ADD CONSTRAINT media_assets_license_url_check
    CHECK (license_url IS NULL OR license_url ~ '^https?://'),
  ADD CONSTRAINT media_assets_source_page_url_check
    CHECK (source_page_url IS NULL OR source_page_url ~ '^https?://'),
  ADD CONSTRAINT media_assets_original_url_check
    CHECK (original_url IS NULL OR original_url ~ '^https?://'),
  ADD CONSTRAINT media_assets_checksum_sha256_check
    CHECK (checksum_sha256 IS NULL OR checksum_sha256 ~ '^[0-9a-f]{64}$'),
  ADD CONSTRAINT media_assets_kind_usage_check
    CHECK ((media_kind = 'external_link' AND usage_mode = 'external_link') OR (media_kind = 'image' AND usage_mode IN ('bundled', 'remote'))),
  ADD CONSTRAINT media_assets_verified_provenance_check
    CHECK (license_status <> 'verified' OR (license_url IS NOT NULL AND source_page_url IS NOT NULL));

COMMENT ON COLUMN media_assets.asset_url IS 'Direct image URL for image media, or the destination page URL for external_link media.';
COMMENT ON COLUMN media_assets.asset_licence IS 'Human-readable licence label copied from the provider metadata.';
COMMENT ON COLUMN media_assets.license_status IS 'Editorial verification state; only verified media may be bundled into production.';
COMMENT ON COLUMN media_assets.source_page_url IS 'Stable provider/file page used for provenance and attribution.';
COMMENT ON COLUMN media_assets.original_url IS 'Provider-hosted original or thumbnail URL retained for re-download and audit; asset_url may be a bundled local path.';
COMMENT ON COLUMN media_assets.usage_mode IS 'bundled is self-hosted in the static build; remote is a permitted direct image URL; external_link is never rendered as an image.';

CREATE INDEX media_assets_license_status_idx ON media_assets(license_status, media_kind);

INSERT INTO schema_migrations(version) VALUES ('011_artwork_media_rights');
COMMIT;
