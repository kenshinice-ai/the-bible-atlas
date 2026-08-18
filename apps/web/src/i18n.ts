import { PROFILE } from "./profile";
import type { DepictionStatus, Locale, MediaRole } from "./types";

/**
 * Every enum value the API can return, in both public locales.
 *
 * Before v4 the UI printed raw database enums ("low", "primary_text",
 * "2 sources") straight into a Chinese page. Anything user-visible now has to
 * come through `label()`, and `missingLabels()` is asserted empty in tests so a
 * new enum value cannot quietly reintroduce English.
 */
type Pair = readonly [zh: string, en: string];

const ENUMS: Record<string, Pair> = {
  // person
  male: ["男", "Male"], female: ["女", "Female"], unknown: ["未知", "Unknown"], na: ["不适用", "N/A"],
  child: ["儿童", "Child"], youth: ["青年", "Youth"], adult: ["成年", "Adult"], elder: ["老年", "Elder"],
  protagonist: ["主要人物", "Protagonist"], antagonist: ["对立人物", "Antagonist"], supporting: ["次要人物", "Supporting"],
  narrator: ["叙述者", "Narrator"], historical: ["历史人物", "Historical"], collective: ["群体", "Collective"], supernatural: ["超自然", "Supernatural"],
  fictional: ["虚构", "Fictional"], fictionalised_historical: ["历史基础的文学人物", "Fictionalised historical"],
  // icon variants
  patriarch: ["族长", "Patriarch"], matriarch: ["女族长", "Matriarch"], king: ["王", "King"], queen: ["王后", "Queen"],
  prophet: ["先知", "Prophet"], priest: ["祭司", "Priest"], judge: ["士师", "Judge"], disciple: ["门徒", "Disciple"],
  missionary: ["宣教士", "Missionary"], ruler: ["统治者", "Ruler"], soldier: ["勇士", "Warrior"],
  teacher: ["教师", "Teacher"], lawgiver: ["颁律法者", "Lawgiver"], person: ["人物", "Person"],
  jedi: ["绝地", "Jedi"], sith: ["西斯", "Sith"], droid: ["机器人", "Droid"], pilot: ["飞行员", "Pilot"],
  senator: ["议员", "Senator"], smuggler: ["走私者", "Smuggler"], bounty_hunter: ["赏金猎人", "Bounty hunter"],
  // event type
  birth: ["出生", "Birth"], death: ["死亡", "Death"], meeting: ["会面", "Meeting"], journey: ["行程", "Journey"],
  battle: ["战事", "Battle"], trial: ["审判", "Trial"], imprisonment: ["囚禁", "Imprisonment"], escape: ["逃离", "Escape"],
  marriage: ["婚姻", "Marriage"], betrayal: ["背叛", "Betrayal"], discovery: ["发现", "Discovery"],
  political: ["政治", "Political"], social: ["社会", "Social"], religious: ["敬拜与立约", "Worship & covenant"], migration: ["迁徙", "Migration"], other: ["其他", "Other"],
  composition: ["创作", "Composition"], commission: ["委约", "Commission"], premiere: ["首演", "Premiere"], performance: ["演出", "Performance"],
  publication: ["出版", "Publication"], revision: ["修订", "Revision"], appointment: ["任职", "Appointment"],
  institution_founding: ["机构建立", "Institution founded"], instrument_innovation: ["乐器革新", "Instrument innovation"],
  musical_debate: ["音乐论争", "Musical debate"], festival: ["音乐节", "Festival"], recording: ["录音", "Recording"], revival: ["复兴演出", "Revival"],
  // time
  exact: ["确切", "Exact"], approximate: ["近似", "Approximate"], range: ["范围", "Range"], relative: ["相对", "Relative"],
  fictional_calendar: ["虚构历法", "Fictional calendar"], gregorian: ["公历", "Gregorian"], julian: ["儒略历", "Julian"],
  // confidence
  high: ["高置信", "High confidence"], medium: ["中置信", "Medium confidence"], low: ["低置信", "Low confidence"],
  // event reality
  verified_historical: ["已证实历史", "Verified historical"], reported_historical: ["文献记述历史", "Reported historical"],
  fictional_narrative: ["虚构叙事", "Fictional narrative"], fictional_with_historical_context: ["历史背景的虚构", "Fictional with historical context"],
  legendary_or_mythic: ["传说或神话", "Legendary or mythic"], symbolic_or_dream: ["象征或梦境", "Symbolic or dream"], contested: ["存在争议", "Contested"],
  // location
  country: ["国家", "Country"], region: ["区域", "Region"], city: ["城市", "City"], district: ["城区", "District"],
  street: ["街道", "Street"], building: ["建筑", "Building"], landmark: ["地标", "Landmark"], prison: ["监狱", "Prison"],
  station: ["车站", "Station"], port: ["港口", "Port"], battlefield: ["战场", "Battlefield"], residence: ["住所", "Residence"],
  school: ["学校", "School"], religious_site: ["圣所", "Sanctuary"], fictional_place: ["虚构地点", "Fictional place"], route_node: ["路线节点", "Route node"],
  planet: ["行星", "Planet"], moon: ["卫星", "Moon"], space_station: ["空间站", "Space station"],
  city_centroid: ["城市中心点", "City centroid"], inferred: ["推定", "Inferred"],
  // relations
  bidirectional: ["双向", "Mutual"], source_to_target: ["单向（前者→后者）", "One-way (first → second)"], target_to_source: ["单向（后者→前者）", "One-way (second → first)"],
  positive: ["正面", "Positive"], negative: ["负面", "Negative"], mixed: ["复杂", "Mixed"], neutral: ["中性", "Neutral"],
  active: ["持续", "Active"], ended: ["已结束", "Ended"], changed: ["已改变", "Changed"],
  family: ["亲属", "Family"], spouse: ["配偶", "Spouse"], sibling: ["兄弟姐妹", "Siblings"], ally: ["同盟", "Ally"],
  adversary: ["对立", "Adversary"], mentor: ["师承", "Mentorship"], romantic: ["情感", "Romantic"],
  liege: ["君臣", "Liege and retainer"], double: ["对照人物", "Narrative double"],
  // routes
  documented: ["有据可考", "Documented"], text_explicit: ["文本明示", "Stated in the text"],
  // sources
  primary_text: ["原始文本", "Primary text"], scholarly: ["学术研究", "Scholarly"], reference: ["参考资料", "Reference"],
  map: ["地图", "Map"], image: ["图像", "Image"], primary: ["一手", "Primary"],
  score: ["乐谱", "Score"], instrument_catalog: ["乐器目录", "Instrument catalogue"],
  // work + group
  historical_document: ["历史文献", "Historical document"], historical_fiction: ["历史小说", "Historical fiction"],
  realist_fiction: ["现实主义小说", "Realist fiction"], fantasy: ["奇幻", "Fantasy"], mythic_epic: ["神话史诗", "Mythic epic"], art_history: ["艺术史", "Art history"], music_history: ["音乐史", "Music history"], mythography: ["古籍博物志", "Ancient mythography"],
  workshop: ["工坊", "Workshop"], anonymous_master: ["匿名大师", "Anonymous master"], artist: ["艺术家人物", "Artist person"],
  confirmed: ["已确认", "Confirmed"], attributed: ["归属推定", "Attributed"], destroyed: ["已毁损", "Destroyed"],
  commissioned: ["委托", "Commissioned"], produced: ["创作", "Produced"], completed: ["完成", "Completed"], exhibited: ["展出", "Exhibited"], acquired: ["收藏", "Acquired"], relocated: ["转移", "Relocated"], restored: ["修复", "Restored"],
  dynasty: ["王朝", "Dynasty"], circle: ["群体", "Circle"], tribe: ["支派", "Tribe"], institution: ["机构与势力", "Institution"],
  composer: ["作曲家", "Composer"], performer: ["演奏家", "Performer"], conductor: ["指挥家", "Conductor"], theorist: ["理论家", "Theorist"],
  librettist: ["词作者", "Librettist"], patron: ["赞助人", "Patron"], publisher: ["出版者", "Publisher"], instrument_maker: ["乐器制作者", "Instrument maker"],
  educator: ["教育家", "Educator"], critic: ["评论家", "Critic"],
  mentorship: ["师承", "Mentorship"], influence: ["影响", "Influence"], collaboration: ["合作", "Collaboration"],
  institutional_peer: ["同一音乐网络", "Institutional peers"], aesthetic_opposition: ["审美立场对照", "Aesthetic opposition"], reception_advocacy: ["传播与倡导", "Reception and advocacy"],
  strings: ["弦乐器", "Strings"], woodwinds: ["木管乐器", "Woodwinds"], brass: ["铜管乐器", "Brass"], percussion: ["打击乐器", "Percussion"],
  keyboards: ["键盘乐器", "Keyboards"], plucked_and_early: ["拨弦与早期乐器", "Plucked and early instruments"], voice: ["人声", "Voice"], mechanical_and_electronic: ["机械与电子", "Mechanical and electronic"],
  historical_style: ["历史风格", "Historical style"], national_tradition: ["民族传统", "National tradition"], genre: ["体裁", "Genre"], form: ["曲式", "Form"], technique: ["技术", "Technique"],
  court: ["宫廷", "Court"], conservatory: ["音乐学院", "Conservatory"], ensemble: ["乐团", "Ensemble"], city_network: ["城市网络", "City network"],
  church: ["教堂", "Church"], opera_house: ["歌剧院", "Opera house"], concert_hall: ["音乐厅", "Concert hall"], archive: ["档案馆", "Archive"],
  sketch: ["草稿", "Sketch"], fragment: ["残篇", "Fragment"], lost: ["已散佚", "Lost"], arrangement: ["改编", "Arrangement"],
  common: ["现代五线谱", "Common notation"], mensural: ["量谱记谱", "Mensural notation"], neume: ["纽姆谱示意", "Neume notation"],
  listening: ["聆听", "Listening"], score_reading: ["读谱", "Score reading"], comparison: ["比较", "Comparison"], route: ["路径", "Route"], introductory: ["入门", "Introductory"], intermediate: ["进阶", "Intermediate"], advanced: ["高级", "Advanced"],
  source_marking: ["来源速度标记", "Source tempo marking"], editorial_learning: ["教学速度", "Editorial learning tempo"],
  verified: ["已核验", "Verified"], pending: ["待核验", "Pending"], rejected: ["不采用", "Rejected"],
  resolved: ["已归并", "Resolved"], provisional: ["暂定", "Provisional"], disputed: ["有争议", "Disputed"], superseded: ["已替代", "Superseded"],
  mountain: ["山", "Mountain"], mountain_range: ["山系", "Mountain range"], river: ["水", "River"], water_source: ["水源", "Water source"], marsh: ["泽", "Marsh"], sea: ["海", "Sea"],
  text_direct: ["原文直证", "Direct text"], transcription: ["原文转录", "Transcription"], editorial_summary: ["编辑归纳", "Editorial synthesis"], scholarly_hypothesis: ["学术假说", "Scholarly hypothesis"], artistic_interpretation: ["艺术演绎", "Artistic interpretation"],
  blocked_missing_api_key: ["待生成（缺少 API 密钥）", "Awaiting generation (API key missing)"], generated: ["已生成待审", "Generated, awaiting review"], withdrawn: ["已撤回", "Withdrawn"],
  // translation status
  draft: ["草稿", "Draft"], reviewed: ["已审阅", "Reviewed"], published: ["已发布", "Published"],
};

