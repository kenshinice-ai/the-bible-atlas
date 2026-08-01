BEGIN;

-- European Art History Atlas: a bilingual, era-first foundation. All prose is
-- original summaries; dates and titles are compact reference metadata.
INSERT INTO works(id,slug,author_name,publication_year,content_mode,map_layer,default_locale,launch_rank,mode_reason,category,origin_region,chronology_start_year,chronology_end_year,theme_color,theme_color_dark,theme_color_light) VALUES
('10000000-0000-4000-8000-000000000009','european-art-history','European art history consortium',NULL,'documented_record','real','zh-CN',9,'A documented art-history atlas: places use historical locations, while each chapter supplies the period language and calendar context.','art_history','Europe',-500,1945,'#B8894A','#5E4527','#E4C99A') ON CONFLICT DO NOTHING;
INSERT INTO work_translations(work_id,locale,title,summary,status) VALUES
('10000000-0000-4000-8000-000000000009','zh-CN','欧洲美术史','以时代为主轴，连接艺术家、作品、流派、机构与真实地点；现代称谓单独标注，不覆盖历史语境。','published'),
('10000000-0000-4000-8000-000000000009','en','European Art History','An era-first atlas connecting artists, artworks, movements, institutions and real places; modern labels are explicit and never replace historical context.','published') ON CONFLICT DO NOTHING;

INSERT INTO work_chronologies(id,work_id,kind,label,start_year,end_year,calendar_system,is_default) VALUES
('91000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000009','historical','BCE/CE historical years',-500,1945,'gregorian',true) ON CONFLICT DO NOTHING;

INSERT INTO chapters(id,work_id,slug,sequence,reference_label,era_start_year,era_end_year,accent_color) VALUES
('89000000-0000-4000-8001-000000000009','10000000-0000-4000-8000-000000000009','classical-antiquity',1,'c. 500 BCE–476 CE',-500,476,'#C9A66B'),
('89000000-0000-4000-8002-000000000009','10000000-0000-4000-8000-000000000009','medieval',2,'c. 476–1400',476,1400,'#8AA3A8'),
('89000000-0000-4000-8003-000000000009','10000000-0000-4000-8000-000000000009','renaissance',3,'c. 1400–1600',1400,1600,'#D28A61'),
('89000000-0000-4000-8004-000000000009','10000000-0000-4000-8000-000000000009','baroque',4,'c. 1600–1750',1600,1750,'#B87965'),
('89000000-0000-4000-8005-000000000009','10000000-0000-4000-8000-000000000009','neoclassicism-and-romanticism',5,'c. 1750–1850',1750,1850,'#8A8DB8'),
('89000000-0000-4000-8006-000000000009','10000000-0000-4000-8000-000000000009','modernism',6,'c. 1850–1945',1850,1945,'#C66F67'),
('89000000-0000-4000-8007-000000000009','10000000-0000-4000-8000-000000000009','modernism-early',7,'c. 1850–1900',1850,1900,'#6EA59B'),
('89000000-0000-4000-8008-000000000009','10000000-0000-4000-8000-000000000009','modernism-and-war',8,'c. 1900–1945',1900,1945,'#B29A66') ON CONFLICT DO NOTHING;
INSERT INTO chapter_translations(chapter_id,locale,title,summary,status)
SELECT c.id,v.locale::locale_code,v.title,v.summary,'published' FROM chapters c JOIN (VALUES
('classical-antiquity','zh-CN','古典时代','希腊与罗马的比例、神话与公共建筑成为欧洲艺术的长期底稿。'),('classical-antiquity','en','Classical Antiquity','Greek and Roman proportion, myth and civic architecture form a durable foundation.'),
('medieval','zh-CN','中世纪','基督教图像、修道院与哥特式城市塑造跨地域的视觉秩序。'),('medieval','en','Medieval','Christian images, monasteries and Gothic cities shape a shared visual order.'),
('renaissance','zh-CN','文艺复兴','人文主义、透视法与赞助制度重新定义艺术家的社会角色。'),('renaissance','en','Renaissance','Humanism, perspective and patronage redefine the artist’s social role.'),
('baroque','zh-CN','巴洛克','戏剧性的光线、运动与宫廷/宗教委托扩展了图像的情感强度。'),('baroque','en','Baroque','Dramatic light, motion and courtly or religious commissions intensify the image.'),
('neoclassicism-and-romanticism','zh-CN','新古典主义与浪漫主义','古典规范与个人情感在革命与工业化时代相互张力。'),('neoclassicism-and-romanticism','en','Neoclassicism and Romanticism','Classical discipline and personal feeling meet amid revolution and industrialisation.'),
('modernism','zh-CN','现代主义','摄影、城市化与战争促使艺术家重写观看、材料与作者身份。'),('modernism','en','Modernism','Photography, cities and war prompt artists to rethink vision, material and authorship.'),
('modernism-early','zh-CN','现代主义早期','摄影、城市化与新材料促使艺术家重写观看、材料与作者身份。'),('modernism-early','en','Early Modernism','Photography, cities and new materials prompt artists to rethink vision, material and authorship.'),
('modernism-and-war','zh-CN','现代主义与战争','先锋派、流亡与战争重塑艺术网络，并把现代艺术推向新的制度语境。'),('modernism-and-war','en','Modernism and War','Avant-gardes, exile and war reshape artistic networks before 1945.')
) AS v(slug,locale,title,summary) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000009';

