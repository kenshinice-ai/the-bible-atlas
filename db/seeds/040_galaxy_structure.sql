BEGIN;

-- 银河原力舆图 The Galactic Force Atlas — structural seed.
--
-- One work (the nine-film Skywalker saga), 12 eras, 13 groups, 11 sources,
-- 39 canvas bodies, 24 anchor characters, 3 trunk hyperspace routes.
-- No events: those come from the twelve era seeds (041-052) per
-- db/seeds/galaxy-seed-spec.md.
--
-- WHY ONE WORK RATHER THAN THREE TRILOGIES: character_relations is scoped by
-- work_id and both ends must belong to the same work, so splitting the saga
-- would cut the Skywalker line into three disconnected relationship graphs —
-- exactly the spine the saga is about. Long arcs get sliced into eras, not
-- into works; the Bible's thirteen eras set that precedent.
--
-- UUID namespace (work position 8; none of these prefixes were in use):
--   works              10000000-0000-4000-8000-000000000008
--   chapters           88000000-0000-4000-80KK-000000000001  (KK = era 01-12)
--   character_groups   a8000000-0000-4000-8000-0000000000NN
--   sources            58000000-0000-4000-8000-0000000000NN
--   locations          38000000-0000-4000-8000-0000000000NN
--   characters         48000000-0000-4000-8000-0000000000NN
--   routes             b8000000-0000-4000-8000-0000000000NN
--   work_chronologies  91000000-0000-4000-8000-000000000006
-- Era seeds use the -80KK- band of 48/38/68/78.
--
-- REQUIRES migration 004: this file is the first writer of the 'planet',
-- 'moon' and 'space_station' location_type values, and a new enum label
-- cannot be used in the transaction that adds it.
--
-- IP: all prose here is written for this project. Proper names appear as
-- factual references only. See blueprint/star-wars/IP_AND_NAMING.md.

-- ============================================================
-- 1. WORK
-- ============================================================

-- launch_rank 8 simply follows the existing seven; the ranking orders a
-- combined works list, and each atlas now ships as its own locked profile
-- build, so there is nothing to be gained by renumbering live rows.
INSERT INTO works(id,slug,author_name,publication_year,content_mode,map_layer,default_locale,launch_rank,mode_reason,category,origin_region,chronology_start_year,chronology_end_year,theme_color,theme_color_dark,theme_color_light) VALUES
('10000000-0000-4000-8000-000000000008','skywalker-saga','George Lucas and successors 乔治·卢卡斯及后继创作者',1977,'literary_narrative','fictional','en',8,'A galaxy-scale invented history: the places belong to no real geography and the years count from an invented epoch, so it needs a fictional canvas and a fictional calendar, and every event is fictional by construction.','mythic_epic','A galaxy far from ours',-33,36,'#C9B45A','#6B5F26','#E7DCA9')
ON CONFLICT DO NOTHING;

INSERT INTO work_translations(work_id,locale,title,summary,status) VALUES
('10000000-0000-4000-8000-000000000008','zh-CN','天行者九部曲','横跨两代人的银河史诗:共和国的衰亡、帝国的崛起与倾覆、以及一个家族在光暗之间的反复抉择。','published'),
('10000000-0000-4000-8000-000000000008','en','The Skywalker Saga','A galaxy-spanning story told across two generations: a republic decaying into empire, that empire brought down, and one family choosing between light and dark again and again.','published')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 2. CHRONOLOGY
-- ============================================================

-- Years are counted from the battle of Yavin. There is no year zero — the
-- database rejects it, and the convention matches BCE/CE — so 0 BBY maps to
-- -1 and 0 ABY to +1. Event-level wording lives in time_label.
INSERT INTO work_chronologies(id,work_id,kind,label,start_year,end_year,calendar_system,is_default) VALUES
('91000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000008','fictional','Galactic Standard (BBY/ABY)',-33,36,'fictional',true)
ON CONFLICT DO NOTHING;

-- ============================================================
-- 3. CHAPTERS (12 eras)
-- ============================================================

-- The hue arc runs republic gold -> war orange -> ember red -> imperial
-- blue-grey -> rebel orange -> Yavin gold -> Hoth ice -> Endor green -> new
-- republic teal -> first order crimson -> twilight violet -> balance jade:
-- warm and cool alternating, which is the light/dark pull of the story.
-- Every value was measured against the panel ink #0C1220 before it was
-- written down (the Bible's seed 025 was a retune done the other way round);
-- the lowest here is 6.30:1, well clear of the 4.5:1 floor.
INSERT INTO chapters(id,work_id,slug,sequence,reference_label,era_start_year,era_end_year,accent_color) VALUES
('88000000-0000-4000-8001-000000000001','10000000-0000-4000-8000-000000000008','naboo-crisis',1,'Episode I',-33,-31,'#D9BC66'),
('88000000-0000-4000-8002-000000000001','10000000-0000-4000-8000-000000000008','clone-wars',2,'Episode II',-23,-19,'#D89A55'),
('88000000-0000-4000-8003-000000000001','10000000-0000-4000-8000-000000000008','order-66-and-imperial-rise',3,'Episode III',-20,-19,'#D4826B'),
('88000000-0000-4000-8004-000000000001','10000000-0000-4000-8000-000000000008','dark-times',4,'Interlude',-19,-5,'#8FA6C8'),
('88000000-0000-4000-8005-000000000001','10000000-0000-4000-8000-000000000008','rebel-alliance-rising',5,'Interlude',-5,-1,'#D98E62'),
('88000000-0000-4000-8006-000000000001','10000000-0000-4000-8000-000000000008','yavin-campaign',6,'Episode IV',-1,1,'#E0A548'),
('88000000-0000-4000-8007-000000000001','10000000-0000-4000-8000-000000000008','hoth-and-exile',7,'Episode V',2,4,'#8FBEDC'),
('88000000-0000-4000-8008-000000000001','10000000-0000-4000-8000-000000000008','endor-and-the-fall',8,'Episode VI',4,5,'#96BE78'),
('88000000-0000-4000-8009-000000000001','10000000-0000-4000-8000-000000000008','new-republic',9,'Interlude',5,28,'#72BCAC'),
('88000000-0000-4000-8010-000000000001','10000000-0000-4000-8000-000000000008','first-order-rising',10,'Episode VII',28,34,'#D97B7B'),
('88000000-0000-4000-8011-000000000001','10000000-0000-4000-8000-000000000008','last-jedi',11,'Episode VIII',34,35,'#B99BD8'),
('88000000-0000-4000-8012-000000000001','10000000-0000-4000-8000-000000000008','skywalker-reborn',12,'Episode IX',35,36,'#93C9B4')
ON CONFLICT DO NOTHING;

INSERT INTO chapter_translations(chapter_id,locale,title,summary,status) VALUES
('88000000-0000-4000-8001-000000000001','zh-CN','纳布危机','一场贸易封锁把一个边缘星球推上银河政治的前台,也把一个议员送进了共和国最高的位置。','published'),
('88000000-0000-4000-8001-000000000001','en','The Naboo Crisis','A trade blockade pushes an outlying world onto the galactic stage, and carries one senator to the top of the Republic.','published'),
('88000000-0000-4000-8002-000000000001','zh-CN','克隆人战争','分离主义的退出演变为全面战争,共和国用一支订购来的军队维持自己的存续。','published'),
('88000000-0000-4000-8002-000000000001','en','The Clone Wars','Separatist secession becomes open war, and the Republic keeps itself alive with an army it did not know it had ordered.','published'),
('88000000-0000-4000-8003-000000000001','zh-CN','66 号令与帝国崛起','战争在一道命令下结束,共和国在掌声中改名为帝国。','published'),
('88000000-0000-4000-8003-000000000001','en','Order 66 and the Rise of the Empire','The war ends with a single order, and the Republic renames itself an Empire to applause.','published'),
('88000000-0000-4000-8004-000000000001','zh-CN','黑暗时代','帝国巩固统治的十余年;幸存者散落各处,反抗尚未成形。','published'),
('88000000-0000-4000-8004-000000000001','en','The Dark Times','The decade and a half in which the Empire consolidates: survivors scatter, and resistance has not yet taken shape.','published'),
('88000000-0000-4000-8005-000000000001','zh-CN','义军同盟集结','零散的抵抗汇成一个同盟,并开始为一场几乎不可能的行动做准备。','published'),
('88000000-0000-4000-8005-000000000001','en','The Rebel Alliance Rising','Scattered resistance coalesces into an alliance, and begins preparing for an operation that should not be survivable.','published'),
('88000000-0000-4000-8006-000000000001','zh-CN','雅汶战役','一份被窃取的技术资料,换来了对抗一座战斗空间站的唯一机会。','published'),
('88000000-0000-4000-8006-000000000001','en','The Yavin Campaign','A stolen technical readout buys the one opening there will ever be against a battle station.','published'),
('88000000-0000-4000-8007-000000000001','zh-CN','霍斯与流亡','同盟被逐出冰原基地,幸存者各自流亡,一段身世在云端揭开。','published'),
('88000000-0000-4000-8007-000000000001','en','Hoth and Exile','The Alliance is driven off its ice base, its survivors scattered into flight, and a parentage is revealed above the clouds.','published'),
('88000000-0000-4000-8008-000000000001','zh-CN','恩多与帝国覆灭','森林卫星上的一场地面战与轨道上的一次决战,同时终结了帝国与一段父子关系的僵局。','published'),
('88000000-0000-4000-8008-000000000001','en','Endor and the Fall','A ground fight on a forest moon and a battle in orbit end the Empire and a father-and-son deadlock at the same hour.','published'),
('88000000-0000-4000-8009-000000000001','zh-CN','新共和国','战后重建的二十余年:秩序缓慢恢复,而灰烬里有人在重新集结。','published'),
('88000000-0000-4000-8009-000000000001','en','The New Republic','Two decades of rebuilding: order slowly returns, while in the ashes someone is quietly regrouping.','published'),
('88000000-0000-4000-8010-000000000001','zh-CN','第一秩序崛起','旧帝国的残部以新的面孔归来,一名拾荒者卷入其中。','published'),
('88000000-0000-4000-8010-000000000001','en','The First Order Rising','What is left of the old Empire returns wearing a new face, and a scavenger is pulled into its path.','published'),
('88000000-0000-4000-8011-000000000001','zh-CN','最后绝地','隐居的传奇被找到,抵抗组织被逼到几乎全灭,火种却传了出去。','published'),
('88000000-0000-4000-8011-000000000001','en','The Last Jedi','A legend in hiding is found, the Resistance is reduced to almost nothing, and the spark is passed on anyway.','published'),
('88000000-0000-4000-8012-000000000001','zh-CN','天行者陨落与重生','旧的敌手重现,一个继承来的名字被一次自己的选择重新定义。','published'),
('88000000-0000-4000-8012-000000000001','en','The Fall and Rebirth of Skywalker','An old adversary resurfaces, and an inherited name is redefined by a choice freely made.','published')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 4. SOURCES
-- ============================================================

-- Sources are named as factual references. This project copies nothing from
-- them; the last two record the conventions this atlas invented for itself,
-- which readers are entitled to see cited like any other basis.
INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type) VALUES
('58000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000008','Episode I: The Phantom Menace (1999 film)',NULL,'Factual reference to the film; no text is reproduced from it.','primary','primary_text'),
('58000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000008','Episode II: Attack of the Clones (2002 film)',NULL,'Factual reference to the film; no text is reproduced from it.','primary','primary_text'),
('58000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000008','Episode III: Revenge of the Sith (2005 film)',NULL,'Factual reference to the film; no text is reproduced from it.','primary','primary_text'),
('58000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000008','Episode IV: A New Hope (1977 film)',NULL,'Factual reference to the film; no text is reproduced from it.','primary','primary_text'),
('58000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000008','Episode V: The Empire Strikes Back (1980 film)',NULL,'Factual reference to the film; no text is reproduced from it.','primary','primary_text'),
('58000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000008','Episode VI: Return of the Jedi (1983 film)',NULL,'Factual reference to the film; no text is reproduced from it.','primary','primary_text'),
('58000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000008','Episode VII: The Force Awakens (2015 film)',NULL,'Factual reference to the film; no text is reproduced from it.','primary','primary_text'),
('58000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000008','Episode VIII: The Last Jedi (2017 film)',NULL,'Factual reference to the film; no text is reproduced from it.','primary','primary_text'),
('58000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000008','Episode IX: The Rise of Skywalker (2019 film)',NULL,'Factual reference to the film; no text is reproduced from it.','primary','primary_text'),
('58000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000008','Dating policy of this atlas (BBY/ABY)',NULL,'This project’s own convention: years are signed integers counted from the battle of Yavin, with no year zero.','reference','reference'),
('58000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000008','Canvas policy of this atlas',NULL,'This project’s own convention: canvas coordinates are original illustrative values expressing publicly described regional placement; no published map is traced.','reference','reference')
ON CONFLICT DO NOTHING;

