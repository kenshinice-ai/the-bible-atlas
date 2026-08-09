/**
 * Foundation curation manifest for the European Classical Music History Atlas.
 *
 * This file is intentionally data-first.  It is the single source used by the
 * future SQL seed generator and the score/audio asset generator, so counts can
 * be audited before content is loaded.
 */

export type ChapterSlug =
  | "medieval-music"
  | "renaissance-music"
  | "baroque-music"
  | "classical-period"
  | "romantic-period"
  | "modernism-and-war"
  | "postwar-and-contemporary";

export interface PersonSeed {
  slug: string;
  zh: string;
  en: string;
  birth: number;
  death: number;
  chapter: ChapterSlug;
  role: string;
  importance: number;
  city: string;
}

export interface CompositionSeed {
  slug: string;
  person: string;
  zh: string;
  en: string;
  start: number;
  end: number;
  genre: string;
  form: string;
  key: string;
  city: string;
}

export interface StyleSeed {
  slug: string;
  zh: string;
  en: string;
  kind: string;
  chapter: ChapterSlug;
}

export interface InstrumentSeed {
  slug: string;
  zh: string;
  en: string;
  family: string;
  hs: string;
  start: number;
  end: number;
}

export interface InstitutionSeed {
  slug: string;
  zh: string;
  en: string;
  type: string;
  city: string;
  founded: number;
  closed: number | null;
}

export interface LocationSeed {
  slug: string;
  zh: string;
  en: string;
  city: string;
  lng: number;
  lat: number;
}

export interface ScoreSeed {
  slug: string;
  composition: string;
  measures: [number, number];
  pattern: "chant" | "organum" | "polyphony" | "dance" | "continuo" | "classical" | "romantic" | "modern";
}

export interface RelationSeed {
  from: string;
  to: string;
  type: string;
  direction: "source_to_target" | "bidirectional";
  strength: number;
}

function rows(input: string): string[][] {
  return input.trim().split(/\n+/u).map((line) => line.split("|").map((cell) => cell.trim()));
}