INSERT INTO locations(id,work_id,slug,layer,geom,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('39000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000009','athens','real',ST_SetSRID(ST_MakePoint(23.7275,37.9838),4326)::geography,1,'city','city_centroid',10,'GR',false,true),
('39000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000009','florence','real',ST_SetSRID(ST_MakePoint(11.2558,43.7696),4326)::geography,2,'city','city_centroid',10,'IT',false,true),
('39000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000009','rome','real',ST_SetSRID(ST_MakePoint(12.4964,41.9028),4326)::geography,3,'city','city_centroid',10,'IT',false,true),
('39000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000009','paris','real',ST_SetSRID(ST_MakePoint(2.3522,48.8566),4326)::geography,4,'city','city_centroid',10,'FR',false,true),
('39000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000009','amsterdam','real',ST_SetSRID(ST_MakePoint(4.9041,52.3676),4326)::geography,5,'city','city_centroid',10,'NL',false,true),
('39000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000009','london','real',ST_SetSRID(ST_MakePoint(-0.1276,51.5072),4326)::geography,6,'city','city_centroid',10,'GB',false,true),
('39000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000009','padua','real',ST_SetSRID(ST_MakePoint(11.8768,45.4064),4326)::geography,7,'city','city_centroid',10,'IT',false,true),
('39000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000009','saint-remy-de-provence','real',ST_SetSRID(ST_MakePoint(4.8311,43.7880),4326)::geography,8,'city','city_centroid',10,'FR',false,true),
('39000000-0000-4000-8000-000000000014','10000000-0000-4000-8000-000000000009','new-york','real',ST_SetSRID(ST_MakePoint(-73.9857,40.7484),4326)::geography,9,'city','city_centroid',10,'US',false,true),
('39000000-0000-4000-8000-000000000015','10000000-0000-4000-8000-000000000009','zundert','real',ST_SetSRID(ST_MakePoint(4.6550,51.4717),4326)::geography,10,'city','city_centroid',10,'NL',false,true),
('39000000-0000-4000-8000-000000000016','10000000-0000-4000-8000-000000000009','auvers-sur-oise','real',ST_SetSRID(ST_MakePoint(2.1690,49.0718),4326)::geography,11,'city','city_centroid',10,'FR',false,true),
('39000000-0000-4000-8000-000000000017','10000000-0000-4000-8000-000000000009','amboise','real',ST_SetSRID(ST_MakePoint(0.9820,47.4125),4326)::geography,12,'city','city_centroid',10,'FR',false,true),
('39000000-0000-4000-8000-000000000018','10000000-0000-4000-8000-000000000009','vinci','real',ST_SetSRID(ST_MakePoint(10.9240,43.7870),4326)::geography,13,'city','city_centroid',10,'IT',false,true) ON CONFLICT DO NOTHING;
INSERT INTO location_translations(location_id,locale,name,summary,status) VALUES
('39000000-0000-4000-8000-000000000001','zh-CN','雅典','古典城邦与学院传统的核心地点','published'),('39000000-0000-4000-8000-000000000001','en','Athens','A core site of the classical polis and academy tradition.','published'),
('39000000-0000-4000-8000-000000000002','zh-CN','佛罗伦萨','文艺复兴赞助、工坊与人文主义网络的中心','published'),('39000000-0000-4000-8000-000000000002','en','Florence','A centre of Renaissance patronage, workshops and humanist networks.','published'),
('39000000-0000-4000-8000-000000000003','zh-CN','罗马','古典遗产、教廷委托与现代艺术机构交叠的城市','published'),('39000000-0000-4000-8000-000000000003','en','Rome','A city where classical heritage, papal commissions and modern institutions overlap.','published'),
('39000000-0000-4000-8000-000000000009','zh-CN','巴黎','学院、沙龙与现代主义先锋网络的节点','published'),('39000000-0000-4000-8000-000000000009','en','Paris','A node of academies, salons and modernist avant-gardes.','published'),
('39000000-0000-4000-8000-000000000010','zh-CN','阿姆斯特丹','荷兰黄金时代绘画与城市收藏文化的中心','published'),('39000000-0000-4000-8000-000000000010','en','Amsterdam','A centre of Dutch Golden Age painting and urban collecting.','published'),
('39000000-0000-4000-8000-000000000011','zh-CN','伦敦','博物馆、学院与战后当代艺术网络的重要城市','published'),('39000000-0000-4000-8000-000000000011','en','London','A major city for museums, academies and postwar contemporary networks.','published'),
('39000000-0000-4000-8000-000000000012','zh-CN','帕多瓦','乔托《哀悼基督》壁画所在城市','published'),('39000000-0000-4000-8000-000000000012','en','Padua','The city of Giotto''s Scrovegni Chapel frescoes.','published'),
('39000000-0000-4000-8000-000000000013','zh-CN','圣雷米','梵高创作《星月夜》的法国南部地点','published'),('39000000-0000-4000-8000-000000000013','en','Saint-Rémy-de-Provence','The southern French place associated with Van Gogh''s Starry Night.','published'),
('39000000-0000-4000-8000-000000000014','zh-CN','纽约','现代艺术博物馆收藏《星月夜》的城市','published'),('39000000-0000-4000-8000-000000000014','en','New York','The city where MoMA holds The Starry Night.','published'),
('39000000-0000-4000-8000-000000000015','zh-CN','尊德特','梵高出生地','published'),('39000000-0000-4000-8000-000000000015','en','Zundert','Vincent van Gogh''s birthplace.','published'),
('39000000-0000-4000-8000-000000000016','zh-CN','瓦兹河畔欧韦','梵高生命最后阶段的法国小镇','published'),('39000000-0000-4000-8000-000000000016','en','Auvers-sur-Oise','The French town where Van Gogh spent his final weeks.','published'),
('39000000-0000-4000-8000-000000000017','zh-CN','昂布瓦斯','列奥纳多晚年与去世地点','published'),('39000000-0000-4000-8000-000000000017','en','Amboise','Leonardo da Vinci''s final French setting.','published'),
('39000000-0000-4000-8000-000000000018','zh-CN','芬奇','列奥纳多的出生地','published'),('39000000-0000-4000-8000-000000000018','en','Vinci','Leonardo da Vinci''s birthplace.','published') ON CONFLICT DO NOTHING;

INSERT INTO movements(id,work_id,slug,chapter_id,start_year,end_year,sort_order) VALUES
('a9000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000009','classicism','89000000-0000-4000-8001-000000000009',-500,476,1),('a9000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000009','gothic','89000000-0000-4000-8002-000000000009',1100,1400,2),('a9000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000009','renaissance-humanism','89000000-0000-4000-8003-000000000009',1400,1600,3),('a9000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000009','baroque','89000000-0000-4000-8004-000000000009',1600,1750,4),('a9000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000009','modernism','89000000-0000-4000-8006-000000000009',1850,1945,5) ON CONFLICT DO NOTHING;
INSERT INTO movement_translations(movement_id,locale,name,summary,status) SELECT m.id,l.locale,CASE WHEN l.locale='zh-CN' THEN v.zh ELSE v.en END,CASE WHEN l.locale='zh-CN' THEN '以时代语境标注的艺术语言与制度网络。' ELSE 'An era-specific artistic language and institutional network.' END,'published' FROM movements m JOIN (VALUES ('classicism','古典主义','Classicism'),('gothic','哥特式','Gothic'),('renaissance-humanism','文艺复兴人文主义','Renaissance Humanism'),('baroque','巴洛克','Baroque'),('modernism','现代主义','Modernism')) v(slug,zh,en) ON v.slug=m.slug CROSS JOIN (VALUES ('zh-CN'::locale_code),('en'::locale_code)) l(locale) WHERE m.work_id='10000000-0000-4000-8000-000000000009' ON CONFLICT DO NOTHING;

INSERT INTO artists(id,work_id,slug,birth_year,death_year,birth_location_id,death_location_id,chapter_id,sort_order) VALUES
('49000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000009','phidias',-490,-430,'39000000-0000-4000-8000-000000000001','39000000-0000-4000-8000-000000000001','89000000-0000-4000-8001-000000000009',1),
('49000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000009','giotto',1267,1337,'39000000-0000-4000-8000-000000000002','39000000-0000-4000-8000-000000000002','89000000-0000-4000-8002-000000000009',2),
('49000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000009','leonardo-da-vinci',1452,1519,'39000000-0000-4000-8000-000000000018','39000000-0000-4000-8000-000000000017','89000000-0000-4000-8003-000000000009',3),
('49000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000009','rembrandt',1606,1669,'39000000-0000-4000-8000-000000000010','39000000-0000-4000-8000-000000000010','89000000-0000-4000-8004-000000000009',4),
('49000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000009','van-gogh',1853,1890,'39000000-0000-4000-8000-000000000015','39000000-0000-4000-8000-000000000016','89000000-0000-4000-8006-000000000009',5) ON CONFLICT DO NOTHING;
INSERT INTO artist_translations(artist_id,locale,name,summary,modern_status,period_titles,status) VALUES
('49000000-0000-4000-8000-000000000001','zh-CN','菲迪亚斯','古典希腊雕塑家，参与雅典卫城视觉秩序的建立。','古典雕塑的奠基性人物',ARRAY['雅典卫城总监','古典主义范式'],'published'),('49000000-0000-4000-8000-000000000001','en','Phidias','Classical Greek sculptor associated with the visual programme of the Acropolis.','Foundational figure of classical sculpture',ARRAY['Director of the Acropolis works','Classical paradigm'],'published'),
('49000000-0000-4000-8000-000000000002','zh-CN','乔托','以叙事性壁画推动中世纪图像向文艺复兴过渡。','西方绘画史的先驱',ARRAY['文艺复兴先驱','佛罗伦萨画派先声'],'published'),('49000000-0000-4000-8000-000000000002','en','Giotto','Narrative frescoes that help move European imagery toward the Renaissance.','Precursor of Western painting',ARRAY['Renaissance precursor','Florentine school forerunner'],'published'),
('49000000-0000-4000-8000-000000000003','zh-CN','列奥纳多·达·芬奇','画家、工程师与观察者，体现文艺复兴跨学科实践。','文艺复兴“通才”典型',ARRAY['文艺复兴大师','通才（uomo universale）'],'published'),('49000000-0000-4000-8000-000000000003','en','Leonardo da Vinci','Painter, engineer and observer embodying Renaissance interdisciplinary practice.','Canonical Renaissance polymath',ARRAY['Renaissance master','uomo universale'],'published'),
('49000000-0000-4000-8000-000000000004','zh-CN','伦勃朗','荷兰黄金时代画家，以光线、肖像与历史画著称。','荷兰黄金时代核心画家',ARRAY['荷兰黄金时代','明暗法大师'],'published'),('49000000-0000-4000-8000-000000000004','en','Rembrandt','Dutch Golden Age painter known for light, portraiture and history painting.','Central Dutch Golden Age painter',ARRAY['Dutch Golden Age','Master of chiaroscuro'],'published'),
('49000000-0000-4000-8000-000000000005','zh-CN','文森特·梵高','后印象派画家，以强烈笔触与色彩影响现代艺术。','现代艺术史的关键先驱',ARRAY['后印象派','表现主义先声'],'published'),('49000000-0000-4000-8000-000000000005','en','Vincent van Gogh','Post-Impressionist painter whose brushwork and colour shaped modern art.','Key precursor of modern art',ARRAY['Post-Impressionism','Precursor to Expressionism'],'published') ON CONFLICT DO NOTHING;

INSERT INTO artworks(id,work_id,slug,primary_artist_id,chapter_id,creation_start_year,creation_end_year,medium,status,creation_location_id,current_location_id,sort_order) VALUES
('a8000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000009','athena-parthenos','49000000-0000-4000-8000-000000000001','89000000-0000-4000-8001-000000000009',-447,-438,'chryselephantine sculpture','confirmed','39000000-0000-4000-8000-000000000001',NULL,1),
('a8000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000009','lamentation-giotto','49000000-0000-4000-8000-000000000002','89000000-0000-4000-8002-000000000009',1303,1305,'fresco','confirmed','39000000-0000-4000-8000-000000000012','39000000-0000-4000-8000-000000000012',2),
('a8000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000009','mona-lisa','49000000-0000-4000-8000-000000000003','89000000-0000-4000-8003-000000000009',1503,1519,'oil on poplar','confirmed','39000000-0000-4000-8000-000000000002','39000000-0000-4000-8000-000000000009',3),
('a8000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000009','night-watch','49000000-0000-4000-8000-000000000004','89000000-0000-4000-8004-000000000009',1642,1642,'oil on canvas','confirmed','39000000-0000-4000-8000-000000000010','39000000-0000-4000-8000-000000000010',4),
('a8000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000009','starry-night','49000000-0000-4000-8000-000000000005','89000000-0000-4000-8006-000000000009',1889,1889,'oil on canvas','confirmed','39000000-0000-4000-8000-000000000013','39000000-0000-4000-8000-000000000014',5) ON CONFLICT DO NOTHING;
INSERT INTO artwork_translations(artwork_id,locale,title,summary,status) SELECT a.id,l.locale,CASE WHEN l.locale='zh-CN' THEN v.zh ELSE v.en END,CASE WHEN l.locale='zh-CN' THEN '以时代语境与来源状态记录的代表性作品。' ELSE 'A representative work recorded with period context and source status.' END,'published' FROM artworks a JOIN (VALUES ('athena-parthenos','雅典娜·帕特农像','Athena Parthenos'),('lamentation-giotto','哀悼基督','Lamentation'),('mona-lisa','蒙娜丽莎','Mona Lisa'),('night-watch','夜巡','The Night Watch'),('starry-night','星月夜','The Starry Night')) v(slug,zh,en) ON v.slug=a.slug CROSS JOIN (VALUES ('zh-CN'::locale_code),('en'::locale_code)) l(locale) WHERE a.work_id='10000000-0000-4000-8000-000000000009' ON CONFLICT DO NOTHING;
INSERT INTO artist_artworks SELECT primary_artist_id,id,'creator' FROM artworks WHERE work_id='10000000-0000-4000-8000-000000000009' ON CONFLICT DO NOTHING;
INSERT INTO artist_movements(artist_id,movement_id) SELECT a.id,m.id FROM artists a JOIN movements m ON m.work_id=a.work_id AND ((a.slug='phidias' AND m.slug='classicism') OR (a.slug='giotto' AND m.slug='gothic') OR (a.slug='leonardo-da-vinci' AND m.slug='renaissance-humanism') OR (a.slug='rembrandt' AND m.slug='baroque') OR (a.slug='van-gogh' AND m.slug='modernism')) ON CONFLICT DO NOTHING;
INSERT INTO artwork_movements(artwork_id,movement_id) SELECT aa.artwork_id,am.movement_id FROM artist_artworks aa JOIN artist_movements am ON am.artist_id=aa.artist_id ON CONFLICT DO NOTHING;
INSERT INTO artist_locations SELECT id,birth_location_id,'birth' FROM artists WHERE birth_location_id IS NOT NULL ON CONFLICT DO NOTHING;
INSERT INTO artist_locations SELECT id,death_location_id,'death' FROM artists WHERE death_location_id IS NOT NULL ON CONFLICT DO NOTHING;

INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type) VALUES ('59000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000009','European art history reference set',NULL,'Compact public-domain reference metadata; verify against museum and scholarly catalogues before production expansion.','scholarly','reference') ON CONFLICT DO NOTHING;
INSERT INTO source_translations(source_id,locale,title,citation,status) VALUES ('59000000-0000-4000-8000-000000000009','zh-CN','欧洲美术史参考集','紧凑的公版参考元数据；扩展生产数据前应以博物馆与学术目录复核。','reviewed'),('59000000-0000-4000-8000-000000000009','en','European art history reference set','Compact public-domain reference metadata; verify against museum and scholarly catalogues before production expansion.','reviewed') ON CONFLICT DO NOTHING;
INSERT INTO artist_sources SELECT id,'59000000-0000-4000-8000-000000000009' FROM artists WHERE work_id='10000000-0000-4000-8000-000000000009' ON CONFLICT DO NOTHING;
INSERT INTO artwork_sources SELECT id,'59000000-0000-4000-8000-000000000009' FROM artworks WHERE work_id='10000000-0000-4000-8000-000000000009' ON CONFLICT DO NOTHING;

COMMIT;
