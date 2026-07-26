import { AtlasResponseSchema, EntityDetailSchema, SearchResponseSchema, WorksResponseSchema, type Atlas, type EntityDetail, type Locale, type SearchResponse, type WorksResponse } from "./types";

const base = (import.meta.env.VITE_API_URL as string | undefined) ?? "http://localhost:4000";

async function request<T>(path: string, parse: (value: unknown) => T, signal?: AbortSignal): Promise<T> {
  const response = await fetch(`${base}${path}`, { signal: signal ?? null });
  if (!response.ok) throw new Error(`API ${response.status}: ${await response.text()}`);
  return parse(await response.json());
}

export const getWorks = (locale: Locale): Promise<WorksResponse> =>
  request(`/api/works?locale=${encodeURIComponent(locale)}`, (v) => WorksResponseSchema.parse(v));

/**
 * The index payload. `detail=lite` drops the long prose columns so a work can
 * grow to thousands of entities without the first request growing with it;
 * `getEntityDetail` fills the prose back in when a drawer opens.
 */
export const getAtlas = (slug: string, locale: Locale, signal?: AbortSignal): Promise<Atlas> =>
  request(`/api/works/${encodeURIComponent(slug)}/atlas?locale=${encodeURIComponent(locale)}&detail=lite`, (v) => AtlasResponseSchema.parse(v), signal);

export const getEntityDetail = (workSlug: string, kind: string, entitySlug: string, locale: Locale, signal?: AbortSignal): Promise<EntityDetail> =>
  request(
    `/api/works/${encodeURIComponent(workSlug)}/entities/${encodeURIComponent(kind)}/${encodeURIComponent(entitySlug)}?locale=${encodeURIComponent(locale)}`,
    (v) => EntityDetailSchema.parse(v),
    signal,
  );

export const search = (query: string, locale: Locale, signal?: AbortSignal): Promise<SearchResponse> =>
  request(`/api/search?locale=${encodeURIComponent(locale)}&q=${encodeURIComponent(query)}`, (v) => SearchResponseSchema.parse(v), signal);
