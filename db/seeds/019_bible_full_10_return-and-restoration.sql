BEGIN;

-- =========================================================================
-- 019_bible_full_10_return-and-restoration.sql
-- Chapter K=10 slug='return-and-restoration' (Ezra–Nehemiah; Esther)
-- Adds 11 characters, 16 new events, relations, and reorders the
-- seven pre-existing events into the 10001-10999 sequence band.
-- Era window: 539-430 BCE. No new locations (reuses babylon, jerusalem, susa).
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('43000000-0000-4000-8010-000000000001','10000000-0000-4000-8000-000000000005','zerubbabel',1000,'male','adult','protagonist','unknown',NULL,NULL,'ruler',3),
('43000000-0000-4000-8010-000000000002','10000000-0000-4000-8000-000000000005','jeshua-the-high-priest',1001,'male','adult','supporting','unknown',NULL,NULL,'priest',2),
('43000000-0000-4000-8010-000000000003','10000000-0000-4000-8000-000000000005','haggai',1002,'male','adult','supporting','unknown',NULL,NULL,'prophet',2),
('43000000-0000-4000-8010-000000000004','10000000-0000-4000-8000-000000000005','zechariah-the-prophet',1003,'male','adult','supporting','unknown',NULL,NULL,'prophet',2),
('43000000-0000-4000-8010-000000000005','10000000-0000-4000-8000-000000000005','ahasuerus',1004,'male','adult','supporting','historical',-518,-465,'king',3),
('43000000-0000-4000-8010-000000000006','10000000-0000-4000-8000-000000000005','vashti',1005,'female','adult','supporting','unknown',NULL,NULL,'queen',2),
('43000000-0000-4000-8010-000000000007','10000000-0000-4000-8000-000000000005','haman',1006,'male','adult','antagonist','unknown',NULL,NULL,'person',3),
('43000000-0000-4000-8010-000000000008','10000000-0000-4000-8000-000000000005','ezra',1007,'male','adult','protagonist','unknown',NULL,NULL,'priest',3),
('43000000-0000-4000-8010-000000000009','10000000-0000-4000-8000-000000000005','artaxerxes',1008,'male','adult','supporting','historical',NULL,-424,'king',2),
('43000000-0000-4000-8010-000000000010','10000000-0000-4000-8000-000000000005','sanballat',1009,'male','adult','antagonist','historical',NULL,NULL,'ruler',2),
('43000000-0000-4000-8010-000000000011','10000000-0000-4000-8000-000000000005','tobiah',1010,'male','adult','antagonist','unknown',NULL,NULL,'person',2)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('zerubbabel','zh-CN','所罗巴伯','大卫王室的后裔，率首批被掳者从巴比伦归回的犹大省长。',ARRAY['撒拉铁之子'],'经文记载他是撒拉铁之子，受波斯委任治理犹大省，与大祭司耶书亚一同重筑祭坛、奠立圣殿根基，并在哈该与撒迦利亚的劝勉下完成第二圣殿。','带领归回的群体重建圣殿与家园。'),
('zerubbabel','en','Zerubbabel','A descendant of David’s royal line and governor of Judah who led the first company of exiles back from Babylon.',ARRAY['son of Shealtiel'],'The text names him son of Shealtiel, appointed governor of Judah under Persia; with the high priest Jeshua he rebuilds the altar, lays the temple foundation, and completes the Second Temple under the urging of Haggai and Zechariah.','To lead the returned community in rebuilding temple and homeland.'),
('jeshua-the-high-priest','zh-CN','耶书亚（大祭司）','归回时期的大祭司，与所罗巴伯共同主持重建工作。',ARRAY['约萨达之子约书亚'],'约萨达之子，随首批归回者回到耶路撒冷，主持重筑祭坛、恢复献祭，并与所罗巴伯一同奠立并完成第二圣殿。','恢复祭司职任与圣殿敬拜。'),
('jeshua-the-high-priest','en','Jeshua the high priest','The high priest of the return era, who directed the rebuilding alongside Zerubbabel.',ARRAY['Joshua son of Jozadak'],'Son of Jozadak, he returns with the first company, presides over the rebuilt altar and restored sacrifices, and joins Zerubbabel in founding and completing the Second Temple.','To restore the priesthood and temple worship.'),
('haggai','zh-CN','哈该','归回时期的先知，劝勉停工多年的民众恢复重建圣殿。',ARRAY[]::text[],'以斯拉记记载他与撒迦利亚一同说预言，责备民众只顾自己的房屋而任凭圣殿荒凉，促使所罗巴伯与耶书亚重新动工。','激励民众以圣殿为先。'),
('haggai','en','Haggai','A prophet of the return era who urged the people to resume the long-halted rebuilding of the temple.',ARRAY[]::text[],'The book of Ezra records him prophesying alongside Zechariah, rebuking the people for tending their own houses while the temple lay waste, and stirring Zerubbabel and Jeshua back to work.','To rouse the people to put the temple first.'),
('zechariah-the-prophet','zh-CN','撒迦利亚（先知）','易多的子孙，与哈该同时代的先知，以夜间异象劝勉重建。',ARRAY['易多之孙'],'与哈该一同在大流士年间说预言，其书卷以一连串夜间异象鼓励所罗巴伯：“不是倚靠势力，乃是倚靠我的灵。”','以异象坚固重建者的信心。'),
('zechariah-the-prophet','en','Zechariah the prophet','A descendant of Iddo and contemporary of Haggai, who encouraged the rebuilding through night visions.',ARRAY['grandson of Iddo'],'Prophesying with Haggai in the days of Darius, his book strengthens Zerubbabel through a series of night visions: not by might, nor by power, but by the spirit.','To strengthen the builders through visions.'),
('ahasuerus','zh-CN','亚哈随鲁','以斯帖记中的波斯王，通常被认同为薛西斯一世。',ARRAY['薛西斯一世'],'统治从印度直到古实一百二十七省的波斯王，废黜瓦实提后立以斯帖为后；他先批准哈曼的灭族之令，后又允许犹太人自卫。','彰显帝国的威荣与权柄。'),
('ahasuerus','en','Ahasuerus','The Persian king of the book of Esther, commonly identified with Xerxes I.',ARRAY['Xerxes I'],'Ruler of 127 provinces from India to Cush, he deposes Vashti and makes Esther queen; he first authorizes Haman’s decree of destruction and later permits the Jews to defend themselves.','To display the splendor and power of his empire.'),
('vashti','zh-CN','瓦实提','亚哈随鲁的王后，因拒绝赴王的筵席而被废。',ARRAY[]::text[],'王在筵席上召她戴冠出席以显其美貌，她拒绝前来；群臣建议将她废黜，以免各家妇人效法藐视丈夫。','守住自己的尊严。'),
('vashti','en','Vashti','Queen of Ahasuerus, deposed for refusing to appear at the king’s banquet.',ARRAY[]::text[],'Summoned to display her beauty wearing the royal crown, she refuses to come; the counselors advise her removal lest wives across the realm despise their husbands.','To keep her own dignity.'),
('haman','zh-CN','哈曼','亚甲族哈米大他之子，谋划灭绝波斯全境犹太人的宰相。',ARRAY['哈米大他之子'],'被亚哈随鲁抬举高过众臣，因末底改不向他跪拜而怒，掣普珥（即签）定日，图谋灭绝通国的犹太人，终被挂在自己所立的木架上。','以灭族之谋报复末底改的不敬。'),
('haman','en','Haman','Son of Hammedatha the Agagite, the vizier who plotted to destroy all the Jews of Persia.',ARRAY['son of Hammedatha'],'Exalted by Ahasuerus above all the officials, he is enraged when Mordecai will not bow, casts pur (the lot) to fix a day, and schemes to annihilate the Jews of the whole realm, until he is hanged on the gallows he built.','To avenge Mordecai’s slight through genocide.'),
('ezra','zh-CN','以斯拉','精通摩西律法的文士与祭司，率第二批归回者并教导律法。',ARRAY[]::text[],'亚伦的后裔，蒙亚达薛西王降旨资助，率领第二批归回者从巴比伦上耶路撒冷；他定志考究、遵行并教导律法，后在水门前向全民宣读律法书。','使归回的群体按律法而活。'),
('ezra','en','Ezra','A scribe and priest skilled in the law of Moses, who led the second return and taught the law.',ARRAY[]::text[],'A descendant of Aaron, commissioned and funded by decree of Artaxerxes, he leads a second company from Babylon to Jerusalem; devoted to studying, keeping, and teaching the law, he later reads it aloud before the Water Gate.','To shape the restored community by the law.'),
('artaxerxes','zh-CN','亚达薛西','波斯王，先后准许以斯拉与尼希米返回耶路撒冷。',ARRAY['亚达薛西一世'],'薛西斯之子，降旨差遣文士以斯拉携带资财归回；后又允准酒政尼希米回去重建耶路撒冷城墙，并供应所需的木料。','借扶持属地各族安定帝国。'),
('artaxerxes','en','Artaxerxes','The Persian king who authorized the returns of both Ezra and Nehemiah to Jerusalem.',ARRAY['Artaxerxes I'],'Son of Xerxes, he issues a decree sending the scribe Ezra back with resources, and later grants his cupbearer Nehemiah leave to rebuild Jerusalem’s wall, supplying timber for the work.','To secure his empire by supporting its peoples.'),
('sanballat','zh-CN','参巴拉','和伦人，撒玛利亚一带的权贵，尼希米筑墙工程的主要反对者。',ARRAY['和伦人参巴拉'],'域外文献亦提及其名。他听见有人来为以色列人求好处便大大恼怒，与多比雅等人讥诮、恐吓筑墙的人，又设计诱骗尼希米出城相会。','阻止耶路撒冷重新强固。'),
('sanballat','en','Sanballat','The Horonite, a magnate of the Samaria region and chief opponent of Nehemiah’s wall.',ARRAY['Sanballat the Horonite'],'His name is also attested outside the Bible. Grieved that someone had come to seek the welfare of Israel, he mocks and threatens the builders with Tobiah and schemes to lure Nehemiah out of the city.','To keep Jerusalem from growing strong again.'),
('tobiah','zh-CN','多比雅','亚扪人臣仆，与参巴拉联手讥诮并阻挠筑墙。',ARRAY['亚扪人多比雅'],'讥诮说狐狸上去也能踩塌他们的石墙，又借与犹大贵胄联姻的关系在城内通风报信；尼希米后来把他安置在圣殿院内的屋子清理出去。','借人脉与讥诮瓦解筑墙的士气。'),
('tobiah','en','Tobiah','The Ammonite official who joined Sanballat in mocking and hindering the wall.',ARRAY['Tobiah the Ammonite'],'He scoffs that even a fox would break down their stone wall, and works his marriage ties with Judean nobles to pass intelligence from inside; Nehemiah later throws his furnishings out of the temple chamber.','To break the builders’ morale through ties and scorn.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. LOCATIONS -- none new; reuses babylon, jerusalem, susa
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- 3. EVENTS (new) -- chapter 'return-and-restoration', 539-430 BCE band
-- -------------------------------------------------------------------------
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('63000000-0000-4000-8010-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'unknown'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'zerubbabel-leads-first-return',10003,'reported_historical','journey','range',-539,-500,'medium','return-and-restoration'),
(2,'altar-rebuilt-at-jerusalem',10007,'reported_historical','religious','range',-538,-500,'medium','return-and-restoration'),
(3,'temple-foundation-laid',10009,'reported_historical','religious','range',-537,-500,'medium','return-and-restoration'),
(4,'samaritan-opposition-halts-work',10011,'reported_historical','political','range',-536,-490,'low','return-and-restoration'),
(5,'haggai-and-zechariah-urge-rebuilding',10013,'reported_historical','religious','range',-525,-490,'medium','return-and-restoration'),
(6,'vashti-deposed-at-susa',10017,'contested','political','range',-500,-460,'low','return-and-restoration'),
(7,'haman-plots-destruction-of-the-jews',10023,'contested','betrayal','range',-495,-455,'low','return-and-restoration'),
(8,'haman-executed',10027,'contested','death','range',-493,-455,'low','return-and-restoration'),
(9,'purim-established',10029,'contested','social','range',-490,-450,'low','return-and-restoration'),
(10,'ezra-leads-second-return',10031,'reported_historical','journey','range',-470,-430,'medium','return-and-restoration'),
(11,'nehemiah-petitions-artaxerxes',10033,'reported_historical','political','range',-468,-430,'medium','return-and-restoration'),
(12,'nehemiah-inspects-walls-by-night',10035,'reported_historical','discovery','range',-466,-430,'low','return-and-restoration'),
(13,'sanballat-and-tobiah-oppose-the-work',10037,'reported_historical','political','range',-465,-430,'low','return-and-restoration'),
(14,'wall-completed-in-fifty-two-days',10041,'reported_historical','political','range',-463,-430,'medium','return-and-restoration'),
(15,'ezra-reads-law-at-water-gate',10043,'reported_historical','religious','range',-462,-430,'medium','return-and-restoration'),
(16,'dedication-of-the-jerusalem-wall',10045,'reported_historical','religious','range',-461,-430,'low','return-and-restoration')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,conf,chapter_slug)
JOIN chapters ch ON ch.slug=v.chapter_slug AND ch.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 4. Reorder existing return-and-restoration events into the 10001-10999 band
-- -------------------------------------------------------------------------
UPDATE events e SET sequence=v.seq FROM (VALUES
  ('cyrus-permits-return',10001),
  ('first-returnees-reach-jerusalem',10005),
  ('second-temple-rebuilt',10015),
  ('esther-becomes-queen-at-susa',10019),
  ('mordecai-refuses-to-bow',10021),
  ('esther-intervenes-at-court',10025),
  ('nehemiah-rebuilds-the-wall',10039)
) AS v(slug,seq) WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug=v.slug;

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tlabel FROM events e JOIN (VALUES
('zerubbabel-leads-first-return','zh-CN','所罗巴伯率首批归回','古列降旨后，所罗巴伯与耶书亚率约四万余名被掳者启程离开巴比伦。','以斯拉记记载归回者按家谱清点，携带古列交还的圣殿金银器皿上路。','七十年被掳生涯结束，归回叙事正式开启。','约公元前 539–500 年'),
('zerubbabel-leads-first-return','en','Zerubbabel leads the first return','After Cyrus’s decree, Zerubbabel and Jeshua set out from Babylon with some forty thousand exiles.','Ezra records the returnees counted by family registers, carrying the temple vessels of gold and silver that Cyrus restored.','The end of the seventy years of exile and the formal opening of the return narrative.','c. 539–500 BCE'),
('altar-rebuilt-at-jerusalem','zh-CN','在耶路撒冷重筑祭坛','耶书亚与所罗巴伯在原处重筑祭坛，恢复早晚的燔祭。','众民因惧怕四围的民而聚集，仍在圣殿根基未立之先守住棚节、恢复献祭。','敬拜先于建筑恢复，标志群体生活的重新开始。','约公元前 538–500 年'),
('altar-rebuilt-at-jerusalem','en','The altar rebuilt at Jerusalem','Jeshua and Zerubbabel rebuild the altar on its old site and restore the daily burnt offerings.','Though in fear of the surrounding peoples, the community keeps the Festival of Booths and resumes sacrifice before any foundation is laid.','Worship precedes construction, marking the restart of communal life.','c. 538–500 BCE'),
('temple-foundation-laid','zh-CN','圣殿根基奠立，老人哭泣','匠人立殿根基时，众人欢呼，见过旧殿的老人却放声大哭。','祭司吹号、利未人击钹赞美；哭号与欢呼相混，声音远闻，分不出彼此。','新旧对照成为归回时代最著名的画面之一。','约公元前 537–500 年'),
('temple-foundation-laid','en','The temple foundation laid, the elders weep','As the builders lay the foundation, the people shout for joy, but elders who had seen the first house weep aloud.','Priests sound trumpets and Levites cymbals; weeping and shouting mingle so that the sound carries far and cannot be told apart.','The contrast of old and new becomes one of the era’s most famous scenes.','c. 537–500 BCE'),
('samaritan-opposition-halts-work','zh-CN','撒玛利亚人阻挠，工程停顿','当地的敌人先求同建被拒，随即贿买谋士、上本控告，使圣殿工程停止多年。','以斯拉记记载这地的民使犹大人的手发软，扰乱他们，工程直到大流士年间才复工。','解释了圣殿完工迟延近二十年的缘由。','约公元前 536–490 年'),
('samaritan-opposition-halts-work','en','Samarian opposition halts the work','Refused a share in the building, adversaries of the land hire counselors and lodge accusations, halting the temple work for years.','Ezra records that the people of the land weakened the hands of Judah and troubled them, so the work ceased until the reign of Darius.','Explains the nearly twenty-year delay before the temple’s completion.','c. 536–490 BCE'),
('haggai-and-zechariah-urge-rebuilding','zh-CN','哈该与撒迦利亚劝勉复工','两位先知奉名说预言，责备民众任凭圣殿荒凉，所罗巴伯与耶书亚随即复工。','以斯拉记五至六章记载先知与他们同在帮助他们，河西总督查问也未能拦阻，大流士降旨准建。','先知的话语成为第二圣殿得以完工的转折点。','约公元前 525–490 年'),
('haggai-and-zechariah-urge-rebuilding','en','Haggai and Zechariah urge the rebuilding','The two prophets prophesy against the neglect of the ruined temple, and Zerubbabel and Jeshua resume the work at once.','Ezra 5–6 records the prophets standing with the builders; the governor’s inquiry cannot stop them, and Darius decrees the work go on.','The prophetic word becomes the turning point that brings the Second Temple to completion.','c. 525–490 BCE'),
('vashti-deposed-at-susa','zh-CN','瓦实提被废','亚哈随鲁在书珊设宴一百八十日，王后瓦实提拒绝奉召出席而被废。','群臣进言，恐各省妇人效法藐视丈夫，遂降旨废后并通告全国。','为以斯帖入宫为后腾出了位置，开启以斯帖记的叙事。','约公元前 500–460 年'),
('vashti-deposed-at-susa','en','Vashti deposed at Susa','During Ahasuerus’s 180-day banquet at Susa, Queen Vashti refuses the royal summons and is deposed.','The counselors warn that wives across the provinces will despise their husbands, so a decree removes her and is published through the realm.','Opens the book of Esther by clearing the way for Esther to become queen.','c. 500–460 BCE'),
('haman-plots-destruction-of-the-jews','zh-CN','哈曼定灭族之谋','哈曼因末底改不跪不拜，掣普珥定日，求王降旨灭绝通国所有的犹太人。','他以一族律例与众不同为由说动王，文书盖上王的戒指印，传遍一百二十七省。','危机全面展开，成为以斯帖挺身而出的背景。','约公元前 495–455 年'),
('haman-plots-destruction-of-the-jews','en','Haman plots the destruction of the Jews','Enraged that Mordecai will neither kneel nor bow, Haman casts pur to fix a day and obtains a royal decree to destroy all the Jews.','Arguing that one people keeps laws different from every other, he persuades the king; the edict, sealed with the royal ring, goes out to 127 provinces.','The crisis unfolds in full, setting the stage for Esther’s intervention.','c. 495–455 BCE'),
('haman-executed','zh-CN','哈曼被处决','以斯帖在第二次筵席上指明哈曼是仇敌，王命将他挂在他为末底改所立的木架上。','王怒极离席又返，见哈曼伏在王后榻前求情，怒不可遏；哈曼遂被挂于五丈高的木架。','恶谋反噬其身，成为以斯帖记逆转的顶点。','约公元前 493–455 年'),
('haman-executed','en','Haman executed','At the second banquet Esther names Haman as the enemy, and the king orders him hanged on the gallows he built for Mordecai.','The king storms out and returns to find Haman fallen on the queen’s couch pleading; Haman is hanged on the fifty-cubit gallows.','The plot recoils on its maker, the peak of the book’s great reversal.','c. 493–455 BCE'),
('purim-established','zh-CN','普珥节设立','末底改与以斯帖传谕各省，定亚达月十四、十五两日为普珥节，世代守为欢宴的日子。','因哈曼曾掣普珥要灭绝犹太人，这两日反成为犹太人脱离仇敌、转忧为喜的纪念。','以斯帖记的叙事由此落定为一个延续至今的节期。','约公元前 490–450 年'),
('purim-established','en','Purim established','Mordecai and Esther send letters fixing the fourteenth and fifteenth of Adar as Purim, days of feasting kept through the generations.','Because Haman had cast pur to destroy the Jews, the days commemorate deliverance from enemies and sorrow turned to joy.','The narrative settles into a festival still observed today.','c. 490–450 BCE'),
('ezra-leads-second-return','zh-CN','以斯拉率第二批归回','文士以斯拉奉亚达薛西王的谕旨，率第二批归回者携资财从巴比伦上耶路撒冷。','他在亚哈瓦河边宣告禁食，不求兵丁护送，四个月后平安抵达；他定志考究、遵行并教导律法。','律法教师的归来使重建从城墙圣殿延伸到群体的内在生活。','约公元前 470–430 年'),
('ezra-leads-second-return','en','Ezra leads the second return','By decree of Artaxerxes, the scribe Ezra leads a second company with treasure from Babylon up to Jerusalem.','He proclaims a fast at the Ahava canal, declining an armed escort, and arrives safely after four months, devoted to studying, keeping, and teaching the law.','The teacher’s return extends restoration from walls and temple to the community’s inner life.','c. 470–430 BCE'),
('nehemiah-petitions-artaxerxes','zh-CN','尼希米求告亚达薛西','酒政尼希米闻耶路撒冷城墙拆毁、城门被火焚烧，在王面前面带愁容，求王差遣他回去重建。','他默祷后开口，王允其所求，赐诏书与园林木料；他遂被立为犹大省长。','宫廷中的一次对话成为城墙重建的起点。','约公元前 468–430 年'),
('nehemiah-petitions-artaxerxes','en','Nehemiah petitions Artaxerxes','Hearing that Jerusalem’s wall is broken and its gates burned, the cupbearer Nehemiah appears sad before the king and asks leave to rebuild.','After a silent prayer he speaks; the king grants letters and timber from the royal forest, and Nehemiah becomes governor of Judah.','A single court conversation becomes the starting point of the wall’s rebuilding.','c. 468–430 BCE'),
('nehemiah-inspects-walls-by-night','zh-CN','尼希米夜巡城墙','尼希米抵达三日后，趁夜带少数人巡查破损的城墙与被焚的城门。','他未将所要行的事告诉任何人，察看后召聚众人说：“来吧，我们重建耶路撒冷的城墙。”','谨慎的夜巡奠定了动员全城分段筑墙的方案。','约公元前 466–430 年'),
('nehemiah-inspects-walls-by-night','en','Nehemiah inspects the walls by night','Three days after arriving, Nehemiah rides out by night with a few men to survey the broken wall and burned gates.','Telling no one what he intends, he completes the survey and then summons the people: come, let us rebuild the wall of Jerusalem.','The careful night ride lays the plan for mobilizing the whole city section by section.','c. 466–430 BCE'),
('sanballat-and-tobiah-oppose-the-work','zh-CN','参巴拉与多比雅的抵挡','参巴拉与多比雅讥诮筑墙的人，继而联合列邦图谋攻击，又设计诱骗尼希米停工。','建造的人一手做工、一手拿兵器；尼希米识破阴谋，答复说：“我现在办理大工，不能下去。”','外部的威吓反而凸显了筑墙群体的坚韧。','约公元前 465–430 年'),
('sanballat-and-tobiah-oppose-the-work','en','Sanballat and Tobiah oppose the work','Sanballat and Tobiah mock the builders, then conspire with neighboring peoples to attack and scheme to lure Nehemiah away.','The builders work with one hand and hold weapons with the other; Nehemiah sees through the plot: I am doing a great work and cannot come down.','The external threats only underline the builders’ resolve.','c. 465–430 BCE'),
('wall-completed-in-fifty-two-days','zh-CN','城墙五十二天完工','以禄月二十五日，耶路撒冷城墙历时五十二天修完。','尼希米记记载仇敌听见就惧怕愁眉，因知这工作是出于神；各族百姓按段承建，各修对着自己房屋的一段。','残破近一个半世纪的城防得以恢复，归回群体重获安全。','约公元前 463–430 年'),
('wall-completed-in-fifty-two-days','en','The wall completed in fifty-two days','On the twenty-fifth of Elul the wall of Jerusalem is finished after fifty-two days.','Nehemiah records that the enemies lost heart, perceiving the work was of God; families had each built the stretch facing their own houses.','Defenses ruined for nearly a century and a half are restored, and the community regains safety.','c. 463–430 BCE'),
('ezra-reads-law-at-water-gate','zh-CN','水门前宣读律法','众民如同一人聚集在水门前的宽阔处，以斯拉从清早到晌午宣读律法书。','利未人讲明意思使百姓明白；众民听见律法书上的话都哭了，尼希米却说这日是圣日，去吃肥美的、喝甘甜的。','公开诵读与讲解律法成为会堂传统的雏形。','约公元前 462–430 年'),
('ezra-reads-law-at-water-gate','en','Ezra reads the law before the Water Gate','The people gather as one in the square before the Water Gate, and Ezra reads the book of the law from dawn to midday.','Levites give the sense so the people understand; hearing the words they weep, but Nehemiah bids them eat the fat and drink the sweet, for the day is holy.','The public reading and exposition of the law foreshadows the synagogue tradition.','c. 462–430 BCE'),
('dedication-of-the-jerusalem-wall','zh-CN','耶路撒冷城墙告成礼','两队称谢的人在城墙上相向而行，会合于圣殿，欢呼歌唱行告成之礼。','尼希米记记载众人大大欢乐，妇女孩童也都欢乐，耶路撒冷的欢声听到远处。','重建叙事在称谢的行进中落幕，城与圣殿重新连为一体。','约公元前 461–430 年'),
('dedication-of-the-jerusalem-wall','en','Dedication of the Jerusalem wall','Two great choirs of thanksgiving march in opposite directions along the wall and meet at the temple with song.','Nehemiah records great rejoicing, women and children among them, so that the joy of Jerusalem was heard far away.','The rebuilding narrative closes in a procession of thanks, city and temple joined again.','c. 461–430 BCE')
) AS v(slug,locale,title,summary,detail,sig,tlabel) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS (reuse babylon, jerusalem, susa)
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('zerubbabel-leads-first-return','babylon'),
('altar-rebuilt-at-jerusalem','jerusalem'),
('temple-foundation-laid','jerusalem'),
('samaritan-opposition-halts-work','jerusalem'),
('haggai-and-zechariah-urge-rebuilding','jerusalem'),
('vashti-deposed-at-susa','susa'),
('haman-plots-destruction-of-the-jews','susa'),
('haman-executed','susa'),
('purim-established','susa'),
('ezra-leads-second-return','babylon'),
('nehemiah-petitions-artaxerxes','susa'),
('nehemiah-inspects-walls-by-night','jerusalem'),
('sanballat-and-tobiah-oppose-the-work','jerusalem'),
('wall-completed-in-fifty-two-days','jerusalem'),
('ezra-reads-law-at-water-gate','jerusalem'),
('dedication-of-the-jerusalem-wall','jerusalem')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS (reuse cyrus, esther, mordecai, nehemiah)
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('zerubbabel-leads-first-return','zerubbabel',0),('zerubbabel-leads-first-return','jeshua-the-high-priest',1),('zerubbabel-leads-first-return','cyrus',2),
('altar-rebuilt-at-jerusalem','jeshua-the-high-priest',0),('altar-rebuilt-at-jerusalem','zerubbabel',1),
('temple-foundation-laid','zerubbabel',0),('temple-foundation-laid','jeshua-the-high-priest',1),
('samaritan-opposition-halts-work','zerubbabel',0),('samaritan-opposition-halts-work','jeshua-the-high-priest',1),
('haggai-and-zechariah-urge-rebuilding','haggai',0),('haggai-and-zechariah-urge-rebuilding','zechariah-the-prophet',1),('haggai-and-zechariah-urge-rebuilding','zerubbabel',2),('haggai-and-zechariah-urge-rebuilding','jeshua-the-high-priest',3),
('vashti-deposed-at-susa','vashti',0),('vashti-deposed-at-susa','ahasuerus',1),
('haman-plots-destruction-of-the-jews','haman',0),('haman-plots-destruction-of-the-jews','ahasuerus',1),('haman-plots-destruction-of-the-jews','mordecai',2),
('haman-executed','haman',0),('haman-executed','ahasuerus',1),('haman-executed','esther',2),
('purim-established','mordecai',0),('purim-established','esther',1),
('ezra-leads-second-return','ezra',0),('ezra-leads-second-return','artaxerxes',1),
('nehemiah-petitions-artaxerxes','nehemiah',0),('nehemiah-petitions-artaxerxes','artaxerxes',1),
('nehemiah-inspects-walls-by-night','nehemiah',0),
('sanballat-and-tobiah-oppose-the-work','sanballat',0),('sanballat-and-tobiah-oppose-the-work','tobiah',1),('sanballat-and-tobiah-oppose-the-work','nehemiah',2),
('wall-completed-in-fifty-two-days','nehemiah',0),('wall-completed-in-fifty-two-days','sanballat',1),('wall-completed-in-fifty-two-days','tobiah',2),
('ezra-reads-law-at-water-gate','ezra',0),('ezra-reads-law-at-water-gate','nehemiah',1),
('dedication-of-the-jerusalem-wall','nehemiah',0),('dedication-of-the-jerusalem-wall','ezra',1)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES (Ezra / Esther / Nehemiah, per event)
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Ezra'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('zerubbabel-leads-first-return','altar-rebuilt-at-jerusalem','temple-foundation-laid',
 'samaritan-opposition-halts-work','haggai-and-zechariah-urge-rebuilding','ezra-leads-second-return')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Esther'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('vashti-deposed-at-susa','haman-plots-destruction-of-the-jews','haman-executed','purim-established')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Nehemiah'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('nehemiah-petitions-artaxerxes','nehemiah-inspects-walls-by-night','sanballat-and-tobiah-oppose-the-work',
 'wall-completed-in-fifty-two-days','ezra-reads-law-at-water-gate','dedication-of-the-jerusalem-wall')
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS
-- -------------------------------------------------------------------------
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('73000000-0000-4000-8010-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'ahasuerus','vashti','spouse','bidirectional','mixed',3,'ended',NULL,'vashti-deposed-at-susa'),
(2,'ahasuerus','esther','spouse','bidirectional','mixed',3,'unknown','esther-becomes-queen-at-susa',NULL),
(3,'haman','mordecai','adversary','bidirectional','negative',4,'ended','mordecai-refuses-to-bow','haman-executed'),
(4,'haman','esther','adversary','bidirectional','negative',4,'ended','haman-plots-destruction-of-the-jews','haman-executed'),
(5,'ahasuerus','haman','ally','bidirectional','mixed',3,'changed',NULL,'haman-executed'),
(6,'zerubbabel','jeshua-the-high-priest','ally','bidirectional','positive',4,'unknown','zerubbabel-leads-first-return',NULL),
(7,'haggai','zerubbabel','mentor','source_to_target','positive',3,'unknown','haggai-and-zechariah-urge-rebuilding',NULL),
(8,'zechariah-the-prophet','zerubbabel','mentor','source_to_target','positive',3,'unknown','haggai-and-zechariah-urge-rebuilding',NULL),
(9,'artaxerxes','ezra','ally','source_to_target','positive',3,'unknown','ezra-leads-second-return',NULL),
(10,'artaxerxes','nehemiah','ally','source_to_target','positive',3,'unknown','nehemiah-petitions-artaxerxes',NULL),
(11,'sanballat','nehemiah','adversary','bidirectional','negative',4,'unknown','sanballat-and-tobiah-oppose-the-work',NULL),
(12,'tobiah','nehemiah','adversary','bidirectional','negative',3,'unknown','sanballat-and-tobiah-oppose-the-work',NULL),
(13,'sanballat','tobiah','ally','bidirectional','positive',3,'unknown',NULL,NULL),
(14,'ezra','nehemiah','ally','bidirectional','positive',3,'unknown','ezra-reads-law-at-water-gate',NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000005'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 10. GROUP MEMBERSHIP (existing groups persian-court, opposing-powers,
--     prophetic-circle)
-- -------------------------------------------------------------------------
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g JOIN (VALUES
('persian-court','ahasuerus'),('persian-court','vashti'),('persian-court','haman'),('persian-court','artaxerxes'),
('opposing-powers','sanballat'),('opposing-powers','tobiah'),
('prophetic-circle','haggai'),('prophetic-circle','zechariah-the-prophet')
) AS v(gslug,cslug)
ON g.slug=v.gslug JOIN characters c ON c.slug=v.cslug AND c.work_id=g.work_id
WHERE g.work_id='10000000-0000-4000-8000-000000000005' ON CONFLICT DO NOTHING;

COMMIT;
