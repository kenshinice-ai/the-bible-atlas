/**
 * Scripture epigraphs for the Bible Atlas, transcribed verbatim from
 * docs/design/sacred-rebrand-plan.md (section 2). Chinese: Union Version
 * (和合本, 1919); English: King James Version. Both public domain.
 * "(节选)" / "(excerpt)" marks a shortened quotation.
 *
 * Text conventions (audited 2026-07, see docs/CLERGY_AUDIT.md):
 * - Chinese follows the Shen (「神」) edition wording with modern punctuation
 *   (新标点和合本 conventions, e.g. 不致/哪里); the traditional full-width
 *   space before 神 is not reproduced in UI copy.
 * - Standalone quotations end with terminal punctuation even where the
 *   KJV verse ends mid-sentence (e.g. Gen 12:2 ":"); wording is untouched.
 */

export interface Epigraph {
  zh: string;
  zhRef: string;
  en: string;
  enRef: string;
}

/** One epigraph per Bible era, keyed by chapter slug. */
export const ERA_EPIGRAPHS: Record<string, Epigraph> = {
  "primeval": {
    zh: "起初,神创造天地。",
    zhRef: "创世记 1:1",
    en: "In the beginning God created the heaven and the earth.",
    enRef: "Genesis 1:1",
  },
  "patriarchs": {
    zh: "我必叫你成为大国。我必赐福给你,叫你的名为大;你也要叫别人得福。",
    zhRef: "创世记 12:2",
    en: "And I will make of thee a great nation, and I will bless thee, and make thy name great; and thou shalt be a blessing.",
    enRef: "Genesis 12:2",
  },
  "exodus-and-sinai": {
    zh: "我向埃及人所行的事,你们都看见了,且看见我如鹰将你们背在翅膀上,带来归我。",
    zhRef: "出埃及记 19:4",
    en: "Ye have seen what I did unto the Egyptians, and how I bare you on eagles' wings, and brought you unto myself.",
    enRef: "Exodus 19:4",
  },
  "wilderness-and-conquest": {
    zh: "你当刚强壮胆!不要惧怕,也不要惊惶;因为你无论往哪里去,耶和华你的神必与你同在。(节选)",
    zhRef: "约书亚记 1:9",
    en: "Be strong and of a good courage; be not afraid, neither be thou dismayed: for the LORD thy God is with thee whithersoever thou goest. (excerpt)",
    enRef: "Joshua 1:9",
  },
  "judges": {
    zh: "那时,以色列中没有王,各人任意而行。",
    zhRef: "士师记 21:25",
    en: "In those days there was no king in Israel: every man did that which was right in his own eyes.",
    enRef: "Judges 21:25",
  },
  "united-monarchy": {
    zh: "你的家和你的国必在我面前永远坚立。你的国位也必坚定,直到永远。",
    zhRef: "撒母耳记下 7:16",
    en: "And thine house and thy kingdom shall be established for ever before thee: thy throne shall be established for ever.",
    enRef: "2 Samuel 7:16",
  },
  "divided-kingdoms": {
    zh: "你们心持两意要到几时呢?若耶和华是神,就当顺从耶和华;若巴力是神,就当顺从巴力。(节选)",
    zhRef: "列王纪上 18:21",
    en: "How long halt ye between two opinions? if the LORD be God, follow him: but if Baal, then follow him. (excerpt)",
    enRef: "1 Kings 18:21",
  },
  "prophetic-narrative": {
    zh: "何况这尼尼微大城,其中不能分辨左手右手的有十二万多人,并有许多牲畜,我岂能不爱惜呢?",
    zhRef: "约拿书 4:11",
    en: "And should not I spare Nineveh, that great city, wherein are more than sixscore thousand persons that cannot discern between their right hand and their left hand; and also much cattle?",
    enRef: "Jonah 4:11",
  },
  "judah-and-exile": {
    zh: "我们不致消灭,是出于耶和华诸般的慈爱;是因他的怜悯不致断绝。每早晨,这都是新的;你的诚实极其广大!",
    zhRef: "耶利米哀歌 3:22–23",
    en: "It is of the LORD's mercies that we are not consumed, because his compassions fail not. They are new every morning: great is thy faithfulness.",
    enRef: "Lamentations 3:22–23",
  },
  "return-and-restoration": {
    zh: "当耶和华将那些被掳的带回锡安的时候,我们好像做梦的人。",
    zhRef: "诗篇 126:1",
    en: "When the LORD turned again the captivity of Zion, we were like them that dream.",
    enRef: "Psalm 126:1",
  },
  "gospels": {
    zh: "我报给你们大喜的信息,是关乎万民的;因今天在大卫的城里,为你们生了救主,就是主基督。(节选)",
    zhRef: "路加福音 2:10–11",
    en: "I bring you good tidings of great joy, which shall be to all people. For unto you is born this day in the city of David a Saviour, which is Christ the Lord. (excerpt)",
    enRef: "Luke 2:10–11",
  },
  "acts": {
    zh: "但圣灵降临在你们身上,你们就必得着能力,并要在耶路撒冷、犹太全地,和撒玛利亚,直到地极,作我的见证。",
    zhRef: "使徒行传 1:8",
    en: "But ye shall receive power, after that the Holy Ghost is come upon you: and ye shall be witnesses unto me both in Jerusalem, and in all Judaea, and in Samaria, and unto the uttermost part of the earth.",
    enRef: "Acts 1:8",
  },
  "pauline-mission": {
    zh: "那美好的仗我已经打过了,当跑的路我已经跑尽了,所信的道我已经守住了。",
    zhRef: "提摩太后书 4:7",
    en: "I have fought a good fight, I have finished my course, I have kept the faith.",
    enRef: "2 Timothy 4:7",
  },
};

/** Shown in the hero area while no era is selected (Psalm 119:18). */
export const WELCOME_EPIGRAPH: Epigraph = {
  zh: "求你开我的眼睛,使我看出你律法中的奇妙。",
  zhRef: "诗篇 119:18",
  en: "Open thou mine eyes, that I may behold wondrous things out of thy law.",
  enRef: "Psalm 119:18",
};

/** Rotated on the loading skeleton. */
export const LOADING_EPIGRAPHS: readonly Epigraph[] = [
  {
    zh: "你的话是我脚前的灯,是我路上的光。",
    zhRef: "诗篇 119:105",
    en: "Thy word is a lamp unto my feet, and a light unto my path.",
    enRef: "Psalm 119:105",
  },
  {
    zh: "你的言语一解开就发出亮光。(节选)",
    zhRef: "诗篇 119:130",
    en: "The entrance of thy words giveth light. (excerpt)",
    enRef: "Psalm 119:130",
  },
  {
    zh: "我的心哪,你当默默无声,专等候神。(节选)",
    zhRef: "诗篇 62:5",
    en: "My soul, wait thou only upon God. (excerpt)",
    enRef: "Psalm 62:5",
  },
];

/** Site-wide footer verse (Isaiah 40:8). */
export const FOOTER_EPIGRAPH: Epigraph = {
  zh: "草必枯干,花必凋残,惟有我们神的话必永远立定。",
  zhRef: "以赛亚书 40:8",
  en: "The grass withereth, the flower fadeth: but the word of our God shall stand for ever.",
  enRef: "Isaiah 40:8",
};
