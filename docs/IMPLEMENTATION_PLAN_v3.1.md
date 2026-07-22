# Implementation Plan v3.1

## Phase gates

1. Audit: commit the supplied execution specification and these current-state documents.
2. Data model: add forward migration, constraints, indexes, and data validation queries.
3. Bible data: add bilingual transactional seed and prove entity/link/source counts.
4. Read model: enrich catalog and atlas API while keeping locale behavior explicit.
5. Explore State: support five selections, typed entities, primary work, timeline mode/range, panel, layers, and legacy links.
6. Map: shared selection, fly-to/popup/highlight, typed markers, layer controls, fit-all, and reduced motion.
7. People and relations: identity cards, source-backed details, relationship graph, relation lifecycle filtering.
8. Timeline: BCE/CE density, zoom/pan controls, history/narrative modes, approximate/range labels, and map linkage.
9. Delivery: responsive/accessibility pass, tests, source policy, interaction spec, changelog, Blueprint v3.1, clean migration/seed verification, browser smoke, production build, Git checkpoint, ZIP.

## Compatibility strategy

- Existing work slugs and `/api/works/:slug/atlas` remain stable.
- Existing v3.0 entity identifiers and content remain stable. Its seed gains explicit v3.1 location metadata plus a seed-history marker so fresh installs and upgrades converge.
- New Bible seed is separate and ordered after the migration.
- Existing `locale`, `mode`, `works`, `active`, `tab`, `selected`, and `until` URLs continue to parse. New links add typed entity, timeline, range, and layer parameters.
- Real/fictional same-map exclusion remains. Up to five works may be selected within one layer.

## Verification matrix

| Gate | Evidence |
|---|---|
| SQL | fresh PostGIS database runs 001, 002, old seed, Bible seed in one transaction sequence |
| Data | bilingual coverage, Bible counts, event links, relationship links, route order, location constraints |
| API | locale/catalog/Bible atlas/search responses and negative errors |
| Types | strict API and web TypeScript checks |
| Unit | five-work limit, URL state, BCE ordering, fuzzy time, zoom, relation lifecycle, fallback |
| UI | event/person/location/route/timeline/relation interactions share selected entity |
| Runtime | Docker DB/API/Web healthy and browser-accessible |
| Package | Git archive excludes dependencies, builds, secrets, `.git`, and release output |

## Scope control

No 3D globe, authentication, comments, automated content generation, unlicensed scraping, historic-border animation, or cross-work inferred relationships are part of v3.1. The implementation favors an accessible SVG timeline/graph and CSS identity system over new heavyweight libraries.
