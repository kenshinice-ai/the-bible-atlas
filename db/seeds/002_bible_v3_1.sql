BEGIN;

INSERT INTO works(id,slug,author_name,publication_year,content_mode,map_layer,default_locale,launch_rank,mode_reason,category,origin_region,chronology_start_year,chronology_end_year,theme_color,theme_color_dark,theme_color_light) VALUES
('10000000-0000-4000-8000-000000000005','the-bible','Various authors and traditions',NULL,'documented_record','real','en',5,'An ancient anthology containing theological narrative, poetry, law, letters, reported history, and contested chronology; event-level reality and confidence must be shown.','mythic_epic','Ancient Near East / Mediterranean',-2100,62,'#c9972e','#6c4a13','#f3d78b');

INSERT INTO work_translations(work_id,locale,title,summary,status) VALUES
('10000000-0000-4000-8000-000000000005','zh-CN','圣经','跨越古代近东与地中海世界的文献汇编。本样本以人物、迁徙、王国与早期基督教事件测试复杂年代、地点可信度和关系网络；年代采用宽范围并明确不确定性。','published'),
('10000000-0000-4000-8000-000000000005','en','The Bible','An anthology spanning the ancient Near East and Mediterranean. This sample uses people, migrations, kingdoms, and early Christian events to stress-test uncertain chronology, geographic confidence, and relationship networks.','published');

INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type) VALUES
('51000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000005','Genesis',NULL,'Genesis 11–35','primary','primary_text'),
('51000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000005','Exodus',NULL,'Exodus 1–24','primary','primary_text'),
('51000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000005','Samuel',NULL,'1 Samuel 16–31; 2 Samuel 1–7','primary','primary_text'),
('51000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000005','Kings',NULL,'1 Kings 1–11','primary','primary_text'),
('51000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000005','Jonah',NULL,'Jonah 1–4','primary','primary_text'),
('51000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000005','Gospel according to Matthew',NULL,'Matthew 1–28','primary','primary_text'),
('51000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000005','Gospel according to Luke',NULL,'Luke 1–24','primary','primary_text'),
('51000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000005','Acts of the Apostles',NULL,'Acts 1–28','primary','primary_text'),
('51000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000005','Biblical chronology policy',NULL,'Demonstration chronology uses broad scholarly ranges and does not adjudicate competing chronologies.','reference','reference'),
('51000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000005','Biblical geography policy',NULL,'Modern coordinates identify present-day sites or conventional reference points; disputed sites are marked inferred or approximate.','reference','map');

INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('31000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000005','ur','real',ST_GeogFromText('POINT(46.1031 30.9625)'),NULL,NULL,1,'city','inferred',11,'IQ',true,true),
('31000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000005','harran','real',ST_GeogFromText('POINT(39.0314 36.8642)'),NULL,NULL,2,'city','approximate',11,'TR',false,true),
('31000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000005','canaan-shechem','real',ST_GeogFromText('POINT(35.2853 32.2136)'),NULL,NULL,3,'region','inferred',7,'PS',true,true),
('31000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000005','nile-delta','real',ST_GeogFromText('POINT(31.1000 30.8000)'),NULL,NULL,4,'region','approximate',7,'EG',true,true),
('31000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000005','mount-sinai-traditional','real',ST_GeogFromText('POINT(33.9750 28.5390)'),NULL,NULL,5,'religious_site','inferred',12,'EG',true,true),
('31000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000005','jerusalem','real',ST_GeogFromText('POINT(35.2350 31.7780)'),NULL,NULL,6,'city','city_centroid',11,'IL',false,true),
('31000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000005','bethlehem','real',ST_GeogFromText('POINT(35.2024 31.7054)'),NULL,NULL,7,'city','city_centroid',12,'PS',false,true),
('31000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000005','nazareth','real',ST_GeogFromText('POINT(35.3035 32.6996)'),NULL,NULL,8,'city','city_centroid',12,'IL',false,true),
('31000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000005','sea-of-galilee','real',ST_GeogFromText('POINT(35.5833 32.8333)'),NULL,NULL,9,'region','approximate',10,'IL',false,true),
('31000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000005','damascus','real',ST_GeogFromText('POINT(36.2765 33.5138)'),NULL,NULL,10,'city','city_centroid',11,'SY',false,true),
('31000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000005','nineveh','real',ST_GeogFromText('POINT(43.1520 36.3590)'),NULL,NULL,11,'landmark','approximate',12,'IQ',false,true),
('31000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000005','rome','real',ST_GeogFromText('POINT(12.4964 41.9028)'),NULL,NULL,12,'city','city_centroid',10,'IT',false,true);

