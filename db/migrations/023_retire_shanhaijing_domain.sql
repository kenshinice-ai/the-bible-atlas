BEGIN;

/*
 * Retire the Shanhaijing domain from this repository.
 *
 * The work moved to its own repository (see the extraction plan that shipped in
 * commit a6d359a, now living with the standalone project). Its corpus JSON and
 * generated master are byte-identical there and its documentation set is a
 * superset of what this repo held, so nothing is lost by removing it here.
 *
 * Migrations 020 and 021, which created these tables, are deleted rather than
 * kept: this repository no longer describes that schema, and a fresh bootstrap
 * should never build it. That leaves two states to reconcile, and this file
 * handles both:
 *
 *   - a fresh database never ran 020/021, so every DROP below is a no-op;
 *   - a database bootstrapped before this change still carries 17 shj_* tables
 *     and a shanhaijing work row, and this drops them.
 *
 * The `mythography` value stays in the work_category enum. Removing a value
 * from a Postgres enum means rebuilding the type and every column that uses it,
 * which is real risk in exchange for tidiness nobody can see.
 */

DELETE FROM works WHERE slug = 'shanhaijing';

DROP VIEW IF EXISTS shj_release_readiness CASCADE;

DROP TABLE IF EXISTS
  shj_artistic_overviews,
  shj_editorial_decisions,
  shj_occurrence_candidates,
  shj_taxonomy_assignments,
  shj_topology_edges,
  shj_place_mentions,
  shj_creature_occurrences,
  shj_creature_translations,
  shj_creatures,
  shj_textual_place_translations,
  shj_textual_places,
  shj_passage_audits,
  shj_passage_translations,
  shj_text_variants,
  shj_text_passages,
  shj_text_sections,
  shj_text_editions
  CASCADE;

INSERT INTO schema_migrations(version) VALUES ('023_retire_shanhaijing_domain');
COMMIT;
