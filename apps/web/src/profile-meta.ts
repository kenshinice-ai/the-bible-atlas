/**
 * The static shell's per-profile metadata: everything a crawler, a link
 * unfurler or a browser tab sees before React runs.
 *
 * This lives apart from profile.ts because it is consumed at *build* time by
 * vite.config.ts, which runs in Node and cannot evaluate `import.meta.env`.
 * Keep this file free of imports so the Vite config can pull it in cheaply.
 *
 * Until this existed, index.html was hard-coded with one atlas's copy and
 * every other profile shipped it: the live Three Kingdoms build served the
 * Bible's description and social card. The keys here must match PROFILES in
 * profile.ts exactly — profile.test.ts asserts it.
 */

export interface ProfileMeta {
  /** <html lang>. Matches the profile's default locale. */
  lang: string;
  /** <title> and og:title. Rendered before React sets document.title. */
  title: string;
  description: string;
  ogDescription: string;
  /** Browser chrome colour; should match the profile's --bg token. */
  themeColor: string;
}

export const PROFILE_META: Record<string, ProfileMeta> = {
  bible: {
    lang: "en",
    title: "圣经舆图 · The Bible Atlas",
    description:
      "圣经舆图——圣经的时空全景:十三个时代、二百余位人物、四百余件事件与一百余处地点,依经文记载绘于一图,中英双语。The Bible Atlas: a bilingual atlas of the Scriptures — every era, person, event and place, mapped in time and space.",
    ogDescription: "从起初,直到地极——圣经的时空全景。From the Beginning to the Ends of the Earth.",
    themeColor: "#0B1120",
  },
  "three-kingdoms": {
    lang: "zh-CN",
    title: "三国舆图 · The Three Kingdoms Atlas",
    description:
      "三国舆图——《三国志》与《三国演义》的时空全景:十三个时代双线对照,正史与演义同图并陈,中英双语。The Three Kingdoms Atlas: Chen Shou's Records and Luo Guanzhong's Romance mapped side by side across thirteen eras.",
    ogDescription: "是非成败,俱付笑谈。History and Romance, Mapped Side by Side.",
    themeColor: "#120D0B",
  },
  // The description's closing sentence is landing point 1 of 2 for the
  // trademark disclaimer (blueprint/star-wars/IP_AND_NAMING.md §1.3); landing
  // point 2 is the footer note in epigraphs.ts. Neither may be dropped.
  galaxy: {
    lang: "en",
    title: "银河原力舆图 · The Galactic Force Atlas",
    description:
      "银河原力舆图——向原著影片致敬而作的非官方检索图集,十二个时代、四十余座星球与航线、天行者家族谱系,依银河纪年绘于一图,中英双语。全站不作任何商业用途:无广告、不收费、不接受打赏,亦不能替代观影。与 Lucasfilm Ltd.、The Walt Disney Company 无隶属、授权或背书关系,相关名称与标志归各自权利人所有。A tribute-made, unofficial, strictly non-commercial reference atlas to the Skywalker saga — no advertising, no fees, no donations, and no substitute for watching the films. Not affiliated with, sponsored, or endorsed by Lucasfilm Ltd. or The Walt Disney Company; all names and marks belong to their respective owners.",
    ogDescription:
      "向原著致敬的非官方检索图集,不作任何商业用途。A tribute-made, unofficial and non-commercial reference to the Skywalker saga — not affiliated with or endorsed by Lucasfilm Ltd.",
    themeColor: "#05070F",
  },
  "european-art-history": {
    lang: "zh-CN",
    title: "欧洲美术史 Atlas · European Art History Atlas",
    description: "欧洲美术史 Atlas——按时代连接艺术家、作品、流派、机构与真实地点，首版聚焦古典时代至 1945 年，提供中英双语结构化资料。European Art History Atlas: artists, artworks, movements, institutions and real places across eras, focused on the period through 1945.",
    ogDescription: "按时代连接艺术家、作品与地点。Artists, artworks and places across time.",
    themeColor: "#17120D",
  },
};
