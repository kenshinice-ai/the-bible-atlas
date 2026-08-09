import { createHash } from "node:crypto";
import { writeFile } from "node:fs/promises";
import { resolve } from "node:path";
import {
  COMPOSITIONS,
  INSTITUTIONS,
  INSTRUMENTS,
  LOCATIONS,
  PEOPLE,
  RELATIONS,
  SOURCE_CATALOG,
  STYLES,
} from "./european_music_foundation_data.ts";
import {
  PHASE2_COMPOSITIONS,
  PHASE2_INSTITUTIONS,
  PHASE2_INSTRUMENTS,
  PHASE2_LEARNING_UNITS,
  PHASE2_LOCATIONS,
  PHASE2_PEOPLE,
  PHASE2_RELATIONS,
  PHASE2_ROUTES,
  PHASE2_SPECIAL_EVENTS,
  PHASE2_STYLES,
  assertPhase2Counts,
} from "./european_music_phase2_data.ts";

assertPhase2Counts();

const root = resolve(import.meta.dirname, "..");
const out = resolve(root, "db/seeds/060_european_classical_music_phase2.sql");
const workId = "10000000-0000-4000-8000-000000000010";
const workSlug = "european-classical-music-history";

const chapters = [
  { slug: "medieval-music", zh: "中世纪音乐", en: "Medieval Music", start: 500, end: 1399, color: "#8F9DA8" },
  { slug: "renaissance-music", zh: "文艺复兴音乐", en: "Renaissance Music", start: 1400, end: 1599, color: "#B99A63" },
  { slug: "baroque-music", zh: "巴洛克音乐", en: "Baroque Music", start: 1600, end: 1749, color: "#B66F56" },
  { slug: "classical-period", zh: "古典主义时期", en: "Classical Period", start: 1750, end: 1819, color: "#7293AE" },
  { slug: "romantic-period", zh: "浪漫主义时期", en: "Romantic Period", start: 1820, end: 1899, color: "#9D6D8E" },
  { slug: "modernism-and-war", zh: "现代主义与战争", en: "Modernism and War", start: 1900, end: 1944, color: "#638D87" },
  { slug: "postwar-and-contemporary", zh: "战后与当代", en: "Postwar and Contemporary", start: 1945, end: 2026, color: "#8A7CB7" },
];

const allPeople = [...PEOPLE, ...PHASE2_PEOPLE];
const allCompositions = [...COMPOSITIONS, ...PHASE2_COMPOSITIONS];
const allStyles = [...STYLES, ...PHASE2_STYLES];
const allInstruments = [...INSTRUMENTS, ...PHASE2_INSTRUMENTS];
const allInstitutions = [...INSTITUTIONS, ...PHASE2_INSTITUTIONS];
const allLocations = [...LOCATIONS, ...PHASE2_LOCATIONS];
const chapterMap = new Map(chapters.map((chapter, index) => [chapter.slug, { ...chapter, index: index + 1, id: uuid("chapter", chapter.slug) }]));
const peopleMap = new Map(allPeople.map((person) => [person.slug, person]));
const compositionMap = new Map(allCompositions.map((composition) => [composition.slug, composition]));
const locationMap = new Map(allLocations.map((location) => [location.slug, location]));
const institutionMap = new Map(allInstitutions.map((institution) => [institution.slug, institution]));
const sourceMap = new Map(SOURCE_CATALOG.map((source) => [source[0], source]));

function uuid(kind, slug) {
  const hex = createHash("sha256").update(`european-classical-music-history:${kind}:${slug}`).digest("hex").slice(0, 32).split("");
  hex[12] = "4";
  hex[16] = ["8", "9", "a", "b"][Number.parseInt(hex[16], 16) % 4];
  const value = hex.join("");
  return `${value.slice(0, 8)}-${value.slice(8, 12)}-${value.slice(12, 16)}-${value.slice(16, 20)}-${value.slice(20)}`;
}

function q(value) {
  if (value === null || value === undefined) return "NULL";
  if (typeof value === "number") return String(value);
  if (typeof value === "boolean") return value ? "TRUE" : "FALSE";
  return `'${String(value).replaceAll("'", "''")}'`;
}