export const PEOPLE: PersonSeed[] = rows(`
hildegard-of-bingen|希尔德加德·冯·宾根|Hildegard of Bingen|1098|1179|medieval-music|composer|5|limoges
leonin|莱奥南|Léonin|1150|1201|medieval-music|composer|4|paris
perotin|佩罗坦|Pérotin|1160|1230|medieval-music|composer|4|paris
guillaume-de-machaut|纪尧姆·德·马肖|Guillaume de Machaut|1300|1377|medieval-music|composer|5|reims
philippe-de-vitry|菲利普·德·维特里|Philippe de Vitry|1291|1361|medieval-music|composer|4|paris
franco-of-cologne|科隆的弗朗科|Franco of Cologne|1220|1270|medieval-music|theorist|3|paris
josquin-des-prez|若斯坎·德普雷|Josquin des Prez|1450|1521|renaissance-music|composer|5|florence
giovanni-pierluigi-da-palestrina|乔万尼·皮耶路易吉·达·帕莱斯特里纳|Giovanni Pierluigi da Palestrina|1525|1594|renaissance-music|composer|5|rome
orlando-di-lasso|奥兰多·迪·拉索|Orlando di Lasso|1532|1594|renaissance-music|composer|5|rome
thomas-tallis|托马斯·塔利斯|Thomas Tallis|1505|1585|renaissance-music|composer|5|london
william-byrd|威廉·伯德|William Byrd|1540|1623|renaissance-music|composer|5|london
giovanni-gabrieli|乔瓦尼·加布里埃利|Giovanni Gabrieli|1554|1612|renaissance-music|composer|4|venice
claudio-monteverdi|克劳迪奥·蒙特威尔第|Claudio Monteverdi|1567|1643|baroque-music|composer|5|mantua
henry-purcell|亨利·珀塞尔|Henry Purcell|1659|1695|baroque-music|composer|5|london
arcangelo-corelli|阿尔坎杰洛·科雷利|Arcangelo Corelli|1653|1713|baroque-music|composer|4|rome
antonio-vivaldi|安东尼奥·维瓦尔第|Antonio Vivaldi|1678|1741|baroque-music|composer|5|venice
johann-sebastian-bach|约翰·塞巴斯蒂安·巴赫|Johann Sebastian Bach|1685|1750|baroque-music|composer|5|leipzig
george-frideric-handel|乔治·弗里德里希·亨德尔|George Frideric Handel|1685|1759|baroque-music|composer|5|london
georg-philipp-telemann|格奥尔格·菲利普·泰勒曼|Georg Philipp Telemann|1681|1767|baroque-music|composer|4|hamburg
jean-philippe-rameau|让-菲利普·拉莫|Jean-Philippe Rameau|1683|1764|baroque-music|composer|4|paris
christoph-willibald-gluck|克里斯托夫·威利巴尔德·格鲁克|Christoph Willibald Gluck|1714|1787|classical-period|composer|5|vienna
joseph-haydn|约瑟夫·海顿|Joseph Haydn|1732|1809|classical-period|composer|5|vienna
wolfgang-amadeus-mozart|沃尔夫冈·阿马德乌斯·莫扎特|Wolfgang Amadeus Mozart|1756|1791|classical-period|composer|5|salzburg
muzio-clementi|穆齐奥·克莱门蒂|Muzio Clementi|1752|1832|classical-period|composer|4|london
luigi-boccherini|路易吉·博凯里尼|Luigi Boccherini|1743|1805|classical-period|composer|4|madrid
ludwig-van-beethoven|路德维希·范·贝多芬|Ludwig van Beethoven|1770|1827|classical-period|composer|5|vienna
franz-schubert|弗朗茨·舒伯特|Franz Schubert|1797|1828|romantic-period|composer|5|vienna
hector-berlioz|埃克托·柏辽兹|Hector Berlioz|1803|1869|romantic-period|composer|5|paris
frederic-chopin|弗雷德里克·肖邦|Frédéric Chopin|1810|1849|romantic-period|composer|5|paris
robert-schumann|罗伯特·舒曼|Robert Schumann|1810|1856|romantic-period|composer|5|leipzig
franz-liszt|弗朗茨·李斯特|Franz Liszt|1811|1886|romantic-period|composer|5|weimar
richard-wagner|理查德·瓦格纳|Richard Wagner|1813|1883|romantic-period|composer|5|bayreuth
johannes-brahms|约翰内斯·勃拉姆斯|Johannes Brahms|1833|1897|romantic-period|composer|5|vienna
giuseppe-verdi|朱塞佩·威尔第|Giuseppe Verdi|1813|1901|romantic-period|composer|5|milan
pyotr-ilyich-tchaikovsky|彼得·伊里奇·柴可夫斯基|Pyotr Ilyich Tchaikovsky|1840|1893|romantic-period|composer|5|moscow
claude-debussy|克洛德·德彪西|Claude Debussy|1862|1918|modernism-and-war|composer|5|paris
maurice-ravel|莫里斯·拉威尔|Maurice Ravel|1875|1937|modernism-and-war|composer|5|paris
gustav-mahler|古斯塔夫·马勒|Gustav Mahler|1860|1911|modernism-and-war|composer|5|vienna
arnold-schoenberg|阿诺德·勋伯格|Arnold Schoenberg|1874|1951|modernism-and-war|composer|5|vienna
igor-stravinsky|伊戈尔·斯特拉文斯基|Igor Stravinsky|1882|1971|modernism-and-war|composer|5|paris
bela-bartok|贝拉·巴托克|Béla Bartók|1881|1945|modernism-and-war|composer|5|budapest
sergei-prokofiev|谢尔盖·普罗科菲耶夫|Sergei Prokofiev|1891|1953|modernism-and-war|composer|5|moscow
benjamin-britten|本杰明·布里顿|Benjamin Britten|1913|1976|postwar-and-contemporary|composer|5|london
olivier-messiaen|奥利维埃·梅西安|Olivier Messiaen|1908|1992|postwar-and-contemporary|composer|5|paris
pierre-boulez|皮埃尔·布列兹|Pierre Boulez|1925|2016|postwar-and-contemporary|composer|4|paris
gyorgy-ligeti|焦尔焦·利盖蒂|György Ligeti|1923|2006|postwar-and-contemporary|composer|5|budapest
edgard-varese|埃德加·瓦雷兹|Edgard Varèse|1883|1965|postwar-and-contemporary|composer|4|paris
carl-orff|卡尔·奥尔夫|Carl Orff|1895|1982|modernism-and-war|composer|4|munich
`).map(([slug, zh, en, birth, death, chapter, role, importance, city]) => ({
  slug, zh, en, birth: Number(birth), death: Number(death), chapter: chapter as ChapterSlug,
  role, importance: Number(importance), city,
}));

