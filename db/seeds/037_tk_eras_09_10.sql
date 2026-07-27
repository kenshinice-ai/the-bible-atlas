BEGIN;

-- Three Kingdoms era seed: KK=09 northern-expeditions (228-234) and KK=10
-- wei-court-and-regency (235-254), Records (志) + Romance (演义) in one file
-- per blueprint/WORK_TEMPLATE.md and blueprint/EXAMPLE_THREE_KINGDOMS.md.
-- Builds on db/seeds/031 (works/chapters/groups/sources) and db/seeds/032
-- (shared anchor cast + gazetteer: zhuge-liang, sima-yi, liu-shan, jiang-wei,
-- cao-pi, and the 38 real-world locations incl. jieting/chencang/wuzhang-plains
-- /hanzhong/luoyang/chengdu/jiange, all already loaded).
--
-- UUID namespace (new, unused before this seed; KK = 09 or 10 embedded in the
-- 4th group as "80KK", per this task's explicit assignment):
--   characters (secondary, era-owned)  4{6|7}000000-0000-4000-80KK-0000000000NN
--   locations  (minor, era-owned)      3{6|7}000000-0000-4000-80KK-0000000000NN
--   events                             6{4|5}000000-0000-4000-80KK-0000000000NN
--   character_relations                7{4|5}000000-0000-4000-80KK-0000000000NN
-- (4/5 = Records/Romance secondary-entity prefixes; anchors from 032 already
-- occupy 44/45 and 34/35, so this file uses the neighbouring 46/47 and 36/37
-- to avoid collision; events/relations have no prior occupant.)
--
-- cao-pi (曹丕) is NOT touched here: he died in 226, belongs to KK=08, and is
-- only ever an anchor reference elsewhere -- not used as a participant in
-- this era's events.

-- ============================================================
-- 1. CHARACTERS (7 secondary figures: 4 for KK=09, 3 for KK=10)
-- ============================================================

INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
-- Records (志) -- KK=09
('46000000-0000-4000-8009-000000000001','10000000-0000-4000-8000-000000000006','ma-su',900,'male','adult','supporting','historical',190,228,'teacher',3),
('46000000-0000-4000-8009-000000000002','10000000-0000-4000-8000-000000000006','wei-yan',901,'male','adult','supporting','historical',NULL,234,'soldier',3),
('46000000-0000-4000-8009-000000000003','10000000-0000-4000-8000-000000000006','wang-ping',902,'male','adult','supporting','historical',NULL,248,'soldier',2),
('46000000-0000-4000-8009-000000000004','10000000-0000-4000-8000-000000000006','zhang-he',903,'male','adult','antagonist','historical',NULL,231,'soldier',3),
-- Records (志) -- KK=10
('46000000-0000-4000-8010-000000000001','10000000-0000-4000-8000-000000000006','cao-rui',1000,'male','adult','historical','historical',204,239,'king',3),
('46000000-0000-4000-8010-000000000002','10000000-0000-4000-8000-000000000006','cao-shuang',1001,'male','adult','antagonist','historical',NULL,249,'person',3),
('46000000-0000-4000-8010-000000000003','10000000-0000-4000-8000-000000000006','sima-shi',1002,'male','adult','antagonist','historical',208,255,'teacher',3),
-- Romance (演义) -- KK=09
('47000000-0000-4000-8009-000000000001','10000000-0000-4000-8000-000000000007','ma-su',900,'male','adult','supporting','fictionalised_historical',190,228,'teacher',3),
('47000000-0000-4000-8009-000000000002','10000000-0000-4000-8000-000000000007','wei-yan',901,'male','adult','supporting','fictionalised_historical',NULL,234,'soldier',3),
('47000000-0000-4000-8009-000000000003','10000000-0000-4000-8000-000000000007','wang-ping',902,'male','adult','supporting','fictionalised_historical',NULL,248,'soldier',2),
('47000000-0000-4000-8009-000000000004','10000000-0000-4000-8000-000000000007','zhang-he',903,'male','adult','antagonist','fictionalised_historical',NULL,231,'soldier',3),
-- Romance (演义) -- KK=10
('47000000-0000-4000-8010-000000000001','10000000-0000-4000-8000-000000000007','cao-rui',1000,'male','adult','historical','fictionalised_historical',204,239,'king',3),
('47000000-0000-4000-8010-000000000002','10000000-0000-4000-8000-000000000007','cao-shuang',1001,'male','adult','antagonist','fictionalised_historical',NULL,249,'person',3),
('47000000-0000-4000-8010-000000000003','10000000-0000-4000-8000-000000000007','sima-shi',1002,'male','adult','antagonist','fictionalised_historical',208,255,'teacher',3)
ON CONFLICT DO NOTHING;

-- Records (志) voice -- 志载/传称.
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,'','' FROM characters c JOIN (VALUES
('ma-su','zh-CN','马谡',ARRAY['幼常']::text[],'蜀汉参军，马良之弟，襄阳宜城人，好论军计，建兴六年违亮节度，街亭败绩，下狱物故，亮为之流涕。'),
('ma-su','en','Ma Su',ARRAY['Youchang']::text[],'A staff officer of Shu Han and younger brother of Ma Liang, a native of Yicheng in Xiangyang known for military discourse; in 228 he disobeyed Zhuge Liang''s dispositions, was routed at Jieting, and died in custody, for which Liang wept.'),
('wei-yan','zh-CN','魏延',ARRAY['文长']::text[],'蜀汉征西大将军，义阳人，以部曲随先主入蜀，屡立战功，建兴十二年亮卒于军，延与杨仪不协，举兵相攻，兵败被杀。'),
('wei-yan','en','Wei Yan',ARRAY['Wenchang']::text[],'General-in-Chief Who Chastises the West under Shu Han, a native of Yiyang who followed Liu Bei into Shu with his own troops and won repeated distinction; after Zhuge Liang died on campaign in 234, his dispute with Yang Yi turned to armed conflict, and he was killed in defeat.'),
('wang-ping','zh-CN','王平',ARRAY['子均']::text[],'蜀汉安汉将军，巴西宕渠人，本魏将，归先主，建兴六年街亭之役独整部众不败，后累迁镇北大将军，延熙十一年卒。'),
('wang-ping','en','Wang Ping',ARRAY['Zijun']::text[],'General Who Pacifies Han under Shu Han, a native of Dangqu in Baxi who had served Wei before submitting to Liu Bei; at Jieting in 228 he alone kept his troops in order amid the rout, later rising to General Who Guards the North before his death in 248.'),
('zhang-he','zh-CN','张郃',ARRAY['儁乂']::text[],'魏征西车骑将军，河间鄚人，本袁绍将，归太祖，善处营陈，建兴六年大破马谡于街亭，太和五年追蜀军于木门为流矢所中而卒。'),
('zhang-he','en','Zhang He',ARRAY['Junyi']::text[],'Cavalry General Who Chastises the West under Wei, a native of Mo in Hejian who had served Yuan Shao before joining Cao Cao, skilled in tactical deployment; he crushed Ma Su at Jieting in 228, and died from a stray arrow while pursuing the Shu army at Mumen in 231.'),
('cao-rui','zh-CN','曹睿',ARRAY['元仲']::text[],'魏明帝，文帝长子，黄初七年即位，屡拒诸葛亮北伐，营宫室、备边防，景初三年崩，遗诏司马懿、曹爽辅政。'),
('cao-rui','en','Cao Rui',ARRAY['Yuanzhong']::text[],'Emperor Ming of Wei, Cao Pi''s eldest son, who succeeded him in 226, repeatedly repelled Zhuge Liang''s northern campaigns and undertook palace building and frontier defence, dying in 239 with a testamentary edict appointing Sima Yi and Cao Shuang as regents.'),
('cao-shuang','zh-CN','曹爽',ARRAY['昭伯']::text[],'魏大将军，曹真之子，明帝崩后与司马懿同受遗诏辅政，专擅朝政，排抑司马懿，嘉平元年高平陵之变为懿所诛，夷灭三族。'),
('cao-shuang','en','Cao Shuang',ARRAY['Zhaobo']::text[],'Grand General of Wei, son of Cao Zhen, who co-received the regency mandate with Sima Yi upon Emperor Ming''s death and then monopolised court power while sidelining his colleague; killed by Sima Yi in the Gaoping Tombs incident of 249, his clan exterminated to the third degree.'),
('sima-shi','zh-CN','司马师',ARRAY['子元']::text[],'魏大将军，司马懿长子，助父谋诛曹爽，懿卒后代总国政，嘉平六年废齐王芳，立高贵乡公，正元二年卒。'),
('sima-shi','en','Sima Shi',ARRAY['Ziyuan']::text[],'Grand General of Wei, Sima Yi''s eldest son, who helped his father plan the destruction of Cao Shuang; on Sima Yi''s death he took over the government, deposed Prince of Qi Cao Fang in 254 to install the Duke of Gaogui, and died in 255.')
) AS v(slug,locale,name,aliases,summary) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000006'
WHERE c.id::text LIKE '46000000-0000-4000-8009%' OR c.id::text LIKE '46000000-0000-4000-8010%';

-- Romance (演义) voice -- 小说叙写.
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,'','' FROM characters c JOIN (VALUES
('ma-su','zh-CN','马谡',ARRAY['幼常']::text[],'马良之弟，自幼熟读兵书，孔明素爱其才，街亭一役刚愎自用、弃水上山，致大军溃败，孔明挥泪斩之以正军法。'),
('ma-su','en','Ma Su',ARRAY['Youchang']::text[],'Younger brother of Ma Liang, steeped in military texts since youth and long favoured by Kongming; at Jieting his stubborn insistence on camping atop the hill against orders led to disaster, and Kongming wept as he ordered his execution to uphold military law.'),
('wei-yan','zh-CN','魏延',ARRAY['文长']::text[],'天生反骨（演义虚构之相术之说），屡献奇谋而孔明每每不用，孔明临终定计，身后果与杨仪相争，兵败马岱斩之。'),
('wei-yan','en','Wei Yan',ARRAY['Wenchang']::text[],'Said in the novel to bear a rebellious bone from birth, he repeatedly proposed daring stratagems that Kongming always declined; true to Kongming''s dying plan, he later clashed with Yang Yi and was cut down by Ma Dai in defeat.'),
('wang-ping','zh-CN','王平',ARRAY['子均']::text[],'不识字而通兵法，街亭战前力谏马谡下寨当道，谡不听，平独率所部严整不乱，后累立战功，位至镇北大将军。'),
('wang-ping','en','Wang Ping',ARRAY['Zijun']::text[],'Unlettered yet versed in tactics, he urged Ma Su before Jieting to camp astride the road; when Ma Su refused, Wang Ping alone kept his own troops in disciplined order, and went on to rise to General Who Guards the North.'),
('zhang-he','zh-CN','张郃',ARRAY['儁乂']::text[],'魏之名将，深通兵机，街亭一战断蜀军汲水之道，大破马谡，后追蜀军至木门道，中伏中箭而亡，孔明设伏之谋终获一将。'),
('zhang-he','en','Zhang He',ARRAY['Junyi']::text[],'A celebrated Wei general deeply versed in tactics, who cut off the Shu army''s water supply at Jieting to crush Ma Su; pursuing the retreating Shu forces to the Wooden Gate Trail, he fell into an ambush and died of an arrow wound, Kongming''s stratagem claiming one general at last.'),
('cao-rui','zh-CN','曹睿',ARRAY['元仲']::text[],'曹丕之子，即位后倚重司马懿御蜀，然亦猜忌其权，临终托孤，命司马懿与曹爽共辅幼主曹芳。'),
('cao-rui','en','Cao Rui',ARRAY['Yuanzhong']::text[],'Cao Pi''s son, who upon succeeding him relied on Sima Yi to hold off Shu yet also grew wary of his power, on his deathbed entrusting the boy emperor Cao Fang to the joint regency of Sima Yi and Cao Shuang.'),
('cao-shuang','zh-CN','曹爽',ARRAY['昭伯']::text[],'明帝托孤重臣，恃宠专权，尽逐司马懿党羽，日事游猎享乐，终为懿装病所惑，高平陵一变阖族被诛。'),
('cao-shuang','en','Cao Shuang',ARRAY['Zhaobo']::text[],'Entrusted as regent by Emperor Ming, he grew arrogant with power, purged Sima Yi''s allies, and gave himself over to hunting and pleasure, until Sima Yi''s feigned illness lulled him into the Gaoping Tombs trap that destroyed his entire clan.'),
('sima-shi','zh-CN','司马师',ARRAY['子元']::text[],'司马懿长子，深沉有谋，暗中操练死士三千，助父诛曹爽，父殁后总揽魏政，废曹芳，立曹髦，威权更盛于父。'),
('sima-shi','en','Sima Shi',ARRAY['Ziyuan']::text[],'Sima Yi''s eldest son, deep and resourceful, who secretly trained three thousand loyal soldiers and helped his father destroy Cao Shuang; after his father''s death he took full control of Wei''s government, deposed Cao Fang, installed Cao Mao, and wielded even greater authority than his father had.')
) AS v(slug,locale,name,aliases,summary) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000007'
WHERE c.id::text LIKE '47000000-0000-4000-8009%' OR c.id::text LIKE '47000000-0000-4000-8010%';

-- ============================================================
-- 2. LOCATIONS (2 minor sites: Qishan for KK=09, Gaoping Tombs for KK=10)
-- ============================================================

INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('36000000-0000-4000-8009-000000000001','10000000-0000-4000-8000-000000000006','qishan','real',ST_GeogFromText('POINT(105.0500 34.0200)'),NULL,NULL,900,'landmark','approximate',12,'CN',true,true),
('36000000-0000-4000-8010-000000000001','10000000-0000-4000-8000-000000000006','gaoping-tombs','real',ST_GeogFromText('POINT(112.4200 34.2000)'),NULL,NULL,1000,'landmark','inferred',13,'CN',true,true),
('37000000-0000-4000-8009-000000000001','10000000-0000-4000-8000-000000000007','qishan','real',ST_GeogFromText('POINT(105.0500 34.0200)'),NULL,NULL,900,'landmark','approximate',12,'CN',true,true),
('37000000-0000-4000-8010-000000000001','10000000-0000-4000-8000-000000000007','gaoping-tombs','real',ST_GeogFromText('POINT(112.4200 34.2000)'),NULL,NULL,1000,'landmark','inferred',13,'CN',true,true)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,status,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',ARRAY[]::text[],'','','','',v.region FROM locations l JOIN (VALUES
('qishan','10000000-0000-4000-8000-000000000006','zh-CN','祁山','汉阳西县境内山地，诸葛亮历次北伐出兵要道，志载亮"由斜谷道"及"出祁山"皆见于此。','凉州汉阳郡'),
('qishan','10000000-0000-4000-8000-000000000006','en','Mount Qi','A highland route in Xi County, Hanyang Commandery, the corridor Zhuge Liang''s campaigns repeatedly used to advance on Wei; the Records notes his armies "issuing forth from Qishan."','Hanyang Commandery, Liangzhou'),
('gaoping-tombs','10000000-0000-4000-8000-000000000006','zh-CN','高平陵','魏明帝陵寝，在洛阳城南，嘉平元年曹爽奉齐王芳出城谒陵，司马懿乘虚闭城举兵，史称高平陵之变。','司隶河南尹'),
('gaoping-tombs','10000000-0000-4000-8000-000000000006','en','Gaoping Tombs','The mausoleum of Emperor Ming of Wei south of Luoyang; when Cao Shuang escorted the young emperor there in 249, Sima Yi sealed the capital and seized power in what history calls the Gaoping Tombs incident.','Henan Commandery, Sili'),
('qishan','10000000-0000-4000-8000-000000000007','zh-CN','祁山','小说中孔明六出祁山之地，据险扎营、屯田练兵，蜀军北伐必经之地。','凉州汉阳郡'),
('qishan','10000000-0000-4000-8000-000000000007','en','Mount Qi','The site the novel names in "six expeditions through Qishan," where Kongming fortified camps and drilled troops on his repeated northern campaigns.','Hanyang Commandery, Liangzhou'),
('gaoping-tombs','10000000-0000-4000-8000-000000000007','zh-CN','高平陵','小说叙写曹爽挟主谒陵行猎，城中司马懿装病多时忽然发难，一举夺魏室兵权。','司隶河南尹'),
('gaoping-tombs','10000000-0000-4000-8000-000000000007','en','Gaoping Tombs','Where the novel has Cao Shuang lead the young emperor out to hunt near the tomb, only for the long-feigning Sima Yi to strike from the sealed capital and seize Wei''s military power in a single stroke.','Henan Commandery, Sili')
) AS v(slug,work_id,locale,name,summary,region) ON l.slug=v.slug AND l.work_id=v.work_id::uuid;

