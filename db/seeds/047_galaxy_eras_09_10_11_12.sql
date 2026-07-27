BEGIN;

-- Eras 09 through 12 — the postwar years and the sequel trilogy.
--
--   09 · new-republic       (5-28 ABY, years 5..28)  — 7 events, thin by design
--   10 · first-order-rising (28-34 ABY, years 28..34) — 11 events
--   11 · last-jedi          (34 ABY, years 34..35)    — 10 events
--   12 · skywalker-reborn   (35 ABY, years 35..36)    — 11 events
--
-- Weight again sits on the family and the Jedi succession: Ben Solo's turn,
-- Luke's exile and return, Rey's inheritance and her choice of name.
-- Bands 9001, 10001, 11001, 12001.

-- ============================================================
-- 1. CHARACTERS
-- ============================================================

INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('48000000-0000-4000-8010-000000000001','10000000-0000-4000-8000-000000000008','poe-dameron',1001,'male','adult','supporting','fictional',2,NULL,'pilot',4),
('48000000-0000-4000-8010-000000000002','10000000-0000-4000-8000-000000000008','bb-8',1002,'na','adult','supporting','fictional',NULL,NULL,'droid',3),
('48000000-0000-4000-8010-000000000003','10000000-0000-4000-8000-000000000008','snoke',1003,'male','elder','antagonist','fictional',NULL,34,'sith',3),
('48000000-0000-4000-8010-000000000004','10000000-0000-4000-8000-000000000008','general-hux',1004,'male','adult','antagonist','fictional',NULL,35,'ruler',3),
('48000000-0000-4000-8010-000000000005','10000000-0000-4000-8000-000000000008','maz-kanata',1005,'female','elder','supporting','fictional',NULL,NULL,'person',2),
('48000000-0000-4000-8011-000000000001','10000000-0000-4000-8000-000000000008','vice-admiral-holdo',1101,'female','adult','supporting','fictional',NULL,34,'soldier',3),
('48000000-0000-4000-8011-000000000002','10000000-0000-4000-8000-000000000008','rose-tico',1102,'female','youth','supporting','fictional',NULL,NULL,'soldier',2),
('48000000-0000-4000-8012-000000000001','10000000-0000-4000-8000-000000000008','jannah',1201,'female','youth','supporting','fictional',NULL,NULL,'soldier',2)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,aliases,detail,motivation,status) VALUES
('48000000-0000-4000-8010-000000000001','zh-CN','波·达默龙','抵抗组织的王牌飞行员。','{}','','把人带回来,而不只是把仗打赢。','published'),
('48000000-0000-4000-8010-000000000001','en','Poe Dameron','The Resistance’s best pilot.','{}','','Bring people back, not merely win.','published'),
('48000000-0000-4000-8010-000000000002','zh-CN','BB-8','波的宇航技工机器人,携带地图残片。','{}','','','published'),
('48000000-0000-4000-8010-000000000002','en','BB-8','Poe’s astromech, carrying the fragment of a map.','{}','','','published'),
('48000000-0000-4000-8010-000000000003','zh-CN','斯诺克','第一秩序的最高领袖,凯洛·伦的师父。','{}','影片后来揭示他并非真正的主使,而是被制造出来的中介。','把一个人塑造成自己想要的样子。','published'),
('48000000-0000-4000-8010-000000000003','en','Snoke','Supreme Leader of the First Order and Kylo Ren’s master.','{}','The films later reveal he was never the principal, only something manufactured to stand between.','To shape one person into what he wants.','published'),
('48000000-0000-4000-8010-000000000004','zh-CN','赫克斯将军','第一秩序军方首脑,与凯洛·伦长期不和。','{}','','在两个上级之间为自己争位置。','published'),
('48000000-0000-4000-8010-000000000004','en','General Hux','The First Order’s military head, permanently at odds with Kylo Ren.','{}','','To hold his own position between two superiors.','published'),
('48000000-0000-4000-8010-000000000005','zh-CN','玛兹·卡纳塔','塔科达纳中立据点的主人,保存着卢克的旧光剑。','{}','','让所有阵营的人都能在她这里落脚。','published'),
('48000000-0000-4000-8010-000000000005','en','Maz Kanata','Keeper of the neutral waypoint on Takodana, and of Luke’s old lightsaber.','{}','','A place where every side can put its feet down.','published'),
('48000000-0000-4000-8011-000000000001','zh-CN','霍尔多中将','抵抗组织指挥官,以自杀式跃迁撞穿第一秩序旗舰。','{}','','','published'),
('48000000-0000-4000-8011-000000000001','en','Vice Admiral Holdo','A Resistance commander who rams the First Order flagship at lightspeed.','{}','','','published'),
('48000000-0000-4000-8011-000000000002','zh-CN','罗丝·提科','抵抗组织机械师。','{}','','','published'),
('48000000-0000-4000-8011-000000000002','en','Rose Tico','A Resistance mechanic.','{}','','','published'),
('48000000-0000-4000-8012-000000000001','zh-CN','珍娜','凯夫比尔的原住民领袖,前第一秩序士兵。','{}','','','published'),
('48000000-0000-4000-8012-000000000001','en','Jannah','Leader of a company on Kef Bir, and a former First Order trooper.','{}','','','published')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 2. EVENTS
-- ============================================================

