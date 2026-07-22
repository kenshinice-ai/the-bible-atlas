# Data Source Policy v3.1

## Content boundary

The atlas stores original summaries, structured facts, relationship descriptions and short passage citations. It does not store long excerpts from modern translations or copyrighted literary text. A citation identifies where a reader can verify a claim; it is not a substitute for the source.

## Bible chronology and geography

Biblical chronology and geography can be tradition-dependent, approximate or disputed. The seed therefore:

- records signed BCE/CE year ranges instead of invented exact dates;
- labels time as exact, approximate, range, relative, fictional-calendar or unknown;
- labels events as reported historical, legendary/mythic, contested or other existing reality classes;
- records confidence separately from event reality;
- labels coordinates exact, approximate, centroid or inferred and explains uncertainty in both languages;
- uses real-world map coordinates only for geographic referents, never as proof that an event occurred exactly there.

The Bible work is categorized as an ancient anthology/documented record with multiple authors and traditions. The v3.1 sample is deliberately representative, not exhaustive or denominationally authoritative.

## Sources and translations

Seed sources distinguish primary-text passage references, scholarly works, historical references, maps and images. Public entity translations must be `published`; drafts never appear unless the defined fallback resolves to a published default-locale row. Search operates in the explicitly requested locale.

## Media licensing

No unlicensed image is bundled. A publishable `media_assets` row requires source, licence, author, URL, attribution and bilingual alt text. Empty media is a supported state. Future assets should prefer public-domain or clearly compatible open licences, and attribution must remain visible in the entity detail.

## Editorial corrections

Stable slugs and IDs should be preserved. Corrections are applied through a new migration/seed version, recorded in `seed_history`, reviewed in both locales, and validated against the invariants in `TEST_PLAN_v3.1.md`.