-- ============================================================
-- 3. EVENTS
-- ============================================================

-- KK=09 Records (6 events)
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('64000000-0000-4000-8009-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,'range'::event_time_type,'julian'::calendar_system,v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'first-expedition-through-qishan',9001,'verified_historical','battle',228,228,'high'),
(2,'loss-of-jieting',9003,'verified_historical','battle',228,228,'high'),
(3,'ma-su-executed-in-tears',9007,'verified_historical','death',228,228,'high'),
(4,'second-memorial-on-the-expedition',9009,'contested','political',228,228,'low'),
(5,'wooden-ox-and-flowing-horse',9011,'reported_historical','discovery',231,231,'medium'),
(6,'death-at-wuzhang-plains',9015,'verified_historical','death',234,234,'high')
) AS v(n,slug,seq,reality,etype,y1,y2,conf)
JOIN chapters ch ON ch.slug='northern-expeditions' AND ch.work_id='10000000-0000-4000-8000-000000000006';

-- KK=09 Romance (8 events)
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('65000000-0000-4000-8009-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,'range'::event_time_type,'julian'::calendar_system,v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'first-expedition-through-qishan',9001,'fictional_with_historical_context','battle',228,228,'medium'),
(2,'loss-of-jieting',9003,'fictional_with_historical_context','battle',228,228,'medium'),
(3,'empty-fort-strategy',9005,'fictional_narrative','other',228,228,'low'),
(4,'ma-su-executed-in-tears',9007,'fictional_with_historical_context','death',228,228,'medium'),
(5,'second-memorial-on-the-expedition',9009,'fictional_with_historical_context','political',228,228,'medium'),
(6,'wooden-ox-and-flowing-horse',9011,'legendary_or_mythic','discovery',231,231,'low'),
(7,'prayer-to-extend-life-at-wuzhang-plains',9013,'legendary_or_mythic','religious',234,234,'low'),
(8,'death-at-wuzhang-plains',9015,'fictional_with_historical_context','death',234,234,'medium')
) AS v(n,slug,seq,reality,etype,y1,y2,conf)
JOIN chapters ch ON ch.slug='northern-expeditions' AND ch.work_id='10000000-0000-4000-8000-000000000007';

-- KK=10 Records (7 events)
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('64000000-0000-4000-8010-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,'range'::event_time_type,'julian'::calendar_system,v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'cao-rui-and-the-wei-succession',10001,'reported_historical','political',235,239,'medium'),
(2,'cao-shuang-seizes-the-regency',10005,'verified_historical','political',239,244,'high'),
(3,'sima-yi-feigns-illness',10009,'verified_historical','other',247,249,'high'),
(4,'gaoping-tombs-incident',10013,'verified_historical','political',249,249,'high'),
(5,'execution-of-the-cao-shuang-faction',10015,'verified_historical','death',249,249,'high'),
(6,'sima-shi-succeeds-sima-yi',10017,'verified_historical','political',251,251,'high'),
(7,'sima-shi-deposes-emperor-fang',10019,'verified_historical','political',254,254,'high')
) AS v(n,slug,seq,reality,etype,y1,y2,conf)
JOIN chapters ch ON ch.slug='wei-court-and-regency' AND ch.work_id='10000000-0000-4000-8000-000000000006';

-- KK=10 Romance (10 events)
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('65000000-0000-4000-8010-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,'range'::event_time_type,'julian'::calendar_system,v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'cao-rui-and-the-wei-succession',10001,'fictional_with_historical_context','political',235,239,'medium'),
(2,'dead-zhuge-liang-routs-living-sima',10003,'legendary_or_mythic','other',234,234,'low'),
(3,'cao-shuang-seizes-the-regency',10005,'fictional_with_historical_context','political',239,244,'medium'),
(4,'cao-shuang-indulges-in-power',10007,'fictional_with_historical_context','social',244,249,'low'),
(5,'sima-yi-feigns-illness',10009,'fictional_with_historical_context','other',247,249,'medium'),
(6,'sima-yi-plots-with-his-sons',10011,'fictional_with_historical_context','political',248,248,'low'),
(7,'gaoping-tombs-incident',10013,'fictional_with_historical_context','political',249,249,'medium'),
(8,'execution-of-the-cao-shuang-faction',10015,'fictional_with_historical_context','death',249,249,'medium'),
(9,'sima-shi-succeeds-sima-yi',10017,'fictional_with_historical_context','political',251,251,'medium'),
(10,'sima-shi-deposes-emperor-fang',10019,'fictional_with_historical_context','political',254,254,'medium')
) AS v(n,slug,seq,reality,etype,y1,y2,conf)
JOIN chapters ch ON ch.slug='wei-court-and-regency' AND ch.work_id='10000000-0000-4000-8000-000000000007';

