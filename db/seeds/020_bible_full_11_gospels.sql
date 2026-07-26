BEGIN;

-- =========================================================================
-- 020_bible_full_11_gospels.sql
-- Chapter K=11 slug='gospels' (Matthew–Luke, the gospel narrative)
-- Adds 11 characters, 4 locations, 15 new events, relations, and reorders
-- the 18 pre-existing gospel events into the 11001-11999 sequence band.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('43000000-0000-4000-8011-000000000001','10000000-0000-4000-8000-000000000005','herod-antipas',1100,'male','adult','antagonist','historical',NULL,NULL,'ruler',3),
('43000000-0000-4000-8011-000000000002','10000000-0000-4000-8000-000000000005','herodias',1101,'female','adult','antagonist','historical',NULL,NULL,'queen',2),
('43000000-0000-4000-8011-000000000003','10000000-0000-4000-8000-000000000005','caiaphas',1102,'male','adult','antagonist','historical',NULL,NULL,'priest',3),
('43000000-0000-4000-8011-000000000004','10000000-0000-4000-8000-000000000005','annas',1103,'male','elder','antagonist','historical',NULL,NULL,'priest',2),
('43000000-0000-4000-8011-000000000005','10000000-0000-4000-8000-000000000005','nicodemus',1104,'male','adult','supporting','unknown',NULL,NULL,'teacher',2),
('43000000-0000-4000-8011-000000000006','10000000-0000-4000-8000-000000000005','joseph-of-arimathea',1105,'male','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8011-000000000007','10000000-0000-4000-8000-000000000005','thomas',1106,'male','adult','supporting','unknown',NULL,NULL,'disciple',3),
('43000000-0000-4000-8011-000000000008','10000000-0000-4000-8000-000000000005','matthew-the-tax-collector',1107,'male','adult','supporting','unknown',NULL,NULL,'disciple',3),
('43000000-0000-4000-8011-000000000009','10000000-0000-4000-8000-000000000005','philip-the-apostle',1108,'male','adult','supporting','unknown',NULL,NULL,'disciple',2),
('43000000-0000-4000-8011-000000000010','10000000-0000-4000-8000-000000000005','james-son-of-zebedee',1109,'male','adult','supporting','unknown',NULL,NULL,'disciple',3),
('43000000-0000-4000-8011-000000000011','10000000-0000-4000-8000-000000000005','zacchaeus',1110,'male','adult','supporting','unknown',NULL,NULL,'person',2)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('herod-antipas','zh-CN','希律·安提帕','大希律之子，加利利与比利亚的分封王。',ARRAY['分封王希律']::text[],'在耶稣与施洗约翰活动的年代统治加利利，因娶兄弟之妻希罗底受约翰谴责，最终下令将约翰斩首；受难叙事中他也曾在耶路撒冷讯问耶稣。','维护王位、颜面与宴席上许下的誓言。'),
('herod-antipas','en','Herod Antipas','Son of Herod the Great, tetrarch of Galilee and Perea.',ARRAY['Herod the tetrarch']::text[],'Ruler of Galilee during the ministries of Jesus and John the Baptist, he was rebuked by John for marrying his brother’s wife Herodias and finally ordered John beheaded; in the passion narrative he also questions Jesus in Jerusalem.','To secure his rule, his honor, and the oath sworn at his banquet.'),
('herodias','zh-CN','希罗底','希律·安提帕之妻，因施洗约翰的谴责而怀恨在心。',ARRAY[]::text[],'先嫁希律家族的另一位兄弟，后改嫁安提帕；因约翰公开谴责这桩婚姻而怀恨，借女儿席间起舞之机求取约翰的首级。','除掉公开羞辱她婚姻的先知。'),
('herodias','en','Herodias','Wife of Herod Antipas, who nursed a grudge against John the Baptist for his rebuke.',ARRAY[]::text[],'First married to another brother of the Herodian house, she then married Antipas; resenting John’s public rebuke of the marriage, she used her daughter’s dance at the banquet to demand John’s head.','To silence the prophet who publicly shamed her marriage.'),
('caiaphas','zh-CN','该亚法','耶稣受难年间在任的犹太大祭司。',ARRAY[]::text[],'约瑟·该亚法约于公元 18–36 年任大祭司，在公会中主导对耶稣的审问，并将他解交罗马巡抚彼拉多；刻有其家族名字的藏骨匣出土，使他成为有实物印证的人物。','维护圣殿体制与祭司集团的地位。'),
('caiaphas','en','Caiaphas','The Jewish high priest in office during the passion of Jesus.',ARRAY[]::text[],'Joseph Caiaphas served as high priest around 18–36 CE, presided over the council’s interrogation of Jesus, and handed him over to the Roman governor Pontius Pilate; an inscribed ossuary has linked his family to the archaeological record.','To protect the temple establishment and the priestly order.'),
('annas','zh-CN','亚那','前任大祭司，该亚法的岳父。',ARRAY[]::text[],'约公元 6–15 年任大祭司，去职后仍在耶路撒冷的祭司集团中举足轻重；约翰福音记载耶稣被捕后先被解到他面前受讯。','延续家族在圣殿中的势力。'),
('annas','en','Annas','A former high priest and the father-in-law of Caiaphas.',ARRAY[]::text[],'High priest from about 6 to 15 CE, he remained a power within the Jerusalem priesthood after leaving office; John’s Gospel records that Jesus was first taken to him for questioning after the arrest.','To preserve his family’s hold on the temple.'),
('nicodemus','zh-CN','尼哥底母','法利赛人、犹太公会成员，夜里来访耶稣。',ARRAY[]::text[],'约翰福音记载他夜访耶稣讨论重生，后在公会中为耶稣说公道话，最终与亚利马太的约瑟一同安葬耶稣。','在体制身份与内心求索之间寻求真理。'),
('nicodemus','en','Nicodemus','A Pharisee and council member who visited Jesus by night.',ARRAY[]::text[],'John’s Gospel records his night visit to discuss being born anew; he later speaks up for Jesus in the council and finally joins Joseph of Arimathea in burying him.','To seek truth between official standing and inner searching.'),
('joseph-of-arimathea','zh-CN','亚利马太的约瑟','富有的公会成员，将自己的新坟墓让出安葬耶稣。',ARRAY[]::text[],'四卷福音书都记载他向彼拉多求领耶稣的遗体，用细麻布包裹，安放在自己凿好的新坟墓里。','以体面的安葬表达对耶稣的敬意。'),
('joseph-of-arimathea','en','Joseph of Arimathea','A wealthy council member who gave his own new tomb for the burial of Jesus.',ARRAY[]::text[],'All four Gospels record that he asked Pilate for the body of Jesus, wrapped it in linen, and laid it in his own newly cut tomb.','To honor Jesus with a dignified burial.'),
('thomas','zh-CN','多马','十二使徒之一，因要求亲见钉痕而被称为“多疑的多马”。',ARRAY['低土马']::text[],'约翰福音记载他声言非摸到钉痕不肯相信复活，八天后见到显现的耶稣，说出“我的主，我的神”。','眼见为实的求证之心。'),
('thomas','en','Thomas','One of the Twelve, remembered as “doubting Thomas” for demanding to see the nail marks.',ARRAY['Didymus']::text[],'John’s Gospel records his insistence on touching the wounds before believing; eight days later, seeing the risen Jesus, he answers, “My Lord and my God.”','A need to see and verify before believing.'),
('matthew-the-tax-collector','zh-CN','马太（税吏）','从税关被呼召的使徒，传统上与第一卷福音书相联系。',ARRAY['利未']::text[],'在迦百农的税关上被耶稣呼召，随即撇下职务跟从，并在家中设宴款待税吏与罪人；教会传统将《马太福音》与他的名字联系起来。','离开旧业，跟从呼召。'),
('matthew-the-tax-collector','en','Matthew the tax collector','An apostle called from the tax booth, traditionally linked with the first Gospel.',ARRAY['Levi']::text[],'Called by Jesus at the tax booth in Capernaum, he leaves his post at once and hosts a banquet for tax collectors and sinners; church tradition attaches his name to the Gospel of Matthew.','To leave his old trade and follow the call.'),
('philip-the-apostle','zh-CN','腓力（使徒）','来自伯赛大的使徒，五饼二鱼叙事中被耶稣考问。',ARRAY[]::text[],'约翰福音记载他引拿但业来见耶稣；在使五千人吃饱的场景中，耶稣以“从哪里买饼给这些人吃”考问他。','跟从耶稣并引人来认识他。'),
('philip-the-apostle','en','Philip the Apostle','An apostle from Bethsaida, questioned by Jesus in the feeding narrative.',ARRAY[]::text[],'John’s Gospel records him bringing Nathanael to Jesus; in the feeding of the five thousand, Jesus tests him with the question of where bread could be bought for the crowd.','To follow Jesus and bring others to meet him.'),
('james-son-of-zebedee','zh-CN','雅各（西庇太之子）','西庇太之子、约翰的兄长，耶稣核心三门徒之一。',ARRAY[]::text[],'与彼得、约翰同为登山变像与客西马尼祷告的见证人；耶稣称这对兄弟为“雷子”。','在核心圈中紧紧跟随师傅。'),
('james-son-of-zebedee','en','James son of Zebedee','Son of Zebedee and brother of John, one of Jesus’ inner three disciples.',ARRAY[]::text[],'With Peter and John he witnesses the transfiguration and the prayer at Gethsemane; Jesus names the two brothers “sons of thunder.”','To follow his teacher closely within the inner circle.'),
('zacchaeus','zh-CN','撒该','耶利哥的税吏长，因爬上桑树看耶稣而闻名。',ARRAY[]::text[],'路加福音记载他身量矮小，爬上桑树要看耶稣，被点名接待后当场承诺把一半家产分给穷人、讹诈的四倍偿还。','渴望亲眼见到耶稣并重新做人。'),
('zacchaeus','en','Zacchaeus','The chief tax collector of Jericho, famous for climbing a sycamore tree to see Jesus.',ARRAY[]::text[],'Luke’s Gospel records that, being short, he climbed a sycamore to see Jesus; singled out as host, he pledges half his goods to the poor and fourfold restitution for fraud.','A longing to see Jesus and to start over.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. LOCATIONS (4 new: temptation mount, mount of beatitudes, Machaerus,
--    Caesarea Philippi; all others reused via slug JOIN)
-- -------------------------------------------------------------------------
INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('33000000-0000-4000-8011-000000000001','10000000-0000-4000-8000-000000000005','mount-of-temptation-traditional','real',ST_GeogFromText('POINT(35.4297 31.8744)'),NULL,NULL,1100,'religious_site','inferred',12,'PS',true,true),
('33000000-0000-4000-8011-000000000002','10000000-0000-4000-8000-000000000005','mount-of-beatitudes','real',ST_GeogFromText('POINT(35.5560 32.8817)'),NULL,NULL,1101,'religious_site','inferred',13,'IL',true,true),
('33000000-0000-4000-8011-000000000003','10000000-0000-4000-8000-000000000005','machaerus','real',ST_GeogFromText('POINT(35.6244 31.5672)'),NULL,NULL,1102,'landmark','exact',13,'JO',false,true),
('33000000-0000-4000-8011-000000000004','10000000-0000-4000-8000-000000000005','caesarea-philippi','real',ST_GeogFromText('POINT(35.6944 33.2481)'),NULL,NULL,1103,'city','exact',13,'IL',false,true)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,status,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',ARRAY[]::text[],'','','','',v.region FROM locations l JOIN (VALUES
('mount-of-temptation-traditional','zh-CN','试探山（传统位置）','传统上认定耶稣禁食受试探的犹太旷野山地，位于耶利哥以西。','犹太旷野'),
('mount-of-temptation-traditional','en','Mount of Temptation (traditional site)','The height in the Judean wilderness west of Jericho traditionally identified with Jesus’ temptation.','Judean Wilderness'),
('mount-of-beatitudes','zh-CN','八福山（传统位置）','传统上认定耶稣宣讲登山宝训的加利利湖畔山坡。','加利利'),
('mount-of-beatitudes','en','Mount of Beatitudes (traditional site)','The hillside above the Sea of Galilee traditionally identified with the Sermon on the Mount.','Galilee'),
('machaerus','zh-CN','马凯鲁斯要塞','希律家族在死海东岸的山顶要塞，约瑟夫斯记载施洗约翰在此被处决。','比利亚'),
('machaerus','en','Machaerus','A Herodian hilltop fortress east of the Dead Sea, where Josephus places the execution of John the Baptist.','Perea'),
('caesarea-philippi','zh-CN','凯撒利亚·腓立比','黑门山麓的希腊化城市，彼得在此境内承认耶稣是基督。','黑门山麓'),
('caesarea-philippi','en','Caesarea Philippi','A Hellenistic city at the foot of Mount Hermon, in whose district Peter confessed Jesus as the Christ.','Foot of Mount Hermon')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug AND l.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 3. EVENTS (15 new) -- range dating within -6..33, chapter 'gospels'
-- -------------------------------------------------------------------------
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('63000000-0000-4000-8011-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'unknown'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'visit-of-the-magi',11005,'legendary_or_mythic','meeting','range',-5::integer,-4::integer,'low','gospels'),
(2,'boy-jesus-in-the-temple',11011,'reported_historical','religious','range',6,9,'low','gospels'),
(3,'temptation-in-the-wilderness',11015,'legendary_or_mythic','trial','range',26,29,'low','gospels'),
(4,'nicodemus-visits-by-night',11021,'reported_historical','meeting','range',27,30,'low','gospels'),
(5,'sermon-on-the-mount',11027,'reported_historical','religious','range',28,31,'medium','gospels'),
(6,'beheading-of-john-the-baptist',11029,'reported_historical','death','range',28,32,'medium','gospels'),
(7,'feeding-of-the-five-thousand',11031,'legendary_or_mythic','other','range',28,32,'low','gospels'),
(8,'peters-confession-at-caesarea-philippi',11033,'reported_historical','meeting','range',28,32,'medium','gospels'),
(9,'zacchaeus-in-jericho',11039,'reported_historical','meeting','range',29,33,'low','gospels'),
(10,'cleansing-of-the-temple',11043,'reported_historical','religious','range',30,33,'medium','gospels'),
(11,'agony-at-gethsemane',11047,'reported_historical','religious','range',30,33,'medium','gospels'),
(12,'peter-denies-jesus-three-times',11051,'reported_historical','betrayal','range',30,33,'medium','gospels'),
(13,'burial-by-joseph-of-arimathea',11057,'reported_historical','death','range',30,33,'medium','gospels'),
(14,'thomas-doubts-and-believes',11063,'legendary_or_mythic','meeting','range',30,33,'low','gospels'),
(15,'ascension-from-the-mount-of-olives',11065,'legendary_or_mythic','religious','range',30,33,'low','gospels')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,conf,chapter_slug)
JOIN chapters ch ON ch.slug=v.chapter_slug AND ch.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 4. Reorder the 18 existing gospel events into the 11001-11999 band
-- -------------------------------------------------------------------------
UPDATE events e SET sequence=v.seq FROM (VALUES
  ('annunciation-at-nazareth',11001),
  ('birth-of-jesus',11003),
  ('flight-to-egypt',11007),
  ('return-to-nazareth',11009),
  ('baptism-at-the-jordan',11013),
  ('calling-of-the-first-disciples',11017),
  ('first-sign-at-cana',11019),
  ('conversation-at-jacobs-well',11023),
  ('galilean-ministry',11025),
  ('transfiguration-on-tabor',11035),
  ('raising-of-lazarus',11037),
  ('entry-into-jerusalem',11041),
  ('last-supper',11045),
  ('arrest-on-the-mount-of-olives',11049),
  ('trial-before-pilate',11053),
  ('crucifixion-in-jerusalem',11055),
  ('empty-tomb',11059),
  ('road-to-emmaus',11061)
) AS v(slug,seq) WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug=v.slug;

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tlabel FROM events e JOIN (VALUES
('visit-of-the-magi','zh-CN','博士来朝','几位来自东方的博士循星而来，在伯利恒朝拜孩童耶稣。','他们先到耶路撒冷向大希律打听“生下来作犹太人之王的”，随后循星找到孩童，献上黄金、乳香、没药，又因梦中受警戒而从别的路回去。','这一朝拜场景成为后世主显节传统的核心，也引出希律的猜忌与逃往埃及的叙事。','约公元前 5–4 年'),
('visit-of-the-magi','en','Visit of the Magi','Wise men from the east follow a star to honor the child Jesus at Bethlehem.','They first ask Herod the Great in Jerusalem about “the one born king of the Jews,” then follow the star to the child, presenting gold, frankincense, and myrrh, and return by another road after a warning in a dream.','The scene becomes the core of the later Epiphany tradition and sets up Herod’s suspicion and the flight to Egypt.','c. 5–4 BCE'),
('boy-jesus-in-the-temple','zh-CN','少年耶稣在圣殿','十二岁的耶稣逾越节后留在圣殿，坐在教师中间问答。','父母走了一天的路才发觉他不在同行的人群中，回耶路撒冷找了三天，发现他在圣殿里一面听一面问，众人都希奇他的聪明。','福音书中耶稣童年与公开传道之间唯一的记载。','约公元 6–9 年'),
('boy-jesus-in-the-temple','en','The boy Jesus in the temple','At twelve, Jesus stays behind after Passover, sitting among the teachers in the temple.','His parents travel a day before missing him, then search Jerusalem for three days and find him in the temple, listening and asking questions, to the amazement of all.','The only recorded episode between Jesus’ infancy and his public ministry.','c. 6–9 CE'),
('temptation-in-the-wilderness','zh-CN','旷野受试探','受洗之后，耶稣被圣灵引到旷野禁食四十天，受魔鬼试探。','试探围绕石头变饼、从殿顶跳下、万国荣华三个场景展开，耶稣均引用经文回答；魔鬼暂时离开了他。','被视为公开传道之前的预备与考验。','约公元 26–29 年'),
('temptation-in-the-wilderness','en','Temptation in the wilderness','After his baptism, Jesus fasts forty days in the wilderness and is tempted by the devil.','The temptations unfold in three scenes—stones into bread, the pinnacle of the temple, and the kingdoms of the world—and Jesus answers each from scripture before the devil departs for a time.','Read as the testing that precedes the public ministry.','c. 26–29 CE'),
('nicodemus-visits-by-night','zh-CN','尼哥底母夜访','法利赛人尼哥底母夜里来见耶稣，谈论人如何重生。','对话围绕“人若不重生，就不能见神的国”展开，并引出“神爱世人”的著名总结。','约翰福音神学的重要场景，也开启尼哥底母贯穿全书的暗线。','约公元 27–30 年'),
('nicodemus-visits-by-night','en','Nicodemus visits by night','The Pharisee Nicodemus comes to Jesus at night to ask about being born anew.','The conversation turns on the saying that no one can see the kingdom of God without being born again, and leads into the famous summary that God so loved the world.','A key theological scene in John’s Gospel, opening Nicodemus’ quiet thread through the book.','c. 27–30 CE'),
('sermon-on-the-mount','zh-CN','登山宝训','耶稣在加利利的山坡上向门徒与群众宣讲天国的伦理。','马太福音五至七章汇集了八福、盐与光、爱仇敌与主祷文等教导，结尾以听道行道的比喻收束。','被视为耶稣教导最集中的纲领性篇章。','约公元 28–31 年'),
('sermon-on-the-mount','en','The Sermon on the Mount','On a Galilean hillside Jesus teaches the ethics of the kingdom to disciples and crowds.','Matthew 5–7 gathers the Beatitudes, salt and light, love of enemies, and the Lord’s Prayer, closing with the parable of hearers and doers.','Regarded as the most concentrated summary of Jesus’ teaching.','c. 28–31 CE'),
('beheading-of-john-the-baptist','zh-CN','施洗约翰被斩','希律·安提帕在生日宴席上应希罗底之女所求，斩了施洗约翰。','约翰因谴责安提帕娶希罗底而被囚；宴席间少女起舞得王欢心，在母亲指使下求约翰的头。约瑟夫斯记载约翰死于马凯鲁斯要塞。','先知与王权冲突的标志性事件，另见于域外史料的记载。','约公元 28–32 年'),
('beheading-of-john-the-baptist','en','Beheading of John the Baptist','At his birthday banquet Herod Antipas grants the request of Herodias’ daughter and has John the Baptist beheaded.','John had been imprisoned for condemning Antipas’ marriage to Herodias; the girl’s dance pleases the king, and at her mother’s prompting she asks for John’s head. Josephus places the execution at the fortress of Machaerus.','An emblematic clash of prophet and throne, also attested outside the Gospels.','c. 28–32 CE'),
('feeding-of-the-five-thousand','zh-CN','五饼二鱼使五千人吃饱','耶稣以五个饼、两条鱼使五千人吃饱。','耶稣以“从哪里买饼给这些人吃”考问腓力，安得烈带来一个有五饼二鱼的孩童；众人坐在草地上分食，剩下的零碎装满十二个篮子。','唯一被四卷福音书共同记载的神迹。','约公元 28–32 年'),
('feeding-of-the-five-thousand','en','Feeding of the five thousand','Jesus feeds five thousand people with five loaves and two fish.','Jesus tests Philip with the question of where bread could be bought, and Andrew brings a boy with five loaves and two fish; the crowd eats seated on the grass, and twelve baskets of fragments remain.','The only miracle recorded in all four Gospels.','c. 28–32 CE'),
('peters-confession-at-caesarea-philippi','zh-CN','彼得在凯撒利亚·腓立比认信','在凯撒利亚·腓立比境内，彼得承认耶稣是基督。','耶稣问门徒“你们说我是谁”，彼得答“你是基督，是永生神的儿子”；耶稣随即第一次预言自己将在耶路撒冷受难。','福音书叙事由加利利传道转向耶路撒冷受难的枢纽。','约公元 28–32 年'),
('peters-confession-at-caesarea-philippi','en','Peter’s confession at Caesarea Philippi','In the district of Caesarea Philippi, Peter confesses Jesus as the Christ.','Jesus asks the disciples who they say he is, and Peter answers, “You are the Christ, the Son of the living God”; Jesus then foretells his suffering in Jerusalem for the first time.','The hinge where the narrative turns from Galilean ministry toward the passion in Jerusalem.','c. 28–32 CE'),
('zacchaeus-in-jericho','zh-CN','撒该在耶利哥接待耶稣','税吏长撒该爬上桑树看耶稣，被点名到家中接待。','撒该当场承诺把一半家产分给穷人，讹诈的四倍偿还；耶稣宣告“今天救恩到了这家”。','路加福音“人子来寻找拯救失丧的人”主题的代表场景。','约公元 29–33 年'),
('zacchaeus-in-jericho','en','Zacchaeus hosts Jesus at Jericho','The chief tax collector Zacchaeus climbs a sycamore to see Jesus and is called down to be his host.','Zacchaeus pledges half his goods to the poor and fourfold restitution for fraud, and Jesus declares that salvation has come to this house today.','A signature scene of Luke’s theme that the Son of Man came to seek the lost.','c. 29–33 CE'),
('cleansing-of-the-temple','zh-CN','洁净圣殿','耶稣进入圣殿，赶出作买卖的人，推倒兑换银钱之人的桌子。','他引用经文说“我的殿必称为祷告的殿”，指责人使它成了贼窝；祭司长与文士听见就想法子要除灭他。','受难周叙事中触发当权者敌意的关键行动。','约公元 30–33 年'),
('cleansing-of-the-temple','en','Cleansing of the temple','Jesus enters the temple, drives out the traders, and overturns the money-changers’ tables.','Quoting scripture that his house shall be called a house of prayer, he charges them with making it a den of robbers; the chief priests and scribes begin seeking a way to destroy him.','The decisive act of passion week that hardens the authorities against him.','c. 30–33 CE'),
('agony-at-gethsemane','zh-CN','客西马尼园的恳切祷告','最后晚餐之后，耶稣在客西马尼园极其伤痛地祷告。','他带彼得与西庇太的两个儿子同去，三次祷告“不要照我的意思，只要照你的意思”，门徒却因困倦睡着了。','受难叙事中刻画耶稣内心挣扎最深的场景。','约公元 30–33 年'),
('agony-at-gethsemane','en','The agony at Gethsemane','After the last supper, Jesus prays in deep anguish in the garden of Gethsemane.','Taking Peter and the two sons of Zebedee, he prays three times, “not as I will, but as you will,” while the disciples fall asleep from sorrow and fatigue.','The scene that portrays Jesus’ inner struggle most deeply in the passion narrative.','c. 30–33 CE'),
('peter-denies-jesus-three-times','zh-CN','彼得三次不认主','耶稣受审的当夜，彼得在大祭司的院子里三次否认认识他。','正如晚餐时的预言，鸡叫以先彼得三次不认主；鸡叫时他想起耶稣的话，就出去痛哭。','门徒软弱与悔改主题的经典场景，与受审叙事平行展开。','约公元 30–33 年'),
('peter-denies-jesus-three-times','en','Peter denies Jesus three times','On the night of the trial, Peter denies knowing Jesus three times in the high priest’s courtyard.','As foretold at supper, Peter denies him three times before the rooster crows; at the crow he remembers Jesus’ words and goes out weeping bitterly.','A classic scene of a disciple’s weakness and remorse, unfolding in parallel with the trial.','c. 30–33 CE'),
('burial-by-joseph-of-arimathea','zh-CN','亚利马太的约瑟安葬耶稣','亚利马太的约瑟求得耶稣的遗体，安放在自己的新坟墓里。','尼哥底母带着没药与沉香同来，二人用细麻布与香料按犹太人的规矩裹好遗体；妇女们看着安放的地方。','为空坟墓叙事提供直接的场景铺垫。','约公元 30–33 年'),
('burial-by-joseph-of-arimathea','en','Burial by Joseph of Arimathea','Joseph of Arimathea obtains the body of Jesus and lays it in his own new tomb.','Nicodemus joins him with myrrh and aloes, and they wrap the body with linen and spices according to Jewish custom, while the women watch where it is laid.','Sets the immediate scene for the empty-tomb narrative.','c. 30–33 CE'),
('thomas-doubts-and-believes','zh-CN','多马疑而后信','多马声言非见钉痕不信，八天后见到复活的耶稣而认信。','耶稣对他说“伸过你的指头来，摸我的手”，多马回答“我的主，我的神”；耶稣说“那没有看见就信的有福了”。','复活叙事中关于怀疑与信心的著名场景。','约公元 30–33 年'),
('thomas-doubts-and-believes','en','Thomas doubts and believes','Thomas refuses to believe without seeing the nail marks, then confesses when the risen Jesus appears a week later.','Jesus invites him to put his finger in the wounds, and Thomas answers, “My Lord and my God”; Jesus adds that those who believe without seeing are blessed.','The famous scene of doubt and faith within the resurrection narrative.','c. 30–33 CE'),
('ascension-from-the-mount-of-olives','zh-CN','耶稣在橄榄山升天','复活显现结束时，耶稣在橄榄山一带被接升天。','路加福音记载他领门徒出去，直到伯大尼的对面，举手祝福他们的时候离开他们；门徒大大欢喜，回耶路撒冷等候。','福音书叙事的终点，衔接使徒行传五旬节的开端。','约公元 30–33 年'),
('ascension-from-the-mount-of-olives','en','Ascension from the Mount of Olives','At the close of the resurrection appearances, Jesus is taken up near the Mount of Olives.','Luke records that he leads the disciples out toward Bethany and is parted from them while blessing them with lifted hands; they return to Jerusalem with great joy to wait.','The ending of the gospel narrative, bridging to Pentecost in Acts.','c. 30–33 CE')
) AS v(slug,locale,title,summary,detail,sig,tlabel) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('visit-of-the-magi','bethlehem'),
('boy-jesus-in-the-temple','jerusalem'),
('temptation-in-the-wilderness','mount-of-temptation-traditional'),
('nicodemus-visits-by-night','jerusalem'),
('sermon-on-the-mount','mount-of-beatitudes'),
('beheading-of-john-the-baptist','machaerus'),
('feeding-of-the-five-thousand','bethsaida'),
('peters-confession-at-caesarea-philippi','caesarea-philippi'),
('zacchaeus-in-jericho','jericho'),
('cleansing-of-the-temple','jerusalem'),
('agony-at-gethsemane','mount-of-olives'),
('peter-denies-jesus-three-times','jerusalem'),
('burial-by-joseph-of-arimathea','golgotha-traditional'),
('thomas-doubts-and-believes','jerusalem'),
('ascension-from-the-mount-of-olives','mount-of-olives')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('visit-of-the-magi','jesus',0),('visit-of-the-magi','mary',1),('visit-of-the-magi','joseph-of-nazareth',2),('visit-of-the-magi','herod-the-great',3),
('boy-jesus-in-the-temple','jesus',0),('boy-jesus-in-the-temple','mary',1),('boy-jesus-in-the-temple','joseph-of-nazareth',2),
('temptation-in-the-wilderness','jesus',0),
('nicodemus-visits-by-night','jesus',0),('nicodemus-visits-by-night','nicodemus',1),
('sermon-on-the-mount','jesus',0),('sermon-on-the-mount','peter',1),('sermon-on-the-mount','matthew-the-tax-collector',2),('sermon-on-the-mount','john-son-of-zebedee',3),
('beheading-of-john-the-baptist','john-the-baptist',0),('beheading-of-john-the-baptist','herod-antipas',1),('beheading-of-john-the-baptist','herodias',2),
('feeding-of-the-five-thousand','jesus',0),('feeding-of-the-five-thousand','philip-the-apostle',1),('feeding-of-the-five-thousand','andrew',2),
('peters-confession-at-caesarea-philippi','peter',0),('peters-confession-at-caesarea-philippi','jesus',1),('peters-confession-at-caesarea-philippi','james-son-of-zebedee',2),('peters-confession-at-caesarea-philippi','john-son-of-zebedee',3),
('zacchaeus-in-jericho','zacchaeus',0),('zacchaeus-in-jericho','jesus',1),
('cleansing-of-the-temple','jesus',0),
('agony-at-gethsemane','jesus',0),('agony-at-gethsemane','peter',1),('agony-at-gethsemane','james-son-of-zebedee',2),('agony-at-gethsemane','john-son-of-zebedee',3),
('peter-denies-jesus-three-times','peter',0),('peter-denies-jesus-three-times','jesus',1),('peter-denies-jesus-three-times','caiaphas',2),('peter-denies-jesus-three-times','annas',3),
('burial-by-joseph-of-arimathea','joseph-of-arimathea',0),('burial-by-joseph-of-arimathea','nicodemus',1),('burial-by-joseph-of-arimathea','jesus',2),('burial-by-joseph-of-arimathea','mary-magdalene',3),
('thomas-doubts-and-believes','thomas',0),('thomas-doubts-and-believes','jesus',1),
('ascension-from-the-mount-of-olives','jesus',0),('ascension-from-the-mount-of-olives','peter',1),('ascension-from-the-mount-of-olives','john-son-of-zebedee',2),('ascension-from-the-mount-of-olives','james-son-of-zebedee',3),('ascension-from-the-mount-of-olives','thomas',4),('ascension-from-the-mount-of-olives','matthew-the-tax-collector',5),('ascension-from-the-mount-of-olives','philip-the-apostle',6)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES (grouped per gospel)
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Gospel according to Matthew'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('visit-of-the-magi','temptation-in-the-wilderness','sermon-on-the-mount','peters-confession-at-caesarea-philippi','cleansing-of-the-temple','peter-denies-jesus-three-times')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Gospel according to Mark'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('beheading-of-john-the-baptist','agony-at-gethsemane')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Gospel according to Luke'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('boy-jesus-in-the-temple','zacchaeus-in-jericho','ascension-from-the-mount-of-olives')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Gospel according to John'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN
('nicodemus-visits-by-night','feeding-of-the-five-thousand','burial-by-joseph-of-arimathea','thomas-doubts-and-believes')
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS
-- -------------------------------------------------------------------------
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('73000000-0000-4000-8011-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'herod-antipas','herodias','spouse','bidirectional','mixed',3,'active',NULL,NULL),
(2,'herod-antipas','john-the-baptist','adversary','bidirectional','negative',4,'ended',NULL,'beheading-of-john-the-baptist'),
(3,'herodias','john-the-baptist','adversary','source_to_target','negative',4,'ended',NULL,'beheading-of-john-the-baptist'),
(4,'herod-the-great','herod-antipas','family','source_to_target','neutral',2,'unknown',NULL,NULL),
(5,'annas','caiaphas','family','source_to_target','neutral',3,'active',NULL,NULL),
(6,'caiaphas','jesus','adversary','source_to_target','negative',4,'ended',NULL,'crucifixion-in-jerusalem'),
(7,'jesus','nicodemus','mentor','source_to_target','positive',3,'active','nicodemus-visits-by-night',NULL),
(8,'joseph-of-arimathea','jesus','ally','source_to_target','positive',3,'active','burial-by-joseph-of-arimathea',NULL),
(9,'jesus','thomas','mentor','source_to_target','positive',4,'active',NULL,NULL),
(10,'jesus','matthew-the-tax-collector','mentor','source_to_target','positive',4,'active',NULL,NULL),
(11,'jesus','philip-the-apostle','mentor','source_to_target','positive',4,'active',NULL,NULL),
(12,'jesus','james-son-of-zebedee','mentor','source_to_target','positive',4,'active',NULL,NULL),
(13,'james-son-of-zebedee','john-son-of-zebedee','sibling','bidirectional','positive',4,'active',NULL,NULL),
(14,'jesus','zacchaeus','other','source_to_target','positive',2,'active','zacchaeus-in-jericho',NULL)
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
('galilean-disciples','thomas'),('galilean-disciples','matthew-the-tax-collector'),
('galilean-disciples','philip-the-apostle'),('galilean-disciples','james-son-of-zebedee'),
('roman-authorities','herod-antipas'),('roman-authorities','herodias')
) AS v(gslug,cslug)
ON g.slug=v.gslug JOIN characters c ON c.slug=v.cslug AND c.work_id=g.work_id
WHERE g.work_id='10000000-0000-4000-8000-000000000005' ON CONFLICT DO NOTHING;

COMMIT;
