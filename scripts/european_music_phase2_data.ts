/**
 * Curated expansion manifest for the second European classical music release.
 *
 * The Foundation manifest remains immutable.  This file is an additive seed
 * for the next release, which keeps seed history reproducible while making the
 * expansion counts and the learning-surface links auditable before loading.
 */
import { PEOPLE, RELATIONS } from "./european_music_foundation_data.ts";
import type {
  ChapterSlug,
  CompositionSeed,
  InstitutionSeed,
  InstrumentSeed,
  LocationSeed,
  PersonSeed,
  RelationSeed,
  ScoreSeed,
  StyleSeed,
} from "./european_music_foundation_data.ts";

export interface Phase2EventSeed {
  slug: string;
  chapter: ChapterSlug;
  year: number;
  endYear: number;
  type: string;
  zh: string;
  en: string;
  summaryZh: string;
  summaryEn: string;
  location?: string;
  person?: string;
  composition?: string;
  institution?: string;
}

export interface LearningUnitSeed {
  slug: string;
  kind: "listening" | "score_reading" | "comparison" | "route";
  difficulty: "introductory" | "intermediate" | "advanced";
  minutes: number;
  zh: string;
  en: string;
  summaryZh: string;
  summaryEn: string;
  objectiveZh: string;
  objectiveEn: string;
  compositions: string[];
  fragments: string[];
}

function rows(input: string): string[][] {
  return input.trim().split(/\n+/u).map((line) => line.split("|").map((cell) => cell.trim()));
}

export const PHASE2_PEOPLE: PersonSeed[] = rows(`
adam-de-la-halle|亚当·德·拉·阿勒|Adam de la Halle|1240|1287|medieval-music|composer|4|arras
jacopo-da-bologna|雅各布·达·博洛尼亚|Jacopo da Bologna|1340|1386|medieval-music|composer|4|bologna
guillaume-dufay|纪尧姆·迪费|Guillaume Dufay|1397|1474|renaissance-music|composer|5|dijon
cipriano-de-rore|奇普里亚诺·德·罗雷|Cipriano de Rore|1515|1565|renaissance-music|composer|4|antwerp
maddalena-casulana|玛达莱娜·卡祖拉娜|Maddalena Casulana|1544|1590|renaissance-music|composer|4|florence
tomas-luis-de-victoria|托马斯·路易斯·德·维多利亚|Tomás Luis de Victoria|1548|1611|renaissance-music|composer|5|madrid
heinrich-schutz|海因里希·许茨|Heinrich Schütz|1585|1672|baroque-music|composer|5|dresden
jean-baptiste-lully|让-巴蒂斯特·吕利|Jean-Baptiste Lully|1632|1687|baroque-music|composer|5|paris
domenico-scarlatti|多梅尼科·斯卡拉蒂|Domenico Scarlatti|1685|1757|baroque-music|composer|5|naples
carl-philipp-emanuel-bach|卡尔·菲利普·埃马努埃尔·巴赫|Carl Philipp Emanuel Bach|1714|1788|classical-period|composer|5|hamburg
luigi-cherubini|路易吉·凯鲁比尼|Luigi Cherubini|1760|1842|classical-period|composer|4|paris
johann-nepomuk-hummel|约翰·内波穆克·胡梅尔|Johann Nepomuk Hummel|1778|1837|classical-period|composer|4|vienna
felix-mendelssohn|费利克斯·门德尔松|Felix Mendelssohn|1809|1847|romantic-period|composer|5|leipzig
clara-schumann|克拉拉·舒曼|Clara Schumann|1819|1896|romantic-period|composer|5|leipzig
anton-bruckner|安东·布鲁克纳|Anton Bruckner|1824|1896|romantic-period|composer|5|vienna
modest-mussorgsky|莫杰斯特·穆索尔斯基|Modest Mussorgsky|1839|1881|romantic-period|composer|4|moscow
richard-strauss|理查德·施特劳斯|Richard Strauss|1864|1949|modernism-and-war|composer|5|munich
jean-sibelius|让·西贝柳斯|Jean Sibelius|1865|1957|modernism-and-war|composer|5|helsinki
alban-berg|阿尔班·贝尔格|Alban Berg|1885|1935|modernism-and-war|composer|5|vienna
paul-hindemith|保罗·欣德米特|Paul Hindemith|1895|1963|modernism-and-war|composer|4|berlin
dmitri-shostakovich|德米特里·肖斯塔科维奇|Dmitri Shostakovich|1906|1975|modernism-and-war|composer|5|moscow
luciano-berio|卢恰诺·贝里奥|Luciano Berio|1925|2003|postwar-and-contemporary|composer|4|milan
karlheinz-stockhausen|卡尔海因茨·施托克豪森|Karlheinz Stockhausen|1928|2007|postwar-and-contemporary|composer|5|cologne
sofia-gubaidulina|索菲亚·古拜杜丽娜|Sofia Gubaidulina|1931|2025|postwar-and-contemporary|composer|5|chistopol
`).map(([slug, zh, en, birth, death, chapter, role, importance, city]) => ({
  slug, zh, en, birth: Number(birth), death: Number(death), chapter: chapter as ChapterSlug,
  role, importance: Number(importance), city,
}));

