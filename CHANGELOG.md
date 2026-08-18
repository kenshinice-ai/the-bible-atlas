# Changelog

## Unreleased — Review follow-ups, and two works retired (2026-08-18)

- Prepared the New Testament Doré batch under the four conditions the clergy/design review set: the emblem layer is untouched (Jesus keeps the Chi-Rho, so identity stays aniconic), every image lands inside the explicit "later reception" band, and the Passion plates are held back for their own image-by-image batch because nineteenth-century Passion iconography routinely carried the antisemitic visual conventions of its moment. The rights gate refused Doré's Sermon on the Mount — the Commons file carries no artist field — so a different plate takes that slot. The batch is **not in this release**: Wikimedia began rate-limiting this address partway through, so six of fourteen plates are downloaded and the seed is unwritten. `npm run import:bible-dore-media new-testament` resumes it.
- Finished the review's remaining items. Jael and Jezebel had existed here only as engravings of a killing, with no emblem and no saying; both now carry emblems, and Jezebel's is Naboth's vineyard rather than the window she was thrown from, which would have been a verdict. Sarah, Hannah and Deborah gained sayings. The chain and thorn borders came off Judas, Nebuchadnezzar and Saul, where nothing in the text put them there. The Doré Jonah plate keeps its 1866 title — an artwork's name is a historical record and follows the artwork, not the Bible. Alt text now describes the picture instead of repeating the caption. Chinese copy uses full-width punctuation throughout, and images reserve their box so the drawer stops jumping.
- Retired the Shanhaijing and Red Chamber material: both moved to their own projects, verified byte-identical (corpus and generated master) and superset (documentation) there before anything was deleted here. Migrations 020/021 and seeds 064–067 are gone rather than superseded, so a fresh bootstrap never builds that schema; migration 023 drops the tables idempotently for databases that already have them.

## 2026-08-18 — Bible art and music upgrade

- Added a heraldic emblem system for people and eras: 41 curated emblems, each declaring whether its sign is attested in the text, in liturgy, or only in later art, plus a deterministic procedural fallback so every one of the 224 people is identifiable. Emblems replace the silhouette avatar, because the atlas has no evidence for anyone's appearance — and deliberately give Jesus a Chi-Rho rather than a face.
- Added verse-level provenance: 59 event scripture references and 38 recorded sayings in both locales, restricted to public-domain editions (CUV 1919, World English Bible; the KJV is excluded over UK Crown copyright). Every excerpt was proved to be a literal substring of a retrieved verse, and the database refuses to mark a quote verified without the source URL, timestamp and containment holding.
- Added `cross_work_links`, a general reception contract between separate atlas works, and used it for 13 Bible↔European-classical-music links that play the music atlas's existing study synthesis in place, disclaimer intact. No new audio.
- Added a deterministic illuminated overview generated from the atlas's own places and routes (`generate:bible-overview`), used as the Bible profile's hero backdrop with a manifest checksum; era emblems now carry the era rail.
- Added the first Gustave Doré depiction batch: 25 rights-audited public-domain engravings (`import:bible-dore-media`), all stored as illustrative. The New Testament batch is deferred pending liturgical design review.
- Rewrote the Bible media verifier to be database-driven with hardcoded *policy* rather than a frozen asset list, and added `verify:bible-art-music` covering all four new contracts fail-closed.
- Fixed `verify:postgis` on PostgreSQL 18 / macOS, which could not start its throwaway cluster without an explicit locale.
- Acted on a blocking clergy/design review before shipping. The footer still told readers the English scripture was the KJV and that the KJV was public domain — the exact claim this round had decided not to make — so every epigraph moved to the World English Bible and the two Union Version settings now name themselves separately instead of sharing one byline. Quote cards say when they are excerpts. John 1:29 no longer loses its whole predicate in Chinese: the CUV's inline 〔…〕 apparatus is stripped before the containment check rather than truncating the quote. `confession` is labelled 认信, not 表白. Eve's emblem is the name the text gives her, mother of all living, not the serpent that tempted her. Chinese readers get 「创世记 1:1–5」 instead of `Gen.1.1-Gen.1.5`. The drawer now draws an explicit line between the record and later reception, which is the distinction the whole emblem design rests on.

