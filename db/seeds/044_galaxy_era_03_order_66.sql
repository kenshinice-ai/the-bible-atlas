BEGIN;

-- Era 03 · order-66-and-imperial-rise (19 BBY, database years -20..-19)
--
-- The pivot of the Skywalker line, so this era keeps its density where the
-- family and the Jedi are concerned; nothing else is elaborated. No new
-- characters: everyone who matters here already exists. Band 3001-3999.

-- ============================================================
-- 1. EVENTS
-- ============================================================

INSERT INTO events(id,work_id,slug,start_date,end_date,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,start_month,start_day,confidence,chapter_id) VALUES
('68000000-0000-4000-8003-000000000001','10000000-0000-4000-8000-000000000008','the-battle-of-coruscant',NULL,NULL,3001,'fictional_narrative','battle','fictional_calendar','fictional',-20,-20,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000002','10000000-0000-4000-8000-000000000008','anakin-executes-dooku',NULL,NULL,3003,'fictional_narrative','death','fictional_calendar','fictional',-20,-20,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000003','10000000-0000-4000-8000-000000000008','anakin-foresees-padmes-death',NULL,NULL,3005,'legendary_or_mythic','discovery','fictional_calendar','fictional',-20,-20,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000004','10000000-0000-4000-8000-000000000008','anakin-placed-on-the-council',NULL,NULL,3007,'fictional_narrative','political','fictional_calendar','fictional',-20,-20,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000005','10000000-0000-4000-8000-000000000008','obi-wan-sent-after-grievous',NULL,NULL,3009,'fictional_narrative','journey','fictional_calendar','fictional',-20,-19,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000006','10000000-0000-4000-8000-000000000008','palpatine-reveals-himself',NULL,NULL,3011,'fictional_narrative','betrayal','fictional_calendar','fictional',-19,-19,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000007','10000000-0000-4000-8000-000000000008','grievous-killed-on-utapau',NULL,NULL,3013,'fictional_narrative','death','fictional_calendar','fictional',-19,-19,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000008','10000000-0000-4000-8000-000000000008','mace-windu-confronts-palpatine',NULL,NULL,3015,'fictional_narrative','battle','fictional_calendar','fictional',-19,-19,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000009','10000000-0000-4000-8000-000000000008','anakin-becomes-darth-vader',NULL,NULL,3017,'fictional_narrative','betrayal','fictional_calendar','fictional',-19,-19,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000010','10000000-0000-4000-8000-000000000008','order-66',NULL,NULL,3019,'fictional_narrative','betrayal','fictional_calendar','fictional',-19,-19,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000011','10000000-0000-4000-8000-000000000008','the-jedi-temple-falls',NULL,NULL,3021,'fictional_narrative','battle','fictional_calendar','fictional',-19,-19,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000012','10000000-0000-4000-8000-000000000008','the-empire-is-declared',NULL,NULL,3023,'fictional_narrative','political','fictional_calendar','fictional',-19,-19,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000013','10000000-0000-4000-8000-000000000008','yoda-fails-against-sidious',NULL,NULL,3025,'fictional_narrative','battle','fictional_calendar','fictional',-19,-19,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000014','10000000-0000-4000-8000-000000000008','the-duel-on-mustafar',NULL,NULL,3027,'fictional_narrative','battle','fictional_calendar','fictional',-19,-19,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000015','10000000-0000-4000-8000-000000000008','the-twins-are-born',NULL,NULL,3029,'fictional_narrative','birth','fictional_calendar','fictional',-19,-19,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000016','10000000-0000-4000-8000-000000000008','padme-amidala-dies',NULL,NULL,3031,'fictional_narrative','death','fictional_calendar','fictional',-19,-19,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000017','10000000-0000-4000-8000-000000000008','vader-is-remade',NULL,NULL,3033,'fictional_narrative','other','fictional_calendar','fictional',-19,-19,NULL,NULL,'high','88000000-0000-4000-8003-000000000001'),
('68000000-0000-4000-8003-000000000018','10000000-0000-4000-8000-000000000008','the-twins-are-hidden',NULL,NULL,3035,'fictional_narrative','migration','fictional_calendar','fictional',-19,-19,NULL,NULL,'high','88000000-0000-4000-8003-000000000001');