INSERT INTO events(id,work_id,slug,start_date,end_date,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,start_month,start_day,confidence,chapter_id) VALUES
-- era 09
('68000000-0000-4000-8009-000000000001','10000000-0000-4000-8000-000000000008','the-new-republic-is-founded',NULL,NULL,9001,'fictional_narrative','political','fictional_calendar','fictional',5,8,NULL,NULL,'medium','88000000-0000-4000-8009-000000000001'),
('68000000-0000-4000-8009-000000000002','10000000-0000-4000-8000-000000000008','the-battle-of-jakku',NULL,NULL,9003,'fictional_narrative','battle','fictional_calendar','fictional',5,6,NULL,NULL,'medium','88000000-0000-4000-8009-000000000001'),
('68000000-0000-4000-8009-000000000003','10000000-0000-4000-8000-000000000008','ben-solo-is-born',NULL,NULL,9005,'fictional_narrative','birth','fictional_calendar','fictional',5,6,NULL,NULL,'high','88000000-0000-4000-8009-000000000001'),
('68000000-0000-4000-8009-000000000004','10000000-0000-4000-8000-000000000008','luke-rebuilds-the-jedi',NULL,NULL,9007,'fictional_narrative','other','fictional_calendar','fictional',8,20,NULL,NULL,'medium','88000000-0000-4000-8009-000000000001'),
('68000000-0000-4000-8009-000000000005','10000000-0000-4000-8000-000000000008','the-night-at-the-temple',NULL,NULL,9009,'fictional_narrative','betrayal','fictional_calendar','fictional',20,25,NULL,NULL,'high','88000000-0000-4000-8009-000000000001'),
('68000000-0000-4000-8009-000000000006','10000000-0000-4000-8000-000000000008','luke-goes-into-exile',NULL,NULL,9011,'fictional_narrative','migration','fictional_calendar','fictional',25,28,NULL,NULL,'high','88000000-0000-4000-8009-000000000001'),
('68000000-0000-4000-8009-000000000007','10000000-0000-4000-8000-000000000008','the-first-order-assembles',NULL,NULL,9013,'fictional_with_historical_context','political','fictional_calendar','fictional',25,28,NULL,NULL,'medium','88000000-0000-4000-8009-000000000001'),
-- era 10
('68000000-0000-4000-8010-000000000001','10000000-0000-4000-8000-000000000008','the-map-is-hidden-in-bb-8',NULL,NULL,10001,'fictional_narrative','discovery','fictional_calendar','fictional',28,34,NULL,NULL,'high','88000000-0000-4000-8010-000000000001'),
('68000000-0000-4000-8010-000000000002','10000000-0000-4000-8000-000000000008','finn-deserts',NULL,NULL,10003,'fictional_narrative','escape','fictional_calendar','fictional',28,34,NULL,NULL,'high','88000000-0000-4000-8010-000000000001'),
('68000000-0000-4000-8010-000000000003','10000000-0000-4000-8000-000000000008','rey-leaves-jakku',NULL,NULL,10005,'fictional_narrative','journey','fictional_calendar','fictional',28,34,NULL,NULL,'high','88000000-0000-4000-8010-000000000001'),
('68000000-0000-4000-8010-000000000004','10000000-0000-4000-8000-000000000008','rey-touches-the-lightsaber',NULL,NULL,10007,'legendary_or_mythic','discovery','fictional_calendar','fictional',28,34,NULL,NULL,'high','88000000-0000-4000-8010-000000000001'),
('68000000-0000-4000-8010-000000000005','10000000-0000-4000-8000-000000000008','the-raid-on-takodana',NULL,NULL,10009,'fictional_narrative','battle','fictional_calendar','fictional',28,34,NULL,NULL,'high','88000000-0000-4000-8010-000000000001'),
('68000000-0000-4000-8010-000000000006','10000000-0000-4000-8000-000000000008','hosnian-prime-destroyed',NULL,NULL,10011,'fictional_narrative','battle','fictional_calendar','fictional',28,34,NULL,NULL,'high','88000000-0000-4000-8010-000000000001'),
('68000000-0000-4000-8010-000000000007','10000000-0000-4000-8000-000000000008','han-solo-meets-his-son',NULL,NULL,10013,'fictional_narrative','death','fictional_calendar','fictional',28,34,NULL,NULL,'high','88000000-0000-4000-8010-000000000001'),
('68000000-0000-4000-8010-000000000008','10000000-0000-4000-8000-000000000008','rey-holds-her-own-against-kylo',NULL,NULL,10015,'fictional_narrative','battle','fictional_calendar','fictional',28,34,NULL,NULL,'high','88000000-0000-4000-8010-000000000001'),
('68000000-0000-4000-8010-000000000009','10000000-0000-4000-8000-000000000008','starkiller-base-destroyed',NULL,NULL,10017,'fictional_narrative','battle','fictional_calendar','fictional',28,34,NULL,NULL,'high','88000000-0000-4000-8010-000000000001'),
('68000000-0000-4000-8010-000000000010','10000000-0000-4000-8000-000000000008','rey-finds-luke-on-ahch-to',NULL,NULL,10019,'fictional_narrative','meeting','fictional_calendar','fictional',34,34,NULL,NULL,'high','88000000-0000-4000-8010-000000000001'),
('68000000-0000-4000-8010-000000000011','10000000-0000-4000-8000-000000000008','leia-commands-the-resistance',NULL,NULL,10021,'fictional_narrative','political','fictional_calendar','fictional',28,34,NULL,NULL,'high','88000000-0000-4000-8010-000000000001'),
-- era 11
('68000000-0000-4000-8011-000000000001','10000000-0000-4000-8000-000000000008','luke-refuses-to-teach',NULL,NULL,11001,'fictional_narrative','meeting','fictional_calendar','fictional',34,34,NULL,NULL,'high','88000000-0000-4000-8011-000000000001'),
('68000000-0000-4000-8011-000000000002','10000000-0000-4000-8000-000000000008','luke-tells-what-happened-at-the-temple',NULL,NULL,11003,'fictional_narrative','discovery','fictional_calendar','fictional',34,34,NULL,NULL,'high','88000000-0000-4000-8011-000000000001'),
('68000000-0000-4000-8011-000000000003','10000000-0000-4000-8000-000000000008','rey-and-kylo-are-linked',NULL,NULL,11005,'legendary_or_mythic','meeting','fictional_calendar','fictional',34,34,NULL,NULL,'high','88000000-0000-4000-8011-000000000001'),
('68000000-0000-4000-8011-000000000004','10000000-0000-4000-8000-000000000008','the-resistance-is-pursued',NULL,NULL,11007,'fictional_narrative','escape','fictional_calendar','fictional',34,34,NULL,NULL,'high','88000000-0000-4000-8011-000000000001'),
('68000000-0000-4000-8011-000000000005','10000000-0000-4000-8000-000000000008','yoda-returns-to-luke',NULL,NULL,11009,'legendary_or_mythic','meeting','fictional_calendar','fictional',34,34,NULL,NULL,'high','88000000-0000-4000-8011-000000000001'),
('68000000-0000-4000-8011-000000000006','10000000-0000-4000-8000-000000000008','kylo-kills-snoke',NULL,NULL,11011,'fictional_narrative','betrayal','fictional_calendar','fictional',34,34,NULL,NULL,'high','88000000-0000-4000-8011-000000000001'),
('68000000-0000-4000-8011-000000000007','10000000-0000-4000-8000-000000000008','rey-refuses-kylos-offer',NULL,NULL,11013,'fictional_narrative','trial','fictional_calendar','fictional',34,34,NULL,NULL,'high','88000000-0000-4000-8011-000000000001'),
('68000000-0000-4000-8011-000000000008','10000000-0000-4000-8000-000000000008','holdos-maneuver',NULL,NULL,11015,'fictional_narrative','battle','fictional_calendar','fictional',34,34,NULL,NULL,'high','88000000-0000-4000-8011-000000000001'),
('68000000-0000-4000-8011-000000000009','10000000-0000-4000-8000-000000000008','the-stand-on-crait',NULL,NULL,11017,'fictional_narrative','battle','fictional_calendar','fictional',34,34,NULL,NULL,'high','88000000-0000-4000-8011-000000000001'),
('68000000-0000-4000-8011-000000000010','10000000-0000-4000-8000-000000000008','luke-skywalker-dies',NULL,NULL,11019,'fictional_narrative','death','fictional_calendar','fictional',34,35,NULL,NULL,'high','88000000-0000-4000-8011-000000000001'),
-- era 12
('68000000-0000-4000-8012-000000000001','10000000-0000-4000-8000-000000000008','the-emperor-is-heard-again',NULL,NULL,12001,'fictional_narrative','discovery','fictional_calendar','fictional',35,35,NULL,NULL,'high','88000000-0000-4000-8012-000000000001'),
('68000000-0000-4000-8012-000000000002','10000000-0000-4000-8000-000000000008','rey-trains-under-leia',NULL,NULL,12003,'fictional_narrative','other','fictional_calendar','fictional',35,35,NULL,NULL,'high','88000000-0000-4000-8012-000000000001'),
('68000000-0000-4000-8012-000000000003','10000000-0000-4000-8000-000000000008','the-search-on-pasaana',NULL,NULL,12005,'fictional_narrative','journey','fictional_calendar','fictional',35,35,NULL,NULL,'high','88000000-0000-4000-8012-000000000001'),
('68000000-0000-4000-8012-000000000004','10000000-0000-4000-8000-000000000008','kylo-tells-rey-her-descent',NULL,NULL,12007,'fictional_narrative','discovery','fictional_calendar','fictional',35,35,NULL,NULL,'high','88000000-0000-4000-8012-000000000001'),
('68000000-0000-4000-8012-000000000005','10000000-0000-4000-8000-000000000008','the-wreck-on-kef-bir',NULL,NULL,12009,'fictional_narrative','battle','fictional_calendar','fictional',35,35,NULL,NULL,'high','88000000-0000-4000-8012-000000000001'),
('68000000-0000-4000-8012-000000000006','10000000-0000-4000-8000-000000000008','leia-reaches-her-son',NULL,NULL,12011,'fictional_narrative','death','fictional_calendar','fictional',35,35,NULL,NULL,'high','88000000-0000-4000-8012-000000000001'),
('68000000-0000-4000-8012-000000000007','10000000-0000-4000-8000-000000000008','ben-solo-returns',NULL,NULL,12013,'fictional_narrative','other','fictional_calendar','fictional',35,35,NULL,NULL,'high','88000000-0000-4000-8012-000000000001'),
('68000000-0000-4000-8012-000000000008','10000000-0000-4000-8000-000000000008','luke-lifts-the-ship',NULL,NULL,12015,'legendary_or_mythic','meeting','fictional_calendar','fictional',35,35,NULL,NULL,'high','88000000-0000-4000-8012-000000000001'),
('68000000-0000-4000-8012-000000000009','10000000-0000-4000-8000-000000000008','the-battle-of-exegol',NULL,NULL,12017,'fictional_narrative','battle','fictional_calendar','fictional',35,35,NULL,NULL,'high','88000000-0000-4000-8012-000000000001'),
('68000000-0000-4000-8012-000000000010','10000000-0000-4000-8000-000000000008','rey-ends-the-emperor',NULL,NULL,12019,'fictional_narrative','battle','fictional_calendar','fictional',35,35,NULL,NULL,'high','88000000-0000-4000-8012-000000000001'),
('68000000-0000-4000-8012-000000000011','10000000-0000-4000-8000-000000000008','rey-takes-the-name-skywalker',NULL,NULL,12021,'fictional_narrative','social','fictional_calendar','fictional',35,36,NULL,NULL,'high','88000000-0000-4000-8012-000000000001');

