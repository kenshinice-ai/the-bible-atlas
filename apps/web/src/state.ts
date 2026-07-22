import { LocaleSchema, type Locale } from "./types";

export type Tab = "characters" | "events" | "locations" | "routes";
export type SelectionMode = "single" | "multi";
export type MapLayer = "real" | "fictional";
const tabs = new Set<Tab>(["characters", "events", "locations", "routes"]);
export interface AtlasState { locale:Locale; mode:SelectionMode; works:string[]; active:string; tab:Tab; selected:string|null; until:number }

/** Parse shareable state defensively; invalid individual fields get documented defaults. */
export function parseAtlasState(search:string):AtlasState {
  const q=new URLSearchParams(search);
  const tabValue=q.get("tab");
  const untilValue=Number(q.get("until")??999);
  const legacyWork=q.get("work");
  const mode:SelectionMode=q.get("mode")==="multi"?"multi":"single";
  const requestedWorks=(q.get("works")?.split(",")??(legacyWork?[legacyWork]:[])).filter(Boolean);
  const works=requestedWorks.slice(0,mode==="multi"?3:1);
  const normalizedWorks=works.length>0?works:["a-tale-of-two-cities"];
  const requestedActive=q.get("active");
  return {
    locale:LocaleSchema.catch("zh-CN").parse(q.get("locale")),
    mode,
    works:normalizedWorks,
    active:requestedActive&&normalizedWorks.includes(requestedActive)?requestedActive:normalizedWorks[0]!,
    tab:tabValue&&tabs.has(tabValue as Tab)?tabValue as Tab:"events",
    selected:q.get("selected"),
    until:Number.isInteger(untilValue)&&untilValue>0?untilValue:999,
  };
}

/** Change only locale; all navigation context remains intact. */
export function withLocale(state:AtlasState,locale:Locale):AtlasState{return{...state,locale}}

export type SelectionIssue="too_many"|"mixed_layers"|"unknown_work";

/** Validate a selection restored from a deep link before any map is rendered. */
export function validateWorkSelection(catalog:readonly {slug:string;mapLayer:MapLayer}[],mode:SelectionMode,selected:readonly string[]):SelectionIssue|null{
  if(selected.length===0||selected.length>(mode==="multi"?3:1))return"too_many";
  const selectedWorks=selected.map((slug)=>catalog.find((work)=>work.slug===slug));
  if(selectedWorks.some((work)=>work===undefined))return"unknown_work";
  if(new Set(selectedWorks.map((work)=>work!.mapLayer)).size>1)return"mixed_layers";
  return null;
}
