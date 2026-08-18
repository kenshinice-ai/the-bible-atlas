/**
 * Curated editorial data for the Bible art/music upgrade
 * (docs/BIBLE_ART_MUSIC_UPGRADE_PLAN_2026-08-18.md).
 *
 * This module holds decisions, not derived values: which traditional symbol
 * stands for which person, which verses a narrative event rests on, which
 * public-domain excerpt a person is remembered for, and which existing
 * composition sets which passage. Every checksum, every SQL statement and every
 * verse verification is computed by scripts/generate_bible_art_music.ts.
 */

export const BIBLE_WORK_ID = "10000000-0000-4000-8000-000000000005";
export const MUSIC_WORK_ID = "10000000-0000-4000-8000-000000000010";

/** OSIS book id -> the book id used by the public-domain verse API. */
export const OSIS_TO_API: Record<string, string> = {
  Gen: "GEN", Exod: "EXO", Lev: "LEV", Num: "NUM", Deut: "DEU",
  Josh: "JOS", Judg: "JDG", Ruth: "RUT", "1Sam": "1SA", "2Sam": "2SA",
  "1Kgs": "1KI", "2Kgs": "2KI", "1Chr": "1CH", "2Chr": "2CH", Ezra: "EZR",
  Neh: "NEH", Esth: "EST", Job: "JOB", Ps: "PSA", Prov: "PRO",
  Isa: "ISA", Jer: "JER", Ezek: "EZK", Dan: "DAN", Hos: "HOS",
  Amos: "AMO", Jonah: "JON", Mic: "MIC", Zech: "ZEC", Mal: "MAL",
  Matt: "MAT", Mark: "MRK", Luke: "LUK", John: "JHN", Acts: "ACT",
  Rom: "ROM", "1Cor": "1CO", "2Cor": "2CO", Gal: "GAL", Eph: "EPH",
  Phil: "PHP", "1Thess": "1TH", "1Tim": "1TI", "2Tim": "2TI", Heb: "HEB",
  Jas: "JAS", "1Pet": "1PE", "1John": "1JN", Rev: "REV",
};

/** Bilingual book names for the reference label shown next to a quote. */
export const BOOK_NAMES: Record<string, { zh: string; en: string }> = {
  Gen: { zh: "创世记", en: "Genesis" },
  Exod: { zh: "出埃及记", en: "Exodus" },
  Num: { zh: "民数记", en: "Numbers" },
  Deut: { zh: "申命记", en: "Deuteronomy" },
  Josh: { zh: "约书亚记", en: "Joshua" },
  Judg: { zh: "士师记", en: "Judges" },
  Ruth: { zh: "路得记", en: "Ruth" },
  "1Sam": { zh: "撒母耳记上", en: "1 Samuel" },
  "2Sam": { zh: "撒母耳记下", en: "2 Samuel" },
  "1Kgs": { zh: "列王纪上", en: "1 Kings" },
  "2Kgs": { zh: "列王纪下", en: "2 Kings" },
  Ezra: { zh: "以斯拉记", en: "Ezra" },
  Neh: { zh: "尼希米记", en: "Nehemiah" },
  Esth: { zh: "以斯帖记", en: "Esther" },
  Ps: { zh: "诗篇", en: "Psalms" },
  Isa: { zh: "以赛亚书", en: "Isaiah" },
  Jer: { zh: "耶利米书", en: "Jeremiah" },
  Dan: { zh: "但以理书", en: "Daniel" },
  Amos: { zh: "阿摩司书", en: "Amos" },
  Jonah: { zh: "约拿书", en: "Jonah" },
  Matt: { zh: "马太福音", en: "Matthew" },
  Mark: { zh: "马可福音", en: "Mark" },
  Luke: { zh: "路加福音", en: "Luke" },
  John: { zh: "约翰福音", en: "John" },
  Acts: { zh: "使徒行传", en: "Acts" },
  "1Cor": { zh: "哥林多前书", en: "1 Corinthians" },
  Gal: { zh: "加拉太书", en: "Galatians" },
  "2Tim": { zh: "提摩太后书", en: "2 Timothy" },
};

// ---------------------------------------------------------------------------
// A1 · Character emblems
// ---------------------------------------------------------------------------

export type Attestation = "scriptural" | "liturgical" | "iconographic";
export type RingKey = "plain" | "braided" | "rayed" | "thorned" | "waved" | "chained";
export type GroundKey = "era" | "gold" | "ink" | "vellum" | "sky";

export interface CharacterEmblem {
  character: string;
  symbol: string;
  ring: RingKey;
  ground: GroundKey;
  attestation: Attestation;
  nameZh: string;
  nameEn: string;
  meaningZh: string;
  meaningEn: string;
  noteZh: string;
  noteEn: string;
}

/**
 * Forty curated emblems. Rule followed throughout: the symbol must already be
 * attached to the person by the text or by a long tradition — no symbol is
 * invented here, and none of them claims to show what anyone looked like.
 */
