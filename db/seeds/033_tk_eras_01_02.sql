BEGIN;

-- Three Kingdoms era content, KK=01 yellow-turban-rising (184-189) and
-- KK=02 dong-zhuo-usurpation (189-192), both works (Records 志 / Romance 演义).
-- Builds on db/seeds/031 (structure: works/chapters/groups/sources) and
-- db/seeds/032 (shared 28-anchor cast + 38-location gazetteer). Per
-- blueprint/WORK_TEMPLATE.md and blueprint/EXAMPLE_THREE_KINGDOMS.md.
--
-- UUID namespace used here (new, unused before this seed):
--   characters (era-only minor cast) 4{6|7}000000-0000-4000-80KK-0000000000NN
--   locations   (era-only minor sites) 3{6|7}000000-0000-4000-80KK-0000000000NN
--   events                             6{4|5}000000-0000-4000-80KK-0000000000NN
--   character_relations                7{4|5}000000-0000-4000-80KK-0000000000NN
-- Works: Records = 10000000-0000-4000-8000-000000000006
--        Romance = 10000000-0000-4000-8000-000000000007
-- Chapters (from 031): yellow-turban-rising = 84/85...-8001-...0001 (KK=01)
--                      dong-zhuo-usurpation = 84/85...-8002-...0001 (KK=02)

-- ============================================================
-- 1. CHARACTERS (era-specific minor cast, <=6 per work per era; none of
--    these slugs collide with the 28-anchor cast from 032)
-- ============================================================

INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
-- Records (志) — KK=01 minor cast
('46000000-0000-4000-8001-000000000001','10000000-0000-4000-8000-000000000006','he-jin',100,'male','adult','supporting','historical',NULL,189,'person',3),
('46000000-0000-4000-8001-000000000002','10000000-0000-4000-8000-000000000006','huangfu-song',101,'male','adult','supporting','historical',NULL,195,'soldier',3),
('46000000-0000-4000-8001-000000000003','10000000-0000-4000-8000-000000000006','lu-zhi',102,'male','adult','supporting','historical',NULL,192,'teacher',3),
('46000000-0000-4000-8001-000000000004','10000000-0000-4000-8000-000000000006','emperor-ling',103,'male','adult','historical','historical',156,189,'king',3),
-- Records (志) — KK=02 minor cast
('46000000-0000-4000-8002-000000000001','10000000-0000-4000-8000-000000000006','ding-yuan',200,'male','adult','supporting','historical',NULL,189,'soldier',2),
('46000000-0000-4000-8002-000000000002','10000000-0000-4000-8000-000000000006','li-jue',201,'male','adult','antagonist','historical',NULL,198,'soldier',3),
('46000000-0000-4000-8002-000000000003','10000000-0000-4000-8000-000000000006','guo-si',202,'male','adult','antagonist','historical',NULL,197,'soldier',2),
-- Romance (演义) — KK=01 minor cast
('47000000-0000-4000-8001-000000000001','10000000-0000-4000-8000-000000000007','he-jin',100,'male','adult','supporting','fictionalised_historical',NULL,189,'person',3),
('47000000-0000-4000-8001-000000000002','10000000-0000-4000-8000-000000000007','huangfu-song',101,'male','adult','supporting','fictionalised_historical',NULL,195,'soldier',3),
('47000000-0000-4000-8001-000000000003','10000000-0000-4000-8000-000000000007','lu-zhi',102,'male','adult','supporting','fictionalised_historical',NULL,192,'teacher',3),
('47000000-0000-4000-8001-000000000004','10000000-0000-4000-8000-000000000007','emperor-ling',103,'male','adult','historical','fictionalised_historical',156,189,'king',3),
-- Romance (演义) — KK=02 minor cast (Hua Xiong is Romance-only)
('47000000-0000-4000-8002-000000000001','10000000-0000-4000-8000-000000000007','ding-yuan',200,'male','adult','supporting','fictionalised_historical',NULL,189,'soldier',2),
('47000000-0000-4000-8002-000000000002','10000000-0000-4000-8000-000000000007','li-jue',201,'male','adult','antagonist','fictionalised_historical',NULL,198,'soldier',3),
('47000000-0000-4000-8002-000000000003','10000000-0000-4000-8000-000000000007','guo-si',202,'male','adult','antagonist','fictionalised_historical',NULL,197,'soldier',2),
('47000000-0000-4000-8002-000000000004','10000000-0000-4000-8000-000000000007','hua-xiong',203,'male','adult','antagonist','fictionalised_historical',NULL,190,'soldier',2)
ON CONFLICT DO NOTHING;

