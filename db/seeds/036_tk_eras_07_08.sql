BEGIN;

-- =========================================================================
-- 036_tk_eras_07_08.sql
-- Three Kingdoms eras KK=07 'jing-province-and-yiling' (219-222/223) and
-- KK=08 'three-thrones' (220-229), Records (Chen Shou) + Romance (Luo
-- Guanzhong) works. Builds on skeleton seed 031 (works/chapters/groups) and
-- shared cast/gazetteer seed 032 (28 anchor characters, 38 real locations).
-- Per blueprint/WORK_TEMPLATE.md and blueprint/EXAMPLE_THREE_KINGDOMS.md.
--
-- UUID namespace (new, unused before this seed; per task brief, NOT the
-- generic T+X pattern from WORK_TEMPLATE.md 1.2 -- deliberately offset to
-- avoid collision with other era agents running in parallel):
--   characters (secondary, <=6/work)  46/47000000-0000-4000-80KK-############
--   locations  (minor, <=3/work)      36/37000000-0000-4000-80KK-############
--   events                            64/65000000-0000-4000-80KK-############
--   character_relations               74/75000000-0000-4000-80KK-############
-- Works: Records = 10000000-0000-4000-8000-000000000006 (X=6)
--        Romance = 10000000-0000-4000-8000-000000000007 (X=7)
--
-- Anchor characters and 38 real locations reused via slug JOIN from seed 032
-- (no recreation): liu-bei, guan-yu, zhang-fei, cao-cao, sun-jian, sun-ce,
-- sun-quan, dong-zhuo, lu-bu, wang-yun, emperor-xian, zhang-jiao, yuan-shao,
-- yuan-shu, zhou-yu, lu-su, zhuge-liang, zhao-yun, xu-shu, sima-yi, cao-pi,
-- liu-shan, lu-xun, jiang-wei, deng-ai, zhong-hui, sima-yan; locations
-- hanzhong, fancheng, jiangling, maicheng, yiling, baidicheng, chengdu,
-- xuchang, ruxukou among others.
--
-- New secondary characters (owning era in parenthesis): Lu Meng, Guan Ping,
-- Mi Fang, Yu Jin (KK07); Meng Huo, Hua Xin (KK08) -- 6 per work, matching
-- the <=6/work cap. New minor locations: Xiaoting, Langzhong (KK07);
-- Wuchang (KK08) -- 3 per work, matching the <=3/work cap.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS (secondary cast, 6 per work: 4 owned by KK07, 2 by KK08)
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
-- Records (志) -- historical
('46000000-0000-4000-8007-000000000001','10000000-0000-4000-8000-000000000006','lu-meng',701,'male','adult','antagonist','historical',178,220,'soldier',3),
('46000000-0000-4000-8007-000000000002','10000000-0000-4000-8000-000000000006','guan-ping',702,'male','adult','supporting','historical',NULL,220,'soldier',2),
('46000000-0000-4000-8007-000000000003','10000000-0000-4000-8000-000000000006','mi-fang',703,'male','adult','antagonist','historical',NULL,NULL,'soldier',2),
('46000000-0000-4000-8007-000000000004','10000000-0000-4000-8000-000000000006','yu-jin',704,'male','adult','antagonist','historical',NULL,221,'soldier',2),
('46000000-0000-4000-8008-000000000001','10000000-0000-4000-8000-000000000006','meng-huo',801,'male','adult','antagonist','historical',NULL,NULL,'ruler',2),
('46000000-0000-4000-8008-000000000002','10000000-0000-4000-8000-000000000006','hua-xin',802,'male','adult','antagonist','historical',157,232,'person',2),
-- Romance (演义) -- fictionalised_historical
('47000000-0000-4000-8007-000000000001','10000000-0000-4000-8000-000000000007','lu-meng',701,'male','adult','antagonist','fictionalised_historical',178,220,'soldier',3),
('47000000-0000-4000-8007-000000000002','10000000-0000-4000-8000-000000000007','guan-ping',702,'male','adult','supporting','fictionalised_historical',NULL,220,'soldier',2),
('47000000-0000-4000-8007-000000000003','10000000-0000-4000-8000-000000000007','mi-fang',703,'male','adult','antagonist','fictionalised_historical',NULL,NULL,'soldier',2),
('47000000-0000-4000-8007-000000000004','10000000-0000-4000-8000-000000000007','yu-jin',704,'male','adult','antagonist','fictionalised_historical',NULL,221,'soldier',2),
('47000000-0000-4000-8008-000000000001','10000000-0000-4000-8000-000000000007','meng-huo',801,'male','adult','antagonist','fictionalised_historical',NULL,NULL,'ruler',2),
('47000000-0000-4000-8008-000000000002','10000000-0000-4000-8000-000000000007','hua-xin',802,'male','adult','antagonist','fictionalised_historical',157,232,'person',2);