export const PHASE2_COMPOSITIONS: CompositionSeed[] = rows(`
le-jeu-de-robin-et-de-marion|adam-de-la-halle|《罗班与玛丽昂的游戏》|Le Jeu de Robin et de Marion|1282|1282|music drama|pastourelle| |arras
li-gieus-d-adam|adam-de-la-halle|《亚当的游戏》|Le Jeu d'Adam|1276|1276|music drama|liturgical play| |arras
non-al-suo-amante|jacopo-da-bologna|《并非献给他的爱人》|Non al suo amante|1350|1350|secular song|madrigal| |bologna
fenice-fu|jacopo-da-bologna|《他曾是凤凰》|Fenice fu|1350|1350|secular song|madrigal| |bologna
questa-fanciulla|jacopo-da-bologna|《这位少女》|Questa fanciulla|1360|1360|secular song|madrigal| |bologna
nuper-rosarum-flores|guillaume-dufay|《新玫瑰之花》|Nuper rosarum flores|1436|1436|motet|isorhythmic motet| |dijon
missa-l-homme-arme-dufay|guillaume-dufay|《武装的人》弥撒|Missa L'homme armé|1450|1450|mass|cantus-firmus mass| |dijon
anchor-che-col-partire|cipriano-de-rore|《即使我离去》|Anchor che col partire|1547|1547|madrigal|madrigal| |antwerp
il-frutto|maddalena-casulana|《果实》|Il frutto|1566|1566|madrigal|madrigal| |florence
o-magnus-mysterium-victoria|tomas-luis-de-victoria|《哦，伟大的奥秘》|O magnum mysterium|1572|1572|motet|motet| |madrid
sagittarius-davids|heinrich-schutz|《大卫的诗篇》|Psalmen Davids|1619|1619|sacred music|sacred concerto| |dresden
musikalische-exequien|heinrich-schutz|《音乐葬礼》|Musikalische Exequien|1636|1636|sacred music|funeral music| |dresden
geistliche-chormusik|heinrich-schutz|《圣乐合唱曲》|Geistliche Chormusik|1648|1648|sacred music|motet collection| |dresden
armide-lully|jean-baptiste-lully|《阿尔米德》|Armide|1686|1686|opera|tragédie en musique| |paris
le-bourgeois-gentilhomme|jean-baptiste-lully|《贵人迷》|Le Bourgeois gentilhomme|1670|1670|music drama|comédie-ballet| |paris
sonata-k141|domenico-scarlatti|《键盘奏鸣曲 K.141》|Keyboard Sonata K.141|1730|1730|keyboard music|sonata| |naples
sonata-k380|domenico-scarlatti|《键盘奏鸣曲 K.380》|Keyboard Sonata K.380|1738|1738|keyboard music|sonata| |naples
stabat-mater-scarlatti|domenico-scarlatti|《圣母悼歌》|Stabat Mater|1715|1715|sacred music|polychoral setting| |naples
symphony-in-e-flat-cpe|carl-philipp-emanuel-bach|《降E大调交响曲》|Symphony in E-flat major|1776|1776|symphony|symphony| |hamburg
concerto-in-a-cpe|carl-philipp-emanuel-bach|《A大调键盘协奏曲》|Keyboard Concerto in A major|1765|1765|concerto|keyboard concerto| |hamburg
sonata-in-a-c-cpe|carl-philipp-emanuel-bach|《C大调奏鸣曲》|Sonata in C major|1779|1779|keyboard music|sonata| |hamburg
m-dedea|luigi-cherubini|《美狄亚》|Médée|1797|1797|opera|opera| |paris
requiem-in-c-cherubini|luigi-cherubini|《C小调安魂曲》|Requiem in C minor|1816|1816|sacred music|requiem| |paris
trumpet-concerto-hummel|johann-nepomuk-hummel|《小号协奏曲》|Trumpet Concerto|1803|1803|concerto|concerto| |vienna
piano-concerto-a-minor-hummel|johann-nepomuk-hummel|《A小调钢琴协奏曲》|Piano Concerto in A minor|1816|1816|concerto|concerto| |vienna
a-midsummer-nights-dream|felix-mendelssohn|《仲夏夜之梦》|A Midsummer Night's Dream|1826|1826|incidental music|overture and incidental music| |leipzig
violin-concerto-mendelssohn|felix-mendelssohn|《E小调小提琴协奏曲》|Violin Concerto in E minor|1844|1844|concerto|violin concerto| |leipzig
hebrides-overture|felix-mendelssohn|《赫布里底群岛》|The Hebrides|1830|1830|orchestral music|concert overture| |leipzig
piano-trio-clara|clara-schumann|《G小调钢琴三重奏》|Piano Trio in G minor|1846|1846|chamber music|piano trio| |leipzig
piano-concerto-clara|clara-schumann|《A小调钢琴协奏曲》|Piano Concerto in A minor|1835|1835|concerto|piano concerto| |leipzig
symphony-no7-bruckner|anton-bruckner|《第七交响曲》|Symphony No. 7|1883|1883|symphony|symphony| |vienna
te-deum-bruckner|anton-bruckner|《感恩赞》|Te Deum|1884|1884|sacred music|te deum| |vienna
symphony-no4-bruckner|anton-bruckner|《第四交响曲》|Symphony No. 4 “Romantic”|1878|1878|symphony|symphony| |vienna
pictures-at-an-exhibition|modest-mussorgsky|《展览会上的图画》|Pictures at an Exhibition|1874|1874|keyboard music|suite| |moscow
night-on-bald-mountain|modest-mussorgsky|《荒山之夜》|Night on Bald Mountain|1867|1867|orchestral music|tone poem| |moscow
salome-strauss|richard-strauss|《莎乐美》|Salome|1905|1905|opera|opera| |munich
symphony-no5-sibelius|jean-sibelius|《第五交响曲》|Symphony No. 5|1915|1915|symphony|symphony| |helsinki
woyzeck|alban-berg|《沃采克》|Wozzeck|1925|1925|opera|opera| |vienna
violin-concerto-berg|alban-berg|《小提琴协奏曲》|Violin Concerto|1935|1935|concerto|violin concerto| |vienna
mathis-der-maler|paul-hindemith|《画家马蒂斯》|Mathis der Maler|1934|1934|symphony|symphony| |berlin
symphony-no5-shostakovich|dmitri-shostakovich|《第五交响曲》|Symphony No. 5|1937|1937|symphony|symphony| |moscow
sinfonia-berio|luciano-berio|《交响曲》|Sinfonia|1968|1968|vocal orchestral music|symphony| |milan
sequenza-i|luciano-berio|《序列 I》|Sequenza I|1958|1958|solo instrumental music|solo flute| |milan
coro-berio|luciano-berio|《合唱》|Coro|1976|1976|vocal orchestral music|choral cycle| |milan
gesang-der-junglinge|karlheinz-stockhausen|《少年之歌》|Gesang der Jünglinge|1956|1956|electronic music|electronic composition| |cologne
kontakte|karlheinz-stockhausen|《接触》|Kontakte|1960|1960|electronic music|electronic composition| |cologne
offertorium-gubaidulina|sofia-gubaidulina|《奉献》|Offertorium|1980|1980|concerto|violin concerto| |chistopol
de-profundis-gubaidulina|sofia-gubaidulina|《深渊》|De profundis|1978|1978|accordion solo|solo work| |chistopol
`).map(([slug, person, zh, en, start, end, genre, form, key, city]) => ({
  slug, person, zh, en, start: Number(start), end: Number(end), genre, form, key, city,
}));