-- Records (志) — 志载/传称 voice.
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('he-jin','zh-CN','何进',ARRAY[]::text[],'南阳宛人，屠家出身，因异母妹何皇后得幸而累官至大将军，中平六年谋诛宦官事泄，为张让等所杀。','黄巾之乱后统摄禁军，灵帝崩后立少帝，谋尽诛宦官而反为所害。','欲借外兵尽除宦官，巩固外戚权柄。'),
('he-jin','en','He Jin',ARRAY[]::text[],'A native of Wan in Nanyang who rose from a butcher''s family to Grand General through his half-sister Empress He, killed by the eunuchs in 189 when his plot against them was betrayed.','After the Yellow Turban revolt he commanded the palace guard and enthroned the boy emperor on Emperor Ling''s death, but his plan to wipe out the eunuchs cost him his own life.','He sought to use outside troops to eliminate the eunuchs and secure his family''s hold on power.'),
('huangfu-song','zh-CN','皇甫嵩',ARRAY['义真']::text[],'安定朝那人，汉左中郎将，统军讨黄巾，火攻破张梁于广宗、张宝于下曲阳，累功封侯。','与朱儁分道讨贼，屡建战功，为平定黄巾主力的头号功臣。','奉命平乱，恪守将臣本分。'),
('huangfu-song','en','Huangfu Song',ARRAY['Yizhen']::text[],'Styled Yizhen, a native of Chaona in Anding who commanded Han forces against the Yellow Turbans, breaking Zhang Liang at Guangzong and Zhang Bao at Xiaquyang with fire attacks, and was enfeoffed for his victories.','Campaigning alongside Zhu Jun, he won repeated victories and stood as the leading commander in crushing the main Yellow Turban forces.','He acted under orders to suppress the revolt, holding faithfully to a general''s duty.'),
('lu-zhi','zh-CN','卢植',ARRAY['子干']::text[],'涿郡涿人，通古今学，为北中郎将讨黄巾，刘备、公孙瓒皆出其门下，后为董卓所忌罢官。','围张角于广宗未下，为宦官所谮下狱，旋获赦免。','以经术自任，出讨黄巾以尽臣节。'),
('lu-zhi','en','Lu Zhi',ARRAY['Zigan']::text[],'Styled Zigan, a native of Zhuo Commandery learned in classical scholarship, who led Han forces against the Yellow Turbans as General of the Household for the North; both Liu Bei and Gongsun Zan studied under him, and Dong Zhuo later had him dismissed.','He besieged Zhang Jiao at Guangzong without taking the city, was slandered by a eunuch envoy and imprisoned, then soon pardoned.','A scholar by vocation, he took the field against the Yellow Turbans out of loyalty to the throne.'),
('emperor-ling','zh-CN','汉灵帝',ARRAY['刘宏']::text[],'名宏，汉第十二代皇帝，在位期间宦官专权、卖官鬻爵，黄巾起、汉室根基自此动摇，中平六年崩于洛阳。','崩后何进立少子刘辩为帝，随即引发外戚、宦官、军阀三方混战。','耽于享乐，倚重宦官，无意振作朝纲。'),
('emperor-ling','en','Emperor Ling of Han',ARRAY['Liu Hong']::text[],'Personal name Hong, the twelfth Han emperor, whose reign of eunuch dominance and open sale of offices saw the Yellow Turban revolt shake the dynasty''s foundations; he died at Luoyang in 189.','On his death He Jin enthroned his younger son Liu Bian, setting off the three-way struggle among consort kin, eunuchs, and warlords.','Given to pleasure and reliant on the eunuchs, he made little effort to restore order to the court.'),
('ding-yuan','zh-CN','丁原',ARRAY['建阳']::text[],'并州刺史，何进召其入京助诛宦官，以吕布为主簿，后为吕布所杀，部众归董卓。','拥并州兵马入京，与董卓争衡，旋为部将吕布所杀。','应召勤王，欲助何进清除宦官。'),
('ding-yuan','en','Ding Yuan',ARRAY['Jianyang']::text[],'Styled Jianyang, Inspector of Bing Province, summoned to the capital by He Jin to help move against the eunuchs; he made Lu Bu his registrar, only to be killed by him, his troops passing to Dong Zhuo.','He brought his Bing Province troops to the capital to contend with Dong Zhuo, only to be killed soon after by his own officer Lu Bu.','He answered the summons to the capital, meaning to help He Jin sweep out the eunuchs.'),
('li-jue','zh-CN','李傕',ARRAY['稚然']::text[],'北地人，董卓部将，卓死后与郭汜合兵攻陷长安，挟持天子，专擅朝政数年。','初平三年攻破长安，杀王允，纵兵剽掠，关中残破。','为求自保、复仇王允诛董卓之事，遂举兵犯阙。'),
('li-jue','en','Li Jue',ARRAY['Zhiran']::text[],'Styled Zhiran, a native of Beidi and one of Dong Zhuo''s officers, who joined Guo Si after Dong Zhuo''s death to storm Chang''an, seize the emperor, and dominate the court for years.','In 192 he broke into Chang''an, killed Wang Yun, and let his troops plunder freely, devastating the region.','Fearing for his own safety and seeking revenge for Wang Yun''s killing of Dong Zhuo, he raised his troops against the capital.'),
('guo-si','zh-CN','郭汜',ARRAY[]::text[],'张掖人，董卓部将，与李傕合兵陷长安，其后二人又自相攻伐，关中大乱。','与李傕共专朝政，纵兵剽掠，为祸关中。','随李傕举兵，图谋共分朝柄。'),
('guo-si','en','Guo Si',ARRAY[]::text[],'A native of Zhangye and one of Dong Zhuo''s officers, who joined Li Jue in taking Chang''an, after which the two fell out and fought each other, plunging the region into chaos.','He and Li Jue together dominated the court and let their troops ravage the region.','He joined Li Jue''s revolt hoping to share in control of the court.')
) AS v(slug,locale,name,aliases,summary,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

-- Romance (演义) — 小说叙写 voice. Hua Xiong is Romance-only.
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('he-jin','zh-CN','何进',ARRAY[]::text[],'屠户出身的国舅，掌禁军大权，谋诛宦官反被十常侍诱杀于宫中。','小说叙写其召四方猛将入京诛宦官，却因优柔寡断错失先机，终遭伏杀。','欲铲除宦官专权，却低估了对手的凶狠。'),
('he-jin','en','He Jin',ARRAY[]::text[],'A butcher-turned-imperial in-law who commanded the palace guard, lured to his death inside the palace by the Ten Attendants when his plot against them leaked.','The novel shows him summoning outside warlords to purge the eunuchs, but his hesitation lets them strike first and kill him.','He wanted to break the eunuchs'' grip on power but underestimated how ruthlessly they would strike back.'),
('huangfu-song','zh-CN','皇甫嵩',ARRAY['义真']::text[],'汉室名将，讨黄巾屡建奇功，火烧张梁大营，威震冀州。','小说叙写其用兵持重，与朱儁协力荡平黄巾主力。','忠于汉室，志在剿灭祸乱。'),
('huangfu-song','en','Huangfu Song',ARRAY['Yizhen']::text[],'A celebrated Han general whose repeated feats against the Yellow Turbans, including the fire attack that broke Zhang Liang''s camp, made his name feared across Jizhou.','The novel portrays him as a careful strategist who works with Zhu Jun to sweep away the main rebel forces.','Loyal to the Han house, he is determined to stamp out the rebellion.'),
('lu-zhi','zh-CN','卢植',ARRAY['子干']::text[],'大儒名将，刘备、公孙瓒之师，奉命讨黄巾，围张角于广宗几近成功。','小说叙写其治军严整，却因不肯贿赂宦官使者而遭构陷罢职。','以师道治军，不齿阿附阉宦。'),
('lu-zhi','en','Lu Zhi',ARRAY['Zigan']::text[],'A renowned scholar-general and the teacher of both Liu Bei and Gongsun Zan, sent to crush the Yellow Turbans and nearly taking Zhang Jiao''s stronghold at Guangzong.','The novel shows him commanding with strict discipline, only to be framed and removed from office after refusing to bribe a eunuch inspector.','He leads by a teacher''s discipline and refuses to curry favor with the eunuchs.'),
('emperor-ling','zh-CN','汉灵帝',ARRAY['刘宏']::text[],'汉灵帝刘宏，昏庸宠信十常侍，卖官鬻爵，黄巾之乱由此而起，驾崩后诸子争位，天下大乱自此始。','小说以其昏聩点出汉室倾颓的根由，为全书乱世埋下总纲。','沉溺声色犬马，放纵宦官弄权。'),
('emperor-ling','en','Emperor Ling of Han',ARRAY['Liu Hong']::text[],'Emperor Ling, personal name Liu Hong, doted on the Ten Attendants and sold offices openly; the Yellow Turban revolt grew from his misrule, and his death touches off the great disorder that engulfs the realm.','The novel uses his folly to set out the root cause of Han''s decline, laying the frame for the whole age of division.','Absorbed in pleasure, he let the eunuchs run rampant with power.'),
('ding-yuan','zh-CN','丁原',ARRAY['建阳']::text[],'并州刺史，义子吕布骁勇冠三军，率兵入京与董卓相争，终被吕布为赤兔马与金珠所惑，弑主来降。','小说叙写其待吕布如子，却料不到义子见利忘义。','欲联合朝臣力量对抗董卓的凉州兵势。'),
('ding-yuan','en','Ding Yuan',ARRAY['Jianyang']::text[],'Inspector of Bing Province whose foster son Lu Bu, peerless in arms, led his troops to the capital to contend with Dong Zhuo, only to be lured by gold and a fine horse into murdering his own patron.','The novel shows him treating Lu Bu like a son, never suspecting the young warrior would abandon loyalty for gain.','He hoped to rally court allies against Dong Zhuo''s Liangzhou army.'),
('li-jue','zh-CN','李傕',ARRAY['稚然']::text[],'董卓部将，卓死后纠合郭汜等反攻长安，纵兵屠掠，王允殉难，汉室再陷兵祸。','小说叙写贾诩献计怂恿其反攻，遂酿成又一场浩劫。','惧祸及身，索性铤而走险攻打长安。'),
('li-jue','en','Li Jue',ARRAY['Zhiran']::text[],'One of Dong Zhuo''s officers who, after his master''s death, rallied Guo Si and others to storm Chang''an, unleashing his troops in slaughter and plunder as Wang Yun died and Han fell once more into chaos.','The novel has Jia Xu''s counsel spur him into the counterattack that brings on fresh calamity.','Fearing he would be next to die, he gambles everything on an assault on Chang''an.'),
('guo-si','zh-CN','郭汜',ARRAY[]::text[],'董卓部将，随李傕攻破长安，其后二人反目相攻，长安再遭兵祸。','小说叙写其与李傕本是同谋，后因猜忌而互相攻杀。','与李傕同求自保，共举兵犯长安。'),
('guo-si','en','Guo Si',ARRAY[]::text[],'One of Dong Zhuo''s officers who joined Li Jue in storming Chang''an, only for the two to later turn on each other and plunge the city into fresh warfare.','The novel shows him as Li Jue''s co-conspirator turned rival, the two destroying each other out of mutual suspicion.','Seeking safety alongside Li Jue, he joins the assault on Chang''an.'),
('hua-xiong','zh-CN','华雄',ARRAY[]::text[],'董卓部将，骁勇善战，讨董联军初战屡挫诸侯兵锋，后于阵前为关羽温酒之间斩杀。','小说叙写其连斩联军数员战将，声势正盛时为关羽阵斩，反衬其锐气。','为董卓先锋，欲挫联军锐气以扬威名。'),
('hua-xiong','en','Hua Xiong',ARRAY[]::text[],'A fierce officer under Dong Zhuo who routed several of the coalition''s contingents in the opening clashes, before Guan Yu killed him in single combat while his wine still stood warm.','The novel has him cut down several coalition officers at the height of his momentum, only to fall to Guan Yu just as his reputation peaks.','Serving as Dong Zhuo''s vanguard, he means to break the coalition''s momentum and make his name.')
) AS v(slug,locale,name,aliases,summary,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 2. LOCATIONS (era-specific minor sites, <=3 per work per era)
-- ============================================================

INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
-- Records (志)
('36000000-0000-4000-8001-000000000001','10000000-0000-4000-8000-000000000006','anxi-county','real',ST_GeogFromText('POINT(114.9891 38.5065)'),NULL,NULL,100,'city','approximate',12,'CN',true,true),
('36000000-0000-4000-8002-000000000001','10000000-0000-4000-8000-000000000006','yangren','real',ST_GeogFromText('POINT(112.8500 34.1667)'),NULL,NULL,200,'battlefield','inferred',12,'CN',true,true),
-- Romance (演义)
('37000000-0000-4000-8001-000000000001','10000000-0000-4000-8000-000000000007','anxi-county','real',ST_GeogFromText('POINT(114.9891 38.5065)'),NULL,NULL,100,'city','approximate',12,'CN',true,true),
('37000000-0000-4000-8002-000000000001','10000000-0000-4000-8000-000000000007','yangren','real',ST_GeogFromText('POINT(112.8500 34.1667)'),NULL,NULL,200,'battlefield','inferred',12,'CN',true,true),
('37000000-0000-4000-8002-000000000002','10000000-0000-4000-8000-000000000007','sishui-pass','real',ST_GeogFromText('POINT(113.0600 34.7890)'),NULL,NULL,201,'landmark','inferred',12,'CN',true,true)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',v.region FROM locations l JOIN (VALUES
('anxi-county','zh-CN','安喜县','中山国属县，刘备讨黄巾有功后任县尉之地。','冀州中山国'),
('anxi-county','en','Anxi County','A county of the Zhongshan princedom where Liu Bei served as a commandant after his service against the Yellow Turbans.','Zhongshan, Jizhou'),
('yangren','zh-CN','阳人聚','阳城附近聚落，孙坚在此大破董卓前锋部队。','司隶河南尹'),
('yangren','en','Yangren','A settlement near Yangcheng where Sun Jian shattered Dong Zhuo''s vanguard force.','Henan Commandery, Sili'),
('sishui-pass','zh-CN','汜水关','虎牢关以西的关隘，小说中联军先锋在此与华雄交战。','司隶荥阳'),
('sishui-pass','en','Sishui Pass','A pass west of Hulao Gate where, in the novel, the coalition''s vanguard clashes with Hua Xiong.','Xingyang, Sili')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug
WHERE l.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

-- Note: anxi-county/yangren rows above apply to both works' matching-slug
-- rows (JOIN by slug only, filtered by WHERE work_id IN (...)); sishui-pass
-- only exists as a Romance row so its translation naturally attaches there.

-- ============================================================
-- 3. EVENTS
-- ============================================================

-- Records (志) — KK=01 yellow-turban-rising (7 events)
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('64000000-0000-4000-8001-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',v.slug,1000+v.n,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'julian'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'yellow-turban-rebellion-breaks-out','verified_historical','battle','exact',184,184,'high'),
(2,'lu-zhi-and-huangfu-song-take-command','reported_historical','political','exact',184,184,'medium'),
(3,'huangfu-song-breaks-yellow-turbans-at-changshe','verified_historical','battle','exact',184,184,'high'),
(4,'zhang-jiao-dies-at-guangzong','verified_historical','death','exact',184,184,'high'),
(5,'liu-bei-serves-as-a-county-commandant','reported_historical','political','approximate',184,185,'low'),
(6,'emperor-ling-dies-at-luoyang','verified_historical','death','exact',189,189,'high'),
(7,'he-jin-summons-dong-zhuo-to-the-capital','reported_historical','political','exact',189,189,'medium')
) AS v(n,slug,reality,etype,ttype,y1,y2,conf)
JOIN chapters ch ON ch.slug='yellow-turban-rising' AND ch.work_id='10000000-0000-4000-8000-000000000006';

