BEGIN;
ALTER TABLE seed_history ADD COLUMN seed_name text;
CREATE OR REPLACE FUNCTION normalize_seed_history_version() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.version IS NULL AND NEW.seed_name IS NOT NULL THEN NEW.version := NEW.seed_name; END IF;
  RETURN NEW;
END;
$$;
CREATE TRIGGER seed_history_version_compat BEFORE INSERT ON seed_history FOR EACH ROW EXECUTE FUNCTION normalize_seed_history_version();
INSERT INTO schema_migrations(version) VALUES ('007_seed_history_compat');
COMMIT;