export const CHARACTER_EMBLEMS: readonly CharacterEmblem[] = [
  {
    character: "abraham", symbol: "starfield", ring: "rayed", ground: "sky", attestation: "scriptural",
    nameZh: "众星", nameEn: "Field of stars",
    meaningZh: "创世记 15:5 领他走到外边，数算天上的星；后裔之约以星为记。",
    meaningEn: "Genesis 15:5 brings him outside to number the stars; the promise of descendants is sealed by them.",
    noteZh: "取自经文本身的意象，不是人物容貌。", noteEn: "Taken from the text's own image, not from any likeness.",
  },
  {
    character: "sarah", symbol: "tent", ring: "plain", ground: "vellum", attestation: "scriptural",
    nameZh: "帐棚门口", nameEn: "Tent door",
    meaningZh: "创世记 18:10 撒拉在帐棚门口听见应许而笑。",
    meaningEn: "Genesis 18:10 places her at the tent door, overhearing the promise and laughing.",
    noteZh: "以叙事场景为记，不描绘人物形貌。", noteEn: "A narrative setting used as a device, not a depiction.",
  },
  {
    character: "isaac", symbol: "ram", ring: "thorned", ground: "vellum", attestation: "scriptural",
    nameZh: "困在稠密树丛的公羊", nameEn: "Ram in the thicket",
    meaningZh: "创世记 22:13 亚伯拉罕举目观看，见一只公羊两角扣在稠密的小树中。",
    meaningEn: "Genesis 22:13: a ram caught in a thicket by its horns, offered in his place.",
    noteZh: "象征替代与保全，不评断该叙事的神学解释。", noteEn: "A sign of substitution; the passage's theology is left to the reader.",
  },
  {
    character: "rebekah", symbol: "pitcher", ring: "waved", ground: "vellum", attestation: "scriptural",
    nameZh: "水瓶", nameEn: "Water jar",
    meaningZh: "创世记 24:15–20 她肩头上扛着水瓶，为仆人和骆驼打水。",
    meaningEn: "Genesis 24:15–20: she comes with a jar on her shoulder and draws for the servant and his camels.",
    noteZh: "取自认亲场景的关键器物。", noteEn: "The object that identifies her in the betrothal scene.",
  },
  {
    character: "jacob", symbol: "ladder", ring: "rayed", ground: "sky", attestation: "scriptural",
    nameZh: "天梯", nameEn: "Ladder",
    meaningZh: "创世记 28:12 梦见一个梯子立在地上，梯子的头顶着天。",
    meaningEn: "Genesis 28:12: a ladder set on the earth with its top reaching heaven.",
    noteZh: "同一意象也是 Dufay《Nuper rosarum flores》定旋律的出处。", noteEn: "The same image supplies the tenor of Dufay's Nuper rosarum flores.",
  },
  {
    character: "rachel", symbol: "crook", ring: "plain", ground: "vellum", attestation: "scriptural",
    nameZh: "牧杖", nameEn: "Shepherd's crook",
    meaningZh: "创世记 29:9 拉结同她父亲的羊来了，因为那些羊是她牧放的。",
    meaningEn: "Genesis 29:9: she comes with her father's sheep, for she is the one who keeps them.",
    noteZh: "以职分为记。", noteEn: "An emblem of her role in the narrative.",
  },
  {
    character: "joseph-son-of-jacob", symbol: "striped-coat", ring: "plain", ground: "gold", attestation: "scriptural",
    nameZh: "彩衣", nameEn: "Long coat",
    meaningZh: "创世记 37:3 以色列给约瑟做了一件彩衣。",
    meaningEn: "Genesis 37:3: his father makes him a coat of many colours.",
    noteZh: "该词的确切含义在译本间有争议，此处只取其为父亲偏爱之记号。", noteEn: "The Hebrew term is debated; used here only as the sign of a father's favour.",
  },
  {
    character: "moses", symbol: "tablets", ring: "rayed", ground: "ink", attestation: "scriptural",
    nameZh: "两块法版", nameEn: "Two tablets",
    meaningZh: "出埃及记 34:29 摩西手里拿着两块法版下西奈山。",
    meaningEn: "Exodus 34:29: he comes down from Sinai with the two tablets in his hand.",
    noteZh: "不采用中世纪艺术中因翻译歧义而生的角状形象。", noteEn: "The horned iconography born of a translation ambiguity is deliberately not used.",
  },
  {
    character: "aaron", symbol: "budding-rod", ring: "braided", ground: "gold", attestation: "scriptural",
    nameZh: "发芽的杖", nameEn: "Budding rod",
    meaningZh: "民数记 17:8 亚伦的杖已经发了芽，开了花，结了熟杏。",
    meaningEn: "Numbers 17:8: Aaron's rod buds, blossoms, and bears almonds.",
    noteZh: "以祭司职分的确认记号为徽。", noteEn: "The sign by which his priestly office is confirmed.",
  },
  {
    character: "miriam", symbol: "timbrel", ring: "waved", ground: "vellum", attestation: "scriptural",
    nameZh: "手鼓", nameEn: "Timbrel",
    meaningZh: "出埃及记 15:20 米利暗手里拿着鼓，众妇女也跟她出去打鼓跳舞。",
    meaningEn: "Exodus 15:20: she takes a timbrel in her hand and the women follow her with dancing.",
    noteZh: "本图集中唯一以乐器为记的旧约人物。", noteEn: "The only Hebrew Bible figure in this atlas emblazoned with an instrument.",
  },
  {
    character: "joshua", symbol: "shofar", ring: "plain", ground: "ink", attestation: "scriptural",
    nameZh: "羊角", nameEn: "Ram's horn",
    meaningZh: "约书亚记 6:4 七个祭司要拿七个羊角走在约柜前。",
    meaningEn: "Joshua 6:4: seven priests carry seven rams' horns before the ark.",
    noteZh: "耶利哥叙事的核心器物。", noteEn: "The instrument at the centre of the Jericho narrative.",
  },
  {
    character: "deborah", symbol: "palm", ring: "plain", ground: "vellum", attestation: "scriptural",
    nameZh: "底波拉的棕树", nameEn: "Palm of Deborah",
    meaningZh: "士师记 4:5 她住在棕树下，以色列人都上她那里去听判断。",
    meaningEn: "Judges 4:5: she sits under the palm and Israel comes up to her for judgement.",
    noteZh: "以审判之处为记。", noteEn: "The place of judgement used as the emblem.",
  },
  {
    character: "gideon", symbol: "fleece", ring: "plain", ground: "vellum", attestation: "scriptural",
    nameZh: "羊毛", nameEn: "Fleece",
    meaningZh: "士师记 6:37 我把一团羊毛放在禾场上。",
    meaningEn: "Judges 6:37: he lays a fleece of wool on the threshing floor.",
    noteZh: "求证据的记号，与他反复求问的性格一致。", noteEn: "A sign asked for as proof, matching his repeated questioning.",
  },
  {
    character: "samson", symbol: "broken-pillars", ring: "chained", ground: "ink", attestation: "scriptural",
    nameZh: "推倒的柱子", nameEn: "Broken pillars",
    meaningZh: "士师记 16:29–30 参孙抱住托房的那两根柱子。",
    meaningEn: "Judges 16:29–30: he takes hold of the two pillars on which the house rests.",
    noteZh: "锁链环纹对应他被掳的结局。", noteEn: "The chained border answers his captivity.",
  },
  {
    character: "jael", symbol: "tent-peg", ring: "plain", ground: "vellum", attestation: "scriptural",
    nameZh: "橛子与锤", nameEn: "Tent peg and mallet",
    meaningZh: "士师记 4:21 雅亿手拿帐棚的橛子，又手拿锤子。",
    meaningEn: "Judges 4:21: Jael takes a tent peg in her hand and a hammer in the other.",
    noteZh: "取自经文所记的器物。她此前在本图集中只以一张杀戮版画存在，没有徽章也没有言论——那不是任何人的编辑决定，而是三条轨各自合理的选择叠加出的结果。",
    noteEn: "The objects the text names. She had previously existed in this atlas only as an engraving of a killing, with no emblem and no saying — not anyone's editorial decision, but what three separately reasonable choices added up to.",
  },
  {
    character: "jezebel", symbol: "vineyard", ring: "plain", ground: "ink", attestation: "scriptural",
    nameZh: "拿伯的葡萄园", nameEn: "Naboth's vineyard",
    meaningZh: "列王纪上 21 章：耶洗别设计夺取拿伯的葡萄园，是叙事中归给她的核心作为。",
    meaningEn: "1 Kings 21: the seizure of Naboth's vineyard is the act the narrative lays to her charge.",
    noteZh: "不采用「高窗」——列王纪下 9:30 的窗口正是她被推下摔死之处，以此为徽等于给她一枚判决。葡萄园标示她在叙事中的作为，由读者自行判断。",
    noteEn: "The high window is deliberately not used: in 2 Kings 9:30 that window is where she is thrown to her death, and an emblem of it would be a verdict. The vineyard marks what the narrative says she did and leaves the judgement to the reader.",
  },
  {
    character: "ruth", symbol: "sheaf", ring: "plain", ground: "gold", attestation: "scriptural",
    nameZh: "麦穗", nameEn: "Sheaf of grain",
    meaningZh: "路得记 2:2 容我往田间去，在人的身后拾取麦穗。",
    meaningEn: "Ruth 2:2: she goes to the field to glean among the ears of grain.",
    noteZh: "拾穗之举贯穿全书。", noteEn: "Gleaning runs through the whole book.",
  },
  {
    character: "samuel", symbol: "horn-of-oil", ring: "braided", ground: "gold", attestation: "scriptural",
    nameZh: "膏油的角", nameEn: "Horn of oil",
    meaningZh: "撒母耳记上 16:13 撒母耳就用角里的膏油在他诸兄中膏了他。",
    meaningEn: "1 Samuel 16:13: he takes the horn of oil and anoints David among his brothers.",
    noteZh: "他两次膏立君王，故以角为记。", noteEn: "He anoints two kings; the horn stands for both.",
  },
  {
    character: "saul", symbol: "spear", ring: "plain", ground: "ink", attestation: "scriptural",
    nameZh: "枪", nameEn: "Spear",
    meaningZh: "撒母耳记上 18:10–11 扫罗手里拿着枪，把枪一抡。",
    meaningEn: "1 Samuel 18:10–11: with a spear in his hand, Saul hurls it.",
    noteZh: "同一件器物在他的叙事中反复出现。", noteEn: "The same object recurs throughout his story.",
  },
  {
    character: "jonathan", symbol: "bow", ring: "plain", ground: "vellum", attestation: "scriptural",
    nameZh: "弓", nameEn: "Bow",
    meaningZh: "撒母耳记下 1:22 约拿单的弓箭非流敌人的血不退缩。",
    meaningEn: "2 Samuel 1:22: the bow of Jonathan did not turn back.",
    noteZh: "取自大卫为他所作的哀歌。", noteEn: "From David's lament over him.",
  },
  {
    character: "david", symbol: "harp", ring: "braided", ground: "gold", attestation: "scriptural",
    nameZh: "琴", nameEn: "Lyre",
    meaningZh: "撒母耳记上 16:23 大卫就拿琴，用手而弹。",
    meaningEn: "1 Samuel 16:23: David takes the harp and plays with his hand.",
    noteZh: "此徽同时是他与欧洲音乐史交叉链接的入口。", noteEn: "This emblem is also his doorway into the music atlas.",
  },
  {
    character: "solomon", symbol: "crown", ring: "braided", ground: "gold", attestation: "scriptural",
    nameZh: "冠冕", nameEn: "Crown",
    meaningZh: "列王纪上 3:9 求你赐我智慧，可以判断你的民。",
    meaningEn: "1 Kings 3:9: he asks for an understanding heart to judge the people.",
    noteZh: "冠冕在此代表王的审断之责，不是财富。", noteEn: "The crown here stands for the duty of judgement, not for wealth.",
  },
  {
    character: "elijah", symbol: "fire-chariot", ring: "rayed", ground: "sky", attestation: "scriptural",
    nameZh: "火车火马", nameEn: "Chariot of fire",
    meaningZh: "列王纪下 2:11 忽有火车火马将二人隔开。",
    meaningEn: "2 Kings 2:11: a chariot of fire and horses of fire separate the two of them.",
    noteZh: "以叙事结局为记。", noteEn: "The emblem is his departure.",
  },
  {
    character: "elisha", symbol: "mantle", ring: "plain", ground: "vellum", attestation: "scriptural",
    nameZh: "以利亚的外衣", nameEn: "Elijah's mantle",
    meaningZh: "列王纪下 2:13 他拾起以利亚身上掉下来的外衣。",
    meaningEn: "2 Kings 2:13: he picks up the mantle that fell from Elijah.",
    noteZh: "承接之记号。", noteEn: "The sign of succession.",
  },
  {
    character: "isaiah", symbol: "coal", ring: "rayed", ground: "ink", attestation: "scriptural",
    nameZh: "红炭", nameEn: "Live coal",
    meaningZh: "以赛亚书 6:6–7 手里拿着红炭，是用火剪从坛上取下来的。",
    meaningEn: "Isaiah 6:6–7: a live coal taken from the altar with tongs.",
    noteZh: "呼召场景的核心意象。", noteEn: "The central image of his call.",
  },
  {
    character: "jeremiah", symbol: "yoke", ring: "chained", ground: "ink", attestation: "scriptural",
    nameZh: "轭", nameEn: "Yoke",
    meaningZh: "耶利米书 27:2 你做绳索与轭，加在自己的颈项上。",
    meaningEn: "Jeremiah 27:2: he is told to make bonds and bars and put them on his neck.",
    noteZh: "先知的象征行动，不是刑具描写；锁链环纹取自他自己戴上的绳索与轭。", noteEn: "A prophetic sign-act, not an instrument of punishment; the chained border is the bonds he puts on himself.",
  },
  {
    character: "daniel", symbol: "lion", ring: "plain", ground: "ink", attestation: "scriptural",
    nameZh: "狮子", nameEn: "Lion",
    meaningZh: "但以理书 6:22 我的神差遣使者，封住狮子的口。",
    meaningEn: "Daniel 6:22: God sends his angel and shuts the lions' mouths.",
    noteZh: "狮口封闭之记，不作现代动物学表述。", noteEn: "The shut lions' mouths, not a zoological statement.",
  },
  {
    character: "esther", symbol: "scepter", ring: "braided", ground: "gold", attestation: "scriptural",
    nameZh: "金杖", nameEn: "Golden scepter",
    meaningZh: "以斯帖记 5:2 王向她伸出手中的金杖。",
    meaningEn: "Esther 5:2: the king holds out to her the golden scepter in his hand.",
    noteZh: "接纳与冒险的双重记号。", noteEn: "A sign of both acceptance and risk.",
  },
  {
    character: "nehemiah", symbol: "trowel", ring: "plain", ground: "ink", attestation: "scriptural",
    nameZh: "泥刀", nameEn: "Trowel",
    meaningZh: "尼希米记 4:17 一手做工，一手拿兵器。",
    meaningEn: "Nehemiah 4:17: each worked with one hand and held a weapon with the other.",
    noteZh: "重建城墙的工具。", noteEn: "The tool of the wall's rebuilding.",
  },
  {
    character: "jonah", symbol: "fish", ring: "waved", ground: "sky", attestation: "scriptural",
    nameZh: "大鱼", nameEn: "Great fish",
    meaningZh: "约拿书 1:17 耶和华安排一条大鱼吞了约拿。",
    meaningEn: "Jonah 1:17: a great fish is appointed to swallow Jonah.",
    noteZh: "文本称大鱼，不称鲸。", noteEn: "The text says a great fish, not a whale.",
  },
  {
    character: "noah", symbol: "ark", ring: "waved", ground: "sky", attestation: "scriptural",
    nameZh: "方舟", nameEn: "Ark",
    meaningZh: "创世记 6–8 章洪水叙事的核心器物。",
    meaningEn: "The vessel at the centre of the Genesis 6–8 flood narrative.",
    noteZh: "示意性船形，不作船体考据。", noteEn: "A schematic hull, not a reconstruction claim.",
  },
  {
    character: "adam", symbol: "tree", ring: "plain", ground: "vellum", attestation: "scriptural",
    nameZh: "园中的树", nameEn: "Tree of the garden",
    meaningZh: "创世记 2:9 园子当中又有生命树和分别善恶的树。",
    meaningEn: "Genesis 2:9: in the middle of the garden stand the tree of life and the tree of knowledge.",
    noteZh: "不描绘人物形貌。", noteEn: "No human likeness is drawn.",
  },
  {
    character: "eve", symbol: "living-branch", ring: "braided", ground: "vellum", attestation: "scriptural",
    nameZh: "众生之母", nameEn: "Mother of all living",
    meaningZh: "创世记 3:20 亚当给他妻子起名叫夏娃，因为她是众生之母。",
    meaningEn: "Genesis 3:20: Adam names his wife Eve, because she is the mother of all living.",
    noteZh: "以经文给她的名号为记。蛇属于伊甸叙事，不是她的身份标识——把女人与蛇焊在一起是后世接受史，不是本文本的说法。",
    noteEn: "Her emblem is the name the text gives her. The serpent belongs to the garden narrative, not to her identity; welding the woman to the snake is later reception, not what this text says.",
  },
  {
    character: "mary", symbol: "lily", ring: "rayed", ground: "sky", attestation: "iconographic",
    nameZh: "百合", nameEn: "Lily",
    meaningZh: "百合是欧洲报喜图像中固定的属性物，不出自经文。",
    meaningEn: "The lily is a fixed attribute in European Annunciation imagery; it is not in the text.",
    noteZh: "此为图像学传统，已明确标注为 iconographic。", noteEn: "An art-historical convention, explicitly marked as iconographic.",
  },
  {
    character: "john-the-baptist", symbol: "reed-cross", ring: "thorned", ground: "ink", attestation: "iconographic",
    nameZh: "苇杖十字", nameEn: "Reed cross",
    meaningZh: "苇杖十字是欧洲艺术中施洗约翰的固定属性物；约翰福音 1:29 供其言语依据。",
    meaningEn: "The reed cross is his standard attribute in European art; John 1:29 supplies his words.",
    noteZh: "属性物属图像传统，经文只提供言语。", noteEn: "The attribute is traditional; only the saying comes from the text.",
  },
  {
    character: "jesus", symbol: "chi-rho", ring: "rayed", ground: "gold", attestation: "liturgical",
    nameZh: "基督符号（Chi-Rho）", nameEn: "Chi-Rho",
    meaningZh: "希腊文 ΧΡΙΣΤΟΣ 的头两个字母，四世纪起为通行的基督符号。",
    meaningEn: "The first two letters of ΧΡΙΣΤΟΣ, in use as a Christ monogram since the fourth century.",
    noteZh: "本图集不为耶稣绘制面容：具象描绘在多个传统中属敏感问题，符号是中立表达。",
    noteEn: "This atlas draws no face for Jesus; figural depiction is contested in several traditions, and a monogram stays neutral.",
  },
  {
    character: "peter", symbol: "keys", ring: "braided", ground: "gold", attestation: "scriptural",
    nameZh: "钥匙", nameEn: "Keys",
    meaningZh: "马太福音 16:19 我要把天国的钥匙给你。",
    meaningEn: "Matthew 16:19: the keys of the kingdom are given to him.",
    noteZh: "此徽在经文与后世图像传统中一致。", noteEn: "Text and later iconography agree on this one.",
  },
  {
    character: "paul", symbol: "sword-scroll", ring: "plain", ground: "ink", attestation: "iconographic",
    nameZh: "剑与书卷", nameEn: "Sword and scroll",
    meaningZh: "书卷代表书信，剑为欧洲艺术中保罗的固定属性物。",
    meaningEn: "The scroll stands for the letters; the sword is Paul's fixed attribute in European art.",
    noteZh: "剑属图像传统，不指涉暴力。", noteEn: "The sword is iconographic convention, not a reference to violence.",
  },
  {
    character: "john-son-of-zebedee", symbol: "eagle", ring: "rayed", ground: "sky", attestation: "iconographic",
    nameZh: "鹰", nameEn: "Eagle",
    meaningZh: "四福音书象征体系中约翰配鹰，源自以西结书 1:10 与启示录 4:7 的四活物。",
    meaningEn: "In the evangelists' symbol system John takes the eagle, from the living creatures of Ezekiel 1:10 and Revelation 4:7.",
    noteZh: "该配对由教父传统确立，不出自福音书自身。", noteEn: "The pairing comes from patristic tradition, not from the Gospel itself.",
  },
  {
    character: "mary-magdalene", symbol: "jar", ring: "plain", ground: "vellum", attestation: "scriptural",
    nameZh: "香膏", nameEn: "Spices for anointing",
    meaningZh: "马可福音 16:1 抹大拉的马利亚买了香膏，要去膏耶稣的身体。",
    meaningEn: "Mark 16:1: Mary Magdalene buys spices in order to anoint the body of Jesus.",
    noteZh: "沿用欧洲艺术为她固定的容器形，但依据取她本人在马可福音 16:1 的携膏之举；不采用把她与路加福音 7 章、约翰福音 12 章的无名妇女合并的后世读法。",
    noteEn: "It keeps the vessel European art fixed on her, but rests on her own act in Mark 16:1 — not on the later conflation of her with the unnamed women of Luke 7 and John 12.",
  },
  {
    character: "judas-iscariot", symbol: "coins", ring: "plain", ground: "ink", attestation: "scriptural",
    nameZh: "三十块钱", nameEn: "Thirty pieces of silver",
    meaningZh: "马太福音 26:15 他们就给了他三十块钱。",
    meaningEn: "Matthew 26:15: they weigh out to him thirty pieces of silver.",
    noteZh: "取自马太福音的叙事细节。该属性物在中世纪以降的欧洲艺术中与敌犹刻板形象合流，本图集只取经文所记的交易，不承接那套图像。", noteEn: "A narrative detail from Matthew. In European art from the Middle Ages on, this attribute merged with antisemitic caricature; the atlas takes only the transaction the text records, not that imagery.",
  },
  {
    character: "pontius-pilate", symbol: "basin", ring: "plain", ground: "ink", attestation: "scriptural",
    nameZh: "洗手的盆", nameEn: "Basin",
    meaningZh: "马太福音 27:24 彼拉多拿水在众人面前洗手。",
    meaningEn: "Matthew 27:24: Pilate takes water and washes his hands before the crowd.",
    noteZh: "只标注叙事动作。", noteEn: "It marks an action in the narrative and nothing more.",
  },
  {
    character: "nebuchadnezzar", symbol: "statue", ring: "plain", ground: "ink", attestation: "scriptural",
    nameZh: "大像", nameEn: "Great image",
    meaningZh: "但以理书 2:31 王啊，你梦见一个大像。",
    meaningEn: "Daniel 2:31: the king sees a great image in his dream.",
    noteZh: "取自但以理书的梦象，不是历史造像考据。", noteEn: "From the dream in Daniel, not from archaeology.",
  },
];

