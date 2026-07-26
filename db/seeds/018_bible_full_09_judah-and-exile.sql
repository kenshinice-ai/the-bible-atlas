BEGIN;

-- =========================================================================
-- 018_bible_full_09_judah-and-exile.sql
-- Chapter K=09 slug='judah-and-exile' (2 Kings 18-25; Jeremiah; Daniel)
-- Adds 14 characters, 15 new events, relations, and reorders the
-- thirteen pre-existing era events into the 9001-9999 sequence band.
-- Era range: 701-539 BCE. No new locations (all reused).
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('43000000-0000-4000-8009-000000000001','10000000-0000-4000-8000-000000000005','sennacherib',900,'male','adult','antagonist','historical',NULL,NULL,'king',3),
('43000000-0000-4000-8009-000000000002','10000000-0000-4000-8000-000000000005','manasseh-king-of-judah',901,'male','adult','supporting','historical',NULL,NULL,'king',2),
('43000000-0000-4000-8009-000000000003','10000000-0000-4000-8000-000000000005','josiah',902,'male','adult','protagonist','unknown',NULL,NULL,'king',3),
('43000000-0000-4000-8009-000000000004','10000000-0000-4000-8000-000000000005','huldah',903,'female','adult','supporting','unknown',NULL,NULL,'prophet',2),
('43000000-0000-4000-8009-000000000005','10000000-0000-4000-8000-000000000005','jehoiakim',904,'male','adult','antagonist','unknown',NULL,NULL,'king',2),
('43000000-0000-4000-8009-000000000006','10000000-0000-4000-8000-000000000005','zedekiah',905,'male','adult','supporting','unknown',NULL,NULL,'king',3),
('43000000-0000-4000-8009-000000000007','10000000-0000-4000-8000-000000000005','baruch',906,'male','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8009-000000000008','10000000-0000-4000-8000-000000000005','ebed-melech',907,'male','adult','supporting','unknown',NULL,NULL,'person',1),
('43000000-0000-4000-8009-000000000009','10000000-0000-4000-8000-000000000005','gedaliah',908,'male','adult','supporting','unknown',NULL,NULL,'ruler',2),
('43000000-0000-4000-8009-000000000010','10000000-0000-4000-8000-000000000005','shadrach',909,'male','youth','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8009-000000000011','10000000-0000-4000-8000-000000000005','meshach',910,'male','youth','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8009-000000000012','10000000-0000-4000-8000-000000000005','abednego',911,'male','youth','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8009-000000000013','10000000-0000-4000-8000-000000000005','belshazzar',912,'male','adult','antagonist','historical',NULL,NULL,'king',2),
('43000000-0000-4000-8009-000000000014','10000000-0000-4000-8000-000000000005','darius-the-mede',913,'male','elder','supporting','unknown',NULL,NULL,'king',2)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('sennacherib','zh-CN','西拿基立','亚述王，率大军入侵犹大并围困耶路撒冷。',ARRAY[]::text[],'他镇压属国的反叛，攻陷拉吉等犹大坚城，并遣使恐吓耶路撒冷；经文记载其大军一夜之间覆灭，他撤回尼尼微，后死于自己儿子之手。其战事另有亚述王家铭文可相对照。','维护亚述霸权，惩罚背叛的属国。'),
('sennacherib','en','Sennacherib','King of Assyria who invaded Judah and besieged Jerusalem.',ARRAY[]::text[],'He crushes rebellious vassals, takes fortified cities such as Lachish, and sends envoys to intimidate Jerusalem; the text records his army perishing in a single night, his withdrawal to Nineveh, and his death at the hands of his own sons. His campaign is also known from Assyrian royal inscriptions.','To uphold Assyrian dominance and punish rebellious vassals.'),
('manasseh-king-of-judah','zh-CN','玛拿西（犹大王）','希西家之子，在位五十五年，以推行偶像崇拜著称。',ARRAY[]::text[],'他重建父亲所毁的邱坛，在圣殿中筑坛立像，经文称其使犹大行恶甚于列国；历代志另记他被掳到巴比伦后悔改归回。','巩固王权，依附强邻的宗教与政治秩序。'),
('manasseh-king-of-judah','en','Manasseh (king of Judah)','Hezekiah’s son, who reigned fifty-five years and is remembered for promoting idolatry.',ARRAY[]::text[],'He rebuilds the high places his father destroyed and sets up altars and images in the temple; the text says he led Judah into greater evil than the nations. Chronicles adds an account of his captivity in Babylon and repentance.','To secure his throne within the religious and political order of a powerful overlord.'),
('josiah','zh-CN','约西亚','八岁登基的犹大王，因律法书的发现而推行全面改革。',ARRAY[]::text[],'他修葺圣殿时发现律法书，撕裂衣服求问女先知户勒大，随后除净偶像、重立圣约、守逾越节；后在米吉多迎击埃及王尼哥时阵亡。','使国家的敬拜归回所发现之律法书的要求。'),
('josiah','en','Josiah','King of Judah from the age of eight, whose sweeping reform followed the finding of the book of the law.',ARRAY[]::text[],'During temple repairs the book of the law is found; he tears his robes, consults the prophetess Huldah, then purges idols, renews the covenant, and keeps a great Passover. He later falls at Megiddo confronting Pharaoh Neco.','To bring the nation’s worship back to the demands of the recovered book of the law.'),
('huldah','zh-CN','户勒大','住在耶路撒冷的女先知，约西亚为律法书求问的对象。',ARRAY[]::text[],'祭司希勒家等人奉王命去见她，她宣告书上的灾祸必然临到，但约西亚因心里柔软必得平安归到列祖那里。','忠实传达所领受的默示。'),
('huldah','en','Huldah','A prophetess in Jerusalem whom Josiah consulted about the book of the law.',ARRAY[]::text[],'Hilkiah the priest and the king’s officials go to her; she declares that the disasters written in the book will surely come, but that Josiah, because his heart was tender, will be gathered to his fathers in peace.','To deliver faithfully the oracle entrusted to her.'),
('jehoiakim','zh-CN','约雅敬','约西亚之子，由埃及王立为犹大王，以焚烧耶利米书卷著称。',ARRAY[]::text[],'尼哥废其弟约哈斯而立他为王；他向埃及纳贡、劳役民众，逐段割破并焚烧巴录所写的耶利米书卷，后又背叛巴比伦。','在强权夹缝中保住王位，压制不利于己的预言。'),
('jehoiakim','en','Jehoiakim','Josiah’s son, made king of Judah by Pharaoh Neco, remembered for burning Jeremiah’s scroll.',ARRAY[]::text[],'Installed by Neco in place of his brother Jehoahaz, he taxes the land for Egypt, presses the people into labor, cuts up and burns the scroll Baruch wrote, and later rebels against Babylon.','To keep his throne between rival empires and silence unwelcome prophecy.'),
('zedekiah','zh-CN','西底家','犹大末代君王，背叛巴比伦，城破后被剜眼掳往巴比伦。',ARRAY[]::text[],'尼布甲尼撒立他为王并为他改名；他暗中求问耶利米却不敢听从，最终背约反叛，城破时出逃被擒，众子在他眼前被杀，双眼被剜。','在朝臣与强邻之间摇摆求存。'),
('zedekiah','en','Zedekiah','The last king of Judah, who rebelled against Babylon and was blinded after the city fell.',ARRAY[]::text[],'Installed and renamed by Nebuchadnezzar, he secretly consults Jeremiah but dares not obey; he finally breaks his oath and rebels, flees when the city is breached, sees his sons killed, and is blinded and carried to Babylon.','To survive between his own officials and an overwhelming overlord.'),
('baruch','zh-CN','巴录','尼利亚的儿子，耶利米的文士，笔录并宣读先知的书卷。',ARRAY[]::text[],'他照耶利米口授把预言写在书卷上，在圣殿向民众宣读；书卷被王焚烧后又重新写过，并添了许多相仿的话；后随耶利米被带往埃及。','忠实记录并传布先知所领受的话。'),
('baruch','en','Baruch','Son of Neriah, Jeremiah’s scribe, who wrote down and read out the prophet’s scroll.',ARRAY[]::text[],'At Jeremiah’s dictation he writes the prophecies on a scroll and reads them in the temple; after the king burns it, he writes it again with many similar words added, and is later taken with Jeremiah to Egypt.','To record and carry the prophet’s words faithfully.'),
('ebed-melech','zh-CN','以伯米勒','王宫中的古实太监，把耶利米从淤泥坑中救出。',ARRAY[]::text[],'他向西底家为耶利米求情，带人用破布旧衣垫着绳子把先知从坑中拉上来；经文记载他因倚靠耶和华，城破之日必得保全性命。','不忍先知冤死，凭信心救人。'),
('ebed-melech','en','Ebed-melech','A Cushite officer of the palace who drew Jeremiah out of the miry cistern.',ARRAY[]::text[],'He appeals to Zedekiah on Jeremiah’s behalf and, with a crew of men, lifts the prophet out with ropes padded by old rags; the text records a promise that his life will be spared at the city’s fall because he trusted the Lord.','Compassion for the prophet and trust that moved him to act.'),
('gedaliah','zh-CN','基大利','亚希甘的儿子，巴比伦所立管理犹大余民的省长，驻米斯巴。',ARRAY[]::text[],'耶路撒冷陷落后他安抚余民，劝众人服事巴比伦以求平安；不听警告，被王族以实玛利在米斯巴刺杀。','使劫后余民得以在故土安居。'),
('gedaliah','en','Gedaliah','Son of Ahikam, appointed by Babylon as governor over the remnant of Judah at Mizpah.',ARRAY[]::text[],'After Jerusalem’s fall he reassures the remnant, urging them to serve Babylon and live in peace; ignoring warnings, he is assassinated at Mizpah by Ishmael of the royal line.','To let the surviving remnant settle safely in the land.'),
('shadrach','zh-CN','沙得拉','但以理的同伴，被投入烈火窑而毫发无伤的三人之一。',ARRAY['哈拿尼雅'],'犹大贵胄少年，被掳后受巴比伦宫廷教养并改名；他与同伴拒拜金像，被扔进烈火的窑中，经文记载三人在火中行走无损。','宁受火刑也不向偶像下拜。'),
('shadrach','en','Shadrach','Companion of Daniel, one of the three cast unharmed into the blazing furnace.',ARRAY['Hananiah'],'A young Judahite noble taken into the Babylonian court and renamed; with his companions he refuses to worship the golden image and is thrown into the furnace, where the text records the three walking unhurt.','To accept the furnace rather than bow to an image.'),
('meshach','zh-CN','米煞','但以理的同伴，火窑三友之一。',ARRAY['米沙利'],'与沙得拉、亚伯尼歌一同在宫廷受教养并任职省事；三人同拒王命，不拜金像，一同被扔进烈火窑而得保全。','宁受火刑也不向偶像下拜。'),
('meshach','en','Meshach','Companion of Daniel, one of the three friends of the fiery furnace.',ARRAY['Mishael'],'Educated in the court and set over the affairs of the province with Shadrach and Abednego; the three together refuse the king’s command, are cast into the furnace, and are preserved.','To accept the furnace rather than bow to an image.'),
('abednego','zh-CN','亚伯尼歌','但以理的同伴，火窑三友之一。',ARRAY['亚撒利雅'],'与两位同伴一同被掳、受教养、改名并任职；同拒下拜金像，被扔入烈火窑中，出来时身上没有火燎的气味。','宁受火刑也不向偶像下拜。'),
('abednego','en','Abednego','Companion of Daniel, one of the three friends of the fiery furnace.',ARRAY['Azariah'],'Deported, educated, renamed, and appointed alongside his two companions; refusing with them to bow to the golden image, he is cast into the furnace and comes out without even the smell of fire.','To accept the furnace rather than bow to an image.'),
('belshazzar','zh-CN','伯沙撒','但以理书中巴比伦的末任摄政者，在盛筵之夜见墙上文字。',ARRAY[]::text[],'他在大筵席上用圣殿的金银器皿饮酒，忽见指头在墙上写字；但以理解明“弥尼、弥尼、提客勒、乌法珥新”，当夜他被杀，国归他人。其名亦见于巴比伦楔文文献。','在帝国倾覆前夜纵情享乐、夸示权势。'),
('belshazzar','en','Belshazzar','The last ruler of Babylon in the book of Daniel, who saw the writing on the wall at his feast.',ARRAY[]::text[],'At a great banquet he drinks from the temple vessels; fingers appear writing on the wall, and Daniel reads “Mene, mene, tekel, upharsin.” That night he is slain and the kingdom passes to another. His name also appears in Babylonian cuneiform documents.','To revel in and display his power on the empire’s last night.'),
('darius-the-mede','zh-CN','玛代人大流士','但以理书中接掌巴比伦国的君王，狮子坑事件中的君主。',ARRAY[]::text[],'他立但以理为总长之一，被臣仆设计签署禁令，不得已把但以理扔进狮子坑，却彻夜禁食，天亮见但以理无恙后惩办诬告者。此王于域外史料中无从确指，学界多有讨论。','器重贤臣，却受制于自己签署的法令。'),
('darius-the-mede','en','Darius the Mede','The king who receives the kingdom of Babylon in the book of Daniel, ruler in the lions’ den episode.',ARRAY[]::text[],'He makes Daniel one of three chief ministers, is maneuvered into signing an irrevocable decree, reluctantly has Daniel cast into the lions’ den, fasts through the night, and at dawn finds him unharmed and punishes the accusers. No such king is securely identified in outside sources, a point much discussed by scholars.','Esteem for a trusted minister, constrained by his own decree.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. LOCATIONS -- none new: all events reuse jerusalem, megiddo, babylon,
--    jericho, mizpah-of-benjamin (and existing events keep lachish etc.)
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- 3. EVENTS (new) -- range dates within era -701..-539, chapter 'judah-and-exile'
-- -------------------------------------------------------------------------
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('63000000-0000-4000-8009-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,'range'::event_time_type,'unknown'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'sennacheribs-army-destroyed',9009,'legendary_or_mythic','other',-701,-671,'low'),
(2,'manasseh-reigns-in-jerusalem',9011,'reported_historical','political',-697,-643,'medium'),
(3,'book-of-the-law-found-in-the-temple',9015,'reported_historical','discovery',-630,-600,'medium'),
(4,'josiah-renews-the-covenant',9017,'reported_historical','religious',-628,-598,'medium'),
(5,'josiah-falls-at-megiddo',9019,'reported_historical','death',-625,-595,'medium'),
(6,'jeremiahs-temple-sermon',9021,'reported_historical','religious',-615,-585,'medium'),
(7,'jehoiakim-burns-jeremiahs-scroll',9023,'reported_historical','political',-610,-580,'medium'),
(8,'daniel-and-friends-refuse-royal-food',9027,'contested','social',-605,-575,'low'),
(9,'nebuchadnezzars-dream-of-the-great-image',9031,'contested','discovery',-600,-570,'low'),
(10,'three-friends-in-the-fiery-furnace',9035,'legendary_or_mythic','trial',-590,-560,'low'),
(11,'jeremiah-lowered-into-the-cistern',9037,'reported_historical','imprisonment',-590,-560,'medium'),
(12,'ebed-melech-rescues-jeremiah',9039,'reported_historical','escape',-590,-560,'medium'),
(13,'zedekiah-captured-and-blinded',9045,'reported_historical','imprisonment',-587,-557,'medium'),
(14,'gedaliah-assassinated-at-mizpah',9047,'reported_historical','betrayal',-586,-556,'low'),
(15,'nebuchadnezzars-madness',9051,'contested','other',-580,-550,'low')
) AS v(n,slug,seq,reality,etype,y1,y2,conf)
JOIN chapters ch ON ch.slug='judah-and-exile' AND ch.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 4. Reorder existing judah-and-exile events into the 9001-9999 band
-- -------------------------------------------------------------------------
UPDATE events e SET sequence=v.seq FROM (VALUES
  ('isaiah-counsels-hezekiah',9001),
  ('assyrian-siege-of-lachish',9003),
  ('sennacherib-besieges-jerusalem',9005),
  ('hezekiahs-water-tunnel',9007),
  ('jeremiah-called',9013),
  ('first-deportation-to-babylon',9025),
  ('daniel-in-the-babylonian-court',9029),
  ('ezekiels-vision-by-the-canal',9033),
  ('jerusalem-falls',9041),
  ('temple-destroyed',9043),
  ('jeremiah-taken-to-egypt',9049),
  ('belshazzars-feast',9053),
  ('daniel-in-the-lions-den',9055)
) AS v(slug,seq) WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug=v.slug;

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('sennacheribs-army-destroyed','zh-CN','西拿基立大军覆灭','经文记载耶和华的使者一夜之间击杀亚述营中十八万五千人。','希西家在圣殿展开亚述的恐吓书信祷告，以赛亚宣告亚述王必不得进这城；当夜使者出去击杀营中大军，清早遍地都是尸首，西拿基立拔营回尼尼微去了。','解释了耶路撒冷得免于亚述之手的结局；亚述铭文只记围困与纳贡，未记攻陷，两种记载的对照历来为学者所注意。','约公元前 701–671 年'),
('sennacheribs-army-destroyed','en','Sennacherib’s army destroyed','The text records the angel of the Lord striking 185,000 in the Assyrian camp in one night.','Hezekiah spreads the Assyrian letter before the Lord, and Isaiah declares the king of Assyria will not enter the city; that night the angel strikes the camp, the morning reveals the dead, and Sennacherib breaks camp and returns to Nineveh.','Accounts for Jerusalem’s survival; Assyrian inscriptions record siege and tribute but no capture, a contrast long noted by scholars.','c. 701–671 BCE'),
('manasseh-reigns-in-jerusalem','zh-CN','玛拿西在耶路撒冷作王','希西家之子玛拿西在位五十五年，重建邱坛、在殿中立偶像。','他效法列国可憎的事，观兆行邪术，使儿子经火，又流许多无辜人的血；列王纪把犹大后来的倾覆归因于他的罪。历代志另记他被亚述人掳到巴比伦，苦难中自卑悔改，归回后除去外邦神像。','叙事中犹大命运的转折点，为审判预言提供背景。','约公元前 697–643 年'),
('manasseh-reigns-in-jerusalem','en','Manasseh reigns in Jerusalem','Hezekiah’s son Manasseh reigns fifty-five years, rebuilding the high places and setting up images in the temple.','He imitates the abominations of the nations, practices divination, makes his son pass through fire, and sheds much innocent blood; Kings traces Judah’s later ruin to his sins. Chronicles adds his captivity in Babylon, his humbling and repentance, and his removal of the foreign gods on his return.','A turning point for Judah’s fate in the narrative, and the backdrop for the oracles of judgment.','c. 697–643 BCE'),
('book-of-the-law-found-in-the-temple','zh-CN','圣殿中发现律法书','修殿时大祭司希勒家发现律法书，约西亚闻言撕裂衣服。','书记沙番把书念给王听，王差人去求问女先知户勒大；她宣告书上的咒诅必临到这地，但约西亚因敬畏自卑，灾祸不在他的日子降下。','这卷书通常被认为与申命记有关，成为约西亚改革的直接推动力。','约公元前 630–600 年'),
('book-of-the-law-found-in-the-temple','en','The book of the law found in the temple','During temple repairs Hilkiah the high priest finds the book of the law, and Josiah tears his robes on hearing it.','Shaphan the scribe reads the book to the king, who sends to consult the prophetess Huldah; she declares that the curses written in it will fall on the land, but not in the days of Josiah, because he humbled himself.','The book is commonly associated with Deuteronomy, and it becomes the direct impetus for Josiah’s reform.','c. 630–600 BCE'),
('josiah-renews-the-covenant','zh-CN','约西亚重立圣约','约西亚召集众民宣读约书，随后清除全国的偶像并守逾越节。','王站在柱旁与耶和华立约，尽心尽性遵行书上的话；他废去偶像祭司，拆毁邱坛，污秽欣嫩子谷的陀斐特，连伯特利的坛也拆毁焚烧，又守了自士师以来未曾有过的逾越节。','列王纪对约西亚的评价冠于诸王，此次改革被视为申命记传统的高峰。','约公元前 628–598 年'),
('josiah-renews-the-covenant','en','Josiah renews the covenant','Josiah gathers the people to hear the book of the covenant, then purges the idols of the land and keeps the Passover.','Standing by the pillar, the king makes a covenant to follow the Lord with all his heart; he deposes the idolatrous priests, tears down the high places, defiles Topheth in the valley of Hinnom, demolishes even the altar at Bethel, and keeps a Passover unmatched since the days of the judges.','Kings praises Josiah above all other kings; the reform is seen as the high point of the Deuteronomic tradition.','c. 628–598 BCE'),
('josiah-falls-at-megiddo','zh-CN','约西亚阵亡于米吉多','约西亚在米吉多迎击北上的埃及王尼哥，中箭身亡。','尼哥率军往幼发拉底河去帮助亚述，约西亚出兵拦截；王在米吉多平原受了致命伤，臣仆用车把他送回耶路撒冷，葬在自己的坟墓里，通国为他哀哭。','改革君王的骤逝震动全国，犹大自此沦为大国角力的棋子。','约公元前 625–595 年'),
('josiah-falls-at-megiddo','en','Josiah falls at Megiddo','Josiah confronts Pharaoh Neco’s northbound army at Megiddo and is fatally wounded.','Neco marches toward the Euphrates to aid Assyria, and Josiah moves to intercept him; struck by archers on the plain of Megiddo, he is carried back to Jerusalem in his chariot, buried in his own tomb, and mourned by all the land.','The reformer king’s sudden death stuns the nation, and Judah becomes a pawn between the great powers.','c. 625–595 BCE'),
('jeremiahs-temple-sermon','zh-CN','耶利米的圣殿讲论','耶利米站在圣殿门口宣告：不可倚靠“这是耶和华的殿”的虚谎话。','他警告民众若不改正行为，这殿必如示罗一样被弃；祭司先知与众民抓住他要治死他，首领们开庭审问，有长老引先弥迦的先例为他辩护，他才得免一死。','对圣殿不可摧毁之信念的正面挑战，也是先知因言获罪的著名场景。','约公元前 615–585 年'),
('jeremiahs-temple-sermon','en','Jeremiah’s temple sermon','At the temple gate Jeremiah proclaims: do not trust the deceptive words, “This is the temple of the Lord.”','He warns that unless the people amend their ways the house will become like Shiloh; priests, prophets, and people seize him to put him to death, officials hold a hearing, and elders citing the precedent of Micah secure his release.','A direct challenge to belief in the temple’s inviolability, and a famous scene of a prophet on trial for his words.','c. 615–585 BCE'),
('jehoiakim-burns-jeremiahs-scroll','zh-CN','巴录笔录与约雅敬焚卷','巴录照耶利米口授写成书卷并在殿中宣读，约雅敬把书卷割破烧尽。','书卷被送到王宫，犹底念给坐在过冬房中的王听；王每听三四篇就用文士的刀割下扔进火盆，直到全卷烧尽，并下令捉拿耶利米和巴录。耶利米随后又口授一卷，另外添了许多相仿的话。','焚而复写的书卷成为先知话语不可磨灭的象征。','约公元前 610–580 年'),
('jehoiakim-burns-jeremiahs-scroll','en','Baruch’s scroll and Jehoiakim’s fire','Baruch writes a scroll at Jeremiah’s dictation and reads it in the temple; Jehoiakim cuts it up and burns it.','The scroll is brought to the palace, where Jehudi reads it to the king seated by his winter brazier; every three or four columns the king slices off with a scribe’s knife and throws into the fire until the whole scroll is consumed, ordering the arrest of Jeremiah and Baruch. Jeremiah then dictates another scroll, with many similar words added.','The burned and rewritten scroll becomes a symbol of the indestructibility of the prophetic word.','c. 610–580 BCE'),
('daniel-and-friends-refuse-royal-food','zh-CN','但以理与三友拒用王膳','被掳的但以理与三个同伴立志不以王的膳食玉液玷污自己。','四位犹大少年被选入宫受迦勒底文化教养并被改名；但以理求太监长准许十天只吃素菜喝白水，十天后他们的面貌比用王膳的少年更加俊美肥胖，遂得照此而行。','被掳群体在异邦宫廷持守身份的开篇场景。','约公元前 605–575 年'),
('daniel-and-friends-refuse-royal-food','en','Daniel and his friends refuse the royal food','Daniel and his three companions, taken into exile, resolve not to defile themselves with the king’s food and wine.','Four young Judahite nobles are chosen for training in Chaldean learning and given new names; Daniel asks the chief officer for a ten-day test on vegetables and water, after which the four look healthier than those on the royal fare, and are allowed to continue.','The opening scene of exiles keeping their identity within a foreign court.','c. 605–575 BCE'),
('nebuchadnezzars-dream-of-the-great-image','zh-CN','尼布甲尼撒的大像之梦','王梦见一座金银铜铁的巨像被非人手凿出的石头砸碎，但以理述梦并解梦。','王要求哲士先说出梦本身，术士无人能够，王下令诛杀全国哲士；但以理求得宽限，夜间蒙启示，向王陈明巨像四段金属所指的相继诸国，以及那砸碎巨像、变成大山的石头。王俯伏敬拜，升但以理为总理。','四国相继的图式对后世的历史观与启示文学影响深远。','约公元前 600–570 年'),
('nebuchadnezzars-dream-of-the-great-image','en','Nebuchadnezzar’s dream of the great image','The king dreams of a colossal image of gold, silver, bronze, and iron shattered by a stone cut without hands; Daniel recounts and interprets the dream.','The king demands that his sages first tell the dream itself; none can, and he orders all the wise men killed. Daniel obtains a delay, receives the mystery in a night vision, and sets before the king the succession of kingdoms figured in the image’s metals, and the stone that shatters it and becomes a great mountain. The king falls on his face and makes Daniel chief over the wise men.','The scheme of four successive kingdoms deeply shaped later views of history and apocalyptic literature.','c. 600–570 BCE'),
('three-friends-in-the-fiery-furnace','zh-CN','火窑中的三友','沙得拉、米煞、亚伯尼歌拒拜金像，被扔进烈火的窑中而毫发无伤。','王在杜拉平原立金像，令各族各方闻乐声即俯伏敬拜；三人抗命，答称“即或不然”也不事奉王的神。窑烧热七倍，抬他们的壮士被火焰烧死，王却见窑中有四人游行，其一“好像神子”。三人出来，头发未焦，衣裳无损，身上也没有火燎的气味。','“即或不然”的回答成为殉道信仰的经典表述。','约公元前 590–560 年'),
('three-friends-in-the-fiery-furnace','en','The three friends in the fiery furnace','Shadrach, Meshach, and Abednego refuse to worship the golden image and are cast unharmed into the blazing furnace.','The king sets up a golden image on the plain of Dura and commands all peoples to bow at the sound of the music; the three refuse, answering that their God can deliver them, “but if not,” they still will not serve the king’s gods. The furnace is heated sevenfold, the men who carry them are killed by the flames, yet the king sees four figures walking in the fire, the fourth “like a son of the gods.” The three emerge with hair unsinged, clothes intact, and no smell of fire.','Their “but if not” becomes a classic confession of faith under threat of death.','c. 590–560 BCE'),
('jeremiah-lowered-into-the-cistern','zh-CN','耶利米被下入淤泥坑','首领们指耶利米动摇军心，把他用绳子缒入王子玛基雅的枯井。','围城期间耶利米劝人出降存命，首领们求王治死他；西底家说“他在你们手中”，他们便把先知缒入牢狱院中的深坑，坑里无水只有淤泥，耶利米陷在其中。','先知与朝廷冲突的最低点，命悬一线。','约公元前 590–560 年'),
('jeremiah-lowered-into-the-cistern','en','Jeremiah lowered into the cistern','Accusing Jeremiah of weakening the soldiers, the officials lower him by ropes into the cistern of Malchiah the king’s son.','During the siege Jeremiah urges surrender as the way to live; the officials demand his death, and Zedekiah answers, “He is in your hands.” They drop the prophet into a deep pit in the court of the guard, where there is no water but only mire, and Jeremiah sinks in the mud.','The lowest point of the prophet’s conflict with the court, his life hanging by a thread.','c. 590–560 BCE'),
('ebed-melech-rescues-jeremiah','zh-CN','以伯米勒救耶利米出坑','古实太监以伯米勒向王求情，用破布旧衣垫绳把耶利米拉出坑来。','以伯米勒当面对王说首领们所行的是恶事，先知必饿死在坑中；王命他带人去救。他从库房取了碎布旧衣，用绳子缒下去，让耶利米垫在胳肢窝下，把他从淤泥中拉上来，先知仍留在护卫兵的院中。','异邦太监的义举与本国首领的狠毒形成鲜明对照。','约公元前 590–560 年'),
('ebed-melech-rescues-jeremiah','en','Ebed-melech rescues Jeremiah from the pit','Ebed-melech the Cushite officer appeals to the king and draws Jeremiah up with ropes padded by old rags.','He tells the king to his face that the officials have done evil and that the prophet will starve in the pit; the king orders him to take men and act. He fetches worn-out clothes and rags from a storeroom, lowers them by ropes for Jeremiah to put under his armpits, and pulls him up out of the mire; the prophet remains in the court of the guard.','The foreign officer’s just deed stands in sharp contrast to the cruelty of the native officials.','c. 590–560 BCE'),
('zedekiah-captured-and-blinded','zh-CN','西底家被擒剜眼','城破之夜西底家出逃，在耶利哥平原被追上，于利比拉受刑。','城被攻破，王与兵丁夜间从两城墙中间的门逃往亚拉巴，迦勒底军追上他，随从尽都四散；他被解到利比拉的尼布甲尼撒面前，众子在他眼前被杀，双眼被剜，用铜链锁着带到巴比伦。','大卫王朝在位君王的终局，应验了先知的警告。','约公元前 587–557 年'),
('zedekiah-captured-and-blinded','en','Zedekiah captured and blinded','On the night the city is breached Zedekiah flees, is overtaken on the plains of Jericho, and is sentenced at Riblah.','As the wall is broken, the king and his soldiers escape by night through the gate between the two walls toward the Arabah; the Chaldean army overtakes him as his men scatter. Brought before Nebuchadnezzar at Riblah, he sees his sons slaughtered, is blinded, and is led to Babylon in bronze chains.','The end of the reigning Davidic line, fulfilling the prophet’s warnings.','c. 587–557 BCE'),
('gedaliah-assassinated-at-mizpah','zh-CN','基大利在米斯巴被刺','王族以实玛利在筵席间刺杀省长基大利及随从，余民惊惶南逃。','巴比伦立基大利治理余民，他劝众人安心服事迦勒底人；约哈难警告有人受亚扪王指使谋害他，他不肯相信。七月间以实玛利带十个人来，在米斯巴一同吃饭时把他杀死，连同在场的犹大人和迦勒底兵丁。余民惧怕报复，最终裹挟耶利米下埃及去了。','劫后重建的最后希望破灭，犹太传统以基大利禁食日纪念此事。','约公元前 586–556 年'),
('gedaliah-assassinated-at-mizpah','en','Gedaliah assassinated at Mizpah','Ishmael of the royal line murders the governor Gedaliah and his men at table, and the terrified remnant flees south.','Babylon appoints Gedaliah over the remnant, and he urges the people to settle and serve the Chaldeans; Johanan warns him of a plot instigated by the king of Ammon, but he refuses to believe it. In the seventh month Ishmael comes with ten men and, while they eat together at Mizpah, kills him along with the Judahites and Chaldean soldiers present. Fearing reprisal, the remnant finally drags Jeremiah with them down to Egypt.','The last hope of rebuilding after the catastrophe collapses; Jewish tradition marks the event with the Fast of Gedaliah.','c. 586–556 BCE'),
('nebuchadnezzars-madness','zh-CN','尼布甲尼撒的疯狂','王梦见大树被伐，但以理劝其悔改；一年后王夸耀荣耀，即刻失去理智如兽。','王在宫顶夸口“这大巴比伦不是我用大能大力建为京都的吗”，话未说完便有声音宣判；他被赶离人群，吃草如牛，身被天露滴湿，头发长如鹰毛，指甲如鸟爪。日期满足，他举目望天，聪明复归，颂赞至高者，随后国位复归于他。','以帝国之主的癫狂宣告“至高者在人的国中掌权”的主题。','约公元前 580–550 年'),
('nebuchadnezzars-madness','en','Nebuchadnezzar’s madness','The king dreams of a great tree cut down; Daniel urges repentance, and a year later, as the king boasts of his glory, his reason leaves him.','On the palace roof he boasts, “Is not this great Babylon, which I have built by my mighty power?” Before the words end, a voice pronounces sentence; he is driven from among men, eats grass like an ox, his body wet with dew, his hair grown like eagles’ feathers and his nails like birds’ claws. At the set time he lifts his eyes to heaven, his reason returns, he blesses the Most High, and his kingdom is restored to him.','Through the madness of the empire’s master, the narrative declares that the Most High rules in the kingdom of men.','c. 580–550 BCE')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS (all reused: jerusalem, megiddo, babylon, jericho,
--    mizpah-of-benjamin)
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('sennacheribs-army-destroyed','jerusalem'),
('manasseh-reigns-in-jerusalem','jerusalem'),
('book-of-the-law-found-in-the-temple','jerusalem'),
('josiah-renews-the-covenant','jerusalem'),
('josiah-falls-at-megiddo','megiddo'),
('jeremiahs-temple-sermon','jerusalem'),
('jehoiakim-burns-jeremiahs-scroll','jerusalem'),
('daniel-and-friends-refuse-royal-food','babylon'),
('nebuchadnezzars-dream-of-the-great-image','babylon'),
('three-friends-in-the-fiery-furnace','babylon'),
('jeremiah-lowered-into-the-cistern','jerusalem'),
('ebed-melech-rescues-jeremiah','jerusalem'),
('zedekiah-captured-and-blinded','jericho'),
('gedaliah-assassinated-at-mizpah','mizpah-of-benjamin'),
('nebuchadnezzars-madness','babylon')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS (new events, plus enrichment of existing era events
--    with the era's newly created figures)
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('sennacheribs-army-destroyed','hezekiah',0),('sennacheribs-army-destroyed','sennacherib',1),('sennacheribs-army-destroyed','isaiah',2),
('manasseh-reigns-in-jerusalem','manasseh-king-of-judah',0),
('book-of-the-law-found-in-the-temple','josiah',0),('book-of-the-law-found-in-the-temple','huldah',1),
('josiah-renews-the-covenant','josiah',0),
('josiah-falls-at-megiddo','josiah',0),
('jeremiahs-temple-sermon','jeremiah',0),
('jehoiakim-burns-jeremiahs-scroll','jeremiah',0),('jehoiakim-burns-jeremiahs-scroll','baruch',1),('jehoiakim-burns-jeremiahs-scroll','jehoiakim',2),
('daniel-and-friends-refuse-royal-food','daniel',0),('daniel-and-friends-refuse-royal-food','shadrach',1),('daniel-and-friends-refuse-royal-food','meshach',2),('daniel-and-friends-refuse-royal-food','abednego',3),
('nebuchadnezzars-dream-of-the-great-image','daniel',0),('nebuchadnezzars-dream-of-the-great-image','nebuchadnezzar',1),
('three-friends-in-the-fiery-furnace','shadrach',0),('three-friends-in-the-fiery-furnace','meshach',1),('three-friends-in-the-fiery-furnace','abednego',2),('three-friends-in-the-fiery-furnace','nebuchadnezzar',3),
('jeremiah-lowered-into-the-cistern','jeremiah',0),('jeremiah-lowered-into-the-cistern','zedekiah',1),
('ebed-melech-rescues-jeremiah','ebed-melech',0),('ebed-melech-rescues-jeremiah','jeremiah',1),('ebed-melech-rescues-jeremiah','zedekiah',2),
('zedekiah-captured-and-blinded','zedekiah',0),('zedekiah-captured-and-blinded','nebuchadnezzar',1),
('gedaliah-assassinated-at-mizpah','gedaliah',0),
('nebuchadnezzars-madness','nebuchadnezzar',0),('nebuchadnezzars-madness','daniel',1),
('assyrian-siege-of-lachish','sennacherib',1),
('sennacherib-besieges-jerusalem','sennacherib',2),
('first-deportation-to-babylon','jehoiakim',2),
('jerusalem-falls','zedekiah',2),
('belshazzars-feast','belshazzar',1),
('daniel-in-the-lions-den','darius-the-mede',1)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES (Kings, Chronicles, Isaiah, Jeremiah, Daniel)
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Kings'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('sennacheribs-army-destroyed','manasseh-reigns-in-jerusalem','book-of-the-law-found-in-the-temple',
 'josiah-renews-the-covenant','josiah-falls-at-megiddo','zedekiah-captured-and-blinded','gedaliah-assassinated-at-mizpah')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Chronicles'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('manasseh-reigns-in-jerusalem','book-of-the-law-found-in-the-temple','josiah-renews-the-covenant','josiah-falls-at-megiddo')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Isaiah'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('sennacheribs-army-destroyed')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Jeremiah'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('jeremiahs-temple-sermon','jehoiakim-burns-jeremiahs-scroll','jeremiah-lowered-into-the-cistern',
 'ebed-melech-rescues-jeremiah','zedekiah-captured-and-blinded','gedaliah-assassinated-at-mizpah')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Daniel'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('daniel-and-friends-refuse-royal-food','nebuchadnezzars-dream-of-the-great-image',
 'three-friends-in-the-fiery-furnace','nebuchadnezzars-madness')
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS
-- -------------------------------------------------------------------------
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('73000000-0000-4000-8009-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'sennacherib','hezekiah','adversary','bidirectional','negative',4,'ended','sennacherib-besieges-jerusalem','sennacheribs-army-destroyed'),
(2,'hezekiah','manasseh-king-of-judah','family','source_to_target','neutral',3,'unknown',NULL,NULL),
(3,'manasseh-king-of-judah','josiah','family','source_to_target','neutral',2,'unknown',NULL,NULL),
(4,'huldah','josiah','mentor','source_to_target','positive',2,'ended','book-of-the-law-found-in-the-temple',NULL),
(5,'josiah','jehoiakim','family','source_to_target','neutral',2,'unknown',NULL,NULL),
(6,'josiah','zedekiah','family','source_to_target','neutral',2,'unknown',NULL,NULL),
(7,'jehoiakim','zedekiah','sibling','bidirectional','neutral',2,'unknown',NULL,NULL),
(8,'jehoiakim','jeremiah','adversary','source_to_target','negative',3,'ended','jehoiakim-burns-jeremiahs-scroll',NULL),
(9,'jeremiah','baruch','ally','bidirectional','positive',4,'unknown','jehoiakim-burns-jeremiahs-scroll',NULL),
(10,'ebed-melech','jeremiah','ally','source_to_target','positive',3,'ended','ebed-melech-rescues-jeremiah',NULL),
(11,'zedekiah','jeremiah','other','bidirectional','mixed',3,'ended','jeremiah-lowered-into-the-cistern',NULL),
(12,'nebuchadnezzar','zedekiah','adversary','source_to_target','negative',3,'ended',NULL,'zedekiah-captured-and-blinded'),
(13,'gedaliah','jeremiah','ally','source_to_target','positive',2,'ended',NULL,NULL),
(14,'shadrach','meshach','ally','bidirectional','positive',3,'unknown',NULL,NULL),
(15,'meshach','abednego','ally','bidirectional','positive',3,'unknown',NULL,NULL),
(16,'daniel','shadrach','ally','bidirectional','positive',3,'unknown',NULL,NULL),
(17,'nebuchadnezzar','belshazzar','family','source_to_target','neutral',2,'unknown',NULL,NULL),
(18,'darius-the-mede','daniel','ally','source_to_target','positive',3,'ended','daniel-in-the-lions-den',NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000005'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 10. GROUP MEMBERSHIP (existing groups only)
-- -------------------------------------------------------------------------
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g JOIN (VALUES
('judahite-court','manasseh-king-of-judah'),('judahite-court','josiah'),('judahite-court','jehoiakim'),
('judahite-court','zedekiah'),('judahite-court','gedaliah'),('judahite-court','baruch'),('judahite-court','ebed-melech'),
('prophetic-circle','huldah'),
('exile-court','shadrach'),('exile-court','meshach'),('exile-court','abednego'),
('exile-court','belshazzar'),('exile-court','darius-the-mede'),
('opposing-powers','sennacherib'),('opposing-powers','belshazzar')
) AS v(gslug,cslug)
ON g.slug=v.gslug JOIN characters c ON c.slug=v.cslug AND c.work_id=g.work_id
WHERE g.work_id='10000000-0000-4000-8000-000000000005' ON CONFLICT DO NOTHING;

COMMIT;
