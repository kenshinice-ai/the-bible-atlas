import { createHash } from "node:crypto";
import { mkdir, readFile, writeFile } from "node:fs/promises";
import { request as httpsRequest } from "node:https";
import { join, resolve } from "node:path";
import pg from "pg";

/**
 * Import the first Gustave Doré batch for the Bible Atlas (track A2).
 *
 * Doré's 1866 Bible is the one image set that covers this atlas end to end in a
 * single hand: one artist, one technique, one date, and a rights position that
 * is not in doubt — he died in 1883, so the engravings are public domain
 * everywhere. That makes it possible to add depictions in batches without
 * relitigating rights per file.
 *
 * The importer is fail-closed. A file is only bundled when Commons reports an
 * explicitly public-domain licence, and every row carries the file page, the
 * original URL, the licence URL, the author, bilingual alt text, a retrieval
 * timestamp and a SHA-256 of the exact bytes written to disk.
 *
 * Editorial boundary, restated in every row: a nineteenth-century engraving is
 * evidence of how the story was pictured in 1866, not of what anyone looked
 * like. Every asset lands as `illustrative`.
 *
 * Two batches ship here. See NEW_TESTAMENT_BATCH for why the second one exists
 * and where it deliberately stops.
 *
 * Usage:
 *   DATABASE_URL=postgresql:///literary_atlas npx tsx scripts/import_bible_dore_media.ts hebrew-bible
 *   DATABASE_URL=postgresql:///literary_atlas npx tsx scripts/import_bible_dore_media.ts new-testament
 */
const ROOT = resolve(process.env.ATLAS_PROJECT_ROOT ?? process.cwd());
const DATABASE_URL = process.env.DATABASE_URL ?? "postgresql://llmacbookpro@localhost:5432/literary_atlas";
const WORK_ID = "10000000-0000-4000-8000-000000000005";
const API_URL = "https://commons.wikimedia.org/w/api.php";
const USER_AGENT = "LiteraryAtlas/3.1 bible-dore-import (contact: repository-maintainer)";
const MEDIA_DIR = join(ROOT, "apps/web/public/media/bible/dore");
const SEED_FILES: Record<string, string> = {
  "hebrew-bible": join(ROOT, "db/seeds/071_bible_dore_media.sql"),
  "new-testament": join(ROOT, "db/seeds/072_bible_dore_new_testament.sql"),
};
const RETRIEVED_AT = process.env.MEDIA_RETRIEVED_AT ?? "2026-08-18T00:00:00Z";
const PD_LICENSE_URL = "https://creativecommons.org/publicdomain/mark/1.0/";

type EntityKind = "character" | "event" | "location";

interface DoreItem {
  slug: string;
  kind: EntityKind;
  entity: string;
  file: string;
  altZh: string;
  altEn: string;
  titleZh: string;
  titleEn: string;
}

