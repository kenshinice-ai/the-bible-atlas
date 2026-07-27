BEGIN;

-- Three Kingdoms era seed, KK=03 (warlords-contending, 192-199) and KK=04
-- (guandu-and-the-north, 200-207), both works (Records 志 = work ...0006,
-- Romance 演义 = work ...0007). Per blueprint/WORK_TEMPLATE.md and
-- blueprint/EXAMPLE_THREE_KINGDOMS.md; skeleton (031) and shared cast/gazetteer
-- (032) already loaded. This file is new-only: no existing seed is modified.
--
-- UUID namespace used here (era-specific, per this task's brief):
--   characters   4{6|7}000000-0000-4000-80KK-000000000NN  (KK=03/04, NN=01-06)
--   locations    3{6|7}000000-0000-4000-80KK-000000000NN  (KK=04 only, NN=01-03)
--   events       6{4|5}000000-0000-4000-80KK-000000000NN  (KK=03 NN=01-08/01-11,
--                                                            KK=04 NN=01-08/01-11)
--   relations    7{4|5}000000-0000-4000-80KK-000000000NN  (KK=03 NN=01-13,
--                                                            KK=04 NN=01-12)
-- Works: Records = 10000000-0000-4000-8000-000000000006
--        Romance = 10000000-0000-4000-8000-000000000007
-- Chapters (already loaded by 031): warlords-contending (seq 3), guandu-and-the-north (seq 4)

-- ============================================================
-- 1. CHARACTERS (era-specific secondary cast, <=6 per work per era)
--    KK=03: Guo Jia, Xun Yu, Zhang Liao, Xiahou Dun, Dian Wei, Tao Qian
--    KK=04: Xu You, Zhang He, Ju Shou, Shen Pei, Guo Tu, Liu Biao
-- ============================================================

INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
-- Records (志) — KK=03
('46000000-0000-4000-8003-000000000001','10000000-0000-4000-8000-000000000006','guo-jia',300,'male','adult','supporting','historical',170,207,'teacher',3),
('46000000-0000-4000-8003-000000000002','10000000-0000-4000-8000-000000000006','xun-yu',301,'male','adult','supporting','historical',163,212,'teacher',3),
('46000000-0000-4000-8003-000000000003','10000000-0000-4000-8000-000000000006','zhang-liao',302,'male','adult','supporting','historical',169,222,'soldier',2),
('46000000-0000-4000-8003-000000000004','10000000-0000-4000-8000-000000000006','xiahou-dun',303,'male','adult','supporting','historical',NULL,220,'soldier',2),
('46000000-0000-4000-8003-000000000005','10000000-0000-4000-8000-000000000006','dian-wei',304,'male','adult','supporting','historical',NULL,197,'soldier',2),
('46000000-0000-4000-8003-000000000006','10000000-0000-4000-8000-000000000006','tao-qian',305,'male','adult','supporting','historical',132,194,'ruler',2),
-- Records (志) — KK=04
('46000000-0000-4000-8004-000000000001','10000000-0000-4000-8000-000000000006','xu-you',400,'male','adult','supporting','historical',NULL,204,'teacher',2),
('46000000-0000-4000-8004-000000000002','10000000-0000-4000-8000-000000000006','zhang-he',401,'male','adult','supporting','historical',NULL,231,'soldier',2),
('46000000-0000-4000-8004-000000000003','10000000-0000-4000-8000-000000000006','ju-shou',402,'male','adult','supporting','historical',NULL,200,'teacher',2),
('46000000-0000-4000-8004-000000000004','10000000-0000-4000-8000-000000000006','shen-pei',403,'male','adult','supporting','historical',NULL,204,'teacher',2),
('46000000-0000-4000-8004-000000000005','10000000-0000-4000-8000-000000000006','guo-tu',404,'male','adult','supporting','historical',NULL,205,'teacher',2),
('46000000-0000-4000-8004-000000000006','10000000-0000-4000-8000-000000000006','liu-biao',405,'male','adult','supporting','historical',142,208,'ruler',2),
-- Romance (演义) — KK=03
('47000000-0000-4000-8003-000000000001','10000000-0000-4000-8000-000000000007','guo-jia',300,'male','adult','supporting','fictionalised_historical',170,207,'teacher',3),
('47000000-0000-4000-8003-000000000002','10000000-0000-4000-8000-000000000007','xun-yu',301,'male','adult','supporting','fictionalised_historical',163,212,'teacher',3),
('47000000-0000-4000-8003-000000000003','10000000-0000-4000-8000-000000000007','zhang-liao',302,'male','adult','supporting','fictionalised_historical',169,222,'soldier',2),
('47000000-0000-4000-8003-000000000004','10000000-0000-4000-8000-000000000007','xiahou-dun',303,'male','adult','supporting','fictionalised_historical',NULL,220,'soldier',2),
('47000000-0000-4000-8003-000000000005','10000000-0000-4000-8000-000000000007','dian-wei',304,'male','adult','supporting','fictionalised_historical',NULL,197,'soldier',2),
('47000000-0000-4000-8003-000000000006','10000000-0000-4000-8000-000000000007','tao-qian',305,'male','adult','supporting','fictionalised_historical',132,194,'ruler',2),
-- Romance (演义) — KK=04
('47000000-0000-4000-8004-000000000001','10000000-0000-4000-8000-000000000007','xu-you',400,'male','adult','supporting','fictionalised_historical',NULL,204,'teacher',2),
('47000000-0000-4000-8004-000000000002','10000000-0000-4000-8000-000000000007','zhang-he',401,'male','adult','supporting','fictionalised_historical',NULL,231,'soldier',2),
('47000000-0000-4000-8004-000000000003','10000000-0000-4000-8000-000000000007','ju-shou',402,'male','adult','supporting','fictionalised_historical',NULL,200,'teacher',2),
('47000000-0000-4000-8004-000000000004','10000000-0000-4000-8000-000000000007','shen-pei',403,'male','adult','supporting','fictionalised_historical',NULL,204,'teacher',2),
('47000000-0000-4000-8004-000000000005','10000000-0000-4000-8000-000000000007','guo-tu',404,'male','adult','supporting','fictionalised_historical',NULL,205,'teacher',2),
('47000000-0000-4000-8004-000000000006','10000000-0000-4000-8000-000000000007','liu-biao',405,'male','adult','supporting','fictionalised_historical',142,208,'ruler',2)
ON CONFLICT DO NOTHING;

-- Records (志) — 志载/传称 voice.
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,'','' FROM characters c JOIN (VALUES
('guo-jia','zh-CN','郭嘉',ARRAY['奉孝']::text[],'颍川阳翟人，曹操军师祭酒，屡进奇策，建安十二年从征乌桓，染疾道卒，年三十八。'),
('guo-jia','en','Guo Jia',ARRAY['Fengxiao']::text[],'A native of Yangdi in Yingchuan who served as Cao Cao’s Chief Retainer of Military Affairs, offering repeated strategic counsel, and died of illness at thirty-eight during the 207 campaign against the Wuhuan.'),
('xun-yu','zh-CN','荀彧',ARRAY['文若']::text[],'颍川颍阴人，曹操侍中、守尚书令，建安元年劝操迎献帝都许，居中持重十余年。'),
('xun-yu','en','Xun Yu',ARRAY['Wenruo']::text[],'A native of Yinyin in Yingchuan who served Cao Cao as Palace Attendant and Acting Imperial Secretary, urging him in 196 to receive Emperor Xian at Xu and steering the court’s affairs for over a decade.'),
('zhang-liao','zh-CN','张辽',ARRAY['文远']::text[],'雁门马邑人，先事吕布，布败降操，为魏名将，后镇合肥有威名。'),
('zhang-liao','en','Zhang Liao',ARRAY['Wenyuan']::text[],'A native of Mayi in Yanmen who served Lü Bu before surrendering to Cao Cao after Xiapi’s fall, becoming one of Wei’s celebrated generals, later renowned for holding Hefei.'),
('xiahou-dun','zh-CN','夏侯惇',ARRAY['元让']::text[],'沛国谯人，曹操从弟，从征多年，尝为流矢伤目，时人称"盲夏侯"。'),
('xiahou-dun','en','Xiahou Dun',ARRAY['Yuanrang']::text[],'A native of Qiao in Pei and Cao Cao’s cousin, who campaigned with him for years and lost an eye to a stray arrow, earning the nickname "Blind Xiahou."'),
('dian-wei','zh-CN','典韦',ARRAY[]::text[],'陈留己吾人，曹操帐下都尉，膂力过人，建安二年宛城之役为救操战死。'),
('dian-wei','en','Dian Wei',ARRAY[]::text[],'A native of Jiwu in Chenliu who served as a commandant in Cao Cao’s guard, a man of extraordinary strength, killed in 197 at Wancheng shielding Cao Cao’s escape.'),
('tao-qian','zh-CN','陶谦',ARRAY['恭祖']::text[],'丹杨人，徐州牧，兴平元年病笃，以徐州让刘备，同年卒。'),
('tao-qian','en','Tao Qian',ARRAY['Gongzu']::text[],'A native of Danyang who governed Xu Province, and on his deathbed in 194 ceded the province to Liu Bei before dying the same year.'),
('xu-you','zh-CN','许攸',ARRAY['子远']::text[],'南阳人，本袁绍谋臣，官渡之战阵前来投，献计袭乌巢粮仓，操由是大胜。'),
('xu-you','en','Xu You',ARRAY['Ziyuan']::text[],'A native of Nanyang and formerly Yuan Shao’s advisor, who defected to Cao Cao during the Guandu campaign and revealed the location of the Wuchao granary, enabling Cao Cao’s decisive victory.'),
('zhang-he','zh-CN','张郃',ARRAY['儁乂']::text[],'河间鄚人，本袁绍部将，官渡之战与高览临阵降操，后为魏之名将。'),
('zhang-he','en','Zhang He',ARRAY['Junyi']::text[],'A native of Mo in Hejian and originally one of Yuan Shao’s officers, who surrendered to Cao Cao alongside Gao Lan during the Guandu campaign and later became one of Wei’s celebrated generals.'),
('ju-shou','zh-CN','沮授',ARRAY[]::text[],'广平人，袁绍监军，力谏持重缓攻而不见用，官渡兵败被俘，不肯降操，终被杀。'),
('ju-shou','en','Ju Shou',ARRAY[]::text[],'A native of Guangping who served as Yuan Shao’s supervising general, urging caution that went unheeded; captured after Guandu, he refused to submit to Cao Cao and was put to death.'),
('shen-pei','zh-CN','审配',ARRAY['正南']::text[],'魏郡人，袁绍谋臣，绍死后奉袁尚，据邺城死守，城破被杀。'),
('shen-pei','en','Shen Pei',ARRAY['Zhengnan']::text[],'A native of Wei Commandery and Yuan Shao’s advisor, who backed Yuan Shang after his lord’s death and held Ye City to the last, killed when it fell.'),
('guo-tu','zh-CN','郭图',ARRAY['公则']::text[],'颍川人，袁绍谋臣，屡进谗言构陷同僚，官渡战后依附袁谭，兵败被杀。'),
('guo-tu','en','Guo Tu',ARRAY['Gongze']::text[],'A native of Yingchuan and Yuan Shao’s advisor, given to slandering his colleagues, who backed Yuan Tan after Guandu and was killed in the ensuing collapse.'),
('liu-biao','zh-CN','刘表',ARRAY['景升']::text[],'山阳高平人，荆州牧，据荆襄多年保境安民，建安十三年病卒。'),
('liu-biao','en','Liu Biao',ARRAY['Jingsheng']::text[],'A native of Gaoping in Shanyang who governed Jing Province for years, keeping it at peace, until his death from illness in 208.')
) AS v(slug,locale,name,aliases,summary) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

-- Romance (演义) — 小说叙写 voice.
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,'','' FROM characters c JOIN (VALUES
('guo-jia','zh-CN','郭嘉',ARRAY['奉孝']::text[],'曹操麾下鬼才军师，屡出奇计料敌如神，随征乌桓病卒，操痛哭"哀哉奉孝"。'),
('guo-jia','en','Guo Jia',ARRAY['Fengxiao']::text[],'Cao Cao’s uncannily gifted strategist, whose foresight time and again outguessed the enemy, dying of illness on the Wuhuan campaign as Cao Cao wept, "Alas, Fengxiao!"'),
('xun-yu','zh-CN','荀彧',ARRAY['文若']::text[],'曹操倚重之谋主，献策迎天子都许，运筹帷幄，人称"荀令君"。'),
('xun-yu','en','Xun Yu',ARRAY['Wenruo']::text[],'Cao Cao’s trusted counsellor, called Lord Xun, whose plan to receive the emperor at Xu shaped the court from behind the scenes.'),
('zhang-liao','zh-CN','张辽',ARRAY['文远']::text[],'吕布麾下骁将，白门楼将被斩，因刘备一语得曹操赦免收降，自此为魏效力。'),
('zhang-liao','en','Zhang Liao',ARRAY['Wenyuan']::text[],'A fierce general under Lü Bu, spared execution at White Gate Tower through Liu Bei’s intercession and won over to serve Wei thereafter.'),
('xiahou-dun','zh-CN','夏侯惇',ARRAY['元让']::text[],'曹氏宗族猛将，中箭拔矢啖睛，"父精母血，不可弃也"一语传为豪谈。'),
('xiahou-dun','en','Xiahou Dun',ARRAY['Yuanrang']::text[],'A ferocious general of the Cao clan who, struck by an arrow, pulled it free and swallowed his own eye, declaring it too precious a gift from his parents to discard.'),
('dian-wei','zh-CN','典韦',ARRAY[]::text[],'曹操帐前第一猛将，双戟惊人，宛城之变以身堵门力战而死，操哭之如丧亲子。'),
('dian-wei','en','Dian Wei',ARRAY[]::text[],'Cao Cao’s foremost bodyguard, wielding twin halberds, who blocked the gate with his own body at Wancheng and died fighting, mourned by Cao Cao as if for a son.'),
('tao-qian','zh-CN','陶谦',ARRAY['恭祖']::text[],'徐州牧，仁厚长者，三让徐州于刘备，临终托付殷殷。'),
('tao-qian','en','Tao Qian',ARRAY['Gongzu']::text[],'The benevolent governor of Xu Province, who three times offered the province to Liu Bei before entrusting it to him with his dying words.'),
('xu-you','zh-CN','许攸',ARRAY['子远']::text[],'袁绍旧友，因谋不见用、家人获罪而奔曹营，献乌巢之计，助操火烧粮草。'),
('xu-you','en','Xu You',ARRAY['Ziyuan']::text[],'An old friend of Yuan Shao’s whose counsel went unheeded and whose kin fell into disgrace, driving him to Cao Cao’s camp with the secret of Wuchao that let the grain stores burn.'),
('zhang-he','zh-CN','张郃',ARRAY['儁乂']::text[],'袁绍帐下大将，因郭图谗言获罪，与高览一同阵前倒戈归曹。'),
('zhang-he','en','Zhang He',ARRAY['Junyi']::text[],'One of Yuan Shao’s leading generals, falsely accused through Guo Tu’s slander, who turned his banner alongside Gao Lan to join Cao Cao mid-battle.'),
('ju-shou','zh-CN','沮授',ARRAY[]::text[],'袁绍谋臣，屡陈良策不为所用，官渡被擒，宁死不降，操亦叹惜其忠。'),
('ju-shou','en','Ju Shou',ARRAY[]::text[],'Yuan Shao’s advisor, whose sound counsel was repeatedly ignored; captured at Guandu, he chose death over surrender, and even Cao Cao mourned his loyalty.'),
('shen-pei','zh-CN','审配',ARRAY['正南']::text[],'袁绍帐下忠臣，邺城被围仍誓死固守，城破犹骂敌不屈，慷慨就戮。'),
('shen-pei','en','Shen Pei',ARRAY['Zhengnan']::text[],'A loyal officer under Yuan Shao who swore to hold besieged Ye City to the death, still defiant and unbowed even as the city fell, meeting execution without flinching.'),
('guo-tu','zh-CN','郭图',ARRAY['公则']::text[],'袁绍谋士，妒害同僚张郃、许攸，致使二人先后叛归曹操，加速河北败亡。'),
('guo-tu','en','Guo Tu',ARRAY['Gongze']::text[],'An advisor to Yuan Shao whose jealous scheming against Zhang He and Xu You drove both men to defect to Cao Cao, hastening Hebei’s collapse.'),
('liu-biao','zh-CN','刘表',ARRAY['景升']::text[],'荆州牧，汉室宗亲，坐拥荆襄却优柔寡断，收留刘备而心存疑惧。'),
('liu-biao','en','Liu Biao',ARRAY['Jingsheng']::text[],'The governor of Jing Province and a distant Han kinsman, holding rich Jing-Xiang yet endlessly irresolute, sheltering Liu Bei while never quite trusting him.')
) AS v(slug,locale,name,aliases,summary) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 2. LOCATIONS (era-specific small sites, KK=04 only: Baima, Wuchao, Liucheng)
-- ============================================================

INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
-- Records (志)
('36000000-0000-4000-8004-000000000001','10000000-0000-4000-8000-000000000006','baima','real',ST_GeogFromText('POINT(114.5170 35.4830)'),NULL,NULL,400,'battlefield','inferred',12,'CN',true,true),
('36000000-0000-4000-8004-000000000002','10000000-0000-4000-8000-000000000006','wuchao','real',ST_GeogFromText('POINT(114.1990 35.1520)'),NULL,NULL,401,'battlefield','inferred',12,'CN',true,true),
('36000000-0000-4000-8004-000000000003','10000000-0000-4000-8000-000000000006','liucheng','real',ST_GeogFromText('POINT(120.4500 41.5500)'),NULL,NULL,402,'battlefield','inferred',11,'CN',true,true),
-- Romance (演义)
('37000000-0000-4000-8004-000000000001','10000000-0000-4000-8000-000000000007','baima','real',ST_GeogFromText('POINT(114.5170 35.4830)'),NULL,NULL,400,'battlefield','inferred',12,'CN',true,true),
('37000000-0000-4000-8004-000000000002','10000000-0000-4000-8000-000000000007','wuchao','real',ST_GeogFromText('POINT(114.1990 35.1520)'),NULL,NULL,401,'battlefield','inferred',12,'CN',true,true),
('37000000-0000-4000-8004-000000000003','10000000-0000-4000-8000-000000000007','liucheng','real',ST_GeogFromText('POINT(120.4500 41.5500)'),NULL,NULL,402,'battlefield','inferred',11,'CN',true,true)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',v.region FROM locations l JOIN (VALUES
('baima','10000000-0000-4000-8000-000000000006','zh-CN','白马','黄河渡口，建安五年关羽于此阵斩袁绍大将颜良。','兖州东郡'),
('baima','10000000-0000-4000-8000-000000000006','en','Baima','A crossing on the Yellow River where Guan Yu killed Yuan Shao’s general Yan Liang in battle in 200.','Dong Commandery, Yan Province'),
('wuchao','10000000-0000-4000-8000-000000000006','zh-CN','乌巢','袁绍屯粮之地，建安五年为曹操奇袭焚毁，河北军心由此瓦解。','兖州东郡'),
('wuchao','10000000-0000-4000-8000-000000000006','en','Wuchao','The site of Yuan Shao’s grain depot, burned in a surprise raid by Cao Cao in 200 that broke Hebei’s army.','Dong Commandery, Yan Province'),
('liucheng','10000000-0000-4000-8000-000000000006','zh-CN','柳城','辽西乌桓所据之地，建安十二年曹操远征至此，大破乌桓，郭嘉病殁于途中。','幽州辽西郡'),
('liucheng','10000000-0000-4000-8000-000000000006','en','Liucheng','The Wuhuan stronghold in Liaoxi that Cao Cao’s army reached in 207, crushing the Wuhuan there, with Guo Jia dying of illness on the campaign.','Liaoxi Commandery, You Province'),
('baima','10000000-0000-4000-8000-000000000007','zh-CN','白马','小说叙写关羽于此策马刺颜良于万军之中，报效曹操知遇之恩。','兖州东郡'),
('baima','10000000-0000-4000-8000-000000000007','en','Baima','The novel’s setting for Guan Yu’s single charge that killed Yan Liang amid the enemy host, repaying Cao Cao’s favour.','Dong Commandery, Yan Province'),
('wuchao','10000000-0000-4000-8000-000000000007','zh-CN','乌巢','小说叙写许攸献计，曹操亲率轻骑夜袭乌巢，火烧袁绍粮草。','兖州东郡'),
('wuchao','10000000-0000-4000-8000-000000000007','en','Wuchao','The novel’s setting for Xu You’s secret counsel and Cao Cao’s night raid that burned Yuan Shao’s grain stores.','Dong Commandery, Yan Province'),
('liucheng','10000000-0000-4000-8000-000000000007','zh-CN','柳城','小说叙写曹操远征乌桓至此获胜，郭嘉临终遗计定辽东。','幽州辽西郡'),
('liucheng','10000000-0000-4000-8000-000000000007','en','Liucheng','The novel’s setting for Cao Cao’s victorious campaign against the Wuhuan, capped by Guo Jia’s dying strategy for Liaodong.','Liaoxi Commandery, You Province')
) AS v(slug,work_id,locale,name,summary,region) ON l.slug=v.slug AND l.work_id=v.work_id::uuid
ON CONFLICT DO NOTHING;