-- Records (志) — KK=02 dong-zhuo-usurpation (7 events)
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('64000000-0000-4000-8002-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',v.slug,2000+v.n,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'julian'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'lu-bu-kills-ding-yuan-and-joins-dong-zhuo','reported_historical','betrayal','exact',189,189,'medium'),
(2,'dong-zhuo-deposes-young-emperor-and-installs-liu-xie','verified_historical','political','exact',189,189,'high'),
(3,'dong-zhuo-burns-luoyang-and-moves-the-capital-to-changan','verified_historical','other','exact',190,190,'high'),
(4,'sun-jian-defeats-hua-xiong-at-yangren','verified_historical','battle','exact',190,190,'high'),
(5,'wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','verified_historical','political','exact',192,192,'high'),
(6,'dong-zhuo-is-killed-at-changan','verified_historical','death','exact',192,192,'high'),
(7,'li-jue-and-guo-si-attack-changan','reported_historical','battle','exact',192,192,'medium')
) AS v(n,slug,reality,etype,ttype,y1,y2,conf)
JOIN chapters ch ON ch.slug='dong-zhuo-usurpation' AND ch.work_id='10000000-0000-4000-8000-000000000006';

-- Romance (演义) — KK=01 yellow-turban-rising (10 events)
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('65000000-0000-4000-8001-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',v.slug,1000+v.n,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'julian'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'yellow-turban-rebellion-breaks-out','fictional_with_historical_context','battle','exact',184,184,'medium'),
(2,'huangfu-song-breaks-yellow-turbans-at-changshe','fictional_with_historical_context','battle','exact',184,184,'medium'),
(3,'zhang-jiao-dies-at-guangzong','fictional_with_historical_context','death','exact',184,184,'medium'),
(4,'emperor-ling-dies-at-luoyang','fictional_with_historical_context','death','exact',189,189,'medium'),
(5,'he-jin-summons-dong-zhuo-to-the-capital','fictional_with_historical_context','political','exact',189,189,'medium'),
(6,'oath-of-the-peach-garden','fictional_narrative','other','exact',184,184,'low'),
(7,'liu-bei-and-brothers-raise-a-militia','fictional_with_historical_context','battle','exact',184,184,'medium'),
(8,'zhang-fei-whips-the-inspector','fictional_narrative','betrayal','approximate',184,185,'low'),
(9,'eunuchs-kill-he-jin','fictional_with_historical_context','death','exact',189,189,'medium'),
(10,'yuan-shao-purges-the-eunuchs','fictional_with_historical_context','battle','exact',189,189,'medium')
) AS v(n,slug,reality,etype,ttype,y1,y2,conf)
JOIN chapters ch ON ch.slug='yellow-turban-rising' AND ch.work_id='10000000-0000-4000-8000-000000000007';

-- Romance (演义) — KK=02 dong-zhuo-usurpation (10 events)
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('65000000-0000-4000-8002-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',v.slug,2000+v.n,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'julian'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'lu-bu-kills-ding-yuan-and-joins-dong-zhuo','fictional_with_historical_context','betrayal','exact',189,189,'medium'),
(2,'dong-zhuo-deposes-young-emperor-and-installs-liu-xie','fictional_with_historical_context','political','exact',189,189,'medium'),
(3,'dong-zhuo-burns-luoyang-and-moves-the-capital-to-changan','fictional_with_historical_context','other','exact',190,190,'medium'),
(4,'wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','fictional_with_historical_context','political','exact',192,192,'medium'),
(5,'dong-zhuo-is-killed-at-changan','fictional_with_historical_context','death','exact',192,192,'medium'),
(6,'li-jue-and-guo-si-attack-changan','fictional_with_historical_context','battle','exact',192,192,'medium'),
(7,'guan-yu-slays-hua-xiong-with-wine-still-warm','fictional_narrative','battle','exact',190,190,'low'),
(8,'three-heroes-battle-lu-bu-at-hulao-pass','fictional_narrative','battle','exact',190,190,'low'),
(9,'wang-yun-devises-the-chain-stratagem-with-diaochan','fictional_narrative','other','exact',191,191,'low'),
(10,'dong-zhuo-and-lu-bu-vie-for-diaochan-at-the-phoenix-pavilion','fictional_narrative','betrayal','exact',192,192,'low')
) AS v(n,slug,reality,etype,ttype,y1,y2,conf)
JOIN chapters ch ON ch.slug='dong-zhuo-usurpation' AND ch.work_id='10000000-0000-4000-8000-000000000007';

-- ============================================================
-- 4. EVENT TRANSLATIONS
-- ============================================================

-- Records (志) — KK=01
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.significance,v.time_label FROM events e JOIN (VALUES
('yellow-turban-rebellion-breaks-out','zh-CN','黄巾起事','志载张角以太平道聚众数十万，中平元年头裹黄巾同日举兵，八州并发。','张角自称大贤良师，以符水治病广收信众，与弟张宝、张梁约期同反，汉廷仓促应对。','汉室统治根基自此动摇，群雄并起的时代由此开启。','约公元184年'),
('yellow-turban-rebellion-breaks-out','en','The Yellow Turban Rebellion breaks out','The Records records Zhang Jiao''s Way of Great Peace raising several hundred thousand followers, who rose in yellow-turbaned revolt across eight provinces on the same day in 184.','Zhang Jiao, styling himself Great Teacher of Virtue, had drawn vast numbers of followers through healing water and talismans; he and his brothers Zhang Bao and Zhang Liang timed a coordinated uprising that caught the Han court unprepared.','The uprising shook the foundations of Han rule and opened the age in which regional warlords would rise.','c. 184 CE'),
('lu-zhi-and-huangfu-song-take-command','zh-CN','卢植、皇甫嵩受命出讨','志载汉廷以卢植、皇甫嵩、朱儁分讨黄巾三路主力。','卢植北攻张角本部于广宗，皇甫嵩、朱儁分讨颍川、汝南诸部。','确立了汉廷讨伐黄巾的军事部署格局。','约公元184年'),
('lu-zhi-and-huangfu-song-take-command','en','Lu Zhi and Huangfu Song take command','The Records records the Han court dispatching Lu Zhi, Huangfu Song, and Zhu Jun to campaign against the three main Yellow Turban forces.','Lu Zhi marched north against Zhang Jiao''s main force at Guangzong while Huangfu Song and Zhu Jun campaigned against the rebel bands in Yingchuan and Runan.','This set the military framework for the Han court''s campaign against the rebellion.','c. 184 CE'),
('huangfu-song-breaks-yellow-turbans-at-changshe','zh-CN','皇甫嵩火攻长社破黄巾','志载皇甫嵩、朱儁于长社乘夜纵火，大破黄巾波才部。','时黄巾依草结营，皇甫嵩乘风纵火，曹操引骑兵适至助战，波才大败。','此役是官军扭转黄巾战局的关键一战。','约公元184年'),
('huangfu-song-breaks-yellow-turbans-at-changshe','en','Huangfu Song breaks the Yellow Turbans at Changshe','The Records records Huangfu Song and Zhu Jun launching a night fire attack at Changshe that shattered the Yellow Turban commander Bo Cai''s forces.','The rebels had camped amid dry grass; Huangfu Song set it ablaze with the wind, and Cao Cao''s arriving cavalry helped rout Bo Cai''s shattered army.','This battle marked the turning point by which government forces gained the upper hand against the rebellion.','c. 184 CE'),
('zhang-jiao-dies-at-guangzong','zh-CN','张角病殁广宗','志载张角在广宗与官军相持，未及城破先已病殁。','皇甫嵩继卢植之后围攻广宗，破城时张角已病死，官军戮其尸。','黄巾主力核心至此瓦解。','约公元184年'),
('zhang-jiao-dies-at-guangzong','en','Zhang Jiao dies at Guangzong','The Records records Zhang Jiao dying of illness at Guangzong while besieged, before the city itself fell.','Huangfu Song took over the siege of Guangzong from Lu Zhi; by the time the city fell Zhang Jiao had already died of illness, and the troops exhumed and mutilated his corpse.','The core of the Yellow Turban leadership collapsed with his death.','c. 184 CE'),
('liu-bei-serves-as-a-county-commandant','zh-CN','刘备任安喜县尉','志载刘备讨黄巾有功，除安喜县尉，后因督邮欲加害而弃官离去。','督邮以公事至县，欲有所举劾，刘备求见不许，遂自杖击督邮而去官。','是刘备早年仕宦生涯的最初挫折与转折。','约公元184–185年'),
('liu-bei-serves-as-a-county-commandant','en','Liu Bei serves as a county commandant','The Records records Liu Bei, rewarded for his service against the Yellow Turbans with the post of commandant at Anxi, later abandoning the office after a corrupt inspector sought to harm him.','When an inspector arrived on official business and refused to see him, Liu Bei himself struck the man with a rod and left his post.','This marks the earliest setback and turning point of Liu Bei''s official career.','c. 184–185 CE'),
('emperor-ling-dies-at-luoyang','zh-CN','汉灵帝崩于洛阳','志载灵帝崩，何进立少子刘辩为帝，外戚宦官之争骤起。','灵帝在位间宦官用事，崩后皇位继承旋即引发朝局动荡。','汉室中枢自此权力真空，为群雄干预朝政埋下契机。','约公元189年'),
('emperor-ling-dies-at-luoyang','en','Emperor Ling dies at Luoyang','The Records records Emperor Ling''s death at Luoyang, upon which He Jin enthroned the younger prince Liu Bian, igniting the clash between consort kin and eunuchs.','The eunuchs had dominated Emperor Ling''s court, and his death immediately set off turmoil over the succession.','A power vacuum opened at the center of Han rule, the opening that let regional strongmen intervene in court affairs.','c. 189 CE'),
('he-jin-summons-dong-zhuo-to-the-capital','zh-CN','何进召董卓入京','志载何进欲尽诛宦官，纳袁绍之谋，召董卓等外将将兵入京以为声援。','董卓奉召引兵东进，未至京师而何进已为宦官所杀。','此举引狼入室，为董卓其后擅权乱政埋下祸根。','约公元189年'),
('he-jin-summons-dong-zhuo-to-the-capital','en','He Jin summons Dong Zhuo to the capital','The Records records He Jin, intent on wiping out the eunuchs, adopting Yuan Shao''s proposal to summon outside generals such as Dong Zhuo to the capital in support.','Dong Zhuo marched his troops east at the summons, but He Jin was killed by the eunuchs before he could arrive.','The summons let a wolf into the house, planting the seed for Dong Zhuo''s later seizure of the court.','c. 189 CE')
) AS v(slug,locale,title,summary,detail,significance,time_label) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000006' AND e.id::text LIKE '64000000-0000-4000-8001%';

