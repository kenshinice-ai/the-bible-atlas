import { EntityTypeSchema, LocaleSchema, type EntityType, type Locale } from "./types";

export type Tab="characters"|"events"|"locations"|"routes"|"relationships";
export type SelectionMode="single"|"multi";
export type MapLayer="real"|"fictional";
export type SelectionSource="map"|"timeline"|"list"|"relationship"|"url";
export type TimelineMode="history"|"narrative";
export type MapContentLayer="places"|"routes"|"landmarks";
export interface SelectedEntity{type:EntityType;id:string;workSlug:string}
export interface ExploreState{
  locale:Locale;mode:SelectionMode;works:string[];active:string;tab:Tab;selectedEntity:SelectedEntity|null;selectionSource:SelectionSource;
  until:number;timelineMode:TimelineMode;rangeStart:number;rangeEnd:number;mapLayers:MapContentLayer[];
}

export const MAX_SELECTED_WORKS=5;
export const DEFAULT_HISTORY_RANGE={start:-3000,end:2026} as const;
const tabs=new Set<Tab>(["characters","events","locations","routes","relationships"]);
const mapLayerValues=new Set<MapContentLayer>(["places","routes","landmarks"]);

function parseEntity(value:string|null,legacy:string|null):SelectedEntity|null{
  if(value){
    const [rawType,workSlug,...idParts]=value.split(":");
    const type=EntityTypeSchema.safeParse(rawType);
    const id=idParts.join(":");
    if(type.success&&workSlug&&id)return{type:type.data,workSlug,id};
  }
  if(legacy){const split=legacy.indexOf(":");if(split>0)return{type:"location",workSlug:legacy.slice(0,split),id:legacy.slice(split+1)}}
  return null;
}

/** Parse shareable Explore State while preserving documented v3.0 links. */
export function parseAtlasState(search:string):ExploreState{
  const q=new URLSearchParams(search);
  const tabValue=q.get("tab");
  const untilValue=Number(q.get("until")??999);
  const rangeStart=Number(q.get("from")??DEFAULT_HISTORY_RANGE.start);
  const rangeEnd=Number(q.get("to")??DEFAULT_HISTORY_RANGE.end);
  const legacyWork=q.get("work");
  const mode:SelectionMode=q.get("mode")==="multi"||q.get("mode")==="compare"?"multi":"single";
  const requestedWorks=(q.get("works")?.split(",")??(legacyWork?[legacyWork]:[])).filter(Boolean);
  const works=requestedWorks.slice(0,mode==="multi"?MAX_SELECTED_WORKS:1);
  const normalizedWorks=works.length>0?works:["the-bible"];
  const requestedActive=q.get("active")??q.get("primary");
  const requestedLayers=(q.get("layers")?.split(",")??["places","routes","landmarks"]).filter((item):item is MapContentLayer=>mapLayerValues.has(item as MapContentLayer));
  return{
    locale:LocaleSchema.catch("zh-CN").parse(q.get("locale")??(q.get("lang")==="en"?"en":"zh-CN")),
    mode,works:normalizedWorks,active:requestedActive&&normalizedWorks.includes(requestedActive)?requestedActive:normalizedWorks[0]!,
    tab:tabValue&&tabs.has(tabValue as Tab)?tabValue as Tab:"events",selectedEntity:parseEntity(q.get("entity"),q.get("selected")),selectionSource:"url",
    until:Number.isInteger(untilValue)&&untilValue>0?untilValue:999,timelineMode:q.get("timeline")==="narrative"?"narrative":"history",
    rangeStart:Number.isInteger(rangeStart)&&rangeStart!==0?rangeStart:DEFAULT_HISTORY_RANGE.start,rangeEnd:Number.isInteger(rangeEnd)&&rangeEnd!==0&&rangeEnd>=rangeStart?rangeEnd:DEFAULT_HISTORY_RANGE.end,
    mapLayers:requestedLayers.length>0?requestedLayers:["places","routes","landmarks"],
  };
}

/** Serialize all navigation state needed for refresh and share restoration. */
export function serializeAtlasState(state:ExploreState):string{
  const q=new URLSearchParams({locale:state.locale,mode:state.mode,works:state.works.join(","),active:state.active,tab:state.tab,timeline:state.timelineMode,layers:state.mapLayers.join(",")});
  if(state.selectedEntity)q.set("entity",`${state.selectedEntity.type}:${state.selectedEntity.workSlug}:${state.selectedEntity.id}`);
  if(state.until!==999)q.set("until",String(state.until));
  if(state.rangeStart!==DEFAULT_HISTORY_RANGE.start)q.set("from",String(state.rangeStart));
  if(state.rangeEnd!==DEFAULT_HISTORY_RANGE.end)q.set("to",String(state.rangeEnd));
  return`?${q}`;
}

/** Change only locale; all exploration context remains intact. */
export function withLocale(state:ExploreState,locale:Locale):ExploreState{return{...state,locale}}

export type SelectionIssue="too_many"|"mixed_layers"|"unknown_work";
export function validateWorkSelection(catalog:readonly {slug:string;mapLayer:MapLayer}[],mode:SelectionMode,selected:readonly string[]):SelectionIssue|null{
  if(selected.length===0||selected.length>(mode==="multi"?MAX_SELECTED_WORKS:1))return"too_many";
  const selectedWorks=selected.map((slug)=>catalog.find((work)=>work.slug===slug));
  if(selectedWorks.some((work)=>work===undefined))return"unknown_work";
  if(new Set(selectedWorks.map((work)=>work!.mapLayer)).size>1)return"mixed_layers";
  return null;
}

/** Convert signed historical years into a sortable scalar without inventing year zero. */
export function historicalSortValue(year:number|null):number{return year??Number.POSITIVE_INFINITY}
export function formatHistoricalYear(year:number,locale:Locale):string{
  if(year===0)return locale==="zh-CN"?"公元纪元分界":"BCE/CE boundary";
  const absolute=Math.abs(year);if(year<0)return locale==="zh-CN"?`公元前 ${absolute} 年`:`${absolute} BCE`;
  return locale==="zh-CN"?`公元 ${absolute} 年`:`${absolute} CE`;
}
export function zoomForLocation(type:string,preferred:number):number{
  const defaults:Record<string,number>={country:5,region:7,city:10,district:13,street:15,building:15,landmark:15,prison:15,station:15,port:13,battlefield:12,residence:15,school:15,religious_site:15,fictional_place:8,route_node:12};
  return Number.isFinite(preferred)&&preferred>=2&&preferred<=18?preferred:(defaults[type]??10);
}
export function relationVisibleAtSequence(relation:{startEventSlug:string|null;endEventSlug:string|null},events:readonly {slug:string;sequence:number}[],sequence:number):boolean{
  const start=relation.startEventSlug?events.find((event)=>event.slug===relation.startEventSlug)?.sequence:undefined;
  const end=relation.endEventSlug?events.find((event)=>event.slug===relation.endEventSlug)?.sequence:undefined;
  return(start===undefined||start<=sequence)&&(end===undefined||end>=sequence);
}
