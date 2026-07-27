BEGIN;

-- Eras 04 and 05, in one file because era 04 is deliberately thin.
--
--   04 · dark-times            (19-5 BBY, years -19..-5)   — 7 events
--   05 · rebel-alliance-rising (5-0 BBY, years -5..-1)     — 11 events
--
-- Era 04 stays sparse by design: it is the stretch derivative works fill in.
-- What it must carry is the Skywalker line — two hidden children growing up,
-- two Jedi in exile, one father hunting what is left of his order.
-- Bands 4001-4999 and 5001-5999.

-- ============================================================
-- 1. CHARACTERS
-- ============================================================

INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('48000000-0000-4000-8005-000000000001','10000000-0000-4000-8000-000000000008','wedge-antilles',501,'male','adult','supporting','fictional',-21,NULL,'pilot',3),
('48000000-0000-4000-8005-000000000002','10000000-0000-4000-8000-000000000008','admiral-ackbar',502,'male','elder','supporting','fictional',NULL,34,'soldier',3),
('48000000-0000-4000-8005-000000000003','10000000-0000-4000-8000-000000000008','grand-admiral-thrawn',503,'male','adult','antagonist','fictional',NULL,NULL,'ruler',2)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,aliases,detail,motivation,status) VALUES
('48000000-0000-4000-8005-000000000001','zh-CN','韦奇·安蒂列斯','义军飞行员,少数三场大战都活下来的人之一。','{}','','把僚机带回来。','published'),
('48000000-0000-4000-8005-000000000001','en','Wedge Antilles','A rebel pilot, and one of the very few to survive all three major battles.','{}','','Bring his wingmen home.','published'),
('48000000-0000-4000-8005-000000000002','zh-CN','阿克巴上将','蒙卡拉马里人,义军舰队司令。','{}','','用一支临时拼凑的舰队打赢正规军。','published'),
('48000000-0000-4000-8005-000000000002','en','Admiral Ackbar','A Mon Calamari and commander of the Alliance fleet.','{}','','Beat a regular navy with a fleet assembled out of whatever there was.','published'),
('48000000-0000-4000-8005-000000000003','zh-CN','索龙大上将','帝国高级将领,黑暗时代后期的主要压制力量之一。','{}','','以最小代价维持秩序。','published'),
('48000000-0000-4000-8005-000000000003','en','Grand Admiral Thrawn','A senior imperial commander, one of the chief forces holding the later Dark Times down.','{}','','Hold order together at the lowest possible cost.','published')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 2. EVENTS — era 04
-- ============================================================

INSERT INTO events(id,work_id,slug,start_date,end_date,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,start_month,start_day,confidence,chapter_id) VALUES
('68000000-0000-4000-8004-000000000001','10000000-0000-4000-8000-000000000008','the-jedi-are-hunted',NULL,NULL,4001,'fictional_narrative','other','fictional_calendar','fictional',-19,-14,NULL,NULL,'medium','88000000-0000-4000-8004-000000000001'),
('68000000-0000-4000-8004-000000000002','10000000-0000-4000-8000-000000000008','obi-wan-watches-over-luke',NULL,NULL,4003,'fictional_narrative','other','fictional_calendar','fictional',-19,-6,NULL,NULL,'medium','88000000-0000-4000-8004-000000000001'),
('68000000-0000-4000-8004-000000000003','10000000-0000-4000-8000-000000000008','yoda-in-exile-on-dagobah',NULL,NULL,4005,'fictional_narrative','other','fictional_calendar','fictional',-19,-6,NULL,NULL,'medium','88000000-0000-4000-8004-000000000001'),
('68000000-0000-4000-8004-000000000004','10000000-0000-4000-8000-000000000008','leia-raised-on-alderaan',NULL,NULL,4007,'fictional_narrative','other','fictional_calendar','fictional',-19,-6,NULL,NULL,'medium','88000000-0000-4000-8004-000000000001'),
('68000000-0000-4000-8004-000000000005','10000000-0000-4000-8000-000000000008','the-senate-is-kept-as-a-shell',NULL,NULL,4009,'fictional_with_historical_context','political','fictional_calendar','fictional',-19,-6,NULL,NULL,'medium','88000000-0000-4000-8004-000000000001'),
('68000000-0000-4000-8004-000000000006','10000000-0000-4000-8000-000000000008','the-battle-station-begins-construction',NULL,NULL,4011,'fictional_narrative','other','fictional_calendar','fictional',-19,-6,NULL,NULL,'medium','88000000-0000-4000-8004-000000000001'),
('68000000-0000-4000-8004-000000000007','10000000-0000-4000-8000-000000000008','scattered-cells-of-resistance',NULL,NULL,4013,'fictional_with_historical_context','political','fictional_calendar','fictional',-14,-5,NULL,NULL,'medium','88000000-0000-4000-8004-000000000001');