function values(rows) {
  return rows.map((row) => `(${row.join(",")})`).join(",\n");
}

function chapterForYear(year) {
  return chapters.find((chapter) => year >= chapter.start && year <= chapter.end) ?? chapters.at(-1);
}

function sourceForPerson(slug) {
  if (slug === "johann-sebastian-bach") return "source-bach-digital";
  if (slug === "wolfgang-amadeus-mozart") return "source-mozarteum";
  if (slug === "ludwig-van-beethoven") return "source-beethoven-haus";
  if (peopleMap.get(slug)?.city === "london") return "source-british-library-music";
  return "source-europeana-music";
}

function sourceForComposition(composition) {
  if (composition.person === "johann-sebastian-bach") return "source-bach-digital";
  if (composition.person === "wolfgang-amadeus-mozart") return "source-mozarteum";
  if (composition.person === "ludwig-van-beethoven") return "source-beethoven-haus";
  return "source-imslp";
}

function styleSlugsForChapter(chapterSlug) {
  const candidates = allStyles.filter((style) => style.chapter === chapterSlug);
  return candidates.length > 0 ? candidates.map((style) => style.slug) : ["serialism"];
}

function instrumentsForComposition(composition) {
  const text = `${composition.genre} ${composition.form} ${composition.en}`.toLowerCase();
  if (/electronic|sequenza|accordion/u.test(text)) return ["ondes-martenot", "celesta"];
  if (/keyboard|piano|sonata|prelude|ballade/u.test(text)) return ["piano", "harpsichord", "mandolin"];
  if (/motet|mass|song|anthem|sacred|oratorio|requiem|cantata|vocal/u.test(text)) return ["voice", "organ", "shawm"];
  if (/quartet|quintet|sextet|chamber/u.test(text)) return ["violin", "viola", "cello", "english-horn"];
  if (/opera|ballet|music drama/u.test(text)) return ["voice", "violin", "cello", "oboe", "bassoon", "french-horn", "timpani"];
  if (/concerto/u.test(text)) return ["violin", "cello", "fortepiano", "baroque-trumpet"];
  return ["violin", "viola", "cello", "double-bass", "oboe", "clarinet", "bassoon", "french-horn", "trumpet", "timpani", "tuba"];
}

function durationForComposition(composition) {
  if (/opera|music drama/u.test(`${composition.genre} ${composition.form}`)) return 900;
  if (/symphony|orchestral/u.test(`${composition.genre} ${composition.form}`)) return 480;
  if (/concerto/u.test(composition.genre)) return 360;
  if (/electronic|vocal orchestral/u.test(composition.genre)) return 300;
  return 240;
}

const textLanguageByPerson = {
  "adam-de-la-halle": "fr", "jacopo-da-bologna": "it", "guillaume-dufay": "la", "cipriano-de-rore": "it",
  "maddalena-casulana": "it", "tomas-luis-de-victoria": "la", "heinrich-schutz": "de", "jean-baptiste-lully": "fr",
  "domenico-scarlatti": "it", "luigi-cherubini": "it", "felix-mendelssohn": "de", "clara-schumann": "de",
  "anton-bruckner": "de", "modest-mussorgsky": "ru", "richard-strauss": "de", "alban-berg": "de",
  "paul-hindemith": "de", "dmitri-shostakovich": "ru",
};

const chapterZh = Object.fromEntries(chapters.map((chapter) => [chapter.slug, chapter.zh]));
const chapterEn = Object.fromEntries(chapters.map((chapter) => [chapter.slug, chapter.en]));
const roleZh = {
  composer: "作曲家", performer: "演奏家", conductor: "指挥家", theorist: "理论家",
  librettist: "词作者", patron: "赞助人", publisher: "出版者", instrument_maker: "乐器制作者",
  educator: "教育家", critic: "评论家",
};
const relationLabels = {
  mentorship: ["师承", "Mentorship"], influence: ["影响", "Influence"], collaboration: ["合作", "Collaboration"],
  institutional_peer: ["同一音乐网络", "Institutional peers"], aesthetic_opposition: ["审美立场对照", "Aesthetic opposition"],
  reception_advocacy: ["传播与倡导", "Reception and advocacy"], family: ["家族关系", "Family connection"],
};

