BEGIN;

-- Three Kingdoms structural seed: two works (Records / Romance), 13 parallel
-- eras (chapters), 14 parallel character groups, sources, and chronologies.
-- No characters/events/relations here — this is skeleton only, per
-- blueprint/WORK_TEMPLATE.md and blueprint/EXAMPLE_THREE_KINGDOMS.md.
--
-- UUID namespace (new, unused before this seed):
--   works            10000000-0000-4000-8000-000000000006/7   (Records/Romance)
--   chapters         8{6|7}000000-... no — see below (works use 06/07, chapters/groups use dedicated prefixes)
--   chapters         84/85000000-0000-4000-80KK-000000000001   (KK = era 01-13)
--   character_groups 86/87000000-0000-4000-8000-0000000000NN  (NN = group 01-14)
--   sources          56/57000000-0000-4000-8000-0000000000NN
--   work_chronologies 91000000-0000-4000-8000-000000000003/4/5 (continues existing 01/02)
--
-- Era accent colours are shared between both works per this seed's brief
-- (same slug/sequence/era years/accent_color); two of the blueprint's
-- suggested hexes (07 jing-province-and-yiling, 09 northern-expeditions)
-- were retuned for >=4.5:1 contrast against the #0F172A panel and #1C1917
-- label ink, following the db/seeds/025 lesson. All 13 pass:
--   01 #C9A227(7.38/7.23) 02 #C0703F(4.79/4.69) 03 #A9825A(5.12/5.02)
--   04 #6E86A8(4.79/4.70) 05 #4E9B8F(5.45/5.34) 06 #8FA352(6.40/6.27)
--   07 #BC6D6D(4.72/4.62, retuned from #B25858) 08 #9C7BC0(5.11/5.00)
--   09 #C76C61(4.88/4.79, retuned from #C25E52) 10 #B39A55(6.52/6.39)
--   11 #B98A6B(5.87/5.75) 12 #8B7F9E(4.78/4.69) 13 #C9BC8F(9.41/9.22)

-- ============================================================
-- 1. WORKS + work_translations
-- ============================================================

INSERT INTO works(id,slug,author_name,publication_year,content_mode,map_layer,default_locale,launch_rank,mode_reason,category,origin_region,chronology_start_year,chronology_end_year,theme_color,theme_color_dark,theme_color_light) VALUES
('10000000-0000-4000-8000-000000000006','records-of-the-three-kingdoms','Chen Shou 陈寿',NULL,'documented_record','real','zh-CN',6,'An official history compiled from court annals and biographies, with Pei Songzhi''s commentary; event-level reality and confidence must be shown alongside the Romance''s fictionalised parallel.','historical_document','China',184,280,'#B39A55','#62552F','#D5C7A2'),
('10000000-0000-4000-8000-000000000007','romance-of-the-three-kingdoms','Luo Guanzhong 罗贯中',1522,'literary_narrative','real','zh-CN',7,'A historical-fiction novel built on the documented fall of Han and rise of the Three Kingdoms, blending verified history with legendary and invented episodes; event-level reality and confidence must be shown.','historical_fiction','China',184,280,'#C25E52','#6B342D','#DDA6A0');

INSERT INTO work_translations(work_id,locale,title,summary,status) VALUES
('10000000-0000-4000-8000-000000000006','zh-CN','三国志','陈寿所撰的三国正史，以纪传体记述汉末群雄割据至西晋统一的兴亡历程。','published'),
('10000000-0000-4000-8000-000000000006','en','Records of the Three Kingdoms','Chen Shou''s official history of the Three Kingdoms period, recording the fall of Han through Jin''s reunification in annals-and-biographies form.','published'),
('10000000-0000-4000-8000-000000000007','zh-CN','三国演义','罗贯中据史敷演的长篇章回小说，以文学笔法重述汉末乱世至三国鼎立的英雄谱系。','published'),
('10000000-0000-4000-8000-000000000007','en','Romance of the Three Kingdoms','Luo Guanzhong''s episodic historical novel, retelling the fall of Han and the rise of the Three Kingdoms through literary embellishment and legend.','published');

-- ============================================================
-- 2. CHAPTERS (13 eras x 2 works) + chapter_translations
-- ============================================================