INSERT INTO event_translations(event_id,locale,title,summary,detail,significance,time_label,status) VALUES
('68000000-0000-4000-8004-000000000001','zh-CN','绝地遭到追猎','帝国以专职猎手清剿 66 号令的幸存者,绝地从一个组织变成零星的个人。','','幸存不等于延续:活下来的人各自躲藏,没有人再教下一代。','雅汶战役前 19 至 14 年','published'),
('68000000-0000-4000-8004-000000000001','en','The Jedi are hunted','The Empire puts dedicated hunters onto the survivors of Order 66, and the Jedi cease to be an order and become scattered individuals.','','Surviving is not continuing: those left alive hide separately, and no one is teaching anyone.','c. 19–14 BBY','published'),
('68000000-0000-4000-8004-000000000002','zh-CN','欧比旺在塔图因守望卢克','欧比旺以隐士身份住在塔图因荒漠,远远看着卢克长大,不与他相认。','欧文明确要求他不要接近这个孩子,而他照办了十九年——这段沉默的守望是整个黑暗时代最长的一条线。','火种没有被教导,只是被看住了。','雅汶战役前 19 至 6 年','published'),
('68000000-0000-4000-8004-000000000002','en','Obi-Wan watches over Luke','Obi-Wan lives as a hermit in the Tatooine wastes, watching Luke grow up from a distance and never claiming him.','Owen tells him plainly to stay away from the boy, and he does so for nineteen years; that silent watch is the longest single thread in the Dark Times.','The spark is not taught. It is only kept.','c. 19–6 BBY','published'),
('68000000-0000-4000-8004-000000000003','zh-CN','尤达在达戈巴流亡','尤达退入达戈巴沼泽,断绝一切联系,等待可以承接的人。','','绝地的传承缩到一个人身上,并且是一个决定什么都不做的人。','雅汶战役前 19 至 6 年','published'),
('68000000-0000-4000-8004-000000000003','en','Yoda in exile on Dagobah','Yoda withdraws into the Dagobah swamps, cuts every connection, and waits for someone to carry it on.','','The whole Jedi succession narrows to one person, and that person has decided to do nothing.','c. 19–6 BBY','published'),
('68000000-0000-4000-8004-000000000004','zh-CN','莱娅在奥德朗长大','莱娅作为奥加纳家的公主长大,受政治训练,不知生父是谁。','贝尔把她养成议员而不是战士,而这恰恰是义军最缺的那种人。','两个孩子被分别培养成两种能力,日后各自派上用场。','雅汶战役前 19 至 6 年','published'),
('68000000-0000-4000-8004-000000000004','en','Leia is raised on Alderaan','Leia grows up a princess of House Organa, trained in politics, and never told whose daughter she is.','Bail raises her into a senator rather than a soldier, which is precisely the thing the rebellion is short of.','The two children are raised into two different competences, and each is needed later.','c. 19–6 BBY','published'),
('68000000-0000-4000-8004-000000000005','zh-CN','议会被保留为空壳','帝国保留议会形式,实权转入地方总督之手。','','形式被保留下来,正是为了让废除它的那天显得只是一道手续。','雅汶战役前 19 至 6 年','published'),
('68000000-0000-4000-8004-000000000005','en','The senate is kept as a shell','The Empire keeps the senate in form while real authority passes to regional governors.','','The form is preserved precisely so that abolishing it later can look like paperwork.','c. 19–6 BBY','published'),
('68000000-0000-4000-8004-000000000006','zh-CN','战斗空间站开工','帝国启动一项耗时近二十年的巨型武器工程。','','','雅汶战役前 19 至 6 年','published'),
('68000000-0000-4000-8004-000000000006','en','The battle station is laid down','The Empire begins a weapons project that will take the better part of twenty years.','','','c. 19–6 BBY','published'),
('68000000-0000-4000-8004-000000000007','zh-CN','零散的抵抗细胞','各地出现互不统属的抵抗小组,尚未联合。','','抵抗先于同盟存在,而把它们连起来的是政治家不是战士。','雅汶战役前 14 至 5 年','published'),
('68000000-0000-4000-8004-000000000007','en','Scattered cells of resistance','Unconnected resistance groups appear across the galaxy, with nothing joining them up.','','Resistance exists before the Alliance does, and what links the cells is politicians rather than soldiers.','c. 14–5 BBY','published');

