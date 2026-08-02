BEGIN;

ALTER TABLE artwork_translations
  ADD COLUMN description text NOT NULL DEFAULT '';

DROP INDEX artwork_translation_search_idx;
CREATE INDEX artwork_translation_search_idx
  ON artwork_translations
  USING gin ((title || ' ' || summary || ' ' || description) gin_trgm_ops);

COMMENT ON COLUMN artwork_translations.summary IS
  'Short list/search summary. Keep concise; long-form display copy belongs in description.';
COMMENT ON COLUMN artwork_translations.description IS
  'Bilingual artwork introduction for the detail drawer: visual subject, context, significance and uncertainty.';

INSERT INTO schema_migrations(version) VALUES ('012_artwork_descriptions');
COMMIT;