-- ============================================================
-- 4. EVENT TRANSLATIONS
-- ============================================================

-- KK=09 Records (志载/传称 voice)
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('first-expedition-through-qishan','zh-CN','诸葛亮首出祁山','建兴六年，诸葛亮率军出祁山，天水、南安、安定三郡响应，姜维亦于此役归蜀。','亮扬言由斜谷取郿，遣赵云、邓芝为疑军据箕谷，自率大军攻祁山；魏明帝西镇长安，遣张郃拒亮，天水太守闻讯弃城，姜维等降蜀。','蜀汉北伐正式开启，姜维自此归入蜀汉阵营。','蜀汉建兴六年（228年）'),
('first-expedition-through-qishan','en','Zhuge Liang''s first expedition through Qishan','In 228 Zhuge Liang led his army out through Qishan; Tianshui, Nan''an, and Anding commanderies responded, and Jiang Wei surrendered to Shu during the campaign.','Liang announced a feint toward Mei via the Xie Valley, sending Zhao Yun and Deng Zhi to hold Ji Valley as a diversion while he led the main force against Qishan; Emperor Ming moved west to Chang''an and sent Zhang He to oppose him, and as Tianshui''s governor fled, Jiang Wei and others submitted to Shu.','Formally opens Shu Han''s northern campaigns and brings Jiang Wei into Shu''s service.','228 CE (Shu Han''s sixth year of Jianxing)'),
('loss-of-jieting','zh-CN','街亭失守','马谡违亮节度，舍水上山，为张郃所破，街亭失守，蜀军前锋尽没。','亮令马谡督诸军在前，与郃战于街亭；谡舍水上山，举措烦扰，郃绝其汲道，击大破之，士卒离散，亮拔西县千余家还汉中。','首次北伐因街亭之失而全线撤退，是役成为北伐成败的转折点。','蜀汉建兴六年（228年）'),
('loss-of-jieting','en','The loss of Jieting','Ma Su disobeyed Zhuge Liang''s dispositions, camped on the hill away from water, and was crushed by Zhang He, losing Jieting and the vanguard of Shu''s army.','Liang had put Ma Su in command of the vanguard to face Zhang He at Jieting; Ma Su abandoned the water source to camp on high ground in disorderly fashion, and Zhang He cut off his water supply and routed him utterly, so that Liang withdrew a thousand households from Xi County back to Hanzhong.','The loss of Jieting forces a full retreat and becomes the turning point of the first expedition.','228 CE (Shu Han''s sixth year of Jianxing)'),
('ma-su-executed-in-tears','zh-CN','挥泪斩马谡','街亭败绩，亮上表自贬，收马谡下狱，谡于狱中物故，亮为之流涕。','亮既拔军还汉中，戮马谡以谢众，谡下狱物故，亮自临祭，待其遗孤如平生；亮亦上疏自贬三等，行右将军事。','依法治军、赏罚分明的著名事例，亦见亮引咎自责之态。','蜀汉建兴六年（228年）'),
('ma-su-executed-in-tears','en','Ma Su executed in tears','After the defeat at Jieting, Liang had Ma Su imprisoned; Ma Su died in custody, and Liang wept for him.','Withdrawing to Hanzhong, Liang executed Ma Su to answer for the defeat; Ma Su died in prison, and Liang mourned him personally and cared for his orphaned children as before, while also petitioning to demote himself three ranks.','A celebrated case of strict military law applied even to a favored subordinate, alongside Liang''s own self-reproach.','228 CE (Shu Han''s sixth year of Jianxing)'),
('second-memorial-on-the-expedition','zh-CN','后出师表','建兴六年冬，亮将再举，上表言北伐不可不为，然此表是否亮所自作，裴注所引颇存争议。','裴松之注引《汉晋春秋》载亮上此表，历数"六未解"以明北伐之不得已，然表不见于亮本传及《诸葛亮集》，学者多疑为后人所托。','志载存疑之文本，反映史料考订的复杂性。','蜀汉建兴六年冬（228年）'),
('second-memorial-on-the-expedition','en','The Second Memorial on the Expedition','In the winter of 228, before renewing the campaign, Liang is said to have submitted a memorial arguing the expeditions could not be abandoned, though its authenticity is disputed.','Pei Songzhi''s commentary quotes the Han-Jin Annals as preserving this memorial, which lists six reasons the campaign must continue; it does not appear in Liang''s own biography or his collected works, and many scholars suspect it was attributed to him later.','A textually disputed document that illustrates the complexities of source criticism.','Winter 228 CE (Shu Han''s sixth year of Jianxing)'),
('wooden-ox-and-flowing-horse','zh-CN','造木牛流马','亮为解运粮之难，造木牛流马以给军食，用于其后诸次出师转运。','亮性长于巧思，损益连弩、木牛流马，皆出其意；志载其法后世多不能详，然当时颇济军运之急。','体现亮治军兼擅工巧、注重后勤的一面。','蜀汉建兴九年（231年）'),
('wooden-ox-and-flowing-horse','en','Wooden ox and flowing horse','To ease the difficulty of grain transport, Liang devised the wooden ox and flowing horse to supply his armies on later campaigns.','Liang was noted for his mechanical ingenuity, improving the repeating crossbow and devising the wooden ox and flowing horse; the Records notes that later generations could not fully reconstruct their design, though they eased the army''s supply problems at the time.','Shows Liang''s skill in engineering alongside strategy, easing the logistics of sustained campaigning.','231 CE (Shu Han''s ninth year of Jianxing)'),
('death-at-wuzhang-plains','zh-CN','秋风五丈原','建兴十二年，亮出屯五丈原，与司马懿相持渭南，因积劳病笃，卒于军中，年五十四。','亮率大军由斜谷出，据五丈原，分兵屯田，为久驻之基；相持百余日，懿坚壁不战，亮病笃，卒于军，蜀军密不发丧，整军而退，百姓为之谚曰"死诸葛走生仲达"。','五次北伐至此终结，亮身后蜀汉再未克复关中。','蜀汉建兴十二年（234年）'),
('death-at-wuzhang-plains','en','Death at Wuzhang Plains','In 234 Liang camped at Wuzhang Plains, facing Sima Yi across the Wei River; worn down by exhaustion, he died in camp at fifty-four.','Liang led his army out through the Xie Valley to hold Wuzhang Plains, dividing his troops to farm the land for a long campaign; after over a hundred days of stalemate with Sima Yi refusing battle, Liang fell gravely ill and died in camp, and Shu withdrew in careful order without announcing his death, giving rise to the popular saying that "the dead Zhuge routed the living Zhongda."','Closes the five northern campaigns; Shu never again recovered the Guanzhong region after Liang''s death.','234 CE (Shu Han''s twelfth year of Jianxing)')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000006';