/** Curated batch one: Hebrew Bible narratives with an entity already in the atlas. */
const HEBREW_BIBLE_BATCH: readonly DoreItem[] = [
  { slug: "eve-created", kind: "character", entity: "eve", file: "002.The Creation of Eve.jpg", titleZh: "夏娃的受造", titleEn: "The Creation of Eve", altZh: "蜿蜒的枝叶与巨大的树干之间，一个女性身形自沉睡的男子身侧升起，上方云隙透下强光。", altEn: "Between coiling branches and huge trunks, a woman's form rises beside a sleeping man as strong light breaks through the cloud above." },
  { slug: "driven-out-of-eden", kind: "event", entity: "expulsion-from-eden", file: "003.Adam and Eve Are Driven out of Eden.jpg", titleZh: "亚当夏娃被逐出伊甸园", titleEn: "Adam and Eve Are Driven out of Eden", altZh: "两个人形俯身走出岩隙，身后是执剑的天使与茂密园林，前方是空旷荒野。", altEn: "Two figures stoop out through a cleft in the rock, an angel with a sword and dense garden behind them, open wilderness ahead." },
  { slug: "rebekah-at-the-well", kind: "character", entity: "rebekah", file: "018.Eliezer and Rebekah at the Well.jpg", titleZh: "以利以谢与利百加在井旁", titleEn: "Eliezer and Rebekah at the Well", altZh: "井边一名少女肩扛水瓶俯身递水，年长仆人俯首接饮，背景有骆驼与随行者。", altEn: "At a well, a young woman with a jar on her shoulder stoops to offer water; an older servant bows to drink, with camels and attendants behind." },
  { slug: "jacobs-dream", kind: "event", entity: "jacobs-dream-at-bethel", file: "021.Jacob's Dream.jpg", titleZh: "雅各的梦", titleEn: "Jacob's Dream", altZh: "一人卧于石上沉睡，上方一道光柱自云中垂下，众多带翼身形沿光阶上下。", altEn: "A man sleeps on a stone; a shaft of light falls from the clouds above him, with many winged figures ascending and descending it." },
  { slug: "jacob-wrestles", kind: "character", entity: "jacob", file: "024.Jacob Wrestles with the Angel.jpg", titleZh: "雅各与天使摔跤", titleEn: "Jacob Wrestles with the Angel", altZh: "暗夜岩地上，一人与带翼身形相抱角力，双方重心相持，背景是溪流与陡岸。", altEn: "On dark rocky ground, a man grapples with a winged figure, the two locked in balance, a stream and steep bank behind." },
  { slug: "joseph-reveals-himself", kind: "character", entity: "joseph-son-of-jacob", file: "028.Joseph Reveals Himself to His Brothers.jpg", titleZh: "约瑟与弟兄相认", titleEn: "Joseph Reveals Himself to His Brothers", altZh: "殿堂中一位盛装者张臂前倾，阶下数名旅装男子跪伏掩面，四周有随侍与柱廊。", altEn: "In a hall, a richly dressed man leans forward with open arms while several travel-worn men kneel and cover their faces below, among attendants and columns." },
  { slug: "giving-of-the-law", kind: "event", entity: "ten-commandments-given", file: "038.The Giving of the Law on Mount Sinai.jpg", titleZh: "西奈山颁布律法", titleEn: "The Giving of the Law on Mount Sinai", altZh: "山巅云雾翻涌雷光四射，一人跪于岩上仰面举手，山下人群远小如蚁。", altEn: "Cloud and lightning boil over a mountain summit; a man kneels on the rock with raised face and hands, the crowd far below reduced to specks." },
  { slug: "moses-comes-down", kind: "character", entity: "moses", file: "039.Moses Comes Down from Mount Sinai.jpg", titleZh: "摩西下西奈山", titleEn: "Moses Comes Down from Mount Sinai", altZh: "一位长者双手抱持两块石版立于山道，面容映着强光，下方人群仰望或掩面退避。", altEn: "An elder stands on the mountain path clasping two stone tablets, his face lit by a strong light, the crowd below looking up or shrinking away." },
  { slug: "crossing-the-jordan", kind: "event", entity: "crossing-the-jordan", file: "044. The Israelites Cross the Jordan River.jpg", titleZh: "以色列人过约旦河", titleEn: "The Israelites Cross the Jordan River", altZh: "大队人群与牲畜穿过干涸河床，两侧水墙高耸，中央数人抬着有杠的柜。", altEn: "A great column of people and livestock crosses a dry riverbed between towering walls of water, men in the middle carrying a poled chest." },
  { slug: "jael-kills-sisera", kind: "character", entity: "jael", file: "052.Jael Kills Sisera.jpg", titleZh: "雅亿杀西西拉", titleEn: "Jael Kills Sisera", altZh: "帐幕内一名女子俯身举锤，地上有一名沉睡的男子；画面以帐帘与暗影收束。", altEn: "Inside a tent, a woman stoops with a raised mallet over a sleeping man; the composition is closed in by tent hangings and deep shadow." },
  { slug: "gideon-chooses-three-hundred", kind: "character", entity: "gideon", file: "054.Gideon Chooses 300 Soldiers.jpg", titleZh: "基甸挑选三百人", titleEn: "Gideon Chooses 300 Soldiers", altZh: "溪边众多兵士俯身掬水或跪饮，一位披甲者立于高处指点分列。", altEn: "At a stream, many soldiers stoop to scoop water or kneel to drink while an armed figure stands above, pointing them into two groups." },
  { slug: "death-of-samson", kind: "character", entity: "samson", file: "064.The Death of Samson.jpg", titleZh: "参孙之死", titleEn: "The Death of Samson", altZh: "一名长发壮汉双臂抵住两根巨柱向内推，殿顶与人群随石块塌落。", altEn: "A long-haired man braces both arms against two great pillars and pushes inward as the roof and the crowd come down with the falling stone." },
  { slug: "ruth-and-boaz", kind: "character", entity: "ruth", file: "069.Ruth and Boaz.jpg", titleZh: "路得与波阿斯", titleEn: "Ruth and Boaz", altZh: "收割后的麦田里，一名女子抱着拾得的麦穗与一位年长男子交谈，远处有俯身的收割者。", altEn: "In a reaped field, a woman holding gleaned ears of grain speaks with an older man, stooping harvesters in the distance." },
  { slug: "david-slays-goliath", kind: "character", entity: "david", file: "071A.David Slays Goliath.jpg", titleZh: "大卫击杀歌利亚", titleEn: "David Slays Goliath", altZh: "一名少年立于倒地的巨人身上举剑，远处两军对峙的队列在山谷中展开。", altEn: "A youth stands over a fallen giant with a raised sword, the ranks of two armies drawn up across the valley behind." },
  { slug: "saul-and-the-witch-of-endor", kind: "character", entity: "saul", file: "075.Saul and the Witch of Endor.jpg", titleZh: "扫罗与隐多珥的女巫", titleEn: "Saul and the Witch of Endor", altZh: "昏暗室内，一名披甲者伏地退缩，一名老妇张臂而立，前方浮现一个发光的直立身形。", altEn: "In a dim room an armed man recoils to the floor while an old woman stands with outstretched arms before a glowing upright figure." },
  { slug: "judgment-of-solomon", kind: "character", entity: "solomon", file: "084.The Judgment of Solomon.jpg", titleZh: "所罗门的判断", titleEn: "The Judgment of Solomon", altZh: "宝座前一名兵士提剑抱起婴孩，一名女子扑跪伸手拦阻，另一名女子在旁旁观，王居高俯视。", altEn: "Before a throne a soldier lifts an infant with drawn sword; one woman throws herself down with outstretched hands to stop him while another looks on, the king watching from above." },
  { slug: "elijah-ascends", kind: "character", entity: "elijah", file: "095.Elijah Ascends to Heaven in a Chariot of Fire.jpg", titleZh: "以利亚乘火车升天", titleEn: "Elijah Ascends to Heaven in a Chariot of Fire", altZh: "烈焰与火马腾空，一位长者立于车上升起，衣袍飞扬，地上另一人仰面伸手呼喊。", altEn: "Flames and fiery horses surge upward; an elder rises standing in the chariot, robes streaming, while another man below reaches up and cries out." },
  { slug: "death-of-jezebel", kind: "character", entity: "jezebel", file: "097.The Death of Jezebel.jpg", titleZh: "耶洗别之死", titleEn: "The Death of Jezebel", altZh: "高窗之下一片混乱，宫墙外骑者与犬群聚集，窗口有人被推出。", altEn: "Below a high window there is confusion; riders and dogs gather outside the palace wall as a figure is thrust from the opening." },
  { slug: "rebuilding-the-temple", kind: "event", entity: "temple-foundation-laid", file: "105.The Rebuilding of the Temple Is Begun.jpg", titleZh: "重建圣殿动工", titleEn: "The Rebuilding of the Temple Is Begun", altZh: "巨石与脚手架之间众多工匠劳作，一侧长者掩面而泣，另一侧人群举手欢呼。", altEn: "Among great stones and scaffolding many workers labour; on one side elders weep with covered faces, on the other a crowd raises its hands in shouting." },
  { slug: "nehemiah-views-the-ruins", kind: "character", entity: "nehemiah", file: "108.Nehemiah Views the Ruins of Jerusalem's Walls.jpg", titleZh: "尼希米察看耶路撒冷城墙的废墟", titleEn: "Nehemiah Views the Ruins of Jerusalem's Walls", altZh: "月夜里一名骑者独自绕行倒塌的城墙，断石与焦门横陈，城郭轮廓隐没在暗处。", altEn: "By night a lone rider skirts the fallen city wall, broken stone and burnt gates strewn before him, the city outline lost in darkness." },
  { slug: "esther-before-the-king", kind: "character", entity: "esther", file: "115.Esther Before the King.jpg", titleZh: "以斯帖见王", titleEn: "Esther Before the King", altZh: "宫殿阶前一名盛装女子昏然后仰由侍女扶住，王自宝座起身伸出手中权杖。", altEn: "At the palace steps a richly dressed woman faints back into her attendants' arms as the king rises from the throne and holds out his scepter." },
  { slug: "prophet-isaiah", kind: "character", entity: "isaiah", file: "120.The Prophet Isaiah.jpg", titleZh: "先知以赛亚", titleEn: "The Prophet Isaiah", altZh: "一位长者半身像，须发浓密，手持展开的卷轴，目光上扬，背景为暗色帷幕。", altEn: "A half-length figure of a bearded elder holding an open scroll, gaze lifted, against a dark ground." },
  { slug: "prophet-jeremiah", kind: "character", entity: "jeremiah", file: "123.The Prophet Jeremiah.jpg", titleZh: "先知耶利米", titleEn: "The Prophet Jeremiah", altZh: "一位长者独坐于断石之间，双手支颐低头，身后是倾颓的城墙。", altEn: "An elder sits alone among broken stones, head bowed on his hands, a ruined city wall behind him." },
  { slug: "daniel-in-the-lions-den", kind: "character", entity: "daniel", file: "131.Daniel in the Lions' Den.jpg", titleZh: "但以理在狮子坑中", titleEn: "Daniel in the Lions' Den", altZh: "石砌深坑中一人合掌垂立，数头狮子伏卧环绕并未扑击，坑口有光落下。", altEn: "In a stone pit a man stands with hands joined while several lions lie about him without springing, light falling from the mouth of the pit." },
  { slug: "jonah-and-the-fish", kind: "character", entity: "jonah", file: "137.Jonah Is Spewed Forth by the Whale.jpg", titleZh: "鲸把约拿吐出", titleEn: "Jonah Is Spewed Forth by the Whale", altZh: "巨大的海兽张口伏于浪间的岸边，一人自口中被抛落沙滩，远处海面波涛翻涌。", altEn: "A huge sea creature lies open-mouthed at the surf line as a man is cast from its jaws onto the sand, heavy waves running behind." },
];