-- ============================================================
-- 3. EVENTS
--    KK=03 (warlords-contending, chapter seq 3): Records 8, Romance 11
--    KK=04 (guandu-and-the-north, chapter seq 4): Records 8, Romance 11
-- ============================================================

-- Records (志), KK=03 — 8 events, sequence 3002..3016
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('64000000-0000-4000-8003-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'julian'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'wang-yun-and-lu-bu-kill-dong-zhuo',3002,'verified_historical','betrayal','exact',192,192,'high'),
(2,'li-jue-guo-si-sack-changan',3004,'verified_historical','battle','exact',192,192,'high'),
(3,'cao-cao-campaigns-against-tao-qian',3006,'verified_historical','battle','range',193,194,'medium'),
(4,'lu-bu-seizes-yanzhou',3008,'verified_historical','political','exact',194,194,'high'),
(5,'tao-qian-cedes-xuzhou-to-liu-bei',3010,'reported_historical','political','exact',194,194,'medium'),
(6,'emperor-xian-arrives-at-xuchang',3012,'verified_historical','political','exact',196,196,'high'),
(7,'yuan-shu-proclaims-himself-emperor',3014,'verified_historical','political','exact',197,197,'high'),
(8,'cao-cao-defeats-lu-bu-at-xiapi',3016,'verified_historical','battle','exact',198,198,'high')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,conf)
JOIN chapters ch ON ch.slug='warlords-contending' AND ch.work_id='10000000-0000-4000-8000-000000000006';

-- Romance (演义), KK=03 — 11 events, sequence 3002..3022
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('65000000-0000-4000-8003-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'julian'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'wang-yun-and-lu-bu-kill-dong-zhuo',3002,'fictional_with_historical_context','betrayal','exact',192,192,'medium'),
(2,'li-jue-guo-si-sack-changan',3004,'fictional_with_historical_context','battle','exact',192,192,'medium'),
(3,'cao-cao-campaigns-against-tao-qian',3006,'fictional_with_historical_context','battle','range',193,194,'medium'),
(4,'lu-bu-seizes-yanzhou',3008,'fictional_with_historical_context','political','exact',194,194,'medium'),
(5,'tao-qian-cedes-xuzhou-to-liu-bei',3010,'fictional_with_historical_context','political','exact',194,194,'medium'),
(6,'emperor-xian-arrives-at-xuchang',3012,'fictional_with_historical_context','political','exact',196,196,'medium'),
(7,'yuan-shu-proclaims-himself-emperor',3014,'fictional_with_historical_context','political','exact',197,197,'medium'),
(8,'cao-cao-defeats-lu-bu-at-xiapi',3016,'fictional_with_historical_context','battle','exact',198,198,'medium'),
(9,'lu-bu-shoots-the-halberd-at-the-camp-gate',3018,'fictional_with_historical_context','social','exact',196,196,'medium'),
(10,'dian-wei-dies-defending-cao-cao-at-wancheng',3020,'fictional_with_historical_context','death','exact',197,197,'medium'),
(11,'cao-cao-and-liu-bei-discuss-heroes-over-wine',3022,'fictional_with_historical_context','social','range',198,199,'low')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,conf)
JOIN chapters ch ON ch.slug='warlords-contending' AND ch.work_id='10000000-0000-4000-8000-000000000007';

