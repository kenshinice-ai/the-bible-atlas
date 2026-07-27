BEGIN;

-- =========================================================================
-- 039_tk_era_13.sql
-- Three Kingdoms chapter KK=13 slug='jin-unification' (265-280 CE), both
-- works: Records of the Three Kingdoms (work 10000000-0000-4000-8000-000000000006)
-- and Romance of the Three Kingdoms (work 10000000-0000-4000-8000-000000000007).
-- Covers Sima Yan's founding of Jin (266), the Yang Hu-Lu Kang standoff at
-- Jing Province, Yang Hu's deathbed recommendation of Du Yu, Wang Jun's
-- towered warships, the six-army invasion of Wu (279), the breaking of the
-- Xiling river defenses, Sun Hao's surrender at Jianye (280), and the
-- Romance's closing reflection on reunification.
--
-- UUID namespace for this file (KK=8013 band):
--   characters (secondary, new)   4{6|7}000000-0000-4000-8013-############
--   locations  (minor, new)       3{6|7}000000-0000-4000-8013-############
--   events                        6{4|5}000000-0000-4000-8013-############
--   character_relations           7{4|5}000000-0000-4000-8013-############
-- (6=Records/志, 7=Romance/演义 for characters+locations; 4=Records,
--  5=Romance for events+relations, per task-issued prefixes.)
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS (6 secondary figures per work: Yang Hu, Lu Kang, Du Yu,
--    Wang Jun, Sun Hao, Jia Chong)
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
-- Records (志) — historical
('46000000-0000-4000-8013-000000000001','10000000-0000-4000-8000-000000000006','yang-hu',29,'male','adult','protagonist','historical',221,278,'soldier',3),
('46000000-0000-4000-8013-000000000002','10000000-0000-4000-8000-000000000006','lu-kang',30,'male','adult','supporting','historical',226,274,'soldier',3),
('46000000-0000-4000-8013-000000000003','10000000-0000-4000-8000-000000000006','du-yu',31,'male','adult','protagonist','historical',222,285,'soldier',3),
('46000000-0000-4000-8013-000000000004','10000000-0000-4000-8000-000000000006','wang-jun',32,'male','adult','protagonist','historical',206,286,'soldier',3),
('46000000-0000-4000-8013-000000000005','10000000-0000-4000-8000-000000000006','sun-hao',33,'male','adult','antagonist','historical',242,284,'king',3),
('46000000-0000-4000-8013-000000000006','10000000-0000-4000-8000-000000000006','jia-chong',34,'male','adult','supporting','historical',217,282,'person',2),
-- Romance (演义) — fictionalised_historical
('47000000-0000-4000-8013-000000000001','10000000-0000-4000-8000-000000000007','yang-hu',29,'male','adult','protagonist','fictionalised_historical',221,278,'soldier',3),
('47000000-0000-4000-8013-000000000002','10000000-0000-4000-8000-000000000007','lu-kang',30,'male','adult','supporting','fictionalised_historical',226,274,'soldier',3),
('47000000-0000-4000-8013-000000000003','10000000-0000-4000-8000-000000000007','du-yu',31,'male','adult','protagonist','fictionalised_historical',222,285,'soldier',3),
('47000000-0000-4000-8013-000000000004','10000000-0000-4000-8000-000000000007','wang-jun',32,'male','adult','protagonist','fictionalised_historical',206,286,'soldier',3),
('47000000-0000-4000-8013-000000000005','10000000-0000-4000-8000-000000000007','sun-hao',33,'male','adult','antagonist','fictionalised_historical',242,284,'king',3),
('47000000-0000-4000-8013-000000000006','10000000-0000-4000-8000-000000000007','jia-chong',34,'male','adult','supporting','fictionalised_historical',217,282,'person',2)
ON CONFLICT DO NOTHING;