// ---------------------------------------------------------------------------
// D2 · Era emblems
// ---------------------------------------------------------------------------

export interface ChapterEmblem {
  chapter: string;
  symbol: string;
  nameZh: string;
  nameEn: string;
  meaningZh: string;
  meaningEn: string;
}

export const CHAPTER_EMBLEMS: readonly ChapterEmblem[] = [
  { chapter: "primeval", symbol: "radiance", nameZh: "光", nameEn: "Light", meaningZh: "创世叙事以光的分开为起点。", meaningEn: "The primeval narrative opens with light divided from darkness." },
  { chapter: "patriarchs", symbol: "starfield", nameZh: "众星", nameEn: "Stars", meaningZh: "族长叙事以数算天上的星为约的记号。", meaningEn: "The patriarchal promise is counted out in stars." },
  { chapter: "exodus-and-sinai", symbol: "flame", nameZh: "火柱", nameEn: "Pillar of fire", meaningZh: "出埃及叙事以火柱与云柱领路。", meaningEn: "Fire and cloud lead the Exodus march." },
  { chapter: "wilderness-and-conquest", symbol: "tent", nameZh: "会幕", nameEn: "Tabernacle", meaningZh: "旷野时期的中心是可迁移的会幕。", meaningEn: "The wilderness centre is a tent that moves." },
  { chapter: "judges", symbol: "shofar", nameZh: "羊角", nameEn: "Ram's horn", meaningZh: "士师叙事以号角召集支派。", meaningEn: "The horn gathers the tribes in the judges' cycles." },
  { chapter: "united-monarchy", symbol: "crown", nameZh: "冠冕", nameEn: "Crown", meaningZh: "统一王国时期以王权为轴。", meaningEn: "The united monarchy turns on kingship." },
  { chapter: "divided-kingdoms", symbol: "split-crown", nameZh: "裂开的冠冕", nameEn: "Divided crown", meaningZh: "王国分裂为南北两国。", meaningEn: "One crown becomes two kingdoms." },
  { chapter: "prophetic-narrative", symbol: "mantle", nameZh: "先知外衣", nameEn: "Prophet's mantle", meaningZh: "先知叙事以承接的外衣为记。", meaningEn: "The prophetic line is marked by a mantle handed on." },
  { chapter: "judah-and-exile", symbol: "broken-wall", nameZh: "破口的城墙", nameEn: "Breached wall", meaningZh: "被掳时期以城墙被破为界。", meaningEn: "Exile begins at a breached wall." },
  { chapter: "return-and-restoration", symbol: "trowel", nameZh: "泥刀", nameEn: "Trowel", meaningZh: "归回时期以重建为主题。", meaningEn: "The return is a rebuilding." },
  { chapter: "gospels", symbol: "chi-rho", nameZh: "基督符号", nameEn: "Chi-Rho", meaningZh: "福音书时期以基督符号为记，不绘面容。", meaningEn: "The Gospels are marked by the monogram, never a face." },
  { chapter: "acts", symbol: "flame-tongues", nameZh: "舌头如火焰", nameEn: "Tongues of fire", meaningZh: "使徒行传以五旬节的火舌开篇。", meaningEn: "Acts opens with tongues as of fire." },
  { chapter: "pauline-mission", symbol: "ship", nameZh: "船", nameEn: "Ship", meaningZh: "保罗宣教以地中海航行为骨架。", meaningEn: "The Pauline mission is built on Mediterranean voyages." },
];