-- Records (志) -- 志载/传称 voice.
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('lu-meng','zh-CN','吕蒙',ARRAY['子明']::text[],'吴中护军，代鲁肃都督军事。','少从孙策征伐，鲁肃卒后代其都督，献策袭荆州，白衣渡江擒关羽，不久病卒于孙权府中。','为孙吴夺回荆州、巩固江东根基。'),
('lu-meng','en','Lü Meng',ARRAY['Ziming']::text[],'A Wu Protector-General who succeeded Lu Su as commander-in-chief.','He campaigned under Sun Ce from youth, succeeded Lu Su as commander after his death, proposed and executed the river-crossing raid that seized Jing Province and captured Guan Yu, then died of illness soon after in Sun Quan’s residence.','To recover Jing Province for Wu and secure the southeast’s foundations.'),
('guan-ping','zh-CN','关平',ARRAY[]::text[],'关羽长子（一说养子），随父镇守荆州。','随父转战荆襄，樊城之役中协助防务，荆州失守后随关羽突围，于临沮被吴军俘获，与父同时遇害。','追随父亲，恪尽子道与臣道。'),
('guan-ping','en','Guan Ping',ARRAY[]::text[],'Guan Yu’s eldest son (by some accounts an adopted son), who garrisoned Jing Province alongside his father.','He campaigned with his father across Jing and Xiang, assisted in the defense during the Fancheng campaign, and after Jing Province fell, was captured with Guan Yu near Linju and killed alongside him.','To follow his father, fulfilling the duties of both son and subordinate.'),
('mi-fang','zh-CN','糜芳',ARRAY['子方']::text[],'糜竺之弟，刘备妻兄，镇守江陵。','早年随刘备起兵，累官至南郡太守，镇守江陵；关羽北伐时供给屡有不继，遭其责备，心生怨望，吕蒙袭荆州时遂开城出降。','因积怨与自保而降吴。'),
('mi-fang','en','Mi Fang',ARRAY['Zifang']::text[],'The younger brother of Mi Zhu and Liu Bei’s brother-in-law, who commanded Jiangling.','He had followed Liu Bei from his early campaigns and rose to Administrator of Nan Commandery, guarding Jiangling; when his supply efforts fell short during Guan Yu’s northern campaign and drew rebuke, he grew resentful, and surrendered the city when Lü Meng’s forces arrived.','Long-standing resentment and self-preservation led him to surrender to Wu.'),
('yu-jin','zh-CN','于禁',ARRAY['文则']::text[],'曹魏名将，督七军救援樊城。','早年从曹操征战，以治军严整著称；建安二十四年奉命救援樊城，值汉水暴涨，七军尽没，遂降于关羽，后被吴所得，遣归魏国，曹丕以画羞辱之，愧愤而卒。','忠于曹魏职守，兵败后以图苟全性命。'),
('yu-jin','en','Yu Jin',ARRAY['Wenze']::text[],'A noted Wei general who commanded the seven relief armies at Fancheng.','He campaigned under Cao Cao from early on, noted for strict discipline; in 219 he was sent to relieve Fancheng, but when the Han River flooded and his seven armies were destroyed, he surrendered to Guan Yu, was later taken by Wu and returned to Wei, where Cao Pi humiliated him with a painting of his surrender, and he died of shame and grief.','Duty-bound service to Wei, and after defeat, a wish simply to survive.'),
('meng-huo','zh-CN','孟获',ARRAY[]::text[],'南中部族首领，诸葛亮南征时的重要对手。','建兴三年诸葛亮南征时为当地渠帅之一，屡与蜀军交锋，终归降蜀汉；此后蜀汉任用南中大姓与部族首领分治其地，南中局势渐趋安定。','保卫部族领地与自治之权。'),
('meng-huo','en','Meng Huo',ARRAY[]::text[],'A chieftain of the Nanzhong tribes, a key adversary during Zhuge Liang’s southern campaign.','During Zhuge Liang’s southern campaign of 225 he was one of the local chieftains who repeatedly clashed with Shu’s forces before finally submitting; Shu Han thereafter relied on local clans and tribal leaders like him to help govern the region, and Nanzhong grew gradually settled.','To defend his tribe’s territory and autonomy.'),
('hua-xin','zh-CN','华歆',ARRAY['子鱼']::text[],'汉末重臣，历仕魏国。','早年以清名著称，历任豫章太守、尚书令等职；曹丕代汉时，华歆领衔百官劝进并督办禅代仪礼，魏国建立后官至相国、司徒。','顺应时势，效忠新朝以保全禄位。'),
('hua-xin','en','Hua Xin',ARRAY['Ziyu']::text[],'A senior official of the late Han who served Wei.','Known early for his upright reputation, he served as Administrator of Yuzhang and Secretariat Director among other posts; when Cao Pi took the throne from Han, Hua Xin led the officials’ petitions and oversaw the abdication ceremony, later rising to Chancellor and Minister over the Masses under Wei.','Adapting to the shifting order, serving the new dynasty to preserve his position.')
) AS v(slug,locale,name,aliases,summary,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

-- Romance (演义) -- 小说叙写 voice.
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('lu-meng','zh-CN','吕蒙',ARRAY['子明']::text[],'吴中大将，本目不知书，后受劝学而智略大进。','小说写吕蒙年少时武勇有余而学问不足，孙权劝其读书，遂发愤攻读，鲁肃大惊其才略之长进；后定计白衣渡江，智赚荆州，然擒杀关羽后不久，忽于庆功宴上七窍流血而死，传说为关羽亡魂索命。','力求上进以证己才，为主公建功立业。'),
('lu-meng','en','Lü Meng',ARRAY['Ziming']::text[],'A Wu general once dismissed as illiterate, until study transformed his strategic insight.','The novel has young Lü Meng strong in arms but weak in learning until Sun Quan urges him to study, after which Lu Su marvels at his transformed insight; he later devises the disguised river crossing that wins Jing Province, but soon after Guan Yu’s death, he collapses bleeding from every orifice at a victory feast, said to be claimed by Guan Yu’s vengeful spirit.','A drive for self-improvement to prove his worth and win glory for his lord.'),
('guan-ping','zh-CN','关平',ARRAY[]::text[],'关羽义子，忠勇随父。','小说写关平自幼随父习武，随侍左右从无懈怠，樊城水淹七军一役中屡建战功；荆州陷落后随父突围，兵败被擒，慷慨赴死，无愧忠义家风。','效忠义父，共赴生死。'),
('guan-ping','en','Guan Ping',ARRAY[]::text[],'Guan Yu’s adopted son, loyal and brave.','The novel has Guan Ping trained in arms at his father’s side from childhood, serving without lapse and distinguishing himself at the flooding of the seven armies at Fancheng; after Jing Province falls, he breaks out with his father, is captured in defeat, and dies with composure, true to his family’s code of loyalty.','Devotion to his adoptive father, sharing his fate to the end.'),
('mi-fang','zh-CN','糜芳',ARRAY['子方']::text[],'刘备内兄，性情狭隘，畏罪降吴。','小说写糜芳与傅士仁同守荆州后方，因督办军需不力受关羽当众斥责，二人惧祸，遂于吕蒙兵至时开门迎降，致使荆州瓦解。','畏罪自保，怨怼积怒之下叛主降敌。'),
('mi-fang','en','Mi Fang',ARRAY['Zifang']::text[],'Liu Bei’s brother-in-law, narrow-minded and quick to surrender out of fear.','The novel has Mi Fang and Fu Shiren, guarding Jing Province’s rear, publicly rebuked by Guan Yu over failed supply efforts; fearing for their lives, the two open the gates to Lü Meng’s approaching army, precipitating Jing Province’s collapse.','Fear of punishment and accumulated resentment drove him to betray his lord and surrender to the enemy.'),
('yu-jin','zh-CN','于禁',ARRAY['文则']::text[],'魏之宿将，畏死而降，归魏后见画羞愧而亡。','小说写于禁素以持重稳健著称，樊城之役中却因贪生降敌，与副将庞德宁死不屈形成鲜明对比；后归魏国，曹丕特绘关羽水淹七军、于禁降服之图羞辱之，于禁见画羞愤成疾而死。','兵败势穷，苟且偷生。'),
('yu-jin','en','Yu Jin',ARRAY['Wenze']::text[],'A veteran Wei general who surrendered out of fear and later died of shame.','The novel portrays Yu Jin, long known for cautious steadiness, surrendering out of fear for his life at Fancheng, in sharp contrast to his deputy Pang De’s defiant death; on his return to Wei, Cao Pi has a painting made of the flood and his surrender to shame him, and Yu Jin dies of shame and illness upon seeing it.','Facing hopeless defeat, a desperate wish to cling to life.'),
('meng-huo','zh-CN','孟获',ARRAY[]::text[],'南蛮王，勇猛而多疑，七擒七纵后心悦诚服。','小说写孟获自恃地利与蛮兵之勇，屡次起兵抗蜀，屡战屡败却不肯心服；经诸葛亮七擒七纵，恩威并施，终于第七次被擒后涕泣拜服，率部众永不复反，蜀汉南疆自此宁靖。','捍卫部族尊严，兵败后为诸葛亮恩义所感化。'),
('meng-huo','en','Meng Huo',ARRAY[]::text[],'King of the southern tribes, fierce but suspicious, won over only after seven captures.','The novel has Meng Huo, relying on terrain and the ferocity of his tribal warriors, repeatedly rise against Shu, losing every battle yet refusing to yield, until after being captured and released seven times by Zhuge Liang’s mixture of severity and mercy, he weeps and submits on the seventh capture, leading his people to never rebel again, settling Shu’s southern frontier.','To defend his tribe’s dignity, until moved at last by Zhuge Liang’s combination of severity and grace after repeated defeat.'),
('hua-xin','zh-CN','华歆',ARRAY['子鱼']::text[],'魏廷重臣，逼迫汉献帝禅位的主谋之一。','小说写华歆手持利剑，威逼献帝当廷交出玉玺，言辞逼迫，毫无人臣之礼；后又在朝堂之上带头劝进曹丕称帝，被塑造为趋附新贵、助纣为虐的反面角色。','攀附新贵，谋取禅代之功以自保富贵。'),
('hua-xin','en','Hua Xin',ARRAY['Ziyu']::text[],'A senior Wei courtier portrayed as a chief instigator of the forced abdication.','The novel has Hua Xin, sword in hand, threaten Emperor Xian into surrendering the imperial seal before the court with none of a minister’s proper deference; he later leads the petitions urging Cao Pi to take the throne, cast as a villainous figure who toadies to the rising power and abets its wrongdoing.','Currying favor with the rising power, seeking credit for the transition to secure his own wealth and standing.')
) AS v(slug,locale,name,aliases,summary,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. LOCATIONS (minor, 3 per work: Xiaoting + Langzhong owned by KK07,
--    Wuchang owned by KK08; all real, reuse existing 38 for everything else)
-- -------------------------------------------------------------------------
INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
-- Records (志)
('36000000-0000-4000-8007-000000000001','10000000-0000-4000-8000-000000000006','xiaoting','real',ST_GeogFromText('POINT(111.4667 30.6333)'),NULL,NULL,701,'battlefield','inferred',13,'CN',true,true),
('36000000-0000-4000-8007-000000000002','10000000-0000-4000-8000-000000000006','langzhong','real',ST_GeogFromText('POINT(105.9739 31.5814)'),NULL,NULL,702,'city','city_centroid',11,'CN',false,true),
('36000000-0000-4000-8008-000000000001','10000000-0000-4000-8000-000000000006','wuchang','real',ST_GeogFromText('POINT(114.8952 30.3928)'),NULL,NULL,801,'city','approximate',11,'CN',true,true),
-- Romance (演义)
('37000000-0000-4000-8007-000000000001','10000000-0000-4000-8000-000000000007','xiaoting','real',ST_GeogFromText('POINT(111.4667 30.6333)'),NULL,NULL,701,'battlefield','inferred',13,'CN',true,true),
('37000000-0000-4000-8007-000000000002','10000000-0000-4000-8000-000000000007','langzhong','real',ST_GeogFromText('POINT(105.9739 31.5814)'),NULL,NULL,702,'city','city_centroid',11,'CN',false,true),
('37000000-0000-4000-8008-000000000001','10000000-0000-4000-8000-000000000007','wuchang','real',ST_GeogFromText('POINT(114.8952 30.3928)'),NULL,NULL,801,'city','approximate',11,'CN',true,true);

INSERT INTO location_translations(location_id,locale,name,summary,status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',v.region FROM locations l JOIN (VALUES
('xiaoting','zh-CN','猇亭','夷陵之战决胜地，陆逊在此以火攻大破刘备连营。','荆州夷陵'),
('xiaoting','en','Xiaoting','The decisive site of the Battle of Yiling, where Lu Xun’s fire attack broke Liu Bei’s linked camps.','Yiling, Jing Province'),
('langzhong','zh-CN','阆中','张飞镇守巴西的治所，其为部将所刺杀之地。','巴西郡'),
('langzhong','en','Langzhong','The seat where Zhang Fei governed Baxi, and the place where he was assassinated by his own officers.','Ba Xi Commandery'),
('wuchang','zh-CN','武昌','孙权称帝登基之地，其后迁都建业。','江夏'),
('wuchang','en','Wuchang','Where Sun Quan proclaimed himself emperor before moving the capital to Jianye.','Jiangxia')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug
WHERE l.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 3. EVENTS (new). KK=07 chapter 'jing-province-and-yiling' (219-222/223),
--    KK=08 chapter 'three-thrones' (220-229). time_type/calendar 'julian'
--    for dated events; the Yuquan Temple legend has no fixed date.
-- -------------------------------------------------------------------------

-- Records (志) KK07 -- 7 events, sequence 7001-7013 step 2
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('64000000-0000-4000-8007-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,v.cal::calendar_system,v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'liu-bei-proclaimed-king-of-hanzhong',7001,'verified_historical','political','exact','julian',219,219,'high'),
(2,'guan-yu-floods-seven-armies',7003,'verified_historical','battle','exact','julian',219,219,'high'),
(3,'lu-meng-seizes-jing-province',7005,'verified_historical','betrayal','exact','julian',219,219,'high'),
(4,'guan-yu-defeated-at-maicheng',7007,'verified_historical','death','exact','julian',220,220,'high'),
(5,'zhang-fei-murdered-by-subordinates',7009,'verified_historical','betrayal','exact','julian',221,221,'high'),
(6,'liu-bei-invades-wu',7011,'verified_historical','battle','range','julian',221,222,'high'),
(7,'liu-bei-entrusts-orphan-at-baidicheng',7013,'verified_historical','death','exact','julian',223,223,'high')
) AS v(n,slug,seq,reality,etype,ttype,cal,y1,y2,conf)
JOIN chapters ch ON ch.slug='jing-province-and-yiling' AND ch.work_id='10000000-0000-4000-8000-000000000006';

-- Romance (演义) KK07 -- 11 events (7 shared slugs + 4 romance-only),
-- sequence 7001-7021 step 2
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('65000000-0000-4000-8007-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,v.cal::calendar_system,v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'liu-bei-proclaimed-king-of-hanzhong',7001,'fictional_with_historical_context','political','exact','julian',219,219,'medium'),
(2,'guan-yu-floods-seven-armies',7003,'fictional_with_historical_context','battle','exact','julian',219,219,'medium'),
(3,'guan-yu-scrapes-poison-from-bone',7005,'fictional_with_historical_context','other','exact','julian',219,219,'low'),
(4,'lu-meng-seizes-jing-province',7007,'fictional_with_historical_context','betrayal','exact','julian',219,219,'medium'),
(5,'guan-yu-defeated-at-maicheng',7009,'fictional_with_historical_context','death','exact','julian',220,220,'medium'),
(6,'guan-yu-manifests-at-yuquan-temple',7011,'legendary_or_mythic','religious','unknown','unknown',NULL,NULL,'low'),
(7,'zhang-fei-murdered-by-subordinates',7013,'fictional_with_historical_context','betrayal','exact','julian',221,221,'medium'),
(8,'liu-bei-vows-revenge-for-his-brothers',7015,'fictional_with_historical_context','other','exact','julian',221,221,'low'),
(9,'liu-bei-invades-wu',7017,'fictional_with_historical_context','battle','range','julian',221,222,'medium'),
(10,'lu-xun-burns-the-linked-camps',7019,'fictional_with_historical_context','battle','exact','julian',222,222,'medium'),
(11,'liu-bei-entrusts-orphan-at-baidicheng',7021,'fictional_with_historical_context','death','exact','julian',223,223,'medium')
) AS v(n,slug,seq,reality,etype,ttype,cal,y1,y2,conf)
JOIN chapters ch ON ch.slug='jing-province-and-yiling' AND ch.work_id='10000000-0000-4000-8000-000000000007';

-- Records (志) KK08 -- 7 events, sequence 8001-8013 step 2
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('64000000-0000-4000-8008-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,v.cal::calendar_system,v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'cao-pi-accepts-han-abdication',8001,'verified_historical','political','exact','julian',220,220,'high'),
(2,'liu-bei-proclaims-emperor-at-chengdu',8003,'verified_historical','political','exact','julian',221,221,'high'),
(3,'zhuge-liang-becomes-chancellor-of-shu',8005,'verified_historical','political','exact','julian',221,221,'high'),
(4,'cao-pi-campaigns-against-wu',8007,'verified_historical','battle','range','julian',222,223,'medium'),
(5,'zhuge-liang-pacifies-nanzhong',8009,'reported_historical','battle','exact','julian',225,225,'medium'),
(6,'zhuge-liang-submits-the-memorial-on-the-expedition',8011,'verified_historical','political','exact','julian',227,227,'high'),
(7,'sun-quan-proclaims-emperor',8013,'verified_historical','political','exact','julian',229,229,'high')
) AS v(n,slug,seq,reality,etype,ttype,cal,y1,y2,conf)
JOIN chapters ch ON ch.slug='three-thrones' AND ch.work_id='10000000-0000-4000-8000-000000000006';

-- Romance (演义) KK08 -- 8 events (6 shared slugs + 2 romance-only: the
-- shared Nanzhong campaign plus the fictional-narrative seven-captures
-- elaboration), sequence 8001-8015 step 2
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('65000000-0000-4000-8008-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,v.cal::calendar_system,v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'cao-pi-accepts-han-abdication',8001,'fictional_with_historical_context','political','exact','julian',220,220,'medium'),
(2,'liu-bei-proclaims-emperor-at-chengdu',8003,'fictional_with_historical_context','political','exact','julian',221,221,'medium'),
(3,'zhuge-liang-becomes-chancellor-of-shu',8005,'fictional_with_historical_context','political','exact','julian',221,221,'medium'),
(4,'cao-pi-campaigns-against-wu',8007,'fictional_with_historical_context','battle','range','julian',222,223,'medium'),
(5,'zhuge-liang-pacifies-nanzhong',8009,'fictional_with_historical_context','battle','exact','julian',225,225,'medium'),
(6,'meng-huo-captured-seven-times',8011,'fictional_narrative','battle','exact','julian',225,225,'low'),
(7,'zhuge-liang-submits-the-memorial-on-the-expedition',8013,'fictional_with_historical_context','political','exact','julian',227,227,'medium'),
(8,'sun-quan-proclaims-emperor',8015,'fictional_with_historical_context','political','exact','julian',229,229,'medium')
) AS v(n,slug,seq,reality,etype,ttype,cal,y1,y2,conf)
JOIN chapters ch ON ch.slug='three-thrones' AND ch.work_id='10000000-0000-4000-8000-000000000007';

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------

-- Records (志) KK07
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('liu-bei-proclaimed-king-of-hanzhong','zh-CN','刘备称汉中王','志载刘备取汉中后，群下劝进，遂自立为汉中王。','建安二十四年，刘备破曹操于汉中，斩夏侯渊，遂据汉中；诸葛亮、法正等联名劝进，刘备乃于沔阳设坛，自称汉中王，拜关羽为前将军。','汉中称王是刘备称帝前的关键一步，正式确立其与曹操分庭抗礼之势。','公元219年'),
('liu-bei-proclaimed-king-of-hanzhong','en','Liu Bei proclaimed King of Hanzhong','The Records records Liu Bei’s officers urging him to take the title King of Hanzhong after he secured the region.','In 219, having defeated Cao Cao’s forces at Hanzhong and killed Xiahou Yuan, Liu Bei held the territory; Zhuge Liang, Fa Zheng, and others petitioned him to take a royal title, and he was enthroned at Mianyang, naming Guan Yu General of the Front.','The Hanzhong kingship was the decisive step before Liu Bei’s later imperial claim, formally setting him against Cao Cao as an equal power.','c. 219 CE'),
('guan-yu-floods-seven-armies','zh-CN','关羽水淹七军','志载关羽围樊城，值汉水暴涨，尽淹于禁所率七军，擒于禁、斩庞德。','建安二十四年秋，关羽自江陵北攻樊城，曹仁婴城固守；会汉水暴涨，于禁所督七军皆没，关羽乘船逼降于禁，又斩庞德，威震华夏。','此役是关羽军事生涯的巅峰，一度动摇曹操迁都之议。','公元219年'),
('guan-yu-floods-seven-armies','en','Guan Yu floods the seven armies','The Records records Guan Yu besieging Fancheng when a flood of the Han River drowned Yu Jin’s seven relieving armies.','In the autumn of 219, Guan Yu advanced north from Jiangling to besiege Fancheng, held by Cao Ren; a sudden rise of the Han River swamped the seven armies under Yu Jin, and Guan Yu forced Yu Jin’s surrender by boat and killed Pang De, his fame shaking all of Han territory.','This was the peak of Guan Yu’s military career, briefly prompting Cao Cao to consider moving the capital.','c. 219 CE'),
('lu-meng-seizes-jing-province','zh-CN','吕蒙袭取荆州','志载吕蒙白衣渡江，兵不血刃取江陵，糜芳、士仁相继出降。','吕蒙代鲁肃都督荆州事，佯称病重，使陆逊代己以麻痹关羽；关羽悉发江陵之兵北攻樊城，吕蒙乘虚率精兵伪装商旅昼夜兼行，袭据江陵，守将糜芳、士仁不战而降。','荆州之失使关羽陷入腹背受敌之境，直接导致其败亡。','公元219年'),
('lu-meng-seizes-jing-province','en','Lü Meng seizes Jing Province','The Records records Lü Meng crossing the river disguised as merchants to take Jiangling without a fight, as Mi Fang and Fu Shiren surrendered in turn.','Lü Meng, having succeeded Lu Su as Wu’s commander, feigned serious illness and let Lu Xun take his place to lull Guan Yu’s guard; when Guan Yu committed Jiangling’s garrison to the siege of Fancheng, Lü Meng led picked troops disguised as merchants upriver day and night to seize Jiangling, and its defenders Mi Fang and Fu Shiren surrendered without resistance.','The loss of Jing Province left Guan Yu caught between two fronts, directly leading to his downfall.','c. 219 CE'),
('guan-yu-defeated-at-maicheng','zh-CN','关羽败走麦城','志载关羽闻荆州已失，回军至麦城，兵散势穷，为吴将所获遇害。','关羽自樊城撤围南归，士卒闻荆州失陷，多不战自溃；关羽退保麦城，兵少粮尽，乃率数十骑突围西走，至临沮为吴将潘璋部所擒，与子关平俱被害。','关羽之死标志荆州彻底易主，孙刘联盟自此破裂。','公元220年'),
('guan-yu-defeated-at-maicheng','en','Guan Yu’s defeat at Maicheng','The Records records Guan Yu retreating to Maicheng on hearing of Jing Province’s loss, his forces scattering until Wu troops captured and killed him.','Guan Yu lifted the siege of Fancheng and turned south, but his soldiers, hearing of Jiangling’s fall, deserted without a fight; he held Maicheng with dwindling troops and supplies, then broke out westward with a few dozen riders, only to be captured near Linju by Wu forces under Pan Zhang and killed along with his son Guan Ping.','Guan Yu’s death marked Jing Province’s final change of hands and the effective collapse of the Sun-Liu alliance.','c. 220 CE'),
('zhang-fei-murdered-by-subordinates','zh-CN','张飞遇害','志载张飞将兴兵伐吴，鞭挞健儿过甚，为部将张达、范强所刺杀。','章武元年，刘备将东征孙吴，命张飞率兵万人自阆中赴江州会师；张飞暴而无恩，日夜鞭挞士卒，帐下张达、范强惧祸，乘夜刺杀张飞，携其首级投奔孙权。','张飞之死使刘备伐吴又折一员大将，亦见蜀汉内部军纪之隐患。','公元221年'),
('zhang-fei-murdered-by-subordinates','en','Zhang Fei murdered by his subordinates','The Records records Zhang Fei, preparing to campaign against Wu, being assassinated by his own officers after excessive flogging of his men.','In 221, as Liu Bei prepared his campaign against Wu, Zhang Fei was ordered to lead troops from Langzhong to rendezvous at Jiangzhou; harsh and given to flogging his soldiers day and night, his subordinates Zhang Da and Fan Qiang, fearing for their lives, assassinated him by night and fled with his head to Sun Quan.','Zhang Fei’s death cost Liu Bei another senior general before the Wu campaign even began, exposing the fragile discipline within Shu Han’s ranks.','c. 221 CE'),
('liu-bei-invades-wu','zh-CN','刘备伐吴','志载刘备率军东征孙吴，欲夺回荆州，连营据守峡口，与陆逊相持经年。','章武元年七月，刘备率诸将东征，攻破巫县、秭归，进兵至夷陵；孙权遣使求和不成，乃以陆逊为大都督拒之；两军相持逾半年，蜀军于山林间连营立寨以避暑。','此役是蜀汉建国后首次重大军事行动，其胜负决定荆益二州的最终归属。','公元221–222年'),
('liu-bei-invades-wu','en','Liu Bei’s campaign against Wu','The Records records Liu Bei leading an eastern campaign to reclaim Jing Province, his forces linking camps along the gorges in a prolonged standoff with Lu Xun.','In the seventh month of 221, Liu Bei led his generals eastward, taking Wu and Zigui counties before advancing to Yiling; Sun Quan’s peace overtures failed, so he appointed Lu Xun as commander-in-chief to resist, and the two armies faced off for over half a year, with Shu’s forces linking camps through the wooded hills to escape the summer heat.','This was Shu Han’s first major military undertaking after its founding, and its outcome would decide the final ownership of Jing and Yi Provinces.','221–222 CE'),
('liu-bei-entrusts-orphan-at-baidicheng','zh-CN','白帝托孤','志载刘备兵败退保白帝城，病笃之际召诸葛亮托付后事。','章武二年，刘备夷陵战败，退驻永安（白帝城），忧愤成疾；次年四月，病笃，召诸葛亮、李严至永安宫，嘱以后事，谓亮“君才十倍曹丕，必能安国，终定大事；若嗣子可辅，辅之，如其不才，君可自取”，亮涕泣受命。','白帝托孤确立诸葛亮此后主政蜀汉的合法地位，是蜀汉政治史上的关键转折。','公元223年'),
('liu-bei-entrusts-orphan-at-baidicheng','en','Liu Bei entrusts his heir at Baidicheng','The Records records Liu Bei, defeated and ailing at Baidicheng, summoning Zhuge Liang to entrust him with the affairs of state.','After his defeat at Yiling in 222, Liu Bei retreated to Yong’an (Baidicheng) and fell ill from grief; in the fourth month of 223, gravely ill, he summoned Zhuge Liang and Li Yan to the palace and told Zhuge Liang, “Your talent exceeds Cao Pi’s tenfold; you will surely stabilise the state and settle great affairs. If my heir can be aided, aid him; if he lacks ability, you may take the throne yourself.” Zhuge Liang wept and accepted the charge.','The Baidicheng entrustment established Zhuge Liang’s legitimacy to govern Shu Han thereafter, a pivotal turning point in its political history.','c. 223 CE')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000006' AND e.id::text LIKE '64000000-0000-4000-8007%';

-- Romance (演义) KK07
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('liu-bei-proclaimed-king-of-hanzhong','zh-CN','刘备称汉中王','小说叙写刘备既定汉中，众将同表劝进，遂筑坛称王。','罗贯中据史敷演，写诸将合词劝进，刘备再三谦让方才受命，设坛于沔阳，昭告天地，自立为汉中王，封关羽、张飞、赵云、马超、黄忠为五虎大将。','小说借此渲染刘备集团鼎盛之势，为后文荆州之失埋下荣极而衰的伏笔。','公元219年'),
('liu-bei-proclaimed-king-of-hanzhong','en','Liu Bei proclaimed King of Hanzhong','The novel dramatises Liu Bei’s officers jointly petitioning him to take the throne after Hanzhong is secured.','The novel has the assembled generals press Liu Bei repeatedly before he accepts, building an altar at Mianyang to proclaim himself King of Hanzhong and naming Guan Yu, Zhang Fei, Zhao Yun, Ma Chao, and Huang Zhong as his Five Tiger Generals.','The novel uses this peak of glory to foreshadow the reversal of fortune that follows with the loss of Jing Province.','c. 219 CE'),
('guan-yu-floods-seven-armies','zh-CN','关羽水淹七军','小说铺陈关羽预判秋汛，决堤放水，生擒于禁、力斩庞德。','小说写关羽登高观测，见罾口川一带地势低洼，预料秋雨必涨，遂命人预筑堤坝，待水势既成便决堤放水，于禁七军尽没，庞德死战不降而被擒斩。','小说渲染关羽用兵如神，将天时地利归功于其个人智略，衬托其“武圣”形象。','公元219年'),
('guan-yu-floods-seven-armies','en','Guan Yu floods the seven armies','The novel dramatises Guan Yu foreseeing the autumn floods and breaking a dam to drown Yu Jin’s relieving force.','The novel has Guan Yu survey the low ground around Zengkou creek, anticipate the seasonal rains, order dikes built in advance, and release the pent floodwaters at the right moment, drowning Yu Jin’s armies while Pang De fights to the last before capture and execution.','The novel credits Guan Yu’s personal foresight for what was in part a natural disaster, reinforcing his image as a peerless warrior-sage.','c. 219 CE'),
('guan-yu-scrapes-poison-from-bone','zh-CN','刮骨疗毒','小说叙写关羽右臂中毒箭，延医刮骨去毒，谈笑对弈自若。','小说写关羽围樊城时中毒箭，毒入于骨，医者为其刮骨疗毒，血流盈盘，关羽却与马良弈棋饮酒，谈笑自若，毫无痛楚之色。','小说借此塑造关羽刚毅不屈的形象，成为其“武圣”人格的经典场景之一。','公元219年'),
('guan-yu-scrapes-poison-from-bone','en','Scraping poison from the bone','The novel depicts Guan Yu having a physician scrape poison from his arm bone while he plays chess unmoved by the pain.','The novel has Guan Yu take a poisoned arrow to the arm during the siege of Fancheng; a physician scrapes the bone clean of poison as blood fills a basin, while Guan Yu calmly plays chess and drinks wine with Ma Liang, showing no sign of pain.','The scene builds Guan Yu’s image of iron composure, becoming one of the defining episodes of his legendary stoicism.','c. 219 CE'),
('lu-meng-seizes-jing-province','zh-CN','吕蒙袭取荆州','小说叙写吕蒙白衣渡江，智赚烽火台，江陵、公安相继失守。','小说写吕蒙诈病辞职，荐陆逊代之，使关羽轻敌尽撤荆州守兵；吕蒙令精兵扮作商贾，暗藏刀甲于船中，昼伏夜行，赚过沿江烽火台，一举袭破江陵，糜芳、士仁开门迎降。','小说以“白衣渡江”渲染吕蒙用计之巧，为关羽“大意失荆州”的评语提供情节支点。','公元219年'),
('lu-meng-seizes-jing-province','en','Lü Meng seizes Jing Province','The novel dramatises Lü Meng’s disguised river crossing and the trick that fooled the watchtowers guarding Jiangling and Gong’an.','The novel has Lü Meng feign illness and recommend Lu Xun in his place so Guan Yu withdraws Jing Province’s garrisons in overconfidence; Lü Meng then disguises his elite troops as merchants with weapons hidden aboard, traveling by night to slip past the river watchtowers and seize Jiangling outright, with Mi Fang and Fu Shiren opening their gates to surrender.','The novel’s telling of the disguised crossing gives narrative substance to the later verdict that Guan Yu lost Jing Province through overconfidence.','c. 219 CE'),
('guan-yu-defeated-at-maicheng','zh-CN','关羽败走麦城','小说叙写关羽众叛亲离，孤守麦城，突围遇伏而死，忠义之名传于后世。','小说渲染关羽归途中将士纷纷投降，廖化突围求救无援，关羽父子退守麦城，夜半率残部突围，中吴军埋伏，父子皆被擒，宁死不降，慷慨就义。','小说将关羽之死处理为“忠义”精神的极致展现，奠定其后世“武圣”地位的叙事基础。','公元220年'),
('guan-yu-defeated-at-maicheng','en','Guan Yu’s defeat at Maicheng','The novel depicts Guan Yu abandoned by his own troops, making a last stand at Maicheng before falling into an ambush with his son.','The novel has Guan Yu’s soldiers desert in droves on the retreat, Liao Hua’s plea for reinforcements go unanswered, and father and son hold Maicheng before breaking out by night, only to ride into a Wu ambush; both are captured and, refusing to surrender, die defiantly.','The novel frames Guan Yu’s death as the ultimate expression of loyalty and righteousness, the narrative foundation of his later status as a warrior-sage.','c. 220 CE'),
('guan-yu-manifests-at-yuquan-temple','zh-CN','玉泉山关公显圣','小说叙写关羽亡魂夜绕玉泉山，呼普静点化，自此显圣护佑一方。','小说写关羽父子被害后，英魂不散，夜叩玉泉山普净禅师之门，高呼“还我头来”；普净以因果之理点化，关羽顿悟前愆，自此常显灵验，乡人建祠祀之。','小说借神异情节将关羽由历史人物提升为超越生死的神明形象，呼应其后世武圣、财神信仰的形成。','约公元220年后不久'),
('guan-yu-manifests-at-yuquan-temple','en','Guan Yu’s spirit manifests at Yuquan Temple','The novel recounts Guan Yu’s unquiet spirit circling Mount Yuquan by night, crying out until the monk Puqing brings him to enlightenment.','After his death, the novel has Guan Yu’s spirit haunt Mount Yuquan, crying “Give me back my head,” until the monk Puqing explains the chain of cause and consequence; Guan Yu awakens to his past debts and thereafter manifests as a protective spirit, honored with a local shrine.','This legendary episode elevates Guan Yu from historical figure to a deity beyond death, foreshadowing his later cult as a god of war and wealth.','shortly after 220 CE'),
('zhang-fei-murdered-by-subordinates','zh-CN','张飞遇害','小说叙写张飞悲愤义兄之死，酗酒鞭挞部将，终遭张达、范强割首而去。','小说写张飞闻关羽死讯，痛哭至于呕血，日夜借酒浇愁，鞭挞部将限期置办白旗白甲；末将张达、范强求宽限不得，惧于死罪，乘张飞醉卧帐中，割其首级，连夜投奔东吴。','小说将张飞之死与关羽之死并置，渲染桃园结义“同生共死”的悲剧闭环，深化蜀汉集团盛极而衰的主题。','公元221年'),
('zhang-fei-murdered-by-subordinates','en','Zhang Fei murdered by his subordinates','The novel depicts Zhang Fei, grief-stricken and drinking heavily over Guan Yu’s death, flogging his officers until two of them cut off his head.','The novel has Zhang Fei weep until he vomits blood on hearing of Guan Yu’s death, drown his grief in wine, and flog his officers Zhang Da and Fan Qiang over an impossible deadline for white banners and armor; fearing execution, the two murder him in his drunken sleep and flee by night to Eastern Wu with his head.','The novel pairs Zhang Fei’s death with Guan Yu’s to complete the tragic circle of the Peach Garden oath’s vow to die together, deepening the theme of Shu Han’s fall from its peak.','c. 221 CE'),
('liu-bei-vows-revenge-for-his-brothers','zh-CN','刘备誓师复仇','小说叙写刘备闻二弟惨死，不顾群臣劝阻，誓师伐吴以复兄弟之仇。','小说写刘备闻张飞遇害，昏绝于地，醒后不听赵云、秦宓等苦谏，坚持起倾国之兵七十余万伐吴，誓与东吴不共戴天，为关羽、张飞报仇。','小说将伐吴之役的动机由单纯的荆州之争，改写为义气至上的复仇叙事，凸显刘备重情而失于理智的性格弱点。','公元221年'),
('liu-bei-vows-revenge-for-his-brothers','en','Liu Bei vows revenge for his brothers','The novel depicts Liu Bei, overriding his ministers’ objections, swearing to avenge his sworn brothers by launching a full invasion of Wu.','The novel has Liu Bei collapse in grief on hearing of Zhang Fei’s murder, then refuse the pleas of Zhao Yun and Qin Mi and others, raising a host of over seven hundred thousand to swear undying enmity with Wu and avenge Guan Yu and Zhang Fei.','The novel recasts the campaign against Wu from a territorial dispute over Jing Province into a revenge narrative driven by brotherhood, highlighting Liu Bei’s fatal weakness for sentiment over strategy.','c. 221 CE'),
('liu-bei-invades-wu','zh-CN','刘备伐吴','小说铺陈刘备七十万大军连营七百里，声势浩大直逼东吴。','小说写刘备亲统七十五万大军，连破东吴数十营寨，直抵夷陵、猇亭一线，安营下寨绵延七百余里，声威震动江东；陆逊临危受命，坚守不战，静待蜀军师老兵疲。','小说以夸张的兵力与连营规模渲染战事之烈，为后文火烧连营的惨败作足铺垫。','公元221–222年'),
('liu-bei-invades-wu','en','Liu Bei’s campaign against Wu','The novel depicts Liu Bei’s seven hundred thousand troops linking camps across seven hundred li, their momentum bearing down on Eastern Wu.','The novel has Liu Bei personally command seven hundred fifty thousand troops, breaking through dozens of Wu encampments to reach the Yiling-Xiaoting line, his linked camps stretching over seven hundred li and shaking the southeast; Lu Xun, given command in the crisis, holds firm and refuses battle, waiting for the Shu army to exhaust itself.','The novel’s exaggerated troop numbers and sprawling camps dramatise the scale of the campaign, setting up the devastating fire attack that follows.','221–222 CE'),
('lu-xun-burns-the-linked-camps','zh-CN','陆逊火烧连营','小说叙写陆逊窥破蜀军虚实，乘风纵火，连营七百里毁于一旦。','小说写陆逊登高遍观蜀营，见其扎寨于林木之间，料定可用火攻；遂命各营将士各持茅草，乘夜顺风纵火，蜀军连营相继延烧，刘备仅率残部突围逃往白帝城。','小说将此役写作全书又一场以弱胜强的经典战役，与赤壁之战遥相呼应，终结了刘备复夺荆州的希望。','公元222年'),
('lu-xun-burns-the-linked-camps','en','Lu Xun burns the linked camps','The novel depicts Lu Xun spotting the weakness in Shu’s wooded encampments and setting them ablaze in a single night of wind-driven fire.','The novel has Lu Xun survey the Shu camps from high ground, notice they are pitched among trees, and judge a fire attack feasible; he orders his troops to carry bundles of dry grass and set them alight by night with the wind at their backs, and the linked camps burn one after another while Liu Bei escapes with only a remnant of his force to Baidicheng.','The novel presents this as another classic victory of the weak over the strong, echoing Red Cliffs, and it ends Liu Bei’s hope of retaking Jing Province.','c. 222 CE'),
('liu-bei-entrusts-orphan-at-baidicheng','zh-CN','白帝托孤','小说叙写刘备泣托诸葛亮，君臣相对而泣，遗命扶保幼主。','小说写刘备自知大限将至，急召诸葛亮星夜赴永安，泣言托孤之语，又唤刘禅兄弟出拜丞相为父，命其“事之如父”；诸葛亮顿首流血，誓竭股肱之力，效忠贞之节，继之以死。','小说将此情节渲染为君臣知遇的至高典范，“鞠躬尽瘁，死而后已”的诸葛亮形象由此奠定。','公元223年'),
('liu-bei-entrusts-orphan-at-baidicheng','en','Liu Bei entrusts his heir at Baidicheng','The novel dramatises Liu Bei weeping as he entrusts Zhuge Liang with his sons, sovereign and minister in tears together.','The novel has Liu Bei, sensing his end near, summon Zhuge Liang through the night to Yong’an, tearfully speak the words of entrustment, and call Liu Shan and his brothers to bow to the chancellor as their father, ordering them to “serve him as you would me”; Zhuge Liang bows until his head bleeds, vowing to serve with every last effort unto death.','The novel elevates this scene into the supreme model of trust between sovereign and minister, cementing Zhuge Liang’s image of devoted service “to the last breath.”','c. 223 CE')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000007' AND e.id::text LIKE '65000000-0000-4000-8007%';

-- Records (志) KK08
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('cao-pi-accepts-han-abdication','zh-CN','曹丕代汉称帝','志载汉献帝禅位于曹丕，曹丕受禅登基，改元黄初，汉祚遂终。','延康元年十月，群臣屡劝进，华歆等奉表逼献帝禅位；曹丕于繁阳筑受禅坛，三让而后受，即皇帝位，改国号为魏，改元黄初，封汉献帝为山阳公。','曹丕代汉标志着延续四百余年的两汉皇统正式终结，三国鼎立之局由此揭幕。','公元220年'),
('cao-pi-accepts-han-abdication','en','Cao Pi accepts Han’s abdication','The Records records Emperor Xian of Han abdicating to Cao Pi, who accepted the throne and ended four centuries of Han rule.','In the tenth month of 220, after repeated petitions from his officials, with Hua Xin among those pressing Emperor Xian to abdicate, Cao Pi built an altar at Fanyang and, after declining three times, accepted the throne, renaming the state Wei, changing the era name to Huangchu, and enfeoffing Emperor Xian as Duke of Shanyang.','Cao Pi’s founding of Wei formally ended the four-century-long Han imperial line, opening the era of the Three Kingdoms’ formal division.','c. 220 CE'),
('liu-bei-proclaims-emperor-at-chengdu','zh-CN','刘备称帝','志载刘备闻汉献帝已逊位，遂于成都称帝，建国号汉，改元章武。','章武元年四月，诸葛亮等以汉祚不可无主为由劝进，刘备乃于成都武担山之南筑坛即皇帝位，国号仍称汉（史家习称蜀汉），改元章武，立吴氏为皇后，刘禅为皇太子。','刘备称帝延续汉室正统名分，使三方鼎立之局正式确立法理基础。','公元221年'),
('liu-bei-proclaims-emperor-at-chengdu','en','Liu Bei proclaims himself emperor','The Records records Liu Bei, on learning of Emperor Xian’s abdication, proclaiming himself emperor at Chengdu under the continued name of Han.','In the fourth month of 221, Zhuge Liang and others argued that the Han line could not go without a sovereign and urged him to take the throne; Liu Bei built an altar south of Mount Wudan at Chengdu and proclaimed himself emperor, keeping the dynastic name Han (later historians call it Shu Han), changing the era name to Zhangwu, and naming Lady Wu empress and Liu Shan crown prince.','Liu Bei’s enthronement claimed continuity with Han’s legitimate line, formally establishing the legal basis for the three-way division of the realm.','c. 221 CE'),
('zhuge-liang-becomes-chancellor-of-shu','zh-CN','诸葛亮拜丞相','志载刘备称帝后，即拜诸葛亮为丞相，录尚书事，总揽蜀汉军政。','刘备即位，以诸葛亮为丞相，许靖为司徒；丞相府总理蜀汉军政要务，诸葛亮自此以丞相身份辅佐刘备，后又受遗诏辅政幼主。','丞相一职的确立使诸葛亮成为蜀汉实际的行政中枢，为其日后独揽朝政、推行北伐奠定制度基础。','公元221年'),
('zhuge-liang-becomes-chancellor-of-shu','en','Zhuge Liang becomes chancellor of Shu','The Records records Liu Bei appointing Zhuge Liang chancellor immediately upon his enthronement, overseeing Shu Han’s military and civil administration.','On taking the throne, Liu Bei named Zhuge Liang chancellor and Xu Jing Minister over the Masses; the chancellery took charge of Shu Han’s key military and civil affairs, with Zhuge Liang thereafter assisting Liu Bei as chancellor and later receiving the deathbed charge to guide the young ruler.','The chancellorship made Zhuge Liang Shu Han’s de facto administrative center, laying the institutional foundation for his later command of the court and the northern campaigns.','c. 221 CE'),
('cao-pi-campaigns-against-wu','zh-CN','曹丕三路伐吴','志载曹丕乘刘备新败，三路兴兵伐吴，围攻江陵、濡须，皆无功而还。','黄初三年至四年，曹丕以孙权称藩而未遣质子为由，分兵三路南征：曹真、夏侯尚围江陵，曹休出洞口，曹仁攻濡须；吴将朱然坚守江陵逾半年，曹休于洞口失利，曹仁攻濡须亦不克，魏军因疫疾及水患相继撤还。','此役耗损魏军实力而无所得，客观上助长孙刘重修盟好，间接促成三国鼎立局面趋于稳固。','公元222–223年'),
('cao-pi-campaigns-against-wu','en','Cao Pi’s three-pronged campaign against Wu','The Records records Cao Pi launching a three-pronged invasion of Wu while Liu Bei lay freshly defeated, besieging Jiangling and Ruxu without success.','From 222 to 223, citing Sun Quan’s failure to send a hostage prince despite nominal submission, Cao Pi sent three armies south: Cao Zhen and Xiahou Shang besieged Jiangling, Cao Xiu advanced at Dongkou, and Cao Ren attacked Ruxu; the Wu general Zhu Ran held Jiangling for over half a year, Cao Xiu was checked at Dongkou, and Cao Ren failed at Ruxu, with Wei’s armies withdrawing amid epidemic and flooding.','The campaign drained Wei’s strength without gain, and in effect encouraged the renewed Sun-Liu alliance, indirectly stabilising the three-way division of the realm.','222–223 CE'),
('zhuge-liang-pacifies-nanzhong','zh-CN','诸葛亮南征','志载诸葛亮率军南征，平定益州南部诸郡叛乱，以孟获为其中著名首领。','建兴三年，诸葛亮以南中诸郡叛乱未平，亲率大军南征，分兵三路进讨；诸军深入不毛之地，大破叛军，擒获当地渠帅孟获等，事后以攻心为上，多用当地首领治理其地，南中自此稍安。','南征平定了蜀汉后方，解除北伐曹魏的后顾之忧，是诸葛亮“先南后北”战略的关键一步。','公元225年'),
('zhuge-liang-pacifies-nanzhong','en','Zhuge Liang pacifies Nanzhong','The Records records Zhuge Liang leading an army to suppress rebellions in the southern commanderies of Yi Province, with Meng Huo noted as a prominent local leader among those subdued.','In 225, with the southern commanderies still in revolt, Zhuge Liang personally led a three-pronged campaign deep into remote terrain, crushing the rebel forces and capturing local chieftains including Meng Huo; afterward, favoring conciliation over harsh rule, he largely left local leaders in charge, and Nanzhong grew relatively settled.','The southern campaign secured Shu Han’s rear, removing a major concern before the northern campaigns against Wei, a key step in Zhuge Liang’s strategy of settling the south before turning north.','c. 225 CE'),
('zhuge-liang-submits-the-memorial-on-the-expedition','zh-CN','诸葛亮上《出师表》','志载诸葛亮率师北驻汉中，上表后主，陈述北伐曹魏之志。','建兴五年，诸葛亮将率诸军北驻汉中，上疏后主刘禅，追述先帝创业未半而中道崩殂之憾，劝诫后主亲贤远佞，并表明“北定中原，兴复汉室”的志向，是为《出师表》。','《出师表》既是北伐的政治宣言，也是研究诸葛亮治国理念与蜀汉内政的重要文献。','公元227年'),
('zhuge-liang-submits-the-memorial-on-the-expedition','en','Zhuge Liang submits the Memorial on the Expedition','The Records records Zhuge Liang, as he moved his forces north to Hanzhong, submitting a memorial to the young ruler setting out his resolve to campaign against Wei.','In 227, as Zhuge Liang prepared to move his armies north to Hanzhong, he submitted a memorial to Liu Shan recalling the late emperor’s unfinished mission cut short by death, urging the ruler to favor worthy officials over flatterers, and declaring his resolve to “settle the central plains and restore the house of Han” — the celebrated Memorial on the Expedition.','The memorial served both as a political manifesto for the northern campaigns and remains a key document for understanding Zhuge Liang’s statecraft and Shu Han’s internal governance.','c. 227 CE'),
('sun-quan-proclaims-emperor','zh-CN','孙权称帝','志载孙权于武昌即皇帝位，改元黄龙，国号吴，其后迁都建业。','黄龙元年四月，孙权即皇帝位于武昌，改元黄龙，追尊父孙坚为武烈皇帝、兄孙策为长沙桓王；同年九月迁都建业，与蜀汉遣使重申盟好，约定平分曹魏疆土。','孙权称帝标志三国鼎立之局最终完成，魏、蜀、吴三方各自称帝的格局正式确立。','公元229年'),
('sun-quan-proclaims-emperor','en','Sun Quan proclaims himself emperor','The Records records Sun Quan taking the imperial title at Wuchang, changing the era name to Huanglong, founding Wu, and later moving the capital to Jianye.','In the fourth month of 229, Sun Quan proclaimed himself emperor at Wuchang, changing the era name to Huanglong and posthumously honouring his father Sun Jian as Emperor Wulie and his brother Sun Ce as Prince Huan of Changsha; that autumn he moved the capital to Jianye, and renewed the alliance with Shu Han, agreeing to divide Wei’s territory between them.','Sun Quan’s enthronement completed the formal division of the Three Kingdoms, with Wei, Shu, and Wu each now under its own emperor.','c. 229 CE')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000006' AND e.id::text LIKE '64000000-0000-4000-8008%';

-- Romance (演义) KK08
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('cao-pi-accepts-han-abdication','zh-CN','曹丕代汉称帝','小说叙写华歆逼宫索玺，曹丕假意三辞而后受禅，汉室四百年基业一朝而终。','小说写华歆手按剑柄，威逼献帝当廷宣诏禅位，献帝含泪交出玉玺；曹丕故作谦让，三次辞让方才登坛受禅，仪式极尽铺张，而献帝母子相拥痛哭之状与曹丕殿上得意之态形成强烈对照。','小说以逼宫索玺的戏剧化场面强化曹魏篡汉的负面形象，反衬蜀汉“正统”叙事的合法性。','公元220年'),
('cao-pi-accepts-han-abdication','en','Cao Pi accepts Han’s abdication','The novel dramatises Hua Xin coercing the emperor into surrendering the seal, and Cao Pi’s staged reluctance before finally accepting the throne.','The novel has Hua Xin, hand on his sword hilt, force Emperor Xian to proclaim his abdication before the court, the emperor surrendering the imperial seal in tears; Cao Pi feigns humility, declining three times before ascending the altar amid lavish ceremony, the scene contrasting the weeping emperor and his mother with Cao Pi’s triumphant bearing.','The novel’s dramatised coercion scene sharpens Wei’s usurpation as illegitimate, reinforcing the novel’s narrative of Shu Han as the true continuation of Han.','c. 220 CE'),
('liu-bei-proclaims-emperor-at-chengdu','zh-CN','刘备称帝','小说叙写众臣以汉祚不可久废为由劝进，刘备泣受帝位，成都改元章武。','小说写诸葛亮托病不朝，以退为进促使刘备回心，终允百官所请，于成都南郊设坛，告祭天地，即皇帝位，追谥关羽为壮缪侯，立誓兴复汉室。','小说借此彰显刘备“汉室宗亲”的正统身份，为其后兴兵伐吴的悲剧作情感与道义上的双重铺垫。','公元221年'),
('liu-bei-proclaims-emperor-at-chengdu','en','Liu Bei proclaims himself emperor','The novel depicts the assembled officials pressing Liu Bei, who weeps as he finally accepts the throne, changing Chengdu’s era name to Zhangwu.','The novel has Zhuge Liang feign illness to withdraw from court as a means of pressing Liu Bei, until he finally yields to his officials’ petitions, building an altar in Chengdu’s southern outskirts to proclaim himself emperor, posthumously honouring Guan Yu as Marquis Zhuangmiu, and vowing to restore the house of Han.','The novel uses this scene to affirm Liu Bei’s legitimacy as a scion of the Han house, laying both emotional and moral groundwork for the tragic campaign against Wu that follows.','c. 221 CE'),
('zhuge-liang-becomes-chancellor-of-shu','zh-CN','诸葛亮拜丞相','小说叙写刘备登基之日即拜诸葛亮为丞相，君臣相得之情溢于殿堂。','小说写刘备称帝当日，即于殿上册封诸葛亮为丞相，许靖为司徒，百官各有封赏；诸葛亮谢恩之际，君臣对视，皆有相知相托之意，为日后托孤一节预留伏笔。','小说借登基大典之隆重铺陈君臣相知，强化“如鱼得水”的君臣关系主题。','公元221年'),
('zhuge-liang-becomes-chancellor-of-shu','en','Zhuge Liang becomes chancellor of Shu','The novel depicts Liu Bei naming Zhuge Liang chancellor on the very day of his enthronement, sovereign and minister exchanging a look of mutual understanding.','The novel has Liu Bei, on the day of his coronation, formally invest Zhuge Liang as chancellor and Xu Jing as Minister over the Masses before the assembled court; as Zhuge Liang offers thanks, sovereign and minister exchange a glance of deep mutual trust, foreshadowing the later deathbed entrustment.','The novel’s grand coronation scene dramatises the bond of mutual understanding between ruler and minister, reinforcing the recurring theme of their relationship being “like fish to water.”','c. 221 CE'),
('cao-pi-campaigns-against-wu','zh-CN','曹丕三路伐吴','小说叙写曹丕乘蜀吴交兵之际三路南征，却因吴将坚守而铩羽收兵。','小说写曹丕闻陆逊火烧连营、蜀吴两败俱伤，以为有机可乘，遂命曹真、曹休、曹仁分三路伐吴；吴主任用朱桓、朱然等分头拒守，又值江南疫气流行，魏军师老无功，只得班师。','小说借此说明孙权外托称藩以拒蜀汉压力、内修战备以御曹魏，展现其审时度势的政治手腕。','公元222–223年'),
('cao-pi-campaigns-against-wu','en','Cao Pi’s three-pronged campaign against Wu','The novel depicts Cao Pi seizing on the mutual exhaustion of Shu and Wu to launch a three-pronged southern campaign, only to be repelled by Wu’s defenders.','The novel has Cao Pi, hearing of Lu Xun’s fire attack and the mutual ruin of Shu and Wu, judge the moment opportune and order Cao Zhen, Cao Xiu, and Cao Ren south in three columns; Wu’s ruler deploys Zhu Huan and Zhu Ran to hold each front, and with an epidemic spreading through the south, Wei’s exhausted armies withdraw without gain.','The novel uses this episode to show Sun Quan’s political skill in outwardly submitting to Wei to deflect pressure from Shu while quietly preparing his defenses against it.','222–223 CE'),
('zhuge-liang-pacifies-nanzhong','zh-CN','诸葛亮南征','小说叙写诸葛亮亲统大军深入南中，以攻心之策平定蛮方。','小说写诸葛亮不顾年迈体弱，亲率五十万大军南征，历经渡泸水、破藤甲兵等艰险，终使南中诸部心悦诚服。','小说借南征进一步烘托诸葛亮“仁德服人、以德服远”的贤相形象，并为北伐大业扫清后方障碍。','公元225年'),
('zhuge-liang-pacifies-nanzhong','en','Zhuge Liang pacifies Nanzhong','The novel depicts Zhuge Liang personally leading a great army deep into Nanzhong, subduing the southern tribes by winning their hearts rather than merely their submission.','The novel has Zhuge Liang, undeterred by age and fatigue, personally command a host of five hundred thousand south, crossing the Lu River and breaking the rattan-armored troops among other trials, until the southern tribes are won over in genuine loyalty.','The novel uses the southern campaign to further burnish Zhuge Liang’s image as a virtuous chancellor who wins distant peoples through benevolence, clearing the rear before the great undertaking of the northern campaigns.','c. 225 CE'),
('meng-huo-captured-seven-times','zh-CN','七擒孟获','小说叙写诸葛亮七擒孟获，屡纵屡战，终使其心服归顺。','小说写孟获兵败被擒六次，诸葛亮每次皆亲释其缚，晓以利害，孟获却不服，屡纵屡战；至第七次被擒，孟获终感其恩威并施，泣然拜服，誓不复反。','小说以“七擒七纵”塑造诸葛亮以德服人的政治智慧典范，成为全书最富传奇色彩的情节之一。','公元225年'),
('meng-huo-captured-seven-times','en','Meng Huo captured seven times','The novel dramatises Zhuge Liang capturing and releasing the southern chieftain Meng Huo seven times until he submits from the heart.','The novel has Meng Huo captured and released six times, each time Zhuge Liang personally freeing his bonds and reasoning with him, yet each time Meng Huo remains defiant and returns to battle; on the seventh capture, moved at last by this combination of severity and grace, Meng Huo weeps and submits, vowing never to rebel again.','The “seven captures, seven releases” episode becomes the novel’s paradigm of Zhuge Liang’s political wisdom in winning submission through virtue, one of the most celebrated and legendary passages in the whole work.','c. 225 CE'),
('zhuge-liang-submits-the-memorial-on-the-expedition','zh-CN','诸葛亮上《出师表》','小说叙写诸葛亮临行上表，字字泣血，后世读之无不动容。','小说全录《出师表》文字，写诸葛亮临表涕零，殷殷叮嘱后主亲贤臣远小人，又布置内外文武之任，方才率师离京北上，出征在即，满朝相送。','小说借此表彰诸葛亮“鞠躬尽瘁”的忠臣典范，此表历来被誉为忠义文章之绝唱。','公元227年'),
('zhuge-liang-submits-the-memorial-on-the-expedition','en','Zhuge Liang submits the Memorial on the Expedition','The novel presents Zhuge Liang weeping over every word of his memorial before departure, a text later readers could not read without being moved.','The novel reproduces the Memorial on the Expedition in full, showing Zhuge Liang in tears as he writes it, earnestly urging the young ruler to favor worthy ministers over flatterers, arranging the civil and military appointments at court, and finally leading his army north from the capital amid the whole court seeing him off.','The novel uses the memorial to honor Zhuge Liang as the model of a minister who serves “to his utmost until death,” a text long celebrated as the supreme expression of loyalty in Chinese letters.','c. 227 CE'),
('sun-quan-proclaims-emperor','zh-CN','孙权称帝','小说叙写孙权久蓄帝王之志，终在武昌登坛称帝，与蜀汉再续盟约。','小说写孙权见魏、蜀已先后称帝，群臣亦屡劝进，遂择吉日于武昌南郊设坛，即皇帝位，国号吴；随后遣使入蜀，与后主重申唇齿之盟，共约兴兵伐魏、事成中分天下。','小说以此收束“三国鼎立”的最后一块拼图，标志全书正式进入三分天下、互为攻守的新阶段。','公元229年'),
('sun-quan-proclaims-emperor','en','Sun Quan proclaims himself emperor','The novel depicts Sun Quan, long harboring imperial ambition, finally taking the throne at Wuchang and renewing the alliance with Shu Han.','The novel has Sun Quan, seeing that both Wei and Shu had already claimed the imperial title and pressed repeatedly by his officials, choose an auspicious day to build an altar in Wuchang’s southern outskirts and proclaim himself emperor of Wu; he then sends envoys to Shu to renew the alliance of mutual dependence, agreeing to jointly campaign against Wei and divide the realm between them upon success.','The novel uses this to complete the final piece of the Three Kingdoms’ division, marking the story’s formal entry into the new phase of three-way rivalry and shifting alliances.','c. 229 CE')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000007' AND e.id::text LIKE '65000000-0000-4000-8008%';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS (one primary location per event; existing 38-location
--    gazetteer plus the 3 new minor locations per work)
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('liu-bei-proclaimed-king-of-hanzhong','hanzhong'),
('guan-yu-floods-seven-armies','fancheng'),
('guan-yu-scrapes-poison-from-bone','fancheng'),
('lu-meng-seizes-jing-province','jiangling'),
('guan-yu-defeated-at-maicheng','maicheng'),
('guan-yu-manifests-at-yuquan-temple','yiling'),
('zhang-fei-murdered-by-subordinates','langzhong'),
('liu-bei-vows-revenge-for-his-brothers','chengdu'),
('liu-bei-invades-wu','yiling'),
('lu-xun-burns-the-linked-camps','xiaoting'),
('liu-bei-entrusts-orphan-at-baidicheng','baidicheng'),
('cao-pi-accepts-han-abdication','xuchang'),
('liu-bei-proclaims-emperor-at-chengdu','chengdu'),
('zhuge-liang-becomes-chancellor-of-shu','chengdu'),
('cao-pi-campaigns-against-wu','ruxukou'),
('zhuge-liang-pacifies-nanzhong','chengdu'),
('meng-huo-captured-seven-times','chengdu'),
('zhuge-liang-submits-the-memorial-on-the-expedition','hanzhong'),
('sun-quan-proclaims-emperor','wuchang')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
  AND (e.id::text LIKE '64000000-0000-4000-8007%' OR e.id::text LIKE '65000000-0000-4000-8007%'
       OR e.id::text LIKE '64000000-0000-4000-8008%' OR e.id::text LIKE '65000000-0000-4000-8008%')
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('liu-bei-proclaimed-king-of-hanzhong','liu-bei',0),('liu-bei-proclaimed-king-of-hanzhong','zhuge-liang',1),('liu-bei-proclaimed-king-of-hanzhong','guan-yu',2),
('guan-yu-floods-seven-armies','guan-yu',0),('guan-yu-floods-seven-armies','yu-jin',1),('guan-yu-floods-seven-armies','guan-ping',2),
('guan-yu-scrapes-poison-from-bone','guan-yu',0),('guan-yu-scrapes-poison-from-bone','guan-ping',1),
('lu-meng-seizes-jing-province','lu-meng',0),('lu-meng-seizes-jing-province','mi-fang',1),('lu-meng-seizes-jing-province','sun-quan',2),
('guan-yu-defeated-at-maicheng','guan-yu',0),('guan-yu-defeated-at-maicheng','guan-ping',1),
('guan-yu-manifests-at-yuquan-temple','guan-yu',0),
('zhang-fei-murdered-by-subordinates','zhang-fei',0),('zhang-fei-murdered-by-subordinates','liu-bei',1),
('liu-bei-vows-revenge-for-his-brothers','liu-bei',0),('liu-bei-vows-revenge-for-his-brothers','zhuge-liang',1),
('liu-bei-invades-wu','liu-bei',0),('liu-bei-invades-wu','lu-xun',1),('liu-bei-invades-wu','sun-quan',2),
('lu-xun-burns-the-linked-camps','lu-xun',0),('lu-xun-burns-the-linked-camps','liu-bei',1),
('liu-bei-entrusts-orphan-at-baidicheng','liu-bei',0),('liu-bei-entrusts-orphan-at-baidicheng','zhuge-liang',1),('liu-bei-entrusts-orphan-at-baidicheng','liu-shan',2),
('cao-pi-accepts-han-abdication','cao-pi',0),('cao-pi-accepts-han-abdication','emperor-xian',1),('cao-pi-accepts-han-abdication','hua-xin',2),
('liu-bei-proclaims-emperor-at-chengdu','liu-bei',0),('liu-bei-proclaims-emperor-at-chengdu','zhuge-liang',1),
('zhuge-liang-becomes-chancellor-of-shu','zhuge-liang',0),('zhuge-liang-becomes-chancellor-of-shu','liu-bei',1),
('cao-pi-campaigns-against-wu','cao-pi',0),('cao-pi-campaigns-against-wu','sun-quan',1),('cao-pi-campaigns-against-wu','sima-yi',2),
('zhuge-liang-pacifies-nanzhong','zhuge-liang',0),('zhuge-liang-pacifies-nanzhong','meng-huo',1),
('meng-huo-captured-seven-times','meng-huo',0),('meng-huo-captured-seven-times','zhuge-liang',1),
('zhuge-liang-submits-the-memorial-on-the-expedition','zhuge-liang',0),('zhuge-liang-submits-the-memorial-on-the-expedition','liu-shan',1),
('sun-quan-proclaims-emperor','sun-quan',0),('sun-quan-proclaims-emperor','lu-xun',1)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
  AND (e.id::text LIKE '64000000-0000-4000-8007%' OR e.id::text LIKE '65000000-0000-4000-8007%'
       OR e.id::text LIKE '64000000-0000-4000-8008%' OR e.id::text LIKE '65000000-0000-4000-8008%')
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES (Records events -> "Records of the Three Kingdoms";
--    Romance events -> "Romance of the Three Kingdoms (Mao edition)";
--    JOIN matched by s.work_id=e.work_id per task brief)
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Records of the Three Kingdoms'
WHERE e.work_id='10000000-0000-4000-8000-000000000006'
  AND (e.id::text LIKE '64000000-0000-4000-8007%' OR e.id::text LIKE '64000000-0000-4000-8008%')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Romance of the Three Kingdoms (Mao edition)'
WHERE e.work_id='10000000-0000-4000-8000-000000000007'
  AND (e.id::text LIKE '65000000-0000-4000-8007%' OR e.id::text LIKE '65000000-0000-4000-8008%')
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS (+ relation_translations, zh-CN + en, both
--    published; 14 relations per work, 10 tagged KK07 + 4 tagged KK08)
-- -------------------------------------------------------------------------

-- Records (志) relations
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('74000000-0000-4000-8007-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'guan-yu','lu-meng','adversary','bidirectional','negative',4,'ended','lu-meng-seizes-jing-province','guan-yu-defeated-at-maicheng'),
(2,'liu-bei','lu-xun','adversary','bidirectional','negative',4,'ended','liu-bei-invades-wu','liu-bei-entrusts-orphan-at-baidicheng'),
(3,'liu-bei','zhuge-liang','ally','bidirectional','positive',5,'changed','liu-bei-proclaimed-king-of-hanzhong','liu-bei-entrusts-orphan-at-baidicheng'),
(4,'lu-meng','mi-fang','ally','source_to_target','mixed',2,'active','lu-meng-seizes-jing-province',NULL),
(5,'guan-yu','mi-fang','other','source_to_target','negative',3,'ended',NULL,'lu-meng-seizes-jing-province'),
(6,'guan-yu','yu-jin','adversary','bidirectional','negative',3,'ended','guan-yu-floods-seven-armies',NULL),
(7,'guan-yu','guan-ping','family','source_to_target','positive',4,'ended',NULL,'guan-yu-defeated-at-maicheng'),
(8,'liu-bei','zhang-fei','ally','bidirectional','positive',5,'ended',NULL,'zhang-fei-murdered-by-subordinates'),
(9,'liu-bei','sun-quan','adversary','bidirectional','negative',3,'changed','lu-meng-seizes-jing-province',NULL),
(10,'sun-quan','lu-xun','ally','source_to_target','positive',4,'active','liu-bei-invades-wu',NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000006'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000006'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000006'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('74000000-0000-4000-8008-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'cao-pi','emperor-xian','other','source_to_target','mixed',3,'ended',NULL,'cao-pi-accepts-han-abdication'),
(2,'cao-pi','sima-yi','ally','source_to_target','positive',4,'active','cao-pi-campaigns-against-wu',NULL),
(3,'zhuge-liang','meng-huo','adversary','bidirectional','mixed',3,'changed','zhuge-liang-pacifies-nanzhong',NULL),
(4,'cao-pi','hua-xin','ally','source_to_target','positive',3,'active','cao-pi-accepts-han-abdication',NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000006'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000006'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000006'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

-- Romance (演义) relations
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('75000000-0000-4000-8007-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'guan-yu','lu-meng','adversary','bidirectional','negative',4,'ended','lu-meng-seizes-jing-province','guan-yu-defeated-at-maicheng'),
(2,'liu-bei','lu-xun','adversary','bidirectional','negative',4,'ended','liu-bei-invades-wu','lu-xun-burns-the-linked-camps'),
(3,'liu-bei','zhuge-liang','ally','bidirectional','positive',5,'changed','liu-bei-proclaimed-king-of-hanzhong','liu-bei-entrusts-orphan-at-baidicheng'),
(4,'lu-meng','mi-fang','ally','source_to_target','mixed',2,'active','lu-meng-seizes-jing-province',NULL),
(5,'guan-yu','mi-fang','other','source_to_target','negative',3,'ended',NULL,'lu-meng-seizes-jing-province'),
(6,'guan-yu','yu-jin','adversary','bidirectional','negative',3,'ended','guan-yu-floods-seven-armies',NULL),
(7,'guan-yu','guan-ping','family','source_to_target','positive',4,'ended',NULL,'guan-yu-defeated-at-maicheng'),
(8,'liu-bei','zhang-fei','ally','bidirectional','positive',5,'ended',NULL,'zhang-fei-murdered-by-subordinates'),
(9,'liu-bei','sun-quan','adversary','bidirectional','negative',3,'changed','lu-meng-seizes-jing-province',NULL),
(10,'sun-quan','lu-xun','ally','source_to_target','positive',4,'active','liu-bei-invades-wu',NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000007'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000007'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000007'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('75000000-0000-4000-8008-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'cao-pi','emperor-xian','other','source_to_target','mixed',3,'ended',NULL,'cao-pi-accepts-han-abdication'),
(2,'cao-pi','sima-yi','ally','source_to_target','positive',4,'active','cao-pi-campaigns-against-wu',NULL),
(3,'zhuge-liang','meng-huo','adversary','bidirectional','mixed',3,'changed','zhuge-liang-pacifies-nanzhong','meng-huo-captured-seven-times'),
(4,'cao-pi','hua-xin','ally','source_to_target','positive',3,'active','cao-pi-accepts-han-abdication',NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000007'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000007'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000007'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- Records (志) relation_translations -- 志载/传称 voice.
INSERT INTO relation_translations(relation_id,locale,label,summary,status)
SELECT r.id,v.locale::locale_code,v.label,v.summary,'published'
FROM character_relations r JOIN (VALUES
('guan-yu','lu-meng','adversary','zh-CN','荆州对垒的宿敌','吕蒙代鲁肃都督后，与镇守荆州的关羽渐成对垒之势，终以奇袭致关羽身死。'),
('guan-yu','lu-meng','adversary','en','Rivals over Jing Province','After succeeding Lu Su as commander, Lü Meng became Guan Yu’s rival over Jing Province, ultimately engineering the raid that led to Guan Yu’s death.'),
('liu-bei','lu-xun','adversary','zh-CN','夷陵交锋，各为其主','刘备东征欲复荆州，陆逊受命拒之，两军相持逾年终以蜀军大败告终。'),
('liu-bei','lu-xun','adversary','en','Opposing commanders at Yiling','Liu Bei campaigned east to reclaim Jing Province while Lu Xun was charged with resisting him; after a prolonged standoff, Shu’s army was decisively defeated.'),
('liu-bei','zhuge-liang','ally','zh-CN','托孤定分的君臣','自汉中称王至白帝托孤，诸葛亮渐由谋主升至受遗辅政的地位。'),
('liu-bei','zhuge-liang','ally','en','Sovereign and minister bound by the deathbed charge','From the Hanzhong kingship to the deathbed charge at Baidicheng, Zhuge Liang’s role grew from chief strategist to appointed regent.'),
('lu-meng','mi-fang','ally','zh-CN','纳降荆州的新主与降将','吕蒙袭取江陵后，糜芳开城出降，转投东吴麾下。'),
('lu-meng','mi-fang','ally','en','New commander and the officer who surrendered to him','After Lü Meng seized Jiangling, Mi Fang surrendered the city and joined the ranks of Wu.'),
('guan-yu','mi-fang','other','zh-CN','反目降敌的部属','糜芳因供给不继屡遭关羽责难，心怀怨望，终于吕蒙来袭时倒戈出降。'),
('guan-yu','mi-fang','other','en','A subordinate turned defector','Repeatedly rebuked by Guan Yu over supply failures, Mi Fang grew resentful and defected when Lü Meng’s forces arrived.'),
('guan-yu','yu-jin','adversary','zh-CN','水淹七军的胜者与降将','关羽水淹于禁所督七军，迫其出降，一时威震华夏。'),
('guan-yu','yu-jin','adversary','en','Victor and vanquished at the flooded armies','Guan Yu’s flood overwhelmed Yu Jin’s seven armies, forcing his surrender and briefly shaking all of Han territory.'),
('guan-yu','guan-ping','family','zh-CN','并肩赴死的父子','关平随父镇守荆州，麦城突围失利后与父同时遇害。'),
('guan-yu','guan-ping','family','en','Father and son who died together','Guan Ping garrisoned Jing Province alongside his father and was killed with him after the failed breakout from Maicheng.'),
('liu-bei','zhang-fei','ally','zh-CN','涿郡旧部的君臣情谊','张飞自涿郡追随刘备起兵，情同手足，章武元年为部下所害。'),
('liu-bei','zhang-fei','ally','en','Lord and officer from Zhuo Commandery','Zhang Fei followed Liu Bei from their raising of troops in Zhuo Commandery, close as brothers, until his murder by subordinates in 221.'),
('liu-bei','sun-quan','adversary','zh-CN','联盟破裂后的敌国之主','荆州之失使孙刘联盟破裂，刘备兴兵东征，两方一度兵戎相见。'),
('liu-bei','sun-quan','adversary','en','Allied rulers turned wartime rivals','The loss of Jing Province shattered the Sun-Liu alliance, and Liu Bei’s eastern campaign briefly turned the two rulers into wartime enemies.'),
('sun-quan','lu-xun','ally','zh-CN','拜为大都督的知遇','孙权破格拔擢陆逊为大都督拒刘备东征军，其后倚为柱石之臣。'),
('sun-quan','lu-xun','ally','en','The trust that named him commander-in-chief','Sun Quan gave the unconventional promotion of commander-in-chief to Lu Xun to resist Liu Bei’s invasion, relying on him thereafter as a pillar of the state.'),
('cao-pi','emperor-xian','other','zh-CN','禅代之局中的君臣','曹丕受汉禅而立魏，汉献帝退居山阳公，两汉皇统至此终结。'),
('cao-pi','emperor-xian','other','en','Sovereign and successor in the abdication','Cao Pi accepted Han’s abdication to found Wei, while Emperor Xian was reduced to Duke of Shanyang, ending the Han imperial line.'),
('cao-pi','sima-yi','ally','zh-CN','委以留守之任的君臣','曹丕伐吴之际，司马懿常受命镇守后方、总理留府事务，渐受倚重。'),
('cao-pi','sima-yi','ally','en','A ruler and the minister entrusted with the rear','During Cao Pi’s campaigns against Wu, Sima Yi was repeatedly entrusted with guarding the rear and overseeing court affairs, growing steadily more trusted.'),
('zhuge-liang','meng-huo','adversary','zh-CN','南征降服的部族渠帅','诸葛亮南征平乱，孟获等渠帅屡战屡败终归降蜀汉。'),
('zhuge-liang','meng-huo','adversary','en','A tribal chieftain subdued in the southern campaign','In the southern campaign, Zhuge Liang overcame the region’s resistance, and chieftains including Meng Huo eventually submitted to Shu Han.'),
('cao-pi','hua-xin','ally','zh-CN','禅代大事的股肱之臣','华歆领衔百官劝进、督办禅让仪礼，曹丕即位后倚为重臣。'),
('cao-pi','hua-xin','ally','en','A minister instrumental in the succession','Hua Xin led the officials’ petitions and oversaw the abdication ceremony; Cao Pi relied on him as a key minister thereafter.')
) AS v(fslug,tslug,rtype,locale,label,summary)
  ON r.relation_type=v.rtype
 JOIN characters fc ON fc.id=r.from_character_id AND fc.slug=v.fslug
 JOIN characters tc ON tc.id=r.to_character_id AND tc.slug=v.tslug
WHERE r.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

-- Romance (演义) relation_translations -- 小说叙写 voice.
INSERT INTO relation_translations(relation_id,locale,label,summary,status)
SELECT r.id,v.locale::locale_code,v.label,v.summary,'published'
FROM character_relations r JOIN (VALUES
('guan-yu','lu-meng','adversary','zh-CN','白衣渡江的死敌','小说写吕蒙以诈病麻痹关羽，终以白衣渡江之计袭破荆州，致关羽父子俱亡。'),
('guan-yu','lu-meng','adversary','en','Deadly rivals of the disguised crossing','The novel has Lü Meng lull Guan Yu with a feigned illness before the disguised river crossing that shattered Jing Province and cost Guan Yu his life.'),
('liu-bei','lu-xun','adversary','zh-CN','连营对垒，火烧收局','小说写陆逊坚守不出，终乘隙火烧连营，迫使刘备仓皇退往白帝城。'),
('liu-bei','lu-xun','adversary','en','Rivals whose standoff ended in fire','The novel has Lu Xun hold firm before seizing his chance to burn the linked camps, forcing Liu Bei’s desperate retreat to Baidicheng.'),
('liu-bei','zhuge-liang','ally','zh-CN','如鱼得水，托孤生死之交','小说写刘备临终泣托幼主，诸葛亮顿首流血誓竭股肱之力，情谊升华至生死相托。'),
('liu-bei','zhuge-liang','ally','en','Bound like fish to water, unto the deathbed charge','The novel has Liu Bei tearfully entrust his heir, and Zhuge Liang bow until his head bleeds vowing utmost devotion, their bond deepened into a trust unto death.'),
('lu-meng','mi-fang','ally','zh-CN','赚城纳降的一段际遇','小说写糜芳畏罪开城迎降，吕蒙纳其归吴，兵不血刃取荆州。'),
('lu-meng','mi-fang','ally','en','A commander’s welcome for a surrendered officer','The novel has Mi Fang, fearing punishment, open the gates in surrender, and Lü Meng receive him into Wu’s service, taking Jing Province without a fight.'),
('guan-yu','mi-fang','other','zh-CN','心怀积怨的旧部','小说写糜芳因关羽当众威言重责而心生惧怨，终致临阵倒戈，铸成大错。'),
('guan-yu','mi-fang','other','en','A resentful subordinate’s betrayal','The novel has Mi Fang, stung by Guan Yu’s public threat of harsh punishment, turn on him in fear and resentment, a betrayal with fatal consequences.'),
('guan-yu','yu-jin','adversary','zh-CN','决水擒将的一战','小说写关羽预判秋汛决堤放水，于禁兵败力竭，被迫俯首乞降。'),
('guan-yu','yu-jin','adversary','en','A battle decided by the breaking of the waters','The novel has Guan Yu foresee the autumn floods and break the dam, leaving Yu Jin’s exhausted army no choice but to surrender.'),
('guan-yu','guan-ping','family','zh-CN','忠孝两全的父子','小说写关平自幼随父习武侍从，麦城之败中誓死不降，与父同殉。'),
('guan-yu','guan-ping','family','en','Father and son, loyal and filial to the end','The novel has Guan Ping, trained at his father’s side since childhood, refuse to surrender at the fall of Maicheng and die alongside him.'),
('liu-bei','zhang-fei','ally','zh-CN','桃园结义的三弟','小说写张飞闻关羽死讯痛哭呕血，终因鞭挞部将过甚而遇害，未能同赴复仇之约。'),
('liu-bei','zhang-fei','ally','en','Third of the Peach Garden oath','The novel has Zhang Fei weep blood at Guan Yu’s death, only to be murdered for flogging his officers too harshly, unable to keep their vow of shared revenge.'),
('liu-bei','sun-quan','adversary','zh-CN','恩断义绝的昔日盟友','小说写刘备誓不与东吴共戴天，两国盟好尽废，直至夷陵战后方议重修旧好。'),
('liu-bei','sun-quan','adversary','en','Once allies, now bitter enemies','The novel has Liu Bei swear undying enmity with Eastern Wu, shattering their former alliance until after Yiling when renewed peace is discussed.'),
('sun-quan','lu-xun','ally','zh-CN','临危受命的都督','小说写孙权力排众议拜陆逊为大都督，陆逊不负所托，火烧连营大破蜀军。'),
('sun-quan','lu-xun','ally','en','A commander entrusted in the hour of crisis','The novel has Sun Quan overrule his doubters to appoint Lu Xun commander-in-chief, and Lu Xun repays the trust by burning the linked camps to break the Shu army.'),
('cao-pi','emperor-xian','other','zh-CN','逼宫夺玺的强弱之局','小说写曹丕假意三让，实则步步紧逼，终使献帝含泪交出玉玺禅位。'),
('cao-pi','emperor-xian','other','en','The coerced surrender of the throne','The novel has Cao Pi feign reluctance while pressing relentlessly, until the weeping emperor surrenders the imperial seal and his throne.'),
('cao-pi','sima-yi','ally','zh-CN','南征北战间的托付','小说写曹丕南征时委司马懿以留守重任，君臣相得，渐成魏廷倚重之臣。'),
('cao-pi','sima-yi','ally','en','Trust forged amid campaigns','The novel has Cao Pi entrust Sima Yi with guarding the capital during his southern campaigns, their trust deepening as Sima Yi becomes indispensable to the Wei court.'),
('zhuge-liang','meng-huo','adversary','zh-CN','七擒七纵，化敌为友','小说写诸葛亮七擒孟获而七次释放，终使其心服归顺，誓不复反。'),
('zhuge-liang','meng-huo','adversary','en','Seven captures that turned an enemy into an ally','The novel has Zhuge Liang capture and release Meng Huo seven times, finally winning his genuine submission and a vow never to rebel again.'),
('cao-pi','hua-xin','ally','zh-CN','逼宫夺玺的心腹','小说写华歆手持利剑威逼献帝禅位，深得曹丕倚重，仕途因此愈显。'),
('cao-pi','hua-xin','ally','en','The confidant who forced the surrender of the throne','The novel has Hua Xin threaten the emperor into abdication at swordpoint, earning Cao Pi’s deep trust and a rise in standing thereafter.')
) AS v(fslug,tslug,rtype,locale,label,summary)
  ON r.relation_type=v.rtype
 JOIN characters fc ON fc.id=r.from_character_id AND fc.slug=v.fslug
 JOIN characters tc ON tc.id=r.to_character_id AND tc.slug=v.tslug
WHERE r.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 10. GROUP MEMBERSHIP (existing groups from seed 031; Meng Huo has no
--     fitting existing group among the 14 and is intentionally left out --
--     see final report for this documented gap)
-- -------------------------------------------------------------------------
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g
JOIN characters c ON c.work_id=g.work_id
JOIN (VALUES
('wu-commandery','lu-meng'),
('shu-generals','guan-ping'),
('jing-province-circle','mi-fang'),
('house-of-cao','yu-jin'),
('men-of-letters','hua-xin')
) AS v(gslug,cslug) ON g.slug=v.gslug AND c.slug=v.cslug
WHERE g.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

COMMIT;