INSERT INTO source_translations(source_id,locale,title,citation,status)
SELECT s.id, l.locale, s.title, s.citation, 'published'
FROM sources s CROSS JOIN (VALUES ('zh-CN'::locale_code),('en'::locale_code)) AS l(locale)
WHERE s.work_id='10000000-0000-4000-8000-000000000008'
ON CONFLICT DO NOTHING;

UPDATE source_translations SET title='第一部:魅影危机(1999 年影片)', citation='对该影片的事实性指称;本站不复制其内容。' WHERE source_id='58000000-0000-4000-8000-000000000001' AND locale='zh-CN';
UPDATE source_translations SET title='第二部:克隆人的进攻(2002 年影片)', citation='对该影片的事实性指称;本站不复制其内容。' WHERE source_id='58000000-0000-4000-8000-000000000002' AND locale='zh-CN';
UPDATE source_translations SET title='第三部:西斯的复仇(2005 年影片)', citation='对该影片的事实性指称;本站不复制其内容。' WHERE source_id='58000000-0000-4000-8000-000000000003' AND locale='zh-CN';
UPDATE source_translations SET title='第四部:新希望(1977 年影片)', citation='对该影片的事实性指称;本站不复制其内容。' WHERE source_id='58000000-0000-4000-8000-000000000004' AND locale='zh-CN';
UPDATE source_translations SET title='第五部:帝国反击战(1980 年影片)', citation='对该影片的事实性指称;本站不复制其内容。' WHERE source_id='58000000-0000-4000-8000-000000000005' AND locale='zh-CN';
UPDATE source_translations SET title='第六部:绝地归来(1983 年影片)', citation='对该影片的事实性指称;本站不复制其内容。' WHERE source_id='58000000-0000-4000-8000-000000000006' AND locale='zh-CN';
UPDATE source_translations SET title='第七部:原力觉醒(2015 年影片)', citation='对该影片的事实性指称;本站不复制其内容。' WHERE source_id='58000000-0000-4000-8000-000000000007' AND locale='zh-CN';
UPDATE source_translations SET title='第八部:最后的绝地武士(2017 年影片)', citation='对该影片的事实性指称;本站不复制其内容。' WHERE source_id='58000000-0000-4000-8000-000000000008' AND locale='zh-CN';
UPDATE source_translations SET title='第九部:天行者崛起(2019 年影片)', citation='对该影片的事实性指称;本站不复制其内容。' WHERE source_id='58000000-0000-4000-8000-000000000009' AND locale='zh-CN';
UPDATE source_translations SET title='本站纪年政策(BBY/ABY)', citation='本站自订约定:年份为以雅汶战役为原点的带符号整数,无 0 年。' WHERE source_id='58000000-0000-4000-8000-000000000010' AND locale='zh-CN';
UPDATE source_translations SET title='本站画布政策', citation='本站自订约定:画布坐标为原创示意值,表达公开可查的区位描述,不摹绘任何已出版地图。' WHERE source_id='58000000-0000-4000-8000-000000000011' AND locale='zh-CN';

-- ============================================================
-- 5. LOCATIONS — the closed 39-body canvas
-- ============================================================