INSERT INTO location_translations(location_id,locale,name,summary,status,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.significance,v.background,v.modern_status,v.region FROM locations l JOIN (VALUES
('ur','zh-CN','吾珥','亚伯拉罕家族叙事的出发地。',ARRAY['迦勒底的吾珥'],'本样本采用伊拉克南部乌尔遗址作为传统参照点，但学界对文本中的吾珥定位仍有讨论。','标记离开故土、走向应许之地的开端。','古代美索不达米亚城市。','乌尔考古遗址仍存。','古代美索不达米亚'),
('ur','en','Ur','The departure point in the Abraham family narrative.',ARRAY['Ur of the Chaldeans'],'This sample uses the southern Iraqi site as the conventional reference point while marking the identification as inferred.','It marks the beginning of leaving homeland toward the promised land.','An ancient Mesopotamian city.','The archaeological site survives.','Ancient Mesopotamia'),
('harran','zh-CN','哈兰','亚伯拉罕家族迁徙中的停留地。',ARRAY['哈兰城'],'从美索不达米亚通往迦南叙事路线的重要节点。','连接出发地与迦南。','古代上美索不达米亚聚落。','现代土耳其哈兰附近仍有人居与遗址。','上美索不达米亚'),
('harran','en','Harran','A stop in the migration of Abraham’s household.',ARRAY['Haran'],'A major narrative waypoint between Mesopotamia and Canaan.','It connects the place of origin with Canaan.','An ancient Upper Mesopotamian settlement.','The modern settlement and archaeological remains persist.','Upper Mesopotamia'),
('canaan-shechem','zh-CN','迦南（示剑参照点）','族长叙事中的目的区域，以示剑附近作为地图参照。',ARRAY['迦南','示剑'],'迦南是区域而非单一点位；坐标仅用于地图聚焦。','承载应许、定居与家族延续主题。','古代黎凡特的地理文化区域。','现代地点跨越多个行政区。','古代迦南'),
('canaan-shechem','en','Canaan (Shechem reference)','The destination region in patriarchal narratives, mapped here to a Shechem-area reference point.',ARRAY['Canaan','Shechem'],'Canaan is a region, not a point; the coordinate exists only for map focus.','It carries themes of promise, settlement, and family continuity.','A geographic and cultural region of the ancient Levant.','The region crosses modern administrative boundaries.','Ancient Canaan'),
('nile-delta','zh-CN','尼罗河三角洲','出埃及叙事的埃及区域参照点。',ARRAY['埃及'],'事件涉及广阔区域，坐标采用三角洲中心近似值。','代表奴役、离开与迁徙的起点。','古埃及北部人口密集区域。','今天仍是埃及核心区域。','古埃及'),
('nile-delta','en','Nile Delta','A regional reference point for Egypt in the Exodus narrative.',ARRAY['Egypt'],'The narrative concerns a broad region, so the coordinate is an approximate delta centroid.','It represents bondage, departure, and the start of migration.','A densely populated region of ancient northern Egypt.','It remains a major region of modern Egypt.','Ancient Egypt'),
('mount-sinai-traditional','zh-CN','西奈山（传统位置）','西奈盟约叙事的传统参照点。',ARRAY['何烈山'],'确切位置存在多种候选，本样本采用杰贝勒穆萨传统地点并标记为推定。','法律与盟约叙事的核心地点。','西奈半岛的传统朝圣地。','传统山址仍可访问。','西奈旷野'),
('mount-sinai-traditional','en','Mount Sinai (traditional site)','The conventional reference point for the Sinai covenant narrative.',ARRAY['Horeb'],'Several candidate locations exist; this sample uses Jebel Musa and marks it inferred.','A central place in the law and covenant narrative.','A traditional pilgrimage site in the Sinai Peninsula.','The traditional mountain site remains accessible.','Sinai wilderness'),
('jerusalem','zh-CN','耶路撒冷','王国、圣殿、福音书与使徒叙事交汇的城市。',ARRAY['锡安'],'不同历史阶段的城界与建筑位置并不相同，地图使用现代城市中心。','连接大卫王权、圣殿、耶稣受难与早期教会。','古代黎凡特长期重要城市。','现代城市仍存，历史与宗教地标众多。','犹大 / 犹太地区'),
('jerusalem','en','Jerusalem','A city linking monarchy, temple, Gospel, and Acts narratives.',ARRAY['Zion'],'Urban boundaries and buildings changed across periods; the map uses a modern city reference point.','It links Davidic kingship, the temple, the crucifixion, and the early church.','A major city of the ancient Levant.','The modern city contains extensive historic and religious sites.','Judah / Judea'),
('bethlehem','zh-CN','伯利恒','大卫传统与耶稣诞生叙事相关的城镇。',ARRAY['大卫之城'],'地图采用现代伯利恒中心，不对应某一具体建筑。','把王室谱系与诞生叙事连接起来。','古代犹大山区城镇。','现代伯利恒仍存。','犹大'),
('bethlehem','en','Bethlehem','A town associated with Davidic tradition and the birth narrative of Jesus.',ARRAY['City of David'],'The map uses the modern town centre and does not assert one precise building.','It links royal genealogy and the nativity narrative.','An ancient town in the Judean hill country.','Modern Bethlehem remains inhabited.','Judah'),
('nazareth','zh-CN','拿撒勒','耶稣成长与早期身份叙事相关的城镇。',ARRAY[]::text[],'以现代城镇中心作为历史地点参照。','为福音书人物提供长期生活地点。','罗马时期加利利聚落。','现代拿撒勒仍存。','加利利'),
('nazareth','en','Nazareth','The town associated with Jesus’ upbringing and early identity.',ARRAY[]::text[],'The modern town centre serves as the historical reference point.','It provides the long-term home location in the Gospel narrative.','A Galilean settlement in the Roman period.','Modern Nazareth remains inhabited.','Galilee'),
('sea-of-galilee','zh-CN','加利利海','多项传道与门徒叙事发生的湖区。',ARRAY['革尼撒勒湖'],'坐标代表湖泊区域中心。','聚集呼召门徒、教导与渡湖事件。','古代加利利的重要渔业与交通区域。','湖泊与周边城镇仍存。','加利利'),
('sea-of-galilee','en','Sea of Galilee','The lake region associated with ministry and disciple narratives.',ARRAY['Lake Gennesaret'],'The coordinate represents the lake region rather than one event point.','It gathers calling, teaching, and crossing narratives.','An important fishing and transport area in ancient Galilee.','The lake and surrounding towns remain.','Galilee'),
('damascus','zh-CN','大马士革','保罗转变与早期活动叙事的地点。',ARRAY['大马色'],'地图使用现代城市中心。','连接迫害者身份与传教使命的转折。','古代叙利亚重要城市。','现代大马士革仍存。','罗马叙利亚'),
('damascus','en','Damascus','The setting of Paul’s conversion and early activity narrative.',ARRAY[]::text[],'The map uses the modern city centre.','It marks the turn from persecutor to missionary.','A major ancient Syrian city.','Modern Damascus remains inhabited.','Roman Syria'),
('nineveh','zh-CN','尼尼微','约拿叙事中的亚述城市。',ARRAY[]::text[],'坐标指向摩苏尔附近公认的尼尼微遗址区域。','把先知使命扩展到以色列之外。','新亚述帝国都城之一。','考古遗址仍存，但受到现代破坏。','亚述'),
('nineveh','en','Nineveh','The Assyrian city in the Jonah narrative.',ARRAY[]::text[],'The coordinate identifies the accepted archaeological area near Mosul.','It extends the prophetic mission beyond Israel.','One of the capitals of the Neo-Assyrian Empire.','Archaeological remains survive despite modern damage.','Assyria'),
('rome','zh-CN','罗马','使徒行传末段保罗抵达的帝国首都。',ARRAY[]::text[],'地图使用现代罗马中心作为城市级参照。','把早期基督教叙事连接到帝国中心。','罗马帝国首都。','现代罗马保留大量古代遗址。','罗马帝国'),
('rome','en','Rome','The imperial capital reached by Paul near the end of Acts.',ARRAY[]::text[],'The map uses central modern Rome as a city-level reference.','It connects the early Christian narrative with the imperial centre.','Capital of the Roman Empire.','Modern Rome preserves extensive ancient remains.','Roman Empire')
) AS v(slug,locale,name,summary,aliases,detail,significance,background,modern_status,region) ON l.slug=v.slug AND l.work_id='10000000-0000-4000-8000-000000000005';

INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,birth_place_id,death_place_id,icon_variant,importance) VALUES
('21000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000005','abraham',1,'male','elder','protagonist','fictionalised_historical',-2100,-1900,'31000000-0000-4000-8000-000000000001',NULL,'patriarch',5),
('21000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000005','sarah',2,'female','elder','protagonist','fictionalised_historical',-2100,-1900,NULL,NULL,'matriarch',4),
('21000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000005','isaac',3,'male','adult','supporting','fictionalised_historical',-2000,-1800,NULL,NULL,'patriarch',4),
('21000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000005','jacob',4,'male','adult','protagonist','fictionalised_historical',-1950,-1750,NULL,NULL,'patriarch',4),
('21000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000005','moses',5,'male','elder','protagonist','fictionalised_historical',-1400,-1200,'31000000-0000-4000-8000-000000000004',NULL,'lawgiver',5),
('21000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000005','aaron',6,'male','elder','supporting','fictionalised_historical',-1400,-1200,'31000000-0000-4000-8000-000000000004',NULL,'priest',4),
('21000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000005','david',7,'male','adult','historical','fictionalised_historical',-1040,-970,'31000000-0000-4000-8000-000000000007','31000000-0000-4000-8000-000000000006','king',5),
('21000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000005','solomon',8,'male','adult','historical','fictionalised_historical',-1000,-930,'31000000-0000-4000-8000-000000000006','31000000-0000-4000-8000-000000000006','king',4),
('21000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000005','jonah',9,'male','adult','protagonist','unknown',-800,-700,NULL,NULL,'prophet',3),
('21000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000005','mary',10,'female','youth','supporting','fictionalised_historical',-25,50,'31000000-0000-4000-8000-000000000008',NULL,'historical',4),
('21000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000005','jesus',11,'male','adult','protagonist','fictionalised_historical',-6,33,'31000000-0000-4000-8000-000000000007','31000000-0000-4000-8000-000000000006','teacher',5),
('21000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000005','peter',12,'male','adult','supporting','fictionalised_historical',-10,65,NULL,NULL,'disciple',4),
('21000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000005','paul',13,'male','adult','historical','fictionalised_historical',5,65,NULL,'31000000-0000-4000-8000-000000000012','missionary',5);

INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('abraham','zh-CN','亚伯拉罕','族长叙事中离开吾珥并前往迦南的人物。',ARRAY['亚伯兰'],'其年代与行程无法转换为确定的现代日期，本样本使用宽范围。','回应呼召并为家族寻找新的生活方向。'),('abraham','en','Abraham','The patriarch who leaves Ur and travels toward Canaan.',ARRAY['Abram'],'His chronology and journey cannot be converted to exact modern dates; this sample uses broad ranges.','To answer a call and establish a future for his household.'),
('sarah','zh-CN','撒拉','与亚伯拉罕共同迁徙并成为以撒之母的族长人物。',ARRAY['撒莱'],'她的叙事连接迁徙、家族承诺与晚年生育。','维护家族延续并在不确定迁徙中建立家庭。'),('sarah','en','Sarah','A matriarch who migrates with Abraham and becomes Isaac’s mother.',ARRAY['Sarai'],'Her narrative connects migration, family promise, and late motherhood.','To sustain the household and its future through uncertain migration.'),
('isaac','zh-CN','以撒','亚伯拉罕与撒拉之子，雅各之父。',ARRAY[]::text[],'他把第一代迁徙叙事连接到后续家族分支。','延续家族并维持在迦南的生活。'),('isaac','en','Isaac','The son of Abraham and Sarah and father of Jacob.',ARRAY[]::text[],'He connects the first migration generation to later family branches.','To continue the household and its life in Canaan.'),
('jacob','zh-CN','雅各','以撒之子，在家族叙事中又名以色列。',ARRAY['以色列'],'他的家庭成为后续民族叙事的重要结构。','寻求祝福、安全与家族延续。'),('jacob','en','Jacob','Isaac’s son, also named Israel in the family narrative.',ARRAY['Israel'],'His household becomes a major structure for later national narratives.','To seek blessing, security, and continuity for his family.'),
('moses','zh-CN','摩西','带领以色列人离开埃及并在西奈接受律法的核心人物。',ARRAY[]::text[],'其年代、路线与西奈位置存在长期讨论，均以范围与推定坐标表示。','解放群体并建立盟约共同体。'),('moses','en','Moses','The central leader of the departure from Egypt and the Sinai law narrative.',ARRAY[]::text[],'His chronology, route, and the location of Sinai remain debated and are represented with ranges and inferred coordinates.','To liberate a community and establish its covenant order.'),
('aaron','zh-CN','亚伦','摩西的兄弟、同工与祭司人物。',ARRAY[]::text[],'他在与法老交涉和旷野礼仪叙事中承担辅助角色。','协助摩西并承担群体礼仪领导。'),('aaron','en','Aaron','Moses’ brother, collaborator, and priestly figure.',ARRAY[]::text[],'He supports negotiations and ritual leadership in the wilderness narrative.','To assist Moses and provide ritual leadership.'),
('david','zh-CN','大卫','从牧者与战士成长为王，并以耶路撒冷为政治中心。',ARRAY[]::text[],'人物具有历史背景，但具体叙事细节仍需逐事件标示可信度。','巩固王权并统一政治中心。'),('david','en','David','A shepherd and warrior who becomes king and makes Jerusalem a political centre.',ARRAY[]::text[],'The figure has a historical setting, while individual narrative details require event-level confidence labels.','To consolidate kingship and a political centre.'),
('solomon','zh-CN','所罗门','大卫之子，与王国治理、智慧传统和第一圣殿相关。',ARRAY[]::text[],'本样本聚焦其继位与圣殿建设叙事。','巩固王国并建立宗教与行政中心。'),('solomon','en','Solomon','David’s son, associated with royal administration, wisdom tradition, and the First Temple.',ARRAY[]::text[],'This sample focuses on accession and temple-building narratives.','To consolidate the kingdom and its religious-administrative centre.'),
('jonah','zh-CN','约拿','被差往尼尼微的先知叙事人物。',ARRAY[]::text[],'事件以传奇或神话叙事标记，不把文学结构宣称为可核实行程。','逃避后重新面对向敌对城市传达信息的使命。'),('jonah','en','Jonah','The prophetic figure sent toward Nineveh.',ARRAY[]::text[],'The event is marked legendary or mythic rather than presented as a verified itinerary.','To resist and eventually confront a mission to an enemy city.'),
('mary','zh-CN','马利亚','耶稣诞生与早期生活叙事中的母亲。',ARRAY['玛利亚'],'不同福音书强调的情节与路线不完全相同。','保护家庭并回应其承担的角色。'),('mary','en','Mary','The mother in the birth and early-life narratives of Jesus.',ARRAY[]::text[],'The Gospel accounts emphasize different details and routes.','To care for her family and respond to the role placed before her.'),
('jesus','zh-CN','耶稣','福音书叙事中心人物，在加利利传道并于耶路撒冷被处决。',ARRAY['拿撒勒人耶稣'],'历史研究与信仰解释并存；本地图只表示来源、地点和年代范围。','宣讲、医治、教导并建立门徒群体。'),('jesus','en','Jesus','The central Gospel figure who teaches in Galilee and is executed in Jerusalem.',ARRAY['Jesus of Nazareth'],'Historical study and theological interpretation coexist; this atlas only represents sources, places, and chronological ranges.','To proclaim, heal, teach, and form a disciple community.'),
('peter','zh-CN','彼得','加利利门徒和早期教会领袖人物。',ARRAY['西门彼得','矶法'],'其人物弧线跨越跟随、失败、恢复与群体领导。','跟随耶稣并在其后参与领导共同体。'),('peter','en','Peter','A Galilean disciple and early church leader.',ARRAY['Simon Peter','Cephas'],'His arc spans discipleship, failure, restoration, and community leadership.','To follow Jesus and later help lead the community.'),
('paul','zh-CN','保罗','从迫害者转变为传教者，并在地中海世界旅行。',ARRAY['扫罗'],'使徒行传与书信为其活动提供不同类型的第一手或叙事证据。','向更广泛的地中海群体传播信仰。'),('paul','en','Paul','A persecutor who becomes a missionary and travels through the Mediterranean world.',ARRAY['Saul'],'Acts and the letters provide different kinds of narrative and first-person evidence for his activity.','To carry the movement to wider Mediterranean communities.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005';

INSERT INTO chapters(id,work_id,slug,sequence,reference_label) VALUES
('81000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000005','patriarchs',1,'Genesis 11–35'),
('81000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000005','exodus-and-sinai',2,'Exodus 1–24'),
('81000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000005','united-monarchy',3,'Samuel–Kings'),
('81000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000005','prophetic-narrative',4,'Jonah'),
('81000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000005','gospels',5,'Matthew–Luke'),
('81000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000005','acts',6,'Acts');

INSERT INTO events(id,work_id,slug,start_date,end_date,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,start_month,start_day,parent_event_id,confidence,chapter_id) VALUES
('41000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000005','abraham-leaves-ur',NULL,NULL,1,'reported_historical','migration','range','unknown',-2100,-1900,NULL,NULL,NULL,'low','81000000-0000-4000-8000-000000000001'),
('41000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000005','birth-of-isaac',NULL,NULL,2,'reported_historical','birth','range','unknown',-2000,-1800,NULL,NULL,NULL,'low','81000000-0000-4000-8000-000000000001'),
('41000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000005','jacob-named-israel',NULL,NULL,3,'legendary_or_mythic','other','range','unknown',-1900,-1700,NULL,NULL,NULL,'low','81000000-0000-4000-8000-000000000001'),
('41000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000005','exodus-from-egypt',NULL,NULL,4,'contested','migration','range','unknown',-1300,-1200,NULL,NULL,NULL,'low','81000000-0000-4000-8000-000000000002'),
('41000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000005','sinai-covenant',NULL,NULL,5,'legendary_or_mythic','religious','range','unknown',-1300,-1200,NULL,NULL,'41000000-0000-4000-8000-000000000004','low','81000000-0000-4000-8000-000000000002'),
('41000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000005','david-becomes-king',NULL,NULL,6,'reported_historical','political','approximate','unknown',-1010,-1000,NULL,NULL,NULL,'medium','81000000-0000-4000-8000-000000000003'),
('41000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000005','jerusalem-royal-capital',NULL,NULL,7,'reported_historical','political','approximate','unknown',-1000,-990,NULL,NULL,'41000000-0000-4000-8000-000000000006','medium','81000000-0000-4000-8000-000000000003'),
('41000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000005','first-temple-built',NULL,NULL,8,'reported_historical','religious','approximate','unknown',-970,-950,NULL,NULL,NULL,'medium','81000000-0000-4000-8000-000000000003'),
('41000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000005','jonah-to-nineveh',NULL,NULL,9,'legendary_or_mythic','journey','range','unknown',-800,-700,NULL,NULL,NULL,'low','81000000-0000-4000-8000-000000000004'),
('41000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000005','birth-of-jesus',NULL,NULL,10,'reported_historical','birth','range','julian',-6,-4,NULL,NULL,NULL,'medium','81000000-0000-4000-8000-000000000005'),
('41000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000005','galilean-ministry',NULL,NULL,11,'reported_historical','religious','range','julian',27,30,NULL,NULL,NULL,'medium','81000000-0000-4000-8000-000000000005'),
('41000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000005','crucifixion-in-jerusalem',NULL,NULL,12,'reported_historical','death','range','julian',30,33,NULL,NULL,NULL,'high','81000000-0000-4000-8000-000000000005'),
('41000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000005','paul-conversion-damascus',NULL,NULL,13,'reported_historical','discovery','range','julian',33,36,NULL,NULL,NULL,'medium','81000000-0000-4000-8000-000000000006'),
('41000000-0000-4000-8000-000000000014','10000000-0000-4000-8000-000000000005','paul-arrives-rome',NULL,NULL,14,'reported_historical','journey','range','julian',60,62,NULL,NULL,NULL,'medium','81000000-0000-4000-8000-000000000006');

INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.significance,v.time_label FROM events e JOIN (VALUES
('abraham-leaves-ur','zh-CN','亚伯拉罕离开吾珥','家族从吾珥经哈兰走向迦南。','路线由文本地点顺序构成，年代与吾珥定位均不确定。','形成迁徙、应许与家族身份的开端。','约公元前 2100–1900 年'),('abraham-leaves-ur','en','Abraham leaves Ur','The household travels from Ur through Harran toward Canaan.','The route follows textual place order; chronology and the identification of Ur remain uncertain.','It begins the migration, promise, and family-identity arc.','c. 2100–1900 BCE'),
('birth-of-isaac','zh-CN','以撒出生','撒拉生下以撒，家族叙事进入下一代。','不转换为某个精确年份。','把迁徙承诺连接到家族延续。','约公元前 2000–1800 年'),('birth-of-isaac','en','Birth of Isaac','Sarah gives birth to Isaac and the family narrative moves to another generation.','No exact modern year is asserted.','It connects migration promises with family continuity.','c. 2000–1800 BCE'),
('jacob-named-israel','zh-CN','雅各被称为以色列','雅各的新名字成为后续群体身份叙事的关键。','本事件按传统叙事而非可验证行政记录呈现。','连接家族人物与后续民族名称。','约公元前 1900–1700 年'),('jacob-named-israel','en','Jacob is named Israel','Jacob’s new name becomes central to later community identity.','The event is presented as traditional narrative rather than a verifiable civil record.','It links a family figure with a later people-name.','c. 1900–1700 BCE'),
('exodus-from-egypt','zh-CN','离开埃及','摩西与亚伦带领群体离开埃及区域。','历史年代与路线存在重大讨论，因此使用世纪范围和区域坐标。','形成解放与群体迁徙的核心记忆。','约公元前 1300–1200 年'),('exodus-from-egypt','en','Departure from Egypt','Moses and Aaron lead a community away from the Egyptian region.','Chronology and route remain heavily debated, so a century range and regional coordinate are used.','It forms a central memory of liberation and migration.','c. 1300–1200 BCE'),
('sinai-covenant','zh-CN','西奈盟约','群体在西奈叙事中接受律法与盟约秩序。','山址采用传统地点，但明确标记为推定。','把迁徙群体塑造成具有共同规范的共同体。','约公元前 1300–1200 年'),('sinai-covenant','en','Sinai covenant','The community receives law and covenant order in the Sinai narrative.','The mountain uses a traditional site and is explicitly marked inferred.','It shapes a migrating population into a norm-governed community.','c. 1300–1200 BCE'),
('david-becomes-king','zh-CN','大卫成为王','大卫的身份从战士与地方领袖转向王权。','采用公元前十一世纪末的约略范围。','开启联合王国阶段的政治叙事。','约公元前 1010–1000 年'),('david-becomes-king','en','David becomes king','David’s role shifts from warrior and local leader to kingship.','An approximate range around the end of the eleventh century BCE is used.','It opens the political narrative of the united monarchy.','c. 1010–1000 BCE'),
('jerusalem-royal-capital','zh-CN','耶路撒冷成为王权中心','大卫把耶路撒冷建立为政治中心。','事件定位到城市层级，不假定现代城界等同古代城界。','使地点、王权与后续圣殿叙事汇合。','约公元前 1000–990 年'),('jerusalem-royal-capital','en','Jerusalem becomes a royal centre','David establishes Jerusalem as a political centre.','The event is located at city level without equating modern and ancient boundaries.','It joins place, kingship, and the later temple narrative.','c. 1000–990 BCE'),
('first-temple-built','zh-CN','第一圣殿建造叙事','所罗门在耶路撒冷建设圣殿中心。','采用传统的公元前十世纪中段范围。','强化王国、礼仪与城市空间的结合。','约公元前 970–950 年'),('first-temple-built','en','Building of the First Temple','Solomon builds a temple centre in Jerusalem.','A conventional mid-tenth-century BCE range is used.','It strengthens the link among monarchy, ritual, and urban space.','c. 970–950 BCE'),
('jonah-to-nineveh','zh-CN','约拿前往尼尼微','约拿最终面向尼尼微传达警告。','以传奇或神话叙事编码，路线不冒充可核实旅行记录。','讨论怜悯、敌对群体与先知使命。','传统置于公元前 8 世纪'),('jonah-to-nineveh','en','Jonah goes to Nineveh','Jonah eventually addresses a warning to Nineveh.','It is encoded as legendary or mythic narrative, not a verified travel log.','It explores mercy, enemy communities, and prophetic mission.','Traditionally placed in the 8th century BCE'),
('birth-of-jesus','zh-CN','耶稣诞生','福音书把耶稣的诞生与伯利恒联系起来。','采用公元前 6–4 年的常见范围，不声称精确日期。','开启福音书人物时间线并连接大卫传统。','约公元前 6–4 年'),('birth-of-jesus','en','Birth of Jesus','The Gospel narratives associate Jesus’ birth with Bethlehem.','A common 6–4 BCE range is used without claiming an exact date.','It opens the Gospel timeline and links it to Davidic tradition.','c. 6–4 BCE'),
('galilean-ministry','zh-CN','加利利传道阶段','耶稣在加利利湖区教导并召集门徒。','这是跨多个地点与事件的父级阶段。','建立人物网络，并把事件、地点和路线联动起来。','约公元 27–30 年'),('galilean-ministry','en','Galilean ministry','Jesus teaches and gathers disciples around the Galilee region.','This is a parent phase spanning several places and episodes.','It forms the person network and links events, places, and movement.','c. 27–30 CE'),
('crucifixion-in-jerusalem','zh-CN','耶路撒冷受难','耶稣在罗马统治下的耶路撒冷被处决。','精确年份存在 30 或 33 年等主要方案，因此保留范围。','改变门徒关系状态并成为后续使徒叙事的转折点。','约公元 30–33 年'),('crucifixion-in-jerusalem','en','Crucifixion in Jerusalem','Jesus is executed in Jerusalem under Roman rule.','Major proposals include 30 and 33 CE, so the range is preserved.','It changes disciple relationships and turns the narrative toward Acts.','c. 30–33 CE'),
('paul-conversion-damascus','zh-CN','保罗在大马士革路上的转变','扫罗在前往大马士革途中经历身份与使命转折。','使徒行传多次叙述该事件，细节角度有所不同。','把人物从迫害者转为传教者。','约公元 33–36 年'),('paul-conversion-damascus','en','Paul’s conversion near Damascus','Saul undergoes a change of identity and mission while travelling toward Damascus.','Acts narrates the event more than once with differing perspectives.','It changes the figure from persecutor to missionary.','c. 33–36 CE'),
('paul-arrives-rome','zh-CN','保罗抵达罗马','保罗作为受押者抵达帝国首都，并继续公开活动。','路线是长期旅程的概括，地图只绘制本样本选取的关键节点。','把耶路撒冷起源的运动连接到罗马。','约公元 60–62 年'),('paul-arrives-rome','en','Paul arrives in Rome','Paul reaches the imperial capital in custody and continues public activity.','The route is a summary of a longer journey; the map shows only selected sample waypoints.','It connects a Jerusalem-rooted movement with Rome.','c. 60–62 CE')
) AS v(slug,locale,title,summary,detail,significance,time_label) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000005';

INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary) VALUES
('41000000-0000-4000-8000-000000000001','21000000-0000-4000-8000-000000000001','traveller',0,true),('41000000-0000-4000-8000-000000000001','21000000-0000-4000-8000-000000000002','traveller',1,true),
('41000000-0000-4000-8000-000000000002','21000000-0000-4000-8000-000000000002','mother',0,true),('41000000-0000-4000-8000-000000000002','21000000-0000-4000-8000-000000000003','child',1,true),('41000000-0000-4000-8000-000000000002','21000000-0000-4000-8000-000000000001','father',2,true),
('41000000-0000-4000-8000-000000000003','21000000-0000-4000-8000-000000000004','subject',0,true),('41000000-0000-4000-8000-000000000003','21000000-0000-4000-8000-000000000003','father',1,false),
('41000000-0000-4000-8000-000000000004','21000000-0000-4000-8000-000000000005','leader',0,true),('41000000-0000-4000-8000-000000000004','21000000-0000-4000-8000-000000000006','spokesperson',1,true),
('41000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000005','mediator',0,true),('41000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000006','priest',1,true),
('41000000-0000-4000-8000-000000000006','21000000-0000-4000-8000-000000000007','king',0,true),
('41000000-0000-4000-8000-000000000007','21000000-0000-4000-8000-000000000007','king',0,true),
('41000000-0000-4000-8000-000000000008','21000000-0000-4000-8000-000000000008','builder',0,true),('41000000-0000-4000-8000-000000000008','21000000-0000-4000-8000-000000000007','predecessor',1,false),
('41000000-0000-4000-8000-000000000009','21000000-0000-4000-8000-000000000009','prophet',0,true),
('41000000-0000-4000-8000-000000000010','21000000-0000-4000-8000-000000000010','mother',0,true),('41000000-0000-4000-8000-000000000010','21000000-0000-4000-8000-000000000011','child',1,true),
('41000000-0000-4000-8000-000000000011','21000000-0000-4000-8000-000000000011','teacher',0,true),('41000000-0000-4000-8000-000000000011','21000000-0000-4000-8000-000000000012','disciple',1,true),
('41000000-0000-4000-8000-000000000012','21000000-0000-4000-8000-000000000011','executed',0,true),('41000000-0000-4000-8000-000000000012','21000000-0000-4000-8000-000000000010','witness',1,true),('41000000-0000-4000-8000-000000000012','21000000-0000-4000-8000-000000000012','disciple',2,true),
('41000000-0000-4000-8000-000000000013','21000000-0000-4000-8000-000000000013','traveller',0,true),('41000000-0000-4000-8000-000000000013','21000000-0000-4000-8000-000000000011','vision figure',1,false),
('41000000-0000-4000-8000-000000000014','21000000-0000-4000-8000-000000000013','prisoner and teacher',0,true);