-- KK=09 Romance (小说叙写 voice)
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('first-expedition-through-qishan','zh-CN','孔明一出祁山','小说叙写孔明六出祁山之首战，兵出祁山，天水城下智收姜维，一时声势大振。','孔明设疑兵于箕谷，自领大军直取祁山，又用计于天水城下收服姜维为徒，蜀军声威一时无两。','六出祁山的开篇，也是孔明收得爱徒姜维的关键一役。','蜀汉建兴六年（228年）'),
('first-expedition-through-qishan','en','Kongming''s first expedition through Qishan','The novel opens its account of the six expeditions with this first march on Qishan, where Kongming cleverly wins over Jiang Wei outside Tianshui.','Kongming sets a decoy force at Ji Valley and leads the main army straight for Qishan, then contrives to win Jiang Wei''s allegiance beneath the walls of Tianshui, and Shu''s momentum swells.','The opening chapter of the six expeditions and the campaign that brings Kongming his prized disciple Jiang Wei.','228 CE (Shu Han''s sixth year of Jianxing)'),
('loss-of-jieting','zh-CN','失街亭','马谡自恃通晓兵法，弃水上山扎寨，王平力谏不听，终为张郃所破，街亭失陷。','马谡到街亭，见地势言当道扎营，王平谏其当道下寨，谡不听，径上山下寨，谓凭高视下、势如破竹；张郃断其水道，蜀军不战自乱，街亭遂失。','小说中北伐首挫的关键场景，为挥泪斩马谡铺垫。','蜀汉建兴六年（228年）'),
('loss-of-jieting','en','The loss of Jieting','Confident in his book learning, Ma Su ignores Wang Ping''s pleas and camps on the hilltop instead of astride the road, and Zhang He shatters his position.','Arriving at Jieting, Ma Su insists on camping atop the hill for commanding height despite Wang Ping''s urging to hold the road; Zhang He cuts the water supply, the Shu troops fall into disorder without a real fight, and Jieting is lost.','The key scene of the first expedition''s failure in the novel, setting up the tearful execution that follows.','228 CE (Shu Han''s sixth year of Jianxing)'),
('empty-fort-strategy','zh-CN','空城计','街亭既失，孔明退守西城，兵力空虚，乃大开城门、抚琴楼上，司马懿疑有伏兵，引兵退去。','司马懿引大军迫近西城，城中止余老弱，孔明命偃旗息鼓、大开四门，自坐城楼焚香抚琴，懿疑城中有伏，不敢轻进，引军退去。','小说虚构情节，塑造孔明临危不乱、料敌如神的形象。','蜀汉建兴六年（228年）'),
('empty-fort-strategy','en','The empty fort strategy','With Jieting lost and Xicheng nearly undefended, Kongming throws open the gates and plays his zither from the tower, and Sima Yi, suspecting an ambush, withdraws his army.','Sima Yi''s army closes on Xicheng, which holds only the old and the weak; Kongming orders the flags struck and drums silenced, throws open all four gates, and sits calmly on the tower burning incense and playing his zither, and Sima Yi, fearing a trap, dares not advance and pulls back.','A fictional episode that cements Kongming''s image as unshakeable and uncannily perceptive of his enemy.','228 CE (Shu Han''s sixth year of Jianxing)'),
('ma-su-executed-in-tears','zh-CN','挥泪斩马谡','孔明按军法斩马谡以正纲纪，行刑之际大哭不已，念其昔日之才。','孔明升帐，命将马谡斩首示众，谡临刑上书托付家小，孔明许之；斩讫，孔明痛哭不已，众问其故，答曰念先帝白帝城遗言"马谡言过其实，不可大用"，深恨己之不明。','小说中最具悲剧色彩的场景之一，凸显军法无情与孔明的自省。','蜀汉建兴六年（228年）'),
('ma-su-executed-in-tears','en','Ma Su executed in tears','Kongming has Ma Su beheaded to uphold military law, weeping bitterly at the execution as he recalls his former talent.','Kongming convenes his officers and orders Ma Su executed as an example; Ma Su, facing death, asks that his family be cared for, which Kongming grants, and afterward weeps without restraint, explaining that he now regrets ignoring the dying Liu Bei''s warning that Ma Su talked bigger than his abilities warranted.','One of the novel''s most tragic scenes, showing both the harshness of military law and Kongming''s self-reproach.','228 CE (Shu Han''s sixth year of Jianxing)'),
('second-memorial-on-the-expedition','zh-CN','后出师表','孔明再表后主，申明北伐之志，"鞠躬尽瘁，死而后已"之语出于此表。','孔明念先帝托孤之重、汉贼不两立之义，复上表后主，历陈六件难明之事，明言唯有北伐方能自保，遂再度出师。','小说中孔明忠悃之志的集中表达，"鞠躬尽瘁"成为其人格的注脚。','蜀汉建兴六年冬（228年）'),
('second-memorial-on-the-expedition','en','The Second Memorial on the Expedition','Kongming again petitions the Later Ruler to affirm his resolve to campaign north, in the memorial that gives rise to his famous vow to serve "until my strength is spent in death."','Mindful of the trust placed in him by the dying Liu Bei and the principle that Han and the usurpers cannot coexist, Kongming lays out six hard truths in a second memorial to the throne, arguing that only campaigning north can preserve Shu, and sets out again.','The novel''s fullest statement of Kongming''s loyalty, the source of the phrase that defines his character.','Winter 228 CE (Shu Han''s sixth year of Jianxing)'),
('wooden-ox-and-flowing-horse','zh-CN','木牛流马','孔明造木牛流马运粮，其形如活，不食水草，昼夜转运不绝，魏军见之惊为神物。','孔明按图造木牛流马，令蜀军搬运粮草往来剑阁、祁山之间，昼夜不绝；司马懿闻之遣人窃仿，反为孔明所算，粮草尽失。','小说渲染孔明用兵之奇，木牛流马成为其智慧的象征。','蜀汉建兴九年（231年）'),
('wooden-ox-and-flowing-horse','en','Wooden ox and flowing horse','Kongming builds wooden oxen and flowing horses to haul grain, moving as if alive without eating or drinking, running day and night between Jiange and Qishan to Wei''s astonishment.','Kongming builds the devices from his own designs and sets Shu troops hauling supplies between Jiange and Qishan around the clock; when Sima Yi has his men steal the design and copy it, Kongming turns the ruse against him and seizes Wei''s grain instead.','A vivid emblem in the novel of Kongming''s ingenuity in the art of war.','231 CE (Shu Han''s ninth year of Jianxing)'),
('prayer-to-extend-life-at-wuzhang-plains','zh-CN','五丈原禳星','孔明自知天命将终，于帐中设七星灯禳星祈寿，命姜维守护，魏延闯帐扑灭主灯，禳法遂败。','孔明于五丈原病笃，夜观将星欲坠，乃于帐中布七星灯，欲借斗祈禳延寿七年，命姜维守帐；届六日，魏延匆忙入报军情，误将主灯扑灭，孔明叹曰"死生有命，不可得而禳也"。','小说渲染孔明命数将尽的悲壮氛围，亦暗伏魏延日后之祸。','蜀汉建兴十二年（234年）'),
('prayer-to-extend-life-at-wuzhang-plains','en','The star ritual at Wuzhang Plains','Sensing his life is ending, Kongming sets seven lamps in his tent to pray for seven more years, with Jiang Wei standing guard, but Wei Yan bursts in and knocks out the main lamp, ruining the rite.','Gravely ill at Wuzhang Plains, Kongming sees his star about to fall and arranges seven lamps in a ritual to extend his life by seven years, setting Jiang Wei to guard the tent; on the sixth night Wei Yan rushes in with urgent news and accidentally extinguishes the central lamp, and Kongming sighs that life and death are fated and cannot be prayed away.','Heightens the novel''s tragic mood as Kongming''s fate closes in, and quietly foreshadows Wei Yan''s own downfall.','234 CE (Shu Han''s twelfth year of Jianxing)'),
('death-at-wuzhang-plains','zh-CN','秋风五丈原','孔明禳星不成，自知大限已至，安排后事，秋风萧瑟中殒命五丈原，将星陨落。','孔明命姜维、杨仪安排退军之计，密授锦囊与魏延之事，是夜大星赤色，光芒有角，自东北流于西南，投于孔明营内，孔明遂卒，年五十四。','小说中最动人的悲情高潮，"鞠躬尽瘁，死而后已"至此画上句点。','蜀汉建兴十二年（234年）'),
('death-at-wuzhang-plains','en','Death at Wuzhang Plains','His ritual to extend his life failed, Kongming knows his time has come, sets his affairs in order, and dies at Wuzhang Plains as autumn wind stirs and his star falls.','Kongming instructs Jiang Wei and Yang Yi on the plan for withdrawal and secretly arranges for the matter of Wei Yan, and that night a great red star with radiating points streams from the northeast to the southwest and falls into his camp; Kongming dies at fifty-four.','The novel''s most moving tragic climax, the final period on his vow to serve until death.','234 CE (Shu Han''s twelfth year of Jianxing)')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000007';