/**
 * Curated batch two: the New Testament, added on the clergy/design review's
 * recommendation and under its four conditions.
 *
 * The review's argument for including figural images of Jesus is worth keeping
 * next to the data: declining to draw him is not a neutral position but a
 * specific one. Nicaea II (787) affirmed that the incarnate Christ may be
 * depicted; Heidelberg Q98 and Westminster Larger Q109 forbid it. Both are
 * serious traditions. What is not defensible is inconsistency — this atlas
 * already carries Doré's Moses, Elijah and Daniel, and under the same reading
 * of the commandment those images stand or fall together. So the atlas hosts
 * the images and declines to adjudicate, while the emblem layer keeps Jesus a
 * monogram: identity stays aniconic, reception is shown as reception.
 *
 * Condition four is why this batch stops where it does. Nineteenth-century
 * Passion iconography routinely carried the antisemitic visual conventions of
 * its moment in how it staged the chief priests and the crowd. Those plates —
 * Gethsemane onward, plus the entry into Jerusalem, the supper, and Stephen's
 * stoning, which is the same crowd-as-accusers composition — are deliberately
 * excluded here and must be reviewed one by one as their own batch.
 */
const NEW_TESTAMENT_BATCH: readonly DoreItem[] = [
  // The obvious choice for this slot was Doré's Sermon on the Mount, but that
  // file carries no artist field on Commons and the rights gate refused it.
  // A depiction has to be attributable before it can be published, even when
  // everyone can see whose hand it is.
  { slug: "raising-of-jairus-daughter", kind: "character", entity: "jesus", file: "Gustave Dore - Jesus raises the daughter of Jairus from the dead.jpg", titleZh: "叫睚鲁的女儿起来", titleEn: "Jesus Raises the Daughter of Jairus",
    altZh: "室内床榻旁一人俯身握住少女的手，父母与随行者立于两侧惊看，光自窗侧落在床上。",
    altEn: "Beside an indoor bed a figure bends and takes a girl's hand while parents and companions stand watching in astonishment, light falling across the bed from a window." },
  { slug: "the-annunciation", kind: "character", entity: "mary", file: "Gustave Dore - The Annunciation.jpg", titleZh: "报喜", titleEn: "The Annunciation",
    altZh: "简朴室内一名女子自读经处起身侧转，带翼身形自光中降临，光自上方斜射入室。",
    altEn: "In a plain interior a woman turns from her reading as a winged figure descends in light that slants down into the room." },
  { slug: "the-birth-of-jesus", kind: "event", entity: "birth-of-jesus", file: "The Birth of Jesus.jpg", titleZh: "耶稣诞生", titleEn: "The Birth of Jesus",
    altZh: "马厩暗处，一对男女俯身围看草料上的婴孩，牲畜立于其后，光自婴孩处向四周散开。",
    altEn: "In the dark of a stable a man and a woman bend over an infant laid on straw, animals standing behind, the light spreading outward from the child." },
  { slug: "boy-jesus-in-the-temple", kind: "event", entity: "boy-jesus-in-the-temple", file: "Gustave Dore - Jesus converses with the learned ones in the Temple.jpg", titleZh: "少年耶稣在殿中", titleEn: "Jesus Converses with the Learned Ones in the Temple",
    altZh: "殿内石柱之间，一名少年站立说话，四周长者环坐持卷争论，有人俯身倾听。",
    altEn: "Among temple columns a boy stands speaking while elders sit around him with scrolls, disputing, some leaning in to listen." },
  { slug: "baptism-at-the-jordan", kind: "event", entity: "baptism-at-the-jordan", file: "Gustave Dore - John the Baptist baptizes Jesus.jpg", titleZh: "约旦河的洗礼", titleEn: "John the Baptist Baptizes Jesus",
    altZh: "河水中一人俯首而立，岸边披毛衣者以手倾水其上，上方云开，众人于岸边观看。",
    altEn: "One figure stands bowed in the river while a man in rough skins pours water over him from the bank; the cloud opens above and onlookers watch from the shore." },
  { slug: "john-preaching-in-the-wilderness", kind: "character", entity: "john-the-baptist", file: "DoreJohntheBaptistPreachingintheWilderness.jpg", titleZh: "施洗约翰在旷野传道", titleEn: "John the Baptist Preaching in the Wilderness",
    altZh: "荒石高处一名披毛衣者振臂疾呼，坡下人群仰面拥挤，天光自云隙压下。",
    altEn: "On rough high ground a man in skins throws out his arm and cries out; the crowd presses upward below as light breaks through the cloud." },
  { slug: "first-sign-at-cana", kind: "event", entity: "first-sign-at-cana", file: "Marriage at Cana engraving by Gustave Doré.jpg", titleZh: "迦拿的婚筵", titleEn: "The Marriage at Cana",
    altZh: "宴席长桌旁宾客环坐，前景仆人自大石缸中舀取，一人抬手示意，帷幕与柱廊在后。",
    altEn: "Guests sit around a long banquet table; in the foreground servants draw from large stone jars as one figure raises a hand, curtains and columns behind." },
  { slug: "conversation-at-jacobs-well", kind: "event", entity: "conversation-at-jacobs-well", file: "Jesus asks the Samaritan woman for a draft from the well.jpg", titleZh: "雅各井旁的谈话", titleEn: "Jesus and the Samaritan Woman at the Well",
    altZh: "野外井台边一人坐于井沿，一名持罐女子立而应答，远处丘陵与城郭。",
    altEn: "At an open-air wellhead one figure sits on the rim while a woman with a jar stands answering, hills and a town in the distance." },
  { slug: "feeding-of-the-five-thousand", kind: "event", entity: "feeding-of-the-five-thousand", file: "JesusFeedingMultitude.jpg", titleZh: "五饼二鱼", titleEn: "Feeding the Multitude",
    altZh: "开阔坡地上人群密密散坐，中央一人举手祝谢，门徒提篮向四方分发。",
    altEn: "A crowd sits scattered across open ground; at the centre a figure raises a hand in blessing while disciples carry baskets outward." },
  { slug: "transfiguration-on-tabor", kind: "event", entity: "transfiguration-on-tabor", file: "Gustave Dore - The Transfiguration.jpg", titleZh: "他泊山的变像", titleEn: "The Transfiguration",
    altZh: "山顶强光中一人衣白升立，两侧各有一身形相对，坡下三人伏地掩面。",
    altEn: "On a summit a figure stands raised in white light with a form on either side, while three men below fall to the ground and cover their faces." },
  { slug: "ascension-from-the-mount-of-olives", kind: "event", entity: "ascension-from-the-mount-of-olives", file: "Gusta Dore - The Ascension.jpg", titleZh: "自橄榄山升天", titleEn: "The Ascension",
    altZh: "云层裂开处一人升起衣袍飞扬，地上众人仰面举手，山坡与远城在下。",
    altEn: "A figure rises where the cloud parts, robes streaming, while those on the ground look up with raised hands above a hillside and distant city." },
  { slug: "peter-freed-from-prison", kind: "event", entity: "peter-imprisoned-and-freed-by-angel", file: "Peter'sEscapefromPrison.jpg", titleZh: "彼得越狱", titleEn: "Peter's Escape from Prison",
    altZh: "牢房石阶间，一名发光身形引路在前，一人随行，锁链垂落，守卫伏睡未醒。",
    altEn: "On prison stairs a luminous figure leads the way with a man following, chains hanging loose and the guards asleep." },
  { slug: "paul-in-prison", kind: "character", entity: "paul", file: "St Paul in prison.jpg", titleZh: "监中的保罗", titleEn: "St Paul in Prison",
    altZh: "石室内一名长者伏案书写，脚上有镣，光自高窗斜落纸面。",
    altEn: "In a stone cell an elder bends over a table writing, irons on his feet, light from a high window falling across the page." },
  { slug: "calming-the-tempest", kind: "location", entity: "sea-of-galilee", file: "JesusCalmingtheTempestDore.jpg", titleZh: "平静风浪", titleEn: "Jesus Calming the Tempest",
    altZh: "小舟在陡立的浪峰间倾侧，船上数人惊惶伏抱，一人立于船尾伸手向海。",
    altEn: "A small boat heels between steep wave crests; several men cling to it in alarm while one stands at the stern with a hand stretched toward the sea." },
];