INSERT INTO event_translations(event_id,locale,title,summary,detail,significance,time_label,status) VALUES
-- era 09
('68000000-0000-4000-8009-000000000001','zh-CN','新共和国成立','同盟改组为新共和国,首都设于霍斯尼安主星。','','','雅汶战役后 5 至 8 年','published'),
('68000000-0000-4000-8009-000000000001','en','The New Republic is founded','The Alliance reorganises into the New Republic, with its seat on Hosnian Prime.','','','c. 5–8 ABY','published'),
('68000000-0000-4000-8009-000000000002','zh-CN','贾库战役','帝国残部在贾库被击溃,战争正式结束。','','','雅汶战役后 5 至 6 年','published'),
('68000000-0000-4000-8009-000000000002','en','The battle of Jakku','What remains of the imperial fleet is broken at Jakku, ending the war.','','','c. 5–6 ABY','published'),
('68000000-0000-4000-8009-000000000003','zh-CN','本·索洛出生','汉与莱娅之子出生,取名本,承自本·克诺比。','','天行者血脉的第三代,名字取自守护过第二代的人。','雅汶战役后 5 至 6 年','published'),
('68000000-0000-4000-8009-000000000003','en','Ben Solo is born','Han and Leia’s son is born and named Ben, after Ben Kenobi.','','The third generation of the line, named for the man who watched over the second.','c. 5–6 ABY','published'),
('68000000-0000-4000-8009-000000000004','zh-CN','卢克重建绝地','卢克开办新的绝地学堂,本·索洛在其门下。','影片让他重复了旧武士团的做法:把孩子从家里带走集中训练,并对自己看见的危险避而不谈。','传承被接了起来,而接法与二十三年前几乎相同。','雅汶战役后 8 至 20 年','published'),
('68000000-0000-4000-8009-000000000004','en','Luke rebuilds the Jedi','Luke opens a new Jedi school, with Ben Solo among his students.','The film has him repeat the old order’s method: take the children from their families to train together, and say nothing about the danger he sees.','The succession resumes, and it resumes almost exactly as before.','c. 8–20 ABY','published'),
('68000000-0000-4000-8009-000000000005','zh-CN','学堂之夜','卢克在本熟睡时窥见其心中的黑暗,一瞬间拔出了光剑;本醒来,学堂随即被毁。','影片让这一瞬间由三个人分别讲述三遍,而三次都承认那一瞬间真的发生过。','绝地的第二次失败,不是被敌人击败,是被一个师父的一瞬间恐惧造成的。','雅汶战役后 20 至 25 年','published'),
('68000000-0000-4000-8009-000000000005','en','The night at the temple','Seeing the dark in his sleeping nephew, Luke ignites his blade for an instant; Ben wakes, and the school is destroyed.','The film tells that instant three times from three mouths, and all three versions admit the instant was real.','The second failure of the Jedi is not a defeat by an enemy. It is one master’s single moment of fear.','c. 20–25 ABY','published'),
('68000000-0000-4000-8009-000000000006','zh-CN','卢克自我流放','卢克退隐阿赫托,切断与原力的联系,只留下一份地图。','','绝地的传承第二次缩到一个人身上,而这个人也决定什么都不做。','雅汶战役后 25 至 28 年','published'),
('68000000-0000-4000-8009-000000000006','en','Luke goes into exile','Luke withdraws to Ahch-To, closes himself off from the Force, and leaves only a map behind.','','For the second time the succession narrows to one person who has decided to do nothing.','c. 25–28 ABY','published'),
('68000000-0000-4000-8009-000000000007','zh-CN','第一秩序集结','帝国残部在未知区域重组为第一秩序。','','','雅汶战役后 25 至 28 年','published'),
('68000000-0000-4000-8009-000000000007','en','The First Order assembles','Imperial remnants regroup in the Unknown Regions as the First Order.','','','c. 25–28 ABY','published'),
-- era 10
('68000000-0000-4000-8010-000000000001','zh-CN','地图残片被藏进 BB-8','波·达默龙取得通往卢克的地图残片,存入 BB-8 后被俘。','','这一手与二十多年前莱娅把资料塞进 R2-D2 完全相同。','雅汶战役后 28 至 34 年','published'),
('68000000-0000-4000-8010-000000000001','en','The map is hidden in BB-8','Poe Dameron obtains the fragment of a map to Luke, puts it in BB-8, and is captured.','','The same move Leia made with R2-D2, thirty-odd years earlier.','c. 28–34 ABY','published'),
('68000000-0000-4000-8010-000000000002','zh-CN','芬恩临阵脱离','第一秩序士兵 FN-2187 拒绝执行屠村命令,救出波并叛逃。','','第一秩序的兵是抢来的孩子,而这一点由一个逃兵当众说明。','雅汶战役后 28 至 34 年','published'),
('68000000-0000-4000-8010-000000000002','en','Finn deserts','The trooper FN-2187 refuses an order to fire on a village, frees Poe, and runs.','','The First Order’s soldiers are stolen children, and it takes a deserter to say so out loud.','c. 28–34 ABY','published'),
('68000000-0000-4000-8010-000000000003','zh-CN','蕾伊离开贾库','拾荒者蕾伊因 BB-8 卷入追捕,与芬恩驾千年隼逃离贾库。','','她一直在等家人回来,而离开是她第一次不再等。','雅汶战役后 28 至 34 年','published'),
('68000000-0000-4000-8010-000000000003','en','Rey leaves Jakku','The scavenger Rey is drawn into the hunt for BB-8 and leaves Jakku with Finn aboard the Falcon.','','She has been waiting for her family to come back; leaving is the first time she stops waiting.','c. 28–34 ABY','published'),
('68000000-0000-4000-8010-000000000004','zh-CN','蕾伊触碰光剑','蕾伊在玛兹的地下室触到卢克的旧光剑,看见一连串不属于她的记忆。','影片让这把剑先后属于阿纳金与卢克,再选中一个不知出身的拾荒者。','传承在此第一次越出血缘。','雅汶战役后 28 至 34 年','published'),
('68000000-0000-4000-8010-000000000004','en','Rey touches the lightsaber','In Maz’s cellar Rey takes hold of Luke’s old lightsaber and sees a run of memories that are not hers.','The film has the weapon pass from Anakin to Luke and then choose a scavenger with no known name.','The succession steps outside the bloodline for the first time.','c. 28–34 ABY','published'),
('68000000-0000-4000-8010-000000000005','zh-CN','塔科达纳遭袭','第一秩序袭击玛兹的据点,凯洛·伦掳走蕾伊。','','','雅汶战役后 28 至 34 年','published'),
('68000000-0000-4000-8010-000000000005','en','The raid on Takodana','The First Order strikes Maz’s waypoint and Kylo Ren takes Rey.','','','c. 28–34 ABY','published'),
('68000000-0000-4000-8010-000000000006','zh-CN','霍斯尼安主星被毁','第一秩序以弑星者基地摧毁新共和国首都星系。','','新共和国在一次射击中消失,战争回到了抵抗组织与正规军之间。','雅汶战役后 28 至 34 年','published'),
('68000000-0000-4000-8010-000000000006','en','Hosnian Prime is destroyed','Starkiller Base destroys the New Republic’s capital system.','','The New Republic ends in a single shot, and the war reverts to a resistance against a regular army.','c. 28–34 ABY','published'),
('68000000-0000-4000-8010-000000000007','zh-CN','汉·索洛与儿子相见','汉在弑星者基地的桥上唤本回家,本刺杀了他。','影片让父亲在动手之前伸手抚了他的脸,而儿子事后并未因此解脱。','这一刀之后,本·索洛再没有能回头的路——直到他母亲用最后一口气叫他。','雅汶战役后 28 至 34 年','published'),
('68000000-0000-4000-8010-000000000007','en','Han Solo meets his son','On a bridge inside Starkiller Base, Han calls Ben home, and Ben runs him through.','The film has the father touch his face before it happens, and the son is not freed by it afterwards.','After this there is no way back for Ben Solo — until his mother spends her last breath calling him.','c. 28–34 ABY','published'),
('68000000-0000-4000-8010-000000000008','zh-CN','蕾伊与凯洛·伦交手','蕾伊初次持剑即与受伤的凯洛·伦战成上风。','','','雅汶战役后 28 至 34 年','published'),
('68000000-0000-4000-8010-000000000008','en','Rey holds her own against Kylo','Holding a lightsaber for the first time, Rey gets the better of a wounded Kylo Ren.','','','c. 28–34 ABY','published'),
('68000000-0000-4000-8010-000000000009','zh-CN','弑星者基地被摧毁','抵抗组织摧毁弑星者基地。','','','雅汶战役后 28 至 34 年','published'),
('68000000-0000-4000-8010-000000000009','en','Starkiller Base is destroyed','The Resistance destroys Starkiller Base.','','','c. 28–34 ABY','published'),
('68000000-0000-4000-8010-000000000010','zh-CN','蕾伊在阿赫托找到卢克','蕾伊循地图抵达阿赫托,把光剑递给卢克。','','','雅汶战役后 34 年','published'),
('68000000-0000-4000-8010-000000000010','en','Rey finds Luke on Ahch-To','Rey follows the map to Ahch-To and holds the lightsaber out to Luke.','','','34 ABY','published'),
('68000000-0000-4000-8010-000000000011','zh-CN','莱娅指挥抵抗组织','新共和国之外,莱娅组建并指挥抵抗组织。','','她一生第三次从头组建一个对抗帝国式政权的组织。','雅汶战役后 28 至 34 年','published'),
('68000000-0000-4000-8010-000000000011','en','Leia commands the Resistance','Outside the New Republic’s structures, Leia raises and commands the Resistance.','','It is the third time in her life she builds an organisation against an imperial power from nothing.','c. 28–34 ABY','published'),
-- era 11
('68000000-0000-4000-8011-000000000001','zh-CN','卢克拒绝授徒','卢克扔开光剑,拒绝蕾伊的请求,称绝地应当终结。','','','雅汶战役后 34 年','published'),
('68000000-0000-4000-8011-000000000001','en','Luke refuses to teach','Luke throws the lightsaber aside, refuses Rey, and says the Jedi should end.','','','34 ABY','published'),
('68000000-0000-4000-8011-000000000002','zh-CN','卢克讲出学堂之夜','卢克三次讲述那一夜,最后承认自己确实拔了剑。','影片把这场坦白拍成绝地传统自我审视的一部分:传承要延续,先得承认师父也会失手。','绝地的第二次重建,是从一次认错开始的。','雅汶战役后 34 年','published'),
('68000000-0000-4000-8011-000000000002','en','Luke tells what happened at the temple','Luke gives three accounts of that night, and in the last one admits he did ignite the blade.','The film makes the confession part of what the tradition has to do: for it to continue, the master has to own that he failed.','The second rebuilding of the Jedi begins with an admission.','34 ABY','published'),
('68000000-0000-4000-8011-000000000003','zh-CN','蕾伊与凯洛的连结','两人跨越星系互相看见、互相交谈。','影片让敌对的两人成为彼此唯一能说实话的对象——这条连结此后决定了两个人的结局。','血脉之外,还有另一种可以传递的东西。','雅汶战役后 34 年','published'),
('68000000-0000-4000-8011-000000000003','en','Rey and Kylo are linked','Across the galaxy the two see and speak to each other.','The film makes two enemies the only person each can be honest with, and that link decides how both of them end.','Something can pass between people that is not blood.','34 ABY','published'),
('68000000-0000-4000-8011-000000000004','zh-CN','抵抗组织被追击','第一秩序以超空间追踪紧咬抵抗舰队,燃料将尽。','','','雅汶战役后 34 年','published'),
('68000000-0000-4000-8011-000000000004','en','The Resistance is pursued','The First Order tracks the Resistance fleet through hyperspace as its fuel runs down.','','','34 ABY','published'),
('68000000-0000-4000-8011-000000000005','zh-CN','尤达重回卢克身边','尤达以灵体现身,烧掉绝地古籍,告诉卢克失败也是要传下去的东西。','','这是整个九部曲对「传承」给出的定义:传的是人怎么面对自己犯的错。','雅汶战役后 34 年','published'),
('68000000-0000-4000-8011-000000000005','en','Yoda returns to Luke','Yoda appears, burns the old Jedi texts, and tells Luke that failure is part of what gets handed on.','','This is the saga’s definition of a succession: what is passed down is how someone faces what they got wrong.','34 ABY','published'),
('68000000-0000-4000-8011-000000000006','zh-CN','凯洛·伦杀死斯诺克','凯洛·伦在王座厅杀死斯诺克,与蕾伊并肩击败卫队。','影片让这一幕与三十年前的王座厅互为镜像,而这次学徒杀了师父之后并没有回头。','同一个房间、同一种选择,两代人给出了相反的答案。','雅汶战役后 34 年','published'),
('68000000-0000-4000-8011-000000000006','en','Kylo Ren kills Snoke','In the throne room Kylo Ren kills Snoke, and he and Rey fight the guard together.','The film mirrors the throne room of thirty years before, except that this apprentice kills his master and does not turn.','The same room and the same choice, answered opposite ways by two generations.','34 ABY','published'),
('68000000-0000-4000-8011-000000000007','zh-CN','蕾伊拒绝凯洛的提议','凯洛提出两人共治,并告诉蕾伊她的父母只是无名之辈;蕾伊拒绝。','','她被告知自己什么都不是,而她选择自己决定自己是谁。','雅汶战役后 34 年','published'),
('68000000-0000-4000-8011-000000000007','en','Rey refuses Kylo’s offer','Kylo offers to rule together and tells Rey her parents were nobody; she refuses.','','She is told she is nothing, and decides for herself what she is.','34 ABY','published'),
('68000000-0000-4000-8011-000000000008','zh-CN','霍尔多的跃迁','霍尔多驾舰以光速撞穿第一秩序旗舰。','','','雅汶战役后 34 年','published'),
('68000000-0000-4000-8011-000000000008','en','Holdo’s manoeuvre','Holdo turns her ship into the First Order flagship at lightspeed.','','','34 ABY','published'),
('68000000-0000-4000-8011-000000000009','zh-CN','克雷特之战','抵抗组织残部在克雷特的旧基地被围。','','','雅汶战役后 34 年','published'),
('68000000-0000-4000-8011-000000000009','en','The stand on Crait','What is left of the Resistance is cornered in an old base on Crait.','','','34 ABY','published'),
('68000000-0000-4000-8011-000000000010','zh-CN','卢克·天行者之死','卢克以跨星系的投影拖住第一秩序全军,让残部撤离,随后力竭而逝。','影片让他不带武器、不出一刀地赢下这一仗——与他父亲那次的答案完全一致。','他最后一次示范了那条规则:不杀,也能赢。','雅汶战役后 34 至 35 年','published'),
('68000000-0000-4000-8011-000000000010','en','The death of Luke Skywalker','Luke holds off the whole First Order with a projection cast across the galaxy, buys the survivors their escape, and is spent by it.','The film lets him win the fight unarmed and without a single stroke — the same answer he gave for his father.','He demonstrates the rule one last time: you can win without killing.','c. 34–35 ABY','published'),
-- era 12
('68000000-0000-4000-8012-000000000001','zh-CN','皇帝的声音再度传出','一段广播传遍银河,宣告皇帝仍然存在。','','','雅汶战役后 35 年','published'),
('68000000-0000-4000-8012-000000000001','en','The Emperor is heard again','A broadcast reaches the whole galaxy announcing that the Emperor is still there.','','','35 ABY','published'),
('68000000-0000-4000-8012-000000000002','zh-CN','蕾伊师从莱娅','莱娅以绝地的身份训练蕾伊。','影片在此确认莱娅本人受过卢克的训练,只是当年主动停下了。','传承的第三段由一位从未被称作绝地的人接手。','雅汶战役后 35 年','published'),
('68000000-0000-4000-8012-000000000002','en','Rey trains under Leia','Leia trains Rey as a Jedi.','The film confirms here that Leia was trained by Luke and chose to stop.','The third stretch of the succession is carried by someone never called a Jedi.','35 ABY','published'),
('68000000-0000-4000-8012-000000000003','zh-CN','帕萨纳的追寻','蕾伊一行前往帕萨纳追查通往皇帝的线索。','','','雅汶战役后 35 年','published'),
('68000000-0000-4000-8012-000000000003','en','The search on Pasaana','Rey and the others follow the trail toward the Emperor to Pasaana.','','','35 ABY','published'),
('68000000-0000-4000-8012-000000000004','zh-CN','凯洛告知蕾伊身世','凯洛·伦告诉蕾伊,她是皇帝的孙女。','影片把最坏的身世交给她,再让她选择不接受它——这与本·索洛的处境正好相反。','血脉被提出来当作宿命,而结局把它驳回了。','雅汶战役后 35 年','published'),
('68000000-0000-4000-8012-000000000004','en','Kylo tells Rey her descent','Kylo Ren tells Rey that she is the Emperor’s granddaughter.','The film hands her the worst possible ancestry and then lets her decline it — the exact inverse of Ben Solo’s situation.','Blood is put forward as destiny, and the ending refuses it.','35 ABY','published'),
('68000000-0000-4000-8012-000000000005','zh-CN','凯夫比尔的残骸','蕾伊在第二死星残骸中与凯洛交手并将其重伤。','','','雅汶战役后 35 年','published'),
('68000000-0000-4000-8012-000000000005','en','The wreck on Kef Bir','Rey fights Kylo in the wreckage of the second battle station and leaves him badly hurt.','','','35 ABY','published'),
('68000000-0000-4000-8012-000000000006','zh-CN','莱娅唤回儿子','莱娅耗尽自身向儿子传出最后一次呼唤,随即离世。','影片让母亲用自己的命完成汉没能完成的事——三十五年前她父亲也是被同一种不放弃救回来的。','天行者家族三代人,靠的是同一件事:有人不肯放手。','雅汶战役后 35 年','published'),
('68000000-0000-4000-8012-000000000006','en','Leia reaches her son','Leia spends the last of herself calling out to her son, and dies.','The film has the mother finish what Han could not — and thirty-five years earlier her own father was recovered by the same refusal to give up.','Three generations of Skywalkers turn on one thing: someone who will not let go.','35 ABY','published'),
('68000000-0000-4000-8012-000000000007','zh-CN','本·索洛回头','本·索洛丢掉面罩与头衔,前往埃克西戈尔。','','第三代完成了他祖父二十三年才走完的那一步。','雅汶战役后 35 年','published'),
('68000000-0000-4000-8012-000000000007','en','Ben Solo returns','Ben Solo throws away the mask and the title and sets course for Exegol.','','The third generation takes in one day the step his grandfather needed twenty-three years for.','35 ABY','published'),
('68000000-0000-4000-8012-000000000008','zh-CN','卢克把战机托出海面','卢克的灵体在阿赫托劝住蕾伊,并把沉入海中的战机举起。','','','雅汶战役后 35 年','published'),
('68000000-0000-4000-8012-000000000008','en','Luke lifts the ship','Luke’s spirit meets Rey on Ahch-To, turns her back from hiding, and raises his sunken fighter out of the sea.','','','35 ABY','published'),
('68000000-0000-4000-8012-000000000009','zh-CN','埃克西戈尔之战','抵抗组织与自发赶来的各方舰船在埃克西戈尔上空迎战。','','抵抗组织赢下这一仗靠的不是舰队,是有人肯来。','雅汶战役后 35 年','published'),
('68000000-0000-4000-8012-000000000009','en','The battle of Exegol','The Resistance and a fleet of ships that simply came meet the Emperor’s force above Exegol.','','The Resistance does not win with a navy. It wins because people turned up.','35 ABY','published'),
('68000000-0000-4000-8012-000000000010','zh-CN','蕾伊终结皇帝','蕾伊以两把光剑挡回皇帝的攻击,皇帝自毁;蕾伊力竭而死,本以自身生机将她救回。','影片让这一代同时给出两个答案:她不用他的力量,他用自己的命还了债。','西斯的传承在这里断了,而绝地的传承由一个自己选定姓氏的人接下去。','雅汶战役后 35 年','published'),
('68000000-0000-4000-8012-000000000010','en','Rey ends the Emperor','Rey turns the Emperor’s own attack back with two blades and he is destroyed; she dies of it, and Ben gives his own life to bring her back.','The film lets this generation answer twice at once: she declines to use his power, and he pays with his life.','The Sith line ends here, and the Jedi one continues in someone who picks her own surname.','35 ABY','published'),
('68000000-0000-4000-8012-000000000011','zh-CN','蕾伊自取天行者之姓','蕾伊回到塔图因埋下两把光剑,自称蕾伊·天行者。','影片让整部九部曲收在一个被选择的姓氏上:血缘给了她最坏的一份,而名字是她自己挑的。','天行者不再是一条血脉,而成为一种可以被继承的选择。','雅汶战役后 35 至 36 年','published'),
('68000000-0000-4000-8012-000000000011','en','Rey takes the name Skywalker','Rey returns to Tatooine, buries the two lightsabers, and gives her name as Rey Skywalker.','The film ends nine films on a chosen surname: her blood gave her the worst of it, and the name is the part she picked.','Skywalker stops being a bloodline and becomes a choice that can be inherited.','c. 35–36 ABY','published');