INSERT INTO event_locations(event_id,location_id,role,position) VALUES
('41000000-0000-4000-8000-000000000001','31000000-0000-4000-8000-000000000001','origin',0),('41000000-0000-4000-8000-000000000001','31000000-0000-4000-8000-000000000002','waypoint',1),('41000000-0000-4000-8000-000000000001','31000000-0000-4000-8000-000000000003','destination',2),
('41000000-0000-4000-8000-000000000002','31000000-0000-4000-8000-000000000003','primary',0),('41000000-0000-4000-8000-000000000003','31000000-0000-4000-8000-000000000003','primary',0),
('41000000-0000-4000-8000-000000000004','31000000-0000-4000-8000-000000000004','origin',0),('41000000-0000-4000-8000-000000000004','31000000-0000-4000-8000-000000000005','waypoint',1),
('41000000-0000-4000-8000-000000000005','31000000-0000-4000-8000-000000000005','primary',0),('41000000-0000-4000-8000-000000000006','31000000-0000-4000-8000-000000000007','origin tradition',0),('41000000-0000-4000-8000-000000000006','31000000-0000-4000-8000-000000000006','royal centre',1),
('41000000-0000-4000-8000-000000000007','31000000-0000-4000-8000-000000000006','primary',0),('41000000-0000-4000-8000-000000000008','31000000-0000-4000-8000-000000000006','primary',0),
('41000000-0000-4000-8000-000000000009','31000000-0000-4000-8000-000000000011','destination',0),('41000000-0000-4000-8000-000000000010','31000000-0000-4000-8000-000000000007','primary',0),
('41000000-0000-4000-8000-000000000011','31000000-0000-4000-8000-000000000009','region',0),('41000000-0000-4000-8000-000000000011','31000000-0000-4000-8000-000000000008','home region',1),
('41000000-0000-4000-8000-000000000012','31000000-0000-4000-8000-000000000006','primary',0),('41000000-0000-4000-8000-000000000013','31000000-0000-4000-8000-000000000010','destination',0),('41000000-0000-4000-8000-000000000014','31000000-0000-4000-8000-000000000012','destination',0);

