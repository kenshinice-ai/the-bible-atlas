import { AtlasResponseSchema, WorksResponseSchema, type Atlas, type Locale, type WorksResponse } from "./types";

type Pair = readonly [string, string];
const pick = (value: Pair, locale: Locale) => value[locale === "zh-CN" ? 0 : 1];
const meta = (locale: Locale) => ({ resolvedLocale: locale, fallbackUsed: false, translationStatus: "published" as const });
const id = (kind: number, index: number) => `${kind}0000000-0000-4000-8000-${String(index).padStart(12, "0")}`;

const people = [
  { slug: "jia-baoyu", name: ["贾宝玉", "Jia Baoyu"], summary: ["钟爱真情与自由的少年，处在家族期待、亲密关系与照护网络的中心。", "A sensitive young heir at the centre of affection, family expectation, and care."], gender: "male", age: "youth", importance: 5, groups: ["baodai-chai", "yihong-court", "jia-power"] },
  { slug: "lin-daiyu", name: ["林黛玉", "Lin Daiyu"], summary: ["敏锐、清醒而深情，在亲密与寄居处境之间保持尊严。", "Perceptive and deeply affectionate, preserving dignity within a precarious household position."], gender: "female", age: "youth", importance: 5, groups: ["baodai-chai", "garden-circle"] },
  { slug: "xue-baochai", name: ["薛宝钗", "Xue Baochai"], summary: ["温润端整，善于理解礼法与人情之间的尺度。", "Composed and perceptive, attentive to the balance between ritual and human feeling."], gender: "female", age: "youth", importance: 5, groups: ["baodai-chai", "garden-circle", "jia-power"] },
  { slug: "wang-xifeng", name: ["王熙凤", "Wang Xifeng"], summary: ["明艳果决的家务治理者，兼具能力、照护、资源控制与冲突。", "A brilliant household administrator whose competence, care, control, and conflict are inseparable."], gender: "female", age: "adult", importance: 5, groups: ["jia-power"] },
  { slug: "jia-mu", name: ["贾母", "Grandmother Jia"], summary: ["家族最高长辈，以威望、资源分配与情感庇护维系府中秩序。", "The senior matriarch whose authority, patronage, and affection sustain the household."], gender: "female", age: "elder", importance: 5, groups: ["jia-power"] },
  { slug: "wang-furen", name: ["王夫人", "Lady Wang"], summary: ["端肃的家内权力人物，以道德判断和母职影响宝玉及其身边人。", "A restrained household authority whose moral judgement shapes Baoyu and his attendants."], gender: "female", age: "adult", importance: 5, groups: ["jia-power", "yihong-court"] },
  { slug: "xiren", name: ["袭人", "Xiren"], summary: ["稳妥细致的照护者，在亲密、职业依赖与规训之间寻找位置。", "A steady carer negotiating intimacy, service, dependence, and discipline."], gender: "female", age: "youth", importance: 4, groups: ["yihong-court"] },
  { slug: "qingwen", name: ["晴雯", "Qingwen"], summary: ["灵秀锐利、才性鲜明，在亲近、尊严与权力压力中保持锋芒。", "Brilliant and sharp-witted, maintaining dignity under intimacy and household pressure."], gender: "female", age: "youth", importance: 4, groups: ["yihong-court"] },
] as const;

const chapterDefs = [
  { slug: "arrival", title: ["初入贾府", "Entering the Jia Household"], ref: "第 1–8 回", color: "#A886B8" },
  { slug: "garden", title: ["大观园", "The Grand View Garden"], ref: "第 17–36 回", color: "#73A894" },
  { slug: "fracture", title: ["关系波澜", "Strain and Fracture"], ref: "第 74–80 回", color: "#DD6B74" },
] as const;

