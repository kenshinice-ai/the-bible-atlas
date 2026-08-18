BEGIN;

/*
 * Bible art/music upgrade (plan docs/BIBLE_ART_MUSIC_UPGRADE_PLAN_2026-08-18.md).
 *
 * Four contracts land together because they share one editorial idea: an atlas
 * of an ancient text can carry visual and musical identity without pretending
 * to carry ancient portraits or ancient sound.
 *
 *   1. emblems    — symbolic identity, not portraiture
 *   2. scripture  — verse-level provenance for events
 *   3. quotes     — public-domain speech with an explicit verification state
 *   4. cross-work — reception links between separate atlas works
 */

-- 1. Emblems ----------------------------------------------------------------
-- A person's emblem is a curated claim about *tradition* ("Peter is shown with
-- keys"), never about appearance. symbol_key drives a deterministic vector
-- renderer; every curated row must say where the symbol comes from.
CREATE TABLE character_emblems (
  character_id uuid PRIMARY KEY REFERENCES characters(id) ON DELETE CASCADE,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  symbol_key text NOT NULL CHECK (symbol_key ~ '^[a-z0-9-]+$'),
  ring_key text NOT NULL DEFAULT 'plain' CHECK (ring_key IN ('plain','braided','rayed','thorned','waved','chained')),
  ground_key text NOT NULL DEFAULT 'era' CHECK (ground_key IN ('era','gold','ink','vellum','sky')),
  attestation text NOT NULL DEFAULT 'scriptural' CHECK (attestation IN ('scriptural','liturgical','iconographic')),
  sort_order integer NOT NULL DEFAULT 0
);