INSERT INTO event_sources(event_id,source_id) VALUES
('41000000-0000-4000-8000-000000000001','51000000-0000-4000-8000-000000000001'),('41000000-0000-4000-8000-000000000001','51000000-0000-4000-8000-000000000009'),
('41000000-0000-4000-8000-000000000002','51000000-0000-4000-8000-000000000001'),('41000000-0000-4000-8000-000000000003','51000000-0000-4000-8000-000000000001'),
('41000000-0000-4000-8000-000000000004','51000000-0000-4000-8000-000000000002'),('41000000-0000-4000-8000-000000000004','51000000-0000-4000-8000-000000000009'),
('41000000-0000-4000-8000-000000000005','51000000-0000-4000-8000-000000000002'),('41000000-0000-4000-8000-000000000006','51000000-0000-4000-8000-000000000003'),
('41000000-0000-4000-8000-000000000007','51000000-0000-4000-8000-000000000003'),('41000000-0000-4000-8000-000000000008','51000000-0000-4000-8000-000000000004'),
('41000000-0000-4000-8000-000000000009','51000000-0000-4000-8000-000000000005'),('41000000-0000-4000-8000-000000000010','51000000-0000-4000-8000-000000000006'),('41000000-0000-4000-8000-000000000010','51000000-0000-4000-8000-000000000007'),
('41000000-0000-4000-8000-000000000011','51000000-0000-4000-8000-000000000006'),('41000000-0000-4000-8000-000000000011','51000000-0000-4000-8000-000000000007'),
('41000000-0000-4000-8000-000000000012','51000000-0000-4000-8000-000000000006'),('41000000-0000-4000-8000-000000000012','51000000-0000-4000-8000-000000000007'),
('41000000-0000-4000-8000-000000000013','51000000-0000-4000-8000-000000000008'),('41000000-0000-4000-8000-000000000014','51000000-0000-4000-8000-000000000008');

