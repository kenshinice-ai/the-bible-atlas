import { divIcon, latLngBounds, type Marker as LeafletMarker } from "leaflet";
import { useEffect, useMemo, useRef, useState } from "react";
import { CircleMarker, MapContainer, Marker, Polyline, Popup, TileLayer, Tooltip, useMap, useMapEvents, ZoomControl } from "react-leaflet";
import Supercluster from "supercluster";
import { chapterForLocation, trajectoryFor } from "../hierarchy";
import { formatCount, label, t } from "../i18n";
import { zoomForLocation, type MapContentLayer, type SelectedEntity, type SelectionSource, type ZoomLevel } from "../state";
import type { Atlas, AtlasLocation, Locale } from "../types";

interface Props {
  atlases: Atlas[];
  visibleLocationSlugs: ReadonlySet<string>;
  visibleEventSlugs: ReadonlySet<string>;
  selectedEntity: SelectedEntity | null;
  selectionSource: SelectionSource;
  mapLayers: MapContentLayer[];
  zoomLevel: ZoomLevel;
  locale: Locale;
  onSelect: (entity: SelectedEntity, source: SelectionSource) => void;
  onToggleLayer: (layer: MapContentLayer) => void;
}

interface Place extends AtlasLocation {
  atlas: Atlas;
  lat: number;
  lng: number;
  accent: string;
  /** How much of the narrative happens here; drives marker size at every zoom. */
  activity: number;
  visible: boolean;
}

const landmarkTypes = new Set(["building", "landmark", "prison", "station", "port", "battlefield", "residence", "school", "religious_site"]);

function markerGlyph(type: string): string {
  if (type === "building" || type === "residence" || type === "school") return '<path d="M3 17h14M5 17V8l5-4 5 4v9M8 17v-5h4v5"/>';
  if (type === "religious_site") return '<path d="M4 17h12M10 3v11M6.5 6.5h7M6 17v-6h8v6"/>';
  if (type === "port") return '<path d="M10 2v13M6 6h8M4 11c0 4 2 6 6 7 4-1 6-3 6-7"/>';
  if (type === "prison") return '<path d="M4 3v14M8 3v14M12 3v14M16 3v14M3 6h14M3 14h14"/>';
  if (type === "battlefield") return '<path d="M4 16 16 4M4 4l12 12M3 17h4M13 17h4"/>';
  if (type === "landmark") return '<path d="M10 2 3 17h14z"/>';
  if (type === "region" || type === "country") return '<path d="M3 5l5-2 4 2 5-2v12l-5 2-4-2-5 2zM8 3v12M12 5v12"/>';
  if (type === "route_node") return '<circle cx="10" cy="10" r="3"/><path d="M2 10h5M13 10h5"/>';
  return '<circle cx="10" cy="10" r="5"/><path d="M10 1v3M10 16v3M1 10h3M16 10h3"/>';
}

/** Marker radius tiers. Low zoom shows only the busiest places at full size. */
function sizeFor(activity: number): number {
  if (activity >= 8) return 34;
  if (activity >= 4) return 28;
  if (activity >= 2) return 24;
  return 20;
}

function locationForEntity(atlas: Atlas, entity: SelectedEntity): AtlasLocation | undefined {
  if (entity.type === "location") return atlas.locations.find((item) => item.slug === entity.id);
  if (entity.type === "event") { const item = atlas.events.find((event) => event.slug === entity.id); return atlas.locations.find((location) => location.slug === item?.locationSlugs[0]); }
  if (entity.type === "character") { const item = atlas.characters.find((character) => character.slug === entity.id); return atlas.locations.find((location) => location.slug === (item?.birthPlaceSlug ?? item?.locationSlugs[0])); }
  if (entity.type === "route") { const item = atlas.routes.find((route) => route.slug === entity.id); return atlas.locations.find((location) => location.slug === item?.waypoints[0]?.locationSlug); }
  if (entity.type === "relationship") { const relation = atlas.relations.find((item) => item.id === entity.id); const person = atlas.characters.find((item) => item.slug === relation?.fromSlug); return atlas.locations.find((location) => location.slug === person?.locationSlugs[0]); }
  return undefined;
}