-- The canvas is 0-100 in both axes with the galactic centre at (50,38); x
-- increases east, y increases south. Band membership is checked by radius
-- from that centre: Core 0-10, Inner Rim 10-16, Mid Rim 16-34, Outer Rim
-- 34-50, beyond 50 outside; the Unknown Regions are defined by bearing
-- (x < 22) rather than radius, and that rule wins where the two disagree.
--
-- Deliberate band exceptions, all noted in their summaries: the two battle
-- stations move under power, and Jakku and Kamino sit where their publicly
-- described positions put them rather than where a clean radius would.
--
-- Coordinates are original illustrative values. They express which region a
-- body is described as belonging to and roughly where it lies relative to the
-- others; no published map is being traced. Era seeds may NOT add bodies to
-- this list — a drifting starfield makes every earlier screenshot a lie.
INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('38000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000008','coruscant','fictional',NULL,52,38,1,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000008','hosnian-prime','fictional',NULL,48,43,2,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000008','alderaan','fictional',NULL,56,42,3,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000008','kuat','fictional',NULL,55,44,4,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000008','chandrila','fictional',NULL,51,34,5,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000008','corellia','fictional',NULL,53,46,6,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000008','cato-neimoidia','fictional',NULL,62,40,7,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000008','jakku','fictional',NULL,30,33,8,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000008','takodana','fictional',NULL,32,48,9,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000008','ord-mantell','fictional',NULL,56,20,10,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000008','mandalore','fictional',NULL,80,18,11,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000008','dantooine','fictional',NULL,44,4,12,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000008','yavin-4','fictional',NULL,78,16,13,'moon','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000014','10000000-0000-4000-8000-000000000008','death-star','fictional',NULL,80,19,14,'space_station','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000015','10000000-0000-4000-8000-000000000008','felucia','fictional',NULL,83,22,15,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000016','10000000-0000-4000-8000-000000000008','mon-cala','fictional',NULL,90,24,16,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000017','10000000-0000-4000-8000-000000000008','dathomir','fictional',NULL,76,14,17,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000018','10000000-0000-4000-8000-000000000008','kashyyyk','fictional',NULL,70,38,18,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000019','10000000-0000-4000-8000-000000000008','nal-hutta','fictional',NULL,84,52,19,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000020','10000000-0000-4000-8000-000000000008','naboo','fictional',NULL,64,66,20,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000021','10000000-0000-4000-8000-000000000008','tatooine','fictional',NULL,80,70,21,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000022','10000000-0000-4000-8000-000000000008','geonosis','fictional',NULL,82,73,22,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000023','10000000-0000-4000-8000-000000000008','ryloth','fictional',NULL,79,76,23,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000024','10000000-0000-4000-8000-000000000008','kamino','fictional',NULL,88,72,24,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000025','10000000-0000-4000-8000-000000000008','jedha','fictional',NULL,61,60,25,'moon','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000026','10000000-0000-4000-8000-000000000008','scarif','fictional',NULL,76,79,26,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000027','10000000-0000-4000-8000-000000000008','d-qar','fictional',NULL,67,75,27,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000028','10000000-0000-4000-8000-000000000008','sullust','fictional',NULL,56,76,28,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000029','10000000-0000-4000-8000-000000000008','hoth','fictional',NULL,47,80,29,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000030','10000000-0000-4000-8000-000000000008','bespin','fictional',NULL,45,78,30,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000031','10000000-0000-4000-8000-000000000008','dagobah','fictional',NULL,56,84,31,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000032','10000000-0000-4000-8000-000000000008','mustafar','fictional',NULL,52,86,32,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000033','10000000-0000-4000-8000-000000000008','utapau','fictional',NULL,61,84,33,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000034','10000000-0000-4000-8000-000000000008','endor','fictional',NULL,34,70,34,'moon','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000035','10000000-0000-4000-8000-000000000008','death-star-ii','fictional',NULL,36,68,35,'space_station','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000036','10000000-0000-4000-8000-000000000008','crait','fictional',NULL,28,66,36,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000037','10000000-0000-4000-8000-000000000008','starkiller-base','fictional',NULL,20,28,37,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000038','10000000-0000-4000-8000-000000000008','ahch-to','fictional',NULL,9,30,38,'planet','fictional',8,NULL,false,NULL),
('38000000-0000-4000-8000-000000000039','10000000-0000-4000-8000-000000000008','exegol','fictional',NULL,7,45,39,'planet','fictional',8,NULL,false,NULL)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name,status) VALUES
('38000000-0000-4000-8000-000000000001','zh-CN','科洛桑','银河首都,共和国与其后帝国的政治中枢,整颗行星覆盖着城市。','{}','','','','','核心世界','published'),
('38000000-0000-4000-8000-000000000001','en','Coruscant','The galactic capital and seat of first the Republic and then the Empire; a world covered entirely by city.','{}','','','','','Core Worlds','published'),
('38000000-0000-4000-8000-000000000002','zh-CN','霍斯尼安主星','新共和国后期的行政中心。','{}','','','','','核心世界','published'),
('38000000-0000-4000-8000-000000000002','en','Hosnian Prime','Administrative seat of the later New Republic.','{}','','','','','Core Worlds','published'),
('38000000-0000-4000-8000-000000000003','zh-CN','奥德朗','以和平传统著称的核心世界,奥加纳家族的故乡。','{}','','','','','核心世界','published'),
('38000000-0000-4000-8000-000000000003','en','Alderaan','A Core world known for its pacifist tradition and the home of House Organa.','{}','','','','','Core Worlds','published'),
('38000000-0000-4000-8000-000000000004','zh-CN','库阿特','大型造船工业所在地,军舰的主要产地。','{}','','','','','核心世界','published'),
('38000000-0000-4000-8000-000000000004','en','Kuat','Home of the great shipyards where much of the galaxy’s warfleet is built.','{}','','','','','Core Worlds','published'),
('38000000-0000-4000-8000-000000000005','zh-CN','钱德里拉','蒙·莫思马的故乡,战后新共和国的发起地之一。','{}','','','','','核心世界','published'),
('38000000-0000-4000-8000-000000000005','en','Chandrila','Mon Mothma’s homeworld and one of the founding sites of the postwar New Republic.','{}','','','','','Core Worlds','published'),
('38000000-0000-4000-8000-000000000006','zh-CN','科雷利亚','航运与走私并存的工业世界,汉·索洛的出身地。','{}','','','','','核心世界','published'),
('38000000-0000-4000-8000-000000000006','en','Corellia','An industrial shipping world where smuggling is a second economy; Han Solo’s birthplace.','{}','','','','','Core Worlds','published'),
('38000000-0000-4000-8000-000000000007','zh-CN','卡托内莫迪亚','贸易联盟的据点之一,克隆人战争期间的战场。','{}','','','','','殖民地','published'),
('38000000-0000-4000-8000-000000000007','en','Cato Neimoidia','A Trade Federation stronghold and a battleground during the Clone Wars.','{}','','','','','Colonies','published'),
('38000000-0000-4000-8000-000000000008','zh-CN','贾库','沙漠星球,帝国覆灭后一场大战的残骸场;蕾伊在此长大。位置介于内环与西境之间,不严格属于任一环带。','{}','','','','','西境','published'),
('38000000-0000-4000-8000-000000000008','en','Jakku','A desert world strewn with the wreckage of a battle fought after the Empire’s fall, where Rey grew up. Its position sits between the Inner Rim and the western reaches rather than squarely in either.','{}','','','','','Western reaches','published'),
('38000000-0000-4000-8000-000000000009','zh-CN','塔科达纳','林地星球,一处历史悠久的中立据点所在。','{}','','','','','中环西','published'),
('38000000-0000-4000-8000-000000000009','en','Takodana','A forested world hosting a long-standing neutral waypoint.','{}','','','','','Mid Rim, west','published'),
('38000000-0000-4000-8000-000000000010','zh-CN','奥德曼特尔','赏金猎人与债主聚集的中转世界。','{}','','','','','中环北','published'),
('38000000-0000-4000-8000-000000000010','en','Ord Mantell','A transit world thick with bounty hunters and the people they are paid by.','{}','','','','','Mid Rim, north','published'),
('38000000-0000-4000-8000-000000000011','zh-CN','曼达洛','有独立战士传统的外环世界。','{}','','','','','外环北','published'),
('38000000-0000-4000-8000-000000000011','en','Mandalore','An Outer Rim world with its own long warrior tradition.','{}','','','','','Outer Rim, north','published'),
('38000000-0000-4000-8000-000000000012','zh-CN','丹图因','草原星球,义军早期基地之一。','{}','','','','','外环北','published'),
('38000000-0000-4000-8000-000000000012','en','Dantooine','A grassland world used as an early rebel base.','{}','','','','','Outer Rim, north','published'),
('38000000-0000-4000-8000-000000000013','zh-CN','雅汶四号卫星','丛林卫星,义军同盟在雅汶战役前的主基地。','{}','','','','','外环东北','published'),
('38000000-0000-4000-8000-000000000013','en','Yavin 4','A jungle moon that served as the Alliance’s main base before the battle of Yavin.','{}','','','','','Outer Rim, north-east','published'),
('38000000-0000-4000-8000-000000000014','zh-CN','死星','帝国的战斗空间站。机动设施,坐标取其决战方位。','{}','','','','','机动(雅汶方位)','published'),
('38000000-0000-4000-8000-000000000014','en','The Death Star','The Empire’s battle station. A mobile installation; its coordinates are those of the battle that destroyed it.','{}','','','','','Mobile (Yavin bearing)','published'),
('38000000-0000-4000-8000-000000000015','zh-CN','费卢西亚','真菌植被覆盖的外环星球,克隆人战争战场之一。','{}','','','','','外环东北','published'),
('38000000-0000-4000-8000-000000000015','en','Felucia','An Outer Rim world of fungal growth; one of the Clone Wars battlefields.','{}','','','','','Outer Rim, north-east','published'),
('38000000-0000-4000-8000-000000000016','zh-CN','蒙卡拉马里','海洋星球,战后为同盟提供主力舰队。','{}','','','','','外环东北','published'),
('38000000-0000-4000-8000-000000000016','en','Mon Cala','An ocean world whose shipyards gave the Alliance its capital fleet.','{}','','','','','Outer Rim, north-east','published'),
('38000000-0000-4000-8000-000000000017','zh-CN','达索米尔','外环星球,以其独立的法术传统著称。','{}','','','','','外环北','published'),
('38000000-0000-4000-8000-000000000017','en','Dathomir','An Outer Rim world known for a magical tradition of its own.','{}','','','','','Outer Rim, north','published'),
('38000000-0000-4000-8000-000000000018','zh-CN','卡希克','森林星球,伍基人的故乡。','{}','','','','','中环东','published'),
('38000000-0000-4000-8000-000000000018','en','Kashyyyk','A forest world; the Wookiee homeworld.','{}','','','','','Mid Rim, east','published'),
('38000000-0000-4000-8000-000000000019','zh-CN','纳尔赫塔','赫特空间的中心,犯罪集团的大本营。','{}','','','','','赫特空间','published'),
('38000000-0000-4000-8000-000000000019','en','Nal Hutta','The heart of Hutt Space and the seat of its crime syndicates.','{}','','','','','Hutt Space','published'),
('38000000-0000-4000-8000-000000000020','zh-CN','纳布','湖泊与草原的星球,帕德梅的故乡,第一部危机的中心。','{}','','','','','中环南','published'),
('38000000-0000-4000-8000-000000000020','en','Naboo','A world of lakes and plains; Padmé’s homeworld and the centre of the first crisis.','{}','','','','','Mid Rim, south','published'),
('38000000-0000-4000-8000-000000000021','zh-CN','塔图因','双日沙漠星球,天行者家族两代人的起点。','{}','','','','','外环东南','published'),
('38000000-0000-4000-8000-000000000021','en','Tatooine','A twin-sunned desert world; the starting point for two generations of Skywalkers.','{}','','','','','Outer Rim, south-east','published'),
('38000000-0000-4000-8000-000000000022','zh-CN','吉奥诺西斯','岩质星球,克隆人战争第一场会战的战场。','{}','','','','','外环东南','published'),
('38000000-0000-4000-8000-000000000022','en','Geonosis','A rocky world where the first pitched battle of the Clone Wars was fought.','{}','','','','','Outer Rim, south-east','published'),
('38000000-0000-4000-8000-000000000023','zh-CN','赖洛思','半面永昼半面永夜的星球,长期受外来势力盘剥。','{}','','','','','外环东南','published'),
('38000000-0000-4000-8000-000000000023','en','Ryloth','A world of permanent day on one face and night on the other, long exploited from outside.','{}','','','','','Outer Rim, south-east','published'),
('38000000-0000-4000-8000-000000000024','zh-CN','卡米诺','海洋星球,克隆人大军的生产地。位于外环之外的南缘。','{}','','','','','外环之外·南','published'),
('38000000-0000-4000-8000-000000000024','en','Kamino','An ocean world where the clone army was grown. It lies beyond the Outer Rim on the southern edge.','{}','','','','','Beyond the Outer Rim, south','published'),
('38000000-0000-4000-8000-000000000025','zh-CN','杰达','沙漠卫星,一处古老信仰的圣地。','{}','','','','','中环南','published'),
('38000000-0000-4000-8000-000000000025','en','Jedha','A desert moon holding a site sacred to an old faith.','{}','','','','','Mid Rim, south','published'),
('38000000-0000-4000-8000-000000000026','zh-CN','斯卡里夫','热带星球,帝国的军事档案库所在。','{}','','','','','外环东南','published'),
('38000000-0000-4000-8000-000000000026','en','Scarif','A tropical world housing the Empire’s military archive.','{}','','','','','Outer Rim, south-east','published'),
('38000000-0000-4000-8000-000000000027','zh-CN','迪卡','抵抗组织的基地星球之一。','{}','','','','','外环南','published'),
('38000000-0000-4000-8000-000000000027','en','D’Qar','One of the Resistance’s base worlds.','{}','','','','','Outer Rim, south','published'),
('38000000-0000-4000-8000-000000000028','zh-CN','苏卢斯特','火山星球,恩多战役前同盟舰队的集结地。','{}','','','','','外环西南','published'),
('38000000-0000-4000-8000-000000000028','en','Sullust','A volcanic world where the Alliance fleet gathered before Endor.','{}','','','','','Outer Rim, south-west','published'),
('38000000-0000-4000-8000-000000000029','zh-CN','霍斯','冰原星球,同盟在帝国反击时期的基地。','{}','','','','','外环南','published'),
('38000000-0000-4000-8000-000000000029','en','Hoth','An ice world; the Alliance base struck during the Empire’s counteroffensive.','{}','','','','','Outer Rim, south','published'),
('38000000-0000-4000-8000-000000000030','zh-CN','贝斯平','气态巨行星,云端之城悬于其大气之中。','{}','','','','','外环南','published'),
('38000000-0000-4000-8000-000000000030','en','Bespin','A gas giant with a city suspended in its atmosphere.','{}','','','','','Outer Rim, south','published'),
('38000000-0000-4000-8000-000000000031','zh-CN','达戈巴','沼泽星球,尤达流亡之地。','{}','','','','','外环南','published'),
('38000000-0000-4000-8000-000000000031','en','Dagobah','A swamp world; the place of Yoda’s exile.','{}','','','','','Outer Rim, south','published'),
('38000000-0000-4000-8000-000000000032','zh-CN','穆斯塔法','熔岩星球,前传三部曲的终局之地。','{}','','','','','外环南','published'),
('38000000-0000-4000-8000-000000000032','en','Mustafar','A lava world; where the prequel arc reaches its end.','{}','','','','','Outer Rim, south','published'),
('38000000-0000-4000-8000-000000000033','zh-CN','乌塔帕','深谷星球,克隆人战争最后阶段的战场。','{}','','','','','外环南','published'),
('38000000-0000-4000-8000-000000000033','en','Utapau','A world of sinkhole cities; a battlefield in the closing phase of the Clone Wars.','{}','','','','','Outer Rim, south','published'),
('38000000-0000-4000-8000-000000000034','zh-CN','恩多','森林卫星,帝国覆灭之战的地面战场。','{}','','','','','外环西','published'),
('38000000-0000-4000-8000-000000000034','en','Endor','A forest moon; the ground theatre of the battle that ended the Empire.','{}','','','','','Outer Rim, west','published'),
('38000000-0000-4000-8000-000000000035','zh-CN','第二死星','未完工的第二座战斗空间站,毁于恩多轨道。坐标取其决战方位。','{}','','','','','机动(恩多方位)','published'),
('38000000-0000-4000-8000-000000000035','en','The Second Death Star','An unfinished second battle station, destroyed in orbit of Endor. Its coordinates are those of that battle.','{}','','','','','Mobile (Endor bearing)','published'),
('38000000-0000-4000-8000-000000000036','zh-CN','克雷特','盐层覆盖的矿业星球,抵抗组织最后的据点。','{}','','','','','外环西','published'),
('38000000-0000-4000-8000-000000000036','en','Crait','A salt-crusted mining world; the Resistance’s last redoubt.','{}','','','','','Outer Rim, west','published'),
('38000000-0000-4000-8000-000000000037','zh-CN','弑星者基地','被改造为武器的行星,第一秩序的核心设施。','{"原伊拉姆"}','','','','','未知区域','published'),
('38000000-0000-4000-8000-000000000037','en','Starkiller Base','A planet remade into a weapon; the First Order’s central installation.','{"Ilum"}','','','','','Unknown Regions','published'),
('38000000-0000-4000-8000-000000000038','zh-CN','阿赫托','海岛星球,卢克自我流放之地。','{}','','','','','未知区域','published'),
('38000000-0000-4000-8000-000000000038','en','Ahch-To','An island world; the place of Luke’s self-imposed exile.','{}','','','','','Unknown Regions','published'),
('38000000-0000-4000-8000-000000000039','zh-CN','埃克西戈尔','隐蔽的西斯世界,最终决战之地。','{}','','','','','未知区域','published'),
('38000000-0000-4000-8000-000000000039','en','Exegol','A hidden Sith world; the site of the final confrontation.','{}','','','','','Unknown Regions','published')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 6. CHARACTERS — 24 anchors (importance >= 4)
-- ============================================================

