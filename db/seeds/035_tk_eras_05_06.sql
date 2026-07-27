BEGIN;

-- =========================================================================
-- 035_tk_eras_05_06.sql
-- Three Kingdoms content seed for KK=05 'red-cliffs' (208-209) and
-- KK=06 'three-spheres-forming' (209-218), Records (志) + Romance (演义).
-- Structure/skeleton already loaded by 031 (works/chapters/groups/sources)
-- and 032 (anchor cast + gazetteer). This file adds era-scoped secondary
-- characters, minor locations, events, event links, and character
-- relations for both works, per blueprint/WORK_TEMPLATE.md structure and
-- blueprint/EXAMPLE_THREE_KINGDOMS.md content decisions.
--
-- UUID namespace used here (new, unused before this seed):
--   characters (secondary)  4{6|7}000000-0000-4000-80KK-############
--   locations (minor)       3{6|7}000000-0000-4000-80KK-############
--   events                  6{4|5}000000-0000-4000-80KK-############
--   character_relations     7{4|5}000000-0000-4000-80KK-############
-- (46/47 = Records/Romance secondary characters; 36/37 = Records/Romance
--  minor locations; 64/65 = Records/Romance events; 74/75 = Records/Romance
--  relations; KK = 05 or 06, matching the era each row belongs to)
--
-- Works: Records = 10000000-0000-4000-8000-000000000006
--        Romance = 10000000-0000-4000-8000-000000000007
--
-- Cast/location budget notes (documented per the brief's caps):
--  - Secondary characters, Records: huang-gai, pang-tong, fa-zheng, liu-zhang,
--    ma-chao, huang-zhong (6, at cap). Romance: the same six plus jiang-gan
--    (Romance-only, 7 total) -- the brief names jiang-gan as an explicit
--    exception to the per-work cap, matching the diaochan precedent in 032.
--  - Minor locations, Records: changban, huarong-road, luocheng (3, at cap).
--    Romance: changban, huarong-road, luofeng-slope (3, at cap) -- Romance
--    substitutes the legendary luofeng-slope for luocheng because Pang
--    Tong's death is told at a different (invented) site in the novel; see
--    the guan-yu-slays-hua-xiong precedent in EXAMPLE_THREE_KINGDOMS.md for
--    same-figure, different-slug divergence between the two works.
--  - liu-zhang has no fitting character_group among the 14 skeleton groups
--    (he is an absorbed independent warlord, not part of any modelled
--    faction); left without membership rather than mis-categorised.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS (secondary, era-scoped)
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
-- Records (志)
('46000000-0000-4000-8005-000000000001','10000000-0000-4000-8000-000000000006','huang-gai',501,'male','adult','supporting','historical',NULL,NULL,'soldier',3),
('46000000-0000-4000-8006-000000000001','10000000-0000-4000-8000-000000000006','pang-tong',601,'male','adult','supporting','historical',179,214,'teacher',3),
('46000000-0000-4000-8006-000000000002','10000000-0000-4000-8000-000000000006','fa-zheng',602,'male','adult','supporting','historical',176,220,'teacher',3),
('46000000-0000-4000-8006-000000000003','10000000-0000-4000-8000-000000000006','liu-zhang',603,'male','adult','supporting','historical',NULL,219,'ruler',2),
('46000000-0000-4000-8006-000000000004','10000000-0000-4000-8000-000000000006','ma-chao',604,'male','adult','supporting','historical',176,222,'soldier',3),
('46000000-0000-4000-8006-000000000005','10000000-0000-4000-8000-000000000006','huang-zhong',605,'male','elder','supporting','historical',NULL,220,'soldier',3),
-- Romance (演义) -- same six, plus jiang-gan (Romance-only)
('47000000-0000-4000-8005-000000000001','10000000-0000-4000-8000-000000000007','huang-gai',501,'male','adult','supporting','fictionalised_historical',NULL,NULL,'soldier',3),
('47000000-0000-4000-8005-000000000002','10000000-0000-4000-8000-000000000007','jiang-gan',502,'male','adult','supporting','fictionalised_historical',NULL,NULL,'person',2),
('47000000-0000-4000-8006-000000000001','10000000-0000-4000-8000-000000000007','pang-tong',601,'male','adult','supporting','fictionalised_historical',179,214,'teacher',3),
('47000000-0000-4000-8006-000000000002','10000000-0000-4000-8000-000000000007','fa-zheng',602,'male','adult','supporting','fictionalised_historical',176,220,'teacher',3),
('47000000-0000-4000-8006-000000000003','10000000-0000-4000-8000-000000000007','liu-zhang',603,'male','adult','supporting','fictionalised_historical',NULL,219,'ruler',2),
('47000000-0000-4000-8006-000000000004','10000000-0000-4000-8000-000000000007','ma-chao',604,'male','adult','supporting','fictionalised_historical',176,222,'soldier',3),
('47000000-0000-4000-8006-000000000005','10000000-0000-4000-8000-000000000007','huang-zhong',605,'male','elder','supporting','fictionalised_historical',NULL,220,'soldier',3);

-- Records (志) -- 志载/传称 voice.
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('huang-gai','zh-CN','黄盖','吴偏将军，庐江人，历事孙坚、孙策、孙权三世，以严明善抚军民著称。',ARRAY['公覆']::text[],'建安十三年随周瑜拒曹于赤壁，献诈降之计，以火攻大破曹军水寨。','忠事孙氏三代，欲以奇计挫强敌。'),
('huang-gai','en','Huang Gai','A Wu general from Lujiang who served three generations of the Sun family and was known for firm, capable command.',ARRAY['Gongfu']::text[],'In 208 he joined Zhou Yu in resisting Cao Cao at Red Cliffs, proposing the feigned-surrender fire attack that broke the northern fleet.','Loyalty to three generations of the Sun house and a resolve to defeat a stronger enemy by stratagem.'),
('pang-tong','zh-CN','庞统','蜀汉军师中郎将，襄阳人，与诸葛亮齐名，时人称为凤雏。',ARRAY['士元','凤雏']::text[],'建安十六年随先主入益州，献策助取蜀地，十九年围雒城时中流矢而卒。','辅佐明主，成就大业。'),
('pang-tong','en','Pang Tong','A military adviser of Shu Han from Xiangyang, ranked alongside Zhuge Liang and known as the Young Phoenix.',ARRAY['Shiyuan','Young Phoenix']::text[],'He accompanied Liu Bei into Yi Province in 211 and was killed by a stray arrow while besieging Luo in 214.','To serve a capable lord and help him secure a realm.'),
('fa-zheng','zh-CN','法正','蜀汉尚书令，扶风郿人，先事刘璋，后为先主主要谋主。',ARRAY['孝直']::text[],'暗劝先主取蜀，又力主进兵汉中，建安二十四年定军山之役其谋居多。','择明主而事之，欲展其谋略。'),
('fa-zheng','en','Fa Zheng','Chancellor of the Secretariat under Shu Han, a native of Mei in Fufeng who first served Liu Zhang before becoming Liu Bei’s chief strategist.',ARRAY['Xiaozhi']::text[],'He privately urged Liu Bei to take Yi Province and later pressed the campaign into Hanzhong, his counsel central to the 219 victory at Mount Dingjun.','To find a worthy lord and put his strategic gifts to use.'),
('liu-zhang','zh-CN','刘璋','益州牧，江夏竟陵人，刘焉之子，暗弱少断，建安十九年降于先主。',ARRAY['季玉']::text[],'延先主入蜀御张鲁，后先主反噬，围成都逾年，璋终开城出降。','欲借外力自保益州。'),
('liu-zhang','en','Liu Zhang','Governor of Yi Province, a native of Jingling in Jiangxia and son of Liu Yan, remembered as weak and indecisive; he surrendered to Liu Bei in 214.',ARRAY['Jiyu']::text[],'He invited Liu Bei into Shu to guard against Zhang Lu, only to see his guest turn against him and besiege Chengdu for over a year before he opened the gates.','To secure Yi Province by borrowing an outside general’s strength.'),
('ma-chao','zh-CN','马超','蜀汉骠骑将军，扶风茂陵人，马腾之子，早年据凉州抗曹，后归先主。',ARRAY['孟起']::text[],'建安十六年与韩遂等联兵抗曹，兵败奔汉中，十九年阵前促降刘璋，遂为先主所用。','为父报仇、保据凉州，兵败后转投能容己者。'),
('ma-chao','en','Ma Chao','General of Chariots and Cavalry under Shu Han, a native of Maoling in Fufeng and son of Ma Teng, who first held Liangzhou against Cao Cao before joining Liu Bei.',ARRAY['Mengqi']::text[],'Defeated alongside Han Sui in 211, he fled toward Hanzhong, and in 214 his arrival before Chengdu helped push Liu Zhang to surrender, after which he entered Liu Bei’s service.','To avenge his father and hold Liangzhou, and after defeat to find a lord who would still receive him.'),
('huang-zhong','zh-CN','黄忠','蜀汉后将军，南阳人，老而弥壮，弓马绝伦。',ARRAY['汉升']::text[],'建安十六年随先主入蜀有功，二十四年定军山一役阵斩夏侯渊，威震汉中。','虽年高而不甘居人后，欲建殊功。'),
('huang-zhong','en','Huang Zhong','General of the Rear under Shu Han, a native of Nanyang renowned in old age for his archery and horsemanship.',ARRAY['Hansheng']::text[],'He distinguished himself in the 211 campaign into Yi Province, and in 219 struck down Xiahou Yuan at Mount Dingjun, a feat that shook Hanzhong.','Though advanced in years, a refusal to be counted behind younger men, and a wish to win real distinction.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000006';

-- Romance (演义) -- 小说叙写 voice. jiang-gan is Romance-only.
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('huang-gai','zh-CN','黄盖','江东三世老臣，赤壁之战献苦肉计，甘受重刑以取曹操之信。',ARRAY['公覆']::text[],'与周瑜合演苦肉计，诈降曹操，驾火船直冲曹军连环战舰，一战功成。','甘为破敌大局忍辱负重。'),
('huang-gai','en','Huang Gai','A veteran of three generations in the southeast, who endured a staged flogging at Red Cliffs to win Cao Cao’s trust.',ARRAY['Gongfu']::text[],'Acting out the ruse of punishment with Zhou Yu, he feigned surrender and then drove blazing ships straight into Cao Cao’s chained fleet.','Willing to suffer humiliation for the sake of victory.'),
('pang-tong','zh-CN','庞统','道号凤雏先生，才具不亚卧龙，然貌陋见轻于世。',ARRAY['士元','凤雏']::text[],'曾献连环计促成赤壁大捷，后随先主入川，进围雒城时于落凤坡中箭殒命。','欲展平生所学，不甘久居人下。'),
('pang-tong','en','Pang Tong','Styled the Young Phoenix, a talent said to rival the Sleeping Dragon, though his plain looks led many to underestimate him.',ARRAY['Shiyuan','Young Phoenix']::text[],'He is credited with the chained-ships stratagem that helped win Red Cliffs, and later died struck by arrows at Fallen Phoenix Slope while advancing on Luo.','A wish to prove his gifts and no longer stand in another’s shadow.'),
('fa-zheng','zh-CN','法正','先主入川后最倚重的谋主，识见过人，然睚眦必报。',ARRAY['孝直']::text[],'暗附先主、献策取蜀，又力促汉中之役，深得先主信重。','欲择真主而事，一展胸中韬略。'),
('fa-zheng','en','Fa Zheng','The strategist Liu Bei came to trust most in Shu, sharp-eyed in counsel though quick to settle old scores.',ARRAY['Xiaozhi']::text[],'He secretly aligned with Liu Bei, urged the taking of Yi Province, and pressed the Hanzhong campaign, earning deep confidence in return.','To find a true lord worthy of his strategy.'),
('liu-zhang','zh-CN','刘璋','益州牧，性柔懦，误信张松、法正之言而请刘备入川，终自食其果。',ARRAY['季玉']::text[],'刘备反客为主，兴兵围成都逾年，璋不忍生灵涂炭，终开城出降。','欲借刘备之力拒张鲁，反招引狼入室。'),
('liu-zhang','en','Liu Zhang','The soft-hearted governor of Yi Province, who trusted Zhang Song and Fa Zheng’s counsel to invite Liu Bei in, only to reap the consequences.',ARRAY['Jiyu']::text[],'Liu Bei turned host into master, besieging Chengdu for over a year until Liu Zhang, unwilling to see more suffering, opened the gates.','To borrow Liu Bei’s strength against Zhang Lu, unaware he was inviting a wolf inside.'),
('ma-chao','zh-CN','马超','锦马超，白袍银甲，勇冠西凉，与张飞葭萌关一夜大战不分胜负。',ARRAY['孟起']::text[],'兵败后走投无路，经诸葛亮设计招揽，兵临成都城下促刘璋出降，遂归刘备帐下。','为父兄复仇，兵败后寻明主以安身立命。'),
('ma-chao','en','Ma Chao','Known as the Brocade Ma Chao, clad in silver armor, foremost in valor from the western marches, who once dueled Zhang Fei through a night at Jiameng Pass without either side prevailing.',ARRAY['Mengqi']::text[],'Defeated and with nowhere to turn, he was won over through Zhuge Liang’s design, and his arrival before Chengdu helped push Liu Zhang to surrender, after which he joined Liu Bei.','To avenge his father and brothers, then to find a worthy lord after defeat.'),
('huang-zhong','zh-CN','黄忠','老将黄忠，须发皆白而弓马益壮，与关羽长沙城下大战不分胜负。',ARRAY['汉升']::text[],'随先主入川屡建战功，定军山一役刀劈夏侯渊，位列五虎上将。','不服老，欲以实绩证明宝刀未老。'),
('huang-zhong','en','Huang Zhong','The veteran general Huang Zhong, white-haired yet ever sharper with bow and blade, who once fought Guan Yu to a standstill beneath the walls of Changsha.',ARRAY['Hansheng']::text[],'He won repeated victories in the campaign into Shu and cut down Xiahou Yuan at Mount Dingjun, earning a place among the Five Tiger Generals.','A refusal to be counted old, proven by feats rather than words.'),
('jiang-gan','zh-CN','蒋干','九江人，曹操帐下幕宾，素与周瑜同窗交好。',ARRAY['子翼']::text[],'奉曹操之命过江说降周瑜，反被将计就计，盗得伪造降书，致蔡瑁、张允枉死。','欲凭旧交说动周瑜，为曹操立功。'),
('jiang-gan','en','Jiang Gan','A native of Jiujiang serving as a guest adviser in Cao Cao’s camp, an old schoolfellow of Zhou Yu.',ARRAY['Ziyi']::text[],'Sent across the river to persuade Zhou Yu to surrender, he was instead outmaneuvered into stealing a forged letter that led Cao Cao to execute his own naval commanders.','To use an old friendship to win Zhou Yu over and earn credit with Cao Cao.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000007';

-- -------------------------------------------------------------------------
-- 2. LOCATIONS (minor, era-scoped)
-- -------------------------------------------------------------------------
INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
-- Records (志)
('36000000-0000-4000-8005-000000000001','10000000-0000-4000-8000-000000000006','changban','real',ST_GeogFromText('POINT(111.7900 30.8500)'),NULL,NULL,501,'battlefield','approximate',12,'CN',true,true),
('36000000-0000-4000-8005-000000000002','10000000-0000-4000-8000-000000000006','huarong-road','real',ST_GeogFromText('POINT(112.9500 29.9200)'),NULL,NULL,502,'route_node','inferred',11,'CN',true,true),
('36000000-0000-4000-8006-000000000001','10000000-0000-4000-8000-000000000006','luocheng','real',ST_GeogFromText('POINT(104.2800 31.1300)'),NULL,NULL,601,'city','approximate',12,'CN',false,true),
-- Romance (演义) -- luofeng-slope replaces luocheng to stay within the per-work cap
('37000000-0000-4000-8005-000000000001','10000000-0000-4000-8000-000000000007','changban','real',ST_GeogFromText('POINT(111.7900 30.8500)'),NULL,NULL,501,'battlefield','approximate',12,'CN',true,true),
('37000000-0000-4000-8005-000000000002','10000000-0000-4000-8000-000000000007','huarong-road','real',ST_GeogFromText('POINT(112.9500 29.9200)'),NULL,NULL,502,'route_node','inferred',11,'CN',true,true),
('37000000-0000-4000-8006-000000000001','10000000-0000-4000-8000-000000000007','luofeng-slope','real',ST_GeogFromText('POINT(104.4300 31.3200)'),NULL,NULL,601,'landmark','inferred',13,'CN',true,true);

INSERT INTO location_translations(location_id,locale,name,summary,status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',v.region FROM locations l JOIN (VALUES
('changban','zh-CN','长坂','南郡当阳境内的山坡地带，建安十三年刘备为曹操追兵所及之地。','荆州 南郡'),
('changban','en','Changban','A stretch of high ground in Dangyang, Nan Commandery, where Cao Cao’s cavalry overtook Liu Bei’s column in 208.','Nan Commandery, Jing Province'),
('huarong-road','zh-CN','华容道','江陵与云梦泽之间的泥泞小道，裴松之注引载曹操引军北还时曾陷于此。','荆州 南郡'),
('huarong-road','en','Huarong Road','A muddy track between Jiangling and the Yunmeng marshes; Pei Songzhi’s commentary records Cao Cao’s retreating column becoming mired here.','Nan Commandery, Jing Province'),
('luocheng','zh-CN','雒城','益州广汉郡属县，刘备围攻月余方下，庞统即殁于此役。','益州 广汉郡'),
('luocheng','en','Luo (Luocheng)','A county seat of Guanghan Commandery in Yi Province, besieged by Liu Bei’s forces for over a year; Pang Tong died in this campaign.','Guanghan Commandery, Yi Province')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug AND l.work_id='10000000-0000-4000-8000-000000000006';

INSERT INTO location_translations(location_id,locale,name,summary,status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',v.region FROM locations l JOIN (VALUES
('changban','zh-CN','长坂坡','当阳境内的山坡，赵子龙单骑救主、张翼德据水断桥的传奇发生地。','荆州 南郡'),
('changban','en','Changban Slope','A stretch of high ground in Dangyang, celebrated as the site of Zhao Yun’s solo rescue of the infant heir and Zhang Fei’s stand at the bridge.','Nan Commandery, Jing Province'),
('huarong-road','zh-CN','华容道','小说中曹操赤壁败后北逃的最后一道险关，关羽在此义释故主之敌。','荆州 南郡'),
('huarong-road','en','Huarong Road','In the novel, the final perilous stretch of Cao Cao’s flight after Red Cliffs, where Guan Yu lets his old benefactor pass out of past kindness.','Nan Commandery, Jing Province'),
('luofeng-slope','zh-CN','落凤坡','小说中雒城附近的山坡地名，传为庞统中箭殒命之地，因其道号“凤雏”而得名。','益州 广汉郡'),
('luofeng-slope','en','Fallen Phoenix Slope','A hillside near Luo in the novel, said to be where Pang Tong -- styled the Young Phoenix -- fell to an ambush of arrows, giving the place its name.','Guanghan Commandery, Yi Province')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug AND l.work_id='10000000-0000-4000-8000-000000000007';

-- -------------------------------------------------------------------------
-- 3. EVENTS
-- -------------------------------------------------------------------------

-- Records (志) KK=05 red-cliffs
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,start_month,confidence,chapter_id)
SELECT ('64000000-0000-4000-8005-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'julian'::calendar_system,
       v.y1,v.y2,v.mo,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'liu-zong-surrenders-jingzhou',5001,'verified_historical','political','range',208,208,NULL::integer,'high','red-cliffs'),
(2,'liu-bei-retreat-at-changban',5003,'verified_historical','battle','range',208,208,NULL,'high','red-cliffs'),
(3,'sun-liu-alliance-at-chaisang',5005,'verified_historical','political','range',208,208,NULL,'medium','red-cliffs'),
(4,'battle-of-red-cliffs',5007,'verified_historical','battle','exact',208,208,11,'high','red-cliffs'),
(5,'cao-cao-withdraws-north-through-huarong',5009,'reported_historical','escape','range',208,208,NULL,'low','red-cliffs'),
(6,'zhou-yu-takes-jiangling',5011,'verified_historical','battle','range',208,209,NULL,'medium','red-cliffs')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,mo,conf)
JOIN chapters ch ON ch.slug='red-cliffs' AND ch.work_id='10000000-0000-4000-8000-000000000006';

-- Records (志) KK=06 three-spheres-forming
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,start_month,confidence,chapter_id)
SELECT ('64000000-0000-4000-8006-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'julian'::calendar_system,
       v.y1,v.y2,NULL::integer,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'liu-bei-takes-four-southern-commanderies',6001,'verified_historical','political','range',209,209,'high'),
(2,'sun-quan-grants-liu-bei-jingzhou',6003,'reported_historical','political','range',209,210,'medium'),
(3,'zhou-yu-dies-at-baqiu',6005,'verified_historical','death','range',210,210,'high'),
(4,'liu-zhang-invites-liu-bei-into-yi-province',6007,'reported_historical','political','range',211,211,'medium'),
(5,'pang-tong-dies-at-luocheng',6009,'verified_historical','death','range',214,214,'high'),
(6,'liu-zhang-surrenders-chengdu',6011,'verified_historical','political','range',214,214,'high'),
(7,'liu-bei-contests-hanzhong-with-cao-cao',6013,'verified_historical','battle','range',217,218,'medium')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,conf)
JOIN chapters ch ON ch.slug='three-spheres-forming' AND ch.work_id='10000000-0000-4000-8000-000000000006';

-- Romance (演义) KK=05 red-cliffs
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,start_month,confidence,chapter_id)
SELECT ('65000000-0000-4000-8005-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'julian'::calendar_system,
       v.y1,v.y2,v.mo,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'liu-zong-surrenders-jingzhou',5001,'fictional_with_historical_context','political','range',208,208,NULL::integer,'medium'),