-- Records (志), KK=04 — 8 events, sequence 4002..4016
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('64000000-0000-4000-8004-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'julian'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'dong-cheng-plot-uncovered',4002,'verified_historical','betrayal','exact',200,200,'high'),
(2,'cao-cao-captures-guan-yu-at-xiapi',4004,'verified_historical','battle','exact',200,200,'high'),
(3,'sun-ce-is-assassinated',4006,'verified_historical','death','exact',200,200,'high'),
(4,'guan-yu-slays-yan-liang-at-baima',4008,'verified_historical','battle','exact',200,200,'high'),
(5,'battle-of-guandu',4010,'verified_historical','battle','exact',200,200,'high'),
(6,'yuan-shaos-sons-fall-to-cao-cao',4012,'verified_historical','political','range',202,205,'medium'),
(7,'cao-cao-campaigns-against-the-wuhuan',4014,'verified_historical','battle','exact',207,207,'high'),
(8,'liu-bei-visits-zhuge-liang-at-longzhong',4016,'reported_historical','meeting','range',206,207,'medium')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,conf)
JOIN chapters ch ON ch.slug='guandu-and-the-north' AND ch.work_id='10000000-0000-4000-8000-000000000006';

-- Romance (演义), KK=04 — 11 events, sequence 4002..4022
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('65000000-0000-4000-8004-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'julian'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'dong-cheng-plot-uncovered',4002,'fictional_with_historical_context','betrayal','exact',200,200,'medium'),
(2,'cao-cao-captures-guan-yu-at-xiapi',4004,'fictional_with_historical_context','battle','exact',200,200,'medium'),
(3,'sun-ce-is-assassinated',4006,'fictional_with_historical_context','death','exact',200,200,'medium'),
(4,'guan-yu-slays-yan-liang-at-baima',4008,'fictional_with_historical_context','battle','exact',200,200,'medium'),
(5,'battle-of-guandu',4010,'fictional_with_historical_context','battle','exact',200,200,'medium'),
(6,'yuan-shaos-sons-fall-to-cao-cao',4012,'fictional_with_historical_context','political','range',202,205,'medium'),
(7,'cao-cao-campaigns-against-the-wuhuan',4014,'fictional_with_historical_context','battle','exact',207,207,'medium'),
(8,'liu-bei-visits-zhuge-liang-at-longzhong',4016,'fictional_with_historical_context','meeting','range',206,207,'medium'),
(9,'guan-yu-and-cao-cao-agree-to-three-conditions',4018,'fictional_with_historical_context','meeting','exact',200,200,'low'),
(10,'guan-yu-rides-a-thousand-li-alone',4020,'fictional_narrative','journey','exact',200,200,'low'),
(11,'guan-yu-reunites-with-liu-bei-at-old-city',4022,'fictional_narrative','meeting','exact',200,200,'low')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,conf)
JOIN chapters ch ON ch.slug='guandu-and-the-north' AND ch.work_id='10000000-0000-4000-8000-000000000007';

-- ============================================================
-- 5. EVENT TRANSLATIONS
-- ============================================================

-- Records (志), KK=03
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tlabel FROM events e JOIN (VALUES
('wang-yun-and-lu-bu-kill-dong-zhuo','zh-CN','王允结吕布诛董卓','志载王允与吕布合谋，于长安诛杀董卓。','董卓专权日甚，司徒王允暗结吕布为内应。初平三年，吕布于未央宫外刺杀董卓，凉州兵一时无主。','董卓之死使中枢权柄骤然真空，为群雄逐鹿埋下伏笔。','约公元192年'),
('wang-yun-and-lu-bu-kill-dong-zhuo','en','Wang Yun and Lü Bu kill Dong Zhuo','The Records records Wang Yun conspiring with Lü Bu to kill Dong Zhuo at Chang’an.','As Dong Zhuo’s tyranny deepened, Minister Wang Yun secretly won over his own ward Lü Bu. In 192, Lü Bu struck Dong Zhuo down outside the palace gates, leaving the Liangzhou army suddenly leaderless.','Dong Zhuo’s death left central power abruptly vacant, setting the stage for the warlords’ scramble.','c. 192 CE'),
('li-jue-guo-si-sack-changan','zh-CN','李傕郭汜攻陷长安','志载董卓部将李傕、郭汜反攻长安，王允身死，献帝再度受制。','董卓旧部李傕、郭汜以为部下无赦为由举兵犯长安，城破，王允遇害，吕布败走。献帝自此落入二人之手，朝局愈乱。','长安再陷使汉室权威进一步瓦解，献帝流离之局由此开始。','约公元192年'),
('li-jue-guo-si-sack-changan','en','Li Jue and Guo Si sack Chang’an','The Records records Dong Zhuo’s former officers Li Jue and Guo Si retaking Chang’an, killing Wang Yun.','Fearing they would not be pardoned, Dong Zhuo’s remaining officers Li Jue and Guo Si stormed Chang’an; the city fell, Wang Yun was killed, and Lü Bu fled. Emperor Xian passed into their custody, and the court fell into deeper disorder.','The second fall of Chang’an further dissolved Han’s authority and began the emperor’s years of displacement.','c. 192 CE'),
('cao-cao-campaigns-against-tao-qian','zh-CN','曹操征讨陶谦','志载曹操以父仇为由兴兵徐州，连破陶谦诸城。','曹操之父曹嵩过境徐州为陶谦部下所害，操怒而兴师，兴平元年、二年两度攻徐州，屠戮甚众。陶谦势蹙求援于田楷、刘备。','此役开启曹操与徐州的长期纠葛，也促成刘备崭露头角的契机。','约公元193–194年'),
('cao-cao-campaigns-against-tao-qian','en','Cao Cao campaigns against Tao Qian','The Records records Cao Cao invading Xu Province to avenge his father’s death, breaking city after city held by Tao Qian.','When Cao Cao’s father Cao Song was killed passing through Xu Province by men under Tao Qian, Cao Cao marched against the province in 193 and 194 with great slaughter. Tao Qian, hard pressed, sought help from Tian Kai and Liu Bei.','The campaign began Cao Cao’s long entanglement with Xu Province and gave Liu Bei his first chance to distinguish himself.','c. 193–194 CE'),
('lu-bu-seizes-yanzhou','zh-CN','吕布袭取兖州','志载吕布乘曹操东征陶谦之隙，联合陈留豪强夺取兖州大半。','吕布自长安败走后依附张邈，乘曹操后方空虚袭取兖州诸郡，唯鄄城、东阿、范三城为荀彧、程昱固守得存。曹操被迫回师相争。','兖州几近尽失，是曹操崛起过程中最险的一次根基动摇。','约公元194年'),
('lu-bu-seizes-yanzhou','en','Lü Bu seizes Yan Province','The Records records Lü Bu, backed by Chenliu magnates, taking most of Yan Province while Cao Cao campaigned in the east.','Having fled Chang’an, Lü Bu allied with Zhang Miao and struck at Cao Cao’s undefended rear, seizing most of Yan Province; only Juancheng, Dong’e, and Fan held out under Xun Yu and Cheng Yu. Cao Cao was forced to turn back and fight for his own base.','The near loss of Yan Province was the gravest threat to Cao Cao’s foundation in his rise to power.','c. 194 CE'),
('tao-qian-cedes-xuzhou-to-liu-bei','zh-CN','陶谦让徐州于刘备','志载陶谦病笃，以徐州相让，刘备遂领徐州牧。','陶谦既老且病，见刘备曾解徐州之围，遂表其领徐州，同年病卒。刘备由此始有一州之地。','徐州的取得使刘备第一次拥有稳定根据地，跻身群雄之列。','约公元194年'),
('tao-qian-cedes-xuzhou-to-liu-bei','en','Tao Qian cedes Xu Province to Liu Bei','The Records records the ailing Tao Qian handing Xu Province to Liu Bei, who had once relieved its siege.','Old and failing, Tao Qian recommended Liu Bei to govern Xu Province in gratitude for his earlier relief of the province, and died the same year. Liu Bei thereby held territory of his own for the first time.','Gaining Xu Province gave Liu Bei his first stable base and a place among the contending warlords.','c. 194 CE'),
('emperor-xian-arrives-at-xuchang','zh-CN','献帝驾幸许昌','志载曹操迎献帝都许，自此挟天子以令诸侯。','献帝东归洛阳，宫室残破，曹操从荀彧之议，建安元年迎帝迁都于许，拜大将军，总揽朝政。','挟天子以令诸侯的格局自此确立，曹操由此获得号令天下的政治资本。','约公元196年'),
('emperor-xian-arrives-at-xuchang','en','Emperor Xian arrives at Xuchang','The Records records Cao Cao welcoming Emperor Xian and moving the court to Xu, thereafter commanding the realm in the emperor’s name.','With Luoyang’s palaces in ruins after the emperor’s return, Cao Cao followed Xun Yu’s counsel and in 196 escorted the emperor to Xu, taking the title of General-in-Chief and control of court affairs.','This established the arrangement of commanding the other warlords in the emperor’s name, giving Cao Cao unmatched political capital.','c. 196 CE'),
('yuan-shu-proclaims-himself-emperor','zh-CN','袁术僭号称帝','志载袁术据传国玉玺，于寿春僭号称帝，国号仲家。','袁术因得孙策所寄传国玉玺，妄自尊大，建安二年于寿春称帝，建号仲家，横征暴敛，众叛亲离。','袁术称帝之举使其成为众矢之的，加速了自身的败亡。','约公元197年'),
('yuan-shu-proclaims-himself-emperor','en','Yuan Shu proclaims himself emperor','The Records records Yuan Shu, holding the imperial seal, proclaiming his own dynasty at Shouchun.','Having obtained the imperial seal left with him by Sun Ce, Yuan Shu grew overconfident and in 197 declared himself emperor at Shouchun under the name Zhongjia, taxing his people heavily and losing his followers’ support.','The self-proclamation made Yuan Shu a target for every rival and hastened his own downfall.','c. 197 CE'),
('cao-cao-defeats-lu-bu-at-xiapi','zh-CN','曹操破吕布于下邳','志载曹操引沂、泗水灌下邳，吕布部将叛降，布出降后被缢杀。','建安三年，曹操围下邳，决泗、沂二水灌城，吕布部将侯成、宋宪等献城投降。吕布出降，操缢杀之于白门楼。','吕布之死清除了徐州一带最大的独立势力，曹操势力进一步扩大。','约公元198年'),
('cao-cao-defeats-lu-bu-at-xiapi','en','Cao Cao defeats Lü Bu at Xiapi','The Records records Cao Cao diverting the Yi and Si rivers to flood Xiapi, where Lü Bu’s officers surrendered and he was executed.','In 198 Cao Cao besieged Xiapi and diverted the Si and Yi rivers to flood the city; Lü Bu’s officers Hou Cheng and Song Xian opened the gates. Lü Bu surrendered and was strangled at White Gate Tower.','Lü Bu’s death removed the largest independent power in the Xuzhou region and further expanded Cao Cao’s reach.','c. 198 CE')
) AS v(slug,locale,title,summary,detail,sig,tlabel) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000006';