-- ============================================================
-- 3. EVENTS — era 05
-- ============================================================

INSERT INTO events(id,work_id,slug,start_date,end_date,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,start_month,start_day,confidence,chapter_id) VALUES
('68000000-0000-4000-8005-000000000001','10000000-0000-4000-8000-000000000008','the-alliance-is-formed',NULL,NULL,5001,'fictional_narrative','political','fictional_calendar','fictional',-5,-3,NULL,NULL,'medium','88000000-0000-4000-8005-000000000001'),
('68000000-0000-4000-8005-000000000002','10000000-0000-4000-8000-000000000008','mon-mothma-leaves-the-senate',NULL,NULL,5003,'fictional_narrative','political','fictional_calendar','fictional',-4,-2,NULL,NULL,'medium','88000000-0000-4000-8005-000000000001'),
('68000000-0000-4000-8005-000000000003','10000000-0000-4000-8000-000000000008','the-station-is-tested-on-jedha',NULL,NULL,5005,'fictional_narrative','battle','fictional_calendar','fictional',-2,-1,NULL,NULL,'high','88000000-0000-4000-8005-000000000001'),
('68000000-0000-4000-8005-000000000004','10000000-0000-4000-8000-000000000008','the-alliance-council-splits',NULL,NULL,5007,'fictional_narrative','political','fictional_calendar','fictional',-2,-1,NULL,NULL,'high','88000000-0000-4000-8005-000000000001'),
('68000000-0000-4000-8005-000000000005','10000000-0000-4000-8000-000000000008','the-scarif-raid',NULL,NULL,5009,'fictional_narrative','battle','fictional_calendar','fictional',-2,-1,NULL,NULL,'high','88000000-0000-4000-8005-000000000001'),
('68000000-0000-4000-8005-000000000006','10000000-0000-4000-8000-000000000008','the-plans-are-transmitted',NULL,NULL,5011,'fictional_narrative','discovery','fictional_calendar','fictional',-2,-1,NULL,NULL,'high','88000000-0000-4000-8005-000000000001'),
('68000000-0000-4000-8005-000000000007','10000000-0000-4000-8000-000000000008','vader-boards-the-tantive',NULL,NULL,5013,'fictional_narrative','battle','fictional_calendar','fictional',-2,-1,NULL,NULL,'high','88000000-0000-4000-8005-000000000001'),
('68000000-0000-4000-8005-000000000008','10000000-0000-4000-8000-000000000008','leia-hides-the-plans-in-r2',NULL,NULL,5015,'fictional_narrative','escape','fictional_calendar','fictional',-2,-1,NULL,NULL,'high','88000000-0000-4000-8005-000000000001'),
('68000000-0000-4000-8005-000000000009','10000000-0000-4000-8000-000000000008','the-droids-land-on-tatooine',NULL,NULL,5017,'fictional_narrative','journey','fictional_calendar','fictional',-2,-1,NULL,NULL,'high','88000000-0000-4000-8005-000000000001'),
('68000000-0000-4000-8005-000000000010','10000000-0000-4000-8000-000000000008','leia-is-taken-prisoner',NULL,NULL,5019,'fictional_narrative','imprisonment','fictional_calendar','fictional',-2,-1,NULL,NULL,'high','88000000-0000-4000-8005-000000000001'),
('68000000-0000-4000-8005-000000000011','10000000-0000-4000-8000-000000000008','the-senate-is-dissolved',NULL,NULL,5021,'fictional_narrative','political','fictional_calendar','fictional',-2,-1,NULL,NULL,'high','88000000-0000-4000-8005-000000000001');