(2,'liu-bei-retreat-at-changban',5003,'fictional_with_historical_context','battle','range',208,208,NULL,'medium'),
(3,'tongue-battle-with-the-scholars',5005,'fictional_narrative','social','range',208,208,NULL,'low'),
(4,'sun-liu-alliance-at-chaisang',5007,'fictional_with_historical_context','political','range',208,208,NULL,'medium'),
(5,'straw-boat-arrows',5009,'fictional_narrative','discovery','range',208,208,NULL,'low'),
(6,'borrowing-the-east-wind',5011,'legendary_or_mythic','religious','range',208,208,NULL,'low'),
(7,'battle-of-red-cliffs',5013,'fictional_with_historical_context','battle','exact',208,208,11,'medium'),
(8,'jiang-gan-is-fooled-at-the-gathering-of-heroes',5015,'fictional_narrative','social','range',208,208,NULL,'low'),
(9,'cao-cao-withdraws-north-through-huarong',5017,'fictional_with_historical_context','escape','range',208,208,NULL,'low'),
(10,'guan-yu-releases-cao-cao-at-huarong-road',5019,'fictional_narrative','other','range',208,208,NULL,'low'),
(11,'zhou-yu-takes-jiangling',5021,'fictional_with_historical_context','battle','range',208,209,NULL,'medium')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,mo,conf)
JOIN chapters ch ON ch.slug='red-cliffs' AND ch.work_id='10000000-0000-4000-8000-000000000007';