-- ============================================================
-- 3. EVENT LOCATIONS
-- ============================================================

INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id, l.id, w.role, w.position
FROM (VALUES
  ('the-new-republic-is-founded','hosnian-prime','primary',0),
  ('the-new-republic-is-founded','chandrila','origin',1),
  ('the-battle-of-jakku','jakku','primary',0),
  ('ben-solo-is-born','chandrila','primary',0),
  ('luke-rebuilds-the-jedi','ahch-to','primary',0),
  ('the-night-at-the-temple','ahch-to','primary',0),
  ('luke-goes-into-exile','ahch-to','primary',0),
  ('the-first-order-assembles','starkiller-base','primary',0),
  ('the-map-is-hidden-in-bb-8','jakku','primary',0),
  ('finn-deserts','jakku','primary',0),
  ('rey-leaves-jakku','jakku','primary',0),
  ('rey-touches-the-lightsaber','takodana','primary',0),
  ('the-raid-on-takodana','takodana','primary',0),
  ('hosnian-prime-destroyed','hosnian-prime','primary',0),
  ('hosnian-prime-destroyed','starkiller-base','origin',1),
  ('han-solo-meets-his-son','starkiller-base','primary',0),
  ('rey-holds-her-own-against-kylo','starkiller-base','primary',0),
  ('starkiller-base-destroyed','starkiller-base','primary',0),
  ('rey-finds-luke-on-ahch-to','ahch-to','primary',0),
  ('leia-commands-the-resistance','d-qar','primary',0),
  ('luke-refuses-to-teach','ahch-to','primary',0),
  ('luke-tells-what-happened-at-the-temple','ahch-to','primary',0),
  ('rey-and-kylo-are-linked','ahch-to','primary',0),
  ('the-resistance-is-pursued','d-qar','primary',0),
  ('yoda-returns-to-luke','ahch-to','primary',0),
  ('kylo-kills-snoke','crait','primary',0),
  ('rey-refuses-kylos-offer','crait','primary',0),
  ('holdos-maneuver','crait','primary',0),
  ('the-stand-on-crait','crait','primary',0),
  ('luke-skywalker-dies','ahch-to','primary',0),
  ('luke-skywalker-dies','crait','front',1),
  ('the-emperor-is-heard-again','exegol','primary',0),
  ('rey-trains-under-leia','ajan-kloss','primary',0),
  ('the-search-on-pasaana','pasaana','primary',0),
  ('kylo-tells-rey-her-descent','kijimi','primary',0),
  ('the-wreck-on-kef-bir','kef-bir','primary',0),
  ('leia-reaches-her-son','ajan-kloss','primary',0),
  ('leia-reaches-her-son','kef-bir','front',1),
  ('ben-solo-returns','kef-bir','primary',0),
  ('luke-lifts-the-ship','ahch-to','primary',0),
  ('the-battle-of-exegol','exegol','primary',0),
  ('rey-ends-the-emperor','exegol','primary',0),
  ('rey-takes-the-name-skywalker','tatooine','primary',0)
) AS w(event_slug, location_slug, role, position)
JOIN events e ON e.work_id='10000000-0000-4000-8000-000000000008' AND e.slug=w.event_slug
JOIN locations l ON l.work_id='10000000-0000-4000-8000-000000000008' AND l.slug=w.location_slug
ON CONFLICT DO NOTHING;