-- Records (志) — KK=02
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.significance,v.time_label FROM events e JOIN (VALUES
('lu-bu-kills-ding-yuan-and-joins-dong-zhuo','zh-CN','吕布杀丁原投董卓','志载吕布本属丁原部下，董卓入京后诱之杀原来降，尽并其众。','董卓自知兵少，欲并丁原部曲，遂以利诱吕布倒戈。','董卓由此兵力大增，得以在朝中为所欲为。','约公元189年'),
('lu-bu-kills-ding-yuan-and-joins-dong-zhuo','en','Lu Bu kills Ding Yuan and joins Dong Zhuo','The Records records Lu Bu, originally a subordinate of Ding Yuan, being persuaded by Dong Zhuo after his arrival in the capital to kill his own patron and bring the troops over.','Aware his own troops were too few, Dong Zhuo lured Lu Bu with rewards to defect and absorb Ding Yuan''s forces.','The defection sharply increased Dong Zhuo''s strength, letting him do as he pleased at court.','c. 189 CE'),
('dong-zhuo-deposes-young-emperor-and-installs-liu-xie','zh-CN','董卓废立天子','志载董卓以兵威胁百官，废少帝为弘农王，立陈留王刘协为帝，是为献帝。','百官慑于兵威，无人敢阻，董卓自为相国，权倾朝野。','汉室天子的废立大权自此落入权臣之手。','约公元189年'),
('dong-zhuo-deposes-young-emperor-and-installs-liu-xie','en','Dong Zhuo deposes the boy emperor and installs Liu Xie','The Records records Dong Zhuo, using armed intimidation against the assembled officials, deposing the boy emperor as Prince of Hongnong and installing Prince Chenliu, Liu Xie, as Emperor Xian.','Overawed by his troops, none of the officials dared object; Dong Zhuo made himself Chancellor of State, his power now unrivaled at court.','The power to depose and install emperors now lay openly in a strongman''s hands.','c. 189 CE'),
('dong-zhuo-burns-luoyang-and-moves-the-capital-to-changan','zh-CN','董卓焚洛阳迁都长安','志载关东联军起，董卓惧其锋，遂焚洛阳宫室民居，挟献帝西迁长安。','徙民数百万口西行，死者相属于道，洛阳自此残破。','东汉两百年都城自此化为灰烬，关东联军虽起而未能救之。','约公元190年'),
('dong-zhuo-burns-luoyang-and-moves-the-capital-to-changan','en','Dong Zhuo burns Luoyang and moves the capital to Chang''an','The Records records Dong Zhuo, alarmed by the rising eastern coalition, burning Luoyang''s palaces and homes and forcing Emperor Xian west to Chang''an.','Millions of residents were forced along the westward road, many dying en route, leaving Luoyang in ruins.','Two centuries of Eastern Han''s capital were reduced to ashes, and the eastern coalition proved unable to prevent it.','c. 190 CE'),
('sun-jian-defeats-hua-xiong-at-yangren','zh-CN','孙坚阳人聚破董卓前锋','志载孙坚率军为讨董联军先锋，于阳人聚大破董卓都督华雄部。','孙坚初为袁术所疑粮草不继，几败于董卓军，终整军再战而胜，威震敌胆。','是讨董联军中难得的一场实际胜仗。','约公元190年'),
('sun-jian-defeats-hua-xiong-at-yangren','en','Sun Jian defeats Dong Zhuo''s vanguard at Yangren','The Records records Sun Jian, serving as vanguard for the coalition against Dong Zhuo, shattering the forces of Dong Zhuo''s commander Hua Xiong at Yangren.','Sun Jian''s campaign nearly faltered when Yuan Shu, suspicious of him, delayed his supplies, but he rallied his troops and won a victory that struck fear into the enemy.','This stands as one of the coalition''s few genuine victories against Dong Zhuo''s forces.','c. 190 CE'),
('wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','zh-CN','王允与吕布密谋诛董卓','志载司徒王允见董卓暴虐日甚，与吕布共谋除之。','王允素与吕布交好，知其与董卓有隙，遂说以大义，约定内应。','为董卓其后遇害埋下直接伏笔。','约公元192年'),
('wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','en','Wang Yun and Lu Bu conspire to kill Dong Zhuo','The Records records Minister over the Masses Wang Yun, seeing Dong Zhuo''s tyranny worsen daily, conspiring with Lu Bu to remove him.','Already on good terms with Lu Bu and aware of his growing friction with Dong Zhuo, Wang Yun persuaded him with an appeal to loyalty and arranged for him to act from within.','This conspiracy directly sets up Dong Zhuo''s assassination soon after.','c. 192 CE'),
('dong-zhuo-is-killed-at-changan','zh-CN','董卓伏诛长安','志载吕布依王允之谋，于长安未央宫门刺杀董卓。','董卓入朝遇刺，其尸暴于市，百姓称庆。','权倾一时的董卓政权就此终结。','约公元192年'),
('dong-zhuo-is-killed-at-changan','en','Dong Zhuo is killed at Chang''an','The Records records Lu Bu, following Wang Yun''s plan, assassinating Dong Zhuo at the gate of the Weiyang Palace in Chang''an.','Dong Zhuo was struck down on his way into court, his corpse exposed in the marketplace to the rejoicing of the people.','The regime of the once-untouchable Dong Zhuo comes to an end.','c. 192 CE'),
('li-jue-and-guo-si-attack-changan','zh-CN','李傕郭汜攻陷长安','志载董卓部将李傕、郭汜惧诛，纠合旧部反攻长安，城陷，王允遇害。','二人纵兵剽掠，挟持献帝，关中自此又陷混战。','王允诛董之功毁于一旦，汉室再无宁日。','约公元192年'),
('li-jue-and-guo-si-attack-changan','en','Li Jue and Guo Si attack Chang''an','The Records records Dong Zhuo''s officers Li Jue and Guo Si, fearing execution, rallying his former troops to storm Chang''an; the city fell and Wang Yun was killed.','The two let their troops plunder freely and held the emperor under their control, plunging the region back into chaos.','Wang Yun''s achievement in ridding the court of Dong Zhuo unravels at once, and Han knows no peace thereafter.','c. 192 CE')
) AS v(slug,locale,title,summary,detail,significance,time_label) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000006' AND e.id::text LIKE '64000000-0000-4000-8002%';