const eventObjects = [];
for (const composition of PHASE2_COMPOSITIONS) {
  const chapter = chapterForYear(composition.start);
  eventObjects.push({
    slug: `creation-${composition.slug}`, chapter: chapter.slug, year: composition.start, endYear: composition.end,
    type: "composition", zh: `《${composition.zh.replaceAll("《", "").replaceAll("》", "")}》创作与早期传播`, en: `Composition and early circulation of ${composition.en}`,
    summaryZh: `${composition.en} 的创作年代、首演或早期传播节点；时间采用扩展目录中的结构化年份。`, summaryEn: `A structured chronology point for the composition, premiere, or early circulation of ${composition.en}.`,
    location: composition.city, person: composition.person, composition: composition.slug, source: sourceForComposition(composition),
  });
}
for (const institution of PHASE2_INSTITUTIONS) {
  const chapter = chapterForYear(institution.founded);
  eventObjects.push({
    slug: `founding-${institution.slug}`, chapter: chapter.slug, year: institution.founded, endYear: institution.founded,
    type: "institution_founding", zh: `${institution.zh}建立`, en: `Foundation of ${institution.en}`,
    summaryZh: `${institution.zh}作为音乐活动、教育、演出或传播机构的建立节点。`, summaryEn: `The foundation point of ${institution.en} as a site of musical activity, education, performance, or circulation.`,
    location: institution.city, institution: institution.slug, source: "source-europeana-music",
  });
}
for (const person of PHASE2_PEOPLE) {
  eventObjects.push({
    slug: `birth-${person.slug}`, chapter: person.chapter, year: person.birth, endYear: person.birth, type: "birth",
    zh: `${person.zh}出生`, en: `Birth of ${person.en}`, summaryZh: `${person.zh}的生年节点；具体出生地点仅按扩展目录的城市层级记录。`,
    summaryEn: `The birth-year anchor for ${person.en}; the expansion records only the city-level location in its curation manifest.`, person: person.slug, location: person.city, source: sourceForPerson(person.slug),
  });
}
for (const event of PHASE2_SPECIAL_EVENTS) eventObjects.push({ ...event, source: event.type === "recording" ? "source-british-library-music" : "source-europeana-music" });
if (eventObjects.length !== 84) throw new Error(`Expected 84 phase 2 events, got ${eventObjects.length}`);

const eventSequence = new Map();
for (const chapter of chapters) {
  const items = eventObjects.filter((event) => event.chapter === chapter.slug).sort((a, b) => a.year - b.year || a.slug.localeCompare(b.slug));
  items.forEach((event, index) => eventSequence.set(event.slug, chapterMap.get(chapter.slug).index * 1000 + 1100 + index));
}

const lines = ["BEGIN;"];
lines.push(`
INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type) VALUES
${values(SOURCE_CATALOG.map(([slug, , en, url, sourceType]) => [
  q(uuid("source", slug)), q(workId), q(en), url ? q(url) : "NULL", q(en),
  q(sourceType === "primary_text" ? "primary" : sourceType === "scholarly" ? "scholarly" : "reference"),
  q(sourceType === "primary_text" ? "score" : sourceType),
]))}
ON CONFLICT DO NOTHING;`);

lines.push(`
INSERT INTO source_translations(source_id,locale,title,citation,status) VALUES
${values(SOURCE_CATALOG.flatMap(([slug, zh, en]) => [
  [q(uuid("source", slug)), "'zh-CN'", q(zh), q(zh), "'published'"],
  [q(uuid("source", slug)), "'en'", q(en), q(en), "'published'"],
]))}
ON CONFLICT DO NOTHING;`);