-- Romance (演义), KK=03
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tlabel FROM events e JOIN (VALUES
('wang-yun-and-lu-bu-kill-dong-zhuo','zh-CN','王允施连环计诛董卓','小说敷演王允献貂蝉设连环计，离间董卓、吕布父子终成大事。','王允假意以歌伎貂蝉先许吕布，复献董卓，父子二人因美色反目。吕布怒而于凤仪亭后举戟弑父，助王允诛除国贼。','连环计是小说中以柔克刚的经典范例，也是全书前期最富戏剧性的转折。','约公元192年'),
('wang-yun-and-lu-bu-kill-dong-zhuo','en','Wang Yun springs the chain stratagem to kill Dong Zhuo','The novel dramatises Wang Yun using the singer Diaochan to turn ward against foster father, ending in Dong Zhuo’s death.','Wang Yun secretly promised the songstress Diaochan first to Lü Bu, then presented her to Dong Zhuo, setting father and son at odds over her. Enraged after the scene at Phoenix Pavilion, Lü Bu struck his foster father down with a halberd, helping Wang Yun rid the realm of a tyrant.','The chain stratagem stands as the novel’s classic display of cunning overcoming brute strength, and its first great turning point.','c. 192 CE'),
('li-jue-guo-si-sack-changan','zh-CN','李傕郭汜之乱','小说叙写李傕、郭汜为董卓复仇，攻陷长安，王允殉难，吕布败走。','李傕、郭汜纠合旧部，诈称赦而复叛，长驱直入长安。王允不肯逃走，慷慨赴难；吕布独力难支，弃城而走投奔袁术。','长安再乱使汉室颜面尽失，也让献帝陷入更深的漂泊。','约公元192年'),
('li-jue-guo-si-sack-changan','en','The chaos of Li Jue and Guo Si','The novel narrates Li Jue and Guo Si avenging Dong Zhuo by storming Chang’an, Wang Yun dying a martyr, and Lü Bu fleeing.','Li Jue and Guo Si rallied Dong Zhuo’s scattered troops on the pretence of a false pardon and drove straight into Chang’an. Wang Yun refused to flee and died bravely; Lü Bu, unable to hold the city alone, abandoned it and fled to Yuan Shu.','The renewed chaos in Chang’an stripped Han of its last dignity and sent the emperor into deeper wandering.','c. 192 CE'),
('cao-cao-campaigns-against-tao-qian','zh-CN','曹操兴兵复仇战徐州','小说叙写曹操为报杀父之仇，两度兴兵徐州，所过多屠戮。','曹嵩举家迁往兖州途中为陶谦部将张闿所害，曹操悲愤兴师，连破徐州诸县，坑杀百姓以泄愤，陶谦仓皇求救于孔融、刘备。','屠城之举成为小说中对曹操"奸雄"性格最直接的刻画。','约公元193–194年'),
('cao-cao-campaigns-against-tao-qian','en','Cao Cao’s war of vengeance in Xu Province','The novel dramatises Cao Cao invading Xu Province twice to avenge his father, leaving slaughter in his wake.','Cao Song was murdered by Tao Qian’s officer Zhang Kai while moving his household toward Yan Province, and a grief-maddened Cao Cao broke county after county in Xu Province, massacring the people in his fury. A desperate Tao Qian appealed to Kong Rong and Liu Bei for aid.','The massacre is the novel’s starkest portrait of Cao Cao as the age’s "capable villain."','c. 193–194 CE'),
('lu-bu-seizes-yanzhou','zh-CN','吕布乘虚取兖州','小说叙写陈宫说动张邈迎吕布入主兖州，曹操后方几近尽失。','陈宫因操屠徐州而心生异志，暗结张邈迎吕布袭据兖州，仅鄄城、范、东阿三县由荀彧、程昱死守得全。','兖州之失几乎断送曹操根本，也是小说中陈宫由从属转向敌对的关键节点。','约公元194年'),
('lu-bu-seizes-yanzhou','en','Lü Bu takes Yan Province by stealth','The novel narrates Chen Gong persuading Zhang Miao to welcome Lü Bu into Yan Province, nearly costing Cao Cao his base.','Disturbed by the massacre in Xu Province, Chen Gong secretly conspired with Zhang Miao to bring Lü Bu into Yan Province; only Juancheng, Fan, and Dong’e held out under Xun Yu and Cheng Yu.','The loss very nearly ended Cao Cao’s power at its root, and marks the novel’s turn of Chen Gong from ally to adversary.','c. 194 CE'),
('tao-qian-cedes-xuzhou-to-liu-bei','zh-CN','陶谦三让徐州','小说叙写陶谦三次相让，刘备再三推辞终受徐州牧之印。','陶谦感刘备两番解围之恩，临终三次以徐州相托，刘备初辞再辞，终因徐州百姓恳留而受任，同年陶谦病故。','三让徐州是刘备"仁德"形象在小说中最具代表性的一幕。','约公元194年'),
('tao-qian-cedes-xuzhou-to-liu-bei','en','Tao Qian offers Xu Province three times','The novel dramatises Tao Qian offering Xu Province three times before Liu Bei finally accepts the governor’s seal.','Grateful for Liu Bei’s two rescues of the province, the dying Tao Qian offered it to him three times; Liu Bei twice declined before the people’s pleas moved him to accept, and Tao Qian died soon after.','The triple offer is the novel’s most emblematic scene of Liu Bei’s benevolence.','c. 194 CE'),
('emperor-xian-arrives-at-xuchang','zh-CN','曹操迎驾都许昌','小说叙写曹操采荀彧之谋，迎献帝迁都于许，自此挟天子以令诸侯。','献帝还都洛阳，宫室残破粮草不继，曹操依荀彧"奉天子以令不臣"之策，亲率大军迎驾迁于许都，自领大将军，威福自专。','此举奠定曹操"名为汉相，实为汉贼"的权力格局，是小说中枢纽性的政治转折。','约公元196年'),
('emperor-xian-arrives-at-xuchang','en','Cao Cao escorts the emperor to Xuchang','The novel narrates Cao Cao following Xun Yu’s counsel to welcome Emperor Xian and move the court to Xu.','With Luoyang in ruins and provisions failing, Cao Cao acted on Xun Yu’s plan to "serve the emperor in order to command the disobedient," personally escorting the court to Xu and taking the title of General-in-Chief.','The move fixed the pattern of Cao Cao ruling as Han’s minister in name and its master in fact, a pivotal turn in the novel’s politics.','c. 196 CE'),
('yuan-shu-proclaims-himself-emperor','zh-CN','袁术僭号称帝','小说叙写袁术恃玉玺骄狂，于寿春称帝，横征暴敛终致众叛亲离。','袁术既得孙策所质传国玉玺，遂不自量力，于寿春僭称帝号，穷奢极欲，麾下将士离心，诸侯共讨之声四起。','袁术称帝的狂妄成为小说中警示僭越必败的典型案例。','约公元197年'),
('yuan-shu-proclaims-himself-emperor','en','Yuan Shu proclaims himself emperor','The novel dramatises Yuan Shu, emboldened by the imperial seal, declaring himself emperor at Shouchun before his following collapses.','Holding the seal that Sun Ce had left in pawn, Yuan Shu overreached and proclaimed his own reign at Shouchun in extravagant luxury; his officers grew estranged and calls to punish the usurper rose on every side.','Yuan Shu’s presumption serves the novel as a cautionary case of ambition outrunning strength.','c. 197 CE'),
('cao-cao-defeats-lu-bu-at-xiapi','zh-CN','白门楼吕布殒命','小说叙写曹操决水灌下邳，吕布被部将出卖，白门楼下丧命。','曹操围城日久，用郭嘉、荀攸之计决沂、泗二水灌城，宋宪、魏续缚吕布献降。吕布乞降之际，刘备一语"公不见丁建阳、董太师之事乎"促操决意杀之。','白门楼一幕是全书前期最具警世意味的收束，吕布"三姓家奴"的形象由此定型。','约公元198年'),
('cao-cao-defeats-lu-bu-at-xiapi','en','Lü Bu falls at White Gate Tower','The novel narrates Cao Cao flooding Xiapi and Lü Bu, betrayed by his own officers, meeting his end beneath White Gate Tower.','After a long siege, Cao Cao used Guo Jia and Xun You’s plan to flood the city with the Yi and Si rivers; Song Xian and Wei Xu bound Lü Bu and surrendered him. As Lü Bu begged for his life, Liu Bei’s reminder of Ding Yuan and Dong Zhuo’s fates sealed Cao Cao’s decision to execute him.','The scene closes the novel’s opening arc on a cautionary note, fixing Lü Bu’s image as a man who served three fathers and betrayed them all.','c. 198 CE'),
('lu-bu-shoots-the-halberd-at-the-camp-gate','zh-CN','吕布辕门射戟','小说叙写吕布于辕门外一箭射中画戟小枝，为刘备解袁术大将纪灵之围。','袁术遣纪灵领兵攻刘备于小沛，吕布恐刘备有失，两家皆折其锐，乃邀两军于辕门置戟百步，一箭中的，纪灵遂罢兵而去。','辕门射戟展现吕布在乱世中周旋各方的一面，也暂时化解了刘备的危局。','约公元196年'),
('lu-bu-shoots-the-halberd-at-the-camp-gate','en','Lü Bu shoots the halberd at the camp gate','The novel dramatises Lü Bu shooting the small branch of a halberd planted a hundred paces off to lift Ji Ling’s siege of Liu Bei.','When Yuan Shu sent his general Ji Ling against Liu Bei at Xiaopei, Lü Bu, wary of either side gaining too much, staged a single archery feat at his camp gate; his arrow struck the mark, and Ji Ling withdrew his troops.','The archery feat shows Lü Bu balancing rival powers against each other, and briefly spares Liu Bei a crisis.','c. 196 CE'),
('dian-wei-dies-defending-cao-cao-at-wancheng','zh-CN','典韦血战宛城','小说叙写张绣降而复叛，典韦力战掩护曹操，终于寡不敌众战死辕门。','曹操纳张绣之降，又纳其婶邹氏，张绣怀恨突袭，曹昂、曹安民同时遇害。典韦持双戟死守寨门，力竭而亡，为操争得脱身之机。','典韦之死是小说中最悲壮的护主场面之一，也使曹操元气大伤。','约公元197年'),
('dian-wei-dies-defending-cao-cao-at-wancheng','en','Dian Wei dies in battle at Wancheng','The novel dramatises Zhang Xiu’s surrender turning to revolt and Dian Wei’s last stand covering Cao Cao’s escape.','After accepting Zhang Xiu’s surrender, Cao Cao took Zhang Xiu’s aunt Lady Zou as a concubine, provoking a furious surprise attack in which Cao Ang and Cao Anmin both died. Dian Wei held the camp gate alone with twin halberds until his strength failed, buying Cao Cao time to flee.','Dian Wei’s death is one of the novel’s most poignant scenes of a bodyguard’s sacrifice, and it cost Cao Cao dearly.','c. 197 CE'),
('cao-cao-and-liu-bei-discuss-heroes-over-wine','zh-CN','青梅煮酒论英雄','小说叙写曹操煮酒相邀，与刘备论天下英雄，刘备闻雷失箸以掩其志。','刘备寄居许都，日于后园种菜以韬光养晦。曹操一日邀其煮酒论英雄，历数当世群雄皆不足道，独言"今天下英雄，惟使君与操耳"，刘备惊而失箸，恰逢雷震借以掩饰。','此段对话是刘备韬晦自保智慧的经典展现，也暗示曹刘终将分道扬镳。','约公元198–199年'),
('cao-cao-and-liu-bei-discuss-heroes-over-wine','en','Discussing heroes over warmed wine','The novel dramatises Cao Cao inviting Liu Bei to drink and rank the era’s heroes, Liu Bei dropping his chopsticks at a timely clap of thunder to mask his ambition.','Lodging in Xu, Liu Bei spent his days tending vegetables to appear harmless. Invited to drink warmed wine, he heard Cao Cao dismiss every rival in turn before declaring, "The only heroes under heaven today are you and I" — and covered his startled reaction behind a sudden thunderclap.','The exchange is the novel’s classic display of Liu Bei’s self-concealing prudence, and foreshadows his eventual break with Cao Cao.','c. 198–199 CE')
) AS v(slug,locale,title,summary,detail,sig,tlabel) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000007';