INSERT INTO routes(id,work_id,slug,layer,certainty,sort_order) VALUES
('61000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000005','patriarchal-migration','real','text_explicit',1),
('61000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000005','exodus-sample-route','real','inferred',2),
('61000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000005','paul-mission-arc','real','inferred',3);

INSERT INTO route_translations(route_id,locale,name,summary,status) VALUES
('61000000-0000-4000-8000-000000000001','zh-CN','族长迁徙路线','吾珥—哈兰—迦南的文本地点顺序；线段不代表精确古代道路。','published'),('61000000-0000-4000-8000-000000000001','en','Patriarchal migration','Ur–Harran–Canaan in textual order; segments do not claim exact ancient roads.','published'),
('61000000-0000-4000-8000-000000000002','zh-CN','出埃及样本路线','埃及区域—传统西奈地点—迦南参照点；路线高度推定。','published'),('61000000-0000-4000-8000-000000000002','en','Exodus sample route','Egypt region–traditional Sinai site–Canaan reference; the route is highly inferred.','published'),
('61000000-0000-4000-8000-000000000003','zh-CN','保罗使命弧线','以耶路撒冷、大马士革与罗马表示人物使命转变和西向扩展，不是完整行程。','published'),('61000000-0000-4000-8000-000000000003','en','Paul mission arc','Jerusalem, Damascus, and Rome summarize a changed mission and westward expansion; this is not a complete itinerary.','published');

