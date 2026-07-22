import { LocaleSchema, type Locale } from "./types";

export type Tab = "characters" | "events" | "locations" | "routes";
export type SelectionMode = "single" | "multi";
const tabs = new Set<Tab>(["characters", "events", "locations", "routes"]);
export interface AtlasState { locale:Locale; mode:SelectionMode; works:string[]; active:string; tab:Tab; selected:string|null; until:number }

/** Parse shareable state defensively; invalid individual fields get documented defaults. */
export function parseAtlasState(search:string):AtlasState {
  const q=new URLSearchParams(search);
  const tabValue=q.get("tab");
  const untilValue=Number(q.get("until")??999);
  const legacyWork=q.get("work");
  const works=(q.get("works")?.split(",")??(legacyWork?[legacyWork]:[])).filter(Boolean).slice(0,3);
  const normalizedWorks=works.length>0?works:["a-tale-of-two-cities"];
  const requestedActive=q.get("active");
  return {
    locale:LocaleSchema.catch("zh-CN").parse(q.get("locale")),
    mode:q.get("mode")==="multi"?"multi":"single",
    works:normalizedWorks,
    active:requestedActive&&normalizedWorks.includes(requestedActive)?requestedActive:normalizedWorks[0]!,
    tab:tabValue&&tabs.has(tabValue as Tab)?tabValue as Tab:"events",
    selected:q.get("selected"),
    until:Number.isInteger(untilValue)&&untilValue>0?untilValue:999,
  };
}

/** Change only locale; all navigation context remains intact. */
export function withLocale(state:AtlasState,locale:Locale):AtlasState{return{...state,locale}}