INSERT INTO chapters(id,work_id,slug,sequence,reference_label,era_start_year,era_end_year,accent_color) VALUES
('84000000-0000-4000-8001-000000000001','10000000-0000-4000-8000-000000000006','yellow-turban-rising',1,'魏書一 武帝紀（黃巾）',184,189,'#C9A227'),
('84000000-0000-4000-8002-000000000001','10000000-0000-4000-8000-000000000006','dong-zhuo-usurpation',2,'魏書一 武帝紀；後漢書 董卓傳',189,192,'#C0703F'),
('84000000-0000-4000-8003-000000000001','10000000-0000-4000-8000-000000000006','warlords-contending',3,'魏書一 武帝紀',192,199,'#A9825A'),
('84000000-0000-4000-8004-000000000001','10000000-0000-4000-8000-000000000006','guandu-and-the-north',4,'魏書一 武帝紀；魏書六 袁紹傳',200,207,'#6E86A8'),
('84000000-0000-4000-8005-000000000001','10000000-0000-4000-8000-000000000006','red-cliffs',5,'魏書一 武帝紀；吳書九 周瑜傳',208,209,'#4E9B8F'),
('84000000-0000-4000-8006-000000000001','10000000-0000-4000-8000-000000000006','three-spheres-forming',6,'蜀書二 先主傳',209,218,'#8FA352'),
('84000000-0000-4000-8007-000000000001','10000000-0000-4000-8000-000000000006','jing-province-and-yiling',7,'蜀書六 關羽傳；蜀書二 先主傳',219,222,'#BC6D6D'),
('84000000-0000-4000-8008-000000000001','10000000-0000-4000-8000-000000000006','three-thrones',8,'魏書二 文帝紀；蜀書二 先主傳；吳書二 吳主傳',220,229,'#9C7BC0'),
('84000000-0000-4000-8009-000000000001','10000000-0000-4000-8000-000000000006','northern-expeditions',9,'蜀書五 諸葛亮傳',228,234,'#C76C61'),
('84000000-0000-4000-8010-000000000001','10000000-0000-4000-8000-000000000006','wei-court-and-regency',10,'魏書四 三少帝紀',235,254,'#B39A55'),
('84000000-0000-4000-8011-000000000001','10000000-0000-4000-8000-000000000006','jiang-wei-and-the-last-campaigns',11,'蜀書十四 姜維傳；魏書二十八 諸葛誕傳',249,262,'#B98A6B'),
('84000000-0000-4000-8012-000000000001','10000000-0000-4000-8000-000000000006','fall-of-shu',12,'蜀書三 後主傳；魏書四 三少帝紀',263,265,'#8B7F9E'),
('84000000-0000-4000-8013-000000000001','10000000-0000-4000-8000-000000000006','jin-unification',13,'晉書 武帝紀',265,280,'#C9BC8F'),
('85000000-0000-4000-8001-000000000001','10000000-0000-4000-8000-000000000007','yellow-turban-rising',1,'第一回至第二回',184,189,'#C9A227'),
('85000000-0000-4000-8002-000000000001','10000000-0000-4000-8000-000000000007','dong-zhuo-usurpation',2,'第三回至第九回',189,192,'#C0703F'),
('85000000-0000-4000-8003-000000000001','10000000-0000-4000-8000-000000000007','warlords-contending',3,'第十回至第十六回',192,199,'#A9825A'),
('85000000-0000-4000-8004-000000000001','10000000-0000-4000-8000-000000000007','guandu-and-the-north',4,'第十七回至第三十回',200,207,'#6E86A8'),
('85000000-0000-4000-8005-000000000001','10000000-0000-4000-8000-000000000007','red-cliffs',5,'第四十三回至第五十回',208,209,'#4E9B8F'),
('85000000-0000-4000-8006-000000000001','10000000-0000-4000-8000-000000000007','three-spheres-forming',6,'第五十一回至第六十回',209,218,'#8FA352'),
('85000000-0000-4000-8007-000000000001','10000000-0000-4000-8000-000000000007','jing-province-and-yiling',7,'第七十三回至第八十四回',219,222,'#BC6D6D'),
('85000000-0000-4000-8008-000000000001','10000000-0000-4000-8000-000000000007','three-thrones',8,'第八十回至第八十五回',220,229,'#9C7BC0'),
('85000000-0000-4000-8009-000000000001','10000000-0000-4000-8000-000000000007','northern-expeditions',9,'第九十一回至第一百零四回',228,234,'#C76C61'),
('85000000-0000-4000-8010-000000000001','10000000-0000-4000-8000-000000000007','wei-court-and-regency',10,'第一百零六回至第一百零七回',235,254,'#B39A55'),
('85000000-0000-4000-8011-000000000001','10000000-0000-4000-8000-000000000007','jiang-wei-and-the-last-campaigns',11,'第一百零七回至第一百十三回',249,262,'#B98A6B'),
('85000000-0000-4000-8012-000000000001','10000000-0000-4000-8000-000000000007','fall-of-shu',12,'第一百十五回至第一百十八回',263,265,'#8B7F9E'),
('85000000-0000-4000-8013-000000000001','10000000-0000-4000-8000-000000000007','jin-unification',13,'第一百十九回至第一百二十回',265,280,'#C9BC8F');

