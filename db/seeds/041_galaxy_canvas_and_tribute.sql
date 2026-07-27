BEGIN;

-- Galaxy atlas: canvas completion + the tribute statement.
--
-- WHY THIS FILE EXISTS: seed 040 declared 39 bodies a closed list, drawn from
-- the blueprint's skeleton table. Walking the twelve eras event by event
-- turned up six places the films actually visit that the table had missed —
-- the outpost where the twins are born, the casino world, and four of the
-- final film's worlds. Closing the list before checking it against the
-- content was the error; adding them here and closing it now is the fix.
--
-- After this file the canvas is 45 bodies and IS closed. Era seeds may add
-- surface places (a city, a temple, a base) inheriting a parent body's
-- coordinates within ±1, and nothing else.
--
-- Coordinates follow section 5 of seed 040: centre (50,38), Core 0-10,
-- Inner Rim 10-16, Mid Rim 16-34, Outer Rim 34-50, Unknown Regions by bearing
-- (x < 22). Each value below was checked against that table before writing.

-- ============================================================
-- 1. SIX MORE BODIES
-- ============================================================

INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('38000000-0000-4000-8000-000000000040','10000000-0000-4000-8000-000000000008','polis-massa','fictional',NULL,63,80,40,'space_station','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000041','10000000-0000-4000-8000-000000000008','cantonica','fictional',NULL,44,55,41,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000042','10000000-0000-4000-8000-000000000008','pasaana','fictional',NULL,86,60,42,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000043','10000000-0000-4000-8000-000000000008','kijimi','fictional',NULL,86,32,43,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000044','10000000-0000-4000-8000-000000000008','kef-bir','fictional',NULL,32,73,44,'moon','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000045','10000000-0000-4000-8000-000000000008','ajan-kloss','fictional',NULL,22,60,45,'moon','fictional',8,NULL,false,NULL)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name,status) VALUES
('38000000-0000-4000-8000-000000000040','zh-CN','波利斯麻沙','外环的小行星医疗设施,天行者双胞胎在此出生。','{}','','','','','外环南','published'),
('38000000-0000-4000-8000-000000000040','en','Polis Massa','An asteroid medical facility in the Outer Rim; the Skywalker twins are born here.','{}','','','','','Outer Rim, south','published'),
('38000000-0000-4000-8000-000000000041','zh-CN','坎托尼卡','沙漠星球,滨海赌城建于其上,靠军火交易致富。','{"坎托湾"}','','','','','中环','published'),
('38000000-0000-4000-8000-000000000041','en','Cantonica','A desert world carrying a seaside casino city grown rich on the arms trade.','{"Canto Bight"}','','','','','Mid Rim','published'),
('38000000-0000-4000-8000-000000000042','zh-CN','帕萨纳','沙漠星球,每四十二年举行一次庆典。','{}','','','','','外环东','published'),
('38000000-0000-4000-8000-000000000042','en','Pasaana','A desert world that holds its festival once every forty-two years.','{}','','','','','Outer Rim, east','published'),
('38000000-0000-4000-8000-000000000043','zh-CN','奇吉米','冰封山地星球,第一秩序占领下的走私者据点。','{}','','','','','外环东北','published'),
('38000000-0000-4000-8000-000000000043','en','Kijimi','A frozen mountain world; a smugglers’ haven under First Order occupation.','{}','','','','','Outer Rim, north-east','published'),
('38000000-0000-4000-8000-000000000044','zh-CN','凯夫比尔','恩多的海洋卫星,第二死星残骸坠落其上。','{}','','','','','外环西','published'),
('38000000-0000-4000-8000-000000000044','en','Kef Bir','An ocean moon of Endor, where the second battle station’s wreckage came down.','{}','','','','','Outer Rim, west','published'),
('38000000-0000-4000-8000-000000000045','zh-CN','阿贾恩克洛斯','丛林卫星,抵抗组织在最后阶段的基地。','{}','','','','','外环西','published'),
('38000000-0000-4000-8000-000000000045','en','Ajan Kloss','A jungle moon serving as the Resistance base in the final phase.','{}','','','','','Outer Rim, west','published')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 2. TRIBUTE AND NON-COMMERCIAL STATEMENT
-- ============================================================

-- Sits in the citation list beside the dating and canvas policies, because it
-- is the same kind of thing: a statement about how this atlas relates to what
-- it indexes. The same wording is carried in the page footer.
INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type) VALUES
('58000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000008','Tribute and non-commercial statement',NULL,'Every entry in this atlas is written in tribute to the original films. This is an index built to make them easier to navigate — nothing here is offered as a substitute for watching them, and nothing here is used commercially: no advertising, no fees, no donations. All entry text is original writing; the films and their names remain the property of their rights holders.','reference','reference')
ON CONFLICT DO NOTHING;

INSERT INTO source_translations(source_id,locale,title,citation,status) VALUES
('58000000-0000-4000-8000-000000000012','zh-CN','致敬与非商业声明','本图集的全部条目均为向原著影片致敬而写。它是一份便于检索的索引,不能也不打算替代观影;全站不作任何商业用途——无广告、不收费、不接受打赏。条目文字均为本站原创,影片及其名称、标志的权利仍属各自权利人。','published'),
('58000000-0000-4000-8000-000000000012','en','Tribute and non-commercial statement','Every entry in this atlas is written in tribute to the original films. This is an index built to make them easier to navigate — nothing here is offered as a substitute for watching them, and nothing here is used commercially: no advertising, no fees, no donations. All entry text is original writing; the films and their names remain the property of their rights holders.','published')
ON CONFLICT DO NOTHING;

COMMIT;