export const PHASE2_STYLES: StyleSeed[] = rows(`
medieval-motet|中世纪经文歌|Medieval motet|historical_style|medieval-music
ars-nova-rhythm|新艺术节奏体系|Ars nova rhythmic practice|technique|medieval-music
madrigalism|牧歌描绘|Madrigalism|technique|renaissance-music
cori-spezzati|分置合唱|Cori spezzati|school|renaissance-music
german-sacred-baroque|德意志圣乐巴洛克|German sacred Baroque|school|baroque-music
french-overture|法国序曲风格|French overture style|form|baroque-music
scarlatti-keyboard-style|斯卡拉蒂键盘风格|Scarlatti keyboard style|school|baroque-music
mannheim-school|曼海姆乐派|Mannheim school|school|classical-period
empfindsamkeit|感伤主义|Empfindsamkeit|historical_style|classical-period
late-romantic-symphonism|晚期浪漫主义交响性|Late-Romantic symphonism|historical_style|romantic-period
musical-expressionism|音乐表现主义实践|Musical expressionist practice|technique|modernism-and-war
electroacoustic-music|电子声学音乐|Electroacoustic music|technique|postwar-and-contemporary
`).map(([slug, zh, en, kind, chapter]) => ({ slug, zh, en, kind, chapter: chapter as ChapterSlug }));

