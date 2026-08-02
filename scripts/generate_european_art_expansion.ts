import { writeFile } from "node:fs/promises";
import { resolve } from "node:path";
import {
  ARTISTS, ARTWORKS, EVENT_SOURCES, LOCATIONS, POSTWAR_EVENTS, RELATIONS,
  type ExpansionArtwork,
} from "./european_art_expansion_data.js";

const WORK_ID = "10000000-0000-4000-8000-000000000009";
const output = resolve(process.env.ART_EXPANSION_SEED_OUT ?? "db/seeds/055_european_art_disciplined_expansion.sql");

const q = (value: string) => `'${value.replaceAll("'", "''")}'`;
const nullable = (value: string | number | null | undefined) => value === null || value === undefined ? "NULL" : typeof value === "number" ? String(value) : q(value);
const array = (values: readonly string[]) => values.length === 0 ? "'{}'::text[]" : `ARRAY[${values.map(q).join(",")}]::text[]`;

const chapterMeta = [
  { slug: "classical-antiquity", sequence: 1, start: -500, end: 476, ref: "c. 500 BCE–476 CE", color: "#B8894A", zh: "古典地中海", en: "Classical Mediterranean", summaryZh: "希腊雕塑、希腊化传统、罗马肖像与公共纪念物。", summaryEn: "Greek sculpture, Hellenistic traditions, Roman portraiture and public monuments." },
  { slug: "medieval", sequence: 2, start: 476, end: 1400, ref: "c. 476–1400", color: "#8B6F47", zh: "中世纪", en: "Medieval Art", summaryZh: "拜占庭、罗马式、哥特式、手稿、教堂与祭坛艺术。", summaryEn: "Byzantine, Romanesque and Gothic art across manuscripts, churches and altarpieces." },
  { slug: "renaissance", sequence: 3, start: 1400, end: 1600, ref: "c. 1400–1600", color: "#A86548", zh: "文艺复兴", en: "Renaissance", summaryZh: "佛罗伦萨、罗马、威尼斯与北方文艺复兴的多中心网络。", summaryEn: "The multi-centred networks of Florence, Rome, Venice and the Northern Renaissance." },
  { slug: "baroque", sequence: 4, start: 1600, end: 1750, ref: "c. 1600–1750", color: "#9B4F49", zh: "巴洛克与洛可可", en: "Baroque and Rococo", summaryZh: "戏剧性宗教艺术、宫廷文化、荷兰黄金时代与洛可可。", summaryEn: "Dramatic religious art, court culture, the Dutch Golden Age and Rococo." },
  { slug: "neoclassicism-and-romanticism", sequence: 5, start: 1750, end: 1840, ref: "c. 1750–1840", color: "#6F6D8A", zh: "新古典主义与浪漫主义", en: "Neoclassicism and Romanticism", summaryZh: "学院、革命、历史画、崇高风景与浪漫主义想象。", summaryEn: "Academies, revolution, history painting, sublime landscape and Romantic imagination." },
  { slug: "modernism", sequence: 6, start: 1840, end: 1886, ref: "c. 1840–1886", color: "#607D76", zh: "现实主义与印象派", en: "Realism and Impressionism", summaryZh: "社会现实、现代生活、户外绘画和新的光色经验。", summaryEn: "Social reality, modern life, plein-air painting and new experiences of light and colour." },
  { slug: "modernism-early", sequence: 7, start: 1886, end: 1905, ref: "c. 1886–1905", color: "#5B7198", zh: "后印象派与象征主义", en: "Post-Impressionism and Symbolism", summaryZh: "结构、色彩、象征、表现性图像与世纪末文化。", summaryEn: "Structure, colour, symbolism, expressive imagery and fin-de-siècle culture." },
  { slug: "modernism-and-war", sequence: 8, start: 1905, end: 1945, ref: "c. 1905–1945", color: "#745C86", zh: "早期现代主义与战争", en: "Early Modernism and War", summaryZh: "野兽派、立体主义、表现主义、未来主义、达达、包豪斯、抽象与超现实主义。", summaryEn: "Fauvism, Cubism, Expressionism, Futurism, Dada, Bauhaus, abstraction and Surrealism." },
  { slug: "postwar-heritage", sequence: 9, start: 1945, end: 2026, ref: "1945–2026", color: "#6E7FAF", zh: "战后传播、修复与遗产治理", en: "Postwar Circulation, Conservation and Heritage", summaryZh: "连接战后展览、博物馆重建、追索返还、修复与数字公共访问。", summaryEn: "Postwar exhibitions, museum reconstruction, restitution, conservation and digital public access." },
] as const;

const movementMeta = [
  { slug: "impressionism", chapter: "modernism", start: 1860, end: 1890, order: 18, zh: "印象派", en: "Impressionism" },
  { slug: "symbolism", chapter: "modernism-early", start: 1880, end: 1910, order: 19, zh: "象征主义", en: "Symbolism" },
  { slug: "rococo", chapter: "baroque", start: 1715, end: 1770, order: 20, zh: "洛可可", en: "Rococo" },
  { slug: "dada", chapter: "modernism-and-war", start: 1916, end: 1924, order: 21, zh: "达达", en: "Dada" },
  { slug: "suprematism", chapter: "modernism-and-war", start: 1913, end: 1930, order: 22, zh: "至上主义", en: "Suprematism" },
  { slug: "fauvism", chapter: "modernism-and-war", start: 1905, end: 1910, order: 23, zh: "野兽派", en: "Fauvism" },
  { slug: "de-stijl", chapter: "modernism-and-war", start: 1917, end: 1931, order: 24, zh: "风格派", en: "De Stijl" },
] as const;

const existingArtistMovements: Record<string, string[]> = {
  phidias: ["classicism"], polykleitos: ["classicism"],
  giotto: ["gothic"], duccio: ["gothic"], cimabue: ["gothic"],
  "jan-van-eyck": ["renaissance-humanism"], "rogier-van-der-weyden": ["renaissance-humanism"],
  "hieronymus-bosch": ["renaissance-humanism"], "sandro-botticelli": ["renaissance-humanism"],
  michelangelo: ["renaissance-humanism"], raphael: ["renaissance-humanism"], "albrecht-durer": ["renaissance-humanism"],
  giorgione: ["renaissance-humanism"], tintoretto: ["renaissance-humanism"], "leonardo-da-vinci": ["renaissance-humanism"],
  masaccio: ["renaissance-humanism"], titian: ["renaissance-humanism"],
  "peter-paul-rubens": ["baroque"], "artemisia-gentileschi": ["baroque"], "johannes-vermeer": ["baroque"],
  rembrandt: ["baroque"], caravaggio: ["baroque"], velazquez: ["baroque"], "nicolas-poussin": ["baroque"],
  "francisco-goya": ["neoclassicism", "romanticism"], "caspar-david-friedrich": ["romanticism"],
  "eugene-delacroix": ["romanticism"], "jacques-louis-david": ["neoclassicism"], "j-m-w-turner": ["romanticism"], "antonio-canova": ["neoclassicism"],
  "gustave-courbet": ["realism"], "edouard-manet": ["realism", "impressionism"], "claude-monet": ["impressionism"],
  "pierre-auguste-renoir": ["impressionism"], "edgar-degas": ["impressionism"],
  "van-gogh": ["post-impressionism"], "paul-cezanne": ["post-impressionism"], "paul-gauguin": ["post-impressionism"],
  "georges-seurat": ["post-impressionism"], "henri-de-toulouse-lautrec": ["post-impressionism"],
  "pablo-picasso": ["cubism"], "henri-matisse": ["fauvism"], "georges-braque": ["cubism"],
  "umberto-boccioni": ["futurism"], "paul-klee": ["bauhaus", "expressionism"], "franz-marc": ["expressionism"],
  "piet-mondrian": ["de-stijl"], "wassily-kandinsky": ["expressionism", "bauhaus"],
};