INSERT INTO route_waypoints(route_id,location_id,position,event_id) VALUES
('61000000-0000-4000-8000-000000000001','31000000-0000-4000-8000-000000000001',0,'41000000-0000-4000-8000-000000000001'),('61000000-0000-4000-8000-000000000001','31000000-0000-4000-8000-000000000002',1,'41000000-0000-4000-8000-000000000001'),('61000000-0000-4000-8000-000000000001','31000000-0000-4000-8000-000000000003',2,'41000000-0000-4000-8000-000000000001'),
('61000000-0000-4000-8000-000000000002','31000000-0000-4000-8000-000000000004',0,'41000000-0000-4000-8000-000000000004'),('61000000-0000-4000-8000-000000000002','31000000-0000-4000-8000-000000000005',1,'41000000-0000-4000-8000-000000000005'),('61000000-0000-4000-8000-000000000002','31000000-0000-4000-8000-000000000003',2,NULL),
('61000000-0000-4000-8000-000000000003','31000000-0000-4000-8000-000000000006',0,NULL),('61000000-0000-4000-8000-000000000003','31000000-0000-4000-8000-000000000010',1,'41000000-0000-4000-8000-000000000013'),('61000000-0000-4000-8000-000000000003','31000000-0000-4000-8000-000000000012',2,'41000000-0000-4000-8000-000000000014');

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id) VALUES
('71000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000001','21000000-0000-4000-8000-000000000002','romantic','bidirectional','positive',5,'active',NULL,NULL),
('71000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000001','21000000-0000-4000-8000-000000000003','family','source_to_target','positive',5,'active','41000000-0000-4000-8000-000000000002',NULL),
('71000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000002','21000000-0000-4000-8000-000000000003','family','source_to_target','positive',5,'active','41000000-0000-4000-8000-000000000002',NULL),
('71000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000003','21000000-0000-4000-8000-000000000004','family','source_to_target','mixed',4,'active',NULL,NULL),
('71000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000001','21000000-0000-4000-8000-000000000004','family','source_to_target','positive',3,'active',NULL,NULL),
('71000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000006','family','bidirectional','positive',5,'active',NULL,NULL),
('71000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000006','ally','bidirectional','positive',5,'active','41000000-0000-4000-8000-000000000004',NULL),
('71000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000007','21000000-0000-4000-8000-000000000008','family','source_to_target','positive',5,'active',NULL,NULL),
('71000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000007','21000000-0000-4000-8000-000000000008','mentor','source_to_target','mixed',4,'ended','41000000-0000-4000-8000-000000000006','41000000-0000-4000-8000-000000000008'),
('71000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000010','21000000-0000-4000-8000-000000000011','family','source_to_target','positive',5,'active','41000000-0000-4000-8000-000000000010',NULL),
('71000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000011','21000000-0000-4000-8000-000000000012','mentor','source_to_target','positive',5,'changed','41000000-0000-4000-8000-000000000011','41000000-0000-4000-8000-000000000012'),
('71000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000011','21000000-0000-4000-8000-000000000012','ally','bidirectional','mixed',4,'changed','41000000-0000-4000-8000-000000000011','41000000-0000-4000-8000-000000000012'),
('71000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000011','21000000-0000-4000-8000-000000000013','mentor','source_to_target','positive',5,'active','41000000-0000-4000-8000-000000000013',NULL),
('71000000-0000-4000-8000-000000000014','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000012','21000000-0000-4000-8000-000000000013','ally','bidirectional','mixed',3,'changed','41000000-0000-4000-8000-000000000013',NULL),
('71000000-0000-4000-8000-000000000015','10000000-0000-4000-8000-000000000005','21000000-0000-4000-8000-000000000009','21000000-0000-4000-8000-000000000011','other','source_to_target','neutral',2,'unknown',NULL,NULL);

INSERT INTO relation_translations(relation_id,locale,label,status,summary)
SELECT r.id,v.locale::locale_code,v.label,'published',v.summary FROM character_relations r JOIN (VALUES
('71000000-0000-4000-8000-000000000001','zh-CN','夫妻','共同迁徙并面对家族延续问题。'),('71000000-0000-4000-8000-000000000001','en','Spouses','They migrate together and face questions of family continuity.'),
('71000000-0000-4000-8000-000000000002','zh-CN','父子','以撒出生后关系开始。'),('71000000-0000-4000-8000-000000000002','en','Father and son','The relationship begins with Isaac’s birth.'),
('71000000-0000-4000-8000-000000000003','zh-CN','母子','撒拉与以撒的母子关系。'),('71000000-0000-4000-8000-000000000003','en','Mother and son','The parent-child relationship of Sarah and Isaac.'),
('71000000-0000-4000-8000-000000000004','zh-CN','父子','祝福与继承冲突使关系带有复杂性。'),('71000000-0000-4000-8000-000000000004','en','Father and son','Blessing and inheritance conflict make the relationship complex.'),
('71000000-0000-4000-8000-000000000005','zh-CN','祖孙','连接亚伯拉罕与雅各两代传统。'),('71000000-0000-4000-8000-000000000005','en','Grandfather and grandson','Links the Abraham and Jacob generations.'),
('71000000-0000-4000-8000-000000000006','zh-CN','兄弟','摩西与亚伦的家族关系。'),('71000000-0000-4000-8000-000000000006','en','Brothers','The family relationship of Moses and Aaron.'),
('71000000-0000-4000-8000-000000000007','zh-CN','共同领导','两人在出埃及阶段分担领导与发言。'),('71000000-0000-4000-8000-000000000007','en','Co-leaders','They share leadership and speaking roles during the Exodus phase.'),
('71000000-0000-4000-8000-000000000008','zh-CN','父子','所罗门继承大卫王朝。'),('71000000-0000-4000-8000-000000000008','en','Father and son','Solomon succeeds within David’s dynasty.'),
('71000000-0000-4000-8000-000000000009','zh-CN','王权继承指导','关系从大卫在位延续到所罗门建立自身统治。'),('71000000-0000-4000-8000-000000000009','en','Royal succession guidance','The relationship spans David’s reign and Solomon’s establishment of rule.'),
('71000000-0000-4000-8000-000000000010','zh-CN','母子','从诞生叙事开始并贯穿福音书。'),('71000000-0000-4000-8000-000000000010','en','Mother and son','Begins in the birth narrative and continues through the Gospels.'),
('71000000-0000-4000-8000-000000000011','zh-CN','师徒','关系在加利利建立，并在受难事件后改变。'),('71000000-0000-4000-8000-000000000011','en','Teacher and disciple','Established in Galilee and changed after the crucifixion event.'),
('71000000-0000-4000-8000-000000000012','zh-CN','同伴与代表','彼得从同行者转向群体代表，关系包含支持与失败。'),('71000000-0000-4000-8000-000000000012','en','Companion and representative','Peter moves from companion to community representative amid support and failure.'),
('71000000-0000-4000-8000-000000000013','zh-CN','异象中的导师关系','保罗的转变叙事把耶稣作为其新使命来源。'),('71000000-0000-4000-8000-000000000013','en','Vision-mediated teacher relation','Paul’s conversion narrative presents Jesus as the source of a new mission.'),
('71000000-0000-4000-8000-000000000014','zh-CN','使徒同工与争议','两人参与同一运动，也在实践问题上出现分歧。'),('71000000-0000-4000-8000-000000000014','en','Apostolic allies with dispute','They work in the same movement and also disagree over practice.'),
('71000000-0000-4000-8000-000000000015','zh-CN','叙事参照','福音书以约拿叙事作为教导参照，不表示两人现实相识。'),('71000000-0000-4000-8000-000000000015','en','Narrative reference','The Gospels use Jonah as a teaching reference; this does not imply a personal meeting.')
) AS v(id,locale,label,summary) ON r.id=v.id::uuid;

