BEGIN;

-- =========================================================================
-- 013_bible_full_04_wilderness-and-conquest.sql
-- Chapter K=04 slug='wilderness-and-conquest' (Numbers, Deuteronomy, Joshua)
-- Adds 11 characters, 16 locations, 25 new events, 10 relations, and
-- reorders the eight pre-existing events into the 4001-4999 sequence band.
-- Era range: c. 1250-1150 BCE.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('43000000-0000-4000-8004-000000000001','10000000-0000-4000-8000-000000000005','korah',400,'male','adult','antagonist','unknown',NULL,NULL,'priest',2),
('43000000-0000-4000-8004-000000000002','10000000-0000-4000-8000-000000000005','dathan',401,'male','adult','antagonist','unknown',NULL,NULL,'person',1),
('43000000-0000-4000-8004-000000000003','10000000-0000-4000-8000-000000000005','abiram',402,'male','adult','antagonist','unknown',NULL,NULL,'person',1),
('43000000-0000-4000-8004-000000000004','10000000-0000-4000-8000-000000000005','balaam',403,'male','adult','supporting','unknown',NULL,NULL,'prophet',3),
('43000000-0000-4000-8004-000000000005','10000000-0000-4000-8000-000000000005','balak',404,'male','adult','antagonist','unknown',NULL,NULL,'king',2),
('43000000-0000-4000-8004-000000000006','10000000-0000-4000-8000-000000000005','phinehas-son-of-eleazar',405,'male','adult','supporting','unknown',NULL,NULL,'priest',2),
('43000000-0000-4000-8004-000000000007','10000000-0000-4000-8000-000000000005','og-king-of-bashan',406,'male','adult','antagonist','unknown',NULL,NULL,'king',1),
('43000000-0000-4000-8004-000000000008','10000000-0000-4000-8000-000000000005','sihon',407,'male','adult','antagonist','unknown',NULL,NULL,'king',1),
('43000000-0000-4000-8004-000000000009','10000000-0000-4000-8000-000000000005','achan',408,'male','adult','antagonist','unknown',NULL,NULL,'person',1),
('43000000-0000-4000-8004-000000000010','10000000-0000-4000-8000-000000000005','adoni-zedek',409,'male','adult','antagonist','unknown',NULL,NULL,'king',1),
('43000000-0000-4000-8004-000000000011','10000000-0000-4000-8000-000000000005','jabin-of-hazor',410,'male','adult','antagonist','unknown',NULL,NULL,'king',1)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('korah','zh-CN','可拉','利未人哥辖的子孙，带领二百五十位首领起来反对摩西与亚伦。',ARRAY[]::text[],'他联合流便支派的大坍、亚比兰，质疑摩西与亚伦独揽圣职；在香炉试验中，叛党被地开口与烈火所灭。','争取与亚伦同等的祭司职分。'),
('korah','en','Korah','A Levite of the line of Kohath who led 250 leaders against Moses and Aaron.',ARRAY[]::text[],'Allied with Dathan and Abiram of Reuben, he disputed the exclusive priesthood of Aaron; in the test of censers the rebels perish by opened earth and by fire.','To claim priestly standing equal to Aaron’s.'),
('dathan','zh-CN','大坍','流便支派以利押之子，与兄弟亚比兰一同抗拒摩西。',ARRAY[]::text[],'他拒绝应召上前，讥讽摩西领百姓出了流奶与蜜之地却未领他们进入应许之地，后与全家一同被地吞灭。','不满摩西的领导权柄。'),
('dathan','en','Dathan','A Reubenite, son of Eliab, who defied Moses together with his brother Abiram.',ARRAY[]::text[],'He refuses Moses’ summons, mocking him for leading the people out of a land of milk and honey without bringing them into the promised one, and is swallowed by the earth with his household.','Resentment of Moses’ authority.'),
('abiram','zh-CN','亚比兰','流便支派以利押之子，大坍的兄弟，同谋抗拒摩西。',ARRAY[]::text[],'他与大坍一同站在帐棚门口对抗摩西，最终帐棚连同全家被裂开的地吞灭。','不满摩西的领导权柄。'),
('abiram','en','Abiram','A Reubenite, son of Eliab and brother of Dathan, co-conspirator against Moses.',ARRAY[]::text[],'He stands with Dathan at the door of his tent in defiance, and the ground splits and swallows him with his household.','Resentment of Moses’ authority.'),
('balaam','zh-CN','巴兰','幼发拉底河畔毗夺的占卜先知，受巴勒重金之邀去咒诅以色列，口中却只能发出祝福。',ARRAY[]::text[],'途中他的驴看见持刀的天使而三次躲避，甚至开口说话；他三次开口皆成祝福，末了预言有星要出于雅各。他后来在米甸之战中被杀。','在酬金与所领受的神谕之间摇摆。'),
('balaam','en','Balaam','A diviner from Pethor by the Euphrates, hired by Balak to curse Israel yet able only to bless.',ARRAY[]::text[],'On the road his donkey sees a sword-bearing angel, shies three times, and finally speaks; his three oracles all become blessings, and his last foretells a star rising out of Jacob. He is later killed in the war against Midian.','Torn between reward money and the word given to him.'),
('balak','zh-CN','巴勒','摩押王西拨之子，因惧怕以色列的人数而重金聘请巴兰咒诅他们。',ARRAY[]::text[],'他三次领巴兰登上不同的高处筑坛献祭，盼望换来咒诅，却三次听见祝福，最终怒而遣走巴兰。','借咒诅之力保全摩押。'),
('balak','en','Balak','King of Moab, son of Zippor, who hires Balaam to curse Israel out of fear of their numbers.',ARRAY[]::text[],'Three times he leads Balaam to a different height to build altars and sacrifice, hoping for a curse, and three times hears a blessing, finally dismissing the seer in anger.','To protect Moab by the power of a curse.'),
('phinehas-son-of-eleazar','zh-CN','非尼哈（以利亚撒之子）','祭司以利亚撒之子、亚伦之孙，在巴力毗珥事件中以枪止息了瘟疫。',ARRAY[]::text[],'他因忌邪的心蒙应许得平安之约与永远的祭司职任；后来又代表以色列各支派，质询约旦河东支派所筑的大坛。','为圣所与百姓的忠贞发热心。'),
('phinehas-son-of-eleazar','en','Phinehas (son of Eleazar)','Son of the priest Eleazar and grandson of Aaron, who halted the plague at Baal-peor with a spear.',ARRAY[]::text[],'For his zeal he receives the promise of a covenant of peace and a lasting priesthood; later he leads the delegation questioning the great altar built by the eastern tribes.','Zeal for the sanctuary and the people’s faithfulness.'),
('og-king-of-bashan','zh-CN','巴珊王噩','巴珊的王，在以得来迎战以色列而败亡，以巨大的铁床闻名。',ARRAY[]::text[],'他是利乏音人余剩的最后一位，率全军在以得来出战，兵败身亡，其地分给玛拿西半支派。','保住巴珊全境的统治。'),
('og-king-of-bashan','en','Og king of Bashan','King of Bashan, defeated by Israel at Edrei and remembered for his huge iron bed.',ARRAY[]::text[],'Called the last of the remnant of the Rephaim, he marches out with all his people at Edrei, falls in battle, and his land passes to the half-tribe of Manasseh.','To hold his rule over all Bashan.'),
('sihon','zh-CN','西宏','希实本的亚摩利王，拒绝以色列借道，出兵迎战而在雅杂败亡。',ARRAY[]::text[],'他不容以色列从大道经过，反倒聚众出到旷野，在雅杂被击败，从亚嫩河到雅博河之地尽归以色列。','守住亚摩利人的疆界。'),
('sihon','en','Sihon','The Amorite king of Heshbon who refused Israel passage and fell in battle at Jahaz.',ARRAY[]::text[],'Refusing to let Israel pass along the highway, he musters his forces into the wilderness and is defeated at Jahaz; his land from the Arnon to the Jabbok falls to Israel.','To guard the Amorite frontier.'),
('achan','zh-CN','亚干','犹大支派人，在耶利哥私藏当灭之物，连累以色列在艾城战败。',ARRAY[]::text[],'他取了示拿衣服、银子和金条藏在帐棚地里；掣签被查出后承认罪行，与家眷一同在亚割谷被处死。','对战利品的贪念。'),
('achan','en','Achan','A man of Judah who hid devoted spoil from Jericho, bringing defeat on Israel at Ai.',ARRAY[]::text[],'He takes a Shinar robe, silver, and a bar of gold and buries them in his tent; identified by lot, he confesses and is executed with his household in the valley of Achor.','Covetous desire for the spoil.'),
('adoni-zedek','zh-CN','亚多尼洗德','耶路撒冷王，联合五王攻打基遍，兵败后藏身玛基大洞中被处死。',ARRAY[]::text[],'他听闻艾城陷落、基遍求和，便召集希伯仑、耶末、拉吉、伊矶伦四王同攻基遍，战败后五王在玛基大的洞里被擒。','扑灭基遍倒向以色列的先例。'),
('adoni-zedek','en','Adoni-zedek','King of Jerusalem who led five kings against Gibeon and was executed after hiding in the cave at Makkedah.',ARRAY[]::text[],'Alarmed by the fall of Ai and Gibeon’s treaty, he summons the kings of Hebron, Jarmuth, Lachish, and Eglon against Gibeon; defeated, the five kings are taken from the cave at Makkedah.','To crush the precedent of Gibeon’s defection.'),
('jabin-of-hazor','zh-CN','夏琐王耶宾','北方大城夏琐的王，召聚北方诸王在米伦水边迎战约书亚。',ARRAY[]::text[],'他集结北方山地、亚拉巴与沿海诸王，人马多如海边的沙；联军在米伦水边被击溃，夏琐城被攻取焚毁。','联合北方诸城抵御以色列。'),
('jabin-of-hazor','en','Jabin of Hazor','King of the great northern city of Hazor, who gathered the northern kings against Joshua at the waters of Merom.',ARRAY[]::text[],'He assembles the kings of the northern hill country, the Arabah, and the coast, a host like the sand of the sea; the coalition is routed at Merom and Hazor itself is taken and burned.','To unite the northern cities against Israel.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. LOCATIONS (reuse mount-sinai-traditional, kadesh-barnea, mount-nebo,
--    jericho, shiloh, hebron, lachish, canaan-shechem; 16 new sites)
-- -------------------------------------------------------------------------
INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('33000000-0000-4000-8004-000000000001','10000000-0000-4000-8000-000000000005','kibroth-hattaavah-reference','real',ST_GeogFromText('POINT(34.6300 29.0000)'),NULL,NULL,400,'route_node','inferred',7,'EG',true,false),
('33000000-0000-4000-8004-000000000002','10000000-0000-4000-8000-000000000005','hazeroth-reference','real',ST_GeogFromText('POINT(34.3500 28.9100)'),NULL,NULL,401,'route_node','inferred',7,'EG',true,false),
('33000000-0000-4000-8004-000000000003','10000000-0000-4000-8000-000000000005','arad','real',ST_GeogFromText('POINT(35.1261 31.2803)'),NULL,NULL,402,'city','approximate',9,'IL',false,false),
('33000000-0000-4000-8004-000000000004','10000000-0000-4000-8000-000000000005','heshbon','real',ST_GeogFromText('POINT(35.8094 31.7997)'),NULL,NULL,403,'city','approximate',9,'JO',false,false),
('33000000-0000-4000-8004-000000000005','10000000-0000-4000-8000-000000000005','edrei-bashan','real',ST_GeogFromText('POINT(36.1050 32.6180)'),NULL,NULL,404,'city','approximate',9,'SY',false,true),
('33000000-0000-4000-8004-000000000006','10000000-0000-4000-8000-000000000005','plains-of-moab','real',ST_GeogFromText('POINT(35.6300 31.8200)'),NULL,NULL,405,'region','approximate',9,'JO',false,true),
('33000000-0000-4000-8004-000000000007','10000000-0000-4000-8000-000000000005','punon-reference','real',ST_GeogFromText('POINT(35.4900 30.6300)'),NULL,NULL,406,'route_node','inferred',8,'JO',true,false),
('33000000-0000-4000-8004-000000000008','10000000-0000-4000-8000-000000000005','gilgal-reference','real',ST_GeogFromText('POINT(35.4900 31.8700)'),NULL,NULL,407,'religious_site','inferred',9,'PS',true,false),
('33000000-0000-4000-8004-000000000009','10000000-0000-4000-8000-000000000005','ai-reference','real',ST_GeogFromText('POINT(35.2610 31.9170)'),NULL,NULL,408,'city','inferred',9,'PS',true,false),
('33000000-0000-4000-8004-000000000010','10000000-0000-4000-8000-000000000005','mount-ebal','real',ST_GeogFromText('POINT(35.2734 32.2340)'),NULL,NULL,409,'landmark','approximate',10,'PS',false,true),
('33000000-0000-4000-8004-000000000011','10000000-0000-4000-8000-000000000005','gibeon','real',ST_GeogFromText('POINT(35.1850 31.8470)'),NULL,NULL,410,'city','approximate',10,'PS',false,false),
('33000000-0000-4000-8004-000000000012','10000000-0000-4000-8000-000000000005','makkedah-reference','real',ST_GeogFromText('POINT(34.9300 31.5800)'),NULL,NULL,411,'city','inferred',9,'IL',true,false),
('33000000-0000-4000-8004-000000000013','10000000-0000-4000-8000-000000000005','waters-of-merom-reference','real',ST_GeogFromText('POINT(35.4400 32.9800)'),NULL,NULL,412,'battlefield','inferred',9,'IL',true,false),
('33000000-0000-4000-8004-000000000014','10000000-0000-4000-8000-000000000005','hazor','real',ST_GeogFromText('POINT(35.5683 33.0175)'),NULL,NULL,413,'city','approximate',9,'IL',false,false),
('33000000-0000-4000-8004-000000000015','10000000-0000-4000-8000-000000000005','timnath-serah-reference','real',ST_GeogFromText('POINT(35.1000 32.0300)'),NULL,NULL,414,'city','inferred',9,'PS',true,false),
('33000000-0000-4000-8004-000000000016','10000000-0000-4000-8000-000000000005','valley-of-achor-reference','real',ST_GeogFromText('POINT(35.4200 31.8300)'),NULL,NULL,415,'landmark','inferred',9,'PS',true,false)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,status,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',ARRAY[]::text[],'','','','',v.region FROM locations l JOIN (VALUES
('kibroth-hattaavah-reference','zh-CN','基博罗哈他瓦（推定位置）','旷野行程中埋葬贪欲之人的营站，因鹌鹑之灾得名，位置仅能推定。','西奈旷野'),
('kibroth-hattaavah-reference','en','Kibroth-hattaavah (traditional site)','The wilderness camp named “graves of craving” after the quail plague; its site can only be inferred.','Wilderness of Sinai'),
('hazeroth-reference','zh-CN','哈洗录（推定位置）','旷野行程中的营站，米利暗与亚伦在此攻击摩西。','西奈旷野'),
('hazeroth-reference','en','Hazeroth (traditional site)','A wilderness station where Miriam and Aaron spoke against Moses.','Wilderness of Sinai'),
('arad','zh-CN','亚拉得','尼革夫地区的迦南城邑，其王曾在旷野末期攻击以色列。','尼革夫'),
('arad','en','Arad','A Canaanite town of the Negev whose king attacked Israel near the end of the wilderness years.','Negev'),
('heshbon','zh-CN','希实本','亚摩利王西宏的都城，后归流便支派。','外约旦'),
('heshbon','en','Heshbon','The capital of the Amorite king Sihon, later assigned to Reuben.','Transjordan'),
('edrei-bashan','zh-CN','以得来','巴珊王噩迎战以色列之地，位于今叙利亚德拉一带。','巴珊'),
('edrei-bashan','en','Edrei','The place in Bashan where King Og met Israel in battle, near modern Daraa.','Bashan'),
('plains-of-moab','zh-CN','摩押平原','约旦河东与耶利哥相对的平原，以色列进迦南前最后的营地。','摩押'),
('plains-of-moab','en','Plains of Moab','The plains east of the Jordan opposite Jericho, Israel’s last camp before entering Canaan.','Moab'),
('punon-reference','zh-CN','普嫩（推定位置）','绕行以东途中的营站，传统上与铜蛇事件相联系，邻近古铜矿区。','以东'),
('punon-reference','en','Punon (traditional site)','A station on the detour around Edom, traditionally linked to the bronze serpent and near ancient copper mines.','Edom'),
('gilgal-reference','zh-CN','吉甲（推定位置）','以色列过约旦河后的第一个营地与圣所，十二块石头立于此。','约旦河谷'),
('gilgal-reference','en','Gilgal (traditional site)','Israel’s first camp and shrine west of the Jordan, where the twelve stones were set up.','Jordan Valley'),
('ai-reference','zh-CN','艾城（推定位置）','伯特利以东的城邑，以色列在此先败后胜，通常与今艾特拉遗址相联系。','迦南中部山地'),
('ai-reference','en','Ai (traditional site)','A town east of Bethel where Israel was first repulsed and then victorious, commonly identified with et-Tell.','Central hill country'),
('mount-ebal','zh-CN','以巴路山','示剑北侧的山，约书亚在此筑坛并宣读律法的咒诅。','撒玛利亚山地'),
('mount-ebal','en','Mount Ebal','The mountain north of Shechem where Joshua built an altar and the curses of the law were read.','Samaria highlands'),
('gibeon','zh-CN','基遍','以诡计与以色列立约的希未人大城，日头停留之战因它而起。','便雅悯山地'),
('gibeon','en','Gibeon','The great Hivite city that gained a treaty by ruse, and over which the sun stood still.','Hill country of Benjamin'),
('makkedah-reference','zh-CN','玛基大（推定位置）','南方战役中五王藏身洞穴被擒之地。','示非拉低地'),
('makkedah-reference','en','Makkedah (traditional site)','Where the five kings were taken from the cave in the southern campaign.','Shephelah'),
('waters-of-merom-reference','zh-CN','米伦水（推定位置）','约书亚突袭北方联军之地，位于上加利利。','上加利利'),
('waters-of-merom-reference','en','Waters of Merom (traditional site)','Where Joshua fell suddenly on the northern coalition, in Upper Galilee.','Upper Galilee'),
('hazor','zh-CN','夏琐','北方最大的迦南王城，耶宾的都城，战后被焚毁。','上加利利'),
('hazor','en','Hazor','The greatest Canaanite royal city of the north, seat of Jabin, burned after the battle.','Upper Galilee'),
('timnath-serah-reference','zh-CN','亭拿西拉（推定位置）','约书亚在以法莲山地所得的产业与安葬之地。','以法莲山地'),
('timnath-serah-reference','en','Timnath-serah (traditional site)','Joshua’s inheritance and burial place in the hill country of Ephraim.','Hill country of Ephraim'),
('valley-of-achor-reference','zh-CN','亚割谷（推定位置）','亚干与其家眷被处死之谷，名意为“连累”。','约旦河谷'),
('valley-of-achor-reference','en','Valley of Achor (traditional site)','The valley of “trouble” where Achan and his household were executed.','Jordan Valley')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug AND l.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 3. EVENTS (25 new) -- range dates within c. 1250-1150 BCE,
--    chapter 'wilderness-and-conquest'
-- -------------------------------------------------------------------------
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('63000000-0000-4000-8004-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'unknown'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'departure-from-sinai',4001,'reported_historical','journey','range',-1250::integer,-1220::integer,'low','wilderness-and-conquest'),
(2,'quail-and-plague-at-kibroth-hattaavah',4003,'legendary_or_mythic','other','range',-1248,-1218,'low','wilderness-and-conquest'),
(3,'miriam-struck-with-leprosy',4005,'legendary_or_mythic','other','range',-1246,-1216,'low','wilderness-and-conquest'),
(4,'forty-years-of-wandering-decreed',4009,'legendary_or_mythic','religious','range',-1245,-1210,'low','wilderness-and-conquest'),
(5,'rebellion-of-korah',4011,'reported_historical','political','range',-1243,-1210,'low','wilderness-and-conquest'),
(6,'earth-swallows-dathan-and-abiram',4013,'legendary_or_mythic','death','range',-1243,-1210,'low','wilderness-and-conquest'),
(7,'aarons-staff-buds',4015,'legendary_or_mythic','religious','range',-1242,-1208,'low','wilderness-and-conquest'),
(8,'water-from-the-rock-at-meribah',4019,'legendary_or_mythic','religious','range',-1240,-1205,'low','wilderness-and-conquest'),
(9,'bronze-serpent-lifted-up',4023,'legendary_or_mythic','religious','range',-1235,-1202,'low','wilderness-and-conquest'),
(10,'defeat-of-sihon',4025,'reported_historical','battle','range',-1232,-1200,'low','wilderness-and-conquest'),
(11,'defeat-of-og-at-edrei',4027,'reported_historical','battle','range',-1231,-1199,'low','wilderness-and-conquest'),
(12,'balaams-donkey-speaks',4029,'legendary_or_mythic','other','range',-1230,-1198,'low','wilderness-and-conquest'),
(13,'balaam-blesses-israel-three-times',4031,'legendary_or_mythic','religious','range',-1230,-1198,'low','wilderness-and-conquest'),
(14,'phinehas-stays-the-plague',4033,'reported_historical','religious','range',-1228,-1196,'low','wilderness-and-conquest'),
(15,'joshua-commissioned-as-successor',4035,'reported_historical','political','range',-1227,-1195,'low','wilderness-and-conquest'),
(16,'death-of-moses',4039,'reported_historical','death','range',-1225,-1195,'low','wilderness-and-conquest'),
(17,'memorial-stones-at-gilgal',4045,'reported_historical','religious','range',-1222,-1192,'low','wilderness-and-conquest'),
(18,'sin-of-achan',4049,'reported_historical','betrayal','range',-1220,-1190,'low','wilderness-and-conquest'),
(19,'israel-defeated-at-ai',4051,'reported_historical','battle','range',-1220,-1190,'low','wilderness-and-conquest'),
(20,'ambush-and-capture-of-ai',4053,'reported_historical','battle','range',-1219,-1189,'low','wilderness-and-conquest'),
(21,'gibeonite-deception',4055,'reported_historical','betrayal','range',-1218,-1185,'low','wilderness-and-conquest'),
(22,'sun-stands-still-over-gibeon',4057,'legendary_or_mythic','other','range',-1216,-1183,'low','wilderness-and-conquest'),
(23,'northern-kings-defeated-at-merom',4059,'contested','battle','range',-1214,-1180,'low','wilderness-and-conquest'),
(24,'covenant-at-shechem',4063,'reported_historical','religious','range',-1200,-1160,'low','wilderness-and-conquest'),
(25,'death-of-joshua',4065,'reported_historical','death','range',-1195,-1150,'low','wilderness-and-conquest')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,conf,chapter_slug)
JOIN chapters ch ON ch.slug=v.chapter_slug AND ch.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 4. Reorder existing wilderness-and-conquest events into the 4001-4999 band
-- -------------------------------------------------------------------------
UPDATE events e SET sequence=v.seq FROM (VALUES
  ('scouts-sent-from-kadesh',4007),
  ('long-stay-at-kadesh',4017),
  ('death-of-aaron',4021),
  ('moses-views-canaan-from-nebo',4037),
  ('scouts-sheltered-by-rahab',4041),
  ('crossing-the-jordan',4043),
  ('fall-of-jericho',4047),
  ('shrine-set-up-at-shiloh',4061)
) AS v(slug,seq) WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug=v.slug;

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('departure-from-sinai','zh-CN','从西奈起行','云彩从法柜的帐幕收上去，以色列人按队伍从西奈旷野起行。','在西奈山下驻扎近一年、领受律法之后，百姓随云彩的引导向应许之地进发。','旷野漂流叙事的正式开端。','约公元前 1250–1220 年'),
('departure-from-sinai','en','Departure from Sinai','The cloud lifts from the tabernacle and Israel sets out from the wilderness of Sinai in ordered companies.','After nearly a year encamped at the mountain receiving the law, the people move off behind the guiding cloud toward the promised land.','The formal opening of the wilderness journey narrative.','c. 1250–1220 BCE'),
('quail-and-plague-at-kibroth-hattaavah','zh-CN','基博罗哈他瓦的鹌鹑之灾','百姓贪恋肉食，风送来鹌鹑，随后瘟疫击杀起贪欲之心的人。','哭号要肉的百姓得着遍地的鹌鹑，肉还在牙缝间瘟疫就发作；死者葬于该地，营地因此得名“贪欲之人的坟墓”。','旷野中怨言与管教主题的代表事件。','约公元前 1248–1218 年'),
('quail-and-plague-at-kibroth-hattaavah','en','The quail and plague at Kibroth-hattaavah','Craving meat, the people receive quail on the wind, and a plague strikes those who craved.','With the meat still between their teeth the plague breaks out; the dead are buried there, giving the camp its name, “graves of craving.”','A defining episode of complaint and discipline in the wilderness.','c. 1248–1218 BCE'),
('miriam-struck-with-leprosy','zh-CN','米利暗患麻风','米利暗与亚伦因古实女子的事攻击摩西，米利暗随即长了大麻风。','二人质问耶和华岂是单与摩西说话；云彩离开会幕后米利暗患了麻风，经摩西代求，被关锁营外七天后痊愈归回。','确立摩西在众先知中独特地位的叙事。','约公元前 1246–1216 年'),
('miriam-struck-with-leprosy','en','Miriam struck with leprosy','Miriam and Aaron speak against Moses, and Miriam is struck with a skin disease.','They ask whether the Lord speaks only through Moses; when the cloud departs Miriam is leprous, and after Moses’ intercession she is shut outside the camp seven days before returning healed.','The narrative that fixes Moses’ unique standing among the prophets.','c. 1246–1216 BCE'),
('forty-years-of-wandering-decreed','zh-CN','四十年漂流的判决','因探子的恶报与百姓的哀哭，这世代被判在旷野漂流四十年。','除迦勒与约书亚外，凡二十岁以上被数点的人都不得进入应许之地，按窥探的四十日一年顶一日。','为整个旷野时代定下框架的转折点。','约公元前 1245–1210 年'),
('forty-years-of-wandering-decreed','en','Forty years of wandering decreed','After the fearful report and the people’s weeping, the generation is sentenced to forty years in the wilderness.','None of those numbered from twenty years old, except Caleb and Joshua, will enter the land—a year for each of the forty days of spying.','The turning point that frames the whole wilderness era.','c. 1245–1210 BCE'),
('rebellion-of-korah','zh-CN','可拉一党的叛乱','可拉联合大坍、亚比兰与二百五十位首领，起来攻击摩西与亚伦。','他们声称全会众都是圣洁的，指责二人自高；摩西提出香炉试验，让耶和华指明谁是属他的。','旷野叙事中最严重的一次权柄危机。','约公元前 1243–1210 年'),
('rebellion-of-korah','en','The rebellion of Korah','Korah, with Dathan, Abiram, and 250 leaders, rises against Moses and Aaron.','Claiming the whole congregation is holy, they charge the brothers with exalting themselves; Moses proposes a test of censers before the Lord.','The gravest crisis of authority in the wilderness narrative.','c. 1243–1210 BCE'),
('earth-swallows-dathan-and-abiram','zh-CN','地开口吞灭叛党','地在大坍、亚比兰的帐棚下裂开，将他们与家眷活活吞下。','摩西宣告若这些人是自然死去便不是耶和华差遣他；话音刚落地就开口，火又烧灭了献香的二百五十人。','叛乱叙事的高潮与结局。','约公元前 1243–1210 年'),
('earth-swallows-dathan-and-abiram','en','The earth swallows the rebels','The ground splits beneath the tents of Dathan and Abiram and swallows them alive with their households.','Moses declares that a natural death would disprove his commission; as he finishes, the earth opens, and fire consumes the 250 offering incense.','The climax and end of the rebellion narrative.','c. 1243–1210 BCE'),
('aarons-staff-buds','zh-CN','亚伦的杖发芽','十二支派的杖放在法柜前过夜，唯有亚伦的杖发芽、开花、结出熟杏。','各支派首领的杖同放在会幕内；次日亚伦的杖已经抽芽开花，被留在法柜前作永远的记号。','以神迹平息关于祭司职分的争论。','约公元前 1242–1208 年'),
('aarons-staff-buds','en','Aaron’s staff buds','Of twelve staffs left before the ark overnight, only Aaron’s buds, blossoms, and bears ripe almonds.','Each tribal leader’s staff is placed in the tent of meeting; the next day Aaron’s has sprouted, and it is kept before the ark as a lasting sign.','A sign settling the dispute over the priesthood.','c. 1242–1208 BCE'),
('water-from-the-rock-at-meribah','zh-CN','米利巴水与摩西之过','摩西在米利巴击打磐石出水，却因未在百姓眼前尊神为圣而不得进入应许之地。','百姓因无水争闹；神吩咐摩西向磐石说话，他却击打磐石两下，水虽涌出，摩西与亚伦被宣告不得领会众进入那地。','解释摩西为何死在约旦河东的关键事件。','约公元前 1240–1205 年'),
('water-from-the-rock-at-meribah','en','Waters of Meribah and Moses’ failure','Moses strikes the rock at Meribah for water, and is barred from the land for failing to hallow God before the people.','Told to speak to the rock, Moses strikes it twice; water gushes out, but Moses and Aaron are told they will not bring the assembly into the land.','The key episode explaining why Moses dies east of the Jordan.','c. 1240–1205 BCE'),
('bronze-serpent-lifted-up','zh-CN','铜蛇','百姓被火蛇所咬，摩西照吩咐造一条铜蛇挂在杆子上，仰望的人得活。','绕行以东途中百姓怨渎神和摩西，火蛇进入营中；铜蛇立起后，凡被咬的一望这蛇就活了。','后世反复回望的医治象征。','约公元前 1235–1202 年'),
('bronze-serpent-lifted-up','en','The bronze serpent lifted up','Bitten by fiery serpents, the people live by looking at a bronze serpent Moses sets on a pole.','On the detour around Edom the people speak against God and Moses, and serpents invade the camp; whoever looks at the raised serpent lives.','A healing image long remembered in later tradition.','c. 1235–1202 BCE'),
('defeat-of-sihon','zh-CN','击败西宏','亚摩利王西宏拒绝以色列借道并出兵迎战，在雅杂被击败。','以色列请求只走大道过境；西宏却聚众出到旷野，战败后从亚嫩河到雅博河的城邑尽归以色列。','约旦河东征服的第一场大捷。','约公元前 1232–1200 年'),
('defeat-of-sihon','en','Defeat of Sihon','The Amorite king Sihon refuses Israel passage, marches out, and is crushed at Jahaz.','Israel asks only to pass along the highway; Sihon musters instead, and after his defeat his towns from the Arnon to the Jabbok fall to Israel.','The first great victory of the Transjordan conquest.','c. 1232–1200 BCE'),
('defeat-of-og-at-edrei','zh-CN','击败巴珊王噩','巴珊王噩率全军在以得来迎战，全军覆没，其地归以色列。','神吩咐摩西不要惧怕他；巴珊六十座坚城被夺，噩的铁床成为后世的谈资。','扫清约旦河东最后的强敌。','约公元前 1231–1199 年'),
('defeat-of-og-at-edrei','en','Defeat of Og at Edrei','Og king of Bashan marches out with all his host at Edrei and is destroyed.','Moses is told not to fear him; sixty fortified towns of Bashan are taken, and Og’s iron bed becomes proverbial.','Clears the last great power east of the Jordan.','c. 1231–1199 BCE'),
('balaams-donkey-speaks','zh-CN','巴兰的驴开口说话','巴兰应巴勒之召前行，驴三次看见拦路的天使，竟开口质问主人。','巴兰的眼目随后也被开启，看见持刀站在路上的使者，得令只可说神所吩咐的话。','圣经中最著名的动物开口场景。','约公元前 1230–1198 年'),
('balaams-donkey-speaks','en','Balaam’s donkey speaks','On the road to Balak, Balaam’s donkey sees the angel barring the way and finally speaks to her master.','Balaam’s own eyes are then opened to the sword-bearing angel, and he is charged to speak only the word given to him.','The most famous speaking-animal scene in the Bible.','c. 1230–1198 BCE'),
('balaam-blesses-israel-three-times','zh-CN','巴兰三次祝福以色列','巴勒三次筑坛求咒诅，巴兰口中却三次发出祝福。','从高处望见安营的以色列，巴兰宣告“雅各啊，你的帐棚何等华美”，末了更预言有星要出于雅各。','咒诅变为祝福的经典叙事。','约公元前 1230–1198 年'),
('balaam-blesses-israel-three-times','en','Balaam blesses Israel three times','Three times Balak builds altars for a curse, and three times Balaam pronounces blessing.','Looking down on the encamped tribes, Balaam declares “how lovely are your tents, O Jacob,” and finally foretells a star out of Jacob.','The classic narrative of a curse turned to blessing.','c. 1230–1198 BCE'),
('phinehas-stays-the-plague','zh-CN','非尼哈止息瘟疫','以色列在巴力毗珥随从摩押女子敬拜偶像，瘟疫蔓延，非尼哈以枪止息灾祸。','亚伦之孙非尼哈将行淫的二人刺透，瘟疫止住，死者已有二万四千；他因忌邪的心蒙应许得平安之约。','巴力毗珥事件的高潮与终结。','约公元前 1228–1196 年'),
('phinehas-stays-the-plague','en','Phinehas stays the plague','As Israel joins the worship of Baal-peor, a plague spreads until Phinehas halts it with his spear.','Aaron’s grandson pierces the offending pair; the plague stops after twenty-four thousand deaths, and for his zeal Phinehas receives a covenant of peace.','The climax and end of the Baal-peor episode.','c. 1228–1196 BCE'),
('joshua-commissioned-as-successor','zh-CN','约书亚受托接续摩西','摩西按神的吩咐为约书亚按手，立他为继任的领袖。','摩西求神为会众立一位牧者；约书亚在祭司以利亚撒与全会众面前受托，得了尊荣与权柄。','领导权正式交接的时刻。','约公元前 1227–1195 年'),
('joshua-commissioned-as-successor','en','Joshua commissioned as successor','At God’s command Moses lays hands on Joshua, appointing him the next leader.','Moses asks for a shepherd for the congregation; Joshua is commissioned before Eleazar the priest and the assembly and invested with authority.','The formal moment of succession.','c. 1227–1195 BCE'),
('death-of-moses','zh-CN','摩西之死','摩西在摩押地死去，葬于伯毗珥对面的谷中，无人知道他的坟墓。','他死时一百二十岁，眼目没有昏花；以色列人为他哀哭三十天，经文称此后以色列中再没有兴起先知像他。','五经叙事的终点。','约公元前 1225–1195 年'),
('death-of-moses','en','The death of Moses','Moses dies in the land of Moab and is buried in the valley opposite Beth-peor, his grave unknown.','He dies at a hundred and twenty with eyes undimmed; Israel weeps thirty days, and the text records that no prophet like him arose again.','The close of the Pentateuch narrative.','c. 1225–1195 BCE'),
('memorial-stones-at-gilgal','zh-CN','吉甲立石与守逾越节','从约旦河中取出的十二块石头立在吉甲，百姓在那里受割礼并守逾越节。','石头作为过河的记念，要向后代述说；新一代在吉甲受割礼，守逾越节，吃了当地的出产后吗哪止住了。','进入迦南后的第一组立约记号。','约公元前 1222–1192 年'),
('memorial-stones-at-gilgal','en','Memorial stones and Passover at Gilgal','Twelve stones from the Jordan are set up at Gilgal, where the people are circumcised and keep Passover.','The stones memorialize the crossing for generations to come; the new generation is circumcised, Passover is kept, and the manna ceases.','The first covenant signs after entering Canaan.','c. 1222–1192 BCE'),
('sin-of-achan','zh-CN','亚干之罪','亚干私取耶利哥当灭之物，耶和华的怒气向以色列发作。','他藏起示拿衣服、银子与一条金子在帐棚的地里；这隐藏的罪使以色列在随后的战事中受挫。','为艾城之败提供叙事原因。','约公元前 1220–1190 年'),
('sin-of-achan','en','The sin of Achan','Achan secretly takes devoted spoil from Jericho, kindling anger against Israel.','He hides a robe of Shinar, silver, and a bar of gold beneath his tent; the hidden sin undermines the campaign that follows.','Supplies the narrative cause of the defeat at Ai.','c. 1220–1190 BCE'),
('israel-defeated-at-ai','zh-CN','艾城之败','以色列轻看小城艾城，反被击退，约书亚撕裂衣服俯伏在约柜前。','约三千人上去便败逃，被击杀三十六人；掣签查出亚干，他与家眷在亚割谷被处死。','征服叙事中唯一的一次败绩。','约公元前 1220–1190 年'),
('israel-defeated-at-ai','en','Israel defeated at Ai','Underestimating the small town of Ai, Israel is repulsed, and Joshua falls before the ark.','About three thousand go up and flee, losing thirty-six men; the lot then exposes Achan, who is executed with his household in the valley of Achor.','The one defeat in the conquest narrative.','c. 1220–1190 BCE'),
('ambush-and-capture-of-ai','zh-CN','设伏攻取艾城','约书亚设下埋伏，佯败诱敌，一举攻取并焚毁艾城。','守军倾城追击时，伏兵入城纵火，以色列回身夹击；艾城王被擒处死。','征服叙事中展示谋略的经典战例。','约公元前 1219–1189 年'),
('ambush-and-capture-of-ai','en','Ambush and capture of Ai','Joshua feigns retreat, springs an ambush, and takes and burns Ai.','While the town empties in pursuit, the hidden force enters and fires it, and Israel turns to catch the defenders between two fronts; the king of Ai is taken.','A classic stratagem in the conquest account.','c. 1219–1189 BCE'),
('gibeonite-deception','zh-CN','基遍人的诡计','基遍人假扮远方来客，骗得以色列起誓与他们立约。','他们带着发霉的饼与破旧的衣物自称从极远之地而来；誓约既立不可背弃，他们从此作了劈柴挑水的人。','关于誓言约束力的著名叙事。','约公元前 1218–1185 年'),
('gibeonite-deception','en','The Gibeonite deception','The Gibeonites pose as travelers from a far country and obtain a sworn treaty with Israel.','With moldy bread and worn-out clothes they claim a distant origin; the oath once sworn cannot be broken, and they become woodcutters and water carriers.','A famous narrative on the binding force of oaths.','c. 1218–1185 BCE'),
('sun-stands-still-over-gibeon','zh-CN','日头停留在基遍','五王联军攻打基遍，约书亚连夜驰援，日头在基遍停留，月亮在亚雅仑谷止住。','耶路撒冷王亚多尼洗德纠合四王围攻基遍；约书亚夜行军奇袭，大冰雹击杀敌军，经文记载日月停留约有一日之久。','南方战役中最著名的神迹场景。','约公元前 1216–1183 年'),
('sun-stands-still-over-gibeon','en','The sun stands still over Gibeon','As five kings assault Gibeon, Joshua marches through the night, and sun and moon stand still.','Adoni-zedek of Jerusalem gathers four kings against Gibeon; after a night march and a rout under great hailstones, the text records the sun halting about a whole day.','The most famous wonder of the southern campaign.','c. 1216–1183 BCE'),
('northern-kings-defeated-at-merom','zh-CN','米伦水边击溃北方联军','夏琐王耶宾召聚北方诸王，约书亚在米伦水边突袭，联军溃败，夏琐被焚。','联军人马多如海边的沙；约书亚照吩咐砍断马蹄筋、焚烧车辆，随后攻取北方诸城，在诸城中独将夏琐焚毁。','征服叙事中最后一场大战役。','约公元前 1214–1180 年'),
('northern-kings-defeated-at-merom','en','Northern coalition defeated at Merom','Jabin of Hazor musters the northern kings, and Joshua falls on them at the waters of Merom; Hazor is burned.','Against a host like the sand of the sea, Joshua hamstrings the horses and burns the chariots as commanded, then takes the northern cities, burning Hazor alone.','The last great battle of the conquest narrative.','c. 1214–1180 BCE'),
('covenant-at-shechem','zh-CN','示剑立约','约书亚在示剑召聚各支派，百姓宣告要事奉耶和华。','约书亚历数从大河那边呼召亚伯拉罕以来的大事，要百姓在诸神之间作出选择，并立大石在橡树下作见证。','全书的信仰总结与立约高峰。','约公元前 1200–1160 年'),
('covenant-at-shechem','en','Covenant at Shechem','Joshua gathers the tribes at Shechem, and the people declare that they will serve the Lord.','Recounting the story from Abraham’s call beyond the River, Joshua sets a choice before the people and raises a great stone of witness under the oak.','The book’s covenantal climax and summation.','c. 1200–1160 BCE'),
('death-of-joshua','zh-CN','约书亚之死','约书亚死时一百一十岁，葬在自己的产业亭拿西拉。','经文记载约书亚在世和其后长老在世的日子，以色列人都事奉耶和华。','征服时代的落幕。','约公元前 1195–1150 年'),
('death-of-joshua','en','The death of Joshua','Joshua dies at a hundred and ten and is buried at Timnath-serah, his own inheritance.','The text notes that Israel served the Lord all the days of Joshua and of the elders who outlived him.','The close of the conquest era.','c. 1195–1150 BCE')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('departure-from-sinai','mount-sinai-traditional'),
('quail-and-plague-at-kibroth-hattaavah','kibroth-hattaavah-reference'),
('miriam-struck-with-leprosy','hazeroth-reference'),
('forty-years-of-wandering-decreed','kadesh-barnea'),
('rebellion-of-korah','kadesh-barnea'),
('earth-swallows-dathan-and-abiram','kadesh-barnea'),
('aarons-staff-buds','kadesh-barnea'),
('water-from-the-rock-at-meribah','kadesh-barnea'),
('bronze-serpent-lifted-up','punon-reference'),
('defeat-of-sihon','heshbon'),
('defeat-of-og-at-edrei','edrei-bashan'),
('balaams-donkey-speaks','plains-of-moab'),
('balaam-blesses-israel-three-times','plains-of-moab'),
('phinehas-stays-the-plague','plains-of-moab'),
('joshua-commissioned-as-successor','plains-of-moab'),
('death-of-moses','mount-nebo'),
('memorial-stones-at-gilgal','gilgal-reference'),
('sin-of-achan','jericho'),
('israel-defeated-at-ai','ai-reference'),
('ambush-and-capture-of-ai','ai-reference'),
('gibeonite-deception','gilgal-reference'),
('sun-stands-still-over-gibeon','gibeon'),
('northern-kings-defeated-at-merom','waters-of-merom-reference'),
('covenant-at-shechem','canaan-shechem'),
('death-of-joshua','timnath-serah-reference')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS
--    (eleazar-son-of-aaron is created by era 03, loaded before this file;
--     during isolated testing that JOIN row is silently dropped -- expected)
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('departure-from-sinai','moses',0),('departure-from-sinai','aaron',1),
('quail-and-plague-at-kibroth-hattaavah','moses',0),
('miriam-struck-with-leprosy','miriam',0),('miriam-struck-with-leprosy','aaron',1),('miriam-struck-with-leprosy','moses',2),
('forty-years-of-wandering-decreed','moses',0),('forty-years-of-wandering-decreed','caleb',1),('forty-years-of-wandering-decreed','joshua',2),
('rebellion-of-korah','korah',0),('rebellion-of-korah','dathan',1),('rebellion-of-korah','abiram',2),('rebellion-of-korah','moses',3),('rebellion-of-korah','aaron',4),
('earth-swallows-dathan-and-abiram','dathan',0),('earth-swallows-dathan-and-abiram','abiram',1),('earth-swallows-dathan-and-abiram','korah',2),('earth-swallows-dathan-and-abiram','moses',3),
('aarons-staff-buds','aaron',0),('aarons-staff-buds','moses',1),
('water-from-the-rock-at-meribah','moses',0),('water-from-the-rock-at-meribah','aaron',1),
('bronze-serpent-lifted-up','moses',0),
('defeat-of-sihon','sihon',0),('defeat-of-sihon','moses',1),
('defeat-of-og-at-edrei','og-king-of-bashan',0),('defeat-of-og-at-edrei','moses',1),
('balaams-donkey-speaks','balaam',0),('balaams-donkey-speaks','balak',1),
('balaam-blesses-israel-three-times','balaam',0),('balaam-blesses-israel-three-times','balak',1),
('phinehas-stays-the-plague','phinehas-son-of-eleazar',0),('phinehas-stays-the-plague','moses',1),
('joshua-commissioned-as-successor','joshua',0),('joshua-commissioned-as-successor','moses',1),('joshua-commissioned-as-successor','eleazar-son-of-aaron',2),
('death-of-moses','moses',0),('death-of-moses','joshua',1),
('memorial-stones-at-gilgal','joshua',0),
('sin-of-achan','achan',0),('sin-of-achan','joshua',1),
('israel-defeated-at-ai','joshua',0),('israel-defeated-at-ai','achan',1),
('ambush-and-capture-of-ai','joshua',0),
('gibeonite-deception','joshua',0),
('sun-stands-still-over-gibeon','joshua',0),('sun-stands-still-over-gibeon','adoni-zedek',1),
('northern-kings-defeated-at-merom','jabin-of-hazor',0),('northern-kings-defeated-at-merom','joshua',1),
('covenant-at-shechem','joshua',0),
('death-of-joshua','joshua',0)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES (Numbers / Deuteronomy / Joshua, grouped by slug)
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Numbers'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN (
'departure-from-sinai','quail-and-plague-at-kibroth-hattaavah','miriam-struck-with-leprosy',
'forty-years-of-wandering-decreed','rebellion-of-korah','earth-swallows-dathan-and-abiram',
'aarons-staff-buds','water-from-the-rock-at-meribah','bronze-serpent-lifted-up',
'defeat-of-sihon','defeat-of-og-at-edrei','balaams-donkey-speaks',
'balaam-blesses-israel-three-times','phinehas-stays-the-plague','joshua-commissioned-as-successor')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Deuteronomy'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN ('death-of-moses')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Joshua'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN (
'memorial-stones-at-gilgal','sin-of-achan','israel-defeated-at-ai','ambush-and-capture-of-ai',
'gibeonite-deception','sun-stands-still-over-gibeon','northern-kings-defeated-at-merom',
'covenant-at-shechem','death-of-joshua')
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS
-- -------------------------------------------------------------------------
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('73000000-0000-4000-8004-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'korah','moses','adversary','bidirectional','negative',4,'ended','rebellion-of-korah','earth-swallows-dathan-and-abiram'),
(2,'dathan','moses','adversary','bidirectional','negative',3,'ended','rebellion-of-korah','earth-swallows-dathan-and-abiram'),
(3,'abiram','moses','adversary','bidirectional','negative',3,'ended','rebellion-of-korah','earth-swallows-dathan-and-abiram'),
(4,'dathan','abiram','sibling','bidirectional','positive',3,'ended',NULL,'earth-swallows-dathan-and-abiram'),
(5,'balak','balaam','ally','source_to_target','mixed',3,'ended','balaams-donkey-speaks','balaam-blesses-israel-three-times'),
(6,'sihon','moses','adversary','bidirectional','negative',3,'ended',NULL,'defeat-of-sihon'),
(7,'og-king-of-bashan','moses','adversary','bidirectional','negative',3,'ended',NULL,'defeat-of-og-at-edrei'),
(8,'aaron','phinehas-son-of-eleazar','family','source_to_target','positive',3,'unknown',NULL,NULL),
(9,'achan','joshua','adversary','source_to_target','negative',3,'ended','sin-of-achan','israel-defeated-at-ai'),
(10,'jabin-of-hazor','joshua','adversary','bidirectional','negative',3,'ended',NULL,'northern-kings-defeated-at-merom')
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000005'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 10. GROUP MEMBERSHIP (existing group conquest-generation)
-- -------------------------------------------------------------------------
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g JOIN (VALUES
('conquest-generation','korah'),('conquest-generation','dathan'),('conquest-generation','abiram'),
('conquest-generation','balaam'),('conquest-generation','balak'),('conquest-generation','phinehas-son-of-eleazar'),
('conquest-generation','og-king-of-bashan'),('conquest-generation','sihon'),('conquest-generation','achan'),
('conquest-generation','adoni-zedek'),('conquest-generation','jabin-of-hazor')
) AS v(gslug,cslug)
ON g.slug=v.gslug JOIN characters c ON c.slug=v.cslug AND c.work_id=g.work_id
WHERE g.work_id='10000000-0000-4000-8000-000000000005' ON CONFLICT DO NOTHING;

COMMIT;