-- Romance (演义) — KK=01
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.significance,v.time_label FROM events e JOIN (VALUES
('yellow-turban-rebellion-breaks-out','zh-CN','黄巾起事','小说叙写张角自称大贤良师，散施符水聚众百万，头裹黄巾同日举事。','张角兄弟三人分掌天、地、人三公，约期同反，天下州郡一时俱乱。','全书群雄并起的乱世由此正式拉开帷幕。','约公元184年'),
('yellow-turban-rebellion-breaks-out','en','The Yellow Turban Rebellion breaks out','The novel opens with Zhang Jiao, styling himself Great Teacher of Virtue, gathering a million followers with talismans and healing water before rising in yellow-turbaned revolt.','Zhang Jiao and his two brothers, calling themselves the Dukes of Heaven, Earth, and Man, time their revolt together, throwing every province into chaos at once.','This formally raises the curtain on the age of warlords that fills the rest of the novel.','c. 184 CE'),
('huangfu-song-breaks-yellow-turbans-at-changshe','zh-CN','皇甫嵩火攻长社破黄巾','小说叙写皇甫嵩、朱儁于长社纵火破敌，曹操引兵接应立功。','黄巾依草结营，一夜大火烧营，曹操恰引骑兵杀到，斩获甚众。','曹操由此崭露头角，登上乱世舞台。','约公元184年'),
('huangfu-song-breaks-yellow-turbans-at-changshe','en','Huangfu Song breaks the Yellow Turbans at Changshe','The novel narrates Huangfu Song and Zhu Jun breaking the rebels with fire at Changshe, with Cao Cao''s arriving troops helping seal the victory.','The rebels'' grass-walled camp goes up in flames overnight, and Cao Cao''s timely cavalry charge adds to the slaughter.','The battle is Cao Cao''s first notable appearance on the stage of the unfolding chaos.','c. 184 CE'),
('zhang-jiao-dies-at-guangzong','zh-CN','张角病殁广宗','小说叙写张角在广宗与官军相持中病重身亡，官军破城戮其尸。','张梁、张宝相继战死，黄巾三兄弟至此俱亡，声势顿息。','黄巾之乱的主线至此告一段落，群雄逐鹿的新局面接续展开。','约公元184年'),
('zhang-jiao-dies-at-guangzong','en','Zhang Jiao dies at Guangzong','The novel has Zhang Jiao fall gravely ill and die at Guangzong during the siege, his corpse mutilated when the city falls.','With Zhang Liang and Zhang Bao both already dead in battle, all three brothers are now gone and the revolt''s momentum collapses.','The main thread of the Yellow Turban revolt closes here, giving way to the contest among warlords that follows.','c. 184 CE'),
('emperor-ling-dies-at-luoyang','zh-CN','汉灵帝崩于洛阳','小说叙写灵帝崩逝，何进立少子刘辩，宦官外戚之争骤然爆发。','灵帝昏庸信任宦官的积弊，至此引发朝局剧变。','汉室倾颓的总纲至此全面展开。','约公元189年'),
('emperor-ling-dies-at-luoyang','en','Emperor Ling dies at Luoyang','The novel narrates Emperor Ling''s death at Luoyang, whereupon He Jin enthrones the younger prince and the clash between eunuchs and consort kin erupts.','The accumulated damage of the emperor''s trust in the eunuchs now bursts into open crisis at court.','The novel''s larger frame of Han''s collapse now unfolds in full.','c. 189 CE'),
('he-jin-summons-dong-zhuo-to-the-capital','zh-CN','何进召董卓入京','小说叙写何进纳袁绍之议，召四方猛将入京以胁迫太后诛除宦官，董卓应召而来。','陈琳、曹操皆谏阻此议，何进不听，终酿大祸。','董卓由此获得名正言顺进京的机会，乱政自此发端。','约公元189年'),
('he-jin-summons-dong-zhuo-to-the-capital','en','He Jin summons Dong Zhuo to the capital','The novel has He Jin, on Yuan Shao''s advice, summon outside warlords to pressure the empress dowager into purging the eunuchs, and Dong Zhuo answers the call.','Both Chen Lin and Cao Cao warn against the plan, but He Jin ignores them, setting the stage for disaster.','The summons gives Dong Zhuo his pretext to enter the capital, and from it his usurpation of the court begins.','c. 189 CE'),
('oath-of-the-peach-garden','zh-CN','桃园结义','小说叙写刘备、关羽、张飞于张飞庄后桃园焚香结拜，誓同生死。','三人虽异姓，誓词却愿同心协力，救困扶危，不求同年同月同日生，只求同年同月同日死。','此誓开启全书情义主线，为三人日后患难与共奠定根基。','约公元184年'),
('oath-of-the-peach-garden','en','The oath of the Peach Garden','The novel has Liu Bei, Guan Yu, and Zhang Fei burn incense in a peach garden behind Zhang Fei''s estate and swear an oath to live and die together.','Though unrelated by blood, the three swear to join their strength in aid of the realm, asking not to be born on the same day but to die on it together.','The oath opens the novel''s central theme of brotherhood, the foundation for everything the three will share thereafter.','c. 184 CE'),
('liu-bei-and-brothers-raise-a-militia','zh-CN','刘关张聚义讨黄巾','小说叙写三人结义后招募乡勇，投效卢植麾下共讨黄巾。','三人首战即解卢植之围，崭露头角。','三兄弟由此正式踏上乱世舞台。','约公元184年'),
('liu-bei-and-brothers-raise-a-militia','en','Liu Bei and his brothers raise a militia','The novel has the three sworn brothers raise a local militia after their oath and place themselves under Lu Zhi''s command against the Yellow Turbans.','Their first engagement lifts the siege around Lu Zhi''s position, marking their first notable feat.','This marks the three brothers'' formal entry onto the stage of the unfolding chaos.','约公元184年'),
('zhang-fei-whips-the-inspector','zh-CN','张飞怒鞭督邮','小说叙写刘备任安喜县尉后，贪暴督邮欲加害之，张飞怒而将其绑树鞭打。','刘备、关羽劝止不及，事后三人挂印弃官而去，另投他处。','此段以张飞之刚烈衬托刘备之隐忍，二人性格由此定型。','约公元184–185年'),
('zhang-fei-whips-the-inspector','en','Zhang Fei whips the inspector','The novel has a corrupt inspector try to harm Liu Bei after his appointment as commandant of Anxi, only for Zhang Fei to bind him to a tree and thrash him in fury.','Liu Bei and Guan Yu arrive too late to stop him; the three then hang up the official seal and move on to seek service elsewhere.','The episode uses Zhang Fei''s fiery temper to set off Liu Bei''s forbearance, fixing both their characters for the rest of the novel.','c. 184–185 CE'),
('eunuchs-kill-he-jin','zh-CN','十常侍诱杀何进','小说叙写十常侍诈称太后相召，诱何进入宫杀之。','何进不听袁绍之谏，独自入宫赴召，终遭伏杀。','何进之死使袁绍等尽诛宦官，朝局彻底失控。','约公元189年'),
('eunuchs-kill-he-jin','en','The eunuchs kill He Jin','The novel has the Ten Attendants falsely claim the empress dowager summons him, luring He Jin into the palace to kill him.','Ignoring Yuan Shao''s warnings, He Jin enters the palace alone at the false summons and is ambushed and killed.','His death sets off Yuan Shao''s slaughter of the eunuchs, and control of the court slips away entirely.','c. 189 CE'),
('yuan-shao-purges-the-eunuchs','zh-CN','袁绍尽诛宦官','小说叙写何进遇害后，袁绍引兵入宫尽杀宦官为其复仇。','宫中大乱，少帝与陈留王仓皇出逃，途中为董卓兵马所遇。','少帝与董卓由此相遇，直接引出董卓入京擅权的下一幕。','约公元189年'),
('yuan-shao-purges-the-eunuchs','en','Yuan Shao purges the eunuchs','The novel has Yuan Shao lead troops into the palace to slaughter the eunuchs in revenge once news of He Jin''s death spreads.','The palace descends into chaos as the boy emperor and Prince Chenliu flee in confusion, only to run into Dong Zhuo''s approaching troops.','This chance meeting between the boy emperor and Dong Zhuo leads directly into the next act of his seizure of the court.','c. 189 CE')
) AS v(slug,locale,title,summary,detail,significance,time_label) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000007' AND e.id::text LIKE '65000000-0000-4000-8001%';

-- Romance (演义) — KK=02
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.significance,v.time_label FROM events e JOIN (VALUES
('lu-bu-kills-ding-yuan-and-joins-dong-zhuo','zh-CN','吕布杀丁原投董卓','小说叙写李肃奉董卓之命，以赤兔马、金珠说吕布杀丁原来降。','吕布连夜提丁原首级来见董卓，董卓大喜，认吕布为义子。','吕布见利忘义之名由此坐实，也为其日后再弑义父埋下伏笔。','约公元189年'),
('lu-bu-kills-ding-yuan-and-joins-dong-zhuo','en','Lu Bu kills Ding Yuan and joins Dong Zhuo','The novel has Li Su, sent by Dong Zhuo, win Lu Bu over with the horse Red Hare and gifts of gold, persuading him to kill Ding Yuan and defect.','Lu Bu brings Ding Yuan''s head to Dong Zhuo that same night, and the delighted Dong Zhuo adopts him as a foster son.','This cements Lu Bu''s reputation for betraying loyalty over gain, foreshadowing his killing of a second foster father later on.','c. 189 CE'),
('dong-zhuo-deposes-young-emperor-and-installs-liu-xie','zh-CN','董卓废立天子','小说叙写董卓于朝堂之上按剑喝令百官，废少帝立陈留王，唯丁管、伍孚等抗争而遇害。','董卓自此专擅朝政，百官敢怒而不敢言。','董卓暴政的高潮由此确立，也激起关东诸侯讨伐之心。','约公元189年'),
('dong-zhuo-deposes-young-emperor-and-installs-liu-xie','en','Dong Zhuo deposes the boy emperor and installs Liu Xie','The novel has Dong Zhuo, hand on his sword, browbeat the assembled officials into deposing the boy emperor for Prince Chenliu, killing the few like Ding Guan and Wu Fu who dare object.','Dong Zhuo now dominates the court outright, and the officials seethe in silence.','This marks the height of Dong Zhuo''s tyranny and stirs the eastern lords to raise their coalition against him.','c. 189 CE'),
('dong-zhuo-burns-luoyang-and-moves-the-capital-to-changan','zh-CN','董卓焚洛阳迁都长安','小说叙写董卓惧联军兵锋，尽焚洛阳宫殿民居，驱百姓西行，惨状载道。','董卓又命人掘皇陵取宝，暴虐之状愈演愈烈。','洛阳化为焦土，董卓恶名至此达于顶点。','约公元190年'),
('dong-zhuo-burns-luoyang-and-moves-the-capital-to-changan','en','Dong Zhuo burns Luoyang and moves the capital to Chang''an','The novel has Dong Zhuo, fearing the coalition''s advance, burn every palace and home in Luoyang and force the population west, the road strewn with suffering.','He further orders the imperial tombs opened for their treasures, his cruelty growing ever more extreme.','Luoyang is left a smoking ruin, and Dong Zhuo''s infamy reaches its peak.','c. 190 CE'),
('wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','zh-CN','王允与吕布密谋诛董卓','小说叙写连环计功成后，王允乘隙说吕布以大义，约期共诛董卓。','吕布念及凤仪亭之恨，欣然应允，只待时机下手。','王允之谋至此进入最后阶段。','约公元192年'),
('wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','en','Wang Yun and Lu Bu conspire to kill Dong Zhuo','The novel has Wang Yun, once his chain stratagem has taken hold, appeal to Lu Bu''s sense of honor and set a date to kill Dong Zhuo together.','Still smarting from the humiliation at the Phoenix Pavilion, Lu Bu readily agrees, waiting only for the moment to strike.','Wang Yun''s scheme now enters its final stage.','c. 192 CE'),
('dong-zhuo-is-killed-at-changan','zh-CN','董卓伏诛长安','小说叙写董卓奉诏入朝，行至宫门为吕布戟刺身死。','长安百姓闻讯欢呼，争相以身缠脂膏为灯，焚尸数日不绝。','全书恶贯满盈的一幕，暴虐者终得应有下场。','约公元192年'),
('dong-zhuo-is-killed-at-changan','en','Dong Zhuo is killed at Chang''an','The novel has Dong Zhuo, summoned to court, struck down by Lu Bu''s halberd at the palace gate.','The people of Chang''an cheer at the news, wrapping his corpse in fat to burn as lamp fuel for days on end.','A moment of poetic justice in the novel, the tyrant meeting the end his cruelty had long invited.','c. 192 CE'),
('li-jue-and-guo-si-attack-changan','zh-CN','李傕郭汜攻陷长安','小说叙写贾诩献计，李傕、郭汜纠合西凉旧部反攻长安，城破，王允殉难。','二贼纵兵大掠，长安百姓死伤枕藉，胜利的喜悦转瞬成空。','王允之死为诛董一事画上悲剧句点，长安再陷兵祸。','约公元192年'),
('li-jue-and-guo-si-attack-changan','en','Li Jue and Guo Si attack Chang''an','The novel has Jia Xu counsel Li Jue and Guo Si to rally Dong Zhuo''s old Liangzhou troops and storm Chang''an; the city falls and Wang Yun dies for his cause.','The two let their troops run riot, and the city''s brief joy at Dong Zhuo''s death turns at once to fresh slaughter.','Wang Yun''s death gives the fall of Dong Zhuo a tragic coda, and Chang''an falls once more into war.','c. 192 CE'),
('guan-yu-slays-hua-xiong-with-wine-still-warm','zh-CN','温酒斩华雄','小说叙写联军诸将屡挫于华雄，关羽请缨出战，曹操温酒相待，未及酒凉已提华雄之首而返。','座中诸侯多轻其马弓手身份，唯曹操赏识，此战令关羽名声初显。','是关羽在全书中的第一场高光战绩，也奠定其"温酒斩华雄"的经典形象。','约公元190年'),
('guan-yu-slays-hua-xiong-with-wine-still-warm','en','Guan Yu slays Hua Xiong while the wine is still warm','The novel has coalition officers falter one after another before Hua Xiong until Guan Yu asks to fight; Cao Cao pours him a cup of warm wine, and he returns with Hua Xiong''s head before it has cooled.','Many of the assembled lords look down on his lowly rank of archer-groom, but Cao Cao alone recognizes his worth, and the feat first makes Guan Yu''s name known.','This is Guan Yu''s first standout feat in the novel, fixing the image behind the famous phrase "the wine still warm."','c. 190 CE'),
('three-heroes-battle-lu-bu-at-hulao-pass','zh-CN','三英战吕布','小说叙写联军会战虎牢关，吕布连挫诸将，张飞、关羽、刘备三人合力方将其逼退。','吕布虽退，其骁勇之名却由此役传遍诸侯军中。','是全书武艺描写的高潮场面之一，也是刘关张兄弟协力作战的经典一幕。','约公元190年'),
('three-heroes-battle-lu-bu-at-hulao-pass','en','Three heroes battle Lu Bu at Hulao Pass','The novel has the coalition give battle at Hulao Pass, where Lu Bu bests officer after officer until Zhang Fei, Guan Yu, and Liu Bei together force him to withdraw.','Though Lu Bu retreats, this clash spreads his reputation for peerless valor across every contingent in the coalition.','One of the novel''s set-piece displays of martial skill, and a classic scene of the sworn brothers fighting side by side.','c. 190 CE'),
('wang-yun-devises-the-chain-stratagem-with-diaochan','zh-CN','王允巧使连环计','小说叙写王允认貂蝉为义女，先许吕布，再献董卓，欲借二人相争除国贼。','貂蝉慨然领命，愿以身赴局报答义父抚育之恩。','连环计由此正式展开，为董卓、吕布反目埋下直接导火索。','约公元191年'),
('wang-yun-devises-the-chain-stratagem-with-diaochan','en','Wang Yun devises the chain stratagem with Diaochan','The novel has Wang Yun take Diaochan as his adopted daughter, first promising her to Lu Bu, then presenting her to Dong Zhuo, hoping the rivalry between the two men will bring down the tyrant.','Diaochan accepts the mission without hesitation, willing to risk herself to repay her adoptive father''s kindness.','The chain stratagem now formally begins, laying the direct fuse for the break between Dong Zhuo and Lu Bu.','c. 191 CE'),
('dong-zhuo-and-lu-bu-vie-for-diaochan-at-the-phoenix-pavilion','zh-CN','凤仪亭董卓吕布争貂蝉','小说叙写吕布与貂蝉于凤仪亭私会，为董卓撞见，掷戟怒逐，父子由此反目。','吕布仓皇逃走，自此怀恨在心，为其后倒戈诛董埋下心结。','连环计的核心冲突至此爆发，直接引出诛董之局。','约公元192年'),
('dong-zhuo-and-lu-bu-vie-for-diaochan-at-the-phoenix-pavilion','en','Dong Zhuo and Lu Bu vie for Diaochan at the Phoenix Pavilion','The novel has Lu Bu meet Diaochan secretly at the Phoenix Pavilion, only for Dong Zhuo to catch them and hurl a halberd at him in fury, breaking the bond between foster father and son.','Lu Bu flees in panic, the humiliation festering into the resentment that will later drive him to kill his foster father.','The central conflict of the chain stratagem erupts here, leading directly into the plot to kill Dong Zhuo.','c. 192 CE')
) AS v(slug,locale,title,summary,detail,significance,time_label) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000007' AND e.id::text LIKE '65000000-0000-4000-8002%';