INSERT INTO character_locations(character_id,location_id,first_event_id,last_event_id,is_primary) VALUES
('21000000-0000-4000-8000-000000000001','31000000-0000-4000-8000-000000000001','41000000-0000-4000-8000-000000000001','41000000-0000-4000-8000-000000000001',true),('21000000-0000-4000-8000-000000000001','31000000-0000-4000-8000-000000000003','41000000-0000-4000-8000-000000000001','41000000-0000-4000-8000-000000000002',false),
('21000000-0000-4000-8000-000000000002','31000000-0000-4000-8000-000000000003','41000000-0000-4000-8000-000000000001','41000000-0000-4000-8000-000000000002',true),('21000000-0000-4000-8000-000000000003','31000000-0000-4000-8000-000000000003','41000000-0000-4000-8000-000000000002','41000000-0000-4000-8000-000000000003',true),('21000000-0000-4000-8000-000000000004','31000000-0000-4000-8000-000000000003','41000000-0000-4000-8000-000000000003','41000000-0000-4000-8000-000000000003',true),
('21000000-0000-4000-8000-000000000005','31000000-0000-4000-8000-000000000004','41000000-0000-4000-8000-000000000004','41000000-0000-4000-8000-000000000004',true),('21000000-0000-4000-8000-000000000005','31000000-0000-4000-8000-000000000005','41000000-0000-4000-8000-000000000005','41000000-0000-4000-8000-000000000005',false),
('21000000-0000-4000-8000-000000000006','31000000-0000-4000-8000-000000000004','41000000-0000-4000-8000-000000000004','41000000-0000-4000-8000-000000000004',true),('21000000-0000-4000-8000-000000000007','31000000-0000-4000-8000-000000000006','41000000-0000-4000-8000-000000000006','41000000-0000-4000-8000-000000000007',true),('21000000-0000-4000-8000-000000000008','31000000-0000-4000-8000-000000000006','41000000-0000-4000-8000-000000000008','41000000-0000-4000-8000-000000000008',true),('21000000-0000-4000-8000-000000000009','31000000-0000-4000-8000-000000000011','41000000-0000-4000-8000-000000000009','41000000-0000-4000-8000-000000000009',true),
('21000000-0000-4000-8000-000000000010','31000000-0000-4000-8000-000000000007','41000000-0000-4000-8000-000000000010','41000000-0000-4000-8000-000000000012',true),('21000000-0000-4000-8000-000000000011','31000000-0000-4000-8000-000000000009','41000000-0000-4000-8000-000000000011','41000000-0000-4000-8000-000000000011',true),('21000000-0000-4000-8000-000000000011','31000000-0000-4000-8000-000000000006','41000000-0000-4000-8000-000000000012','41000000-0000-4000-8000-000000000012',false),('21000000-0000-4000-8000-000000000012','31000000-0000-4000-8000-000000000009','41000000-0000-4000-8000-000000000011','41000000-0000-4000-8000-000000000012',true),('21000000-0000-4000-8000-000000000013','31000000-0000-4000-8000-000000000010','41000000-0000-4000-8000-000000000013','41000000-0000-4000-8000-000000000013',true),('21000000-0000-4000-8000-000000000013','31000000-0000-4000-8000-000000000012','41000000-0000-4000-8000-000000000014','41000000-0000-4000-8000-000000000014',false);

INSERT INTO character_sources(character_id,source_id)
SELECT c.id,s.id FROM characters c JOIN sources s ON s.work_id=c.work_id WHERE c.work_id='10000000-0000-4000-8000-000000000005' AND (
  (c.slug IN ('abraham','sarah','isaac','jacob') AND s.title='Genesis') OR
  (c.slug IN ('moses','aaron') AND s.title='Exodus') OR
  (c.slug='david' AND s.title='Samuel') OR
  (c.slug='solomon' AND s.title='Kings') OR
  (c.slug='jonah' AND s.title='Jonah') OR
  (c.slug IN ('mary','jesus','peter') AND s.title IN ('Gospel according to Matthew','Gospel according to Luke')) OR
  (c.slug IN ('peter','paul') AND s.title='Acts of the Apostles'));

INSERT INTO relation_sources(relation_id,source_id)
SELECT r.id,s.id FROM character_relations r JOIN sources s ON s.work_id=r.work_id WHERE r.work_id='10000000-0000-4000-8000-000000000005' AND (
  (r.id BETWEEN '71000000-0000-4000-8000-000000000001' AND '71000000-0000-4000-8000-000000000005' AND s.title='Genesis') OR
  (r.id IN ('71000000-0000-4000-8000-000000000006','71000000-0000-4000-8000-000000000007') AND s.title='Exodus') OR
  (r.id IN ('71000000-0000-4000-8000-000000000008','71000000-0000-4000-8000-000000000009') AND s.title IN ('Samuel','Kings')) OR
  (r.id IN ('71000000-0000-4000-8000-000000000010','71000000-0000-4000-8000-000000000011','71000000-0000-4000-8000-000000000012','71000000-0000-4000-8000-000000000015') AND s.title IN ('Gospel according to Matthew','Gospel according to Luke')) OR
  (r.id IN ('71000000-0000-4000-8000-000000000013','71000000-0000-4000-8000-000000000014') AND s.title='Acts of the Apostles'));

INSERT INTO work_chronologies(id,work_id,kind,label,start_year,end_year,calendar_system,is_default) VALUES
('91000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000005','historical','Representative Bible chronology',-2100,62,'unknown',true),
('91000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000005','narrative','Canonical sample order',NULL,NULL,'unknown',false);

INSERT INTO seed_history(version) VALUES ('002_bible_v3_1');
COMMIT;