INSERT INTO event_translations(event_id,locale,title,summary,detail,significance,time_label,status) VALUES
('68000000-0000-4000-8003-000000000001','zh-CN','科洛桑上空之战','分离主义舰队突袭首都并劫走最高议长,绝地登舰营救。','','','雅汶战役前 20 年','published'),
('68000000-0000-4000-8003-000000000001','en','The battle over Coruscant','A Separatist fleet raids the capital and takes the Chancellor; the Jedi board to bring him back.','','','20 BBY','published'),
('68000000-0000-4000-8003-000000000002','zh-CN','阿纳金处决杜库','阿纳金制服杜库后,在帕尔帕廷的怂恿下当场将其斩杀。','俘虏已经缴械跪地,阿纳金仍然动手;影片让他立刻说出这不合规矩,然后接受了对方的宽慰。','这是他第一次在有人授意下越界,而授意者正是他最信任的人。','雅汶战役前 20 年','published'),
('68000000-0000-4000-8003-000000000002','en','Anakin executes Dooku','Anakin disarms Dooku and, urged on by Palpatine, kills him where he kneels.','The prisoner is disarmed and on his knees and Anakin strikes anyway; the film has him say at once that it was not right, and then accept being told otherwise.','The first line he crosses at another man’s prompting — and the man prompting is the one he trusts most.','20 BBY','published'),
('68000000-0000-4000-8003-000000000003','zh-CN','阿纳金预见帕德梅之死','帕德梅告知怀孕,阿纳金随即梦见她死于分娩。','影片让这个梦与母亲那次同构,而他已经学会相信自己的梦。','他要阻止的不再是一个抽象的失去,而是一个他确信会发生的画面。','雅汶战役前 20 年','published'),
('68000000-0000-4000-8003-000000000003','en','Anakin foresees Padmé’s death','Padmé tells him she is pregnant, and he begins dreaming that she dies giving birth.','The film makes the dream the same shape as the one about his mother, and by now he has learned to believe his dreams.','What he sets out to prevent is no longer an abstract loss but an image he is certain of.','20 BBY','published'),
('68000000-0000-4000-8003-000000000004','zh-CN','阿纳金被安插进委员会','最高议长指派阿纳金进入绝地委员会,委员会接纳其人却拒授大师衔。','两边都在利用他:一边要他监视委员会,一边要他监视议长。影片让他同时被两个自己效忠的机构当成工具。','他的被侮辱感是被精心制造出来的,而制造者随后提供了唯一的安慰。','雅汶战役前 20 年','published'),
('68000000-0000-4000-8003-000000000004','en','Anakin is placed on the council','The Chancellor appoints Anakin to the Jedi council, which seats him but withholds the rank of master.','Both sides are using him: one wants him watching the council, the other wants him watching the Chancellor. The film has both institutions he serves treat him as an instrument.','His sense of being slighted is manufactured, and the manufacturer then offers the only comfort available.','20 BBY','published'),
('68000000-0000-4000-8003-000000000005','zh-CN','欧比旺受命追击格里弗斯','委员会派欧比旺远赴乌塔帕追击格里弗斯,阿纳金被留在首都。','','','雅汶战役前 20 至 19 年','published'),
('68000000-0000-4000-8003-000000000005','en','Obi-Wan is sent after Grievous','The council sends Obi-Wan to Utapau after Grievous, leaving Anakin in the capital.','','','c. 20–19 BBY','published'),
('68000000-0000-4000-8003-000000000006','zh-CN','帕尔帕廷向阿纳金摊牌','帕尔帕廷承认自己就是西斯尊主,并允诺教他阻止所爱之人死去的方法。','影片让摊牌发生在一场歌剧里:他先把阿纳金的孤立感说透,再把唯一的出路摆出来。','整场堕落的交易条款在此讲明——用一个人的性命换他的效忠。','雅汶战役前 19 年','published'),
('68000000-0000-4000-8003-000000000006','en','Palpatine reveals himself','Palpatine admits he is the Sith lord and offers to teach Anakin how to keep the people he loves from dying.','The film stages it at an opera: he first names Anakin’s isolation exactly, then lays out the only way out of it.','The terms of the whole fall are stated here — one person’s life in exchange for his allegiance.','19 BBY','published'),
('68000000-0000-4000-8003-000000000007','zh-CN','格里弗斯死于乌塔帕','欧比旺在乌塔帕击杀格里弗斯,战争的正面部分随之结束。','','','雅汶战役前 19 年','published'),
('68000000-0000-4000-8003-000000000007','en','Grievous is killed on Utapau','Obi-Wan kills Grievous on Utapau, and the visible half of the war ends with him.','','','19 BBY','published'),
('68000000-0000-4000-8003-000000000008','zh-CN','梅斯·温杜逮捕帕尔帕廷','阿纳金告发后,温杜率四名绝地前往逮捕,三人当场被杀。','温杜制服帕尔帕廷、决定不留活口的瞬间,阿纳金赶到——影片让他看见的正是他刚刚举报过的那种越界。','他救下的不是一个人,而是那句「我可以教你」;救人的动机与投敌的动作在此重合。','雅汶战役前 19 年','published'),
('68000000-0000-4000-8003-000000000008','en','Mace Windu moves to arrest Palpatine','Acting on Anakin’s report, Windu takes four Jedi to arrest the Chancellor; three are killed at once.','Anakin arrives at the moment Windu has him beaten and decides not to take him alive — the film shows him exactly the kind of overreach he has just reported.','What he saves is not a man but the offer; the impulse to save and the act of betrayal happen in the same motion.','19 BBY','published'),
('68000000-0000-4000-8003-000000000009','zh-CN','阿纳金成为达斯·维达','阿纳金出手使温杜失去防御而坠亡,当即跪下受封为西斯学徒。','影片让他在事后立刻说出自己已经无路可退——效忠不是被说服的结果,是被自己的一次出手锁死的。','此后二十三年他都被这一步困住,直到有人愿意为他不放手。','雅汶战役前 19 年','published'),
('68000000-0000-4000-8003-000000000009','en','Anakin becomes Darth Vader','Anakin strikes Windu’s guard aside, Windu falls, and Anakin kneels to be named a Sith apprentice.','The film has him say immediately afterwards that there is no way back; the allegiance is not argued into him, it is locked by his own hand.','Twenty-three years hang on this step, until someone is willing not to let go of him.','19 BBY','published'),
('68000000-0000-4000-8003-000000000010','zh-CN','66 号令','帕尔帕廷向全银河的克隆人部队下达 66 号令,各处绝地被身边的士兵射杀。','影片把这一段拍成同一时刻的多地并置:每个绝地都是被自己三年来并肩的部下从背后打倒的。','这不是战败,是背叛被预先写进了军队的构造里。','雅汶战役前 19 年','published'),
('68000000-0000-4000-8003-000000000010','en','Order 66','Palpatine issues Order 66 to the clone forces across the galaxy, and Jedi everywhere are shot by the troops beside them.','The film cuts between many places at one moment: each Jedi is taken from behind by the soldiers he has fought beside for three years.','This is not a defeat. The betrayal was built into the army in advance.','19 BBY','published'),
('68000000-0000-4000-8003-000000000011','zh-CN','绝地圣殿陷落','维达率部攻入绝地圣殿,殿中人无一幸免。','影片没有回避殿中还有孩子这件事,却把它留在门外交代——这是他此后无法辩解的一笔。','绝地武士团作为一个机构在这一夜终结。','雅汶战役前 19 年','published'),
('68000000-0000-4000-8003-000000000011','en','The Jedi Temple falls','Vader leads troops into the Jedi Temple, and no one inside survives.','The film does not pretend there were no children there, and does not show it either; it is left just off screen, and it is the thing he can never argue away.','The Jedi Order ends as an institution in a single night.','19 BBY','published'),
('68000000-0000-4000-8003-000000000012','zh-CN','帝国宣告成立','帕尔帕廷在议会宣布共和国改组为帝国,议员起立鼓掌。','影片让掌声成为这一场的重点:没有政变的画面,只有一次全场通过。','共和国不是被攻陷的,是在自己的议事厅里被欢呼着交出去的。','雅汶战役前 19 年','published'),
('68000000-0000-4000-8003-000000000012','en','The Empire is declared','Palpatine announces to the senate that the Republic is reorganised into an Empire, and the chamber rises to applaud.','The film makes the applause the point of the scene: there is no image of a coup, only of a vote carried.','The Republic is not stormed. It is handed over, to cheering, in its own chamber.','19 BBY','published'),
('68000000-0000-4000-8003-000000000013','zh-CN','尤达与西迪厄斯之战','尤达在议事厅与西迪厄斯交手未能取胜,选择流亡。','','','雅汶战役前 19 年','published'),
('68000000-0000-4000-8003-000000000013','en','Yoda fails against Sidious','Yoda fights Sidious in the senate chamber, cannot finish it, and chooses exile.','','','19 BBY','published'),
('68000000-0000-4000-8003-000000000014','zh-CN','穆斯塔法决斗','欧比旺追至穆斯塔法与维达决斗,维达重伤于熔岩河畔。','帕德梅先到,维达认定她带来了欧比旺;他掐住妻子的那一刻,他要救的人正死在他手里。','他为阻止一个预见而做的一切,恰好造成了那个预见。','雅汶战役前 19 年','published'),
('68000000-0000-4000-8003-000000000014','en','The duel on Mustafar','Obi-Wan follows Vader to Mustafar and leaves him maimed at the edge of the lava.','Padmé arrives first and Vader decides she brought Obi-Wan; in the moment his hand closes on his wife, the person he is trying to save is dying by it.','Everything he did to prevent the vision is what produces the vision.','19 BBY','published'),
('68000000-0000-4000-8003-000000000015','zh-CN','双胞胎出生','帕德梅在波利斯麻沙产下卢克与莱娅。','影片把出生与维达的重铸剪在一起——一边缝合金属,一边接生。','整部九部曲的后半段从这两个孩子开始。','雅汶战役前 19 年','published'),
('68000000-0000-4000-8003-000000000015','en','The twins are born','Padmé gives birth to Luke and Leia on Polis Massa.','The film cuts the birth against Vader’s reconstruction: metal being closed on one table, children being delivered on the other.','The back half of the saga begins with these two.','19 BBY','published'),
('68000000-0000-4000-8003-000000000016','zh-CN','帕德梅·阿米达拉之死','帕德梅在分娩后死去。','','','雅汶战役前 19 年','published'),
('68000000-0000-4000-8003-000000000016','en','The death of Padmé Amidala','Padmé dies after the birth.','','','19 BBY','published'),
('68000000-0000-4000-8003-000000000017','zh-CN','维达被重铸','帕尔帕廷取回残躯,以机械与呼吸器重铸维达,并告知他妻子已死。','影片让他醒来后第一句问的是她,得到的答案锁死了他剩下的二十三年。','此后维达之所以留在帕尔帕廷身边,靠的不是信任,是无处可去。','雅汶战役前 19 年','published'),
('68000000-0000-4000-8003-000000000017','en','Vader is remade','Palpatine recovers what is left of him, rebuilds him in machinery and a respirator, and tells him his wife is dead.','The film has him ask about her the moment he wakes, and the answer locks the next twenty-three years in place.','What keeps Vader at Palpatine’s side afterwards is not trust but having nowhere else to be.','19 BBY','published'),
('68000000-0000-4000-8003-000000000018','zh-CN','双胞胎被分开藏匿','莱娅由贝尔·奥加纳带回奥德朗,卢克由欧比旺送往塔图因交给拉尔斯夫妇。','两个孩子被分别托付给一个王室与一户农家,而尤达与欧比旺各自退入流亡。','唯一保住的东西不是绝地武士团,是两个不知道自己身世的孩子。','雅汶战役前 19 年','published'),
('68000000-0000-4000-8003-000000000018','en','The twins are hidden apart','Leia is taken to Alderaan by Bail Organa; Luke is carried to Tatooine by Obi-Wan and left with the Lars family.','The children are placed with a royal house and a farming family respectively, while Yoda and Obi-Wan withdraw separately into exile.','What survives is not the Jedi Order but two children who do not know whose they are.','19 BBY','published');