-- ALIASES, NOT DUPLICATE ROWS: a character who takes a second name is one row
-- with the second name in translations.aliases. Two rows would split
-- Anakin<->Obi-Wan from Vader<->Luke into two unconnected components and
-- break the spine of the relationship graph. Search matches name + aliases,
-- so both names still find the person.
--
-- Birth and death years are signed BBY/ABY (see section 2); they are given
-- only where the films state them plainly, and left null otherwise rather
-- than invented.
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('48000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000008','anakin-skywalker',1,'male','adult','protagonist','fictional',-41,4,'sith',5),
('48000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000008','padme-amidala',2,'female','adult','protagonist','fictional',-46,-19,'senator',5),
('48000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000008','obi-wan-kenobi',3,'male','elder','protagonist','fictional',-57,-1,'jedi',5),
('48000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000008','yoda',4,'male','elder','supporting','fictional',-896,4,'jedi',5),
('48000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000008','sheev-palpatine',5,'male','elder','antagonist','fictional',-84,NULL,'sith',5),
('48000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000008','qui-gon-jinn',6,'male','adult','supporting','fictional',-92,-32,'jedi',4),
('48000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000008','mace-windu',7,'male','adult','supporting','fictional',-72,-19,'jedi',4),
('48000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000008','darth-maul',8,'male','adult','antagonist','fictional',-54,NULL,'sith',4),
('48000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000008','count-dooku',9,'male','elder','antagonist','fictional',-102,-19,'sith',4),
('48000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000008','general-grievous',10,'male','adult','antagonist','fictional',NULL,-19,'soldier',4),
('48000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000008','jango-fett',11,'male','adult','antagonist','fictional',-66,-22,'bounty_hunter',4),
('48000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000008','ahsoka-tano',12,'female','youth','supporting','fictional',-36,NULL,'jedi',4),
('48000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000008','bail-organa',13,'male','adult','supporting','fictional',-67,-1,'senator',4),
('48000000-0000-4000-8000-000000000014','10000000-0000-4000-8000-000000000008','mon-mothma',14,'female','adult','supporting','fictional',-48,NULL,'senator',4),
('48000000-0000-4000-8000-000000000015','10000000-0000-4000-8000-000000000008','grand-moff-tarkin',15,'male','elder','antagonist','fictional',-64,1,'ruler',4),
('48000000-0000-4000-8000-000000000016','10000000-0000-4000-8000-000000000008','luke-skywalker',16,'male','adult','protagonist','fictional',-19,34,'jedi',5),
('48000000-0000-4000-8000-000000000017','10000000-0000-4000-8000-000000000008','leia-organa',17,'female','adult','protagonist','fictional',-19,35,'senator',5),
('48000000-0000-4000-8000-000000000018','10000000-0000-4000-8000-000000000008','han-solo',18,'male','adult','protagonist','fictional',-32,34,'smuggler',5),
('48000000-0000-4000-8000-000000000019','10000000-0000-4000-8000-000000000008','chewbacca',19,'male','adult','supporting','fictional',-200,NULL,'smuggler',4),
('48000000-0000-4000-8000-000000000020','10000000-0000-4000-8000-000000000008','lando-calrissian',20,'male','adult','supporting','fictional',-31,NULL,'smuggler',4),
('48000000-0000-4000-8000-000000000021','10000000-0000-4000-8000-000000000008','boba-fett',21,'male','adult','antagonist','fictional',-32,NULL,'bounty_hunter',4),
('48000000-0000-4000-8000-000000000022','10000000-0000-4000-8000-000000000008','rey',22,'female','youth','protagonist','fictional',15,NULL,'jedi',5),
('48000000-0000-4000-8000-000000000023','10000000-0000-4000-8000-000000000008','ben-solo',23,'male','adult','antagonist','fictional',5,35,'sith',5),
('48000000-0000-4000-8000-000000000024','10000000-0000-4000-8000-000000000008','finn',24,'male','youth','supporting','fictional',11,NULL,'soldier',4)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,aliases,detail,motivation,status) VALUES
('48000000-0000-4000-8000-000000000001','zh-CN','阿纳金·天行者','塔图因出身的绝地武士,在战争与恐惧中转向西斯,以达斯·维达之名效力帝国,最后一刻转回。','{"达斯·维达"}','影片以他的转变作为前六部的主轴:被寄予厚望的少年,先后失去母亲与妻子,在害怕再失去的驱使下接受了另一种力量。','阻止自己所爱之人死去。','published'),
('48000000-0000-4000-8000-000000000001','en','Anakin Skywalker','A Jedi from Tatooine who turns to the Sith under the pressure of war and fear, serves the Empire as Darth Vader, and turns back at the last.','{"Darth Vader"}','His change is the spine of the first six films: a boy carrying everyone’s expectations, who loses his mother and then his wife, and accepts another kind of power rather than lose again.','To stop the people he loves from dying.','published'),
('48000000-0000-4000-8000-000000000002','zh-CN','帕德梅·阿米达拉','纳布的女王,后为议员;在共和国转为帝国的过程中始终站在宪政一边。','{"阿米达拉女王"}','影片让她在议会中提出的警告与银河的走向形成对照。','以政治手段保住共和国的正当性。','published'),
('48000000-0000-4000-8000-000000000002','en','Padmé Amidala','Queen and later senator of Naboo, who stays on the constitutional side throughout the Republic’s slide into empire.','{"Queen Amidala"}','The films set her warnings in the senate against the direction the galaxy actually takes.','To keep the Republic legitimate by political means.','published'),
('48000000-0000-4000-8000-000000000003','zh-CN','欧比旺·克诺比','绝地武士,阿纳金的师父;帝国时期以本·克诺比之名隐居塔图因。','{"本·克诺比"}','他既是师父也是兄长,影片把这段关系的破裂放在整部前传的终点。','守住自己所受的托付。','published'),
('48000000-0000-4000-8000-000000000003','en','Obi-Wan Kenobi','A Jedi and Anakin’s master, who lives out the imperial years on Tatooine under the name Ben Kenobi.','{"Ben Kenobi"}','He is master and elder brother at once, and the films place the breaking of that bond at the end of the prequel arc.','To keep the trust he was given.','published'),
('48000000-0000-4000-8000-000000000004','zh-CN','尤达','绝地委员会的长者,战后流亡达戈巴,晚年收卢克为徒。','{}','影片用他贯穿前后两代的教导来对照两种失败与两种坚持。','把可传的东西传下去。','published'),
('48000000-0000-4000-8000-000000000004','en','Yoda','The elder of the Jedi council, exiled to Dagobah after the war, who takes Luke as his last student.','{}','His teaching spans both generations, and the films use it to set two kinds of failure against two kinds of persistence.','To pass on what can still be passed on.','published'),
('48000000-0000-4000-8000-000000000005','zh-CN','希夫·帕尔帕廷','纳布议员、共和国最高议长,同时以达斯·西迪厄斯之名操纵战争双方,最终自立为皇帝。','{"达斯·西迪厄斯","皇帝"}','影片把他塑造成同时经营公开与隐蔽两条线的人:战争是他自己订的,和平也由他宣布。','取得并保住不受制约的权力。','published'),
('48000000-0000-4000-8000-000000000005','en','Sheev Palpatine','Senator of Naboo and Supreme Chancellor, who as Darth Sidious runs both sides of the war and finally declares himself Emperor.','{"Darth Sidious","the Emperor"}','The films give him an open career and a hidden one at the same time: he commissions the war and then announces the peace.','To take power that nothing can check, and keep it.','published'),
('48000000-0000-4000-8000-000000000006','zh-CN','魁刚·金','绝地武士,欧比旺的师父,在纳布危机中发现阿纳金。','{}','','按自己的判断行事,即便与委员会相左。','published'),
('48000000-0000-4000-8000-000000000006','en','Qui-Gon Jinn','A Jedi and Obi-Wan’s master, who finds Anakin during the Naboo crisis.','{}','','To act on his own judgement, even against the council.','published'),
('48000000-0000-4000-8000-000000000007','zh-CN','梅斯·温杜','绝地委员会成员,主张对最高议长采取直接行动。','{}','','以制度手段阻止权力集中。','published'),
('48000000-0000-4000-8000-000000000007','en','Mace Windu','A member of the Jedi council who argues for direct action against the Chancellor.','{}','','To stop power concentrating, by institutional means.','published'),
('48000000-0000-4000-8000-000000000008','zh-CN','达斯·摩尔','西迪厄斯的学徒,纳布危机中的杀手。','{"摩尔"}','','复仇。','published'),
('48000000-0000-4000-8000-000000000008','en','Darth Maul','Sidious’s apprentice and the assassin of the Naboo crisis.','{"Maul"}','','Revenge.','published'),
('48000000-0000-4000-8000-000000000009','zh-CN','杜库伯爵','脱离绝地的政治家,分离主义联盟的领袖,亦是西迪厄斯的学徒。','{"达斯·泰拉纳斯"}','','以脱离来纠正一个他认为已经腐坏的共和国——而这正被人利用。','published'),
('48000000-0000-4000-8000-000000000009','en','Count Dooku','A politician who left the Jedi, leads the Separatist Alliance, and is also Sidious’s apprentice.','{"Darth Tyranus"}','','To correct a Republic he considers rotten by leaving it — which is exactly what is being used.','published'),
('48000000-0000-4000-8000-000000000010','zh-CN','格里弗斯将军','分离主义军队的最高指挥官。','{}','','以战功证明自己。','published'),
('48000000-0000-4000-8000-000000000010','en','General Grievous','Supreme commander of the Separatist armies.','{}','','To prove himself by conquest.','published'),
('48000000-0000-4000-8000-000000000011','zh-CN','詹戈·费特','赏金猎人,克隆人大军的基因来源。','{}','','报酬,以及为自己留一个儿子。','published'),
('48000000-0000-4000-8000-000000000011','en','Jango Fett','A bounty hunter and the genetic source of the clone army.','{}','','Payment — and one son of his own.','published'),
('48000000-0000-4000-8000-000000000012','zh-CN','阿索卡·塔诺','阿纳金的学徒,后离开绝地武士团。','{}','','在一个她不再信任的体制之外继续做对的事。','published'),
('48000000-0000-4000-8000-000000000012','en','Ahsoka Tano','Anakin’s apprentice, who later leaves the Jedi Order.','{}','','To keep doing right outside an institution she no longer trusts.','published'),
('48000000-0000-4000-8000-000000000013','zh-CN','贝尔·奥加纳','奥德朗的议员与王室成员,莱娅的养父。','{}','','在帝国之下保住一条可以反抗的线。','published'),
('48000000-0000-4000-8000-000000000013','en','Bail Organa','Senator and member of Alderaan’s royal house; Leia’s adoptive father.','{}','','To keep a line of resistance alive under the Empire.','published'),
('48000000-0000-4000-8000-000000000014','zh-CN','蒙·莫思马','议员,义军同盟的主要创建者,战后新共和国的领导者之一。','{}','','把反抗组织成一个可以交接的政权。','published'),
('48000000-0000-4000-8000-000000000014','en','Mon Mothma','A senator, principal founder of the Rebel Alliance, and later a leader of the New Republic.','{}','','To turn resistance into a government that can be handed on.','published'),
('48000000-0000-4000-8000-000000000015','zh-CN','塔金总督','帝国高级军政官员,战斗空间站战略的推动者。','{}','','以恐惧代替驻军来统治。','published'),
('48000000-0000-4000-8000-000000000015','en','Grand Moff Tarkin','A senior imperial governor and the architect of the battle-station strategy.','{}','','To rule by fear instead of by garrisons.','published'),
('48000000-0000-4000-8000-000000000016','zh-CN','卢克·天行者','塔图因的农家少年,成为绝地武士;既是帝国的对手,也是维达的儿子。','{}','影片让他在最后拒绝以杀戮取胜,这一选择构成正传三部曲的结局。','救回自己的父亲,而不是打败他。','published'),
('48000000-0000-4000-8000-000000000016','en','Luke Skywalker','A farm boy from Tatooine who becomes a Jedi; the Empire’s opponent and Vader’s son.','{}','His refusal to win by killing is what closes the original trilogy.','To recover his father rather than defeat him.','published'),
('48000000-0000-4000-8000-000000000017','zh-CN','莱娅·奥加纳','奥德朗公主与议员,义军同盟的核心指挥者,后为抵抗组织将军。','{"莱娅公主","奥加纳将军"}','影片让她横跨政治、军事与家庭三条线,是贯穿九部曲最久的人物之一。','把该做的事做完,不论体制换了几次。','published'),
('48000000-0000-4000-8000-000000000017','en','Leia Organa','Princess and senator of Alderaan, a central commander of the Alliance, and later general of the Resistance.','{"Princess Leia","General Organa"}','She runs through the political, military and family threads at once, and is present across more of the saga than almost anyone.','To finish what needs doing, however many times the institutions change.','published'),
('48000000-0000-4000-8000-000000000018','zh-CN','汉·索洛','科雷利亚出身的走私者与飞行员,从雇佣者变为同盟指挥官。','{}','','起初是钱,后来是这些人。','published'),
('48000000-0000-4000-8000-000000000018','en','Han Solo','A smuggler and pilot from Corellia who goes from hired hand to Alliance commander.','{}','','Money at first, and then these people.','published'),
('48000000-0000-4000-8000-000000000019','zh-CN','丘巴卡','卡希克的伍基人,千年隼的副驾驶。','{"丘伊"}','','对同伴的誓约。','published'),
('48000000-0000-4000-8000-000000000019','en','Chewbacca','A Wookiee of Kashyyyk and co-pilot of the Millennium Falcon.','{"Chewie"}','','A debt of loyalty, kept.','published'),
('48000000-0000-4000-8000-000000000020','zh-CN','兰多·卡瑞辛','云端之城的管理者,先出卖旧友,后加入同盟。','{}','','先保住自己的城,再补上欠下的。','published'),
('48000000-0000-4000-8000-000000000020','en','Lando Calrissian','Administrator of the cloud city, who sells out an old friend and then joins the Alliance.','{}','','To protect his city first, and then to make it up.','published'),
('48000000-0000-4000-8000-000000000021','zh-CN','波巴·费特','詹戈之子,帝国时期最知名的赏金猎人之一。','{}','','契约与父亲留下的名声。','published'),
('48000000-0000-4000-8000-000000000021','en','Boba Fett','Jango’s son and one of the best-known bounty hunters of the imperial years.','{}','','Contracts, and the name his father left him.','published'),
('48000000-0000-4000-8000-000000000022','zh-CN','蕾伊','贾库的拾荒者,在第一秩序崛起时被卷入,最终自选姓氏。','{"蕾伊·天行者"}','影片让她的出身与她的选择彼此拉扯,结局把答案交给她自己。','弄清自己是谁,并自己决定。','published'),
('48000000-0000-4000-8000-000000000022','en','Rey','A scavenger from Jakku drawn into the First Order’s rise, who chooses her own surname at the end.','{"Rey Skywalker"}','The films pull her origin against her choices and finally hand the answer to her.','To find out who she is — and then decide it herself.','published'),
('48000000-0000-4000-8000-000000000023','zh-CN','本·索洛','汉与莱娅之子,以凯洛·伦之名效力第一秩序,末了回头。','{"凯洛·伦"}','影片把他与蕾伊设为互相牵引的一对,他的转回与其外祖父的转回互为回声。','摆脱两代人留下的阴影。','published'),
('48000000-0000-4000-8000-000000000023','en','Ben Solo','Han and Leia’s son, who serves the First Order as Kylo Ren and turns back at the end.','{"Kylo Ren"}','He and Rey are written as a pair pulling on each other, and his turn echoes his grandfather’s.','To get out from under two generations of shadow.','published'),
('48000000-0000-4000-8000-000000000024','zh-CN','芬恩','第一秩序的士兵,编号 FN-2187,临阵脱离后加入抵抗组织。','{"FN-2187"}','','不再执行自己不认同的命令。','published'),
('48000000-0000-4000-8000-000000000024','en','Finn','A First Order soldier, designation FN-2187, who walks away mid-operation and joins the Resistance.','{"FN-2187"}','','To stop carrying out orders he does not accept.','published')
ON CONFLICT DO NOTHING;

