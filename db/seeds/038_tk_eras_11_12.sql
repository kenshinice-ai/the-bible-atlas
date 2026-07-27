BEGIN;

-- Three Kingdoms content seed for KK=11 jiang-wei-and-the-last-campaigns
-- (249-262) and KK=12 fall-of-shu (263-265), Records + Romance in parallel,
-- per blueprint/WORK_TEMPLATE.md and blueprint/EXAMPLE_THREE_KINGDOMS.md.
-- Builds on db/seeds/031 (skeleton: works/chapters/groups/sources) and
-- db/seeds/032 (anchor cast + gazetteer: jiang-wei, deng-ai, zhong-hui,
-- liu-shan, sima-yi, zhuge-liang, and locations chengdu/jiange/mianzhu/
-- shouchun/luoyang/hanzhong already exist and are reused here by slug JOIN).
--
-- UUID namespace used in this file (isolated from the anchor prefixes
-- 44/45 (characters) and 34/35 (locations) already consumed by 032):
--   secondary characters  4{6|7}000000-0000-4000-80KK-############
--   small locations       3{6|7}000000-0000-4000-80KK-############
--   events                6{4|5}000000-0000-4000-80KK-############
--   character_relations   7{4|5}000000-0000-4000-80KK-############
-- (46/36/64/74 = Records; 47/37/65/75 = Romance; KK = 11 or 12 per entity's
-- home era, chosen by first/primary appearance.)
--
-- Works: Records = 10000000-0000-4000-8000-000000000006
--        Romance = 10000000-0000-4000-8000-000000000007
-- Chapters (from 031): jiang-wei-and-the-last-campaigns (seq 11, 249-262),
--                       fall-of-shu (seq 12, 263-265)

-- ============================================================
-- 1. CHARACTERS (6 secondary per work: sima-zhao, sima-shi, cao-mao,
--    zhuge-dan, huang-hao home in KK11; zhuge-zhan home in KK12)
-- ============================================================

INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
-- Records (志)
('46000000-0000-4000-8011-000000000001','10000000-0000-4000-8000-000000000006','sima-zhao',1101,'male','adult','antagonist','historical',211,265,'teacher',3),
('46000000-0000-4000-8011-000000000002','10000000-0000-4000-8000-000000000006','sima-shi',1102,'male','adult','supporting','historical',208,255,'teacher',2),
('46000000-0000-4000-8011-000000000003','10000000-0000-4000-8000-000000000006','cao-mao',1103,'male','adult','supporting','historical',241,260,'king',2),
('46000000-0000-4000-8011-000000000004','10000000-0000-4000-8000-000000000006','zhuge-dan',1104,'male','adult','supporting','historical',NULL,258,'soldier',2),
('46000000-0000-4000-8011-000000000005','10000000-0000-4000-8000-000000000006','huang-hao',1105,'male','adult','antagonist','historical',NULL,NULL,'person',2),
('46000000-0000-4000-8012-000000000001','10000000-0000-4000-8000-000000000006','zhuge-zhan',1201,'male','adult','supporting','historical',227,263,'soldier',2),
-- Romance (演义)
('47000000-0000-4000-8011-000000000001','10000000-0000-4000-8000-000000000007','sima-zhao',1101,'male','adult','antagonist','fictionalised_historical',211,265,'teacher',3),
('47000000-0000-4000-8011-000000000002','10000000-0000-4000-8000-000000000007','sima-shi',1102,'male','adult','supporting','fictionalised_historical',208,255,'teacher',2),
('47000000-0000-4000-8011-000000000003','10000000-0000-4000-8000-000000000007','cao-mao',1103,'male','adult','supporting','fictionalised_historical',241,260,'king',2),
('47000000-0000-4000-8011-000000000004','10000000-0000-4000-8000-000000000007','zhuge-dan',1104,'male','adult','supporting','fictionalised_historical',NULL,258,'soldier',2),
('47000000-0000-4000-8011-000000000005','10000000-0000-4000-8000-000000000007','huang-hao',1105,'male','adult','antagonist','fictionalised_historical',NULL,NULL,'person',2),
('47000000-0000-4000-8012-000000000001','10000000-0000-4000-8000-000000000007','zhuge-zhan',1201,'male','adult','supporting','fictionalised_historical',227,263,'soldier',2)
ON CONFLICT DO NOTHING;

