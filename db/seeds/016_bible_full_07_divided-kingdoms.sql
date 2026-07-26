BEGIN;

-- =========================================================================
-- 016_bible_full_07_divided-kingdoms.sql
-- Chapter K=07 slug='divided-kingdoms' (1 Kings 12 - 2 Kings 17), era -930..-722
-- Adds 15 characters, 4 locations, 18 new events, relations, and reorders
-- the ten pre-existing divided-kingdoms events into the 7001-7999 band.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('43000000-0000-4000-8007-000000000001','10000000-0000-4000-8000-000000000005','shishak',700,'male','adult','antagonist','historical',NULL,NULL,'king',2),
('43000000-0000-4000-8007-000000000002','10000000-0000-4000-8000-000000000005','omri',701,'male','adult','supporting','historical',NULL,NULL,'king',3),
('43000000-0000-4000-8007-000000000003','10000000-0000-4000-8000-000000000005','jehoshaphat',702,'male','adult','supporting','unknown',NULL,NULL,'king',3),
('43000000-0000-4000-8007-000000000004','10000000-0000-4000-8000-000000000005','ben-hadad',703,'male','adult','antagonist','historical',NULL,NULL,'king',2),
('43000000-0000-4000-8007-000000000005','10000000-0000-4000-8000-000000000005','micaiah',704,'male','adult','supporting','unknown',NULL,NULL,'prophet',2),
('43000000-0000-4000-8007-000000000006','10000000-0000-4000-8000-000000000005','widow-of-zarephath',705,'female','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8007-000000000007','10000000-0000-4000-8000-000000000005','naaman',706,'male','adult','supporting','unknown',NULL,NULL,'soldier',3),
('43000000-0000-4000-8007-000000000008','10000000-0000-4000-8000-000000000005','gehazi',707,'male','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8007-000000000009','10000000-0000-4000-8000-000000000005','shunammite-woman',708,'female','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8007-000000000010','10000000-0000-4000-8000-000000000005','jehu',709,'male','adult','supporting','historical',NULL,NULL,'king',3),
('43000000-0000-4000-8007-000000000011','10000000-0000-4000-8000-000000000005','athaliah',710,'female','adult','antagonist','unknown',NULL,NULL,'queen',3),
('43000000-0000-4000-8007-000000000012','10000000-0000-4000-8000-000000000005','joash-of-judah',711,'male','child','supporting','unknown',NULL,NULL,'king',2),
('43000000-0000-4000-8007-000000000013','10000000-0000-4000-8000-000000000005','jehoiada-the-priest',712,'male','elder','supporting','unknown',NULL,NULL,'priest',2),
('43000000-0000-4000-8007-000000000014','10000000-0000-4000-8000-000000000005','hazael',713,'male','adult','antagonist','historical',NULL,NULL,'king',3),
('43000000-0000-4000-8007-000000000015','10000000-0000-4000-8000-000000000005','jeroboam-ii',714,'male','adult','supporting','historical',NULL,NULL,'king',3)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('shishak','zh-CN','示撒','埃及王，在罗波安年间上来攻取耶路撒冷。',ARRAY[]::text[],'一般认作埃及第二十二王朝法老舍顺克一世。罗波安第五年，他率军上来攻打耶路撒冷，夺去耶和华殿和王宫里的宝物，包括所罗门制造的金盾牌。','扩张埃及在迦南地区的势力并夺取财富。'),
('shishak','en','Shishak','The king of Egypt who attacked Jerusalem in the days of Rehoboam.',ARRAY[]::text[],'Commonly identified with Pharaoh Shoshenq I of the Twenty-second Dynasty. In Rehoboam’s fifth year he came up against Jerusalem and carried off the treasures of the temple and the palace, including the golden shields Solomon had made.','To extend Egypt’s power into Canaan and seize its wealth.'),
('omri','zh-CN','暗利','北国以色列的国王，建造撒玛利亚为新都。',ARRAY[]::text[],'原为军长，在内乱中胜出登基；他用二他连得银子向撒玛买下山冈，建城并起名撒玛利亚，立为北国的京城，又为其子亚哈聘娶西顿公主耶洗别。','巩固王朝并为北国建立稳固的都城。'),
('omri','en','Omri','King of the northern kingdom of Israel, builder of Samaria as its new capital.',ARRAY[]::text[],'A commander who prevailed in civil strife to take the throne; he bought the hill of Samaria from Shemer for two talents of silver, built his capital there, and arranged his son Ahab’s marriage to the Sidonian princess Jezebel.','To secure his dynasty and give the northern kingdom a lasting capital.'),
('jehoshaphat','zh-CN','约沙法','犹大王，与北国的亚哈结盟，同上基列的拉末争战。',ARRAY[]::text[],'亚撒之子，经文称他行耶和华眼中看为正的事；他与亚哈家联姻结盟，战前坚持先求问耶和华的先知，米该雅因此被召来；基列的拉末之战中他一度被误认为以色列王，险遭围杀。','在结盟与敬虔之间维系犹大的安稳。'),
('jehoshaphat','en','Jehoshaphat','King of Judah, allied with Ahab of Israel in the campaign at Ramoth-gilead.',ARRAY[]::text[],'Son of Asa, described as doing right in the eyes of the Lord; bound to Ahab’s house by marriage alliance, he insisted on consulting a prophet of the Lord before battle, which brought Micaiah forward; at Ramoth-gilead he was nearly killed when mistaken for the king of Israel.','To keep Judah secure between alliance and piety.'),
('ben-hadad','zh-CN','便哈达','亚兰王，多次与以色列争战，曾围困撒玛利亚。',ARRAY[]::text[],'大马士革的亚兰王，率三十二个王围攻撒玛利亚，两度被亚哈击败后立约；后来病中差哈薛去求问以利沙，反被哈薛闷死篡位。','确立亚兰对以色列的支配地位。'),
('ben-hadad','en','Ben-hadad','The king of Aram who repeatedly fought Israel and besieged Samaria.',ARRAY[]::text[],'King of Aram-Damascus, he besieged Samaria with thirty-two allied kings and was twice defeated by Ahab before making a treaty; later, while ill, he sent Hazael to consult Elisha and was smothered by him.','To assert Aram’s dominance over Israel.'),
('micaiah','zh-CN','米该雅','音拉的儿子，敢于向亚哈预言败亡的先知。',ARRAY[]::text[],'当四百名先知齐声预言得胜时，他先以讥讽附和，随后讲出所见的异象：以色列民散在山上，如同没有牧人的羊；又述说谎言的灵入了众先知的口。他因此被掌掴并下在监里。','耶和华对他说什么，他就说什么。'),
('micaiah','en','Micaiah','The son of Imlah, the prophet who dared to foretell Ahab’s defeat.',ARRAY[]::text[],'While four hundred prophets promised victory, he first echoed them in irony, then told his vision of Israel scattered on the hills like sheep without a shepherd, and of a lying spirit in the prophets’ mouths; for this he was struck and imprisoned.','To speak only what the Lord says to him.'),
('widow-of-zarephath','zh-CN','撒勒法的寡妇','西顿地撒勒法的寡妇，在饥荒中供养以利亚。',ARRAY[]::text[],'饥荒中她只剩一把面、一点油，正拾柴要做最后一餐；以利亚求她先为自己做饼，坛内的面和瓶里的油果然不减少；后来她的儿子病死，以利亚使孩子复活。','在绝境中养活自己和儿子。'),
('widow-of-zarephath','en','The widow of Zarephath','The widow at Zarephath in Sidon who sustained Elijah through the famine.',ARRAY[]::text[],'Down to a handful of flour and a little oil, she was gathering sticks for a last meal when Elijah asked her to feed him first; the jar of flour and jug of oil did not fail, and when her son died Elijah restored him to life.','To keep herself and her son alive through the famine.'),
('naaman','zh-CN','乃缦','亚兰王的元帅，长大麻风，在约旦河沐浴七回得洁净。',ARRAY[]::text[],'大能的勇士却患麻风；因掳来的以色列小女子指点，他带着礼物往以色列求医；起初不肯在约旦河沐浴，经仆人劝说后照以利沙的话行，肉复原好像小孩子的肉。','求得医治，并归认以色列的神。'),
('naaman','en','Naaman','The commander of the army of Aram, healed of leprosy by washing seven times in the Jordan.',ARRAY[]::text[],'A mighty warrior afflicted with leprosy, he sought healing in Israel at the word of a captive Israelite girl; at first he scorned the Jordan, but at his servants’ urging he washed as Elisha directed, and his flesh was restored like that of a child.','To be healed, and afterward to honor the God of Israel.'),
('gehazi','zh-CN','基哈西','以利沙的仆人，因贪取乃缦的礼物染上麻风。',ARRAY[]::text[],'在书念妇人的事上作以利沙的传话人；乃缦得医治后，他私下追去谎称主人需要银子和衣裳，回来又向以利沙隐瞒，乃缦的大麻风就沾染了他。','贪图不属自己的财物。'),
('gehazi','en','Gehazi','Elisha’s servant, struck with leprosy after coveting Naaman’s gifts.',ARRAY[]::text[],'He served as Elisha’s messenger in the Shunammite’s story; after Naaman’s healing he ran after him with a false request for silver and garments, then lied to Elisha, and Naaman’s leprosy clung to him.','Desire for wealth that was not his to take.'),
('shunammite-woman','zh-CN','书念妇人','书念的大户妇人，接待以利沙，失而复得独生的儿子。',ARRAY[]::text[],'她在墙上为以利沙盖了一间小楼，备有床榻、桌椅和灯台；以利沙应许她得子；孩子长大后在田间突然死去，她奔往迦密山求以利沙，以利沙使孩子复活。','款待神人，并为儿子的性命奔走。'),
('shunammite-woman','en','The Shunammite woman','A well-to-do woman of Shunem who hosted Elisha and received her son back from death.',ARRAY[]::text[],'She built a small roof chamber for Elisha with a bed, table, chair, and lamp; a son was promised and born to her; when the boy died suddenly in the fields she rode to Mount Carmel for Elisha, who raised him.','To show hospitality to the man of God, and to fight for her son’s life.'),
('jehu','zh-CN','耶户','奉命受膏的北国将军，发动政变剪除亚哈家与巴力崇拜。',ARRAY[]::text[],'以利沙差少年先知在基列的拉末膏他为以色列王；他驾车如狂，射杀约兰，令人把耶洗别扔下楼，又用计聚杀巴力的众拜奉者，拆毁巴力庙。','执行对亚哈家的判决并夺取王位。'),
('jehu','en','Jehu','The northern general anointed to overthrow the house of Ahab and destroy Baal worship.',ARRAY[]::text[],'Anointed king at Ramoth-gilead by a young prophet sent from Elisha, he drove his chariot furiously, shot Joram, had Jezebel thrown from her window, and gathered and killed the worshippers of Baal, demolishing Baal’s temple.','To execute judgment on Ahab’s house and take the throne.'),
('athaliah','zh-CN','亚她利雅','亚哈家的女儿、犹大的太后，剿灭王室宗嗣自立为王。',ARRAY[]::text[],'其子亚哈谢死后，她起来剿灭犹大王室的后裔，惟约阿施被姑母藏在圣殿中幸免；她统治犹大约六年，在约阿施登基之日被拉出圣殿处死。','保住亚哈家在犹大的权势。'),
('athaliah','en','Athaliah','A daughter of Ahab’s house and queen of Judah, who destroyed the royal line and seized the throne.',ARRAY[]::text[],'After her son Ahaziah died, she set out to destroy the royal family of Judah; only the infant Joash was hidden in the temple by his aunt. She ruled about six years and was put to death when Joash was crowned.','To preserve the power of Ahab’s house in Judah.'),
('joash-of-judah','zh-CN','约阿施（犹大王）','幸存的犹大王子，七岁在圣殿中登基。',ARRAY[]::text[],'婴孩时被姑母约示巴从被杀的王子中偷出，与乳母藏在耶和华殿里六年；第七年祭司耶何耶大召集护卫兵立他为王；耶何耶大在世的日子，他行耶和华眼中看为正的事，并主持修葺圣殿。','（幼年登基，叙事中由耶何耶大引导。）'),
('joash-of-judah','en','Joash of Judah','The surviving prince of Judah, crowned in the temple at the age of seven.',ARRAY[]::text[],'Stolen away as an infant by his aunt Jehosheba from among the murdered princes, he was hidden with his nurse in the temple for six years; in the seventh year the priest Jehoiada crowned him king. He did right as long as Jehoiada instructed him, and oversaw repairs of the temple.','Crowned as a child; guided in the narrative by Jehoiada.'),
('jehoiada-the-priest','zh-CN','耶何耶大（祭司）','大祭司，藏匿并拥立约阿施，重立君民与神之约。',ARRAY[]::text[],'在亚她利雅当政的年间保护约阿施藏于圣殿；第七年联合护卫兵长在殿中膏立约阿施，处死亚她利雅，率民拆毁巴力庙，并使王与民立约归耶和华。','保存大卫家的灯火，复兴圣殿的敬拜。'),
('jehoiada-the-priest','en','Jehoiada the priest','The high priest who hid and enthroned Joash and renewed the covenant.',ARRAY[]::text[],'Through Athaliah’s reign he kept Joash hidden in the temple; in the seventh year he and the guard captains crowned Joash, had Athaliah executed, led the people to tear down the house of Baal, and renewed the covenant between the Lord, the king, and the people.','To preserve the lamp of David’s house and restore the temple worship.'),
('hazael','zh-CN','哈薛','亚兰王，杀主篡位，长期压迫以色列。',ARRAY[]::text[],'原是便哈达的臣仆，奉差求问以利沙时被指认将作亚兰王；以利沙因预见他将加于以色列的残害而哭泣；他回去闷死便哈达自立，在耶户与其子的年间屡屡攻占以色列的城邑。','以武力扩张大马士革的疆土。'),
('hazael','en','Hazael','The king of Aram who murdered his master and long oppressed Israel.',ARRAY[]::text[],'A servant of Ben-hadad sent to consult Elisha, who wept foreseeing the harm he would do to Israel; he smothered Ben-hadad and reigned in his place, seizing Israelite territory throughout the days of Jehu and his son.','To enlarge Damascus’s realm by force.'),
('jeroboam-ii','zh-CN','耶罗波安二世','耶户王朝的第四代以色列王，在位长久，恢复北国疆界。',ARRAY[]::text[],'约阿施之子，在撒玛利亚作王四十一年；照迦特希弗人先知约拿所传的话，收回从哈马口直到亚拉巴海的边界；其治下北国富庶，却也是阿摩司与何西阿传讲斥责的年代。','重振北国的国势与疆域。'),
('jeroboam-ii','en','Jeroboam II','The fourth king of Jehu’s dynasty, whose long reign restored the borders of Israel.',ARRAY[]::text[],'Son of Jehoash, he reigned forty-one years in Samaria and recovered the border from Lebo-hamath to the sea of the Arabah, according to the word of the prophet Jonah of Gath-hepher; his prosperous reign was also the age that Amos and Hosea denounced.','To rebuild the strength and borders of the northern kingdom.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. LOCATIONS (reuse jerusalem, samaria-sebaste, bethel, damascus,
--    jordan-river-bethany; only 4 new)
-- -------------------------------------------------------------------------
INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('33000000-0000-4000-8007-000000000001','10000000-0000-4000-8000-000000000005','wadi-cherith-reference','real',ST_GeogFromText('POINT(35.6200 32.3800)'),NULL,NULL,700,'landmark','inferred',9,'JO',true,true),
('33000000-0000-4000-8007-000000000002','10000000-0000-4000-8000-000000000005','zarephath','real',ST_GeogFromText('POINT(35.2919 33.4589)'),NULL,NULL,701,'city','approximate',9,'LB',false,true),
('33000000-0000-4000-8007-000000000003','10000000-0000-4000-8000-000000000005','ramoth-gilead','real',ST_GeogFromText('POINT(36.0100 32.5500)'),NULL,NULL,702,'city','approximate',9,'JO',false,false),
('33000000-0000-4000-8007-000000000004','10000000-0000-4000-8000-000000000005','shunem','real',ST_GeogFromText('POINT(35.3369 32.6053)'),NULL,NULL,703,'city','approximate',9,'IL',false,true)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,status,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',ARRAY[]::text[],'','','','',v.region FROM locations l JOIN (VALUES
('wadi-cherith-reference','zh-CN','基立溪（推定位置）','以利亚在旱灾中藏身的溪谷，位于约旦河东，传统上或认作雅比溪。','基列'),
('wadi-cherith-reference','en','Brook Cherith (traditional site)','The ravine east of the Jordan where Elijah hid during the drought, often identified with Wadi al-Yabis.','Gilead'),
('zarephath','zh-CN','撒勒法','西顿所属的海滨城镇，以利亚寄居寡妇家之处，今黎巴嫩的萨拉凡德。','西顿'),
('zarephath','en','Zarephath','A coastal town belonging to Sidon where Elijah lodged with the widow; modern Sarafand in Lebanon.','Sidon'),
('ramoth-gilead','zh-CN','基列的拉末','约旦河东基列地的重镇，以色列与亚兰反复争夺的战场，一般认作鲁梅特丘遗址。','基列'),
('ramoth-gilead','en','Ramoth-gilead','A key city of Gilead east of the Jordan, long contested between Israel and Aram; commonly identified with Tell er-Rumeith.','Gilead'),
('shunem','zh-CN','书念','耶斯列平原边缘的村镇，书念妇人接待以利沙之处，今苏莱姆村。','耶斯列平原'),
('shunem','en','Shunem','A village on the edge of the Jezreel Valley where the Shunammite woman hosted Elisha; modern Sulam.','Jezreel Valley')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug AND l.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 3. EVENTS (new) -- range dates within era -930..-722, chapter 'divided-kingdoms'
-- -------------------------------------------------------------------------
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('63000000-0000-4000-8007-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,'range'::event_time_type,'unknown'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'shishak-invades-judah',7007,'verified_historical','battle',-930,-900,'high'),
(2,'omri-builds-samaria',7009,'reported_historical','political',-900,-860,'medium'),
(3,'elijah-fed-by-ravens-at-cherith',7013,'legendary_or_mythic','religious',-880,-845,'low'),
(4,'elijah-and-the-widow-of-zarephath',7015,'legendary_or_mythic','religious',-880,-845,'low'),
(5,'ben-hadad-besieges-samaria',7023,'reported_historical','battle',-875,-840,'low'),
(6,'micaiah-prophesies-defeat',7027,'reported_historical','religious',-870,-835,'low'),
(7,'ahab-dies-at-ramoth-gilead',7029,'reported_historical','death',-870,-835,'medium'),
(8,'elijah-taken-up-in-a-whirlwind',7031,'legendary_or_mythic','religious',-865,-830,'low'),
(9,'elisha-and-the-shunammite-son',7033,'legendary_or_mythic','religious',-860,-820,'low'),
(10,'elisha-heals-naaman',7035,'legendary_or_mythic','religious',-860,-820,'low'),
(11,'jehu-anointed-at-ramoth-gilead',7037,'reported_historical','political',-850,-810,'medium'),
(12,'jehu-destroys-baal-worship',7041,'reported_historical','religious',-850,-810,'medium'),
(13,'athaliah-seizes-the-throne',7043,'reported_historical','political',-850,-810,'low'),
(14,'joash-crowned-in-the-temple',7045,'reported_historical','political',-845,-805,'low'),
(15,'hazael-oppresses-israel',7047,'reported_historical','battle',-845,-800,'medium'),
(16,'jeroboam-ii-restores-borders',7049,'reported_historical','political',-795,-745,'medium'),
(17,'amos-preaches-at-bethel',7051,'reported_historical','religious',-775,-740,'medium'),
(18,'hosea-marries-gomer',7053,'reported_historical','marriage',-760,-725,'low')
) AS v(n,slug,seq,reality,etype,y1,y2,conf)
JOIN chapters ch ON ch.slug='divided-kingdoms' AND ch.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 4. Reorder existing divided-kingdoms events into the 7001-7999 band
-- -------------------------------------------------------------------------
UPDATE events e SET sequence=v.seq FROM (VALUES
  ('rehoboam-refuses-relief',7001),
  ('kingdom-divides',7003),
  ('jeroboam-establishes-northern-shrines',7005),
  ('ahab-and-jezebel-marry',7011),
  ('contest-on-mount-carmel',7017),
  ('elijah-withdraws-to-horeb',7019),
  ('elijah-passes-the-mantle',7021),
  ('naboths-vineyard',7025),
  ('death-of-jezebel',7039),
  ('fall-of-samaria',7055)
) AS v(slug,seq) WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug=v.slug;

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('shishak-invades-judah','zh-CN','示撒入侵犹大','罗波安第五年，埃及王示撒上来攻取耶路撒冷。','他夺去耶和华殿和王宫里的宝物，连所罗门制造的金盾牌也一并掳去；罗波安造铜盾牌代替，交给守门的护卫兵看管。','此役有埃及卡纳克神庙铭文可相印证，是分裂初期犹大衰弱的标志。','约公元前 930–900 年'),
('shishak-invades-judah','en','Shishak invades Judah','In Rehoboam’s fifth year, Shishak king of Egypt comes up against Jerusalem.','He carries off the treasures of the temple and the palace, including the golden shields Solomon made, which Rehoboam replaces with bronze ones entrusted to the guard.','The campaign is corroborated by the reliefs at Karnak, marking Judah’s weakness soon after the division.','c. 930–900 BCE'),
('omri-builds-samaria','zh-CN','暗利建造撒玛利亚','暗利买下撒玛利亚山，建城立为北国京城。','他用二他连得银子向撒玛买山，在山上造城，按山原主撒玛的名给城起名叫撒玛利亚；此后历代北国君王都以此为都。','撒玛利亚自此成为北国的政治中心，直到被亚述攻陷。','约公元前 900–860 年'),
('omri-builds-samaria','en','Omri builds Samaria','Omri buys the hill of Samaria and builds his capital there.','He purchases the hill from Shemer for two talents of silver, fortifies it, and names the city Samaria after its former owner; it remains the northern capital for the rest of the kingdom’s history.','Samaria becomes the political center of the north until its fall to Assyria.','c. 900–860 BCE'),
('elijah-fed-by-ravens-at-cherith','zh-CN','以利亚在基立溪被乌鸦供养','旱灾之初，以利亚奉命藏在约旦河东的基立溪旁。','他宣告数年之内不降露不下雨，随后遵命藏身溪旁，喝那溪里的水；乌鸦早晚给他叼饼和肉来，直到溪水干了。','开启以利亚在大旱年间被神暗中供养的叙事。','约公元前 880–845 年'),
('elijah-fed-by-ravens-at-cherith','en','Elijah fed by ravens at Cherith','At the drought’s beginning, Elijah hides by the brook Cherith east of the Jordan.','After announcing that neither dew nor rain will fall except at his word, he is commanded to hide by the brook, drinking its water while ravens bring him bread and meat morning and evening, until the brook dries up.','Opens the narrative of Elijah’s hidden sustenance through the great drought.','c. 880–845 BCE'),
('elijah-and-the-widow-of-zarephath','zh-CN','以利亚与撒勒法的寡妇','以利亚寄居西顿地撒勒法一个寡妇家，面油不减，孩子复活。','寡妇只剩一把面、一点油，先为以利亚做饼，坛内的面和瓶里的油竟不短缺；后来她的儿子病死，以利亚三次伏在孩子身上呼求，孩子的灵魂仍入他里面。','叙事让大旱中的供养与复活神迹发生在以色列境外的西顿地。','约公元前 880–845 年'),
('elijah-and-the-widow-of-zarephath','en','Elijah and the widow of Zarephath','Elijah lodges with a widow at Zarephath in Sidon; her flour and oil do not fail, and her son is restored to life.','Asked to bake for Elijah first from her last handful of flour, the widow finds the jar and jug unspent; when her son later dies, Elijah stretches himself over the child three times and his life returns.','The narrative sets miracles of provision and revival outside Israel, in the land of Sidon.','c. 880–845 BCE'),
('ben-hadad-besieges-samaria','zh-CN','便哈达围困撒玛利亚','亚兰王便哈达率盟军围攻撒玛利亚，被亚哈击退。','便哈达带着三十二个王上来，索要金银妻儿，出言羞辱；一位先知指示亚哈用跟从省长的少年人出击，亚兰军大败；次年亚兰人在亚弗再败，便哈达求和立约。','以色列与亚兰长期拉锯战事的开端场景之一。','约公元前 875–840 年'),
('ben-hadad-besieges-samaria','en','Ben-hadad besieges Samaria','Ben-hadad of Aram besieges Samaria with his allies and is driven off by Ahab.','Coming up with thirty-two kings, Ben-hadad demands silver, gold, wives, and children; at a prophet’s direction Ahab strikes first with the young men of the district governors, routing Aram, and after a second defeat at Aphek Ben-hadad sues for a treaty.','One of the opening scenes of the long struggle between Israel and Aram.','c. 875–840 BCE'),
('micaiah-prophesies-defeat','zh-CN','米该雅预言败亡','两王座前，米该雅独自预言基列的拉末之战必败。','亚哈与约沙法坐在撒玛利亚城门口的禾场上，四百先知齐声说可以上去；米该雅却见以色列民散在山上如无牧之羊，又述说谎言的灵的异象；他被西底家掌掴，亚哈下令把他下在监里，只给他吃不饱的饼和水。','成为圣经中真假预言对峙的经典场景。','约公元前 870–835 年'),
('micaiah-prophesies-defeat','en','Micaiah prophesies defeat','Before the two enthroned kings, Micaiah alone foretells disaster at Ramoth-gilead.','As Ahab and Jehoshaphat sit at the threshing floor by the gate of Samaria, four hundred prophets promise victory; Micaiah instead sees Israel scattered on the hills like sheep without a shepherd and tells of a lying spirit in the prophets’ mouths; he is struck by Zedekiah and sent to prison on scant bread and water.','A classic confrontation between true and false prophecy.','c. 870–835 BCE'),
('ahab-dies-at-ramoth-gilead','zh-CN','亚哈战死基列的拉末','亚哈改装上阵，仍被随手拉弓的箭射中，日落时死去。','亚兰王吩咐众军长专攻以色列王；约沙法一度被误认；有人随便开弓，恰恰射入亚哈的甲缝里，他被扶着站在车上抵挡亚兰人，晚上死了，血流在车中。','应验米该雅与以利亚先前的预言，亚哈家由盛转衰。','约公元前 870–835 年'),
('ahab-dies-at-ramoth-gilead','en','Ahab dies at Ramoth-gilead','Ahab goes into battle disguised, yet a bow drawn at random strikes him, and he dies at sunset.','The king of Aram orders his captains to fight only the king of Israel; Jehoshaphat is briefly mistaken for him; an arrow shot at random finds the joints of Ahab’s armor, and he is propped up in his chariot facing Aram until evening, when he dies.','Fulfills the earlier words of Micaiah and Elijah, turning the fortunes of Ahab’s house.','c. 870–835 BCE'),
('elijah-taken-up-in-a-whirlwind','zh-CN','以利亚乘旋风升天','约旦河东，火车火马将以利亚与以利沙隔开，以利亚乘旋风升天。','二人过河时以利亚用卷起的外衣打水，水左右分开；以利沙求感动以利亚的灵加倍感动自己；火车火马忽然出现，以利亚乘旋风升天，以利沙拾起落下的外衣，再次打水过河。','先知职分正式从以利亚移交以利沙。','约公元前 865–830 年'),
('elijah-taken-up-in-a-whirlwind','en','Elijah taken up in a whirlwind','East of the Jordan, chariots of fire part the two prophets and Elijah ascends in a whirlwind.','Elijah strikes the water with his rolled mantle and the river parts; Elisha asks for a double portion of his spirit; a chariot and horses of fire separate them, Elijah goes up in the whirlwind, and Elisha takes up the fallen mantle and parts the water again.','The prophetic office passes formally from Elijah to Elisha.','c. 865–830 BCE'),
('elisha-and-the-shunammite-son','zh-CN','以利沙使书念妇人之子复活','书念妇人应许而得的儿子突然死去，以利沙使他复活。','妇人为以利沙在墙上盖了小楼；以利沙应许她明年抱一个儿子；孩子长大后在收割的人中喊着头疼死去；妇人骑驴直奔迦密山，以利沙回来伏在孩子身上，孩子打了七个喷嚏，就睁开眼睛。','以利沙神迹群中最著名的复活叙事。','约公元前 860–820 年'),
('elisha-and-the-shunammite-son','en','Elisha and the Shunammite’s son','The son promised to the Shunammite woman dies suddenly, and Elisha restores him to life.','The woman had built Elisha a roof chamber; a son was promised and born; the grown child cries out in pain among the reapers and dies; his mother rides to Carmel, and Elisha stretches himself upon the boy, who sneezes seven times and opens his eyes.','The most celebrated raising narrative among Elisha’s miracles.','c. 860–820 BCE'),
('elisha-heals-naaman','zh-CN','乃缦得医治','亚兰元帅乃缦照以利沙的话在约旦河沐浴七回，大麻风得洁净。','乃缦起初忿忿而去，说大马士革的河岂不胜过以色列的一切水；仆人劝他，先知若吩咐作一件大事岂不去作；他沐浴七回，肉复原如小孩子；以利沙分文不受，仆人基哈西私追讨要，麻风便沾染了他。','外邦将军得洁净的叙事，后来在新约中被引用。','约公元前 860–820 年'),
('elisha-heals-naaman','en','The healing of Naaman','Naaman, commander of Aram, washes seven times in the Jordan at Elisha’s word and is cleansed of leprosy.','Naaman first turns away in anger, preferring the rivers of Damascus, but his servants persuade him; he washes seven times and his flesh is restored like a child’s. Elisha refuses any payment, and when Gehazi secretly claims gifts, the leprosy passes to him.','The cleansing of a foreign commander, later recalled in the New Testament.','c. 860–820 BCE'),
('jehu-anointed-at-ramoth-gilead','zh-CN','耶户在基列的拉末受膏','以利沙差少年先知往军中膏耶户为以色列王。','少年先知把耶户请入内室，倒膏油在他头上，宣告他要击杀亚哈全家，为诸先知的血伸冤，随即开门逃跑；众军长听见，急忙各将衣服铺在台阶上，吹角宣告耶户作王。','引爆推翻暗利王朝的政变。','约公元前 850–810 年'),
('jehu-anointed-at-ramoth-gilead','en','Jehu anointed at Ramoth-gilead','A young prophet sent by Elisha anoints Jehu king over Israel in the army camp.','Called into an inner room, Jehu is anointed and charged to strike down the house of Ahab and avenge the blood of the prophets; the messenger flees at once, and the officers spread their garments on the steps, blow the trumpet, and proclaim, “Jehu is king.”','Ignites the coup that topples the dynasty of Omri.','c. 850–810 BCE'),
('jehu-destroys-baal-worship','zh-CN','耶户剪除巴力崇拜','耶户假意大祭巴力，聚杀拜巴力的人，拆毁巴力庙。','他宣告亚哈事奉巴力还冷淡，耶户却要大大事奉，召聚巴力的众先知与拜奉者挤满巴力庙；献祭完毕，护卫兵奉命进去击杀众人，焚烧柱像，拆毁庙宇。','北国的巴力国家崇拜就此终结，但金牛犊仍存。','约公元前 850–810 年'),
('jehu-destroys-baal-worship','en','Jehu destroys the worship of Baal','Feigning a great sacrifice to Baal, Jehu gathers the worshippers, kills them, and demolishes the temple.','Announcing that Ahab served Baal a little but Jehu will serve him much, he fills Baal’s temple with its prophets and worshippers; when the offering is done, his guards slaughter them all, burn the sacred pillar, and tear the temple down.','Ends the state cult of Baal in the north, though the golden calves remain.','c. 850–810 BCE'),
('athaliah-seizes-the-throne','zh-CN','亚她利雅篡位','亚哈谢死后，太后亚她利雅剿灭王室宗嗣，自立为犹大的君主。','她起来剿灭犹大家一切能继位的后裔；亚哈谢的妹妹约示巴将婴孩约阿施从被杀的王子中偷出，与乳母藏在耶和华殿的卧房里；亚她利雅遂治理犹大约六年。','大卫家的世系几乎断绝，只剩一个藏在圣殿中的孩子。','约公元前 850–810 年'),
('athaliah-seizes-the-throne','en','Athaliah seizes the throne','After Ahaziah’s death, the queen mother Athaliah destroys the royal line and rules Judah.','She rises to wipe out all the royal offspring of Judah, but Jehosheba steals the infant Joash from among the murdered princes and hides him with his nurse in a temple chamber; Athaliah then reigns over the land about six years.','The line of David is nearly severed, surviving in one hidden child.','c. 850–810 BCE'),
('joash-crowned-in-the-temple','zh-CN','约阿施在圣殿登基','第七年，祭司耶何耶大在殿中立七岁的约阿施为王，处死亚她利雅。','耶何耶大召集护卫兵长立约，把王的儿子指给他们看；众人在殿里护卫幼主，膏他为王，拍掌高呼愿王万岁；亚她利雅撕裂衣服喊叫反了，被拉出殿外处死；民众随后拆毁巴力庙。','大卫家的王统得以延续，君民重新与耶和华立约。','约公元前 845–805 年'),
('joash-crowned-in-the-temple','en','Joash crowned in the temple','In the seventh year, the priest Jehoiada crowns seven-year-old Joash and Athaliah is put to death.','Jehoiada binds the guard captains by covenant and shows them the king’s son; ringed by armed guards, the boy is crowned and anointed amid shouts of “Long live the king”; Athaliah tears her clothes crying “Treason,” and is executed outside the temple; the people then tear down the house of Baal.','The Davidic line is preserved and the covenant is renewed.','c. 845–805 BCE'),
('hazael-oppresses-israel','zh-CN','哈薛的压迫','哈薛篡得亚兰王位，在耶户及其子年间不断侵夺以色列的土地。','哈薛奉差求问以利沙时，以利沙注视他而哭，预言他将攻破以色列的保障、残害他们的妇孺；哈薛回去闷死便哈达自立为王；那些年日，他攻击以色列四境，夺去约旦河东基列全地。','以色列在亚兰的重压下几乎不能自保。','约公元前 845–800 年'),
('hazael-oppresses-israel','en','The oppression of Hazael','Hazael usurps the throne of Aram and strips Israel of territory throughout Jehu’s dynasty.','Sent to consult Elisha, Hazael hears the prophet weep over the harm he will do to Israel; he returns, smothers Ben-hadad, and reigns in his place; in those days he defeats Israel throughout its borders, taking all Gilead east of the Jordan.','Israel is left barely able to defend itself under Aram’s weight.','c. 845–800 BCE'),
('jeroboam-ii-restores-borders','zh-CN','耶罗波安二世恢复疆界','耶罗波安二世在位年间，北国收复从哈马口到亚拉巴海的疆土。','他在撒玛利亚作王四十一年；经文记载这是照耶和华借迦特希弗人约拿所说的话，因为耶和华看见以色列人甚是艰苦；北国由此进入最后一段富庶扩张的岁月。','约拿书的主人公在此以宫廷先知的身份出现；繁荣背后的不义成为阿摩司与何西阿传讲的主题。','约公元前 795–745 年'),
('jeroboam-ii-restores-borders','en','Jeroboam II restores the borders','Under Jeroboam II the north recovers its territory from Lebo-hamath to the sea of the Arabah.','Reigning forty-one years in Samaria, he restores the border according to the word of the Lord spoken through Jonah of Gath-hepher, for the Lord had seen Israel’s bitter affliction; the kingdom enters its last age of prosperity and expansion.','Jonah appears here as a court prophet; the injustice beneath the prosperity becomes the theme of Amos and Hosea.','c. 795–745 BCE'),
('amos-preaches-at-bethel','zh-CN','阿摩司在伯特利传讲','提哥亚的牧人阿摩司在王家圣所伯特利宣告审判，被祭司驱逐。','他斥责以色列人为银子卖了义人，践踏穷人的头，宣告惟愿公平如大水滚滚、公义如江河滔滔；伯特利的祭司亚玛谢向王告发他，命他逃回犹大去，不许再在伯特利说预言。','书写先知传统的开端之一，审判的信息直指王家圣所。','约公元前 775–740 年'),
('amos-preaches-at-bethel','en','Amos preaches at Bethel','Amos, a herdsman from Tekoa, proclaims judgment at the royal sanctuary of Bethel and is expelled by its priest.','He denounces those who sell the righteous for silver and trample the heads of the poor, crying, “Let justice roll down like waters, and righteousness like an ever-flowing stream”; Amaziah the priest of Bethel reports him to the king and orders him back to Judah.','One of the beginnings of the written prophetic tradition, aimed straight at the royal shrine.','c. 775–740 BCE'),
('hosea-marries-gomer','zh-CN','何西阿娶歌篾','先知何西阿奉命娶歌篾为妻，以婚姻为北国背约的记号。','他给儿女起名耶斯列、罗路哈玛（不蒙怜悯）、罗阿米（非我民）；妻子离去后他又奉命用银子和大麦把她赎回，要她多日为他独居；婚姻成为神与以色列关系的活的比喻。','以最私密的伤痛承载先知信息，是何西阿书的叙事核心。','约公元前 760–725 年'),
('hosea-marries-gomer','en','Hosea marries Gomer','The prophet Hosea is commanded to marry Gomer, his marriage becoming a sign of Israel’s unfaithfulness.','He names his children Jezreel, Lo-ruhamah (Not pitied), and Lo-ammi (Not my people); when his wife leaves he is told to buy her back with silver and barley and to keep her many days; the marriage becomes a living parable of God and Israel.','The prophetic message carried in the most intimate grief, at the heart of the book of Hosea.','c. 760–725 BCE')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS (reuse jerusalem, samaria-sebaste, bethel, damascus,
--    jordan-river-bethany; new wadi-cherith-reference, zarephath,
--    ramoth-gilead, shunem)
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('shishak-invades-judah','jerusalem'),
('omri-builds-samaria','samaria-sebaste'),
('elijah-fed-by-ravens-at-cherith','wadi-cherith-reference'),
('elijah-and-the-widow-of-zarephath','zarephath'),
('ben-hadad-besieges-samaria','samaria-sebaste'),
('micaiah-prophesies-defeat','samaria-sebaste'),
('ahab-dies-at-ramoth-gilead','ramoth-gilead'),
('elijah-taken-up-in-a-whirlwind','jordan-river-bethany'),
('elisha-and-the-shunammite-son','shunem'),
('elisha-heals-naaman','jordan-river-bethany'),
('jehu-anointed-at-ramoth-gilead','ramoth-gilead'),
('jehu-destroys-baal-worship','samaria-sebaste'),
('athaliah-seizes-the-throne','jerusalem'),
('joash-crowned-in-the-temple','jerusalem'),
('hazael-oppresses-israel','damascus'),
('jeroboam-ii-restores-borders','samaria-sebaste'),
('amos-preaches-at-bethel','bethel'),
('hosea-marries-gomer','samaria-sebaste')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('shishak-invades-judah','shishak',0),('shishak-invades-judah','rehoboam',1),
('omri-builds-samaria','omri',0),('omri-builds-samaria','ahab',1),
('elijah-fed-by-ravens-at-cherith','elijah',0),
('elijah-and-the-widow-of-zarephath','elijah',0),('elijah-and-the-widow-of-zarephath','widow-of-zarephath',1),
('ben-hadad-besieges-samaria','ben-hadad',0),('ben-hadad-besieges-samaria','ahab',1),
('micaiah-prophesies-defeat','micaiah',0),('micaiah-prophesies-defeat','ahab',1),('micaiah-prophesies-defeat','jehoshaphat',2),
('ahab-dies-at-ramoth-gilead','ahab',0),('ahab-dies-at-ramoth-gilead','jehoshaphat',1),('ahab-dies-at-ramoth-gilead','ben-hadad',2),
('elijah-taken-up-in-a-whirlwind','elijah',0),('elijah-taken-up-in-a-whirlwind','elisha',1),
('elisha-and-the-shunammite-son','elisha',0),('elisha-and-the-shunammite-son','shunammite-woman',1),('elisha-and-the-shunammite-son','gehazi',2),
('elisha-heals-naaman','naaman',0),('elisha-heals-naaman','elisha',1),('elisha-heals-naaman','gehazi',2),
('jehu-anointed-at-ramoth-gilead','jehu',0),('jehu-anointed-at-ramoth-gilead','elisha',1),
('jehu-destroys-baal-worship','jehu',0),
('athaliah-seizes-the-throne','athaliah',0),('athaliah-seizes-the-throne','joash-of-judah',1),
('joash-crowned-in-the-temple','joash-of-judah',0),('joash-crowned-in-the-temple','jehoiada-the-priest',1),('joash-crowned-in-the-temple','athaliah',2),
('hazael-oppresses-israel','hazael',0),('hazael-oppresses-israel','jehu',1),
('jeroboam-ii-restores-borders','jeroboam-ii',0),('jeroboam-ii-restores-borders','jonah',1),
('amos-preaches-at-bethel','amos',0),('amos-preaches-at-bethel','amaziah-priest-of-bethel',1),('amos-preaches-at-bethel','jeroboam-ii',2),
('hosea-marries-gomer','hosea',0),('hosea-marries-gomer','gomer',1)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES (Kings / Amos / Hosea, per event)
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Kings'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN (
 'shishak-invades-judah','omri-builds-samaria','elijah-fed-by-ravens-at-cherith',
 'elijah-and-the-widow-of-zarephath','ben-hadad-besieges-samaria','micaiah-prophesies-defeat',
 'ahab-dies-at-ramoth-gilead','elijah-taken-up-in-a-whirlwind','elisha-and-the-shunammite-son',
 'elisha-heals-naaman','jehu-anointed-at-ramoth-gilead','jehu-destroys-baal-worship',
 'athaliah-seizes-the-throne','joash-crowned-in-the-temple','hazael-oppresses-israel',
 'jeroboam-ii-restores-borders')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Amos'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN (
 'amos-preaches-at-bethel')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Hosea'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN (
 'hosea-marries-gomer')
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS
-- -------------------------------------------------------------------------
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('73000000-0000-4000-8007-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'shishak','rehoboam','adversary','source_to_target','negative',3,'ended',NULL,'shishak-invades-judah'),
(2,'omri','ahab','family','source_to_target','positive',3,'unknown',NULL,NULL),
(3,'ben-hadad','ahab','adversary','bidirectional','negative',4,'ended',NULL,'ahab-dies-at-ramoth-gilead'),
(4,'jehoshaphat','ahab','ally','bidirectional','mixed',3,'ended',NULL,'ahab-dies-at-ramoth-gilead'),
(5,'ahab','micaiah','adversary','source_to_target','negative',3,'ended','micaiah-prophesies-defeat','ahab-dies-at-ramoth-gilead'),
(6,'elijah','widow-of-zarephath','ally','bidirectional','positive',3,'ended','elijah-and-the-widow-of-zarephath',NULL),
(7,'elisha','gehazi','mentor','source_to_target','mixed',3,'changed',NULL,'elisha-heals-naaman'),
(8,'elisha','shunammite-woman','ally','bidirectional','positive',3,'unknown','elisha-and-the-shunammite-son',NULL),
(9,'naaman','elisha','ally','source_to_target','positive',3,'unknown','elisha-heals-naaman',NULL),
(10,'elisha','jehu','other','source_to_target','neutral',2,'unknown','jehu-anointed-at-ramoth-gilead',NULL),
(11,'jehu','jezebel','adversary','source_to_target','negative',4,'ended',NULL,'death-of-jezebel'),
(12,'athaliah','joash-of-judah','family','source_to_target','negative',4,'ended','athaliah-seizes-the-throne','joash-crowned-in-the-temple'),
(13,'jehoiada-the-priest','joash-of-judah','mentor','source_to_target','positive',4,'unknown','joash-crowned-in-the-temple',NULL),
(14,'hazael','ben-hadad','adversary','source_to_target','negative',4,'ended',NULL,'hazael-oppresses-israel'),
(15,'hazael','jehu','adversary','bidirectional','negative',4,'unknown','hazael-oppresses-israel',NULL),
(16,'jonah','jeroboam-ii','other','source_to_target','positive',2,'unknown','jeroboam-ii-restores-borders',NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000005'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 10. GROUP MEMBERSHIP (existing groups northern-court, prophetic-circle,
--     opposing-powers)
-- -------------------------------------------------------------------------
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g JOIN (VALUES
('northern-court','omri'),('northern-court','jehu'),('northern-court','jeroboam-ii'),
('prophetic-circle','micaiah'),
('opposing-powers','shishak'),('opposing-powers','ben-hadad'),('opposing-powers','hazael')
) AS v(gslug,cslug)
ON g.slug=v.gslug JOIN characters c ON c.slug=v.cslug AND c.work_id=g.work_id
WHERE g.work_id='10000000-0000-4000-8000-000000000005' ON CONFLICT DO NOTHING;

COMMIT;
