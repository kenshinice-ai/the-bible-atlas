import type { Locale } from "./types";

export type ProfileTab = "characters" | "artists" | "artworks" | "movements" | "compositions" | "instruments" | "scoreFragments" | "events" | "locations" | "routes" | "relations";
export type ProfileZoomLevel = "era" | "group" | "major" | "all";

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
  specialization: "base" | "art" | "music";
  tabs: readonly ProfileTab[];
  defaultTab: ProfileTab;
  graphLevels: readonly ProfileZoomLevel[];
  defaultGraphLevel: ProfileZoomLevel;
  canonicalArtistPeople?: boolean;
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
    specialization: "base", tabs: ["characters", "events", "locations", "routes", "relations"], defaultTab: "events",
    graphLevels: ["era", "group", "major", "all"], defaultGraphLevel: "group",
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
    specialization: "base", tabs: ["characters", "events", "locations", "routes", "relations"], defaultTab: "events",
    graphLevels: ["era", "group", "major", "all"], defaultGraphLevel: "group",
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
    specialization: "base", tabs: ["characters", "events", "locations", "routes", "relations"], defaultTab: "events",
    graphLevels: ["era", "group", "major", "all"], defaultGraphLevel: "group",
    // Years are counted from the battle of Yavin: BBY before, ABY after. There
    // is no year zero, matching the BCE/CE convention the database already
    // enforces, so 0 BBY maps to -1 and 0 ABY to +1.
    yearLabels: {
      negative: ["雅汶战役前 {n} 年", "{n} BBY"],
      positive: ["雅汶战役后 {n} 年", "{n} ABY"],
    },
  },
  "european-art-history": {
    id: "european-art-history",
    works: ["european-art-history"],
    active: "european-art-history",
    mode: "single",
    defaultLocale: "zh-CN",
    title: ["欧洲美术史 Atlas", "European Art History Atlas"],
    tagline: ["按时代连接艺术家、作品与地点", "Artists, artworks and places across time"],
    theme: "european-art-history",
    specialization: "art", tabs: ["characters", "artworks", "movements", "events", "locations", "routes", "relations"], defaultTab: "events",
    graphLevels: ["major", "all"], defaultGraphLevel: "all", canonicalArtistPeople: true,
  },
  "european-classical-music-history": {
    id: "european-classical-music-history",
    works: ["european-classical-music-history"],
    active: "european-classical-music-history",
    mode: "single",
    defaultLocale: "zh-CN",
    title: ["欧洲古典音乐史 Atlas", "European Classical Music History Atlas"],
    tagline: ["聆听时代，连接人物、曲目与乐器", "Hear the eras through people, works and instruments"],
    theme: "european-classical-music-history",
    specialization: "music", tabs: ["characters", "compositions", "scoreFragments", "events", "relations"], defaultTab: "events",
    graphLevels: ["era", "group", "major", "all"], defaultGraphLevel: "group",
  },
};

const requested = (import.meta.env.VITE_WORK_PROFILE as string | undefined) ?? "bible";
export const PROFILE: WorkProfile = PROFILES[requested] ?? PROFILES.bible!;