export const PHASE2_INSTRUMENTS: InstrumentSeed[] = rows(`
rebec|里贝克琴|Rebec|plucked_and_early|321.321|1000|1600
shawm|肖姆管|Shawm|woodwinds|422.112|1000|1700
sackbut|萨克布号|Sackbut|brass|423.22|1400|1700
baroque-trumpet|巴洛克小号|Baroque trumpet|brass|423.121.12|1600|1800
mandolin|曼陀林|Mandolin|plucked_and_early|321.321|1650|2026
harmonium|簧风琴|Harmonium|keyboards|412.132|1840|1950
celesta|钢片琴|Celesta|keyboards|111.222|1886|2026
english-horn|英国管|English horn|woodwinds|422.112-62|1750|2026
tuba|大号|Tuba|brass|423.232|1835|2026
marimba|马林巴|Marimba|percussion|111.212|1890|2026
ondes-martenot|马特诺电子琴|Ondes Martenot|mechanical_and_electronic|531.1|1928|2026
glass-harmonica|玻璃琴|Glass harmonica|mechanical_and_electronic|147.12|1761|1900
`).map(([slug, zh, en, family, hs, start, end]) => ({
  slug, zh, en, family, hs, start: Number(start), end: Number(end),
}));

export const PHASE2_LOCATIONS: LocationSeed[] = rows(`
arras|阿拉斯|Arras|arras|2.7775|50.2910
bologna|博洛尼亚|Bologna|bologna|11.3426|44.4949
dijon|第戎|Dijon|dijon|5.0415|47.3220
mannheim|曼海姆|Mannheim|mannheim|8.4660|49.4875
berlin|柏林|Berlin|berlin|13.4050|52.5200
stockholm|斯德哥尔摩|Stockholm|stockholm|18.0686|59.3293
helsinki|赫尔辛基|Helsinki|helsinki|24.9384|60.1699
brussels|布鲁塞尔|Brussels|brussels|4.3517|50.8503
antwerp|安特卫普|Antwerp|antwerp|4.4025|51.2194
chistopol|奇斯托波尔|Chistopol|chistopol|50.6438|55.3631
cologne|科隆|Cologne|cologne|6.9603|50.9375
zurich|苏黎世|Zurich|zurich|8.5417|47.3769
`).map(([slug, zh, en, city, lng, lat]) => ({
  slug, zh, en, city, lng: Number(lng), lat: Number(lat),
}));