-- Records (志) — 志载/传称 voice.
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('yang-hu','zh-CN','羊祜',ARRAY['叔子']::text[],'晋都督荆州诸军事，泰山南城人，与吴将陆抗对峙十年而不失礼，临终荐杜预自代，未及见天下一统。','都督荆州十年，务农训卒，屡陈灭吴方略，咸宁四年病重还京，垂泣荐杜预自代，不久卒于洛阳。','以德服人，谋成混一大业而不欲多造杀伐。'),
('yang-hu','en','Yang Hu',ARRAY['Shuzi']::text[],'Jin''s commander of Jing Province, a native of Nancheng in Taishan who held a decade-long standoff with Wu''s Lu Kang and recommended Du Yu as his successor on his deathbed.','After a decade commanding Jing Province and repeatedly arguing for the conquest of Wu, he returned to Luoyang gravely ill in 278 and, weeping, recommended Du Yu take his place before dying soon after.','To win over the south through virtue rather than bloodshed, laying the ground for reunification.'),
('lu-kang','zh-CN','陆抗',ARRAY['幼节']::text[],'吴大司马，都督西陵诸军事，陆逊次子，与羊祜对垒而各守礼节，凤凰元年卒后吴之边防渐弛。','镇守西陵十年，与羊祜书信往还、赠药馈酒而不相疑，屡谏孙皓修德防边，未获采纳。','恪守臣节，虽知国势难挽仍尽忠戍边。'),
('lu-kang','en','Lu Kang',ARRAY['Youjie']::text[],'Wu''s Grand Marshal commanding the Xiling frontier, Lu Xun''s second son, who held courteous relations with Yang Hu even in opposition; Wu''s defenses weakened after his death in 274.','He held Xiling for a decade, exchanging letters, medicine, and wine with Yang Hu without suspicion, and repeatedly urged Sun Hao to govern virtuously and strengthen the border, without success.','To hold his post loyally in defense of a state he knew was failing.'),
('du-yu','zh-CN','杜预',ARRAY['元凯','杜武库']::text[],'晋都督荆州诸军事，京兆杜陵人，受羊祜临终举荐，太康元年率军会同诸道伐吴，克江陵定江南。','受命自代羊祜都督荆州，太康元年率军攻克江陵，传檄而定江南诸郡，后又领兵会师建业。','承羊祜遗志，务求一战而定江南。'),
('du-yu','en','Du Yu',ARRAY['Yuankai','Arsenal of Books']::text[],'A native of Duling in Jingzhao who succeeded Yang Hu as commander of Jing Province and in 280 led the Jin advance that took Jiangling and secured the south.','Appointed to succeed Yang Hu at Jing Province, he captured Jiangling in 280 and secured the southern commanderies by proclamation before joining the converging armies at Jianye.','To fulfill Yang Hu''s legacy by settling the south in a single decisive campaign.'),
('wang-jun','zh-CN','王濬',ARRAY['士治']::text[],'益州刺史，弘农湖县人，受命于益州造大船，太康元年舟师顺流东下，先诸军抵建业受孙皓之降。','历时七年督造楼船战舰，方百二十步，可容二千余人，太康元年率舟师东下，克丹阳、西陵、乐乡诸城，直抵建业。','精研舟师之利，欲以水军之力毕其功于一役。'),
('wang-jun','en','Wang Jun',ARRAY['Shizhi']::text[],'Inspector of Yizhou, a native of Hu County in Hongnong who was ordered to build a great fleet in Yizhou and in 280 sailed it downriver ahead of every other column to receive Sun Hao''s surrender at Jianye.','He spent seven years overseeing the construction of towered warships each holding over two thousand men, then in 280 sailed downriver taking Danyang, Xiling, and Lexiang before reaching Jianye.','To perfect naval power and deliver victory in a single decisive stroke.'),
('sun-hao','zh-CN','孙皓',ARRAY['元宗','归命侯']::text[],'吴末代皇帝，孙权之孙，在位十六年暴虐失德，太康元年王濬兵临建业，面缚舆榇出降，吴亡。','嗣位后猜忌臣下，谏者多获罪，太康元年王濬舟师至城下，用群臣之谋自缚双手、衔璧舆榇出降，后封归命侯，卒于洛阳。','耽于逸乐，猜忌臣下，终至举国离心。'),
('sun-hao','en','Sun Hao',ARRAY['Yuanzong','Marquis of Guiming']::text[],'Wu''s last emperor, Sun Quan''s grandson, whose sixteen-year reign grew notorious for cruelty; he surrendered bound before Wang Jun''s forces at Jianye in 280, ending Wu.','Suspicious of his officials, he punished those who advised him; when Wang Jun''s fleet reached the city in 280 he bound his own hands, held a jade disc in his mouth, and brought a coffin as he surrendered, later dying in Luoyang as Marquis of Guiming.','Given to indulgence and suspicion of his officials, he alienated the state he ruled.'),
('jia-chong','zh-CN','贾充',ARRAY['公闾']::text[],'晋开国功臣，平阳襄陵人，受禅之际执节授玺，后为伐吴之役名义都督，太康元年吴平进封鲁郡公。','魏晋禅代之际执节相礼，太康元年伐吴以其为大都督，实总调度而不亲临战阵，事后仍以功进封。','依附司马氏以谋权位，晚年犹图自保功名。'),
('jia-chong','en','Jia Chong',ARRAY['Gonglü']::text[],'A founding minister of Jin from Xiangling in Pingyang who held the ceremonial tally at Wei''s abdication and later served as nominal supreme commander of the invasion of Wu, enfeoffed Duke of Lu after 280.','He held the ceremonial tally at the Wei-to-Jin abdication rites and, though named supreme commander of the Wu campaign, directed it from the rear rather than the field, still receiving high honors afterward.','To attach himself to the Sima house to secure power, guarding his own standing to the end.')
) AS v(slug,locale,name,aliases,summary,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

-- Romance (演义) — 小说叙写 voice.
INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('yang-hu','zh-CN','羊祜',ARRAY['叔子']::text[],'都督荆襄的晋室名将，与陆抗互赠酒药、按兵不掩，君子之交传为美谈，临终泣荐杜预自代。','小说描写其宽仁得军民之心，与陆抗书信往还各守边境，抗染疾则遗药，己犒酒则抗亦不疑而饮，临终泣谏武帝伐吴并荐杜预。','欲以仁德感召吴人，不战而屈人之兵。'),
('yang-hu','en','Yang Hu',ARRAY['Shuzi']::text[],'Jin''s celebrated commander at Jing Province, whose gentlemanly exchanges of wine and medicine with Lu Kang became legend, who wept as he recommended Du Yu on his deathbed.','The novel portrays his generosity winning the hearts of soldiers and civilians, his correspondence with Lu Kang across the border, and his tearful deathbed plea to the emperor to strike Wu, naming Du Yu his successor.','To move Wu''s people through benevolence, subduing them without battle.'),
('lu-kang','zh-CN','陆抗',ARRAY['幼节']::text[],'陆逊之子，继承父风镇守西陵，与羊祜书信往来、义不掩人之丧，惜英年病逝，吴国自此再无良将可当西陵之任。','小说写其虽为敌国仍以诚待羊祜，屡谏孙皓修德防边而不见纳，病逝后西陵防务顿失倚仗。','忠于吴室，虽敬重强敌仍恪尽戍边之责。'),
('lu-kang','en','Lu Kang',ARRAY['Youjie']::text[],'Lu Xun''s son, inheriting his father''s bearing at Xiling, exchanging courteous letters with Yang Hu and refusing to exploit a rival''s mourning, dying young after which Wu had no general left to match his post.','The novel shows him treating his enemy Yang Hu with sincerity despite their rival allegiances, repeatedly urging Sun Hao toward virtue and vigilance, unheeded before his early death left Xiling exposed.','Loyal to the house of Wu, he guarded the frontier faithfully even while respecting a formidable rival.'),
('du-yu','zh-CN','杜预',ARRAY['元凯','杜武库']::text[],'羊祜临终荐其自代，人称"杜武库"，博学多能，统荆州之众策应六路大军，势如破竹，一举定江南。','小说写其受命自代羊祜，用兵沉稳而果决，率军克江陵，与诸路会师建业，一战而定江南诸郡。','继羊祜遗命，誓将平吴大业毕于一役。'),
('du-yu','en','Du Yu',ARRAY['Yuankai','Arsenal of Books']::text[],'Recommended by the dying Yang Hu, nicknamed the Arsenal for his encyclopedic learning, he commanded the Jing Province forces alongside the six-army invasion, advancing like splitting bamboo to secure the south.','The novel shows him taking Yang Hu''s place with calm resolve, capturing Jiangling and converging with the other columns at Jianye to settle the southern provinces in a single stroke.','Sworn to carry out his mentor Yang Hu''s dying wish and complete the conquest of Wu in one campaign.'),
('wang-jun','zh-CN','王濬',ARRAY['士治']::text[],'益州刺史王濬奉命造楼船战舰，方百二十步，上可驰马，又凿沉铁锥、烧断横江铁锁，楼船顺流而下，直取石头城，竟先诸军而入建业受降，与王浑争功几生嫌隙。','小说浓墨描写其造船之巧、破锁之勇，楼船先至石头城下，受孙皓面缚之降，事后又因功劳之争与同僚生隙。','一心造就无敌楼船，誓要率先攻入建业。'),
('wang-jun','en','Wang Jun',ARRAY['Shizhi']::text[],'Inspector of Yizhou, ordered to build towering warships broad enough to gallop a horse across, he melted through sunken iron spikes and river-spanning chains with fire rafts, reaching Jianye ahead of every other column and nearly clashing with Wang Hun over credit.','The novel lavishes attention on his shipbuilding and his fiery breakthrough at the iron chains, his fleet arriving first at Stone City to receive Sun Hao''s surrender before a dispute over credit follows.','Determined to build an unrivaled fleet and be first to break into Jianye.'),
('sun-hao','zh-CN','孙皓',ARRAY['元宗','归命侯']::text[],'孙权之孙，嗣位残暴，忠谏者多遭杀戮，不听吾彦木屑之警，终致王濬楼船直入建业，面缚出降，与蜀汉刘禅故事相映成一代兴亡之叹。','小说描写其沉溺酒色、猜忌大臣，拒纳吾彦、陆抗等忠谏，终至国破身降，效刘禅故事自缚舆榇出城。','沉溺酒色，拒纳忠言，终致社稷倾覆。'),
('sun-hao','en','Sun Hao',ARRAY['Yuanzong','Marquis of Guiming']::text[],'Sun Quan''s grandson, whose tyrannical reign saw honest advisors put to death; ignoring the drifting-timber warning, he watched Wang Jun''s warships sail into Jianye, surrendering bound in mourning dress, his fall echoing Liu Shan''s before him.','The novel portrays him sunk in drink and pleasure, suspicious of his ministers, dismissing the warnings of Wu Yan and Lu Kang alike, until his kingdom collapsed and he followed Liu Shan''s example of bound surrender.','Sunk in drink and pleasure, refusing honest counsel, he brought his own state to ruin.'),
('jia-chong','zh-CN','贾充',ARRAY['公闾']::text[],'晋室重臣，受禅大典执节相礼，伐吴之役挂名都督实则畏难持重，战后仍论功封赏，位列开国元勋。','小说写其于禅代之际执礼相授，伐吴时挂帅而心存观望，待捷报传来仍分沾大功。','趋附权势，借佐命之功保全自身富贵。'),
('jia-chong','en','Jia Chong',ARRAY['Gonglü']::text[],'A powerful Jin minister who held the ceremonial tally at the abdication rites and served as nominal commander-in-chief of the Wu campaign despite private misgivings, still rewarded as a founding hero once victory was won.','The novel shows him presiding over the abdication ceremony and nominally leading the Wu campaign while privately hesitant, sharing nonetheless in the glory once the victory was reported.','Aligning himself with power, he used his role in the founding to secure his own fortune.')
) AS v(slug,locale,name,aliases,summary,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. LOCATIONS (2 minor sites per work: Xiling, Stone City)
-- -------------------------------------------------------------------------
INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('36000000-0000-4000-8013-000000000001','10000000-0000-4000-8000-000000000006','xiling','real',ST_GeogFromText('POINT(111.3500 30.7500)'),NULL,NULL,39,'battlefield','approximate',12,'CN',false,true),
('36000000-0000-4000-8013-000000000002','10000000-0000-4000-8000-000000000006','stone-city','real',ST_GeogFromText('POINT(118.7460 32.0580)'),NULL,NULL,40,'landmark','approximate',13,'CN',false,true),
('37000000-0000-4000-8013-000000000001','10000000-0000-4000-8000-000000000007','xiling','real',ST_GeogFromText('POINT(111.3500 30.7500)'),NULL,NULL,39,'battlefield','approximate',12,'CN',false,true),
('37000000-0000-4000-8013-000000000002','10000000-0000-4000-8000-000000000007','stone-city','real',ST_GeogFromText('POINT(118.7460 32.0580)'),NULL,NULL,40,'landmark','approximate',13,'CN',false,true)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,status)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published' FROM locations l JOIN (VALUES
('xiling','zh-CN','西陵','长江三峡出口要塞，吴将陆抗都督西陵诸军事之地，晋灭吴时王濬舟师于此烧断铁锁东下。'),
('xiling','en','Xiling','A stronghold at the mouth of the Yangzi''s Three Gorges where Lu Kang commanded Wu''s western defenses, and where Wang Jun''s fleet burned through the river''s iron chains during Jin''s conquest.'),
('stone-city','zh-CN','石头城','建业城西石头山上的军事要塞，晋灭吴时孙皓面缚出降于王濬军前的地点。'),
('stone-city','en','Stone City','A fortress on Stone Mountain west of Jianye, the site where Sun Hao surrendered himself bound before Wang Jun''s forces as Wu fell.')
) AS v(slug,locale,name,summary) ON l.slug=v.slug
WHERE l.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 3. EVENTS (Records = 8 events)
-- -------------------------------------------------------------------------
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,start_month,confidence,chapter_id)
SELECT ('64000000-0000-4000-8013-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'julian'::calendar_system,
       v.y1,v.y2,v.mo,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'sima-yan-accepts-the-wei-abdication',13001,'verified_historical','political','exact',266,266,2,'high','jin-unification'),