const existingArtistChapter: Record<string, string> = {
  "gustave-courbet": "modernism", "edouard-manet": "modernism", "claude-monet": "modernism",
  "pierre-auguste-renoir": "modernism", "edgar-degas": "modernism",
  "van-gogh": "modernism-early", "paul-cezanne": "modernism-early", "paul-gauguin": "modernism-early",
  "georges-seurat": "modernism-early", "henri-de-toulouse-lautrec": "modernism-early",
  "pablo-picasso": "modernism-and-war", "henri-matisse": "modernism-and-war", "georges-braque": "modernism-and-war",
  "umberto-boccioni": "modernism-and-war", "paul-klee": "modernism-and-war", "franz-marc": "modernism-and-war",
  "piet-mondrian": "modernism-and-war", "wassily-kandinsky": "modernism-and-war",
};

const allArtistMovements = { ...existingArtistMovements };
for (const artist of ARTISTS) allArtistMovements[artist.slug] = artist.movements;

function yearsZh(work: ExpansionArtwork): string {
  if (work.start === work.end) return work.start < 0 ? `约公元前 ${Math.abs(work.start)} 年` : `${work.start} 年`;
  if (work.start < 0 && work.end < 0) return `约公元前 ${Math.abs(work.start)}–${Math.abs(work.end)} 年`;
  return `${work.start}–${work.end} 年`;
}

function yearsEn(work: ExpansionArtwork): string {
  if (work.start === work.end) return work.start < 0 ? `c. ${Math.abs(work.start)} BCE` : `${work.start}`;
  if (work.start < 0 && work.end < 0) return `c. ${Math.abs(work.start)}–${Math.abs(work.end)} BCE`;
  return `${work.start}–${work.end}`;
}

function mediumNoteZh(medium: string): string {
  const text = medium.toLowerCase();
  if (/architecture|cathedral|portal|colonnade|urban design/u.test(text)) return "作品把结构、光线、表面装饰与人的行走路线组织为整体空间";
  if (/sculpture|bronze|marble|relief|tympanum/u.test(text)) return "作品通过体量、姿态、表面和环绕观看建立形象";
  if (/manuscript|etching|woodcut|lithograph|print|poster|embroidery/u.test(text)) return "作品利用线条、层次与可传播的图像媒介组织叙事";
  if (/mosaic|fresco/u.test(text)) return "作品把图像、色彩与建筑表面结合，使观看与场所不可分离";
  if (/readymade|wheel|urinal|tape|collage/u.test(text)) return "作品重新界定日常材料、制作行为与艺术制度之间的关系";
  return "作品通过构图、色彩、光线和人物或空间关系组织观看";
}

function mediumNoteEn(medium: string): string {
  const text = medium.toLowerCase();
  if (/architecture|cathedral|portal|colonnade|urban design/u.test(text)) return "It organises structure, light, surface and bodily movement as a single spatial experience";
  if (/sculpture|bronze|marble|relief|tympanum/u.test(text)) return "It builds meaning through volume, pose, surface and viewing in the round";
  if (/manuscript|etching|woodcut|lithograph|print|poster|embroidery/u.test(text)) return "It uses line, layering and a reproducible or portable image medium to organise narrative";
  if (/mosaic|fresco/u.test(text)) return "It binds image and colour to an architectural surface, making viewing inseparable from place";
  if (/readymade|wheel|urinal|tape|collage/u.test(text)) return "It redefines the relation between ordinary material, artistic making and the institution of art";
  return "It organises viewing through composition, colour, light and the relation of figures or space";
}

function chapterSignificanceZh(chapter: string): string {
  return ({
    "classical-antiquity": "它显示古典艺术如何以比例、身体和公共纪念塑造后世的视觉标准",
    medieval: "它连接礼仪、城市工坊、建筑空间和中世纪图像传播",
    renaissance: "它体现文艺复兴对古典传统、自然观察、透视和个人创作身份的重组",
    baroque: "它体现巴洛克或洛可可对戏剧、感官、宫廷与宗教空间的调动",
    "neoclassicism-and-romanticism": "它把学院规范、革命历史、个人情感和崇高自然置于新的公共观看中",
    modernism: "它把现代生活、社会现实和变化中的光色经验带入艺术主叙事",
    "modernism-early": "它推动结构、象征、表现性形象与世纪末文化之间的新关系",
    "modernism-and-war": "它回应工业化、战争与先锋运动对艺术材料、形式和观念的重构",
  } as Record<string, string>)[chapter] ?? "它构成欧洲艺术史主干中的重要作品节点";
}

function chapterSignificanceEn(chapter: string): string {
  return ({
    "classical-antiquity": "It shows how classical art made proportion, the body and public monument into enduring visual standards",
    medieval: "It connects ritual, urban workshops, architectural space and medieval image circulation",
    renaissance: "It reflects the Renaissance reworking of antiquity, natural observation, perspective and artistic identity",
    baroque: "It mobilises Baroque or Rococo drama, sensation, court culture and religious space",
    "neoclassicism-and-romanticism": "It places academic order, revolutionary history, personal feeling and sublime nature before a new public",
    modernism: "It brings modern life, social reality and changing experiences of light and colour into the main narrative of art",
    "modernism-early": "It advances new relations among structure, symbolism, expressive imagery and fin-de-siècle culture",
    "modernism-and-war": "It answers industrialisation, war and the avant-garde reconstruction of artistic material, form and concept",
  } as Record<string, string>)[chapter] ?? "It forms an important node in the main narrative of European art history";
}

function createSummaryZh(title: string, artist: string, medium: string): string {
  const category = mediumNoteZh(medium).replace(/^作品/u, "");
  return `《${title}》由${artist}以${medium}创作，${category}。`;
}

function createSummaryEn(title: string, artist: string, medium: string): string {
  const category = mediumNoteEn(medium).replace(/^It /u, "").replace(/\.$/u, "");
  return `${title}, made by ${artist} in ${medium}, ${category.charAt(0).toLowerCase()}${category.slice(1)}.`;
}