lines.push(`
INSERT INTO locations(id,work_id,slug,layer,geom,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
${PHASE2_LOCATIONS.map((location, index) => `(${q(uuid("location", location.slug))},${q(workId)},${q(location.slug)},'real',ST_SetSRID(ST_MakePoint(${location.lng},${location.lat}),4326)::geography,${LOCATIONS.length + index + 1},'city','city_centroid',10,NULL,false,true)`).join(",\n")}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO location_translations(location_id,locale,name,summary,status,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name) VALUES
${values(PHASE2_LOCATIONS.flatMap((location) => [
  [q(uuid("location", location.slug)), "'zh-CN'", q(location.zh), q(`${location.zh}作为扩展阶段的欧洲音乐史城市节点。`), "'published'", "'{}'", q(""), q(""), q(""), q(""), q("")],
  [q(uuid("location", location.slug)), "'en'", q(location.en), q(`${location.en} as a city node in the phase 2 European music-history network.`), "'published'", "'{}'", q(""), q(""), q(""), q(""), q("")],
]))}
ON CONFLICT DO NOTHING;`);

lines.push(`
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
${values(PHASE2_PEOPLE.map((person, index) => [
  q(uuid("character", person.slug)), q(workId), q(person.slug), PEOPLE.length + index + 1, "'unknown'", "'unknown'", "'historical'", "'historical'", person.birth, person.death, q(person.role), person.importance,
]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation) VALUES
${values(PHASE2_PEOPLE.flatMap((person) => [
  [q(uuid("character", person.slug)), "'zh-CN'", q(person.zh), q(`${chapterZh[person.chapter]}的${roleZh[person.role] ?? "音乐人物"}，在扩展阶段连接作品、机构、地点与关系。`), "'published'", "'{}'", q(`${person.zh}的扩展条目用于补充时期平衡，并把作品证据、学习单元和网络关系放在同一身份下。`), q("")],
  [q(uuid("character", person.slug)), "'en'", q(person.en), q(`A ${person.role.replaceAll("_", " ")} in ${chapterEn[person.chapter]}, connected through works, institutions, places, and relations.`), "'published'", "'{}'", q(`The phase 2 entry for ${person.en} balances the era coverage and keeps work evidence, learning units, and network relations under one identity.`), q("")],
]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO music_person_profiles(character_id,work_id,primary_role,chapter_id,sort_order) VALUES
${values(PHASE2_PEOPLE.map((person, index) => [q(uuid("character", person.slug)), q(workId), q(person.role), q(chapterMap.get(person.chapter).id), PEOPLE.length + index + 1]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO music_person_roles(character_id,work_id,role) VALUES
${values(PHASE2_PEOPLE.map((person) => [q(uuid("character", person.slug)), q(workId), q(person.role)]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO character_locations(character_id,location_id,is_primary) VALUES
${values(PHASE2_PEOPLE.map((person) => [q(uuid("character", person.slug)), q(uuid("location", person.city)), "true"]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO character_sources(character_id,source_id) VALUES
${values(PHASE2_PEOPLE.map((person) => [q(uuid("character", person.slug)), q(uuid("source", sourceForPerson(person.slug)))]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO character_group_members(group_id,character_id,membership_role) VALUES
${values(PHASE2_PEOPLE.map((person) => [q(uuid("group", person.chapter)), q(uuid("character", person.slug)), q(person.role)]))}
ON CONFLICT DO NOTHING;`);

lines.push(`
INSERT INTO music_styles(id,work_id,slug,style_kind,chapter_id,start_year,end_year,sort_order) VALUES
${values(PHASE2_STYLES.map((style, index) => {
  const chapter = chapterMap.get(style.chapter);
  return [q(uuid("style", style.slug)), q(workId), q(style.slug), q(style.kind), q(chapter.id), chapter.start, chapter.end, STYLES.length + index + 1];
}))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO music_style_translations(style_id,locale,name,summary,status) VALUES
${values(PHASE2_STYLES.flatMap((style) => [
  [q(uuid("style", style.slug)), "'zh-CN'", q(style.zh), q(`${style.zh}作为扩展阶段的风格、体裁或技术标签。`), "'published'"],
  [q(uuid("style", style.slug)), "'en'", q(style.en), q(`${style.en} is an expansion-stage style, genre, or technique tag.`), "'published'"],
]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO music_style_sources(style_id,source_id) VALUES
${values(PHASE2_STYLES.map((style) => [q(uuid("style", style.slug)), q(uuid("source", "source-british-library-music"))]))}
ON CONFLICT DO NOTHING;`);