-- 志 (Records) chapter translations — 志载/传称 voice.
INSERT INTO chapter_translations(chapter_id,locale,title,summary,status)
SELECT c.id,v.locale::locale_code,v.title,v.summary,'published' FROM chapters c JOIN (VALUES
('yellow-turban-rising','zh-CN','黄巾之乱','志载黄巾军起、灵帝崩、外戚与宦官相残，汉室权柄自此旁落。'),
('yellow-turban-rising','en','Yellow Turban Rebellion','The Records recounts the Yellow Turban uprising, Emperor Ling''s death, and the clash of consort clans and eunuchs that loosened Han''s grip on power.'),
('dong-zhuo-usurpation','zh-CN','董卓乱政','志载董卓废立、迁都长安，关东诸侯起兵讨董而未能一心。'),
('dong-zhuo-usurpation','en','Dong Zhuo''s Usurpation','The Records records Dong Zhuo''s deposal of an emperor, the forced move to Chang''an, and the disunited eastern coalition raised against him.'),
('warlords-contending','zh-CN','群雄割据','志载曹操、袁术、吕布、刘备等在中原与徐州反复攻伐，格局未定。'),
('warlords-contending','en','Warlords Contending','The Records traces the shifting contests among Cao Cao, Yuan Shu, Lü Bu, and Liu Bei across the central plains and Xuzhou.'),
('guandu-and-the-north','zh-CN','官渡与河北','志载曹操与袁绍会战官渡，继而平定河北，统一中国北方。'),
('guandu-and-the-north','en','Guandu and the North','The Records details Cao Cao''s victory over Yuan Shao at Guandu and his subsequent pacification of Hebei, unifying the north.'),
('red-cliffs','zh-CN','赤壁','志载孙权、刘备联军于赤壁大破曹军，奠定南北分峙之势。'),
('red-cliffs','en','Red Cliffs','The Records records the allied forces of Sun Quan and Liu Bei defeating Cao Cao at Red Cliffs, setting the north–south divide.'),
('three-spheres-forming','zh-CN','三分雏形（取荆入益）','志载刘备借荆州、入益州，孙刘曹三方分据渐成雏形。'),
('three-spheres-forming','en','Three Spheres Forming','The Records records Liu Bei''s hold on Jing Province and his entry into Yi Province, as the three-way division begins to take shape.'),
('jing-province-and-yiling','zh-CN','失荆州与夷陵','志载关羽败亡、荆州失守，刘备伐吴兵败夷陵。'),
('jing-province-and-yiling','en','Loss of Jing Province and Yiling','The Records records Guan Yu''s defeat and the loss of Jing Province, followed by Liu Bei''s disastrous campaign against Wu at Yiling.'),
('three-thrones','zh-CN','三国鼎立（称帝建制）','志载曹丕代汉称帝，刘备、孙权相继称尊，三国正式鼎立。'),
('three-thrones','en','Three Thrones','The Records records Cao Pi''s founding of Wei, followed by Liu Bei''s and Sun Quan''s own imperial titles, formalising the Three Kingdoms.'),
('northern-expeditions','zh-CN','诸葛北伐','志载诸葛亮五次北伐曹魏，终因积劳病逝五丈原。'),
('northern-expeditions','en','Zhuge Liang''s Northern Expeditions','The Records recounts Zhuge Liang''s five northern campaigns against Wei, ending with his death from exhaustion at Wuzhang Plains.'),
('wei-court-and-regency','zh-CN','魏廷与正始之变','志载魏明帝之后主少国疑，司马懿诛曹爽，专擅魏廷政柄。'),
('wei-court-and-regency','en','The Wei Court and the Regency Crisis','The Records records the fragile Wei succession after Emperor Ming and Sima Yi''s purge of Cao Shuang, seizing control of the court.'),
('jiang-wei-and-the-last-campaigns','zh-CN','姜维北伐与淮南三叛','志载姜维屡次北伐，淮南三叛相继而起，魏室内外交困。'),
('jiang-wei-and-the-last-campaigns','en','Jiang Wei''s Campaigns and the Three Rebellions of Huainan','The Records records Jiang Wei''s repeated northern campaigns alongside the three Huainan rebellions that strained Wei from within and without.'),
('fall-of-shu','zh-CN','灭蜀','志载邓艾偷渡阴平，刘禅出降，蜀汉灭亡。'),
('fall-of-shu','en','The Fall of Shu','The Records records Deng Ai''s covert crossing of Yinping and Liu Shan''s surrender, ending Shu Han.'),
('jin-unification','zh-CN','魏晋嬗代与晋并天下','志载司马炎代魏建晋，终灭孙吴，天下复归一统。'),
('jin-unification','en','The Jin Succession and Unification','The Records records Sima Yan''s founding of Jin in Wei''s place and the final conquest of Wu that reunifies the realm.')
) AS v(slug,locale,title,summary) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000006';