-- ============================================================
-- 2. EVENT LOCATIONS
-- ============================================================

INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id, l.id, w.role, w.position
FROM (VALUES
  ('the-battle-of-coruscant','coruscant','primary',0),
  ('anakin-executes-dooku','coruscant','primary',0),
  ('anakin-foresees-padmes-death','coruscant','primary',0),
  ('anakin-placed-on-the-council','coruscant','primary',0),
  ('obi-wan-sent-after-grievous','utapau','primary',0),
  ('palpatine-reveals-himself','coruscant','primary',0),
  ('grievous-killed-on-utapau','utapau','primary',0),
  ('mace-windu-confronts-palpatine','coruscant','primary',0),
  ('anakin-becomes-darth-vader','coruscant','primary',0),
  ('order-66','coruscant','primary',0),
  ('order-66','utapau','front',1),
  ('order-66','felucia','front',2),
  ('order-66','kashyyyk','front',3),
  ('the-jedi-temple-falls','coruscant','primary',0),
  ('the-empire-is-declared','coruscant','primary',0),
  ('yoda-fails-against-sidious','coruscant','primary',0),
  ('the-duel-on-mustafar','mustafar','primary',0),
  ('the-twins-are-born','polis-massa','primary',0),
  ('padme-amidala-dies','polis-massa','primary',0),
  ('vader-is-remade','coruscant','primary',0),
  ('the-twins-are-hidden','tatooine','primary',0),
  ('the-twins-are-hidden','alderaan','destination',1),
  ('the-twins-are-hidden','dagobah','destination',2)
) AS w(event_slug, location_slug, role, position)
JOIN events e ON e.work_id='10000000-0000-4000-8000-000000000008' AND e.slug=w.event_slug
JOIN locations l ON l.work_id='10000000-0000-4000-8000-000000000008' AND l.slug=w.location_slug
ON CONFLICT DO NOTHING;