function MapFocusController({ target, keyValue, source }: { target: Place | undefined; keyValue: string; source: SelectionSource }) {
  const map = useMap();
  const lastKey = useRef("");
  const dragging = useRef(false);
  useEffect(() => {
    const start = () => { dragging.current = true; };
    const end = () => { dragging.current = false; };
    map.on("dragstart", start); map.on("dragend", end);
    return () => { map.off("dragstart", start); map.off("dragend", end); };
  }, [map]);
  useEffect(() => {
    if (!target || lastKey.current === keyValue || dragging.current) return;
    lastKey.current = keyValue;
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    const zoom = Math.max(map.getZoom(), zoomForLocation(target.locationType, target.preferredZoom) - 2);
    if (reduce) map.setView([target.lat, target.lng], zoom, { animate: false });
    else map.flyTo([target.lat, target.lng], zoom, { animate: source !== "map", duration: source === "map" ? 0.35 : 0.8 });
  }, [keyValue, map, source, target]);
  return null;
}

/**
 * Refits the viewport whenever the set of works changes.
 *
 * react-leaflet only reads `center` on mount, so before v4 switching the primary
 * work in-app left the map stranded over the previous work's region with no
 * markers on screen. Keying the fit on the work list fixes that without
 * hijacking the viewport while the user is panning within one work.
 */
function AutoFitController({ places, fitKey }: { places: Place[]; fitKey: string }) {
  const map = useMap();
  const lastKey = useRef<string | null>(null);
  useEffect(() => {
    if (lastKey.current === fitKey || places.length === 0) return;
    const fit = () => {
      lastKey.current = fitKey;
      map.invalidateSize();
      if (places.length === 1) { map.setView([places[0]!.lat, places[0]!.lng], places[0]!.preferredZoom, { animate: false }); return; }
      map.fitBounds(latLngBounds(places.map((item) => [item.lat, item.lng])), { padding: [48, 48], animate: false });
    };
    // Fitting a map whose container has not been laid out yet (size 0) makes
    // Leaflet compute a nonsense max-zoom viewport, so wait for a real size.
    const container = map.getContainer();
    if (container.clientWidth > 0 && container.clientHeight > 0) { fit(); return; }
    const observer = new ResizeObserver(() => {
      if (container.clientWidth > 0 && container.clientHeight > 0) { fit(); observer.disconnect(); }
    });
    observer.observe(container);
    return () => observer.disconnect();
  }, [fitKey, map, places]);
  return null;
}

interface ClusterPoint { type: "Feature"; properties: { key: string; place: Place }; geometry: { type: "Point"; coordinates: [number, number] } }

/**
 * Clustered marker layer.
 *
 * Without clustering, Jerusalem, Bethlehem, Bethany, Golgotha and the Mount of
 * Olives collapse into one unreadable blob at continental zoom. Supercluster
 * gives the map the same level-of-detail behaviour the graph and the timeline
 * have: fewer, larger objects when zoomed out; individual places when zoomed in.
 */
