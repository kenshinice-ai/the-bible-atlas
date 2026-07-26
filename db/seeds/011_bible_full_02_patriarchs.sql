BEGIN;

-- =========================================================================
-- 011_bible_full_02_patriarchs.sql
-- Chapter K=02 slug='patriarchs' (Genesis 11:27-50:26, the patriarchal era)
-- Adds 10 characters, 1 location, 21 new events, relations, and reorders
-- the 19 pre-existing patriarch events into the 2001-2999 sequence band.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('43000000-0000-4000-8002-000000000001','10000000-0000-4000-8000-000000000005','terah',220,'male','elder','supporting','unknown',NULL,NULL,'patriarch',2),
('43000000-0000-4000-8002-000000000002','10000000-0000-4000-8000-000000000005','melchizedek',221,'male','adult','supporting','unknown',NULL,NULL,'priest',2),
('43000000-0000-4000-8002-000000000003','10000000-0000-4000-8000-000000000005','laban',222,'male','adult','supporting','unknown',NULL,NULL,'person',3),
('43000000-0000-4000-8002-000000000004','10000000-0000-4000-8000-000000000005','bilhah',223,'female','adult','supporting','unknown',NULL,NULL,'person',1),
('43000000-0000-4000-8002-000000000005','10000000-0000-4000-8000-000000000005','zilpah',224,'female','adult','supporting','unknown',NULL,NULL,'person',1),
('43000000-0000-4000-8002-000000000006','10000000-0000-4000-8000-000000000005','dinah',225,'female','youth','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8002-000000000007','10000000-0000-4000-8000-000000000005','reuben',226,'male','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8002-000000000008','10000000-0000-4000-8000-000000000005','potiphar',227,'male','adult','supporting','unknown',NULL,NULL,'soldier',2),
('43000000-0000-4000-8002-000000000009','10000000-0000-4000-8000-000000000005','potiphars-wife',228,'female','adult','antagonist','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8002-000000000010','10000000-0000-4000-8000-000000000005','pharaoh-of-joseph',229,'male','adult','supporting','unknown',NULL,NULL,'king',2)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('terah','zh-CN','他拉','亚伯兰的父亲，带领全家离开迦勒底的吾珥，定居哈兰。',ARRAY[]::text[],'他拉生亚伯兰、拿鹤、哈兰，带着亚伯兰、撒莱与孙子罗得离开吾珥，原要往迦南地去，却在哈兰住下，二百零五岁时死在那里。','带领家族迁往新的居住之地。'),
('terah','en','Terah','Abram’s father, who led the family out of Ur of the Chaldeans and settled in Harran.',ARRAY[]::text[],'Terah fathers Abram, Nahor, and Haran; he sets out from Ur with Abram, Sarai, and his grandson Lot, intending to reach Canaan, but settles in Harran and dies there at 205.','To lead his household to a new dwelling place.'),
('melchizedek','zh-CN','麦基洗德','撒冷王，至高神的祭司，以饼和酒迎接亚伯兰并为他祝福。',ARRAY[]::text[],'亚伯兰击败诸王、救回罗得之后，麦基洗德带着饼和酒出来迎接，以至高神祭司的身份为他祝福；亚伯兰将所得的十分之一给了他。','以祭司的身份祝福得胜归来的亚伯兰。'),
('melchizedek','en','Melchizedek','King of Salem and priest of God Most High, who met Abram with bread and wine and blessed him.',ARRAY[]::text[],'After Abram’s victory over the kings and the rescue of Lot, Melchizedek comes out with bread and wine and blesses him as priest of God Most High; Abram gives him a tenth of everything.','To bless the returning victor as priest of God Most High.'),
('laban','zh-CN','拉班','利百加的兄长，利亚与拉结的父亲，雅各在哈兰的舅父与雇主。',ARRAY[]::text[],'雅各投奔哈兰的拉班，为娶拉结服事他多年；拉班在婚宴上以利亚顶替拉结，又屡次更改雅各的工价，最终在基列山与雅各堆石立约分手。','借雅各的劳力谋取自家产业的兴旺。'),
('laban','en','Laban','Rebekah’s brother and the father of Leah and Rachel, Jacob’s uncle and employer in Harran.',ARRAY[]::text[],'Jacob takes refuge with Laban in Harran and serves years for Rachel; Laban substitutes Leah at the wedding and repeatedly changes Jacob’s wages, until the two part with a covenant of stones in the hills of Gilead.','To turn Jacob’s labor to the growth of his own household.'),
('bilhah','zh-CN','辟拉','拉结的使女，雅各之妾，但与拿弗他利的母亲。',ARRAY[]::text[],'拉结不生育，将使女辟拉给雅各为妾；辟拉生下但与拿弗他利，归在拉结名下。','（叙事中未明言，处于使女的从属地位。）'),
('bilhah','en','Bilhah','Rachel’s maidservant, given to Jacob, mother of Dan and Naphtali.',ARRAY[]::text[],'Unable to bear children, Rachel gives her maid Bilhah to Jacob; Bilhah bears Dan and Naphtali, counted to Rachel.','Unstated in the text; she acts within her role as a maidservant.'),
('zilpah','zh-CN','悉帕','利亚的使女，雅各之妾，迦得与亚设的母亲。',ARRAY[]::text[],'利亚停了生育，将使女悉帕给雅各为妾；悉帕生下迦得与亚设，归在利亚名下。','（叙事中未明言，处于使女的从属地位。）'),
('zilpah','en','Zilpah','Leah’s maidservant, given to Jacob, mother of Gad and Asher.',ARRAY[]::text[],'When Leah stops bearing, she gives her maid Zilpah to Jacob; Zilpah bears Gad and Asher, counted to Leah.','Unstated in the text; she acts within her role as a maidservant.'),
('dinah','zh-CN','底拿','雅各与利亚的女儿，示剑事件的中心人物。',ARRAY[]::text[],'底拿出去探望那地的女子，被示剑城主之子玷辱；她的兄长西缅与利未借割礼之约设计，杀了示剑城中所有的男丁。','（叙事以她的遭遇为中心，未记述她自己的言语。）'),
('dinah','en','Dinah','Daughter of Jacob and Leah, at the center of the Shechem episode.',ARRAY[]::text[],'Dinah goes out to visit the women of the land and is violated by the son of Shechem’s ruler; her brothers Simeon and Levi use the covenant of circumcision as a ruse and kill the men of the city.','The narrative centers on what befalls her and records no words of her own.'),
('reuben','zh-CN','吕便','雅各的长子，利亚所生，曾出手救约瑟免于被杀。',ARRAY[]::text[],'兄弟们谋害约瑟时，吕便提议把约瑟丢进坑里，想要救他回去；后因玷污父亲的妾室辟拉，在雅各临终的祝福中失去长子的名分。','保全兄弟，却难挽回自己失去的名分。'),
('reuben','en','Reuben','Jacob’s firstborn by Leah, who tried to save Joseph from his brothers.',ARRAY[]::text[],'As the eldest, Reuben proposes casting Joseph into a pit, intending to rescue him; he later loses his firstborn preeminence in Jacob’s deathbed blessing for defiling his father’s concubine Bilhah.','To protect his brother, though he cannot recover his own standing.'),
('potiphar','zh-CN','波提乏','法老的内臣、护卫长，买下约瑟并把家务托付给他。',ARRAY[]::text[],'波提乏从以实玛利人手中买下约瑟，见他凡事顺利，便把家中一切交在他手里；后因妻子的指控把约瑟下在监里。','用可靠的管家治理自己的家业。'),
('potiphar','en','Potiphar','Pharaoh’s officer and captain of the guard, who bought Joseph and set him over his house.',ARRAY[]::text[],'Potiphar buys Joseph from the Ishmaelites and, seeing that all he does prospers, entrusts his household to him; on his wife’s accusation he puts Joseph in prison.','To run his estate through a trustworthy steward.'),
('potiphars-wife','zh-CN','波提乏之妻','波提乏的妻子，引诱约瑟不成便诬告他。',ARRAY[]::text[],'她天天引诱约瑟与她同寝，被拒后抓住他的外衣，反诬他戏弄自己，使约瑟被下在监里。','得不到的欲望转为报复。'),
('potiphars-wife','en','Potiphar’s wife','Potiphar’s wife, who tried to seduce Joseph and accused him falsely when refused.',ARRAY[]::text[],'Day after day she urges Joseph to lie with her; when he refuses and flees, she keeps his garment and accuses him of mocking her, and Joseph is imprisoned.','Desire refused turns to vengeance.'),
('pharaoh-of-joseph','zh-CN','法老（约瑟时代）','约瑟时代的埃及王，因约瑟解梦而立他治理全国。',ARRAY[]::text[],'这位法老梦见七只肥牛与七只瘦牛、七个饱满与七个枯瘦的穗子；约瑟解明为七年丰收与七年饥荒，法老便立他为宰相，治理埃及全地。','在预告的饥荒来临前保全国家。'),
('pharaoh-of-joseph','en','Pharaoh (of Joseph’s time)','The Egyptian king whose dreams Joseph interpreted, and who raised Joseph over Egypt.',ARRAY[]::text[],'This Pharaoh dreams of seven fat and seven lean cows, and of full and withered ears of grain; Joseph reads them as seven years of plenty followed by famine, and Pharaoh sets him over all the land of Egypt.','To secure his kingdom against the foretold famine.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. LOCATIONS (reuse ur, harran, hebron, beersheba, bethel, jerusalem,
--    canaan-shechem, sodom-region, peniel-jabbok, goshen, nile-delta;
--    only 1 new, inferred site)
-- -------------------------------------------------------------------------
INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('33000000-0000-4000-8002-000000000001','10000000-0000-4000-8000-000000000005','mizpah-of-gilead','real',ST_GeogFromText('POINT(35.7500 32.3000)'),NULL,NULL,230,'region','inferred',7,'JO',true,false)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,status,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',ARRAY[]::text[],'','','','',v.region FROM locations l JOIN (VALUES
('mizpah-of-gilead','zh-CN','基列米斯巴（推定位置）','雅各与拉班堆石立约、彼此分手之处，位于约旦河东的基列山地。','基列'),
('mizpah-of-gilead','en','Mizpah of Gilead (traditional site)','The hill country of Gilead east of the Jordan where Jacob and Laban parted with a covenant, raising a heap of stones as witness.','Gilead')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug AND l.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 3. EVENTS (new) -- range dating within c. 2100-1700 BCE, chapter 'patriarchs'
-- -------------------------------------------------------------------------
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('63000000-0000-4000-8002-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'unknown'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'terah-settles-and-dies-in-harran',2003,'reported_historical','migration','range',-2100::integer,-1950::integer,'low','patriarchs'),
(2,'call-of-abram-at-harran',2005,'legendary_or_mythic','religious','range',-2090,-1940,'low','patriarchs'),
(3,'melchizedek-blesses-abram',2011,'reported_historical','meeting','range',-2080,-1930,'low','patriarchs'),
(4,'covenant-between-the-pieces',2013,'legendary_or_mythic','religious','range',-2080,-1930,'low','patriarchs'),
(5,'birth-of-ishmael',2015,'reported_historical','birth','range',-2070,-1920,'low','patriarchs'),
(6,'covenant-of-circumcision',2017,'legendary_or_mythic','religious','range',-2060,-1910,'low','patriarchs'),
(7,'visitors-at-mamre',2019,'legendary_or_mythic','meeting','range',-2060,-1910,'low','patriarchs'),
(8,'lot-flees-to-zoar',2021,'legendary_or_mythic','escape','range',-2050,-1900,'low','patriarchs'),
(9,'covenant-at-beersheba',2029,'reported_historical','political','range',-2050,-1900,'low','patriarchs'),
(10,'birth-of-jacob-and-esau',2037,'reported_historical','birth','range',-2000,-1850,'low','patriarchs'),
(11,'esau-sells-his-birthright',2039,'reported_historical','social','range',-1990,-1840,'low','patriarchs'),
(12,'sons-born-to-jacob-in-harran',2047,'reported_historical','birth','range',-1950,-1800,'low','patriarchs'),
(13,'jacob-flees-and-covenant-with-laban',2049,'reported_historical','escape','range',-1940,-1790,'low','patriarchs'),
(14,'dinah-at-shechem',2055,'reported_historical','betrayal','range',-1930,-1780,'low','patriarchs'),
(15,'josephs-dreams-and-the-coat',2059,'reported_historical','social','range',-1920,-1770,'low','patriarchs'),
(16,'joseph-in-potiphars-house',2063,'reported_historical','imprisonment','range',-1910,-1760,'low','patriarchs'),
(17,'joseph-interprets-dreams-in-prison',2065,'reported_historical','discovery','range',-1900,-1750,'low','patriarchs'),
(18,'jacob-goes-down-to-egypt',2071,'reported_historical','journey','range',-1880,-1730,'low','patriarchs'),
(19,'jacob-blesses-his-sons',2075,'reported_historical','religious','range',-1870,-1720,'low','patriarchs'),
(20,'jacob-buried-at-machpelah',2077,'reported_historical','death','range',-1870,-1720,'low','patriarchs'),
(21,'death-of-joseph',2079,'reported_historical','death','range',-1860,-1710,'low','patriarchs')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,conf,chapter_slug)
JOIN chapters ch ON ch.slug=v.chapter_slug AND ch.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 4. Reorder existing patriarch events into the 2001-2999 band
-- -------------------------------------------------------------------------
UPDATE events e SET sequence=v.seq FROM (VALUES
  ('abraham-leaves-ur',2001),
  ('abram-at-shechem',2007),
  ('lot-settles-near-sodom',2009),
  ('destruction-of-the-sodom-cities',2023),
  ('birth-of-isaac',2025),
  ('hagar-and-ishmael-in-the-wilderness',2027),
  ('binding-of-isaac',2031),
  ('sarah-buried-at-hebron',2033),
  ('rebekah-brought-from-harran',2035),
  ('jacob-takes-the-blessing',2041),
  ('jacobs-dream-at-bethel',2043),
  ('jacob-marries-leah-and-rachel',2045),
  ('jacob-named-israel',2051),
  ('jacob-and-esau-reconcile',2053),
  ('rachel-buried-near-bethlehem',2057),
  ('joseph-sold-into-egypt',2061),
  ('joseph-rises-in-egypt',2067),
  ('brothers-reunite-in-egypt',2069),
  ('household-settles-in-goshen',2073)
) AS v(slug,seq) WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug=v.slug;

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tlabel FROM events e JOIN (VALUES
('terah-settles-and-dies-in-harran','zh-CN','他拉定居哈兰并去世','他拉带着全家离开吾珥要往迦南去，行到哈兰就住下，后死在那里。','他拉带着亚伯兰、撒莱和孙子罗得出吾珥，原意前往迦南地，却在哈兰定居；他拉共活了二百零五岁，死在哈兰。','为亚伯兰蒙召离开哈兰的叙事提供起点。','约公元前 2100–1950 年'),
('terah-settles-and-dies-in-harran','en','Terah settles and dies in Harran','Terah leads the family out of Ur toward Canaan, but settles in Harran and dies there.','Terah takes Abram, Sarai, and his grandson Lot out of Ur, intending Canaan, yet settles in Harran; he lives 205 years and dies there.','Provides the starting point for Abram’s call to leave Harran.','c. 2100–1950 BCE'),
('call-of-abram-at-harran','zh-CN','亚伯兰在哈兰蒙召','耶和华呼召亚伯兰离开本地、本族、父家，往他所要指示的地去。','呼召附带应许：成为大国、得福，并使地上的万族因他得福；亚伯兰七十五岁时带着撒莱与罗得离开哈兰。','族长叙事的开端，应许的主题由此展开。','约公元前 2090–1940 年'),
('call-of-abram-at-harran','en','The call of Abram at Harran','The Lord calls Abram to leave his land, his kin, and his father’s house for a land to be shown him.','The call carries promises: a great nation, blessing, and blessing for all families of the earth through him; at seventy-five Abram leaves Harran with Sarai and Lot.','The opening of the patriarchal narrative and its theme of promise.','c. 2090–1940 BCE'),
('melchizedek-blesses-abram','zh-CN','麦基洗德祝福亚伯兰','撒冷王麦基洗德带着饼和酒出来，为击败诸王归来的亚伯兰祝福。','亚伯兰救回罗得之后，麦基洗德以至高神祭司的身份祝福他；亚伯兰将所得的十分之一给了他。','撒冷传统上与耶路撒冷相联系，这一幕在后世经文中被反复引用。','约公元前 2080–1930 年'),
('melchizedek-blesses-abram','en','Melchizedek blesses Abram','Melchizedek, king of Salem, comes out with bread and wine to bless Abram returning from his victory over the kings.','After the rescue of Lot, Melchizedek blesses Abram as priest of God Most High, and Abram gives him a tenth of everything.','Salem is traditionally linked with Jerusalem, and the scene is repeatedly invoked in later scripture.','c. 2080–1930 BCE'),
('covenant-between-the-pieces','zh-CN','亚伯兰的立约异象','耶和华在异象中与亚伯兰立约，应许后裔多如天上的星，并赐迦南地为业。','亚伯兰剖开祭牲，日落之后有冒烟的炉与烧着的火把从肉块中经过；经文并预言其后裔将寄居异邦四百年。','应许之地与后裔的主题在此以立约的形式正式确认。','约公元前 2080–1930 年'),
('covenant-between-the-pieces','en','Abram’s covenant vision','In a vision the Lord makes a covenant with Abram, promising offspring like the stars and the land of Canaan.','Abram divides the sacrificial animals, and after sundown a smoking fire pot and flaming torch pass between the pieces; the text also foretells four hundred years of sojourn in a foreign land.','The themes of land and offspring are here formally sealed by covenant.','c. 2080–1930 BCE'),
('birth-of-ishmael','zh-CN','以实玛利出生','撒莱不生育，把使女夏甲给亚伯兰为妾，夏甲生下以实玛利。','夏甲怀孕后受苦逃往旷野，在水泉旁得应许而回；亚伯兰八十六岁时以实玛利出生。','为后来以撒出生与夏甲被逐的叙事埋下张力。','约公元前 2070–1920 年'),
('birth-of-ishmael','en','Birth of Ishmael','The childless Sarai gives her maid Hagar to Abram, and Hagar bears Ishmael.','Mistreated while pregnant, Hagar flees to a spring in the wilderness, receives a promise, and returns; Ishmael is born when Abram is eighty-six.','Plants the tension that later surfaces in Isaac’s birth and Hagar’s expulsion.','c. 2070–1920 BCE'),
('covenant-of-circumcision','zh-CN','割礼之约','神与亚伯兰立永约，改他的名为亚伯拉罕，以割礼为立约的记号。','撒莱改名撒拉，并得着生子的应许；亚伯拉罕当日就为家中所有的男丁行了割礼。','亚伯拉罕之名与立约的记号由此确立。','约公元前 2060–1910 年'),
('covenant-of-circumcision','en','The covenant of circumcision','God makes an everlasting covenant with Abram, renames him Abraham, and gives circumcision as its sign.','Sarai is renamed Sarah and promised a son; that very day Abraham circumcises every male of his household.','Establishes both the name Abraham and the sign of the covenant.','c. 2060–1910 BCE'),
('visitors-at-mamre','zh-CN','幔利的三位访客','三人在幔利橡树那里向亚伯拉罕显现，应许撒拉明年必生一子。','亚伯拉罕殷勤款待；帐棚里的撒拉暗笑，得到“耶和华岂有难成的事”的回答；访客随后面向所多玛而去，亚伯拉罕为城中的义人代求。','以撒出生的直接预告，也引出所多玛审判的叙事。','约公元前 2060–1910 年'),
('visitors-at-mamre','en','The visitors at Mamre','Three visitors appear to Abraham by the oaks of Mamre and promise Sarah a son within the year.','Abraham hurries to show hospitality; Sarah laughs within the tent and hears, “Is anything too hard for the Lord?”; the visitors then turn toward Sodom, and Abraham pleads for its righteous.','The direct announcement of Isaac’s birth, leading into the Sodom judgment narrative.','c. 2060–1910 BCE'),
('lot-flees-to-zoar','zh-CN','罗得逃往琐珥','两位使者催促罗得一家离开所多玛，罗得逃到小城琐珥。','罗得的妻子在后面回头一看，变成了一根盐柱；罗得与两个女儿得以脱离倾覆。','与所多玛倾覆的叙事相接，罗得之妻的结局成为著名的警示意象。','约公元前 2050–1900 年'),
('lot-flees-to-zoar','en','Lot flees to Zoar','Two messengers urge Lot’s family out of Sodom, and Lot escapes to the small town of Zoar.','Lot’s wife looks back behind him and becomes a pillar of salt; Lot and his two daughters escape the overthrow.','Joined to the destruction of Sodom, with the fate of Lot’s wife as its famous warning image.','c. 2050–1900 BCE'),
('covenant-at-beersheba','zh-CN','别是巴之约','亚伯拉罕与亚比米勒在别是巴立约，解决水井之争。','亚伯拉罕以七只母羊羔为证，证明水井为他所挖；那地因起誓得名别是巴，他在那里栽了一棵垂丝柳树。','别是巴由此成为族长叙事中反复出现的居住与敬拜之地。','约公元前 2050–1900 年'),
('covenant-at-beersheba','en','The covenant at Beersheba','Abraham and Abimelech make a covenant at Beersheba, settling a dispute over a well.','Abraham sets apart seven ewe lambs as witness that he dug the well; the place is named Beersheba for the oath, and he plants a tamarisk tree there.','Beersheba becomes a recurring place of dwelling and worship in the patriarchal narratives.','c. 2050–1900 BCE'),
('birth-of-jacob-and-esau','zh-CN','雅各与以扫出生','利百加怀孕，双子在腹中相争，生下以扫和抓住哥哥脚跟的雅各。','以撒六十岁时双子出生；神谕说“将来大的要服事小的”；以扫善于打猎，雅各安静住在帐棚里。','双子之争贯穿整个雅各叙事。','约公元前 2000–1850 年'),
('birth-of-jacob-and-esau','en','Birth of Jacob and Esau','Rebekah’s twins struggle in the womb; Esau is born first, with Jacob grasping his heel.','The twins are born when Isaac is sixty; the oracle says “the older shall serve the younger”; Esau becomes a hunter while Jacob dwells quietly in tents.','The rivalry of the twins runs through the whole Jacob narrative.','c. 2000–1850 BCE'),
('esau-sells-his-birthright','zh-CN','以扫出卖长子名分','以扫打猎回来疲乏至极，用长子的名分换了雅各的一碗红豆汤。','经文记载以扫“轻看了他长子的名分”；这碗红汤也使他得名以东。','为雅各日后骗取祝福的叙事作铺垫。','约公元前 1990–1840 年'),
('esau-sells-his-birthright','en','Esau sells his birthright','Coming in famished from the field, Esau trades his birthright to Jacob for a bowl of red stew.','The text notes that Esau “despised his birthright”; the red stew also gives him the name Edom.','Sets up the later narrative of Jacob taking the blessing by deceit.','c. 1990–1840 BCE'),
('sons-born-to-jacob-in-harran','zh-CN','雅各诸子在哈兰出生','在哈兰的岁月里，利亚、拉结及使女辟拉、悉帕先后为雅各生下众子女。','利亚生吕便、西缅、利未、犹大等；辟拉生但、拿弗他利，悉帕生迦得、亚设，拉结最终生下约瑟；女儿底拿也在其中。','以色列十二支派的家族雏形在此形成。','约公元前 1950–1800 年'),
('sons-born-to-jacob-in-harran','en','Jacob’s children born in Harran','During the Harran years, Leah, Rachel, and the maids Bilhah and Zilpah bear Jacob’s children.','Leah bears Reuben, Simeon, Levi, Judah, and others; Bilhah bears Dan and Naphtali, Zilpah bears Gad and Asher, and Rachel at last bears Joseph; the daughter Dinah is among them.','The family nucleus of the twelve tribes of Israel takes shape here.','c. 1950–1800 BCE'),
('jacob-flees-and-covenant-with-laban','zh-CN','雅各离开拉班，基列立约','雅各带着妻儿牲畜暗自离开哈兰，拉班追到基列山，两人堆石立约分手。','拉班搜寻被拉结藏起的家中神像而不得；二人以石堆为证，称那地方为米斯巴，彼此起誓不越界加害。','结束雅各在哈兰二十年的岁月，叙事转向归回迦南。','约公元前 1940–1790 年'),
('jacob-flees-and-covenant-with-laban','en','Jacob leaves Laban; covenant in Gilead','Jacob departs Harran secretly with his family and flocks; Laban overtakes him in the hills of Gilead, where they part with a covenant of stones.','Laban searches in vain for his household gods, hidden by Rachel; the two raise a heap of stones called Mizpah and swear not to pass it to harm each other.','Closes Jacob’s twenty years in Harran and turns the narrative toward Canaan.','c. 1940–1790 BCE'),
('dinah-at-shechem','zh-CN','底拿与示剑事件','底拿在示剑被城主之子玷辱，西缅与利未设计屠城报复。','示剑人接受割礼作为联姻的条件；第三日，西缅与利未趁他们疼痛之时杀了城中所有男丁。雅各责备二子使他在当地居民中有了臭名。','这一暴行在雅各临终的祝福中仍被追究。','约公元前 1930–1780 年'),
('dinah-at-shechem','en','Dinah and the Shechem episode','Dinah is violated by the son of Shechem’s ruler, and Simeon and Levi avenge her by slaughtering the city.','The men of Shechem accept circumcision as the condition for intermarriage; on the third day, while they are in pain, Simeon and Levi kill every male. Jacob rebukes his sons for making him odious to the inhabitants of the land.','The violence is still reckoned with in Jacob’s deathbed blessing.','c. 1930–1780 BCE'),
('josephs-dreams-and-the-coat','zh-CN','约瑟的梦与彩衣','雅各偏爱约瑟，为他做彩衣；约瑟两次梦见兄长向他下拜。','禾捆下拜与日月十一星下拜的梦激起兄长们的嫉恨，连父亲也责备他；兄长们因父亲的偏爱越发恨他。','直接引向约瑟被卖往埃及的转折。','约公元前 1920–1770 年'),
('josephs-dreams-and-the-coat','en','Joseph’s dreams and the coat','Jacob favors Joseph with an ornamented coat, and Joseph twice dreams of his brothers bowing to him.','The dreams of the bowing sheaves and of the sun, moon, and eleven stars provoke his brothers’ envy, and even his father rebukes him; the favoritism deepens their hatred.','Leads directly to the turning point of Joseph being sold into Egypt.','c. 1920–1770 BCE'),
('joseph-in-potiphars-house','zh-CN','约瑟在波提乏家被诬下监','约瑟在波提乏家中作管家，因拒绝主母的引诱被诬告下监。','耶和华与约瑟同在，凡他所作的尽都顺利；波提乏之妻抓住他的外衣作假见证，约瑟被下在王的囚犯所在的监里。','监狱成为约瑟通往埃及宫廷的意外通道。','约公元前 1910–1760 年'),
('joseph-in-potiphars-house','en','Joseph accused in Potiphar’s house','Joseph stewards Potiphar’s house, then is falsely accused after refusing his master’s wife and is imprisoned.','The Lord is with Joseph and all he does prospers; Potiphar’s wife keeps his garment as false evidence, and Joseph is put in the prison where the king’s prisoners are held.','The prison becomes Joseph’s unexpected path toward the Egyptian court.','c. 1910–1760 BCE'),
('joseph-interprets-dreams-in-prison','zh-CN','约瑟在监中解梦','约瑟为同监的酒政与膳长解梦，所言一一应验。','酒政三日后官复原职，膳长被挂在木头上；酒政却忘了替约瑟说情，直到两年后法老作梦才想起他。','为约瑟为法老解梦、升任宰相的叙事作铺垫。','约公元前 1900–1750 年'),
('joseph-interprets-dreams-in-prison','en','Joseph interprets dreams in prison','Joseph interprets the dreams of the imprisoned cupbearer and baker, and each comes true.','Within three days the cupbearer is restored and the baker hanged; yet the cupbearer forgets Joseph until Pharaoh dreams two years later.','Prepares for Joseph’s interpretation of Pharaoh’s dreams and his rise to power.','c. 1900–1750 BCE'),
('jacob-goes-down-to-egypt','zh-CN','雅各下埃及','雅各得知约瑟尚在，举家南下，途中在别是巴献祭并得夜间异象的应许。','神在异象中说“不要怕下埃及去，我必使你在那里成为大族”；随行下埃及的家眷共七十人。','以色列家从迦南迁往埃及，为出埃及叙事铺设背景。','约公元前 1880–1730 年'),
('jacob-goes-down-to-egypt','en','Jacob goes down to Egypt','Learning that Joseph lives, Jacob moves his whole household south, offering sacrifices at Beersheba where he receives a night vision.','In the vision God says, “Do not fear to go down to Egypt, for I will make you a great nation there”; seventy persons of his household go down with him.','The move of Israel’s family from Canaan to Egypt sets the stage for the exodus narrative.','c. 1880–1730 BCE'),
('jacob-blesses-his-sons','zh-CN','雅各祝福众子','雅各临终把十二个儿子叫到跟前，逐一说出各人日后的遭遇。','吕便因玷污父榻失去长子名分，犹大得着王权的应许，约瑟蒙“多结果子”的祝福；雅各随后嘱咐把他葬在麦比拉洞。','十二支派各自命运的经典预言场景。','约公元前 1870–1720 年'),
('jacob-blesses-his-sons','en','Jacob blesses his sons','On his deathbed Jacob gathers his twelve sons and pronounces what will befall each.','Reuben forfeits his preeminence for defiling his father’s bed, Judah receives the promise of rule, and Joseph the blessing of fruitfulness; Jacob then charges them to bury him in the cave of Machpelah.','The classic scene foretelling the destinies of the twelve tribes.','c. 1870–1720 BCE'),
('jacob-buried-at-machpelah','zh-CN','雅各归葬麦比拉洞','约瑟与众兄长遵父遗命，把雅各的遗体从埃及送回迦南，葬在麦比拉洞。','埃及人为雅各哀哭七十天，送葬的队伍浩大；麦比拉洞是亚伯拉罕从赫人以弗仑买下的坟地，撒拉、亚伯拉罕、以撒都葬在那里。','归葬迦南表明应许之地仍是这个家族认定的归宿。','约公元前 1870–1720 年'),
('jacob-buried-at-machpelah','en','Jacob buried at Machpelah','Joseph and his brothers carry Jacob’s body from Egypt back to Canaan and bury him in the cave of Machpelah.','Egypt mourns Jacob seventy days and a great procession goes up; Machpelah is the burial plot Abraham bought from Ephron the Hittite, where Sarah, Abraham, and Isaac already lie.','The burial in Canaan marks the promised land as the family’s acknowledged home.','c. 1870–1720 BCE'),
('death-of-joseph','zh-CN','约瑟去世','约瑟活到一百一十岁，死前嘱咐族人日后必把他的骸骨带出埃及。','约瑟对兄弟们说“神必看顾你们，领你们从这地上去”；他的遗体用香料薰了，收殓在棺材里，停放在埃及。','创世记在此收束，并为出埃及的叙事留下伏笔。','约公元前 1860–1710 年'),
('death-of-joseph','en','Death of Joseph','Joseph dies at one hundred and ten, charging his kin to carry his bones out of Egypt in days to come.','Joseph tells his brothers, “God will surely visit you and bring you up out of this land”; his body is embalmed and placed in a coffin in Egypt.','Genesis closes here, leaving a thread that the exodus narrative will take up.','c. 1860–1710 BCE')
) AS v(slug,locale,title,summary,detail,sig,tlabel) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS (reuse harran, jerusalem, hebron, sodom-region,
--    beersheba, canaan-shechem, nile-delta, goshen; new mizpah-of-gilead)
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('terah-settles-and-dies-in-harran','harran'),
('call-of-abram-at-harran','harran'),
('melchizedek-blesses-abram','jerusalem'),
('covenant-between-the-pieces','hebron'),
('birth-of-ishmael','hebron'),
('covenant-of-circumcision','hebron'),
('visitors-at-mamre','hebron'),
('lot-flees-to-zoar','sodom-region'),
('covenant-at-beersheba','beersheba'),
('birth-of-jacob-and-esau','beersheba'),
('esau-sells-his-birthright','beersheba'),
('sons-born-to-jacob-in-harran','harran'),
('jacob-flees-and-covenant-with-laban','mizpah-of-gilead'),
('dinah-at-shechem','canaan-shechem'),
('josephs-dreams-and-the-coat','hebron'),
('joseph-in-potiphars-house','nile-delta'),
('joseph-interprets-dreams-in-prison','nile-delta'),
('jacob-goes-down-to-egypt','beersheba'),
('jacob-blesses-his-sons','goshen'),
('jacob-buried-at-machpelah','hebron'),
('death-of-joseph','goshen')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS (also attaches laban / pharaoh-of-joseph to
--    pre-existing events)
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('terah-settles-and-dies-in-harran','terah',0),('terah-settles-and-dies-in-harran','abraham',1),('terah-settles-and-dies-in-harran','sarah',2),('terah-settles-and-dies-in-harran','lot',3),
('call-of-abram-at-harran','abraham',0),('call-of-abram-at-harran','sarah',1),('call-of-abram-at-harran','lot',2),
('melchizedek-blesses-abram','melchizedek',0),('melchizedek-blesses-abram','abraham',1),
('covenant-between-the-pieces','abraham',0),
('birth-of-ishmael','ishmael',0),('birth-of-ishmael','hagar',1),('birth-of-ishmael','abraham',2),('birth-of-ishmael','sarah',3),
('covenant-of-circumcision','abraham',0),('covenant-of-circumcision','sarah',1),('covenant-of-circumcision','ishmael',2),
('visitors-at-mamre','abraham',0),('visitors-at-mamre','sarah',1),
('lot-flees-to-zoar','lot',0),
('covenant-at-beersheba','abraham',0),
('birth-of-jacob-and-esau','jacob',0),('birth-of-jacob-and-esau','esau',1),('birth-of-jacob-and-esau','isaac',2),('birth-of-jacob-and-esau','rebekah',3),
('esau-sells-his-birthright','esau',0),('esau-sells-his-birthright','jacob',1),
('sons-born-to-jacob-in-harran','jacob',0),('sons-born-to-jacob-in-harran','leah',1),('sons-born-to-jacob-in-harran','rachel',2),('sons-born-to-jacob-in-harran','bilhah',3),('sons-born-to-jacob-in-harran','zilpah',4),('sons-born-to-jacob-in-harran','reuben',5),('sons-born-to-jacob-in-harran','judah-son-of-jacob',6),('sons-born-to-jacob-in-harran','dinah',7),
('jacob-flees-and-covenant-with-laban','jacob',0),('jacob-flees-and-covenant-with-laban','laban',1),('jacob-flees-and-covenant-with-laban','rachel',2),('jacob-flees-and-covenant-with-laban','leah',3),
('dinah-at-shechem','dinah',0),('dinah-at-shechem','jacob',1),
('josephs-dreams-and-the-coat','joseph-son-of-jacob',0),('josephs-dreams-and-the-coat','jacob',1),('josephs-dreams-and-the-coat','reuben',2),('josephs-dreams-and-the-coat','judah-son-of-jacob',3),
('joseph-in-potiphars-house','joseph-son-of-jacob',0),('joseph-in-potiphars-house','potiphar',1),('joseph-in-potiphars-house','potiphars-wife',2),
('joseph-interprets-dreams-in-prison','joseph-son-of-jacob',0),
('jacob-goes-down-to-egypt','jacob',0),('jacob-goes-down-to-egypt','judah-son-of-jacob',1),('jacob-goes-down-to-egypt','joseph-son-of-jacob',2),('jacob-goes-down-to-egypt','benjamin',3),
('jacob-blesses-his-sons','jacob',0),('jacob-blesses-his-sons','joseph-son-of-jacob',1),('jacob-blesses-his-sons','reuben',2),('jacob-blesses-his-sons','judah-son-of-jacob',3),('jacob-blesses-his-sons','benjamin',4),
('jacob-buried-at-machpelah','jacob',0),('jacob-buried-at-machpelah','joseph-son-of-jacob',1),
('death-of-joseph','joseph-son-of-jacob',0),
('jacob-marries-leah-and-rachel','laban',5),
('joseph-rises-in-egypt','pharaoh-of-joseph',5)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES (all new events map to Genesis)
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Genesis'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.id::text LIKE '63000000-0000-4000-8002%'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS
-- -------------------------------------------------------------------------
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('73000000-0000-4000-8002-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'terah','abraham','family','source_to_target','positive',3,'ended',NULL,'terah-settles-and-dies-in-harran'),
(2,'melchizedek','abraham','ally','source_to_target','positive',2,'ended','melchizedek-blesses-abram',NULL),
(3,'laban','jacob','family','bidirectional','mixed',3,'changed','jacob-marries-leah-and-rachel','jacob-flees-and-covenant-with-laban'),
(4,'laban','rachel','family','source_to_target','positive',3,'changed',NULL,'jacob-flees-and-covenant-with-laban'),
(5,'laban','leah','family','source_to_target','positive',3,'changed',NULL,'jacob-flees-and-covenant-with-laban'),
(6,'jacob','dinah','family','source_to_target','positive',2,'unknown','sons-born-to-jacob-in-harran',NULL),
(7,'jacob','reuben','family','source_to_target','mixed',3,'changed','sons-born-to-jacob-in-harran','jacob-blesses-his-sons'),
(8,'potiphar','joseph-son-of-jacob','other','source_to_target','mixed',2,'ended','joseph-sold-into-egypt','joseph-in-potiphars-house'),
(9,'potiphars-wife','joseph-son-of-jacob','adversary','source_to_target','negative',3,'ended',NULL,'joseph-in-potiphars-house'),
(10,'pharaoh-of-joseph','joseph-son-of-jacob','ally','source_to_target','positive',4,'active','joseph-rises-in-egypt',NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000005'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 10. GROUP MEMBERSHIP (existing groups abrahamic-household, house-of-jacob)
-- -------------------------------------------------------------------------
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g JOIN (VALUES
('abrahamic-household','terah'),
('house-of-jacob','bilhah'),('house-of-jacob','zilpah'),
('house-of-jacob','dinah'),('house-of-jacob','reuben')
) AS v(gslug,cslug)
ON g.slug=v.gslug JOIN characters c ON c.slug=v.cslug AND c.work_id=g.work_id
WHERE g.work_id='10000000-0000-4000-8000-000000000005' ON CONFLICT DO NOTHING;

COMMIT;
