BEGIN;

CREATE TABLE score_fragments (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  composition_id uuid NOT NULL,
  slug text NOT NULL CHECK (slug ~ '^[a-z0-9-]+$'),
  start_measure integer NOT NULL CHECK (start_measure >= 1),
  end_measure integer NOT NULL,
  notation_kind text NOT NULL CHECK (notation_kind IN ('common','mensural','neume','mixed')),
  mei_asset_path text NOT NULL,
  svg_asset_path text NOT NULL,
  timing_asset_path text NOT NULL,
  audio_asset_path text NOT NULL,
  duration_seconds numeric(6,2) NOT NULL CHECK (duration_seconds BETWEEN 8 AND 30),
  tempo_bpm numeric(6,2),
  tempo_basis text NOT NULL CHECK (tempo_basis IN ('source_marking','editorial_learning','unknown')),
  rights_status text NOT NULL CHECK (rights_status IN ('verified','pending','rejected','unknown')),
  source_id uuid NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE (work_id, slug),
  UNIQUE (id, work_id),
  CHECK (end_measure >= start_measure),
  CHECK ((end_measure - start_measure + 1) BETWEEN 2 AND 8),
  CHECK (tempo_bpm IS NULL OR tempo_bpm > 0),
  CHECK (mei_asset_path ~ '^/media/music/scores/[a-z0-9-]+\\.mei$'),
  CHECK (svg_asset_path ~ '^/media/music/scores/[a-z0-9-]+\\.svg$'),
  CHECK (timing_asset_path ~ '^/media/music/timing/[a-z0-9-]+\\.json$'),
  CHECK (audio_asset_path ~ '^/media/music/audio/[a-z0-9-]+\\.wav$'),
  FOREIGN KEY (composition_id, work_id) REFERENCES compositions(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (source_id, work_id) REFERENCES sources(id, work_id) ON DELETE CASCADE
);

CREATE TABLE score_fragment_translations (
  fragment_id uuid NOT NULL REFERENCES score_fragments(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  title text NOT NULL,
  summary text NOT NULL,
  analysis_note text NOT NULL,
  playback_disclaimer text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (fragment_id, locale)
);

CREATE TABLE score_annotations (
  id uuid PRIMARY KEY,
  fragment_id uuid NOT NULL REFERENCES score_fragments(id) ON DELETE CASCADE,
  target_xml_id text,
  start_beat numeric(8,3),
  end_beat numeric(8,3),
  annotation_type text NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  CHECK (target_xml_id IS NOT NULL OR start_beat IS NOT NULL),
  CHECK (start_beat IS NULL OR start_beat >= 0),
  CHECK (end_beat IS NULL OR start_beat IS NULL OR end_beat >= start_beat)
);

CREATE TABLE score_annotation_translations (
  annotation_id uuid NOT NULL REFERENCES score_annotations(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  label text NOT NULL,
  explanation text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (annotation_id, locale)
);

CREATE TABLE score_generation_manifests (
  fragment_id uuid PRIMARY KEY REFERENCES score_fragments(id) ON DELETE CASCADE,
  mei_checksum_sha256 text NOT NULL CHECK (mei_checksum_sha256 ~ '^[0-9a-f]{64}$'),
  svg_checksum_sha256 text NOT NULL CHECK (svg_checksum_sha256 ~ '^[0-9a-f]{64}$'),
  timing_checksum_sha256 text NOT NULL CHECK (timing_checksum_sha256 ~ '^[0-9a-f]{64}$'),
  audio_checksum_sha256 text NOT NULL CHECK (audio_checksum_sha256 ~ '^[0-9a-f]{64}$'),
  generator_version text NOT NULL,
  synthesis_profile text NOT NULL,
  sample_rate integer NOT NULL DEFAULT 22050 CHECK (sample_rate = 22050),
  channels smallint NOT NULL DEFAULT 1 CHECK (channels = 1),
  bit_depth smallint NOT NULL DEFAULT 16 CHECK (bit_depth = 16),
  output_format text NOT NULL DEFAULT 'wav' CHECK (output_format = 'wav'),
  generated_at timestamptz NOT NULL,
  manifest_path text NOT NULL CHECK (manifest_path ~ '^/media/music/manifests/[a-z0-9-]+\\.json$')
);

CREATE INDEX score_fragments_work_composition_idx ON score_fragments(work_id, composition_id, sort_order);
CREATE INDEX score_fragment_translation_search_idx ON score_fragment_translations USING gin ((title || ' ' || summary || ' ' || analysis_note) gin_trgm_ops);
CREATE INDEX score_annotations_fragment_idx ON score_annotations(fragment_id, sort_order);

INSERT INTO schema_migrations(version) VALUES ('014_music_score_assets');
COMMIT;
