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
  /**
   * Era naming for works that do not count years from the Common Era.
   * `{n}` is replaced by the absolute year; negative/positive select the side
   * of the epoch. Absent means the atlas is dated BCE/CE as before.
   */
  yearLabels?: { negative: readonly [string, string]; positive: readonly [string, string] };
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
  // Unofficial fan reference. The product name carries no trademark, and the
  // tagline states the unofficial relationship in the nominative-use form
  // required by blueprint/star-wars/IP_AND_NAMING.md §1.
  galaxy: {
    id: "galaxy",
    works: ["skywalker-saga"],
    active: "skywalker-saga",
    mode: "single",
    defaultLocale: "en",
    title: ["银河原力舆图", "The Galactic Force Atlas"],
    tagline: ["天行者九部曲非官方检索图集", "An unofficial reference to the Skywalker saga"],
    theme: "galaxy",
    // Years are counted from the battle of Yavin: BBY before, ABY after. There
    // is no year zero, matching the BCE/CE convention the database already
    // enforces, so 0 BBY maps to -1 and 0 ABY to +1.
    yearLabels: {
      negative: ["雅汶战役前 {n} 年", "{n} BBY"],
      positive: ["雅汶战役后 {n} 年", "{n} ABY"],
    },
  },
};

const requested = (import.meta.env.VITE_WORK_PROFILE as string | undefined) ?? "bible";
export const PROFILE: WorkProfile = PROFILES[requested] ?? PROFILES.bible!;