-- Birthplaces the films state outright.
UPDATE characters SET birth_place_id=(SELECT id FROM locations WHERE work_id='10000000-0000-4000-8000-000000000008' AND slug='tatooine') WHERE id='48000000-0000-4000-8000-000000000001';
UPDATE characters SET birth_place_id=(SELECT id FROM locations WHERE work_id='10000000-0000-4000-8000-000000000008' AND slug='naboo') WHERE id='48000000-0000-4000-8000-000000000002';
UPDATE characters SET birth_place_id=(SELECT id FROM locations WHERE work_id='10000000-0000-4000-8000-000000000008' AND slug='corellia') WHERE id='48000000-0000-4000-8000-000000000018';
UPDATE characters SET birth_place_id=(SELECT id FROM locations WHERE work_id='10000000-0000-4000-8000-000000000008' AND slug='kashyyyk') WHERE id='48000000-0000-4000-8000-000000000019';
UPDATE characters SET birth_place_id=(SELECT id FROM locations WHERE work_id='10000000-0000-4000-8000-000000000008' AND slug='kamino') WHERE id='48000000-0000-4000-8000-000000000021';
UPDATE characters SET birth_place_id=(SELECT id FROM locations WHERE work_id='10000000-0000-4000-8000-000000000008' AND slug='jakku') WHERE id='48000000-0000-4000-8000-000000000022';