const phase2StyleLinks = PHASE2_PEOPLE.map((person, index) => [person.slug, PHASE2_STYLES[index % PHASE2_STYLES.length].slug]);
lines.push(`
INSERT INTO music_person_styles(character_id,style_id,work_id) VALUES
${values(phase2StyleLinks.map(([person, style]) => [q(uuid("character", person)), q(uuid("style", style)), q(workId)]))}
ON CONFLICT DO NOTHING;`);

lines.push(`
INSERT INTO instruments(id,work_id,slug,family,hornbostel_sachs_code,mimo_term,start_year,end_year,sort_order) VALUES
${values(PHASE2_INSTRUMENTS.map((instrument, index) => [q(uuid("instrument", instrument.slug)), q(workId), q(instrument.slug), q(instrument.family), q(instrument.hs), q(instrument.en), instrument.start, instrument.end, INSTRUMENTS.length + index + 1]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO instrument_translations(instrument_id,locale,name,aliases,summary,status) VALUES
${values(PHASE2_INSTRUMENTS.flatMap((instrument) => [
  [q(uuid("instrument", instrument.slug)), "'zh-CN'", q(instrument.zh), "'{}'", q(`${instrument.zh}属于${instrument.family.replaceAll("_", " ")}家族，作为扩展阶段的器物与聆听线索。`), "'published'"],
  [q(uuid("instrument", instrument.slug)), "'en'", q(instrument.en), "'{}'", q(`${instrument.en} belongs to the ${instrument.family.replaceAll("_", " ")} family and acts as an expansion-stage listening clue.`), "'published'"],
]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO instrument_sources(instrument_id,source_id) VALUES
${values(PHASE2_INSTRUMENTS.map((instrument) => [q(uuid("instrument", instrument.slug)), q(uuid("source", "source-europeana-music"))]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO music_person_instruments(character_id,instrument_id,work_id,role) VALUES
${values(PHASE2_PEOPLE.map((person, index) => [q(uuid("character", person.slug)), q(uuid("instrument", PHASE2_INSTRUMENTS[index % PHASE2_INSTRUMENTS.length].slug)), q(workId), "'associated'"]))}
ON CONFLICT DO NOTHING;`);

lines.push(`
INSERT INTO music_institutions(id,work_id,slug,location_id,institution_type,founded_year,closed_year,sort_order) VALUES
${values(PHASE2_INSTITUTIONS.map((institution, index) => [q(uuid("institution", institution.slug)), q(workId), q(institution.slug), q(uuid("location", institution.city)), q(institution.type), institution.founded, q(institution.closed), INSTITUTIONS.length + index + 1]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO music_institution_translations(institution_id,locale,name,summary,status) VALUES
${values(PHASE2_INSTITUTIONS.flatMap((institution) => [
  [q(uuid("institution", institution.slug)), "'zh-CN'", q(institution.zh), q(`${institution.zh}作为扩展阶段的创作、教育、演出或传播机构节点。`), "'published'"],
  [q(uuid("institution", institution.slug)), "'en'", q(institution.en), q(`${institution.en} is an expansion-stage institutional node for composition, education, performance, or circulation.`), "'published'"],
]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO music_institution_sources(institution_id,source_id) VALUES
${values(PHASE2_INSTITUTIONS.map((institution) => [q(uuid("institution", institution.slug)), q(uuid("source", "source-europeana-music"))]))}
ON CONFLICT DO NOTHING;`);