## Unreleased — Shanhaijing Atlas V1 vertical pilot (2026-08-16 → 2026-08-18)

- Added the `shanhaijing` first-party profile with a passage-rooted domain model (17 `shj_*` tables, migrations 020/021) separating creature concepts, textual occurrences, corpus coverage, topology, taxonomy, and artistic interpretation.
- Loaded the first Queshan route of the Nanshan Jing as an audited V1 slice: 9 checksummed passages, 9 creature concepts, 9 occurrences, 9 textual places, 8 topology edges, 19 taxonomy assignments, bilingual throughout (seeds 064/065).
- Wired the API domain loader, Shanhaijing workspace UI, search, epigraphs, and profile metadata; the artistic overview currently falls back to the structured topology view.
- Completed the Gate 0 document suite (20+ specs) with a mechanical consistency verifier (`verify:shanhaijing-docs`); external expert sign-off remains pending, evidence level `local_candidate`.
- Recorded decisions SJ-D010 (V1 pilot authorized ahead of external sign-off), SJ-D011 (artistic overview switches to an original procedural SVG composite; raster generation deferred to Scale), and SJ-D012 (owner internal sign-off; external institutional sign-off stays pending).
- Expanded the corpus to the complete Nanshan Jing (segmentation `nanshan-full-v2`): 43 audited passages across three routes, 39 textual places, 23 creature concepts, 24 occurrences, 36 topology edges, emitted deterministically from a frozen collation.
- Added `verify:shanhaijing`, isolated-database fresh/repeat bootstrap evidence, and a dynamic/static parity report with zero key differences in both locales.
- Fixed three latent defects found while building: the atlas API loader passed three bind parameters to two-placeholder queries (the dynamic shanhaijing payload had never loaded), an SVG filter region clipped flat-ellipse shadows into hard horizontal seams, and `min-width:auto` on workspace grid children leaked the route table's narrow-screen min-width into document-level horizontal overflow at 390px.

## Unreleased — Bible visual pilot (2026-08-09)

- Executed the approved P0/P1/P2 pilot locally: one public-domain visual each for a person, event and location.
- Added visual-context metadata (media_role, depiction_status), bundled Commons provenance/checksum verification, and generic person/event/place drawer media cards with explicit semantic disclaimers.
- Closed the main bilingual UI leaks found in audit: origin region, Bible reference labels, dated/undated event counts, and narrow-screen timeline overflow handling.
- Added db/migrations/019_media_visual_context.sql, db/seeds/063_bible_visual_media_pilot.sql, scripts/verify_bible_visual_media.ts, and the dated handoff/decision records.
- Passed one local validation pass: fresh/repeat bootstrap, media verifier, typecheck, API 5 + Web 33 tests, build, PostGIS/API smoke, English/Chinese drawer checks, and 390px no-overflow check.
- Local candidate only; the public Bible Atlas deployment was not changed. Commit/push remain pending because the iCloud Git refs checkpoint could not be created.

## 2026-08-09 — European Classical Music History Atlas Foundation

- Added the independent bilingual `european-classical-music-history` profile with 48 people, 72 compositions, 20 styles, 24 instruments, 16 institutions, 96 events, 80 relationships and 8 routes.
- Added 28 rights-verified MEI/Verovio/timing/WAV study fragments generated from shared note data, with manifests and SHA-256 verification.
- Published the static profile to Cloudflare Pages production as `european-classical-music-history-atlas`.

## 3.1.0 — 2026-07-22

- Added the Bible as the fifth bilingual work and primary complex reference sample.
- Added 13 people, 14 events, 12 real-world locations, 3 routes, 15 relationships and source-closed links.
- Added BCE/CE range and uncertainty modeling, location accuracy/type, rich identities, relationship lifecycle, chronologies and licensed-media metadata.
- Raised same-layer comparison capacity from three to five and introduced a searchable work control center.
- Added unified deep-linkable Explore State, entity drawer, historical/narrative timeline and relationship graph.
- Added typed map focus, popups, place symbols, fit-all, layer controls and reduced-motion behavior.
- Added forward migration/seed runner and validated fresh-install plus v3.0-volume upgrade paths.
- Updated one-click startup, documentation and release verification for v3.1.