export const COMPOSITIONS: CompositionSeed[] = rows(`
ordo-virtutum|hildegard-of-bingen|《美德剧》|Ordo Virtutum|1151|1151|sacred drama|liturgical drama| |limoges
o-viridissima-virga|hildegard-of-bingen|《啊，最翠绿的枝条》|O viridissima virga|1150|1150|sacred song|sequence| |limoges
viderunt-omnes-leonin|leonin|《众目皆见》|Viderunt omnes|1198|1198|organum|two-part organum| |paris
viderunt-omnes-perotin|perotin|《众目皆见》|Viderunt omnes|1198|1198|organum|four-part organum| |paris
messe-de-nostre-dame|guillaume-de-machaut|《圣母弥撒》|Messe de Nostre Dame|1360|1365|mass|cyclic mass| |reims
douce-dame-jolie|guillaume-de-machaut|《温柔的美人》|Douce dame jolie|1360|1360|secular song|virelai| |reims
cum-statua|philippe-de-vitry|《与雕像同在》|Cum statua|1320|1320|motet|isorhythmic motet| |paris
in-seculum-viellatoris|franco-of-cologne|《在小提琴手的世代》|In seculum viellatoris|1260|1260|motet|mensural motet| |paris
ave-maria-virgo-serena|josquin-des-prez|《圣母颂》|Ave Maria... virgo serena|1485|1485|motet|imitative motet| |florence
missa-pange-lingua|josquin-des-prez|《唱吧，我的舌》弥撒|Missa Pange lingua|1515|1515|mass|paraphrase mass| |florence
missa-papae-marcelli|giovanni-pierluigi-da-palestrina|《教皇马塞尔弥撒》|Missa Papae Marcelli|1562|1562|mass|parody mass| |rome
sicut-cervus|giovanni-pierluigi-da-palestrina|《如鹿渴慕溪水》|Sicut cervus|1581|1581|motet|motet| |rome
matona-mia-cara|orlando-di-lasso|《我的夫人》|Matona mia cara|1581|1581|secular song|madrigal| |rome
spem-in-alium|thomas-tallis|《我从未寄望于任何人》|Spem in alium|1570|1570|motet|forty-part motet| |london
if-ye-love-me|thomas-tallis|《你们若爱我》|If ye love me|1565|1565|anthem|anthem| |london
ave-verum-corpus-byrd|william-byrd|《圣体颂》|Ave verum corpus|1605|1605|motet|motet| |london
in-ecclesiis|giovanni-gabrieli|《在教会中》|In ecclesiis|1615|1615|sacred concerto|polychoral concerto| |venice
lorfeo|claudio-monteverdi|《奥菲欧》|L'Orfeo|1607|1607|opera|early opera| |mantua
vespers-1610|claudio-monteverdi|《1610年晚祷》|Vespers of 1610|1610|1610|sacred music|vespers| |mantua
dido-and-aeneas|henry-purcell|《狄多与埃涅阿斯》|Dido and Aeneas|1689|1689|opera|baroque opera| |london
corelli-concerto-grosso-op6-no8|arcangelo-corelli|《圣诞协奏曲》|Concerto grosso Op. 6 No. 8|1690|1690|concerto|concerto grosso| |rome
four-seasons|antonio-vivaldi|《四季》|The Four Seasons|1725|1725|concerto|solo concerto| |venice
gloria-rv589|antonio-vivaldi|《荣耀颂》|Gloria RV 589|1715|1715|sacred music|mass movement| |venice
brandenburg-concerto-no3|johann-sebastian-bach|《勃兰登堡协奏曲第三号》|Brandenburg Concerto No. 3|1721|1721|concerto|concerto grosso| |leipzig
st-matthew-passion|johann-sebastian-bach|《马太受难曲》|St Matthew Passion|1727|1727|sacred music|passion| |leipzig
messiah|george-frideric-handel|《弥赛亚》|Messiah|1741|1741|oratorio|oratorio| |london
water-music|george-frideric-handel|《水上音乐》|Water Music|1717|1717|orchestral suite|suite| |london
tafelmusik|georg-philipp-telemann|《餐桌音乐》|Tafelmusik|1733|1733|chamber music|collection| |hamburg
hippolyte-et-aricie|jean-philippe-rameau|《希波吕托斯与阿里西娅》|Hippolyte et Aricie|1733|1733|opera|tragédie lyrique| |paris
orfeo-ed-euridice|christoph-willibald-gluck|《奥菲欧与尤丽狄茜》|Orfeo ed Euridice|1762|1762|opera|reform opera| |vienna
symphony-no94-surprise|joseph-haydn|《惊愕交响曲》|Symphony No. 94 “Surprise”|1791|1791|symphony|classical symphony| |vienna
string-quartet-op76-no3|joseph-haydn|《皇帝四重奏》|String Quartet Op. 76 No. 3|1797|1797|chamber music|string quartet| |vienna
symphony-no40|wolfgang-amadeus-mozart|《第四十交响曲》|Symphony No. 40|1788|1788|symphony|classical symphony| |salzburg
don-giovanni|wolfgang-amadeus-mozart|《唐·乔万尼》|Don Giovanni|1787|1787|opera|opera buffa| |vienna
piano-sonata-op2-no1|muzio-clementi|《第一钢琴奏鸣曲》|Piano Sonata Op. 2 No. 1|1779|1779|keyboard music|sonata| |london
cello-quintet-op11-no5|luigi-boccherini|《E大调大提琴五重奏》|Cello Quintet in E major|1771|1771|chamber music|quintet| |madrid
symphony-no5|ludwig-van-beethoven|《第五交响曲》|Symphony No. 5|1808|1808|symphony|symphony| |vienna
eroica|ludwig-van-beethoven|《英雄交响曲》|Symphony No. 3 “Eroica”|1804|1804|symphony|symphony| |vienna
string-quartet-op131|ludwig-van-beethoven|《降C小调弦乐四重奏》|String Quartet Op. 131|1826|1826|chamber music|string quartet| |vienna
erlkonig|franz-schubert|《魔王》|Erlkönig|1815|1815|song|lied| |vienna
symphony-no8-unfinished|franz-schubert|《未完成交响曲》|Symphony No. 8 “Unfinished”|1822|1822|symphony|symphony| |vienna
symphonie-fantastique|hector-berlioz|《幻想交响曲》|Symphonie fantastique|1830|1830|symphony|program symphony| |paris
prelude-op28-no4|frederic-chopin|《前奏曲》作品28第4首|Prelude Op. 28 No. 4|1839|1839|keyboard music|prelude| |paris
ballade-no1|frederic-chopin|《第一叙事曲》|Ballade No. 1|1835|1835|keyboard music|ballade| |paris
carnaval|robert-schumann|《狂欢节》|Carnaval|1835|1835|keyboard music|character pieces| |leipzig
sonata-in-b-minor|franz-liszt|《B小调奏鸣曲》|Piano Sonata in B minor|1853|1853|keyboard music|sonata| |weimar
tristan-und-isolde|richard-wagner|《特里斯坦与伊索尔德》|Tristan und Isolde|1859|1859|opera|music drama| |bayreuth
ride-of-the-valkyries|richard-wagner|《女武神的骑行》|Ride of the Valkyries|1856|1856|opera|music drama| |bayreuth
symphony-no1-brahms|johannes-brahms|《第一交响曲》|Symphony No. 1|1876|1876|symphony|symphony| |vienna
clarinet-quintet-brahms|johannes-brahms|《单簧管五重奏》|Clarinet Quintet|1891|1891|chamber music|quintet| |vienna
la-traviata|giuseppe-verdi|《茶花女》|La traviata|1853|1853|opera|opera| |milan
requiem-verdi|giuseppe-verdi|《安魂曲》|Messa da Requiem|1874|1874|sacred music|requiem| |milan
symphony-no6-pathetique|pyotr-ilyich-tchaikovsky|《悲怆交响曲》|Symphony No. 6 “Pathétique”|1893|1893|symphony|symphony| |moscow
swan-lake|pyotr-ilyich-tchaikovsky|《天鹅湖》|Swan Lake|1876|1876|ballet|ballet| |moscow
prelude-afternoon-faun|claude-debussy|《牧神午后前奏曲》|Prélude à l'après-midi d'un faune|1894|1894|orchestral poem|tone poem| |paris
la-mer|claude-debussy|《大海》|La mer|1905|1905|orchestral music|three symphonic sketches| |paris
bolero|maurice-ravel|《波莱罗》|Boléro|1928|1928|ballet|ballet| |paris
string-quartet-ravel|maurice-ravel|《弦乐四重奏》|String Quartet|1903|1903|chamber music|string quartet| |paris
symphony-no1-mahler|gustav-mahler|《第一交响曲》|Symphony No. 1|1888|1888|symphony|symphony| |vienna
symphony-no5-mahler|gustav-mahler|《第五交响曲》|Symphony No. 5|1902|1902|symphony|symphony| |vienna
verklare-nacht|arnold-schoenberg|《升华之夜》|Verklärte Nacht|1899|1899|chamber music|string sextet| |vienna
rite-of-spring|igor-stravinsky|《春之祭》|The Rite of Spring|1913|1913|ballet|ballet| |paris
pulcinella|igor-stravinsky|《普尔钦奈拉》|Pulcinella|1920|1920|ballet|neoclassical ballet| |paris
music-for-strings-percussion-celesta|bela-bartok|《弦乐、打击乐与钢片琴音乐》|Music for Strings, Percussion and Celesta|1936|1936|orchestral music|four movements| |budapest
concerto-for-orchestra|bela-bartok|《乐队协奏曲》|Concerto for Orchestra|1943|1943|orchestral music|concerto| |budapest
classical-symphony|sergei-prokofiev|《古典交响曲》|Classical Symphony|1917|1917|symphony|neoclassical symphony| |moscow
war-requiem|benjamin-britten|《战争安魂曲》|War Requiem|1962|1962|sacred music|requiem| |london
quartet-for-the-end-of-time|olivier-messiaen|《时间终结四重奏》|Quartet for the End of Time|1941|1941|chamber music|quartet| |paris
le-marteau-sans-maitre|pierre-boulez|《无主之锤》|Le marteau sans maître|1955|1955|vocal chamber music|cycle| |paris
atmospheres|gyorgy-ligeti|《大气层》|Atmosphères|1961|1961|orchestral music|cluster texture| |budapest
ionisation|edgard-varese|《离子化》|Ionisation|1931|1931|percussion music|ensemble| |paris
carmina-burana|carl-orff|《布兰诗歌》|Carmina Burana|1936|1936|scenic cantata|cantata| |munich
`).map(([slug, person, zh, en, start, end, genre, form, key, city]) => ({
  slug, person, zh, en, start: Number(start), end: Number(end), genre, form, key, city,
}));