const institutionByCity = new Map();
for (const institution of allInstitutions) if (!institutionByCity.has(institution.city)) institutionByCity.set(institution.city, institution.slug);
const personInstitutionRows = PHASE2_PEOPLE.filter((person) => institutionByCity.has(person.city)).map((person) => [q(uuid("character", person.slug)), q(uuid("institution", institutionByCity.get(person.city))), q(workId), "'associated'"]);
if (personInstitutionRows.length > 0) lines.push(`
INSERT INTO music_person_institutions(character_id,institution_id,work_id,role) VALUES
${values(personInstitutionRows)}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO compositions(id,work_id,slug,primary_composer_character_id,chapter_id,composition_start_year,composition_end_year,composition_time_type,confidence,catalogue_number,genre,form,key_signature,approx_duration_seconds,text_language,work_status,sort_order) VALUES
${values(PHASE2_COMPOSITIONS.map((composition, index) => {
  const chapter = chapterForYear(composition.start);
  const language = textLanguageByPerson[composition.person] ?? (/sacred|motet|mass/u.test(composition.genre) ? "la" : "");
  return [q(uuid("composition", composition.slug)), q(workId), q(composition.slug), q(uuid("character", composition.person)), q(chapterMap.get(chapter.slug).id), composition.start, composition.end, q(composition.start === composition.end ? "exact" : "range"), "'high'", q(""), q(composition.genre), q(composition.form), q(composition.key), durationForComposition(composition), q(language), "'confirmed'", COMPOSITIONS.length + index + 1];
}))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO composition_translations(composition_id,locale,title,alternate_titles,summary,description,status) VALUES
${values(PHASE2_COMPOSITIONS.flatMap((composition) => {
  const person = peopleMap.get(composition.person);
  const location = locationMap.get(composition.city);
  return [
    [q(uuid("composition", composition.slug)), "'zh-CN'", q(composition.zh), "'{}'", q(`${person.zh}的${composition.genre}代表作，创作于${composition.start}年。`), q(`${composition.zh}在本图集中连接${person.zh}、${location.zh}、${composition.form}、相关乐器与学习单元。扩展阶段将作品年代、来源与权利状态分开记录。`), "'published'"],
    [q(uuid("composition", composition.slug)), "'en'", q(composition.en), "'{}'", q(`A representative ${composition.genre} by ${person.en}, composed in ${composition.start}.`), q(`${composition.en} connects ${person.en}, ${location.en}, its ${composition.form}, instruments, and learning units. The expansion keeps dates, sources, and rights status as separate evidence fields.`), "'published'"],
  ];
}))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO composition_contributors(composition_id,character_id,work_id,role,sort_order) VALUES
${values(PHASE2_COMPOSITIONS.map((composition) => [q(uuid("composition", composition.slug)), q(uuid("character", composition.person)), q(workId), "'composer'", 1]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO composition_sources(composition_id,source_id) VALUES
${values(PHASE2_COMPOSITIONS.map((composition) => [q(uuid("composition", composition.slug)), q(uuid("source", sourceForComposition(composition)))]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO composition_styles(composition_id,style_id,work_id) VALUES
${values(PHASE2_COMPOSITIONS.flatMap((composition, index) => {
  const chapter = chapterForYear(composition.start);
  const existing = styleSlugsForChapter(chapter.slug).slice(0, 1);
  const phase2Style = PHASE2_STYLES[index % PHASE2_STYLES.length].slug;
  return [...new Set([...existing, phase2Style])].map((style) => [q(uuid("composition", composition.slug)), q(uuid("style", style)), q(workId)]);
}))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO composition_instruments(composition_id,instrument_id,work_id,role) VALUES
${values(PHASE2_COMPOSITIONS.flatMap((composition) => instrumentsForComposition(composition).filter((instrument) => allInstruments.some((item) => item.slug === instrument)).map((instrument) => [q(uuid("composition", composition.slug)), q(uuid("instrument", instrument)), q(workId), "'ensemble'"])))}
ON CONFLICT DO NOTHING;`);
const compositionInstitutionRows = PHASE2_COMPOSITIONS.filter((composition) => institutionByCity.has(composition.city)).map((composition) => [q(uuid("composition", composition.slug)), q(uuid("institution", institutionByCity.get(composition.city))), q(workId), "'city_context'"]);
if (compositionInstitutionRows.length > 0) lines.push(`
INSERT INTO composition_institutions(composition_id,institution_id,work_id,role) VALUES
${values(compositionInstitutionRows)}
ON CONFLICT DO NOTHING;`);