-- 演义 (Romance) chapter translations — 小说叙写 voice.
INSERT INTO chapter_translations(chapter_id,locale,title,summary,status)
SELECT c.id,v.locale::locale_code,v.title,v.summary,'published' FROM chapters c JOIN (VALUES
('yellow-turban-rising','zh-CN','黄巾之乱','小说叙写黄巾举事、桃园结义与讨伐黄巾的群雄初现。'),
('yellow-turban-rising','en','Yellow Turban Rebellion','The novel opens with the Yellow Turban revolt, the Peach Garden oath, and the warlords who first rise to suppress it.'),
('dong-zhuo-usurpation','zh-CN','董卓乱政','小说敷演董卓暴虐、王允巧施连环计，终致吕布诛卓。'),
('dong-zhuo-usurpation','en','Dong Zhuo''s Usurpation','The novel dramatises Dong Zhuo''s tyranny and Wang Yun''s chain stratagem, ending with Lü Bu''s killing of his patron.'),
('warlords-contending','zh-CN','群雄割据','小说叙写群雄逐鹿，吕布辕门射戟、白门楼授首等回目次第展开。'),
('warlords-contending','en','Warlords Contending','The novel unfolds the warlords'' scramble for supremacy, including Lü Bu''s archery at the camp gate and his end at White Gate Tower.'),
('guandu-and-the-north','zh-CN','官渡与河北','小说叙写官渡之战曹操以弱胜强，其后北征乌桓，底定河朔。'),
('guandu-and-the-north','en','Guandu and the North','The novel narrates Cao Cao''s underdog triumph at Guandu and his later campaign against the Wuhuan that secures the north.'),
('red-cliffs','zh-CN','赤壁','小说铺陈群英会、连环计与借东风等回目，渲染赤壁鏖兵之奇。'),
('red-cliffs','en','Red Cliffs','The novel elaborates the gathering of talents, the chained-ships ruse, and the borrowed east wind that colour the Red Cliffs campaign.'),
('three-spheres-forming','zh-CN','三分雏形（取荆入益）','小说叙写刘备入川、智取益州，三分天下的格局初现。'),
('three-spheres-forming','en','Three Spheres Forming','The novel narrates Liu Bei''s entry into Shu and his taking of Yi Province, the first outline of a three-way realm.'),
('jing-province-and-yiling','zh-CN','失荆州与夷陵','小说叙写关羽走麦城、刘备兴兵复仇，火烧连营七百里。'),
('jing-province-and-yiling','en','Loss of Jing Province and Yiling','The novel dramatises Guan Yu''s fall at Maicheng and Liu Bei''s vengeful campaign, ending in the burning of the linked camps.'),
('three-thrones','zh-CN','三国鼎立（称帝建制）','小说叙写汉祚终结、二帝相继登基，三国鼎立之局遂定。'),
('three-thrones','en','Three Thrones','The novel narrates the end of Han and the successive enthronements that fix the Three Kingdoms in place.'),
('northern-expeditions','zh-CN','诸葛北伐','小说敷演诸葛亮六出祁山、空城计、木牛流马诸事，至星落秋风五丈原。'),
('northern-expeditions','en','Zhuge Liang''s Northern Expeditions','The novel elaborates Zhuge Liang''s expeditions through Qishan, the Empty Fort ruse, and his death beneath the autumn stars at Wuzhang Plains.'),
('wei-court-and-regency','zh-CN','魏廷与正始之变','小说叙写司马懿装病韬晦、高平陵之变夺权，魏室名存实亡。'),
('wei-court-and-regency','en','The Wei Court and the Regency Crisis','The novel narrates Sima Yi''s feigned illness and the Gaoping Tombs coup, leaving Wei''s ruling house a hollow name.'),
('jiang-wei-and-the-last-campaigns','zh-CN','姜维北伐与淮南三叛','小说叙写姜维继承丞相遗志九伐中原，淮南三叛先后败灭。'),
('jiang-wei-and-the-last-campaigns','en','Jiang Wei''s Campaigns and the Three Rebellions of Huainan','The novel narrates Jiang Wei''s nine campaigns in his mentor''s memory, set against the failed Huainan rebellions.'),
('fall-of-shu','zh-CN','灭蜀','小说叙写邓艾偷渡阴平、诸葛瞻绵竹殉国，后主出降蜀汉终结。'),
('fall-of-shu','en','The Fall of Shu','The novel dramatises Deng Ai''s secret crossing, Zhuge Zhan''s death at Mianzhu, and Liu Shan''s surrender that ends Shu Han.'),
('jin-unification','zh-CN','魏晋嬗代与晋并天下','小说叙写三家归晋，末回以“分久必合”总收百年乱世。'),
('jin-unification','en','The Jin Succession and Unification','The novel closes with the Three Kingdoms'' absorption into Jin, its final chapter gathering a century of division into unity.')
) AS v(slug,locale,title,summary) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000007';