export const STYLES: StyleSeed[] = rows(`
plainchant|格里高利圣咏|Gregorian chant|historical_style|medieval-music
organum|奥尔加农|Organum|technique|medieval-music
ars-antiqua|古艺术|Ars antiqua|historical_style|medieval-music
ars-nova|新艺术|Ars nova|historical_style|medieval-music
renaissance-polyphony|文艺复兴复调|Renaissance polyphony|historical_style|renaissance-music
venetian-polychoral|威尼斯多重合唱|Venetian polychoral style|school|renaissance-music
seconda-prattica|第二实践|Seconda pratica|technique|baroque-music
basso-continuo|数字低音|Basso continuo|technique|baroque-music
concerto-grosso|大协奏曲|Concerto grosso|genre|baroque-music
baroque-opera|巴洛克歌剧|Baroque opera|genre|baroque-music
galant-style|华丽风格|Galant style|historical_style|classical-period
sonata-form|奏鸣曲式|Sonata form|form|classical-period
classical-symphony|古典交响曲|Classical symphony|genre|classical-period
romanticism|浪漫主义|Romanticism|historical_style|romantic-period
program-music|标题音乐|Program music|technique|romantic-period
nationalism|民族主义|Musical nationalism|national_tradition|romantic-period
impressionism|音乐印象主义|Musical impressionism|historical_style|modernism-and-war
expressionism|表现主义|Expressionism|historical_style|modernism-and-war
neoclassicism|新古典主义|Neoclassicism|historical_style|modernism-and-war
serialism|序列主义|Serialism|technique|postwar-and-contemporary
`).map(([slug, zh, en, kind, chapter]) => ({ slug, zh, en, kind, chapter: chapter as ChapterSlug }));

