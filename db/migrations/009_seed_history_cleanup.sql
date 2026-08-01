BEGIN;
DROP TRIGGER IF EXISTS seed_history_version_compat ON seed_history;
DROP FUNCTION IF EXISTS normalize_seed_history_version();
ALTER TABLE seed_history DROP COLUMN IF EXISTS seed_name;
INSERT INTO schema_migrations(version) VALUES ('009_seed_history_cleanup');
COMMIT;
