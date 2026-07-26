BEGIN;

-- =========================================================================
-- 010_bible_full_01_primeval.sql
-- Chapter K=01 slug='primeval' (Genesis 1-11, the origin narrative)
-- Adds ~12 characters, ~47 new events, relations, and reorders the
-- three pre-existing primeval events into the 1001-1999 sequence band.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('43000000-0000-4000-8001-000000000001','10000000-0000-4000-8000-000000000005','adam',200,'male','adult','protagonist','unknown',NULL,NULL,'patriarch',4),
('43000000-0000-4000-8001-000000000002','10000000-0000-4000-8000-000000000005','eve',201,'female','adult','protagonist','unknown',NULL,NULL,'matriarch',4),
('43000000-0000-4000-8001-000000000003','10000000-0000-4000-8000-000000000005','cain',202,'male','adult','antagonist','unknown',NULL,NULL,'person',3),
('43000000-0000-4000-8001-000000000004','10000000-0000-4000-8000-000000000005','abel',203,'male','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8001-000000000005','10000000-0000-4000-8000-000000000005','seth',204,'male','adult','supporting','unknown',NULL,NULL,'patriarch',2),
('43000000-0000-4000-8001-000000000006','10000000-0000-4000-8000-000000000005','enoch',205,'male','adult','supporting','unknown',NULL,NULL,'patriarch',2),
('43000000-0000-4000-8001-000000000007','10000000-0000-4000-8000-000000000005','methuselah',206,'male','elder','supporting','unknown',NULL,NULL,'patriarch',1),
('43000000-0000-4000-8001-000000000008','10000000-0000-4000-8000-000000000005','lamech-father-of-noah',207,'male','adult','supporting','unknown',NULL,NULL,'patriarch',1),
('43000000-0000-4000-8001-000000000009','10000000-0000-4000-8000-000000000005','shem',208,'male','adult','supporting','unknown',NULL,NULL,'patriarch',2),
('43000000-0000-4000-8001-000000000010','10000000-0000-4000-8000-000000000005','ham',209,'male','adult','supporting','unknown',NULL,NULL,'patriarch',2),
('43000000-0000-4000-8001-000000000011','10000000-0000-4000-8000-000000000005','japheth',210,'male','adult','supporting','unknown',NULL,NULL,'patriarch',2),
('43000000-0000-4000-8001-000000000012','10000000-0000-4000-8000-000000000005','nimrod',211,'male','adult','antagonist','unknown',NULL,NULL,'king',2);

INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('adam','zh-CN','亚当','创世记开篇的首位人类，被安置在伊甸园中。',ARRAY[]::text[],'由尘土所造，奉命看守伊甸园并为动物命名，后与夏娃一同被逐出园外。','守护并耕种所托付的园子。'),
('adam','en','Adam','The first human of the Genesis narrative, placed in the garden of Eden.',ARRAY[]::text[],'Formed from dust, he is set to keep the garden and name the animals, and is later expelled with Eve.','To tend and keep the garden entrusted to him.'),
('eve','zh-CN','夏娃','亚当的妻子，被称为众生之母。',ARRAY[]::text[],'取自亚当的肋骨所造，被蛇引诱食用禁果，后生育该隐、亚伯与塞特。','渴望智慧与生命的丰盛。'),
('eve','en','Eve','Adam’s wife, described as the mother of all the living.',ARRAY[]::text[],'Formed from Adam’s rib, she is persuaded by the serpent to eat the forbidden fruit and later bears Cain, Abel, and Seth.','A longing for wisdom and fuller life.'),
('cain','zh-CN','该隐','亚当与夏娃的长子，因嫉妒杀害兄弟亚伯。',ARRAY[]::text[],'务农为业，因所献祭物不被悦纳而心生忿怒，杀弟后遭放逐并带有标记。','对兄弟蒙悦纳的嫉妒与愤怒。'),
('cain','en','Cain','Adam and Eve’s firstborn, who killed his brother Abel out of jealousy.',ARRAY[]::text[],'A tiller of the ground, he grows resentful when his offering is not accepted, kills Abel, and is exiled bearing a protective mark.','Jealousy and anger at his brother’s favored offering.'),
('abel','zh-CN','亚伯','亚当与夏娃之子，牧羊人，被兄长该隐所杀。',ARRAY[]::text[],'以牧羊为业，所献的头生羊羔蒙神悦纳，因此招致该隐的嫉恨。','以最好的初产献给神。'),
('abel','en','Abel','Adam and Eve’s son, a shepherd killed by his brother Cain.',ARRAY[]::text[],'A keeper of flocks whose firstborn offering is favored, provoking Cain’s resentment.','To offer the best of his flock.'),
('seth','zh-CN','塞特','亚当与夏娃在亚伯死后所生之子，被列为挪亚的先祖。',ARRAY[]::text[],'代替亚伯成为家系的延续者，其后裔谱系一直传到挪亚。','延续家族血脉。'),
('seth','en','Seth','Adam and Eve’s son, born after Abel’s death and listed as an ancestor of Noah.',ARRAY[]::text[],'He continues the family line in place of Abel, and his descendants are traced down to Noah.','To continue the family line.'),
('enoch','zh-CN','以诺','塞特谱系中的一位先祖，据载与神同行，未经历死亡而被接去。',ARRAY[]::text[],'家谱记载他与神同行三百年，随后“不在世上，因为神将他取去”。','与神同行的敬虔生活。'),
('enoch','en','Enoch','A patriarch in Seth’s line, said to have walked with God and to have been taken without dying.',ARRAY[]::text[],'The genealogy records that he walked with God for three hundred years and then “was not, for God took him.”','A life of walking closely with God.'),
('methuselah','zh-CN','玛土撒拉','以诺之子，谱系中记载寿数最长的人物。',ARRAY[]::text[],'家谱中记载他活了九百六十九岁，是塞特世系中承前启后的一环。','延续家族谱系。'),
('methuselah','en','Methuselah','Enoch’s son, recorded in the genealogy as the longest-lived figure.',ARRAY[]::text[],'The genealogy credits him with a lifespan of 969 years, linking Seth’s line forward to Noah.','To carry the family line forward.'),
('lamech-father-of-noah','zh-CN','拉麦（挪亚之父）','玛土撒拉之子，挪亚的父亲。',ARRAY[]::text[],'为儿子取名挪亚，盼望他能使人从劳苦中得安慰。','盼望后代带来安慰与释放。'),
('lamech-father-of-noah','en','Lamech (father of Noah)','Methuselah’s son and the father of Noah.',ARRAY[]::text[],'He names his son Noah, hoping he will bring comfort from the toil of the cursed ground.','Hope that his son would bring relief and comfort.'),
('shem','zh-CN','闪','挪亚的长子，被列为闪族谱系的先祖。',ARRAY[]::text[],'与父亲一同进入方舟度过洪水，因未窥看父亲的赤身而蒙祝福。','对父亲的敬重与遮盖。'),
('shem','en','Shem','Noah’s eldest son, listed as ancestor of the Semitic peoples.',ARRAY[]::text[],'He enters the ark with his father, and is blessed for covering rather than viewing his father’s nakedness.','Reverence and discretion toward his father.'),
('ham','zh-CN','含','挪亚之子，因窥见父亲醉酒赤身而招致咒诅。',ARRAY[]::text[],'与家人一同经历洪水，事后因窥看并宣扬父亲醉酒赤身之事，其子迦南遭到咒诅。','（叙事中未明言，行为招致后果。）'),
('ham','en','Ham','Noah’s son, whose act of seeing his father’s nakedness brought a curse.',ARRAY[]::text[],'He survives the flood with his family, but seeing and reporting his father’s drunken nakedness results in a curse on his son Canaan.','Unstated in the text; his act brings consequence.'),
('japheth','zh-CN','雅弗','挪亚之子，被列为诸海岛民族的先祖。',ARRAY[]::text[],'与兄长闪一同遮盖父亲的赤身，蒙父祝福，其后裔被列为沿海邦国的先祖。','对父亲的敬重与遮盖。'),
('japheth','en','Japheth','Noah’s son, listed as ancestor of the coastland peoples.',ARRAY[]::text[],'He joins Shem in covering their father’s nakedness and is blessed; his descendants are traced to the coastland nations.','Reverence and discretion toward his father.'),
('nimrod','zh-CN','宁录','含之孙，被描述为地上第一位英雄和王国的建立者。',ARRAY[]::text[],'古实之子，被称为“世上英雄之首”，在示拿地建立巴别、以力等城邦。','建立势力与统治的雄心。'),
('nimrod','en','Nimrod','Ham’s grandson, described as the first mighty one on earth and founder of a kingdom.',ARRAY[]::text[],'A son of Cush called “a mighty one on the earth,” he establishes Babel, Erech, and other cities in the land of Shinar.','Ambition to build power and dominion.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 2. LOCATIONS (reuse ararat-mountains, babylon; only 2 new, inferred sites)
-- -------------------------------------------------------------------------
INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('33000000-0000-4000-8001-000000000001','10000000-0000-4000-8000-000000000005','eden-reference','real',ST_GeogFromText('POINT(47.4400 31.0000)'),NULL,NULL,212,'religious_site','inferred',7,'IQ',true,false),
('33000000-0000-4000-8001-000000000002','10000000-0000-4000-8000-000000000005','land-of-nod-reference','real',ST_GeogFromText('POINT(50.5000 32.5000)'),NULL,NULL,213,'region','inferred',6,'IR',true,false);

INSERT INTO location_translations(location_id,locale,name,summary,status,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',ARRAY[]::text[],'','','','',v.region FROM locations l JOIN (VALUES
('eden-reference','zh-CN','伊甸园（推定位置）','创世记记载的人类起源之园，传统上定位于两河流域南部。','美索不达米亚'),
('eden-reference','en','Eden (traditional site)','The garden of human origins in Genesis, traditionally placed in southern Mesopotamia.','Mesopotamia'),
('land-of-nod-reference','zh-CN','挪得之地（推定位置）','该隐被放逐后所居之地，经文记载在伊甸以东。','伊甸以东'),
('land-of-nod-reference','en','Land of Nod (traditional site)','The place east of Eden where Cain settled after his exile.','East of Eden')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug AND l.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 3. EVENTS (new) -- all NULL years, time_type unknown, confidence low,
--    reality legendary_or_mythic, chapter 'primeval'
-- -------------------------------------------------------------------------
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('63000000-0000-4000-8001-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'unknown'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'creation-of-heavens-and-earth',1001,'legendary_or_mythic','religious','unknown',NULL::integer,NULL::integer,'low','primeval'),
(2,'creation-of-humankind',1003,'legendary_or_mythic','religious','unknown',NULL,NULL,'low','primeval'),
(3,'sabbath-rest-of-creation',1005,'legendary_or_mythic','religious','unknown',NULL,NULL,'low','primeval'),
(4,'adam-placed-in-garden-of-eden',1007,'legendary_or_mythic','religious','unknown',NULL,NULL,'low','primeval'),
(5,'naming-of-the-animals',1009,'legendary_or_mythic','discovery','unknown',NULL,NULL,'low','primeval'),
(6,'creation-of-eve-from-adams-rib',1011,'legendary_or_mythic','religious','unknown',NULL,NULL,'low','primeval'),
(7,'serpent-tempts-eve',1013,'legendary_or_mythic','trial','unknown',NULL,NULL,'low','primeval'),
(8,'adam-and-eve-eat-forbidden-fruit',1015,'legendary_or_mythic','betrayal','unknown',NULL,NULL,'low','primeval'),
(9,'expulsion-from-eden',1017,'legendary_or_mythic','migration','unknown',NULL,NULL,'low','primeval'),
(10,'birth-of-cain',1019,'legendary_or_mythic','birth','unknown',NULL,NULL,'low','primeval'),
(11,'birth-of-abel',1021,'legendary_or_mythic','birth','unknown',NULL,NULL,'low','primeval'),
(12,'cain-and-abel-bring-offerings',1023,'legendary_or_mythic','religious','unknown',NULL,NULL,'low','primeval'),
(13,'cain-murders-abel',1025,'legendary_or_mythic','death','unknown',NULL,NULL,'low','primeval'),
(14,'cain-marked-and-exiled',1027,'legendary_or_mythic','migration','unknown',NULL,NULL,'low','primeval'),
(15,'birth-of-seth',1029,'legendary_or_mythic','birth','unknown',NULL,NULL,'low','primeval'),
(16,'genealogy-from-seth-to-noah',1031,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(17,'birth-of-enoch',1033,'legendary_or_mythic','birth','unknown',NULL,NULL,'low','primeval'),
(18,'enoch-walks-with-god-and-is-taken',1035,'legendary_or_mythic','religious','unknown',NULL,NULL,'low','primeval'),
(19,'birth-of-lamech-father-of-noah',1037,'legendary_or_mythic','birth','unknown',NULL,NULL,'low','primeval'),
(20,'sons-of-god-and-daughters-of-men',1039,'legendary_or_mythic','marriage','unknown',NULL,NULL,'low','primeval'),
(21,'nephilim-on-the-earth',1041,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(22,'god-resolves-to-send-flood',1043,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(23,'noah-found-righteous',1045,'legendary_or_mythic','discovery','unknown',NULL,NULL,'low','primeval'),
(24,'god-commands-noah-to-build-ark',1047,'legendary_or_mythic','religious','unknown',NULL,NULL,'low','primeval'),
(25,'construction-of-the-ark',1049,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(26,'gathering-of-the-animals-into-ark',1051,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(27,'noah-and-family-enter-the-ark',1053,'legendary_or_mythic','journey','unknown',NULL,NULL,'low','primeval'),
(28,'forty-days-of-rain-begins',1055,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(29,'flood-waters-cover-the-earth',1057,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(30,'waters-recede-from-earth',1061,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(31,'noah-sends-out-raven',1063,'legendary_or_mythic','discovery','unknown',NULL,NULL,'low','primeval'),
(32,'noah-sends-out-dove-with-olive-leaf',1065,'legendary_or_mythic','discovery','unknown',NULL,NULL,'low','primeval'),
(33,'earth-dries-and-covering-removed',1067,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(34,'noah-and-family-leave-the-ark',1069,'legendary_or_mythic','journey','unknown',NULL,NULL,'low','primeval'),
(35,'noah-builds-altar-and-offers-sacrifice',1071,'legendary_or_mythic','religious','unknown',NULL,NULL,'low','primeval'),
(36,'noah-plants-vineyard',1075,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(37,'noah-drunk-and-uncovered',1077,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(38,'ham-sees-fathers-nakedness',1079,'legendary_or_mythic','betrayal','unknown',NULL,NULL,'low','primeval'),
(39,'noahs-curse-and-blessing-of-sons',1081,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(40,'genealogy-of-japheth',1083,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(41,'genealogy-of-ham',1085,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(42,'genealogy-of-shem',1087,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(43,'table-of-nations-summary',1089,'legendary_or_mythic','other','unknown',NULL,NULL,'low','primeval'),
(44,'nimrod-rises-as-mighty-hunter',1091,'legendary_or_mythic','political','unknown',NULL,NULL,'low','primeval'),
(45,'nimrod-founds-cities-in-shinar',1093,'legendary_or_mythic','political','unknown',NULL,NULL,'low','primeval'),
(46,'humanity-speaks-one-language-and-settles-in-shinar',1095,'legendary_or_mythic','migration','unknown',NULL,NULL,'low','primeval'),
(47,'building-of-tower-of-babel',1097,'legendary_or_mythic','political','unknown',NULL,NULL,'low','primeval')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,conf,chapter_slug)
JOIN chapters ch ON ch.slug=v.chapter_slug AND ch.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 4. Reorder existing primeval events into the 1001-1999 band
-- -------------------------------------------------------------------------
UPDATE events e SET sequence=v.seq FROM (VALUES
  ('flood-narrative-ends-at-ararat',1059),
  ('covenant-after-the-flood',1073),
  ('dispersal-at-babel',1099)
) AS v(slug,seq) WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug=v.slug;

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,'' FROM events e JOIN (VALUES
('creation-of-heavens-and-earth','zh-CN','创造天地','创世记开篇叙述天地与光暗的分别造成。','六日创造的起始场景，奠定叙事的宇宙秩序。','为后续人类故事确立背景。'),
('creation-of-heavens-and-earth','en','Creation of the heavens and the earth','The opening Genesis account of the separation of light from darkness.','The first scene of the six-day creation, establishing the narrative’s cosmic order.','Sets the stage for the human story that follows.'),
('creation-of-humankind','zh-CN','创造人类','神按自己的形像造男造女。','叙事将人置于受造次序的顶点，赋予治理的托付。','人类起源的核心宣告。'),
('creation-of-humankind','en','Creation of humankind','God creates male and female in his own image.','The narrative places humanity at the summit of the created order, given dominion.','A core statement on the origin of humanity.'),
('sabbath-rest-of-creation','zh-CN','创造后的安息','第七日神歇了他一切的工，安息了。','为后续安息日传统提供叙事根据。','引入劳作与安息的节奏。'),
('sabbath-rest-of-creation','en','The rest after creation','On the seventh day God rests from all his work.','Provides the narrative basis for later sabbath tradition.','Introduces the rhythm of labor and rest.'),
('adam-placed-in-garden-of-eden','zh-CN','亚当被安置于伊甸园','神将亚当安置在伊甸园中，使他修理看守。','伊甸园被描述为可耕种、可看守的园地，附有诫命。','标示人类的原初处境与责任。'),
('adam-placed-in-garden-of-eden','en','Adam placed in the garden of Eden','God places Adam in Eden to work and keep it.','Eden is described as a garden to be tended, with an accompanying command.','Marks humanity’s original setting and responsibility.'),
('naming-of-the-animals','zh-CN','亚当为动物命名','神带各样活物到亚当面前，由他命名。','命名行动象征人对受造界的认知与治理角色。','也显明尚无合适的配偶。'),
('naming-of-the-animals','en','Naming of the animals','God brings the creatures to Adam for him to name.','The act of naming signals humanity’s role of knowing and ordering creation.','It also reveals that no suitable companion is found.'),
('creation-of-eve-from-adams-rib','zh-CN','夏娃由亚当肋骨所造','神使亚当沉睡，取其肋骨造成夏娃。','叙事强调二人“骨中骨、肉中肉”的一体关系。','为婚姻关系提供叙事原型。'),
('creation-of-eve-from-adams-rib','en','Eve formed from Adam’s rib','God causes Adam to sleep and forms Eve from his rib.','The narrative stresses their shared identity as “bone of bone, flesh of flesh.”','Provides the narrative archetype for marriage.'),
('serpent-tempts-eve','zh-CN','蛇引诱夏娃','蛇质疑神的话，引诱夏娃相信禁果能使人如神。','对话围绕分别善恶树的果子展开。','叙事的转折点，引入怀疑与欲望。'),
('serpent-tempts-eve','en','The serpent tempts Eve','The serpent questions God’s word and suggests the fruit will make her like God.','The dialogue centers on the tree of the knowledge of good and evil.','A turning point introducing doubt and desire.'),
('adam-and-eve-eat-forbidden-fruit','zh-CN','亚当夏娃吃禁果','二人违背诫命，吃了分别善恶树的果子。','随即眼睛明亮，自觉赤身而羞愧。','传统上视为人类堕落的关键事件。'),
('adam-and-eve-eat-forbidden-fruit','en','Adam and Eve eat the forbidden fruit','Both eat from the tree of the knowledge of good and evil, breaking the command.','Their eyes are opened and they feel shame at their nakedness.','Traditionally read as the pivotal event of the human fall.'),
('expulsion-from-eden','zh-CN','被逐出伊甸园','神将亚当夏娃逐出园外，安设基路伯把守生命树的路。','叙事解释人类此后劳苦谋生的处境。','标志人与园中安逸生活的分离。'),
('expulsion-from-eden','en','Expulsion from Eden','God expels Adam and Eve from the garden and stations cherubim to guard the way to the tree of life.','The narrative explains humanity’s subsequent toil for survival.','Marks the separation from the garden’s ease.'),
('birth-of-cain','zh-CN','该隐出生','夏娃生下长子该隐。','夏娃称因耶和华的帮助得了一个男子。','开启该隐与亚伯的叙事。'),
('birth-of-cain','en','Birth of Cain','Eve bears her firstborn son, Cain.','Eve declares she has gotten a man with the Lord’s help.','Opens the narrative of Cain and Abel.'),
('birth-of-abel','zh-CN','亚伯出生','夏娃又生了亚伯，他后来成为牧羊人。','该隐与亚伯分别务农与牧羊。','为献祭冲突的场景做铺垫。'),
('birth-of-abel','en','Birth of Abel','Eve bears Abel, who becomes a keeper of flocks.','Cain tills the ground while Abel keeps sheep.','Sets up the scene of the rival offerings.'),
('cain-and-abel-bring-offerings','zh-CN','该隐与亚伯献祭','该隐献地里的出产，亚伯献羊群中头生的。','神悦纳亚伯的供物，却不悦纳该隐的。','引发该隐的忿怒与脸色变化。'),
('cain-and-abel-bring-offerings','en','Cain and Abel bring offerings','Cain offers the fruit of the ground; Abel offers the firstborn of his flock.','God has regard for Abel’s offering but not for Cain’s.','Triggers Cain’s anger and downcast face.'),
('cain-murders-abel','zh-CN','该隐杀害亚伯','该隐在田间起来击杀了兄弟亚伯。','神质问该隐“你兄弟亚伯在哪里”。','圣经记载的第一桩杀人事件。'),
('cain-murders-abel','en','Cain murders Abel','Cain rises against his brother Abel in the field and kills him.','God questions Cain, “Where is Abel your brother?”','The first recorded killing in the Bible.'),
('cain-marked-and-exiled','zh-CN','该隐受印记并被放逐','该隐被咒诅离开土地，神却给他留下印记。','印记为要保护他不被人擅自杀害。','该隐迁往挪得之地定居。'),
('cain-marked-and-exiled','en','Cain marked and exiled','Cain is cursed from the ground, but God places a protective mark on him.','The mark ensures no one who finds him will kill him.','Cain settles in the land of Nod.'),
('birth-of-seth','zh-CN','塞特出生','亚当夏娃在亚伯死后又生一子，取名塞特。','夏娃称神另立了一个后裔代替亚伯。','塞特成为通向挪亚谱系的起点。'),
('birth-of-seth','en','Birth of Seth','Adam and Eve have another son after Abel’s death, naming him Seth.','Eve says God has appointed another offspring in place of Abel.','Seth becomes the starting point of the line leading to Noah.'),
('genealogy-from-seth-to-noah','zh-CN','塞特到挪亚的谱系','创世记五章记载从塞特到挪亚的世系名单。','谱系以“生了……就死了”的公式反复出现。','为洪水叙事提供家族背景。'),
('genealogy-from-seth-to-noah','en','Genealogy from Seth to Noah','Genesis 5 records the line of descent from Seth down to Noah.','The genealogy repeats a formula of birth and death across generations.','Provides the family background for the flood narrative.'),
('birth-of-enoch','zh-CN','以诺出生','雅列生以诺，塞特谱系继续延续。','以诺后来因“与神同行”而在谱系中显得特别。','为“被神取去”的叙述作铺垫。'),
('birth-of-enoch','en','Birth of Enoch','Jared fathers Enoch, continuing the line of Seth.','Enoch later stands out in the genealogy for “walking with God.”','Sets up the account of his being taken by God.'),
('enoch-walks-with-god-and-is-taken','zh-CN','以诺与神同行并被接去','以诺与神同行三百年，神将他取去，他就不在世了。','谱系记载中打破了“……就死了”的固定格式。','传统上被视为免于死亡的特例。'),
('enoch-walks-with-god-and-is-taken','en','Enoch walks with God and is taken','Enoch walks with God for three hundred years, and God takes him so he is no more.','The genealogy breaks its usual formula of death here.','Traditionally read as an exception to ordinary death.'),
('birth-of-lamech-father-of-noah','zh-CN','拉麦（挪亚之父）出生','玛土撒拉生拉麦，谱系逼近挪亚一代。','拉麦后来为儿子取名挪亚，寄望得安慰。','衔接到洪水叙事的直接先祖。'),
('birth-of-lamech-father-of-noah','en','Birth of Lamech, father of Noah','Methuselah fathers Lamech, bringing the genealogy close to Noah’s generation.','Lamech later names his son Noah, hoping for comfort.','Links directly to the flood narrative’s protagonist.'),
('sons-of-god-and-daughters-of-men','zh-CN','神的儿子们与人的女子结合','创世记六章记载“神的儿子们”娶“人的女子”为妻。','这段简短记载历来有多种解释。','为世上罪恶加增的背景之一。'),
('sons-of-god-and-daughters-of-men','en','The sons of God and daughters of men','Genesis 6 briefly records “the sons of God” taking “the daughters of men” as wives.','This terse account has invited a range of interpretations.','Part of the backdrop for the earth’s growing corruption.'),
('nephilim-on-the-earth','zh-CN','地上有伟人（尼腓利姆）','经文提到那时候地上有伟人，是上古英武有名的人。','这一简短记述常与洪水前的败坏联系在一起。','强化了神决定审判的叙事张力。'),
('nephilim-on-the-earth','en','The Nephilim on the earth','The text notes there were “mighty men of old, men of renown” on the earth in those days.','This brief notice is often linked to the corruption before the flood.','Heightens the narrative tension leading to judgment.'),
('god-resolves-to-send-flood','zh-CN','神决定降洪水审判','神见人在地上罪恶很大，后悔造人，定意用洪水除灭。','叙事将审判的原因归结为地上强暴的充满。','为方舟叙事提供神学动机。'),
('god-resolves-to-send-flood','en','God resolves to send the flood','Seeing humanity’s great wickedness, God is grieved and resolves to blot out life with a flood.','The narrative attributes the judgment to the earth being filled with violence.','Provides the theological motive for the ark narrative.'),
('noah-found-righteous','zh-CN','挪亚在当代人中为义','经文记载挪亚是个义人，在当时的世代是个完全人。','唯独挪亚一家在神眼前蒙恩。','使挪亚成为洪水叙事中蒙拣选的一家之主。'),
('noah-found-righteous','en','Noah found righteous','The text records Noah as a righteous man, blameless among the people of his time.','Only Noah’s household finds favor in God’s sight.','Establishes Noah as the chosen head of household in the flood narrative.'),
('god-commands-noah-to-build-ark','zh-CN','神吩咐挪亚造方舟','神指示挪亚用歌斐木造方舟，并给出具体的尺寸。','方舟被设计为容纳挪亚一家与各类活物。','开启洪水前的准备叙事。'),
('god-commands-noah-to-build-ark','en','God commands Noah to build an ark','God instructs Noah to build an ark of gopher wood, giving specific dimensions.','The ark is designed to hold Noah’s household and representatives of every kind of creature.','Opens the preparation narrative before the flood.'),
('construction-of-the-ark','zh-CN','方舟的建造','挪亚遵照神所吩咐的一切去行，建成方舟。','叙事强调挪亚完全依从指示，不多不少。','儿子闪、含、雅弗协助其中。'),
('construction-of-the-ark','en','Construction of the ark','Noah does all that God commands him, and the ark is completed.','The narrative stresses Noah’s exact obedience to the instructions.','His sons Shem, Ham, and Japheth assist in the work.'),
('gathering-of-the-animals-into-ark','zh-CN','各类动物聚集入方舟','洁净与不洁净的活物各按种类进入方舟。','经文描述神使动物自行前来，如同预先安排。','为洪水后重新繁衍作准备。'),
('gathering-of-the-animals-into-ark','en','Gathering of the animals into the ark','Clean and unclean creatures come into the ark, each according to its kind.','The text describes the animals arriving as if by divine arrangement.','Prepares for repopulation after the flood.'),
('noah-and-family-enter-the-ark','zh-CN','挪亚一家进入方舟','挪亚与妻子、三个儿子及儿媳一同进入方舟。','耶和华随后将他们关在方舟里。','标志洪水降临前的最后准备完成。'),
('noah-and-family-enter-the-ark','en','Noah’s family enters the ark','Noah, his wife, his three sons, and their wives enter the ark together.','The Lord then shuts them in.','Marks the completion of preparations before the flood begins.'),
('forty-days-of-rain-begins','zh-CN','大雨四十昼夜降下','大渊的泉源都裂开，天上的窗户也敞开。','雨在地上下了四十昼夜。','洪水叙事进入高潮的开端。'),
('forty-days-of-rain-begins','en','Forty days of rain begins','The fountains of the great deep burst forth and the windows of heaven are opened.','Rain falls upon the earth for forty days and forty nights.','The beginning of the flood narrative’s climax.'),
('flood-waters-cover-the-earth','zh-CN','洪水淹没全地','水势浩大，淹没了地上一切的高山。','经文描述凡有气息的生物都灭亡了，只留挪亚一家。','强调审判的彻底性。'),
('flood-waters-cover-the-earth','en','Flood waters cover the earth','The waters prevail greatly, covering even the highest mountains.','The text states every living thing with breath perishes, except Noah’s household.','Emphasizes the totality of the judgment.'),
('waters-recede-from-earth','zh-CN','洪水开始消退','神使风吹地，水势渐落，泉源和天窗也止住了。','水从地上渐渐消退。','为方舟停靠作铺垫。'),
('waters-recede-from-earth','en','The waters recede','God makes a wind blow over the earth, and the waters gradually subside as the springs and windows close.','The waters continue to recede from the earth.','Sets up the ark’s eventual landing.'),
('noah-sends-out-raven','zh-CN','挪亚放出乌鸦','挪亚打开方舟的窗户，放出一只乌鸦。','乌鸦飞来飞去，直到地上的水都干了。','挪亚借此测试地面干燥的情况。'),
('noah-sends-out-raven','en','Noah sends out a raven','Noah opens a window of the ark and releases a raven.','It flies back and forth until the waters dry up from the earth.','Noah uses this to test whether the ground has dried.'),
('noah-sends-out-dove-with-olive-leaf','zh-CN','鸽子衔回橄榄叶','挪亚放出鸽子，鸽子叼着新拧下来的橄榄叶回来。','这是水势渐落、地面复苏的明确记号。','橄榄叶后来成为和平与新生的象征。'),
('noah-sends-out-dove-with-olive-leaf','en','The dove returns with an olive leaf','Noah releases a dove, which returns with a freshly plucked olive leaf.','This becomes the clear sign that the waters are subsiding and the earth is reviving.','The olive leaf later becomes a symbol of peace and renewal.'),
('earth-dries-and-covering-removed','zh-CN','地面全干，挪亚撤去方舟的盖','挪亚撤去方舟的盖观看，见地面都干了。','神吩咐他们可以出方舟了。','标志洪水叙事的结束阶段。'),
('earth-dries-and-covering-removed','en','The earth dries and the covering is removed','Noah removes the covering of the ark and sees that the ground is dry.','God then instructs the household that they may leave the ark.','Marks the closing stage of the flood narrative.'),
('noah-and-family-leave-the-ark','zh-CN','挪亚一家出方舟','挪亚一家与所有的活物按种类出了方舟。','经文记载他们各从其类，一同离开方舟踏上干地。','为洪水后的新起点铺陈场景。'),
('noah-and-family-leave-the-ark','en','Noah’s family leaves the ark','Noah’s household and every creature, each according to its kind, come out of the ark.','The text records them departing together onto dry land.','Sets the scene for a new beginning after the flood.'),
('noah-builds-altar-and-offers-sacrifice','zh-CN','挪亚筑坛献祭','挪亚为耶和华筑了一座坛，献上燔祭。','耶和华闻其馨香之气，心里说不再因人的缘故咒诅地。','为随后的洪水后之约作铺垫。'),
('noah-builds-altar-and-offers-sacrifice','en','Noah builds an altar and offers sacrifice','Noah builds an altar to the Lord and offers burnt offerings.','The Lord smells the pleasing aroma and resolves never again to curse the ground because of humanity.','Sets up the subsequent post-flood covenant.'),
('noah-plants-vineyard','zh-CN','挪亚栽种葡萄园','挪亚作起农夫来，栽了一个葡萄园。','这是洪水后重新耕作生活的开始。','为后续醉酒事件埋下伏笔。'),
('noah-plants-vineyard','en','Noah plants a vineyard','Noah becomes a farmer and plants a vineyard.','This marks the resumption of settled agricultural life after the flood.','Sets up the account of his drunkenness that follows.'),
('noah-drunk-and-uncovered','zh-CN','挪亚醉酒赤身','挪亚喝了园中的酒便醉了，在帐棚里赤着身子。','这一场景引出儿子们不同的反应。','为随后的咒诅与祝福提供背景。'),
('noah-drunk-and-uncovered','en','Noah becomes drunk and uncovered','Noah drinks wine from his vineyard, becomes drunk, and lies uncovered in his tent.','The scene sets up the differing responses of his sons.','Provides the background for the curse and blessing that follow.'),
('ham-sees-fathers-nakedness','zh-CN','含窥见父亲赤身','含看见父亲赤身，出去告诉了两个兄弟。','闪与雅弗则倒退着进去，为父亲盖上衣服。','两种反应之间的对比成为叙事的核心。'),
('ham-sees-fathers-nakedness','en','Ham sees his father’s nakedness','Ham sees his father’s nakedness and tells his two brothers outside.','Shem and Japheth instead walk in backward and cover their father.','The contrast between the two responses becomes the narrative’s core.'),
('noahs-curse-and-blessing-of-sons','zh-CN','挪亚咒诅与祝福儿子们','挪亚醒来后咒诅含之子迦南，祝福闪与雅弗。','这段宣告后来被援引来解释诸民族间的关系。','为民族列表的叙事提供神学框架。'),
('noahs-curse-and-blessing-of-sons','en','Noah curses and blesses his sons','Noah wakes and curses Canaan, Ham’s son, while blessing Shem and Japheth.','This pronouncement is later invoked to explain relations among peoples.','Provides a theological frame for the table of nations that follows.'),
('genealogy-of-japheth','zh-CN','雅弗的后裔','创世记十章列出雅弗的后裔，与沿海地区的民族相联系。','谱系简短，列出多个地域性族群的名字。','说明诸海岛邦国的起源。'),
('genealogy-of-japheth','en','The descendants of Japheth','Genesis 10 lists Japheth’s descendants, associated with the coastland peoples.','The genealogy is brief, naming several regional groups.','Accounts for the origin of the coastland nations.'),
('genealogy-of-ham','zh-CN','含的后裔','含的后裔谱系中包括古实、麦西、迦南等支系。','宁录作为古实之子在此谱系中被特别提及。','为宁录建立城邦的叙事提供家系背景。'),
('genealogy-of-ham','en','The descendants of Ham','Ham’s genealogy includes the lines of Cush, Egypt, and Canaan.','Nimrod, a son of Cush, is singled out within this genealogy.','Provides the lineage background for Nimrod’s city-building narrative.'),
('genealogy-of-shem','zh-CN','闪的后裔','闪的后裔谱系延伸到亚伯拉罕的先祖法勒等人。','谱系将闪族一脉与后续的族长叙事连接起来。','为亚伯拉罕故事的开启作铺垫。'),
('genealogy-of-shem','en','The descendants of Shem','Shem’s genealogy extends to Peleg and other forebears of Abraham.','The genealogy links the Semitic line to the patriarchal narratives that follow.','Sets up the eventual introduction of Abraham.'),
('table-of-nations-summary','zh-CN','列国志总述','创世记十章总结挪亚三子的后裔如何分为列邦。','经文称“这些国民是从挪亚的儿子们分开的”。','为巴别塔叙事之后的民族分散提供整体框架。'),
('table-of-nations-summary','en','Summary of the table of nations','Genesis 10 summarizes how the descendants of Noah’s three sons divided into nations.','The text states these nations “were separated” from Noah’s sons.','Provides the overall frame preceding the Babel dispersal narrative.'),
('nimrod-rises-as-mighty-hunter','zh-CN','宁录成为地上英雄','古实生宁录，他为世上英雄之首，在耶和华面前是个英勇的猎户。','这句谚语式的描述被反复引用。','为其后建立城邦的记载作铺垫。'),
('nimrod-rises-as-mighty-hunter','en','Nimrod rises as a mighty hunter','Cush fathers Nimrod, who becomes the first mighty one on earth, a mighty hunter before the Lord.','This proverbial description is repeatedly quoted afterward.','Sets up the account of his city-founding that follows.'),
('nimrod-founds-cities-in-shinar','zh-CN','宁录在示拿建立城邦','他国的起头是巴别、以力、亚甲，都在示拿地。','经文随后提及他向亚述扩展，建立尼尼微等城。','使宁录成为古代近东王权叙事中的象征人物。'),
('nimrod-founds-cities-in-shinar','en','Nimrod founds cities in Shinar','The beginning of his kingdom is Babel, Erech, and Akkad, all in the land of Shinar.','The text goes on to note his expansion toward Assyria, founding Nineveh and other cities.','Makes Nimrod a symbolic figure of ancient Near Eastern kingship.'),
('humanity-speaks-one-language-and-settles-in-shinar','zh-CN','人类同一语言迁至示拿平原','那时天下人的口音、言语都是一样，众人往东边迁移，在示拿地找到一片平原居住。','为随后建造高塔的计划提供地理与语言背景。','强调人类合一却也埋下悖逆的伏笔。'),
('humanity-speaks-one-language-and-settles-in-shinar','en','Humanity speaks one language and settles in Shinar','With the whole earth sharing one language, the people migrate eastward and settle on a plain in the land of Shinar.','This provides the geographic and linguistic setting for the tower-building plan that follows.','Highlights human unity while foreshadowing the coming defiance.'),
('building-of-tower-of-babel','zh-CN','建造巴别塔','众人商议用砖当石头，用石漆当灰泥，建造一座城和塔，塔顶通天，为要传扬自己的名。','工程意在防止民众分散在全地面上。','成为随后神变乱语言、分散人群这一情节的直接起因。'),
('building-of-tower-of-babel','en','Building the tower of Babel','The people resolve to make bricks and build a city and a tower with its top in the heavens, to make a name for themselves.','The project is undertaken so that they will not be scattered over the whole earth.','Becomes the direct cause of God confusing their language and scattering them, in the episode that follows.')
) AS v(slug,locale,title,summary,detail,sig) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS (reuse eden-reference, land-of-nod-reference,
--    ararat-mountains, babylon)
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('creation-of-heavens-and-earth','eden-reference'),
('creation-of-humankind','eden-reference'),
('sabbath-rest-of-creation','eden-reference'),
('adam-placed-in-garden-of-eden','eden-reference'),
('naming-of-the-animals','eden-reference'),
('creation-of-eve-from-adams-rib','eden-reference'),
('serpent-tempts-eve','eden-reference'),
('adam-and-eve-eat-forbidden-fruit','eden-reference'),
('expulsion-from-eden','eden-reference'),
('birth-of-cain','eden-reference'),
('birth-of-abel','eden-reference'),
('cain-and-abel-bring-offerings','eden-reference'),
('cain-murders-abel','eden-reference'),
('cain-marked-and-exiled','land-of-nod-reference'),
('birth-of-seth','eden-reference'),
('genealogy-from-seth-to-noah','eden-reference'),
('birth-of-enoch','eden-reference'),
('enoch-walks-with-god-and-is-taken','eden-reference'),
('birth-of-lamech-father-of-noah','eden-reference'),
('sons-of-god-and-daughters-of-men','eden-reference'),
('nephilim-on-the-earth','eden-reference'),
('god-resolves-to-send-flood','eden-reference'),
('noah-found-righteous','eden-reference'),
('god-commands-noah-to-build-ark','eden-reference'),
('construction-of-the-ark','eden-reference'),
('gathering-of-the-animals-into-ark','eden-reference'),
('noah-and-family-enter-the-ark','eden-reference'),
('forty-days-of-rain-begins','eden-reference'),
('flood-waters-cover-the-earth','eden-reference'),
('waters-recede-from-earth','ararat-mountains'),
('noah-sends-out-raven','ararat-mountains'),
('noah-sends-out-dove-with-olive-leaf','ararat-mountains'),
('earth-dries-and-covering-removed','ararat-mountains'),
('noah-and-family-leave-the-ark','ararat-mountains'),
('noah-builds-altar-and-offers-sacrifice','ararat-mountains'),
('noah-plants-vineyard','ararat-mountains'),
('noah-drunk-and-uncovered','ararat-mountains'),
('ham-sees-fathers-nakedness','ararat-mountains'),
('noahs-curse-and-blessing-of-sons','ararat-mountains'),
('genealogy-of-japheth','ararat-mountains'),
('genealogy-of-ham','ararat-mountains'),
('genealogy-of-shem','ararat-mountains'),
('table-of-nations-summary','ararat-mountains'),
('nimrod-rises-as-mighty-hunter','babylon'),
('nimrod-founds-cities-in-shinar','babylon'),
('humanity-speaks-one-language-and-settles-in-shinar','babylon'),
('building-of-tower-of-babel','babylon')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('creation-of-heavens-and-earth','adam',0),
('creation-of-humankind','adam',0),('creation-of-humankind','eve',1),
('sabbath-rest-of-creation','adam',0),
('adam-placed-in-garden-of-eden','adam',0),
('naming-of-the-animals','adam',0),
('creation-of-eve-from-adams-rib','eve',0),('creation-of-eve-from-adams-rib','adam',1),
('serpent-tempts-eve','eve',0),
('adam-and-eve-eat-forbidden-fruit','adam',0),('adam-and-eve-eat-forbidden-fruit','eve',1),
('expulsion-from-eden','adam',0),('expulsion-from-eden','eve',1),
('birth-of-cain','cain',0),('birth-of-cain','eve',1),('birth-of-cain','adam',2),
('birth-of-abel','abel',0),('birth-of-abel','eve',1),
('cain-and-abel-bring-offerings','cain',0),('cain-and-abel-bring-offerings','abel',1),
('cain-murders-abel','cain',0),('cain-murders-abel','abel',1),
('cain-marked-and-exiled','cain',0),
('birth-of-seth','seth',0),('birth-of-seth','eve',1),('birth-of-seth','adam',2),
('genealogy-from-seth-to-noah','seth',0),('genealogy-from-seth-to-noah','enoch',1),('genealogy-from-seth-to-noah','methuselah',2),('genealogy-from-seth-to-noah','lamech-father-of-noah',3),
('birth-of-enoch','enoch',0),
('enoch-walks-with-god-and-is-taken','enoch',0),
('birth-of-lamech-father-of-noah','lamech-father-of-noah',0),('birth-of-lamech-father-of-noah','methuselah',1),
('sons-of-god-and-daughters-of-men','lamech-father-of-noah',0),
('nephilim-on-the-earth','lamech-father-of-noah',0),
('god-resolves-to-send-flood','noah',0),
('noah-found-righteous','noah',0),
('god-commands-noah-to-build-ark','noah',0),
('construction-of-the-ark','noah',0),('construction-of-the-ark','shem',1),('construction-of-the-ark','ham',2),('construction-of-the-ark','japheth',3),
('gathering-of-the-animals-into-ark','noah',0),
('noah-and-family-enter-the-ark','noah',0),('noah-and-family-enter-the-ark','shem',1),('noah-and-family-enter-the-ark','ham',2),('noah-and-family-enter-the-ark','japheth',3),
('forty-days-of-rain-begins','noah',0),
('flood-waters-cover-the-earth','noah',0),
('waters-recede-from-earth','noah',0),
('noah-sends-out-raven','noah',0),
('noah-sends-out-dove-with-olive-leaf','noah',0),
('earth-dries-and-covering-removed','noah',0),
('noah-and-family-leave-the-ark','noah',0),('noah-and-family-leave-the-ark','shem',1),('noah-and-family-leave-the-ark','ham',2),('noah-and-family-leave-the-ark','japheth',3),
('noah-builds-altar-and-offers-sacrifice','noah',0),
('noah-plants-vineyard','noah',0),
('noah-drunk-and-uncovered','noah',0),
('ham-sees-fathers-nakedness','ham',0),('ham-sees-fathers-nakedness','noah',1),
('noahs-curse-and-blessing-of-sons','noah',0),('noahs-curse-and-blessing-of-sons','ham',1),('noahs-curse-and-blessing-of-sons','shem',2),('noahs-curse-and-blessing-of-sons','japheth',3),
('genealogy-of-japheth','japheth',0),
('genealogy-of-ham','ham',0),
('genealogy-of-shem','shem',0),
('table-of-nations-summary','shem',0),('table-of-nations-summary','ham',1),('table-of-nations-summary','japheth',2),('table-of-nations-summary','noah',3),
('nimrod-rises-as-mighty-hunter','nimrod',0),('nimrod-rises-as-mighty-hunter','ham',1),
('nimrod-founds-cities-in-shinar','nimrod',0),
('humanity-speaks-one-language-and-settles-in-shinar','nimrod',0),
('building-of-tower-of-babel','nimrod',0)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES (all new events map to Genesis)
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Genesis'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.id::text LIKE '63000000-0000-4000-8001%'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS
-- -------------------------------------------------------------------------
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('73000000-0000-4000-8001-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'adam','eve','spouse','bidirectional','positive',4,'ended','creation-of-eve-from-adams-rib',NULL),
(2,'adam','cain','family','source_to_target','positive',3,'unknown','birth-of-cain',NULL),
(3,'eve','cain','family','source_to_target','positive',3,'unknown','birth-of-cain',NULL),
(4,'adam','abel','family','source_to_target','positive',3,'ended','birth-of-abel','cain-murders-abel'),
(5,'eve','abel','family','source_to_target','positive',3,'ended','birth-of-abel','cain-murders-abel'),
(6,'cain','abel','sibling','bidirectional','negative',4,'ended',NULL,'cain-murders-abel'),
(7,'adam','seth','family','source_to_target','positive',3,'unknown','birth-of-seth',NULL),
(8,'eve','seth','family','source_to_target','positive',3,'unknown','birth-of-seth',NULL),
(9,'seth','enoch','family','source_to_target','positive',2,'unknown',NULL,NULL),
(10,'enoch','methuselah','family','source_to_target','positive',2,'unknown','birth-of-enoch',NULL),
(11,'methuselah','lamech-father-of-noah','family','source_to_target','positive',2,'unknown','birth-of-lamech-father-of-noah',NULL),
(12,'lamech-father-of-noah','noah','family','source_to_target','positive',3,'unknown',NULL,NULL),
(13,'noah','shem','family','source_to_target','positive',3,'unknown',NULL,NULL),
(14,'noah','ham','family','source_to_target','mixed',3,'changed',NULL,'noahs-curse-and-blessing-of-sons'),
(15,'noah','japheth','family','source_to_target','positive',3,'unknown',NULL,NULL),
(16,'shem','ham','sibling','bidirectional','neutral',2,'unknown',NULL,NULL),
(17,'ham','japheth','sibling','bidirectional','neutral',2,'unknown',NULL,NULL),
(18,'nimrod','ham','family','source_to_target','neutral',2,'unknown',NULL,NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000005'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 10. GROUP MEMBERSHIP (existing group primeval-figures)
-- -------------------------------------------------------------------------
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g JOIN (VALUES
('primeval-figures','adam'),('primeval-figures','eve'),('primeval-figures','cain'),('primeval-figures','abel'),
('primeval-figures','seth'),('primeval-figures','enoch'),('primeval-figures','methuselah'),
('primeval-figures','lamech-father-of-noah'),('primeval-figures','shem'),('primeval-figures','ham'),
('primeval-figures','japheth'),('primeval-figures','nimrod')
) AS v(gslug,cslug)
ON g.slug=v.gslug JOIN characters c ON c.slug=v.cslug AND c.work_id=g.work_id
WHERE g.work_id='10000000-0000-4000-8000-000000000005' ON CONFLICT DO NOTHING;

COMMIT;
