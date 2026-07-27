-- Widen location_type for fictional works whose places are not settlements.
--
-- Until now every atlas was terrestrial: the enum's 16 values all describe
-- places on a planet's surface, and the one fictional work (the-hobbit) made
-- do with the catch-all 'fictional_place'. A galaxy-scale atlas needs to say
-- "planet" where it means a world, "moon" where it means a satellite, and
-- "space_station" for the mobile installations that are places in the
-- narrative but belong to no world at all.
--
-- These three values are deliberately generic rather than franchise-specific:
-- any future fictional work set beyond one planet reuses them.
--
-- NOTE ON TRANSACTIONS: PostgreSQL 12+ permits ALTER TYPE ... ADD VALUE inside
-- a transaction block, but the new label cannot be *used* until that
-- transaction commits. db-cli.ts applies each migration/seed file as one
-- pool.query(), i.e. one implicit transaction per file — so the seed that
-- first writes 'planet' MUST be a separate file from this one. It is
-- (db/seeds/040_galaxy_structure.sql). Do not fold these ALTERs into a seed.
--
-- Anything reading this enum must be widened in lockstep, or the atlas
-- response fails schema validation as a whole and the app renders nothing:
--   apps/web/src/types.ts   LocationTypeSchema (strict zod enum)
--   apps/web/src/i18n.ts    ENUMS bilingual labels
--   apps/web/src/state.ts   zoomForLocation defaults

ALTER TYPE location_type ADD VALUE IF NOT EXISTS 'planet';
ALTER TYPE location_type ADD VALUE IF NOT EXISTS 'moon';
ALTER TYPE location_type ADD VALUE IF NOT EXISTS 'space_station';

INSERT INTO schema_migrations(version) VALUES ('004_location_type_galaxy') ON CONFLICT DO NOTHING;