-- ============================================================
-- 3. CHARACTER GROUPS (14 groups x 2 works) + group_translations
-- ============================================================

INSERT INTO character_groups(id,work_id,slug,group_type,sort_order,accent_color) VALUES
('86000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000006','han-court','institution',1,'#C9A227'),
('86000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000006','yellow-turbans','institution',2,'#A9825A'),
('86000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000006','liangzhou-faction','institution',3,'#C0703F'),
('86000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000006','hebei-faction','institution',4,'#6E86A8'),
('86000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000006','house-of-cao','dynasty',5,'#B39A55'),
('86000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000006','house-of-liu','dynasty',6,'#C25E52'),
('86000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000006','house-of-sun','dynasty',7,'#4E9B8F'),
('86000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000006','shu-generals','circle',8,'#BC6D6D'),
('86000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000006','shu-chancellery','circle',9,'#C76C61'),
('86000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000006','wu-commandery','circle',10,'#5FAFA0'),
('86000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000006','wei-strategists','circle',11,'#9C7BC0'),
('86000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000006','jing-province-circle','circle',12,'#8FA352'),
('86000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000006','house-of-sima','dynasty',13,'#C9BC8F'),
('86000000-0000-4000-8000-000000000014','10000000-0000-4000-8000-000000000006','men-of-letters','circle',14,'#A79C86'),
('87000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000007','han-court','institution',1,'#C9A227'),
('87000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000007','yellow-turbans','institution',2,'#A9825A'),
('87000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000007','liangzhou-faction','institution',3,'#C0703F'),
('87000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000007','hebei-faction','institution',4,'#6E86A8'),
('87000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000007','house-of-cao','dynasty',5,'#B39A55'),
('87000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000007','house-of-liu','dynasty',6,'#C25E52'),
('87000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000007','house-of-sun','dynasty',7,'#4E9B8F'),
('87000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000007','shu-generals','circle',8,'#BC6D6D'),
('87000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000007','shu-chancellery','circle',9,'#C76C61'),
('87000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000007','wu-commandery','circle',10,'#5FAFA0'),
('87000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000007','wei-strategists','circle',11,'#9C7BC0'),
('87000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000007','jing-province-circle','circle',12,'#8FA352'),
('87000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000007','house-of-sima','dynasty',13,'#C9BC8F'),
('87000000-0000-4000-8000-000000000014','10000000-0000-4000-8000-000000000007','men-of-letters','circle',14,'#A79C86');