-- ============================================================
-- 3. EVENT CHARACTERS
-- ============================================================

INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id, c.id, w.role, w.participant_order, w.is_primary
FROM (VALUES
  ('the-battle-of-coruscant','anakin-skywalker','primary',0,true),
  ('the-battle-of-coruscant','obi-wan-kenobi','participant',1,false),
  ('the-battle-of-coruscant','general-grievous','participant',2,false),
  ('the-battle-of-coruscant','r2-d2','participant',3,false),
  ('anakin-executes-dooku','anakin-skywalker','primary',0,true),
  ('anakin-executes-dooku','count-dooku','participant',1,false),
  ('anakin-executes-dooku','sheev-palpatine','participant',2,false),
  ('anakin-foresees-padmes-death','anakin-skywalker','primary',0,true),
  ('anakin-foresees-padmes-death','padme-amidala','participant',1,false),
  ('anakin-placed-on-the-council','anakin-skywalker','primary',0,true),
  ('anakin-placed-on-the-council','mace-windu','participant',1,false),
  ('anakin-placed-on-the-council','yoda','participant',2,false),
  ('anakin-placed-on-the-council','sheev-palpatine','participant',3,false),
  ('obi-wan-sent-after-grievous','obi-wan-kenobi','primary',0,true),
  ('obi-wan-sent-after-grievous','commander-cody','participant',1,false),
  ('palpatine-reveals-himself','sheev-palpatine','primary',0,true),
  ('palpatine-reveals-himself','anakin-skywalker','participant',1,false),
  ('grievous-killed-on-utapau','obi-wan-kenobi','primary',0,true),
  ('grievous-killed-on-utapau','general-grievous','participant',1,false),
  ('mace-windu-confronts-palpatine','mace-windu','primary',0,true),
  ('mace-windu-confronts-palpatine','sheev-palpatine','participant',1,false),
  ('mace-windu-confronts-palpatine','anakin-skywalker','participant',2,false),
  ('anakin-becomes-darth-vader','anakin-skywalker','primary',0,true),
  ('anakin-becomes-darth-vader','sheev-palpatine','participant',1,false),
  ('anakin-becomes-darth-vader','mace-windu','participant',2,false),
  ('order-66','sheev-palpatine','primary',0,true),
  ('order-66','commander-cody','participant',1,false),
  ('order-66','obi-wan-kenobi','participant',2,false),
  ('order-66','yoda','participant',3,false),
  ('order-66','ki-adi-mundi','participant',4,false),
  ('the-jedi-temple-falls','anakin-skywalker','primary',0,true),
  ('the-empire-is-declared','sheev-palpatine','primary',0,true),
  ('the-empire-is-declared','padme-amidala','participant',1,false),
  ('the-empire-is-declared','bail-organa','participant',2,false),
  ('the-empire-is-declared','mon-mothma','participant',3,false),
  ('yoda-fails-against-sidious','yoda','primary',0,true),
  ('yoda-fails-against-sidious','sheev-palpatine','participant',1,false),
  ('yoda-fails-against-sidious','bail-organa','participant',2,false),
  ('the-duel-on-mustafar','anakin-skywalker','primary',0,true),
  ('the-duel-on-mustafar','obi-wan-kenobi','participant',1,false),
  ('the-duel-on-mustafar','padme-amidala','participant',2,false),
  ('the-twins-are-born','padme-amidala','primary',0,true),
  ('the-twins-are-born','luke-skywalker','participant',1,false),
  ('the-twins-are-born','leia-organa','participant',2,false),
  ('the-twins-are-born','obi-wan-kenobi','participant',3,false),
  ('the-twins-are-born','bail-organa','participant',4,false),
  ('padme-amidala-dies','padme-amidala','primary',0,true),
  ('vader-is-remade','anakin-skywalker','primary',0,true),
  ('vader-is-remade','sheev-palpatine','participant',1,false),
  ('the-twins-are-hidden','obi-wan-kenobi','primary',0,true),
  ('the-twins-are-hidden','luke-skywalker','participant',1,false),
  ('the-twins-are-hidden','leia-organa','participant',2,false),
  ('the-twins-are-hidden','bail-organa','participant',3,false),
  ('the-twins-are-hidden','owen-lars','participant',4,false),
  ('the-twins-are-hidden','beru-whitesun-lars','participant',5,false),
  ('the-twins-are-hidden','yoda','participant',6,false)
) AS w(event_slug, character_slug, role, participant_order, is_primary)
JOIN events e ON e.work_id='10000000-0000-4000-8000-000000000008' AND e.slug=w.event_slug
JOIN characters c ON c.work_id='10000000-0000-4000-8000-000000000008' AND c.slug=w.character_slug
ON CONFLICT DO NOTHING;