-- Records (志), KK=04
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tlabel FROM events e JOIN (VALUES
('dong-cheng-plot-uncovered','zh-CN','董承衣带诏事泄','志载车骑将军董承奉密诏谋诛曹操，事泄被杀。','建安五年，董承等密谋诛曹操，事泄，操诛董承及其党羽，并夷其族。刘备时预其谋，因出徐州而幸免。','此事使曹操与汉室、与刘备的裂痕彻底公开化。','约公元200年'),
('dong-cheng-plot-uncovered','en','Dong Cheng’s secret plot is uncovered','The Records records General Dong Cheng’s conspiracy against Cao Cao, formed under a secret edict, being discovered and its members executed.','In 200, Dong Cheng and his fellow conspirators plotted to kill Cao Cao; the plot was uncovered and Cao Cao had Dong Cheng and his associates put to death along with their clans. Liu Bei, party to the plan, escaped because he was already away in Xu Province.','The affair made the breach between Cao Cao, the Han court, and Liu Bei fully open.','c. 200 CE'),
('cao-cao-captures-guan-yu-at-xiapi','zh-CN','曹操东征擒关羽','志载曹操乘刘备立足未稳东征徐州，破下邳，关羽被俘归降。','刘备杀徐州刺史车胄反曹，操亲率大军东征，刘备败走投袁绍，关羽守下邳兵败被俘，暂归曹操，操礼遇甚厚，拜偏将军。','关羽暂附曹营为其后官渡之役阵斩颜良埋下伏笔。','约公元200年'),
('cao-cao-captures-guan-yu-at-xiapi','en','Cao Cao captures Guan Yu at Xiapi','The Records records Cao Cao striking east at Liu Bei before his hold on Xu Province was secure, taking Xiapi and Guan Yu’s surrender.','After Liu Bei killed Cao Cao’s governor Che Zhou and turned against him, Cao Cao personally led an army east; Liu Bei fled to Yuan Shao while Guan Yu, defending Xiapi, was defeated and taken. Cao Cao treated him generously, naming him a subordinate general.','Guan Yu’s temporary service under Cao Cao set up his later killing of Yan Liang at Guandu.','c. 200 CE'),
('sun-ce-is-assassinated','zh-CN','孙策遇刺身亡','志载孙策为许贡门客所刺，重伤而亡，孙权继领江东。','孙策曾杀吴郡太守许贡，其门客伏于丹徒山中，乘策出猎行刺，策重伤，数日后卒，年二十六，遗命孙权继位。','孙策早逝使江东基业提前转入孙权之手，深刻影响此后孙吴的走向。','约公元200年'),
('sun-ce-is-assassinated','en','Sun Ce is assassinated','The Records records Sun Ce mortally wounded by retainers of Xu Gong and dying soon after, with Sun Quan succeeding him.','Having killed the governor Xu Gong, Sun Ce was ambushed by Xu Gong’s retainers while hunting near Danyu and gravely wounded; he died days later at twenty-six, leaving the succession to his brother Sun Quan.','Sun Ce’s early death passed the southeast’s holdings to Sun Quan far sooner than expected, shaping Wu’s later course.','c. 200 CE'),
('guan-yu-slays-yan-liang-at-baima','zh-CN','关羽白马斩颜良','志载关羽于万众之中策马刺杀袁绍大将颜良，解白马之围。','袁绍遣颜良攻白马，曹操遣张辽、关羽为前锋。关羽望见颜良麾盖，策马刺之于万众之中，斩其首而还，绍诸将莫能当。','此役是关羽武勇见载正史最直接的一笔，也报答了曹操此前的礼遇。','约公元200年'),
('guan-yu-slays-yan-liang-at-baima','en','Guan Yu kills Yan Liang at Baima','The Records records Guan Yu charging through the enemy host to kill Yuan Shao’s general Yan Liang, lifting the siege of Baima.','When Yuan Shao sent Yan Liang against Baima, Cao Cao sent Zhang Liao and Guan Yu ahead; spotting Yan Liang’s banner, Guan Yu charged through the massed enemy, killed him, and returned with his head, a feat none of Yuan Shao’s generals could answer.','The episode is the most direct record of Guan Yu’s valour in official history, and repaid Cao Cao’s earlier generosity.','c. 200 CE'),
('battle-of-guandu','zh-CN','官渡之战','志载曹操以寡敌众，纳许攸之策夜袭乌巢，大破袁绍于官渡。','建安五年，袁绍率大军十万进逼官渡，曹操兵少粮乏，几不能支。许攸自绍营来降，献计袭乌巢粮仓，操亲率精骑夜袭焚粮，绍军由是大溃。','官渡之战确立曹操统一北方的根本优势，是三国鼎立格局的关键起点。','约公元200年'),
('battle-of-guandu','en','The Battle of Guandu','The Records records Cao Cao, badly outnumbered, taking Xu You’s counsel to burn Yuan Shao’s grain at Wuchao and shattering his army at Guandu.','In 200, Yuan Shao advanced on Guandu with a hundred thousand men while Cao Cao, short of troops and supplies, could barely hold on. Xu You defected from Yuan Shao’s camp and revealed the Wuchao granary; Cao Cao personally led picked cavalry on a night raid that burned the grain, and Yuan Shao’s army collapsed.','Guandu secured Cao Cao’s decisive advantage in unifying the north and marks the key turning point toward the Three Kingdoms division.','c. 200 CE'),
('yuan-shaos-sons-fall-to-cao-cao','zh-CN','袁氏兄弟败亡与邺城陷落','志载袁绍败后忧愤而卒，其子袁谭、袁尚相争，曹操乘隙取邺城，尽定河北。','袁绍官渡败后忧惧成疾，建安七年卒。二子袁谭、袁尚为嗣位相攻，曹操乘乱各个击破，建安九年破邺城，审配死守城破被杀，袁谭亦于次年败亡。','袁氏兄弟阋墙使曹操得以从容并吞河北，完成对北方的实质统一。','约公元202–205年'),
('yuan-shaos-sons-fall-to-cao-cao','en','Yuan Shao’s sons fall to Cao Cao','The Records records Yuan Shao dying of grief after Guandu, his sons Yuan Tan and Yuan Shang fighting each other, and Cao Cao seizing Ye City amid the chaos.','Yuan Shao, broken by defeat at Guandu, died of illness in 202; his sons Yuan Tan and Yuan Shang fought over the succession, letting Cao Cao defeat them in turn. Ye City fell in 204, with Shen Pei killed defending it, and Yuan Tan was defeated the following year.','The brothers’ feud let Cao Cao absorb Hebei at his leisure, completing his effective unification of the north.','c. 202–205 CE'),
('cao-cao-campaigns-against-the-wuhuan','zh-CN','曹操远征乌桓','志载曹操北征乌桓于柳城大破之，郭嘉染疾道卒，河北余患自此肃清。','袁尚、袁熙败逃依附乌桓，建安十二年曹操从郭嘉之谋轻兵远征，于柳城大破乌桓，郭嘉于归途染疾而卒。二袁复奔辽东，为公孙康所杀，传首示操。','此役彻底清除袁氏残余势力，标志曹操对北方统一之最终完成。','约公元207年'),
('cao-cao-campaigns-against-the-wuhuan','en','Cao Cao campaigns against the Wuhuan','The Records records Cao Cao crushing the Wuhuan at Liucheng, though his advisor Guo Jia died of illness on the campaign.','When Yuan Shang and Yuan Xi fled to take refuge with the Wuhuan, Cao Cao in 207 followed Guo Jia’s counsel and marched swiftly to crush them at Liucheng; Guo Jia fell ill and died on the return journey. The two Yuan brothers fled on to Liaodong, where Gongsun Kang killed them and sent their heads to Cao Cao.','The campaign eliminated the last of the Yuan faction and marks the true completion of Cao Cao’s unification of the north.','c. 207 CE'),
('liu-bei-visits-zhuge-liang-at-longzhong','zh-CN','刘备三顾隆中','志载刘备屯兵新野，三往隆中求见诸葛亮，亮遂出佐之。','刘备依附刘表屯于新野，闻诸葛亮之名，三往其庐求见，亮为陈天下大势，遂许出仕。诸葛亮后于《出师表》自述"三顾臣于草庐之中"。','此事是刘备阵营由武人集团转向兼具战略谋划之始，为其后取荆益奠定基础。','约公元207年'),
('liu-bei-visits-zhuge-liang-at-longzhong','en','Liu Bei visits Zhuge Liang at Longzhong','The Records records Liu Bei, stationed at Xinye, calling three times at Longzhong before Zhuge Liang agreed to serve him.','Sheltering under Liu Biao at Xinye, Liu Bei heard of Zhuge Liang’s reputation and called at his cottage three times; Zhuge Liang laid out the realm’s strategic picture and agreed to serve. Zhuge Liang later recalled in his Memorial on the Expedition that Liu Bei "called on me three times in my thatched cottage."','The visit marked Liu Bei’s camp gaining genuine strategic direction beyond its martial strength, laying the ground for his later hold on Jing and Yi Provinces.','c. 207 CE')
) AS v(slug,locale,title,summary,detail,sig,tlabel) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000006';