-- Romance (演义) KK=06 three-spheres-forming
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,start_month,confidence,chapter_id)
SELECT ('65000000-0000-4000-8006-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'julian'::calendar_system,
       v.y1,v.y2,NULL::integer,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'liu-bei-takes-four-southern-commanderies',6001,'fictional_with_historical_context','political','range',209,209,'medium'),
(2,'sun-quan-grants-liu-bei-jingzhou',6003,'fictional_with_historical_context','political','range',209,210,'medium'),
(3,'liu-bei-marries-lady-sun-at-ganlu-temple',6005,'fictional_with_historical_context','marriage','range',209,210,'medium'),
(4,'zhou-yu-dies-at-baqiu',6007,'fictional_with_historical_context','death','range',210,210,'medium'),
(5,'liu-zhang-invites-liu-bei-into-yi-province',6009,'fictional_with_historical_context','political','range',211,211,'medium'),
(6,'fa-zheng-secretly-pledges-to-liu-bei',6011,'reported_historical','betrayal','range',211,211,'low'),
(7,'pang-tong-dies-at-luofeng-slope',6013,'legendary_or_mythic','death','range',214,214,'low'),
(8,'liu-zhang-surrenders-chengdu',6015,'fictional_with_historical_context','political','range',214,214,'medium'),
(9,'liu-bei-contests-hanzhong-with-cao-cao',6017,'fictional_with_historical_context','battle','range',217,218,'medium')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,conf)
JOIN chapters ch ON ch.slug='three-spheres-forming' AND ch.work_id='10000000-0000-4000-8000-000000000007';

-- -------------------------------------------------------------------------
-- 4. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------