-- 志 (Records) group translations.
INSERT INTO character_group_translations(group_id,locale,name,summary,status)
SELECT g.id,v.locale::locale_code,v.name,v.summary,'published' FROM character_groups g JOIN (VALUES
('han-court','zh-CN','汉室朝廷','志载以汉献帝为核心的朝廷官僚系统，汉末权柄旁落，形同虚设。'),
('han-court','en','Han Imperial Court','The Records situates the court around Emperor Xian of Han, whose bureaucracy retained ritual authority long after real power had slipped away.'),
('yellow-turbans','zh-CN','黄巾军','志载张角兄弟以太平道号召起事的黄巾余部，为汉末大乱之始。'),
('yellow-turbans','en','Yellow Turban Army','The Records records the Yellow Turban forces raised by the Zhang brothers under the Way of Great Peace, the spark of Han''s collapse.'),
('liangzhou-faction','zh-CN','董卓凉州集团','志载董卓所率凉州边军入京擅政的军事集团。'),
('liangzhou-faction','en','Dong Zhuo''s Liangzhou Faction','The Records identifies the Liangzhou frontier army that Dong Zhuo led into the capital to seize control of the court.'),
('hebei-faction','zh-CN','袁绍河北集团','志载袁绍据冀、青、幽、并四州所建的河北军事集团。'),
('hebei-faction','en','Yuan Shao''s Hebei Faction','The Records records Yuan Shao''s Hebei power base spanning Ji, Qing, You, and Bing provinces.'),
('house-of-cao','zh-CN','曹氏霸府（曹魏）','志载曹操及其子孙所建霸府，终代汉建立曹魏。'),
('house-of-cao','en','House of Cao (Wei)','The Records traces the Cao family''s hegemon government, which ultimately supplanted Han to found Wei.'),
('house-of-liu','zh-CN','昭烈帝室（蜀汉）','志载刘备及其子刘禅所建蜀汉帝系，以汉室宗亲自居。'),
('house-of-liu','en','House of Liu (Shu Han)','The Records records the Shu Han imperial line of Liu Bei and his son Liu Shan, who claimed descent from the Han house.'),
('house-of-sun','zh-CN','孙氏江东（孙吴）','志载孙坚、孙策、孙权三代经营江东所建之孙吴政权。'),
('house-of-sun','en','House of Sun (Eastern Wu)','The Records traces three generations of the Sun family—Sun Jian, Sun Ce, and Sun Quan—building the state of Wu in the southeast.'),
('shu-generals','zh-CN','蜀汉武臣','志载关羽、张飞、赵云等随刘备征战的蜀汉将领。'),
('shu-generals','en','Shu Han''s Generals','The Records records the Shu Han generals—Guan Yu, Zhang Fei, Zhao Yun among them—who campaigned alongside Liu Bei.'),
('shu-chancellery','zh-CN','丞相府与北伐幕僚','志载诸葛亮丞相府及历次北伐随行的僚属谋臣。'),
('shu-chancellery','en','The Chancellery and the Northern Expedition Staff','The Records records Zhuge Liang''s chancellery and the staff who accompanied his northern campaigns.'),
('wu-commandery','zh-CN','江东都督府','志载周瑜、鲁肃、吕蒙、陆逊相继任都督统兵的孙吴军府。'),
('wu-commandery','en','The Wu Commandery-in-Chief','The Records records the succession of commanders-in-chief—Zhou Yu, Lu Su, Lü Meng, Lu Xun—who led Wu''s armies.'),
('wei-strategists','zh-CN','魏廷谋主','志载荀彧、郭嘉、司马懿等为曹魏出谋划策的廷臣。'),
('wei-strategists','en','Wei''s Court Strategists','The Records records Xun Yu, Guo Jia, Sima Yi, and other court strategists who counselled the Wei government.'),
('jing-province-circle','zh-CN','荆州集团','志载刘表旧部与刘备入荆后聚拢的荆州本地势力。'),
('jing-province-circle','en','The Jing Province Circle','The Records records Liu Biao''s former retinue and the local Jing Province figures gathered under Liu Bei.'),
('house-of-sima','zh-CN','司马氏','志载司马懿及其子孙专魏政、终代魏建晋的司马氏家族。'),
('house-of-sima','en','House of Sima','The Records traces the Sima family from Sima Yi''s control of Wei''s court to their founding of Jin.'),
('men-of-letters','zh-CN','建安名士与士族','志载建安年间文人名士与世家大族，兼跨魏蜀吴三方。'),
('men-of-letters','en','Jian''an Literati and Gentry Clans','The Records records the literati and gentry clans of the Jian''an era, whose members served across Wei, Shu, and Wu.')
) AS v(slug,locale,name,summary) ON g.slug=v.slug AND g.work_id='10000000-0000-4000-8000-000000000006';

