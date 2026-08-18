BEGIN;

/*
  Shanhaijing V1 release hardening.

  Migration 001 was written when the repository only admitted real-world works
  plus The Hobbit as a fictional exception.  The domain model now has a
  first-party mythography profile, so the exception must be removed rather than
  special-casing another slug.
*/
DO $$
DECLARE
  constraint_name text;
BEGIN
  SELECT con.conname
    INTO constraint_name
    FROM pg_constraint con
   WHERE con.conrelid = 'public.works'::regclass
     AND con.contype = 'c'
     AND pg_get_constraintdef(con.oid) ILIKE '%map_layer%'
     AND pg_get_constraintdef(con.oid) ILIKE '%the-hobbit%';

  IF constraint_name IS NOT NULL THEN
    EXECUTE format('ALTER TABLE public.works DROP CONSTRAINT %I', constraint_name);
  END IF;
END
$$;

ALTER TABLE works
  ADD CONSTRAINT works_map_layer_valid
  CHECK (map_layer IN ('real', 'fictional'));

/*
  Edition provenance and review metadata.  Defaults keep this migration
  backwards-compatible with the already-created V1 rows; the seed supplies
  explicit values for the frozen Pilot input.
*/
ALTER TABLE shj_text_editions
  ADD COLUMN IF NOT EXISTS edition_reference text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS responsible_editor text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS retrieved_at date,
  ADD COLUMN IF NOT EXISTS source_file_checksum_sha256 text
    CHECK (source_file_checksum_sha256 IS NULL OR source_file_checksum_sha256 ~ '^[0-9a-f]{64}$'),
  ADD COLUMN IF NOT EXISTS transcription_checksum_sha256 text
    CHECK (transcription_checksum_sha256 IS NULL OR transcription_checksum_sha256 ~ '^[0-9a-f]{64}$'),
  ADD COLUMN IF NOT EXISTS license_note text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS segmentation_version text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS reviewer_role text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS reviewed_at date;

ALTER TABLE shj_text_editions
  DROP CONSTRAINT IF EXISTS shj_text_editions_one_baseline_per_work;

CREATE UNIQUE INDEX IF NOT EXISTS shj_text_editions_one_baseline_per_work
  ON shj_text_editions(work_id)
  WHERE is_baseline;

ALTER TABLE shj_text_passages
  ADD COLUMN IF NOT EXISTS source_locator text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS normalization_version text NOT NULL DEFAULT 'none',
  ADD COLUMN IF NOT EXISTS start_char integer
    CHECK (start_char IS NULL OR start_char >= 0),
  ADD COLUMN IF NOT EXISTS end_char integer
    CHECK (end_char IS NULL OR end_char >= 0);

ALTER TABLE shj_passage_translations
  ADD COLUMN IF NOT EXISTS translation_kind text NOT NULL DEFAULT 'original_editorial_summary',
  ADD COLUMN IF NOT EXISTS glossary_version text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS translator_or_editor text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS reviewer_role text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS reviewed_at date;

ALTER TABLE shj_creature_translations
  ADD COLUMN IF NOT EXISTS translation_kind text NOT NULL DEFAULT 'original_editorial_summary',
  ADD COLUMN IF NOT EXISTS glossary_version text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS translator_or_editor text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS reviewer_role text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS reviewed_at date;

ALTER TABLE shj_textual_place_translations
  ADD COLUMN IF NOT EXISTS translation_kind text NOT NULL DEFAULT 'original_editorial_summary',
  ADD COLUMN IF NOT EXISTS glossary_version text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS translator_or_editor text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS reviewer_role text NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS reviewed_at date;

ALTER TABLE shj_creature_occurrences
  ADD COLUMN IF NOT EXISTS start_char integer
    CHECK (start_char IS NULL OR start_char >= 0),
  ADD COLUMN IF NOT EXISTS end_char integer
    CHECK (end_char IS NULL OR end_char >= 0);

