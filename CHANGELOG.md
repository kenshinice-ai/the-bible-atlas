# Changelog

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