-- Romance (演义), KK=04
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tlabel FROM events e JOIN (VALUES
('dong-cheng-plot-uncovered','zh-CN','董承衣带诏','小说叙写献帝藏诏于玉带，密授董承谋诛曹操，事泄身死。','献帝深恨曹操专权，密书血诏藏于玉带，授国舅董承，联络刘备、王子服等谋诛之。事为曹操察觉，董承等尽被诛杀，刘备幸因领兵在外得免。','衣带诏是小说中刘备"正统"抗曹立场的正式确立。','约公元200年'),
('dong-cheng-plot-uncovered','en','The sash edict of Dong Cheng','The novel dramatises Emperor Xian hiding a blood edict in a jade sash, entrusting Dong Cheng to organise Cao Cao’s assassination.','Resenting Cao Cao’s domination, Emperor Xian hid a secret edict written in blood inside a jade sash and gave it to his uncle Dong Cheng, who drew in Liu Bei and Wang Zifu. Cao Cao discovered the plot and had Dong Cheng’s circle executed; Liu Bei escaped only because he was already leading troops elsewhere.','The sash edict formally establishes Liu Bei’s position as the legitimate resistance to Cao Cao in the novel.','c. 200 CE'),
('cao-cao-captures-guan-yu-at-xiapi','zh-CN','曹操困下邳擒关羽','小说叙写刘备兵败投袁绍，关羽守下邳孤立无援，被围于土山之上。','刘备杀车胄事泄，曹操大军东征，刘备兵败投奔袁绍。关羽保护二嫂守下邳，粮尽援绝，被张辽说降于土山之上，暂居曹营。','此段为下一场"土山三约"与"挂印封金"的伏笔，塑造关羽忠义两全的形象。','约公元200年'),
('cao-cao-captures-guan-yu-at-xiapi','en','Cao Cao besieges Xiapi and takes Guan Yu','The novel dramatises Liu Bei’s defeat and flight to Yuan Shao, leaving Guan Yu isolated at Xiapi.','When Liu Bei’s killing of Che Zhou was discovered, Cao Cao marched east and Liu Bei fled defeated to Yuan Shao. Guan Yu, protecting Liu Bei’s two wives, held Xiapi until supplies ran out and was persuaded by Zhang Liao to accept terms atop Earth Mountain, lodging for a time in Cao Cao’s camp.','The episode sets up the following scenes of the three conditions and Guan Yu’s eventual departure, shaping his image as loyal to both lord and honour.','c. 200 CE'),
('sun-ce-is-assassinated','zh-CN','小霸王孙策之死','小说叙写孙策怒杀道士于吉，其后为许贡门客所伤，惊惧成疾而亡。','孙策因惑于人心，怒斩妖言惑众的道士于吉，其后屡见幻象，又猎中中许贡门客暗算，面部重伤，惊怒交加，临终以基业托付孙权。','孙策之死交织神怪渲染与史实，是小说江东叙事由攻取转向守成的转折。','约公元200年'),
('sun-ce-is-assassinated','en','The death of the Little Conqueror, Sun Ce','The novel dramatises Sun Ce killing the sorcerer Yu Ji in anger, then being struck down by Xu Gong’s retainers and dying of shock and rage.','Fearing Yu Ji’s hold over the people’s hearts, Sun Ce had the sorcerer executed, and was afterward haunted by visions of him; ambushed while hunting by Xu Gong’s retainers, he suffered grave wounds to the face and, overcome with fury, entrusted his holdings to Sun Quan before he died.','Sun Ce’s death weaves the supernatural into the historical record and turns the novel’s southeastern narrative from conquest to consolidation.','c. 200 CE'),
('guan-yu-slays-yan-liang-at-baima','zh-CN','关云长策马刺颜良','小说叙写关羽为报曹操之恩，于万军之中斩颜良、解白马之围。','曹操厚待关羽，欲试其能，遣与张辽同为前部解白马之围。关羽见颜良麾盖，跃马冲阵，手起刀落斩其首级而回，如入无人之境。','此役是关羽在小说中"武圣"形象确立的关键一役，也暗埋其终将辞归刘备的伏笔。','约公元200年'),
('guan-yu-slays-yan-liang-at-baima','en','Guan Yu charges to kill Yan Liang','The novel dramatises Guan Yu, repaying Cao Cao’s generosity, cutting down Yan Liang amid the massed enemy to relieve Baima.','Testing the man he had treated so well, Cao Cao sent Guan Yu forward with Zhang Liao to relieve Baima; spotting Yan Liang’s banner, Guan Yu charged through the enemy ranks as if through empty ground and returned with his head on his blade.','The feat is the key scene cementing Guan Yu’s image as the "Sage of War," while quietly foreshadowing his eventual return to Liu Bei.','c. 200 CE'),
('battle-of-guandu','zh-CN','官渡之战','小说敷演许攸弃绍投操，献乌巢之计，曹操亲率精骑火烧粮草，大破袁绍。','袁绍拥兵十倍围攻官渡，曹操粮尽将危。许攸因谋不用、家人获罪，连夜投奔曹操，献乌巢屯粮之秘。操诈作袁将蒋奇旗号夜袭乌巢，火光冲天，绍军军心尽失，一败涂地。','官渡一役是小说"以少胜多"的典范战例，奠定曹操统一北方之势。','约公元200年'),
('battle-of-guandu','en','The Battle of Guandu','The novel elaborates Xu You defecting from Yuan Shao to reveal the Wuchao granary, letting Cao Cao burn the grain and shatter Yuan Shao’s army.','With Yuan Shao’s tenfold host closing on Guandu, Cao Cao’s supplies were nearly spent. Xu You, his counsel ignored and his family disgraced, fled by night to Cao Cao with the secret of the Wuchao granary; disguised under a rival general’s banner, Cao Cao’s night raid set the grain ablaze, and Yuan Shao’s army collapsed in panic.','Guandu stands in the novel as the archetypal victory of the few over the many, founding Cao Cao’s dominance of the north.','c. 200 CE'),
('yuan-shaos-sons-fall-to-cao-cao','zh-CN','袁氏兄弟自相残杀','小说叙写袁绍病故，谭、尚二子因郭图、审配党争而自相攻伐，终为曹操所并。','袁绍忧愤呕血而亡，长子袁谭、幼子袁尚因废长立幼旧怨相攻不已，郭图、审配各为其主构陷对方党羽。曹操坐观其乱，先取邺城，审配死战城破被杀，后灭袁谭。','兄弟阋墙、朋党相争是小说对袁氏集团覆灭原因最直接的道德评判。','约公元202–205年'),
('yuan-shaos-sons-fall-to-cao-cao','en','Yuan Shao’s sons destroy each other','The novel narrates Yuan Shao dying of grief and rage, his sons Tan and Shang tearing each other apart in a feud stoked by rival advisors, until Cao Cao absorbed them both.','Yuan Shao died vomiting blood in his fury after Guandu; his elder son Yuan Tan and younger favourite Yuan Shang fought bitterly over the succession, with Guo Tu and Shen Pei each slandering the other’s faction. Cao Cao watched the chaos, took Ye City first as Shen Pei died defending it, then destroyed Yuan Tan.','The brothers’ feud and factional intrigue serve as the novel’s direct moral verdict on the Yuan house’s collapse.','c. 202–205 CE'),
('cao-cao-campaigns-against-the-wuhuan','zh-CN','曹操北征乌桓','小说叙写曹操轻兵冒险远征乌桓于柳城获胜，郭嘉临终遗计定辽东。','袁尚、袁熙投乌桓，曹操从郭嘉之议轻兵倍道而进，大破乌桓于柳城，郭嘉染疾先逝，临终遗书教操勿追二袁，公孙康自会杀之献首。','郭嘉遗计一节渲染其"鬼才"形象，也为北方统一画上句点。','约公元207年'),
('cao-cao-campaigns-against-the-wuhuan','en','Cao Cao’s northern campaign against the Wuhuan','The novel dramatises Cao Cao risking a swift, light-armed march to crush the Wuhuan at Liucheng, capped by Guo Jia’s dying strategy for Liaodong.','When Yuan Shang and Yuan Xi took refuge with the Wuhuan, Cao Cao followed Guo Jia’s counsel to force a swift march and broke the Wuhuan at Liucheng; Guo Jia fell ill and died before the return, leaving a letter advising Cao Cao not to pursue the Yuan brothers, since Gongsun Kang would kill them and send their heads unbidden.','Guo Jia’s posthumous scheme burnishes his reputation as an uncanny strategist and closes the arc of the north’s unification.','c. 207 CE'),
('liu-bei-visits-zhuge-liang-at-longzhong','zh-CN','三顾茅庐','小说敷演刘备三访隆中，诸葛亮以隆中对策纵论天下三分之势。','刘备两次访诸葛亮不遇，第三次冒雪再往，终得相见。诸葛亮为陈"隆中对"，析天下大势，劝其先取荆州、后图益州，以成鼎足之业。刘备大喜，遂拜为军师。','三顾茅庐与隆中对是小说中蜀汉立国方略的思想源头，也是刘备阵营命运的转折点。','约公元207年'),
('liu-bei-visits-zhuge-liang-at-longzhong','en','Three visits to the thatched cottage','The novel elaborates Liu Bei calling three times at Longzhong until Zhuge Liang lays out his strategy for a three-way division of the realm.','Twice Liu Bei found Zhuge Liang away from home; on the third visit, made through snow, they finally met. Zhuge Liang delivered his Longzhong strategy, analysing the realm and urging Liu Bei to take Jing Province first and Yi Province after, to found one leg of a three-way balance. Delighted, Liu Bei named him his strategist.','The three visits and the Longzhong strategy are the intellectual origin of Shu Han’s founding plan, and the turning point of Liu Bei’s fortunes.','c. 207 CE'),
('guan-yu-and-cao-cao-agree-to-three-conditions','zh-CN','土山三约','小说叙写关羽被困土山，与曹操约法三章而后暂降。','关羽兵败被困土山，张辽劝降。关羽提出三事：只降汉帝不降曹操、以俸禄奉养二嫂、一旦知刘备下落即当辞去，操皆应允，关羽方降。','三约之设使关羽降曹之举不失气节，是小说塑造其"义绝"形象的关键铺垫。','约公元200年'),
('guan-yu-and-cao-cao-agree-to-three-conditions','en','The three conditions atop Earth Mountain','The novel dramatises Guan Yu, besieged on Earth Mountain, agreeing to serve Cao Cao only under three conditions.','Trapped and defeated, Guan Yu was persuaded by Zhang Liao to consider surrender. He set three terms — that he submitted to the Han emperor and not to Cao Cao personally, that his lord’s two wives be properly maintained, and that he would leave the moment he learned Liu Bei’s whereabouts — and only when Cao Cao agreed did he accept.','The conditions let Guan Yu’s surrender preserve his honour, key groundwork for the novel’s portrait of him as the "paragon of loyalty."','c. 200 CE'),
('guan-yu-rides-a-thousand-li-alone','zh-CN','千里走单骑','小说叙写关羽挂印封金，护嫂寻兄，过五关斩六将千里独行。','关羽既知刘备下落，尽封曹操所赠金银，挂印告辞。曹操故意不见以拖延，关羽径自护送二嫂上路，沿途连过五关，斩杀六员拦截守将，终与刘备重逢。','此段千里独行是小说中最广为传颂的忠义传奇，塑造关羽"义薄云天"的顶点形象。','约公元200年'),
('guan-yu-rides-a-thousand-li-alone','en','Riding a thousand li alone','The novel dramatises Guan Yu sealing away Cao Cao’s gifts and setting out alone with his lord’s wives to find Liu Bei.','Once he learned Liu Bei’s whereabouts, Guan Yu sealed up every gift of gold Cao Cao had given him, hung up his seal, and took his leave; Cao Cao delayed granting an audience, so Guan Yu set off regardless, fighting through five passes and killing six generals who barred his way before reaching Liu Bei at last.','The lone thousand-li journey is the novel’s most celebrated legend of loyalty, the high point of Guan Yu’s image as boundless in honour.','c. 200 CE'),
('guan-yu-reunites-with-liu-bei-at-old-city','zh-CN','古城相会','小说叙写关羽历经艰险抵古城，张飞误会其变节，几经证明始得兄弟重聚。','关羽抵古城见张飞，飞疑其已降曹操变节，几欲挥刀相向。适逢曹将蔡阳追至，关羽出其不意斩之，张飞方信其忠，兄弟三人终得团聚。','古城相会以误会和解收束关羽归途，重塑桃园结义之情谊，为刘备阵营重新集结奠定基础。','约公元200年'),
('guan-yu-reunites-with-liu-bei-at-old-city','en','The reunion at the old walled town','The novel dramatises Guan Yu reaching the old town only to face Zhang Fei’s suspicion of betrayal before the brothers reconcile.','Arriving at the old town to find Zhang Fei, Guan Yu was met with fury, Zhang Fei suspecting he had turned traitor to Cao Cao and nearly striking him down. When Cao Cao’s general Cai Yang arrived in pursuit, Guan Yu cut him down without warning, at last convincing Zhang Fei of his loyalty, and the three sworn brothers were reunited.','The reconciliation closes Guan Yu’s journey home on a note of restored trust, remaking the Peach Garden bond and regathering Liu Bei’s camp.','c. 200 CE')
) AS v(slug,locale,title,summary,detail,sig,tlabel) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000007';

-- ============================================================
-- 6. EVENT-LOCATIONS
-- ============================================================

INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('wang-yun-and-lu-bu-kill-dong-zhuo','changan'),('li-jue-guo-si-sack-changan','changan'),
('cao-cao-campaigns-against-tao-qian','xuzhou'),('lu-bu-seizes-yanzhou','puyang'),
('tao-qian-cedes-xuzhou-to-liu-bei','xuzhou'),('emperor-xian-arrives-at-xuchang','xuchang'),
('yuan-shu-proclaims-himself-emperor','shouchun'),('cao-cao-defeats-lu-bu-at-xiapi','xiapi'),
('lu-bu-shoots-the-halberd-at-the-camp-gate','xiaopei'),('dian-wei-dies-defending-cao-cao-at-wancheng','wancheng'),
('cao-cao-and-liu-bei-discuss-heroes-over-wine','xuchang'),
('dong-cheng-plot-uncovered','xuchang'),('cao-cao-captures-guan-yu-at-xiapi','xiapi'),
('sun-ce-is-assassinated','jianye'),('yuan-shaos-sons-fall-to-cao-cao','yecheng'),
('liu-bei-visits-zhuge-liang-at-longzhong','longzhong'),
('guan-yu-and-cao-cao-agree-to-three-conditions','xiapi'),('guan-yu-rides-a-thousand-li-alone','xuchang'),
('guan-yu-reunites-with-liu-bei-at-old-city','changshe')
) AS v(event_slug,location_slug) ON e.slug=v.event_slug
JOIN locations l ON l.slug=v.location_slug AND l.work_id=e.work_id
WHERE e.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

-- guan-yu-slays-yan-liang-at-baima: primary Baima (new location)
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e
JOIN locations l ON l.slug='baima' AND l.work_id=e.work_id
WHERE e.slug='guan-yu-slays-yan-liang-at-baima'
  AND e.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

-- cao-cao-campaigns-against-the-wuhuan: primary Liucheng (new location)
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e
JOIN locations l ON l.slug='liucheng' AND l.work_id=e.work_id
WHERE e.slug='cao-cao-campaigns-against-the-wuhuan'
  AND e.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