export const PHASE2_INSTITUTIONS: InstitutionSeed[] = rows(`
saxony-court-dresden|萨克森宫廷乐团|Saxon Court Dresden|court|dresden|1547|
academie-royale-de-musique|皇家音乐学院|Académie Royale de Musique|opera_house|paris|1669|
mannheim-court-orchestra|曼海姆宫廷乐团|Mannheim Court Orchestra|ensemble|mannheim|1720|1778
leipzig-conservatory|莱比锡音乐学院|Leipzig Conservatory|conservatory|leipzig|1843|
mendelssohn-house-leipzig|门德尔松故居|Mendelssohn House Leipzig|archive|leipzig|1845|
berlin-state-opera|柏林国家歌剧院|Berlin State Opera|opera_house|berlin|1742|
sibelius-academy|西贝柳斯学院|Sibelius Academy|conservatory|helsinki|1882|
berlin-electronic-studio|柏林电子音乐工作室|Berlin Electronic Studio|archive|berlin|1953|
`).map(([slug, zh, en, type, city, founded, closed]) => ({
  slug, zh, en, type, city, founded: Number(founded), closed: closed ? Number(closed) : null,
}));

export const PHASE2_SCORE_FRAGMENTS: ScoreSeed[] = [
  ["adam-robin-marion", "le-jeu-de-robin-et-de-marion", [1, 4], "chant"],
  ["adam-jeu", "li-gieus-d-adam", [1, 4], "organum"],
  ["jacopo-non-al-suo", "non-al-suo-amante", [1, 4], "polyphony"],
  ["jacopo-fenice", "fenice-fu", [1, 4], "polyphony"],
  ["dufay-nuper", "nuper-rosarum-flores", [1, 4], "polyphony"],
  ["dufay-lhomme-arme", "missa-l-homme-arme-dufay", [1, 4], "polyphony"],
  ["rore-anchor", "anchor-che-col-partire", [1, 4], "polyphony"],
  ["casulana-il-frutto", "il-frutto", [1, 4], "polyphony"],
  ["victoria-magnus", "o-magnus-mysterium-victoria", [1, 4], "polyphony"],
  ["schutz-sagittarius", "sagittarius-davids", [1, 4], "continuo"],
  ["schutz-exequien", "musikalische-exequien", [1, 4], "continuo"],
  ["schutz-chormusik", "geistliche-chormusik", [1, 4], "polyphony"],
  ["lully-armide", "armide-lully", [1, 4], "dance"],
  ["lully-bourgeois", "le-bourgeois-gentilhomme", [1, 4], "dance"],
  ["scarlatti-k141", "sonata-k141", [1, 4], "continuo"],
  ["scarlatti-k380", "sonata-k380", [1, 4], "continuo"],
  ["cpe-symphony", "symphony-in-e-flat-cpe", [1, 4], "classical"],
  ["cpe-concerto", "concerto-in-a-cpe", [1, 4], "classical"],
  ["cherubini-medee", "m-dedea", [1, 4], "classical"],
  ["cherubini-requiem", "requiem-in-c-cherubini", [1, 4], "classical"],
  ["hummel-trumpet", "trumpet-concerto-hummel", [1, 4], "classical"],
  ["hummel-piano", "piano-concerto-a-minor-hummel", [1, 4], "classical"],
  ["mendelssohn-hebrides", "hebrides-overture", [1, 4], "romantic"],
  ["mendelssohn-violin", "violin-concerto-mendelssohn", [1, 4], "romantic"],
  ["clara-trio", "piano-trio-clara", [1, 4], "romantic"],
  ["bruckner-seven", "symphony-no7-bruckner", [1, 4], "romantic"],
  ["mussorgsky-pictures", "pictures-at-an-exhibition", [1, 4], "romantic"],
  ["strauss-salome", "salome-strauss", [1, 4], "modern"],
].map(([slug, composition, measures, pattern]) => ({
  slug, composition, measures: measures as [number, number], pattern: pattern as ScoreSeed["pattern"],
}));