export const INSTRUMENTS: InstrumentSeed[] = rows(`
voice|人声|Voice|voice| |500|2026
lute|鲁特琴|Lute|plucked_and_early|321.321|500|1800
viol|维奥尔琴|Viol|strings|321.322|1500|1800
violin|小提琴|Violin|strings|321.322-71|1550|2026
viola|中提琴|Viola|strings|321.322-71|1550|2026
cello|大提琴|Cello|strings|321.322-71|1660|2026
double-bass|低音提琴|Double bass|strings|321.322-71|1650|2026
harpsichord|羽管键琴|Harpsichord|keyboards|314.122-4|1500|1800
fortepiano|古钢琴|Fortepiano|keyboards|314.122-4|1700|1850
piano|钢琴|Piano|keyboards|314.122-4|1800|2026
organ|管风琴|Organ|keyboards|421.222|500|2026
recorder|竖笛|Recorder|woodwinds|421.221.12|500|1800
traverso|横笛|Traverso|woodwinds|421.121|1600|1800
oboe|双簧管|Oboe|woodwinds|422.112|1650|2026
clarinet|单簧管|Clarinet|woodwinds|422.211|1700|2026
bassoon|巴松管|Bassoon|woodwinds|422.112-71|1650|2026
natural-horn|自然号|Natural horn|brass|423.121.22|1650|1850
french-horn|圆号|French horn|brass|423.121.22|1815|2026
trumpet|小号|Trumpet|brass|423.121.12|1500|2026
trombone|长号|Trombone|brass|423.22|1500|2026
timpani|定音鼓|Timpani|percussion|211.11|1500|2026
harp|竖琴|Harp|plucked_and_early|322.221|500|2026
percussion|打击乐|Percussion|percussion|2|500|2026
saxophone|萨克斯管|Saxophone|woodwinds|422.212|1840|2026
`).map(([slug, zh, en, family, hs, start, end]) => ({
  slug, zh, en, family, hs, start: Number(start), end: Number(end),
}));

