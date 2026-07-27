import react from "@vitejs/plugin-react";
import { defineConfig, type Plugin } from "vite";
import { PROFILE_META } from "./src/profile-meta";

/**
 * Stamp the active profile's metadata into the static shell.
 *
 * index.html is served before any JavaScript runs, so whatever it contains is
 * what crawlers and link unfurlers see — document.title being corrected at
 * runtime does not reach them. Hard-coding one atlas's copy there meant every
 * other profile shipped that atlas's description; for the galaxy profile it
 * would also drop a required legal disclaimer. Placeholders are substituted
 * here so each build carries only its own copy.
 */
function profileHtml(): Plugin {
  const id = process.env.VITE_WORK_PROFILE ?? "bible";
  const meta = PROFILE_META[id];
  if (!meta) throw new Error(`VITE_WORK_PROFILE="${id}" has no entry in src/profile-meta.ts`);
  const substitutions: Record<string, string> = {
    "%LANG%": meta.lang,
    "%TITLE%": meta.title,
    "%DESCRIPTION%": meta.description,
    "%OG_DESCRIPTION%": meta.ogDescription,
    "%THEME_COLOR%": meta.themeColor,
  };
  return {
    name: "atlas-profile-html",
    transformIndexHtml(html) {
      // Every placeholder sits inside a double-quoted attribute.
      return Object.entries(substitutions).reduce(
        (out, [token, value]) => out.replaceAll(token, value.replaceAll("\"", "&quot;")),
        html,
      );
    },
  };
}

export default defineConfig({ plugins: [react(), profileHtml()], server: { port: 5173 } });