export const PHASE2_SPECIAL_EVENTS: Phase2EventSeed[] = [
  {
    slug: "premiere-salome-strauss", chapter: "modernism-and-war", year: 1905, endYear: 1905, type: "premiere",
    zh: "《莎乐美》首演", en: "Premiere of Salome", summaryZh: "理查德·施特劳斯的歌剧在德累斯顿首演，标志着现代歌剧语汇的强烈转向。", summaryEn: "The Dresden premiere of Richard Strauss's opera marks a forceful turn in modern operatic language.", location: "dresden", person: "richard-strauss", composition: "salome-strauss",
  },
  {
    slug: "premiere-woyzeck", chapter: "modernism-and-war", year: 1925, endYear: 1925, type: "premiere",
    zh: "《沃采克》首演", en: "Premiere of Wozzeck", summaryZh: "贝尔格的歌剧完成从晚期浪漫主义到表现主义舞台结构的关键连接。", summaryEn: "Berg's opera creates a key bridge from late Romanticism to expressionist stage structure.", location: "berlin", person: "alban-berg", composition: "woyzeck",
  },
  {
    slug: "premiere-shostakovich-five", chapter: "modernism-and-war", year: 1937, endYear: 1937, type: "premiere",
    zh: "《第五交响曲》首演", en: "Premiere of Symphony No. 5", summaryZh: "肖斯塔科维奇第五交响曲的首演成为政治压力、公共聆听与交响叙事交汇的节点。", summaryEn: "The premiere of Shostakovich's Fifth Symphony joins political pressure, public listening, and symphonic narrative.", location: "moscow", person: "dmitri-shostakovich", composition: "symphony-no5-shostakovich",
  },
  {
    slug: "electronic-studio-stockhausen", chapter: "postwar-and-contemporary", year: 1956, endYear: 1956, type: "recording",
    zh: "电子音乐工作室与《少年之歌》", en: "Electronic studio work and Gesang der Jünglinge", summaryZh: "施托克豪森把人声、磁带与空间化处理带入战后电子音乐的学习路径。", summaryEn: "Stockhausen's work brings voice, tape, and spatial processing into a postwar electronic-music learning path.", location: "cologne", person: "karlheinz-stockhausen", composition: "gesang-der-junglinge",
  },
];

const anchorPeople = PEOPLE.slice(0, 24).map((person) => person.slug);
const relationRows: RelationSeed[] = [];
const relationKeys = new Set(RELATIONS.map((relation) => `${relation.from}|${relation.to}|${relation.type}`));
function addRelation(from: string, to: string, type: string, direction: RelationSeed["direction"], strength: number): void {
  const key = `${from}|${to}|${type}`;
  if (relationKeys.has(key)) throw new Error(`Duplicate phase 2 relation: ${key}`);
  relationKeys.add(key);
  relationRows.push({ from, to, type, direction, strength });
}

for (let index = 0; index < PHASE2_PEOPLE.length; index += 1) {
  const person = PHASE2_PEOPLE[index]!;
  const anchor = anchorPeople[index]!;
  addRelation(person.slug, anchor, "influence", "source_to_target", 4 - (index % 2));
  addRelation(anchor, person.slug, "reception_advocacy", "source_to_target", 3 + (index % 3));
  addRelation(person.slug, PHASE2_PEOPLE[(index + 1) % PHASE2_PEOPLE.length]!.slug, "institutional_peer", "bidirectional", 2 + (index % 4));
}
for (let index = 0; index < 8; index += 1) {
  addRelation(PHASE2_PEOPLE[index]!.slug, PHASE2_PEOPLE[index + 8]!.slug, "collaboration", "bidirectional", 3 + (index % 3));
}
export const PHASE2_RELATIONS = relationRows;

export const PHASE2_ROUTES = [
  ["vernacular-medieval-route", "中世纪世俗歌曲路径", "Medieval vernacular song route", ["arras", "bologna", "reims"]],
  ["nineteenth-century-women-composers", "十九世纪女性作曲家路径", "Nineteenth-century women composers route", ["leipzig", "vienna", "paris"]],
  ["nordic-modernism-route", "北欧现代主义路径", "Nordic modernism route", ["stockholm", "helsinki", "berlin"]],
  ["electronic-avant-garde-route", "电子先锋音乐路径", "Electronic avant-garde route", ["cologne", "zurich", "berlin", "paris"]],
] as const;