-- ============================================================
-- 7. CHARACTER GROUPS
-- ============================================================

-- Factions that outlive any one era are groups, not eras: the Jedi Order runs
-- through all twelve. Same principle as the Han court in the Three Kingdoms
-- seed. A group with no members does not render, so every group here gets at
-- least one anchor in section 8 and the era seeds add the rest.
INSERT INTO character_groups(id,work_id,slug,group_type,sort_order,accent_color) VALUES
('a8000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000008','jedi-order','institution',1,'#D9BC66'),
('a8000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000008','sith-lineage','institution',2,'#D97B7B'),
('a8000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000008','galactic-republic','institution',3,'#E0A548'),
('a8000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000008','separatist-alliance','institution',4,'#D89A55'),
('a8000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000008','clone-army','institution',5,'#8FBEDC'),
('a8000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000008','galactic-empire','institution',6,'#8FA6C8'),
('a8000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000008','rebel-alliance','institution',7,'#D98E62'),
('a8000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000008','house-of-skywalker','family',8,'#D4826B'),
('a8000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000008','house-of-organa','family',9,'#93C9B4'),
('a8000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000008','naboo-royal-house','dynasty',10,'#B99BD8'),
('a8000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000008','smugglers-and-outlaws','circle',11,'#96BE78'),
('a8000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000008','first-order','institution',12,'#D97B7B'),
('a8000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000008','the-resistance','institution',13,'#72BCAC')
ON CONFLICT DO NOTHING;

