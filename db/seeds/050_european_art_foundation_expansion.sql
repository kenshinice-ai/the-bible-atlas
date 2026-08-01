BEGIN;

-- Foundation expansion: eleven additional artists plus the first institution
-- records. Each row has a chapter, two published translations and a source.
INSERT INTO artists(id,work_id,slug,artist_kind,birth_year,death_year,birth_location_id,death_location_id,chapter_id,sort_order) VALUES
('49000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000009','polykleitos','person',-480,-420,NULL,NULL,'89000000-0000-4000-8001-000000000009',6),
('49000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000009','duccio','person',1255,1319,NULL,NULL,'89000000-0000-4000-8002-000000000009',7),
('49000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000009','masaccio','person',1401,1428,'39000000-0000-4000-8000-000000000002',NULL,'89000000-0000-4000-8003-000000000009',8),
('49000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000009','titian','person',1488,1576,NULL,NULL,'89000000-0000-4000-8003-000000000009',9),
('49000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000009','caravaggio','person',1571,1610,NULL,NULL,'89000000-0000-4000-8004-000000000009',10),
('49000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000009','velazquez','person',1599,1660,NULL,NULL,'89000000-0000-4000-8004-000000000009',11),
('49000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000009','jacques-louis-david','person',1748,1825,NULL,NULL,'89000000-0000-4000-8005-000000000009',12),
('49000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000009','j-m-w-turner','person',1775,1851,'39000000-0000-4000-8000-000000000011','39000000-0000-4000-8000-000000000011','89000000-0000-4000-8005-000000000009',13),
('49000000-0000-4000-8000-000000000014','10000000-0000-4000-8000-000000000009','claude-monet','person',1840,1926,'39000000-0000-4000-8000-000000000009',NULL,'89000000-0000-4000-8006-000000000009',14),
('49000000-0000-4000-8000-000000000015','10000000-0000-4000-8000-000000000009','pablo-picasso','person',1881,1973,NULL,NULL,'89000000-0000-4000-8007-000000000009',15),
('49000000-0000-4000-8000-000000000016','10000000-0000-4000-8000-000000000009','wassily-kandinsky','person',1866,1944,NULL,NULL,'89000000-0000-4000-8008-000000000009',16)
ON CONFLICT DO NOTHING;

