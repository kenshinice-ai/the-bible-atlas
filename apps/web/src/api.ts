import { AtlasResponseSchema, WorksResponseSchema, type Atlas, type Locale, type WorksResponse } from "./types";
const base=(import.meta.env.VITE_API_URL as string | undefined) ?? "http://localhost:4000";
async function request<T>(path:string,parse:(value:unknown)=>T):Promise<T>{const response=await fetch(`${base}${path}`);if(!response.ok)throw new Error(`API ${response.status}: ${await response.text()}`);return parse(await response.json());}
export const getWorks=(locale:Locale):Promise<WorksResponse>=>request(`/api/works?locale=${encodeURIComponent(locale)}`,(v)=>WorksResponseSchema.parse(v));
export const getAtlas=(slug:string,locale:Locale):Promise<Atlas>=>request(`/api/works/${encodeURIComponent(slug)}/atlas?locale=${encodeURIComponent(locale)}`,(v)=>AtlasResponseSchema.parse(v));

