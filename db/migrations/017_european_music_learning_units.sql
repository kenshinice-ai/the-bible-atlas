BEGIN;

/*
 * Phase 2 makes the specialist layer useful as a learning surface rather than
 * only as a catalogue.  A unit is deliberately small and composable: it can
 * point at one or more works and/or score fragments without duplicating the
 * canonical composition or fragment records.
 */
CREATE TABLE music_learning_units (
  id uuid PRIMARY KEY,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  slug text NOT NULL CHECK (slug ~ '^[a-z0-9-]+$'),
  unit_kind text NOT NULL CHECK (unit_kind IN ('listening','score_reading','comparison','route')),
  difficulty text NOT NULL CHECK (difficulty IN ('introductory','intermediate','advanced')),
  target_minutes smallint NOT NULL CHECK (target_minutes BETWEEN 5 AND 120),
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE (work_id, slug),
  UNIQUE (id, work_id)
);

CREATE TABLE music_learning_unit_translations (
  unit_id uuid NOT NULL REFERENCES music_learning_units(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  title text NOT NULL,
  summary text NOT NULL,
  objective text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (unit_id, locale)
);

CREATE TABLE music_learning_unit_compositions (
  unit_id uuid NOT NULL,
  composition_id uuid NOT NULL,
  work_id uuid NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  PRIMARY KEY (unit_id, composition_id),
  FOREIGN KEY (unit_id, work_id) REFERENCES music_learning_units(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (composition_id, work_id) REFERENCES compositions(id, work_id) ON DELETE CASCADE
);

CREATE TABLE music_learning_unit_fragments (
  unit_id uuid NOT NULL,
  fragment_id uuid NOT NULL,
  work_id uuid NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  PRIMARY KEY (unit_id, fragment_id),
  FOREIGN KEY (unit_id, work_id) REFERENCES music_learning_units(id, work_id) ON DELETE CASCADE,
  FOREIGN KEY (fragment_id, work_id) REFERENCES score_fragments(id, work_id) ON DELETE CASCADE
);

CREATE INDEX music_learning_units_work_order_idx
  ON music_learning_units(work_id, sort_order, slug);
CREATE INDEX music_learning_unit_compositions_composition_idx
  ON music_learning_unit_compositions(work_id, composition_id, sort_order);
CREATE INDEX music_learning_unit_fragments_fragment_idx
  ON music_learning_unit_fragments(work_id, fragment_id, sort_order);
CREATE INDEX music_person_roles_work_idx
  ON music_person_roles(work_id, character_id, role);
CREATE INDEX compositions_work_year_idx
  ON compositions(work_id, composition_start_year, sort_order);
CREATE INDEX score_fragments_work_rights_idx
  ON score_fragments(work_id, rights_status, sort_order);

/*
 * Legacy source link tables predate composite work foreign keys.  Keep the
 * links backwards compatible while exposing a machine-checkable audit view so
 * every release can prove that a specialist row does not borrow another
 * work's source by accident.
 */
CREATE VIEW music_cross_work_link_audit AS
SELECT 'composition_sources'::text AS link_table, cs.composition_id AS entity_id, cs.source_id
FROM composition_sources cs
JOIN compositions c ON c.id = cs.composition_id
JOIN sources s ON s.id = cs.source_id
WHERE c.work_id <> s.work_id
UNION ALL
SELECT 'music_style_sources'::text, ms.id, mss.source_id
FROM music_style_sources mss
JOIN music_styles ms ON ms.id = mss.style_id
JOIN sources s ON s.id = mss.source_id
WHERE ms.work_id <> s.work_id
UNION ALL
SELECT 'instrument_sources'::text, i.id, ins.source_id
FROM instrument_sources ins
JOIN instruments i ON i.id = ins.instrument_id
JOIN sources s ON s.id = ins.source_id
WHERE i.work_id <> s.work_id
UNION ALL
SELECT 'music_institution_sources'::text, mi.id, mis.source_id
FROM music_institution_sources mis
JOIN music_institutions mi ON mi.id = mis.institution_id
JOIN sources s ON s.id = mis.source_id
WHERE mi.work_id <> s.work_id
UNION ALL
SELECT 'relation_sources'::text, r.id, rs.source_id
FROM relation_sources rs
JOIN character_relations r ON r.id = rs.relation_id
JOIN sources s ON s.id = rs.source_id
WHERE r.work_id <> s.work_id;

INSERT INTO schema_migrations(version) VALUES ('017_european_music_learning_units');
COMMIT;