/** Translate one API enum value. Unknown values degrade to a readable form. */
export function label(value: string | null | undefined, locale: Locale): string {
  if (!value) return locale === "zh-CN" ? "未标注" : "Not recorded";
  const pair = ENUMS[value];
  if (pair) return pair[locale === "zh-CN" ? 0 : 1];
  return value.replaceAll("_", " ");
}

/** Test hook: any value here would render as raw English in the zh-CN UI. */
export function missingLabels(values: readonly string[]): string[] {
  return values.filter((value) => !(value in ENUMS));
}

/** Era naming for atlases that do not count years from the Common Era. */
export type YearLabels = { negative: readonly [string, string]; positive: readonly [string, string] };

/**
 * A signed year as readers of this atlas name it.
 *
 * Signed integers are the only chronology the engine understands, so a work
 * with its own epoch (a fictional calendar, say) supplies `labels` and the
 * sign is rendered in that work's terms instead of BCE/CE.
 *
 * The active profile's labels are the default rather than something each call
 * site passes in: six call sites reach this function without a curated
 * `time_label` to prefer, and one of them forgetting would have a galaxy-scale
 * atlas quietly announcing that its events happened BCE.
 */
export function formatYear(year: number, locale: Locale, labels: YearLabels | undefined = PROFILE.yearLabels): string {
  const index = locale === "zh-CN" ? 0 : 1;
  if (labels) {
    if (year === 0) return labels.positive[index].replace("{n}", "0");
    const template = year < 0 ? labels.negative[index] : labels.positive[index];
    return template.replace("{n}", String(Math.abs(year)));
  }
  if (year === 0) return locale === "zh-CN" ? "公元纪元分界" : "BCE/CE boundary";
  const absolute = Math.abs(year);
  if (year < 0) return locale === "zh-CN" ? `公元前 ${absolute} 年` : `${absolute} BCE`;
  return locale === "zh-CN" ? `公元 ${absolute} 年` : `${absolute} CE`;
}