export const PHASE2_LEARNING_UNITS: LearningUnitSeed[] = [
  ["medieval-vernacular-song", "listening", "introductory", 15, "中世纪世俗歌曲：从戏剧到旋律", "Medieval vernacular song: from drama to melody", "以《罗班与玛丽昂的游戏》和雅各布的牧歌为入口，辨认节奏、语言与表演场景。", "Use Le Jeu de Robin et de Marion and Jacopo's madrigals to identify rhythm, language, and performance setting.", "能说出世俗歌曲与礼仪音乐在功能和听感上的两个差异。", "Name two functional and listening differences between secular song and liturgical music.", ["le-jeu-de-robin-et-de-marion", "non-al-suo-amante"], ["adam-robin-marion", "jacopo-non-al-suo"]],
  ["ars-nova-rhythm", "score_reading", "intermediate", 20, "新艺术的节奏组织", "Ars nova rhythmic organization", "通过雅各布和迪费的片段比较等时结构、复调层次与乐句呼吸。", "Compare Jacopo and Dufay excerpts to trace isorhythmic structure, polyphonic layers, and phrase breathing.", "在乐谱上标出两个重复或变化的节奏手势。", "Mark two repeated or transformed rhythmic gestures in the score.", ["fenice-fu", "nuper-rosarum-flores"], ["jacopo-fenice", "dufay-nuper"]],
  ["renaissance-women-and-print", "comparison", "introductory", 18, "文艺复兴的作者身份与印刷", "Authorship and print in the Renaissance", "比较卡祖拉娜、罗雷与维多利亚的体裁选择及其传播语境。", "Compare Casulana, Rore, and Victoria through genre choice and circulation context.", "区分作者身份、体裁标签和传播机构三个层次。", "Distinguish authorship, genre labels, and circulation institutions.", ["il-frutto", "anchor-che-col-partire", "o-magnus-mysterium-victoria"], ["casulana-il-frutto", "rore-anchor", "victoria-magnus"]],
  ["renaissance-sacred-architecture", "score_reading", "intermediate", 22, "复调与空间", "Polyphony and space", "把迪费和维多利亚的复调片段放回礼拜空间与合唱组织中聆听。", "Place Dufay and Victoria's polyphonic excerpts within worship space and choral organization.", "用一句话解释空间如何改变复调的可听层次。", "Explain in one sentence how space changes audible polyphonic layers.", ["missa-l-homme-arme-dufay", "o-magnus-mysterium-victoria"], ["dufay-lhomme-arme", "victoria-magnus"]],
  ["baroque-sacred-sound", "listening", "intermediate", 20, "巴洛克圣乐与记忆", "Baroque sacred sound and memory", "从许茨的圣乐中观察文本、低音支点和合唱声部的层次。", "Observe text, bass support, and choral layers in Schütz's sacred music.", "指出一个低音支点与一个声部模仿的听觉线索。", "Identify one bass-support cue and one imitative-voice cue.", ["musikalische-exequien", "geistliche-chormusik"], ["schutz-exequien", "schutz-chormusik"]],
  ["baroque-virtuoso-keyboard", "score_reading", "intermediate", 18, "键盘炫技与身体动作", "Keyboard virtuosity and physical gesture", "比较吕利舞曲节奏和斯卡拉蒂键盘手势如何组织身体感。", "Compare Lully's dance pulse with Scarlatti's keyboard gestures as bodily organization.", "标出一个规则脉动与一个跳跃性音型。", "Mark one regular pulse and one leaping figure.", ["sonata-k141", "le-bourgeois-gentilhomme"], ["scarlatti-k141", "lully-bourgeois"]],
  ["classical-sensitive-style", "comparison", "introductory", 16, "感伤主义到古典主义", "From Empfindsamkeit to Classicism", "以C.P.E.巴赫和凯鲁比尼的作品比较句法、情绪与公共体裁。", "Compare syntax, affect, and public genres through C. P. E. Bach and Cherubini.", "用三个形容词描述两种句法的差别并说明依据。", "Use three adjectives to describe the syntactic contrast and give evidence.", ["symphony-in-e-flat-cpe", "m-dedea"], ["cpe-symphony", "cherubini-medee"]],
  ["romantic-composer-identity", "comparison", "introductory", 20, "浪漫主义的作者肖像", "Romantic composer identity", "比较门德尔松、克拉拉·舒曼与布鲁克纳如何在作品中构造公共身份。", "Compare how Mendelssohn, Clara Schumann, and Bruckner construct public identity through works.", "区分传记叙事与作品证据，写出一条可核验的观察。", "Separate biographical narrative from work evidence in one verifiable observation.", ["piano-trio-clara", "hebrides-overture", "symphony-no7-bruckner"], ["clara-trio", "mendelssohn-hebrides", "bruckner-seven"]],
  ["romantic-orchestra", "listening", "intermediate", 22, "交响乐团的扩张", "The expanding Romantic orchestra", "聆听布鲁克纳、穆索尔斯基与施特劳斯的配器层次。", "Listen for orchestral layers in Bruckner, Mussorgsky, and Strauss.", "指出一个音色层叠和一个结构性高潮。", "Identify one timbral layer and one structural climax.", ["symphony-no4-bruckner", "pictures-at-an-exhibition", "salome-strauss"], ["bruckner-seven", "mussorgsky-pictures", "strauss-salome"]],
  ["modern-stage-and-expression", "score_reading", "advanced", 25, "现代舞台与表现主义", "Modern stage and expressionism", "从《莎乐美》和《沃采克》观察和声张力、舞台时间与人物心理。", "Trace harmonic tension, stage time, and character psychology in Salome and Wozzeck.", "在片段中标注一个张力累积点，并说明它如何服务戏剧。", "Annotate one accumulation of tension and explain its dramatic function.", ["salome-strauss", "woyzeck"], ["strauss-salome"]],
  ["modern-wartime-ethics", "comparison", "advanced", 25, "战争、制度与作曲选择", "War, institutions, and compositional choice", "把欣德米特、贝尔格和肖斯塔科维奇放入制度与战争的时间轴。", "Place Hindemith, Berg, and Shostakovich on a timeline of institutions and war.", "区分作品年代、首演节点与政治解释的证据等级。", "Distinguish evidence levels for composition dates, premieres, and political interpretations.", ["mathis-der-maler", "woyzeck", "symphony-no5-shostakovich"], []],
  ["postwar-electronic-listening", "listening", "advanced", 28, "人声、磁带与空间", "Voice, tape, and space", "以贝里奥和施托克豪森的作品进入战后电子与音色化听觉。", "Enter postwar electronic and timbral listening through Berio and Stockhausen.", "写出一个关于声音材料而非作曲家意图的听觉判断。", "Write one listening judgement about sound material rather than authorial intent.", ["gesang-der-junglinge", "sinfonia-berio"], []],
].map(([slug, kind, difficulty, minutes, zh, en, summaryZh, summaryEn, objectiveZh, objectiveEn, compositions, fragments]) => ({
  slug, kind: kind as LearningUnitSeed["kind"], difficulty: difficulty as LearningUnitSeed["difficulty"], minutes: Number(minutes), zh, en, summaryZh, summaryEn, objectiveZh, objectiveEn,
  compositions: compositions as string[], fragments: fragments as string[],
}));