ALTER TABLE shj_place_mentions
  ADD COLUMN IF NOT EXISTS start_char integer
    CHECK (start_char IS NULL OR start_char >= 0),
  ADD COLUMN IF NOT EXISTS end_char integer
    CHECK (end_char IS NULL OR end_char >= 0);

/*
  The passage audit is the denominator authority for corpus coverage.  It is
  intentionally separate from public visibility and translation status.
*/
CREATE TABLE IF NOT EXISTS shj_passage_audits (
  passage_id uuid PRIMARY KEY REFERENCES shj_text_passages(id) ON DELETE CASCADE,
  audit_status text NOT NULL CHECK (audit_status IN ('pending_review', 'reviewed', 'excluded')),
  segmentation_version text NOT NULL,
  input_checksum_sha256 text NOT NULL CHECK (input_checksum_sha256 ~ '^[0-9a-f]{64}$'),
  reviewer_role text NOT NULL,
  reviewed_at date,
  evidence_note text NOT NULL DEFAULT ''
);

CREATE TABLE IF NOT EXISTS shj_editorial_decisions (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  decision_key text NOT NULL CHECK (decision_key ~ '^[a-z0-9-]+$'),
  decision_type text NOT NULL CHECK (decision_type IN ('canonical_name', 'merge', 'split', 'variant', 'occurrence', 'exclusion', 'topology')),
  subject_kind text NOT NULL CHECK (subject_kind IN ('passage', 'creature', 'occurrence', 'place', 'taxonomy', 'topology')),
  subject_ref text NOT NULL,
  decision_status text NOT NULL CHECK (decision_status IN ('provisional', 'accepted', 'superseded')),
  rationale text NOT NULL,
  evidence_note text NOT NULL DEFAULT '',
  reviewer_role text NOT NULL,
  decided_at date NOT NULL,
  UNIQUE (work_id, decision_key)
);

CREATE TABLE IF NOT EXISTS shj_occurrence_candidates (
  id uuid PRIMARY KEY,
  passage_id uuid NOT NULL REFERENCES shj_text_passages(id) ON DELETE CASCADE,
  surface_form text NOT NULL,
  start_char integer CHECK (start_char IS NULL OR start_char >= 0),
  end_char integer CHECK (end_char IS NULL OR end_char >= 0),
  disposition text NOT NULL CHECK (disposition IN ('included', 'excluded', 'pending_review', 'not_applicable')),
  creature_id uuid REFERENCES shj_creatures(id) ON DELETE SET NULL,
  occurrence_id uuid REFERENCES shj_creature_occurrences(id) ON DELETE SET NULL,
  evidence_note text NOT NULL DEFAULT '',
  reviewer_role text NOT NULL,
  reviewed_at date
);

CREATE TABLE IF NOT EXISTS shj_text_variants (
  id uuid PRIMARY KEY,
  passage_id uuid NOT NULL REFERENCES shj_text_passages(id) ON DELETE CASCADE,
  occurrence_candidate_id uuid REFERENCES shj_occurrence_candidates(id) ON DELETE SET NULL,
  variant_form text NOT NULL,
  variant_type text NOT NULL CHECK (variant_type IN ('orthographic', 'edition_reading', 'editorial_normalization', 'unresolved')),
  source_note text NOT NULL,
  decision_key text,
  reviewer_role text NOT NULL,
  reviewed_at date
);

CREATE INDEX IF NOT EXISTS shj_passage_audits_status_idx
  ON shj_passage_audits(audit_status, segmentation_version);
CREATE INDEX IF NOT EXISTS shj_occurrence_candidates_passage_idx
  ON shj_occurrence_candidates(passage_id, disposition);
CREATE INDEX IF NOT EXISTS shj_editorial_decisions_subject_idx
  ON shj_editorial_decisions(work_id, subject_kind, subject_ref);
CREATE INDEX IF NOT EXISTS shj_text_variants_passage_idx
  ON shj_text_variants(passage_id, variant_type);

INSERT INTO schema_migrations(version)
VALUES ('021_shanhaijing_release_hardening')
ON CONFLICT DO NOTHING;

COMMIT;