function ClusteredMarkers({ places, target, selectionSource, locale, zoomLevel, onSelect }: {
  places: Place[]; target: Place | undefined; selectionSource: SelectionSource; locale: Locale; zoomLevel: ZoomLevel;
  onSelect: Props["onSelect"];
}) {
  const map = useMap();
  const [view, setView] = useState(() => ({ zoom: map.getZoom(), bounds: map.getBounds() }));
  useMapEvents({ moveend: () => setView({ zoom: map.getZoom(), bounds: map.getBounds() }), zoomend: () => setView({ zoom: map.getZoom(), bounds: map.getBounds() }) });

  // The shared zoom tier tightens or loosens clustering, so the map answers the
  // same question the graph does at that tier: regions, then areas, then places.
  const radius = { era: 96, group: 74, major: 58, all: 44 }[zoomLevel];
  const index = useMemo(() => {
    const cluster = new Supercluster<ClusterPoint["properties"]>({ radius, maxZoom: 12, minPoints: 2 });
    cluster.load(places.map((place): ClusterPoint => ({
      type: "Feature",
      properties: { key: `${place.atlas.work.slug}:${place.slug}`, place },
      geometry: { type: "Point", coordinates: [place.lng, place.lat] },
    })));
    return cluster;
  }, [places, radius]);

  const clusters = useMemo(() => {
    const bounds = view.bounds;
    const bbox: [number, number, number, number] = [
      Math.max(-180, bounds.getWest()), Math.max(-85, bounds.getSouth()),
      Math.min(180, bounds.getEast()), Math.min(85, bounds.getNorth()),
    ];
    return index.getClusters(bbox, Math.round(view.zoom));
  }, [index, view]);

  return <>
    {clusters.map((feature) => {
      const [lng, lat] = feature.geometry.coordinates as [number, number];
      const clusterId = (feature.properties as { cluster_id?: number }).cluster_id;
      if (clusterId !== undefined) {
        const count = (feature.properties as { point_count: number }).point_count;
        const leaves = index.getLeaves(clusterId, 4).map((leaf) => (leaf.properties as ClusterPoint["properties"]).place);
        const accent = leaves[0]?.accent ?? "#c9972e";
        const diameter = Math.min(64, 34 + Math.log2(count + 1) * 8);
        return <Marker
          key={`cluster-${clusterId}`}
          position={[lat, lng]}
          icon={divIcon({
            className: "atlas-cluster",
            html: `<span style="--accent:${accent};width:${diameter}px;height:${diameter}px">${count}</span>`,
            iconSize: [diameter, diameter], iconAnchor: [diameter / 2, diameter / 2],
          })}
          eventHandlers={{ click: () => map.flyTo([lat, lng], Math.min(16, index.getClusterExpansionZoom(clusterId)), { duration: 0.5 }) }}
        >
          <Tooltip direction="top" offset={[0, -diameter / 2]}>
            <strong>{formatCount(count, "locations", locale)}</strong>
            <br />{leaves.map((leaf) => leaf.name).join(" · ")}{count > 4 ? " …" : ""}
            <br /><em>{t("clusterHint", locale)}</em>
          </Tooltip>
        </Marker>;
      }
      const place = (feature.properties as ClusterPoint["properties"]).place;
      return <PlaceMarker
        key={`${place.atlas.work.slug}:${place.slug}`}
        place={place}
        selected={target?.slug === place.slug && target.atlas.work.slug === place.atlas.work.slug}
        dimmed={Boolean(target) && target?.slug !== place.slug}
        showLabel={view.zoom >= 7}
        source={selectionSource}
        locale={locale}
        onSelect={onSelect}
      />;
    })}
  </>;
}