-- ============================================================
-- 4. EVENT CHARACTERS
-- ============================================================

INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id, c.id, w.role, w.participant_order, w.is_primary
FROM (VALUES
  ('the-new-republic-is-founded','mon-mothma','primary',0,true),
  ('the-new-republic-is-founded','leia-organa','participant',1,false),
  ('the-battle-of-jakku','admiral-ackbar','primary',0,true),
  ('the-battle-of-jakku','wedge-antilles','participant',1,false),
  ('ben-solo-is-born','ben-solo','primary',0,true),
  ('ben-solo-is-born','leia-organa','participant',1,false),
  ('ben-solo-is-born','han-solo','participant',2,false),
  ('luke-rebuilds-the-jedi','luke-skywalker','primary',0,true),
  ('luke-rebuilds-the-jedi','ben-solo','participant',1,false),
  ('luke-rebuilds-the-jedi','r2-d2','participant',2,false),
  ('the-night-at-the-temple','luke-skywalker','primary',0,true),
  ('the-night-at-the-temple','ben-solo','participant',1,false),
  ('the-night-at-the-temple','snoke','participant',2,false),
  ('luke-goes-into-exile','luke-skywalker','primary',0,true),
  ('the-first-order-assembles','snoke','primary',0,true),
  ('the-first-order-assembles','general-hux','participant',1,false),
  ('the-first-order-assembles','ben-solo','participant',2,false),
  ('the-map-is-hidden-in-bb-8','poe-dameron','primary',0,true),
  ('the-map-is-hidden-in-bb-8','bb-8','participant',1,false),
  ('the-map-is-hidden-in-bb-8','ben-solo','participant',2,false),
  ('finn-deserts','finn','primary',0,true),
  ('finn-deserts','poe-dameron','participant',1,false),
  ('rey-leaves-jakku','rey','primary',0,true),
  ('rey-leaves-jakku','finn','participant',1,false),
  ('rey-leaves-jakku','bb-8','participant',2,false),
  ('rey-touches-the-lightsaber','rey','primary',0,true),
  ('rey-touches-the-lightsaber','maz-kanata','participant',1,false),
  ('the-raid-on-takodana','ben-solo','primary',0,true),
  ('the-raid-on-takodana','rey','participant',1,false),
  ('the-raid-on-takodana','han-solo','participant',2,false),
  ('the-raid-on-takodana','maz-kanata','participant',3,false),
  ('hosnian-prime-destroyed','general-hux','primary',0,true),
  ('han-solo-meets-his-son','han-solo','primary',0,true),
  ('han-solo-meets-his-son','ben-solo','participant',1,false),
  ('han-solo-meets-his-son','rey','participant',2,false),
  ('han-solo-meets-his-son','finn','participant',3,false),
  ('han-solo-meets-his-son','chewbacca','participant',4,false),
  ('rey-holds-her-own-against-kylo','rey','primary',0,true),
  ('rey-holds-her-own-against-kylo','ben-solo','participant',1,false),
  ('rey-holds-her-own-against-kylo','finn','participant',2,false),
  ('starkiller-base-destroyed','poe-dameron','primary',0,true),
  ('starkiller-base-destroyed','han-solo','participant',1,false),
  ('starkiller-base-destroyed','chewbacca','participant',2,false),
  ('rey-finds-luke-on-ahch-to','rey','primary',0,true),
  ('rey-finds-luke-on-ahch-to','luke-skywalker','participant',1,false),
  ('rey-finds-luke-on-ahch-to','chewbacca','participant',2,false),
  ('leia-commands-the-resistance','leia-organa','primary',0,true),
  ('leia-commands-the-resistance','poe-dameron','participant',1,false),
  ('leia-commands-the-resistance','admiral-ackbar','participant',2,false),
  ('luke-refuses-to-teach','luke-skywalker','primary',0,true),
  ('luke-refuses-to-teach','rey','participant',1,false),
  ('luke-tells-what-happened-at-the-temple','luke-skywalker','primary',0,true),
  ('luke-tells-what-happened-at-the-temple','rey','participant',1,false),
  ('luke-tells-what-happened-at-the-temple','ben-solo','participant',2,false),
  ('rey-and-kylo-are-linked','rey','primary',0,true),
  ('rey-and-kylo-are-linked','ben-solo','participant',1,false),
  ('rey-and-kylo-are-linked','snoke','participant',2,false),
  ('the-resistance-is-pursued','leia-organa','primary',0,true),
  ('the-resistance-is-pursued','poe-dameron','participant',1,false),
  ('the-resistance-is-pursued','vice-admiral-holdo','participant',2,false),
  ('the-resistance-is-pursued','rose-tico','participant',3,false),
  ('yoda-returns-to-luke','yoda','primary',0,true),
  ('yoda-returns-to-luke','luke-skywalker','participant',1,false),
  ('kylo-kills-snoke','ben-solo','primary',0,true),
  ('kylo-kills-snoke','snoke','participant',1,false),
  ('kylo-kills-snoke','rey','participant',2,false),
  ('rey-refuses-kylos-offer','rey','primary',0,true),
  ('rey-refuses-kylos-offer','ben-solo','participant',1,false),
  ('holdos-maneuver','vice-admiral-holdo','primary',0,true),
  ('holdos-maneuver','general-hux','participant',1,false),
  ('the-stand-on-crait','poe-dameron','primary',0,true),
  ('the-stand-on-crait','finn','participant',1,false),
  ('the-stand-on-crait','rose-tico','participant',2,false),
  ('the-stand-on-crait','leia-organa','participant',3,false),
  ('luke-skywalker-dies','luke-skywalker','primary',0,true),
  ('luke-skywalker-dies','ben-solo','participant',1,false),
  ('luke-skywalker-dies','leia-organa','participant',2,false),
  ('the-emperor-is-heard-again','sheev-palpatine','primary',0,true),
  ('the-emperor-is-heard-again','general-hux','participant',1,false),
  ('rey-trains-under-leia','rey','primary',0,true),
  ('rey-trains-under-leia','leia-organa','participant',1,false),
  ('the-search-on-pasaana','rey','primary',0,true),
  ('the-search-on-pasaana','finn','participant',1,false),
  ('the-search-on-pasaana','poe-dameron','participant',2,false),
  ('the-search-on-pasaana','c-3po','participant',3,false),
  ('the-search-on-pasaana','chewbacca','participant',4,false),
  ('kylo-tells-rey-her-descent','ben-solo','primary',0,true),
  ('kylo-tells-rey-her-descent','rey','participant',1,false),
  ('kylo-tells-rey-her-descent','sheev-palpatine','participant',2,false),
  ('the-wreck-on-kef-bir','rey','primary',0,true),
  ('the-wreck-on-kef-bir','ben-solo','participant',1,false),
  ('the-wreck-on-kef-bir','jannah','participant',2,false),
  ('leia-reaches-her-son','leia-organa','primary',0,true),
  ('leia-reaches-her-son','ben-solo','participant',1,false),
  ('leia-reaches-her-son','rey','participant',2,false),
  ('ben-solo-returns','ben-solo','primary',0,true),
  ('ben-solo-returns','han-solo','participant',1,false),
  ('luke-lifts-the-ship','luke-skywalker','primary',0,true),
  ('luke-lifts-the-ship','rey','participant',1,false),
  ('the-battle-of-exegol','poe-dameron','primary',0,true),
  ('the-battle-of-exegol','finn','participant',1,false),
  ('the-battle-of-exegol','lando-calrissian','participant',2,false),
  ('the-battle-of-exegol','jannah','participant',3,false),
  ('the-battle-of-exegol','chewbacca','participant',4,false),
  ('rey-ends-the-emperor','rey','primary',0,true),
  ('rey-ends-the-emperor','sheev-palpatine','participant',1,false),
  ('rey-ends-the-emperor','ben-solo','participant',2,false),
  ('rey-takes-the-name-skywalker','rey','primary',0,true),
  ('rey-takes-the-name-skywalker','luke-skywalker','participant',1,false),
  ('rey-takes-the-name-skywalker','leia-organa','participant',2,false),
  ('rey-takes-the-name-skywalker','bb-8','participant',3,false)
) AS w(event_slug, character_slug, role, participant_order, is_primary)
JOIN events e ON e.work_id='10000000-0000-4000-8000-000000000008' AND e.slug=w.event_slug
JOIN characters c ON c.work_id='10000000-0000-4000-8000-000000000008' AND c.slug=w.character_slug
ON CONFLICT DO NOTHING;