-- Records (志)
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('liu-zong-surrenders-jingzhou','zh-CN','刘琮举州降曹','刘表卒后，其子刘琮以荆州举众降于曹操。','建安十三年秋，曹操南征荆州，刘表适卒，少子刘琮代立，遂以荆、襄之地束手归附，不发一矢。','曹操不战而得荆州要地，刘备仓促南撤，赤壁之战的态势自此展开。','约公元208年'),
('liu-zong-surrenders-jingzhou','en','Liu Zong surrenders Jing Province','After Liu Biao’s death, his son Liu Zong submits Jing Province to Cao Cao without a fight.','In the autumn of 208, as Cao Cao marched south, Liu Biao died and his younger son Liu Zong succeeded him, promptly surrendering Jing and Xiangyang without loosing an arrow.','Cao Cao gains the strategic province without battle, forcing Liu Bei into a hasty retreat and setting the stage for the Red Cliffs campaign.','c. 208 CE'),
('liu-bei-retreat-at-changban','zh-CN','当阳长坂之败','刘备携民南撤，为曹公骑兵追及于当阳长坂。','刘备闻曹军将至，携荆州吏民十余万缓行，为曹公精骑一日一夜行三百余里追及，弃妻子仓皇南走，张飞据水断桥以拒追兵，赵云于乱军中护得幼主与甘夫人得免。','此败使刘备几陷绝境，亦促成其转投江夏、终定孙刘合力抗曹之局。','约公元208年'),
('liu-bei-retreat-at-changban','en','Defeat at Changban, Dangyang','Liu Bei’s column, encumbered by refugees, is overtaken by Cao Cao’s cavalry at Changban.','Warned of Cao Cao’s approach, Liu Bei moved south with over a hundred thousand civilians; Cao Cao’s elite horsemen covered over three hundred li in a day and night to catch him, and he fled leaving his family behind, while Zhang Fei held a bridge to block the pursuit and Zhao Yun brought the infant heir and Lady Gan to safety through the chaos.','The rout nearly ends Liu Bei’s cause, pushing him toward Jiangxia and the alliance with Sun Quan that follows.','c. 208 CE'),
('sun-liu-alliance-at-chaisang','zh-CN','孙刘结盟于柴桑','诸葛亮奉命使吴，鲁肃周旋其间，孙权决意联刘拒曹。','刘备退保夏口，遣诸葛亮随鲁肃使吴，陈说利害；孙权召周瑜还柴桑议事，终定联刘抗曹之策，授兵三万与周瑜、程普。','此盟确立南方抗曹的联合阵线，为赤壁之战的胜利奠定基础。','约公元208年'),
('sun-liu-alliance-at-chaisang','en','The Sun-Liu alliance at Chaisang','Zhuge Liang is sent to Wu, and with Lu Su’s mediation, Sun Quan resolves to ally with Liu Bei against Cao Cao.','With Liu Bei holding at Xiakou, Zhuge Liang travels to Wu with Lu Su to argue the case; Sun Quan recalls Zhou Yu to Chaisang for counsel and settles on the alliance, granting Zhou Yu and Cheng Pu thirty thousand troops.','The alliance forms the southern front against Cao Cao and lays the groundwork for the Red Cliffs victory.','c. 208 CE'),
('battle-of-red-cliffs','zh-CN','赤壁之战','周瑜、刘备联军于赤壁迎击曹军，大破之。','建安十三年冬十一月，曹公军至赤壁，与备战不利；黄盖献计诈降，纵火焚曹军连舰，会大疫，吏士多死，曹公遂引军还。','此役奠定南北分峙之势，为三国鼎立局面的直接起点。','约公元208年11月'),
('battle-of-red-cliffs','en','The Battle of Red Cliffs','The allied forces of Zhou Yu and Liu Bei meet Cao Cao’s army at Red Cliffs and break it decisively.','In the eleventh month of 208, Cao Cao’s fleet met the allies at Red Cliffs and fared badly; Huang Gai’s feigned surrender and fire attack burned the chained ships, and as plague spread through his ranks with heavy losses, Cao Cao withdrew his army north.','The battle fixes the north-south divide and marks the direct starting point of the Three Kingdoms division.','c. November 208 CE'),
('cao-cao-withdraws-north-through-huarong','zh-CN','曹公引军北还，陷于华容','曹操自赤壁败归，取道华容，遇泥泞而军多死者。','裴松之注引《山阳公载记》，曹公军过华容道，遇泥泞，老弱者相蹈藉而死，公令羸兵负草填道，骑乃得过，公事后犹自嘲言周瑜、刘备智不及此，未曾设伏。','此段记载显示官方史笔简略归因于瘟疫，而裴注保留了更具体的败退细节，二者互为参照。','约公元208年'),
('cao-cao-withdraws-north-through-huarong','en','Cao Cao’s retreat north through Huarong','Retreating from Red Cliffs, Cao Cao’s army takes the Huarong road and suffers heavily in the mud.','Pei Songzhi’s commentary, citing the Shanyang Gong Zaiji, records that Cao Cao’s column bogged down in the mud of Huarong, with the weak trampled underfoot until reeds were laid to let the horsemen pass; Cao Cao himself later joked that Zhou Yu and Liu Bei lacked the wit to have set an ambush there.','The main annals attribute the retreat’s losses to plague alone, while Pei’s commentary preserves a more specific account of the disaster, the two together illustrating history’s own layered record.','c. 208 CE'),
('zhou-yu-takes-jiangling','zh-CN','周瑜克江陵','周瑜率军围攻江陵曹仁，逾年乃克。','赤壁战后，周瑜、程普等进兵南郡，与曹仁隔江对峙，攻战经年，瑜身中流矢，创甚，仍力疾拔城，曹仁遂弃江陵北走。','江陵既下，孙刘两家得以分据荆州要地，为其后借荆州之议埋下伏笔。','约公元208至209年'),
('zhou-yu-takes-jiangling','en','Zhou Yu takes Jiangling','Zhou Yu besieges Cao Ren at Jiangling and takes the city after more than a year.','After Red Cliffs, Zhou Yu and Cheng Pu advanced on Nan Commandery, facing Cao Ren across the river in a siege lasting over a year; though badly wounded by a stray arrow, Zhou Yu pressed on until Cao Ren abandoned Jiangling and withdrew north.','With Jiangling taken, Wu and Shu divide the key holdings of Jing Province between them, setting up the later dispute over lending it to Liu Bei.','c. 208–209 CE'),
('liu-bei-takes-four-southern-commanderies','zh-CN','刘备平定荆南四郡','刘备南征武陵、长沙、桂阳、零陵，四郡皆降。','赤壁战后，刘备表荆南四郡太守，四郡望风归附，以赵云领桂阳太守。','刘备始有稳固根据地，为其后借荆州、入益州积蓄实力。','约公元209年'),
('liu-bei-takes-four-southern-commanderies','en','Liu Bei secures the four southern commanderies','Liu Bei campaigns south and receives the surrender of Wuling, Changsha, Guiyang, and Lingling.','After Red Cliffs, Liu Bei’s forces moved through the four commanderies south of Jing Province, which submitted without much resistance; Zhao Yun was made Administrator of Guiyang.','Liu Bei gains his first stable territorial base, the resources on which the later moves to borrow Jing Province and enter Yi Province depend.','c. 209 CE'),
('sun-quan-grants-liu-bei-jingzhou','zh-CN','孙权借荆州与刘备','鲁肃力主借南郡之地与刘备，以共拒曹操。','刘备自诣京见孙权，求都督荆州；鲁肃劝权以荆土借之，共为掎角以御曹操，权从其议。','此议巩固孙刘联盟，然亦为日后争夺荆州、关羽之败埋下祸根。','约公元209至210年'),
('sun-quan-grants-liu-bei-jingzhou','en','Sun Quan lends Liu Bei Jing Province','Lu Su presses Sun Quan to lend Nan Commandery to Liu Bei to strengthen the front against Cao Cao.','Liu Bei travels in person to see Sun Quan and request oversight of Jing Province; Lu Su argues for lending him the territory so the two can present a joint front against Cao Cao, and Sun Quan agrees.','The arrangement cements the Sun-Liu alliance for the moment, but also plants the seed of the later dispute over Jing Province that costs Guan Yu his life.','c. 209–210 CE'),
('zhou-yu-dies-at-baqiu','zh-CN','周瑜卒于巴丘','周瑜将图益州，行至巴丘病卒，年三十六。','周瑜克江陵后，请于孙权，愿并取蜀，还师至巴丘，得疾卒，临终上疏荐鲁肃自代。','都督之任转归鲁肃，孙吴对荆州、蜀地的方略随之调整。','约公元210年'),
('zhou-yu-dies-at-baqiu','en','Zhou Yu dies at Baqiu','Preparing a campaign toward Yi Province, Zhou Yu falls ill and dies at Baqiu at thirty-six.','After taking Jiangling, Zhou Yu proposed to Sun Quan a joint campaign to take Shu; marching back toward Baqiu he fell gravely ill and died, recommending Lu Su as his successor in his final memorial.','Command passes to Lu Su, and Wu’s strategy toward Jing Province and the west shifts accordingly.','c. 210 CE'),
('liu-zhang-invites-liu-bei-into-yi-province','zh-CN','刘璋迎刘备入蜀','刘璋闻曹操将图汉中，纳法正之议，迎刘备入蜀以拒张鲁。','法正、庞统皆劝刘备乘势取蜀，先主犹豫未决，璋复资以兵粮，令备北屯葭萌，以御张鲁。','刘备由此获得进取益州的立足点，三分格局的西南一翼开始成形。','约公元211年'),
('liu-zhang-invites-liu-bei-into-yi-province','en','Liu Zhang invites Liu Bei into Yi Province','Fearing Cao Cao’s designs on Hanzhong, Liu Zhang follows Fa Zheng’s counsel and invites Liu Bei into Shu to guard against Zhang Lu.','Fa Zheng and Pang Tong both urge Liu Bei to seize the opportunity to take Shu; Liu Bei hesitates, while Liu Zhang supplies him with troops and provisions and stations him north at Jiameng to hold off Zhang Lu.','Liu Bei gains a foothold for the conquest of Yi Province, and the southwestern arm of the three-way division begins to take shape.','c. 211 CE'),
('pang-tong-dies-at-luocheng','zh-CN','庞统殒于雒城','刘备既与刘璋决裂，进围雒城，庞统中流矢卒。','建安十九年，刘备督兵攻雒，庞统亲临矢石，为流矢所中，卒于军中，年三十六。','蜀汉痛失一位与诸葛亮并称的谋主，然雒城终为刘备所拔，进围成都之势已成。','约公元214年'),
('pang-tong-dies-at-luocheng','en','Pang Tong dies at Luo','After Liu Bei breaks with Liu Zhang and besieges Luo, Pang Tong is killed by a stray arrow.','In 214, as Liu Bei’s forces pressed the siege of Luo, Pang Tong, exposed to the fighting, was struck by a stray arrow and died at thirty-six.','Shu Han loses a strategist ranked alongside Zhuge Liang, though Luo falls soon after, opening the way to besiege Chengdu.','c. 214 CE'),
('liu-zhang-surrenders-chengdu','zh-CN','刘璋出降成都','刘备围成都逾月，马超复至城下，刘璋遂开城出降。','法正致书劝降，马超率众来附兵临城下，城中震恐，刘璋以百姓久困，遂率吏民出降，益州悉归先主。','刘备始有跨州连郡之基业，三分天下的西南一角至此确立。','约公元214年'),
('liu-zhang-surrenders-chengdu','en','Liu Zhang surrenders Chengdu','After a siege of Chengdu lasting weeks, and with Ma Chao’s arrival before the walls, Liu Zhang opens the gates and surrenders.','Fa Zheng writes urging surrender, and Ma Chao’s arrival with his own forces shakes the besieged city; unwilling to prolong his people’s suffering, Liu Zhang leads his officials out to surrender, and Yi Province passes entirely to Liu Bei.','Liu Bei now holds territory spanning two provinces, fixing the southwestern corner of the coming three-way division.','c. 214 CE'),
('liu-bei-contests-hanzhong-with-cao-cao','zh-CN','刘备争汉中','法正劝先主取汉中，黄忠等率军北进，与曹公相持。','建安二十二年，法正陈说汉中形胜，劝先主进取；先主遂率诸将北屯阳平，与曹公所遣夏侯渊、张郃相持经年。','此役为其后定军山阵斩夏侯渊、先主自立汉中王的直接伏笔。','约公元217至218年'),
('liu-bei-contests-hanzhong-with-cao-cao','en','Liu Bei contests Hanzhong with Cao Cao','On Fa Zheng’s urging, Liu Bei advances north with Huang Zhong and others to contest Hanzhong.','In 217, Fa Zheng argued the strategic value of Hanzhong and urged the campaign; Liu Bei moved his generals north to Yangping, facing Cao Cao’s commanders Xiahou Yuan and Zhang He in a standoff lasting into the following year.','The campaign sets up the decisive strike at Mount Dingjun and Liu Bei’s later self-declaration as King of Hanzhong.','c. 217–218 CE')
) AS v(eslug,locale,title,summary,detail,sig,tl) ON e.slug=v.eslug AND e.work_id='10000000-0000-4000-8000-000000000006';

