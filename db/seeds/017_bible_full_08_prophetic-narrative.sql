BEGIN;

-- =========================================================================
-- 017_bible_full_08_prophetic-narrative.sql
-- Chapter K=08 slug='prophetic-narrative' (Jonah, Amos, Hosea, Isaiah 1-39
-- narrative portions, c. 800-680 BCE)
-- Adds 8 characters, 3 locations, 18 new events, 8 relations, and reorders
-- the five pre-existing prophetic events into the 8001-8999 sequence band.
-- Note: jeroboam-ii is created by era 07 (loaded before this file); the
-- relation referencing him silently drops when testing this file alone.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('43000000-0000-4000-8008-000000000001','10000000-0000-4000-8000-000000000005','amos',800,'male','adult','protagonist','unknown',NULL,NULL,'prophet',3),
('43000000-0000-4000-8008-000000000002','10000000-0000-4000-8000-000000000005','hosea',801,'male','adult','protagonist','unknown',NULL,NULL,'prophet',3),
('43000000-0000-4000-8008-000000000003','10000000-0000-4000-8000-000000000005','gomer',802,'female','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8008-000000000004','10000000-0000-4000-8000-000000000005','amaziah-priest-of-bethel',803,'male','adult','antagonist','unknown',NULL,NULL,'priest',2),
('43000000-0000-4000-8008-000000000005','10000000-0000-4000-8000-000000000005','uzziah',804,'male','adult','supporting','historical',NULL,NULL,'king',3),
('43000000-0000-4000-8008-000000000006','10000000-0000-4000-8000-000000000005','ahaz',805,'male','adult','supporting','historical',NULL,NULL,'king',2),
('43000000-0000-4000-8008-000000000007','10000000-0000-4000-8000-000000000005','micah-of-moresheth',806,'male','adult','supporting','unknown',NULL,NULL,'prophet',2),
('43000000-0000-4000-8008-000000000008','10000000-0000-4000-8000-000000000005','king-of-nineveh',807,'male','adult','supporting','unknown',NULL,NULL,'king',2)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('amos','zh-CN','阿摩司','提哥亚的牧人，蒙召向北国以色列传讲公义的先知。',ARRAY[]::text[],'他原以牧羊和修理桑树为业，却在耶罗波安二世年间被差往伯特利等地，斥责奢华与欺压，并见到准绳等审判异象。','传讲耶和华对不义的审判与公义的要求。'),
('amos','en','Amos','A herdsman of Tekoa called to prophesy justice to the northern kingdom of Israel.',ARRAY[]::text[],'A shepherd and dresser of sycamore figs, he is sent north in the days of Jeroboam II, denouncing luxury and oppression and seeing visions of judgment such as the plumb line.','To proclaim the Lord’s judgment on injustice and his demand for righteousness.'),
('hosea','zh-CN','何西阿','北国先知，其婚姻被叙述为神与以色列关系的记号。',ARRAY[]::text[],'他奉命娶歌篾为妻，为儿女起下预兆性的名字；婚姻的破裂与赎回承载他宣讲背道与复和的信息。','以自身的婚姻见证神对背道之民持久的爱。'),
('hosea','en','Hosea','A prophet of the northern kingdom whose marriage is narrated as a sign of God’s bond with Israel.',ARRAY[]::text[],'Commanded to marry Gomer, he gives his children sign-laden names; the rupture and redemption of the marriage carry his message of apostasy and reconciliation.','To embody God’s enduring love for a wayward people in his own marriage.'),
('gomer','zh-CN','歌篾','滴拉音的女儿，何西阿的妻子。',ARRAY[]::text[],'她与何西阿生育儿女，后离家随从别人，又被何西阿用银子和大麦赎回。','经文未明言其内心动机。'),
('gomer','en','Gomer','Daughter of Diblaim and wife of Hosea.',ARRAY[]::text[],'She bears Hosea children, later leaves him for other lovers, and is bought back with silver and barley.','Her inner motives are left unstated in the text.'),
('amaziah-priest-of-bethel','zh-CN','亚玛谢（伯特利祭司）','伯特利王家圣所的祭司，驱逐先知阿摩司。',ARRAY[]::text[],'他向耶罗波安王告发阿摩司谋叛，命他回犹大糊口，不得再在伯特利说预言。','维护王家圣所与现有秩序。'),
('amaziah-priest-of-bethel','en','Amaziah (priest of Bethel)','Priest of the royal sanctuary at Bethel who expelled the prophet Amos.',ARRAY[]::text[],'He denounces Amos to King Jeroboam as a conspirator and orders him back to Judah, forbidding him to prophesy at Bethel again.','To defend the royal sanctuary and the standing order.'),
('uzziah','zh-CN','乌西雅','犹大王，长期在位而国势强盛，晚年因擅自烧香患麻风。',ARRAY['亚撒利雅'],'他修筑防务、发展农牧，名声远播；后因进殿烧香被祭司拦阻，额上发出麻风，隔离而终。以赛亚在他驾崩之年见到异象。','巩固并扩张犹大的国势。'),
('uzziah','en','Uzziah','King of Judah whose long, prosperous reign ended in leprosy after he burned incense unlawfully.',ARRAY['Azariah'],'He fortified Jerusalem and fostered farming and herds, and his fame spread far; struck with leprosy when he usurped the priests’ office, he lived apart until his death. Isaiah’s vision is dated to the year he died.','To consolidate and extend Judah’s power.'),
('ahaz','zh-CN','亚哈斯','犹大王，面对亚兰以法莲同盟的威胁时求助于亚述。',ARRAY[]::text[],'同盟压境时他拒绝向耶和华求兆，以赛亚仍宣告以马内利之兆；他献重礼求亚述王相助，亚述碑铭中也记有他的名字。','倚靠亚述保全王位与国土。'),
('ahaz','en','Ahaz','King of Judah who turned to Assyria when the Aram-Ephraim alliance threatened.',ARRAY[]::text[],'Refusing to ask a sign from the Lord while under threat, he receives the Immanuel sign anyway; he sends tribute to the Assyrian king, whose inscriptions record his name.','To secure his throne and land by leaning on Assyria.'),
('micah-of-moresheth','zh-CN','弥迦（摩利沙人）','出身犹大低地的先知，警告撒玛利亚与耶路撒冷的倾覆。',ARRAY[]::text[],'他在约坦、亚哈斯、希西家年间说预言，为受欺压的小民发声；"锡安必被耕种像一块田"的警告在耶利米时代仍被长老引用。','为受欺压者伸冤，呼唤行公义、好怜悯。'),
('micah-of-moresheth','en','Micah of Moresheth','A prophet from the Judean lowlands who warned of the fall of Samaria and Jerusalem.',ARRAY[]::text[],'Prophesying in the days of Jotham, Ahaz, and Hezekiah, he speaks for the oppressed smallholders; his warning that Zion would be plowed as a field was still cited in Jeremiah’s day.','To plead the cause of the oppressed and call for justice and mercy.'),
('king-of-nineveh','zh-CN','尼尼微王','听见约拿警告后带头悔改的亚述都城之王。',ARRAY[]::text[],'他离开宝座、披麻坐灰，下诏全城人畜禁食求告神。经文未记其名。','盼望神转意后悔，使全城免于倾覆。'),
('king-of-nineveh','en','The king of Nineveh','The unnamed ruler of the Assyrian capital who led its repentance at Jonah’s warning.',ARRAY[]::text[],'He rises from his throne to sit in ashes wearing sackcloth, decreeing a fast for people and beasts alike. The text leaves him unnamed.','Hope that God may relent so the city is not overthrown.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. LOCATIONS (reuse joppa, tarshish-reference, nineveh, bethel,
--    samaria-sebaste, jerusalem; only 3 new)
-- -------------------------------------------------------------------------
INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('33000000-0000-4000-8008-000000000001','10000000-0000-4000-8000-000000000005','gath-hepher','real',ST_GeogFromText('POINT(35.3253 32.7397)'),NULL,NULL,800,'city','approximate',9,'IL',false,false),
('33000000-0000-4000-8008-000000000002','10000000-0000-4000-8000-000000000005','tekoa','real',ST_GeogFromText('POINT(35.2110 31.6350)'),NULL,NULL,801,'city','approximate',9,'PS',false,true),
('33000000-0000-4000-8008-000000000003','10000000-0000-4000-8000-000000000005','mediterranean-open-sea-reference','real',ST_GeogFromText('POINT(33.5000 33.0000)'),NULL,NULL,802,'route_node','inferred',5,NULL,true,true)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,status,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',ARRAY[]::text[],'','','','',v.region FROM locations l JOIN (VALUES
('gath-hepher','zh-CN','迦特希弗','加利利地区的城镇，先知约拿的家乡。','加利利'),
('gath-hepher','en','Gath-hepher','A Galilean town, home of the prophet Jonah.','Galilee'),
('tekoa','zh-CN','提哥亚','犹大旷野边缘的城镇，先知阿摩司的家乡。','犹大'),
('tekoa','en','Tekoa','A town on the edge of the Judean wilderness, home of the prophet Amos.','Judah'),
('mediterranean-open-sea-reference','zh-CN','地中海海上（示意位置）','约拿逃往他施途中遭遇风暴的东地中海海域。','大海'),
('mediterranean-open-sea-reference','en','Open Mediterranean (indicative point)','The eastern Mediterranean waters where the storm overtook Jonah’s ship on the way to Tarshish.','The Great Sea')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug AND l.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 3. EVENTS (new) -- chapter 'prophetic-narrative', sequence band 8001-8999
-- -------------------------------------------------------------------------
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('63000000-0000-4000-8008-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'unknown'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'jonah-called-to-nineveh',8001,'legendary_or_mythic','religious','range',-790,-760,'low','prophetic-narrative'),
(2,'storm-overtakes-jonahs-ship',8007,'legendary_or_mythic','other','range',-790,-760,'low','prophetic-narrative'),
(3,'jonah-cast-into-the-sea',8009,'legendary_or_mythic','trial','range',-790,-760,'low','prophetic-narrative'),
(4,'great-fish-swallows-jonah',8011,'legendary_or_mythic','other','range',-790,-760,'low','prophetic-narrative'),
(5,'jonah-prays-inside-the-fish',8013,'legendary_or_mythic','religious','range',-790,-760,'low','prophetic-narrative'),
(6,'jonah-vomited-onto-dry-land',8015,'legendary_or_mythic','escape','range',-790,-760,'low','prophetic-narrative'),
(7,'jonah-called-a-second-time',8017,'legendary_or_mythic','religious','range',-790,-760,'low','prophetic-narrative'),
(8,'king-of-nineveh-decrees-repentance',8021,'legendary_or_mythic','religious','range',-790,-760,'low','prophetic-narrative'),
(9,'jonah-angry-over-the-plant',8025,'legendary_or_mythic','other','range',-790,-760,'low','prophetic-narrative'),
(10,'amos-called-from-tekoa',8027,'reported_historical','religious','range',-770,-750,'low','prophetic-narrative'),
(11,'amos-vision-of-plumb-line',8029,'legendary_or_mythic','religious','range',-765,-750,'low','prophetic-narrative'),
(12,'amaziah-confronts-amos',8031,'reported_historical','political','range',-765,-750,'low','prophetic-narrative'),
(13,'hosea-commanded-to-marry-gomer',8033,'reported_historical','marriage','range',-760,-740,'low','prophetic-narrative'),
(14,'gomer-leaves-hosea',8035,'reported_historical','betrayal','range',-755,-735,'low','prophetic-narrative'),
(15,'hosea-redeems-gomer',8037,'reported_historical','social','range',-750,-730,'low','prophetic-narrative'),
(16,'uzziah-burns-incense-and-is-struck-with-leprosy',8039,'reported_historical','religious','range',-755,-740,'low','prophetic-narrative'),
(17,'sign-of-immanuel',8043,'reported_historical','religious','range',-735,-732,'low','prophetic-narrative'),
(18,'micah-prophesies-zion-plowed',8045,'reported_historical','religious','range',-720,-700,'low','prophetic-narrative')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,conf,chapter_slug)
JOIN chapters ch ON ch.slug=v.chapter_slug AND ch.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 4. Reorder existing prophetic-narrative events into the 8001-8999 band
-- -------------------------------------------------------------------------
UPDATE events e SET sequence=v.seq FROM (VALUES
  ('jonah-sails-from-joppa',8003),
  ('jonah-heads-for-tarshish',8005),
  ('jonah-to-nineveh',8019),
  ('jonah-outside-nineveh',8023),
  ('isaiah-called-in-the-temple',8041)
) AS v(slug,seq) WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug=v.slug;

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('jonah-called-to-nineveh','zh-CN','约拿蒙召往尼尼微','耶和华的话临到亚米太的儿子约拿，吩咐他往尼尼微大城去呼喊。','经文记载尼尼微的恶达到神面前，约拿却起身逃往相反的方向。','开启约拿书的叙事主线。','约公元前 790–760 年'),
('jonah-called-to-nineveh','en','Jonah called to go to Nineveh','The word of the Lord comes to Jonah son of Amittai, sending him to cry against the great city of Nineveh.','The text records that Nineveh’s wickedness has come up before God, yet Jonah rises to flee in the opposite direction.','Opens the main narrative line of the book of Jonah.','c. 790–760 BCE'),
('storm-overtakes-jonahs-ship','zh-CN','海上狂风大作','耶和华使海中起大风，船几乎破坏，水手各求自己的神。','约拿却在舱底沉睡，船主叫醒他，催他求告他的神。','水手的惊惶与逃跑先知的沉睡形成鲜明对照。','约公元前 790–760 年'),
('storm-overtakes-jonahs-ship','en','A great storm overtakes the ship','The Lord hurls a great wind upon the sea, the ship threatens to break apart, and the sailors each cry to their own god.','Jonah, asleep in the hold, is roused by the captain and urged to call on his God.','The sailors’ terror contrasts sharply with the fleeing prophet’s sleep.','c. 790–760 BCE'),
('jonah-cast-into-the-sea','zh-CN','掣签落海','众人掣签，签落在约拿身上；他自请被抛进海里，海浪就平息了。','约拿承认风暴因他逃避耶和华而起，水手把他抬起来抛进海中。','水手因此大大敬畏耶和华，献祭许愿。','约公元前 790–760 年'),
('jonah-cast-into-the-sea','en','Jonah cast into the sea','The lot falls on Jonah, and at his own word the sailors throw him into the sea, which grows calm.','Jonah admits the storm has come because he is fleeing from the Lord, and the sailors lift him overboard.','The sailors fear the Lord greatly, offering sacrifice and making vows.','c. 790–760 BCE'),
('great-fish-swallows-jonah','zh-CN','大鱼吞下约拿','耶和华安排一条大鱼吞下约拿，他在鱼腹中三日三夜。','叙事以此使逃跑的先知在深渊中转向。','这一场景后世常被引用，象征绝境与拯救。','约公元前 790–760 年'),
('great-fish-swallows-jonah','en','A great fish swallows Jonah','The Lord appoints a great fish to swallow Jonah, and he remains in its belly three days and three nights.','The narrative uses the deep to turn the fleeing prophet around.','The scene is later widely invoked as an image of the depths and of deliverance.','c. 790–760 BCE'),
('jonah-prays-inside-the-fish','zh-CN','鱼腹中的祷告','约拿在鱼腹中向耶和华祷告，回顾自己的下沉与获救。','祷文以诗体写成，称他从阴间的深处呼求而蒙垂听。','祷告以"救恩出于耶和华"作结。','约公元前 790–760 年'),
('jonah-prays-inside-the-fish','en','Jonah prays inside the fish','From the belly of the fish Jonah prays, tracing his descent and rescue.','The prayer is cast in poetic form, recalling how he cried out of the depths and was heard.','It closes with the declaration that salvation belongs to the Lord.','c. 790–760 BCE'),
('jonah-vomited-onto-dry-land','zh-CN','大鱼把约拿吐在旱地','耶和华吩咐鱼，鱼就把约拿吐在旱地上。','先知重新获得完成使命的机会。','叙事由此转回尼尼微的主线。','约公元前 790–760 年'),
('jonah-vomited-onto-dry-land','en','The fish spits Jonah onto dry land','At the Lord’s command the fish vomits Jonah onto dry land.','The prophet is given a fresh chance to carry out his commission.','The narrative then returns to the Nineveh storyline.','c. 790–760 BCE'),
('jonah-called-a-second-time','zh-CN','约拿二次奉差','耶和华的话第二次临到约拿，吩咐他往尼尼微去宣告所指示的话。','这一次约拿依言起身前往。','重复的呼召凸显使命不可回避。','约公元前 790–760 年'),
('jonah-called-a-second-time','en','Jonah commissioned a second time','The word of the Lord comes to Jonah a second time, sending him to Nineveh with the message given to him.','This time Jonah rises and goes as told.','The repeated call underscores that the commission cannot be evaded.','c. 790–760 BCE'),
('king-of-nineveh-decrees-repentance','zh-CN','尼尼微王下诏悔改','警告传到尼尼微王那里，他离开宝座、披上麻布、坐在灰中。','他下诏令全城人畜禁食披麻，切切求告神，离开恶道。','经文记载神察看他们的行为，就不降所说的灾。','约公元前 790–760 年'),
('king-of-nineveh-decrees-repentance','en','The king of Nineveh decrees repentance','When the warning reaches the king of Nineveh, he rises from his throne, puts on sackcloth, and sits in ashes.','He decrees a fast for people and animals alike, calling the city to turn from its evil ways.','The text records that God sees their deeds and relents from the disaster he had spoken.','c. 790–760 BCE'),
('jonah-angry-over-the-plant','zh-CN','蓖麻树与约拿的怒气','神安排一棵蓖麻为约拿遮荫，又安排虫子咬死它，约拿因此发怒求死。','神以约拿怜惜一夜长成的蓖麻，反问他岂不该怜惜尼尼微众多不能分辨左右手的人。','约拿书在这个未回答的问句中结束。','约公元前 790–760 年'),
('jonah-angry-over-the-plant','en','Jonah’s anger over the plant','God appoints a plant to shade Jonah, then a worm to destroy it, and Jonah is angry enough to die.','God contrasts Jonah’s pity for a plant that grew in a night with his own pity for Nineveh’s many people who cannot tell right hand from left.','The book of Jonah ends on this unanswered question.','c. 790–760 BCE'),
('amos-called-from-tekoa','zh-CN','阿摩司从提哥亚受召','提哥亚的牧人阿摩司蒙召，离开羊群往北国以色列传讲预言。','他自称原不是先知，也不是先知的门徒，本以牧羊和修理桑树为业。','他的言论集中于社会不义与虚假敬拜。','约公元前 770–750 年'),
('amos-called-from-tekoa','en','Amos called from Tekoa','Amos, a herdsman of Tekoa, is called from following the flock to prophesy to the northern kingdom of Israel.','He insists he was neither a prophet nor a prophet’s son, but a shepherd and dresser of sycamore figs.','His oracles center on social injustice and hollow worship.','c. 770–750 BCE'),
('amos-vision-of-plumb-line','zh-CN','准绳的异象','阿摩司见主站在准绳砌成的墙上，手拿准绳。','耶和华宣告要用准绳量度他的百姓以色列，不再宽恕。','这一异象成为审判临近的著名意象。','约公元前 765–750 年'),
('amos-vision-of-plumb-line','en','The vision of the plumb line','Amos sees the Lord standing by a wall built with a plumb line, a plumb line in his hand.','The Lord declares he is setting a plumb line among his people Israel and will spare them no longer.','The vision becomes a famous image of impending judgment.','c. 765–750 BCE'),
('amaziah-confronts-amos','zh-CN','伯特利祭司亚玛谢驱逐阿摩司','亚玛谢差人告到王那里，又命阿摩司回犹大糊口，不许再在王的圣所说预言。','阿摩司回答自己本是牧人，是耶和华从羊群中选召他向以色列说话。','这场冲突成为先知与王家圣所对立的经典场景。','约公元前 765–750 年'),
('amaziah-confronts-amos','en','Amaziah of Bethel confronts Amos','Amaziah reports Amos to the king and orders him to flee to Judah and earn his bread there, never again to prophesy at the royal sanctuary.','Amos replies that he was a herdsman whom the Lord took from the flock to speak to Israel.','The clash becomes a classic scene of prophet against royal shrine.','c. 765–750 BCE'),
('hosea-commanded-to-marry-gomer','zh-CN','何西阿奉命娶歌篾','耶和华吩咐何西阿娶滴拉音的女儿歌篾为妻。','这桩婚姻被叙述为以色列离弃耶和华的记号。','先知的家庭生活由此成为他传讲信息的一部分。','约公元前 760–740 年'),
('hosea-commanded-to-marry-gomer','en','Hosea commanded to marry Gomer','The Lord tells Hosea to take Gomer, daughter of Diblaim, as his wife.','The marriage is narrated as a sign of Israel’s unfaithfulness to the Lord.','The prophet’s family life thus becomes part of his message.','c. 760–740 BCE'),
('gomer-leaves-hosea','zh-CN','歌篾离开何西阿','歌篾离开何西阿随从别人，叙事以此对应以色列随从别神。','经文描写她追随所爱的，却寻不见。','婚姻的破裂成为全书哀婉的核心。','约公元前 755–735 年'),
('gomer-leaves-hosea','en','Gomer leaves Hosea','Gomer leaves Hosea for other lovers, mirroring Israel’s pursuit of other gods in the narrative.','The text pictures her chasing after her lovers without finding them.','The broken marriage becomes the book’s aching center.','c. 755–735 BCE'),
('hosea-redeems-gomer','zh-CN','何西阿赎回歌篾','何西阿奉命再去爱那被爱却不忠的妇人，用银子和大麦把歌篾赎回。','他叮嘱她多日为他独居，不归别人。','赎回的行动被解读为神对以色列持久之爱的记号。','约公元前 750–730 年'),
('hosea-redeems-gomer','en','Hosea redeems Gomer','Told to love again a woman who is loved yet unfaithful, Hosea buys Gomer back for silver and barley.','He tells her to remain with him and belong to no other for many days.','The act of redemption is read as a sign of God’s enduring love for Israel.','c. 750–730 BCE'),
('uzziah-burns-incense-and-is-struck-with-leprosy','zh-CN','乌西雅擅自烧香患麻风','犹大王乌西雅国势强盛后心高气傲，进耶和华的殿要亲自在香坛上烧香。','祭司们拦阻他，他发怒之间额上发出麻风。','他从此隔离居住直到死日，国事由儿子约坦代理。','约公元前 755–740 年'),
('uzziah-burns-incense-and-is-struck-with-leprosy','en','Uzziah burns incense and is struck with leprosy','Grown strong and then proud, King Uzziah of Judah enters the temple to burn incense on the altar himself.','When the priests withstand him, leprosy breaks out on his forehead even as he rages.','He lives apart until his death, his son Jotham governing in his stead.','c. 755–740 BCE'),
('sign-of-immanuel','zh-CN','以马内利之兆','亚兰与以法莲结盟攻犹大，以赛亚奉命去见亚哈斯王，宣告以马内利之兆。','王和百姓的心摇动如林中的树；以赛亚劝他安然镇定，并宣告"必有童女怀孕生子，给他起名叫以马内利"。','这一兆头日后成为最常被引用的先知经文之一。','约公元前 735–732 年'),
('sign-of-immanuel','en','The sign of Immanuel','With Aram and Ephraim allied against Judah, Isaiah is sent to King Ahaz and announces the sign of Immanuel.','The hearts of king and people shake like trees in the wind; Isaiah urges calm and declares that the young woman shall conceive and bear a son named Immanuel.','The sign later becomes one of the most quoted prophetic texts.','c. 735–732 BCE'),
('micah-prophesies-zion-plowed','zh-CN','弥迦预言锡安必被耕种','摩利沙人弥迦警告，因首领的不义，锡安必被耕种像一块田，耶路撒冷必变为乱堆。','一个世纪后耶利米受审时，长老们仍引用这段话为他辩护。','弥迦书中也保留了"将刀打成犁头"的著名愿景。','约公元前 720–700 年'),
('micah-prophesies-zion-plowed','en','Micah prophesies Zion plowed as a field','Micah of Moresheth warns that because of its leaders’ injustice Zion will be plowed as a field and Jerusalem become a heap of ruins.','A century later the elders still cite these words in Jeremiah’s defense at his trial.','His book also preserves the famous vision of swords beaten into plowshares.','c. 720–700 BCE')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('jonah-called-to-nineveh','gath-hepher'),
('storm-overtakes-jonahs-ship','mediterranean-open-sea-reference'),
('jonah-cast-into-the-sea','mediterranean-open-sea-reference'),
('great-fish-swallows-jonah','mediterranean-open-sea-reference'),
('jonah-prays-inside-the-fish','mediterranean-open-sea-reference'),
('jonah-vomited-onto-dry-land','joppa'),
('jonah-called-a-second-time','joppa'),
('king-of-nineveh-decrees-repentance','nineveh'),
('jonah-angry-over-the-plant','nineveh'),
('amos-called-from-tekoa','tekoa'),
('amos-vision-of-plumb-line','bethel'),
('amaziah-confronts-amos','bethel'),
('hosea-commanded-to-marry-gomer','samaria-sebaste'),
('gomer-leaves-hosea','samaria-sebaste'),
('hosea-redeems-gomer','samaria-sebaste'),
('uzziah-burns-incense-and-is-struck-with-leprosy','jerusalem'),
('sign-of-immanuel','jerusalem'),
('micah-prophesies-zion-plowed','jerusalem')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('jonah-called-to-nineveh','jonah',0),
('storm-overtakes-jonahs-ship','jonah',0),
('jonah-cast-into-the-sea','jonah',0),
('great-fish-swallows-jonah','jonah',0),
('jonah-prays-inside-the-fish','jonah',0),
('jonah-vomited-onto-dry-land','jonah',0),
('jonah-called-a-second-time','jonah',0),
('king-of-nineveh-decrees-repentance','king-of-nineveh',0),('king-of-nineveh-decrees-repentance','jonah',1),
('jonah-angry-over-the-plant','jonah',0),
('amos-called-from-tekoa','amos',0),
('amos-vision-of-plumb-line','amos',0),
('amaziah-confronts-amos','amaziah-priest-of-bethel',0),('amaziah-confronts-amos','amos',1),
('hosea-commanded-to-marry-gomer','hosea',0),('hosea-commanded-to-marry-gomer','gomer',1),
('gomer-leaves-hosea','gomer',0),('gomer-leaves-hosea','hosea',1),
('hosea-redeems-gomer','hosea',0),('hosea-redeems-gomer','gomer',1),
('uzziah-burns-incense-and-is-struck-with-leprosy','uzziah',0),
('sign-of-immanuel','isaiah',0),('sign-of-immanuel','ahaz',1),
('micah-prophesies-zion-plowed','micah-of-moresheth',0)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES (grouped by book)
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Jonah'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('jonah-called-to-nineveh','storm-overtakes-jonahs-ship','jonah-cast-into-the-sea','great-fish-swallows-jonah',
 'jonah-prays-inside-the-fish','jonah-vomited-onto-dry-land','jonah-called-a-second-time',
 'king-of-nineveh-decrees-repentance','jonah-angry-over-the-plant')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Amos'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('amos-called-from-tekoa','amos-vision-of-plumb-line','amaziah-confronts-amos')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Hosea'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('hosea-commanded-to-marry-gomer','gomer-leaves-hosea','hosea-redeems-gomer')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Isaiah'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('sign-of-immanuel')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Kings'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('uzziah-burns-incense-and-is-struck-with-leprosy','micah-prophesies-zion-plowed')
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS
--    (relation 8 references jeroboam-ii, created by era 07; when testing
--     this file alone that row silently drops -- expected.)
-- -------------------------------------------------------------------------
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('73000000-0000-4000-8008-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'hosea','gomer','spouse','bidirectional','mixed',4,'changed','hosea-commanded-to-marry-gomer',NULL),
(2,'amos','amaziah-priest-of-bethel','adversary','bidirectional','negative',3,'unknown','amaziah-confronts-amos',NULL),
(3,'uzziah','ahaz','family','source_to_target','neutral',2,'unknown',NULL,NULL),
(4,'ahaz','hezekiah','family','source_to_target','neutral',3,'unknown',NULL,NULL),
(5,'isaiah','ahaz','other','bidirectional','mixed',3,'unknown','sign-of-immanuel',NULL),
(6,'isaiah','micah-of-moresheth','other','bidirectional','neutral',2,'unknown',NULL,NULL),
(7,'jonah','king-of-nineveh','other','source_to_target','mixed',2,'unknown','jonah-to-nineveh',NULL),
(8,'amos','jeroboam-ii','adversary','source_to_target','negative',3,'unknown',NULL,NULL)
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
('prophetic-circle','amos'),('prophetic-circle','hosea'),('prophetic-circle','micah-of-moresheth'),
('judahite-court','uzziah'),('judahite-court','ahaz'),
('northern-court','amaziah-priest-of-bethel'),
('opposing-powers','king-of-nineveh')
) AS v(gslug,cslug)
ON g.slug=v.gslug JOIN characters c ON c.slug=v.cslug AND c.work_id=g.work_id
WHERE g.work_id='10000000-0000-4000-8000-000000000005' ON CONFLICT DO NOTHING;

COMMIT;