/**
 * A human date for an event. Prefers the curated bilingual `timeLabel`, then
 * derives one from the signed year range, and never turns a range into a point.
 */
export function formatEventTime(
  event: { timeLabel: string; timeType: string; historicalStartYear: number | null; historicalEndYear: number | null },
  locale: Locale,
): string {
  if (event.timeLabel) return event.timeLabel;
  const { historicalStartYear: start, historicalEndYear: end } = event;
  if (start === null) return locale === "zh-CN" ? "年代不详（仅叙事顺序）" : "Undated (narrative order only)";
  const circa = event.timeType === "approximate" || event.timeType === "range";
  const prefix = circa ? (locale === "zh-CN" ? "约" : "c. ") : "";
  if (end === null || end === start) return `${prefix}${formatYear(start, locale)}`;
  return `${prefix}${formatYear(start, locale)} – ${formatYear(end, locale)}`;
}

export function formatCount(count: number, kind: "characters" | "artists" | "artworks" | "movements" | "events" | "locations" | "routes" | "relations" | "sources", locale: Locale): string {
  const nouns = {
    characters: ["人物", "people"], artists: ["艺术家", "artists"], artworks: ["作品", "artworks"], movements: ["流派", "movements"], events: ["事件", "events"], locations: ["地点", "places"],
    routes: ["路线", "routes"], relations: ["关系", "relations"], sources: ["来源", "sources"],
  } as const;
  const noun = nouns[kind][locale === "zh-CN" ? 0 : 1];
  return locale === "zh-CN" ? `${count} ${noun}` : `${count} ${noun}`;
}

