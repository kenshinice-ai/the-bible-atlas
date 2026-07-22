import { z } from "zod";

export const LocaleSchema = z.enum(["zh-CN", "en"]);
export type Locale = z.infer<typeof LocaleSchema>;
const WorkSchema = z.object({ slug:z.string(),authorName:z.string(),contentMode:z.enum(["documented_record","literary_narrative"]),mapLayer:z.enum(["real","fictional"]),title:z.string(),summary:z.string(),resolvedLocale:LocaleSchema,fallbackUsed:z.boolean() });
export const WorksResponseSchema = z.object({ locale:LocaleSchema,items:z.array(WorkSchema.extend({publicationYear:z.number().nullable()})) });
const LocationSchema = z.object({ slug:z.string(),layer:z.enum(["real","fictional"]),lng:z.coerce.number().nullable(),lat:z.coerce.number().nullable(),canvasX:z.coerce.number().nullable(),canvasY:z.coerce.number().nullable(),name:z.string(),summary:z.string() });
const EventSchema = z.object({ slug:z.string(),startDate:z.string().nullable(),endDate:z.string().nullable(),sequence:z.number(),reality:z.string(),title:z.string(),summary:z.string(),locationIds:z.array(z.string()) });
const RouteSchema = z.object({ id:z.string(),slug:z.string(),layer:z.enum(["real","fictional"]),certainty:z.string(),name:z.string(),summary:z.string(),waypoints:z.array(z.object({position:z.number(),locationSlug:z.string()})) });
export const AtlasResponseSchema = z.object({ requestedLocale:LocaleSchema,work:WorkSchema.extend({id:z.string(),default_locale:LocaleSchema}),characters:z.array(z.object({slug:z.string(),name:z.string(),summary:z.string()})),locations:z.array(LocationSchema),events:z.array(EventSchema),routes:z.array(RouteSchema),relations:z.array(z.object({fromSlug:z.string(),toSlug:z.string(),relationType:z.string(),label:z.string()})),sources:z.array(z.object({title:z.string(),url:z.string().nullable(),citation:z.string(),evidenceGrade:z.string()})) });
export type WorksResponse=z.infer<typeof WorksResponseSchema>;
export type Atlas=z.infer<typeof AtlasResponseSchema>;