-- battle-of-guandu: primary Guandu, secondary Wuchao (new location)
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e
JOIN locations l ON l.slug='guandu' AND l.work_id=e.work_id
WHERE e.slug='battle-of-guandu'
  AND e.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'secondary',1 FROM events e
JOIN locations l ON l.slug='wuchao' AND l.work_id=e.work_id
WHERE e.slug='battle-of-guandu'
  AND e.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 7. EVENT-CHARACTERS
-- ============================================================

INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('wang-yun-and-lu-bu-kill-dong-zhuo','wang-yun',0),('wang-yun-and-lu-bu-kill-dong-zhuo','lu-bu',1),('wang-yun-and-lu-bu-kill-dong-zhuo','dong-zhuo',2),
('li-jue-guo-si-sack-changan','emperor-xian',0),('li-jue-guo-si-sack-changan','wang-yun',1),
('cao-cao-campaigns-against-tao-qian','cao-cao',0),('cao-cao-campaigns-against-tao-qian','tao-qian',1),
('lu-bu-seizes-yanzhou','lu-bu',0),('lu-bu-seizes-yanzhou','cao-cao',1),
('tao-qian-cedes-xuzhou-to-liu-bei','tao-qian',0),('tao-qian-cedes-xuzhou-to-liu-bei','liu-bei',1),
('emperor-xian-arrives-at-xuchang','emperor-xian',0),('emperor-xian-arrives-at-xuchang','cao-cao',1),('emperor-xian-arrives-at-xuchang','xun-yu',2),
('yuan-shu-proclaims-himself-emperor','yuan-shu',0),
('cao-cao-defeats-lu-bu-at-xiapi','cao-cao',0),('cao-cao-defeats-lu-bu-at-xiapi','lu-bu',1),('cao-cao-defeats-lu-bu-at-xiapi','liu-bei',2),
('lu-bu-shoots-the-halberd-at-the-camp-gate','lu-bu',0),('lu-bu-shoots-the-halberd-at-the-camp-gate','liu-bei',1),
('dian-wei-dies-defending-cao-cao-at-wancheng','dian-wei',0),('dian-wei-dies-defending-cao-cao-at-wancheng','cao-cao',1),
('cao-cao-and-liu-bei-discuss-heroes-over-wine','cao-cao',0),('cao-cao-and-liu-bei-discuss-heroes-over-wine','liu-bei',1),
('dong-cheng-plot-uncovered','cao-cao',0),('dong-cheng-plot-uncovered','emperor-xian',1),
('cao-cao-captures-guan-yu-at-xiapi','cao-cao',0),('cao-cao-captures-guan-yu-at-xiapi','guan-yu',1),
('sun-ce-is-assassinated','sun-ce',0),('sun-ce-is-assassinated','sun-quan',1),
('guan-yu-slays-yan-liang-at-baima','guan-yu',0),('guan-yu-slays-yan-liang-at-baima','cao-cao',1),
('battle-of-guandu','cao-cao',0),('battle-of-guandu','yuan-shao',1),('battle-of-guandu','xu-you',2),
('yuan-shaos-sons-fall-to-cao-cao','yuan-shao',0),('yuan-shaos-sons-fall-to-cao-cao','cao-cao',1),('yuan-shaos-sons-fall-to-cao-cao','shen-pei',2),
('cao-cao-campaigns-against-the-wuhuan','cao-cao',0),('cao-cao-campaigns-against-the-wuhuan','guo-jia',1),
('liu-bei-visits-zhuge-liang-at-longzhong','liu-bei',0),('liu-bei-visits-zhuge-liang-at-longzhong','zhuge-liang',1),
('guan-yu-and-cao-cao-agree-to-three-conditions','guan-yu',0),('guan-yu-and-cao-cao-agree-to-three-conditions','cao-cao',1),
('guan-yu-rides-a-thousand-li-alone','guan-yu',0),
('guan-yu-reunites-with-liu-bei-at-old-city','guan-yu',0),('guan-yu-reunites-with-liu-bei-at-old-city','zhang-fei',1),('guan-yu-reunites-with-liu-bei-at-old-city','liu-bei',2)
) AS v(event_slug,char_slug,ord) ON e.slug=v.event_slug
JOIN characters c ON c.slug=v.char_slug AND c.work_id=e.work_id
WHERE e.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 8. EVENT-SOURCES (LIKE-prefix filtered by work)
-- ============================================================

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e
JOIN sources s ON s.work_id=e.work_id AND s.title LIKE 'Records of the Three Kingdoms%'
JOIN chapters ch ON ch.id=e.chapter_id AND ch.slug IN ('warlords-contending','guandu-and-the-north')
WHERE e.work_id='10000000-0000-4000-8000-000000000006'
  AND (e.id::text LIKE '64000000-0000-4000-8003%' OR e.id::text LIKE '64000000-0000-4000-8004%')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e
JOIN sources s ON s.work_id=e.work_id AND s.title LIKE 'Romance of the Three Kingdoms%'
JOIN chapters ch ON ch.id=e.chapter_id AND ch.slug IN ('warlords-contending','guandu-and-the-north')
WHERE e.work_id='10000000-0000-4000-8000-000000000007'
  AND (e.id::text LIKE '65000000-0000-4000-8003%' OR e.id::text LIKE '65000000-0000-4000-8004%')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 9. CHARACTER RELATIONS + relation_translations
-- ============================================================

-- KK=03 relations (13 per work)
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('74000000-0000-4000-8003-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'cao-cao','tao-qian','adversary','bidirectional','negative',4,'ended','cao-cao-campaigns-against-tao-qian','tao-qian-cedes-xuzhou-to-liu-bei'),
(2,'tao-qian','liu-bei','mentor','source_to_target','positive',4,'ended',NULL,'tao-qian-cedes-xuzhou-to-liu-bei'),
(3,'cao-cao','lu-bu','adversary','bidirectional','mixed',4,'ended','lu-bu-seizes-yanzhou','cao-cao-defeats-lu-bu-at-xiapi'),
(4,'wang-yun','lu-bu','ally','bidirectional','mixed',3,'ended','wang-yun-and-lu-bu-kill-dong-zhuo','li-jue-guo-si-sack-changan'),
(5,'wang-yun','dong-zhuo','adversary','bidirectional','negative',5,'ended',NULL,'wang-yun-and-lu-bu-kill-dong-zhuo'),
(6,'lu-bu','dong-zhuo','adversary','bidirectional','mixed',4,'ended',NULL,'wang-yun-and-lu-bu-kill-dong-zhuo'),
(7,'cao-cao','guo-jia','liege','source_to_target','positive',4,'active',NULL,NULL),
(8,'cao-cao','xun-yu','liege','source_to_target','positive',5,'active',NULL,NULL),
(9,'cao-cao','zhang-liao','liege','source_to_target','positive',3,'active','cao-cao-defeats-lu-bu-at-xiapi',NULL),
(10,'cao-cao','xiahou-dun','family','bidirectional','positive',5,'active',NULL,NULL),
(11,'cao-cao','dian-wei','liege','source_to_target','positive',4,'ended',NULL,NULL),
(12,'yuan-shu','lu-bu','adversary','bidirectional','mixed',3,'active',NULL,NULL),
(13,'yuan-shu','liu-bei','adversary','bidirectional','negative',3,'active',NULL,NULL)
) AS v(n,from_slug,to_slug,rtype,dir,sentiment,strength,rstatus,start_slug,end_slug)
JOIN characters fc ON fc.slug=v.from_slug AND fc.work_id='10000000-0000-4000-8000-000000000006'
JOIN characters tc ON tc.slug=v.to_slug AND tc.work_id=fc.work_id
LEFT JOIN events se ON se.slug=v.start_slug AND se.work_id=fc.work_id
LEFT JOIN events ee ON ee.slug=v.end_slug AND ee.work_id=fc.work_id
ON CONFLICT DO NOTHING;

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('75000000-0000-4000-8003-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'cao-cao','tao-qian','adversary','bidirectional','negative',4,'ended','cao-cao-campaigns-against-tao-qian','tao-qian-cedes-xuzhou-to-liu-bei'),
(2,'tao-qian','liu-bei','mentor','source_to_target','positive',4,'ended',NULL,'tao-qian-cedes-xuzhou-to-liu-bei'),
(3,'cao-cao','lu-bu','adversary','bidirectional','mixed',4,'ended','lu-bu-seizes-yanzhou','cao-cao-defeats-lu-bu-at-xiapi'),
(4,'wang-yun','lu-bu','ally','bidirectional','mixed',3,'ended','wang-yun-and-lu-bu-kill-dong-zhuo','li-jue-guo-si-sack-changan'),
(5,'wang-yun','dong-zhuo','adversary','bidirectional','negative',5,'ended',NULL,'wang-yun-and-lu-bu-kill-dong-zhuo'),
(6,'lu-bu','dong-zhuo','adversary','bidirectional','mixed',4,'ended',NULL,'wang-yun-and-lu-bu-kill-dong-zhuo'),
(7,'cao-cao','guo-jia','liege','source_to_target','positive',4,'active',NULL,NULL),
(8,'cao-cao','xun-yu','liege','source_to_target','positive',5,'active',NULL,NULL),
(9,'cao-cao','zhang-liao','liege','source_to_target','positive',3,'active','cao-cao-defeats-lu-bu-at-xiapi',NULL),
(10,'cao-cao','xiahou-dun','family','bidirectional','positive',5,'active',NULL,NULL),
(11,'cao-cao','dian-wei','liege','source_to_target','positive',4,'ended',NULL,'dian-wei-dies-defending-cao-cao-at-wancheng'),
(12,'yuan-shu','lu-bu','adversary','bidirectional','mixed',3,'active',NULL,NULL),
(13,'yuan-shu','liu-bei','adversary','bidirectional','negative',3,'active',NULL,NULL)
) AS v(n,from_slug,to_slug,rtype,dir,sentiment,strength,rstatus,start_slug,end_slug)
JOIN characters fc ON fc.slug=v.from_slug AND fc.work_id='10000000-0000-4000-8000-000000000007'
JOIN characters tc ON tc.slug=v.to_slug AND tc.work_id=fc.work_id
LEFT JOIN events se ON se.slug=v.start_slug AND se.work_id=fc.work_id
LEFT JOIN events ee ON ee.slug=v.end_slug AND ee.work_id=fc.work_id
ON CONFLICT DO NOTHING;