-- KK=10 Records (志载/传称 voice)
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('cao-rui-and-the-wei-succession','zh-CN','明帝托孤','魏明帝屡拒蜀汉北伐，营治宫室，景初三年病笃，托孤于司马懿、曹爽，寻即崩逝。','睿以文帝长子即位，改元太和、青龙、景初，屡遣张郃、司马懿等御亮之师；晚年大治宫室，耗费民力；景初三年正月，召司马懿自辽东还，与曹爽同受遗诏辅少子齐王芳，是日崩，年三十六。','少主即位、双头辅政的格局，为其后曹爽、司马懿之争埋下伏笔。','魏青龙三年至景初三年（235–239年）'),
('cao-rui-and-the-wei-succession','en','Emperor Ming''s deathbed succession','Emperor Ming of Wei repeatedly repelled Shu Han''s northern campaigns and undertook great palace works, then fell gravely ill in 239 and entrusted the regency to Sima Yi and Cao Shuang before dying.','Cao Rui succeeded his father Cao Pi and sent generals including Zhang He and Sima Yi to resist Liang''s campaigns; in his later years he built extensively at great cost to the people, and in early 239 he recalled Sima Yi from Liaodong and named him co-regent with Cao Shuang for the child heir Cao Fang, dying that same day at thirty-six.','The joint regency for a child emperor sets up the later contest between Cao Shuang and Sima Yi.','235–239 CE (Wei''s Qinglong 3 to Jingchu 3)'),
('cao-shuang-seizes-the-regency','zh-CN','曹爽专擅','曹爽与懿同受遗诏，寻用何晏等谋，明升懿为太傅，实夺其兵权，遂专擅朝政。','爽初事懿甚恭，后用丁谧计，奏懿为太傅，外崇之而实无权，乃引何晏、邓飏、丁谧等为腹心，屡改制度，树党专权，懿遂称疾不与政事。','双头辅政名存实亡，曹爽独揽朝纲，激化与司马氏之矛盾。','魏正始初年（239–244年）'),
('cao-shuang-seizes-the-regency','en','Cao Shuang seizes the regency','Though co-regent with Sima Yi, Cao Shuang follows advisers'' schemes to promote Sima Yi to the honorary post of Grand Tutor while stripping his actual power, and monopolizes the court.','Cao Shuang was at first deferential to Sima Yi, but on Ding Mi''s advice petitioned to elevate him to Grand Tutor in name while leaving him no real authority, then drew He Yan, Deng Yang, and Ding Mi in as his inner circle, repeatedly altered institutions to build his faction, while Sima Yi withdrew from affairs pleading illness.','The nominal joint regency collapses in practice as Cao Shuang monopolizes power, sharpening the conflict with the Sima family.','239–244 CE (early Wei Zhengshi era)'),
('sima-yi-feigns-illness','zh-CN','懿称疾示弱','嘉平元年前，懿久称疾不与政事，暗中布置，李胜就问疾，懿故为昏聩之态以疑爽。','爽遣李胜出为荆州刺史，因往辞懿以觇虚实，懿故为病笃昏乱之状，言语错乱、粥流满襟，胜还报爽曰"司马公尸居余气，形神已离，不足虑也"，爽由是不复设备。','示弱麻痹之计，为高平陵之变的突袭埋下成功的关键。','魏正始末至嘉平元年（247–249年）'),
('sima-yi-feigns-illness','en','Sima Yi feigns illness','Before 249, Sima Yi stayed away from court pleading illness while secretly making preparations; when Li Sheng visited to assess him, Yi played the part of a failing old man to deceive Cao Shuang.','Cao Shuang sent Li Sheng, newly appointed governor of Jing Province, to bid Sima Yi farewell and gauge his condition; Yi feigned confused speech and let gruel dribble down his robe, so that Li Sheng reported back that "Lord Sima is but a corpse with breath left in it, his spirit already departed, not worth worrying over," and Cao Shuang let his guard down entirely.','This deception of weakness proves decisive in the surprise success of the Gaoping Tombs coup.','247–249 CE (late Zhengshi to Jiaping 1)'),
('gaoping-tombs-incident','zh-CN','高平陵之变','嘉平元年正月，爽兄弟从帝谒高平陵，懿乘虚闭城门，据武库，奏免爽兄弟官。','正月甲午，帝谒高平陵，爽兄弟皆从；懿于是奏永宁太后，废爽兄弟官职，勒兵屯司马门，遣人据武库，遣侍中高柔行大将军事，占据爽营，爽惶惑不知所为，终纳桓范之谏不及，束手请降。','魏室军政大权自此归司马氏，为其代魏张本。','魏嘉平元年（249年）'),
('gaoping-tombs-incident','en','The Gaoping Tombs incident','In 249, while Cao Shuang and his brothers accompanied the emperor to Gaoping Tombs, Sima Yi seized the moment to seal the city gates, occupy the arsenal, and petition to remove the Cao brothers from office.','On the day the emperor visited Gaoping Tombs with the Cao brothers in attendance, Sima Yi petitioned the Dowager Empress to strip Cao Shuang and his brothers of office, stationed troops at the palace gates, sent men to seize the arsenal, appointed Gao Rou to act as Grand General over Cao Shuang''s camp, and Cao Shuang, panicked and indecisive, ultimately failed to heed Huan Fan''s counsel and surrendered.','Military and political authority in Wei passes to the Sima family from this point, paving the way for their eventual usurpation.','249 CE (Wei''s first year of Jiaping)'),
('execution-of-the-cao-shuang-faction','zh-CN','曹爽伏诛','爽既降，懿旋以谋反罪奏诛爽兄弟及其党羽何晏等，皆夷三族。','爽降后归第，懿寻使人告爽与何晏、邓飏、丁谧、毕轨、李胜、桓范等谋反，悉收付廷尉，皆夷三族，曹氏宗室势力自此一蹶不振。','曹爽一党尽灭，司马氏遂无与之抗衡者。','魏嘉平元年（249年）'),
('execution-of-the-cao-shuang-faction','en','Execution of the Cao Shuang faction','After Cao Shuang''s surrender, Sima Yi soon had him and his brothers, along with allies including He Yan, charged with treason and executed, their clans exterminated.','After returning home under surrender, Cao Shuang was soon accused of treason together with He Yan, Deng Yang, Ding Mi, Bi Gui, Li Sheng, and Huan Fan, all handed to the judiciary and executed with their clans wiped out to the third degree, breaking the power of the Cao imperial clan for good.','With Cao Shuang''s faction destroyed entirely, no one remains to rival the Sima family.','249 CE (Wei''s first year of Jiaping)'),
('sima-shi-succeeds-sima-yi','zh-CN','司马师秉政','嘉平三年懿卒，子司马师以抚军大将军辅政，总揽魏之朝纲。','懿卒于嘉平三年八月，年七十三；子师袭爵，进位抚军大将军、录尚书事，凡朝廷大政悉由师决，父子相继专魏之柄。','司马氏专权由懿而师，权势不衰反盛。','魏嘉平三年（251年）'),
('sima-shi-succeeds-sima-yi','en','Sima Shi takes charge','When Sima Yi died in 251, his son Sima Shi took over the regency as General Who Nurtures the Army, holding the reins of Wei''s government.','Sima Yi died in the eighth month of 251 at seventy-three; his son Shi inherited his title, rose to General Who Nurtures the Army with authority over the Imperial Secretariat, and all major court decisions passed through him, continuing the family''s grip on Wei from father to son.','The Sima family''s dominance passes from Yi to Shi without diminishing, only growing stronger.','251 CE (Wei''s third year of Jiaping)'),
('sima-shi-deposes-emperor-fang','zh-CN','司马师废齐王芳','嘉平六年，师以帝谋诛己为由，奏永宁太后废齐王芳为齐王，迎立高贵乡公曹髦。','帝芳与李丰、张缉等谋以夏侯玄代师辅政，事泄，师悉诛之；九月，师奏太后废芳为齐王，遣归藩国，迎文帝孙高贵乡公曹髦即皇帝位。','魏室皇帝首遭权臣废黜，司马氏权势凌驾皇权之上。','魏嘉平六年（254年）'),
('sima-shi-deposes-emperor-fang','en','Sima Shi deposes Prince Cao Fang','In 254, citing a plot against him, Sima Shi petitioned the Dowager Empress to depose Emperor Cao Fang to Prince of Qi and install Cao Mao, Duke of Gaogui Township, in his place.','When Cao Fang conspired with Li Feng and Zhang Ji to replace Sima Shi with Xiahou Xuan as regent, the plot was discovered and Sima Shi executed them all; in the ninth month he petitioned the Dowager Empress to demote Fang to Prince of Qi and sent him back to his fief, installing Cao Mao, Duke of Gaogui Township and grandson of Cao Pi, as emperor.','The first deposition of a Wei emperor by a powerful minister, showing Sima authority now surpassing the throne itself.','254 CE (Wei''s sixth year of Jiaping)')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000006';