INSERT INTO event_translations(event_id,locale,title,summary,detail,significance,time_label,status) VALUES
('68000000-0000-4000-8005-000000000001','zh-CN','义军同盟成立','分散的抵抗力量在数名议员牵头下结成同盟。','','抵抗第一次有了可以被谈判、也可以被消灭的实体。','雅汶战役前 5 至 3 年','published'),
('68000000-0000-4000-8005-000000000001','en','The Alliance is formed','Scattered resistance groups are joined into an alliance under a handful of senators.','','For the first time the resistance is a body that can be negotiated with — and destroyed.','c. 5–3 BBY','published'),
('68000000-0000-4000-8005-000000000002','zh-CN','蒙·莫思马退出议会','蒙·莫思马公开与帝国决裂,转入地下。','','','雅汶战役前 4 至 2 年','published'),
('68000000-0000-4000-8005-000000000002','en','Mon Mothma leaves the senate','Mon Mothma breaks with the Empire publicly and goes underground.','','','c. 4–2 BBY','published'),
('68000000-0000-4000-8005-000000000003','zh-CN','杰达试炮','帝国以杰达的圣城作为战斗空间站的首次实战试验。','影片让这次试炮只毁掉一座城,而不是一颗行星——目的是先看看它能做到什么。','消息传出后,同盟才相信这件武器真的存在。','雅汶战役前 2 至 1 年','published'),
('68000000-0000-4000-8005-000000000003','en','The station is tested on Jedha','The Empire fires the battle station at Jedha’s holy city as its first live test.','The film has the shot destroy a city rather than a planet: the point is to find out what it can do.','Only once word gets out does the Alliance accept that the weapon is real.','c. 2–1 BBY','published'),
('68000000-0000-4000-8005-000000000004','zh-CN','同盟议会分裂','面对一件无法对抗的武器,同盟议会否决出兵,一部分人自行行动。','','同盟最重要的一次行动是违抗自己的决议做出的。','雅汶战役前 2 至 1 年','published'),
('68000000-0000-4000-8005-000000000004','en','The Alliance council splits','Facing a weapon they cannot fight, the Alliance council votes against action and part of it goes anyway.','','The Alliance’s most important operation is carried out against its own decision.','c. 2–1 BBY','published'),
('68000000-0000-4000-8005-000000000005','zh-CN','斯卡里夫突袭','一支未获授权的小队突入斯卡里夫的帝国档案库,夺取战斗空间站的技术资料。','影片让参与者全部阵亡,而他们换来的只是把资料送上一艘船的机会。','雅汶战役的全部可能性,是在这里用整支队伍换来的。','雅汶战役前 2 至 1 年','published'),
('68000000-0000-4000-8005-000000000005','en','The raid on Scarif','An unauthorised team breaks into the imperial archive on Scarif and takes the battle station’s technical readout.','The film lets everyone who goes die there, and what they buy is only the chance to put the plans aboard a ship.','Everything that becomes possible at Yavin is bought here, for the whole team.','c. 2–1 BBY','published'),
('68000000-0000-4000-8005-000000000006','zh-CN','技术资料被传出','资料在轨道上经数次转手送出斯卡里夫。','','','雅汶战役前 2 至 1 年','published'),
('68000000-0000-4000-8005-000000000006','en','The plans are transmitted','The readout is passed hand to hand in orbit and gets clear of Scarif.','','','c. 2–1 BBY','published'),
('68000000-0000-4000-8005-000000000007','zh-CN','维达登上坦帝夫四号','维达追上莱娅的外交舰并强行登舰。','影片让维达一路追到最后一道门,而门后是他自己的女儿——他不知道,观众知道。','父女第一次同处一室,双方都不知道对方是谁。','雅汶战役前 2 至 1 年','published'),
('68000000-0000-4000-8005-000000000007','en','Vader boards the Tantive IV','Vader runs down Leia’s diplomatic ship and takes it by boarding.','The film walks him to the last door on the ship, and behind it is his own daughter; he does not know, and the audience does.','Father and daughter are in the same corridor for the first time, and neither knows it.','c. 2–1 BBY','published'),
('68000000-0000-4000-8005-000000000008','zh-CN','莱娅把资料藏进 R2-D2','莱娅在被俘前把技术资料与一段求援讯息存入 R2-D2,并把它送上逃生舱。','她求援的对象是欧比旺·克诺比——这条讯息把她哥哥、她父亲的师父与那台机器人一起牵回了同一条线。','整部正传的引信,是一个不知道自己身世的女儿点的。','雅汶战役前 2 至 1 年','published'),
('68000000-0000-4000-8005-000000000008','en','Leia hides the plans in R2-D2','Before she is taken, Leia puts the readout and a plea for help into R2-D2 and gets him into an escape pod.','The plea is addressed to Obi-Wan Kenobi, and it pulls her brother, her father’s master and that droid onto one line at once.','The fuse of the original trilogy is lit by a daughter who does not know whose she is.','c. 2–1 BBY','published'),
('68000000-0000-4000-8005-000000000009','zh-CN','两台机器人降落塔图因','逃生舱落在塔图因沙漠,两台机器人被贾瓦人捡走转卖。','影片用一次转卖把资料送到了拉尔斯农场,也就是卢克手上。','银河的走向再一次系在塔图因的一桩小买卖上。','雅汶战役前 2 至 1 年','published'),
('68000000-0000-4000-8005-000000000009','en','The droids land on Tatooine','The pod comes down in the Tatooine desert and the two droids are scavenged and resold.','A single resale delivers the readout to the Lars farm, which is to say to Luke.','The galaxy turns once more on a small piece of Tatooine business.','c. 2–1 BBY','published'),
('68000000-0000-4000-8005-000000000010','zh-CN','莱娅被俘','莱娅被押上战斗空间站,受审讯而未开口。','','','雅汶战役前 2 至 1 年','published'),
('68000000-0000-4000-8005-000000000010','en','Leia is taken prisoner','Leia is brought aboard the battle station and interrogated without giving anything up.','','','c. 2–1 BBY','published'),
('68000000-0000-4000-8005-000000000011','zh-CN','议会被解散','帝国正式解散议会,地方总督直接掌权。','','保留了二十年的形式在武器就位的同一周被废除。','雅汶战役前 2 至 1 年','published'),
('68000000-0000-4000-8005-000000000011','en','The senate is dissolved','The Empire formally dissolves the senate and hands authority to the regional governors.','','A form kept for twenty years is abolished the same week the weapon is ready.','c. 2–1 BBY','published');

