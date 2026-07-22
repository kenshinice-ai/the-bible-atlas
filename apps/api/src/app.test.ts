import request from "supertest";
import { describe, expect, it, vi } from "vitest";
import { createApp } from "./app.js";

function setup(rows:Record<string,unknown>[]=[]){
  const query=vi.fn(async()=>({rows,command:"SELECT",rowCount:rows.length,oid:0,fields:[]}));
  return{app:createApp({query} as never),query};
}
describe("HTTP errors and locale contract",()=>{
  it("publishes supported locales",async()=>{const{app}=setup();const response=await request(app).get("/api/locales");expect(response.status).toBe(200);expect(response.body).toMatchObject({locales:["zh-CN","en"],defaultLocale:"zh-CN"})});
  it("rejects an unsupported locale before querying",async()=>{const{app,query}=setup();const response=await request(app).get("/api/works?locale=fr");expect(response.status).toBe(400);expect(query).not.toHaveBeenCalled();expect(response.body).toMatchObject({error:{code:"INVALID_REQUEST"}})});
  it("returns a structured unknown-work error",async()=>{const{app}=setup([]);const response=await request(app).get("/api/works/unknown/atlas?locale=en");expect(response.status).toBe(404);expect(response.body).toEqual({error:{code:"WORK_NOT_FOUND",message:"Unknown work: unknown"}})});
});