// ---------------------------------------------------------------------------
// B1 · Event scripture references
// ---------------------------------------------------------------------------

export interface ScriptureRef {
  event: string;
  osis: string;
  role: "primary" | "parallel" | "background";
}

export const EVENT_SCRIPTURE_REFS: readonly ScriptureRef[] = [
  { event: "creation-of-heavens-and-earth", osis: "Gen.1.1-Gen.1.5", role: "primary" },
  { event: "creation-of-humankind", osis: "Gen.1.26-Gen.1.31", role: "primary" },
  { event: "creation-of-humankind", osis: "Gen.2.7", role: "parallel" },
  { event: "sabbath-rest-of-creation", osis: "Gen.2.1-Gen.2.3", role: "primary" },
  { event: "adam-placed-in-garden-of-eden", osis: "Gen.2.8-Gen.2.15", role: "primary" },
  { event: "creation-of-eve-from-adams-rib", osis: "Gen.2.21-Gen.2.23", role: "primary" },
  { event: "expulsion-from-eden", osis: "Gen.3.22-Gen.3.24", role: "primary" },
  { event: "birth-of-cain", osis: "Gen.4.1", role: "primary" },
  { event: "birth-of-abel", osis: "Gen.4.2", role: "primary" },
  { event: "cain-marked-and-exiled", osis: "Gen.4.15-Gen.4.16", role: "primary" },
  { event: "birth-of-seth", osis: "Gen.4.25", role: "primary" },
  { event: "birth-of-lamech-father-of-noah", osis: "Gen.5.25", role: "primary" },
  { event: "birth-of-ishmael", osis: "Gen.16.15", role: "primary" },
  { event: "birth-of-isaac", osis: "Gen.21.1-Gen.21.3", role: "primary" },
  { event: "birth-of-jacob-and-esau", osis: "Gen.25.24-Gen.25.26", role: "primary" },
  { event: "esau-sells-his-birthright", osis: "Gen.25.29-Gen.25.34", role: "primary" },
  { event: "jacobs-dream-at-bethel", osis: "Gen.28.10-Gen.28.22", role: "primary" },
  { event: "birth-of-moses-in-goshen", osis: "Exod.2.1-Exod.2.10", role: "primary" },
  { event: "theophany-at-sinai", osis: "Exod.19.16-Exod.19.20", role: "primary" },
  { event: "ten-commandments-given", osis: "Exod.20.1-Exod.20.17", role: "primary" },
  { event: "ten-commandments-given", osis: "Deut.5.6-Deut.5.21", role: "parallel" },
  { event: "sinai-covenant", osis: "Exod.24.3-Exod.24.8", role: "primary" },
  { event: "departure-from-sinai", osis: "Num.10.11-Num.10.13", role: "primary" },
  { event: "crossing-the-jordan", osis: "Josh.3.14-Josh.3.17", role: "primary" },
  { event: "birth-of-samson-foretold", osis: "Judg.13.2-Judg.13.5", role: "primary" },
  { event: "birth-and-dedication-of-samuel", osis: "1Sam.1.20-1Sam.1.28", role: "primary" },
  { event: "samuel-anoints-saul", osis: "1Sam.10.1", role: "primary" },
  { event: "samuel-anoints-david-at-bethlehem", osis: "1Sam.16.11-1Sam.16.13", role: "primary" },
  { event: "david-anointed-king-at-hebron", osis: "2Sam.2.4", role: "primary" },
  { event: "hiram-supplies-the-temple-project", osis: "1Kgs.5.1-1Kgs.5.12", role: "primary" },
  { event: "first-temple-built", osis: "1Kgs.6.1-1Kgs.6.14", role: "primary" },
  { event: "dedication-of-the-temple", osis: "1Kgs.8.10-1Kgs.8.13", role: "primary" },
  { event: "jehu-anointed-at-ramoth-gilead", osis: "2Kgs.9.1-2Kgs.9.6", role: "primary" },
  { event: "joash-crowned-in-the-temple", osis: "2Kgs.11.12", role: "primary" },
  { event: "amos-preaches-at-bethel", osis: "Amos.7.10-Amos.7.13", role: "primary" },
  { event: "isaiah-called-in-the-temple", osis: "Isa.6.1-Isa.6.8", role: "primary" },
  { event: "book-of-the-law-found-in-the-temple", osis: "2Kgs.22.8-2Kgs.22.13", role: "primary" },
  { event: "jeremiahs-temple-sermon", osis: "Jer.7.1-Jer.7.15", role: "primary" },
  { event: "first-deportation-to-babylon", osis: "2Kgs.24.10-2Kgs.24.16", role: "primary" },
  { event: "daniel-in-the-babylonian-court", osis: "Dan.1.3-Dan.1.7", role: "primary" },
  { event: "temple-destroyed", osis: "2Kgs.25.8-2Kgs.25.10", role: "primary" },
  { event: "temple-foundation-laid", osis: "Ezra.3.10-Ezra.3.13", role: "primary" },
  { event: "second-temple-rebuilt", osis: "Ezra.6.14-Ezra.6.16", role: "primary" },
  { event: "birth-of-jesus", osis: "Luke.2.1-Luke.2.7", role: "primary" },
  { event: "birth-of-jesus", osis: "Matt.1.18-Matt.1.25", role: "parallel" },
  { event: "boy-jesus-in-the-temple", osis: "Luke.2.41-Luke.2.52", role: "primary" },
  { event: "baptism-at-the-jordan", osis: "Mark.1.9-Mark.1.11", role: "primary" },
  { event: "baptism-at-the-jordan", osis: "Matt.3.13-Matt.3.17", role: "parallel" },
  { event: "beheading-of-john-the-baptist", osis: "Mark.6.21-Mark.6.29", role: "primary" },
  { event: "beheading-of-john-the-baptist", osis: "Matt.14.6-Matt.14.12", role: "parallel" },
  { event: "cleansing-of-the-temple", osis: "Mark.11.15-Mark.11.18", role: "primary" },
  { event: "cleansing-of-the-temple", osis: "John.2.13-John.2.17", role: "parallel" },
  { event: "last-supper", osis: "Luke.22.14-Luke.22.20", role: "primary" },
  { event: "last-supper", osis: "Mark.14.22-Mark.14.25", role: "parallel" },
  { event: "crucifixion-in-jerusalem", osis: "Mark.15.22-Mark.15.37", role: "primary" },
  { event: "crucifixion-in-jerusalem", osis: "John.19.17-John.19.30", role: "parallel" },
  { event: "pentecost-in-jerusalem", osis: "Acts.2.1-Acts.2.4", role: "primary" },
  { event: "peter-preaches-at-pentecost", osis: "Acts.2.14-Acts.2.41", role: "primary" },
  { event: "paul-conversion-damascus", osis: "Acts.9.1-Acts.9.19", role: "primary" },
];