-- Romance (演义)
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('liu-zong-surrenders-jingzhou','zh-CN','刘琮献荆州','刘表新丧，蔡夫人与刘琮暗纳降表，襄阳拱手让与曹操。','刘表病故，蔡夫人与蔡瑁、张允合谋，瞒过刘备，暗遣使纳降，曹操兵不血刃据有荆襄。','小说借此渲染刘备寄人篱下的无奈处境，为长坂坡之败张本。','约公元208年'),
('liu-zong-surrenders-jingzhou','en','Liu Zong surrenders Jing Province','With Liu Biao newly dead, Lady Cai and Liu Zong secretly send terms of surrender, yielding Xiangyang to Cao Cao without a fight.','On Liu Biao’s death, Lady Cai conspires with Cai Mao and Zhang Yun to keep Liu Bei in the dark and send a secret envoy to surrender, letting Cao Cao occupy Jing Province bloodlessly.','The novel uses the scene to underline Liu Bei’s precarious position as a guest in another’s land, setting up the disaster at Changban.','c. 208 CE'),
('liu-bei-retreat-at-changban','zh-CN','长坂坡之战','曹军追至当阳，赵云单骑救主，张飞据水断桥喝退曹军。','刘备携民渡江仓皇南奔，赵云于百万军中七进七出，怀抱阿斗杀出重围；张飞立马桥头，一声断喝，曹军竟不敢近前。','此役是小说塑造赵云、张飞英雄形象的核心场面，亦是刘备漂泊生涯的至暗时刻。','约公元208年'),
('liu-bei-retreat-at-changban','en','The Battle of Changban Slope','With Cao Cao’s army closing in at Dangyang, Zhao Yun rides alone to save the infant heir while Zhang Fei’s roar at a bridge holds the pursuers back.','As Liu Bei’s column flees south in chaos, Zhao Yun cuts through the enemy host seven times over to carry the infant Adou to safety, while Zhang Fei plants himself at a bridgehead and roars a challenge that Cao Cao’s men dare not answer.','The novel’s defining showcase of Zhao Yun and Zhang Fei as heroes, and the darkest hour of Liu Bei’s wandering years.','c. 208 CE'),
('tongue-battle-with-the-scholars','zh-CN','舌战群儒','诸葛亮渡江说吴，独对江东谋臣群起发难，一一驳倒。','诸葛亮至柴桑，张昭等江东谋士齐聚发难，或讥其才学，或劝孙权降曹，孔明从容应对，逐一折服群儒，坚定孙权抗曹之心。','这是小说塑造诸葛亮外交辩才的经典场面，为孙刘联盟的达成扫清舆论障碍。','约公元208年'),
('tongue-battle-with-the-scholars','en','The tongue battle with the assembled scholars','Zhuge Liang crosses to Wu to argue for alliance and single-handedly outdebates a hall full of hostile court advisers.','At Chaisang, Zhang Zhao and other Wu counselors confront Zhuge Liang in turn, mocking his learning or urging surrender to Cao Cao; he answers each calmly and turns back every argument, steadying Sun Quan’s resolve to resist.','The novel’s classic showcase of Zhuge Liang’s rhetorical skill, clearing the way for the Sun-Liu alliance.','c. 208 CE'),
('sun-liu-alliance-at-chaisang','zh-CN','孙刘联盟定于柴桑','周瑜、鲁肃与诸葛亮共谋，孙权终决意联刘抗曹。','舌战群儒之后，周瑜归柴桑主持大局，与诸葛亮暗中较量智谋，孙权见曹操书信辞气骄狂，遂拔剑斩案，决意一战。','联盟既定，赤壁鏖兵之局遂开。','约公元208年'),
('sun-liu-alliance-at-chaisang','en','The Sun-Liu alliance is settled at Chaisang','Zhou Yu, Lu Su, and Zhuge Liang confer, and Sun Quan resolves at last to ally with Liu Bei against Cao Cao.','After the tongue battle, Zhou Yu returns to Chaisang to take charge, matching wits quietly with Zhuge Liang; reading the arrogance of Cao Cao’s letter, Sun Quan draws his sword and slices the corner from his table, declaring for war.','With the alliance fixed, the stage is set for the clash at Red Cliffs.','c. 208 CE'),
('straw-boat-arrows','zh-CN','草船借箭','周瑜限诸葛亮三日造箭十万，孔明乘雾以草船向曹营诈取箭矢。','周瑜妒其才，限三日内造箭十万支意欲加害，孔明却只备草船二十只，乘大雾逼近曹营击鼓呐喊，曹军放箭如雨，箭悉集于草人之上，不费一箭而得十余万支。','小说借此事渲染诸葛亮料事如神的智谋形象；史源实为建安十八年濡须口孙权乘船受箭之事，移花接木而成。','约公元208年'),
('straw-boat-arrows','en','Borrowing arrows with boats of straw','Given three days by Zhou Yu to produce a hundred thousand arrows, Zhuge Liang instead sails straw-covered boats through fog to draw Cao Cao’s fire.','Hoping to see him fail, Zhou Yu sets an impossible three-day deadline; Zhuge Liang instead readies twenty straw-lined boats, approaches Cao Cao’s camp under thick fog beating drums and shouting, and lets the answering volley of arrows bury itself in the straw, gathering over a hundred thousand shafts without loosing one himself.','The episode showcases Zhuge Liang’s seemingly supernatural foresight; its historical seed is an unrelated 213 incident at Ruxukou where Sun Quan’s own boat took on arrows, transplanted here by the novelist.','c. 208 CE'),
('borrowing-the-east-wind','zh-CN','借东风','诸葛亮于南屏山筑坛作法，为周瑜的火攻借来东南风。','隆冬时节本无东南风，火攻之计几废，诸葛亮筑七星坛，作法三日，果然东南风大作，周瑜得以纵火焚曹军战船。','此为小说渲染诸葛亮通晓天时、近乎神异的高潮场面，直接促成火攻之计的成功。','约公元208年'),
('borrowing-the-east-wind','en','Borrowing the east wind','Zhuge Liang builds an altar and performs a ritual to summon the southeast wind that Zhou Yu’s fire attack requires.','With no southeast wind expected in deep winter, the fire plan nearly collapses; Zhuge Liang builds a seven-star altar and performs rites for three days until the wind rises as needed, letting Zhou Yu set the fleet ablaze.','The novel’s most overtly supernatural showcase of Zhuge Liang’s near-mystical command of the elements, the direct trigger for the fire attack’s success.','c. 208 CE'),
('battle-of-red-cliffs','zh-CN','赤壁鏖兵','东风既起，黄盖火船齐发，曹军连环战舰尽付一炬。','黄盖乘小船诈降，近曹营突然纵火，借东风之势延烧曹操连环战船，江面火光冲天，曹军水陆俱溃，曹操仅以身免。','小说将此役渲染为环环相扣的连环妙计之总成，奠定其后三分天下的文学母题。','约公元208年11月'),
('battle-of-red-cliffs','en','The blazing battle of Red Cliffs','With the east wind risen, Huang Gai’s fire ships strike, and Cao Cao’s chained fleet burns to ruin.','Huang Gai’s small boats close under the guise of surrender and suddenly erupt in flame, the borrowed wind spreading fire through the linked ships until the river itself seems ablaze; Cao Cao’s forces collapse on water and land alike, and he barely escapes with his life.','The novel presents the battle as the culmination of a chain of interlocking stratagems, the literary origin point of the coming three-way division.','c. November 208 CE'),
('jiang-gan-is-fooled-at-the-gathering-of-heroes','zh-CN','群英会蒋干中计','蒋干渡江欲说降周瑜，反被周瑜将计就计，盗得伪造降书。','曹操遣蒋干过江探听虚实，周瑜佯醉留宿，故布伪造的蔡瑁、张允降书于案，蒋干窃书连夜逃回，曹操信以为真，斩杀二人，自毁水军。','小说借此展现周瑜的反间之才，间接为赤壁大捷扫除曹军水战障碍。','约公元208年'),
('jiang-gan-is-fooled-at-the-gathering-of-heroes','en','Jiang Gan is fooled at the gathering of heroes','Sent to talk Zhou Yu into surrender, Jiang Gan is instead maneuvered into stealing a forged letter.','Cao Cao sends his old friend Jiang Gan across the river to probe Zhou Yu’s intentions; Zhou Yu feigns drunkenness and leaves a forged surrender letter from Cai Mao and Zhang Yun where Jiang Gan can steal it, and Cao Cao, believing it genuine, executes his own naval commanders.','The episode showcases Zhou Yu’s gift for counter-intelligence, removing Cao Cao’s naval expertise ahead of the Red Cliffs battle.','c. 208 CE'),
('cao-cao-withdraws-north-through-huarong','zh-CN','曹操败走华容','曹操兵败赤壁，一路狼狈北窜，三次大笑皆招来伏兵。','曹操引残兵沿途逃窜，三次自笑周瑜、诸葛亮谋略不周，每笑毕辄有伏兵杀出，狼狈至极，终至华容道前。','小说以曹操屡笑屡败的桥段渲染其虽败犹傲的性格，也为华容道释曹的高潮蓄势。','约公元208年'),
('cao-cao-withdraws-north-through-huarong','en','Cao Cao flees north through Huarong','Routed at Red Cliffs, Cao Cao’s ragged column flees north, his laughter at each supposed lapse in his enemies’ planning summoning an ambush each time.','Fleeing with his remaining troops, Cao Cao laughs three times at what he takes for gaps in Zhou Yu and Zhuge Liang’s strategy, and each time an ambush springs from hiding, driving him further into disarray until he reaches the Huarong road.','The novel uses his repeated laughter to paint a man proud even in defeat, building toward the climactic release at Huarong Road.','c. 208 CE'),
('guan-yu-releases-cao-cao-at-huarong-road','zh-CN','华容道义释曹操','关羽奉命扼守华容道，念及旧日恩义，终纵曹操北归。','诸葛亮料曹操必走华容，故遣关羽把守，实欲全其义气；曹操于绝境哀求，关羽念昔日许都相待之情，横刀立马，终放曹操及残部通过。','此段是小说塑造关羽“义”字性格的巅峰场面，亦成就后世“华容道”典故。','约公元208年'),
('guan-yu-releases-cao-cao-at-huarong-road','en','Guan Yu releases Cao Cao at Huarong Road','Posted to block Cao Cao’s retreat at Huarong Road, Guan Yu lets him pass in memory of an old debt of kindness.','Foreseeing that Cao Cao would flee this way, Zhuge Liang assigns Guan Yu to hold the road, meaning in truth to let his sense of honor be tested; when Cao Cao begs for his life, Guan Yu, remembering Cao Cao’s past generosity toward him at Xuchang, lowers his blade and lets the broken column through.','The scene stands as the novel’s supreme showcase of Guan Yu’s code of loyalty and honor, and gives later tradition its proverbial image of Huarong Road.','c. 208 CE'),
('zhou-yu-takes-jiangling','zh-CN','周瑜智取南郡','周瑜强攻南郡受挫中箭，诸葛亮乘隙遣兵先取江陵。','周瑜攻南郡，中曹仁毒箭，佯死诱曹仁劫寨，反破之；然诸葛亮早遣赵云乘虚径取江陵，周瑜空自辛劳，反为他人作嫁。','此段进一步渲染诸葛亮谋略胜周瑜一筹的文学主题，为“三气周瑜”张本。','约公元208至209年'),
('zhou-yu-takes-jiangling','en','Zhou Yu wins Nan Commandery by stratagem','Wounded by a poisoned arrow while storming Nan Commandery, Zhou Yu still breaks Cao Ren’s raid, only for Zhuge Liang to seize Jiangling first.','Struck by a poisoned arrow at Nan Commandery, Zhou Yu feigns death to lure Cao Ren into a raid and turns it back on him; but Zhuge Liang has already sent Zhao Yun to take Jiangling in the confusion, leaving Zhou Yu’s hard-won victory to profit another.','The episode extends the novel’s running theme of Zhuge Liang outmaneuvering Zhou Yu, the first of the “three angerings” that mark their rivalry.','c. 208–209 CE'),
('liu-bei-takes-four-southern-commanderies','zh-CN','刘备智取荆南四郡','刘备率赵云、张飞等南征，武陵、长沙、桂阳、零陵相继来降。','刘备乘赤壁胜势南下，赵云取桂阳、张飞取武陵、关羽义释黄忠取长沙，四郡望风归附。','小说借四郡之战添入黄忠归汉、关羽义释的插曲，丰富了蜀汉阵营的将才谱系。','约公元209年'),
('liu-bei-takes-four-southern-commanderies','en','Liu Bei wins the four southern commanderies by strategy','Liu Bei sends Zhao Yun, Zhang Fei, and others south, and Wuling, Changsha, Guiyang, and Lingling all submit in turn.','Riding the momentum of Red Cliffs, Liu Bei moves south; Zhao Yun takes Guiyang, Zhang Fei takes Wuling, and Guan Yu’s sparing of Huang Zhong wins Changsha, and all four commanderies yield.','The novel uses the campaign to introduce Huang Zhong’s allegiance and Guan Yu’s mercy, enriching the roster of talent gathering around Liu Bei.','c. 209 CE'),
('sun-quan-grants-liu-bei-jingzhou','zh-CN','刘备借荆州','鲁肃三番索讨荆州未果，孙权终暂允刘备承管其地。','刘备亲往江东见孙权，鲁肃周旋其间，反复索取荆州，诸葛亮以刘表托孤、日后取蜀即还为辞婉拒，孙权无奈，姑且许之。','“刘备借荆州，一借不还”由此成为日后孙刘反目的伏线。','约公元209至210年'),
('sun-quan-grants-liu-bei-jingzhou','en','Liu Bei borrows Jing Province','Lu Su presses repeatedly for the return of Jing Province, and Sun Quan reluctantly agrees to let Liu Bei hold it for now.','Liu Bei travels in person to see Sun Quan; Lu Su presses the claim to Jing Province again and again, while Zhuge Liang deflects with the excuse of Liu Biao’s trust and a promise to return it once Shu is taken, leaving Sun Quan to grant the arrangement unwillingly.','The proverbial complaint that Liu Bei “borrowed Jing Province and never gave it back” begins here, the seed of the later rupture between the two houses.','c. 209–210 CE'),
('liu-bei-marries-lady-sun-at-ganlu-temple','zh-CN','甘露寺招亲','周瑜献美人计，欲以孙权之妹诱刘备入吴为质，反弄假成真。','周瑜劝孙权以妹许嫁刘备，赚其入吴扣为人质，孙权之母吴国太于甘露寺相看女婿，见刘备仪表非凡，竟弄假成真，招为东床快婿。','计谋弄假成真的转折，是小说“赔了夫人又折兵”这一著名讽喻的开端，婚事本身实有其事，寺中相亲一节则为小说家言。','约公元209至210年'),
('liu-bei-marries-lady-sun-at-ganlu-temple','en','The marriage arranged at Ganlu Temple','Zhou Yu’s plan to lure Liu Bei to Wu as a hostage bridegroom backfires when the marriage becomes real.','Zhou Yu urges Sun Quan to offer his sister to Liu Bei as bait to hold him hostage in Wu; but at Ganlu Temple, Lady Wu, Sun Quan’s mother, is so taken with Liu Bei’s bearing that she insists on a genuine marriage.','The reversal of the ruse into a real marriage opens the novel’s famous mockery that Zhou Yu “lost a bride and cost troops besides”; the marriage itself is historically real, though the temple courtship is the novelist’s invention.','c. 209–210 CE'),
('zhou-yu-dies-at-baqiu','zh-CN','既生瑜何生亮','周瑜三番算计诸葛亮皆落空，怒气攻心，箭疮迸裂而亡于巴丘。','周瑜设美人计、讨荆州诸计皆为诸葛亮识破化解，怒极吐血，仰天长叹既生瑜何生亮，箭疮复裂，卒于巴丘。','小说以此收束周瑜与诸葛亮斗智的主线，都督之位转归鲁肃。','约公元210年'),
('zhou-yu-dies-at-baqiu','en','“Why, since there was Yu, was there also Liang?”','Each of Zhou Yu’s schemes against Zhuge Liang unravels, and his old arrow wound reopens in his fury, killing him at Baqiu.','Every stratagem Zhou Yu sets -- the marriage trap, the repeated demands for Jing Province -- is seen through and turned aside by Zhuge Liang, until in his rage he cries out asking why fate paired him against such a rival, and his old wound bursts open, killing him at Baqiu.','The novel closes its central rivalry between Zhou Yu and Zhuge Liang with this line, and command passes to Lu Su.','c. 210 CE'),
('liu-zhang-invites-liu-bei-into-yi-province','zh-CN','张松献图，刘璋迎刘备','张松暗献西川地图，刘璋轻信而迎刘备入蜀拒张鲁。','别驾张松使曹操受辱，转而暗投刘备，献上西川地图；刘璋不知有诈，反听法正、张松之劝，迎刘备入蜀，令其北屯葭萌以拒张鲁。','小说借张松献图渲染刘璋的昏聩与刘备取蜀的天时人和。','约公元211年'),
('liu-zhang-invites-liu-bei-into-yi-province','en','Zhang Song offers the map, and Liu Zhang invites Liu Bei in','Snubbed by Cao Cao, the officer Zhang Song secretly turns to Liu Bei and hands over a map of western Shu, and Liu Zhang, unaware of the betrayal, invites Liu Bei in.','Humiliated at Cao Cao’s court, the aide Zhang Song secretly offers Liu Bei a detailed map of Shu; unaware of the scheme, Liu Zhang follows Fa Zheng and Zhang Song’s advice to invite Liu Bei in and station him at Jiameng against Zhang Lu.','The episode with Zhang Song’s map underlines Liu Zhang’s poor judgment against the favorable timing of Liu Bei’s conquest of Shu.','c. 211 CE'),
('fa-zheng-secretly-pledges-to-liu-bei','zh-CN','法正暗通刘备','法正虽奉刘璋之命出使，实则早与张松合谋，暗许诚款于刘备。','法正素轻刘璋暗弱，与张松私交甚厚，奉命迎接刘备时即暗中输诚，密陈取蜀方略，为刘备日后反戈埋下内应。','法正的暗中倒戈是刘备取蜀成功的关键内应，亦见其审时度势之才。','约公元211年'),
('fa-zheng-secretly-pledges-to-liu-bei','en','Fa Zheng secretly pledges himself to Liu Bei','Sent by Liu Zhang to receive Liu Bei, Fa Zheng has already conspired with Zhang Song and secretly pledges his loyalty instead.','Long contemptuous of Liu Zhang’s weakness and close with Zhang Song, Fa Zheng uses his mission to welcome Liu Bei as cover to pledge secret loyalty and lay out a plan for taking Shu.','Fa Zheng’s covert defection provides the inside support crucial to Liu Bei’s later campaign, and reflects his gift for reading the shifting balance of power.','c. 211 CE'),
('pang-tong-dies-at-luofeng-slope','zh-CN','庞统殒命落凤坡','庞统进军雒城，误骑白马当先，为埋伏乱箭射死于落凤坡。','庞统求功心切，代刘备骑白马当先开路，蜀中伏兵误认为刘备坐骑，万箭齐发，庞统死于乱箭之下，其地因而得名落凤坡，应验其“凤雏”之号。','小说以谶语式的地名巧合渲染庞统之死的宿命色彩，也促使诸葛亮自荆州星夜入蜀。','约公元214年'),
('pang-tong-dies-at-luofeng-slope','en','Pang Tong dies at Fallen Phoenix Slope','Eager to prove himself, Pang Tong rides ahead on a white horse toward Luo and is cut down by an ambush that mistakes him for Liu Bei.','Riding Liu Bei’s white horse at the head of the column in his eagerness for credit, Pang Tong draws an ambush meant for his lord, and dies under a hail of arrows at a slope that comes to be called Fallen Phoenix, fulfilling the name he was given.','The novel uses the omen-like coincidence of the place-name to lend his death a fated quality, and the loss draws Zhuge Liang west from Jing Province to join the campaign.','c. 214 CE'),
('liu-zhang-surrenders-chengdu','zh-CN','刘璋献城投降','马超兵临成都，城中震恐，刘璋不忍生灵涂炭，献城出降。','诸葛亮设计招降马超，马超率军直抵成都城下，城中军民惶惧，刘璋念及百姓，不听左右死战之请，开城出降，刘备秋毫无犯。','益州归于刘备，蜀汉基业自此奠定。','约公元214年'),
('liu-zhang-surrenders-chengdu','en','Liu Zhang surrenders the city','With Ma Chao’s army before the walls and the city in panic, Liu Zhang, unwilling to see more bloodshed, opens the gates.','Zhuge Liang’s design wins over Ma Chao, whose forces arrive directly before Chengdu, terrifying the garrison; Liu Zhang, thinking of his people rather than his advisers’ calls to fight on, surrenders the city, and Liu Bei’s troops enter without looting.','Yi Province passes to Liu Bei, and the foundation of Shu Han is laid.','c. 214 CE'),
('liu-bei-contests-hanzhong-with-cao-cao','zh-CN','刘备兴兵取汉中','法正力劝，黄忠、老将请缨，刘备大举北进，与曹军相持汉中。','法正陈说汉中形胜利害，刘备遂命黄忠等将北进阳平，与曹公所遣夏侯渊、张郃相持，蓄势待发。','此为定军山黄忠刀劈夏侯渊、刘备自立汉中王的直接前奏。','约公元217至218年'),
('liu-bei-contests-hanzhong-with-cao-cao','en','Liu Bei marches to take Hanzhong','On Fa Zheng’s urging, and with veteran Huang Zhong volunteering for the front, Liu Bei launches a major push north against Cao Cao’s forces in Hanzhong.','Fa Zheng lays out the strategic case for Hanzhong, and Liu Bei sends Huang Zhong and other generals north to Yangping, facing off against Cao Cao’s commanders Xiahou Yuan and Zhang He as both sides gather strength.','This sets the stage directly for Huang Zhong’s killing of Xiahou Yuan at Mount Dingjun and Liu Bei’s later self-proclamation as King of Hanzhong.','c. 217–218 CE')
) AS v(eslug,locale,title,summary,detail,sig,tl) ON e.slug=v.eslug AND e.work_id='10000000-0000-4000-8000-000000000007';

