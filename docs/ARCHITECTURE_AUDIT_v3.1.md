# Architecture Audit v3.1

## Current source of truth

The repository is an npm-workspaces monorepo with a React 19/Vite/strict TypeScript client, an Express 5/strict TypeScript API, PostgreSQL 16 with PostGIS, and Docker Compose. The database is initialized from ordered SQL files. Public strings are stored in entity-specific translation tables and the API applies one explicit fallback: requested published locale, then the work default published locale.

The current runtime has three services: `db`, `api`, and `web`. The macOS start command checks Docker, builds all services, waits for API/Web health, and prints access instructions. The current v3.0 stack has been verified locally before this audit.

## Existing state and interaction model

- `App.tsx` owns URL-derived state with independent React state fields: locale, selection mode, selected works, active work, active tab, selected location, and narrative cutoff.
- `state.ts` parses and validates deep-link state. It currently caps comparison at three works.
- `AtlasMap.tsx` renders real locations with Leaflet and fictional geography with a separate SVG canvas.
- The right browser exposes people, events, locations, and routes. Selection is location-only and encoded as `workSlug:locationSlug`.
- The timeline is a narrative sequence slider. It is not a historical timeline.
- Character relations are returned by the API but only displayed as labels under character cards.

## Reusable foundations

- Translation tables, translation status, locale validation, and per-entity fallback are sound and will remain.
- PostGIS versus fictional-canvas separation is correct and will remain.
- Work-filtered atlas endpoints, Zod response validation, Docker startup, and deep-link restoration are reusable.
- Leaflet, the existing visual palette, and the responsive map/right-panel layout can be incrementally extended.

## Structural blockers

1. The schema cannot represent BCE years, approximate/range/relative dates, or fictional calendars without pretending a PostgreSQL `date` is exact.
2. Character identity lacks gender, age stage, role, reality, aliases, motivations, life bounds, and source links.
3. Relations lack direction, sentiment, strength, lifecycle events, summaries, and sources.
4. Locations lack type, accuracy, historical/modern naming, literary and historical detail, preferred zoom, media, and person links.
5. Events lack type, detail, significance, confidence, parent/child structure, participant ordering, and explicit historical-year bounds.
6. The API response cannot drive a shared person/event/location/route/relation selection model.
7. The map component has no imperative focus controller, popup control, layer controls, fit-all action, or reduced-motion handling.
8. There is no world-history timeline or relationship graph.
9. Work catalog metadata is too thin for search/filter/counts and has no stable theme colors.

## Minimum justified refactor

- Add a forward-only `002_v3_1_complex_atlas.sql` migration; do not rewrite `001_initial.sql`.
- Add a separate transactional Bible seed and update Compose initialization order.
- Extend existing tables and translation tables rather than renaming `characters` to `persons`, preserving API and seed compatibility.
- Replace location-only selection with a typed Explore State while retaining legacy URL parsing.
- Split the client into focused components: work control center, map, historical timeline, relationship graph, and entity drawer.
- Keep the atlas endpoint as the aggregate read model, but enrich it with explicit IDs and associations.

## Risks and controls

- Biblical chronology varies by interpretive tradition. Store broad BCE/CE ranges, `approximate` or `range` time types, confidence, and source notes; never emit invented exact dates.
- Biblical geography includes disputed and approximate sites. Store coordinate accuracy and explain uncertainty in bilingual detail.
- The Bible is an anthology, not a single-author modern novel. Model author as `Various / 多位作者与传统`, use `documented_record`, and label events `reported_historical`, `legendary_or_mythic`, or `contested` as appropriate.
- Existing Docker volumes do not replay init SQL. Delivery verification must use a fresh isolated database; local upgrade uses the migration runner.
- Multi-work maps may become visually dense. Keep a maximum of five, same-layer validation, per-work visibility controls, and a primary work.

## Decision ledger

- “Five works” means a comparison limit of five, not a catalog limit. Adding the Bible produces five catalog works now and remains extensible.
- The Bible uses the real-world map because its places refer to real geographic regions; uncertain locations are marked approximate/inferred rather than moved to fictional coordinates.
- Historical time uses signed integer years (`-` for BCE, positive for CE) plus optional month/day and display labels. PostgreSQL dates remain only for confidently date-compatible modern events.
- The relationship graph will use an accessible SVG layout without a new graph dependency at this data scale; its data contract remains compatible with a future Cytoscape implementation.
- No unlicensed images are shipped in seed v3.1. Media tables and attribution fields are implemented and validated, while the UI explicitly handles an empty media set.