-- ============================================================
-- 4. EVENT SOURCES
-- ============================================================

INSERT INTO event_sources(event_id,source_id)
SELECT e.id, s.id
FROM events e
JOIN sources s ON s.work_id='10000000-0000-4000-8000-000000000008' AND s.title='Episode III: Revenge of the Sith (2005 film)'
WHERE e.id::text LIKE '68000000-0000-4000-8003%'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 5. RELATIONS — the Skywalker spine
-- ============================================================

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT w.id::uuid, '10000000-0000-4000-8000-000000000008', f.id, t.id, w.relation_type, w.direction::relationship_direction, w.sentiment::relationship_sentiment, w.strength, w.status::relationship_status, NULL, NULL
FROM (VALUES
  ('78000000-0000-4000-8003-000000000001','sheev-palpatine','anakin-skywalker','mentor','source_to_target','negative',5,'active'),
  ('78000000-0000-4000-8003-000000000002','anakin-skywalker','obi-wan-kenobi','adversary','bidirectional','mixed',5,'changed'),
  ('78000000-0000-4000-8003-000000000003','anakin-skywalker','luke-skywalker','family','bidirectional','mixed',5,'active'),
  ('78000000-0000-4000-8003-000000000004','anakin-skywalker','leia-organa','family','bidirectional','mixed',5,'active'),
  ('78000000-0000-4000-8003-000000000005','padme-amidala','luke-skywalker','family','bidirectional','positive',5,'ended'),
  ('78000000-0000-4000-8003-000000000006','padme-amidala','leia-organa','family','bidirectional','positive',5,'ended'),
  ('78000000-0000-4000-8003-000000000007','luke-skywalker','leia-organa','sibling','bidirectional','positive',5,'active'),
  ('78000000-0000-4000-8003-000000000008','bail-organa','leia-organa','family','source_to_target','positive',5,'ended'),
  ('78000000-0000-4000-8003-000000000009','obi-wan-kenobi','luke-skywalker','mentor','source_to_target','positive',5,'ended'),
  ('78000000-0000-4000-8003-000000000010','owen-lars','luke-skywalker','family','source_to_target','positive',4,'ended'),
  ('78000000-0000-4000-8003-000000000011','beru-whitesun-lars','luke-skywalker','family','source_to_target','positive',4,'ended'),
  ('78000000-0000-4000-8003-000000000012','anakin-skywalker','mace-windu','adversary','source_to_target','negative',4,'ended'),
  ('78000000-0000-4000-8003-000000000013','anakin-skywalker','count-dooku','adversary','source_to_target','negative',4,'ended'),
  ('78000000-0000-4000-8003-000000000014','commander-cody','obi-wan-kenobi','betrayal','source_to_target','negative',4,'ended'),
  ('78000000-0000-4000-8003-000000000015','yoda','sheev-palpatine','adversary','bidirectional','negative',5,'ended'),
  ('78000000-0000-4000-8003-000000000016','bail-organa','obi-wan-kenobi','ally','bidirectional','positive',4,'ended'),
  ('78000000-0000-4000-8003-000000000017','bail-organa','yoda','ally','bidirectional','positive',4,'ended')
) AS w(id, from_slug, to_slug, relation_type, direction, sentiment, strength, status)
JOIN characters f ON f.work_id='10000000-0000-4000-8000-000000000008' AND f.slug=w.from_slug
JOIN characters t ON t.work_id='10000000-0000-4000-8000-000000000008' AND t.slug=w.to_slug
ON CONFLICT DO NOTHING;