-- ============================================================
-- 4. EVENT LOCATIONS
-- ============================================================

INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id, l.id, w.role, w.position
FROM (VALUES
  ('the-jedi-are-hunted','coruscant','primary',0),
  ('obi-wan-watches-over-luke','tatooine','primary',0),
  ('yoda-in-exile-on-dagobah','dagobah','primary',0),
  ('leia-raised-on-alderaan','alderaan','primary',0),
  ('the-senate-is-kept-as-a-shell','coruscant','primary',0),
  ('the-battle-station-begins-construction','death-star','primary',0),
  ('scattered-cells-of-resistance','dantooine','primary',0),
  ('scattered-cells-of-resistance','mon-cala','front',1),
  ('the-alliance-is-formed','chandrila','primary',0),
  ('the-alliance-is-formed','dantooine','base',1),
  ('mon-mothma-leaves-the-senate','coruscant','primary',0),
  ('the-station-is-tested-on-jedha','jedha','primary',0),
  ('the-alliance-council-splits','yavin-4','primary',0),
  ('the-scarif-raid','scarif','primary',0),
  ('the-plans-are-transmitted','scarif','primary',0),
  ('vader-boards-the-tantive','tatooine','primary',0),
  ('leia-hides-the-plans-in-r2','tatooine','primary',0),
  ('the-droids-land-on-tatooine','tatooine','primary',0),
  ('leia-is-taken-prisoner','death-star','primary',0),
  ('the-senate-is-dissolved','coruscant','primary',0)
) AS w(event_slug, location_slug, role, position)
JOIN events e ON e.work_id='10000000-0000-4000-8000-000000000008' AND e.slug=w.event_slug
JOIN locations l ON l.work_id='10000000-0000-4000-8000-000000000008' AND l.slug=w.location_slug
ON CONFLICT DO NOTHING;

-- ============================================================
-- 5. EVENT CHARACTERS
-- ============================================================

INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id, c.id, w.role, w.participant_order, w.is_primary
FROM (VALUES
  ('the-jedi-are-hunted','anakin-skywalker','primary',0,true),
  ('the-jedi-are-hunted','sheev-palpatine','participant',1,false),
  ('obi-wan-watches-over-luke','obi-wan-kenobi','primary',0,true),
  ('obi-wan-watches-over-luke','luke-skywalker','participant',1,false),
  ('obi-wan-watches-over-luke','owen-lars','participant',2,false),
  ('obi-wan-watches-over-luke','beru-whitesun-lars','participant',3,false),
  ('yoda-in-exile-on-dagobah','yoda','primary',0,true),
  ('leia-raised-on-alderaan','leia-organa','primary',0,true),
  ('leia-raised-on-alderaan','bail-organa','participant',1,false),
  ('the-senate-is-kept-as-a-shell','sheev-palpatine','primary',0,true),
  ('the-senate-is-kept-as-a-shell','grand-moff-tarkin','participant',1,false),
  ('the-battle-station-begins-construction','grand-moff-tarkin','primary',0,true),
  ('scattered-cells-of-resistance','mon-mothma','primary',0,true),
  ('scattered-cells-of-resistance','grand-admiral-thrawn','participant',1,false),
  ('the-alliance-is-formed','mon-mothma','primary',0,true),
  ('the-alliance-is-formed','bail-organa','participant',1,false),
  ('the-alliance-is-formed','leia-organa','participant',2,false),
  ('the-alliance-is-formed','admiral-ackbar','participant',3,false),
  ('mon-mothma-leaves-the-senate','mon-mothma','primary',0,true),
  ('the-station-is-tested-on-jedha','grand-moff-tarkin','primary',0,true),
  ('the-alliance-council-splits','mon-mothma','primary',0,true),
  ('the-alliance-council-splits','leia-organa','participant',1,false),
  ('the-scarif-raid','grand-moff-tarkin','primary',0,true),
  ('the-scarif-raid','anakin-skywalker','participant',1,false),
  ('the-plans-are-transmitted','leia-organa','primary',0,true),
  ('vader-boards-the-tantive','anakin-skywalker','primary',0,true),
  ('vader-boards-the-tantive','leia-organa','participant',1,false),
  ('leia-hides-the-plans-in-r2','leia-organa','primary',0,true),
  ('leia-hides-the-plans-in-r2','r2-d2','participant',1,false),
  ('leia-hides-the-plans-in-r2','c-3po','participant',2,false),
  ('the-droids-land-on-tatooine','r2-d2','primary',0,true),
  ('the-droids-land-on-tatooine','c-3po','participant',1,false),
  ('the-droids-land-on-tatooine','owen-lars','participant',2,false),
  ('leia-is-taken-prisoner','leia-organa','primary',0,true),
  ('leia-is-taken-prisoner','anakin-skywalker','participant',1,false),
  ('leia-is-taken-prisoner','grand-moff-tarkin','participant',2,false),
  ('the-senate-is-dissolved','grand-moff-tarkin','primary',0,true),
  ('the-senate-is-dissolved','sheev-palpatine','participant',1,false)
) AS w(event_slug, character_slug, role, participant_order, is_primary)
JOIN events e ON e.work_id='10000000-0000-4000-8000-000000000008' AND e.slug=w.event_slug
JOIN characters c ON c.work_id='10000000-0000-4000-8000-000000000008' AND c.slug=w.character_slug
ON CONFLICT DO NOTHING;

-- ============================================================
-- 6. EVENT SOURCES
-- ============================================================

INSERT INTO event_sources(event_id,source_id)
SELECT e.id, s.id
FROM events e
JOIN sources s ON s.work_id='10000000-0000-4000-8000-000000000008' AND s.title='Episode III: Revenge of the Sith (2005 film)'
WHERE e.id::text LIKE '68000000-0000-4000-8004%'
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id, s.id
FROM events e
JOIN sources s ON s.work_id='10000000-0000-4000-8000-000000000008' AND s.title='Episode IV: A New Hope (1977 film)'
WHERE e.id::text LIKE '68000000-0000-4000-8005%'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 7. RELATIONS
-- ============================================================

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT w.id::uuid, '10000000-0000-4000-8000-000000000008', f.id, t.id, w.relation_type, w.direction::relationship_direction, w.sentiment::relationship_sentiment, w.strength, w.status::relationship_status, NULL, NULL
FROM (VALUES
  ('78000000-0000-4000-8005-000000000001','mon-mothma','bail-organa','ally','bidirectional','positive',5,'ended'),
  ('78000000-0000-4000-8005-000000000002','mon-mothma','leia-organa','mentor','source_to_target','positive',4,'active'),
  ('78000000-0000-4000-8005-000000000003','grand-moff-tarkin','anakin-skywalker','ally','bidirectional','neutral',3,'ended'),
  ('78000000-0000-4000-8005-000000000004','sheev-palpatine','grand-moff-tarkin','liege','source_to_target','neutral',4,'ended'),
  ('78000000-0000-4000-8005-000000000005','leia-organa','r2-d2','ally','bidirectional','positive',5,'active'),
  ('78000000-0000-4000-8005-000000000006','admiral-ackbar','mon-mothma','ally','bidirectional','positive',4,'ended'),
  ('78000000-0000-4000-8005-000000000007','wedge-antilles','luke-skywalker','ally','bidirectional','positive',4,'active'),
  ('78000000-0000-4000-8005-000000000008','sheev-palpatine','grand-admiral-thrawn','liege','source_to_target','neutral',3,'ended')
) AS w(id, from_slug, to_slug, relation_type, direction, sentiment, strength, status)
JOIN characters f ON f.work_id='10000000-0000-4000-8000-000000000008' AND f.slug=w.from_slug
JOIN characters t ON t.work_id='10000000-0000-4000-8000-000000000008' AND t.slug=w.to_slug
ON CONFLICT DO NOTHING;