INSERT INTO character_group_translations(group_id,locale,name,summary,status) VALUES
('a8000000-0000-4000-8000-000000000001','zh-CN','绝地武士团','贯穿十二个时代的修习与执法传统,在 66 号令后近乎断绝。','published'),
('a8000000-0000-4000-8000-000000000001','en','The Jedi Order','A tradition of training and peacekeeping that runs through all twelve eras and is all but ended by Order 66.','published'),
('a8000000-0000-4000-8000-000000000002','zh-CN','西斯传承','以师徒二人相传的隐秘法统,长期在幕后运作。','published'),
('a8000000-0000-4000-8000-000000000002','en','The Sith Lineage','A hidden line passed between master and apprentice, working from behind the scenes for generations.','published'),
('a8000000-0000-4000-8000-000000000003','zh-CN','银河共和国','前三个时代的合法政体,最终由内部改制为帝国。','published'),
('a8000000-0000-4000-8000-000000000003','en','The Galactic Republic','The lawful polity of the first three eras, converted into an Empire from within.','published'),
('a8000000-0000-4000-8000-000000000004','zh-CN','分离主义联盟','脱离共和国的星系与企业联合,克隆人战争的一方。','published'),
('a8000000-0000-4000-8000-000000000004','en','The Separatist Alliance','A coalition of systems and corporations that secede from the Republic; one side of the Clone Wars.','published'),
('a8000000-0000-4000-8000-000000000005','zh-CN','克隆人大军','为共和国订购的军队,后成为帝国军的基础。','published'),
('a8000000-0000-4000-8000-000000000005','en','The Clone Army','An army commissioned for the Republic that becomes the basis of the imperial military.','published'),
('a8000000-0000-4000-8000-000000000006','zh-CN','银河帝国','由共和国改制而来的集权政体,存续约二十余年。','published'),
('a8000000-0000-4000-8000-000000000006','en','The Galactic Empire','The centralised state the Republic becomes, lasting some two decades.','published'),
('a8000000-0000-4000-8000-000000000007','zh-CN','义军同盟','由分散抵抗汇成的联盟,推翻帝国的主体。','published'),
('a8000000-0000-4000-8000-000000000007','en','The Rebel Alliance','The alliance that grows out of scattered resistance and brings the Empire down.','published'),
('a8000000-0000-4000-8000-000000000008','zh-CN','天行者家族','贯穿九部曲的血脉,也是全作的叙事主轴。','published'),
('a8000000-0000-4000-8000-000000000008','en','House Skywalker','The bloodline that runs through all nine films, and the saga’s central thread.','published'),
('a8000000-0000-4000-8000-000000000009','zh-CN','奥加纳家族','奥德朗王室,莱娅的养家。','published'),
('a8000000-0000-4000-8000-000000000009','en','House Organa','The royal house of Alderaan and Leia’s adoptive family.','published'),
('a8000000-0000-4000-8000-000000000010','zh-CN','纳布王室','以选举产生君主的纳布政权。','published'),
('a8000000-0000-4000-8000-000000000010','en','The Naboo Royal House','Naboo’s polity, whose monarch is elected.','published'),
('a8000000-0000-4000-8000-000000000011','zh-CN','走私者与法外之徒','在两个政权之外谋生的一群人,多次成为关键的临时同盟。','published'),
('a8000000-0000-4000-8000-000000000011','en','Smugglers and Outlaws','People who make a living outside both regimes, and who repeatedly become the decisive temporary allies.','published'),
('a8000000-0000-4000-8000-000000000012','zh-CN','第一秩序','帝国残部在未知区域重组后的政权。','published'),
('a8000000-0000-4000-8000-000000000012','en','The First Order','What the Empire’s remnants become after regrouping in the Unknown Regions.','published'),
('a8000000-0000-4000-8000-000000000013','zh-CN','抵抗组织','新共和国之外的武装力量,由莱娅组建。','published'),
('a8000000-0000-4000-8000-000000000013','en','The Resistance','An armed force raised by Leia outside the New Republic’s structures.','published')
ON CONFLICT DO NOTHING;

UPDATE character_groups SET anchor_character_id='48000000-0000-4000-8000-000000000004' WHERE id='a8000000-0000-4000-8000-000000000001';
UPDATE character_groups SET anchor_character_id='48000000-0000-4000-8000-000000000005' WHERE id='a8000000-0000-4000-8000-000000000002';
UPDATE character_groups SET anchor_character_id='48000000-0000-4000-8000-000000000002' WHERE id='a8000000-0000-4000-8000-000000000003';
UPDATE character_groups SET anchor_character_id='48000000-0000-4000-8000-000000000009' WHERE id='a8000000-0000-4000-8000-000000000004';
UPDATE character_groups SET anchor_character_id='48000000-0000-4000-8000-000000000011' WHERE id='a8000000-0000-4000-8000-000000000005';
UPDATE character_groups SET anchor_character_id='48000000-0000-4000-8000-000000000015' WHERE id='a8000000-0000-4000-8000-000000000006';
UPDATE character_groups SET anchor_character_id='48000000-0000-4000-8000-000000000014' WHERE id='a8000000-0000-4000-8000-000000000007';
UPDATE character_groups SET anchor_character_id='48000000-0000-4000-8000-000000000001' WHERE id='a8000000-0000-4000-8000-000000000008';
UPDATE character_groups SET anchor_character_id='48000000-0000-4000-8000-000000000013' WHERE id='a8000000-0000-4000-8000-000000000009';
UPDATE character_groups SET anchor_character_id='48000000-0000-4000-8000-000000000002' WHERE id='a8000000-0000-4000-8000-000000000010';
UPDATE character_groups SET anchor_character_id='48000000-0000-4000-8000-000000000018' WHERE id='a8000000-0000-4000-8000-000000000011';
UPDATE character_groups SET anchor_character_id='48000000-0000-4000-8000-000000000023' WHERE id='a8000000-0000-4000-8000-000000000012';
UPDATE character_groups SET anchor_character_id='48000000-0000-4000-8000-000000000017' WHERE id='a8000000-0000-4000-8000-000000000013';