function PlaceMarker({ place, selected, dimmed, showLabel, source, locale, onSelect }: {
  place: Place; selected: boolean; dimmed: boolean; showLabel: boolean; source: SelectionSource; locale: Locale; onSelect: Props["onSelect"];
}) {
  const markerRef = useRef<LeafletMarker | null>(null);
  useEffect(() => {
    if (!selected) return;
    const timer = window.setTimeout(() => markerRef.current?.openPopup(), source === "map" ? 100 : 700);
    return () => window.clearTimeout(timer);
  }, [selected, source]);
  const size = sizeFor(place.activity);
  const uncertain = place.isInferred || place.coordinateAccuracy === "inferred" || place.coordinateAccuracy === "approximate";
  const classNames = ["atlas-marker", `type-${place.locationType}`, uncertain ? "uncertain" : "surveyed", selected ? "selected" : "", dimmed ? "dimmed" : "", place.visible ? "" : "out-of-range"].filter(Boolean).join(" ");
  return <Marker
    ref={markerRef}
    title={place.name}
    alt={place.name}
    position={[place.lat, place.lng]}
    zIndexOffset={selected ? 1000 : Math.round(place.activity)}
    icon={divIcon({
      className: classNames,
      html: `<span style="--accent:${place.accent};width:${size}px;height:${size}px"><svg viewBox="0 0 20 20" aria-hidden="true">${markerGlyph(place.locationType)}</svg></span>${showLabel ? `<b class="atlas-marker-label">${place.name}</b>` : ""}`,
      iconSize: [size, size], iconAnchor: [size / 2, size / 2],
    })}
    eventHandlers={{ click: () => onSelect({ type: "location", workSlug: place.atlas.work.slug, id: place.slug }, "map") }}
  >
    <Popup>
      <strong>{place.name}</strong>
      <small>{label(place.locationType, locale)} · {label(place.coordinateAccuracy, locale)}</small>
      <p>{place.summary}</p>
      {uncertain && <em>{t("uncertainCoordinate", locale)}</em>}
    </Popup>
  </Marker>;
}

function Legend({ locale, atlases }: { locale: Locale; atlases: Atlas[] }) {
  const [open, setOpen] = useState(false);
  const chapters = atlases[0]?.chapters ?? [];
  return <details className="map-legend" open={open} onToggle={(event) => setOpen(event.currentTarget.open)}>
    <summary>{t("legend", locale)}</summary>
    <div>
      <p className="legend-note">{t("markerSize", locale)}</p>
      <ul className="legend-swatches">
        <li><span className="legend-dot surveyed" /> {t("exactCoordinate", locale)}</li>
        <li><span className="legend-dot uncertain" /> {t("uncertainCoordinate", locale)}</li>
      </ul>
      {chapters.length > 0 && <>
        <p className="legend-note">{t("eraBands", locale)}</p>
        <ul className="legend-eras">
          {chapters.map((chapter) => <li key={chapter.slug}><i style={{ background: chapter.accentColor }} />{chapter.title}</li>)}
        </ul>
      </>}
    </div>
  </details>;
}

function LayerControls({ mapLayers, onToggleLayer, locale }: { mapLayers: MapContentLayer[]; onToggleLayer: (layer: MapContentLayer) => void; locale: Locale }) {
  const labels: Record<MapContentLayer, string> = { places: t("places", locale), routes: t("routes", locale), landmarks: t("landmarks", locale) };
  return <fieldset className="map-layers">
    <legend>{t("mapLayers", locale)}</legend>
    {(["places", "routes", "landmarks"] as MapContentLayer[]).map((layer) => (
      <label key={layer}><input type="checkbox" checked={mapLayers.includes(layer)} onChange={() => onToggleLayer(layer)} />{labels[layer]}</label>
    ))}
  </fieldset>;
}

/** Render selected works and consume the same typed selection as every other panel. */
export function AtlasMap(props: Props) {
  if (props.atlases[0]?.work.mapLayer === "fictional") return <FictionalCanvas {...props} />;
  return <RealMap {...props} />;
}

