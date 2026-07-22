import { divIcon, latLngBounds, type Marker as LeafletMarker } from "leaflet";
import { useEffect, useMemo, useRef } from "react";
import { MapContainer, Marker, Polyline, Popup, TileLayer, useMap } from "react-leaflet";
import { zoomForLocation, type MapContentLayer, type SelectedEntity, type SelectionSource } from "../state";
import type { Atlas, AtlasLocation } from "../types";

interface Props{
  atlases:Atlas[];selectedEntity:SelectedEntity|null;selectionSource:SelectionSource;mapLayers:MapContentLayer[];
  onSelect:(entity:SelectedEntity,source:SelectionSource)=>void;onToggleLayer:(layer:MapContentLayer)=>void;labels:{fit:string;places:string;routes:string;landmarks:string;uncertain:string};
}
interface RealPlace extends AtlasLocation{atlas:Atlas;atlasIndex:number;lat:number;lng:number}
const landmarkTypes=new Set(["building","landmark","prison","station","port","battlefield","residence","school","religious_site"]);

function markerGlyph(type:string):string{
  if(type==="building"||type==="residence"||type==="school"||type==="religious_site")return'<svg viewBox="0 0 20 20" aria-hidden="true"><path d="M3 17h14M5 17V8l5-4 5 4v9M8 17v-5h4v5"/></svg>';
  if(type==="port")return'<svg viewBox="0 0 20 20" aria-hidden="true"><path d="M10 2v13M6 6h8M4 11c0 4 2 6 6 7 4-1 6-3 6-7M7 3h6"/></svg>';
  if(type==="prison")return'<svg viewBox="0 0 20 20" aria-hidden="true"><path d="M4 3v14M8 3v14M12 3v14M16 3v14M3 6h14M3 14h14"/></svg>';
  if(type==="region"||type==="country")return'<svg viewBox="0 0 20 20" aria-hidden="true"><path d="M3 5l5-2 4 2 5-2v12l-5 2-4-2-5 2zM8 3v12M12 5v12"/></svg>';
  return'<svg viewBox="0 0 20 20" aria-hidden="true"><circle cx="10" cy="10" r="5"/><path d="M10 1v3M10 16v3M1 10h3M16 10h3"/></svg>';
}

function locationForEntity(atlas:Atlas,entity:SelectedEntity):AtlasLocation|undefined{
  if(entity.type==="location")return atlas.locations.find((item)=>item.slug===entity.id);
  if(entity.type==="event"){const item=atlas.events.find((event)=>event.slug===entity.id);return atlas.locations.find((location)=>location.slug===item?.locationSlugs[0])}
  if(entity.type==="character"){const item=atlas.characters.find((character)=>character.slug===entity.id);return atlas.locations.find((location)=>location.slug===item?.locationSlugs[0])}
  if(entity.type==="route"){const item=atlas.routes.find((route)=>route.slug===entity.id);return atlas.locations.find((location)=>location.slug===item?.waypoints[0]?.locationSlug)}
  if(entity.type==="relationship"){const relation=atlas.relations.find((item)=>item.id===entity.id);const person=atlas.characters.find((item)=>item.slug===relation?.fromSlug);return atlas.locations.find((location)=>location.slug===person?.locationSlugs[0])}
  return undefined;
}

function MapFocusController({target,keyValue,source}:{target:RealPlace|undefined;keyValue:string;source:SelectionSource}){
  const map=useMap();const lastKey=useRef("");const dragging=useRef(false);
  useEffect(()=>{const start=()=>{dragging.current=true};const end=()=>{dragging.current=false};map.on("dragstart",start);map.on("dragend",end);return()=>{map.off("dragstart",start);map.off("dragend",end)}},[map]);
  useEffect(()=>{
    if(!target||lastKey.current===keyValue||dragging.current)return;
    lastKey.current=keyValue;
    const reduce=window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    const zoom=zoomForLocation(target.locationType,target.preferredZoom);
    if(reduce)map.setView([target.lat,target.lng],zoom,{animate:false});else map.flyTo([target.lat,target.lng],zoom,{animate:source!=="map",duration:source==="map"?.35:.8});
  },[keyValue,map,source,target]);
  return null;
}

function FitAllButton({places,label}:{places:RealPlace[];label:string}){
  const map=useMap();
  return <button className="map-fit" type="button" onClick={()=>{if(places.length===1)map.setView([places[0]!.lat,places[0]!.lng],places[0]!.preferredZoom);else if(places.length>1)map.fitBounds(latLngBounds(places.map((item)=>[item.lat,item.lng])),{padding:[36,36]})}}>{label}</button>;
}

function RealLocationMarker({location,selected,dimmed,source,onSelect,uncertain}:{location:RealPlace;selected:boolean;dimmed:boolean;source:SelectionSource;onSelect:Props["onSelect"];uncertain:string}){
  const markerRef=useRef<LeafletMarker|null>(null);
  useEffect(()=>{if(!selected)return;const timer=window.setTimeout(()=>markerRef.current?.openPopup(),source==="map"?100:850);return()=>window.clearTimeout(timer)},[selected,source]);
  return <Marker ref={markerRef} title={location.name} alt={location.name} position={[location.lat,location.lng]} icon={divIcon({className:`atlas-marker type-${location.locationType} reality-${location.atlas.work.category} ${selected?"selected":""} ${dimmed?"dimmed":""}`,html:`<span style="--work-color:${location.atlas.work.themeColor}">${markerGlyph(location.locationType)}</span>`})} eventHandlers={{click:()=>onSelect({type:"location",workSlug:location.atlas.work.slug,id:location.slug},"map")}}><Popup><strong>{location.name}</strong><small>{location.locationType.replaceAll("_"," ")} · {location.coordinateAccuracy}</small><p>{location.summary}</p>{location.isInferred&&<em>{uncertain}</em>}</Popup></Marker>;
}