INSERT INTO relation_translations(relation_id,locale,label,summary,status) VALUES
('78000000-0000-4000-8005-000000000001','zh-CN','同盟创建者(莫思马↔贝尔)','两名议员把零散的抵抗接成一个可以打仗的组织。','published'),
('78000000-0000-4000-8005-000000000001','en','Founders of the Alliance (Mothma ↔ Bail)','Two senators wire scattered resistance into something that can fight.','published'),
('78000000-0000-4000-8005-000000000002','zh-CN','政治上的师承(莫思马→莱娅)','把她从公主带成同盟的核心指挥者。','published'),
('78000000-0000-4000-8005-000000000002','en','Political mentor (Mothma → Leia)','She takes her from princess to one of the Alliance’s central commanders.','published'),
('78000000-0000-4000-8005-000000000003','zh-CN','同僚(塔金↔维达)','帝国的两把刀,互相不服但共用一条指挥链。','published'),
('78000000-0000-4000-8005-000000000003','en','Colleagues (Tarkin ↔ Vader)','The Empire’s two instruments, contemptuous of each other and sharing one chain of command.','published'),
('78000000-0000-4000-8005-000000000004','zh-CN','君臣(皇帝→塔金)','把恐惧作为统治手段的那套方案,出自这名总督。','published'),
('78000000-0000-4000-8005-000000000004','en','Emperor and governor (Palpatine → Tarkin)','The doctrine of ruling by fear is this governor’s design.','published'),
('78000000-0000-4000-8005-000000000005','zh-CN','托付(莱娅↔R2-D2)','她把整场战争的希望塞进一台机器人。','published'),
('78000000-0000-4000-8005-000000000005','en','Entrusted (Leia ↔ R2-D2)','She puts the war’s only chance inside a droid.','published'),
('78000000-0000-4000-8005-000000000006','zh-CN','舰队与议会(阿克巴↔莫思马)','出兵的人与决定出兵的人。','published'),
('78000000-0000-4000-8005-000000000006','en','Fleet and council (Ackbar ↔ Mothma)','The one who sails and the one who decides whether to.','published'),
('78000000-0000-4000-8005-000000000007','zh-CN','僚机(韦奇↔卢克)','两场决战都在同一编队里。','published'),
('78000000-0000-4000-8005-000000000007','en','Wingmen (Wedge ↔ Luke)','In the same squadron for both decisive battles.','published'),
('78000000-0000-4000-8005-000000000008','zh-CN','君臣(皇帝→索龙)','负责在边缘星域按住抵抗的那个人。','published'),
('78000000-0000-4000-8005-000000000008','en','Emperor and admiral (Palpatine → Thrawn)','The man tasked with holding the resistance down out on the Rim.','published')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 8. GROUP MEMBERSHIP
-- ============================================================

INSERT INTO character_group_members(group_id,character_id,membership_role)
SELECT g.id, c.id, w.membership_role
FROM (VALUES
  ('rebel-alliance','wedge-antilles','pilot'),
  ('rebel-alliance','admiral-ackbar','fleet commander'),
  ('rebel-alliance','bail-organa','founder'),
  ('galactic-empire','grand-admiral-thrawn','grand admiral'),
  ('the-resistance','admiral-ackbar','fleet commander'),
  ('house-of-organa','mon-mothma','ally of the house')
) AS w(group_slug, character_slug, membership_role)
JOIN character_groups g ON g.work_id='10000000-0000-4000-8000-000000000008' AND g.slug=w.group_slug
JOIN characters c ON c.work_id='10000000-0000-4000-8000-000000000008' AND c.slug=w.character_slug
ON CONFLICT DO NOTHING;

COMMIT;