function RealMap(props: Props) {
  const { atlases, visibleLocationSlugs, visibleEventSlugs, locale } = props;

  const places = useMemo(() => atlases.flatMap((atlas) => atlas.locations.flatMap((location) => {
    if (location.lat === null || location.lng === null) return [];
    const chapter = chapterForLocation(atlas, location);
    const accent = atlas.chapters.find((item) => item.slug === chapter)?.accentColor ?? atlas.work.themeColor;
    const activity = location.eventSlugs.filter((slug) => visibleEventSlugs.has(slug)).length;
    return [{ ...location, atlas, lat: location.lat, lng: location.lng, accent, activity, visible: visibleLocationSlugs.has(location.slug) }];
  })), [atlases, visibleEventSlugs, visibleLocationSlugs]);

  // Layer toggles and the shared time filter both cut the marker set. A place
  // whose every event has been filtered out leaves the map instead of lingering.
  const shown = useMemo(() => places.filter((place) =>
    place.visible &&
    props.mapLayers.includes("places") &&
    (!landmarkTypes.has(place.locationType) || props.mapLayers.includes("landmarks"))
  ), [places, props.mapLayers]);

  const byKey = useMemo(() => new Map(places.map((place) => [`${place.atlas.work.slug}:${place.slug}`, place])), [places]);
  const selectedAtlas = props.selectedEntity ? atlases.find((atlas) => atlas.work.slug === props.selectedEntity?.workSlug) : undefined;
  const selectedLocation = selectedAtlas && props.selectedEntity ? locationForEntity(selectedAtlas, props.selectedEntity) : undefined;
  const target = selectedAtlas && selectedLocation ? byKey.get(`${selectedAtlas.work.slug}:${selectedLocation.slug}`) : undefined;
  const targetKey = target && props.selectedEntity ? `${props.selectedEntity.type}:${props.selectedEntity.workSlug}:${props.selectedEntity.id}` : "";

  const trajectory = useMemo(() => {
    if (!selectedAtlas || props.selectedEntity?.type !== "character") return [];
    return trajectoryFor(selectedAtlas, props.selectedEntity.id);
  }, [props.selectedEntity, selectedAtlas]);

  const fitKey = atlases.map((atlas) => atlas.work.slug).join(",");
  const centre: [number, number] = places[0] ? [places[0].lat, places[0].lng] : [31.8, 35.2];

  return <div className="map-stage">
    <MapContainer className="map" center={centre} zoom={5} scrollWheelZoom zoomControl={false} worldCopyJump>
      {/* A dark basemap so the map belongs to the same surface as the rest of the
          interface; the light default tiles fought every panel around them. */}
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="https://carto.com/attributions">CARTO</a>'
        url="https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
        subdomains="abcd"
        maxZoom={19}
      />
      <ZoomControl position="bottomright" />
      <AutoFitController places={shown.length > 0 ? shown : places} fitKey={fitKey} />
      <MapFocusController target={target} keyValue={targetKey} source={props.selectionSource} />

      {props.mapLayers.includes("routes") && atlases.flatMap((atlas) => atlas.routes.map((route) => {
        const points = route.waypoints.flatMap((waypoint) => {
          const location = byKey.get(`${atlas.work.slug}:${waypoint.locationSlug}`);
          return location ? [[location.lat, location.lng] as [number, number]] : [];
        });
        if (points.length < 2) return null;
        const active = props.selectedEntity?.type === "route" && props.selectedEntity.id === route.slug;
        // `active` is part of the key: Leaflet only applies className when a path
        // is created (react-leaflet's setStyle never re-syncs it), so remounting
        // on toggle is what lets the CSS flow animation attach to the SVG path.
        return <Polyline
          key={`${atlas.work.slug}:${route.slug}:${active ? "active" : "idle"}`}
          className={`atlas-route certainty-${route.certainty}${active ? " active" : ""}`}
          eventHandlers={{ click: () => props.onSelect({ type: "route", workSlug: atlas.work.slug, id: route.slug }, "map") }}
          positions={points}
          pathOptions={{ color: atlas.work.themeColor, dashArray: route.certainty === "documented" ? undefined : "10 8", weight: active ? 5 : 3, opacity: active ? 0.95 : 0.5 }}
        >
          <Tooltip sticky>{route.name} · {label(route.certainty, locale)}</Tooltip>
        </Polyline>;
      }))}

      {/* One person's stops in order: the map answers "where did this life go?" */}
      {trajectory.length > 1 && <>
        <Polyline className="atlas-trajectory" positions={trajectory.map((place) => [place.lat!, place.lng!])} pathOptions={{ color: "#f3c969", weight: 3, opacity: 0.9, dashArray: "2 9", lineCap: "round" }} />
        {trajectory.map((place, index) => <CircleMarker
          key={`trajectory-${place.slug}-${index}`}
          center={[place.lat!, place.lng!]}
          radius={5}
          pathOptions={{ color: "#f3c969", fillColor: "#1a1526", fillOpacity: 1, weight: 2 }}
        >
          <Tooltip direction="top">{index + 1}. {place.name}</Tooltip>
        </CircleMarker>)}
      </>}

      <ClusteredMarkers places={shown} target={target} selectionSource={props.selectionSource} locale={locale} zoomLevel={props.zoomLevel} onSelect={props.onSelect} />
      <FitAllButton places={shown.length > 0 ? shown : places} locale={locale} />
    </MapContainer>

    <div className="map-controls">
      <LayerControls mapLayers={props.mapLayers} onToggleLayer={props.onToggleLayer} locale={locale} />
      <Legend locale={locale} atlases={atlases} />
    </div>
  </div>;
}

