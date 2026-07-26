BEGIN;

-- =========================================================================
-- 012_bible_full_03_exodus-and-sinai.sql
-- Chapter K=03 slug='exodus-and-sinai' (Exodus: oppression, deliverance, Sinai)
-- Adds 9 characters, 2 locations, 16 new events, 8 relations, and reorders
-- the ten pre-existing exodus events into the 3001-3999 sequence band.
-- Also backfills the eleazar-son-of-aaron link dropped when 013 was loaded.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('43000000-0000-4000-8003-000000000001','10000000-0000-4000-8000-000000000005','shiphrah',300,'female','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8003-000000000002','10000000-0000-4000-8000-000000000005','puah',301,'female','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8003-000000000003','10000000-0000-4000-8000-000000000005','jochebed',302,'female','adult','supporting','unknown',NULL,NULL,'matriarch',3),
('43000000-0000-4000-8003-000000000004','10000000-0000-4000-8000-000000000005','pharaohs-daughter',303,'female','adult','supporting','unknown',NULL,NULL,'person',3),
('43000000-0000-4000-8003-000000000005','10000000-0000-4000-8000-000000000005','zipporah',304,'female','adult','supporting','unknown',NULL,NULL,'matriarch',3),
('43000000-0000-4000-8003-000000000006','10000000-0000-4000-8000-000000000005','gershom',305,'male','child','supporting','unknown',NULL,NULL,'person',1),
('43000000-0000-4000-8003-000000000007','10000000-0000-4000-8000-000000000005','hur',306,'male','elder','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8003-000000000008','10000000-0000-4000-8000-000000000005','bezalel',307,'male','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8003-000000000009','10000000-0000-4000-8000-000000000005','eleazar-son-of-aaron',308,'male','adult','supporting','unknown',NULL,NULL,'priest',3)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('shiphrah','zh-CN','施弗拉','希伯来收生婆之一，未遵行法老杀害男婴的命令。',ARRAY[]::text[],'出埃及记开篇记载的两位收生婆之一。她敬畏神，存留希伯来男婴的性命，经文记载神因此厚待收生婆。','敬畏神过于惧怕王命。'),
('shiphrah','en','Shiphrah','One of the Hebrew midwives who did not carry out Pharaoh’s order to kill the boys.',ARRAY[]::text[],'One of two midwives named at the opening of Exodus. Fearing God, she lets the Hebrew boys live, and the text records that God dealt well with the midwives.','Fear of God above fear of the king’s command.'),
('puah','zh-CN','普阿','希伯来收生婆之一，与施弗拉一同存留男婴性命。',ARRAY[]::text[],'与施弗拉并列记名的收生婆。面对法老质问，她们答称希伯来妇人健壮，收生婆尚未赶到孩子已经生下。','敬畏神过于惧怕王命。'),
('puah','en','Puah','One of the Hebrew midwives who, with Shiphrah, let the boys live.',ARRAY[]::text[],'Named alongside Shiphrah. Questioned by Pharaoh, the midwives answer that the Hebrew women are vigorous and give birth before a midwife arrives.','Fear of God above fear of the king’s command.'),
('jochebed','zh-CN','约基别','摩西、亚伦与米利暗的母亲，将婴孩摩西藏于蒲草箱中。',ARRAY[]::text[],'利未家的女子。在杀婴令下把儿子藏了三个月，后置于抹了石漆的蒲草箱放在河边芦荻中，又因公主之召得以亲自乳养自己的孩子。','保全儿子的性命。'),
('jochebed','en','Jochebed','Mother of Moses, Aaron, and Miriam, who hid the infant Moses in a papyrus basket.',ARRAY[]::text[],'A daughter of Levi. Under the killing decree she hides her son for three months, then places him in a pitch-coated basket among the reeds, and is later called by the princess to nurse her own child.','To save her son’s life.'),
('pharaohs-daughter','zh-CN','法老的女儿','在尼罗河边发现蒲草箱中的婴孩并收养他，为他起名摩西。',ARRAY[]::text[],'下到河边沐浴时看见箱中啼哭的希伯来婴孩，动了慈心。她雇孩子的生母乳养他，孩子长大后收为己子。','对弃婴的怜悯。'),
('pharaohs-daughter','en','Pharaoh’s daughter','Found the infant in the basket by the Nile, adopted him, and named him Moses.',ARRAY[]::text[],'Coming down to bathe, she sees the weeping Hebrew child in the basket and takes pity on him. She hires the child’s own mother as nurse, and when he is grown adopts him as her son.','Compassion for the abandoned infant.'),
('zipporah','zh-CN','西坡拉','米甸祭司叶忒罗的女儿，摩西的妻子。',ARRAY[]::text[],'摩西逃亡米甸时在井旁相遇的七姐妹之一，后嫁给摩西，生革舜与以利以谢。归途中曾以火石行割礼救护摩西。','持守家庭于流亡与征召之间。'),
('zipporah','en','Zipporah','Daughter of Jethro the priest of Midian, and wife of Moses.',ARRAY[]::text[],'One of the seven sisters Moses meets at the well in Midian. She marries Moses and bears Gershom and Eliezer, and on the journey back circumcises her son with a flint to protect Moses.','Holding her family together between exile and calling.'),
('gershom','zh-CN','革舜','摩西与西坡拉的长子，生于米甸。',ARRAY[]::text[],'摩西为他起名革舜，说“因我在外邦作了寄居的”。这个名字概括了摩西流亡岁月的心境。','（叙事中未明言。）'),
('gershom','en','Gershom','Firstborn son of Moses and Zipporah, born in Midian.',ARRAY[]::text[],'Moses names him Gershom, saying, “I have been a sojourner in a foreign land.” The name sums up the years of Moses’ exile.','Unstated in the text.'),
('hur','zh-CN','户珥','以色列的长老，与亚伦一同在山顶扶住摩西的手。',ARRAY[]::text[],'亚玛力之战中与亚伦在山顶左右扶住摩西下垂的手，直到日落。摩西上西奈山时，把百姓的争讼交托给亚伦与户珥。','扶持摩西与百姓。'),
('hur','en','Hur','An elder of Israel who, with Aaron, held up Moses’ hands on the hilltop.',ARRAY[]::text[],'During the battle with Amalek he and Aaron support Moses’ weary hands until sunset. When Moses ascends Sinai, the people’s disputes are entrusted to Aaron and Hur.','To support Moses and the people.'),
('bezalel','zh-CN','比撒列','犹大支派的工匠，奉召督造会幕及其器具。',ARRAY[]::text[],'经文记载他被神的灵充满，有智慧、聪明、知识，能作各样的工。他与亚何利亚伯一同带领工匠完成会幕、约柜与全部器具。','以手艺成就所吩咐的工。'),
('bezalel','en','Bezalel','A craftsman of the tribe of Judah called to oversee the making of the tabernacle.',ARRAY[]::text[],'The text records that he is filled with the Spirit of God, with skill, intelligence, and knowledge for every craft. With Oholiab he leads the artisans in completing the tabernacle, the ark, and all the furnishings.','To accomplish the commanded work through craftsmanship.'),
('eleazar-son-of-aaron','zh-CN','以利亚撒（亚伦之子）','亚伦的第三子，继任大祭司。',ARRAY[]::text[],'与拿答、亚比户、以他玛同列为亚伦之子，承接圣职。拿答与亚比户死后地位上升，亚伦死于何珥山时接续父亲作大祭司，并参与约书亚受立与分地。','承续祭司职分。'),
('eleazar-son-of-aaron','en','Eleazar (son of Aaron)','Third son of Aaron, who succeeded him as high priest.',ARRAY[]::text[],'Listed with Nadab, Abihu, and Ithamar among Aaron’s sons set apart for the priesthood. After the deaths of Nadab and Abihu his standing rises; at Aaron’s death on Mount Hor he succeeds his father, and later shares in Joshua’s commissioning and the allotment of the land.','To carry on the priestly office.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. LOCATIONS (reuse goshen, nile-delta, mount-sinai-traditional,
--    reed-sea-crossing; only 2 new, traditional wilderness stations)
-- -------------------------------------------------------------------------
INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('33000000-0000-4000-8003-000000000001','10000000-0000-4000-8000-000000000005','elim-reference','real',ST_GeogFromText('POINT(33.0300 29.0600)'),NULL,NULL,300,'landmark','inferred',8,'EG',true,true),
('33000000-0000-4000-8003-000000000002','10000000-0000-4000-8000-000000000005','rephidim-reference','real',ST_GeogFromText('POINT(33.6000 28.7000)'),NULL,NULL,301,'landmark','inferred',8,'EG',true,true)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,status,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',ARRAY[]::text[],'','','','',v.region FROM locations l JOIN (VALUES
('elim-reference','zh-CN','以琳（推定位置）','旷野行程中有十二股水泉、七十棵棕树的绿洲，传统上定于西奈半岛西侧的加兰德勒旱谷。','西奈旷野'),
('elim-reference','en','Elim (traditional site)','The oasis of twelve springs and seventy palms on the wilderness route, traditionally placed at Wadi Gharandel on the west side of the Sinai peninsula.','Wilderness of Sinai'),
('rephidim-reference','zh-CN','利非订（推定位置）','磐石出水与亚玛力之战的营地，传统上定于西奈山西北的费兰旱谷一带。','西奈旷野'),
('rephidim-reference','en','Rephidim (traditional site)','The camp of the water from the rock and the battle with Amalek, traditionally placed near Wadi Feiran northwest of Mount Sinai.','Wilderness of Sinai')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug AND l.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 3. EVENTS (new) -- range dating within the era band -1400..-1200,
--    chapter 'exodus-and-sinai'
-- -------------------------------------------------------------------------
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('63000000-0000-4000-8003-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,'range'::event_time_type,'unknown'::calendar_system,
       v.y1,v.y2,'low'::confidence_level,ch.id
FROM (VALUES
(1,'pharaoh-orders-killing-of-hebrew-boys',3001,'reported_historical','political',-1400,-1260),
(2,'moses-hidden-in-basket-on-the-nile',3005,'reported_historical','escape',-1400,-1250),
(3,'pharaohs-daughter-adopts-moses',3007,'reported_historical','social',-1400,-1250),
(4,'moses-kills-an-egyptian',3009,'reported_historical','death',-1380,-1250),
(5,'moses-marries-zipporah',3013,'reported_historical','marriage',-1370,-1240),
(6,'nine-plagues-strike-egypt',3019,'legendary_or_mythic','religious',-1310,-1210),
(7,'institution-of-the-passover',3021,'reported_historical','religious',-1300,-1200),
(8,'death-of-the-firstborn',3023,'legendary_or_mythic','death',-1300,-1200),
(9,'bitter-water-at-marah-and-springs-of-elim',3031,'legendary_or_mythic','journey',-1300,-1200),
(10,'manna-and-quail-in-the-wilderness',3033,'legendary_or_mythic','religious',-1300,-1200),
(11,'water-from-the-rock-at-rephidim',3035,'legendary_or_mythic','religious',-1300,-1200),
(12,'battle-with-amalek-at-rephidim',3037,'reported_historical','battle',-1300,-1200),
(13,'theophany-at-sinai',3041,'legendary_or_mythic','religious',-1300,-1200),
(14,'ten-commandments-given',3043,'legendary_or_mythic','religious',-1300,-1200),
(15,'moses-intercedes-and-new-tablets',3049,'reported_historical','religious',-1300,-1200),
(16,'tabernacle-completed-and-glory-fills',3051,'legendary_or_mythic','religious',-1300,-1200)
) AS v(n,slug,seq,reality,etype,y1,y2)
JOIN chapters ch ON ch.slug='exodus-and-sinai' AND ch.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 4. Reorder existing exodus-and-sinai events into the 3001-3999 band,
--    interleaved with the new events above
-- -------------------------------------------------------------------------
UPDATE events e SET sequence=v.seq FROM (VALUES
  ('birth-of-moses-in-goshen',3003),
  ('moses-flees-to-midian',3011),
  ('call-at-the-burning-bush',3015),
  ('confrontation-with-pharaoh',3017),
  ('exodus-from-egypt',3025),
  ('crossing-of-the-sea',3027),
  ('song-at-the-sea',3029),
  ('jethro-advises-a-court-system',3039),
  ('sinai-covenant',3045),
  ('golden-calf-episode',3047)
) AS v(slug,seq) WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug=v.slug;

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tlabel FROM events e JOIN (VALUES
('pharaoh-orders-killing-of-hebrew-boys','zh-CN','法老下令杀害希伯来男婴','新王恐惧以色列人增多，吩咐收生婆杀死所有希伯来男婴。','收生婆施弗拉与普阿敬畏神，不遵王命，存留男婴的性命。法老遂命令全民把希伯来人所生的男孩都丢在河里。','压迫叙事的顶点，为摩西的出生与获救设定险境。','约公元前 1400–1260 年'),
('pharaoh-orders-killing-of-hebrew-boys','en','Pharaoh orders the killing of Hebrew boys','Fearing the growth of Israel, the new king commands the midwives to kill every Hebrew boy.','The midwives Shiphrah and Puah fear God and do not obey, letting the boys live. Pharaoh then orders all his people to cast every Hebrew-born son into the Nile.','The climax of the oppression narrative, setting the peril into which Moses is born.','c. 1400–1260 BCE'),
('moses-hidden-in-basket-on-the-nile','zh-CN','摩西藏于蒲草箱','约基别把藏了三个月的婴孩放进抹了石漆的蒲草箱，搁在尼罗河边的芦荻中。','孩子的姐姐米利暗远远站着，要知道他究竟会怎样。','希伯来婴孩在死亡之河上得以存留，成为拯救叙事的开端。','约公元前 1400–1250 年'),
('moses-hidden-in-basket-on-the-nile','en','Moses hidden in a basket on the Nile','After hiding him three months, Jochebed places the infant in a pitch-coated papyrus basket among the reeds of the Nile.','His sister Miriam stands at a distance to see what will happen to him.','A Hebrew infant is preserved on the river of death, opening the deliverance narrative.','c. 1400–1250 BCE'),
('pharaohs-daughter-adopts-moses','zh-CN','法老的女儿收养摩西','公主在河边发现箱中啼哭的婴孩，动了慈心，收他为子，起名摩西。','经米利暗引荐，公主雇孩子的生母约基别为乳母。孩子长大后进入王宫，名字被解作“因我把他从水里拉出来”。','拯救者在压迫者的宫中长大，构成出埃及叙事的反讽核心。','约公元前 1400–1250 年'),
('pharaohs-daughter-adopts-moses','en','Pharaoh’s daughter adopts Moses','The princess finds the weeping child in the basket, takes pity on him, and adopts him as her son, naming him Moses.','Through Miriam’s intervention, the child’s own mother Jochebed is hired as his nurse. Grown, he enters the palace; the name is explained as “because I drew him out of the water.”','The deliverer is raised in the oppressor’s own house, the central irony of the exodus narrative.','c. 1400–1250 BCE'),
('moses-kills-an-egyptian','zh-CN','摩西击杀埃及人','摩西见一个埃及人打希伯来同胞，便击杀了那埃及人，把他藏在沙土里。','次日他劝解两个相争的希伯来人，却被反问“谁立你作我们的首领和审判官呢”。事情传到法老耳中，法老想要杀他。','这一冲动之举终结了摩西的宫廷岁月，把他推向流亡。','约公元前 1380–1250 年'),
('moses-kills-an-egyptian','en','Moses kills an Egyptian','Seeing an Egyptian beating a Hebrew kinsman, Moses strikes the Egyptian down and hides him in the sand.','The next day, intervening between two quarreling Hebrews, he is asked, “Who made you a ruler and judge over us?” Word reaches Pharaoh, who seeks his life.','This impulsive act ends Moses’ palace years and drives him into exile.','c. 1380–1250 BCE'),
('moses-marries-zipporah','zh-CN','摩西娶西坡拉','摩西在米甸井旁帮助祭司的七个女儿饮群羊，被留居其家，娶了西坡拉为妻。','西坡拉生子，摩西为他起名革舜，说“因我在外邦作了寄居的”。摩西为岳父叶忒罗牧羊约四十年。','流亡者在米甸安家牧羊，等候荆棘中的呼召。','约公元前 1370–1240 年'),
('moses-marries-zipporah','en','Moses marries Zipporah','After helping the priest’s seven daughters water their flock at a well in Midian, Moses stays with the household and marries Zipporah.','She bears a son whom Moses names Gershom, saying, “I have been a sojourner in a foreign land.” Moses keeps Jethro’s flock for some forty years.','The exile settles as a shepherd in Midian, awaiting the call from the burning bush.','c. 1370–1240 BCE'),
('nine-plagues-strike-egypt','zh-CN','九灾接连击打埃及','血水、青蛙、虱子、苍蝇、瘟疫、疮、冰雹、蝗虫、黑暗接连临到埃及。','每次灾祸后法老或应许或反悔，心里刚硬，不容以色列人离去。叙事以灾祸的升级刻画两造之间的较量。','十灾叙事的主体，显明王权在更大权能面前的步步崩解。','约公元前 1310–1210 年'),
('nine-plagues-strike-egypt','en','Nine plagues strike Egypt','Blood, frogs, gnats, flies, pestilence, boils, hail, locusts, and darkness fall upon Egypt in succession.','After each plague Pharaoh promises or reneges, his heart hardened, refusing to let Israel go. The narrative stages the contest through the escalation of the blows.','The main body of the plagues narrative, portraying royal power crumbling before a greater one.','c. 1310–1210 BCE'),
('institution-of-the-passover','zh-CN','逾越节的设立','以色列各家取羔羊宰杀，把血涂在门框门楣上，当夜带着腰间束带吃烤羊肉与无酵饼。','经文规定这月为正月，这礼要世世代代守为永远的定例，好在击杀之灾中“越过”涂血的家。','以色列最核心的节期在此设立，此后世代以此夜追念出埃及。','约公元前 1300–1200 年'),
('institution-of-the-passover','en','Institution of the Passover','Each Israelite household slaughters a lamb, puts its blood on the doorposts and lintel, and that night eats the roasted meat with unleavened bread, dressed for departure.','The text appoints this month as the first of months and the rite as a perpetual ordinance, so that the destroying blow will “pass over” the blood-marked houses.','Israel’s central festival is founded here; every later generation recalls the exodus through this night.','c. 1300–1200 BCE'),
('death-of-the-firstborn','zh-CN','击杀长子之灾','半夜时分，埃及全地的长子都被击杀，从法老的长子直到囚犯的长子。','埃及有大哀号，法老夜间召摩西亚伦，催促以色列人带着群畜离去。','第十灾击破法老最后的抗拒，直接引出出埃及。','约公元前 1300–1200 年'),
('death-of-the-firstborn','en','Death of the firstborn','At midnight every firstborn in the land of Egypt is struck down, from the firstborn of Pharaoh to the firstborn of the captive.','A great cry rises in Egypt; Pharaoh summons Moses and Aaron by night and urges Israel to leave with their flocks and herds.','The tenth plague breaks Pharaoh’s final resistance and leads directly into the exodus.','c. 1300–1200 BCE'),
('bitter-water-at-marah-and-springs-of-elim','zh-CN','玛拉苦水与以琳水泉','行走三日无水，到玛拉水又是苦的；摩西照指示把一棵树丢在水里，水就变甜。','百姓随后来到以琳，那里有十二股水泉、七十棵棕树，就在水边安营。','旷野供应叙事的开端：怨言、试炼与安歇交替出现。','约公元前 1300–1200 年'),
('bitter-water-at-marah-and-springs-of-elim','en','Bitter water at Marah and the springs of Elim','After three waterless days the people reach Marah, where the water is bitter; shown a log, Moses throws it in and the water turns sweet.','The people then come to Elim, with its twelve springs and seventy palm trees, and camp by the water.','The opening of the wilderness-provision narrative: complaint, testing, and rest in alternation.','c. 1300–1200 BCE'),
('manna-and-quail-in-the-wilderness','zh-CN','旷野降下吗哪与鹌鹑','百姓在汛的旷野因饥饿发怨言，晚上有鹌鹑飞来遮满营地，早晨地面上有如白霜的小圆物。','以色列人叫它吗哪。经文规定每日按食量收取，第六日收双份，安息日不降。','四十年旷野岁月的日用供应由此开始，也成为安息日操练的功课。','约公元前 1300–1200 年'),
('manna-and-quail-in-the-wilderness','en','Manna and quail in the wilderness','Hungry in the wilderness of Sin, the people complain; quail cover the camp at evening, and in the morning a fine flake-like thing lies on the ground like frost.','Israel calls it manna. The text prescribes gathering a daily portion, a double share on the sixth day, and none on the sabbath.','The daily provision of the forty wilderness years begins here, and with it the discipline of the sabbath.','c. 1300–1200 BCE'),
('water-from-the-rock-at-rephidim','zh-CN','利非订磐石出水','百姓在利非订无水可喝，与摩西争闹，几乎要拿石头打他。','摩西照指示用杖击打何烈的磐石，就有水流出来。那地方得名玛撒、米利巴，意为试探与争闹。','旷野怨言叙事的典型场景，此后一再被追述为“试探耶和华”的地方。','约公元前 1300–1200 年'),
('water-from-the-rock-at-rephidim','en','Water from the rock at Rephidim','With no water at Rephidim, the people quarrel with Moses and are almost ready to stone him.','As instructed, Moses strikes the rock at Horeb with his staff and water flows out. The place is named Massah and Meribah, testing and quarreling.','A defining scene of the wilderness complaints, recalled ever after as the place where the Lord was tested.','c. 1300–1200 BCE'),
('battle-with-amalek-at-rephidim','zh-CN','与亚玛力人争战','亚玛力人来到利非订攻击以色列，约书亚奉命选人出战。','摩西在山顶举手，以色列就得胜；手一垂下，亚玛力就得胜。亚伦与户珥左右扶住他的手，直到日落，约书亚杀败了亚玛力人。','约书亚首次以统帅身份出场，户珥也由此进入叙事。','约公元前 1300–1200 年'),
('battle-with-amalek-at-rephidim','en','Battle with Amalek at Rephidim','Amalek comes to fight Israel at Rephidim, and Joshua is charged to choose men and go out to battle.','While Moses holds up his hands on the hilltop Israel prevails; when they drop, Amalek prevails. Aaron and Hur hold up his hands until sunset, and Joshua defeats Amalek.','Joshua’s first appearance as commander, and Hur’s entry into the narrative.','c. 1300–1200 BCE'),
('theophany-at-sinai','zh-CN','西奈山上的显现','出埃及后第三个月，以色列人在西奈山下安营；第三天早晨山上有雷轰、闪电、密云与极大的角声。','西奈全山冒烟，因为耶和华在火中降临；百姓在界限外发颤，摩西上到山上。','旷野叙事的中心场景，为立约与颁布律法拉开帷幕。','约公元前 1300–1200 年'),
('theophany-at-sinai','en','Theophany at Sinai','In the third month after leaving Egypt Israel camps before Mount Sinai; on the morning of the third day come thunder, lightning, thick cloud, and a very loud trumpet blast.','The whole mountain smokes because the Lord descends on it in fire; the people tremble behind the boundary while Moses goes up.','The central scene of the wilderness narrative, opening the covenant and the giving of the law.','c. 1300–1200 BCE'),
('ten-commandments-given','zh-CN','颁布十诫','神在西奈山上晓谕十条诫命，从“除我以外你不可有别的神”到“不可贪恋”。','百姓见雷轰闪电便远远站立，求摩西代为传话。十诫其后又由神亲手写在两块石版上。','以色列律法传统的核心文本，此后一切诫命叙事的基石。','约公元前 1300–1200 年'),
('ten-commandments-given','en','The Ten Commandments given','On Sinai God speaks the ten words, from “You shall have no other gods before me” to “You shall not covet.”','Seeing the thunder and lightning the people stand far off and ask Moses to speak for them. The commandments are afterwards written by God on two stone tablets.','The core text of Israel’s legal tradition, the foundation of every later commandment narrative.','c. 1300–1200 BCE'),
('moses-intercedes-and-new-tablets','zh-CN','摩西代求与重造法版','金牛犊事件后，摩西为百姓恳切代求，求神不要灭绝他们，甚至愿意从册上被涂抹。','神应允同行，摩西奉命凿出两块新石版再上西奈山。耶和华在他面前宣告自己的名，摩西下山时脸上发光。','立约破裂后的修复叙事，塑造了摩西作为代求者的形象。','约公元前 1300–1200 年'),
('moses-intercedes-and-new-tablets','en','Moses intercedes and new tablets are made','After the golden calf Moses pleads for the people, asking God not to destroy them and offering to be blotted out of the book himself.','God consents to go with them; Moses cuts two new tablets and ascends Sinai again, where the Lord proclaims his name before him. Moses descends with his face shining.','The narrative of repair after the broken covenant, shaping Moses’ image as intercessor.','c. 1300–1200 BCE'),
('tabernacle-completed-and-glory-fills','zh-CN','会幕建成，荣光充满','比撒列率工匠照山上所示的样式完成会幕、约柜与一切器具，摩西验看并为工作祝福。','出埃及第二年正月初一日会幕立起，云彩遮盖会幕，耶和华的荣光充满帐幕，连摩西也不能进去。','出埃及记以此收束：同在的记号从山上移入营中，引导此后的旷野行程。','约公元前 1300–1200 年'),
('tabernacle-completed-and-glory-fills','en','The tabernacle completed and filled with glory','Bezalel and the artisans finish the tabernacle, the ark, and all the furnishings after the pattern shown on the mountain, and Moses inspects and blesses the work.','On the first day of the first month of the second year the tabernacle is raised; the cloud covers it and the glory of the Lord fills it, so that even Moses cannot enter.','Exodus closes here: the sign of presence moves from the mountain into the camp, guiding the wilderness journeys to come.','c. 1300–1200 BCE')
) AS v(slug,locale,title,summary,detail,sig,tlabel) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS (reuse goshen, nile-delta, mount-sinai-traditional;
--    new elim-reference, rephidim-reference)
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('pharaoh-orders-killing-of-hebrew-boys','goshen'),
('moses-hidden-in-basket-on-the-nile','nile-delta'),
('pharaohs-daughter-adopts-moses','nile-delta'),
('moses-kills-an-egyptian','nile-delta'),
('moses-marries-zipporah','mount-sinai-traditional'),
('nine-plagues-strike-egypt','nile-delta'),
('institution-of-the-passover','goshen'),
('death-of-the-firstborn','nile-delta'),
('bitter-water-at-marah-and-springs-of-elim','elim-reference'),
('manna-and-quail-in-the-wilderness','elim-reference'),
('water-from-the-rock-at-rephidim','rephidim-reference'),
('battle-with-amalek-at-rephidim','rephidim-reference'),
('theophany-at-sinai','mount-sinai-traditional'),
('ten-commandments-given','mount-sinai-traditional'),
('moses-intercedes-and-new-tablets','mount-sinai-traditional'),
('tabernacle-completed-and-glory-fills','mount-sinai-traditional')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('pharaoh-orders-killing-of-hebrew-boys','pharaoh-of-the-exodus',0),('pharaoh-orders-killing-of-hebrew-boys','shiphrah',1),('pharaoh-orders-killing-of-hebrew-boys','puah',2),
('moses-hidden-in-basket-on-the-nile','jochebed',0),('moses-hidden-in-basket-on-the-nile','moses',1),('moses-hidden-in-basket-on-the-nile','miriam',2),
('pharaohs-daughter-adopts-moses','pharaohs-daughter',0),('pharaohs-daughter-adopts-moses','moses',1),('pharaohs-daughter-adopts-moses','miriam',2),('pharaohs-daughter-adopts-moses','jochebed',3),
('moses-kills-an-egyptian','moses',0),
('moses-marries-zipporah','moses',0),('moses-marries-zipporah','zipporah',1),('moses-marries-zipporah','jethro',2),('moses-marries-zipporah','gershom',3),
('nine-plagues-strike-egypt','moses',0),('nine-plagues-strike-egypt','aaron',1),('nine-plagues-strike-egypt','pharaoh-of-the-exodus',2),
('institution-of-the-passover','moses',0),('institution-of-the-passover','aaron',1),
('death-of-the-firstborn','pharaoh-of-the-exodus',0),('death-of-the-firstborn','moses',1),('death-of-the-firstborn','aaron',2),
('bitter-water-at-marah-and-springs-of-elim','moses',0),('bitter-water-at-marah-and-springs-of-elim','aaron',1),
('manna-and-quail-in-the-wilderness','moses',0),('manna-and-quail-in-the-wilderness','aaron',1),
('water-from-the-rock-at-rephidim','moses',0),
('battle-with-amalek-at-rephidim','joshua',0),('battle-with-amalek-at-rephidim','moses',1),('battle-with-amalek-at-rephidim','aaron',2),('battle-with-amalek-at-rephidim','hur',3),
('theophany-at-sinai','moses',0),('theophany-at-sinai','aaron',1),
('ten-commandments-given','moses',0),
('moses-intercedes-and-new-tablets','moses',0),
('tabernacle-completed-and-glory-fills','bezalel',0),('tabernacle-completed-and-glory-fills','moses',1),('tabernacle-completed-and-glory-fills','aaron',2)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- Backfill: 013 referenced eleazar-son-of-aaron in joshua-commissioned-as-successor
-- before the character existed; restore the dropped event_characters row.
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,'participant',
       (SELECT COALESCE(MAX(ec.participant_order),-1)+1 FROM event_characters ec WHERE ec.event_id=e.id),
       false
FROM events e
JOIN characters c ON c.slug='eleazar-son-of-aaron' AND c.work_id=e.work_id
WHERE e.slug='joshua-commissioned-as-successor' AND e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES (all new events map to Exodus)
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Exodus'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.id::text LIKE '63000000-0000-4000-8003%'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS
-- -------------------------------------------------------------------------
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('73000000-0000-4000-8003-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'jochebed','moses','family','source_to_target','positive',4,'unknown','moses-hidden-in-basket-on-the-nile',NULL),
(2,'pharaohs-daughter','moses','family','source_to_target','positive',3,'changed','pharaohs-daughter-adopts-moses','moses-flees-to-midian'),
(3,'moses','zipporah','spouse','bidirectional','positive',4,'active','moses-marries-zipporah',NULL),
(4,'jethro','zipporah','family','source_to_target','positive',3,'unknown',NULL,NULL),
(5,'moses','gershom','family','source_to_target','positive',3,'unknown','moses-marries-zipporah',NULL),
(6,'zipporah','gershom','family','source_to_target','positive',3,'unknown','moses-marries-zipporah',NULL),
(7,'aaron','eleazar-son-of-aaron','family','source_to_target','positive',3,'unknown',NULL,NULL),
(8,'hur','moses','ally','source_to_target','positive',3,'active','battle-with-amalek-at-rephidim',NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000005'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 10. GROUP MEMBERSHIP (existing group exodus-leadership)
-- -------------------------------------------------------------------------
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g JOIN (VALUES
('exodus-leadership','jochebed'),('exodus-leadership','zipporah'),('exodus-leadership','hur'),
('exodus-leadership','bezalel'),('exodus-leadership','eleazar-son-of-aaron')
) AS v(gslug,cslug)
ON g.slug=v.gslug JOIN characters c ON c.slug=v.cslug AND c.work_id=g.work_id
WHERE g.work_id='10000000-0000-4000-8000-000000000005' ON CONFLICT DO NOTHING;

COMMIT;
