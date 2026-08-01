# European Art History time-seed discipline

The European atlas follows the same rules that made the Bible, Three Kingdoms and Galactic Force atlases auditable:

1. Every chapter is an explicit era with `era_start_year`, `era_end_year`, a stable sequence and an accent colour.
2. Every artist, artwork and movement points to one chapter; no entity is rendered without a time anchor.
3. Dates are signed historical years on the BCE/CE convention. Uncertain dates remain ranges or null; they are never silently invented.
4. Historical names and period titles are stored separately from modern status labels. A modern honorific cannot overwrite the name used in the period view.
5. Real locations use PostGIS coordinates only when the location is a real place. Fictional canvas coordinates are not used in this atlas.
6. Every bilingual row has an explicit translation status and a source join. Missing requested locale data resolves to the work default locale and exposes `fallbackUsed`.
7. The skeleton seed is intentionally small and deterministic. Expansion must add a source, a time anchor, both locales and a reproducible UUID in the same change.

The first seed (`049_european_art_history_skeleton.sql`) is therefore a framework dataset, not a claim of complete art-historical coverage.