-- -------------------------------------------------------------------------
-- 5. EVENT-LOCATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('liu-zong-surrenders-jingzhou','xiangyang'),
('liu-bei-retreat-at-changban','changban'),
('sun-liu-alliance-at-chaisang','chaisang'),
('battle-of-red-cliffs','chibi'),
('cao-cao-withdraws-north-through-huarong','huarong-road'),
('zhou-yu-takes-jiangling','jiangling'),
('liu-bei-takes-four-southern-commanderies','jiangxia'),
('sun-quan-grants-liu-bei-jingzhou','jiangling'),
('zhou-yu-dies-at-baqiu','chaisang'),
('liu-zhang-invites-liu-bei-into-yi-province','chengdu'),
('pang-tong-dies-at-luocheng','luocheng'),
('liu-zhang-surrenders-chengdu','chengdu'),
('liu-bei-contests-hanzhong-with-cao-cao','hanzhong'),
('tongue-battle-with-the-scholars','chaisang'),
('straw-boat-arrows','chibi'),
('borrowing-the-east-wind','chibi'),
('jiang-gan-is-fooled-at-the-gathering-of-heroes','chaisang'),
('guan-yu-releases-cao-cao-at-huarong-road','huarong-road'),
('liu-bei-marries-lady-sun-at-ganlu-temple','jianye'),
('fa-zheng-secretly-pledges-to-liu-bei','chengdu'),
('pang-tong-dies-at-luofeng-slope','luofeng-slope')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.id::text LIKE '6_000000-0000-4000-8005%' OR e.id::text LIKE '6_000000-0000-4000-8006%'
ON CONFLICT DO NOTHING;

