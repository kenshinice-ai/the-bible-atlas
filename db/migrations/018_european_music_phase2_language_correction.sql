BEGIN;

/* Keep a rerun-safe correction for databases that loaded the first phase 2
 * seed before the editorial language mapping was tightened. */
UPDATE compositions
SET text_language = CASE slug
  WHEN 'le-jeu-de-robin-et-de-marion' THEN 'fr'
  WHEN 'li-gieus-d-adam' THEN 'fr'
  WHEN 'non-al-suo-amante' THEN 'it'
  WHEN 'fenice-fu' THEN 'it'
  WHEN 'questa-fanciulla' THEN 'it'
  WHEN 'nuper-rosarum-flores' THEN 'la'
  WHEN 'missa-l-homme-arme-dufay' THEN 'la'
  WHEN 'anchor-che-col-partire' THEN 'it'
  WHEN 'il-frutto' THEN 'it'
  WHEN 'o-magnus-mysterium-victoria' THEN 'la'
  WHEN 'sagittarius-davids' THEN 'de'
  WHEN 'musikalische-exequien' THEN 'de'
  WHEN 'geistliche-chormusik' THEN 'de'
  WHEN 'armide-lully' THEN 'fr'
  WHEN 'le-bourgeois-gentilhomme' THEN 'fr'
  WHEN 'stabat-mater-scarlatti' THEN 'la'
  WHEN 'm-dedea' THEN 'it'
  WHEN 'requiem-in-c-cherubini' THEN 'la'
  WHEN 'salome-strauss' THEN 'de'
  WHEN 'woyzeck' THEN 'de'
  ELSE text_language
END
WHERE work_id = '10000000-0000-4000-8000-000000000010'
  AND slug IN (
    'le-jeu-de-robin-et-de-marion','li-gieus-d-adam','non-al-suo-amante','fenice-fu','questa-fanciulla',
    'nuper-rosarum-flores','missa-l-homme-arme-dufay','anchor-che-col-partire','il-frutto','o-magnus-mysterium-victoria',
    'sagittarius-davids','musikalische-exequien','geistliche-chormusik','armide-lully','le-bourgeois-gentilhomme',
    'stabat-mater-scarlatti','m-dedea','requiem-in-c-cherubini','salome-strauss','woyzeck'
  );

INSERT INTO schema_migrations(version) VALUES ('018_european_music_phase2_language_correction');
COMMIT;
