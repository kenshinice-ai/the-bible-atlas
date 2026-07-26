BEGIN;

-- =========================================================================
-- 014_bible_full_05_judges.sql
-- Chapter K=05 slug='judges' (Judges, Ruth, 1 Samuel 1-7), era -1150..-1030
-- Adds 10 characters, 3 locations, 20 new events, relations, and reorders
-- the nine pre-existing judges events into the 5001-5999 sequence band.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('43000000-0000-4000-8005-000000000001','10000000-0000-4000-8000-000000000005','ehud',500,'male','adult','protagonist','unknown',NULL,NULL,'judge',3),
('43000000-0000-4000-8005-000000000002','10000000-0000-4000-8000-000000000005','eglon',501,'male','adult','antagonist','unknown',NULL,NULL,'king',2),
('43000000-0000-4000-8005-000000000003','10000000-0000-4000-8000-000000000005','jael',502,'female','adult','supporting','unknown',NULL,NULL,'person',3),
('43000000-0000-4000-8005-000000000004','10000000-0000-4000-8000-000000000005','sisera',503,'male','adult','antagonist','unknown',NULL,NULL,'soldier',3),
('43000000-0000-4000-8005-000000000005','10000000-0000-4000-8000-000000000005','jephthah',504,'male','adult','protagonist','unknown',NULL,NULL,'judge',3),
('43000000-0000-4000-8005-000000000006','10000000-0000-4000-8000-000000000005','naomi',505,'female','elder','supporting','unknown',NULL,NULL,'matriarch',3),
('43000000-0000-4000-8005-000000000007','10000000-0000-4000-8000-000000000005','eli',506,'male','elder','supporting','unknown',NULL,NULL,'priest',3),
('43000000-0000-4000-8005-000000000008','10000000-0000-4000-8000-000000000005','hannah',507,'female','adult','protagonist','unknown',NULL,NULL,'person',3),
('43000000-0000-4000-8005-000000000009','10000000-0000-4000-8000-000000000005','elkanah',508,'male','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8005-000000000010','10000000-0000-4000-8000-000000000005','manoah',509,'male','adult','supporting','unknown',NULL,NULL,'person',2)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('ehud','zh-CN','以笏','便雅悯支派的左手士师,刺杀摩押王伊矶伦。',ARRAY[]::text[],'便雅悯人基拉的儿子,惯用左手。奉命向摩押王进贡时暗藏两刃短剑,在凉楼中单独进言刺杀伊矶伦,随后率以色列人夺取约旦河渡口,击退摩押。','解救以色列脱离摩押的辖制。'),
('ehud','en','Ehud','The left-handed judge from Benjamin who assassinated Eglon king of Moab.',ARRAY[]::text[],'A son of Gera the Benjaminite, he hides a double-edged sword while delivering tribute, kills Eglon alone in his cool upper room, then leads Israel to seize the Jordan fords against Moab.','To deliver Israel from Moabite domination.'),
('eglon','zh-CN','伊矶伦','压制以色列十八年的摩押王,被以笏刺杀。',ARRAY[]::text[],'联合亚扪人与亚玛力人攻取棕树城,使以色列人服事他十八年,后在凉楼接见以笏时被刺身亡。','扩张摩押对以色列的统治。'),
('eglon','en','Eglon','The king of Moab who oppressed Israel for eighteen years and was killed by Ehud.',ARRAY[]::text[],'Allied with Ammon and Amalek, he seizes the city of palms and makes Israel serve him for eighteen years, until Ehud kills him during a private audience.','To extend Moab’s rule over Israel.'),
('jael','zh-CN','雅亿','基尼人希百之妻,用帐棚橛子钉死西西拉。',ARRAY[]::text[],'战败的西西拉逃到她的帐棚,她以奶款待并用被遮盖他,待其熟睡后用橛子和锤子将他钉死于地。','终结迦南军长带来的威胁。'),
('jael','en','Jael','The wife of Heber the Kenite, who killed Sisera with a tent peg.',ARRAY[]::text[],'When the defeated Sisera flees to her tent, she gives him milk, covers him, and drives a tent peg through his temple as he sleeps.','To end the threat posed by the Canaanite commander.'),
('sisera','zh-CN','西西拉','夏琐王耶宾的军长,拥有九百辆铁车,兵败后死于雅亿帐中。',ARRAY[]::text[],'率铁车大军欺压以色列二十年,在基顺河一带被底波拉与巴拉击溃,弃车步逃,最终死在雅亿的帐棚里。','以武力维持对以色列的压制。'),
('sisera','en','Sisera','Commander of Jabin of Hazor’s army with nine hundred iron chariots, killed in Jael’s tent after his defeat.',ARRAY[]::text[],'He oppresses Israel for twenty years until his chariot force is routed by the Kishon; fleeing on foot, he dies in the tent of Jael.','To hold Israel down by force of arms.'),
('jephthah','zh-CN','耶弗他','基列的勇士与士师,因许愿而失去独生女儿。',ARRAY[]::text[],'妓女之子,被兄弟赶逐后在陀伯地聚集勇士;基列长老请他回来抵御亚扪人,他战前许愿,凯旋时首先出门迎接他的竟是独生女儿。','为得胜亚扪人并在同胞中恢复地位。'),
('jephthah','en','Jephthah','The Gileadite warrior-judge whose vow cost him his only daughter.',ARRAY[]::text[],'Son of a prostitute, driven out by his brothers, he gathers fighters in the land of Tob; recalled by Gilead’s elders against Ammon, he makes a vow before battle, and his only daughter is the first to meet him on his return.','Victory over Ammon and restored standing among his people.'),
('naomi','zh-CN','拿俄米','路得的婆婆,在摩押丧夫丧子后携路得返回伯利恒。',ARRAY['玛拉']::text[],'因饥荒随丈夫以利米勒迁居摩押,十年间丈夫与两个儿子相继去世;她自称“玛拉”(苦),带着儿妇路得回乡,并为她谋划与波阿斯的婚事。','为自己与儿妇寻得安身之所。'),
('naomi','en','Naomi','Ruth’s mother-in-law, who returned to Bethlehem from Moab after losing her husband and sons.',ARRAY['Mara']::text[],'Famine drives her family to Moab, where her husband Elimelech and both sons die within about ten years; calling herself “Mara” (bitter), she returns with Ruth and arranges her marriage to Boaz.','To find rest and security for herself and her daughter-in-law.'),
('eli','zh-CN','以利','示罗的祭司,抚养撒母耳,闻约柜被掳而死。',ARRAY[]::text[],'在示罗圣所任祭司并治理以色列;误以为祈祷的哈拿醉酒,后收养撒母耳在殿中供职;两个儿子行恶,他年老目盲,听闻约柜被掳、二子阵亡,从位上跌倒折颈而死。','守护示罗圣所的职事。'),
('eli','en','Eli','The priest at Shiloh who raised Samuel and died at the news of the ark’s capture.',ARRAY[]::text[],'Priest and judge at the Shiloh sanctuary, he mistakes the praying Hannah for a drunkard, then raises Samuel in the temple service; old and blind, he falls from his seat and dies on hearing that the ark is taken and his sons are dead.','To keep the sanctuary service at Shiloh.'),
('hannah','zh-CN','哈拿','撒母耳的母亲,在示罗祈祷求子并将他献与耶和华。',ARRAY[]::text[],'以利加拿之妻,多年不育而愁苦,在示罗默祷许愿;得子撒母耳后断奶即送往示罗归与耶和华,并唱出颂歌。','求得儿子并向耶和华还愿。'),
('hannah','en','Hannah','Samuel’s mother, who prayed for a son at Shiloh and dedicated him to the Lord.',ARRAY[]::text[],'Elkanah’s wife, long childless and grieved, she prays silently at Shiloh and vows her son to the Lord; after weaning Samuel she brings him to Shiloh and sings her song of praise.','To receive a son and to keep her vow to the Lord.'),
('elkanah','zh-CN','以利加拿','以法莲山地拉玛的人,哈拿的丈夫,撒母耳之父。',ARRAY[]::text[],'每年上示罗敬拜献祭;深爱哈拿,在她愁苦时加倍分给她祭肉,并支持她还愿将撒母耳献与耶和华。','持守每年的敬拜并眷爱家人。'),
('elkanah','en','Elkanah','A man of Ramah in the hill country of Ephraim, Hannah’s husband and Samuel’s father.',ARRAY[]::text[],'He goes up yearly to worship and sacrifice at Shiloh, gives the grieving Hannah a double portion, and supports her vow to give Samuel to the Lord.','To keep the yearly worship and care for his household.'),
('manoah','zh-CN','玛挪亚','琐拉的但支派人,参孙的父亲。',ARRAY[]::text[],'妻子不育,耶和华的使者两次显现预告参孙出生;他献上素祭,使者在坛上的火焰中升天,夫妻俯伏于地。','求问如何养育所应许的孩子。'),
('manoah','en','Manoah','A Danite of Zorah, the father of Samson.',ARRAY[]::text[],'The angel of the Lord twice appears to announce a son to his barren wife; when Manoah offers a grain offering, the messenger ascends in the flame of the altar.','To learn how to raise the promised child.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. LOCATIONS (reuse jericho, bethel, hazor, mount-gilboa, canaan-shechem,
--    mizpah-of-gilead, plains-of-moab, bethlehem, shiloh; only 3 new)
-- -------------------------------------------------------------------------
INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('33000000-0000-4000-8005-000000000001','10000000-0000-4000-8000-000000000005','ophrah-reference','real',ST_GeogFromText('POINT(35.2900 32.6100)'),NULL,NULL,500,'city','inferred',8,'IL',true,false),
('33000000-0000-4000-8005-000000000002','10000000-0000-4000-8000-000000000005','zorah','real',ST_GeogFromText('POINT(34.9700 31.7620)'),NULL,NULL,501,'city','approximate',9,'IL',false,false),
('33000000-0000-4000-8005-000000000003','10000000-0000-4000-8000-000000000005','mizpah-of-benjamin','real',ST_GeogFromText('POINT(35.2170 31.8850)'),NULL,NULL,502,'city','approximate',9,'PS',false,false)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,status,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',ARRAY[]::text[],'','','','',v.region FROM locations l JOIN (VALUES
('ophrah-reference','zh-CN','俄弗拉(推定位置)','基甸的家乡,亚比以谢族的俄弗拉,确切位置不详,一般推定在玛拿西山地。','玛拿西'),
('ophrah-reference','en','Ophrah (traditional site)','Gideon’s hometown among the Abiezrites; the exact site is uncertain, traditionally placed in the hill country of Manasseh.','Manasseh'),
('zorah','zh-CN','琐拉','梭烈谷北侧的但支派城镇,参孙的家乡,附近有玛哈尼但与伯示麦。','梭烈谷'),
('zorah','en','Zorah','A Danite town on the north side of the Sorek Valley, Samson’s hometown, near Mahaneh-dan and Beth-shemesh.','Sorek Valley'),
('mizpah-of-benjamin','zh-CN','米斯巴(便雅悯)','便雅悯地的米斯巴,撒母耳召聚以色列人悔改之处,一般认作纳斯贝丘遗址。','便雅悯'),
('mizpah-of-benjamin','en','Mizpah of Benjamin','Mizpah in the territory of Benjamin, where Samuel assembled Israel in repentance; commonly identified with Tell en-Nasbeh.','Benjamin')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug AND l.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 3. EVENTS (new) -- range dates within era -1150..-1030, chapter 'judges'
-- -------------------------------------------------------------------------
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('63000000-0000-4000-8005-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,'range'::event_time_type,'unknown'::calendar_system,
       v.y1,v.y2,'low'::confidence_level,ch.id
FROM (VALUES
(1,'ehud-kills-eglon',5001,'reported_historical','political',-1150,-1110),
(2,'deborah-rises-as-judge',5003,'reported_historical','political',-1140,-1100),
(3,'jael-kills-sisera',5009,'reported_historical','death',-1140,-1100),
(4,'gideon-called-and-tears-down-baal-altar',5011,'legendary_or_mythic','religious',-1120,-1080),
(5,'gideon-night-attack-with-three-hundred',5015,'reported_historical','battle',-1120,-1080),
(6,'abimelech-and-jothams-parable',5017,'reported_historical','political',-1100,-1060),
(7,'jephthah-vow-and-his-daughter',5019,'reported_historical','religious',-1090,-1050),
(8,'birth-of-samson-foretold',5021,'legendary_or_mythic','religious',-1090,-1050),
(9,'samson-lion-and-riddle',5023,'legendary_or_mythic','other',-1080,-1040),
(10,'samson-foxes-and-firebrands',5025,'legendary_or_mythic','other',-1080,-1040),
(11,'samson-jawbone-at-lehi',5027,'legendary_or_mythic','battle',-1080,-1040),
(12,'naomi-bereaved-in-moab',5035,'reported_historical','death',-1100,-1060),
(13,'ruth-gleans-in-boaz-field',5039,'reported_historical','meeting',-1100,-1060),
(14,'boaz-redeems-ruth-at-the-gate',5043,'reported_historical','marriage',-1100,-1060),
(15,'hannah-prays-at-shiloh',5045,'reported_historical','religious',-1080,-1050),
(16,'birth-and-dedication-of-samuel',5047,'reported_historical','birth',-1080,-1050),
(17,'god-calls-samuel-in-the-night',5051,'legendary_or_mythic','religious',-1070,-1040),
(18,'ark-captured-and-death-of-eli',5053,'reported_historical','battle',-1060,-1030),
(19,'ark-returned-to-israel',5055,'legendary_or_mythic','religious',-1060,-1030),
(20,'israel-repents-at-mizpah',5057,'reported_historical','religious',-1050,-1030)
) AS v(n,slug,seq,reality,etype,y1,y2)
JOIN chapters ch ON ch.slug='judges' AND ch.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 4. Reorder existing judges events into the 5001-5999 band (interleaved)
-- -------------------------------------------------------------------------
UPDATE events e SET sequence=v.seq FROM (VALUES
  ('deborah-and-barak-muster-at-tabor',5005),
  ('battle-near-megiddo',5007),
  ('gideon-reduces-his-force',5013),
  ('samson-among-the-philistine-cities',5029),
  ('samson-and-delilah',5031),
  ('samson-at-gaza',5033),
  ('naomi-and-ruth-reach-bethlehem',5037),
  ('ruth-and-boaz-at-the-threshing-floor',5041),
  ('samuel-serves-at-shiloh',5049)
) AS v(slug,seq) WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug=v.slug;

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('ehud-kills-eglon','zh-CN','以笏刺杀伊矶伦','便雅悯人以笏进贡时用暗藏的短剑刺杀摩押王伊矶伦。','以笏称有机密奏告,在凉楼中单独面见伊矶伦,用左手拔出右腿上的两刃剑刺入王腹,随后逃往西伊拉,率以色列人夺取约旦河渡口。','结束摩押十八年的辖制,此后地方太平八十年。','约公元前 1150–1110 年'),
('ehud-kills-eglon','en','Ehud kills Eglon','Ehud of Benjamin assassinates Eglon king of Moab with a hidden sword while delivering tribute.','Claiming a secret message, Ehud meets Eglon alone in his cool upper room, draws the double-edged sword from his right thigh with his left hand, then escapes to Seirah and leads Israel to seize the fords of the Jordan.','Ends eighteen years of Moabite domination, followed by eighty years of quiet.','c. 1150–1110 BCE'),
('deborah-rises-as-judge','zh-CN','底波拉兴起作士师','女先知底波拉在以法莲山地的棕树下听讼,治理以色列。','她坐在拉玛和伯特利中间的底波拉棕树下,以色列人都上她那里听判断;当时夏琐王耶宾借军长西西拉的铁车欺压以色列已二十年。','为召巴拉出战夏琐王的叙事作铺垫。','约公元前 1140–1100 年'),
('deborah-rises-as-judge','en','Deborah rises as judge','The prophetess Deborah judges Israel under a palm in the hill country of Ephraim.','She holds court under the palm of Deborah between Ramah and Bethel, and the Israelites come up to her for judgment, while Jabin of Hazor and his commander Sisera have oppressed Israel for twenty years.','Sets up the summons of Barak against the forces of Hazor.','c. 1140–1100 BCE'),
('jael-kills-sisera','zh-CN','雅亿钉死西西拉','兵败的西西拉逃入雅亿帐中,被她用帐棚橛子钉死。','西西拉弃车步逃,雅亿出来迎接,给他奶喝并用被遮盖;他因困乏沉睡时,雅亿手持锤子,将橛子从他鬓边钉入地里。','应验底波拉所说“耶和华要将西西拉交在一个妇人手里”的预言。','约公元前 1140–1100 年'),
('jael-kills-sisera','en','Jael kills Sisera','The defeated Sisera flees to Jael’s tent, where she drives a tent peg through his temple.','Sisera abandons his chariot and flees on foot; Jael welcomes him, gives him milk, and covers him, then kills him with peg and hammer as he sleeps exhausted.','Fulfills Deborah’s word that the Lord would give Sisera into the hand of a woman.','c. 1140–1100 BCE'),
('gideon-called-and-tears-down-baal-altar','zh-CN','基甸蒙召并拆毁巴力祭坛','耶和华的使者在俄弗拉向基甸显现,基甸夜间拆毁父亲的巴力祭坛。','使者称在酒榨里打麦子躲避米甸人的基甸为“大能的勇士”;基甸献祭后奉命拆毁巴力坛、砍下木偶,因惧怕家人和本城的人而在夜间行事,由此得名耶路巴力。','开启基甸拯救以色列脱离米甸人的叙事。','约公元前 1120–1080 年'),
('gideon-called-and-tears-down-baal-altar','en','Gideon called and the altar of Baal torn down','The angel of the Lord appears to Gideon at Ophrah, and by night he tears down his father’s altar of Baal.','The messenger greets Gideon, threshing wheat in a winepress to hide it from Midian, as a “mighty man of valor”; ordered to demolish the Baal altar and cut down the Asherah, he acts at night out of fear and earns the name Jerubbaal.','Opens the narrative of Gideon’s deliverance of Israel from Midian.','c. 1120–1080 BCE'),
('gideon-night-attack-with-three-hundred','zh-CN','三百人夜袭米甸营','基甸率三百人吹角打破瓶子,夜袭米甸军营。','三队人在营的四围吹角、打破瓶子、高举火把,喊着“耶和华和基甸的刀”;米甸全营惊乱,自相击杀而溃逃。','以极少的人数得胜,突显叙事中以色列不可自夸的主题。','约公元前 1120–1080 年'),
('gideon-night-attack-with-three-hundred','en','Night attack with three hundred','Gideon’s three hundred break jars, blow trumpets, and rout the Midianite camp by night.','Three companies surround the camp with trumpets, torches, and the cry “A sword for the Lord and for Gideon”; the whole camp panics, turns sword on itself, and flees.','Victory through a deliberately small force underscores the theme that Israel must not boast in its own strength.','c. 1120–1080 BCE'),
('abimelech-and-jothams-parable','zh-CN','亚比米勒称王与约坦的寓言','基甸之子亚比米勒杀众兄弟在示剑称王,约坦以荆棘作王的寓言警告示剑人。','亚比米勒在一块磐石上杀了兄弟七十人,唯独幼子约坦逃脱;约坦站在基利心山顶讲述众树立荆棘为王的寓言,预言亚比米勒与示剑人必彼此吞灭。','寓言成为圣经中反思王权的经典段落;亚比米勒与示剑人后来果然同归于尽。','约公元前 1100–1060 年'),
('abimelech-and-jothams-parable','en','Abimelech’s kingship and Jotham’s parable','Abimelech, Gideon’s son, kills his brothers and is made king at Shechem; Jotham answers with the parable of the bramble king.','Seventy brothers are killed on one stone, and only Jotham, the youngest, escapes; from the top of Mount Gerizim he tells how the trees crowned the bramble, foretelling that Abimelech and Shechem will devour each other.','The parable becomes a classic biblical reflection on kingship; Abimelech and the Shechemites later destroy one another.','c. 1100–1060 BCE'),
('jephthah-vow-and-his-daughter','zh-CN','耶弗他的许愿与他的女儿','耶弗他战前许愿,凯旋时首先出来迎接他的竟是独生女儿。','他向耶和华许愿,若得胜就将首先从家门出来迎接的献上;击败亚扪人回到米斯巴时,女儿击鼓跳舞出来迎接;她求两个月与同伴在山上哀哭,以色列的女子从此每年为她哀哭四天。','士师记中最沉痛的叙事之一,历代解经聚讼不已。','约公元前 1090–1050 年'),
('jephthah-vow-and-his-daughter','en','Jephthah’s vow and his daughter','Jephthah vows before battle, and it is his only daughter who first comes out to meet him.','He vows to offer whatever first comes from his door if he returns victorious; back at Mizpah after defeating Ammon, his daughter comes out with timbrels and dancing; she asks two months to bewail her virginity in the mountains, and the daughters of Israel commemorate her yearly.','One of the most sorrowful narratives in Judges, debated by interpreters through the ages.','c. 1090–1050 BCE'),
('birth-of-samson-foretold','zh-CN','参孙出生的预告','耶和华的使者向玛挪亚不育的妻子显现,预告拿细耳人参孙的出生。','使者吩咐孩子从胎里就归神作拿细耳人,不可用剃刀剃头;玛挪亚献上素祭,使者在坛上的火焰中升天,夫妻就俯伏于地。','为参孙的能力与其条件埋下叙事伏笔。','约公元前 1090–1050 年'),
('birth-of-samson-foretold','en','The birth of Samson foretold','The angel of the Lord appears to Manoah’s barren wife, announcing the birth of Samson the Nazirite.','The child is to be a Nazirite to God from the womb, no razor ever touching his head; when Manoah offers a grain offering, the messenger ascends in the flame of the altar, and the couple fall on their faces.','Plants the narrative seed of Samson’s strength and its condition.','c. 1090–1050 BCE'),
('samson-lion-and-riddle','zh-CN','参孙撕狮与婚宴谜语','参孙下亭拿途中徒手撕裂少壮狮子,后在婚宴上以蜜出谜语。','死狮体内后来有蜂群与蜜;婚宴上参孙出谜“吃的从吃者出来,甜的从强者出来”,三十个陪伴借他妻子探得谜底,参孙怒而在亚实基伦击杀三十人取衣抵偿。','开启参孙与非利士人纠缠冲突的连环叙事。','约公元前 1080–1040 年'),
('samson-lion-and-riddle','en','Samson, the lion, and the riddle','On the way down to Timnah Samson tears a young lion barehanded, then poses a riddle at his wedding feast.','Bees and honey later fill the carcass; his riddle — “Out of the eater came something to eat, out of the strong came something sweet” — is pried out through his bride, and in anger he strikes down thirty men at Ashkelon to pay the wager.','Opens the chain of Samson’s entanglements with the Philistines.','c. 1080–1040 BCE'),
('samson-foxes-and-firebrands','zh-CN','狐狸火把烧田','参孙捉三百只狐狸,尾巴绑上火把,烧毁非利士人的庄稼。','因妻子被转嫁他人,参孙将狐狸成对捆上火把放入站着的禾稼,烧尽禾捆、葡萄园与橄榄园;非利士人用火烧死他的妻子和岳父作为报复。','冤冤相报的循环不断升级。','约公元前 1080–1040 年'),
('samson-foxes-and-firebrands','en','Foxes and firebrands','Samson ties torches to three hundred foxes and burns the Philistines’ grain.','After his wife is given to another man, he releases the paired animals into the standing grain, destroying sheaves, vineyards, and olive groves; the Philistines retaliate by burning his wife and her father.','The cycle of retaliation escalates step by step.','c. 1080–1040 BCE'),
('samson-jawbone-at-lehi','zh-CN','驴腮骨杀敌一千','在利希,参孙挣断绳索,用一块未干的驴腮骨击杀非利士人一千。','犹大人将参孙捆绑交给非利士人;耶和华的灵大大感动他,绳子如火烧的麻从他手上脱落;战后他口渴呼求,神使利希的洼处裂开出水。','拉末利希与隐哈歌利的地名由此而来。','约公元前 1080–1040 年'),
('samson-jawbone-at-lehi','en','The jawbone at Lehi','At Lehi Samson bursts his bonds and strikes down a thousand Philistines with a fresh donkey’s jawbone.','Handed over bound by the men of Judah, he is seized by the Spirit of the Lord and the ropes fall from his hands like burnt flax; afterward God opens the hollow at Lehi to quench his thirst.','The place names Ramath-lehi and En-hakkore preserve the tale.','c. 1080–1040 BCE'),
('naomi-bereaved-in-moab','zh-CN','拿俄米在摩押痛失亲人','逃荒到摩押的拿俄米十年间接连失去丈夫以利米勒与两个儿子。','伯利恒遭遇饥荒,以利米勒带全家迁往摩押地;两个儿子娶摩押女子俄珥巴与路得为妻,随后父子三人相继去世,只剩拿俄米与两个儿妇。','为路得记回归伯利恒的叙事设定起点。','约公元前 1100–1060 年'),
('naomi-bereaved-in-moab','en','Naomi bereaved in Moab','In Moab Naomi loses her husband Elimelech and both sons within about ten years.','Famine drives the family from Bethlehem to the country of Moab; the sons marry Orpah and Ruth, then father and sons die in turn, leaving three widows.','Sets the starting point for the book of Ruth’s return to Bethlehem.','c. 1100–1060 BCE'),
('ruth-gleans-in-boaz-field','zh-CN','路得在波阿斯田间拾穗','路得恰巧到波阿斯的田里拾取麦穗,得到他的眷顾。','波阿斯听闻路得善待婆婆的名声,吩咐仆人容她拾穗,还故意从捆里抽出些来留给她,并请她同席用饭。','拾穗的律法与个人的恩慈在此交汇,开启二人的姻缘。','约公元前 1100–1060 年'),
('ruth-gleans-in-boaz-field','en','Ruth gleans in Boaz’s field','Ruth happens upon the field of Boaz, who shows her favor as she gleans.','Having heard of her loyalty to Naomi, Boaz tells his reapers to let her glean and to pull out stalks from the bundles for her, and invites her to share the meal.','Gleaning law and personal kindness meet, beginning their courtship.','c. 1100–1060 BCE'),
('boaz-redeems-ruth-at-the-gate','zh-CN','城门前赎业娶路得','波阿斯在城门长老面前赎回以利米勒的产业,娶路得为妻。','更近的亲属脱鞋放弃赎业之权,十位长老作见证;众民祝福路得像拉结与利亚;路得生俄备得,就是大卫的祖父。','借着家谱把士师时代与大卫王朝连接起来。','约公元前 1100–1060 年'),
('boaz-redeems-ruth-at-the-gate','en','Boaz redeems and marries Ruth at the gate','Before the elders at the town gate Boaz redeems Elimelech’s land and takes Ruth as his wife.','The nearer kinsman waives his right with the drawing off of a sandal; ten elders bear witness, the people bless Ruth like Rachel and Leah, and she bears Obed, grandfather of David.','The closing genealogy links the age of the judges to the house of David.','c. 1100–1060 BCE'),
('hannah-prays-at-shiloh','zh-CN','哈拿在示罗祈祷','不育的哈拿在示罗殿中默祷许愿,被祭司以利误认为醉酒。','她心中默祷,只动嘴唇不出声音,许愿若得男儿必将他终身归与耶和华,不用剃刀剃头;以利明白后为她祝福,哈拿就不再面带愁容。','为撒母耳的出生与献上作铺垫。','约公元前 1080–1050 年'),
('hannah-prays-at-shiloh','en','Hannah prays at Shiloh','The childless Hannah prays silently at the Shiloh sanctuary, and Eli the priest mistakes her for a drunkard.','Her lips move without sound as she vows that a son will be given to the Lord all his days, no razor touching his head; Eli, understanding, blesses her, and her face is no longer sad.','Prepares for the birth and dedication of Samuel.','c. 1080–1050 BCE'),
('birth-and-dedication-of-samuel','zh-CN','撒母耳出生并献于示罗','哈拿生撒母耳,断奶后带他上示罗归与耶和华。','哈拿说“这是我从耶和华那里求来的”,故给他起名撒母耳;还愿时献上公牛、细面与酒,并唱出“我的心因耶和华快乐”的颂歌。','撒母耳自幼在以利面前事奉,成为先知与士师之路的开端。','约公元前 1080–1050 年'),
('birth-and-dedication-of-samuel','en','Birth and dedication of Samuel','Hannah bears Samuel and, once he is weaned, brings him to Shiloh to be given to the Lord.','She names him Samuel, saying she asked him of the Lord; at the dedication she offers a bull, flour, and wine, and sings “My heart exults in the Lord.”','Samuel’s childhood service before Eli begins his path as prophet and judge.','c. 1080–1050 BCE'),
('god-calls-samuel-in-the-night','zh-CN','神在夜间呼唤撒母耳','童子撒母耳在殿中三次听见呼唤,以利指点他回答“请说,仆人敬听”。','当时耶和华的言语稀少,不常有默示;神向撒母耳宣告将审判以利家;从此撒母耳的话一句都不落空,全以色列都知道他被立为先知。','先知职分从以利家转向撒母耳的转折点。','约公元前 1070–1040 年'),
('god-calls-samuel-in-the-night','en','God calls Samuel in the night','The boy Samuel hears his name called three times in the temple, and Eli tells him to answer, “Speak, for your servant hears.”','The word of the Lord was rare in those days; God announces judgment on Eli’s house, and thereafter none of Samuel’s words fall to the ground, and all Israel knows him as a prophet.','The turning point that establishes Samuel as prophet in place of Eli’s house.','c. 1070–1040 BCE'),
('ark-captured-and-death-of-eli','zh-CN','约柜被掳与以利之死','以色列在亚弗附近战败,约柜被非利士人掳去,以利闻讯跌死。','何弗尼与非尼哈抬约柜上阵,以色列仍大败,二人阵亡;九十八岁目盲的以利听见“神的约柜被掳去”,从位上往后跌倒,折断颈项而死;他的儿媳临产,给孩子起名以迦博,说“荣耀离开以色列了”。','示罗圣所的时代就此终结。','约公元前 1060–1030 年'),
('ark-captured-and-death-of-eli','en','The ark captured and the death of Eli','Israel is routed near Aphek, the ark of God is taken, and Eli dies at the news.','Hophni and Phinehas carry the ark into battle and are killed as Israel falls; blind Eli, ninety-eight, falls backward from his seat and breaks his neck on hearing “the ark of God is captured”; his daughter-in-law names her child Ichabod, “the glory has departed.”','The era of the Shiloh sanctuary comes to an end.','c. 1060–1030 BCE'),
('ark-returned-to-israel','zh-CN','约柜归回以色列','非利士人因灾祸将约柜放上牛车送回,母牛直行到伯示麦。','约柜在非利士诸城引发灾祸七个月;他们以五个金痔疮与五个金老鼠为赔罪礼,两头未负轭的母牛拉车直奔伯示麦的大道,田间收麦的人举目看见就欢喜。','叙事强调约柜的归回并非出于人的安排。','约公元前 1060–1030 年'),
('ark-returned-to-israel','en','The ark returns to Israel','Plagued by disasters, the Philistines send the ark back on a cart, and the cows go straight to Beth-shemesh.','After seven months of afflictions in the Philistine cities, golden tumors and golden mice accompany the ark as a guilt offering; two unyoked milk cows pull the cart straight up the road to Beth-shemesh, and the reapers in the wheat harvest rejoice at the sight.','The narrative stresses that the ark’s return was beyond human steering.','c. 1060–1030 BCE'),
('israel-repents-at-mizpah','zh-CN','米斯巴的悔改','撒母耳在米斯巴召聚以色列人禁食认罪,除掉外邦神像。','众人打水浇在耶和华面前,当日禁食认罪;非利士人趁机上来攻击,耶和华大发雷声使其溃乱;撒母耳立石起名以便以谢,说“到如今耶和华都帮助我们”。','标志撒母耳作士师治理以色列的确立。','约公元前 1050–1030 年'),
('israel-repents-at-mizpah','en','Israel repents at Mizpah','Samuel gathers Israel at Mizpah to fast, confess, and put away the foreign gods.','Water is poured out before the Lord amid fasting and confession; when the Philistines come up to attack, the Lord thunders them into confusion, and Samuel sets up the stone Ebenezer, saying, “Till now the Lord has helped us.”','Marks the establishment of Samuel’s judgeship over Israel.','c. 1050–1030 BCE')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS (reuse jericho, bethel, hazor, ophrah-reference,
--    mount-gilboa, canaan-shechem, mizpah-of-gilead, zorah, plains-of-moab,
--    bethlehem, shiloh, mizpah-of-benjamin)
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('ehud-kills-eglon','jericho'),
('deborah-rises-as-judge','bethel'),
('jael-kills-sisera','hazor'),
('gideon-called-and-tears-down-baal-altar','ophrah-reference'),
('gideon-night-attack-with-three-hundred','mount-gilboa'),
('abimelech-and-jothams-parable','canaan-shechem'),
('jephthah-vow-and-his-daughter','mizpah-of-gilead'),
('birth-of-samson-foretold','zorah'),
('samson-lion-and-riddle','zorah'),
('samson-foxes-and-firebrands','zorah'),
('samson-jawbone-at-lehi','zorah'),
('naomi-bereaved-in-moab','plains-of-moab'),
('ruth-gleans-in-boaz-field','bethlehem'),
('boaz-redeems-ruth-at-the-gate','bethlehem'),
('hannah-prays-at-shiloh','shiloh'),
('birth-and-dedication-of-samuel','shiloh'),
('god-calls-samuel-in-the-night','shiloh'),
('ark-captured-and-death-of-eli','shiloh'),
('ark-returned-to-israel','zorah'),
('israel-repents-at-mizpah','mizpah-of-benjamin')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('ehud-kills-eglon','ehud',0),('ehud-kills-eglon','eglon',1),
('deborah-rises-as-judge','deborah',0),
('jael-kills-sisera','jael',0),('jael-kills-sisera','sisera',1),
('gideon-called-and-tears-down-baal-altar','gideon',0),
('gideon-night-attack-with-three-hundred','gideon',0),
('abimelech-and-jothams-parable','gideon',0),
('jephthah-vow-and-his-daughter','jephthah',0),
('birth-of-samson-foretold','manoah',0),('birth-of-samson-foretold','samson',1),
('samson-lion-and-riddle','samson',0),
('samson-foxes-and-firebrands','samson',0),
('samson-jawbone-at-lehi','samson',0),
('naomi-bereaved-in-moab','naomi',0),('naomi-bereaved-in-moab','ruth',1),
('ruth-gleans-in-boaz-field','ruth',0),('ruth-gleans-in-boaz-field','boaz',1),('ruth-gleans-in-boaz-field','naomi',2),
('boaz-redeems-ruth-at-the-gate','boaz',0),('boaz-redeems-ruth-at-the-gate','ruth',1),('boaz-redeems-ruth-at-the-gate','naomi',2),
('hannah-prays-at-shiloh','hannah',0),('hannah-prays-at-shiloh','eli',1),('hannah-prays-at-shiloh','elkanah',2),
('birth-and-dedication-of-samuel','samuel',0),('birth-and-dedication-of-samuel','hannah',1),('birth-and-dedication-of-samuel','elkanah',2),('birth-and-dedication-of-samuel','eli',3),
('god-calls-samuel-in-the-night','samuel',0),('god-calls-samuel-in-the-night','eli',1),
('ark-captured-and-death-of-eli','eli',0),('ark-captured-and-death-of-eli','samuel',1),
('ark-returned-to-israel','samuel',0),
('israel-repents-at-mizpah','samuel',0)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES (Judges / Ruth / Samuel, per event)
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Judges'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN (
 'ehud-kills-eglon','deborah-rises-as-judge','jael-kills-sisera',
 'gideon-called-and-tears-down-baal-altar','gideon-night-attack-with-three-hundred',
 'abimelech-and-jothams-parable','jephthah-vow-and-his-daughter',
 'birth-of-samson-foretold','samson-lion-and-riddle','samson-foxes-and-firebrands','samson-jawbone-at-lehi')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Ruth'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN (
 'naomi-bereaved-in-moab','ruth-gleans-in-boaz-field','boaz-redeems-ruth-at-the-gate')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Samuel'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN (
 'hannah-prays-at-shiloh','birth-and-dedication-of-samuel','god-calls-samuel-in-the-night',
 'ark-captured-and-death-of-eli','ark-returned-to-israel','israel-repents-at-mizpah')
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS
-- -------------------------------------------------------------------------
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('73000000-0000-4000-8005-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'ehud','eglon','adversary','source_to_target','negative',4,'ended',NULL,'ehud-kills-eglon'),
(2,'jael','sisera','adversary','source_to_target','negative',4,'ended',NULL,'jael-kills-sisera'),
(3,'barak','sisera','adversary','bidirectional','negative',4,'ended',NULL,'jael-kills-sisera'),
(4,'elkanah','hannah','spouse','bidirectional','positive',4,'unknown',NULL,NULL),
(5,'hannah','samuel','family','source_to_target','positive',4,'unknown','birth-and-dedication-of-samuel',NULL),
(6,'elkanah','samuel','family','source_to_target','positive',3,'unknown','birth-and-dedication-of-samuel',NULL),
(7,'eli','samuel','mentor','source_to_target','positive',4,'ended','birth-and-dedication-of-samuel','ark-captured-and-death-of-eli'),
(8,'naomi','ruth','family','bidirectional','positive',4,'unknown',NULL,NULL),
(9,'manoah','samson','family','source_to_target','positive',3,'unknown',NULL,NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000005'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 10. GROUP MEMBERSHIP (existing group judges-circle)
-- -------------------------------------------------------------------------
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g JOIN (VALUES
('judges-circle','ehud'),('judges-circle','eglon'),('judges-circle','jael'),('judges-circle','sisera'),
('judges-circle','jephthah'),('judges-circle','naomi'),('judges-circle','eli'),
('judges-circle','hannah'),('judges-circle','elkanah'),('judges-circle','manoah')
) AS v(gslug,cslug)
ON g.slug=v.gslug JOIN characters c ON c.slug=v.cslug AND c.work_id=g.work_id
WHERE g.work_id='10000000-0000-4000-8000-000000000005' ON CONFLICT DO NOTHING;

COMMIT;