-- KK=04 relations (12 per work)
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('74000000-0000-4000-8004-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'cao-cao','guan-yu','liege','source_to_target','mixed',4,'ended','cao-cao-captures-guan-yu-at-xiapi',NULL),
(2,'cao-cao','xu-you','liege','source_to_target','positive',3,'active','battle-of-guandu',NULL),
(3,'cao-cao','zhang-he','liege','source_to_target','positive',3,'active','battle-of-guandu',NULL),
(4,'yuan-shao','ju-shou','liege','source_to_target','mixed',3,'changed',NULL,'battle-of-guandu'),
(5,'yuan-shao','shen-pei','liege','source_to_target','positive',4,'ended',NULL,'yuan-shaos-sons-fall-to-cao-cao'),
(6,'yuan-shao','guo-tu','liege','source_to_target','mixed',2,'active',NULL,NULL),
(7,'zhuge-liang','liu-bei','mentor','source_to_target','positive',5,'active','liu-bei-visits-zhuge-liang-at-longzhong',NULL),
(8,'liu-bei','zhao-yun','ally','bidirectional','positive',5,'active',NULL,NULL),
(9,'cao-cao','liu-biao','adversary','bidirectional','mixed',2,'active',NULL,NULL),
(10,'yuan-shao','cao-cao','adversary','bidirectional','negative',5,'ended','battle-of-guandu','yuan-shaos-sons-fall-to-cao-cao'),
(11,'sun-quan','sun-ce','family','bidirectional','positive',5,'ended',NULL,'sun-ce-is-assassinated'),
(12,'xu-shu','liu-bei','mentor','source_to_target','positive',4,'ended',NULL,'liu-bei-visits-zhuge-liang-at-longzhong')
) AS v(n,from_slug,to_slug,rtype,dir,sentiment,strength,rstatus,start_slug,end_slug)
JOIN characters fc ON fc.slug=v.from_slug AND fc.work_id='10000000-0000-4000-8000-000000000006'
JOIN characters tc ON tc.slug=v.to_slug AND tc.work_id=fc.work_id
LEFT JOIN events se ON se.slug=v.start_slug AND se.work_id=fc.work_id
LEFT JOIN events ee ON ee.slug=v.end_slug AND ee.work_id=fc.work_id
ON CONFLICT DO NOTHING;

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('75000000-0000-4000-8004-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'cao-cao','guan-yu','liege','source_to_target','mixed',4,'ended','cao-cao-captures-guan-yu-at-xiapi','guan-yu-rides-a-thousand-li-alone'),
(2,'cao-cao','xu-you','liege','source_to_target','positive',3,'active','battle-of-guandu',NULL),
(3,'cao-cao','zhang-he','liege','source_to_target','positive',3,'active','battle-of-guandu',NULL),
(4,'yuan-shao','ju-shou','liege','source_to_target','mixed',3,'changed',NULL,'battle-of-guandu'),
(5,'yuan-shao','shen-pei','liege','source_to_target','positive',4,'ended',NULL,'yuan-shaos-sons-fall-to-cao-cao'),
(6,'yuan-shao','guo-tu','liege','source_to_target','mixed',2,'active',NULL,NULL),
(7,'zhuge-liang','liu-bei','mentor','source_to_target','positive',5,'active','liu-bei-visits-zhuge-liang-at-longzhong',NULL),
(8,'liu-bei','zhao-yun','ally','bidirectional','positive',5,'active',NULL,NULL),
(9,'cao-cao','liu-biao','adversary','bidirectional','mixed',2,'active',NULL,NULL),
(10,'yuan-shao','cao-cao','adversary','bidirectional','negative',5,'ended','battle-of-guandu','yuan-shaos-sons-fall-to-cao-cao'),
(11,'sun-quan','sun-ce','family','bidirectional','positive',5,'ended',NULL,'sun-ce-is-assassinated'),
(12,'xu-shu','liu-bei','mentor','source_to_target','positive',4,'ended',NULL,'liu-bei-visits-zhuge-liang-at-longzhong')
) AS v(n,from_slug,to_slug,rtype,dir,sentiment,strength,rstatus,start_slug,end_slug)
JOIN characters fc ON fc.slug=v.from_slug AND fc.work_id='10000000-0000-4000-8000-000000000007'
JOIN characters tc ON tc.slug=v.to_slug AND tc.work_id=fc.work_id
LEFT JOIN events se ON se.slug=v.start_slug AND se.work_id=fc.work_id
LEFT JOIN events ee ON ee.slug=v.end_slug AND ee.work_id=fc.work_id
ON CONFLICT DO NOTHING;

-- relation_translations — KK=03 and KK=04, both works in one pass by (from,to) slug pair.
INSERT INTO relation_translations(relation_id,locale,label,summary,status)
SELECT r.id,v.locale::locale_code,v.label,v.summary,'published'
FROM character_relations r
JOIN characters fc ON fc.id=r.from_character_id
JOIN characters tc ON tc.id=r.to_character_id
JOIN (VALUES
('cao-cao','tao-qian','zh-CN','复仇对手','曹操因父仇兴兵徐州，与陶谦结为死敌。'),
('cao-cao','tao-qian','en','Vengeance and adversary','Cao Cao made war on Xu Province to avenge his father, becoming Tao Qian’s mortal enemy.'),
('tao-qian','liu-bei','zh-CN','让贤托付','陶谦感刘备解围之恩，临终以徐州相托。'),
('tao-qian','liu-bei','en','Bequest of trust','Grateful for his rescue, the dying Tao Qian entrusted Xu Province to Liu Bei.'),
('cao-cao','lu-bu','zh-CN','争夺兖州','吕布袭取兖州与曹操反复争战，终败亡于下邳。'),
('cao-cao','lu-bu','en','Rivals for Yan Province','Lü Bu seized Yan Province from Cao Cao and fought him repeatedly, ending in defeat at Xiapi.'),
('wang-yun','lu-bu','zh-CN','同谋诛董','王允结吕布为内应，共谋诛杀董卓。'),
('wang-yun','lu-bu','en','Co-conspirators','Wang Yun won Lü Bu as his inside agent in the plot to kill Dong Zhuo.'),
('wang-yun','dong-zhuo','zh-CN','朝臣与权奸','王允身为汉臣，暗谋诛除专权的董卓。'),
('wang-yun','dong-zhuo','en','Courtier and tyrant','A loyal Han minister, Wang Yun secretly plotted to remove the overbearing Dong Zhuo.'),
('lu-bu','dong-zhuo','zh-CN','义子弑父','吕布本为董卓义子，终因猜忌与美色反目，手刃其父。'),
('lu-bu','dong-zhuo','en','Foster son turned killer','Once Dong Zhuo’s adopted son, Lü Bu turned on him amid suspicion and rivalry over a woman, killing him with his own hand.'),
('cao-cao','guo-jia','zh-CN','主臣（军师）','郭嘉为曹操军师祭酒，屡出奇策深受倚重。'),
('cao-cao','guo-jia','en','Lord and strategist','Guo Jia served as Cao Cao’s chief strategist, his counsel repeatedly trusted and acted upon.'),
('cao-cao','xun-yu','zh-CN','主臣（谋主）','荀彧献策迎天子都许，为曹操倚重的谋主。'),
('cao-cao','xun-yu','en','Lord and chief advisor','Xun Yu’s plan to receive the emperor at Xu made him one of Cao Cao’s most trusted counsellors.'),
('cao-cao','zhang-liao','zh-CN','主臣（降将）','张辽本吕布部将，下邳城破后降曹，此后为魏效力。'),
('cao-cao','zhang-liao','en','Lord and surrendered general','Once Lü Bu’s officer, Zhang Liao surrendered to Cao Cao after Xiapi fell and served Wei thereafter.'),
('cao-cao','xiahou-dun','zh-CN','宗族兄弟','夏侯惇为曹操从弟，随其转战多年。'),
('cao-cao','xiahou-dun','en','Clan kinsmen','Xiahou Dun, Cao Cao’s cousin, campaigned at his side for years.'),
('cao-cao','dian-wei','zh-CN','主臣（护卫）','典韦为曹操帐前护卫，宛城之变力战身死。'),
('cao-cao','dian-wei','en','Lord and bodyguard','Dian Wei served as Cao Cao’s personal guard, dying in his defence during the Wancheng crisis.'),
('yuan-shu','lu-bu','zh-CN','联姻反目','袁术曾议与吕布结亲，旋因猜忌反目成仇。'),
('yuan-shu','lu-bu','en','Marriage alliance turned hostile','Yuan Shu once proposed a marriage tie with Lü Bu, only for mutual suspicion to turn them into enemies.'),
('yuan-shu','liu-bei','zh-CN','争夺徐淮','袁术屡遣兵攻刘备，双方在徐、淮一带反复交锋。'),
('yuan-shu','liu-bei','en','Rivals over Xu and Huai','Yuan Shu repeatedly sent troops against Liu Bei, the two clashing across the Xu-Huai region.'),
('cao-cao','guan-yu','zh-CN','礼遇与恩义','关羽兵败暂归曹营，操礼遇甚厚，然终不能挽留其去意。'),
('cao-cao','guan-yu','en','Generosity and honour-bound loyalty','Cao Cao treated the captured Guan Yu with great generosity, yet could not keep him from leaving once his mind was set.'),
('cao-cao','xu-you','zh-CN','纳降献策','许攸弃绍投操，献乌巢之计促成官渡大胜。'),
('cao-cao','xu-you','en','Defector and strategist','Xu You defected to Cao Cao and revealed the Wuchao granary, enabling the victory at Guandu.'),
('cao-cao','zhang-he','zh-CN','阵前来降','张郃于官渡阵前降操，此后成为魏之名将。'),
('cao-cao','zhang-he','en','Battlefield defector','Zhang He surrendered to Cao Cao during the Guandu campaign and became one of Wei’s renowned generals.'),
('yuan-shao','ju-shou','zh-CN','谏而不用','沮授屡谏袁绍持重缓攻，皆不见用，终致官渡之败。'),
('yuan-shao','ju-shou','en','Counsel ignored','Ju Shou repeatedly urged Yuan Shao toward caution, advice that went unheeded and led to defeat at Guandu.'),
('yuan-shao','shen-pei','zh-CN','主臣（死守）','审配为袁绍谋臣，绍死后仍拥戴其子，死守邺城不降。'),
('yuan-shao','shen-pei','en','Lord and loyal defender','Shen Pei served Yuan Shao and remained loyal to his sons after his death, holding Ye City to the end.'),
('yuan-shao','guo-tu','zh-CN','主臣（谋士）','郭图为袁绍谋士，然屡进谗言加剧内部倾轧。'),
('yuan-shao','guo-tu','en','Lord and advisor','Guo Tu advised Yuan Shao, though his slander deepened the faction’s internal strife.'),
('zhuge-liang','liu-bei','zh-CN','师友之交','诸葛亮受三顾之诚出山辅佐，为刘备定隆中之策。'),
('zhuge-liang','liu-bei','en','Mentor and lord','Moved by three visits, Zhuge Liang left seclusion to serve Liu Bei, laying out the Longzhong strategy.'),
('liu-bei','zhao-yun','zh-CN','主从相随','赵云此时正式随事刘备，此后忠勇护主始终不渝。'),
('liu-bei','zhao-yun','en','Lord and steadfast retainer','Zhao Yun formally entered Liu Bei’s service in this period, remaining unwaveringly loyal thereafter.'),
('cao-cao','liu-biao','zh-CN','南北对峙','刘表坐拥荆襄保境自守，与曹操长期未战而互相提防。'),
('cao-cao','liu-biao','en','Wary rivals','Liu Biao held Jing Province in cautious self-defence, watching Cao Cao warily without open war.'),
('yuan-shao','cao-cao','zh-CN','河北对决','袁绍与曹操会战官渡，是汉末规模最大的一场决战。'),
('yuan-shao','cao-cao','en','The Hebei showdown','Yuan Shao and Cao Cao met in battle at Guandu, the largest decisive engagement of the late Han.'),
('sun-quan','sun-ce','zh-CN','兄终弟及','孙策遇刺身亡，遗命孙权继掌江东基业。'),
('sun-quan','sun-ce','en','Brother succeeds brother','After Sun Ce’s assassination, he entrusted the southeast’s holdings to his brother Sun Quan.'),
('xu-shu','liu-bei','zh-CN','荐贤而别','徐庶因母被曹操赚去，辞别刘备时力荐诸葛亮出山相助。'),
('xu-shu','liu-bei','en','Parting recommendation','Lured away when his mother was taken by Cao Cao, Xu Shu recommended Zhuge Liang to Liu Bei before he left.')
) AS v(from_slug,to_slug,locale,label,summary)
  ON fc.slug=v.from_slug AND tc.slug=v.to_slug
WHERE (r.id::text LIKE '74000000-0000-4000-8003%' OR r.id::text LIKE '75000000-0000-4000-8003%'
    OR r.id::text LIKE '74000000-0000-4000-8004%' OR r.id::text LIKE '75000000-0000-4000-8004%')
ON CONFLICT (relation_id,locale) DO NOTHING;

-- ============================================================
-- 10. GROUP MEMBERSHIP (existing 14 groups from seed 031)
-- ============================================================

INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g
JOIN characters c ON c.work_id=g.work_id
JOIN (VALUES
('wei-strategists','guo-jia'),
('wei-strategists','xun-yu'),
('house-of-cao','zhang-liao'),
('house-of-cao','xiahou-dun'),
('house-of-cao','dian-wei'),
('han-court','tao-qian'),
('hebei-faction','xu-you'),
('hebei-faction','zhang-he'),
('hebei-faction','ju-shou'),
('hebei-faction','shen-pei'),
('hebei-faction','guo-tu'),
('jing-province-circle','liu-biao')
) AS v(group_slug,char_slug) ON g.slug=v.group_slug AND c.slug=v.char_slug
WHERE g.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

COMMIT;
