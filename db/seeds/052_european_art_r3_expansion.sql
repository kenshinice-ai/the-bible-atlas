BEGIN;

-- R3 expansion: 32 additional artists, 91 additional artworks and one
-- lifecycle event per artwork. All visible rows have zh-CN/en published translations.

CREATE TEMP TABLE r3_locations (
  location_no integer PRIMARY KEY, slug text UNIQUE NOT NULL, name_zh text NOT NULL,
  name_en text NOT NULL, lng numeric NOT NULL, lat numeric NOT NULL, country_code char(2) NOT NULL,
  summary_zh text NOT NULL, summary_en text NOT NULL
) ON COMMIT DROP;
INSERT INTO r3_locations VALUES
(19,'siena','锡耶纳','Siena',11.3308,43.3188,'IT','锡耶纳画派与中世纪城市艺术的重要中心。','A key centre of the Sienese school and medieval civic art.'),
(20,'bruges','布鲁日','Bruges',3.2247,51.2093,'BE','尼德兰绘画、贸易与工坊网络的城市。','A city of Netherlandish painting, trade and workshops.'),
(21,'ghent','根特','Ghent',3.7174,51.0543,'BE','根特祭坛画所在的佛兰德斯城市。','The Flemish city associated with the Ghent Altarpiece.'),
(22,'munich','慕尼黑','Munich',11.5820,48.1351,'DE','德国艺术学院、收藏与表现主义网络的城市。','A German centre of academies, collections and Expressionist networks.'),
(23,'madrid','马德里','Madrid',-3.7038,40.4168,'ES','西班牙宫廷、博物馆与现代艺术史的重要城市。','A major city of Spanish court art, museums and modern art history.'),
(24,'venice','威尼斯','Venice',12.3155,45.4408,'IT','色彩、贸易与威尼斯画派的城市。','A city of colour, trade and the Venetian school.'),
(25,'antwerp','安特卫普','Antwerp',4.4025,51.2194,'BE','佛兰德斯巴洛克绘画与国际贸易网络的城市。','A city of Flemish Baroque painting and international trade.'),
(26,'berlin','柏林','Berlin',13.4050,52.5200,'DE','德国现代艺术机构与先锋网络的城市。','A German city of modern art institutions and avant-garde networks.'),
(27,'vienna','维也纳','Vienna',16.3738,48.2082,'AT','宫廷收藏、学院与现代主义交汇的城市。','A city where court collections, academies and modernism meet.'),
(28,'milan','米兰','Milan',9.1900,45.4642,'IT','工业化城市与未来主义艺术网络的重要节点。','A key node of industrial modernity and Futurist networks.'),
(29,'dresden','德累斯顿','Dresden',13.7373,51.0504,'DE','德国浪漫主义风景画与收藏文化的城市。','A city of German Romantic landscape and collecting culture.');

INSERT INTO locations(id,work_id,slug,layer,geom,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists)
SELECT ('39000000-0000-4000-8000-'||lpad(location_no::text,12,'0'))::uuid,
       '10000000-0000-4000-8000-000000000009','real-'||slug,'real',
       ST_SetSRID(ST_MakePoint(lng,lat),4326)::geography,location_no,'city','city_centroid',10,
       country_code,false,true
FROM r3_locations
ON CONFLICT DO NOTHING;
UPDATE locations l SET slug=r.slug
FROM r3_locations r
WHERE l.id=('39000000-0000-4000-8000-'||lpad(r.location_no::text,12,'0'))::uuid;
INSERT INTO location_translations(location_id,locale,name,summary,status)
SELECT ('39000000-0000-4000-8000-'||lpad(location_no::text,12,'0'))::uuid,'zh-CN'::locale_code,name_zh,summary_zh,'published'::translation_status FROM r3_locations
UNION ALL
SELECT ('39000000-0000-4000-8000-'||lpad(location_no::text,12,'0'))::uuid,'en'::locale_code,name_en,summary_en,'published'::translation_status FROM r3_locations
ON CONFLICT DO NOTHING;

CREATE TEMP TABLE r3_movements (
  slug text PRIMARY KEY, name_zh text NOT NULL, name_en text NOT NULL,
  chapter_slug text NOT NULL, start_year integer, end_year integer, sort_order integer NOT NULL
) ON COMMIT DROP;
INSERT INTO r3_movements VALUES
('byzantine','拜占庭艺术','Byzantine Art','medieval',-330,1453,6),
('romanism','罗马式艺术','Romanesque Art','medieval',950,1200,7),
('realism','现实主义','Realism','modernism-early',1840,1900,8),
('impressionism','印象派','Impressionism','modernism-early',1860,1890,9),
('post-impressionism','后印象派','Post-Impressionism','modernism-early',1886,1905,10),
('expressionism','表现主义','Expressionism','modernism-and-war',1905,1925,11),
('cubism','立体主义','Cubism','modernism-and-war',1907,1914,12),
('futurism','未来主义','Futurism','modernism-and-war',1909,1916,13),
('surrealism','超现实主义','Surrealism','modernism-and-war',1924,1945,14),
('bauhaus','包豪斯','Bauhaus','modernism-and-war',1919,1933,15),
('romanticism','浪漫主义','Romanticism','neoclassicism-and-romanticism',1790,1850,16),
('neoclassicism','新古典主义','Neoclassicism','neoclassicism-and-romanticism',1750,1830,17);
INSERT INTO movements(id,work_id,slug,chapter_id,start_year,end_year,sort_order)
SELECT ('a9000000-0000-4000-8000-'||lpad(sort_order::text,12,'0'))::uuid,
       '10000000-0000-4000-8000-000000000009',r.slug,ch.id,r.start_year,r.end_year,r.sort_order