-- battle-of-red-cliffs also touches wulin (secondary location), both works
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'secondary',1 FROM events e JOIN locations l ON l.slug='wulin' AND l.work_id=e.work_id
WHERE e.slug='battle-of-red-cliffs'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 6. EVENT-CHARACTERS
-- -------------------------------------------------------------------------

-- Records (志)
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('liu-zong-surrenders-jingzhou','cao-cao',0),('liu-zong-surrenders-jingzhou','liu-bei',1),
('liu-bei-retreat-at-changban','liu-bei',0),('liu-bei-retreat-at-changban','zhang-fei',1),('liu-bei-retreat-at-changban','zhao-yun',2),
('sun-liu-alliance-at-chaisang','zhuge-liang',0),('sun-liu-alliance-at-chaisang','sun-quan',1),('sun-liu-alliance-at-chaisang','lu-su',2),('sun-liu-alliance-at-chaisang','zhou-yu',3),
('battle-of-red-cliffs','zhou-yu',0),('battle-of-red-cliffs','huang-gai',1),('battle-of-red-cliffs','cao-cao',2),('battle-of-red-cliffs','liu-bei',3),
('cao-cao-withdraws-north-through-huarong','cao-cao',0),
('zhou-yu-takes-jiangling','zhou-yu',0),('zhou-yu-takes-jiangling','huang-gai',1),
('liu-bei-takes-four-southern-commanderies','liu-bei',0),('liu-bei-takes-four-southern-commanderies','zhao-yun',1),
('sun-quan-grants-liu-bei-jingzhou','liu-bei',0),('sun-quan-grants-liu-bei-jingzhou','sun-quan',1),('sun-quan-grants-liu-bei-jingzhou','lu-su',2),
('zhou-yu-dies-at-baqiu','zhou-yu',0),('zhou-yu-dies-at-baqiu','sun-quan',1),
('liu-zhang-invites-liu-bei-into-yi-province','liu-bei',0),('liu-zhang-invites-liu-bei-into-yi-province','liu-zhang',1),('liu-zhang-invites-liu-bei-into-yi-province','fa-zheng',2),
('pang-tong-dies-at-luocheng','liu-bei',0),('pang-tong-dies-at-luocheng','pang-tong',1),
('liu-zhang-surrenders-chengdu','liu-bei',0),('liu-zhang-surrenders-chengdu','liu-zhang',1),('liu-zhang-surrenders-chengdu','fa-zheng',2),('liu-zhang-surrenders-chengdu','ma-chao',3),
('liu-bei-contests-hanzhong-with-cao-cao','liu-bei',0),('liu-bei-contests-hanzhong-with-cao-cao','huang-zhong',1),('liu-bei-contests-hanzhong-with-cao-cao','fa-zheng',2)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

-- Romance (演义)
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('liu-zong-surrenders-jingzhou','cao-cao',0),('liu-zong-surrenders-jingzhou','liu-bei',1),
('liu-bei-retreat-at-changban','liu-bei',0),('liu-bei-retreat-at-changban','zhang-fei',1),('liu-bei-retreat-at-changban','zhao-yun',2),
('tongue-battle-with-the-scholars','zhuge-liang',0),('tongue-battle-with-the-scholars','lu-su',1),
('sun-liu-alliance-at-chaisang','zhuge-liang',0),('sun-liu-alliance-at-chaisang','sun-quan',1),('sun-liu-alliance-at-chaisang','zhou-yu',2),('sun-liu-alliance-at-chaisang','lu-su',3),
('straw-boat-arrows','zhuge-liang',0),('straw-boat-arrows','lu-su',1),('straw-boat-arrows','zhou-yu',2),
('borrowing-the-east-wind','zhuge-liang',0),('borrowing-the-east-wind','zhou-yu',1),
('battle-of-red-cliffs','zhou-yu',0),('battle-of-red-cliffs','huang-gai',1),('battle-of-red-cliffs','zhuge-liang',2),('battle-of-red-cliffs','cao-cao',3),
('jiang-gan-is-fooled-at-the-gathering-of-heroes','zhou-yu',0),('jiang-gan-is-fooled-at-the-gathering-of-heroes','jiang-gan',1),
('cao-cao-withdraws-north-through-huarong','cao-cao',0),
('guan-yu-releases-cao-cao-at-huarong-road','guan-yu',0),('guan-yu-releases-cao-cao-at-huarong-road','cao-cao',1),
('zhou-yu-takes-jiangling','zhou-yu',0),('zhou-yu-takes-jiangling','huang-gai',1),
('liu-bei-takes-four-southern-commanderies','liu-bei',0),('liu-bei-takes-four-southern-commanderies','zhao-yun',1),
('sun-quan-grants-liu-bei-jingzhou','liu-bei',0),('sun-quan-grants-liu-bei-jingzhou','sun-quan',1),('sun-quan-grants-liu-bei-jingzhou','lu-su',2),
('liu-bei-marries-lady-sun-at-ganlu-temple','liu-bei',0),('liu-bei-marries-lady-sun-at-ganlu-temple','sun-quan',1),
('zhou-yu-dies-at-baqiu','zhou-yu',0),('zhou-yu-dies-at-baqiu','zhuge-liang',1),('zhou-yu-dies-at-baqiu','sun-quan',2),
('liu-zhang-invites-liu-bei-into-yi-province','liu-bei',0),('liu-zhang-invites-liu-bei-into-yi-province','liu-zhang',1),('liu-zhang-invites-liu-bei-into-yi-province','fa-zheng',2),
('fa-zheng-secretly-pledges-to-liu-bei','fa-zheng',0),('fa-zheng-secretly-pledges-to-liu-bei','liu-bei',1),
('pang-tong-dies-at-luofeng-slope','pang-tong',0),('pang-tong-dies-at-luofeng-slope','liu-bei',1),
('liu-zhang-surrenders-chengdu','liu-bei',0),('liu-zhang-surrenders-chengdu','liu-zhang',1),('liu-zhang-surrenders-chengdu','ma-chao',2),
('liu-bei-contests-hanzhong-with-cao-cao','liu-bei',0),('liu-bei-contests-hanzhong-with-cao-cao','huang-zhong',1),('liu-bei-contests-hanzhong-with-cao-cao','fa-zheng',2)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-SOURCES
-- -------------------------------------------------------------------------

-- Records: primary text on every new event.
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e, sources s
WHERE e.work_id='10000000-0000-4000-8000-000000000006' AND s.id='56000000-0000-4000-8000-000000000001'
  AND (e.id::text LIKE '64000000-0000-4000-8005%' OR e.id::text LIKE '64000000-0000-4000-8006%')
ON CONFLICT DO NOTHING;

-- Records: Zizhi Tongjian cross-reference for the most consequential events.
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.id='56000000-0000-4000-8000-000000000002'
WHERE e.work_id='10000000-0000-4000-8000-000000000006'
  AND e.slug IN ('battle-of-red-cliffs','zhou-yu-dies-at-baqiu','liu-zhang-surrenders-chengdu','liu-bei-contests-hanzhong-with-cao-cao')
ON CONFLICT DO NOTHING;

-- Romance: primary text (Mao edition) on every new event.
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e, sources s
WHERE e.work_id='10000000-0000-4000-8000-000000000007' AND s.id='57000000-0000-4000-8000-000000000001'
  AND (e.id::text LIKE '65000000-0000-4000-8005%' OR e.id::text LIKE '65000000-0000-4000-8006%')
ON CONFLICT DO NOTHING;

-- Romance: Records cross-reference for the historically-grounded shared-slug events.
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.id='57000000-0000-4000-8000-000000000002'
WHERE e.work_id='10000000-0000-4000-8000-000000000007'
  AND e.slug IN ('liu-zong-surrenders-jingzhou','liu-bei-retreat-at-changban','sun-liu-alliance-at-chaisang',
                 'battle-of-red-cliffs','cao-cao-withdraws-north-through-huarong','zhou-yu-takes-jiangling',
                 'liu-bei-takes-four-southern-commanderies','sun-quan-grants-liu-bei-jingzhou',
                 'liu-bei-marries-lady-sun-at-ganlu-temple','zhou-yu-dies-at-baqiu',
                 'liu-zhang-invites-liu-bei-into-yi-province','fa-zheng-secretly-pledges-to-liu-bei',
                 'liu-zhang-surrenders-chengdu','liu-bei-contests-hanzhong-with-cao-cao')
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. CHARACTER RELATIONS (+ relation_translations)
-- -------------------------------------------------------------------------