-- ============================================================
-- 5. EVENT SOURCES
-- ============================================================

INSERT INTO event_sources(event_id,source_id)
SELECT e.id, s.id FROM events e
JOIN sources s ON s.work_id='10000000-0000-4000-8000-000000000008' AND s.title='Episode VII: The Force Awakens (2015 film)'
WHERE e.id::text LIKE '68000000-0000-4000-8009%' OR e.id::text LIKE '68000000-0000-4000-8010%' ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id, s.id FROM events e
JOIN sources s ON s.work_id='10000000-0000-4000-8000-000000000008' AND s.title='Episode VIII: The Last Jedi (2017 film)'
WHERE e.id::text LIKE '68000000-0000-4000-8011%' OR e.slug IN ('the-night-at-the-temple','luke-goes-into-exile','luke-rebuilds-the-jedi') ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id, s.id FROM events e
JOIN sources s ON s.work_id='10000000-0000-4000-8000-000000000008' AND s.title='Episode IX: The Rise of Skywalker (2019 film)'
WHERE e.id::text LIKE '68000000-0000-4000-8012%' ON CONFLICT DO NOTHING;

-- ============================================================
-- 6. RELATIONS — the third generation
-- ============================================================

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT w.id::uuid, '10000000-0000-4000-8000-000000000008', f.id, t.id, w.relation_type, w.direction::relationship_direction, w.sentiment::relationship_sentiment, w.strength, w.status::relationship_status, NULL, NULL
FROM (VALUES
  ('78000000-0000-4000-8009-000000000001','leia-organa','ben-solo','family','bidirectional','mixed',5,'ended'),
  ('78000000-0000-4000-8009-000000000002','han-solo','ben-solo','family','bidirectional','mixed',5,'ended'),
  ('78000000-0000-4000-8009-000000000003','luke-skywalker','ben-solo','mentor','source_to_target','negative',5,'ended'),
  ('78000000-0000-4000-8009-000000000004','anakin-skywalker','ben-solo','family','source_to_target','mixed',4,'ended'),
  ('78000000-0000-4000-8010-000000000001','snoke','ben-solo','mentor','source_to_target','negative',5,'ended'),
  ('78000000-0000-4000-8010-000000000002','rey','ben-solo','adversary','bidirectional','mixed',5,'changed'),
  ('78000000-0000-4000-8010-000000000003','rey','finn','ally','bidirectional','positive',5,'active'),
  ('78000000-0000-4000-8010-000000000004','poe-dameron','finn','ally','bidirectional','positive',5,'active'),
  ('78000000-0000-4000-8010-000000000005','rey','bb-8','ally','bidirectional','positive',4,'active'),
  ('78000000-0000-4000-8010-000000000006','general-hux','ben-solo','adversary','bidirectional','negative',3,'ended'),
  ('78000000-0000-4000-8010-000000000007','maz-kanata','han-solo','ally','bidirectional','positive',3,'ended'),
  ('78000000-0000-4000-8010-000000000008','leia-organa','poe-dameron','mentor','source_to_target','positive',4,'ended'),
  ('78000000-0000-4000-8011-000000000001','luke-skywalker','rey','mentor','source_to_target','mixed',5,'ended'),
  ('78000000-0000-4000-8011-000000000002','vice-admiral-holdo','leia-organa','ally','bidirectional','positive',4,'ended'),
  -- Yoda -> Luke is NOT repeated here. It already exists from era 07, and
  -- character_relations is unique on (work, from, to, type): a second row is
  -- skipped by ON CONFLICT, and its translations then have nothing to point
  -- at. A recurring relationship is one row; the eras it spans are carried by
  -- the events, not by duplicate edges.
  ('78000000-0000-4000-8011-000000000003','rose-tico','finn','romantic','source_to_target','positive',3,'active'),
  ('78000000-0000-4000-8012-000000000001','leia-organa','rey','mentor','source_to_target','positive',5,'ended'),
  ('78000000-0000-4000-8012-000000000002','sheev-palpatine','rey','family','source_to_target','negative',4,'ended'),
  ('78000000-0000-4000-8012-000000000003','rey','luke-skywalker','other','source_to_target','positive',5,'active'),
  ('78000000-0000-4000-8012-000000000004','jannah','finn','ally','bidirectional','positive',3,'active'),
  ('78000000-0000-4000-8012-000000000005','lando-calrissian','jannah','ally','bidirectional','positive',3,'active')
) AS w(id, from_slug, to_slug, relation_type, direction, sentiment, strength, status)
JOIN characters f ON f.work_id='10000000-0000-4000-8000-000000000008' AND f.slug=w.from_slug
JOIN characters t ON t.work_id='10000000-0000-4000-8000-000000000008' AND t.slug=w.to_slug
ON CONFLICT DO NOTHING;