(2,'yang-hu-and-lu-kang-mutual-respect-at-jingzhou',13003,'reported_historical','social','range',269,274,NULL::smallint,'medium','jin-unification'),
(3,'yang-hu-deathbed-recommends-du-yu',13005,'verified_historical','political','exact',278,278,11,'high','jin-unification'),
(4,'wang-jun-builds-the-towered-warships',13007,'verified_historical','other','range',269,279,NULL,'medium','jin-unification'),
(5,'sima-yan-launches-the-six-armies-against-wu',13009,'verified_historical','battle','exact',279,279,11,'high','jin-unification'),
(6,'wang-jun-burns-through-the-iron-chains-at-xiling',13011,'verified_historical','battle','exact',280,280,1,'high','jin-unification'),
(7,'sun-hao-surrenders-at-jianye',13013,'verified_historical','political','exact',280,280,3,'high','jin-unification'),
(8,'wang-jun-and-wang-hun-dispute-credit-for-the-conquest',13015,'reported_historical','social','range',280,281,NULL,'low','jin-unification')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,mo,conf,chapter_slug)
JOIN chapters ch ON ch.slug=v.chapter_slug AND ch.work_id='10000000-0000-4000-8000-000000000006';

-- EVENTS (Romance = 9 events)
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,start_month,confidence,chapter_id)
SELECT ('65000000-0000-4000-8013-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'julian'::calendar_system,
       v.y1,v.y2,v.mo,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'sima-yan-accepts-the-wei-abdication',13001,'fictional_with_historical_context','political','exact',266,266,2,'medium','jin-unification'),