-- 演义 (Romance) group translations.
INSERT INTO character_group_translations(group_id,locale,name,summary,status)
SELECT g.id,v.locale::locale_code,v.name,v.summary,'published' FROM character_groups g JOIN (VALUES
('han-court','zh-CN','汉室朝廷','小说叙写名存实亡的汉室朝廷，为群雄挟天子以令诸侯所环绕。'),
('han-court','en','Han Imperial Court','The novel depicts a Han court reduced to a figurehead, contested by warlords who sought to command the realm in the emperor''s name.'),
('yellow-turbans','zh-CN','黄巾军','小说叙写黄巾举事的道众与残部，为全书群雄并起的序幕。'),
('yellow-turbans','en','Yellow Turban Army','The novel presents the Yellow Turban rebels and their remnants as the opening upheaval that draws every hero onto the stage.'),
('liangzhou-faction','zh-CN','董卓凉州集团','小说叙写董卓凉州兵马纵横洛阳、废立天子的暴虐集团。'),
('liangzhou-faction','en','Dong Zhuo''s Liangzhou Faction','The novel portrays Dong Zhuo''s Liangzhou troops running roughshod over Luoyang and deposing an emperor at will.'),
('hebei-faction','zh-CN','袁绍河北集团','小说叙写袁绍雄踞河北、门第显赫却终败于官渡的世家集团。'),
('hebei-faction','en','Yuan Shao''s Hebei Faction','The novel depicts Yuan Shao''s aristocratic Hebei following, formidable yet undone at Guandu.'),
('house-of-cao','zh-CN','曹氏霸府（曹魏）','小说叙写曹操挟天子以令诸侯、终至曹丕代汉的曹氏一族。'),
('house-of-cao','en','House of Cao (Wei)','The novel follows the Cao clan from commanding the emperor''s name to Cao Pi''s final usurpation of the throne.'),
('house-of-liu','zh-CN','昭烈帝室（蜀汉）','小说叙写以匡扶汉室为志、终至刘禅出降的刘氏帝系。'),
('house-of-liu','en','House of Liu (Shu Han)','The novel portrays the Liu imperial line, sworn to restore Han, down to Liu Shan''s eventual surrender.'),
('house-of-sun','zh-CN','孙氏江东（孙吴）','小说叙写孙氏据守江东、联刘抗曹又终自立为帝的家族基业。'),
('house-of-sun','en','House of Sun (Eastern Wu)','The novel depicts the Sun family holding the southeast, allying with and against their neighbours before founding their own throne.'),
('shu-generals','zh-CN','蜀汉武臣','小说塑造关羽、张飞、赵云等武艺超群、义气深重的蜀汉猛将。'),
('shu-generals','en','Shu Han''s Generals','The novel celebrates Guan Yu, Zhang Fei, Zhao Yun, and their peers as Shu Han''s peerless and loyal warriors.'),
('shu-chancellery','zh-CN','丞相府与北伐幕僚','小说叙写诸葛亮运筹帷幄的丞相府班底及北伐幕僚。'),
('shu-chancellery','en','The Chancellery and the Northern Expedition Staff','The novel depicts Zhuge Liang''s chancellery staff, the planners behind his repeated northern expeditions.'),
('wu-commandery','zh-CN','江东都督府','小说叙写江东历任都督运筹赤壁、荆州诸役的军府班底。'),
('wu-commandery','en','The Wu Commandery-in-Chief','The novel follows the line of Wu commanders who plotted Red Cliffs and the Jing Province campaigns.'),
('wei-strategists','zh-CN','魏廷谋主','小说叙写荀彧、郭嘉、司马懿等运筹帷幄的魏廷谋士群像。'),
('wei-strategists','en','Wei''s Court Strategists','The novel portrays Xun Yu, Guo Jia, Sima Yi, and their peers as the calculating minds behind the Wei court.'),
('jing-province-circle','zh-CN','荆州集团','小说叙写刘表旧属与荆襄名士归附刘备的地方集团。'),
('jing-province-circle','en','The Jing Province Circle','The novel depicts Liu Biao''s former officers and Jing-Xiang notables who came to serve Liu Bei.'),
('house-of-sima','zh-CN','司马氏','小说叙写司马懿隐忍夺权，子孙终篡魏建晋的司马氏一门。'),
('house-of-sima','en','House of Sima','The novel follows Sima Yi''s patient seizure of power through to his descendants'' founding of Jin.'),
('men-of-letters','zh-CN','建安名士与士族','小说叙写建安文坛名士与士族清议之风，点缀于乱世之中。'),
('men-of-letters','en','Jian''an Literati and Gentry Clans','The novel weaves in the Jian''an-era literary figures and gentry opinion that coloured the age of division.')
) AS v(slug,locale,name,summary) ON g.slug=v.slug AND g.work_id='10000000-0000-4000-8000-000000000007';