INSERT INTO relation_translations(relation_id,locale,label,summary,status) VALUES
('78000000-0000-4000-8003-000000000001','zh-CN','西斯师徒(西迪厄斯→维达)','用一个人的性命作价换来的效忠,维持了二十三年。','published'),
('78000000-0000-4000-8003-000000000001','en','Sith master and apprentice (Sidious → Vader)','An allegiance bought with one person’s life, and held for twenty-three years.','published'),
('78000000-0000-4000-8003-000000000002','zh-CN','师徒反目(阿纳金↔欧比旺)','兄弟一般的师徒在熔岩边相搏,活下来的那个把孩子藏了起来。','published'),
('78000000-0000-4000-8003-000000000002','en','Master and apprentice, turned (Anakin ↔ Obi-Wan)','Two who were as brothers fight at the lava’s edge; the one who walks away hides the children.','published'),
('78000000-0000-4000-8003-000000000003','zh-CN','父子(维达↔卢克)','儿子在二十年后才知道父亲是谁,并且拒绝了「像父亲那样」这条路。','published'),
('78000000-0000-4000-8003-000000000003','en','Father and son (Vader ↔ Luke)','A son who learns whose he is twenty years late, and refuses the road his father took.','published'),
('78000000-0000-4000-8003-000000000004','zh-CN','父女(维达↔莱娅)','她被他审讯过、被他毁掉了家园,而他自始至终不知道她是谁。','published'),
('78000000-0000-4000-8003-000000000004','en','Father and daughter (Vader ↔ Leia)','He interrogates her and destroys her home, and never once knows who she is.','published'),
('78000000-0000-4000-8003-000000000005','zh-CN','母子(帕德梅↔卢克)','分娩即诀别。','published'),
('78000000-0000-4000-8003-000000000005','en','Mother and son (Padmé ↔ Luke)','The birth and the parting are the same hour.','published'),
('78000000-0000-4000-8003-000000000006','zh-CN','母女(帕德梅↔莱娅)','莱娅只留下一点模糊的印象,而那已经是她全部的记忆。','published'),
('78000000-0000-4000-8003-000000000006','en','Mother and daughter (Padmé ↔ Leia)','Leia keeps only an impression, and that impression is all the memory there is.','published'),
('78000000-0000-4000-8003-000000000007','zh-CN','孪生兄妹(卢克↔莱娅)','分开抚养、互不知情,直到银河把他们送到一起。','published'),
('78000000-0000-4000-8003-000000000007','en','Twins (Luke ↔ Leia)','Raised apart and unaware, until the galaxy puts them in the same room.','published'),
('78000000-0000-4000-8003-000000000008','zh-CN','养父女(贝尔→莱娅)','把她当女儿养大,也把她养成了一个议员。','published'),
('78000000-0000-4000-8003-000000000008','en','Adoptive father and daughter (Bail → Leia)','He raises her as a daughter, and raises her into a senator.','published'),
('78000000-0000-4000-8003-000000000009','zh-CN','师徒(欧比旺→卢克)','守了他十九年,只教了他几天。','published'),
('78000000-0000-4000-8003-000000000009','en','Master and student (Obi-Wan → Luke)','Nineteen years of watching over him, and a few days of teaching.','published'),
('78000000-0000-4000-8003-000000000010','zh-CN','养父与养子(欧文→卢克)','用不让他离开农场的方式保护了他十九年。','published'),
('78000000-0000-4000-8003-000000000010','en','Foster father and son (Owen → Luke)','Nineteen years of protection, delivered as a refusal to let him leave the farm.','published'),
('78000000-0000-4000-8003-000000000011','zh-CN','养母与养子(贝露→卢克)','在丈夫的严厉之外,替他留出一点余地。','published'),
('78000000-0000-4000-8003-000000000011','en','Foster mother and son (Beru → Luke)','She keeps a little room for him alongside her husband’s hardness.','published'),
('78000000-0000-4000-8003-000000000012','zh-CN','出手与坠落(阿纳金→温杜)','一次挡开,决定了整个银河此后二十三年。','published'),
('78000000-0000-4000-8003-000000000012','en','One stroke, one fall (Anakin → Windu)','A single parry decides the next twenty-three years of the galaxy.','published'),
('78000000-0000-4000-8003-000000000013','zh-CN','处决者与被处决者(阿纳金→杜库)','在授意之下斩杀了一名跪着的俘虏。','published'),
('78000000-0000-4000-8003-000000000013','en','Executioner and prisoner (Anakin → Dooku)','A kneeling captive killed at another man’s prompting.','published'),
('78000000-0000-4000-8003-000000000014','zh-CN','副手倒戈(科迪→欧比旺)','三年的信任,在一道命令下当场作废。','published'),
('78000000-0000-4000-8003-000000000014','en','Second turned (Cody → Obi-Wan)','Three years of trust voided the instant the order comes through.','published'),
('78000000-0000-4000-8003-000000000015','zh-CN','宿敌(尤达↔西迪厄斯)','在议事厅里分不出胜负,于是一个流亡、一个称帝。','published'),
('78000000-0000-4000-8003-000000000015','en','Old enemies (Yoda ↔ Sidious)','Neither can finish it in the senate chamber, so one goes into exile and the other crowns himself.','published'),
('78000000-0000-4000-8003-000000000016','zh-CN','同谋(贝尔↔欧比旺)','共同决定把两个孩子分开藏起。','published'),
('78000000-0000-4000-8003-000000000016','en','Co-conspirators (Bail ↔ Obi-Wan)','Together they decide to hide the two children apart.','published'),
('78000000-0000-4000-8003-000000000017','zh-CN','同谋(贝尔↔尤达)','从议事厅里救出尤达的人,也是保住火种的人。','published'),
('78000000-0000-4000-8003-000000000017','en','Co-conspirators (Bail ↔ Yoda)','The man who gets Yoda out of the senate chamber is the man who keeps the spark.','published')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 6. GROUP MEMBERSHIP
-- ============================================================

INSERT INTO character_group_members(group_id,character_id,membership_role)
SELECT g.id, c.id, w.membership_role
FROM (VALUES
  ('sith-lineage','anakin-skywalker','apprentice, named Vader'),
  ('house-of-organa','luke-skywalker','twin of the adopted daughter'),
  ('house-of-skywalker','bail-organa','guardian of the daughter'),
  ('galactic-empire','sheev-palpatine','emperor')
) AS w(group_slug, character_slug, membership_role)
JOIN character_groups g ON g.work_id='10000000-0000-4000-8000-000000000008' AND g.slug=w.group_slug
JOIN characters c ON c.work_id='10000000-0000-4000-8000-000000000008' AND c.slug=w.character_slug
ON CONFLICT DO NOTHING;

COMMIT;
