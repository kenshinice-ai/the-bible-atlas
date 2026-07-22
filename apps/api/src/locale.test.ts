import { describe, expect, it } from "vitest";
import { resolveLocale } from "./locale.js";

describe("resolveLocale", () => {
  it("defaults explicitly to zh-CN", () => expect(resolveLocale(undefined)).toEqual({ requestedLocale: "zh-CN", fallbackLocale: "en" }));
  it("rejects unsupported locales", () => expect(() => resolveLocale("fr")).toThrow());
});