(2,'yang-hu-and-lu-kang-mutual-respect-at-jingzhou',13003,'fictional_with_historical_context','social','range',269,274,NULL::smallint,'medium','jin-unification'),
(3,'yang-hu-deathbed-recommends-du-yu',13005,'fictional_with_historical_context','political','exact',278,278,11,'medium','jin-unification'),
(4,'wang-jun-builds-the-towered-warships',13007,'fictional_with_historical_context','other','range',269,279,NULL,'medium','jin-unification'),
(5,'drifting-timber-warns-wu-of-invasion',13009,'reported_historical','discovery','exact',279,279,NULL,'low','jin-unification'),
(6,'sima-yan-launches-the-six-armies-against-wu',13011,'fictional_with_historical_context','battle','exact',279,279,11,'medium','jin-unification'),
(7,'wang-jun-burns-through-the-iron-chains-at-xiling',13013,'fictional_with_historical_context','battle','exact',280,280,1,'medium','jin-unification'),
(8,'sun-hao-surrenders-at-jianye',13015,'fictional_with_historical_context','political','exact',280,280,3,'medium','jin-unification'),
(9,'the-three-kingdoms-reunited-in-jin',13017,'fictional_with_historical_context','political','exact',280,280,NULL,'low','jin-unification')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,mo,conf,chapter_slug)
JOIN chapters ch ON ch.slug=v.chapter_slug AND ch.work_id='10000000-0000-4000-8000-000000000007';

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------
-- Records (志) — 志载/传称 voice.
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tlabel FROM events e JOIN (VALUES
('sima-yan-accepts-the-wei-abdication','zh-CN','司马炎受禅建晋','咸熙二年十二月，魏帝曹奂禅位于晋王司马炎，晋室代魏。','司马昭卒后，子司马炎嗣晋王位，旋即依受禅仪注，使贾充等执节奉玺绶，魏帝曹奂逊位于金墉城，司马炎即皇帝位，改元泰始，魏遂亡。','结束了曹魏自220年以来的国祚，开启晋室统一进程的起点。','约公元266年'),
('sima-yan-accepts-the-wei-abdication','en','Sima Yan Accepts Wei''s Abdication','In the twelfth month of Xianxi 2, Emperor Cao Huan of Wei abdicated to Sima Yan, King of Jin, and Jin replaced Wei.','After Sima Zhao''s death, his son Sima Yan inherited the kingship of Jin and, following the abdication rites with Jia Chong and others bearing the ceremonial tally and seals, received Cao Huan''s abdication at Jinyong; Sima Yan then took the imperial title, proclaiming the Taishi era, and Wei came to an end.','Closed the Wei dynasty that had ruled since 220 and opened the process that would culminate in Jin''s reunification of China.','c. 266 CE'),
('yang-hu-and-lu-kang-mutual-respect-at-jingzhou','zh-CN','羊陆之交：羊祜与陆抗对峙荆州','晋都督羊祜与吴都督陆抗分守荆州边境，相持数年而各守礼节，不趁危相图。','羊祜镇襄阳，陆抗镇西陵，两军对垒而使命往来不绝；陆抗有疾，羊祜遗之药，抗服而不疑；羊祜馈酒于抗军，抗亦饮之。抗尝诫部下曰"彼专为德，我专为暴，是不战而自服也"，劝吴主罢边衅。','荆州边境十年无大战事，晋得以从容筹划灭吴之策；后世传为"羊陆之交"的佳话。','约公元269—274年'),
('yang-hu-and-lu-kang-mutual-respect-at-jingzhou','en','The Yang-Lu Rapport at Jing Province','Jin''s commander Yang Hu and Wu''s commander Lu Kang held the Jing Province border for years in careful mutual courtesy rather than open war.','Yang Hu held Xiangyang while Lu Kang held Xiling, and messages passed between the opposing camps; when Lu Kang fell ill, Yang Hu sent medicine which Lu Kang drank without suspicion, and when Yang Hu sent wine, Lu Kang drank it in turn. Lu Kang warned his officers that virtue alone would win without battle, and urged his sovereign to avoid provoking the border.','A decade of quiet along the Jing Province frontier let Jin plan its conquest of Wu at leisure; the episode became known afterward as the Yang-Lu rapport.','c. 269-274 CE'),
('yang-hu-deathbed-recommends-du-yu','zh-CN','羊祜临终荐杜预自代','羊祜病笃入朝，临终上表力陈伐吴之策，并荐杜预自代都督荆州。','羊祜久镇荆州，屡陈灭吴方略而朝议未决，咸宁四年病重还京，晋武帝亲往问疾，羊祜垂泣荐杜预代己，并言"吴人虐政已甚，可不战而克"，不久卒于洛阳，天下闻之痛惜。','羊祜身后其伐吴方略为杜预、王濬所继承，终促成太康元年的统一之役。','约公元278年'),
('yang-hu-deathbed-recommends-du-yu','en','Yang Hu Recommends Du Yu on His Deathbed','Gravely ill, Yang Hu returned to court and, on his deathbed, urged the invasion of Wu and recommended Du Yu as his successor.','Having long argued for a campaign against Wu without winning over the court, Yang Hu returned to Luoyang in 278 as his illness worsened; Emperor Wu of Jin visited him in person, and Yang Hu, in tears, recommended Du Yu to take his place, insisting Wu''s misgovernment had grown so severe that it could be conquered without a fight. He died in Luoyang soon after, mourned throughout the realm.','His strategy for conquering Wu was carried forward by Du Yu and Wang Jun, culminating in the reunification campaign of 280.','c. 278 CE'),
('wang-jun-builds-the-towered-warships','zh-CN','王濬于益州造楼船','益州刺史王濬奉命大造舟舰，楼船方百二十步，可容二千余人。','王濬受命于益州整军备战，历时七年督造楼船战舰，舟大者可载马驰骋其上，又以木屑弃于江中，顺流而下，吴建平太守见而知晋将有舟师之谋，然孙皓不以为意。','楼船水军的建成是太康元年伐吴一役顺流东下、直取建业的关键力量。','约公元269—279年'),
('wang-jun-builds-the-towered-warships','en','Wang Jun Builds the Towered Warships in Yizhou','Wang Jun, Inspector of Yizhou, was ordered to build a great fleet whose towered warships were broad enough to gallop a horse across.','Ordered to prepare in Yizhou, Wang Jun spent seven years overseeing the construction of towered warships large enough to carry horses; wood shavings from the work drifted downriver, and Wu''s governor of Jianping recognized the sign of a coming Jin fleet, though Sun Hao paid it no heed.','This fleet became the decisive force that sailed downriver to take Jianye directly in the 280 campaign.','c. 269-279 CE'),
('sima-yan-launches-the-six-armies-against-wu','zh-CN','晋发六路大军伐吴','太康元年，晋武帝下诏发兵二十余万，分六路并进伐吴。','司马炎纳杜预、张华之议，决意伐吴，以贾充为大都督，分遣王濬、杜预、王浑、胡奋、司马伷、王戎等六路并进，水陆齐发，直指建业。','这是三国末期规模最大的统一战役，标志晋灭吴、天下归一的开始。','约公元279年'),
('sima-yan-launches-the-six-armies-against-wu','en','Jin Launches Six Armies Against Wu','In 279, Emperor Wu of Jin ordered more than two hundred thousand troops mobilized in six columns against Wu.','Adopting the counsel of Du Yu and Zhang Hua, Sima Yan resolved on the invasion, naming Jia Chong nominal supreme commander and dispatching Wang Jun, Du Yu, Wang Hun, Hu Fen, Sima Zhou, and Wang Rong in six coordinated columns by land and river toward Jianye.','The largest unifying campaign of the late Three Kingdoms period, marking the start of Jin''s conquest of Wu and reunification of the realm.','c. 279 CE'),
('wang-jun-burns-through-the-iron-chains-at-xiling','zh-CN','王濬烧断西陵铁锁','吴人于西陵峡以铁锁、铁锥横江拒守，王濬以火炬熔锥烧锁，楼船顺流东下。','吴于险要处置铁锥沉于江中，并横铁锁以阻船，王濬预造大筏，使善水者推筏先行以触锥，复以麻油灌炬，置船前烧铁锁，须臾之间锁绝筏坏，舟师遂无阻而下。','突破西陵天险是六路伐吴中决定性的一战，自此晋师顺流长驱直入吴境腹地。','约公元280年'),
('wang-jun-burns-through-the-iron-chains-at-xiling','en','Wang Jun Burns Through the Iron Chains at Xiling','Wu had set sunken iron spikes and river-spanning chains at Xiling; Wang Jun''s men melted the spikes and burned through the chains with fire rafts.','Wu had planted iron spikes beneath the water and stretched iron chains across the gorge; Wang Jun sent large rafts manned by swimmers ahead to strike the spikes, then set hemp-oil torches on rafts before his ships to burn through the chains, clearing the way within moments for his fleet to press on unopposed.','Breaking the natural stronghold at Xiling was the decisive action of the six-column campaign, opening the Yangzi for Jin''s fleet to drive deep into Wu territory.','c. 280 CE'),
('sun-hao-surrenders-at-jianye','zh-CN','孙皓面缚出降','王濬舟师直抵建业，吴主孙皓面缚衔璧，舆榇出降，吴亡。','王濬楼船先诸军至石头城下，孙皓用光禄勋薛莹等之谋，仿刘禅故事，自缚双手、口衔玉璧、身随棺木出城请降，晋悉收其图籍，吴之四州、四十三郡遂入于晋。','孙皓出降标志三国鼎立局面终结，天下复归一统。','约公元280年'),
('sun-hao-surrenders-at-jianye','en','Sun Hao Surrenders at Jianye','Wang Jun''s fleet reached Jianye directly, and Sun Hao, following the precedent of Liu Shan, bound himself and surrendered with a coffin borne behind him, ending Wu.','Wang Jun''s towered ships arrived at Stone City ahead of every other column; on the advice of officials including Xue Ying, Sun Hao bound his own hands, held a jade disc in his mouth, and had a coffin carried behind him as he came out to surrender. Jin took possession of Wu''s registers, and its four provinces and forty-three commanderies passed to Jin.','Sun Hao''s surrender marked the end of the three-way division of the realm and the return of China to a single rule.','c. 280 CE'),
('wang-jun-and-wang-hun-dispute-credit-for-the-conquest','zh-CN','王濬与王浑争功','吴平之后，都督王浑以王濬违令专进为由奏劾其罪，朝廷终裁定王濬有功无罪。','王浑军次未至建业而王濬已先受降，王浑忿其专擅，上表弹劾；王濬亦自陈战功，朝议纷纭，司马炎终念其平吴大功，不加罪责，加封辅国大将军。','这场争功公案暴露晋初功臣间的猜忌，也从侧面印证王濬破吴之功实为首功。','约公元280—281年'),
('wang-jun-and-wang-hun-dispute-credit-for-the-conquest','en','Wang Jun and Wang Hun Dispute Credit for the Conquest','After Wu''s fall, commander Wang Hun accused Wang Jun of disobeying orders by advancing alone; the court ultimately ruled that Wang Jun had committed no offense.','Wang Hun''s column had not yet reached Jianye when Wang Jun accepted the surrender alone, and the resentful Wang Hun submitted a memorial accusing him of insubordination; Wang Jun defended his actions, and after extended debate at court Sima Yan, mindful of his decisive role in conquering Wu, absolved him and further honored him as General Who Guards the State.','The dispute exposed rivalries among Jin''s founding generals even as it confirmed, in effect, that Wang Jun''s fleet had delivered the decisive stroke against Wu.','c. 280-281 CE')
) AS v(slug,locale,title,summary,detail,sig,tlabel) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000006';