export function assertPhase2Counts(): void {
  const expected = { people: 24, compositions: 48, styles: 12, instruments: 12, institutions: 8, locations: 12, relations: 80, scoreFragments: 28, specialEvents: 4, learningUnits: 12, routes: 4 };
  const actual = {
    people: PHASE2_PEOPLE.length, compositions: PHASE2_COMPOSITIONS.length, styles: PHASE2_STYLES.length,
    instruments: PHASE2_INSTRUMENTS.length, institutions: PHASE2_INSTITUTIONS.length, locations: PHASE2_LOCATIONS.length,
    relations: PHASE2_RELATIONS.length, scoreFragments: PHASE2_SCORE_FRAGMENTS.length, specialEvents: PHASE2_SPECIAL_EVENTS.length,
    learningUnits: PHASE2_LEARNING_UNITS.length, routes: PHASE2_ROUTES.length,
  };
  for (const [key, value] of Object.entries(expected)) if (actual[key as keyof typeof actual] !== value) throw new Error(`Phase 2 count mismatch for ${key}: expected ${value}, got ${actual[key as keyof typeof actual]}`);
  for (const person of PHASE2_PEOPLE) if (!PHASE2_COMPOSITIONS.some((composition) => composition.person === person.slug)) throw new Error(`Phase 2 composer has no composition: ${person.slug}`);
  for (const relation of PHASE2_RELATIONS) if (![...PEOPLE, ...PHASE2_PEOPLE].some((person) => person.slug === relation.from) || ![...PEOPLE, ...PHASE2_PEOPLE].some((person) => person.slug === relation.to)) throw new Error(`Unknown phase 2 relation endpoint: ${relation.from} -> ${relation.to}`);
}

assertPhase2Counts();