export const INSTITUTIONS: InstitutionSeed[] = rows(`
notre-dame-school|巴黎圣母院音乐学校|Notre-Dame School|church|paris|1150|
university-of-paris|巴黎大学|University of Paris|conservatory|paris|1150|
papal-chapel|罗马教皇礼拜堂|Papal Chapel|church|rome|1471|
st-marks-basilica|圣马可大教堂|St Mark's Basilica|church|venice|1063|
gonzaga-court|贡扎加宫廷|Gonzaga Court|court|mantua|1328|1708
teatro-san-cassiano|圣卡西亚诺剧院|Teatro San Cassiano|opera_house|venice|1637|1807
st-thomas-church-leipzig|莱比锡圣托马斯教堂|St Thomas Church Leipzig|church|leipzig|1212|
royal-academy-of-music|皇家音乐学院|Royal Academy of Music|conservatory|london|1822|
esterhazy-court|埃斯特哈齐宫廷|Esterházy Court|court|vienna|1680|1866
imperial-court-vienna|维也纳宫廷|Imperial Court Vienna|court|vienna|1500|1918
paris-conservatoire|巴黎音乐学院|Paris Conservatoire|conservatory|paris|1795|
bayreuth-festival|拜罗伊特音乐节|Bayreuth Festival|festival|bayreuth|1876|
moscow-conservatory|莫斯科音乐学院|Moscow Conservatory|conservatory|moscow|1866|
budapest-academy|李斯特音乐学院|Liszt Academy|conservatory|budapest|1875|
ircam|法国音乐声学与协调研究所|IRCAM|archive|paris|1970|
bbc-music|BBC 音乐部门|BBC Music|institution|london|1936|
`).map(([slug, zh, en, type, city, founded, closed]) => ({
  slug, zh, en, type, city, founded: Number(founded), closed: closed ? Number(closed) : null,
}));

export const LOCATIONS: LocationSeed[] = rows(`
paris|巴黎|Paris|paris|2.3522|48.8566
limoges|利摩日|Limoges|limoges|1.2611|45.8336
reims|兰斯|Reims|reims|4.0317|49.2583
munich|慕尼黑|Munich|munich|11.5820|48.1351
florence|佛罗伦萨|Florence|florence|11.2558|43.7696
rome|罗马|Rome|rome|12.4964|41.9028
venice|威尼斯|Venice|venice|12.3155|45.4408
mantua|曼图亚|Mantua|mantua|10.7914|45.1564
london|伦敦|London|london|-0.1276|51.5074
leipzig|莱比锡|Leipzig|leipzig|12.3731|51.3397
eisenach|爱森纳赫|Eisenach|eisenach|10.3167|50.9746
weimar|魏玛|Weimar|weimar|11.3290|50.9795
hamburg|汉堡|Hamburg|hamburg|9.9937|53.5511
vienna|维也纳|Vienna|vienna|16.3738|48.2082
salzburg|萨尔茨堡|Salzburg|salzburg|13.0550|47.8095
bonn|波恩|Bonn|bonn|7.0982|50.7374
prague|布拉格|Prague|prague|14.4378|50.0755
madrid|马德里|Madrid|madrid|-3.7038|40.4168
milan|米兰|Milan|milan|9.1900|45.4642
naples|那不勒斯|Naples|naples|14.2681|40.8518
dresden|德累斯顿|Dresden|dresden|13.7373|51.0504
budapest|布达佩斯|Budapest|budapest|19.0402|47.4979
moscow|莫斯科|Moscow|moscow|37.6173|55.7558
bayreuth|拜罗伊特|Bayreuth|bayreuth|11.5783|49.9480
`).map(([slug, zh, en, city, lng, lat]) => ({
  slug, zh, en, city, lng: Number(lng), lat: Number(lat),
}));

export const SCORE_FRAGMENTS: ScoreSeed[] = [
  ["chant-viridissima", "o-viridissima-virga", [1, 4], "chant"],
  ["organum-viderunt-leonin", "viderunt-omnes-leonin", [1, 4], "organum"],
  ["organum-viderunt-perotin", "viderunt-omnes-perotin", [1, 4], "organum"],
  ["machaut-mass", "messe-de-nostre-dame", [1, 4], "polyphony"],
  ["josquin-ave-maria", "ave-maria-virgo-serena", [1, 4], "polyphony"],
  ["palestrina-sicut-cervus", "sicut-cervus", [1, 4], "polyphony"],
  ["tallis-spem", "spem-in-alium", [1, 4], "polyphony"],
  ["byrd-ave-verum", "ave-verum-corpus-byrd", [1, 4], "polyphony"],
  ["monteverdi-lorfeo", "lorfeo", [1, 4], "continuo"],
  ["purcell-dido", "dido-and-aeneas", [1, 4], "dance"],
  ["corelli-christmas", "corelli-concerto-grosso-op6-no8", [1, 4], "dance"],
  ["vivaldi-spring", "four-seasons", [1, 4], "dance"],
  ["bach-brandenburg", "brandenburg-concerto-no3", [1, 4], "continuo"],
  ["handel-water", "water-music", [1, 4], "dance"],
  ["rameau-hippolyte", "hippolyte-et-aricie", [1, 4], "dance"],
  ["haydn-surprise", "symphony-no94-surprise", [1, 4], "classical"],
  ["mozart-g-minor", "symphony-no40", [1, 4], "classical"],
  ["beethoven-fifth", "symphony-no5", [1, 4], "classical"],
  ["schubert-erlkonig", "erlkonig", [1, 4], "romantic"],
  ["berlioz-fantastique", "symphonie-fantastique", [1, 4], "romantic"],
  ["chopin-prelude", "prelude-op28-no4", [1, 4], "romantic"],
  ["wagner-tristan", "tristan-und-isolde", [1, 4], "romantic"],
  ["brahms-clarinet", "clarinet-quintet-brahms", [1, 4], "romantic"],
  ["debussy-faun", "prelude-afternoon-faun", [1, 4], "modern"],
  ["ravel-bolero", "bolero", [1, 4], "modern"],
  ["bartok-celesta", "music-for-strings-percussion-celesta", [1, 4], "modern"],
  ["schoenberg-night", "verklare-nacht", [1, 4], "modern"],
  ["prokofiev-classical", "classical-symphony", [1, 4], "modern"],
].map(([slug, composition, measures, pattern]) => ({ slug, composition, measures: measures as [number, number], pattern: pattern as ScoreSeed["pattern"] }));