CREATE TABLE character_emblem_translations (
  character_id uuid NOT NULL REFERENCES character_emblems(character_id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  symbol_name text NOT NULL,
  symbol_meaning text NOT NULL,
  attribution_note text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (character_id, locale)
);

-- Eras get the same visual grammar so the timeline and the people agree.
CREATE TABLE chapter_emblems (
  chapter_id uuid PRIMARY KEY REFERENCES chapters(id) ON DELETE CASCADE,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  symbol_key text NOT NULL CHECK (symbol_key ~ '^[a-z0-9-]+$'),
  sort_order integer NOT NULL DEFAULT 0
);

CREATE TABLE chapter_emblem_translations (
  chapter_id uuid NOT NULL REFERENCES chapter_emblems(chapter_id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  symbol_name text NOT NULL,
  symbol_meaning text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (chapter_id, locale)
);

COMMENT ON TABLE character_emblems IS 'Symbolic (heraldic) identity for a person. Not a portrait and not a likeness claim.';
COMMENT ON COLUMN character_emblems.attestation IS 'scriptural: the symbol appears in the text; liturgical: church use; iconographic: art-historical convention only.';

-- 2. Scripture references ---------------------------------------------------
-- Events already carry source *titles*; this narrows provenance to book,
-- chapter and verse so a reader can check a claim instead of trusting it.
CREATE TABLE event_scripture_refs (
  id uuid PRIMARY KEY,
  event_id uuid NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  osis_ref text NOT NULL CHECK (osis_ref ~ '^[1-4]?[A-Za-z]+\.[0-9]+(\.[0-9]+(-[1-4]?[A-Za-z]+\.[0-9]+\.[0-9]+)?)?$'),
  book_osis text NOT NULL CHECK (book_osis ~ '^[1-4]?[A-Za-z]+$'),
  chapter_number smallint NOT NULL CHECK (chapter_number > 0),
  verse_start smallint CHECK (verse_start IS NULL OR verse_start > 0),
  verse_end smallint CHECK (verse_end IS NULL OR verse_end > 0),
  ref_role text NOT NULL DEFAULT 'primary' CHECK (ref_role IN ('primary','parallel','background')),
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE (event_id, osis_ref),
  CHECK (verse_end IS NULL OR verse_start IS NULL OR verse_end >= verse_start)
);

CREATE INDEX event_scripture_refs_work_book_idx ON event_scripture_refs(work_id, book_osis, chapter_number, verse_start);

-- 3. Quotes -----------------------------------------------------------------
-- Only public-domain translations may be stored. text_status is the gate that
-- keeps "typed from memory" visibly different from "checked against a source".
CREATE TABLE character_quotes (
  id uuid PRIMARY KEY,
  character_id uuid NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  event_id uuid REFERENCES events(id) ON DELETE SET NULL,
  location_id uuid REFERENCES locations(id) ON DELETE SET NULL,
  osis_ref text NOT NULL CHECK (osis_ref ~ '^[1-4]?[A-Za-z]+\.[0-9]+\.[0-9]+(-[1-4]?[A-Za-z]+\.[0-9]+\.[0-9]+)?$'),
  -- `confession` is a confession of faith. Admitting what one has done is a
  -- different speech act and gets its own kind, so Peter at Caesarea Philippi
  -- and Adam in the garden are not filed under the same word.
  speech_kind text NOT NULL CHECK (speech_kind IN ('declaration','prayer','praise','blessing','lament','command','confession','admission','objection','prophecy','question')),
  importance smallint NOT NULL DEFAULT 3 CHECK (importance BETWEEN 1 AND 5),
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE (character_id, osis_ref)
);

CREATE TABLE character_quote_translations (
  quote_id uuid NOT NULL REFERENCES character_quotes(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  quote_text text NOT NULL CHECK (length(quote_text) BETWEEN 2 AND 600),
  reference_label text NOT NULL,
  context_note text NOT NULL DEFAULT '',
  -- Public-domain editions only. CUV 1919 for Chinese, World English Bible for
  -- English; the KJV is deliberately excluded because of UK Crown copyright.
  translation_edition text NOT NULL CHECK (translation_edition IN ('CUV-1919','WEB')),
  script_variant text NOT NULL DEFAULT 'na' CHECK (script_variant IN ('na','han-traditional')),
  text_status text NOT NULL DEFAULT 'editorially_entered' CHECK (text_status IN ('editorially_entered','source_verified')),
  text_sha256 text NOT NULL CHECK (text_sha256 ~ '^[0-9a-f]{64}$'),
  -- The whole verse as retrieved, so a reviewer can see what the excerpt was
  -- cut from without trusting the excerpt itself.
  source_verse_text text NOT NULL DEFAULT '',
  source_verse_sha256 text CHECK (source_verse_sha256 IS NULL OR source_verse_sha256 ~ '^[0-9a-f]{64}$'),
  verified_source_url text,
  verified_at timestamptz,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (quote_id, locale),
  /*
   * A quote may only claim verification when it carries a retrievable HTTPS
   * source, a timestamp, and the retrieved verse itself — and when the shown
   * excerpt is literally contained in that verse. This is the same containment
   * discipline the Shanhaijing corpus uses for its occurrence quotes.
   *
   * 〔…〕 is stripped before the comparison because in the CUV those brackets
   * carry the apparatus — an alternative rendering the 1919 editors printed
   * inline — not the translated text. Quoting John 1:29 without its bracketed
   * variant is dropping a critical mark, not editing scripture; leaving the
   * mark in would have forced the quote to stop at "Behold, the Lamb of God"
   * and silently cost Chinese readers the whole predicate.
   */
  CHECK (
    text_status <> 'source_verified' OR (
      verified_source_url IS NOT NULL AND verified_source_url LIKE 'https://%'
      AND verified_at IS NOT NULL
      AND source_verse_sha256 IS NOT NULL
      AND position(quote_text IN regexp_replace(source_verse_text, '〔[^〕]*〕', '', 'g')) > 0
    )
  )
);

CREATE INDEX character_quotes_work_character_idx ON character_quotes(work_id, character_id, sort_order);

COMMENT ON COLUMN character_quote_translations.text_status IS 'editorially_entered: typed by an editor, not yet compared against a canonical public-domain file. source_verified: compared, with URL and timestamp.';

-- 4. Cross-work links -------------------------------------------------------
-- Deliberately generic: art history, music history and the Bible are separate
-- works in this schema, and reception runs between them in every direction.
CREATE TABLE cross_work_links (
  id uuid PRIMARY KEY,
  from_work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  from_entity_kind text NOT NULL CHECK (from_entity_kind IN ('character','event','location')),
  from_entity_id uuid NOT NULL,
  to_work_id uuid NOT NULL REFERENCES works(id) ON DELETE CASCADE,
  to_entity_kind text NOT NULL CHECK (to_entity_kind IN ('composition','artwork','character','event','location')),
  to_entity_id uuid NOT NULL,
  link_type text NOT NULL CHECK (link_type IN ('musical_setting','musical_reception','visual_reception','shared_subject')),
  confidence confidence_level NOT NULL DEFAULT 'high',
  sort_order integer NOT NULL DEFAULT 0,
  UNIQUE (from_entity_id, to_entity_id, link_type),
  CHECK (from_work_id <> to_work_id)
);

CREATE TABLE cross_work_link_translations (
  link_id uuid NOT NULL REFERENCES cross_work_links(id) ON DELETE CASCADE,
  locale locale_code NOT NULL,
  label text NOT NULL,
  basis_note text NOT NULL,
  status translation_status NOT NULL DEFAULT 'draft',
  PRIMARY KEY (link_id, locale)
);

CREATE INDEX cross_work_links_from_idx ON cross_work_links(from_work_id, from_entity_kind, from_entity_id, sort_order);
CREATE INDEX cross_work_links_to_idx ON cross_work_links(to_work_id, to_entity_kind, to_entity_id);

COMMENT ON TABLE cross_work_links IS 'Reception links between two different works, e.g. a Bible event and the composition that sets it. Same-work links belong in the domain tables.';

INSERT INTO schema_migrations(version) VALUES ('022_bible_emblems_scripture_music');
COMMIT;