function FitAllButton({ places, locale }: { places: Place[]; locale: Locale }) {
  const map = useMap();
  return <button className="map-fit" type="button" onClick={() => {
    if (places.length === 1) { map.setView([places[0]!.lat, places[0]!.lng], places[0]!.preferredZoom); return; }
    if (places.length > 1) map.fitBounds(latLngBounds(places.map((item) => [item.lat, item.lng])), { padding: [48, 48] });
  }}>{t("fitAll", locale)}</button>;
}

function FictionalCanvas(props: Props) {
  const selected = props.selectedEntity?.type === "location" ? `${props.selectedEntity.workSlug}:${props.selectedEntity.id}` : null;
  return <div className="map-stage">
    <div className="fictional">
      <svg viewBox="0 0 100 100" role="img" aria-label="Fictional world map canvas">
        <path className="mountains" d="M2 55 L18 35 L29 56 L43 25 L57 56 L70 31 L98 60" />
        {props.atlases.flatMap((atlas) => {
          const bySlug = new Map(atlas.locations.map((location) => [location.slug, location]));
          return [
            props.mapLayers.includes("routes") && atlas.routes.map((route) => <polyline
              key={`${atlas.work.slug}:${route.slug}`}
              onClick={() => props.onSelect({ type: "route", workSlug: atlas.work.slug, id: route.slug }, "map")}
              points={route.waypoints.flatMap((waypoint) => {
                const location = bySlug.get(waypoint.locationSlug);
                return location?.canvasX != null && location.canvasY != null ? [`${location.canvasX},${location.canvasY}`] : [];
              }).join(" ")}
              className="quest"
              style={{ stroke: atlas.work.themeColor }}
            />),
            props.mapLayers.includes("places") && atlas.locations.map((location) => {
              const key = `${atlas.work.slug}:${location.slug}`;
              if (location.canvasX == null || location.canvasY == null) return null;
              return <g
                key={key}
                transform={`translate(${location.canvasX} ${location.canvasY})`}
                onClick={() => props.onSelect({ type: "location", workSlug: atlas.work.slug, id: location.slug }, "map")}
                className={selected === key ? "place selected" : "place"}
                role="button"
                tabIndex={0}
              >
                <circle r="2.4" style={{ fill: atlas.work.themeColor }} />
                <text y="-4" textAnchor="middle">{location.name}</text>
              </g>;
            }),
          ];
        })}
      </svg>
      <p className="canvas-note">Fictional coordinates · 虚构画布坐标，不映射现实经纬度</p>
    </div>
    <div className="map-controls"><LayerControls mapLayers={props.mapLayers} onToggleLayer={props.onToggleLayer} locale={props.locale} /></div>
  </div>;
}