const ORIGIN_REGIONS: Record<string, Pair> = {
  "Ancient Near East / Mediterranean": ["古代近东 / 地中海", "Ancient Near East / Mediterranean"],
  "Ancient China / textual cosmography": ["古代中国 / 文本宇宙地理", "Ancient China / textual cosmography"],
};

/** Localise the small set of canonical geographic labels stored on works. */
export function originRegionLabel(region: string, locale: Locale): string {
  const pair = ORIGIN_REGIONS[region];
  return pair?.[locale === "zh-CN" ? 0 : 1] ?? region;
}

const BIBLE_BOOK_LABELS: readonly (readonly [string, string])[] = [
  ["Genesis", "创世记"], ["Exodus", "出埃及记"], ["Leviticus", "利未记"], ["Numbers", "民数记"], ["Deuteronomy", "申命记"],
  ["Joshua", "约书亚记"], ["Judges", "士师记"], ["Ruth", "路得记"], ["Samuel", "撒母耳记"], ["Kings", "列王纪"], ["Chronicles", "历代志"],
  ["Ezra", "以斯拉记"], ["Nehemiah", "尼希米记"], ["Esther", "以斯帖记"], ["Job", "约伯记"], ["Psalms", "诗篇"], ["Proverbs", "箴言"],
  ["Isaiah", "以赛亚书"], ["Jeremiah", "耶利米书"], ["Ezekiel", "以西结书"], ["Daniel", "但以理书"], ["Hosea", "何西阿书"], ["Joel", "约珥书"],
  ["Amos", "阿摩司书"], ["Obadiah", "俄巴底亚书"], ["Jonah", "约拿书"], ["Micah", "弥迦书"], ["Nahum", "那鸿书"], ["Habakkuk", "哈巴谷书"],
  ["Zephaniah", "西番雅书"], ["Haggai", "哈该书"], ["Zechariah", "撒迦利亚书"], ["Malachi", "玛拉基书"], ["Matthew", "马太福音"], ["Mark", "马可福音"],
  ["Luke", "路加福音"], ["John", "约翰福音"], ["Acts", "使徒行传"], ["Romans", "罗马书"], ["Corinthians", "哥林多书"], ["Revelation", "启示录"],
];