-- ============================================================
-- 4. SOURCES + source_translations
-- ============================================================

INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type) VALUES
('56000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000006','Records of the Three Kingdoms',NULL,'Chen Shou. Records of the Three Kingdoms (Sanguo Zhi). c. 280–297 CE, with Pei Songzhi''s commentary (429 CE).','primary','primary_text'),
('56000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000006','Zizhi Tongjian',NULL,'Sima Guang. Zizhi Tongjian, juan 59–81. 1084 CE.','scholarly','historical'),
('56000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000006','Three Kingdoms chronology policy',NULL,'Editorial note on the chronological conventions shared by the Records and Romance works.','reference','reference'),
('57000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000007','Romance of the Three Kingdoms (Mao edition)',NULL,'Attributed to Luo Guanzhong, revised by Mao Lun and Mao Zonggang. Jiajing-era edition 1522 CE; Mao commentary edition settled c. 1679 CE.','primary','primary_text'),
('57000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000007','Records of the Three Kingdoms',NULL,'Chen Shou. Records of the Three Kingdoms (Sanguo Zhi). c. 280–297 CE, with Pei Songzhi''s commentary (429 CE).','scholarly','historical'),
('57000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000007','Three Kingdoms chronology policy',NULL,'Editorial note on the chronological conventions shared by the Records and Romance works.','reference','reference');

INSERT INTO source_translations(source_id,locale,title,citation,status) VALUES
('56000000-0000-4000-8000-000000000001','zh-CN','三国志','陈寿《三国志》，约成书于西晋太康年间（280–297年），裴松之注（429年）。','published'),
('56000000-0000-4000-8000-000000000001','en','Records of the Three Kingdoms','Chen Shou, Records of the Three Kingdoms (Sanguo Zhi), compiled c. 280–297 CE, with Pei Songzhi''s commentary (429 CE).','published'),
('56000000-0000-4000-8000-000000000002','zh-CN','资治通鉴','司马光《资治通鉴》卷五十九至八十一，1084年成书。','published'),
('56000000-0000-4000-8000-000000000002','en','Zizhi Tongjian','Sima Guang, Zizhi Tongjian, juan 59–81, completed 1084 CE.','published'),
('56000000-0000-4000-8000-000000000003','zh-CN','三国年代表述政策','志与演义两作品所采年代惯例的编者说明。','published'),
('56000000-0000-4000-8000-000000000003','en','Three Kingdoms chronology policy','Editorial note on the chronological conventions shared by the Records and Romance works.','published'),
('57000000-0000-4000-8000-000000000001','zh-CN','三国演义（毛评本）','罗贯中原著，毛纶、毛宗岗父子评改本，嘉靖本成书于1522年，毛评本定型于清初（约1679年）。','published'),
('57000000-0000-4000-8000-000000000001','en','Romance of the Three Kingdoms (Mao edition)','Attributed to Luo Guanzhong, revised by Mao Lun and Mao Zonggang; the Jiajing-era edition dates to 1522, with the Mao commentary edition settling c. 1679 CE.','published'),
('57000000-0000-4000-8000-000000000002','zh-CN','三国志','陈寿《三国志》，约成书于西晋太康年间（280–297年），裴松之注（429年）。','published'),
('57000000-0000-4000-8000-000000000002','en','Records of the Three Kingdoms','Chen Shou, Records of the Three Kingdoms (Sanguo Zhi), compiled c. 280–297 CE, with Pei Songzhi''s commentary (429 CE).','published'),
('57000000-0000-4000-8000-000000000003','zh-CN','三国年代表述政策','志与演义两作品所采年代惯例的编者说明。','published'),
('57000000-0000-4000-8000-000000000003','en','Three Kingdoms chronology policy','Editorial note on the chronological conventions shared by the Records and Romance works.','published');

-- ============================================================
-- 5. WORK CHRONOLOGIES
-- ============================================================

INSERT INTO work_chronologies(id,work_id,kind,label,start_year,end_year,calendar_system,is_default) VALUES
('91000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000006','historical','Historical chronology (fall of Han to Jin unification)',184,280,'gregorian',true),
('91000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000007','historical','Historical chronology (fall of Han to Jin unification)',184,280,'gregorian',true),
('91000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000007','narrative','Mao-edition chapter sequence (hui 1–120)',NULL,NULL,'unknown',false);

COMMIT;
