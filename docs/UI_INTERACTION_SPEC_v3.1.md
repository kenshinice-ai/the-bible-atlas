# UI Interaction Specification v3.1

## Unified Explore State

One serializable state controls locale, selected works, primary work, active tab, typed entity selection, timeline mode/range and map-layer visibility. It is written to the URL and restored on refresh/back/forward. Language changes preserve every non-language field. Legacy v3.0 location links remain readable.

## Work control center

- Search and category filtering affect the catalog list, not selected data.
- A work click selects it and makes it primary. Up to five same-layer works are allowed.
- Real and fictional works cannot be mixed; the UI explains the rejection.
- Selected chips expose theme color, primary state and removal. A visible count communicates capacity.
- Only selected works are fetched/rendered. The primary work drives people, event, timeline and graph panels.

## Shared entity selection

Person, event, location, route and relationship use a typed `{workSlug, kind, slug}` identity. Selecting from any panel opens the same detail drawer. Cross-links update selection instead of creating parallel local state.

## Map

- Real works render on Leaflet/PostGIS geography; fictional works render on the independent 0–100 SVG canvas.
- A selected place, event-linked place or person-linked place flies to its preferred zoom, highlights and opens a popup.
- Dragging/zooming by the user is not immediately overridden. Re-selecting an entity may refocus it.
- Fit-all includes visible selected-work markers/routes. Per-work layer controls reduce density.
- Marker symbols communicate place type in addition to color. Motion is disabled/reduced for `prefers-reduced-motion`.

## Timeline

- Historical mode sorts signed years from BCE to CE and displays uncertainty labels.
- Narrative mode sorts by sequence and supports relation lifecycle filtering.
- Zoom and pan alter the visible range; full-range restores the work chronology.
- Dense ranges form clickable buckets. Event selection opens details and map linkage.

## Relationship graph

- Nodes are people; edges are typed relationships with direction, sentiment and strength.
- Direct/all filtering reduces density. Narrative cutoff hides relationships before start or after end lifecycle events.
- Node and edge controls are keyboard-focusable and open the person/relation drawer.

## Responsive and accessibility behavior

Desktop uses map plus explorer panels. Narrow screens stack controls, visualization and drawer without horizontal page scrolling. Native buttons/inputs are used, focus indicators remain visible, icons are not the sole carrier of meaning, color themes preserve text contrast, and empty/error/loading states are explicit.