/** Render selected works and consume the same typed selection as lists, timeline, and graph. */
export function AtlasMap(props:Props){
  if(props.atlases[0]?.work.mapLayer==="fictional")return <FictionalCanvas {...props}/>;
  const real=props.atlases.flatMap((atlas,atlasIndex)=>atlas.locations.flatMap((location)=>location.lat!==null&&location.lng!==null?[{...location,atlas,atlasIndex,lat:location.lat,lng:location.lng}]:[]));
  const visible=real.filter((location)=>props.mapLayers.includes("places")&&(!landmarkTypes.has(location.locationType)||props.mapLayers.includes("landmarks")));
  const byKey=new Map(real.map((location)=>[`${location.atlas.work.slug}:${location.slug}`,location]));
  const selectedAtlas=props.selectedEntity?props.atlases.find((atlas)=>atlas.work.slug===props.selectedEntity?.workSlug):undefined;
  const selectedLocation=selectedAtlas&&props.selectedEntity?locationForEntity(selectedAtlas,props.selectedEntity):undefined;
  const target=selectedAtlas&&selectedLocation?byKey.get(`${selectedAtlas.work.slug}:${selectedLocation.slug}`):undefined;
  const targetKey=target&&props.selectedEntity?`${props.selectedEntity.type}:${props.selectedEntity.workSlug}:${props.selectedEntity.id}`:"";
  return <div className="map-stage"><MapContainer className="map" center={real[0]?[real[0].lat,real[0].lng]:[31.8,35.2]} zoom={4} scrollWheelZoom>
    <TileLayer attribution="© OpenStreetMap contributors" url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"/>
    <MapFocusController target={target} keyValue={targetKey} source={props.selectionSource}/><FitAllButton places={visible} label={props.labels.fit}/>
    {props.mapLayers.includes("routes")&&props.atlases.flatMap((atlas)=>atlas.routes.map((route)=><Polyline key={`${atlas.work.slug}:${route.slug}`} eventHandlers={{click:()=>props.onSelect({type:"route",workSlug:atlas.work.slug,id:route.slug},"map")}} positions={route.waypoints.flatMap((waypoint)=>{const location=byKey.get(`${atlas.work.slug}:${waypoint.locationSlug}`);return location?[[location.lat,location.lng] as [number,number]]:[]})} pathOptions={{color:atlas.work.themeColor,dashArray:route.certainty==="documented"?undefined:"8 8",weight:4}}/>))}
    {visible.map((location)=><RealLocationMarker key={`${location.atlas.work.slug}:${location.slug}`} location={location} selected={target===location} dimmed={Boolean(target&&target!==location)} source={props.selectionSource} onSelect={props.onSelect} uncertain={props.labels.uncertain}/>)}
  </MapContainer><LayerControls {...props}/></div>;
}

function LayerControls({mapLayers,onToggleLayer,labels}:{mapLayers:MapContentLayer[];onToggleLayer:(layer:MapContentLayer)=>void;labels:Props["labels"]}){
  return <fieldset className="map-layers"><legend>Layers</legend>{(["places","routes","landmarks"] as MapContentLayer[]).map((layer)=><label key={layer}><input type="checkbox" checked={mapLayers.includes(layer)} onChange={()=>onToggleLayer(layer)}/>{labels[layer]}</label>)}</fieldset>;
}

function FictionalCanvas(props:Props){
  const selected=props.selectedEntity?.type==="location"?`${props.selectedEntity.workSlug}:${props.selectedEntity.id}`:null;
  return <div className="map-stage"><div className="fictional"><svg viewBox="0 0 100 100" role="img" aria-label="Fictional world map canvas"><defs><radialGradient id="glow"><stop stopColor="#b99cff"/><stop offset="1" stopColor="#5d477f"/></radialGradient></defs><path className="mountains" d="M2 55 L18 35 L29 56 L43 25 L57 56 L70 31 L98 60"/>{props.atlases.flatMap((atlas)=>{const bySlug=new Map(atlas.locations.map((location)=>[location.slug,location]));return [props.mapLayers.includes("routes")&&atlas.routes.map((route)=><polyline key={`${atlas.work.slug}:${route.slug}`} onClick={()=>props.onSelect({type:"route",workSlug:atlas.work.slug,id:route.slug},"map")} points={route.waypoints.flatMap((waypoint)=>{const location=bySlug.get(waypoint.locationSlug);return location?.canvasX!=null&&location.canvasY!=null?[`${location.canvasX},${location.canvasY}`]:[]}).join(" ")} className="quest" style={{stroke:atlas.work.themeColor}}/>),props.mapLayers.includes("places")&&atlas.locations.map((location)=>{const key=`${atlas.work.slug}:${location.slug}`;return location.canvasX!=null&&location.canvasY!=null?<g key={key} transform={`translate(${location.canvasX} ${location.canvasY})`} onClick={()=>props.onSelect({type:"location",workSlug:atlas.work.slug,id:location.slug},"map")} className={selected===key?"place selected":"place"} role="button" tabIndex={0}><circle r="2.4" style={{fill:atlas.work.themeColor}}/><text y="-4" textAnchor="middle">{location.name}</text></g>:null})]})}</svg><p className="canvas-note">Fictional coordinates · 虚构画布坐标，不映射现实经纬度</p></div><LayerControls {...props}/></div>;
}
