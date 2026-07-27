import type { Locale } from "./types";

/**
 * Deployment profiles: one engine, many atlases.
 *
 * A profile pins which works a build serves, its branding, its default
 * language and its visual theme. `VITE_WORK_PROFILE` selects one at build
 * time; everything else in the app reads from the resolved PROFILE constant.
 * The Bible profile reproduces the original BIBLE_ONLY behaviour exactly.
 */
export interface WorkProfile {
  id: string;
  /** Work slugs this build is locked to; deep links outside are normalised. */
  works: string[];
  /** The work that opens as primary. */
  active: string;
  mode: "single" | "multi";
  defaultLocale: Locale;
  /** Brand strings as [zh, en]; these override the i18n title/tagline keys. */
  title: readonly [string, string];
  tagline: readonly [string, string];
  /** data-profile attribute value driving the CSS token theme. */
  theme: string;
}

export const PROFILES: Record<string, WorkProfile> = {
  bible: {
    id: "bible",
    works: ["the-bible"],
    active: "the-bible",
    mode: "single",
    defaultLocale: "en",
    title: ["圣经舆图", "The Bible Atlas"],
    tagline: ["从起初,直到地极", "From the Beginning to the Ends of the Earth"],
    theme: "bible",
  },
  "three-kingdoms": {
    id: "three-kingdoms",
    works: ["records-of-the-three-kingdoms", "romance-of-the-three-kingdoms"],
    active: "romance-of-the-three-kingdoms",
    mode: "multi",
    defaultLocale: "zh-CN",
    title: ["三国舆图", "The Three Kingdoms Atlas"],
    tagline: ["是非成败,俱付笑谈", "History and Romance, Mapped Side by Side"],
    theme: "three-kingdoms",
  },
};

const requested = (import.meta.env.VITE_WORK_PROFILE as string | undefined) ?? "bible";
export const PROFILE: WorkProfile = PROFILES[requested] ?? PROFILES.bible!;