-- Records (志) — 志载/传称 voice.
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('sima-zhao','zh-CN','司马昭',ARRAY['子上']::text[],'魏晋公，司马懿次子、司马师之弟，甘露五年弑高贵乡公，寻遣钟会、邓艾灭蜀，未及受禅而卒，谥文王。','累封晋公、晋王，加九锡而未称帝。','承续父兄权柄，欲扫平蜀吴以为受禅之资。'),
('sima-zhao','en','Sima Zhao',ARRAY['Zishang']::text[],'Duke of Jin under Wei, Sima Yi’s second son and Sima Shi’s younger brother, who had Cao Mao killed in 260 and dispatched Zhong Hui and Deng Ai to conquer Shu, dying in 265 shortly before his own house’s accession.','Successively enfeoffed as Duke then King of Jin and granted the Nine Bestowals, though he never proclaimed himself emperor.','Building on his father’s and brother’s power, he sought to conquer Shu and Wu as the credential for his own house’s eventual accession.'),
('sima-shi','zh-CN','司马师',ARRAY['子元']::text[],'魏大将军，司马懿长子，嘉平六年废齐王芳，正元二年讨破毌丘俭、文钦于乐嘉，旋病重卒于许昌。','嘉平六年废齐王芳，立高贵乡公。','承父司马懿之柄，欲以废立巩固司马氏专权。'),
('sima-shi','en','Sima Shi',ARRAY['Ziyuan']::text[],'Grand General of Wei, Sima Yi’s eldest son, who deposed Cao Fang in 254 and crushed the rebellion of Guanqiu Jian and Wen Qin at Leji in 255, dying of illness at Xuchang soon after.','In 254 he deposed Cao Fang and installed Cao Mao, the Duke of Gaoguixiang, as emperor.','Inheriting his father Sima Yi’s power, he sought to entrench Sima family control through the deposal and installation of emperors.'),
('cao-mao','zh-CN','曹髦',ARRAY['彦士']::text[],'魏第四位皇帝，正元二年即位，甘露五年不甘为傀儡，率殿中宿卫讨司马昭，为其党羽成济弑于南阙。','甘露五年率宿卫讨司马昭，兵败遇弑。','不甘为傀儡天子，欲奋起夺回皇权。'),
('cao-mao','en','Cao Mao',ARRAY['Yanshi']::text[],'The fourth emperor of Wei, enthroned in 254, who in 260 led the palace guard against Sima Zhao rather than remain a puppet, and was killed at the southern gate by Cheng Ji.','In 260 he led the palace guard against Sima Zhao and was killed when the attempt failed.','Unwilling to remain a puppet emperor, he sought to seize back real imperial authority.'),
('zhuge-dan','zh-CN','诸葛诞',ARRAY['公休']::text[],'魏征东大将军，琅邪阳都人，甘露二年据寿春举兵反司马昭，次年城破被杀，夷三族。','曾助平毌丘俭之乱，后据寿春反司马昭，城破族灭。','惧见疑于司马氏，遂举兵自保。'),
('zhuge-dan','en','Zhuge Dan',ARRAY['Gongxiu']::text[],'Wei’s General Who Conquers the East, a native of Yangdu in Langye, who raised rebellion at Shouchun against Sima Zhao in 257 and was killed when the city fell the following year, his clan exterminated.','He had earlier helped suppress Guanqiu Jian’s revolt before rebelling at Shouchun against Sima Zhao, his clan destroyed when the city fell.','Fearing suspicion from the Sima family, he raised his own rebellion in self-preservation.'),
('huang-hao','zh-CN','黄皓',ARRAY[]::text[],'蜀汉宦官，后主宠信之，专擅朝政，景耀中排挤姜维出屯沓中，蜀亡后为晋所恶，几遭诛而以贿得免。','蜀亡后为晋所恶，几遭诛而以贿获免。','谋一己之宠，弄权自利。'),
('huang-hao','en','Huang Hao',ARRAY[]::text[],'A eunuch of Shu Han favored by Liu Shan, who dominated the court, pressed Jiang Wei into a distant garrison at Tazhong in the early 260s, and after Shu’s fall nearly faced execution under Jin before bribing his way to freedom.','After Shu’s fall he was nearly executed under Jin before bribing his way to freedom.','He pursued his own favor and profit through manipulation of the court.'),
('zhuge-zhan','zh-CN','诸葛瞻',ARRAY['思远']::text[],'蜀汉卫将军，诸葛亮之子，尚公主，景耀六年邓艾入蜀，率军拒于绵竹，兵败与子诸葛尚俱战死。','尚蜀汉公主，官至卫将军，绵竹战殁。','欲承父志、扶保社稷，临阵死战不降。'),
('zhuge-zhan','en','Zhuge Zhan',ARRAY['Siyuan']::text[],'Guard General of Shu Han, Zhuge Liang’s son and an imperial son-in-law, who led an army against Deng Ai’s invasion at Mianzhu in 263 and died in battle there together with his son Zhuge Shang.','Married to a Shu Han princess and serving as Guard General, he died in battle at Mianzhu.','He sought to uphold his father’s devotion to the state, fighting to the death rather than surrender.')
) AS v(slug,locale,name,aliases,summary,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

-- Romance (演义) — 小说叙写 voice.
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('sima-zhao','zh-CN','司马昭',ARRAY['子上']::text[],'司马懿次子，接兄司马师之柄，弑帝立傀儡，“司马昭之心，路人所知”一语传世，遣将灭蜀而不及篡魏身死。','累封晋公、晋王，加九锡而终不肯自代。','欲效父兄故智，藉灭蜀之功为受禅铺路。'),
('sima-zhao','en','Sima Zhao',ARRAY['Zishang']::text[],'Sima Yi’s second son, who inherited his brother’s grip on power, murdered an emperor to install a puppet, and became proverbial for transparent ambition—“Sima Zhao’s intent is known to every passerby”—dying just before the throne he coveted passed to his own house.','Rising to Duke then King of Jin with the Nine Bestowals, he stopped short of claiming the throne himself.','Following his father’s and brother’s example, he sought the conquest of Shu as the credential that would pave his house’s way to the throne.'),
('sima-shi','zh-CN','司马师',ARRAY['子元']::text[],'司马懿长子，父殁后独揽魏政，废主立新，淮南二叛皆亲征平之，班师未几病殁许昌，弟司马昭继其位。','废齐王芳，立高贵乡公，权倾朝野。','欲以废立立威，巩固司马氏于魏廷的专制之权。'),
('sima-shi','en','Sima Shi',ARRAY['Ziyuan']::text[],'Sima Yi’s eldest son, who seized sole command of the Wei court after his father’s death, deposed one emperor for another, personally crushed the second Huainan rebellion, and died of illness at Xuchang on the way home, leaving his brother Sima Zhao to inherit his power.','He deposed Cao Fang and installed Cao Mao, ruling the court unchallenged.','He sought to entrench Sima authority over Wei by demonstrating his power to make and unmake emperors.'),
('cao-mao','zh-CN','曹髦',ARRAY['彦士']::text[],'少年天子，不堪司马昭跋扈，愤然拔剑亲率宿卫讨贼，反为成济所弑于云龙门下，年止二十。','拔剑亲讨司马昭，兵败被弑于宫门之下。','不甘坐视皇权旁落，宁死而不为傀儡。'),
('cao-mao','en','Cao Mao',ARRAY['Yanshi']::text[],'A youthful emperor who could no longer bear Sima Zhao’s overreach, drew his own sword to lead the palace guard against him, only to be cut down by Cheng Ji at the Cloud Dragon Gate at the age of twenty.','He personally led the guard against Sima Zhao and was killed at the palace gate when the attempt failed.','He would rather die than continue as a puppet while imperial authority slipped away.'),
('zhuge-dan','zh-CN','诸葛诞',ARRAY['公休']::text[],'魏之宿将，曾助平毌丘俭之乱，后惧司马昭见疑，据淮南举义，城破力战而死，忠愤之志见于末路。','联结东吴，据寿春反司马昭，兵败城破而亡。','惧祸及身，宁举兵一搏而不甘坐以待毙。'),
('zhuge-dan','en','Zhuge Dan',ARRAY['Gongxiu']::text[],'A veteran Wei general who had helped crush Guanqiu Jian’s revolt, later fearing Sima Zhao’s suspicion led his own uprising at Huainan, dying in battle when the city fell, his defiant loyalty visible to the last.','He allied with Wu and rebelled at Shouchun against Sima Zhao, dying when the city was overrun.','Fearing for his life, he chose open rebellion rather than await destruction passively.'),
('huang-hao','zh-CN','黄皓',ARRAY[]::text[],'后主身边佞幸宦官，谄媚弄权，蒙蔽圣听，屡阻姜维之谋，蜀汉之亡此人难辞其咎。','与阎宇结党，排挤姜维出屯沓中。','谋一己荣宠，罔顾社稷安危。'),
('huang-hao','en','Huang Hao',ARRAY[]::text[],'A flattering eunuch at Liu Shan’s side who manipulated his ruler, clouded his judgment, repeatedly frustrated Jiang Wei’s strategies, and bears no small share of blame for Shu Han’s fall.','He colluded with Yan Yu to press Jiang Wei into a distant garrison at Tazhong.','He pursued his own favor with no regard for the safety of the state.'),
('zhuge-zhan','zh-CN','诸葛瞻',ARRAY['思远']::text[],'卧龙之子，尚蜀汉公主，绵竹一战拒邓艾，父子两代殉国，临阵叹曰内不能除黄皓、外不能制姜维，死而无憾。','率子诸葛尚死战绵竹，斩邓艾使者以明志。','欲承父志、扶保社稷，宁死不降。'),
('zhuge-zhan','en','Zhuge Zhan',ARRAY['Siyuan']::text[],'The Sleeping Dragon’s son and an imperial son-in-law, who made his stand against Deng Ai at Mianzhu, dying alongside his own son in a battle where he lamented failing to remove Huang Hao within or restrain Jiang Wei without, yet met death without regret.','He fought to the death at Mianzhu with his son Zhuge Shang, beheading Deng Ai’s envoy to declare his resolve.','He sought to carry forward his father’s devotion to the state, choosing death over surrender.')
) AS v(slug,locale,name,aliases,summary,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 2. LOCATIONS (1 small location per work: yinping-trail, home KK12)
-- ============================================================

INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('36000000-0000-4000-8012-000000000001','10000000-0000-4000-8000-000000000006','yinping-trail','real',ST_GeogFromText('POINT(104.5200 32.9100)'),NULL,NULL,1200,'route_node','inferred',10,'CN',true,true),
('37000000-0000-4000-8012-000000000001','10000000-0000-4000-8000-000000000007','yinping-trail','real',ST_GeogFromText('POINT(104.5200 32.9100)'),NULL,NULL,1200,'route_node','inferred',10,'CN',true,true)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',v.region FROM locations l JOIN (VALUES
('yinping-trail','zh-CN','阴平道','景元四年邓艾偷渡入蜀所行的七百余里无人险径，起自阴平，径趋江油、绵竹。','蜀魏边界（阴平、江油间）'),
('yinping-trail','en','Yinping Trail','A trackless seven-hundred-li mountain path Deng Ai secretly crossed into Shu in 263, running from Yinping through Jiangyou toward Mianzhu.','The Shu–Wei frontier between Yinping and Jiangyou')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug
WHERE l.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 3. EVENTS
-- ============================================================

-- --- Records (志), KK11 jiang-wei-and-the-last-campaigns (7 events) ---
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('64000000-0000-4000-8011-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,v.cal::calendar_system,v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'jiang-wei-resumes-northern-campaigns',11001,'verified_historical','battle','range','unknown',249,253,'medium'),
(2,'jiang-wei-victory-at-taoxi',11003,'verified_historical','battle','exact','julian',255,255,'high'),
(3,'jiang-wei-defeated-at-duangu',11005,'verified_historical','battle','exact','julian',256,256,'high'),
(4,'first-two-huainan-rebellions',11007,'verified_historical','battle','range','unknown',251,255,'medium'),
(5,'zhuge-dan-rebellion-at-shouchun',11009,'verified_historical','battle','range','unknown',257,258,'high'),
(6,'sima-zhao-murders-cao-mao',11011,'verified_historical','betrayal','exact','julian',260,260,'high'),
(7,'huang-hao-corrupts-the-shu-court',11013,'reported_historical','political','range','unknown',258,262,'medium')
) AS v(n,slug,seq,reality,etype,ttype,cal,y1,y2,conf)
JOIN chapters ch ON ch.slug='jiang-wei-and-the-last-campaigns' AND ch.work_id='10000000-0000-4000-8000-000000000006';

-- --- Records (志), KK12 fall-of-shu (7 events) ---
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('64000000-0000-4000-8012-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,v.cal::calendar_system,v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'wei-orders-conquest-of-shu',12001,'verified_historical','political','exact','julian',263,263,'high'),
(2,'jiang-wei-withdraws-to-jiange',12003,'verified_historical','battle','exact','julian',263,263,'high'),
(3,'deng-ai-crosses-yinping',12005,'verified_historical','journey','exact','julian',263,263,'high'),
(4,'zhuge-zhan-dies-at-mianzhu',12007,'verified_historical','battle','exact','julian',263,263,'high'),
(5,'liu-shan-surrenders-shu-falls',12009,'verified_historical','political','exact','julian',263,263,'high'),
(6,'chengdu-mutiny-and-triple-deaths',12011,'verified_historical','betrayal','exact','julian',264,264,'high'),
(7,'liu-shan-professes-contentment-in-luoyang',12013,'reported_historical','social','approximate','julian',265,265,'medium')
) AS v(n,slug,seq,reality,etype,ttype,cal,y1,y2,conf)
JOIN chapters ch ON ch.slug='fall-of-shu' AND ch.work_id='10000000-0000-4000-8000-000000000006';

-- --- Romance (演义), KK11 jiang-wei-and-the-last-campaigns (9 events) ---
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('65000000-0000-4000-8011-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,v.cal::calendar_system,v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'jiang-wei-vows-to-continue-the-chancellors-mission',11001,'fictional_with_historical_context','other','approximate','unknown',249,249,'low'),
(2,'jiang-wei-campaigns-into-yongzhou',11003,'fictional_with_historical_context','battle','exact','julian',250,250,'medium'),
(3,'jiang-wei-victory-at-taoxi',11005,'fictional_with_historical_context','battle','exact','julian',255,255,'medium'),
(4,'jiang-wei-checked-at-duangu',11007,'fictional_with_historical_context','battle','exact','julian',256,256,'medium'),
(5,'wang-ling-conspires-against-sima-yi',11009,'fictional_with_historical_context','betrayal','exact','julian',251,251,'low'),
(6,'guanqiu-jian-and-wen-qin-rise-at-shouchun',11011,'fictional_with_historical_context','battle','exact','julian',255,255,'medium'),
(7,'zhuge-dan-rebels-at-shouchun',11013,'fictional_with_historical_context','battle','range','unknown',257,258,'medium'),
(8,'sima-zhao-has-cao-mao-killed',11015,'fictional_with_historical_context','betrayal','exact','julian',260,260,'high'),
(9,'huang-hao-dominates-the-shu-court',11017,'fictional_with_historical_context','political','range','unknown',258,262,'medium')
) AS v(n,slug,seq,reality,etype,ttype,cal,y1,y2,conf)
JOIN chapters ch ON ch.slug='jiang-wei-and-the-last-campaigns' AND ch.work_id='10000000-0000-4000-8000-000000000007';

-- --- Romance (演义), KK12 fall-of-shu (10 events) ---
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('65000000-0000-4000-8012-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,v.cal::calendar_system,v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'wei-court-dispatches-zhong-hui-and-deng-ai',12001,'fictional_with_historical_context','political','exact','julian',263,263,'medium'),
(2,'jiang-wei-outmaneuvers-zhong-hui-at-jiange',12003,'fictional_with_historical_context','battle','exact','julian',263,263,'medium'),
(3,'deng-ai-crosses-the-yinping-trail',12005,'fictional_with_historical_context','journey','exact','julian',263,263,'high'),
(4,'zhuge-zhan-and-his-son-die-at-mianzhu',12007,'fictional_with_historical_context','battle','exact','julian',263,263,'high'),
(5,'liu-shan-opens-the-gates-of-chengdu',12009,'fictional_with_historical_context','political','exact','julian',263,263,'high'),
(6,'zhong-hui-frames-deng-ai-for-treason',12011,'fictional_with_historical_context','betrayal','range','unknown',263,264,'medium'),
(7,'jiang-wei-feigns-surrender-to-zhong-hui',12013,'fictional_with_historical_context','betrayal','exact','julian',264,264,'medium'),
(8,'zhong-hui-rebels-in-the-chengdu-mutiny',12015,'fictional_with_historical_context','battle','exact','julian',264,264,'medium'),
(9,'deng-ai-zhong-hui-and-jiang-wei-all-perish',12017,'fictional_with_historical_context','death','exact','julian',264,264,'medium'),
(10,'liu-shan-says-he-does-not-miss-shu',12019,'fictional_with_historical_context','social','approximate','julian',265,265,'medium')
) AS v(n,slug,seq,reality,etype,ttype,cal,y1,y2,conf)
JOIN chapters ch ON ch.slug='fall-of-shu' AND ch.work_id='10000000-0000-4000-8000-000000000007';

-- ============================================================
-- 5. EVENT TRANSLATIONS
-- ============================================================

-- --- Records (志) KK11 ---
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('jiang-wei-resumes-northern-campaigns','zh-CN','姜维复兴北伐','志载姜维自嘉平元年起连年出兵雍凉，欲承丞相遗志。','姜维屡督偏师出陇西，然功业未就，粮尽而还。','开启姜维时代频繁北伐的基本格局。','公元249—253年'),
('jiang-wei-resumes-northern-campaigns','en','Jiang Wei Resumes the Northern Campaigns','The Records recounts Jiang Wei launching repeated campaigns into Yong and Liang provinces from 249 onward, in the name of his mentor’s unfinished mission.','He repeatedly led detachments into Longxi, yet achieved little before withdrawing for lack of supplies.','Establishes the pattern of frequent campaigning that defines the Jiang Wei era.','c. 249–253 CE'),
('jiang-wei-victory-at-taoxi','zh-CN','洮西大破王经','志载姜维正元二年于洮西大破魏将王经，斩获甚众。','王经退保狄道，姜维乘胜围城。','姜维北伐生涯中战果最大的一役。','公元255年'),
('jiang-wei-victory-at-taoxi','en','Victory at Taoxi','The Records records Jiang Wei’s crushing defeat of the Wei general Wang Jing at Taoxi in 255, inflicting heavy losses.','Wang Jing withdrew to defend Didao, and Jiang Wei pressed the siege in the wake of his victory.','The single greatest battlefield success of Jiang Wei’s campaigning career.','255 CE'),
('jiang-wei-defeated-at-duangu','zh-CN','段谷兵败','志载姜维甘露元年于段谷为邓艾所破，士卒死伤惨重。','胡济失期不至，姜维孤军受挫，上表自贬。','洮西大捷之后的重大挫折，暴露蜀汉后继乏力。','公元256年'),
('jiang-wei-defeated-at-duangu','en','Defeat at Duangu','The Records records Jiang Wei’s defeat by Deng Ai at Duangu in 256, with heavy casualties among his troops.','Hu Ji failed to arrive as arranged, leaving Jiang Wei’s isolated force checked, and he petitioned to be demoted for it.','A major setback following the Taoxi victory, exposing Shu Han’s dwindling capacity to sustain the campaigns.','256 CE'),
('first-two-huainan-rebellions','zh-CN','淮南前二叛','志载王凌于嘉平三年、毌丘俭与文钦于正元二年相继据淮南举兵反司马氏，皆败。','司马懿讨平王凌，司马师继讨破毌丘俭、文钦于乐嘉，师亦因此疾笃而卒。','魏室宗亲与旧臣两度反抗司马氏专权，皆归失败，权柄益固。','公元251—255年'),
('first-two-huainan-rebellions','en','The First Two Huainan Rebellions','The Records records Wang Ling’s rebellion at Huainan in 251 and Guanqiu Jian and Wen Qin’s in 255, both raised against Sima family control and both crushed.','Sima Yi suppressed Wang Ling, and Sima Shi in turn broke Guanqiu Jian and Wen Qin at Leji, though the campaign left him mortally ill.','Two attempts by Wei loyalists to resist Sima dominance both failed, only entrenching that family’s grip on power.','c. 251–255 CE'),
('zhuge-dan-rebellion-at-shouchun','zh-CN','诸葛诞据寿春叛','志载诸葛诞甘露二年惧祸据寿春反司马昭，次年城破被杀。','司马昭亲统大军围城逾年，城中粮尽，诸葛诞战死，夷其三族。','淮南三叛的最后一次，此后曹魏内部再无有力反抗司马氏之力量。','公元257—258年'),
('zhuge-dan-rebellion-at-shouchun','en','Zhuge Dan’s Rebellion at Shouchun','The Records records Zhuge Dan, fearing for his safety, rebelling at Shouchun against Sima Zhao in 257, with the city falling and Zhuge Dan killed the following year.','Sima Zhao personally led a year-long siege; when supplies within the city ran out, Zhuge Dan died in battle and his clan was exterminated.','The last of the three Huainan rebellions, after which no force within Wei could effectively resist the Sima family.','c. 257–258 CE'),
('sima-zhao-murders-cao-mao','zh-CN','司马昭弑高贵乡公','志载曹髦甘露五年率殿中宿卫讨司马昭，为其党羽成济所弑于南阙。','事后司马昭归罪成济，诛其三族以自解，另立常道乡公曹奂为帝。','魏室皇权彻底沦丧的标志性事件。','公元260年'),
('sima-zhao-murders-cao-mao','en','Sima Zhao Has Cao Mao Killed','The Records records Cao Mao leading the palace guard against Sima Zhao in 260, only to be killed by Cheng Ji, one of Sima Zhao’s retainers, at the southern gate.','Sima Zhao afterward shifted blame onto Cheng Ji, exterminating his clan to absolve himself, and installed Cao Huan, the Duke of Changdaoxiang, as the new emperor.','The event that marks the final collapse of genuine imperial authority under Wei.','260 CE'),
('huang-hao-corrupts-the-shu-court','zh-CN','黄皓乱政','志载后主宠信宦官黄皓，景耀年间朝纲日坏，姜维亦为其所忌。','黄皓排挤姜维出屯沓中，蜀汉内部离心。','蜀汉衰亡的内因之一，与姜维屡战在外的外患相为表里。','公元258—262年'),
('huang-hao-corrupts-the-shu-court','en','Huang Hao Corrupts the Shu Court','The Records records Liu Shan’s favored eunuch Huang Hao steadily undermining court governance through the Jingyao years, with Jiang Wei himself falling under his suspicion.','Huang Hao maneuvered Jiang Wei into a distant garrison at Tazhong, deepening divisions within the Shu Han government.','One of the internal causes of Shu Han’s decline, compounding the external strain of Jiang Wei’s ongoing campaigns.','c. 258–262 CE')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

-- --- Records (志) KK12 ---
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('wei-orders-conquest-of-shu','zh-CN','魏廷决意伐蜀','志载司马昭景元四年遣钟会、邓艾分道伐蜀。','钟会都统关中诸军为主力，邓艾、诸葛绪各率一军自陇西、祁山策应。','蜀汉灭亡之役的正式开端。','公元263年'),
('wei-orders-conquest-of-shu','en','Wei Orders the Conquest of Shu','The Records records Sima Zhao dispatching Zhong Hui and Deng Ai on separate routes to conquer Shu in 263.','Zhong Hui commanded the main force through Guanzhong, while Deng Ai and Zhuge Xu led supporting armies from Longxi and Qishan.','The formal opening of the campaign that ends Shu Han.','263 CE'),
('jiang-wei-withdraws-to-jiange','zh-CN','姜维退保剑阁','志载姜维闻魏军大举而至，自沓中退保剑阁，拒钟会大军。','剑阁天险，钟会久攻不下，一度议退兵。','姜维以险固守，几使钟会伐蜀之役功败垂成。','公元263年'),
('jiang-wei-withdraws-to-jiange','en','Jiang Wei Withdraws to Jiange','The Records records Jiang Wei, on learning of the massive Wei advance, withdrawing from Tazhong to hold Jiange against Zhong Hui’s army.','Jiange’s natural defenses held firm against Zhong Hui’s prolonged assault, to the point that withdrawal was considered.','Jiang Wei’s stand very nearly caused Zhong Hui’s campaign to fail outright.','263 CE'),
('deng-ai-crosses-yinping','zh-CN','邓艾偷渡阴平','志载邓艾自阴平凿山开道七百余里，出剑阁之后，直趋江油。','山高谷深，粮运几绝，士卒裹毡推转而下。','出奇兵绕过姜维正面防线，直接叩开蜀中门户。','公元263年'),
('deng-ai-crosses-yinping','en','Deng Ai Crosses the Yinping Trail','The Records records Deng Ai hacking a path over seven hundred li through the mountains from Yinping, emerging behind Jiange to strike directly at Jiangyou.','The terrain was so steep that supplies nearly failed, and soldiers wrapped themselves in felt to roll down the cliffs.','A daring maneuver that bypassed Jiang Wei’s front line entirely and opened the gateway to the Shu heartland.','263 CE'),
('zhuge-zhan-dies-at-mianzhu','zh-CN','诸葛瞻绵竹殉国','志载诸葛瞻率军拒邓艾于绵竹，兵败与子诸葛尚俱死。','邓艾遣使诱降，诸葛瞻斩使表志，力战而亡。','蜀汉朝廷最后一支有组织抵抗力量的覆灭。','公元263年'),
('zhuge-zhan-dies-at-mianzhu','en','Zhuge Zhan Dies at Mianzhu','The Records records Zhuge Zhan leading his army against Deng Ai at Mianzhu, dying in defeat together with his son Zhuge Shang.','Deng Ai sent an envoy offering surrender terms; Zhuge Zhan beheaded the envoy to declare his resolve and fought to the death.','The destruction of the last organized Shu Han force capable of resistance.','263 CE'),
('liu-shan-surrenders-shu-falls','zh-CN','刘禅出降，蜀汉遂亡','志载邓艾兵临成都，后主刘禅奉玺绶出降，蜀汉灭亡。','刘禅从谯周之议，不待姜维回援即降。','蜀汉自昭烈帝立国四十三年至此终结。','公元263年'),
('liu-shan-surrenders-shu-falls','en','Liu Shan Surrenders and Shu Han Falls','The Records records Deng Ai’s army reaching Chengdu and Liu Shan surrendering the imperial seal, ending Shu Han.','Liu Shan followed Qiao Zhou’s counsel to surrender without waiting for Jiang Wei’s relieving force to arrive.','The end of Shu Han, forty-three years after its founding by Liu Bei.','263 CE'),
('chengdu-mutiny-and-triple-deaths','zh-CN','成都兵变，三人俱死','志载钟会至成都后忌邓艾之功，槛车征还，复与姜维合谋自立，为魏军将士所杀，邓艾亦死于乱中。','姜维密谓后主，欲藉钟会之乱以图复国，事泄，三人皆死于兵变。','灭蜀之役以三位主将俱亡告终，蜀地一时大乱。','公元264年'),
('chengdu-mutiny-and-triple-deaths','en','The Chengdu Mutiny and the Triple Deaths','The Records records Zhong Hui, jealous of Deng Ai’s credit, having him sent back under arrest in a caged cart, then conspiring with Jiang Wei to rebel, only to be killed by mutinous Wei soldiers, with Deng Ai also dying amid the chaos.','Jiang Wei had secretly written to Liu Shan hoping to exploit Zhong Hui’s rebellion to restore Shu, but the plot was discovered and all three men died in the mutiny.','The conquest of Shu closes with the deaths of all three of its principal commanders, plunging the region into brief chaos.','264 CE'),
('liu-shan-professes-contentment-in-luoyang','zh-CN','乐不思蜀','汉晋春秋载刘禅徙居洛阳后，司马昭宴而问之，答曰“此间乐，不思蜀”。','郤正尝教其言以思蜀对答，刘禅复述，司马昭反疑其诈。','后世用以形容安于现状、忘怀故国之典。','约公元265年'),
('liu-shan-professes-contentment-in-luoyang','en','“This Place Is Enjoyable; I Do Not Think of Shu”','The Han Jin Chunqiu records that after Liu Shan was resettled in Luoyang, Sima Zhao asked him at a banquet whether he missed Shu, and he replied that this place was enjoyable and he did not think of Shu.','Xi Zheng had coached him to answer instead that he longed for Shu, and when Liu Shan clumsily repeated the coached line, Sima Zhao only grew more suspicious of deception.','The episode became proverbial for contentment with one’s present circumstances at the cost of forgetting one’s former homeland.','c. 265 CE')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

-- --- Romance (演义) KK11 ---
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('jiang-wei-vows-to-continue-the-chancellors-mission','zh-CN','姜维誓继丞相遗志','小说叙写姜维承诸葛亮临终托付，誓志北伐以图兴复汉室。','姜维每念丞相六出祁山未竟之业，慨然再举义旗。','承接诸葛亮北伐叙事的情感与使命延续。','约公元249年'),
('jiang-wei-vows-to-continue-the-chancellors-mission','en','Jiang Wei Vows to Continue the Chancellor’s Mission','The novel narrates Jiang Wei, heir to Zhuge Liang’s dying charge, vowing to press the northern campaigns in hope of restoring the Han.','Mindful of his mentor’s unfinished expeditions through Qishan, Jiang Wei raises the banner of righteousness once more.','Carries forward the emotional and moral mission of Zhuge Liang’s campaigns into a new generation.','c. 249 CE'),
('jiang-wei-campaigns-into-yongzhou','zh-CN','姜维出师雍州','小说叙写姜维联结羌胡，出兵雍州，与魏将郭淮、陈泰周旋。','兵行诡谲，互有胜负，终因粮尽而还。','展现姜维用兵灵活却难成大功的宿命基调。','约公元250年'),
('jiang-wei-campaigns-into-yongzhou','en','Jiang Wei Campaigns into Yongzhou','The novel narrates Jiang Wei allying with Qiang tribes and marching into Yongzhou, maneuvering against the Wei generals Guo Huai and Chen Tai.','The campaign turns on clever stratagems with fortunes on both sides, ending in withdrawal for lack of supplies.','Establishes the recurring pattern of Jiang Wei’s tactical brilliance never quite yielding decisive success.','c. 250 CE'),
('jiang-wei-victory-at-taoxi','zh-CN','洮西大捷','小说叙写姜维大破魏将王经于洮西，斩首数万，威震陇右。','陈泰、邓艾引兵来救，狄道城下相持不下。','姜维九伐中原中战果最盛的一场大捷。','公元255年'),
('jiang-wei-victory-at-taoxi','en','Great Victory at Taoxi','The novel narrates Jiang Wei crushing the Wei general Wang Jing at Taoxi, taking tens of thousands of heads and shaking all of Longxi.','Chen Tai and Deng Ai bring relief forces, and the two sides settle into a standoff beneath the walls of Didao.','The most resounding triumph among Jiang Wei’s nine campaigns against the Central Plains.','255 CE'),
('jiang-wei-checked-at-duangu','zh-CN','段谷受挫','小说叙写胡济失期不至，邓艾预伏奇兵，姜维大败于段谷。','姜维自请贬爵以谢败绩，效古人罪己之义。','洮西大捷之后的顿挫，为后续北伐蒙上阴影。','公元256年'),
('jiang-wei-checked-at-duangu','en','Checked at Duangu','The novel narrates Hu Ji failing to arrive as arranged while Deng Ai lays an ambush in advance, dealing Jiang Wei a heavy defeat at Duangu.','Jiang Wei asks to be demoted in atonement for the defeat, following the ancient example of self-blame.','A setback following the Taoxi triumph that casts a shadow over the campaigns to come.','256 CE'),
('wang-ling-conspires-against-sima-yi','zh-CN','王凌谋讨司马懿','小说叙写王凌不满司马懿专权，密谋于淮南举兵，事泄兵败自尽。','司马懿亲率大军突至寿春，王凌自知不敌，束手请罪，途中饮鸩而亡。','淮南三叛之首，揭开司马氏与曹魏旧臣长期角力的序幕。','公元251年'),
('wang-ling-conspires-against-sima-yi','en','Wang Ling Conspires Against Sima Yi','The novel narrates Wang Ling, resentful of Sima Yi’s dominance, plotting rebellion at Huainan in secret, only for the plot to be discovered and crushed.','Sima Yi personally leads an army to Shouchun before Wang Ling can act; recognizing he cannot prevail, Wang Ling surrenders and takes poison on the journey back.','The first of the three Huainan rebellions, opening the long contest between the Sima family and Wei’s old loyalists.','251 CE'),
('guanqiu-jian-and-wen-qin-rise-at-shouchun','zh-CN','毌丘俭文钦起兵寿春','小说叙写毌丘俭、文钦声讨司马师废主之罪，起兵淮南。','司马师抱病亲征，诸葛诞助战，文钦败走东吴，毌丘俭死于乱军。','淮南三叛之第二次，司马师因此役伤病加剧而卒。','公元255年'),
('guanqiu-jian-and-wen-qin-rise-at-shouchun','en','Guanqiu Jian and Wen Qin Rise at Shouchun','The novel narrates Guanqiu Jian and Wen Qin denouncing Sima Shi for deposing an emperor and rising in arms at Huainan.','Sima Shi leads the campaign in person despite illness, with Zhuge Dan’s help; Wen Qin flees to Wu while Guanqiu Jian dies amid the fighting.','The second of the three Huainan rebellions, whose toll on Sima Shi’s health contributed to his death soon after.','255 CE'),
('zhuge-dan-rebels-at-shouchun','zh-CN','诸葛诞举兵寿春','小说叙写诸葛诞惧祸，联结东吴，据寿春反司马昭。','司马昭亲统大军围城逾年，城破，诸葛诞死于乱军之中。','淮南三叛之终局，此后魏廷再无力量能制衡司马氏。','公元257—258年'),
('zhuge-dan-rebels-at-shouchun','en','Zhuge Dan Rebels at Shouchun','The novel narrates Zhuge Dan, fearing disaster, allying with Wu and rebelling at Shouchun against Sima Zhao.','Sima Zhao personally besieges the city for over a year; when it falls, Zhuge Dan dies amid the fighting.','The last of the three Huainan rebellions, after which no force remained within Wei to check the Sima family.','c. 257–258 CE'),
('sima-zhao-has-cao-mao-killed','zh-CN','司马昭弑君','小说叙写曹髦不甘为傀儡，拔剑亲讨司马昭，反为成济所弑于云龙门下。','司马昭佯为不知，归罪成济，另立曹奂为帝，“司马昭之心，路人皆知”一语由此传世。','魏室皇权彻底沦为虚名的转折点。','公元260年'),
('sima-zhao-has-cao-mao-killed','en','Sima Zhao Has the Emperor Killed','The novel narrates Cao Mao, refusing to remain a puppet, drawing his own sword against Sima Zhao, only to be cut down by Cheng Ji at the Cloud Dragon Gate.','Sima Zhao feigns ignorance and shifts the blame to Cheng Ji, installing Cao Huan as emperor instead, giving rise to the enduring saying that “Sima Zhao’s intent is known to every passerby.”','The turning point after which Wei’s imperial throne retains nothing but its name.','260 CE'),
('huang-hao-dominates-the-shu-court','zh-CN','黄皓专权蜀廷','小说叙写后主宠信宦官黄皓，谄媚弄权，屡阻姜维之谋。','黄皓与右将军阎宇结交，排挤姜维出屯沓中避祸。','小说借此渲染蜀汉内政之腐败，为亡国之局预先埋笔。','约公元258—262年'),
('huang-hao-dominates-the-shu-court','en','Huang Hao Dominates the Shu Court','The novel narrates Liu Shan’s favored eunuch Huang Hao flattering his way into power and repeatedly frustrating Jiang Wei’s plans.','Huang Hao colludes with the General of the Right, Yan Yu, to press Jiang Wei into a distant garrison at Tazhong to escape danger.','Dramatizes the rot within Shu Han’s government that foreshadows its coming ruin.','c. 258–262 CE')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- --- Romance (演义) KK12 ---
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('wei-court-dispatches-zhong-hui-and-deng-ai','zh-CN','魏廷遣钟会邓艾伐蜀','小说叙写司马昭决意伐蜀，命钟会督十余万众为主力，邓艾、诸葛绪分道策应。','钟会临行进献伐蜀方略，司马昭壮其言而委以重任。','开启灭蜀叙事的宏大战役序幕。','公元263年'),
('wei-court-dispatches-zhong-hui-and-deng-ai','en','The Wei Court Dispatches Zhong Hui and Deng Ai','The novel narrates Sima Zhao resolving to conquer Shu, giving Zhong Hui command of the main force of over a hundred thousand while Deng Ai and Zhuge Xu advance on supporting routes.','Zhong Hui presents his strategy for the conquest before departing, and Sima Zhao, impressed, entrusts him with the campaign.','Opens the grand campaign narrative that will end in Shu’s fall.','263 CE'),
('jiang-wei-outmaneuvers-zhong-hui-at-jiange','zh-CN','姜维剑阁拒钟会','小说叙写姜维回师退保剑阁天险，屡挫钟会攻势。','钟会久攻不克，粮运不继，一度欲退兵北还。','姜维凭险固守，几令魏军伐蜀之谋功亏一篑。','公元263年'),
('jiang-wei-outmaneuvers-zhong-hui-at-jiange','en','Jiang Wei Outmaneuvers Zhong Hui at Jiange','The novel narrates Jiang Wei withdrawing his forces to hold the natural stronghold of Jiange, repeatedly repelling Zhong Hui’s assaults.','Unable to break through and running short of supplies, Zhong Hui at one point considers withdrawing north altogether.','Jiang Wei’s defense very nearly unravels the entire Wei campaign against Shu.','263 CE'),
('deng-ai-crosses-the-yinping-trail','zh-CN','邓艾偷渡阴平','小说叙写邓艾自请奇兵，凿山通道七百余里，出剑阁之后直趋江油。','悬崖峭壁，士卒以毡裹身滚坠而下，邓艾身先士卒。','小说浓墨渲染此役之险绝，为其平生用兵最奇之笔。','公元263年'),
('deng-ai-crosses-the-yinping-trail','en','Deng Ai Crosses the Yinping Trail','The novel narrates Deng Ai volunteering for a daring maneuver, cutting a path over seven hundred li through the mountains to emerge behind Jiange and strike at Jiangyou.','Facing sheer cliffs, his soldiers wrap themselves in felt and roll down the slopes, with Deng Ai himself leading the way.','The novel dwells on this as the most audacious stroke of Deng Ai’s entire career.','263 CE'),
('zhuge-zhan-and-his-son-die-at-mianzhu','zh-CN','诸葛瞻父子死节绵竹','小说叙写诸葛瞻斩邓艾使者，率子诸葛尚力战绵竹，父子俱亡。','临阵自叹内不能除黄皓、外不能制姜维，唯有一死以报国恩。','小说借父子殉国渲染蜀汉忠烈精神的最后余晖。','公元263年'),
('zhuge-zhan-and-his-son-die-at-mianzhu','en','Zhuge Zhan and His Son Die at Mianzhu','The novel narrates Zhuge Zhan beheading Deng Ai’s envoy and fighting to the death at Mianzhu alongside his son Zhuge Shang.','On the field he laments being unable to remove Huang Hao within or restrain Jiang Wei without, resolving that only death can repay the state.','The novel uses this father-and-son sacrifice as the last flare of Shu Han’s spirit of loyalty.','263 CE'),
('liu-shan-opens-the-gates-of-chengdu','zh-CN','后主开城出降','小说叙写邓艾兵临成都，后主从谯周之劝，自缚请降。','北地王刘谌力谏不听，先哭祖庙而后自尽，以身殉国。','蜀汉四十三年基业至此终结，全书悲怆之极笔。','公元263年'),
('liu-shan-opens-the-gates-of-chengdu','en','Liu Shan Opens the Gates of Chengdu','The novel narrates Deng Ai’s army reaching Chengdu, with Liu Shan heeding Qiao Zhou’s counsel and binding himself to beg surrender.','Prince Liu Chen of Beidi argues fiercely against surrender in vain, then weeps before the ancestral shrine and takes his own life rather than submit.','The end of forty-three years of Shu Han, rendered as one of the novel’s most tragic passages.','263 CE'),
('zhong-hui-frames-deng-ai-for-treason','zh-CN','钟会构陷邓艾','小说叙写钟会妒邓艾灭蜀首功，密奏其专擅有反状，槛车征还。','卫瓘奉命收艾，邓艾父子被执，钟会遂独揽蜀中兵权。','灭蜀功臣自相构陷，埋下成都兵变的祸根。','公元263—264年'),
('zhong-hui-frames-deng-ai-for-treason','en','Zhong Hui Frames Deng Ai for Treason','The novel narrates Zhong Hui, envious of Deng Ai’s leading credit for conquering Shu, secretly reporting him for overreach bordering on rebellion and having him hauled back in a caged cart.','Wei Guan carries out the arrest, taking Deng Ai and his son into custody, leaving Zhong Hui in sole command of the forces in Shu.','The conquerors of Shu turn on one another, planting the seed of the mutiny to come at Chengdu.','c. 263–264 CE'),
('jiang-wei-feigns-surrender-to-zhong-hui','zh-CN','姜维诈降钟会','小说叙写姜维见钟会有异志，佯为归附，密劝其举兵自立以图复蜀。','姜维密书后主，称欲使社稷危而复安，日月幽而复明。','姜维绝境中最后的复国之谋，悲壮而终归徒劳。','公元264年'),
('jiang-wei-feigns-surrender-to-zhong-hui','en','Jiang Wei Feigns Surrender to Zhong Hui','The novel narrates Jiang Wei, sensing Zhong Hui’s own ambitions, pretending to submit to him while secretly urging him toward rebellion in hope of restoring Shu.','Jiang Wei writes secretly to Liu Shan, vowing that the endangered altars of state would yet stand again and the darkened sun and moon shine once more.','Jiang Wei’s last, desperate scheme for restoration, as poignant as it is ultimately futile.','264 CE'),
('zhong-hui-rebels-in-the-chengdu-mutiny','zh-CN','钟会成都兵变','小说叙写钟会据成都自立，欲尽杀魏将，事泄，为乱兵所杀。','魏军诸将不服，突入内城，钟会、姜维死于乱兵之中。','灭蜀之役以主帅自身叛乱、身死当场收场，极具反讽意味。','公元264年'),
('zhong-hui-rebels-in-the-chengdu-mutiny','en','Zhong Hui Rebels in the Chengdu Mutiny','The novel narrates Zhong Hui declaring independence at Chengdu and plotting to kill the Wei officers there, only for the plot to be discovered and for mutinous troops to kill him.','The Wei officers refuse to submit, storming the inner citadel, and both Zhong Hui and Jiang Wei die amid the chaos.','The conquest of Shu closes with a bitterly ironic reversal, its own commander rebelling and dying on the spot.','264 CE'),
('deng-ai-zhong-hui-and-jiang-wei-all-perish','zh-CN','邓艾钟会姜维俱亡','小说叙写成都乱军之中，姜维、钟会先后死难，被囚之邓艾亦为仇家所杀。','三位灭蜀主帅先后殒命，蜀地一时大乱，全书至此叹惋不已。','以三雄俱亡的悲剧收束灭蜀一役，凸显乱世功名之虚幻。','公元264年'),
('deng-ai-zhong-hui-and-jiang-wei-all-perish','en','Deng Ai, Zhong Hui, and Jiang Wei All Perish','The novel narrates Jiang Wei and Zhong Hui both dying in the Chengdu mutiny, while the imprisoned Deng Ai is also killed by old enemies amid the chaos.','All three commanders who conquered Shu meet their deaths in quick succession, plunging the region into brief turmoil that the novel mourns at length.','Closes the conquest of Shu on the tragedy of three great figures perishing together, underscoring the hollowness of glory in a divided age.','264 CE'),
('liu-shan-says-he-does-not-miss-shu','zh-CN','乐不思蜀','小说叙写刘禅徙居洛阳，司马昭宴而问之，答曰“此间乐，不思蜀”，传为千古笑谈。','郤正教其以思蜀之语相答，刘禅复述时神情茫然，反被司马昭识破。','全书以此讽写亡国之君的浑噩，为蜀汉一线作结。','约公元265年'),
('liu-shan-says-he-does-not-miss-shu','en','“I Do Not Think of Shu”','The novel narrates Liu Shan, resettled in Luoyang, replying at a banquet hosted by Sima Zhao that this place was enjoyable and he did not think of Shu—a line that became a byword across the ages.','Xi Zheng had coached him to instead claim he longed for Shu, but when Liu Shan parroted the line with a blank expression, Sima Zhao saw through the deception at once.','The novel closes Shu Han’s thread with this satirical portrait of a fallen ruler’s obliviousness.','c. 265 CE')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 6. EVENT-LOCATIONS
-- ============================================================

INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('jiang-wei-resumes-northern-campaigns','hanzhong'),
('jiang-wei-victory-at-taoxi','hanzhong'),
('jiang-wei-defeated-at-duangu','hanzhong'),
('first-two-huainan-rebellions','shouchun'),
('zhuge-dan-rebellion-at-shouchun','shouchun'),
('sima-zhao-murders-cao-mao','luoyang'),
('huang-hao-corrupts-the-shu-court','chengdu'),
('wei-orders-conquest-of-shu','luoyang'),
('jiang-wei-withdraws-to-jiange','jiange'),
('deng-ai-crosses-yinping','yinping-trail'),
('zhuge-zhan-dies-at-mianzhu','mianzhu'),
('liu-shan-surrenders-shu-falls','chengdu'),
('chengdu-mutiny-and-triple-deaths','chengdu'),
('liu-shan-professes-contentment-in-luoyang','luoyang')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('jiang-wei-vows-to-continue-the-chancellors-mission','hanzhong'),
('jiang-wei-campaigns-into-yongzhou','hanzhong'),
('jiang-wei-victory-at-taoxi','hanzhong'),
('jiang-wei-checked-at-duangu','hanzhong'),
('wang-ling-conspires-against-sima-yi','shouchun'),
('guanqiu-jian-and-wen-qin-rise-at-shouchun','shouchun'),
('zhuge-dan-rebels-at-shouchun','shouchun'),
('sima-zhao-has-cao-mao-killed','luoyang'),
('huang-hao-dominates-the-shu-court','chengdu'),
('wei-court-dispatches-zhong-hui-and-deng-ai','luoyang'),
('jiang-wei-outmaneuvers-zhong-hui-at-jiange','jiange'),
('deng-ai-crosses-the-yinping-trail','yinping-trail'),
('zhuge-zhan-and-his-son-die-at-mianzhu','mianzhu'),
('liu-shan-opens-the-gates-of-chengdu','chengdu'),
('zhong-hui-frames-deng-ai-for-treason','chengdu'),
('jiang-wei-feigns-surrender-to-zhong-hui','chengdu'),
('zhong-hui-rebels-in-the-chengdu-mutiny','chengdu'),
('deng-ai-zhong-hui-and-jiang-wei-all-perish','chengdu'),
('liu-shan-says-he-does-not-miss-shu','luoyang')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 7. EVENT-CHARACTERS
-- ============================================================

INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('jiang-wei-resumes-northern-campaigns','jiang-wei',0),('jiang-wei-resumes-northern-campaigns','liu-shan',1),
('jiang-wei-victory-at-taoxi','jiang-wei',0),
('jiang-wei-defeated-at-duangu','jiang-wei',0),('jiang-wei-defeated-at-duangu','deng-ai',1),
('first-two-huainan-rebellions','sima-shi',0),('first-two-huainan-rebellions','sima-yi',1),('first-two-huainan-rebellions','zhuge-dan',2),
('zhuge-dan-rebellion-at-shouchun','zhuge-dan',0),('zhuge-dan-rebellion-at-shouchun','sima-zhao',1),('zhuge-dan-rebellion-at-shouchun','zhong-hui',2),
('sima-zhao-murders-cao-mao','cao-mao',0),('sima-zhao-murders-cao-mao','sima-zhao',1),
('huang-hao-corrupts-the-shu-court','huang-hao',0),('huang-hao-corrupts-the-shu-court','liu-shan',1),('huang-hao-corrupts-the-shu-court','jiang-wei',2),
('wei-orders-conquest-of-shu','sima-zhao',0),('wei-orders-conquest-of-shu','zhong-hui',1),('wei-orders-conquest-of-shu','deng-ai',2),
('jiang-wei-withdraws-to-jiange','jiang-wei',0),('jiang-wei-withdraws-to-jiange','zhong-hui',1),
('deng-ai-crosses-yinping','deng-ai',0),
('zhuge-zhan-dies-at-mianzhu','zhuge-zhan',0),('zhuge-zhan-dies-at-mianzhu','deng-ai',1),
('liu-shan-surrenders-shu-falls','liu-shan',0),('liu-shan-surrenders-shu-falls','deng-ai',1),
('chengdu-mutiny-and-triple-deaths','zhong-hui',0),('chengdu-mutiny-and-triple-deaths','jiang-wei',1),('chengdu-mutiny-and-triple-deaths','deng-ai',2),
('liu-shan-professes-contentment-in-luoyang','liu-shan',0),('liu-shan-professes-contentment-in-luoyang','sima-zhao',1)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('jiang-wei-vows-to-continue-the-chancellors-mission','jiang-wei',0),
('jiang-wei-campaigns-into-yongzhou','jiang-wei',0),
('jiang-wei-victory-at-taoxi','jiang-wei',0),('jiang-wei-victory-at-taoxi','deng-ai',1),
('jiang-wei-checked-at-duangu','jiang-wei',0),('jiang-wei-checked-at-duangu','deng-ai',1),
('wang-ling-conspires-against-sima-yi','sima-yi',0),
('guanqiu-jian-and-wen-qin-rise-at-shouchun','sima-shi',0),('guanqiu-jian-and-wen-qin-rise-at-shouchun','zhuge-dan',1),
('zhuge-dan-rebels-at-shouchun','zhuge-dan',0),('zhuge-dan-rebels-at-shouchun','sima-zhao',1),
('sima-zhao-has-cao-mao-killed','cao-mao',0),('sima-zhao-has-cao-mao-killed','sima-zhao',1),
('huang-hao-dominates-the-shu-court','huang-hao',0),('huang-hao-dominates-the-shu-court','liu-shan',1),('huang-hao-dominates-the-shu-court','jiang-wei',2),
('wei-court-dispatches-zhong-hui-and-deng-ai','sima-zhao',0),('wei-court-dispatches-zhong-hui-and-deng-ai','zhong-hui',1),('wei-court-dispatches-zhong-hui-and-deng-ai','deng-ai',2),
('jiang-wei-outmaneuvers-zhong-hui-at-jiange','jiang-wei',0),('jiang-wei-outmaneuvers-zhong-hui-at-jiange','zhong-hui',1),
('deng-ai-crosses-the-yinping-trail','deng-ai',0),
('zhuge-zhan-and-his-son-die-at-mianzhu','zhuge-zhan',0),('zhuge-zhan-and-his-son-die-at-mianzhu','deng-ai',1),
('liu-shan-opens-the-gates-of-chengdu','liu-shan',0),('liu-shan-opens-the-gates-of-chengdu','deng-ai',1),
('zhong-hui-frames-deng-ai-for-treason','zhong-hui',0),('zhong-hui-frames-deng-ai-for-treason','deng-ai',1),
('jiang-wei-feigns-surrender-to-zhong-hui','jiang-wei',0),('jiang-wei-feigns-surrender-to-zhong-hui','zhong-hui',1),
('zhong-hui-rebels-in-the-chengdu-mutiny','zhong-hui',0),('zhong-hui-rebels-in-the-chengdu-mutiny','jiang-wei',1),
('deng-ai-zhong-hui-and-jiang-wei-all-perish','jiang-wei',0),('deng-ai-zhong-hui-and-jiang-wei-all-perish','zhong-hui',1),('deng-ai-zhong-hui-and-jiang-wei-all-perish','deng-ai',2),
('liu-shan-says-he-does-not-miss-shu','liu-shan',0),('liu-shan-says-he-does-not-miss-shu','sima-zhao',1)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 8. EVENT-SOURCES
-- ============================================================

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Records of the Three Kingdoms'
WHERE e.work_id='10000000-0000-4000-8000-000000000006' AND (e.id::text LIKE '64000000-0000-4000-8011%' OR e.id::text LIKE '64000000-0000-4000-8012%')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Romance of the Three Kingdoms (Mao edition)'
WHERE e.work_id='10000000-0000-4000-8000-000000000007' AND (e.id::text LIKE '65000000-0000-4000-8011%' OR e.id::text LIKE '65000000-0000-4000-8012%')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 9. CHARACTER RELATIONS (+ relation_translations, required both locales)
-- ============================================================

-- --- Records (志) ---
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('74000000-0000-4000-8011-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'jiang-wei','zhong-hui','other','bidirectional','mixed',4,'changed','jiang-wei-withdraws-to-jiange','chengdu-mutiny-and-triple-deaths'),
(2,'deng-ai','zhong-hui','adversary','bidirectional','negative',4,'ended',NULL,'chengdu-mutiny-and-triple-deaths'),
(3,'sima-zhao','cao-mao','adversary','source_to_target','negative',5,'ended',NULL,'sima-zhao-murders-cao-mao'),
(4,'sima-yi','sima-zhao','family','source_to_target','positive',3,'unknown',NULL,NULL),
(5,'sima-yi','sima-shi','family','source_to_target','positive',3,'unknown',NULL,NULL),
(6,'sima-shi','sima-zhao','sibling','bidirectional','positive',3,'changed',NULL,'first-two-huainan-rebellions'),
(7,'zhuge-liang','zhuge-zhan','family','source_to_target','positive',4,'unknown',NULL,NULL),
(8,'liu-shan','huang-hao','ally','source_to_target','mixed',3,'active',NULL,NULL),
(9,'zhuge-dan','sima-zhao','adversary','source_to_target','negative',4,'ended',NULL,'zhuge-dan-rebellion-at-shouchun'),
(10,'jiang-wei','deng-ai','adversary','bidirectional','negative',4,'ended',NULL,'liu-shan-surrenders-shu-falls'),
(11,'jiang-wei','liu-shan','ally','source_to_target','mixed',4,'ended',NULL,'liu-shan-surrenders-shu-falls')
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000006'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000006'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000006'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

INSERT INTO relation_translations(relation_id,locale,label,summary,status)
SELECT r.id,v.locale::locale_code,v.label,v.summary,'published'
FROM character_relations r JOIN (VALUES
('jiang-wei','zhong-hui','other','zh-CN','姜维与钟会（伐蜀对手至诈降同谋）','二人本为伐蜀战场上的敌手，蜀亡后姜维诈降钟会，欲借其谋乱复国，终同死于成都兵变。'),
('jiang-wei','zhong-hui','other','en','Jiang Wei and Zhong Hui (wartime foes turned entangled co-conspirators)','Battlefield adversaries during the conquest of Shu, the two became entangled after Jiang Wei feigned surrender to plot Shu’s restoration through Zhong Hui, and both died together in the Chengdu mutiny.'),
('deng-ai','zhong-hui','adversary','zh-CN','邓艾与钟会（争功构陷之敌）','二将分道灭蜀，钟会妒邓艾之功，构陷谋反，致邓艾被杀，自身旋亦死于兵变。'),
('deng-ai','zhong-hui','adversary','en','Deng Ai and Zhong Hui (rivals undone by rivalry over credit)','The two generals conquered Shu by separate routes; Zhong Hui, envious of Deng Ai’s credit, framed him for treason, leading to Deng Ai’s death and Zhong Hui’s own death in the mutiny that followed.'),
('sima-zhao','cao-mao','adversary','zh-CN','司马昭与曹髦（权臣与傀儡之君）','曹髦不甘傀儡之位，起兵讨司马昭，反为其党羽所弑，魏室名存实亡。'),
('sima-zhao','cao-mao','adversary','en','Sima Zhao and Cao Mao (overmighty minister and puppet emperor)','Cao Mao refused to remain a puppet and moved against Sima Zhao, only to be killed by Sima Zhao’s own retainers, leaving Wei’s throne hollow in all but name.'),
('sima-yi','sima-zhao','family','zh-CN','司马懿与司马昭（父子）','司马昭为司马懿次子，承父兄之业，终奠晋室基业。'),
('sima-yi','sima-zhao','family','en','Sima Yi and Sima Zhao (father and son)','Sima Zhao, Sima Yi’s second son, inherited his father’s and brother’s power, laying the final groundwork for the house of Jin.'),
('sima-yi','sima-shi','family','zh-CN','司马懿与司马师（父子）','司马师为司马懿长子，父殁后独揽魏廷军政大权。'),
('sima-yi','sima-shi','family','en','Sima Yi and Sima Shi (father and son)','Sima Shi, Sima Yi’s eldest son, took sole command of Wei’s court and armies after his father’s death.'),
('sima-shi','sima-zhao','sibling','zh-CN','司马师与司马昭（兄弟，权柄相继）','司马师讨破毌丘俭后病重而卒，权柄遂归其弟司马昭。'),
('sima-shi','sima-zhao','sibling','en','Sima Shi and Sima Zhao (brothers in successive command)','Sima Shi died of illness shortly after crushing Guanqiu Jian’s revolt, passing control of the Wei court to his brother Sima Zhao.'),
('zhuge-liang','zhuge-zhan','family','zh-CN','诸葛亮与诸葛瞻（父子）','诸葛瞻为诸葛亮之子，绵竹殉国，延续其父鞠躬尽瘁之志。'),
('zhuge-liang','zhuge-zhan','family','en','Zhuge Liang and Zhuge Zhan (father and son)','Zhuge Zhan, Zhuge Liang’s son, died defending Mianzhu, carrying forward his father’s devotion to Shu Han unto death.'),
('liu-shan','huang-hao','ally','zh-CN','刘禅与黄皓（后主与佞幸宦官）','后主宠信黄皓，使其干预朝政，终至朝纲不振。'),
('liu-shan','huang-hao','ally','en','Liu Shan and Huang Hao (the Later Ruler and his favored eunuch)','Liu Shan’s favor let Huang Hao meddle in state affairs, contributing to the court’s decline.'),
('zhuge-dan','sima-zhao','adversary','zh-CN','诸葛诞与司马昭（淮南举兵之敌）','诸葛诞惧见疑于司马昭，据寿春举兵反，城破被杀。'),
('zhuge-dan','sima-zhao','adversary','en','Zhuge Dan and Sima Zhao (foes in the Huainan uprising)','Fearing Sima Zhao’s suspicion, Zhuge Dan raised rebellion at Shouchun, and was killed when the city fell.'),
('jiang-wei','deng-ai','adversary','zh-CN','姜维与邓艾（北伐与灭蜀的对手）','二人于洮西、段谷屡次交锋，终因邓艾偷渡阴平而致蜀汉灭亡。'),
('jiang-wei','deng-ai','adversary','en','Jiang Wei and Deng Ai (rivals across the campaigns and the fall of Shu)','The two clashed repeatedly at Taoxi and Duangu, and Deng Ai’s covert crossing of the Yinping trail finally brought about Shu Han’s fall.'),
('jiang-wei','liu-shan','ally','zh-CN','姜维与刘禅（蜀汉大将军与后主）','姜维屡次北伐以图兴复，然后主信用黄皓，终未能挽蜀汉之亡。'),
('jiang-wei','liu-shan','ally','en','Jiang Wei and Liu Shan (Shu Han’s Grand General and the Later Ruler)','Jiang Wei campaigned repeatedly north hoping to restore Han, but Liu Shan’s trust in Huang Hao meant Shu Han’s fall could not be averted.')
) AS v(fslug,tslug,rtype,locale,label,summary)
  ON r.relation_type=v.rtype
 JOIN characters fc ON fc.id=r.from_character_id AND fc.slug=v.fslug
 JOIN characters tc ON tc.id=r.to_character_id AND tc.slug=v.tslug
WHERE r.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

-- --- Romance (演义) ---
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('75000000-0000-4000-8011-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'jiang-wei','zhong-hui','other','bidirectional','mixed',4,'changed','jiang-wei-outmaneuvers-zhong-hui-at-jiange','deng-ai-zhong-hui-and-jiang-wei-all-perish'),
(2,'deng-ai','zhong-hui','adversary','bidirectional','negative',4,'ended',NULL,'deng-ai-zhong-hui-and-jiang-wei-all-perish'),
(3,'sima-zhao','cao-mao','adversary','source_to_target','negative',5,'ended',NULL,'sima-zhao-has-cao-mao-killed'),
(4,'sima-yi','sima-zhao','family','source_to_target','positive',3,'unknown',NULL,NULL),
(5,'sima-yi','sima-shi','family','source_to_target','positive',3,'unknown',NULL,NULL),
(6,'sima-shi','sima-zhao','sibling','bidirectional','positive',3,'changed',NULL,'guanqiu-jian-and-wen-qin-rise-at-shouchun'),
(7,'zhuge-liang','zhuge-zhan','family','source_to_target','positive',4,'unknown',NULL,NULL),
(8,'liu-shan','huang-hao','ally','source_to_target','mixed',3,'active',NULL,NULL),
(9,'zhuge-dan','sima-zhao','adversary','source_to_target','negative',4,'ended',NULL,'zhuge-dan-rebels-at-shouchun'),
(10,'jiang-wei','deng-ai','adversary','bidirectional','negative',4,'ended',NULL,'liu-shan-opens-the-gates-of-chengdu'),
(11,'jiang-wei','liu-shan','ally','source_to_target','mixed',4,'ended',NULL,'liu-shan-opens-the-gates-of-chengdu')
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000007'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000007'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000007'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

INSERT INTO relation_translations(relation_id,locale,label,summary,status)
SELECT r.id,v.locale::locale_code,v.label,v.summary,'published'
FROM character_relations r JOIN (VALUES
('jiang-wei','zhong-hui','other','zh-CN','姜维与钟会（伐蜀对手至诈降同谋）','二人本为伐蜀战场上的敌手，蜀亡后姜维诈降钟会，欲借其谋乱复国，终同死于成都兵变。'),
('jiang-wei','zhong-hui','other','en','Jiang Wei and Zhong Hui (wartime foes turned entangled co-conspirators)','Battlefield adversaries during the conquest of Shu, the two became entangled after Jiang Wei feigned surrender to plot Shu’s restoration through Zhong Hui, and both died together in the Chengdu mutiny.'),
('deng-ai','zhong-hui','adversary','zh-CN','邓艾与钟会（争功构陷之敌）','二将分道灭蜀，钟会妒邓艾之功，构陷谋反，致邓艾被杀，自身旋亦死于兵变。'),
('deng-ai','zhong-hui','adversary','en','Deng Ai and Zhong Hui (rivals undone by rivalry over credit)','The two generals conquered Shu by separate routes; Zhong Hui, envious of Deng Ai’s credit, framed him for treason, leading to Deng Ai’s death and Zhong Hui’s own death in the mutiny that followed.'),
('sima-zhao','cao-mao','adversary','zh-CN','司马昭与曹髦（权臣与傀儡之君）','曹髦不甘傀儡之位，起兵讨司马昭，反为其党羽所弑，魏室名存实亡。'),
('sima-zhao','cao-mao','adversary','en','Sima Zhao and Cao Mao (overmighty minister and puppet emperor)','Cao Mao refused to remain a puppet and moved against Sima Zhao, only to be killed by Sima Zhao’s own retainers, leaving Wei’s throne hollow in all but name.'),
('sima-yi','sima-zhao','family','zh-CN','司马懿与司马昭（父子）','司马昭为司马懿次子，承父兄之业，终奠晋室基业。'),
('sima-yi','sima-zhao','family','en','Sima Yi and Sima Zhao (father and son)','Sima Zhao, Sima Yi’s second son, inherited his father’s and brother’s power, laying the final groundwork for the house of Jin.'),
('sima-yi','sima-shi','family','zh-CN','司马懿与司马师（父子）','司马师为司马懿长子，父殁后独揽魏廷军政大权。'),
('sima-yi','sima-shi','family','en','Sima Yi and Sima Shi (father and son)','Sima Shi, Sima Yi’s eldest son, took sole command of Wei’s court and armies after his father’s death.'),
('sima-shi','sima-zhao','sibling','zh-CN','司马师与司马昭（兄弟，权柄相继）','司马师讨破毌丘俭后病重而卒，权柄遂归其弟司马昭。'),
('sima-shi','sima-zhao','sibling','en','Sima Shi and Sima Zhao (brothers in successive command)','Sima Shi died of illness shortly after crushing Guanqiu Jian’s revolt, passing control of the Wei court to his brother Sima Zhao.'),
('zhuge-liang','zhuge-zhan','family','zh-CN','诸葛亮与诸葛瞻（父子）','诸葛瞻为诸葛亮之子，绵竹殉国，延续其父鞠躬尽瘁之志。'),
('zhuge-liang','zhuge-zhan','family','en','Zhuge Liang and Zhuge Zhan (father and son)','Zhuge Zhan, Zhuge Liang’s son, died defending Mianzhu, carrying forward his father’s devotion to Shu Han unto death.'),
('liu-shan','huang-hao','ally','zh-CN','刘禅与黄皓（后主与佞幸宦官）','后主宠信黄皓，使其干预朝政，终至朝纲不振。'),
('liu-shan','huang-hao','ally','en','Liu Shan and Huang Hao (the Later Ruler and his favored eunuch)','Liu Shan’s favor let Huang Hao meddle in state affairs, contributing to the court’s decline.'),
('zhuge-dan','sima-zhao','adversary','zh-CN','诸葛诞与司马昭（淮南举兵之敌）','诸葛诞惧见疑于司马昭，据寿春举兵反，城破被杀。'),
('zhuge-dan','sima-zhao','adversary','en','Zhuge Dan and Sima Zhao (foes in the Huainan uprising)','Fearing Sima Zhao’s suspicion, Zhuge Dan raised rebellion at Shouchun, and was killed when the city fell.'),
('jiang-wei','deng-ai','adversary','zh-CN','姜维与邓艾（北伐与灭蜀的对手）','二人于洮西、段谷屡次交锋，终因邓艾偷渡阴平而致蜀汉灭亡。'),
('jiang-wei','deng-ai','adversary','en','Jiang Wei and Deng Ai (rivals across the campaigns and the fall of Shu)','The two clashed repeatedly at Taoxi and Duangu, and Deng Ai’s covert crossing of the Yinping trail finally brought about Shu Han’s fall.'),
('jiang-wei','liu-shan','ally','zh-CN','姜维与刘禅（蜀汉大将军与后主）','姜维屡次北伐以图兴复，然后主信用黄皓，终未能挽蜀汉之亡。'),
('jiang-wei','liu-shan','ally','en','Jiang Wei and Liu Shan (Shu Han’s Grand General and the Later Ruler)','Jiang Wei campaigned repeatedly north hoping to restore Han, but Liu Shan’s trust in Huang Hao meant Shu Han’s fall could not be averted.')
) AS v(fslug,tslug,rtype,locale,label,summary)
  ON r.relation_type=v.rtype
 JOIN characters fc ON fc.id=r.from_character_id AND fc.slug=v.fslug
 JOIN characters tc ON tc.id=r.to_character_id AND tc.slug=v.tslug
WHERE r.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 10. GROUP MEMBERSHIP (existing groups from 031: house-of-sima,
--     wei-strategists, house-of-cao, house-of-liu, shu-chancellery,
--     shu-generals)
-- ============================================================

INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g
JOIN characters c ON c.work_id=g.work_id
JOIN (VALUES
('house-of-sima','sima-zhao'),
('house-of-sima','sima-shi'),
('wei-strategists','sima-zhao'),
('wei-strategists','sima-shi'),
('wei-strategists','zhuge-dan'),
('house-of-cao','cao-mao'),
('house-of-liu','huang-hao'),
('shu-chancellery','zhuge-zhan'),
('shu-generals','zhuge-zhan')
) AS v(gslug,cslug) ON g.slug=v.gslug AND c.slug=v.cslug
WHERE g.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

COMMIT;