FROM r3_movements r JOIN chapters ch ON ch.work_id='10000000-0000-4000-8000-000000000009' AND ch.slug=r.chapter_slug
ON CONFLICT DO NOTHING;
INSERT INTO movement_translations(movement_id,locale,name,summary,status)
SELECT m.id,'zh-CN'::locale_code,r.name_zh,'以时代语境标注的艺术语言、媒介与制度网络。','published'::translation_status
FROM r3_movements r JOIN movements m ON m.work_id='10000000-0000-4000-8000-000000000009' AND m.slug=r.slug
UNION ALL
SELECT m.id,'en'::locale_code,r.name_en,'An era-specific artistic language, medium and institutional network.','published'::translation_status
FROM r3_movements r JOIN movements m ON m.work_id='10000000-0000-4000-8000-000000000009' AND m.slug=r.slug
ON CONFLICT DO NOTHING;

-- Realism begins before the rounded 1850 boundary; keep Courbet's 1849 works
-- inside the early-modern chapter while preserving the 1900/1901 hand-off.
UPDATE chapters SET era_start_year=1840, reference_label='c. 1840–1900'
WHERE work_id='10000000-0000-4000-8000-000000000009' AND slug='modernism-early';

CREATE TEMP TABLE r3_artists (
  ordinal integer PRIMARY KEY, slug text UNIQUE NOT NULL, name_zh text NOT NULL, name_en text NOT NULL,
  birth_year integer NOT NULL, death_year integer NOT NULL, birth_location_slug text NOT NULL,
  death_location_slug text NOT NULL, chapter_slug text NOT NULL, importance integer NOT NULL,
  movement_slugs text[] NOT NULL, modern_zh text NOT NULL, modern_en text NOT NULL,
  period_zh text[] NOT NULL, period_en text[] NOT NULL
) ON COMMIT DROP;
INSERT INTO r3_artists VALUES
(17,'cimabue','契马布埃','Cimabue',1240,1302,'florence','florence','medieval',3,ARRAY['gothic'],'中世纪绘画转型的重要先声','Important precursor to late medieval painting',ARRAY['中世纪画家','意大利绘画先声'],ARRAY['Medieval painter','Italian painting precursor']),
(18,'jan-van-eyck','扬·凡·艾克','Jan van Eyck',1390,1441,'bruges','bruges','renaissance',4,ARRAY['gothic'],'北方文艺复兴核心人物','Central figure of the Northern Renaissance',ARRAY['北方文艺复兴','油画技法'],ARRAY['Northern Renaissance','Oil technique']),
(19,'rogier-van-der-weyden','罗希尔·凡·德·魏登','Rogier van der Weyden',1399,1464,'bruges','bruges','renaissance',3,ARRAY['gothic'],'北方文艺复兴祭坛画大师','Master of Northern Renaissance altarpiece painting',ARRAY['北方文艺复兴','祭坛画'],ARRAY['Northern Renaissance','Altarpiece painting']),
(20,'hieronymus-bosch','希罗尼穆斯·博斯','Hieronymus Bosch',1450,1516,'antwerp','antwerp','renaissance',3,ARRAY['gothic'],'北方文艺复兴寓言画家','Allegorical painter of the Northern Renaissance',ARRAY['北方文艺复兴','寓言画'],ARRAY['Northern Renaissance','Allegory']),
(21,'sandro-botticelli','桑德罗·波提切利','Sandro Botticelli',1445,1510,'florence','florence','renaissance',4,ARRAY['renaissance-humanism'],'佛罗伦萨文艺复兴代表人物','Representative Florentine Renaissance painter',ARRAY['佛罗伦萨画派','神话绘画'],ARRAY['Florentine school','Mythological painting']),
(22,'michelangelo','米开朗基罗','Michelangelo',1475,1564,'florence','rome','renaissance',5,ARRAY['renaissance-humanism'],'文艺复兴巨匠','Renaissance master',ARRAY['文艺复兴','雕塑与壁画'],ARRAY['Renaissance','Sculpture and fresco']),
(23,'raphael','拉斐尔','Raphael',1483,1520,'florence','rome','renaissance',5,ARRAY['renaissance-humanism'],'盛期文艺复兴典范','Model of the High Renaissance',ARRAY['盛期文艺复兴','罗马画派'],ARRAY['High Renaissance','Roman school']),
(24,'albrecht-durer','阿尔布雷希特·丢勒','Albrecht Dürer',1471,1528,'munich','munich','renaissance',4,ARRAY['renaissance-humanism'],'北方文艺复兴版画大师','Master of Northern Renaissance printmaking',ARRAY['北方文艺复兴','版画艺术'],ARRAY['Northern Renaissance','Printmaking']),
(25,'giorgione','乔尔乔内','Giorgione',1477,1510,'venice','venice','renaissance',3,ARRAY['renaissance-humanism'],'威尼斯画派早期核心','Early central figure of the Venetian school',ARRAY['威尼斯画派','诗性绘画'],ARRAY['Venetian school','Poetic painting']),
(26,'tintoretto','丁托列托','Tintoretto',1518,1594,'venice','venice','renaissance',4,ARRAY['renaissance-humanism'],'威尼斯晚期文艺复兴大师','Master of the late Venetian Renaissance',ARRAY['威尼斯画派','晚期文艺复兴'],ARRAY['Venetian school','Late Renaissance']),
(27,'peter-paul-rubens','彼得·保罗·鲁本斯','Peter Paul Rubens',1577,1640,'antwerp','antwerp','baroque',5,ARRAY['baroque'],'巴洛克国际大师','International master of the Baroque',ARRAY['巴洛克','佛兰德斯画派'],ARRAY['Baroque','Flemish school']),
(28,'artemisia-gentileschi','阿尔泰米西娅·真蒂莱斯基','Artemisia Gentileschi',1593,1654,'rome','rome','baroque',4,ARRAY['baroque'],'巴洛克重要女性画家','Important woman painter of the Baroque',ARRAY['巴洛克','历史画'],ARRAY['Baroque','History painting']),
(29,'johannes-vermeer','约翰内斯·维米尔','Johannes Vermeer',1632,1675,'amsterdam','amsterdam','baroque',4,ARRAY['baroque'],'荷兰黄金时代代表人物','Representative of the Dutch Golden Age',ARRAY['荷兰黄金时代','室内画'],ARRAY['Dutch Golden Age','Interior painting']),
(30,'nicolas-poussin','尼古拉·普桑','Nicolas Poussin',1594,1665,'paris','rome','baroque',3,ARRAY['baroque'],'法国古典主义核心画家','Central French classical painter',ARRAY['巴洛克古典主义','历史画'],ARRAY['Baroque classicism','History painting']),
(31,'francisco-goya','弗朗西斯科·戈雅','Francisco Goya',1746,1828,'madrid','madrid','neoclassicism-and-romanticism',5,ARRAY['neoclassicism','romanticism'],'现代艺术的重要先声','Important precursor to modern art',ARRAY['浪漫主义','社会批判绘画'],ARRAY['Romanticism','Social critique']),
(32,'antonio-canova','安东尼奥·卡诺瓦','Antonio Canova',1757,1822,'rome','rome','neoclassicism-and-romanticism',3,ARRAY['neoclassicism'],'新古典主义雕塑代表','Representative Neoclassical sculptor',ARRAY['新古典主义','大理石雕塑'],ARRAY['Neoclassicism','Marble sculpture']),
(33,'caspar-david-friedrich','卡斯帕·大卫·弗里德里希','Caspar David Friedrich',1774,1840,'dresden','dresden','neoclassicism-and-romanticism',4,ARRAY['romanticism'],'德国浪漫主义风景画核心','Central German Romantic landscape painter',ARRAY['浪漫主义','崇高风景'],ARRAY['Romanticism','Sublime landscape']),
(34,'eugene-delacroix','欧仁·德拉克罗瓦','Eugène Delacroix',1798,1863,'paris','paris','neoclassicism-and-romanticism',4,ARRAY['romanticism'],'法国浪漫主义旗帜','Flagship French Romantic painter',ARRAY['浪漫主义','历史画'],ARRAY['Romanticism','History painting']),
(35,'gustave-courbet','古斯塔夫·库尔贝','Gustave Courbet',1819,1877,'paris','paris','modernism-early',4,ARRAY['realism'],'现实主义奠基者','Founder of Realism',ARRAY['现实主义','社会题材'],ARRAY['Realism','Social subject']),
(36,'edouard-manet','爱德华·马奈','Édouard Manet',1832,1883,'paris','paris','modernism-early',5,ARRAY['realism','impressionism'],'现代绘画转折人物','Turning point in modern painting',ARRAY['现实主义','印象派先声'],ARRAY['Realism','Impressionist precursor']),
(37,'pierre-auguste-renoir','皮埃尔-奥古斯特·雷诺阿','Pierre-Auguste Renoir',1841,1919,'paris','paris','modernism-early',4,ARRAY['impressionism'],'印象派代表画家','Representative Impressionist painter',ARRAY['印象派','人物画'],ARRAY['Impressionism','Figure painting']),
(38,'edgar-degas','埃德加·德加','Edgar Degas',1834,1917,'paris','paris','modernism-early',4,ARRAY['impressionism'],'印象派现代生活观察者','Impressionist observer of modern life',ARRAY['印象派','舞者题材'],ARRAY['Impressionism','Dancer subjects']),
(39,'paul-cezanne','保罗·塞尚','Paul Cézanne',1839,1906,'paris','paris','modernism-early',5,ARRAY['post-impressionism'],'现代主义关键先驱','Key precursor of modernism',ARRAY['后印象派','结构化绘画'],ARRAY['Post-Impressionism','Structured painting']),
(40,'georges-seurat','乔治·修拉','Georges Seurat',1859,1891,'paris','paris','modernism-early',3,ARRAY['post-impressionism'],'新印象主义创始者','Founder of Neo-Impressionism',ARRAY['新印象主义','点彩法'],ARRAY['Neo-Impressionism','Pointillism']),
(41,'paul-gauguin','保罗·高更','Paul Gauguin',1848,1903,'paris','paris','modernism-early',4,ARRAY['post-impressionism'],'后印象派代表人物','Representative Post-Impressionist',ARRAY['后印象派','象征性绘画'],ARRAY['Post-Impressionism','Symbolic painting']),
(42,'henri-de-toulouse-lautrec','亨利·德·图卢兹-洛特列克','Henri de Toulouse-Lautrec',1864,1901,'paris','paris','modernism-early',3,ARRAY['post-impressionism'],'现代海报艺术先驱','Precursor of modern poster art',ARRAY['后印象派','海报艺术'],ARRAY['Post-Impressionism','Poster art']),
(43,'henri-matisse','亨利·马蒂斯','Henri Matisse',1869,1954,'paris','paris','modernism-and-war',5,ARRAY['expressionism'],'野兽派核心人物','Central figure of Fauvism',ARRAY['野兽派','现代主义'],ARRAY['Fauvism','Modernism']),
(44,'georges-braque','乔治·布拉克','Georges Braque',1882,1963,'paris','paris','modernism-and-war',4,ARRAY['cubism'],'立体主义共同奠基者','Co-founder of Cubism',ARRAY['立体主义','拼贴'],ARRAY['Cubism','Collage']),
(45,'umberto-boccioni','翁贝托·博乔尼','Umberto Boccioni',1882,1916,'milan','milan','modernism-and-war',4,ARRAY['futurism'],'未来主义核心艺术家','Central Futurist artist',ARRAY['未来主义','雕塑与绘画'],ARRAY['Futurism','Sculpture and painting']),
(46,'paul-klee','保罗·克利','Paul Klee',1879,1940,'munich','munich','modernism-and-war',4,ARRAY['bauhaus','expressionism'],'包豪斯重要教师','Important Bauhaus teacher',ARRAY['包豪斯','抽象艺术'],ARRAY['Bauhaus','Abstraction']),
(47,'franz-marc','弗朗茨·马尔克','Franz Marc',1880,1916,'munich','munich','modernism-and-war',3,ARRAY['expressionism'],'蓝骑士成员','Member of Der Blaue Reiter',ARRAY['表现主义','蓝骑士'],ARRAY['Expressionism','Der Blaue Reiter']),
(48,'piet-mondrian','皮特·蒙德里安','Piet Mondrian',1872,1944,'amsterdam','new-york','modernism-and-war',5,ARRAY['cubism','bauhaus'],'风格派抽象艺术代表','Representative of De Stijl abstraction',ARRAY['风格派','几何抽象'],ARRAY['De Stijl','Geometric abstraction']);