const eventDefs = [
  { slug: "daiyu-arrives", chapter: "arrival", seq: 1, title: ["黛玉入府", "Daiyu enters the household"], summary: ["黛玉进入贾府，宝玉、贾母与王夫人的关系网络由此重新排列。", "Daiyu's arrival rearranges the relationships around Baoyu, Grandmother Jia, and Lady Wang."], people: ["jia-baoyu", "lin-daiyu", "jia-mu", "wang-furen"] },
  { slug: "baochai-enters", chapter: "arrival", seq: 2, title: ["宝钗进入核心关系圈", "Baochai enters the central circle"], summary: ["宝钗进入贾府同辈网络，礼法、亲密与家族期待开始交叠。", "Baochai enters the peer network, bringing affection, ritual, and family expectation together."], people: ["jia-baoyu", "xue-baochai", "wang-furen", "jia-mu"] },
  { slug: "garden-companionship", chapter: "garden", seq: 3, title: ["园中相伴", "Companionship in the garden"], summary: ["大观园使同辈交往与日常照护变得更密集。", "The garden intensifies peer companionship and everyday care."], people: ["jia-baoyu", "lin-daiyu", "xue-baochai", "xiren", "qingwen"] },
  { slug: "household-order", chapter: "garden", seq: 4, title: ["家内秩序", "Household order"], summary: ["王熙凤与王夫人的治理关系影响怡红院内外。", "The governing relationship between Wang Xifeng and Lady Wang shapes the Yihong Court."], people: ["wang-xifeng", "wang-furen", "xiren", "jia-baoyu"] },
  { slug: "qingwen-pressure", chapter: "fracture", seq: 5, title: ["晴雯承受压力", "Pressure closes around Qingwen"], summary: ["亲密、流言和家内权力汇合，晴雯的处境急剧恶化。", "Intimacy, rumour, and household power converge, sharply worsening Qingwen's position."], people: ["qingwen", "jia-baoyu", "wang-furen", "xiren"] },
  { slug: "garden-fractures", chapter: "fracture", seq: 6, title: ["园中关系裂变", "The garden network fractures"], summary: ["原本紧密的关系圈在制度压力下发生改变。", "A once-close network changes under institutional pressure."], people: ["jia-baoyu", "lin-daiyu", "xue-baochai", "wang-xifeng", "jia-mu"] },
] as const;

const relationDefs = [
  ["jia-baoyu", "lin-daiyu", "romantic", "mixed", 5, ["知己与深情", "Kindred affection"], ["亲密、敏感与误解共同塑造这段核心关系。", "Intimacy, sensitivity, and misunderstanding shape this central bond."], "daiyu-arrives", null],
  ["jia-baoyu", "xue-baochai", "romantic", "mixed", 4, ["亲近与礼法期待", "Affection and ritual expectation"], ["彼此欣赏与家族期待相互交叠。", "Mutual regard overlaps with household expectation."], "baochai-enters", null],
  ["jia-mu", "jia-baoyu", "family", "positive", 5, ["庇护", "Protection"], ["贾母以长辈权威和情感偏爱保护宝玉。", "Grandmother Jia protects Baoyu through senior authority and affection."], "daiyu-arrives", null],
  ["jia-mu", "lin-daiyu", "family", "positive", 4, ["外祖母与外孙女", "Grandmother and granddaughter"], ["亲属、怜爱与寄居处境构成黛玉的重要支持。", "Kinship and affection provide crucial support within Daiyu's dependent position."], "daiyu-arrives", null],
  ["wang-furen", "jia-baoyu", "family", "mixed", 4, ["母子与规训", "Motherhood and discipline"], ["母爱与道德规训同时存在。", "Maternal care and moral discipline coexist."], "daiyu-arrives", null],
  ["jia-baoyu", "xiren", "care", "positive", 5, ["亲密照护", "Intimate care"], ["日常照护、依赖与规训紧密相连。", "Everyday care, dependence, and discipline are closely entwined."], "garden-companionship", null],
  ["jia-baoyu", "qingwen", "care", "mixed", 4, ["亲近与尊严", "Closeness and dignity"], ["欣赏与亲近无法消除身份带来的风险。", "Affection cannot remove the risks created by status."], "garden-companionship", "qingwen-pressure"],
  ["wang-furen", "xiren", "authority", "mixed", 4, ["认可与代理", "Approval and delegation"], ["王夫人的认可给予袭人位置，也强化规训责任。", "Lady Wang's approval gives Xiren standing while deepening her disciplinary role."], "household-order", null],
  ["wang-furen", "qingwen", "conflict", "negative", 5, ["判断与清退", "Judgement and expulsion"], ["权力判断最终决定晴雯的处境。", "Household judgement ultimately determines Qingwen's fate."], "qingwen-pressure", "qingwen-pressure"],
  ["xiren", "qingwen", "rivalry", "mixed", 3, ["同侍与张力", "Shared service and tension"], ["二人的差异形成照护方式与自我位置的对照。", "Their differences contrast modes of care and self-positioning."], "garden-companionship", null],
  ["jia-mu", "wang-xifeng", "authority", "positive", 5, ["信任与授权", "Trust and delegated authority"], ["贾母的信任是王熙凤治理权的重要来源。", "Grandmother Jia's trust is a major source of Wang Xifeng's authority."], "daiyu-arrives", null],
  ["wang-furen", "wang-xifeng", "alliance", "positive", 4, ["家务同盟", "Household alliance"], ["二人在家务治理和资源安排上形成权力合作。", "They form a governing alliance over household affairs and resources."], "household-order", null],
  ["lin-daiyu", "xue-baochai", "rivalry", "mixed", 4, ["竞争、理解与对照", "Rivalry, understanding, and contrast"], ["竞争并不排除理解，二人的关系随叙事逐渐复杂。", "Rivalry does not exclude understanding; their bond grows more complex."], "baochai-enters", null],
  ["wang-xifeng", "jia-baoyu", "care", "mixed", 3, ["照应与管理", "Care and management"], ["亲族照应与家内管理同时作用于宝玉。", "Kinship care and household management both shape Baoyu's position."], "daiyu-arrives", null],
  ["jia-mu", "wang-furen", "authority", "mixed", 4, ["长辈秩序", "Senior household order"], ["两代女性权威共同维系秩序，也存在判断尺度差异。", "Two generations of female authority sustain order while differing in judgement."], "daiyu-arrives", null],
] as const;