INSERT INTO relation_translations(relation_id,locale,label,summary,status) VALUES
('78000000-0000-4000-8009-000000000001','zh-CN','母子(莱娅↔本)','她耗尽自己唤回了他,而她父亲当年也是被同一种不放弃救回来的。','published'),
('78000000-0000-4000-8009-000000000001','en','Mother and son (Leia ↔ Ben)','She spends herself to reach him — the same refusal that once recovered her own father.','published'),
('78000000-0000-4000-8009-000000000002','zh-CN','父子(汉↔本)','父亲在桥上叫他回家,儿子动了手,却没有因此解脱。','published'),
('78000000-0000-4000-8009-000000000002','en','Father and son (Han ↔ Ben)','The father calls him home on a bridge; the son strikes, and is not freed by it.','published'),
('78000000-0000-4000-8009-000000000003','zh-CN','舅甥与师徒(卢克→本)','一瞬间的恐惧毁掉了学堂,也造出了凯洛·伦。','published'),
('78000000-0000-4000-8009-000000000003','en','Uncle and nephew, master and student (Luke → Ben)','One instant of fear destroys the school and makes Kylo Ren.','published'),
('78000000-0000-4000-8009-000000000004','zh-CN','祖孙(维达→本)','孙子拿祖父的旧头盔当榜样,却学错了榜样。','published'),
('78000000-0000-4000-8009-000000000004','en','Grandfather and grandson (Vader → Ben)','The grandson takes the old helmet as his model, and models himself on the wrong half.','published'),
('78000000-0000-4000-8010-000000000001','zh-CN','西斯师徒(斯诺克→凯洛)','中介式的师父,最终死在学徒手里。','published'),
('78000000-0000-4000-8010-000000000001','en','Sith master and apprentice (Snoke → Kylo)','A master who was only ever an intermediary, killed by his own apprentice.','published'),
('78000000-0000-4000-8010-000000000002','zh-CN','对手与连结(蕾伊↔本)','跨星系互相看见的两个人,最后一个救了另一个。','published'),
('78000000-0000-4000-8010-000000000002','en','Adversaries, linked (Rey ↔ Ben)','Two who see each other across the galaxy, and at the end one gives his life for the other.','published'),
('78000000-0000-4000-8010-000000000003','zh-CN','生死之交(蕾伊↔芬恩)','一个拾荒者与一个逃兵,互相成了对方的第一个家人。','published'),
('78000000-0000-4000-8010-000000000003','en','Sworn friends (Rey ↔ Finn)','A scavenger and a deserter, each the other’s first family.','published'),
('78000000-0000-4000-8010-000000000004','zh-CN','生死之交(波↔芬恩)','把名字给了一个只有编号的人。','published'),
('78000000-0000-4000-8010-000000000004','en','Sworn friends (Poe ↔ Finn)','He gives a name to a man who had only a number.','published'),
('78000000-0000-4000-8010-000000000005','zh-CN','搭档(蕾伊↔BB-8)','第三代的人与机器人搭档。','published'),
('78000000-0000-4000-8010-000000000005','en','Partners (Rey ↔ BB-8)','The third generation’s pairing of person and droid.','published'),
('78000000-0000-4000-8010-000000000006','zh-CN','同僚倾轧(赫克斯↔凯洛)','第一秩序内部的两条线,彼此都想除掉对方。','published'),
('78000000-0000-4000-8010-000000000006','en','Rivals (Hux ↔ Kylo)','Two lines inside the First Order, each trying to be rid of the other.','published'),
('78000000-0000-4000-8010-000000000007','zh-CN','旧识(玛兹↔汉)','欠账多年的老朋友。','published'),
('78000000-0000-4000-8010-000000000007','en','Old acquaintances (Maz ↔ Han)','Old friends, with debts outstanding.','published'),
('78000000-0000-4000-8010-000000000008','zh-CN','将军与飞行员(莱娅→波)','她教他别把人当消耗品。','published'),
('78000000-0000-4000-8010-000000000008','en','General and pilot (Leia → Poe)','She teaches him not to spend people.','published'),
('78000000-0000-4000-8011-000000000001','zh-CN','师徒(卢克→蕾伊)','先拒绝,后承认自己的错,再把传承交出去。','published'),
('78000000-0000-4000-8011-000000000001','en','Master and student (Luke → Rey)','He refuses, then owns what he got wrong, and then hands it on.','published'),
('78000000-0000-4000-8011-000000000002','zh-CN','战友(霍尔多↔莱娅)','多年旧交,以一次自毁式跃迁作别。','published'),
('78000000-0000-4000-8011-000000000002','en','Comrades (Holdo ↔ Leia)','Friends of long standing, parted by one lightspeed ram.','published'),
('78000000-0000-4000-8011-000000000003','zh-CN','情感(罗丝→芬恩)','她拦下了他的自杀式冲锋。','published'),
('78000000-0000-4000-8011-000000000003','en','Attachment (Rose → Finn)','She stops him from spending himself.','published'),
('78000000-0000-4000-8012-000000000001','zh-CN','师徒(莱娅→蕾伊)','从未被称作绝地的人,训练出了最后一位绝地。','published'),
('78000000-0000-4000-8012-000000000001','en','Master and student (Leia → Rey)','Someone never called a Jedi trains the last one.','published'),
('78000000-0000-4000-8012-000000000002','zh-CN','祖孙(皇帝→蕾伊)','血缘上最坏的一份继承,被继承者当面拒绝。','published'),
('78000000-0000-4000-8012-000000000002','en','Grandfather and granddaughter (Palpatine → Rey)','The worst inheritance in the saga, declined to its face.','published'),
('78000000-0000-4000-8012-000000000003','zh-CN','自取的姓氏(蕾伊→天行者)','她埋下两把光剑,选了这个名字。','published'),
('78000000-0000-4000-8012-000000000003','en','A chosen name (Rey → Skywalker)','She buries the two lightsabers and picks the name.','published'),
('78000000-0000-4000-8012-000000000004','zh-CN','战友(珍娜↔芬恩)','两个被抢走童年的人,认出了彼此。','published'),
('78000000-0000-4000-8012-000000000004','en','Comrades (Jannah ↔ Finn)','Two people whose childhoods were taken, recognising each other.','published'),
('78000000-0000-4000-8012-000000000005','zh-CN','同行(兰多↔珍娜)','老一代与新一代在最后一战里并肩。','published'),
('78000000-0000-4000-8012-000000000005','en','Fellow travellers (Lando ↔ Jannah)','An old generation and a new one, side by side in the last fight.','published')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 7. GROUP MEMBERSHIP
-- ============================================================