INSERT INTO artist_translations(artist_id,locale,name,summary,modern_status,period_titles,status) VALUES
('49000000-0000-4000-8000-000000000006','zh-CN','波留克列托斯','古典希腊雕塑家，以比例法则和理想人体研究著称。','古典雕塑理论的重要参照',ARRAY['古典雕塑家','比例法则理论家'],'published'),('49000000-0000-4000-8000-000000000006','en','Polykleitos','Classical Greek sculptor associated with proportion and the ideal body.','Important reference point for classical sculpture',ARRAY['Classical sculptor','Theorist of proportion'],'published'),
('49000000-0000-4000-8000-000000000007','zh-CN','杜乔','锡耶纳画派代表人物，连接拜占庭图像传统与意大利绘画革新。','锡耶纳画派奠基者之一',ARRAY['锡耶纳画派','中世纪晚期画家'],'published'),('49000000-0000-4000-8000-000000000007','en','Duccio','A leading Sienese painter connecting Byzantine image traditions with Italian innovation.','One of the founders of the Sienese school',ARRAY['Sienese school','Late medieval painter'],'published'),
('49000000-0000-4000-8000-000000000008','zh-CN','马萨乔','以体积、透视和光线推动佛罗伦萨绘画转向文艺复兴。','早期文艺复兴关键人物',ARRAY['早期文艺复兴','佛罗伦萨画派'],'published'),('49000000-0000-4000-8000-000000000008','en','Masaccio','His volume, perspective and light help turn Florentine painting toward the Renaissance.','Key figure of the Early Renaissance',ARRAY['Early Renaissance','Florentine school'],'published'),
('49000000-0000-4000-8000-000000000009','zh-CN','提香','威尼斯画家，以色彩、肖像和大型宗教画拓展油画语言。','威尼斯画派核心大师',ARRAY['威尼斯画派','文艺复兴大师'],'published'),('49000000-0000-4000-8000-000000000009','en','Titian','Venetian painter who expanded oil painting through colour, portraiture and large religious works.','Central master of the Venetian school',ARRAY['Venetian school','Renaissance master'],'published'),
('49000000-0000-4000-8000-000000000010','zh-CN','卡拉瓦乔','以强烈明暗和现实人物形象改变巴洛克绘画的戏剧性。','巴洛克自然主义先驱',ARRAY['巴洛克','明暗法'],'published'),('49000000-0000-4000-8000-000000000010','en','Caravaggio','His stark light and real models transform the drama of Baroque painting.','Precursor of Baroque naturalism',ARRAY['Baroque','Chiaroscuro'],'published'),
('49000000-0000-4000-8000-000000000011','zh-CN','委拉斯开兹','西班牙宫廷画家，以肖像、空间和观看关系影响后世绘画。','西班牙黄金时代代表画家',ARRAY['西班牙黄金时代','宫廷画家'],'published'),('49000000-0000-4000-8000-000000000011','en','Diego Velázquez','Spanish court painter whose portraits and spatial intelligence influence later painting.','Representative painter of the Spanish Golden Age',ARRAY['Spanish Golden Age','Court painter'],'published'),
('49000000-0000-4000-8000-000000000012','zh-CN','雅克-路易·大卫','新古典主义画家，连接革命政治、历史画与学院制度。','新古典主义核心人物',ARRAY['新古典主义','革命时期画家'],'published'),('49000000-0000-4000-8000-000000000012','en','Jacques-Louis David','Neoclassical painter connecting revolutionary politics, history painting and the academy.','Central figure of Neoclassicism',ARRAY['Neoclassicism','Revolutionary-era painter'],'published'),
('49000000-0000-4000-8000-000000000013','zh-CN','J·M·W·透纳','英国风景画家，以光、气候和运动重写风景画。','浪漫主义风景画先驱',ARRAY['浪漫主义','英国风景画'],'published'),('49000000-0000-4000-8000-000000000013','en','J. M. W. Turner','British landscape painter who reworks landscape through light, weather and motion.','Precursor of Romantic landscape painting',ARRAY['Romanticism','British landscape painting'],'published'),
('49000000-0000-4000-8000-000000000014','zh-CN','克劳德·莫奈','印象派画家，以连续观察和色彩并置研究光的变化。','印象派代表人物',ARRAY['印象派','户外写生'],'published'),('49000000-0000-4000-8000-000000000014','en','Claude Monet','Impressionist painter studying changing light through serial observation and colour juxtaposition.','Representative Impressionist',ARRAY['Impressionism','Plein-air painting'],'published'),
('49000000-0000-4000-8000-000000000015','zh-CN','巴勃罗·毕加索','跨越立体主义与多种媒介的现代主义艺术家。','现代艺术的关键人物',ARRAY['立体主义','现代主义'],'published'),('49000000-0000-4000-8000-000000000015','en','Pablo Picasso','Modernist artist working across Cubism and multiple media.','Key figure of modern art',ARRAY['Cubism','Modernism'],'published'),
('49000000-0000-4000-8000-000000000016','zh-CN','瓦西里·康定斯基','以抽象绘画、色彩理论和跨国先锋网络影响现代艺术。','抽象艺术的重要先驱',ARRAY['抽象艺术','表现主义'],'published'),('49000000-0000-4000-8000-000000000016','en','Wassily Kandinsky','Artist whose abstraction, colour theory and transnational networks shape modern art.','Important precursor of abstraction',ARRAY['Abstraction','Expressionism'],'published')
ON CONFLICT DO NOTHING;

INSERT INTO artist_movements(artist_id,movement_id)
SELECT a.id,m.id FROM artists a JOIN movements m ON m.work_id=a.work_id AND (
  (a.slug='polykleitos' AND m.slug='classicism') OR (a.slug='duccio' AND m.slug='gothic') OR
  (a.slug='masaccio' AND m.slug='renaissance-humanism') OR (a.slug='titian' AND m.slug='renaissance-humanism') OR
  (a.slug='caravaggio' AND m.slug='baroque') OR (a.slug='velazquez' AND m.slug='baroque') OR
  (a.slug='jacques-louis-david' AND m.slug='renaissance-humanism') OR (a.slug='j-m-w-turner' AND m.slug='modernism') OR
  (a.slug='claude-monet' AND m.slug='modernism') OR (a.slug='pablo-picasso' AND m.slug='modernism') OR (a.slug='wassily-kandinsky' AND m.slug='modernism'))
ON CONFLICT DO NOTHING;

INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type) VALUES
('59000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000009','The Museum of Modern Art collection','https://www.moma.org/collection/works/79802','Institutional collection record for The Starry Night and its current custody.','primary','reference'),
('59000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000009','Louvre Collections','https://collections.louvre.fr/en/album/2','Institutional collection record for the Mona Lisa.','primary','reference'),
('59000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000009','Van Gogh Museum timeline','https://www.vangoghmuseum.nl/en/stories/vincents-life','Institutional timeline for Van Gogh places and dates.','primary','reference')
ON CONFLICT DO NOTHING;
INSERT INTO source_translations(source_id,locale,title,citation,status) VALUES
('59000000-0000-4000-8000-000000000010','zh-CN','纽约现代艺术博物馆藏品','《星月夜》及其现藏信息的机构记录。','published'),('59000000-0000-4000-8000-000000000010','en','The Museum of Modern Art collection','Institutional collection record for The Starry Night and its current custody.','published'),
('59000000-0000-4000-8000-000000000011','zh-CN','卢浮宫藏品目录','《蒙娜丽莎》及其现藏信息的机构记录。','published'),('59000000-0000-4000-8000-000000000011','en','Louvre Collections','Institutional collection record for the Mona Lisa.','published'),
('59000000-0000-4000-8000-000000000012','zh-CN','梵高博物馆生平时间线','梵高生平地点与年代的机构时间线。','published'),('59000000-0000-4000-8000-000000000012','en','Van Gogh Museum timeline','Institutional timeline for Van Gogh places and dates.','published') ON CONFLICT DO NOTHING;
INSERT INTO artist_sources SELECT id,'59000000-0000-4000-8000-000000000009' FROM artists WHERE work_id='10000000-0000-4000-8000-000000000009' ON CONFLICT DO NOTHING;

INSERT INTO art_institutions(id,work_id,slug,location_id,institution_type,founded_year) VALUES
('b9000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000009','louvre-museum','39000000-0000-4000-8000-000000000009','museum',1793),
('b9000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000009','moma','39000000-0000-4000-8000-000000000014','museum',1929),
('b9000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000009','scrovegni-chapel','39000000-0000-4000-8000-000000000012','chapel',1303)
ON CONFLICT DO NOTHING;
INSERT INTO art_institution_translations(institution_id,locale,name,summary,status) VALUES
('b9000000-0000-4000-8000-000000000001','zh-CN','卢浮宫博物馆','收藏并展出《蒙娜丽莎》的巴黎博物馆。','published'),('b9000000-0000-4000-8000-000000000001','en','Louvre Museum','The Paris museum that holds and displays the Mona Lisa.','published'),
('b9000000-0000-4000-8000-000000000002','zh-CN','纽约现代艺术博物馆','收藏《星月夜》的纽约现代艺术机构。','published'),('b9000000-0000-4000-8000-000000000002','en','The Museum of Modern Art','The New York modern art institution that holds The Starry Night.','published'),
('b9000000-0000-4000-8000-000000000003','zh-CN','斯克罗威尼礼拜堂','帕多瓦保存乔托壁画的重要地点。','published'),('b9000000-0000-4000-8000-000000000003','en','Scrovegni Chapel','The Padua site preserving Giotto''s major fresco cycle.','published') ON CONFLICT DO NOTHING;
INSERT INTO institution_sources(institution_id,source_id) VALUES
('b9000000-0000-4000-8000-000000000001','59000000-0000-4000-8000-000000000011'),('b9000000-0000-4000-8000-000000000002','59000000-0000-4000-8000-000000000010'),('b9000000-0000-4000-8000-000000000003','59000000-0000-4000-8000-000000000009') ON CONFLICT DO NOTHING;
INSERT INTO artist_institutions(artist_id,institution_id,role) VALUES
('49000000-0000-4000-8000-000000000003','b9000000-0000-4000-8000-000000000001','collection'),('49000000-0000-4000-8000-000000000005','b9000000-0000-4000-8000-000000000002','collection'),('49000000-0000-4000-8000-000000000002','b9000000-0000-4000-8000-000000000003','site') ON CONFLICT DO NOTHING;

INSERT INTO artwork_sources SELECT id,'59000000-0000-4000-8000-000000000009' FROM artworks WHERE work_id='10000000-0000-4000-8000-000000000009' ON CONFLICT DO NOTHING;
INSERT INTO artwork_sources(artwork_id,source_id) VALUES ('a8000000-0000-4000-8000-000000000003','59000000-0000-4000-8000-000000000011'),('a8000000-0000-4000-8000-000000000005','59000000-0000-4000-8000-000000000010') ON CONFLICT DO NOTHING;
INSERT INTO movement_sources SELECT id,'59000000-0000-4000-8000-000000000009' FROM movements WHERE work_id='10000000-0000-4000-8000-000000000009' ON CONFLICT DO NOTHING;

INSERT INTO seed_history(version) VALUES ('050_european_art_foundation_expansion') ON CONFLICT DO NOTHING;
COMMIT;