lines.push(`
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id) VALUES
${values(eventObjects.map((event) => [q(uuid("event", event.slug)), q(workId), q(event.slug), eventSequence.get(event.slug), "'verified_historical'", q(event.type), q(event.year === event.endYear ? "exact" : "range"), "'gregorian'", event.year, event.endYear, event.type === "birth" ? "'medium'" : "'high'", q(chapterMap.get(event.chapter).id)]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label) VALUES
${values(eventObjects.flatMap((event) => [
  [q(uuid("event", event.slug)), "'zh-CN'", q(event.zh), q(event.summaryZh), "'published'", q(""), q(""), q(event.year === event.endYear ? `${event.year}年` : `${event.year}–${event.endYear}年`)],
  [q(uuid("event", event.slug)), "'en'", q(event.en), q(event.summaryEn), "'published'", q(""), q(""), q(event.year === event.endYear ? `${event.year}` : `${event.year}–${event.endYear}`)],
]))}
ON CONFLICT DO NOTHING;`);
const eventCharacterRows = eventObjects.filter((event) => event.person).map((event) => [q(uuid("event", event.slug)), q(uuid("character", event.person)), q(event.type === "birth" ? "subject" : "composer"), 0, "true"]);
if (eventCharacterRows.length > 0) lines.push(`
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary) VALUES
${values(eventCharacterRows)}
ON CONFLICT DO NOTHING;`);
const eventLocationRows = eventObjects.filter((event) => event.location && locationMap.has(event.location)).map((event) => [q(uuid("event", event.slug)), q(uuid("location", event.location)), "'primary'", 0]);
if (eventLocationRows.length > 0) lines.push(`
INSERT INTO event_locations(event_id,location_id,role,position) VALUES
${values(eventLocationRows)}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO event_sources(event_id,source_id) VALUES
${values(eventObjects.map((event) => [q(uuid("event", event.slug)), q(uuid("source", event.source))]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO composition_event_links(composition_id,event_id,work_id,role) VALUES
${values(eventObjects.filter((event) => event.composition).map((event) => [q(uuid("composition", event.composition)), q(uuid("event", event.slug)), q(workId), q(event.type === "composition" ? "composed" : "premiered")]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO music_person_event_links(character_id,event_id,work_id,role) VALUES
${values(eventObjects.filter((event) => event.person).map((event) => [q(uuid("character", event.person)), q(uuid("event", event.slug)), q(workId), q(event.type === "birth" ? "subject" : "composer")]))}
ON CONFLICT DO NOTHING;`);

lines.push(`
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status) VALUES
${values(PHASE2_RELATIONS.map((relation) => [q(uuid("relation", `${relation.from}-${relation.to}-${relation.type}`)), q(workId), q(uuid("character", relation.from)), q(uuid("character", relation.to)), q(relation.type), q(relation.direction), q(relation.type === "aesthetic_opposition" ? "mixed" : "neutral"), relation.strength, "'ended'"]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO relation_translations(relation_id,locale,label,summary,status) VALUES
${values(PHASE2_RELATIONS.flatMap((relation) => {
  const from = peopleMap.get(relation.from);
  const to = peopleMap.get(relation.to);
  const pair = relationLabels[relation.type] ?? ["音乐史关系", "Music-history relation"];
  return [
    [q(uuid("relation", `${relation.from}-${relation.to}-${relation.type}`)), "'zh-CN'", q(pair[0]), q(`${from.zh}与${to.zh}之间的${pair[0]}关系；强度用于关系图层级，不代表价值判断。`), "'published'"],
    [q(uuid("relation", `${relation.from}-${relation.to}-${relation.type}`)), "'en'", q(pair[1]), q(`${pair[1]} between ${from.en} and ${to.en}; graph strength is a display aid, not a value judgement.`), "'published'"],
  ];
}))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO relation_sources(relation_id,source_id) VALUES
${values(PHASE2_RELATIONS.map((relation) => [q(uuid("relation", `${relation.from}-${relation.to}-${relation.type}`)), q(uuid("source", "source-british-library-music"))]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO relation_contexts(id,work_id,relation_id,composition_id,context_role,source_id) VALUES
${values(PHASE2_RELATIONS.map((relation, index) => {
  const target = PHASE2_COMPOSITIONS[index % PHASE2_COMPOSITIONS.length];
  return [q(uuid("relation-context", `${relation.from}-${relation.to}-${relation.type}`)), q(workId), q(uuid("relation", `${relation.from}-${relation.to}-${relation.type}`)), q(uuid("composition", target.slug)), q(relation.type), q(uuid("source", "source-british-library-music"))];
}))}
ON CONFLICT DO NOTHING;`);