INSERT INTO character_group_members(group_id,character_id,membership_role)
SELECT g.id, c.id, w.membership_role
FROM (VALUES
  ('the-resistance','poe-dameron','commander'),
  ('the-resistance','bb-8','astromech'),
  ('the-resistance','vice-admiral-holdo','vice admiral'),
  ('the-resistance','rose-tico','mechanic'),
  ('the-resistance','jannah','ally at Kef Bir'),
  ('the-resistance','han-solo','ally'),
  ('the-resistance','lando-calrissian','ally'),
  ('the-resistance','finn','recruit, former trooper'),
  ('first-order','snoke','supreme leader'),
  ('first-order','general-hux','general'),
  ('smugglers-and-outlaws','maz-kanata','keeper of the waypoint'),
  ('jedi-order','ben-solo','student, returned at the end'),
  ('house-of-skywalker','ben-solo','son of Leia'),
  ('house-of-skywalker','han-solo','father of Ben'),
  ('house-of-organa','ben-solo','grandson of the house'),
  ('house-of-organa','han-solo','husband of the daughter')
) AS w(group_slug, character_slug, membership_role)
JOIN character_groups g ON g.work_id='10000000-0000-4000-8000-000000000008' AND g.slug=w.group_slug
JOIN characters c ON c.work_id='10000000-0000-4000-8000-000000000008' AND c.slug=w.character_slug
ON CONFLICT DO NOTHING;

COMMIT;