function sql(): string {
  const lines: string[] = [
    "BEGIN;",
    "",
    "-- R9/R10 combined disciplined expansion: 82 artists, 200 artworks and a postwar event layer.",
    "-- Generated by scripts/generate_european_art_expansion.ts from the frozen expansion data file.",
    "CREATE OR REPLACE FUNCTION pg_temp.stable_uuid(seed text) RETURNS uuid",
    "LANGUAGE sql IMMUTABLE AS $fn$",
    "  SELECT (substr(md5(seed),1,8)||'-'||substr(md5(seed),9,4)||'-4'||substr(md5(seed),14,3)||'-8'||substr(md5(seed),18,3)||'-'||substr(md5(seed),21))::uuid",
    "$fn$;",
    "",
    `UPDATE works SET chronology_end_year=2026 WHERE id=${q(WORK_ID)};`,
    `UPDATE work_chronologies SET end_year=2026 WHERE work_id=${q(WORK_ID)} AND kind='historical';`,
    "",
  ];

  for (const chapter of chapterMeta) {
    if (chapter.slug === "postwar-heritage") {
      lines.push(
        `INSERT INTO chapters(id,work_id,slug,sequence,reference_label,era_start_year,era_end_year,accent_color) VALUES (pg_temp.stable_uuid(${q(`chapter:${chapter.slug}`)}),${q(WORK_ID)},${q(chapter.slug)},${chapter.sequence},${q(chapter.ref)},${chapter.start},${chapter.end},${q(chapter.color)}) ON CONFLICT(work_id,slug) DO UPDATE SET sequence=EXCLUDED.sequence,reference_label=EXCLUDED.reference_label,era_start_year=EXCLUDED.era_start_year,era_end_year=EXCLUDED.era_end_year,accent_color=EXCLUDED.accent_color;`,
      );
    } else {
      lines.push(`UPDATE chapters SET sequence=${chapter.sequence},reference_label=${q(chapter.ref)},era_start_year=${chapter.start},era_end_year=${chapter.end},accent_color=${q(chapter.color)} WHERE work_id=${q(WORK_ID)} AND slug=${q(chapter.slug)};`);
    }
    lines.push(
      `INSERT INTO chapter_translations(chapter_id,locale,title,summary,status) SELECT id,'zh-CN',${q(chapter.zh)},${q(chapter.summaryZh)},'published' FROM chapters WHERE work_id=${q(WORK_ID)} AND slug=${q(chapter.slug)} ON CONFLICT(chapter_id,locale) DO UPDATE SET title=EXCLUDED.title,summary=EXCLUDED.summary,status=EXCLUDED.status;`,
      `INSERT INTO chapter_translations(chapter_id,locale,title,summary,status) SELECT id,'en',${q(chapter.en)},${q(chapter.summaryEn)},'published' FROM chapters WHERE work_id=${q(WORK_ID)} AND slug=${q(chapter.slug)} ON CONFLICT(chapter_id,locale) DO UPDATE SET title=EXCLUDED.title,summary=EXCLUDED.summary,status=EXCLUDED.status;`,
    );
  }
  lines.push("");

  const movementChapterUpdates: Record<string, string> = {
    realism: "modernism", impressionism: "modernism", "post-impressionism": "modernism-early",
    expressionism: "modernism-and-war", cubism: "modernism-and-war", futurism: "modernism-and-war",
    surrealism: "modernism-and-war", bauhaus: "modernism-and-war", modernism: "modernism-and-war",
    romanticism: "neoclassicism-and-romanticism", neoclassicism: "neoclassicism-and-romanticism",
  };
  for (const [movement, chapter] of Object.entries(movementChapterUpdates)) {
    lines.push(`UPDATE movements m SET chapter_id=ch.id FROM chapters ch WHERE m.work_id=${q(WORK_ID)} AND m.slug=${q(movement)} AND ch.work_id=m.work_id AND ch.slug=${q(chapter)};`);
  }
  lines.push(`UPDATE movement_translations SET name=CASE locale WHEN 'zh-CN' THEN '早期现代主义' ELSE 'Early Modernism' END,summary=CASE locale WHEN 'zh-CN' THEN '连接 1905–1945 年先锋运动的概括性艺术语言。' ELSE 'An umbrella language connecting avant-garde movements from 1905 to 1945.' END WHERE movement_id=(SELECT id FROM movements WHERE work_id=${q(WORK_ID)} AND slug='modernism');`);
  for (const movement of movementMeta) {
    lines.push(
      `INSERT INTO movements(id,work_id,slug,chapter_id,start_year,end_year,sort_order) SELECT pg_temp.stable_uuid(${q(`movement:${movement.slug}`)}),${q(WORK_ID)},${q(movement.slug)},ch.id,${movement.start},${movement.end},${movement.order} FROM chapters ch WHERE ch.work_id=${q(WORK_ID)} AND ch.slug=${q(movement.chapter)} ON CONFLICT(work_id,slug) DO UPDATE SET chapter_id=EXCLUDED.chapter_id,start_year=EXCLUDED.start_year,end_year=EXCLUDED.end_year,sort_order=EXCLUDED.sort_order;`,
      `INSERT INTO movement_translations(movement_id,locale,name,summary,status) SELECT id,'zh-CN',${q(movement.zh)},'以作品、人物、城市和制度网络标注的核心艺术运动。','published' FROM movements WHERE work_id=${q(WORK_ID)} AND slug=${q(movement.slug)} ON CONFLICT(movement_id,locale) DO UPDATE SET name=EXCLUDED.name,summary=EXCLUDED.summary,status=EXCLUDED.status;`,
      `INSERT INTO movement_translations(movement_id,locale,name,summary,status) SELECT id,'en',${q(movement.en)},'A core movement mapped through works, people, cities and institutions.','published' FROM movements WHERE work_id=${q(WORK_ID)} AND slug=${q(movement.slug)} ON CONFLICT(movement_id,locale) DO UPDATE SET name=EXCLUDED.name,summary=EXCLUDED.summary,status=EXCLUDED.status;`,
    );
  }
  lines.push("");

  for (const location of LOCATIONS) {
    lines.push(
      `INSERT INTO locations(id,work_id,slug,layer,geom,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES (pg_temp.stable_uuid(${q(`location:${location.slug}`)}),${q(WORK_ID)},${q(location.slug)},'real',ST_SetSRID(ST_MakePoint(${location.lng},${location.lat}),4326)::geography,${100 + LOCATIONS.indexOf(location)},'city','city_centroid',10,${q(location.country)},false,true) ON CONFLICT(work_id,slug) DO NOTHING;`,
      `INSERT INTO location_translations(location_id,locale,name,summary,status) SELECT id,'zh-CN',${q(location.zh)},${q(`${location.zh}在本次艺术史扩充中承载作品、艺术家或机构事件。`)},'published' FROM locations WHERE work_id=${q(WORK_ID)} AND slug=${q(location.slug)} ON CONFLICT(location_id,locale) DO UPDATE SET name=EXCLUDED.name,summary=EXCLUDED.summary,status=EXCLUDED.status;`,
      `INSERT INTO location_translations(location_id,locale,name,summary,status) SELECT id,'en',${q(location.en)},${q(`${location.en} anchors an artwork, artist or institutional event in this art-history expansion.`)},'published' FROM locations WHERE work_id=${q(WORK_ID)} AND slug=${q(location.slug)} ON CONFLICT(location_id,locale) DO UPDATE SET name=EXCLUDED.name,summary=EXCLUDED.summary,status=EXCLUDED.status;`,
    );
  }
  lines.push("");

  lines.push(
    `INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type) VALUES (pg_temp.stable_uuid('source:eah-met-timeline'),${q(WORK_ID)},'The Met Heilbrunn Timeline of Art History','https://www.metmuseum.org/toah/','Museum art-history timeline used for period and movement context.','reference','reference'),(pg_temp.stable_uuid('source:eah-moma-terms'),${q(WORK_ID)},'MoMA Art Terms','https://www.moma.org/collection/terms/','Museum terminology used for modern movements and media context.','reference','reference') ON CONFLICT(id) DO UPDATE SET title=EXCLUDED.title,url=EXCLUDED.url,citation=EXCLUDED.citation;`,
    `INSERT INTO source_translations(source_id,locale,title,citation,status) VALUES (pg_temp.stable_uuid('source:eah-met-timeline'),'zh-CN','大都会艺术博物馆海尔布伦艺术史时间线','用于时期、流派与作品语境的博物馆艺术史时间线。','published'),(pg_temp.stable_uuid('source:eah-met-timeline'),'en','The Met Heilbrunn Timeline of Art History','Museum art-history timeline used for period, movement and artwork context.','published'),(pg_temp.stable_uuid('source:eah-moma-terms'),'zh-CN','纽约现代艺术博物馆艺术术语','用于现代艺术运动、媒介和观念语境的机构术语。','published'),(pg_temp.stable_uuid('source:eah-moma-terms'),'en','MoMA Art Terms','Institutional terminology for modern movements, media and concepts.','published') ON CONFLICT(source_id,locale) DO UPDATE SET title=EXCLUDED.title,citation=EXCLUDED.citation,status=EXCLUDED.status;`,
  );
  for (const source of EVENT_SOURCES) {
    lines.push(
      `INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type) VALUES (pg_temp.stable_uuid(${q(`source:event:${source.key}`)}),${q(WORK_ID)},${q(source.title)},${q(source.url)},${q(source.citationEn)},'primary','reference') ON CONFLICT(id) DO UPDATE SET title=EXCLUDED.title,url=EXCLUDED.url,citation=EXCLUDED.citation;`,
      `INSERT INTO source_translations(source_id,locale,title,citation,status) VALUES (pg_temp.stable_uuid(${q(`source:event:${source.key}`)}),'zh-CN',${q(source.title)},${q(source.citationZh)},'published'),(pg_temp.stable_uuid(${q(`source:event:${source.key}`)}),'en',${q(source.title)},${q(source.citationEn)},'published') ON CONFLICT(source_id,locale) DO UPDATE SET title=EXCLUDED.title,citation=EXCLUDED.citation,status=EXCLUDED.status;`,
    );
  }
  lines.push("");

  for (const [artistSlug, chapterSlug] of Object.entries(existingArtistChapter)) {
    lines.push(`UPDATE artists a SET chapter_id=ch.id FROM chapters ch WHERE a.work_id=${q(WORK_ID)} AND a.slug=${q(artistSlug)} AND ch.work_id=a.work_id AND ch.slug=${q(chapterSlug)};`);
  }

  ARTISTS.forEach((artist, index) => {
    const fullZh = artist.fullZh ?? artist.zh;
    const fullEn = artist.fullEn ?? artist.en;
    const modernZh = `${chapterMeta.find((item) => item.slug === artist.chapter)?.zh ?? "欧洲艺术史"}核心人物`;
    const modernEn = `Core figure in ${chapterMeta.find((item) => item.slug === artist.chapter)?.en ?? "European art history"}`;
    lines.push(
      `INSERT INTO artists(id,work_id,slug,artist_kind,birth_year,death_year,chapter_id,importance,sort_order) SELECT pg_temp.stable_uuid(${q(`artist:${artist.slug}`)}),${q(WORK_ID)},${q(artist.slug)},'person',${nullable(artist.birth)},${nullable(artist.death)},ch.id,${artist.importance},${49 + index} FROM chapters ch WHERE ch.work_id=${q(WORK_ID)} AND ch.slug=${q(artist.chapter)} ON CONFLICT(work_id,slug) DO UPDATE SET birth_year=EXCLUDED.birth_year,death_year=EXCLUDED.death_year,chapter_id=EXCLUDED.chapter_id,importance=EXCLUDED.importance,sort_order=EXCLUDED.sort_order;`,
      `INSERT INTO artist_translations(artist_id,locale,name,summary,modern_status,period_titles,status,full_name,aliases,formal_titles) SELECT id,'zh-CN',${q(artist.zh)},${q(`${artist.zh}以作品、媒介和城市网络进入欧洲艺术史主干。`)},${q(modernZh)},${array(artist.movements)},'published',${q(fullZh)},'{}','{}' FROM artists WHERE work_id=${q(WORK_ID)} AND slug=${q(artist.slug)} ON CONFLICT(artist_id,locale) DO UPDATE SET name=EXCLUDED.name,summary=EXCLUDED.summary,modern_status=EXCLUDED.modern_status,period_titles=EXCLUDED.period_titles,status=EXCLUDED.status,full_name=EXCLUDED.full_name;`,
      `INSERT INTO artist_translations(artist_id,locale,name,summary,modern_status,period_titles,status,full_name,aliases,formal_titles) SELECT id,'en',${q(artist.en)},${q(`${artist.en} enters the main narrative of European art history through works, media and city networks.`)},${q(modernEn)},${array(artist.movements)},'published',${q(fullEn)},'{}','{}' FROM artists WHERE work_id=${q(WORK_ID)} AND slug=${q(artist.slug)} ON CONFLICT(artist_id,locale) DO UPDATE SET name=EXCLUDED.name,summary=EXCLUDED.summary,modern_status=EXCLUDED.modern_status,period_titles=EXCLUDED.period_titles,status=EXCLUDED.status,full_name=EXCLUDED.full_name;`,
      `INSERT INTO artist_locations(artist_id,location_id,role) SELECT a.id,l.id,'active' FROM artists a JOIN locations l ON l.work_id=a.work_id AND l.slug=${q(artist.mainLocation)} WHERE a.work_id=${q(WORK_ID)} AND a.slug=${q(artist.slug)} ON CONFLICT DO NOTHING;`,
    );
  });
  lines.push("");

  lines.push(`DELETE FROM artist_movements am USING artists a WHERE am.artist_id=a.id AND a.work_id=${q(WORK_ID)};`);
  for (const [artistSlug, movements] of Object.entries(allArtistMovements)) {
    for (const movement of movements) {
      lines.push(`INSERT INTO artist_movements(artist_id,movement_id) SELECT a.id,m.id FROM artists a JOIN movements m ON m.work_id=a.work_id AND m.slug=${q(movement)} WHERE a.work_id=${q(WORK_ID)} AND a.slug=${q(artistSlug)} ON CONFLICT DO NOTHING;`);
    }
  }
  lines.push("");

  lines.push(
    `INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) SELECT pg_temp.stable_uuid('artist-person:'||a.id::text),a.work_id,a.slug,a.sort_order,CASE WHEN a.slug IN (${ARTISTS.filter((item) => item.gender === "female").map((item) => q(item.slug)).join(",") || "NULL"}) THEN 'female'::person_gender ELSE 'male'::person_gender END,'adult','historical','historical',a.birth_year,a.death_year,'artist',a.importance FROM artists a WHERE a.work_id=${q(WORK_ID)} AND a.slug IN (${ARTISTS.map((item) => q(item.slug)).join(",")}) ON CONFLICT(work_id,slug) DO UPDATE SET sort_order=EXCLUDED.sort_order,gender=EXCLUDED.gender,birth_year=EXCLUDED.birth_year,death_year=EXCLUDED.death_year,icon_variant=EXCLUDED.icon_variant,importance=EXCLUDED.importance;`,
    `UPDATE artists a SET character_id=c.id FROM characters c WHERE a.work_id=c.work_id AND a.slug=c.slug AND a.work_id=${q(WORK_ID)};`,
    `INSERT INTO character_translations(character_id,locale,name,summary,aliases,detail,motivation,status) SELECT a.character_id,t.locale,COALESCE(NULLIF(t.full_name,''),t.name),t.summary,t.aliases,CASE WHEN t.locale='zh-CN' THEN '艺术家与人物身份统一；作品、事件、地点、来源和关系沿用同一人物链。' ELSE 'Artist and person identities are unified; works, events, places, sources and relations use the same person chain.' END,CASE WHEN t.locale='zh-CN' THEN concat_ws('；',t.modern_status,array_to_string(t.period_titles,'、')) ELSE concat_ws('; ',t.modern_status,array_to_string(t.period_titles,'; ')) END,t.status FROM artists a JOIN artist_translations t ON t.artist_id=a.id WHERE a.work_id=${q(WORK_ID)} AND a.character_id IS NOT NULL ON CONFLICT(character_id,locale) DO UPDATE SET name=EXCLUDED.name,summary=EXCLUDED.summary,aliases=EXCLUDED.aliases,detail=EXCLUDED.detail,motivation=EXCLUDED.motivation,status=EXCLUDED.status;`,
    `INSERT INTO artist_sources(artist_id,source_id) SELECT id,CASE WHEN chapter_id=(SELECT id FROM chapters WHERE work_id=${q(WORK_ID)} AND slug='modernism-and-war') THEN pg_temp.stable_uuid('source:eah-moma-terms') ELSE pg_temp.stable_uuid('source:eah-met-timeline') END FROM artists WHERE work_id=${q(WORK_ID)} ON CONFLICT DO NOTHING;`,
    `INSERT INTO character_sources(character_id,source_id) SELECT a.character_id,s.source_id FROM artist_sources s JOIN artists a ON a.id=s.artist_id WHERE a.work_id=${q(WORK_ID)} AND a.character_id IS NOT NULL ON CONFLICT DO NOTHING;`,
    `INSERT INTO character_locations(character_id,location_id,is_primary) SELECT a.character_id,al.location_id,true FROM artist_locations al JOIN artists a ON a.id=al.artist_id WHERE a.work_id=${q(WORK_ID)} AND a.character_id IS NOT NULL GROUP BY a.character_id,al.location_id ON CONFLICT(character_id,location_id) DO UPDATE SET is_primary=true;`,
  );
  lines.push("");

  ARTWORKS.forEach((work, offset) => {
    const ordinal = 97 + offset;
    const primary = work.artists[0] ?? null;
    lines.push(
      `INSERT INTO artworks(id,work_id,slug,primary_artist_id,chapter_id,creation_start_year,creation_end_year,creation_time_type,medium,status,attribution_confidence,copyright_status,creation_location_id,current_location_id,sort_order) SELECT pg_temp.stable_uuid(${q(`artwork:${work.slug}`)}),${q(WORK_ID)},${q(work.slug)},${primary ? `(SELECT id FROM artists WHERE work_id=${q(WORK_ID)} AND slug=${q(primary)})` : "NULL"},ch.id,${work.start},${work.end},${q(work.timeType ?? (work.start === work.end ? "exact" : "range"))},${q(work.medium)},${q(work.status ?? "confirmed")},${q(work.status === "attributed" ? "medium" : work.status === "lost" ? "low" : "high")},'metadata_only',${work.creationLocation ? `(SELECT id FROM locations WHERE work_id=${q(WORK_ID)} AND slug=${q(work.creationLocation)})` : "NULL"},${work.currentLocation ? `(SELECT id FROM locations WHERE work_id=${q(WORK_ID)} AND slug=${q(work.currentLocation)})` : "NULL"},${ordinal} FROM chapters ch WHERE ch.work_id=${q(WORK_ID)} AND ch.slug=${q(work.chapter)} ON CONFLICT(work_id,slug) DO UPDATE SET primary_artist_id=EXCLUDED.primary_artist_id,chapter_id=EXCLUDED.chapter_id,creation_start_year=EXCLUDED.creation_start_year,creation_end_year=EXCLUDED.creation_end_year,creation_time_type=EXCLUDED.creation_time_type,medium=EXCLUDED.medium,status=EXCLUDED.status,attribution_confidence=EXCLUDED.attribution_confidence,creation_location_id=EXCLUDED.creation_location_id,current_location_id=EXCLUDED.current_location_id,sort_order=EXCLUDED.sort_order;`,
      `INSERT INTO artwork_translations(artwork_id,locale,title,summary,description,status) SELECT id,'zh-CN',${q(work.zh)},'', '', 'published' FROM artworks WHERE work_id=${q(WORK_ID)} AND slug=${q(work.slug)} ON CONFLICT(artwork_id,locale) DO UPDATE SET title=EXCLUDED.title,status=EXCLUDED.status;`,
      `INSERT INTO artwork_translations(artwork_id,locale,title,summary,description,status) SELECT id,'en',${q(work.en)},'', '', 'published' FROM artworks WHERE work_id=${q(WORK_ID)} AND slug=${q(work.slug)} ON CONFLICT(artwork_id,locale) DO UPDATE SET title=EXCLUDED.title,status=EXCLUDED.status;`,
    );
    for (const artistSlug of work.artists) {
      lines.push(`INSERT INTO artist_artworks(artist_id,artwork_id,role) SELECT a.id,aw.id,'creator' FROM artists a JOIN artworks aw ON aw.work_id=a.work_id AND aw.slug=${q(work.slug)} WHERE a.work_id=${q(WORK_ID)} AND a.slug=${q(artistSlug)} ON CONFLICT DO NOTHING;`);
    }
    for (const movement of work.movements) {
      lines.push(`INSERT INTO artwork_movements(artwork_id,movement_id) SELECT aw.id,m.id FROM artworks aw JOIN movements m ON m.work_id=aw.work_id AND m.slug=${q(movement)} WHERE aw.work_id=${q(WORK_ID)} AND aw.slug=${q(work.slug)} ON CONFLICT DO NOTHING;`);
    }
    lines.push(
      `INSERT INTO artwork_sources(artwork_id,source_id) SELECT id,CASE WHEN chapter_id=(SELECT id FROM chapters WHERE work_id=${q(WORK_ID)} AND slug='modernism-and-war') THEN pg_temp.stable_uuid('source:eah-moma-terms') ELSE pg_temp.stable_uuid('source:eah-met-timeline') END FROM artworks WHERE work_id=${q(WORK_ID)} AND slug=${q(work.slug)} ON CONFLICT DO NOTHING;`,
      `INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id) SELECT pg_temp.stable_uuid(${q(`event:artwork:${work.slug}`)}),${q(WORK_ID)},${q(`artwork-${work.slug}`)},${ordinal},'verified_historical','other',${q(work.timeType ?? (work.start === work.end ? "exact" : "range"))},'gregorian',${work.start},${work.end},${q(work.status === "attributed" ? "medium" : work.status === "lost" ? "low" : "high")},ch.id FROM chapters ch WHERE ch.work_id=${q(WORK_ID)} AND ch.slug=${q(work.chapter)} ON CONFLICT(work_id,slug) DO UPDATE SET sequence=EXCLUDED.sequence,time_type=EXCLUDED.time_type,historical_start_year=EXCLUDED.historical_start_year,historical_end_year=EXCLUDED.historical_end_year,confidence=EXCLUDED.confidence,chapter_id=EXCLUDED.chapter_id;`,
      `INSERT INTO event_translations(event_id,locale,title,summary,status,time_label,detail,significance) SELECT id,'zh-CN',${q(`《${work.zh}》创作节点`)},${q(`作品于${yearsZh(work)}完成或持续推进，并进入本图集的作品生命周期。`)},'published',${q(yearsZh(work))},${q(`${work.zh}的创作、媒介与地点信息按机构目录和艺术史时间线整理。`)},${q(chapterSignificanceZh(work.chapter))} FROM events WHERE work_id=${q(WORK_ID)} AND slug=${q(`artwork-${work.slug}`)} ON CONFLICT(event_id,locale) DO UPDATE SET title=EXCLUDED.title,summary=EXCLUDED.summary,status=EXCLUDED.status,time_label=EXCLUDED.time_label,detail=EXCLUDED.detail,significance=EXCLUDED.significance;`,
      `INSERT INTO event_translations(event_id,locale,title,summary,status,time_label,detail,significance) SELECT id,'en',${q(`${work.en}: creation`)},${q(`The work was completed or developed in ${yearsEn(work)} and enters the atlas as an artwork-lifecycle event.`)},'published',${q(yearsEn(work))},${q(`The creation, medium and place of ${work.en} are organised from institutional catalogues and art-history timelines.`)},${q(chapterSignificanceEn(work.chapter))} FROM events WHERE work_id=${q(WORK_ID)} AND slug=${q(`artwork-${work.slug}`)} ON CONFLICT(event_id,locale) DO UPDATE SET title=EXCLUDED.title,summary=EXCLUDED.summary,status=EXCLUDED.status,time_label=EXCLUDED.time_label,detail=EXCLUDED.detail,significance=EXCLUDED.significance;`,
      `INSERT INTO artwork_event_links(work_id,artwork_id,event_id,role) SELECT ${q(WORK_ID)},aw.id,e.id,'produced' FROM artworks aw JOIN events e ON e.work_id=aw.work_id AND e.slug=${q(`artwork-${work.slug}`)} WHERE aw.work_id=${q(WORK_ID)} AND aw.slug=${q(work.slug)} ON CONFLICT DO NOTHING;`,
      `INSERT INTO event_sources(event_id,source_id) SELECT e.id,aws.source_id FROM events e JOIN artworks aw ON aw.work_id=e.work_id AND aw.slug=${q(work.slug)} JOIN artwork_sources aws ON aws.artwork_id=aw.id WHERE e.work_id=${q(WORK_ID)} AND e.slug=${q(`artwork-${work.slug}`)} ON CONFLICT DO NOTHING;`,
    );
    if (work.creationLocation || work.currentLocation) {
      const locationSlug = work.creationLocation ?? work.currentLocation!;
      lines.push(`INSERT INTO event_locations(event_id,location_id,role,position) SELECT e.id,l.id,'site',0 FROM events e JOIN locations l ON l.work_id=e.work_id AND l.slug=${q(locationSlug)} WHERE e.work_id=${q(WORK_ID)} AND e.slug=${q(`artwork-${work.slug}`)} ON CONFLICT DO NOTHING;`);
    }
    for (const artistSlug of work.artists) {
      lines.push(
        `INSERT INTO artist_event_links(work_id,artist_id,event_id,role) SELECT ${q(WORK_ID)},a.id,e.id,'creator' FROM artists a JOIN events e ON e.work_id=a.work_id AND e.slug=${q(`artwork-${work.slug}`)} WHERE a.work_id=${q(WORK_ID)} AND a.slug=${q(artistSlug)} ON CONFLICT DO NOTHING;`,
        `INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary) SELECT e.id,a.character_id,'creator',0,true FROM artists a JOIN events e ON e.work_id=a.work_id AND e.slug=${q(`artwork-${work.slug}`)} WHERE a.work_id=${q(WORK_ID)} AND a.slug=${q(artistSlug)} AND a.character_id IS NOT NULL ON CONFLICT DO NOTHING;`,
      );
    }
  });
  lines.push("");

  const modernArtistSlugs = Object.entries(existingArtistChapter).filter(([, chapter]) => ["modernism", "modernism-early", "modernism-and-war"].includes(chapter));
  for (const [artistSlug, chapterSlug] of modernArtistSlugs) {
    lines.push(
      `UPDATE artworks aw SET chapter_id=ch.id FROM artists a,chapters ch WHERE aw.primary_artist_id=a.id AND aw.work_id=${q(WORK_ID)} AND a.slug=${q(artistSlug)} AND ch.work_id=aw.work_id AND ch.slug=${q(chapterSlug)} AND aw.sort_order<=96;`,
      `UPDATE events e SET chapter_id=aw.chapter_id FROM artwork_event_links ael JOIN artworks aw ON aw.id=ael.artwork_id WHERE e.id=ael.event_id AND aw.work_id=${q(WORK_ID)} AND aw.primary_artist_id=(SELECT id FROM artists WHERE work_id=${q(WORK_ID)} AND slug=${q(artistSlug)}) AND aw.sort_order<=96;`,
    );
  }
  lines.push("");

  lines.push(
    `UPDATE artwork_translations t SET summary=CASE WHEN t.locale='zh-CN' THEN CASE WHEN at.name IS NULL THEN '《'||t.title||'》以'||aw.medium||'保存匿名或集体创作的关键视觉传统。' ELSE '《'||t.title||'》由'||at.name||'以'||aw.medium||'创作，'||CASE WHEN aw.medium ~* 'architecture|cathedral|portal|colonnade|urban design' THEN '以结构、光线和行走路线组织空间。' WHEN aw.medium ~* 'sculpture|bronze|marble|relief|tympanum' THEN '以体量、姿态和环绕观看建立形象。' WHEN aw.medium ~* 'manuscript|etching|woodcut|lithograph|print|poster|embroidery' THEN '以线条、层次和可传播媒介组织图像。' WHEN aw.medium ~* 'mosaic|fresco' THEN '把图像、色彩和建筑表面结合。' WHEN aw.medium ~* 'readymade|wheel|urinal|tape|collage' THEN '重新界定材料、制作与艺术制度。' ELSE '以构图、色彩、光线和空间关系组织观看。' END END ELSE CASE WHEN at.name IS NULL THEN t.title||' preserves a major anonymous or collective visual tradition in '||aw.medium||'.' ELSE t.title||', made by '||at.name||' in '||aw.medium||', organises a key problem of form, image and viewing.' END END,description=CASE WHEN t.locale='zh-CN' THEN '《'||t.title||'》创作于'||CASE WHEN aw.creation_start_year=aw.creation_end_year THEN CASE WHEN aw.creation_start_year<0 THEN '约公元前 '||abs(aw.creation_start_year)||' 年' ELSE aw.creation_start_year||' 年' END ELSE CASE WHEN aw.creation_start_year<0 AND aw.creation_end_year<0 THEN '约公元前 '||abs(aw.creation_start_year)||'–'||abs(aw.creation_end_year)||' 年' ELSE aw.creation_start_year||'–'||aw.creation_end_year||' 年' END END||'，媒介为'||aw.medium||'。'||CASE WHEN aw.medium ~* 'architecture|cathedral|portal|colonnade|urban design' THEN '作品把结构、光线、表面装饰与人的行走路线组织为整体空间。' WHEN aw.medium ~* 'sculpture|bronze|marble|relief|tympanum' THEN '作品通过体量、姿态、表面和环绕观看建立形象。' WHEN aw.medium ~* 'manuscript|etching|woodcut|lithograph|print|poster|embroidery' THEN '作品利用线条、层次与可传播的图像媒介组织叙事。' WHEN aw.medium ~* 'mosaic|fresco' THEN '作品把图像、色彩与建筑表面结合，使观看与场所不可分离。' WHEN aw.medium ~* 'readymade|wheel|urinal|tape|collage' THEN '作品重新界定日常材料、制作行为与艺术制度之间的关系。' ELSE '作品通过构图、色彩、光线和人物或空间关系组织观看。' END||CASE ch.slug WHEN 'classical-antiquity' THEN '它显示古典艺术如何以比例、身体和公共纪念塑造后世的视觉标准。' WHEN 'medieval' THEN '它连接礼仪、城市工坊、建筑空间和中世纪图像传播。' WHEN 'renaissance' THEN '它体现文艺复兴对古典传统、自然观察、透视和个人创作身份的重组。' WHEN 'baroque' THEN '它体现巴洛克或洛可可对戏剧、感官、宫廷与宗教空间的调动。' WHEN 'neoclassicism-and-romanticism' THEN '它把学院规范、革命历史、个人情感和崇高自然置于新的公共观看中。' WHEN 'modernism' THEN '它把现代生活、社会现实和变化中的光色经验带入艺术主叙事。' WHEN 'modernism-early' THEN '它推动结构、象征、表现性形象与世纪末文化之间的新关系。' ELSE '它回应工业化、战争与先锋运动对艺术材料、形式和观念的重构。' END ELSE t.title||' was made in '||CASE WHEN aw.creation_start_year=aw.creation_end_year THEN CASE WHEN aw.creation_start_year<0 THEN 'c. '||abs(aw.creation_start_year)||' BCE' ELSE aw.creation_start_year::text END ELSE CASE WHEN aw.creation_start_year<0 AND aw.creation_end_year<0 THEN 'c. '||abs(aw.creation_start_year)||'–'||abs(aw.creation_end_year)||' BCE' ELSE aw.creation_start_year||'–'||aw.creation_end_year END END||' in '||aw.medium||'. '||CASE WHEN aw.medium ~* 'architecture|cathedral|portal|colonnade|urban design' THEN 'It organises structure, light, surface and bodily movement as a single spatial experience. ' WHEN aw.medium ~* 'sculpture|bronze|marble|relief|tympanum' THEN 'It builds meaning through volume, pose, surface and viewing in the round. ' WHEN aw.medium ~* 'manuscript|etching|woodcut|lithograph|print|poster|embroidery' THEN 'It uses line, layering and a reproducible or portable image medium to organise narrative. ' WHEN aw.medium ~* 'mosaic|fresco' THEN 'It binds image and colour to an architectural surface, making viewing inseparable from place. ' WHEN aw.medium ~* 'readymade|wheel|urinal|tape|collage' THEN 'It redefines the relation between ordinary material, artistic making and the institution of art. ' ELSE 'It organises viewing through composition, colour, light and the relation of figures or space. ' END||CASE ch.slug WHEN 'classical-antiquity' THEN 'It shows how classical art made proportion, the body and public monument into enduring visual standards.' WHEN 'medieval' THEN 'It connects ritual, urban workshops, architectural space and medieval image circulation.' WHEN 'renaissance' THEN 'It reflects the Renaissance reworking of antiquity, natural observation, perspective and artistic identity.' WHEN 'baroque' THEN 'It mobilises Baroque or Rococo drama, sensation, court culture and religious space.' WHEN 'neoclassicism-and-romanticism' THEN 'It places academic order, revolutionary history, personal feeling and sublime nature before a new public.' WHEN 'modernism' THEN 'It brings modern life, social reality and changing experiences of light and colour into the main narrative of art.' WHEN 'modernism-early' THEN 'It advances new relations among structure, symbolism, expressive imagery and fin-de-siècle culture.' ELSE 'It answers industrialisation, war and the avant-garde reconstruction of artistic material, form and concept.' END END FROM artworks aw LEFT JOIN artists a ON a.id=aw.primary_artist_id LEFT JOIN artist_translations at ON at.artist_id=a.id JOIN chapters ch ON ch.id=aw.chapter_id WHERE t.artwork_id=aw.id AND aw.work_id=${q(WORK_ID)} AND (at.locale=t.locale OR at.artist_id IS NULL);`,
  );
  lines.push("");

  POSTWAR_EVENTS.forEach((event, index) => {
    const sequence = 201 + index;
    const endYear = event.endYear ?? event.year;
    lines.push(
      `INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id) SELECT pg_temp.stable_uuid(${q(`event:postwar:${event.slug}`)}),${q(WORK_ID)},${q(event.slug)},${sequence},'verified_historical','social',${q(event.endYear ? "range" : "exact")},'gregorian',${event.year},${endYear},'high',ch.id FROM chapters ch WHERE ch.work_id=${q(WORK_ID)} AND ch.slug='postwar-heritage' ON CONFLICT(work_id,slug) DO UPDATE SET sequence=EXCLUDED.sequence,historical_start_year=EXCLUDED.historical_start_year,historical_end_year=EXCLUDED.historical_end_year,chapter_id=EXCLUDED.chapter_id;`,
      `INSERT INTO event_translations(event_id,locale,title,summary,status,time_label,detail,significance) SELECT id,'zh-CN',${q(event.titleZh)},${q(event.summaryZh)},'published',${q(event.endYear ? `${event.year}–${event.endYear} 年` : `${event.year} 年`)},${q(event.summaryZh)},${q(event.significanceZh)} FROM events WHERE work_id=${q(WORK_ID)} AND slug=${q(event.slug)} ON CONFLICT(event_id,locale) DO UPDATE SET title=EXCLUDED.title,summary=EXCLUDED.summary,status=EXCLUDED.status,time_label=EXCLUDED.time_label,detail=EXCLUDED.detail,significance=EXCLUDED.significance;`,
      `INSERT INTO event_translations(event_id,locale,title,summary,status,time_label,detail,significance) SELECT id,'en',${q(event.titleEn)},${q(event.summaryEn)},'published',${q(event.endYear ? `${event.year}–${event.endYear}` : `${event.year}`)},${q(event.summaryEn)},${q(event.significanceEn)} FROM events WHERE work_id=${q(WORK_ID)} AND slug=${q(event.slug)} ON CONFLICT(event_id,locale) DO UPDATE SET title=EXCLUDED.title,summary=EXCLUDED.summary,status=EXCLUDED.status,time_label=EXCLUDED.time_label,detail=EXCLUDED.detail,significance=EXCLUDED.significance;`,
      `INSERT INTO event_locations(event_id,location_id,role,position) SELECT e.id,l.id,'site',0 FROM events e JOIN locations l ON l.work_id=e.work_id AND l.slug=${q(event.location)} WHERE e.work_id=${q(WORK_ID)} AND e.slug=${q(event.slug)} ON CONFLICT DO NOTHING;`,
      `INSERT INTO event_sources(event_id,source_id) SELECT e.id,pg_temp.stable_uuid(${q(`source:event:${event.sourceKey}`)}) FROM events e WHERE e.work_id=${q(WORK_ID)} AND e.slug=${q(event.slug)} ON CONFLICT DO NOTHING;`,
    );
  });
  lines.push("");

  for (const relation of RELATIONS) {
    const direction = relation.type === "parallel" || relation.type === "network" ? "bidirectional" : "source_to_target";
    lines.push(
      `INSERT INTO artist_relations(id,work_id,from_artist_id,to_artist_id,relation_type,strength) SELECT pg_temp.stable_uuid(${q(`artist-relation:${relation.from}:${relation.to}:${relation.type}`)}),${q(WORK_ID)},f.id,t.id,${q(relation.type)},${relation.strength} FROM artists f JOIN artists t ON t.work_id=f.work_id AND t.slug=${q(relation.to)} WHERE f.work_id=${q(WORK_ID)} AND f.slug=${q(relation.from)} ON CONFLICT(work_id,from_artist_id,to_artist_id,relation_type) DO UPDATE SET strength=EXCLUDED.strength;`,
      `INSERT INTO artist_relation_translations(relation_id,locale,label,summary,status) VALUES (pg_temp.stable_uuid(${q(`artist-relation:${relation.from}:${relation.to}:${relation.type}`)}),'zh-CN',${q(relation.zh)},${q(relation.summaryZh)},'published'),(pg_temp.stable_uuid(${q(`artist-relation:${relation.from}:${relation.to}:${relation.type}`)}),'en',${q(relation.en)},${q(relation.summaryEn)},'published') ON CONFLICT(relation_id,locale) DO UPDATE SET label=EXCLUDED.label,summary=EXCLUDED.summary,status=EXCLUDED.status;`,
      `INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status) SELECT pg_temp.stable_uuid(${q(`character-relation:${relation.from}:${relation.to}:${relation.type}`)}),${q(WORK_ID)},f.character_id,t.character_id,${q(relation.type)},${q(direction)},'positive',${relation.strength},'ended' FROM artists f JOIN artists t ON t.work_id=f.work_id AND t.slug=${q(relation.to)} WHERE f.work_id=${q(WORK_ID)} AND f.slug=${q(relation.from)} AND f.character_id IS NOT NULL AND t.character_id IS NOT NULL ON CONFLICT(work_id,from_character_id,to_character_id,relation_type) DO UPDATE SET direction=EXCLUDED.direction,sentiment=EXCLUDED.sentiment,strength=EXCLUDED.strength,status=EXCLUDED.status;`,
      `INSERT INTO relation_translations(relation_id,locale,label,summary,status) VALUES (pg_temp.stable_uuid(${q(`character-relation:${relation.from}:${relation.to}:${relation.type}`)}),'zh-CN',${q(relation.zh)},${q(relation.summaryZh)},'published'),(pg_temp.stable_uuid(${q(`character-relation:${relation.from}:${relation.to}:${relation.type}`)}),'en',${q(relation.en)},${q(relation.summaryEn)},'published') ON CONFLICT(relation_id,locale) DO UPDATE SET label=EXCLUDED.label,summary=EXCLUDED.summary,status=EXCLUDED.status;`,
      `INSERT INTO relation_sources(relation_id,source_id) VALUES (pg_temp.stable_uuid(${q(`character-relation:${relation.from}:${relation.to}:${relation.type}`)}),pg_temp.stable_uuid('source:eah-met-timeline')) ON CONFLICT DO NOTHING;`,
    );
  }
  lines.push("");

  lines.push(
    `INSERT INTO seed_history(version) VALUES ('055_european_art_disciplined_expansion') ON CONFLICT DO NOTHING;`,
    "COMMIT;",
    "",
  );
  return lines.join("\n");
}

async function main(): Promise<void> {
  await writeFile(output, sql(), "utf8");
  console.log(`wrote ${output}`);
  console.log(`expansion: ${ARTISTS.length} artists, ${ARTWORKS.length} artworks, ${POSTWAR_EVENTS.length} postwar events, ${LOCATIONS.length} locations, ${RELATIONS.length} relations`);
}

main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : error);
  process.exitCode = 1;
});
