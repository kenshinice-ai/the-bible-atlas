import { describe, expect, it } from "vitest";
import { AtlasResponseSchema } from "./types";

const translationMeta={resolvedLocale:"zh-CN",fallbackUsed:false,translationStatus:"published"} as const;
const fixture={requestedLocale:"zh-CN",work:{id:"10000000-0000-4000-8000-000000000001",slug:"a-tale-of-two-cities",authorName:"Charles Dickens",contentMode:"literary_narrative",mapLayer:"real",title:"双城记",summary:"摘要",default_locale:"en",...translationMeta},characters:[{slug:"charles-darnay",name:"查尔斯·达尔内",summary:"摘要",eventSlugs:["darnay-trial"],...translationMeta}],locations:[{slug:"london",layer:"real",lng:-0.1276,lat:51.5072,canvasX:null,canvasY:null,name:"伦敦",summary:"摘要",...translationMeta}],events:[{slug:"darnay-trial",startDate:null,endDate:null,sequence:1,reality:"fictional_narrative",title:"受审",summary:"摘要",locationSlugs:["london"],sourceTitles:["A Tale of Two Cities"],...translationMeta}],routes:[{id:"60000000-0000-4000-8000-000000000001",slug:"route",layer:"real",certainty:"text_explicit",name:"路线",summary:"摘要",waypoints:[{position:0,locationSlug:"london"}],...translationMeta}],relations:[{fromSlug:"charles-darnay",toSlug:"sydney-carton",relationType:"double",label:"命运对照",...translationMeta}],sources:[{title:"A Tale of Two Cities",url:null,citation:"citation",evidenceGrade:"primary"}]};

describe("atlas runtime contract",()=>{
  it("accepts linked entities with explicit translation metadata",()=>expect(AtlasResponseSchema.parse(fixture).events[0]?.locationSlugs).toEqual(["london"]));
  it("rejects a silent entity fallback",()=>{const invalid=structuredClone(fixture) as Record<string,unknown>;const locations=invalid.locations as Array<Record<string,unknown>>;delete locations[0]?.fallbackUsed;expect(AtlasResponseSchema.safeParse(invalid).success).toBe(false)});
});