-- Romance (演义) — 小说叙写 voice.
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tlabel FROM events e JOIN (VALUES
('sima-yan-accepts-the-wei-abdication','zh-CN','司马炎受禅建晋','魏帝曹奂效汉献帝故事，三让而后禅位，晋王司马炎登坛受禅，魏祚遂终。','小说叙写晋王司马炎承父兄基业，群臣劝进，仿魏受汉禅之礼，筑坛受命，魏主曹奂如当年汉献帝逊位一般，退居金墉城，史家评曰"天下大势，又逢一合"。','与全书开篇"合久必分，分久必合"之语遥相呼应，预示三分归晋的结局。','约公元266年'),
('sima-yan-accepts-the-wei-abdication','en','Sima Yan Accepts Wei''s Abdication','Following the old precedent of Emperor Xian of Han, Cao Huan of Wei thrice declined before yielding the throne, and Sima Yan ascended the altar to receive it, ending Wei.','The novel recounts how Sima Yan, heir to his father''s and brother''s accumulated power, mounted an altar to accept the ministers'' petition in a ceremony mirroring Wei''s own reception of Han''s abdication, while Cao Huan withdrew to Jinyong just as Emperor Xian once had.','Echoes the novel''s opening line that the realm, long divided, must reunite, foreshadowing the coming reunification under Jin.','c. 266 CE'),
('yang-hu-and-lu-kang-mutual-respect-at-jingzhou','zh-CN','羊陆之交','羊祜镇荆襄，与吴都督陆抗互通使命，赠酒馈药，两军按兵不动，传为一时美谈。','小说描写羊祜宽仁得军民之心，与陆抗书信往还，各守边境而不相侵；陆抗染疾，羊祜遣医赠药，抗欣然服之；羊祜以酒犒抗军，抗亦不疑而饮，时人称二人之交虽为敌国，义气不减。','塑造了乱世中敌对双方相知相重的形象，为后文吴国无良将可继而衰亡埋下伏笔。','约公元269—274年'),
('yang-hu-and-lu-kang-mutual-respect-at-jingzhou','en','The Yang-Lu Rapport','Garrisoned at Jing Province, Yang Hu exchanged courtesies with Wu''s commander Lu Kang, sending wine and medicine across the lines while both armies held their positions, a story long remembered.','The novel portrays Yang Hu''s generosity winning the hearts of soldiers and civilians alike as he corresponded with Lu Kang, each holding his own border without encroachment; when Lu Kang fell ill, Yang Hu sent a physician and medicine, which Lu Kang gladly took, and when Yang Hu sent wine to Lu Kang''s camp, it too was drunk without suspicion, the two enemies bound by an unlikely mutual respect.','Portrays rival commanders capable of honoring one another even in a divided age, setting up Wu''s later decline once no successor of Lu Kang''s caliber remained.','c. 269-274 CE'),
('yang-hu-deathbed-recommends-du-yu','zh-CN','羊祜临终荐杜预','羊祜病笃，晋武帝亲临探视，祜含泪力陈伐吴之计，并荐杜预自代，言讫而卒。','小说描写羊祜抱病还朝，武帝亲往问疾，祜泣谏当乘吴主失德、速图江东，并荐杜预继其任；帝感其忠，许之。未几羊祜病逝，朝野闻讯无不哀痛，荆州百姓为之罢市。','以感人至深的托付场景，承接羊祜十年经营荆州之功业，过渡到杜预、王濬完成灭吴大业。','约公元278年'),
('yang-hu-deathbed-recommends-du-yu','en','Yang Hu Recommends Du Yu on His Deathbed','Gravely ill, Yang Hu was visited by Emperor Wu in person; weeping, he urged the conquest of Wu and recommended Du Yu to succeed him, then died.','The novel depicts Yang Hu returning to court in illness, the emperor visiting his sickbed, and Yang Hu, in tears, urging that Wu be struck now while its rule had grown corrupt, naming Du Yu as his successor; the emperor, moved, agreed. Yang Hu died soon after, and Jing Province''s people are said to have closed their markets in mourning.','A moving scene of succession that carries Yang Hu''s decade of work in Jing Province forward into Du Yu and Wang Jun''s completion of the conquest.','c. 278 CE'),
('wang-jun-builds-the-towered-warships','zh-CN','王濬造大船','益州刺史王濬奉张华、羊祜遗策，大造战舰，方百二十步，上可立马驰骋。','小说描写王濬受命于成都造船，舟形如城，楼橹数重，可容二千余人，又设长木为筏，先探水道；造船木屑蔽江而下，吴人拾之知晋有大举，然孙皓不以为然。','楼船大军是六路伐吴中破江防、直取建业的关键，亦是全书"分久必合"结局最具象征意味的准备。','约公元269—279年'),
('wang-jun-builds-the-towered-warships','en','Wang Jun Builds the Great Ships','Following the strategy left by Zhang Hua and Yang Hu, Wang Jun, Inspector of Yizhou, built warships broad enough to gallop a horse across their decks.','The novel recounts Wang Jun building his fleet at Chengdu, vessels shaped like floating fortresses with towered decks holding over two thousand men each, and rafts sent ahead to probe the channel; wood shavings from the construction covered the river downstream, a sign Wu''s people gathered but which Sun Hao dismissed.','The towered fleet becomes the decisive instrument that breaks Wu''s river defenses and reaches Jianye directly, the novel''s most vivid symbol of the coming reunification.','c. 269-279 CE'),
('drifting-timber-warns-wu-of-invasion','zh-CN','木屑蔽江，吴彦进谏不纳','建平太守吾彦见江中木屑，知晋将有大举，进谏孙皓宜加防备，孙皓不纳。','小说描写吾彦拾江中所漂木屑，断言上流必有晋人造船伐吴之举，遂上表请增兵备防西陵；孙皓耽于酒色，视为妄言，不加理会，西陵防务由此愈发空虚。','以小人物的先见反衬孙皓之昏聩，为其后西陵失守、王濬长驱直入埋下直接伏笔。','约公元279年'),
('drifting-timber-warns-wu-of-invasion','en','Drifting Wood Shavings Warn of Invasion','Wu Yan, Governor of Jianping, saw wood shavings drifting down the river and warned Sun Hao that Jin was preparing a major campaign, but Sun Hao ignored him.','The novel has Wu Yan gather the shavings floating downstream and conclude that Jin must be building a fleet upstream, petitioning for reinforcements at Xiling; but Sun Hao, absorbed in drink and pleasure, dismisses the warning as idle talk, leaving Xiling''s defenses hollow.','The overlooked foresight of a minor official throws Sun Hao''s negligence into relief and directly sets up the fall of Xiling and Wang Jun''s unimpeded advance.','c. 279 CE'),
('sima-yan-launches-the-six-armies-against-wu','zh-CN','晋发六路大军伐吴','晋武帝纳张华、杜预之谏，决意伐吴，命贾充总督军事，分六路大军并进。','小说描写朝中群臣多以吴有长江之险谏阻，惟张华、杜预力主速伐；武帝遂命贾充为大都督，王濬、杜预等六路并进，水陆齐下，声势浩大。','全书末段最大规模的军事行动，正式开启统一天下的终局篇章。','约公元279年'),
('sima-yan-launches-the-six-armies-against-wu','en','Jin Launches Six Armies Against Wu','Persuaded by Zhang Hua and Du Yu, Emperor Wu of Jin resolved on the invasion, naming Jia Chong overall commander of six columns advancing together.','The novel shows most ministers cautioning that the Yangzi''s natural defenses made Wu unconquerable, save Zhang Hua and Du Yu, who pressed for immediate action; the emperor thus named Jia Chong supreme commander, with Wang Jun, Du Yu, and others advancing in six columns by land and water in overwhelming force.','The novel''s largest military operation in its closing chapters, formally opening the final act of reunification.','c. 279 CE'),
('wang-jun-burns-through-the-iron-chains-at-xiling','zh-CN','火烧铁锁破西陵','吴人以铁锥铁锁横断江道，王濬以麻油灌炬，乘筏先焚，须臾锁断锥沉，楼船长驱东下。','小说浓墨重彩描写此役：吴人于西陵凿沉铁锥、横铁锁以为江防，王濬预造大筏数十，以草人披甲立其上诱吴军出击，复用麻油灌炬置于船首，遇锁即焚，顷刻锁镕锥没，楼船遂长驱无阻。','全书最具场面感的水战场景之一，象征晋军势如破竹，吴国天险尽失。','约公元280年'),
('wang-jun-burns-through-the-iron-chains-at-xiling','en','Fire Melts the Chains at Xiling','Wu had blocked the river at Xiling with sunken spikes and iron chains; Wang Jun set hemp-oil torches ablaze on rafts sent ahead, and the chains melted and spikes gave way within moments, letting his fleet drive on.','The novel gives this battle vivid treatment: Wu had sunk iron spikes and strung chains across Xiling as a river defense, while Wang Jun sent dozens of great rafts, some bearing straw men in armor to draw Wu''s fire, and set torches soaked in hemp oil at the bows of his ships; on contact the chains melted and the spikes sank, and the towered fleet advanced unhindered.','One of the novel''s most spectacular naval set-pieces, symbolizing Jin''s unstoppable momentum as Wu''s natural defenses collapse.','c. 280 CE'),
('sun-hao-surrenders-at-jianye','zh-CN','孙皓面缚出降','王濬楼船先至石头城下，孙皓效法蜀汉刘禅故事，自缚舆榇出城请降，吴亡。','小说描写王濬舟师顺流而下，直抵石头城，城中震恐；孙皓用群臣之谋，仿刘禅出降旧例，自缚双手、拉榇随身，出城拜伏于王濬马前，三国鼎立之局至此终结。','与前文蜀汉刘禅出降情节前后映照，共同烘托全书"分久必合"的历史宿命。','约公元280年'),
('sun-hao-surrenders-at-jianye','en','Sun Hao Surrenders at Jianye','Wang Jun''s fleet reached Stone City first, and Sun Hao, following Liu Shan''s earlier precedent, bound himself and had a coffin carried out as he surrendered, ending Wu.','The novel describes Wang Jun''s ships sailing straight downriver to Stone City as the city trembled in fear; on his ministers'' counsel Sun Hao followed Liu Shan''s earlier example, binding his own hands and bringing a coffin behind him as he bowed before Wang Jun''s horse, closing the era of three divided kingdoms.','Mirrors Liu Shan''s earlier surrender, together underscoring the novel''s central theme that long division must end in reunion.','c. 280 CE'),
('the-three-kingdoms-reunited-in-jin','zh-CN','三分归一统','吴主既降，三国鼎立之势尽归于晋，应验开篇"天下大势，分久必合"之语。','小说于末回总收全书，历数汉末以来群雄并起、三分鼎立、终归于晋的兴亡大势，附诗慨叹"纷纷世事无穷尽，天数茫茫不可逃"，以孙皓、刘禅相继出降之事收束全篇。','呼应第一回"话说天下大势，分久必合，合久必分"的开篇之语，为全书画上历史循环的句点。','约公元280年'),
('the-three-kingdoms-reunited-in-jin','en','The Three Kingdoms Reunited Under Jin','With Wu''s ruler surrendered, the three-way division of the realm resolved entirely into Jin, fulfilling the novel''s opening claim that long division must end in unity.','The novel''s final chapter surveys the whole sweep of history from Han''s collapse through the rise of rival warlords to the three-way division and its resolution under Jin, closing with a poem lamenting that worldly affairs never cease and fate cannot be escaped, framed by the successive surrenders of Sun Hao and Liu Shan before him.','Echoes the novel''s opening line that the realm, long divided, must unite, and long united, must divide, closing the book on a historical cycle.','c. 280 CE')
) AS v(slug,locale,title,summary,detail,sig,tlabel) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000007';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,v.role,v.pos FROM events e JOIN (VALUES
-- Records (志)
('sima-yan-accepts-the-wei-abdication','luoyang','primary',0),
('yang-hu-and-lu-kang-mutual-respect-at-jingzhou','xiangyang','primary',0),
('yang-hu-and-lu-kang-mutual-respect-at-jingzhou','jiangling','secondary',1),
('yang-hu-deathbed-recommends-du-yu','luoyang','primary',0),
('wang-jun-builds-the-towered-warships','chengdu','primary',0),
('sima-yan-launches-the-six-armies-against-wu','luoyang','primary',0),
('wang-jun-burns-through-the-iron-chains-at-xiling','xiling','primary',0),
('sun-hao-surrenders-at-jianye','jianye','primary',0),
('sun-hao-surrenders-at-jianye','stone-city','secondary',1),
('wang-jun-and-wang-hun-dispute-credit-for-the-conquest','luoyang','primary',0)
) AS v(eslug,lslug,role,pos) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,v.role,v.pos FROM events e JOIN (VALUES
-- Romance (演义)
('sima-yan-accepts-the-wei-abdication','luoyang','primary',0),
('yang-hu-and-lu-kang-mutual-respect-at-jingzhou','xiangyang','primary',0),
('yang-hu-and-lu-kang-mutual-respect-at-jingzhou','jiangling','secondary',1),
('yang-hu-deathbed-recommends-du-yu','luoyang','primary',0),
('wang-jun-builds-the-towered-warships','chengdu','primary',0),
('drifting-timber-warns-wu-of-invasion','xiling','primary',0),
('sima-yan-launches-the-six-armies-against-wu','luoyang','primary',0),
('wang-jun-burns-through-the-iron-chains-at-xiling','xiling','primary',0),
('sun-hao-surrenders-at-jianye','jianye','primary',0),
('sun-hao-surrenders-at-jianye','stone-city','secondary',1),
('the-three-kingdoms-reunited-in-jin','jianye','primary',0),
('the-three-kingdoms-reunited-in-jin','luoyang','secondary',1)
) AS v(eslug,lslug,role,pos) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
-- Records (志)
('sima-yan-accepts-the-wei-abdication','sima-yan',0),('sima-yan-accepts-the-wei-abdication','jia-chong',1),
('yang-hu-and-lu-kang-mutual-respect-at-jingzhou','yang-hu',0),('yang-hu-and-lu-kang-mutual-respect-at-jingzhou','lu-kang',1),
('yang-hu-deathbed-recommends-du-yu','yang-hu',0),('yang-hu-deathbed-recommends-du-yu','du-yu',1),('yang-hu-deathbed-recommends-du-yu','sima-yan',2),
('wang-jun-builds-the-towered-warships','wang-jun',0),
('sima-yan-launches-the-six-armies-against-wu','sima-yan',0),('sima-yan-launches-the-six-armies-against-wu','jia-chong',1),('sima-yan-launches-the-six-armies-against-wu','du-yu',2),('sima-yan-launches-the-six-armies-against-wu','wang-jun',3),
('wang-jun-burns-through-the-iron-chains-at-xiling','wang-jun',0),
('sun-hao-surrenders-at-jianye','sun-hao',0),('sun-hao-surrenders-at-jianye','wang-jun',1),
('wang-jun-and-wang-hun-dispute-credit-for-the-conquest','wang-jun',0),('wang-jun-and-wang-hun-dispute-credit-for-the-conquest','jia-chong',1),('wang-jun-and-wang-hun-dispute-credit-for-the-conquest','sima-yan',2)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
-- Romance (演义)
('sima-yan-accepts-the-wei-abdication','sima-yan',0),('sima-yan-accepts-the-wei-abdication','jia-chong',1),
('yang-hu-and-lu-kang-mutual-respect-at-jingzhou','yang-hu',0),('yang-hu-and-lu-kang-mutual-respect-at-jingzhou','lu-kang',1),
('yang-hu-deathbed-recommends-du-yu','yang-hu',0),('yang-hu-deathbed-recommends-du-yu','du-yu',1),('yang-hu-deathbed-recommends-du-yu','sima-yan',2),
('wang-jun-builds-the-towered-warships','wang-jun',0),
('drifting-timber-warns-wu-of-invasion','sun-hao',0),
('sima-yan-launches-the-six-armies-against-wu','sima-yan',0),('sima-yan-launches-the-six-armies-against-wu','jia-chong',1),('sima-yan-launches-the-six-armies-against-wu','du-yu',2),('sima-yan-launches-the-six-armies-against-wu','wang-jun',3),
('wang-jun-burns-through-the-iron-chains-at-xiling','wang-jun',0),
('sun-hao-surrenders-at-jianye','sun-hao',0),('sun-hao-surrenders-at-jianye','wang-jun',1),
('the-three-kingdoms-reunited-in-jin','sima-yan',0),('the-three-kingdoms-reunited-in-jin','sun-hao',1),('the-three-kingdoms-reunited-in-jin','liu-shan',2)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title LIKE 'Records of the Three Kingdoms%'
WHERE e.work_id='10000000-0000-4000-8000-000000000006' AND e.id::text LIKE '64000000-0000-4000-8013%'
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title LIKE 'Romance of the Three Kingdoms%'
WHERE e.work_id='10000000-0000-4000-8000-000000000007' AND e.id::text LIKE '65000000-0000-4000-8013%'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS (+ relation_translations, zh-CN + en required)
-- -------------------------------------------------------------------------
-- Records (志)
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('74000000-0000-4000-8013-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000006',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'sima-yan','jia-chong','ally','bidirectional','positive',4,'active','sima-yan-accepts-the-wei-abdication',NULL),
(2,'sima-yan','yang-hu','ally','source_to_target','positive',4,'ended',NULL,'yang-hu-deathbed-recommends-du-yu'),
(3,'yang-hu','lu-kang','adversary','bidirectional','positive',4,'ended','yang-hu-and-lu-kang-mutual-respect-at-jingzhou',NULL),
(4,'yang-hu','du-yu','mentor','source_to_target','positive',4,'ended','yang-hu-deathbed-recommends-du-yu',NULL),
(5,'sima-yan','sun-hao','adversary','bidirectional','negative',4,'ended','sima-yan-launches-the-six-armies-against-wu','sun-hao-surrenders-at-jianye'),
(6,'wang-jun','sun-hao','adversary','source_to_target','negative',3,'ended','wang-jun-burns-through-the-iron-chains-at-xiling','sun-hao-surrenders-at-jianye'),
(7,'wang-jun','jia-chong','adversary','bidirectional','mixed',2,'ended','wang-jun-and-wang-hun-dispute-credit-for-the-conquest',NULL),
(8,'lu-kang','sun-hao','other','source_to_target','mixed',3,'ended',NULL,NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000006'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000006'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000006'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000006'
ON CONFLICT DO NOTHING;

INSERT INTO relation_translations(relation_id,locale,label,status,summary)
SELECT r.id,v.locale::locale_code,v.label,'published',v.summary
FROM character_relations r
JOIN characters fc ON fc.id=r.from_character_id
JOIN characters tc ON tc.id=r.to_character_id
JOIN (VALUES
('sima-yan','jia-chong','ally','zh-CN','开国君臣','贾充受禅之际执节授玺，后又总督伐吴之役，始终为司马炎倚重的心腹重臣。'),
('sima-yan','jia-chong','ally','en','Founding sovereign and minister','Jia Chong held the ceremonial tally at the abdication and later served as nominal commander of the Wu campaign, remaining Sima Yan''s trusted confidant throughout.'),
('sima-yan','yang-hu','ally','zh-CN','君主与柱石之臣','司马炎倚重羊祜镇守荆州十年，临终亲往探视，深为悼惜。'),
('sima-yan','yang-hu','ally','en','Sovereign and pillar of the state','Sima Yan relied on Yang Hu to hold Jing Province for a decade and personally visited his deathbed, mourning deeply at his loss.'),
('yang-hu','lu-kang','adversary','zh-CN','敌国相敬的对手','两人分守荆州边境，互赠酒药而不相疑，后世传为"羊陆之交"。'),
('yang-hu','lu-kang','adversary','en','Respectful adversaries across the border','The two held opposite ends of the Jing Province border, exchanging wine and medicine without suspicion, remembered afterward as the Yang-Lu rapport.'),
('yang-hu','du-yu','mentor','zh-CN','荐主与继任者','羊祜临终力荐杜预自代都督荆州，伐吴之策赖以延续。'),
('yang-hu','du-yu','mentor','en','Patron and successor','On his deathbed, Yang Hu strongly recommended Du Yu as his successor over Jing Province, ensuring his strategy against Wu would continue.'),
('sima-yan','sun-hao','adversary','zh-CN','兴晋之主与亡国之君','司马炎发六路大军伐吴，孙皓兵败面缚出降，吴亡而天下归晋。'),
('sima-yan','sun-hao','adversary','en','Jin''s founding emperor and Wu''s fallen ruler','Sima Yan launched six armies against Wu, and Sun Hao, defeated, surrendered bound before him, ending Wu and returning the realm to Jin.'),
('wang-jun','sun-hao','adversary','zh-CN','伐国之将与出降之主','王濬楼船破西陵而下，先诸军抵建业，受孙皓之降。'),
('wang-jun','sun-hao','adversary','en','Conquering general and surrendering sovereign','Wang Jun''s fleet broke through Xiling and reached Jianye ahead of every other column, receiving Sun Hao''s surrender.'),
('wang-jun','jia-chong','adversary','zh-CN','争功的同僚','王濬破吴后与王浑争功，贾充等朝臣议其罪责，终获司马炎宽宥。'),
('wang-jun','jia-chong','adversary','en','Rival colleagues over credit','After conquering Wu, Wang Jun found himself accused amid the dispute with Wang Hun, with ministers including Jia Chong weighing his culpability before Sima Yan finally absolved him.'),
('lu-kang','sun-hao','other','zh-CN','忠臣与失德之主','陆抗屡次上疏谏止孙皓奢暴，虽尽忠效命，终未能挽救吴之国势。'),
('lu-kang','sun-hao','other','en','Loyal general and a ruler beset by misrule','Lu Kang repeatedly petitioned against Sun Hao''s excess and cruelty, and though he served loyally to the end, he could not reverse Wu''s decline.')
) AS v(fslug,tslug,rtype,locale,label,summary) ON fc.slug=v.fslug AND tc.slug=v.tslug AND r.relation_type=v.rtype
WHERE r.work_id='10000000-0000-4000-8000-000000000006' AND r.id::text LIKE '74000000-0000-4000-8013%'
ON CONFLICT DO NOTHING;

-- Romance (演义)
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('75000000-0000-4000-8013-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000007',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'sima-yan','jia-chong','ally','bidirectional','positive',4,'active','sima-yan-accepts-the-wei-abdication',NULL),
(2,'sima-yan','yang-hu','ally','source_to_target','positive',4,'ended',NULL,'yang-hu-deathbed-recommends-du-yu'),
(3,'yang-hu','lu-kang','adversary','bidirectional','positive',4,'ended','yang-hu-and-lu-kang-mutual-respect-at-jingzhou',NULL),
(4,'yang-hu','du-yu','mentor','source_to_target','positive',4,'ended','yang-hu-deathbed-recommends-du-yu',NULL),
(5,'sima-yan','sun-hao','adversary','bidirectional','negative',4,'ended','sima-yan-launches-the-six-armies-against-wu','sun-hao-surrenders-at-jianye'),
(6,'wang-jun','sun-hao','adversary','source_to_target','negative',3,'ended','wang-jun-burns-through-the-iron-chains-at-xiling','sun-hao-surrenders-at-jianye'),
(7,'wang-jun','jia-chong','adversary','bidirectional','mixed',2,'ended',NULL,NULL),
(8,'lu-kang','sun-hao','other','source_to_target','mixed',3,'ended',NULL,NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000007'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000007'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000007'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000007'
ON CONFLICT DO NOTHING;

INSERT INTO relation_translations(relation_id,locale,label,status,summary)
SELECT r.id,v.locale::locale_code,v.label,'published',v.summary
FROM character_relations r
JOIN characters fc ON fc.id=r.from_character_id
JOIN characters tc ON tc.id=r.to_character_id
JOIN (VALUES
('sima-yan','jia-chong','ally','zh-CN','开国君臣','受禅大典执节相礼，伐吴之役挂名都督，贾充始终追随司马炎左右，同享开国之功。'),
('sima-yan','jia-chong','ally','en','Founding sovereign and minister','Holding the ceremonial tally at the abdication rite and serving as nominal commander in the Wu campaign, Jia Chong stood at Sima Yan''s side throughout, sharing in the credit for founding Jin.'),
('sima-yan','yang-hu','ally','zh-CN','君主与柱石之臣','武帝素重羊祜之谋，病革之际亲临探视，泣纳其伐吴之谏。'),
('sima-yan','yang-hu','ally','en','Sovereign and pillar of the state','Emperor Wu long valued Yang Hu''s counsel and visited him in person as his illness worsened, weeping as he accepted his final plea to conquer Wu.'),
('yang-hu','lu-kang','adversary','zh-CN','敌国相敬的对手','羊祜陆抗虽为敌国，书信往还、赠酒馈药，彼此以诚相待，传为千古美谈。'),
('yang-hu','lu-kang','adversary','en','Respectful adversaries across the border','Though serving rival states, Yang Hu and Lu Kang corresponded, exchanged wine and medicine, and treated one another with sincerity, a story remembered for ages.'),
('yang-hu','du-yu','mentor','zh-CN','荐主与继任者','羊祜含泪举杜预自代，武帝允之，杜预遂承其遗志克成灭吴大功。'),
('yang-hu','du-yu','mentor','en','Patron and successor','Weeping, Yang Hu recommended Du Yu take his place, and with the emperor''s assent Du Yu carried his mentor''s ambition through to the conquest of Wu.'),
('sima-yan','sun-hao','adversary','zh-CN','兴晋之主与亡国之君','司马炎兴师伐吴，孙皓面缚舆榇出降，应验"分久必合"之数。'),
('sima-yan','sun-hao','adversary','en','Jin''s founding emperor and Wu''s fallen ruler','Sima Yan raised his armies against Wu, and Sun Hao surrendered bound with a coffin borne behind him, fulfilling the novel''s prophecy that division must end in unity.'),
('wang-jun','sun-hao','adversary','zh-CN','伐国之将与出降之主','王濬楼船直入石头城下，孙皓面缚出城，拜伏于其马前请降。'),
('wang-jun','sun-hao','adversary','en','Conquering general and surrendering sovereign','Wang Jun''s towered ships sailed straight to Stone City, and Sun Hao came out bound to bow before his horse and surrender.'),
('wang-jun','jia-chong','adversary','zh-CN','争功的同僚','王濬平吴后遭同僚构陷争功，贾充等于朝堂论其是非，幸得武帝主持公道。'),
('wang-jun','jia-chong','adversary','en','Rival colleagues over credit','After Wu''s fall, Wang Jun faced accusations from a rival colleague over credit, debated at court by ministers including Jia Chong, until the emperor himself set the matter right.'),
('lu-kang','sun-hao','other','zh-CN','忠臣与失德之主','陆抗镇守西陵，屡谏孙皓修德防边，惜其不纳，终致晋师有隙可乘。'),
('lu-kang','sun-hao','other','en','Loyal general and a ruler beset by misrule','Lu Kang held Xiling and repeatedly urged Sun Hao to govern virtuously and strengthen the border, but his advice went unheeded, leaving an opening Jin would later exploit.')
) AS v(fslug,tslug,rtype,locale,label,summary) ON fc.slug=v.fslug AND tc.slug=v.tslug AND r.relation_type=v.rtype
WHERE r.work_id='10000000-0000-4000-8000-000000000007' AND r.id::text LIKE '75000000-0000-4000-8013%'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 10. GROUP MEMBERSHIP (existing groups wei-strategists, wu-commandery,
--     house-of-sun)
-- -------------------------------------------------------------------------
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g
JOIN characters c ON c.work_id=g.work_id
JOIN (VALUES
('wei-strategists','yang-hu'),
('wei-strategists','du-yu'),
('wei-strategists','wang-jun'),
('wei-strategists','jia-chong'),
('wu-commandery','lu-kang'),
('house-of-sun','sun-hao')
) AS v(group_slug,char_slug) ON g.slug=v.group_slug AND c.slug=v.char_slug
WHERE g.work_id IN ('10000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007')
ON CONFLICT DO NOTHING;

COMMIT;