export function redChamberFixture(locale: Locale): Atlas {
  const events = eventDefs.map((event, index) => ({
    id: id(2, index + 1), slug: event.slug, startDate: null, endDate: null, sequence: event.seq,
    reality: "fictional_narrative" as const, eventType: "social", timeType: "relative" as const, calendarSystem: "unknown" as const,
    historicalStartYear: null, historicalEndYear: null, startMonth: null, startDay: null, confidence: "high" as const,
    parentEventSlug: null, chapterSlug: event.chapter, title: pick(event.title, locale), summary: pick(event.summary, locale),
    detail: pick(event.summary, locale), significance: "", timeLabel: locale === "zh-CN" ? `叙事节点 ${event.seq}` : `Narrative node ${event.seq}`,
    locationSlugs: [], characterSlugs: [...event.people], sourceTitles: [locale === "zh-CN" ? "《红楼梦》原著（原型定位）" : "Dream of the Red Chamber (prototype locator)"], routeSlugs: [], ...meta(locale),
  }));
  const characters = people.map((person, index) => {
    const linked = events.filter((event) => event.characterSlugs.includes(person.slug)).map((event) => event.slug);
    return {
      id: id(1, index + 1), slug: person.slug, gender: person.gender, ageStage: person.age, roleType: "protagonist" as const,
      realityType: "fictional" as const, birthYear: null, deathYear: null, birthPlaceSlug: null, deathPlaceSlug: null,
      iconVariant: person.slug === "jia-mu" ? "matriarch" : "person", importance: person.importance, artistSlug: null,
      name: pick(person.name, locale), summary: pick(person.summary, locale), aliases: [], detail: pick(person.summary, locale),
      motivation: "", eventSlugs: linked, locationSlugs: [], sourceTitles: [locale === "zh-CN" ? "《红楼梦》原著" : "Dream of the Red Chamber"],
      groupSlugs: [...person.groups], chapterSlug: null, firstSequence: Math.min(...events.filter((event) => event.characterSlugs.includes(person.slug)).map((event) => event.sequence)),
      lastSequence: Math.max(...events.filter((event) => event.characterSlugs.includes(person.slug)).map((event) => event.sequence)), ...meta(locale),
    };
  });
  const relations = relationDefs.map((relation, index) => ({
    id: id(3, index + 1), fromSlug: relation[0], toSlug: relation[1], relationType: relation[2],
    direction: relation[2] === "authority" ? "source_to_target" as const : "bidirectional" as const,
    sentiment: relation[3], strength: relation[4], status: relation[8] ? "changed" as const : "active" as const,
    startEventSlug: relation[7], endEventSlug: relation[8], label: pick(relation[5], locale), summary: pick(relation[6], locale),
    sourceTitles: [locale === "zh-CN" ? "《红楼梦》原著（原型关系摘要）" : "Dream of the Red Chamber (prototype relation summary)"], ...meta(locale),
  }));
  const chapters = chapterDefs.map((chapter, index) => ({
    id: id(4, index + 1), slug: chapter.slug, sequence: index + 1, referenceLabel: chapter.ref,
    eraStartYear: null, eraEndYear: null, accentColor: chapter.color, title: pick(chapter.title, locale),
    summary: chapter.ref, eventCount: events.filter((event) => event.chapterSlug === chapter.slug).length,
    firstSequence: Math.min(...events.filter((event) => event.chapterSlug === chapter.slug).map((event) => event.sequence)),
    lastSequence: Math.max(...events.filter((event) => event.chapterSlug === chapter.slug).map((event) => event.sequence)),
  }));
  const groupDefs = [
    ["baodai-chai", ["宝黛钗关系核心", "Baoyu–Daiyu–Baochai"], "#E8A0B5", ["jia-baoyu", "lin-daiyu", "xue-baochai"]],
    ["jia-power", ["贾府权力核心", "Jia household authority"], "#D7B46A", ["jia-baoyu", "xue-baochai", "wang-xifeng", "jia-mu", "wang-furen"]],
    ["garden-circle", ["大观园同辈", "Garden peer circle"], "#73A894", ["lin-daiyu", "xue-baochai"]],
    ["yihong-court", ["怡红院照护网络", "Yihong Court care network"], "#7E98BE", ["jia-baoyu", "wang-furen", "xiren", "qingwen"]],
  ] as const;
  return AtlasResponseSchema.parse({
    requestedLocale: locale, detail: "full",
    work: { id: id(8, 1), slug: "dream-of-the-red-chamber", authorName: locale === "zh-CN" ? "曹雪芹" : "Cao Xueqin", publicationYear: null,
      contentMode: "literary_narrative", mapLayer: "fictional", category: "realist_fiction", originRegion: locale === "zh-CN" ? "中国古典小说" : "Classical Chinese fiction",
      chronologyStartYear: null, chronologyEndYear: null, themeColor: "#DD6B74", themeColorDark: "#120F10", themeColorLight: "#F0A29A",
      title: locale === "zh-CN" ? "红楼梦 Atlas · 8 人原型" : "Dream of the Red Chamber Atlas · Eight-person prototype",
      summary: locale === "zh-CN" ? "以人物关系为主舞台的交互原型：聚焦情、礼、权、照护与冲突如何随叙事变化。" : "A relationship-first prototype exploring affection, ritual, power, care, and conflict across the narrative.",
      default_locale: "zh-CN", ...meta(locale) },
    characters, locations: [], events, routes: [], relations,
    sources: [{ id: id(6, 1), title: locale === "zh-CN" ? "《红楼梦》原著与原型编辑说明" : "Dream of the Red Chamber and prototype editorial notes", url: null, citation: locale === "zh-CN" ? "本原型仅使用原创结构化摘要，不代替底本审校。" : "This prototype uses original structured summaries and does not replace edition review.", evidenceGrade: "prototype", sourceType: "primary_text" }],
    chronologies: [{ id: id(7, 1), kind: "narrative", label: locale === "zh-CN" ? "章回顺序" : "Chapter order", startYear: null, endYear: null, calendarSystem: "unknown", isDefault: true }],
    media: [], chapters,
    groups: groupDefs.map((group, index) => ({ id: id(5, index + 1), slug: group[0], groupType: "circle", sortOrder: index + 1, accentColor: group[2], anchorCharacterSlug: group[3][0], name: pick(group[1], locale), summary: "", characterSlugs: [...group[3]] })),
    artists: [], artworks: [], movements: [], institutions: [], musicPeople: [], compositions: [], musicStyles: [], instruments: [],
    musicInstitutions: [], scoreFragments: [], musicLearningUnits: [], shanhaijing: null,
  });
}

export function redChamberWorks(locale: Locale): WorksResponse {
  const atlas = redChamberFixture(locale);
  return WorksResponseSchema.parse({ locale, items: [{
    ...atlas.work, alternateTitle: locale === "zh-CN" ? "石头记" : "The Story of the Stone",
    characterCount: atlas.characters.length, eventCount: atlas.events.length, locationCount: 0,
  }] });
}