export const RELATIONS: RelationSeed[] = rows(`
leonin|perotin|mentorship|source_to_target|5
franco-of-cologne|philippe-de-vitry|influence|source_to_target|4
philippe-de-vitry|guillaume-de-machaut|influence|source_to_target|5
hildegard-of-bingen|guillaume-de-machaut|reception_advocacy|source_to_target|2
josquin-des-prez|giovanni-pierluigi-da-palestrina|influence|source_to_target|5
josquin-des-prez|orlando-di-lasso|influence|source_to_target|4
giovanni-pierluigi-da-palestrina|william-byrd|influence|source_to_target|4
thomas-tallis|william-byrd|mentorship|source_to_target|5
giovanni-gabrieli|claudio-monteverdi|influence|source_to_target|4
claudio-monteverdi|henry-purcell|influence|source_to_target|4
arcangelo-corelli|antonio-vivaldi|influence|source_to_target|4
arcangelo-corelli|johann-sebastian-bach|influence|source_to_target|3
antonio-vivaldi|johann-sebastian-bach|influence|source_to_target|5
johann-sebastian-bach|george-frideric-handel|institutional_peer|bidirectional|3
georg-philipp-telemann|johann-sebastian-bach|institutional_peer|bidirectional|4
jean-philippe-rameau|christoph-willibald-gluck|influence|source_to_target|4
claudio-monteverdi|christoph-willibald-gluck|influence|source_to_target|3
christoph-willibald-gluck|wolfgang-amadeus-mozart|influence|source_to_target|4
joseph-haydn|wolfgang-amadeus-mozart|collaboration|bidirectional|5
joseph-haydn|ludwig-van-beethoven|mentorship|source_to_target|5
wolfgang-amadeus-mozart|ludwig-van-beethoven|influence|source_to_target|5
muzio-clementi|ludwig-van-beethoven|influence|source_to_target|3
luigi-boccherini|joseph-haydn|institutional_peer|bidirectional|3
johann-sebastian-bach|wolfgang-amadeus-mozart|reception_advocacy|source_to_target|5
johann-sebastian-bach|ludwig-van-beethoven|influence|source_to_target|5
ludwig-van-beethoven|franz-schubert|influence|source_to_target|5
ludwig-van-beethoven|hector-berlioz|influence|source_to_target|5
ludwig-van-beethoven|robert-schumann|influence|source_to_target|5
ludwig-van-beethoven|johannes-brahms|influence|source_to_target|5
franz-schubert|robert-schumann|influence|source_to_target|4
franz-schubert|johannes-brahms|influence|source_to_target|4
frederic-chopin|franz-liszt|institutional_peer|bidirectional|4
robert-schumann|johannes-brahms|mentorship|source_to_target|5
robert-schumann|frederic-chopin|reception_advocacy|source_to_target|4
franz-liszt|richard-wagner|collaboration|bidirectional|5
franz-liszt|hector-berlioz|reception_advocacy|bidirectional|4
richard-wagner|gustav-mahler|influence|source_to_target|5
richard-wagner|arnold-schoenberg|influence|source_to_target|5
johannes-brahms|arnold-schoenberg|influence|source_to_target|4
giuseppe-verdi|richard-wagner|aesthetic_opposition|bidirectional|4
pyotr-ilyich-tchaikovsky|igor-stravinsky|influence|source_to_target|4
pyotr-ilyich-tchaikovsky|sergei-prokofiev|influence|source_to_target|4
claude-debussy|maurice-ravel|institutional_peer|bidirectional|5
claude-debussy|igor-stravinsky|influence|source_to_target|4
claude-debussy|olivier-messiaen|influence|source_to_target|5
maurice-ravel|igor-stravinsky|collaboration|bidirectional|4
gustav-mahler|arnold-schoenberg|reception_advocacy|source_to_target|5
gustav-mahler|benjamin-britten|influence|source_to_target|3
arnold-schoenberg|pierre-boulez|influence|source_to_target|5
arnold-schoenberg|gyorgy-ligeti|influence|source_to_target|4
arnold-schoenberg|bela-bartok|institutional_peer|bidirectional|3
igor-stravinsky|sergei-prokofiev|institutional_peer|bidirectional|4
igor-stravinsky|benjamin-britten|influence|source_to_target|4
igor-stravinsky|pierre-boulez|influence|source_to_target|5
bela-bartok|gyorgy-ligeti|influence|source_to_target|5
bela-bartok|benjamin-britten|influence|source_to_target|4
sergei-prokofiev|benjamin-britten|influence|source_to_target|3
olivier-messiaen|pierre-boulez|mentorship|source_to_target|5
olivier-messiaen|gyorgy-ligeti|influence|source_to_target|4
edgard-varese|pierre-boulez|influence|source_to_target|4
edgard-varese|gyorgy-ligeti|influence|source_to_target|4
orlando-di-lasso|giovanni-pierluigi-da-palestrina|institutional_peer|bidirectional|4
thomas-tallis|giovanni-pierluigi-da-palestrina|institutional_peer|bidirectional|3
william-byrd|giovanni-gabrieli|institutional_peer|bidirectional|3
henry-purcell|george-frideric-handel|influence|source_to_target|4
george-frideric-handel|wolfgang-amadeus-mozart|influence|source_to_target|4
georg-philipp-telemann|george-frideric-handel|institutional_peer|bidirectional|3
jean-philippe-rameau|george-frideric-handel|institutional_peer|bidirectional|3
joseph-haydn|luigi-boccherini|influence|source_to_target|3
wolfgang-amadeus-mozart|muzio-clementi|aesthetic_opposition|bidirectional|3
muzio-clementi|ludwig-van-beethoven|reception_advocacy|source_to_target|4
hector-berlioz|franz-liszt|collaboration|bidirectional|4
franz-liszt|richard-wagner|family|bidirectional|4
giuseppe-verdi|hector-berlioz|institutional_peer|bidirectional|3
pyotr-ilyich-tchaikovsky|johannes-brahms|institutional_peer|bidirectional|3
claude-debussy|maurice-ravel|aesthetic_opposition|bidirectional|3
maurice-ravel|bela-bartok|influence|source_to_target|3
pierre-boulez|gustav-mahler|reception_advocacy|source_to_target|4
carl-orff|benjamin-britten|institutional_peer|bidirectional|2
edgard-varese|igor-stravinsky|institutional_peer|bidirectional|3
`).map(([from, to, type, direction, strength]) => ({ from, to, type, direction: direction as RelationSeed["direction"], strength: Number(strength) }));