-- ============================================================
-- 5. EVENT-LOCATIONS
-- ============================================================

INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,v.role,v.position FROM events e JOIN (VALUES
-- Records KK01
('yellow-turban-rebellion-breaks-out','guangzong','primary',0),
('lu-zhi-and-huangfu-song-take-command','luoyang','primary',0),
('huangfu-song-breaks-yellow-turbans-at-changshe','changshe','primary',0),
('zhang-jiao-dies-at-guangzong','guangzong','primary',0),
('liu-bei-serves-as-a-county-commandant','anxi-county','primary',0),
('emperor-ling-dies-at-luoyang','luoyang','primary',0),
('he-jin-summons-dong-zhuo-to-the-capital','luoyang','primary',0),
-- Records KK02
('lu-bu-kills-ding-yuan-and-joins-dong-zhuo','luoyang','primary',0),
('dong-zhuo-deposes-young-emperor-and-installs-liu-xie','luoyang','primary',0),
('dong-zhuo-burns-luoyang-and-moves-the-capital-to-changan','luoyang','primary',0),
('dong-zhuo-burns-luoyang-and-moves-the-capital-to-changan','changan','secondary',1),
('sun-jian-defeats-hua-xiong-at-yangren','yangren','primary',0),
('wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','changan','primary',0),
('dong-zhuo-is-killed-at-changan','changan','primary',0),
('li-jue-and-guo-si-attack-changan','changan','primary',0)
) AS v(event_slug,location_slug,role,position) ON e.slug=v.event_slug AND e.work_id='10000000-0000-4000-8000-000000000006' AND e.id::text LIKE '64000000%'
JOIN locations l ON l.slug=v.location_slug AND l.work_id=e.work_id
ON CONFLICT DO NOTHING;

INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,v.role,v.position FROM events e JOIN (VALUES
-- Romance KK01
('yellow-turban-rebellion-breaks-out','guangzong','primary',0),
('huangfu-song-breaks-yellow-turbans-at-changshe','changshe','primary',0),
('zhang-jiao-dies-at-guangzong','guangzong','primary',0),
('emperor-ling-dies-at-luoyang','luoyang','primary',0),
('he-jin-summons-dong-zhuo-to-the-capital','luoyang','primary',0),
('oath-of-the-peach-garden','zhuo-commandery','primary',0),
('liu-bei-and-brothers-raise-a-militia','guangzong','primary',0),
('zhang-fei-whips-the-inspector','anxi-county','primary',0),
('eunuchs-kill-he-jin','luoyang','primary',0),
('yuan-shao-purges-the-eunuchs','luoyang','primary',0),
-- Romance KK02
('lu-bu-kills-ding-yuan-and-joins-dong-zhuo','luoyang','primary',0),
('dong-zhuo-deposes-young-emperor-and-installs-liu-xie','luoyang','primary',0),
('dong-zhuo-burns-luoyang-and-moves-the-capital-to-changan','luoyang','primary',0),
('dong-zhuo-burns-luoyang-and-moves-the-capital-to-changan','changan','secondary',1),
('wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','changan','primary',0),
('dong-zhuo-is-killed-at-changan','changan','primary',0),
('li-jue-and-guo-si-attack-changan','changan','primary',0),
('guan-yu-slays-hua-xiong-with-wine-still-warm','sishui-pass','primary',0),
('three-heroes-battle-lu-bu-at-hulao-pass','hulao-pass','primary',0),
('wang-yun-devises-the-chain-stratagem-with-diaochan','changan','primary',0),
('dong-zhuo-and-lu-bu-vie-for-diaochan-at-the-phoenix-pavilion','changan','primary',0)
) AS v(event_slug,location_slug,role,position) ON e.slug=v.event_slug AND e.work_id='10000000-0000-4000-8000-000000000007' AND e.id::text LIKE '65000000%'
JOIN locations l ON l.slug=v.location_slug AND l.work_id=e.work_id
ON CONFLICT DO NOTHING;

-- ============================================================
-- 6. EVENT-CHARACTERS
-- ============================================================

INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
-- Records KK01
('yellow-turban-rebellion-breaks-out','zhang-jiao',0),('yellow-turban-rebellion-breaks-out','cao-cao',1),
('lu-zhi-and-huangfu-song-take-command','lu-zhi',0),('lu-zhi-and-huangfu-song-take-command','huangfu-song',1),
('huangfu-song-breaks-yellow-turbans-at-changshe','huangfu-song',0),('huangfu-song-breaks-yellow-turbans-at-changshe','cao-cao',1),
('zhang-jiao-dies-at-guangzong','zhang-jiao',0),('zhang-jiao-dies-at-guangzong','huangfu-song',1),
('liu-bei-serves-as-a-county-commandant','liu-bei',0),('liu-bei-serves-as-a-county-commandant','lu-zhi',1),
('emperor-ling-dies-at-luoyang','emperor-ling',0),('emperor-ling-dies-at-luoyang','he-jin',1),
('he-jin-summons-dong-zhuo-to-the-capital','he-jin',0),('he-jin-summons-dong-zhuo-to-the-capital','dong-zhuo',1),
-- Records KK02
('lu-bu-kills-ding-yuan-and-joins-dong-zhuo','lu-bu',0),('lu-bu-kills-ding-yuan-and-joins-dong-zhuo','ding-yuan',1),('lu-bu-kills-ding-yuan-and-joins-dong-zhuo','dong-zhuo',2),
('dong-zhuo-deposes-young-emperor-and-installs-liu-xie','dong-zhuo',0),('dong-zhuo-deposes-young-emperor-and-installs-liu-xie','emperor-xian',1),
('dong-zhuo-burns-luoyang-and-moves-the-capital-to-changan','dong-zhuo',0),('dong-zhuo-burns-luoyang-and-moves-the-capital-to-changan','emperor-xian',1),
('sun-jian-defeats-hua-xiong-at-yangren','sun-jian',0),('sun-jian-defeats-hua-xiong-at-yangren','yuan-shu',1),
('wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','wang-yun',0),('wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','lu-bu',1),('wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','dong-zhuo',2),
('dong-zhuo-is-killed-at-changan','lu-bu',0),('dong-zhuo-is-killed-at-changan','dong-zhuo',1),('dong-zhuo-is-killed-at-changan','wang-yun',2),
('li-jue-and-guo-si-attack-changan','li-jue',0),('li-jue-and-guo-si-attack-changan','guo-si',1),('li-jue-and-guo-si-attack-changan','wang-yun',2)
) AS v(event_slug,char_slug,ord) ON e.slug=v.event_slug AND e.work_id='10000000-0000-4000-8000-000000000006' AND e.id::text LIKE '64000000%'
JOIN characters c ON c.slug=v.char_slug AND c.work_id=e.work_id
ON CONFLICT DO NOTHING;

INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
-- Romance KK01
('yellow-turban-rebellion-breaks-out','zhang-jiao',0),('yellow-turban-rebellion-breaks-out','cao-cao',1),
('huangfu-song-breaks-yellow-turbans-at-changshe','huangfu-song',0),('huangfu-song-breaks-yellow-turbans-at-changshe','cao-cao',1),
('zhang-jiao-dies-at-guangzong','zhang-jiao',0),('zhang-jiao-dies-at-guangzong','huangfu-song',1),
('emperor-ling-dies-at-luoyang','emperor-ling',0),('emperor-ling-dies-at-luoyang','he-jin',1),
('he-jin-summons-dong-zhuo-to-the-capital','he-jin',0),('he-jin-summons-dong-zhuo-to-the-capital','dong-zhuo',1),
('oath-of-the-peach-garden','liu-bei',0),('oath-of-the-peach-garden','guan-yu',1),('oath-of-the-peach-garden','zhang-fei',2),
('liu-bei-and-brothers-raise-a-militia','liu-bei',0),('liu-bei-and-brothers-raise-a-militia','guan-yu',1),('liu-bei-and-brothers-raise-a-militia','zhang-fei',2),('liu-bei-and-brothers-raise-a-militia','lu-zhi',3),
('zhang-fei-whips-the-inspector','zhang-fei',0),('zhang-fei-whips-the-inspector','liu-bei',1),
('eunuchs-kill-he-jin','he-jin',0),('eunuchs-kill-he-jin','yuan-shao',1),
('yuan-shao-purges-the-eunuchs','yuan-shao',0),('yuan-shao-purges-the-eunuchs','he-jin',1),
-- Romance KK02
('lu-bu-kills-ding-yuan-and-joins-dong-zhuo','lu-bu',0),('lu-bu-kills-ding-yuan-and-joins-dong-zhuo','ding-yuan',1),('lu-bu-kills-ding-yuan-and-joins-dong-zhuo','dong-zhuo',2),
('dong-zhuo-deposes-young-emperor-and-installs-liu-xie','dong-zhuo',0),('dong-zhuo-deposes-young-emperor-and-installs-liu-xie','emperor-xian',1),
('dong-zhuo-burns-luoyang-and-moves-the-capital-to-changan','dong-zhuo',0),('dong-zhuo-burns-luoyang-and-moves-the-capital-to-changan','emperor-xian',1),
('wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','wang-yun',0),('wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','lu-bu',1),('wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','dong-zhuo',2),
('dong-zhuo-is-killed-at-changan','lu-bu',0),('dong-zhuo-is-killed-at-changan','dong-zhuo',1),('dong-zhuo-is-killed-at-changan','wang-yun',2),
('li-jue-and-guo-si-attack-changan','li-jue',0),('li-jue-and-guo-si-attack-changan','guo-si',1),('li-jue-and-guo-si-attack-changan','wang-yun',2),
('guan-yu-slays-hua-xiong-with-wine-still-warm','guan-yu',0),('guan-yu-slays-hua-xiong-with-wine-still-warm','hua-xiong',1),('guan-yu-slays-hua-xiong-with-wine-still-warm','cao-cao',2),
('three-heroes-battle-lu-bu-at-hulao-pass','liu-bei',0),('three-heroes-battle-lu-bu-at-hulao-pass','guan-yu',1),('three-heroes-battle-lu-bu-at-hulao-pass','zhang-fei',2),('three-heroes-battle-lu-bu-at-hulao-pass','lu-bu',3),
('wang-yun-devises-the-chain-stratagem-with-diaochan','wang-yun',0),('wang-yun-devises-the-chain-stratagem-with-diaochan','diaochan',1),
('dong-zhuo-and-lu-bu-vie-for-diaochan-at-the-phoenix-pavilion','dong-zhuo',0),('dong-zhuo-and-lu-bu-vie-for-diaochan-at-the-phoenix-pavilion','lu-bu',1),('dong-zhuo-and-lu-bu-vie-for-diaochan-at-the-phoenix-pavilion','diaochan',2)
) AS v(event_slug,char_slug,ord) ON e.slug=v.event_slug AND e.work_id='10000000-0000-4000-8000-000000000007' AND e.id::text LIKE '65000000%'
JOIN characters c ON c.slug=v.char_slug AND c.work_id=e.work_id
ON CONFLICT DO NOTHING;

-- ============================================================
-- 7. EVENT-SOURCES
-- ============================================================

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e, sources s
WHERE e.work_id='10000000-0000-4000-8000-000000000006' AND e.id::text LIKE '64000000%'
  AND s.id='56000000-0000-4000-8000-000000000001'
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e, sources s
WHERE e.work_id='10000000-0000-4000-8000-000000000007' AND e.id::text LIKE '65000000%'
  AND s.id='57000000-0000-4000-8000-000000000001'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 8. CHARACTER RELATIONS (+ relation_translations)
-- ============================================================

-- Records (志) — KK01 relations (established/closed within yellow-turban-rising)
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('74000000-0000-4000-8001-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'liu-bei','guan-yu','family','bidirectional','positive',4,'active',NULL,NULL),
(2,'liu-bei','zhang-fei','family','bidirectional','positive',4,'active',NULL,NULL),
(3,'guan-yu','zhang-fei','family','bidirectional','positive',4,'active',NULL,NULL),
(4,'zhang-jiao','cao-cao','adversary','bidirectional','negative',2,'ended','yellow-turban-rebellion-breaks-out','zhang-jiao-dies-at-guangzong'),
(5,'liu-bei','lu-zhi','mentor','source_to_target','positive',3,'active','lu-zhi-and-huangfu-song-take-command',NULL),
(6,'he-jin','dong-zhuo','ally','source_to_target','mixed',2,'ended','he-jin-summons-dong-zhuo-to-the-capital',NULL)
) AS v(n,from_slug,to_slug,rtype,dir,sentiment,strength,rstatus,start_slug,end_slug)
JOIN characters fc ON fc.slug=v.from_slug AND fc.work_id='10000000-0000-4000-8000-000000000006'
JOIN characters tc ON tc.slug=v.to_slug AND tc.work_id=fc.work_id
LEFT JOIN events se ON se.slug=v.start_slug AND se.work_id=fc.work_id
LEFT JOIN events ee ON ee.slug=v.end_slug AND ee.work_id=fc.work_id
ON CONFLICT DO NOTHING;

-- Records (志) — KK02 relations
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('74000000-0000-4000-8002-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'dong-zhuo','lu-bu','mentor','source_to_target','mixed',4,'ended','lu-bu-kills-ding-yuan-and-joins-dong-zhuo','dong-zhuo-is-killed-at-changan'),
(2,'lu-bu','ding-yuan','mentor','target_to_source','negative',2,'ended',NULL,'lu-bu-kills-ding-yuan-and-joins-dong-zhuo'),
(3,'wang-yun','lu-bu','ally','bidirectional','positive',4,'ended','wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','li-jue-and-guo-si-attack-changan'),
(4,'wang-yun','dong-zhuo','adversary','source_to_target','negative',5,'ended','wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','dong-zhuo-is-killed-at-changan'),
(5,'dong-zhuo','emperor-xian','ally','source_to_target','negative',4,'ended','dong-zhuo-deposes-young-emperor-and-installs-liu-xie','dong-zhuo-is-killed-at-changan'),
(6,'sun-jian','dong-zhuo','adversary','bidirectional','negative',3,'active','sun-jian-defeats-hua-xiong-at-yangren',NULL)
) AS v(n,from_slug,to_slug,rtype,dir,sentiment,strength,rstatus,start_slug,end_slug)
JOIN characters fc ON fc.slug=v.from_slug AND fc.work_id='10000000-0000-4000-8000-000000000006'
JOIN characters tc ON tc.slug=v.to_slug AND tc.work_id=fc.work_id
LEFT JOIN events se ON se.slug=v.start_slug AND se.work_id=fc.work_id
LEFT JOIN events ee ON ee.slug=v.end_slug AND ee.work_id=fc.work_id
ON CONFLICT DO NOTHING;

-- Romance (演义) — KK01 relations
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('75000000-0000-4000-8001-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'liu-bei','guan-yu','family','bidirectional','positive',5,'active','oath-of-the-peach-garden',NULL),
(2,'liu-bei','zhang-fei','family','bidirectional','positive',5,'active','oath-of-the-peach-garden',NULL),
(3,'guan-yu','zhang-fei','family','bidirectional','positive',5,'active','oath-of-the-peach-garden',NULL),
(4,'zhang-jiao','cao-cao','adversary','bidirectional','negative',2,'ended','yellow-turban-rebellion-breaks-out','zhang-jiao-dies-at-guangzong'),
(5,'he-jin','dong-zhuo','ally','source_to_target','mixed',2,'ended','he-jin-summons-dong-zhuo-to-the-capital','eunuchs-kill-he-jin')
) AS v(n,from_slug,to_slug,rtype,dir,sentiment,strength,rstatus,start_slug,end_slug)
JOIN characters fc ON fc.slug=v.from_slug AND fc.work_id='10000000-0000-4000-8000-000000000007'
JOIN characters tc ON tc.slug=v.to_slug AND tc.work_id=fc.work_id
LEFT JOIN events se ON se.slug=v.start_slug AND se.work_id=fc.work_id
LEFT JOIN events ee ON ee.slug=v.end_slug AND ee.work_id=fc.work_id
ON CONFLICT DO NOTHING;

-- Romance (演义) — KK02 relations
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('75000000-0000-4000-8002-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'dong-zhuo','lu-bu','mentor','source_to_target','mixed',4,'ended','lu-bu-kills-ding-yuan-and-joins-dong-zhuo','dong-zhuo-is-killed-at-changan'),
(2,'lu-bu','ding-yuan','mentor','target_to_source','negative',2,'ended',NULL,'lu-bu-kills-ding-yuan-and-joins-dong-zhuo'),
(3,'wang-yun','lu-bu','ally','bidirectional','positive',4,'ended','wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','li-jue-and-guo-si-attack-changan'),
(4,'wang-yun','dong-zhuo','adversary','source_to_target','negative',5,'ended','wang-yun-and-lu-bu-conspire-to-kill-dong-zhuo','dong-zhuo-is-killed-at-changan'),
(5,'dong-zhuo','emperor-xian','ally','source_to_target','negative',4,'ended','dong-zhuo-deposes-young-emperor-and-installs-liu-xie','dong-zhuo-is-killed-at-changan'),
(6,'dong-zhuo','diaochan','romantic','source_to_target','mixed',3,'ended','wang-yun-devises-the-chain-stratagem-with-diaochan','dong-zhuo-is-killed-at-changan'),
(7,'lu-bu','diaochan','romantic','bidirectional','positive',4,'active','wang-yun-devises-the-chain-stratagem-with-diaochan',NULL),
(8,'wang-yun','diaochan','family','source_to_target','positive',4,'active','wang-yun-devises-the-chain-stratagem-with-diaochan',NULL)
) AS v(n,from_slug,to_slug,rtype,dir,sentiment,strength,rstatus,start_slug,end_slug)
JOIN characters fc ON fc.slug=v.from_slug AND fc.work_id='10000000-0000-4000-8000-000000000007'
JOIN characters tc ON tc.slug=v.to_slug AND tc.work_id=fc.work_id
LEFT JOIN events se ON se.slug=v.start_slug AND se.work_id=fc.work_id
LEFT JOIN events ee ON ee.slug=v.end_slug AND ee.work_id=fc.work_id
ON CONFLICT DO NOTHING;