-- KK=10 Romance (小说叙写 voice)
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('cao-rui-and-the-wei-succession','zh-CN','曹睿托孤','曹睿多年抗蜀，晚年大兴土木，病笃之际急召司马懿，与曹爽同受顾命，立齐王芳为嗣。','曹睿在位屡拒孔明之师，晚年耽于宫室游宴；病革，星夜召还司马懿，执其手泣托幼主曹芳，命与曹爽同为辅政大臣，言讫而崩。','小说藉托孤一幕铺陈魏室主少国疑之势，为高平陵之变张本。','魏青龙三年至景初三年（235–239年）'),
('cao-rui-and-the-wei-succession','en','Cao Rui''s deathbed succession','After years resisting Kongming, Cao Rui indulges in palace building in his later years, then on his deathbed urgently recalls Sima Yi to share the regency with Cao Shuang over the boy heir Cao Fang.','Having spent his reign fending off Kongming''s campaigns and his later years on palaces and revelry, the dying Cao Rui summons Sima Yi through the night, grasps his hand in tears to entrust him with the young Cao Fang, names him co-regent with Cao Shuang, and expires.','The deathbed scene dramatizes Wei''s fragile child succession, setting the stage for the Gaoping Tombs coup.','235–239 CE (Wei''s Qinglong 3 to Jingchu 3)'),
('dead-zhuge-liang-routs-living-sima','zh-CN','死诸葛走生仲达','孔明既卒，蜀军依计退兵，司马懿追至，姜维推出孔明木像，懿大惊而退，蜀军从容归国。','懿闻孔明已死，率兵追赶，姜维反旗鸣鼓，推出孔明生前所坐四轮车、木像端坐如常，懿疑其未死，惊而拨马便走，蜀军由是安然退入斜谷，百姓遂有"死诸葛能走生仲达"之谚。','小说以此谚语总结孔明用兵之余威，亦见司马懿谨慎多疑之性。','蜀汉建兴十二年（234年）'),
('dead-zhuge-liang-routs-living-sima','en','The dead Zhuge routs the living Zhongda','After Kongming''s death, Shu withdraws according to his plan; when Sima Yi pursues, Jiang Wei displays Kongming''s wooden effigy and Sima Yi flees in alarm, letting Shu retreat unmolested.','Learning of Kongming''s death, Sima Yi gives chase, but Jiang Wei turns his banners about and beats the drums, wheeling out the four-wheeled carriage bearing Kongming''s wooden effigy seated as if alive; suspecting a ruse, Sima Yi wheels his horse about and flees, allowing Shu to withdraw safely through the Xie Valley, giving rise to the saying that the dead Zhuge could still rout the living Zhongda.','The novel crystallizes Kongming''s lingering authority in this proverb, while also revealing Sima Yi''s wary, suspicious nature.','234 CE (Shu Han''s twelfth year of Jianxing)'),
('cao-shuang-seizes-the-regency','zh-CN','曹爽专权','曹爽用何晏之谋，尊懿为太傅而夺其兵权，广植党羽，独揽朝纲。','爽听何晏、邓飏之言，表懿为太傅，虚尊而实黜之，自领禁军，引何晏等为羽翼，饮宴游猎无度，朝中大权尽归曹氏。','小说渲染曹爽骄纵专权之态，为后文司马懿隐忍反扑蓄势。','魏正始初年（239–244年）'),
('cao-shuang-seizes-the-regency','en','Cao Shuang monopolizes power','On He Yan''s counsel, Cao Shuang honors Sima Yi as Grand Tutor while stripping his command, builds a faction of favorites, and monopolizes the court.','Following He Yan and Deng Yang, Cao Shuang petitions to name Sima Yi Grand Tutor in empty honor while removing his real power, takes personal command of the palace guards, draws He Yan and others as his wings, and indulges without restraint in feasting and hunting as the Cao faction takes total control of the court.','Dramatizes Cao Shuang''s arrogance and overreach, setting up Sima Yi''s patient counterstroke.','239–244 CE (early Wei Zhengshi era)'),
('cao-shuang-indulges-in-power','zh-CN','曹爽纵情游乐','曹爽既夺大权，日与何晏等纵情声色、游猎无度，僭用禁物，朝野侧目。','爽与何晏、邓飏、丁谧等日夜宴饮，僭用先帝仪仗器物出猎，兄弟并典禁兵而倾城相从，朝中忠直之士敢怒不敢言。','小说借此渲染曹爽骄奢忘形，为其败亡埋下伏笔。','魏正始年间（244–249年）'),
('cao-shuang-indulges-in-power','en','Cao Shuang indulges in pleasure','With power secured, Cao Shuang and his circle give themselves over to feasting and unrestrained hunting, overstepping ceremonial privilege while the court watches in silent disapproval.','Cao Shuang, He Yan, Deng Yang, and Ding Mi feast day and night, ride out hunting with imperial regalia beyond their rank, and command the palace guards through his brothers while the whole city turns out to follow him, and upright officials dare not voice their anger.','Dramatizes Cao Shuang''s arrogant excess, foreshadowing his coming downfall.','244–249 CE (Wei Zhengshi era)'),
('sima-yi-feigns-illness','zh-CN','司马懿装病赚曹爽','懿托病不出，暗养死士，李胜来探，懿故作昏聩之态，爽遂尽释猜疑。','懿闭门称疾，暗中与二子谋定大计，蓄养死士三千，散在民间；曹爽遣李胜以辞行为名往探虚实，懿佯装耳聋眼花、言语颠倒，衣不解带、粥洒满襟，胜信以为真，回报爽曰太傅将不久于人世，爽大喜，自此不复提防。','小说中司马懿隐忍权谋的经典场面，麻痹曹爽而促成日后之变。','魏正始末至嘉平元年（247–249年）'),
('sima-yi-feigns-illness','en','Sima Yi feigns illness to deceive Cao Shuang','Feigning illness at home, Sima Yi secretly trains loyal soldiers; when Li Sheng comes to inspect him, Yi plays the part of a failing old man and Cao Shuang''s suspicions are entirely dispelled.','Sima Yi shuts his doors pleading sickness while secretly plotting with his two sons and hiding three thousand loyal soldiers among the populace; when Cao Shuang sends Li Sheng under the pretext of a farewell visit, Yi feigns deafness, confusion, and trembling hands, spilling gruel down his robe, and Li Sheng, taken in, reports the Grand Tutor will not live long, delighting Cao Shuang, who drops his guard entirely.','A classic scene of Sima Yi''s patient scheming in the novel, lulling Cao Shuang into the vulnerability that enables the later coup.','247–249 CE (late Zhengshi to Jiaping 1)'),
('sima-yi-plots-with-his-sons','zh-CN','司马懿与二子密谋','懿装病既成，密召司马师、司马昭商定举事之计，唯师知蓄养死士之事。','懿见李胜已去、爽不复设备，乃密召二子入内室，告以举事之期；司马师素知父蓄养死士三千散在各处，一声令下即可齐集，昭闻之亦惊其周密。','小说交代政变筹划的隐秘过程，凸显司马师之干练。','魏正始九年（248年）'),
('sima-yi-plots-with-his-sons','en','Sima Yi plots with his sons','With his ruse against Li Sheng complete, Sima Yi secretly summons Sima Shi and Sima Zhao to settle the timing of the coup, and only Shi already knows of the hidden soldiers.','Seeing Li Sheng gone and Cao Shuang''s guard fully down, Sima Yi calls his two sons into his inner chamber to fix the date for action; Sima Shi alone had known of the three thousand loyal soldiers hidden about the city, ready to gather at a single order, and Sima Zhao is startled at how thoroughly the plan has been laid.','Reveals the secret planning behind the coup in the novel and highlights Sima Shi''s capability.','248 CE (Wei''s ninth year of Zhengshi)'),
('gaoping-tombs-incident','zh-CN','高平陵之变','曹爽兄弟随帝出城谒陵，司马懿乘城中空虚，突然发难，占据武库，奏罢爽兄弟兵权。','爽兄弟挟天子出城谒高平陵，城中空虚；懿闻讯大喜，即披甲上马，率二子并旧部占据武库、屯兵司马门，遣人奏知太后废爽之职，又遣人劝爽以性命为重、纳降免死，爽终不听桓范死守许都之策，反信懿指洛水为誓之言，束甲来降。','小说渲染司马懿隐忍多年一举夺权的高潮，魏室名存实亡。','魏嘉平元年（249年）'),
('gaoping-tombs-incident','en','The Gaoping Tombs incident','While the Cao brothers escort the emperor out of the city to Gaoping Tombs, Sima Yi seizes the empty capital, occupies the arsenal, and petitions to strip the brothers of their military authority.','With the Cao brothers escorting the emperor out to the tombs and the city left undefended, Sima Yi rejoices at the news, arms himself, and with his sons and old retainers occupies the arsenal and the palace gates, sends word to the Dowager Empress to remove Cao Shuang from office, and urges Cao Shuang to value his life and surrender; ignoring Huan Fan''s counsel to hold out at Xu, Cao Shuang instead trusts Sima Yi''s oath by the Luo River and lays down his arms.','The novel''s climactic payoff for years of Sima Yi''s patience, leaving Wei''s ruling house a hollow name.','249 CE (Wei''s first year of Jiaping)'),
('execution-of-the-cao-shuang-faction','zh-CN','曹爽伏诛','曹爽既降，未几懿即以谋反之罪尽诛爽兄弟及何晏等党羽，皆灭三族。','爽自谓纳降可保富贵，归家未几，懿即遣人以谋反罪收爽兄弟及何晏、邓飏等下狱，皆斩于市，夷灭三族，曹氏宗族由是式微。','小说以此收束曹爽骄纵一时的下场，司马氏由此独掌魏权。','魏嘉平元年（249年）'),
('execution-of-the-cao-shuang-faction','en','Execution of the Cao Shuang faction','Soon after surrendering, Cao Shuang and his brothers, along with He Yan and other allies, are charged with treason and executed, their clans wiped out.','Believing his surrender would preserve his rank and wealth, Cao Shuang has scarcely returned home before Sima Yi has him, his brothers, He Yan, Deng Yang, and others arrested on charges of treason, executed in the marketplace, and their clans exterminated, breaking the Cao family''s power for good.','Closes out Cao Shuang''s brief arrogance in the novel, leaving the Sima family in sole command of Wei.','249 CE (Wei''s first year of Jiaping)'),
('sima-shi-succeeds-sima-yi','zh-CN','司马师继掌大权','司马懿病逝，长子司马师承其权位，威福自专，魏之朝政尽归司马氏。','懿临终嘱二子曰："吾事魏历年，人皆疑我有异志，我死之后，汝二人善理国政，务从谨慎。"言讫而亡；司马师承父之位，独揽朝纲，威权更甚于前。','小说藉此交代司马氏世袭专权的延续，为后文废立埋下伏笔。','魏嘉平三年（251年）'),
('sima-shi-succeeds-sima-yi','en','Sima Shi takes over','On Sima Yi''s death, his eldest son Sima Shi inherits his position and authority, monopolizing Wei''s government even more completely.','On his deathbed Sima Yi tells his two sons that though many suspected him of harboring ambitions during his years serving Wei, they must now govern with great caution after he is gone, and dies; Sima Shi inherits his father''s position and monopolizes the court, wielding even greater authority than before.','Establishes the continuation of hereditary Sima dominance in the novel, foreshadowing the deposition to come.','251 CE (Wei''s third year of Jiaping)'),
('sima-shi-deposes-emperor-fang','zh-CN','司马师废曹芳','曹芳与李丰等密谋诛师未成，事泄被诛，师遂废芳为齐王，另立曹髦。','芳不甘为师所制，与国丈张缉、中书令李丰密谋以夏侯玄代师，事泄，师尽诛其党；乃入宫奏太后，废芳为齐王，迎立高贵乡公曹髦为帝，魏室之权尽归司马氏。','小说以此写魏室彻底沦为司马氏傀儡，三国鼎立格局加速崩解。','魏嘉平六年（254年）'),
('sima-shi-deposes-emperor-fang','en','Sima Shi deposes Cao Fang','When Cao Fang''s secret plot with Li Feng to have Sima Shi killed is discovered and its conspirators executed, Sima Shi deposes Fang as Prince of Qi and installs Cao Mao instead.','Unwilling to remain under Sima Shi''s thumb, Cao Fang conspires in secret with his father-in-law Zhang Ji and Secretariat Director Li Feng to replace Shi with Xiahou Xuan; when the plot is discovered, Shi executes the conspirators, then petitions the Dowager Empress to demote Fang to Prince of Qi and install Cao Mao, Duke of Gaogui Township, as emperor, leaving Wei''s authority entirely in Sima hands.','Depicts Wei''s ruling house reduced fully to a Sima puppet, accelerating the collapse of the three-way balance of power.','254 CE (Wei''s sixth year of Jiaping)')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000007';

-- ============================================================
-- 5. EVENT LOCATIONS
-- ============================================================

INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('first-expedition-through-qishan','qishan'),('loss-of-jieting','jieting'),('empty-fort-strategy','jieting'),
('ma-su-executed-in-tears','hanzhong'),('second-memorial-on-the-expedition','hanzhong'),('wooden-ox-and-flowing-horse','qishan'),
('prayer-to-extend-life-at-wuzhang-plains','wuzhang-plains'),('death-at-wuzhang-plains','wuzhang-plains'),
('cao-rui-and-the-wei-succession','luoyang'),('dead-zhuge-liang-routs-living-sima','wuzhang-plains'),
('cao-shuang-seizes-the-regency','luoyang'),('cao-shuang-indulges-in-power','luoyang'),
('sima-yi-feigns-illness','luoyang'),('sima-yi-plots-with-his-sons','luoyang'),
('gaoping-tombs-incident','gaoping-tombs'),('execution-of-the-cao-shuang-faction','luoyang'),
('sima-shi-succeeds-sima-yi','luoyang'),('sima-shi-deposes-emperor-fang','luoyang')
) AS v(event_slug,location_slug) ON e.slug=v.event_slug
JOIN locations l ON l.slug=v.location_slug AND l.work_id=e.work_id
WHERE e.id::text LIKE '64000000-0000-4000-8009%' OR e.id::text LIKE '65000000-0000-4000-8009%'
   OR e.id::text LIKE '64000000-0000-4000-8010%' OR e.id::text LIKE '65000000-0000-4000-8010%'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 6. EVENT CHARACTERS
-- ============================================================

INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('first-expedition-through-qishan','zhuge-liang',0),('first-expedition-through-qishan','wei-yan',1),('first-expedition-through-qishan','jiang-wei',2),('first-expedition-through-qishan','zhao-yun',3),
('loss-of-jieting','ma-su',0),('loss-of-jieting','zhang-he',1),('loss-of-jieting','wang-ping',2),('loss-of-jieting','zhuge-liang',3),
('empty-fort-strategy','zhuge-liang',0),('empty-fort-strategy','sima-yi',1),
('ma-su-executed-in-tears','zhuge-liang',0),('ma-su-executed-in-tears','ma-su',1),
('second-memorial-on-the-expedition','zhuge-liang',0),('second-memorial-on-the-expedition','liu-shan',1),
('wooden-ox-and-flowing-horse','zhuge-liang',0),('wooden-ox-and-flowing-horse','wang-ping',1),
('prayer-to-extend-life-at-wuzhang-plains','zhuge-liang',0),('prayer-to-extend-life-at-wuzhang-plains','jiang-wei',1),('prayer-to-extend-life-at-wuzhang-plains','wei-yan',2),
('death-at-wuzhang-plains','zhuge-liang',0),('death-at-wuzhang-plains','jiang-wei',1),
('cao-rui-and-the-wei-succession','cao-rui',0),('cao-rui-and-the-wei-succession','sima-yi',1),('cao-rui-and-the-wei-succession','cao-shuang',2),
('dead-zhuge-liang-routs-living-sima','sima-yi',0),('dead-zhuge-liang-routs-living-sima','jiang-wei',1),
('cao-shuang-seizes-the-regency','cao-shuang',0),('cao-shuang-seizes-the-regency','sima-yi',1),
('cao-shuang-indulges-in-power','cao-shuang',0),
('sima-yi-feigns-illness','sima-yi',0),('sima-yi-feigns-illness','cao-shuang',1),
('sima-yi-plots-with-his-sons','sima-yi',0),('sima-yi-plots-with-his-sons','sima-shi',1),
('gaoping-tombs-incident','sima-yi',0),('gaoping-tombs-incident','cao-shuang',1),('gaoping-tombs-incident','sima-shi',2),
('execution-of-the-cao-shuang-faction','sima-yi',0),('execution-of-the-cao-shuang-faction','cao-shuang',1),
('sima-shi-succeeds-sima-yi','sima-shi',0),('sima-shi-succeeds-sima-yi','sima-yi',1),
('sima-shi-deposes-emperor-fang','sima-shi',0)
) AS v(event_slug,char_slug,ord) ON e.slug=v.event_slug
JOIN characters c ON c.slug=v.char_slug AND c.work_id=e.work_id
WHERE e.id::text LIKE '64000000-0000-4000-8009%' OR e.id::text LIKE '65000000-0000-4000-8009%'
   OR e.id::text LIKE '64000000-0000-4000-8010%' OR e.id::text LIKE '65000000-0000-4000-8010%'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 7. EVENT SOURCES