// ---------------------------------------------------------------------------
// B2 · Character quotes
// ---------------------------------------------------------------------------

export type SpeechKind = "declaration" | "prayer" | "blessing" | "lament" | "command" | "confession" | "admission" | "praise" | "objection" | "prophecy" | "question";

export interface CharacterQuote {
  character: string;
  osis: string;
  kind: SpeechKind;
  importance: number;
  /** Excerpt as published in the CUV (1919), traditional script. */
  zh: string;
  /** Excerpt as published in the World English Bible. */
  en: string;
  event?: string;
  contextZh: string;
  contextEn: string;
}

export const CHARACTER_QUOTES: readonly CharacterQuote[] = [
  {
    character: "abraham", osis: "Gen.22.8", kind: "declaration", importance: 5,
    zh: "我兒，神必自己預備作燔祭的羊羔", en: "God will provide himself the lamb for a burnt offering, my son",
    contextZh: "以撒问燔祭的羊羔在哪里，亚伯拉罕如此回答。", contextEn: "His answer when Isaac asks where the lamb is.",
  },
  {
    character: "adam", osis: "Gen.3.12", kind: "admission", importance: 4,
    zh: "你所賜給我、與我同居的女人，她把那樹上的果子給我，我就吃了", en: "The woman whom you gave to be with me, she gave me fruit from the tree, and I ate",
    event: "expulsion-from-eden",
    contextZh: "被追问时的第一句推诿。", contextEn: "The first deflection in the garden interrogation.",
  },
  {
    character: "eve", osis: "Gen.3.13", kind: "admission", importance: 4,
    zh: "那蛇引誘我，我就吃了", en: "The serpent deceived me, and I ate",
    event: "expulsion-from-eden",
    contextZh: "紧接亚当之后的回答。", contextEn: "Her answer immediately after Adam's.",
  },
  {
    character: "jacob", osis: "Gen.28.16", kind: "declaration", importance: 5,
    zh: "耶和華真在這裏，我竟不知道", en: "Surely Yahweh is in this place, and I didn’t know it",
    event: "jacobs-dream-at-bethel",
    contextZh: "伯特利梦醒后的第一句话。", contextEn: "His first words on waking at Bethel.",
  },
  {
    character: "joseph-son-of-jacob", osis: "Gen.50.20", kind: "declaration", importance: 5,
    zh: "從前你們的意思是要害我，但神的意思原是好的", en: "As for you, you meant evil against me, but God meant it for good",
    contextZh: "与兄弟重逢并赦免时所说。", contextEn: "Spoken when he forgives his brothers.",
  },
  {
    character: "moses", osis: "Exod.5.1", kind: "command", importance: 5,
    zh: "容我的百姓去，在曠野向我守節", en: "Let my people go, that they may hold a feast to me in the wilderness",
    contextZh: "首次面见法老时转述的话。", contextEn: "The message he carries to Pharaoh.",
  },
  {
    character: "moses", osis: "Deut.6.4", kind: "declaration", importance: 5,
    zh: "以色列啊，你要聽", en: "Hear, Israel",
    contextZh: "示玛（Shema）的开篇。", contextEn: "The opening of the Shema.",
  },
  {
    character: "miriam", osis: "Exod.15.21", kind: "praise", importance: 3,
    zh: "你們要歌頌耶和華，因他大大戰勝", en: "Sing to Yahweh, for he has triumphed gloriously",
    contextZh: "过海之后领众妇女击鼓歌唱。", contextEn: "Her song with the women after the sea crossing.",
  },
  {
    character: "sarah", osis: "Gen.18.12", kind: "question", importance: 3,
    zh: "我既已衰敗，我主也老邁，豈能有這喜事呢", en: "After I have grown old will I have pleasure, my lord being old also",
    contextZh: "在帐棚门口听见应许后暗笑所说，与她的帐棚徽章互文。",
    contextEn: "Spoken to herself, laughing, when she overhears the promise at the tent door — the scene her emblem records.",
  },
  {
    character: "hannah", osis: "1Sam.2.1", kind: "praise", importance: 4,
    zh: "我的心因耶和華快樂", en: "My heart exults in Yahweh",
    contextZh: "献上撒母耳后的祷告开篇；其结构与措辞是路加福音尊主颂的先声。",
    contextEn: "The opening of her prayer after she gives up Samuel; its shape and wording stand behind the Magnificat in Luke.",
  },
  {
    character: "joshua", osis: "Josh.24.15", kind: "declaration", importance: 5,
    zh: "至於我和我家，我們必定事奉耶和華", en: "as for me and my house, we will serve Yahweh",
    contextZh: "示剑大会上要求百姓选择时所说。", contextEn: "At the assembly of Shechem, calling for a choice.",
  },
  {
    character: "deborah", osis: "Judg.5.7", kind: "declaration", importance: 3,
    zh: "直到我底波拉興起", en: "until I, Deborah, arose",
    contextZh: "底波拉之歌中的自述；她此前有棕树徽章却不出声。",
    contextEn: "From the Song of Deborah; until now she carried a palm emblem in this atlas but no voice.",
  },
  {
    character: "gideon", osis: "Judg.6.15", kind: "objection", importance: 3,
    zh: "我有何能拯救以色列人呢", en: "how shall I save Israel",
    contextZh: "受召时的推辞。", contextEn: "His objection when called.",
  },
  {
    character: "samson", osis: "Judg.16.30", kind: "declaration", importance: 3,
    zh: "我情願與非利士人同死", en: "Let me die with the Philistines",
    contextZh: "推倒柱子前的最后一句。", contextEn: "His last words before the pillars fall.",
  },
  {
    character: "ruth", osis: "Ruth.1.16", kind: "confession", importance: 5,
    zh: "你往那裏去，我也往那裏去", en: "where you go, I will go",
    contextZh: "拒绝离开拿俄米时的誓言。", contextEn: "Her vow when she refuses to leave Naomi.",
  },
  {
    character: "samuel", osis: "1Sam.3.10", kind: "confession", importance: 4,
    zh: "請說，僕人敬聽", en: "Speak; for your servant hears",
    contextZh: "夜间第四次被呼唤后的回应。", contextEn: "His answer at the fourth call in the night.",
  },
  {
    character: "david", osis: "1Sam.17.45", kind: "declaration", importance: 5,
    zh: "我來攻擊你，是靠着萬軍之耶和華的名", en: "I come to you in the name of Yahweh of Armies",
    contextZh: "在以拉谷对歌利亚所说。", contextEn: "Spoken to Goliath in the Valley of Elah.",
  },
  {
    character: "david", osis: "Ps.23.1", kind: "prayer", importance: 5,
    zh: "耶和華是我的牧者，我必不至缺乏", en: "Yahweh is my shepherd: I shall lack nothing",
    contextZh: "诗篇 23 的开篇，超题归于大卫。", contextEn: "The opening of Psalm 23, ascribed to David in the superscription.",
  },
  {
    character: "solomon", osis: "1Kgs.3.9", kind: "prayer", importance: 5,
    zh: "所以求你賜我智慧，可以判斷你的民，能辨別是非", en: "Give your servant therefore an understanding heart to judge your people, that I may discern between good and evil",
    contextZh: "基遍梦中所求。", contextEn: "His request in the dream at Gibeon.",
  },
  {
    character: "elijah", osis: "1Kgs.18.21", kind: "question", importance: 4,
    zh: "你們心持兩意要到幾時呢", en: "How long will you waver between the two sides",
    contextZh: "迦密山上向百姓发问。", contextEn: "His challenge to the people on Carmel.",
  },
  {
    character: "isaiah", osis: "Isa.6.8", kind: "confession", importance: 5,
    zh: "我在這裏，請差遣我", en: "Here I am. Send me",
    event: "isaiah-called-in-the-temple",
    contextZh: "圣殿异象中的应答。", contextEn: "His answer in the temple vision.",
  },
  {
    character: "jeremiah", osis: "Jer.1.6", kind: "objection", importance: 4,
    zh: "我不知怎樣說，因為我是年幼的", en: "I don’t know how to speak; for I am a child",
    contextZh: "受召时的推辞。", contextEn: "His objection when called.",
  },
  {
    character: "daniel", osis: "Dan.6.22", kind: "declaration", importance: 4,
    zh: "我的神差遣使者，封住獅子的口", en: "My God has sent his angel, and has shut the lions’ mouths",
    contextZh: "自狮子坑中回话。", contextEn: "Called up out of the den.",
  },
  {
    character: "esther", osis: "Esth.4.16", kind: "declaration", importance: 5,
    zh: "我若死就死吧", en: "if I perish, I perish",
    contextZh: "决定进见王之前所说。", contextEn: "Her decision before going in to the king.",
  },
  {
    character: "nehemiah", osis: "Neh.6.3", kind: "declaration", importance: 4,
    zh: "我現在辦理大工，不能下去", en: "I am doing a great work, so that I can’t come down",
    contextZh: "拒绝下到阿挪平原赴约。", contextEn: "His refusal to come down to the plain of Ono.",
  },
  {
    character: "jonah", osis: "Jonah.2.9", kind: "prayer", importance: 4,
    zh: "救恩出於耶和華", en: "Salvation belongs to Yahweh",
    contextZh: "鱼腹中祷告的结句。", contextEn: "The close of his prayer from the fish.",
  },
  {
    character: "nebuchadnezzar", osis: "Dan.4.30", kind: "declaration", importance: 3,
    zh: "這大巴比倫不是我用大能大力建為京都", en: "Is not this great Babylon, which I have built for the royal dwelling place",
    contextZh: "在王宫顶上自夸。", contextEn: "Boasting on the roof of his palace.",
  },
  {
    character: "mary", osis: "Luke.1.38", kind: "confession", importance: 5,
    zh: "我是主的使女，情願照你的話成就在我身上", en: "Behold, the servant of the Lord; let it be done to me according to your word",
    contextZh: "报喜叙事中的应答。", contextEn: "Her answer in the annunciation narrative.",
  },
  {
    character: "mary", osis: "Luke.1.46", kind: "prayer", importance: 4,
    zh: "我心尊主為大", en: "My soul magnifies the Lord",
    contextZh: "尊主颂（Magnificat）的开篇。", contextEn: "The opening of the Magnificat.",
  },
  {
    character: "john-the-baptist", osis: "John.1.29", kind: "declaration", importance: 5,
    zh: "看哪，神的羔羊，除去世人罪孽的", en: "Behold, the Lamb of God, who takes away the sin of the world",
    contextZh: "见耶稣走来时所说。和合本在「除去」处附异读〔或作：背負〕。", contextEn: "Spoken as he sees Jesus coming toward him. The CUV carries a variant reading at “takes away”.",
  },
  {
    character: "john-the-baptist", osis: "John.3.30", kind: "declaration", importance: 4,
    zh: "他必興旺，我必衰微", en: "He must increase, but I must decrease",
    contextZh: "门徒问及众人转投耶稣时的回答。", contextEn: "His reply when his disciples report the crowds leaving.",
  },
  {
    character: "jesus", osis: "John.14.6", kind: "declaration", importance: 5,
    zh: "我就是道路、真理、生命", en: "I am the way, the truth, and the life",
    contextZh: "最后晚餐后对门徒所说。", contextEn: "Spoken to the disciples after the supper.",
  },
  {
    character: "jesus", osis: "Luke.23.34", kind: "prayer", importance: 5,
    zh: "父啊！赦免他們；因為他們所作的，他們不曉得", en: "Father, forgive them, for they don’t know what they are doing",
    event: "crucifixion-in-jerusalem",
    contextZh: "十字架上的祷告。此句在部分最早期抄本中缺，和合本与 WEB 均照印。", contextEn: "A prayer from the cross. The sentence is absent from several of the earliest manuscripts; both the CUV and the WEB print it.",
  },
  {
    character: "jesus", osis: "Matt.22.37", kind: "command", importance: 5,
    zh: "你要盡心、盡性、盡意愛主你的神", en: "You shall love the Lord your God with all your heart, with all your soul, and with all your mind",
    contextZh: "回答哪一条诫命最大。", contextEn: "His answer to which commandment is greatest.",
  },
  {
    character: "peter", osis: "Matt.16.16", kind: "confession", importance: 5,
    zh: "你是基督，是永生神的兒子", en: "You are the Christ, the Son of the living God",
    contextZh: "在该撒利亚腓立比境内的回答。", contextEn: "His answer in the district of Caesarea Philippi.",
  },
  {
    character: "judas-iscariot", osis: "Matt.26.15", kind: "question", importance: 3,
    zh: "我把他交給你們，你們願意給我多少錢", en: "What are you willing to give me, that I should deliver him to you",
    contextZh: "去见祭司长时所说。", contextEn: "Spoken when he goes to the chief priests.",
  },
  {
    character: "pontius-pilate", osis: "John.18.38", kind: "question", importance: 3,
    zh: "真理是甚麼呢", en: "What is truth",
    contextZh: "审问中的一问。", contextEn: "A question put during the interrogation.",
  },
  {
    character: "mary-magdalene", osis: "John.20.13", kind: "lament", importance: 4,
    zh: "有人把我主挪了去，我不知道放在那裏", en: "Because they have taken away my Lord, and I don’t know where they have laid him",
    contextZh: "在空墓旁被问为何哭泣时的回答。", contextEn: "Her answer at the empty tomb when asked why she is weeping.",
  },
  {
    character: "paul", osis: "Gal.2.20", kind: "confession", importance: 5,
    zh: "現在活着的不再是我，乃是基督在我裏面活着", en: "it is no longer I that live, but Christ lives in me",
    contextZh: "加拉太书中自述。", contextEn: "From his own account in Galatians.",
  },
  {
    character: "paul", osis: "1Cor.13.13", kind: "declaration", importance: 5,
    zh: "其中最大的是愛", en: "The greatest of these is love",
    contextZh: "哥林多前书第十三章的结句。", contextEn: "The close of 1 Corinthians 13.",
  },
  {
    character: "paul", osis: "2Tim.4.7", kind: "declaration", importance: 4,
    zh: "那美好的仗我已經打過了，當跑的路我已經跑盡了，所信的道我已經守住了", en: "I have fought the good fight. I have finished the course. I have kept the faith",
    contextZh: "书信末尾的回顾。", contextEn: "A retrospect near the end of the letter.",
  },
];