/** Keep chapter/source reference labels from leaking English into zh-CN. */
export function referenceLabel(value: string, locale: Locale): string {
  if (locale !== "zh-CN") return value;
  return BIBLE_BOOK_LABELS.reduce((result, [english, chinese]) => result.split(english).join(chinese), value);
}

const MEDIA_ROLE_LABELS: Record<MediaRole, Pair> = {
  character_depiction: ["人物形象", "Character depiction"],
  place_view: ["地点影像", "Place view"],
  event_scene: ["事件场景", "Event scene"],
  artwork: ["作品图像", "Artwork image"],
  map: ["地图资料", "Map reference"],
  other: ["视觉资料", "Visual reference"],
};

const MEDIA_STATUS_LABELS: Record<DepictionStatus, Pair> = {
  illustrative: ["艺术性示意", "Illustrative"],
  documentary: ["现代地点记录", "Documentary site view"],
  cartographic: ["制图资料", "Cartographic"],
  unknown: ["未分类", "Unclassified"],
};

export function mediaRoleLabel(role: MediaRole, locale: Locale): string { return MEDIA_ROLE_LABELS[role][locale === "zh-CN" ? 0 : 1]; }
export function depictionStatusLabel(status: DepictionStatus, locale: Locale): string { return MEDIA_STATUS_LABELS[status][locale === "zh-CN" ? 0 : 1]; }

