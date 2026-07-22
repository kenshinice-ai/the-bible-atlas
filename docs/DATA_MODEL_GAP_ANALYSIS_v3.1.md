# Data Model Gap Analysis v3.1

## Required additions

| Domain | v3.0 | v3.1 authoritative representation |
|---|---|---|
| Work | author/year/mode/layer | category, origin, chronology bounds, stable theme colors |
| Person | slug/order | gender, age stage, role, reality, life-year bounds, place links, icon, importance |
| Person translation | name/summary | aliases, detail, motivation |
| Event | SQL dates/sequence/reality | event type, time type, calendar, signed year range, month/day, parent event, confidence |
| Event translation | title/summary | detail, significance, human-readable time label |
| Location | coordinates/canvas | type, accuracy, preferred zoom, modern country, existence and inferred flags |
| Location translation | name/summary | aliases, literary significance, historical background, modern status |
| Relation | endpoints/type | direction, sentiment, strength, lifecycle events, status |
| Relation translation | label | summary |
| Source | work/title/citation | source type |
| Cross-links | event-person/event-place | person-place, character-source, relation-source, generic media |
| Structure | none | chapters and work chronologies |

## Time model

`historical_start_year` and `historical_end_year` are signed integers. Negative values are BCE; year zero is forbidden. Month and day are optional and only meaningful when sufficiently supported. `time_type` controls presentation:

- `exact`: all supplied components may be rendered as exact.
- `approximate`: display a localized circa label.
- `range`: display both bounds without collapsing them to one date.
- `relative`: use translated narrative time text and narrative order.
- `fictional_calendar`: never place on the real historical scale unless an explicit mapping is added later.
- `unknown`: narrative order only.

The original `start_date` and `end_date` columns remain for backward compatibility. New readers use the v3.1 fields.

## Bible sample scope

The first v3.1 Bible seed is an intentionally bounded, source-closed pressure sample rather than a claim to encode the entire biblical corpus:

- 13 core people spanning patriarchal, Exodus, monarchy, prophetic, and New Testament narratives.
- 14 representative events with approximate/range time metadata and explicit reality/confidence labels.
- 12 real-world locations with location types, coordinate accuracy, preferred zoom, historical context, and modern-country codes.
- 3 routes with ordered waypoints.
- at least 15 directed or bidirectional relationships with bilingual summaries and lifecycle event links where relevant.
- primary-text citations to Bible passages plus reference sources for geography/chronology policy.

Every visible Bible entity has published `zh-CN` and `en` translations. Seed summaries are original summaries; no long Bible translation passages are stored.

## Invariants

1. Entity slugs remain stable and unique within a work.
2. A relationship cannot point to the same person.
3. Life and historical ranges cannot end before they begin.
4. Signed historical years cannot be zero.
5. Real locations require PostGIS coordinates; fictional locations require canvas coordinates.
6. `coordinate_accuracy=fictional` is only valid for fictional locations.
7. Preferred zoom is 2–18.
8. Theme colors are six-digit hex values.
9. Every published v3.1 seed entity has both public locales.
10. Every Bible event has at least one person, location, and source.
11. Every Bible route waypoint position is unique and contiguous from zero.
12. No media asset may be published without source, licence, URL, and attribution.

## API impact

The aggregate atlas response gains IDs, rich person/location/event/relation fields, link arrays, work metadata, and media. Existing v3.0 field names remain so old behavior is not silently changed. The work catalog gains bilingual alternate title, category/origin/chronology, counts, and theme colors. All new response fields are validated by the web Zod schema.