/** The extra 24 non-composition events are anchored to these people. */
export const KEY_PERSON_EVENT_SLUGS = PEOPLE.slice(0, 24).map((person) => person.slug);

export const SOURCE_CATALOG = [
  ["source-imslp", "国际乐谱库", "International Music Score Library Project", "https://imslp.org/", "reference"],
  ["source-bach-digital", "巴赫数字档案", "Bach Digital", "https://www.bach-digital.de/", "primary_text"],
  ["source-mozarteum", "莫扎特数字档案", "Mozart Digital", "https://dme.mozarteum.at/", "primary_text"],
  ["source-beethoven-haus", "贝多芬故居档案", "Beethoven-Haus Bonn", "https://www.beethoven.de/", "primary_text"],
  ["source-british-library-music", "大英图书馆音乐资料", "British Library Music Collections", "https://www.bl.uk/collection-guides/music", "reference"],
  ["source-library-congress-music", "美国国会图书馆音乐资料", "Library of Congress Music Collections", "https://www.loc.gov/music/", "reference"],
  ["source-europeana-music", "Europeana 音乐专题", "Europeana Music", "https://www.europeana.eu/en/collections/topic/62-music", "reference"],
  ["source-mei", "Music Encoding Initiative", "Music Encoding Initiative", "https://music-encoding.org/guidelines/", "scholarly"],
  ["source-verovio", "Verovio 排版工具", "Verovio Toolkit", "https://www.verovio.org/", "reference"],
  ["source-music-atlas-editorial", "本图集编辑性乐谱研究片段", "Atlas editorial analytical studies", "", "scholarly"],
] as const;

export function assertFoundationCounts(): void {
  const expected: Record<string, number> = { people: 48, compositions: 72, styles: 20, instruments: 24, institutions: 16, locations: 24, relations: 80, scoreFragments: 28, keyPersonEvents: 24 };
  const actual = { people: PEOPLE.length, compositions: COMPOSITIONS.length, styles: STYLES.length, instruments: INSTRUMENTS.length, institutions: INSTITUTIONS.length, locations: LOCATIONS.length, relations: RELATIONS.length, scoreFragments: SCORE_FRAGMENTS.length, keyPersonEvents: KEY_PERSON_EVENT_SLUGS.length };
  for (const [key, value] of Object.entries(expected)) if (actual[key as keyof typeof actual] !== value) throw new Error(`Foundation count mismatch for ${key}: expected ${value}, got ${actual[key as keyof typeof actual]}`);
}

assertFoundationCounts();
