# European Art History time-seed discipline

The European atlas follows the same rules that made the Bible, Three Kingdoms and Galactic Force atlases auditable:

1. Every chapter is an explicit era with `era_start_year`, `era_end_year`, a stable sequence and an accent colour.
2. Every artist, artwork and movement points to one chapter; no entity is rendered without a time anchor.
3. Dates are signed historical years on the BCE/CE convention. Uncertain dates remain ranges or null; they are never silently invented.
4. Historical names and period titles are stored separately from modern status labels. A modern honorific cannot overwrite the name used in the period view.
5. Real locations use PostGIS coordinates only when the location is a real place. Fictional canvas coordinates are not used in this atlas.
6. Every bilingual row has an explicit translation status and a source join. Missing requested locale data resolves to the work default locale and exposes `fallbackUsed`.
7. The skeleton seed is intentionally small and deterministic. Expansion must add a source, a time anchor, both locales and a reproducible UUID in the same change.
8. A named artist is also a person: every `artist_kind=person` row must map to exactly one canonical `characters` row before adding person-level relations. Mirror artist event/location/source links into the character chain; keep the specialist artist row for artwork and movement metadata.
9. `full_name` is the complete historical name, `aliases` contains concise catalogue names, and `formal_titles` contains only source-supported ranks or honorifics. An empty title array is the correct value when no documented title is established.

The first seed (`049_european_art_history_skeleton.sql`) is therefore a framework dataset, not a claim of complete art-historical coverage.