/** All fixed interface strings. Keeping them in one table makes gaps obvious. */
export const UI = {
  title: ["圣经舆图", "The Bible Atlas"],
  tagline: ["从起初,直到地极", "From the Beginning to the Ends of the Earth"],
  loading: ["载入中", "Loading"],
  error: ["加载失败", "Load failed"],
  retry: ["重试", "Retry"],
  characters: ["人物", "People"], events: ["事件", "Events"], locations: ["地点", "Places"],
  routes: ["路线", "Routes"], relations: ["关系", "Relations"], artists: ["艺术家", "Artists"], artworks: ["作品", "Artworks"], movements: ["流派", "Movements"],
  compositions: ["曲目", "Compositions"], instruments: ["乐器", "Instruments"], scoreFragments: ["乐谱片段", "Score excerpts"], musicInstitutions: ["音乐机构", "Music institutions"],
  overview: ["艺术总览", "Overview"], creatures: ["异兽与生灵", "Creatures"], passages: ["原文段落", "Passages"], textualPlaces: ["山川路线", "Textual places"],
  musicStudy: ["学习路径", "Study paths"], learningPath: ["学习路径", "Learning path"], catalog: ["音乐目录", "Music catalogue"], targetMinutes: ["目标时长", "Target time"], studyOpenComposition: ["打开曲目", "Open composition"], studyOpenFragment: ["打开乐谱片段", "Open score excerpt"],
  creationPlace: ["创作地点", "Creation place"], currentLocation: ["现藏地点", "Current collection"], medium: ["媒介", "Medium"],
  artworkDescription: ["作品简介", "About this work"],
  artworkImage: ["作品展示图", "Artwork image"], imageAttribution: ["图片归属", "Image attribution"], viewSource: ["查看来源页", "View source page"],
  visualReference: ["视觉参考", "Visual reference"], illustrativeMediaNote: ["艺术性诠释，不是历史肖像或现场记录。", "Artistic depiction; not a historical portrait or eyewitness record."],
  documentaryMediaNote: ["现代地点影像，不等同于古代场景。", "Present-day site view; not an ancient scene."], cartographicMediaNote: ["制图辅助资料，不是实体照片。", "Cartographic aid; not a physical photograph."],
  unclassifiedMediaNote: ["媒体性质尚未分类。", "Media context is not classified."],
  externalImageNote: ["图片由来源站点托管，本图集不复制该文件。", "The provider hosts this image; this atlas does not redistribute the file."],
  imageUnavailable: ["暂无可再发布的图片；请打开来源页查看。", "No redistributable image is available; open the source page to view it."],
  formalTitles: ["正式爵位或荣誉称号", "Formal rank or honorific"],
  sources: ["出处与数据说明", "Sources and data notes"],
  copy: ["复制此景链接", "Copy link to this view"], copied: ["已复制", "Copied"],
  single: ["单部探索", "Single work"], multi: ["多部对照", "Compare works"],
  primary: ["主作品", "Primary"], limitReached: ["已达 5 部上限；请先移除一部。", "Five-work limit reached; remove one first."],
  keepOne: ["至少需要保留一部作品。", "At least one work must stay selected."],
  mixedLayers: ["现实作品与虚构作品不能叠加在同一地图层", "Real and fictional works cannot share one map layer"],
  unknownWork: ["深链接中包含未知作品", "The deep link contains an unknown work"],
  multiHint: ["地图叠加已选作品；人物、事件、关系与叙事顺序跟随主作品。", "The map overlays selected works; people, events, relations and narrative order follow the primary work."],
  workPicker: ["作品控制中心", "Work control centre"],
  searchWorks: ["搜索名称、作者、地区、年代或类型", "Search title, author, region, era, or type"],
  allCategories: ["全部类型", "All categories"],
  searchEverything: ["寻访人物、艺术家、作品、事件与地点…", "Search people, artists, artworks, events and places…"],
  kindWork: ["作品集", "Work"], kindCharacter: ["人物", "Person"], kindEvent: ["事件", "Event"], kindLocation: ["地点", "Place"], kindArtist: ["艺术家", "Artist"], kindArtwork: ["作品", "Artwork"], kindMovement: ["流派", "Movement"], kindInstitution: ["机构", "Institution"],
  kindComposition: ["曲目", "Composition"], kindMusicStyle: ["音乐风格", "Music style"], kindInstrument: ["乐器", "Instrument"], kindMusicInstitution: ["音乐机构", "Music institution"], kindScoreFragment: ["乐谱片段", "Score excerpt"],
  kindCreature: ["异兽", "Creature"], kindPassage: ["原文段落", "Passage"], kindTextualPlace: ["文本地点", "Textual place"],
  noResults: ["没有匹配结果", "No matches"],
  clear: ["清除", "Clear"],
  clearFilters: ["清除全部筛选", "Clear all filters"],
  // map
  mapLayers: ["地图图层", "Map layers"],
  places: ["地点", "Places"], landmarks: ["地标", "Landmarks"],
  fitAll: ["回看全境", "Fit the whole land"],
  legend: ["图例", "Legend"],
  uncertainCoordinate: ["推定或近似坐标", "Inferred or approximate coordinate"],
  exactCoordinate: ["实测坐标", "Surveyed coordinate"],
  clusterHint: ["点击展开该区域", "Click to expand this area"],
  trajectory: ["人物行迹", "Person's journeys"],
  showTrajectory: ["显示所选人物的行迹", "Show the selected person's journeys"],
  markerSize: ["标记大小对应人物/事件密度", "Marker size follows how much happens there"],
  // timeline
  timeline: ["时间轴", "Timeline"],
  historyMode: ["历史时间", "Historical time"], narrativeMode: ["叙事顺序", "Narrative order"],
  fullRange: ["完整范围", "Full range"],
  eraBands: ["时代", "Eras"],
  datedEvents: ["有年代事件", "dated events"],
  brushHint: ["在轴上拖动可框选时间范围", "Drag across the axis to select a range"],
  undated: ["年代不详", "Undated"],
  undatedNote: ["以下事件没有历史年代，只出现在叙事顺序中", "These events carry no historical year and appear only in narrative order"],
  collapse: ["收起", "Collapse"],
  // graph
  graphLevelEra: ["时代", "Eras"], graphLevelGroup: ["群体", "Groups"], graphLevelMajor: ["核心人物", "Key people"], graphLevelAll: ["全部人物", "Everyone"],
  graphZoomHint: ["滚轮缩放；放大自动展开到更细的层级", "Scroll to zoom; zooming in expands to a finer tier"],
  graphReset: ["重置视图", "Reset view"],
  graphAsTable: ["以表格显示", "Show as table"],
  graphAsGraph: ["以关系图显示", "Show as graph"],
  adjacencyFrom: ["人物 A", "Person A"], adjacencyTo: ["人物 B", "Person B"],
  adjacencyKind: ["关系", "Relation"], adjacencyStrength: ["强度", "Strength"], adjacencySentiment: ["情感", "Sentiment"],
  directOnly: ["只看直接关系", "Direct relations only"], showAll: ["显示全部", "Show all"],
  nodes: ["节点", "nodes"], edges: ["连线", "edges"],
  hiddenAtTier: ["人在当前层级未显示", "people hidden at this tier"],
  showEveryone: ["显示全部人物", "Show everyone"],
  dragHint: ["拖动节点可固定位置；双击已固定的节点可释放", "Drag a node to pin it; double-click a pinned node to release"],
  // drawer + detail
  close: ["关闭", "Close"],
  aliases: ["又名", "Also called"],
  lifeRange: ["生卒年代", "Life range"],
  birthPlace: ["出生地", "Birthplace"], deathPlace: ["逝世地", "Place of death"],
  motivation: ["人物动机", "Motivation"],
  significance: ["经文意义", "Significance in Scripture"],
  literarySignificance: ["经文脉络", "Scriptural context"],
  historicalBackground: ["历史背景", "Historical background"],
  modernStatus: ["今日现状", "Present day"],
  historicalRegion: ["历史区域", "Historical region"],
  coordinates: ["坐标", "Coordinates"],
  coordinateQuality: ["坐标精度", "Coordinate precision"],
  stillExists: ["现今仍存", "Still exists"],
  yes: ["是", "Yes"], no: ["否", "No"],
  era: ["所属时代", "Era"],
  groups: ["所属群体", "Groups"],
  parentEvent: ["上级事件", "Parent event"],
  childEvents: ["子事件", "Sub-events"],
  prevEvent: ["上一事件", "Previous event"],
  nextEvent: ["下一事件", "Next event"],
  people: ["参与人物", "People"],
  relatedEvents: ["相关事件", "Related events"],
  relatedPlaces: ["相关地点", "Related places"],
  relatedRoutes: ["相关路线", "Related routes"],
  keyRelations: ["重要关系", "Key relations"],
  locateOnMap: ["在地图中定位", "Locate on map"],
  openGraph: ["查看关系图", "Open relationship graph"],
  waypoints: ["途经节点", "Waypoints"],
  direction: ["方向", "Direction"], sentiment: ["情感", "Sentiment"], strength: ["强度", "Strength"], status: ["状态", "Status"],
  relationLifecycle: ["关系起止", "Relation lifecycle"],
  from: ["自", "from"], to: ["至", "to"],
  // filters
  filterByEra: ["按时代筛选", "Filter by era"],
  allEras: ["全部时代", "All eras"],
  narrativeUpTo: ["叙事进度", "Narrative progress"],
  showAllNarrative: ["显示全部叙事", "Show the whole narrative"],
  activeFilters: ["当前筛选", "Active filters"],
  showing: ["显示", "Showing"],
  ofTotal: ["共", "of"],
  emptyList: ["当前筛选没有内容", "Nothing matches the current filter"],
  dataNote: ["凡近似年代与推定地点均已明确标注;摘要为原创结构化描述,悉以经文记载为本。", "Uncertain dates and inferred places are explicitly marked; summaries are original structured descriptions following the scriptural record."],
  epigraphSourceSuffix: ["(和合本)", "(KJV)"],
  scriptureNote: ["经文引用:中文和合本(1919),英文 King James Version;均为公有领域译本。", "Scripture quotations: Chinese Union Version (1919) and King James Version, both in the public domain."],
  fallbackUsed: ["此条目使用了作品默认语言", "This entry falls back to the work’s default language"],
} as const;

export type UIKey = keyof typeof UI;
export function t(key: UIKey, locale: Locale): string { return UI[key][locale === "zh-CN" ? 0 : 1]; }