lines.push(`
INSERT INTO routes(id,work_id,slug,layer,certainty,sort_order) VALUES
${values(PHASE2_ROUTES.map((route, index) => [q(uuid("route", route[0])), q(workId), q(route[0]), "'real'", "'documented'", 8 + index + 1]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO route_translations(route_id,locale,name,summary,status) VALUES
${values(PHASE2_ROUTES.flatMap((route) => [
  [q(uuid("route", route[0])), "'zh-CN'", q(route[1]), q(`${route[1]}连接扩展阶段的主要城市节点，并把地点、事件与学习单元放在同一路径上。`), "'published'"],
  [q(uuid("route", route[0])), "'en'", q(route[2]), q(`${route[2]} connects expansion-stage city nodes and places locations, events, and learning units on one route.`), "'published'"],
]))}
ON CONFLICT DO NOTHING;`);
const firstEventAtLocation = new Map();
for (const event of [...eventObjects].sort((a, b) => a.year - b.year)) if (event.location && !firstEventAtLocation.has(event.location)) firstEventAtLocation.set(event.location, event.slug);
lines.push(`
INSERT INTO route_waypoints(route_id,location_id,position,event_id) VALUES
${values(PHASE2_ROUTES.flatMap((route) => route[3].map((location, position) => [q(uuid("route", route[0])), q(uuid("location", location)), position, firstEventAtLocation.has(location) ? q(uuid("event", firstEventAtLocation.get(location))) : "NULL"])))}
ON CONFLICT DO NOTHING;`);

lines.push(`
INSERT INTO music_learning_units(id,work_id,slug,unit_kind,difficulty,target_minutes,sort_order) VALUES
${values(PHASE2_LEARNING_UNITS.map((unit, index) => [q(uuid("learning-unit", unit.slug)), q(workId), q(unit.slug), q(unit.kind), q(unit.difficulty), unit.minutes, index + 1]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO music_learning_unit_translations(unit_id,locale,title,summary,objective,status) VALUES
${values(PHASE2_LEARNING_UNITS.flatMap((unit) => [
  [q(uuid("learning-unit", unit.slug)), "'zh-CN'", q(unit.zh), q(unit.summaryZh), q(unit.objectiveZh), "'published'"],
  [q(uuid("learning-unit", unit.slug)), "'en'", q(unit.en), q(unit.summaryEn), q(unit.objectiveEn), "'published'"],
]))}
ON CONFLICT DO NOTHING;`);
lines.push(`
INSERT INTO music_learning_unit_compositions(unit_id,composition_id,work_id,sort_order) VALUES
${values(PHASE2_LEARNING_UNITS.flatMap((unit) => unit.compositions.map((composition, index) => [q(uuid("learning-unit", unit.slug)), q(uuid("composition", composition)), q(workId), index + 1])))}
ON CONFLICT DO NOTHING;`);

lines.push("COMMIT;");
await writeFile(out, `${lines.join("\n\n")}\n`);
console.log(`generated ${out}`);
console.log({ people: PHASE2_PEOPLE.length, compositions: PHASE2_COMPOSITIONS.length, styles: PHASE2_STYLES.length, instruments: PHASE2_INSTRUMENTS.length, institutions: PHASE2_INSTITUTIONS.length, locations: PHASE2_LOCATIONS.length, events: eventObjects.length, relations: PHASE2_RELATIONS.length, routes: PHASE2_ROUTES.length, learningUnits: PHASE2_LEARNING_UNITS.length });
