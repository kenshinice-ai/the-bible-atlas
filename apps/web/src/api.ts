import { AtlasResponseSchema, EntityDetailSchema, SearchResponseSchema, WorksResponseSchema, type Atlas, type EntityDetail, type Locale, type SearchResponse, type WorksResponse } from "./types";

/**
 * Data modes. "api" talks to the Express server; "static" reads the JSON that
 * `apps/api/src/bake-static.ts` baked into /data, which turns the build into a
 * fully static site (deployment plan C — no server, no database).
 */
export const STATIC_DATA = (import.meta.env.VITE_DATA_MODE as string | undefined) === "static";

const base = STATIC_DATA ? "" : ((import.meta.env.VITE_API_URL as string | undefined) ?? "http://localhost:4000");

async function request<T>(path: string, parse: (value: unknown) => T, signal?: AbortSignal): Promise<T> {
  const response = await fetch(`${base}${path}`, { signal: signal ?? null });
  if (!response.ok) throw new Error(`API ${response.status}: ${await response.text()}`);
  return parse(await response.json());
}

export const getWorks = (locale: Locale): Promise<WorksResponse> =>
  STATIC_DATA
    ? request(`/data/works.${encodeURIComponent(locale)}.json`, (v) => WorksResponseSchema.parse(v))
    : request(`/api/works?locale=${encodeURIComponent(locale)}`, (v) => WorksResponseSchema.parse(v));

/**
 * The index payload. Against the API, `detail=lite` drops the long prose
 * columns and `getEntityDetail` fills them in per drawer. The static bake
 * instead ships `detail=full`, so the atlas already carries every field and
 * no further requests are needed.
 */
export const getAtlas = (slug: string, locale: Locale, signal?: AbortSignal): Promise<Atlas> =>
  STATIC_DATA
    ? request(`/data/atlas.${encodeURIComponent(slug)}.${encodeURIComponent(locale)}.json`, (v) => AtlasResponseSchema.parse(v), signal)
    : request(`/api/works/${encodeURIComponent(slug)}/atlas?locale=${encodeURIComponent(locale)}&detail=lite`, (v) => AtlasResponseSchema.parse(v), signal);

export const getEntityDetail = (workSlug: string, kind: string, entitySlug: string, locale: Locale, signal?: AbortSignal): Promise<EntityDetail> =>
  STATIC_DATA
    // The full-detail atlas already holds the prose; the drawer falls back to it.
    ? Promise.resolve({ requestedLocale: locale, kind, slug: entitySlug, fields: {} })
    : request(
      `/api/works/${encodeURIComponent(workSlug)}/entities/${encodeURIComponent(kind)}/${encodeURIComponent(entitySlug)}?locale=${encodeURIComponent(locale)}`,
      (v) => EntityDetailSchema.parse(v),
      signal,
    );

/** Server-backed search; the static build searches the in-memory atlas instead. */
export const search = (query: string, locale: Locale, signal?: AbortSignal): Promise<SearchResponse> =>
  request(`/api/search?locale=${encodeURIComponent(locale)}&q=${encodeURIComponent(query)}`, (v) => SearchResponseSchema.parse(v), signal);