-- ============================================================
-- 8. GROUP MEMBERSHIP
-- ============================================================

INSERT INTO character_group_members(group_id,character_id,membership_role) VALUES
-- Jedi Order
('a8000000-0000-4000-8000-000000000001','48000000-0000-4000-8000-000000000004','grand master'),
('a8000000-0000-4000-8000-000000000001','48000000-0000-4000-8000-000000000007','council member'),
('a8000000-0000-4000-8000-000000000001','48000000-0000-4000-8000-000000000006','master'),
('a8000000-0000-4000-8000-000000000001','48000000-0000-4000-8000-000000000003','master'),
('a8000000-0000-4000-8000-000000000001','48000000-0000-4000-8000-000000000001','knight'),
('a8000000-0000-4000-8000-000000000001','48000000-0000-4000-8000-000000000012','apprentice, later departed'),
('a8000000-0000-4000-8000-000000000001','48000000-0000-4000-8000-000000000016','last student, later teacher'),
('a8000000-0000-4000-8000-000000000001','48000000-0000-4000-8000-000000000022','student'),
-- Sith lineage
('a8000000-0000-4000-8000-000000000002','48000000-0000-4000-8000-000000000005','master'),
('a8000000-0000-4000-8000-000000000002','48000000-0000-4000-8000-000000000008','apprentice'),
('a8000000-0000-4000-8000-000000000002','48000000-0000-4000-8000-000000000009','apprentice'),
('a8000000-0000-4000-8000-000000000002','48000000-0000-4000-8000-000000000001','apprentice'),
-- Republic
('a8000000-0000-4000-8000-000000000003','48000000-0000-4000-8000-000000000002','senator'),
('a8000000-0000-4000-8000-000000000003','48000000-0000-4000-8000-000000000013','senator'),
('a8000000-0000-4000-8000-000000000003','48000000-0000-4000-8000-000000000014','senator'),
('a8000000-0000-4000-8000-000000000003','48000000-0000-4000-8000-000000000005','supreme chancellor'),
-- Separatists
('a8000000-0000-4000-8000-000000000004','48000000-0000-4000-8000-000000000009','head of state'),
('a8000000-0000-4000-8000-000000000004','48000000-0000-4000-8000-000000000010','supreme commander'),
-- Clone army
('a8000000-0000-4000-8000-000000000005','48000000-0000-4000-8000-000000000011','genetic template'),
-- Empire
('a8000000-0000-4000-8000-000000000006','48000000-0000-4000-8000-000000000005','emperor'),
('a8000000-0000-4000-8000-000000000006','48000000-0000-4000-8000-000000000001','enforcer'),
('a8000000-0000-4000-8000-000000000006','48000000-0000-4000-8000-000000000015','grand moff'),
-- Rebel Alliance
('a8000000-0000-4000-8000-000000000007','48000000-0000-4000-8000-000000000014','founder'),
('a8000000-0000-4000-8000-000000000007','48000000-0000-4000-8000-000000000017','commander'),
('a8000000-0000-4000-8000-000000000007','48000000-0000-4000-8000-000000000016','pilot, later Jedi'),
('a8000000-0000-4000-8000-000000000007','48000000-0000-4000-8000-000000000018','captain'),
('a8000000-0000-4000-8000-000000000007','48000000-0000-4000-8000-000000000019','co-pilot'),
('a8000000-0000-4000-8000-000000000007','48000000-0000-4000-8000-000000000020','general'),
-- House Skywalker
('a8000000-0000-4000-8000-000000000008','48000000-0000-4000-8000-000000000001','father'),
('a8000000-0000-4000-8000-000000000008','48000000-0000-4000-8000-000000000002','mother'),
('a8000000-0000-4000-8000-000000000008','48000000-0000-4000-8000-000000000016','son'),
('a8000000-0000-4000-8000-000000000008','48000000-0000-4000-8000-000000000017','daughter'),
('a8000000-0000-4000-8000-000000000008','48000000-0000-4000-8000-000000000023','grandson'),
('a8000000-0000-4000-8000-000000000008','48000000-0000-4000-8000-000000000022','adopted the name'),
-- House Organa
('a8000000-0000-4000-8000-000000000009','48000000-0000-4000-8000-000000000013','head of house'),
('a8000000-0000-4000-8000-000000000009','48000000-0000-4000-8000-000000000017','adopted daughter'),
-- Naboo royal house
('a8000000-0000-4000-8000-000000000010','48000000-0000-4000-8000-000000000002','elected queen'),
-- Smugglers and outlaws
('a8000000-0000-4000-8000-000000000011','48000000-0000-4000-8000-000000000018','smuggler'),
('a8000000-0000-4000-8000-000000000011','48000000-0000-4000-8000-000000000019','smuggler'),
('a8000000-0000-4000-8000-000000000011','48000000-0000-4000-8000-000000000020','gambler and administrator'),
('a8000000-0000-4000-8000-000000000011','48000000-0000-4000-8000-000000000011','bounty hunter'),
('a8000000-0000-4000-8000-000000000011','48000000-0000-4000-8000-000000000021','bounty hunter'),
-- First Order
('a8000000-0000-4000-8000-000000000012','48000000-0000-4000-8000-000000000023','commander'),
('a8000000-0000-4000-8000-000000000012','48000000-0000-4000-8000-000000000024','trooper, defected'),
-- Resistance
('a8000000-0000-4000-8000-000000000013','48000000-0000-4000-8000-000000000017','general'),
('a8000000-0000-4000-8000-000000000013','48000000-0000-4000-8000-000000000022','recruit'),
('a8000000-0000-4000-8000-000000000013','48000000-0000-4000-8000-000000000024','recruit'),
('a8000000-0000-4000-8000-000000000013','48000000-0000-4000-8000-000000000019','crew'),
('a8000000-0000-4000-8000-000000000013','48000000-0000-4000-8000-000000000020','ally')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 9. ROUTES — trunk hyperspace lanes
-- ============================================================

-- Routes carry the narrative order in their waypoint order. Three lanes are
-- enough to give the canvas its lines at skeleton stage; the Kessel run waits
-- for the derivative work that is actually about it.
INSERT INTO routes(id,work_id,slug,layer,certainty,sort_order) VALUES
('b8000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000008','corellian-run','fictional','text_explicit',1),
('b8000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000008','hutt-space-run','fictional','inferred',2),
('b8000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000008','rebel-flight','fictional','text_explicit',3)
ON CONFLICT DO NOTHING;

INSERT INTO route_translations(route_id,locale,name,summary,status) VALUES
('b8000000-0000-4000-8000-000000000001','zh-CN','科雷利亚大道','由核心世界向外环东南延伸的主干航线,把工业中心与边缘沙漠世界连成一线。','published'),
('b8000000-0000-4000-8000-000000000001','en','The Corellian Run','A trunk lane running from the Core out to the south-eastern Outer Rim, tying the industrial centre to the desert edge.','published'),
('b8000000-0000-4000-8000-000000000002','zh-CN','赫特空间线','连接赫特犯罪集团腹地与外环沙漠世界的走私航路。','published'),
('b8000000-0000-4000-8000-000000000002','en','The Hutt Space Run','A smugglers’ lane linking the Hutt syndicates’ heartland to the desert worlds of the Rim.','published'),
('b8000000-0000-4000-8000-000000000003','zh-CN','义军转移线','义军同盟在三个时代之间接连迁移基地的路径:雅汶四号 → 霍斯 → 恩多。','published'),
('b8000000-0000-4000-8000-000000000003','en','The Rebel Flight','The path along which the Alliance moved its base across three eras: Yavin 4, then Hoth, then Endor.','published')
ON CONFLICT DO NOTHING;

INSERT INTO route_waypoints(route_id,location_id,position,event_id)
SELECT r.id, l.id, w.position, NULL
FROM (VALUES
  ('corellian-run','corellia',0),
  ('corellian-run','naboo',1),
  ('corellian-run','tatooine',2),
  ('hutt-space-run','nal-hutta',0),
  ('hutt-space-run','tatooine',1),
  ('rebel-flight','yavin-4',0),
  ('rebel-flight','hoth',1),
  ('rebel-flight','endor',2)
) AS w(route_slug, location_slug, position)
JOIN routes r ON r.work_id='10000000-0000-4000-8000-000000000008' AND r.slug=w.route_slug
JOIN locations l ON l.work_id='10000000-0000-4000-8000-000000000008' AND l.slug=w.location_slug
ON CONFLICT DO NOTHING;

COMMIT;