// ---------------------------------------------------------------------------
// C1 · Cross-work music links
// ---------------------------------------------------------------------------

export interface MusicLink {
  fromKind: "character" | "event" | "location";
  from: string;
  composition: string;
  linkType: "musical_setting" | "musical_reception";
  labelZh: string;
  labelEn: string;
  basisZh: string;
  basisEn: string;
}

export const MUSIC_LINKS: readonly MusicLink[] = [
  {
    fromKind: "character", from: "david", composition: "sagittarius-davids", linkType: "musical_setting",
    labelZh: "许茨《大卫诗篇集》", labelEn: "Schütz, Psalmen Davids",
    basisZh: "1619 年出版的诗篇合唱集，所选文本为归于大卫的诗篇。",
    basisEn: "The 1619 collection sets psalms ascribed to David.",
  },
  {
    fromKind: "character", from: "mary", composition: "ave-maria-virgo-serena", linkType: "musical_setting",
    labelZh: "若斯坎《圣母颂》", labelEn: "Josquin, Ave Maria… virgo serena",
    basisZh: "经文起句取自路加福音 1:28 天使的问安，其余为中世纪续祷文。",
    basisEn: "The opening salutation is Luke 1:28; the rest is a medieval sequence text.",
  },
  {
    fromKind: "character", from: "mary", composition: "o-viridissima-virga", linkType: "musical_reception",
    labelZh: "希尔德加德《最青翠的枝》", labelEn: "Hildegard, O viridissima virga",
    basisZh: "十二世纪圣母交替圣歌，以枝子意象呼应以赛亚书 11:1 的传统解读。",
    basisEn: "A twelfth-century Marian antiphon whose branch imagery follows the traditional reading of Isaiah 11:1.",
  },
  {
    fromKind: "character", from: "mary", composition: "messe-de-nostre-dame", linkType: "musical_reception",
    labelZh: "马肖《圣母弥撒》", labelEn: "Machaut, Messe de Nostre Dame",
    basisZh: "已知最早由单一作曲家完成的常规弥撒套曲，为圣母弥撒而作。",
    basisEn: "The earliest complete Mass Ordinary by one named composer, written for a Lady Mass.",
  },
  {
    fromKind: "event", from: "birth-of-jesus", composition: "o-magnus-mysterium-victoria", linkType: "musical_setting",
    labelZh: "维多利亚《何等伟大的奥秘》", labelEn: "Victoria, O magnum mysterium",
    basisZh: "圣诞晨祷应答圣歌的文本设置。",
    basisEn: "A setting of the Christmas Matins responsory.",
  },
  {
    fromKind: "event", from: "birth-of-jesus", composition: "corelli-concerto-grosso-op6-no8", linkType: "musical_reception",
    labelZh: "科雷利《圣诞协奏曲》", labelEn: "Corelli, Christmas Concerto",
    basisZh: "乐谱题献注明「为圣诞夜而作」。",
    basisEn: "The score is inscribed as made for the night of the Nativity.",
  },
  {
    fromKind: "event", from: "birth-of-jesus", composition: "viderunt-omnes-leonin", linkType: "musical_setting",
    labelZh: "莱奥南《普世看见》（二声部）", labelEn: "Léonin, Viderunt omnes (two voices)",
    basisZh: "圣诞日弥撒升阶经，文本取自诗篇 98:3。",
    basisEn: "The gradual for Christmas Day, its text from Psalm 98:3.",
  },
  {
    fromKind: "event", from: "birth-of-jesus", composition: "viderunt-omnes-perotin", linkType: "musical_setting",
    labelZh: "佩罗坦《普世看见》（四声部）", labelEn: "Pérotin, Viderunt omnes (four voices)",
    basisZh: "同一升阶经的四声部扩写，可与莱奥南版直接对听。",
    basisEn: "The four-voice expansion of the same gradual, made to be compared with Léonin's.",
  },
  {
    fromKind: "event", from: "jacobs-dream-at-bethel", composition: "nuper-rosarum-flores", linkType: "musical_reception",
    labelZh: "杜费《玫瑰花开》", labelEn: "Dufay, Nuper rosarum flores",
    basisZh: "定旋律取自「Terribilis est locus iste」，其经文出处为创世记 28:17 雅各在伯特利之言。",
    basisEn: "Its tenor is Terribilis est locus iste, whose text is Jacob's words at Bethel in Genesis 28:17.",
  },
  {
    fromKind: "event", from: "beheading-of-john-the-baptist", composition: "salome-strauss", linkType: "musical_reception",
    labelZh: "理查·施特劳斯《莎乐美》", labelEn: "R. Strauss, Salome",
    basisZh: "取材自马太福音 14 与马可福音 6 的叙事，经王尔德剧本转手，属现代接受而非经文设置。「莎乐美」之名不见于圣经，马可福音只作「希罗底的女儿」，该名出自约瑟夫《犹太古史》。",
    basisEn: "Drawn from Matthew 14 and Mark 6 by way of Wilde's play: modern reception, not a setting of the text. The name Salome is not in the Bible — Mark says only \"the daughter of Herodias\"; the name comes from Josephus.",
  },
  {
    fromKind: "event", from: "expulsion-from-eden", composition: "li-gieus-d-adam", linkType: "musical_reception",
    labelZh: "《亚当剧》", labelEn: "Le Jeu d'Adam",
    basisZh: "十二世纪盎格鲁-诺曼礼仪剧，搬演创世记 2–3 章的亚当夏娃叙事。",
    basisEn: "A twelfth-century Anglo-Norman liturgical drama staging the Adam and Eve narrative of Genesis 2–3.",
  },
  {
    fromKind: "event", from: "last-supper", composition: "ave-verum-corpus-byrd", linkType: "musical_reception",
    labelZh: "伯德《圣体颂》", labelEn: "Byrd, Ave verum corpus",
    basisZh: "十四世纪圣体文本，属拉丁礼传统的圣体崇敬，不是最后晚餐叙事的经文设置。伯德是伊丽莎白治下的天主教 recusant，此类作品为私下礼拜而写。",
    basisEn: "A fourteenth-century Eucharistic text belonging to Latin-rite devotion to the Body of Christ, not a setting of the supper narrative. Byrd was a Catholic recusant under Elizabeth I, writing such works for worship held in private.",
  },
  {
    fromKind: "location", from: "jerusalem", composition: "sicut-cervus", linkType: "musical_setting",
    labelZh: "帕莱斯特里那《如鹿切慕溪水》", labelEn: "Palestrina, Sicut cervus",
    basisZh: "文本为诗篇 42:1–2；该诗超题归于可拉后裔而非大卫，说话者渴慕重回神的殿。",
    basisEn: "Its text is Psalm 42:1–2; the psalm is ascribed to the sons of Korah, not to David, and its speaker longs for God's house.",
  },
];