INSERT INTO artists(id,work_id,slug,artist_kind,birth_year,death_year,birth_location_id,death_location_id,chapter_id,importance,sort_order)
SELECT ('49000000-0000-4000-8000-'||lpad(a.ordinal::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000009',
       a.slug,'person',a.birth_year,a.death_year,bl.id,dl.id,ch.id,a.importance,a.ordinal
FROM r3_artists a JOIN locations bl ON bl.work_id='10000000-0000-4000-8000-000000000009' AND bl.slug=a.birth_location_slug
JOIN locations dl ON dl.work_id='10000000-0000-4000-8000-000000000009' AND dl.slug=a.death_location_slug
JOIN chapters ch ON ch.work_id='10000000-0000-4000-8000-000000000009' AND ch.slug=a.chapter_slug
ON CONFLICT DO NOTHING;
INSERT INTO artist_translations(artist_id,locale,name,summary,modern_status,period_titles,status)
SELECT a.id,'zh-CN'::locale_code,r.name_zh,r.name_zh||'的创作实践在欧洲艺术史中形成可追踪的作品与事件网络。',r.modern_zh,r.period_zh,'published'::translation_status
FROM r3_artists r JOIN artists a ON a.work_id='10000000-0000-4000-8000-000000000009' AND a.slug=r.slug
UNION ALL
SELECT a.id,'en'::locale_code,r.name_en,r.name_en||' forms a traceable network of works and events in European art history.',r.modern_en,r.period_en,'published'::translation_status
FROM r3_artists r JOIN artists a ON a.work_id='10000000-0000-4000-8000-000000000009' AND a.slug=r.slug
ON CONFLICT DO NOTHING;
INSERT INTO artist_movements(artist_id,movement_id)
SELECT a.id,m.id FROM r3_artists r JOIN artists a ON a.slug=r.slug AND a.work_id='10000000-0000-4000-8000-000000000009'
CROSS JOIN LATERAL unnest(r.movement_slugs) ms
JOIN movements m ON m.work_id='10000000-0000-4000-8000-000000000009' AND m.slug=ms
ON CONFLICT DO NOTHING;
INSERT INTO artist_locations(artist_id,location_id,role)
SELECT a.id,l.id,'birth' FROM r3_artists r JOIN artists a ON a.slug=r.slug AND a.work_id='10000000-0000-4000-8000-000000000009'
JOIN locations l ON l.work_id=a.work_id AND l.slug=r.birth_location_slug
UNION ALL
SELECT a.id,l.id,'death' FROM r3_artists r JOIN artists a ON a.slug=r.slug AND a.work_id='10000000-0000-4000-8000-000000000009'
JOIN locations l ON l.work_id=a.work_id AND l.slug=r.death_location_slug
ON CONFLICT DO NOTHING;

CREATE TEMP TABLE r3_works (
  ordinal integer PRIMARY KEY, artist_slug text NOT NULL, slug text UNIQUE NOT NULL,
  name_zh text NOT NULL, name_en text NOT NULL, start_year integer NOT NULL, end_year integer NOT NULL,
  medium text NOT NULL, location_slug text NOT NULL, artwork_status artwork_status NOT NULL
) ON COMMIT DROP;
INSERT INTO r3_works VALUES
(6,'cimabue','santa-trinita-madonna','圣三一圣母','Santa Trinita Madonna',1280,1290,'tempera on panel','florence','confirmed'),
(7,'cimabue','cimabue-crucifix-arezzo','阿雷佐十字架','Crucifix of Arezzo',1267,1271,'tempera on panel','florence','attributed'),
(8,'jan-van-eyck','ghent-altarpiece','根特祭坛画','Ghent Altarpiece',1432,1432,'oil on panel','ghent','confirmed'),
(9,'jan-van-eyck','arnolfini-portrait','阿尔诺芬尼夫妇像','Arnolfini Portrait',1434,1434,'oil on panel','bruges','confirmed'),
(10,'jan-van-eyck','man-in-red-turban','红帽男子肖像','Man in a Red Turban',1433,1433,'oil on panel','bruges','confirmed'),
(11,'rogier-van-der-weyden','descent-from-cross','下十字架','Descent from the Cross',1435,1435,'oil on panel','bruges','confirmed'),
(12,'rogier-van-der-weyden','miraflores-altarpiece','米拉弗洛雷斯祭坛画','Miraflores Altarpiece',1445,1450,'tempera on panel','bruges','attributed'),
(13,'hieronymus-bosch','garden-of-earthly-delights','人间乐园','The Garden of Earthly Delights',1490,1510,'oil on panel','antwerp','confirmed'),
(14,'hieronymus-bosch','haywain-triptych','干草车','The Haywain Triptych',1510,1516,'oil on panel','antwerp','confirmed'),
(15,'sandro-botticelli','birth-of-venus','维纳斯的诞生','The Birth of Venus',1484,1486,'tempera on canvas','florence','confirmed'),
(16,'sandro-botticelli','primavera','春','Primavera',1477,1482,'tempera on panel','florence','confirmed'),
(17,'sandro-botticelli','adoration-of-magi-botticelli','博士来拜','Adoration of the Magi',1475,1475,'tempera on panel','florence','confirmed'),
(18,'michelangelo','pieta','圣母怜子','Pietà',1498,1499,'marble sculpture','rome','confirmed'),
(19,'michelangelo','david-michelangelo','大卫','David',1501,1504,'marble sculpture','florence','confirmed'),
(20,'michelangelo','sistine-ceiling','西斯廷礼拜堂天顶画','Sistine Chapel ceiling',1508,1512,'fresco','rome','confirmed'),
(21,'michelangelo','last-judgment-michelangelo','最后的审判','The Last Judgment',1536,1541,'fresco','rome','confirmed'),
(22,'raphael','school-of-athens','雅典学院','The School of Athens',1509,1511,'fresco','rome','confirmed'),
(23,'raphael','sistine-madonna','西斯廷圣母','Sistine Madonna',1512,1513,'oil on canvas','rome','confirmed'),
(24,'raphael','portrait-castiglione','巴尔达萨雷·卡斯蒂廖内肖像','Portrait of Baldassare Castiglione',1514,1515,'oil on canvas','rome','confirmed'),
(25,'albrecht-durer','self-portrait-1500','1500年自画像','Self-Portrait at 28',1500,1500,'oil on panel','munich','confirmed'),
(26,'albrecht-durer','melencolia-i','忧郁 I','Melencolia I',1514,1514,'engraving','munich','confirmed'),
(27,'albrecht-durer','four-horsemen','四骑士','The Four Horsemen of the Apocalypse',1497,1498,'woodcut','munich','confirmed'),
(28,'giorgione','the-tempest','暴风雨','The Tempest',1506,1508,'oil on canvas','venice','attributed'),
(29,'giorgione','sleeping-venus','沉睡的维纳斯','Sleeping Venus',1508,1510,'oil on canvas','venice','attributed'),
(30,'tintoretto','miracle-of-slave','圣马可拯救奴隶的奇迹','The Miracle of the Slave',1548,1549,'oil on canvas','venice','confirmed'),
(31,'tintoretto','last-supper-tintoretto','最后的晚餐','The Last Supper',1592,1594,'oil on canvas','venice','confirmed'),
(32,'peter-paul-rubens','raising-of-the-cross','竖起十字架','The Raising of the Cross',1610,1611,'oil on panel','antwerp','confirmed'),
(33,'peter-paul-rubens','medici-cycle','玛丽·德·美第奇生平组画','Marie de Medici Cycle',1622,1625,'oil on canvas','antwerp','confirmed'),
(34,'peter-paul-rubens','three-graces-rubens','三美神','The Three Graces',1635,1639,'oil on canvas','antwerp','confirmed'),
(35,'artemisia-gentileschi','judith-slaying-holofernes-artemisia','朱迪思斩杀赫罗弗涅斯','Judith Slaying Holofernes',1612,1613,'oil on canvas','rome','confirmed'),
(36,'artemisia-gentileschi','judith-and-maidservant-artemisia','朱迪思与侍女','Judith and Her Maidservant',1613,1614,'oil on canvas','rome','confirmed'),
(37,'johannes-vermeer','girl-with-pearl-earring','戴珍珠耳环的少女','Girl with a Pearl Earring',1665,1667,'oil on canvas','amsterdam','confirmed'),
(38,'johannes-vermeer','milkmaid-vermeer','倒牛奶的女仆','The Milkmaid',1658,1660,'oil on canvas','amsterdam','confirmed'),
(39,'johannes-vermeer','art-of-painting','绘画艺术','The Art of Painting',1666,1668,'oil on canvas','amsterdam','confirmed'),
(40,'nicolas-poussin','et-in-arcadia-ego','阿卡迪亚的牧人','Et in Arcadia Ego',1637,1638,'oil on canvas','rome','confirmed'),
(41,'nicolas-poussin','rape-of-sabine-women-poussin','萨宾妇女被劫','The Rape of the Sabine Women',1637,1638,'oil on canvas','rome','confirmed'),
(42,'francisco-goya','third-of-may','五月三日','The Third of May 1808',1814,1814,'oil on canvas','madrid','confirmed'),
(43,'francisco-goya','saturn-devouring-son','农神吞噬其子','Saturn Devouring His Son',1819,1823,'oil transferred to canvas','madrid','confirmed'),
(44,'francisco-goya','family-of-charles-iv','查理四世一家','The Family of Charles IV',1800,1801,'oil on canvas','madrid','confirmed'),
(45,'antonio-canova','psyche-revived','普赛克复苏','Psyche Revived by Cupid''s Kiss',1787,1793,'marble sculpture','rome','confirmed'),
(46,'antonio-canova','three-graces-canova','三美神','The Three Graces',1814,1817,'marble sculpture','rome','confirmed'),
(47,'caspar-david-friedrich','wanderer-above-sea-fog','雾海上的漫步者','Wanderer above the Sea of Fog',1818,1818,'oil on canvas','dresden','confirmed'),
(48,'caspar-david-friedrich','monk-by-the-sea','海边的修士','Monk by the Sea',1808,1810,'oil on canvas','dresden','confirmed'),
(49,'eugene-delacroix','liberty-leading-people','自由引导人民','Liberty Leading the People',1830,1830,'oil on canvas','paris','confirmed'),
(50,'eugene-delacroix','death-of-sardanapalus','萨达纳帕卢斯之死','The Death of Sardanapalus',1827,1827,'oil on canvas','paris','confirmed'),
(51,'eugene-delacroix','women-of-algiers','阿尔及尔的女人','Women of Algiers in Their Apartment',1834,1834,'oil on canvas','paris','confirmed'),
(52,'gustave-courbet','burial-at-ornans','奥尔南的葬礼','A Burial at Ornans',1849,1850,'oil on canvas','paris','confirmed'),
(53,'gustave-courbet','stone-breakers','碎石工','The Stone Breakers',1849,1850,'oil on canvas','paris','destroyed'),
(54,'gustave-courbet','origin-of-the-world','世界的起源','The Origin of the World',1866,1866,'oil on canvas','paris','confirmed'),
(55,'edouard-manet','olympia','奥林匹亚','Olympia',1863,1863,'oil on canvas','paris','confirmed'),
(56,'edouard-manet','luncheon-on-grass','草地上的午餐','Le Déjeuner sur l''herbe',1863,1863,'oil on canvas','paris','confirmed'),
(57,'edouard-manet','bar-at-folies-bergere','弗里斯-贝尔热酒吧','A Bar at the Folies-Bergère',1881,1882,'oil on canvas','paris','confirmed'),
(58,'edouard-manet','masked-ball-at-opera','歌剧院假面舞会','Masked Ball at the Opera',1873,1874,'oil on canvas','paris','confirmed'),
(59,'pierre-auguste-renoir','moulin-de-la-galette','煎饼磨坊的舞会','Bal du moulin de la Galette',1876,1876,'oil on canvas','paris','confirmed'),
(60,'pierre-auguste-renoir','luncheon-boating-party','船上的午餐','Luncheon of the Boating Party',1880,1881,'oil on canvas','paris','confirmed'),
(61,'pierre-auguste-renoir','large-bathers-renoir','大浴女','The Large Bathers',1884,1887,'oil on canvas','paris','confirmed'),
(62,'edgar-degas','ballet-class','芭蕾课','The Ballet Class',1871,1874,'oil on canvas','paris','confirmed'),
(63,'edgar-degas','little-dancer','十四岁的小舞者','Little Dancer Aged Fourteen',1880,1881,'wax and textile sculpture','paris','confirmed'),
(64,'edgar-degas','absinthe-degas','苦艾酒','L''Absinthe',1875,1876,'oil on canvas','paris','confirmed'),
(65,'paul-cezanne','mont-sainte-victoire','圣维克多山','Mont Sainte-Victoire',1885,1887,'oil on canvas','paris','confirmed'),
(66,'paul-cezanne','card-players-cezanne','玩纸牌者','The Card Players',1890,1895,'oil on canvas','paris','confirmed'),
(67,'paul-cezanne','basket-of-apples','苹果篮子','The Basket of Apples',1893,1894,'oil on canvas','paris','confirmed'),
(68,'paul-cezanne','large-bathers-cezanne','大浴女','The Large Bathers',1898,1905,'oil on canvas','paris','confirmed'),
(69,'georges-seurat','sunday-afternoon','大碗岛的星期日下午','A Sunday Afternoon on the Island of La Grande Jatte',1884,1886,'oil on canvas','paris','confirmed'),
(70,'georges-seurat','circus-seurat','马戏团','The Circus',1890,1891,'oil on canvas','paris','confirmed'),
(71,'georges-seurat','models-seurat','模特们','The Models',1886,1888,'oil on canvas','paris','confirmed'),
(72,'paul-gauguin','where-do-we-come-from','我们从哪里来','Where Do We Come From? What Are We? Where Are We Going?',1897,1898,'oil on canvas','paris','confirmed'),
(73,'paul-gauguin','vision-after-sermon','布道后的幻觉','Vision After the Sermon',1888,1888,'oil on canvas','paris','confirmed'),
(74,'paul-gauguin','spirit-of-dead-watching','死者的灵魂注视','Spirit of the Dead Watching',1892,1892,'oil on canvas','paris','confirmed'),
(75,'paul-gauguin','tahitian-women','大溪地妇女','Tahitian Women',1891,1891,'oil on canvas','paris','confirmed'),
(76,'henri-de-toulouse-lautrec','moulin-rouge-la-goulue','红磨坊：拉·古吕','Moulin Rouge: La Goulue',1891,1891,'lithograph','paris','confirmed'),
(77,'henri-de-toulouse-lautrec','at-moulin-rouge','在红磨坊','At the Moulin Rouge',1892,1895,'oil on canvas','paris','confirmed'),
(78,'henri-de-toulouse-lautrec','jane-avril-poster','珍妮·阿芙丽尔海报','Jane Avril',1893,1893,'lithograph','paris','confirmed'),
(79,'henri-matisse','woman-with-hat','戴帽子的女人','Woman with a Hat',1905,1905,'oil on canvas','paris','confirmed'),
(80,'henri-matisse','dance-matisse','舞蹈','Dance',1909,1910,'oil on canvas','paris','confirmed'),
(81,'henri-matisse','red-studio','红色画室','The Red Studio',1911,1911,'oil on canvas','paris','confirmed'),
(82,'georges-braque','violin-and-candlestick','小提琴与烛台','Violin and Candlestick',1910,1910,'oil on canvas','paris','confirmed'),
(83,'georges-braque','portuguese-braque','葡萄牙人','The Portuguese',1911,1911,'oil on canvas','paris','confirmed'),
(84,'georges-braque','houses-at-lestaque','埃斯塔克的房屋','Houses at L''Estaque',1908,1908,'oil on canvas','paris','confirmed'),
(85,'umberto-boccioni','unique-forms-of-continuity','空间中连续性的独特形式','Unique Forms of Continuity in Space',1913,1913,'bronze sculpture','milan','confirmed'),
(86,'umberto-boccioni','elasticity-boccioni','弹性','Elasticity',1912,1912,'oil on canvas','milan','confirmed'),
(87,'umberto-boccioni','states-of-mind','心灵状态','States of Mind',1911,1911,'oil on canvas','milan','confirmed'),
(88,'paul-klee','twittering-machine','鸣鸟机器','Twittering Machine',1922,1922,'watercolour and ink','munich','confirmed'),
(89,'paul-klee','senecio','塞内西奥','Senecio',1922,1922,'oil on gauze','munich','confirmed'),
(90,'paul-klee','ad-parnassum','帕纳塞斯山','Ad Parnassum',1932,1932,'oil and tempera on gauze','munich','confirmed'),
(91,'franz-marc','blue-horse-i','蓝马 I','Blue Horse I',1911,1911,'oil on canvas','munich','confirmed'),
(92,'franz-marc','fate-of-animals','动物的命运','The Fate of the Animals',1913,1913,'oil on canvas','munich','confirmed'),
(93,'franz-marc','foxes-marc','狐狸','Foxes',1913,1913,'oil on canvas','munich','confirmed'),
(94,'piet-mondrian','broadway-boogie-woogie','百老汇爵士乐','Broadway Boogie Woogie',1942,1943,'oil on canvas','new-york','confirmed'),
(95,'piet-mondrian','composition-ii-red-blue-yellow','红蓝黄构图 II','Composition II in Red, Blue, and Yellow',1930,1930,'oil on canvas','amsterdam','confirmed'),
(96,'piet-mondrian','gray-tree','灰树','The Gray Tree',1911,1912,'oil on canvas','amsterdam','confirmed');

INSERT INTO artworks(id,work_id,slug,primary_artist_id,chapter_id,creation_start_year,creation_end_year,creation_time_type,medium,status,attribution_confidence,copyright_status,creation_location_id,current_location_id,sort_order)
SELECT ('a8000000-0000-4000-8000-'||lpad(w.ordinal::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000009',
       w.slug,a.id,ch.id,w.start_year,w.end_year,CASE WHEN w.start_year=w.end_year THEN 'exact'::event_time_type ELSE 'range'::event_time_type END,
       w.medium,w.artwork_status,CASE WHEN w.artwork_status='confirmed' THEN 'high' WHEN w.artwork_status='destroyed' THEN 'low' ELSE 'medium' END,
       'metadata_only',l.id,l.id,w.ordinal
FROM r3_works w JOIN artists a ON a.work_id='10000000-0000-4000-8000-000000000009' AND a.slug=w.artist_slug
JOIN chapters ch ON ch.work_id=a.work_id AND ch.id=CASE WHEN w.start_year<1900 AND w.end_year>1900 THEN (SELECT id FROM chapters WHERE work_id=a.work_id AND slug='modernism') WHEN w.end_year>1900 THEN (SELECT id FROM chapters WHERE work_id=a.work_id AND slug='modernism-and-war') ELSE a.chapter_id END
JOIN locations l ON l.work_id=a.work_id AND l.slug=w.location_slug
ON CONFLICT DO NOTHING;
INSERT INTO artwork_translations(artwork_id,locale,title,summary,status)
SELECT aw.id,'zh-CN'::locale_code,w.name_zh,a.name||'的代表性作品，按创作年代、媒介、地点与来源状态记录。','published'::translation_status
FROM r3_works w JOIN artworks aw ON aw.work_id='10000000-0000-4000-8000-000000000009' AND aw.slug=w.slug
JOIN artist_translations a ON a.artist_id=aw.primary_artist_id AND a.locale='zh-CN'
UNION ALL
SELECT aw.id,'en'::locale_code,w.name_en,a.name||' forms a representative work record with period, medium, place and source metadata.','published'::translation_status
FROM r3_works w JOIN artworks aw ON aw.work_id='10000000-0000-4000-8000-000000000009' AND aw.slug=w.slug
JOIN artist_translations a ON a.artist_id=aw.primary_artist_id AND a.locale='en'
ON CONFLICT DO NOTHING;
INSERT INTO artist_artworks(artist_id,artwork_id,role)
SELECT a.id,aw.id,'creator' FROM r3_works w JOIN artists a ON a.work_id='10000000-0000-4000-8000-000000000009' AND a.slug=w.artist_slug
JOIN artworks aw ON aw.work_id=a.work_id AND aw.slug=w.slug
ON CONFLICT DO NOTHING;
INSERT INTO artwork_movements(artwork_id,movement_id)
SELECT aw.id,m.id FROM r3_works w JOIN artworks aw ON aw.work_id='10000000-0000-4000-8000-000000000009' AND aw.slug=w.slug
JOIN r3_artists ra ON ra.slug=w.artist_slug CROSS JOIN LATERAL unnest(ra.movement_slugs) ms
JOIN movements m ON m.work_id=aw.work_id AND m.slug=ms
ON CONFLICT DO NOTHING;

INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type) VALUES
('59000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000009','British Museum collection','https://www.britishmuseum.org/collection','欧洲艺术史的机构藏品与对象记录。','primary','reference'),
('59000000-0000-4000-8000-000000000014','10000000-0000-4000-8000-000000000009','Uffizi Galleries collection','https://www.uffizi.it/en/artworks','佛罗伦萨与文艺复兴作品的机构目录页面。','primary','reference'),
('59000000-0000-4000-8000-000000000015','10000000-0000-4000-8000-000000000009','Vatican Museums collections','https://www.museivaticani.va/content/museivaticani/en/collezioni/musei.html','罗马文艺复兴作品的机构目录页面。','primary','reference'),
('59000000-0000-4000-8000-000000000016','10000000-0000-4000-8000-000000000009','Rijksmuseum collection','https://www.rijksmuseum.nl/en/collection','荷兰黄金时代作品的机构目录页面。','primary','reference'),
('59000000-0000-4000-8000-000000000017','10000000-0000-4000-8000-000000000009','Museo del Prado collection','https://www.museodelprado.es/en/the-collection','西班牙与欧洲绘画的机构目录页面。','primary','reference'),
('59000000-0000-4000-8000-000000000018','10000000-0000-4000-8000-000000000009','National Gallery London collection','https://www.nationalgallery.org.uk/paintings','欧洲绘画的机构目录页面。','primary','reference'),
('59000000-0000-4000-8000-000000000019','10000000-0000-4000-8000-000000000009','Tate art collection','https://www.tate.org.uk/art','英国与现代艺术的机构目录页面。','primary','reference'),
('59000000-0000-4000-8000-000000000020','10000000-0000-4000-8000-000000000009','The Met collection','https://www.metmuseum.org/art/collection','欧洲艺术与雕塑的机构目录页面。','primary','reference')
ON CONFLICT DO NOTHING;
INSERT INTO source_translations(source_id,locale,title,citation,status)
SELECT id,'zh-CN'::locale_code,title,citation,'published'::translation_status FROM sources WHERE work_id='10000000-0000-4000-8000-000000000009' AND id BETWEEN '59000000-0000-4000-8000-000000000013'::uuid AND '59000000-0000-4000-8000-000000000020'::uuid
UNION ALL
SELECT id,'en'::locale_code,title,citation,'published'::translation_status FROM sources WHERE work_id='10000000-0000-4000-8000-000000000009' AND id BETWEEN '59000000-0000-4000-8000-000000000013'::uuid AND '59000000-0000-4000-8000-000000000020'::uuid
ON CONFLICT DO NOTHING;
INSERT INTO artist_sources(artist_id,source_id)
SELECT a.id,'59000000-0000-4000-8000-000000000009' FROM artists a
WHERE a.work_id='10000000-0000-4000-8000-000000000009' AND a.slug IN (SELECT slug FROM r3_artists)
ON CONFLICT DO NOTHING;
INSERT INTO artwork_sources(artwork_id,source_id)
SELECT aw.id,'59000000-0000-4000-8000-000000000009' FROM artworks aw
WHERE aw.work_id='10000000-0000-4000-8000-000000000009' AND aw.slug IN (SELECT slug FROM r3_works)
ON CONFLICT DO NOTHING;
INSERT INTO movement_sources(movement_id,source_id)
SELECT m.id,'59000000-0000-4000-8000-000000000009' FROM movements m
WHERE m.work_id='10000000-0000-4000-8000-000000000009' AND m.slug IN (SELECT slug FROM r3_movements)
ON CONFLICT DO NOTHING;

INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('69000000-0000-4000-8000-'||lpad(w.ordinal::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000009',
       'artwork-'||w.slug,w.ordinal,'verified_historical','other',
       CASE WHEN w.start_year=w.end_year THEN 'exact'::event_time_type ELSE 'range'::event_time_type END,
       'gregorian',w.start_year,w.end_year,(CASE WHEN w.artwork_status='confirmed' THEN 'high' WHEN w.artwork_status='destroyed' THEN 'low' ELSE 'medium' END)::confidence_level,
       ch.id
FROM r3_works w JOIN artists a ON a.work_id='10000000-0000-4000-8000-000000000009' AND a.slug=w.artist_slug
JOIN chapters ch ON ch.id=CASE WHEN w.start_year<1900 AND w.end_year>1900 THEN (SELECT id FROM chapters WHERE work_id=a.work_id AND slug='modernism') WHEN w.end_year>1900 THEN (SELECT id FROM chapters WHERE work_id=a.work_id AND slug='modernism-and-war') ELSE a.chapter_id END
ON CONFLICT DO NOTHING;
INSERT INTO event_translations(event_id,locale,title,summary,status,time_label)
SELECT e.id,'zh-CN'::locale_code,'《'||w.name_zh||'》创作节点',at2.name||'在'||lt.name||'完成或推进《'||w.name_zh||'》；时间采用艺术史目录中的范围或单年。','published'::translation_status,
       CASE WHEN w.start_year=w.end_year THEN w.start_year::text||' 年' ELSE w.start_year::text||'–'||w.end_year::text||' 年' END
FROM r3_works w JOIN events e ON e.work_id='10000000-0000-4000-8000-000000000009' AND e.slug='artwork-'||w.slug
JOIN artists a ON a.work_id=e.work_id AND a.slug=w.artist_slug
JOIN artist_translations at2 ON at2.artist_id=a.id AND at2.locale='zh-CN'
JOIN locations l ON l.work_id=e.work_id AND l.slug=w.location_slug
JOIN location_translations lt ON lt.location_id=l.id AND lt.locale='zh-CN'
UNION ALL
SELECT e.id,'en'::locale_code,'Creation of '||w.name_en,at.name||' creates or advances '||w.name_en||' in '||lt.name||'; the date follows a catalogue range or year.','published'::translation_status,
       CASE WHEN w.start_year=w.end_year THEN w.start_year::text ELSE w.start_year::text||'–'||w.end_year::text END
FROM r3_works w JOIN events e ON e.work_id='10000000-0000-4000-8000-000000000009' AND e.slug='artwork-'||w.slug
JOIN artists a ON a.work_id=e.work_id AND a.slug=w.artist_slug
JOIN artist_translations at ON at.artist_id=a.id AND at.locale='en'
JOIN locations l ON l.work_id=e.work_id AND l.slug=w.location_slug
JOIN location_translations lt ON lt.location_id=l.id AND lt.locale='en'
ON CONFLICT DO NOTHING;
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'creation',0 FROM r3_works w JOIN events e ON e.work_id='10000000-0000-4000-8000-000000000009' AND e.slug='artwork-'||w.slug
JOIN locations l ON l.work_id=e.work_id AND l.slug=w.location_slug
ON CONFLICT DO NOTHING;
INSERT INTO artwork_event_links(work_id,artwork_id,event_id,role)
SELECT aw.work_id,aw.id,e.id,CASE WHEN w.artwork_status='destroyed' THEN 'destroyed' ELSE 'produced' END
FROM r3_works w JOIN artworks aw ON aw.work_id='10000000-0000-4000-8000-000000000009' AND aw.slug=w.slug
JOIN events e ON e.work_id=aw.work_id AND e.slug='artwork-'||w.slug
ON CONFLICT DO NOTHING;
INSERT INTO artist_event_links(work_id,artist_id,event_id,role)
SELECT a.work_id,a.id,e.id,'creator' FROM r3_works w JOIN artists a ON a.work_id='10000000-0000-4000-8000-000000000009' AND a.slug=w.artist_slug
JOIN events e ON e.work_id=a.work_id AND e.slug='artwork-'||w.slug
ON CONFLICT DO NOTHING;
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,'59000000-0000-4000-8000-000000000009' FROM events e WHERE e.work_id='10000000-0000-4000-8000-000000000009' AND e.sequence BETWEEN 6 AND 96
ON CONFLICT DO NOTHING;

INSERT INTO seed_history(version) VALUES ('052_european_art_r3_expansion') ON CONFLICT DO NOTHING;
COMMIT;