-- Records (志)
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('74000000-0000-4000-8005-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'liu-bei','sun-quan','ally','bidirectional','positive',5,'active','sun-liu-alliance-at-chaisang',NULL),
(2,'zhuge-liang','sun-quan','ally','source_to_target','positive',3,'active','sun-liu-alliance-at-chaisang',NULL),
(3,'zhou-yu','lu-su','mentor','source_to_target','positive',4,'ended',NULL,'zhou-yu-dies-at-baqiu'),
(4,'zhou-yu','liu-bei','ally','bidirectional','mixed',3,'ended','sun-liu-alliance-at-chaisang','zhou-yu-dies-at-baqiu'),
(5,'ma-chao','liu-bei','ally','source_to_target','positive',3,'active','liu-zhang-surrenders-chengdu',NULL),
(6,'pang-tong','liu-bei','mentor','source_to_target','positive',4,'ended','liu-zhang-invites-liu-bei-into-yi-province','pang-tong-dies-at-luocheng'),
(7,'fa-zheng','liu-bei','mentor','source_to_target','positive',4,'active','liu-zhang-invites-liu-bei-into-yi-province',NULL),
(8,'liu-bei','liu-zhang','adversary','bidirectional','mixed',4,'ended','liu-zhang-invites-liu-bei-into-yi-province','liu-zhang-surrenders-chengdu'),
(9,'huang-zhong','liu-bei','ally','source_to_target','positive',3,'active','liu-bei-contests-hanzhong-with-cao-cao',NULL),
(10,'huang-gai','zhou-yu','ally','source_to_target','positive',4,'ended','battle-of-red-cliffs','zhou-yu-dies-at-baqiu'),
(11,'fa-zheng','liu-zhang','adversary','bidirectional','negative',2,'changed','liu-zhang-invites-liu-bei-into-yi-province','liu-zhang-surrenders-chengdu'),
(12,'cao-cao','zhou-yu','adversary','bidirectional','negative',4,'ended','battle-of-red-cliffs','cao-cao-withdraws-north-through-huarong')
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000006'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000006'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000006'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

-- Romance (演义)
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('75000000-0000-4000-8005-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'liu-bei','sun-quan','ally','bidirectional','positive',5,'active','sun-liu-alliance-at-chaisang',NULL),
(2,'zhou-yu','zhuge-liang','adversary','bidirectional','mixed',4,'ended','sun-liu-alliance-at-chaisang','zhou-yu-dies-at-baqiu'),
(3,'zhuge-liang','lu-su','ally','bidirectional','positive',4,'active','tongue-battle-with-the-scholars',NULL),
(4,'pang-tong','liu-bei','mentor','source_to_target','positive',4,'ended','liu-zhang-invites-liu-bei-into-yi-province','pang-tong-dies-at-luofeng-slope'),
(5,'fa-zheng','liu-bei','mentor','source_to_target','positive',4,'active','liu-zhang-invites-liu-bei-into-yi-province',NULL),
(6,'fa-zheng','liu-zhang','adversary','bidirectional','negative',2,'changed','liu-zhang-invites-liu-bei-into-yi-province','liu-zhang-surrenders-chengdu'),
(7,'liu-bei','liu-zhang','adversary','bidirectional','mixed',4,'ended','liu-zhang-invites-liu-bei-into-yi-province','liu-zhang-surrenders-chengdu'),
(8,'ma-chao','liu-bei','ally','source_to_target','positive',3,'active','liu-zhang-surrenders-chengdu',NULL),
(9,'huang-zhong','liu-bei','ally','source_to_target','positive',3,'active','liu-bei-contests-hanzhong-with-cao-cao',NULL),
(10,'huang-gai','zhou-yu','ally','source_to_target','positive',4,'ended','battle-of-red-cliffs','zhou-yu-dies-at-baqiu'),
(11,'zhou-yu','jiang-gan','adversary','source_to_target','mixed',3,'ended','jiang-gan-is-fooled-at-the-gathering-of-heroes',NULL),
(12,'cao-cao','zhou-yu','adversary','bidirectional','negative',4,'ended','battle-of-red-cliffs','cao-cao-withdraws-north-through-huarong'),
(13,'zhou-yu','lu-su','mentor','source_to_target','positive',4,'ended',NULL,'zhou-yu-dies-at-baqiu'),
(14,'guan-yu','cao-cao','other','bidirectional','mixed',3,'ended',NULL,'guan-yu-releases-cao-cao-at-huarong-road')
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000007'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000007'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000007'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- relation_translations (zh-CN + en, both works matched by from/to slug pair)
INSERT INTO relation_translations(relation_id,locale,label,summary,status)
SELECT r.id,v.locale::locale_code,v.label,v.summary,'published'
FROM character_relations r
JOIN characters fc ON fc.id=r.from_character_id
JOIN characters tc ON tc.id=r.to_character_id
JOIN (VALUES
('liu-bei','sun-quan','zh-CN','孙刘联盟','为拒曹操结成的南方联合阵线。'),
('liu-bei','sun-quan','en','Sun-Liu alliance','The southern coalition formed to resist Cao Cao.'),
('zhuge-liang','sun-quan','zh-CN','联吴使者','奉命赴吴促成结盟的外交关系。'),
('zhuge-liang','sun-quan','en','Envoy to the alliance','The diplomatic tie formed while securing the alliance with Wu.'),
('zhou-yu','lu-su','zh-CN','荐为继任都督','临终举荐接掌兵权的同僚关系。'),
('zhou-yu','lu-su','en','Endorsed as successor','A colleague relation capped by a deathbed recommendation of command.'),
('zhou-yu','liu-bei','zh-CN','联军协同','赤壁之役并肩迎敌又互怀戒心的关系。'),
('zhou-yu','liu-bei','en','Allied command','Fighting side by side at Red Cliffs while each still watched the other warily.'),
('ma-chao','liu-bei','zh-CN','兵败来归','西凉旧将兵败后转投明主。'),
('ma-chao','liu-bei','en','A defeated general’s allegiance','A former Liangzhou commander who turns to a new lord after defeat.'),
('pang-tong','liu-bei','zh-CN','军师中郎将','入蜀方略的主要谋划者与主公。'),
('pang-tong','liu-bei','en','Chief strategist and lord','The chief planner of the Shu campaign and the lord he served.'),
('fa-zheng','liu-bei','zh-CN','谋主','弃旧主而暗助新主取蜀的谋臣关系。'),
('fa-zheng','liu-bei','en','Trusted strategist','An adviser who abandons his old lord to help a new one take Shu.'),
('liu-bei','liu-zhang','zh-CN','受邀反噬','受邀入蜀却终致其失国的关系。'),
('liu-bei','liu-zhang','en','Invited guest turned conqueror','A guest invited in for protection who ultimately takes his host’s land.'),
('huang-zhong','liu-bei','zh-CN','麾下宿将','随军入蜀、屡建战功的老将与主公。'),
('huang-zhong','liu-bei','en','Veteran general and lord','A seasoned general and the lord he wins repeated victories for.'),
('huang-gai','zhou-yu','zh-CN','诈降定计','共谋苦肉计以破敌的都督与部将。'),
('huang-gai','zhou-yu','en','Partners in the feigned surrender','A commander and his subordinate who together plot the ruse that wins Red Cliffs.'),
('fa-zheng','liu-zhang','zh-CN','旧主与叛臣','表面效力实则暗通敌营的君臣关系。'),
('fa-zheng','liu-zhang','en','Lord and a defecting officer','A lord served in name while his officer secretly works for another.'),
('cao-cao','zhou-yu','zh-CN','赤壁交兵','赤壁一役的正面交锋对手。'),
('cao-cao','zhou-yu','en','Adversaries at Red Cliffs','Opposing commanders in the direct clash at Red Cliffs.'),
('zhou-yu','zhuge-liang','zh-CN','既生瑜何生亮','既是对手又不得不协作的复杂关系。'),
('zhou-yu','zhuge-liang','en','Rivals and reluctant partners','“Why, since there was Yu, was there also Liang?” -- rivalry entangled with necessary cooperation.'),
('zhuge-liang','lu-su','zh-CN','联盟中的默契','促成孙刘合作、彼此信任的外交同侪。'),
('zhuge-liang','lu-su','en','Quiet understanding in the alliance','Diplomatic peers who trust each other in bringing the alliance about.'),
('zhou-yu','jiang-gan','zh-CN','反间与戏弄','故交却被都督将计就计的关系。'),
('zhou-yu','jiang-gan','en','Counter-intelligence and mockery','An old friend turned into the unwitting instrument of a counter-intelligence trick.'),
('guan-yu','cao-cao','zh-CN','华容道恩义','因旧日恩义而在绝境中放行的关系。'),
('guan-yu','cao-cao','en','A debt of honor at Huarong Road','A past kindness repaid by letting an enemy escape at the moment of his capture.')
) AS v(fslug,tslug,locale,label,summary)
ON fc.slug=v.fslug AND tc.slug=v.tslug
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. GROUP MEMBERSHIP
-- -------------------------------------------------------------------------
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g
JOIN characters c ON c.work_id=g.work_id
JOIN (VALUES
('wu-commandery','huang-gai'),
('shu-chancellery','pang-tong'),
('shu-chancellery','fa-zheng'),
('shu-generals','ma-chao'),
('shu-generals','huang-zhong')
) AS v(gslug,cslug) ON g.slug=v.gslug AND c.slug=v.cslug
WHERE g.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

-- jiang-gan is Romance-only; add to wei-strategists in that work alone.
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g
JOIN characters c ON c.work_id=g.work_id AND c.slug='jiang-gan'
WHERE g.slug='wei-strategists' AND g.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

COMMIT;
