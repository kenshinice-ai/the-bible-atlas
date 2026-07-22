import { divIcon } from "leaflet";
import { MapContainer, Marker, Polyline, TileLayer, Tooltip } from "react-leaflet";
import type { Atlas } from "../types";

interface Props { atlases:Atlas[]; selected:string|null; onSelect:(key:string)=>void }
const palette=["#b99cff","#f1ad66","#65c6bd"] as const;

/** Render only selected atlases. The parent guarantees every atlas uses the same world layer. */
export function AtlasMap({atlases,selected,onSelect}:Props){
  if(atlases[0]?.work.mapLayer==="fictional") return <FictionalCanvas atlases={atlases} selected={selected} onSelect={onSelect}/>;
  const real=atlases.flatMap((atlas,atlasIndex)=>atlas.locations.flatMap((location)=>location.lat!==null&&location.lng!==null?[{...location,atlas,atlasIndex,lat:location.lat,lng:location.lng}]:[]));
  const byKey=new Map(real.map((location)=>[`${location.atlas.work.slug}:${location.slug}`,location]));
  const first=real[0];
  return <MapContainer className="map" center={first?[first.lat,first.lng]:[48,2]} zoom={4} scrollWheelZoom>
    <TileLayer attribution="© OpenStreetMap contributors" url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"/>
    {atlases.flatMap((atlas,atlasIndex)=>atlas.routes.map((route)=><Polyline key={`${atlas.work.slug}:${route.slug}`} positions={route.waypoints.flatMap((waypoint)=>{const location=byKey.get(`${atlas.work.slug}:${waypoint.locationSlug}`);return location?[[location.lat,location.lng] as [number,number]]:[]})} pathOptions={{color:palette[atlasIndex%palette.length],dashArray:route.certainty==="documented"?undefined:"8 8"}}/>))}
    {real.map((location)=>{const key=`${location.atlas.work.slug}:${location.slug}`;return <Marker key={key} position={[location.lat,location.lng]} icon={divIcon({className:`atlas-marker ${selected===key?"selected":""}`,html:`<span style="background:${palette[location.atlasIndex%palette.length]}"></span>`})} eventHandlers={{click:()=>onSelect(key)}}><Tooltip>{location.atlas.work.title} · {location.name}</Tooltip></Marker>})}
  </MapContainer>;
}

function FictionalCanvas({atlases,selected,onSelect}:Props){
  return <div className="fictional"><svg viewBox="0 0 100 100" role="img" aria-label="Fictional world map canvas"><defs><radialGradient id="glow"><stop stopColor="#b99cff"/><stop offset="1" stopColor="#5d477f"/></radialGradient></defs><path className="mountains" d="M2 55 L18 35 L29 56 L43 25 L57 56 L70 31 L98 60"/>{atlases.flatMap((atlas,atlasIndex)=>{const bySlug=new Map(atlas.locations.map((location)=>[location.slug,location]));return [atlas.routes.map((route)=><polyline key={`${atlas.work.slug}:${route.slug}`} points={route.waypoints.flatMap((waypoint)=>{const location=bySlug.get(waypoint.locationSlug);return location?.canvasX!=null&&location.canvasY!=null?[`${location.canvasX},${location.canvasY}`]:[]}).join(" ")} className="quest" style={{stroke:palette[atlasIndex%palette.length]}}/>),atlas.locations.map((location)=>{const key=`${atlas.work.slug}:${location.slug}`;return location.canvasX!=null&&location.canvasY!=null?<g key={key} transform={`translate(${location.canvasX} ${location.canvasY})`} onClick={()=>onSelect(key)} className={selected===key?"place selected":"place"} role="button"><circle r="2.4" style={{fill:palette[atlasIndex%palette.length]}}/><text y="-4" textAnchor="middle">{location.name}</text></g>:null})]})}</svg><p className="canvas-note">Fictional coordinates · 虚构画布坐标，不映射现实经纬度</p></div>;
}