-- ============================================================

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e
JOIN sources s ON s.work_id=e.work_id AND (
  (e.work_id='10000000-0000-4000-8000-000000000006' AND s.title='Records of the Three Kingdoms') OR
  (e.work_id='10000000-0000-4000-8000-000000000007' AND s.title='Romance of the Three Kingdoms (Mao edition)')
)
WHERE e.id::text LIKE '64000000-0000-4000-8009%' OR e.id::text LIKE '65000000-0000-4000-8009%'
   OR e.id::text LIKE '64000000-0000-4000-8010%' OR e.id::text LIKE '65000000-0000-4000-8010%'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 8. CHARACTER RELATIONS (+ relation_translations)
-- ============================================================

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('74000000-0000-4000-8009-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'zhuge-liang','ma-su','mentor','source_to_target','mixed',4,'ended',NULL,'ma-su-executed-in-tears'),
(2,'zhuge-liang','sima-yi','adversary','bidirectional','negative',5,'ended',NULL,'death-at-wuzhang-plains'),
(3,'zhuge-liang','jiang-wei','mentor','source_to_target','positive',5,'ended','first-expedition-through-qishan','death-at-wuzhang-plains'),
(4,'ma-su','wang-ping','ally','bidirectional','mixed',3,'ended',NULL,'ma-su-executed-in-tears'),
(5,'zhang-he','ma-su','adversary','source_to_target','negative',4,'ended',NULL,'loss-of-jieting'),
(6,'zhuge-liang','wei-yan','ally','bidirectional','mixed',3,'active',NULL,NULL),
(7,'zhang-he','sima-yi','ally','bidirectional','positive',3,'active',NULL,NULL),
(8,'jiang-wei','wei-yan','ally','bidirectional','neutral',2,'active',NULL,NULL)
) AS v(n,from_slug,to_slug,rtype,dir,sentiment,strength,rstatus,start_slug,end_slug)
JOIN characters fc ON fc.slug=v.from_slug AND fc.work_id='10000000-0000-4000-8000-000000000006'
JOIN characters tc ON tc.slug=v.to_slug AND tc.work_id=fc.work_id
LEFT JOIN events se ON se.slug=v.start_slug AND se.work_id=fc.work_id
LEFT JOIN events ee ON ee.slug=v.end_slug AND ee.work_id=fc.work_id
ON CONFLICT DO NOTHING;

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('74000000-0000-4000-8010-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'sima-yi','cao-shuang','adversary','bidirectional','negative',5,'ended','cao-shuang-seizes-the-regency','execution-of-the-cao-shuang-faction'),
(2,'cao-rui','sima-yi','ally','source_to_target','positive',4,'ended',NULL,'cao-rui-and-the-wei-succession'),
(3,'cao-rui','cao-shuang','family','bidirectional','positive',3,'ended',NULL,'cao-rui-and-the-wei-succession'),
(4,'sima-yi','sima-shi','family','bidirectional','positive',5,'active',NULL,NULL),
(5,'sima-shi','cao-shuang','adversary','bidirectional','negative',4,'ended',NULL,'execution-of-the-cao-shuang-faction'),
(6,'cao-rui','liu-shan','adversary','bidirectional','negative',2,'ended',NULL,'cao-rui-and-the-wei-succession')
) AS v(n,from_slug,to_slug,rtype,dir,sentiment,strength,rstatus,start_slug,end_slug)
JOIN characters fc ON fc.slug=v.from_slug AND fc.work_id='10000000-0000-4000-8000-000000000006'
JOIN characters tc ON tc.slug=v.to_slug AND tc.work_id=fc.work_id
LEFT JOIN events se ON se.slug=v.start_slug AND se.work_id=fc.work_id
LEFT JOIN events ee ON ee.slug=v.end_slug AND ee.work_id=fc.work_id
ON CONFLICT DO NOTHING;

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('75000000-0000-4000-8009-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'zhuge-liang','ma-su','mentor','source_to_target','mixed',4,'ended',NULL,'ma-su-executed-in-tears'),
(2,'zhuge-liang','sima-yi','adversary','bidirectional','negative',5,'ended',NULL,'death-at-wuzhang-plains'),
(3,'zhuge-liang','jiang-wei','mentor','source_to_target','positive',5,'ended','first-expedition-through-qishan','death-at-wuzhang-plains'),
(4,'ma-su','wang-ping','ally','bidirectional','mixed',3,'ended',NULL,'ma-su-executed-in-tears'),
(5,'zhang-he','ma-su','adversary','source_to_target','negative',4,'ended',NULL,'loss-of-jieting'),
(6,'zhuge-liang','wei-yan','ally','bidirectional','mixed',3,'active',NULL,NULL),
(7,'zhang-he','sima-yi','ally','bidirectional','positive',3,'active',NULL,NULL),
(8,'jiang-wei','wei-yan','ally','bidirectional','neutral',2,'active',NULL,NULL)
) AS v(n,from_slug,to_slug,rtype,dir,sentiment,strength,rstatus,start_slug,end_slug)
JOIN characters fc ON fc.slug=v.from_slug AND fc.work_id='10000000-0000-4000-8000-000000000007'
JOIN characters tc ON tc.slug=v.to_slug AND tc.work_id=fc.work_id
LEFT JOIN events se ON se.slug=v.start_slug AND se.work_id=fc.work_id
LEFT JOIN events ee ON ee.slug=v.end_slug AND ee.work_id=fc.work_id
ON CONFLICT DO NOTHING;

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('75000000-0000-4000-8010-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'sima-yi','cao-shuang','adversary','bidirectional','negative',5,'ended','cao-shuang-seizes-the-regency','execution-of-the-cao-shuang-faction'),
(2,'cao-rui','sima-yi','ally','source_to_target','positive',4,'ended',NULL,'cao-rui-and-the-wei-succession'),
(3,'cao-rui','cao-shuang','family','bidirectional','positive',3,'ended',NULL,'cao-rui-and-the-wei-succession'),
(4,'sima-yi','sima-shi','family','bidirectional','positive',5,'active',NULL,NULL),
(5,'sima-shi','cao-shuang','adversary','bidirectional','negative',4,'ended',NULL,'execution-of-the-cao-shuang-faction'),
(6,'cao-rui','liu-shan','adversary','bidirectional','negative',2,'ended',NULL,'cao-rui-and-the-wei-succession')
) AS v(n,from_slug,to_slug,rtype,dir,sentiment,strength,rstatus,start_slug,end_slug)
JOIN characters fc ON fc.slug=v.from_slug AND fc.work_id='10000000-0000-4000-8000-000000000007'
JOIN characters tc ON tc.slug=v.to_slug AND tc.work_id=fc.work_id
LEFT JOIN events se ON se.slug=v.start_slug AND se.work_id=fc.work_id
LEFT JOIN events ee ON ee.slug=v.end_slug AND ee.work_id=fc.work_id
ON CONFLICT DO NOTHING;