-- Relation translations — Records (志)
INSERT INTO relation_translations(relation_id,locale,label,summary,status)
SELECT r.id,v.locale::locale_code,v.label,v.summary,'published'
FROM character_relations r
JOIN characters fc ON fc.id=r.from_character_id
JOIN characters tc ON tc.id=r.to_character_id
JOIN (VALUES
('liu-bei','guan-yu','zh-CN','情谊笃厚','志载二人恩若兄弟，情谊笃厚。'),('liu-bei','guan-yu','en','Bound as brothers','The Records notes the two were "as close as brothers," in its own restrained phrase.'),
('liu-bei','zhang-fei','zh-CN','情谊笃厚','志载张飞与关羽同事刘备，稠人广坐，侍立终日。'),('liu-bei','zhang-fei','en','Bound as brothers','The Records notes Zhang Fei served Liu Bei alongside Guan Yu, standing attendance at his side through the day.'),
('guan-yu','zhang-fei','zh-CN','同殿之交','志载二人俱随先主，未见结拜之说。'),('guan-yu','zhang-fei','en','Comrades in arms','The Records records both following Liu Bei together, with no mention of any sworn oath.'),
('zhang-jiao','cao-cao','zh-CN','讨贼与贼首','志载曹操参与讨伐张角所部黄巾。'),('zhang-jiao','cao-cao','en','Suppressor and rebel','The Records records Cao Cao taking part in the campaign against Zhang Jiao''s Yellow Turban forces.'),
('liu-bei','lu-zhi','zh-CN','师从卢植','志载刘备少时曾从卢植受学，后又随其讨黄巾。'),('liu-bei','lu-zhi','en','Student and teacher','The Records records Liu Bei studying under Lu Zhi in his youth and later serving under him against the Yellow Turbans.'),
('he-jin','dong-zhuo','zh-CN','召援与应召','志载何进召董卓引兵入京以为外援。'),('he-jin','dong-zhuo','en','Summoner and the summoned','The Records records He Jin summoning Dong Zhuo''s troops to the capital as outside support.'),
('dong-zhuo','lu-bu','zh-CN','义父义子','志载董卓宠信吕布，誓为父子，后反目相杀。'),('dong-zhuo','lu-bu','en','Foster father and son','The Records records Dong Zhuo favoring Lu Bu as a sworn son, a bond that ends when Lu Bu kills him.'),
('lu-bu','ding-yuan','zh-CN','旧主与部将','志载吕布本事丁原，后见利而杀之。'),('lu-bu','ding-yuan','en','Patron and officer','The Records records Lu Bu originally serving Ding Yuan before killing him for reward.'),
('wang-yun','lu-bu','zh-CN','共谋诛卓','志载二人合谋，以吕布为内应刺杀董卓。'),('wang-yun','lu-bu','en','Co-conspirators','The Records records the two conspiring together, with Lu Bu acting from within to kill Dong Zhuo.'),
('wang-yun','dong-zhuo','zh-CN','谋主与国贼','志载王允表面顺从，暗谋诛卓。'),('wang-yun','dong-zhuo','en','Conspirator and tyrant','The Records records Wang Yun outwardly compliant while secretly plotting Dong Zhuo''s death.'),
('dong-zhuo','emperor-xian','zh-CN','权臣与天子','志载董卓立献帝而挟制之，君臣名分徒具其表。'),('dong-zhuo','emperor-xian','en','Strongman and emperor','The Records records Dong Zhuo installing then controlling Emperor Xian, the bond between ruler and minister a hollow form.'),
('sun-jian','dong-zhuo','zh-CN','讨董先锋','志载孙坚为讨董联军先锋，屡挫董卓兵锋。'),('sun-jian','dong-zhuo','en','Coalition vanguard and foe','The Records records Sun Jian serving as the coalition''s vanguard, repeatedly blunting Dong Zhuo''s forces.')
) AS v(from_slug,to_slug,locale,label,summary)
  ON fc.slug=v.from_slug AND tc.slug=v.to_slug
WHERE r.work_id='10000000-0000-4000-8000-000000000006' AND (r.id::text LIKE '74000000-0000-4000-8001%' OR r.id::text LIKE '74000000-0000-4000-8002%')
ON CONFLICT (relation_id,locale) DO NOTHING;

-- Relation translations — Romance (演义)
INSERT INTO relation_translations(relation_id,locale,label,summary,status)
SELECT r.id,v.locale::locale_code,v.label,v.summary,'published'
FROM character_relations r
JOIN characters fc ON fc.id=r.from_character_id
JOIN characters tc ON tc.id=r.to_character_id
JOIN (VALUES
('liu-bei','guan-yu','zh-CN','结义兄弟','小说叙写桃园结义，誓同生死。'),('liu-bei','guan-yu','en','Sworn brothers','The novel has them swear the Peach Garden oath, vowing to live and die together.'),
('liu-bei','zhang-fei','zh-CN','结义兄弟','小说叙写桃园结义，誓同生死。'),('liu-bei','zhang-fei','en','Sworn brothers','The novel has them swear the Peach Garden oath, vowing to live and die together.'),
('guan-yu','zhang-fei','zh-CN','结义兄弟','小说叙写桃园结义，誓同生死。'),('guan-yu','zhang-fei','en','Sworn brothers','The novel has them swear the Peach Garden oath, vowing to live and die together.'),
('zhang-jiao','cao-cao','zh-CN','讨贼与贼首','小说叙写曹操引兵助战，参与讨伐张角黄巾。'),('zhang-jiao','cao-cao','en','Suppressor and rebel','The novel has Cao Cao lead troops in support of the campaign against Zhang Jiao''s Yellow Turbans.'),
('he-jin','dong-zhuo','zh-CN','召援与应召','小说叙写何进纳袁绍之谋，召董卓引兵入京。'),('he-jin','dong-zhuo','en','Summoner and the summoned','The novel has He Jin, on Yuan Shao''s advice, summon Dong Zhuo''s troops to the capital.'),
('dong-zhuo','lu-bu','zh-CN','义父义子','小说叙写董卓认吕布为义子，后因貂蝉反目，终为吕布所杀。'),('dong-zhuo','lu-bu','en','Foster father and son','The novel has Dong Zhuo adopt Lu Bu as a foster son, a bond broken over Diaochan and ended when Lu Bu kills him.'),
('lu-bu','ding-yuan','zh-CN','义父义子','小说叙写吕布本为丁原义子，为赤兔马、金珠所惑而弑之来降。'),('lu-bu','ding-yuan','en','Foster father and son','The novel has Lu Bu, once Ding Yuan''s foster son, murder him for the horse Red Hare and gifts of gold.'),
('wang-yun','lu-bu','zh-CN','共谋诛卓','小说叙写连环计功成后，王允说吕布共谋除董卓。'),('wang-yun','lu-bu','en','Co-conspirators','The novel has Wang Yun, once the chain stratagem takes hold, win Lu Bu over to a joint plot against Dong Zhuo.'),
('wang-yun','dong-zhuo','zh-CN','谋主与国贼','小说叙写王允巧施连环计，暗中图谋诛卓。'),('wang-yun','dong-zhuo','en','Conspirator and tyrant','The novel has Wang Yun deploy his chain stratagem while secretly plotting Dong Zhuo''s downfall.'),
('dong-zhuo','emperor-xian','zh-CN','权臣与天子','小说叙写董卓废立天子，挟献帝以令朝纲。'),('dong-zhuo','emperor-xian','en','Strongman and emperor','The novel has Dong Zhuo depose and install emperors at will, holding Emperor Xian as a puppet of his rule.'),
('dong-zhuo','diaochan','zh-CN','献美与专宠','小说叙写王允献貂蝉，董卓大喜，纳为宠妾。'),('dong-zhuo','diaochan','en','Gifted beauty and besotted lord','The novel has Wang Yun present Diaochan to Dong Zhuo, who takes her at once as a favored concubine.'),
('lu-bu','diaochan','zh-CN','凤仪亭之情','小说叙写吕布与貂蝉暗通情愫，凤仪亭密会为董卓撞破。'),('lu-bu','diaochan','en','The Phoenix Pavilion romance','The novel has Lu Bu and Diaochan fall for each other, their secret meeting at the Phoenix Pavilion discovered by Dong Zhuo.'),
('wang-yun','diaochan','zh-CN','义父义女','小说叙写貂蝉为王允歌姬义女，慨然领命行连环计。'),('wang-yun','diaochan','en','Foster father and daughter','The novel has Diaochan, Wang Yun''s adopted daughter and household singer, accept his plan without hesitation.')
) AS v(from_slug,to_slug,locale,label,summary)
  ON fc.slug=v.from_slug AND tc.slug=v.to_slug
WHERE r.work_id='10000000-0000-4000-8000-000000000007' AND (r.id::text LIKE '75000000-0000-4000-8001%' OR r.id::text LIKE '75000000-0000-4000-8002%')
ON CONFLICT (relation_id,locale) DO NOTHING;

-- ============================================================
-- 9. GROUP MEMBERSHIP (era-specific minor cast joins existing groups)
-- ============================================================

INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g
JOIN characters c ON c.work_id=g.work_id
JOIN (VALUES
('han-court','he-jin'),
('han-court','huangfu-song'),
('han-court','emperor-ling'),
('han-court','ding-yuan'),
('men-of-letters','lu-zhi'),
('liangzhou-faction','li-jue'),
('liangzhou-faction','guo-si'),
('liangzhou-faction','hua-xiong')
) AS v(group_slug,char_slug) ON g.slug=v.group_slug AND c.slug=v.char_slug
WHERE g.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

COMMIT;
