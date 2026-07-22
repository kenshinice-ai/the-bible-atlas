# Test Plan v3.1

## Release gates

Every command must exit zero; failures are reported and never converted to warnings.

| Gate | Command or procedure | Acceptance |
|---|---|---|
| Strict types | `npm run typecheck` | API and Web compile with strict TypeScript |
| Unit/API | `npm test` | locale, fallback, URL state, five-work cap, BCE sorting, contracts pass |
| Production | `npm run build` | API JavaScript and optimized Web bundle build |
| SQL/API integration | `npm run verify:postgis` | v3.0 upgrade, fresh migrations, both seeds, invariants and API smoke pass |
| Launcher | `npm run test:start-command` | command syntax, dry-run, Unicode-path mode and v3.1 instructions pass |
| Compose runtime | `./Start-Literary-Atlas.command --no-open` | migrate exits 0; DB/API/Web become healthy |
| Browser | manual scripted flow below | URL, details, map, timeline, graph, locale and responsive behavior agree |

## Browser critical path

1. Open `/` and confirm the default primary work is the Bible in Chinese.
2. Select a Bible event. Confirm its typed deep link, detail drawer, people, place and sources.
3. Follow its place link. Confirm map focus, selected marker, popup and preferred zoom.
4. Switch to the timeline; toggle historical/narrative modes, zoom, pan and select a BCE event.
5. Switch to relationships; select a node and an edge and confirm person/relation details.
6. Switch to English and refresh. Locale, works, tab, time mode/range and entity selection must survive.
7. Add compatible real-map works, hide/show a work layer, fit all, then remove a work.
8. Switch to the Hobbit. Confirm it uses only the fictional canvas and cannot mix with real works.
9. Repeat the main flow at a narrow mobile viewport; controls remain reachable and focus-visible.

## Data assertions

- Five works have published `zh-CN` and `en` titles.
- Bible: 13 people, 14 events, 12 places, 3 routes, 15 relationships.
- Every Bible event has at least one person, place and source.
- Approximate/range biblical dates do not use exact SQL dates.
- Real places use PostGIS and non-fictional accuracy; Hobbit places use canvas coordinates and fictional accuracy.
- Draft requested translations fall back only to the work default published locale and report `fallbackUsed=true`.
- Unsupported locale returns 400; unknown work returns 404.

## Upgrade and rollback

`verify_postgis.sh` creates a separate v3.0 fixture database containing a fictional location, applies migration 002, and confirms the location is backfilled before the new constraint is installed. SQL migrations are forward-only. For local recovery, back up the Postgres volume before upgrade; do not delete a volume as a rollback method.