-- Records (志) relation labels.
INSERT INTO relation_translations(relation_id,locale,label,summary,status)
SELECT r.id,v.locale::locale_code,v.label,v.summary,'published'
FROM character_relations r
JOIN characters fc ON fc.id=r.from_character_id
JOIN characters tc ON tc.id=r.to_character_id
JOIN (VALUES
('zhuge-liang','ma-su','zh-CN','师徒与军法','亮素爱谡之材，委以街亭之任，谡违令致败，亮依法斩之而深自悼惜。'),
('zhuge-liang','ma-su','en','Mentor and military law','Liang valued Ma Su''s ability and entrusted him with Jieting, but when Ma Su''s disobedience brought defeat, Liang had him executed by law while deeply mourning him.'),
('zhuge-liang','sima-yi','zh-CN','五丈原对垒','亮五次北伐，与懿数度对阵，终于五丈原相持百日，亮卒而懿始终未能一战擒之。'),
('zhuge-liang','sima-yi','en','Rivals at Wuzhang Plains','Across five northern campaigns Liang and Sima Yi faced each other repeatedly, ending in a hundred-day standoff at Wuzhang Plains that closed only with Liang''s death.'),
('zhuge-liang','jiang-wei','zh-CN','收降与器重','亮于天水降维后深加器重，倾心传授兵法方略，视为北伐后继之才。'),
('zhuge-liang','jiang-wei','en','Surrender and mentorship','After Jiang Wei''s surrender at Tianshui, Liang came to value him deeply, passing on his military knowledge as the heir to his campaigns.'),
('ma-su','wang-ping','zh-CN','同守街亭','二人同赴街亭拒张郃，平谏谡当道下寨不听，兵败后平独整所部不乱。'),
('ma-su','wang-ping','en','Fellow defenders of Jieting','The two were sent together to hold Jieting against Zhang He; Wang Ping''s advice to camp astride the road was ignored, and after the defeat only his own troops stayed in order.'),
('zhang-he','ma-su','zh-CN','街亭克星','郃善用兵，断谡汲水之道，一战破之，是役成就其军旅生涯的显赫一战。'),
('zhang-he','ma-su','en','Nemesis at Jieting','The skilled Zhang He cut off Ma Su''s water supply and crushed him in a single engagement, one of the defining victories of his career.'),
('zhuge-liang','wei-yan','zh-CN','统帅与骁将','延屡从亮出师，勇冠诸将，然其子午谷之谋亮终未用，君臣间不无芥蒂。'),
('zhuge-liang','wei-yan','en','Commander and bold general','Wei Yan campaigned repeatedly under Liang and was the boldest of his generals, though Liang never adopted his risky plan through the Ziwu Valley, leaving some friction between them.'),
('zhang-he','sima-yi','zh-CN','帐下部将','郃屡从懿拒亮之师，木门之役郃不欲追而懿强令进兵，终中伏而亡。'),
('zhang-he','sima-yi','en','A subordinate commander','Zhang He repeatedly served under Sima Yi against Liang''s campaigns; at Mumen he was reluctant to pursue but Yi insisted, and he died in the resulting ambush.'),
('jiang-wei','wei-yan','zh-CN','蜀汉同僚','二人同为蜀汉北伐骁将，然性行不同，延死后维继其军职、承其北伐之志。'),
('jiang-wei','wei-yan','en','Fellow Shu officers','Both were leading Shu generals in the northern campaigns, though very different in temperament; after Wei Yan''s death Jiang Wei inherited his military role and continued the campaigns.'),
('sima-yi','cao-shuang','zh-CN','辅政对立','二人同受明帝遗诏辅政，爽专权排懿，懿隐忍称疾，终于高平陵之变尽诛爽党。'),
('sima-yi','cao-shuang','en','Rival regents','Co-regents under Emperor Ming''s testament, Cao Shuang monopolized power and sidelined Sima Yi, who patiently feigned illness before destroying Cao Shuang''s faction in the Gaoping Tombs coup.'),
('cao-rui','sima-yi','zh-CN','托孤重臣','睿倚懿御蜀多年，临终急召还朝，与曹爽同受顾命之托。'),
('cao-rui','sima-yi','en','Emperor and entrusted minister','Cao Rui relied on Sima Yi for years to hold off Shu, and on his deathbed urgently recalled him to share the regency with Cao Shuang.'),
('cao-rui','cao-shuang','zh-CN','宗室托付','爽为睿从兄弟曹真之子，睿托以辅政之任，望其匡弼幼主。'),
('cao-rui','cao-shuang','en','A kinsman''s trust','Cao Shuang, son of Cao Rui''s cousin Cao Zhen, was entrusted by the dying emperor with regency over the boy heir.'),
('sima-yi','sima-shi','zh-CN','父子专政','师佐父谋诛曹爽，懿卒后袭其位、专魏之柄，父子相继执掌国政。'),
('sima-yi','sima-shi','en','Father and son in power','Sima Shi helped his father plan Cao Shuang''s destruction, then inherited his position and continued to control Wei''s government.'),
('sima-shi','cao-shuang','zh-CN','隔代之敌','师助父谋诛爽党，爽虽先懿而亡，然师终承其父未竟之业，尽灭曹氏之势。'),
('sima-shi','cao-shuang','en','An adversary once removed','Sima Shi helped plan the destruction of Cao Shuang''s faction, and though Cao Shuang died before Sima Yi, Shi carried his father''s work to completion in ending Cao power.'),
('cao-rui','liu-shan','zh-CN','敌国之君','睿在位与蜀汉后主对峙，屡遣兵拒亮之师，终至其崩逝而两国相争未歇。'),
('cao-rui','liu-shan','en','Rival sovereigns','Cao Rui''s reign stood opposed to the Shu Han throne of Liu Shan, sending armies to resist Liang''s campaigns until his death, with the rivalry between the states unresolved.')
) AS v(from_slug,to_slug,locale,label,summary)
  ON fc.slug=v.from_slug AND tc.slug=v.to_slug
WHERE r.work_id='10000000-0000-4000-8000-000000000006' AND (r.id::text LIKE '74000000-0000-4000-8009%' OR r.id::text LIKE '74000000-0000-4000-8010%')
ON CONFLICT (relation_id,locale) DO NOTHING;

-- Romance (演义) relation labels.
INSERT INTO relation_translations(relation_id,locale,label,summary,status)
SELECT r.id,v.locale::locale_code,v.label,v.summary,'published'
FROM character_relations r
JOIN characters fc ON fc.id=r.from_character_id
JOIN characters tc ON tc.id=r.to_character_id
JOIN (VALUES
('zhuge-liang','ma-su','zh-CN','师徒情深与军法无情','孔明素器重马谡，委以重任而痛失街亭，挥泪按律斩之，情法两难。'),
('zhuge-liang','ma-su','en','Deep mentorship, unforgiving law','Kongming prized Ma Su and entrusted him with a vital post, only to see Jieting lost; he executes him in tears, torn between affection and duty.'),
('zhuge-liang','sima-yi','zh-CN','既生瑜何生亮式的宿敌','孔明与仲达用兵各有所长，渭南相持互探虚实，终以孔明星陨、仲达含恨收兵告终。'),
('zhuge-liang','sima-yi','en','Fated rivals','Kongming and Zhongda match wits along the Wei River, each probing the other''s weakness, until Kongming''s star falls and Zhongda withdraws unfulfilled.'),
('zhuge-liang','jiang-wei','zh-CN','师徒传承','孔明视姜维为衣钵传人，临终犹以后事相托，姜维亦终身以继承师志为念。'),
('zhuge-liang','jiang-wei','en','Mentor and successor','Kongming regards Jiang Wei as his true successor, entrusting him with his final plans, and Jiang Wei devotes his life to carrying on his mentor''s cause.'),
('ma-su','wang-ping','zh-CN','谏而不纳的同僚','王平力谏马谡当道扎营，谡刚愎自用不听，终致同僚兵败身死。'),
('ma-su','wang-ping','en','An unheeded warning','Wang Ping urges Ma Su to camp astride the road, but his stubborn colleague refuses, leading to defeat and death.'),
('zhang-he','ma-su','zh-CN','阵前克星','张郃深谙兵机，断马谡水道破其军，成就自身声名，亦促成孔明挥泪斩将。'),
('zhang-he','ma-su','en','Battlefield nemesis','The tactically astute Zhang He cuts off Ma Su''s water and breaks his army, a victory that also leads directly to Kongming''s tearful execution of his own officer.'),
('zhuge-liang','wei-yan','zh-CN','用而不尽信','孔明倚重魏延之勇，然疑其素有反骨，屡次用其兵而不尽从其谋。'),
('zhuge-liang','wei-yan','en','Valued yet mistrusted','Kongming relies on Wei Yan''s courage in battle, yet suspects him of a rebellious streak, using his troops without ever fully adopting his plans.'),
('zhang-he','sima-yi','zh-CN','将帅之间的分歧','张郃随懿拒蜀，木门一役郃谏不可追而懿不听，郃身死，懿亦未尝无憾。'),
('zhang-he','sima-yi','en','A rift between commander and general','Zhang He serves under Sima Yi against Shu, but at Mumen his warning against pursuit goes unheeded, and his death leaves Sima Yi with some regret.'),
('jiang-wei','wei-yan','zh-CN','同殿为将','姜维与魏延同为孔明帐下猛将，禳星之夜延误闯灯坛，二人际遇自此殊途。'),
('jiang-wei','wei-yan','en','Fellow officers under one banner','Jiang Wei and Wei Yan both serve as Kongming''s bold generals, until Wei Yan''s fateful intrusion on the night of the star ritual sends their fortunes in different directions.'),
('sima-yi','cao-shuang','zh-CN','明争暗夺的辅政搭档','曹爽夺权在明，司马懿隐忍在暗，一朝发难，尽夺曹氏兵权，情谊荡然无存。'),
('sima-yi','cao-shuang','en','Regents in open and hidden conflict','Cao Shuang seizes power openly while Sima Yi bides his time in secret, and when he finally strikes, all of Cao Shuang''s authority is swept away.'),
('cao-rui','sima-yi','zh-CN','临终托付','曹睿病革之际泣执懿手，托以幼主曹芳，望其与曹爽同心辅政。'),
('cao-rui','sima-yi','en','A dying entrustment','On his deathbed, a weeping Cao Rui grasps Sima Yi''s hand to entrust him with the boy heir Cao Fang, hoping he and Cao Shuang will govern as one.'),
('cao-rui','cao-shuang','zh-CN','宗室相托','曹睿念曹爽为宗室子弟，临终托以辅政重任，望其保全社稷。'),
('cao-rui','cao-shuang','en','Trust placed in kin','Regarding Cao Shuang as a trusted member of the imperial clan, the dying Cao Rui entrusts him with the regency, hoping he will preserve the state.'),
('sima-yi','sima-shi','zh-CN','父子同谋','司马师素知父蓄养死士之谋，父子同心策划高平陵之变，懿卒后师承其权柄。'),
('sima-yi','sima-shi','en','Father and son in conspiracy','Sima Shi already knew of his father''s hidden soldiers and helped plan the Gaoping Tombs coup together, inheriting his authority after Sima Yi''s death.'),
('sima-shi','cao-shuang','zh-CN','助谋除敌','司马师参与谋划诛除曹爽之计，虽未亲手交锋，实为父辈之敌的终结者。'),
('sima-shi','cao-shuang','en','A hand in his destruction','Sima Shi took part in plotting Cao Shuang''s downfall, and though never facing him directly, was instrumental in ending his father''s great rival.'),
('cao-rui','liu-shan','zh-CN','两国敌对之君','曹睿与刘禅分主魏蜀，两国交兵不绝，然二君实未尝一面。'),
('cao-rui','liu-shan','en','Sovereigns of rival states','Cao Rui and Liu Shan ruled opposing states locked in continual warfare, though the two rulers never once met face to face.')
) AS v(from_slug,to_slug,locale,label,summary)
  ON fc.slug=v.from_slug AND tc.slug=v.to_slug
WHERE r.work_id='10000000-0000-4000-8000-000000000007' AND (r.id::text LIKE '75000000-0000-4000-8009%' OR r.id::text LIKE '75000000-0000-4000-8010%')
ON CONFLICT (relation_id,locale) DO NOTHING;

-- ============================================================
-- 9. GROUP MEMBERSHIP
-- ============================================================

INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g
JOIN characters c ON c.work_id=g.work_id
JOIN (VALUES
('shu-chancellery','ma-su'),
('shu-generals','wei-yan'),
('shu-generals','wang-ping'),
('house-of-cao','cao-rui'),
('house-of-cao','cao-shuang'),
('house-of-sima','sima-shi')
) AS v(group_slug,char_slug) ON g.slug=v.group_slug AND c.slug=v.char_slug
WHERE g.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

COMMIT;