const q = (value: string): string => `'${value.replace(/'/gu, "''")}'`;
const stableUuid = (seed: string): string => {
  const hex = createHash("md5").update(seed).digest("hex");
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-4${hex.slice(13, 16)}-8${hex.slice(17, 20)}-${hex.slice(20, 32)}`;
};
const sleep = (ms: number): Promise<void> => new Promise((done) => setTimeout(done, ms));

/** Commons decorates its URLs with campaign tracking; store the clean file URL. */
const cleanUrl = (url: string): string => {
  const parsed = new URL(url);
  parsed.search = "";
  return parsed.toString();
};

interface ExtMetadata { [key: string]: { value: string } | undefined }

/**
 * One request. Uses node:https rather than global fetch because undici's
 * connection setup times out against Wikimedia's hosts on this network while a
 * plain IPv4 HTTPS request succeeds; the batch is not worth losing to that.
 */
function httpsGet(url: string, depth = 0): Promise<{ status: number; body: Buffer }> {
  return new Promise((settle, reject) => {
    if (depth > 4) { reject(new Error(`too many redirects for ${url}`)); return; }
    const target = new URL(url);
    const request = httpsRequest({
      host: target.host, path: `${target.pathname}${target.search}`, family: 4, timeout: 45000,
      // Wikimedia's edge is markedly happier with an explicit, uncompressed,
      // non-keep-alive request than with the defaults; without these headers
      // the same URLs stall or answer 429.
      headers: { "user-agent": USER_AGENT, accept: "*/*", "accept-encoding": "identity", connection: "close" },
    }, (response) => {
      const status = response.statusCode ?? 0;
      const location = response.headers.location;
      if (status >= 300 && status < 400 && location) {
        response.resume();
        httpsGet(new URL(location, url).toString(), depth + 1).then(settle, reject);
        return;
      }
      const chunks: Buffer[] = [];
      response.on("data", (chunk: Buffer) => chunks.push(chunk));
      response.on("end", () => settle({ status, body: Buffer.concat(chunks) }));
      response.on("error", reject);
    });
    request.on("timeout", () => { request.destroy(new Error("request timed out")); });
    request.on("error", reject);
    request.end();
  });
}

/** Commons throttles bursts; back off rather than dropping items from a batch. */
async function politeFetch(url: string | URL, what: string): Promise<Buffer> {
  for (let attempt = 1; attempt <= 8; attempt += 1) {
    const wait = Math.min(120000, 6000 * 2 ** (attempt - 1));
    let result: { status: number; body: Buffer };
    try {
      result = await httpsGet(url.toString());
    } catch (error) {
      // A dropped connection mid-batch is throttling by another name; treat it
      // like a 429 rather than losing the items already downloaded.
      console.log(`  ${what} -> ${error instanceof Error ? error.message : "network error"}; retrying in ${wait / 1000}s`);
      await new Promise((done) => setTimeout(done, wait));
      continue;
    }
    if (result.status >= 200 && result.status < 300) return result.body;
    if (result.status !== 429 && result.status < 500) throw new Error(`${what} returned HTTP ${result.status}`);
    console.log(`  ${what} -> HTTP ${result.status}; retrying in ${wait / 1000}s`);
    await new Promise((done) => setTimeout(done, wait));
  }
  throw new Error(`${what} kept failing after 8 attempts`);
}

async function commonsInfo(file: string): Promise<{ thumbUrl: string; originalUrl: string; descriptionUrl: string; licence: string; author: string }> {
  const url = new URL(API_URL);
  url.searchParams.set("action", "query");
  url.searchParams.set("format", "json");
  url.searchParams.set("titles", `File:${file}`);
  url.searchParams.set("prop", "imageinfo");
  url.searchParams.set("iiprop", "url|extmetadata");
  url.searchParams.set("iiurlwidth", "960");
  const payload = JSON.parse((await politeFetch(url, `Commons API for ${file}`)).toString("utf8")) as {
    query?: { pages?: Record<string, { missing?: string; imageinfo?: { thumburl?: string; url?: string; descriptionurl?: string; extmetadata?: ExtMetadata }[] }> };
  };
  const page = Object.values(payload.query?.pages ?? {})[0];
  if (!page || page.missing !== undefined) throw new Error(`Commons has no file page for ${file}`);
  const info = page.imageinfo?.[0];
  if (!info?.thumburl || !info.url || !info.descriptionurl) throw new Error(`${file} has no usable image info`);
  const metadata = info.extmetadata ?? {};
  const licence = metadata.LicenseShortName?.value ?? "";
  if (!/^public domain$/iu.test(licence.trim())) throw new Error(`${file} is not explicitly public domain (licence: ${licence || "none"})`);
  const rawArtist = metadata.Artist?.value ?? "";
  const author = /Gustave Dor/iu.test(rawArtist) ? "Gustave Doré" : "";
  if (!author) throw new Error(`${file} is not attributed to Gustave Doré (artist field: ${rawArtist.slice(0, 80)})`);
  return { thumbUrl: info.thumburl, originalUrl: cleanUrl(info.url), descriptionUrl: info.descriptionurl, licence: "Public domain", author };
}

async function main(): Promise<void> {
  const pool = new pg.Pool({ connectionString: DATABASE_URL });
  try {
    const batchName = process.argv[2] ?? "hebrew-bible";
    const batch = batchName === "new-testament" ? NEW_TESTAMENT_BATCH : HEBREW_BIBLE_BATCH;
    const outSeed = SEED_FILES[batchName];
    if (!outSeed) throw new Error(`unknown batch ${batchName}; expected hebrew-bible or new-testament`);

    const characters = await pool.query<{ slug: string }>(`SELECT slug FROM characters WHERE work_id=$1`, [WORK_ID]);
    const events = await pool.query<{ slug: string }>(`SELECT slug FROM events WHERE work_id=$1`, [WORK_ID]);
    const locations = await pool.query<{ slug: string }>(`SELECT slug FROM locations WHERE work_id=$1`, [WORK_ID]);
    const known: Record<EntityKind, Set<string>> = {
      character: new Set(characters.rows.map((row) => row.slug)),
      event: new Set(events.rows.map((row) => row.slug)),
      location: new Set(locations.rows.map((row) => row.slug)),
    };

    await mkdir(MEDIA_DIR, { recursive: true });
    const statements: string[] = [
      "BEGIN;", "",
      `-- Bible depiction batch: Gustave Doré, 1866 (${batchName}).`,
      "-- Generated by scripts/import_bible_dore_media.ts. Every asset is a",
      "-- nineteenth-century artistic depiction, never a historical portrait or an",
      "-- eyewitness record, and is stored as `illustrative` to say so in the data.",
      "",
    ];
    let bundled = 0;

    for (const item of batch) {
      if (!known[item.kind].has(item.entity)) throw new Error(`${item.slug}: unknown ${item.kind} ${item.entity}`);
      const info = await commonsInfo(item.file);
      const filename = `${item.slug}.jpg`;
      // Resume support: Wikimedia throttles hard enough that a batch this size
      // rarely completes in one pass, and re-downloading what is already on
      // disk is both slower and ruder than reusing it.
      const existing = await readFile(join(MEDIA_DIR, filename)).catch(() => null);
      const bytes = existing && existing.length >= 4096
        ? existing
        : await politeFetch(info.thumbUrl, `${item.file} thumbnail`);
      if (bytes.length < 4096) throw new Error(`${item.file} thumbnail is implausibly small (${bytes.length} bytes)`);
      if (!existing) await writeFile(join(MEDIA_DIR, filename), bytes);
      const checksum = createHash("sha256").update(bytes).digest("hex");
      const assetUrl = `/media/bible/dore/${filename}`;
      const sourceId = stableUuid(`source:commons:bible:dore:${item.slug}`);
      const mediaId = stableUuid(`media:commons:bible:dore:${item.slug}`);
      const attribution = `Gustave Doré / Wikimedia Commons / Public domain`;
      const citationZh = `作者：Gustave Doré（1866）；许可：Public domain；人物与场景为艺术性诠释，不是历史肖像或现场记录；图片文件页：${info.descriptionUrl}`;
      const citationEn = `Author: Gustave Doré (1866); licence: Public domain; the image is an artistic depiction, not a historical portrait or eyewitness record; file page: ${info.descriptionUrl}`;
      const role = item.kind === "character" ? "character_depiction" : "event_scene";
      const linkTable = item.kind === "character" ? "characters" : item.kind === "event" ? "events" : "locations";

      statements.push(
        `INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type) VALUES`,
        `  ('${sourceId}','${WORK_ID}',${q(`Wikimedia Commons: ${item.titleEn}`)},${q(info.descriptionUrl)},${q(citationEn)},'reference','image')`,
        `ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,url=EXCLUDED.url,citation=EXCLUDED.citation,evidence_grade=EXCLUDED.evidence_grade,source_type=EXCLUDED.source_type;`,
        `INSERT INTO source_translations(source_id,locale,title,citation,status) VALUES`,
        `  ('${sourceId}','zh-CN',${q(`Wikimedia Commons：${item.titleZh}`)},${q(citationZh)},'published'),`,
        `  ('${sourceId}','en',${q(`Wikimedia Commons: ${item.titleEn}`)},${q(citationEn)},'published')`,
        `ON CONFLICT (source_id,locale) DO UPDATE SET title=EXCLUDED.title,citation=EXCLUDED.citation,status=EXCLUDED.status;`,
        `INSERT INTO media_assets(id,source_id,asset_source,asset_licence,asset_author,asset_url,attribution_text,alt_text_zh,alt_text_en,media_kind,usage_mode,license_status,license_url,source_page_url,original_url,retrieved_at,checksum_sha256,media_role,depiction_status) VALUES`,
        `  ('${mediaId}','${sourceId}','Wikimedia Commons','Public domain',${q(info.author)},${q(assetUrl)},${q(attribution)},${q(item.altZh)},${q(item.altEn)},'image','bundled','verified',${q(PD_LICENSE_URL)},${q(info.descriptionUrl)},${q(info.originalUrl)},'${RETRIEVED_AT}'::timestamptz,${q(checksum)},'${role}','illustrative')`,
        `ON CONFLICT (id) DO UPDATE SET source_id=EXCLUDED.source_id,asset_source=EXCLUDED.asset_source,asset_licence=EXCLUDED.asset_licence,asset_author=EXCLUDED.asset_author,asset_url=EXCLUDED.asset_url,attribution_text=EXCLUDED.attribution_text,alt_text_zh=EXCLUDED.alt_text_zh,alt_text_en=EXCLUDED.alt_text_en,media_kind=EXCLUDED.media_kind,usage_mode=EXCLUDED.usage_mode,license_status=EXCLUDED.license_status,license_url=EXCLUDED.license_url,source_page_url=EXCLUDED.source_page_url,original_url=EXCLUDED.original_url,retrieved_at=EXCLUDED.retrieved_at,checksum_sha256=EXCLUDED.checksum_sha256,media_role=EXCLUDED.media_role,depiction_status=EXCLUDED.depiction_status;`,
        `INSERT INTO media_links(media_id,entity_kind,entity_id,sort_order)`,
        `SELECT '${mediaId}','${item.kind}',x.id,${bundled + 1} FROM ${linkTable} x WHERE x.work_id='${WORK_ID}' AND x.slug=${q(item.entity)}`,
        `ON CONFLICT DO NOTHING;`,
        "",
      );
      bundled += 1;
      console.log(`  ${item.slug}: ${bytes.length} bytes, ${checksum.slice(0, 12)}…${existing ? " (already on disk)" : ""}`);
      await sleep(existing ? 250 : 15000);
    }

    statements.push("COMMIT;");
    await writeFile(outSeed, `${statements.join("\n")}\n`, "utf8");
    console.log(`Doré ${batchName}: ${bundled} public-domain engravings bundled under /media/bible/dore/`);
  } finally {
    await pool.end();
  }
}

main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : error);
  process.exitCode = 1;
});
