BEGIN;

-- Eras 06, 07 and 08 — the original trilogy.
--
--   06 · yavin-campaign     (0 BBY-0 ABY, years -1..1)  — 12 events
--   07 · hoth-and-exile     (3 ABY, years 2..4)         — 12 events
--   08 · endor-and-the-fall (4 ABY, years 4..5)         — 12 events
--
-- Density sits on the Skywalker line and the Jedi succession: the reveal, the
-- training, the refusal to kill, the turn. Peripheral events carry a summary
-- and nothing more. Bands 6001, 7001, 8001.

-- ============================================================
-- 1. CHARACTERS
-- ============================================================

INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('48000000-0000-4000-8006-000000000001','10000000-0000-4000-8000-000000000008','jabba-the-hutt',601,'male','adult','antagonist','fictional',NULL,5,'ruler',3),
('48000000-0000-4000-8008-000000000001','10000000-0000-4000-8000-000000000008','wicket',801,'male','adult','supporting','fictional',NULL,NULL,'person',2)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,aliases,detail,motivation,status) VALUES
('48000000-0000-4000-8006-000000000001','zh-CN','贾巴','赫特人犯罪集团首领,塔图因的实际统治者。','{}','','收账,并让所有人看见欠债的下场。','published'),
('48000000-0000-4000-8006-000000000001','en','Jabba the Hutt','A Hutt crime lord and the effective ruler of Tatooine.','{}','','Collect what he is owed, in public.','published'),
('48000000-0000-4000-8008-000000000001','zh-CN','维克特','恩多森林卫星的原住民,义军地面行动的向导。','{}','','','published'),
('48000000-0000-4000-8008-000000000001','en','Wicket','A native of the Endor forest moon who guides the rebel ground team.','{}','','','published')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 2. EVENTS
-- ============================================================

INSERT INTO events(id,work_id,slug,start_date,end_date,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,start_month,start_day,confidence,chapter_id) VALUES
-- era 06
('68000000-0000-4000-8006-000000000001','10000000-0000-4000-8000-000000000008','luke-finds-leias-message',NULL,NULL,6001,'fictional_narrative','discovery','fictional_calendar','fictional',-1,-1,NULL,NULL,'high','88000000-0000-4000-8006-000000000001'),
('68000000-0000-4000-8006-000000000002','10000000-0000-4000-8000-000000000008','obi-wan-tells-luke-of-his-father',NULL,NULL,6003,'fictional_narrative','meeting','fictional_calendar','fictional',-1,-1,NULL,NULL,'high','88000000-0000-4000-8006-000000000001'),
('68000000-0000-4000-8006-000000000003','10000000-0000-4000-8000-000000000008','the-lars-farm-is-burned',NULL,NULL,6005,'fictional_narrative','death','fictional_calendar','fictional',-1,-1,NULL,NULL,'high','88000000-0000-4000-8006-000000000001'),
('68000000-0000-4000-8006-000000000004','10000000-0000-4000-8000-000000000008','hiring-the-falcon',NULL,NULL,6007,'fictional_narrative','meeting','fictional_calendar','fictional',-1,-1,NULL,NULL,'high','88000000-0000-4000-8006-000000000001'),
('68000000-0000-4000-8006-000000000005','10000000-0000-4000-8000-000000000008','alderaan-is-destroyed',NULL,NULL,6009,'fictional_narrative','battle','fictional_calendar','fictional',-1,-1,NULL,NULL,'high','88000000-0000-4000-8006-000000000001'),
('68000000-0000-4000-8006-000000000006','10000000-0000-4000-8000-000000000008','the-rescue-of-leia',NULL,NULL,6011,'fictional_narrative','escape','fictional_calendar','fictional',-1,-1,NULL,NULL,'high','88000000-0000-4000-8006-000000000001'),
('68000000-0000-4000-8006-000000000007','10000000-0000-4000-8000-000000000008','obi-wan-falls-to-vader',NULL,NULL,6013,'fictional_narrative','death','fictional_calendar','fictional',-1,-1,NULL,NULL,'high','88000000-0000-4000-8006-000000000001'),
('68000000-0000-4000-8006-000000000008','10000000-0000-4000-8000-000000000008','the-plans-reach-yavin-4',NULL,NULL,6015,'fictional_narrative','discovery','fictional_calendar','fictional',-1,-1,NULL,NULL,'high','88000000-0000-4000-8006-000000000001'),
('68000000-0000-4000-8006-000000000009','10000000-0000-4000-8000-000000000008','the-battle-of-yavin',NULL,NULL,6017,'fictional_narrative','battle','fictional_calendar','fictional',-1,1,NULL,NULL,'high','88000000-0000-4000-8006-000000000001'),
('68000000-0000-4000-8006-000000000010','10000000-0000-4000-8000-000000000008','the-trench-run',NULL,NULL,6019,'fictional_narrative','battle','fictional_calendar','fictional',-1,1,NULL,NULL,'high','88000000-0000-4000-8006-000000000001'),
('68000000-0000-4000-8006-000000000011','10000000-0000-4000-8000-000000000008','tarkin-dies-with-the-station',NULL,NULL,6021,'fictional_narrative','death','fictional_calendar','fictional',-1,1,NULL,NULL,'high','88000000-0000-4000-8006-000000000001'),
('68000000-0000-4000-8006-000000000012','10000000-0000-4000-8000-000000000008','the-ceremony-on-yavin-4',NULL,NULL,6023,'fictional_narrative','social','fictional_calendar','fictional',1,1,NULL,NULL,'high','88000000-0000-4000-8006-000000000001'),
-- era 07
('68000000-0000-4000-8007-000000000001','10000000-0000-4000-8000-000000000008','the-alliance-base-on-hoth',NULL,NULL,7001,'fictional_narrative','other','fictional_calendar','fictional',2,3,NULL,NULL,'high','88000000-0000-4000-8007-000000000001'),
('68000000-0000-4000-8007-000000000002','10000000-0000-4000-8000-000000000008','obi-wan-appears-to-luke',NULL,NULL,7003,'legendary_or_mythic','meeting','fictional_calendar','fictional',2,3,NULL,NULL,'high','88000000-0000-4000-8007-000000000001'),
('68000000-0000-4000-8007-000000000003','10000000-0000-4000-8000-000000000008','the-battle-of-hoth',NULL,NULL,7005,'fictional_narrative','battle','fictional_calendar','fictional',3,3,NULL,NULL,'high','88000000-0000-4000-8007-000000000001'),
('68000000-0000-4000-8007-000000000004','10000000-0000-4000-8000-000000000008','the-evacuation-of-echo-base',NULL,NULL,7007,'fictional_narrative','escape','fictional_calendar','fictional',3,3,NULL,NULL,'high','88000000-0000-4000-8007-000000000001'),
('68000000-0000-4000-8007-000000000005','10000000-0000-4000-8000-000000000008','luke-seeks-yoda-on-dagobah',NULL,NULL,7009,'fictional_narrative','journey','fictional_calendar','fictional',3,3,NULL,NULL,'high','88000000-0000-4000-8007-000000000001'),
('68000000-0000-4000-8007-000000000006','10000000-0000-4000-8000-000000000008','yoda-takes-luke-as-a-student',NULL,NULL,7011,'fictional_narrative','meeting','fictional_calendar','fictional',3,3,NULL,NULL,'high','88000000-0000-4000-8007-000000000001'),
('68000000-0000-4000-8007-000000000007','10000000-0000-4000-8000-000000000008','the-cave-on-dagobah',NULL,NULL,7013,'symbolic_or_dream','trial','fictional_calendar','fictional',3,3,NULL,NULL,'high','88000000-0000-4000-8007-000000000001'),
('68000000-0000-4000-8007-000000000008','10000000-0000-4000-8000-000000000008','the-trap-at-cloud-city',NULL,NULL,7015,'fictional_narrative','betrayal','fictional_calendar','fictional',3,3,NULL,NULL,'high','88000000-0000-4000-8007-000000000001'),
('68000000-0000-4000-8007-000000000009','10000000-0000-4000-8000-000000000008','han-solo-frozen-in-carbonite',NULL,NULL,7017,'fictional_narrative','imprisonment','fictional_calendar','fictional',3,3,NULL,NULL,'high','88000000-0000-4000-8007-000000000001'),
('68000000-0000-4000-8007-000000000010','10000000-0000-4000-8000-000000000008','luke-leaves-his-training',NULL,NULL,7019,'fictional_narrative','journey','fictional_calendar','fictional',3,3,NULL,NULL,'high','88000000-0000-4000-8007-000000000001'),
('68000000-0000-4000-8007-000000000011','10000000-0000-4000-8000-000000000008','vader-tells-luke-the-truth',NULL,NULL,7021,'fictional_narrative','discovery','fictional_calendar','fictional',3,3,NULL,NULL,'high','88000000-0000-4000-8007-000000000001'),
('68000000-0000-4000-8007-000000000012','10000000-0000-4000-8000-000000000008','lando-turns-back',NULL,NULL,7023,'fictional_narrative','escape','fictional_calendar','fictional',3,4,NULL,NULL,'high','88000000-0000-4000-8007-000000000001'),
-- era 08
('68000000-0000-4000-8008-000000000001','10000000-0000-4000-8000-000000000008','the-rescue-from-jabbas-palace',NULL,NULL,8001,'fictional_narrative','escape','fictional_calendar','fictional',4,4,NULL,NULL,'high','88000000-0000-4000-8008-000000000001'),
('68000000-0000-4000-8008-000000000002','10000000-0000-4000-8000-000000000008','jabba-the-hutt-dies',NULL,NULL,8003,'fictional_narrative','death','fictional_calendar','fictional',4,4,NULL,NULL,'high','88000000-0000-4000-8008-000000000001'),
('68000000-0000-4000-8008-000000000003','10000000-0000-4000-8000-000000000008','yoda-dies-on-dagobah',NULL,NULL,8005,'fictional_narrative','death','fictional_calendar','fictional',4,4,NULL,NULL,'high','88000000-0000-4000-8008-000000000001'),
('68000000-0000-4000-8008-000000000004','10000000-0000-4000-8000-000000000008','obi-wan-explains-the-twins',NULL,NULL,8007,'legendary_or_mythic','discovery','fictional_calendar','fictional',4,4,NULL,NULL,'high','88000000-0000-4000-8008-000000000001'),
('68000000-0000-4000-8008-000000000005','10000000-0000-4000-8000-000000000008','luke-tells-leia-they-are-siblings',NULL,NULL,8009,'fictional_narrative','discovery','fictional_calendar','fictional',4,4,NULL,NULL,'high','88000000-0000-4000-8008-000000000001'),
('68000000-0000-4000-8008-000000000006','10000000-0000-4000-8000-000000000008','the-fleet-gathers-at-sullust',NULL,NULL,8011,'fictional_narrative','political','fictional_calendar','fictional',4,4,NULL,NULL,'high','88000000-0000-4000-8008-000000000001'),
('68000000-0000-4000-8008-000000000007','10000000-0000-4000-8000-000000000008','the-ground-battle-on-endor',NULL,NULL,8013,'fictional_narrative','battle','fictional_calendar','fictional',4,4,NULL,NULL,'high','88000000-0000-4000-8008-000000000001'),
('68000000-0000-4000-8008-000000000008','10000000-0000-4000-8000-000000000008','luke-surrenders-to-his-father',NULL,NULL,8015,'fictional_narrative','meeting','fictional_calendar','fictional',4,4,NULL,NULL,'high','88000000-0000-4000-8008-000000000001'),
('68000000-0000-4000-8008-000000000009','10000000-0000-4000-8000-000000000008','the-throne-room-duel',NULL,NULL,8017,'fictional_narrative','battle','fictional_calendar','fictional',4,4,NULL,NULL,'high','88000000-0000-4000-8008-000000000001'),
('68000000-0000-4000-8008-000000000010','10000000-0000-4000-8000-000000000008','luke-refuses-to-strike',NULL,NULL,8019,'fictional_narrative','trial','fictional_calendar','fictional',4,4,NULL,NULL,'high','88000000-0000-4000-8008-000000000001'),
('68000000-0000-4000-8008-000000000011','10000000-0000-4000-8000-000000000008','anakin-turns-back',NULL,NULL,8021,'fictional_narrative','death','fictional_calendar','fictional',4,4,NULL,NULL,'high','88000000-0000-4000-8008-000000000001'),
('68000000-0000-4000-8008-000000000012','10000000-0000-4000-8000-000000000008','the-second-station-destroyed',NULL,NULL,8023,'fictional_narrative','battle','fictional_calendar','fictional',4,5,NULL,NULL,'high','88000000-0000-4000-8008-000000000001');

INSERT INTO event_translations(event_id,locale,title,summary,detail,significance,time_label,status) VALUES
-- era 06
('68000000-0000-4000-8006-000000000001','zh-CN','卢克发现莱娅的讯息','卢克在清理 R2-D2 时看到一段残缺的求援全息影像。','','妹妹的求救信,由哥哥先看到,而两人都不知道彼此的存在。','雅汶战役前 0 年','published'),
('68000000-0000-4000-8006-000000000001','en','Luke finds Leia’s message','Cleaning R2-D2, Luke plays back a fragment of a holographic plea for help.','','A sister’s call for help, seen first by her brother, with neither knowing the other exists.','0 BBY','published'),
('68000000-0000-4000-8006-000000000002','zh-CN','欧比旺讲述卢克的父亲','欧比旺告诉卢克他父亲是绝地武士,并交给他一把光剑。','影片让欧比旺说父亲「被维达害死了」——这句半真半假的话此后成了卢克与他之间最大的裂痕。','绝地的传承在这一天以一个隐瞒开始。','雅汶战役前 0 年','published'),
('68000000-0000-4000-8006-000000000002','en','Obi-Wan tells Luke about his father','Obi-Wan tells Luke his father was a Jedi and gives him a lightsaber.','The film has Obi-Wan say Vader killed his father — a half-truth that becomes the deepest fracture between them.','The Jedi succession resumes on a day that begins with a concealment.','0 BBY','published'),
('68000000-0000-4000-8006-000000000003','zh-CN','拉尔斯农场被焚','帝国部队追查逃生舱,烧毁农场并杀害欧文与贝露。','','卢克唯一的家被烧掉,他才没有了留下的理由。','雅汶战役前 0 年','published'),
('68000000-0000-4000-8006-000000000003','en','The Lars farm is burned','Imperial troops tracing the escape pod burn the farm and kill Owen and Beru.','','Luke’s only home is destroyed, and only then does he have no reason to stay.','0 BBY','published'),
('68000000-0000-4000-8006-000000000004','zh-CN','雇下千年隼','卢克与欧比旺在莫斯艾斯利雇下汉·索洛与丘巴卡的走私船。','','正传三人组的组合始于一笔付不起的运费。','雅汶战役前 0 年','published'),
('68000000-0000-4000-8006-000000000004','en','Hiring the Falcon','Luke and Obi-Wan hire Han Solo and Chewbacca’s smuggling ship in Mos Eisley.','','The trio of the original trilogy begins as a fare they cannot afford.','0 BBY','published'),
('68000000-0000-4000-8006-000000000005','zh-CN','奥德朗被摧毁','塔金以战斗空间站摧毁奥德朗,以此逼供莱娅。','影片让摧毁发生在莱娅眼前,而她刚刚说出的坐标是假的——恐惧统治的第一次公开演示,同时也是它的第一次失效。','莱娅在同一天失去父亲、母星与整个族群。','雅汶战役前 0 年','published'),
('68000000-0000-4000-8006-000000000005','en','Alderaan is destroyed','Tarkin destroys Alderaan with the battle station to break Leia.','The film makes her watch, and the coordinates she has just given are false; the first public demonstration of rule by fear is also the first time it fails.','In one day Leia loses her father, her world and her people.','0 BBY','published'),
('68000000-0000-4000-8006-000000000006','zh-CN','营救莱娅','千年隼被吸入战斗空间站,三人临时决定救出被囚的莱娅。','','兄妹第一次见面,是在一间牢房门口。','雅汶战役前 0 年','published'),
('68000000-0000-4000-8006-000000000006','en','The rescue of Leia','The Falcon is pulled into the battle station and the three improvise a rescue of the prisoner.','','Brother and sister meet for the first time at a cell door.','0 BBY','published'),
('68000000-0000-4000-8006-000000000007','zh-CN','欧比旺死于维达之手','欧比旺在战斗空间站上与维达对决,主动收剑赴死。','他在卢克的注视下停手,躯体随即消失——影片让这次死亡成为一种转移,而不是一次终结。','卢克失去唯一的老师,而这个老师从此以另一种方式在场。','雅汶战役前 0 年','published'),
('68000000-0000-4000-8006-000000000007','en','Obi-Wan falls to Vader','Obi-Wan meets Vader aboard the station and lowers his blade rather than fight on.','He stops while Luke is watching, and his body is gone; the film makes the death a transfer rather than an end.','Luke loses his only teacher, and that teacher is present from then on in another form.','0 BBY','published'),
('68000000-0000-4000-8006-000000000008','zh-CN','技术资料送抵雅汶四号','资料被送到义军基地,分析后找出唯一的结构弱点。','','','雅汶战役前 0 年','published'),
('68000000-0000-4000-8006-000000000008','en','The plans reach Yavin 4','The readout arrives at the rebel base and analysis finds the one structural flaw.','','','0 BBY','published'),
('68000000-0000-4000-8006-000000000009','zh-CN','雅汶战役','义军以三十架战机迎战战斗空间站,伤亡惨重。','','此役成为全银河的纪年原点。','雅汶战役前 0 年至战役后 0 年','published'),
('68000000-0000-4000-8006-000000000009','en','The battle of Yavin','Thirty-odd rebel fighters meet the battle station, and most of them do not come back.','','This battle becomes the zero point of the galaxy’s calendar.','0 BBY–0 ABY','published'),
('68000000-0000-4000-8006-000000000010','zh-CN','壕沟突袭','卢克关闭瞄准计算机,凭直觉命中排气口。','汉·索洛在最后一刻折返,把维达的战机撞出航道;影片让走私者的转变与卢克的第一次「相信」同时发生。','绝地的方法第一次在战场上被证明有效,而它靠的是放弃仪器。','雅汶战役前 0 年至战役后 0 年','published'),
('68000000-0000-4000-8006-000000000010','en','The trench run','Luke switches off his targeting computer and makes the shot by feel.','Han turns back at the last moment and knocks Vader’s fighter off the run; the film puts the smuggler’s change and Luke’s first act of trust in the same minute.','The Jedi method is vindicated in combat for the first time, and it works by turning the instruments off.','0 BBY–0 ABY','published'),
('68000000-0000-4000-8006-000000000011','zh-CN','塔金与空间站同归于尽','塔金拒绝撤离,随战斗空间站被毁。','','','雅汶战役前 0 年至战役后 0 年','published'),
('68000000-0000-4000-8006-000000000011','en','Tarkin dies with the station','Tarkin refuses to evacuate and goes down with the battle station.','','','0 BBY–0 ABY','published'),
('68000000-0000-4000-8006-000000000012','zh-CN','雅汶四号的授勋','莱娅在义军基地为卢克与汉授勋。','','','雅汶战役后 0 年','published'),
('68000000-0000-4000-8006-000000000012','en','The ceremony on Yavin 4','Leia decorates Luke and Han at the rebel base.','','','0 ABY','published'),
-- era 07
('68000000-0000-4000-8007-000000000001','zh-CN','同盟在霍斯建立基地','义军在冰原星球霍斯建立回音基地。','','','雅汶战役后 2 至 3 年','published'),
('68000000-0000-4000-8007-000000000001','en','The Alliance base on Hoth','The rebels establish Echo Base on the ice world of Hoth.','','','c. 2–3 ABY','published'),
('68000000-0000-4000-8007-000000000002','zh-CN','欧比旺向卢克显现','卢克重伤濒死时,欧比旺以灵体现身,嘱他前往达戈巴。','','失去的老师转为另一种在场,绝地的传承靠这条线接了下去。','雅汶战役后 2 至 3 年','published'),
('68000000-0000-4000-8007-000000000002','en','Obi-Wan appears to Luke','Dying in the snow, Luke sees Obi-Wan, who tells him to go to Dagobah.','','The lost teacher becomes present in another form, and the succession continues along that thread.','c. 2–3 ABY','published'),
('68000000-0000-4000-8007-000000000003','zh-CN','霍斯战役','帝国以步行机部队攻破回音基地的护盾防线。','','','雅汶战役后 3 年','published'),
('68000000-0000-4000-8007-000000000003','en','The battle of Hoth','Imperial walkers break the shield line at Echo Base.','','','3 ABY','published'),
('68000000-0000-4000-8007-000000000004','zh-CN','回音基地撤离','同盟分批撤离,舰队被打散。','','此后同盟不再有固定基地,直到恩多战役前。','雅汶战役后 3 年','published'),
('68000000-0000-4000-8007-000000000004','en','The evacuation of Echo Base','The Alliance pulls out in waves and its fleet is scattered.','','From here the Alliance has no fixed base until the eve of Endor.','3 ABY','published'),
('68000000-0000-4000-8007-000000000005','zh-CN','卢克前往达戈巴','卢克独自驾机前往达戈巴寻找尤达。','','','雅汶战役后 3 年','published'),
('68000000-0000-4000-8007-000000000005','en','Luke seeks Yoda on Dagobah','Luke flies alone to Dagobah to find Yoda.','','','3 ABY','published'),
('68000000-0000-4000-8007-000000000006','zh-CN','尤达收卢克为徒','尤达起初拒绝,称他太急躁;在欧比旺的劝说下同意训练。','尤达拒绝的理由与二十三年前拒绝阿纳金时几乎相同——影片让同一套判断标准第二次面对同一个家族。','绝地的最后一位大师,教了最后一位学生。','雅汶战役后 3 年','published'),
('68000000-0000-4000-8007-000000000006','en','Yoda takes Luke as a student','Yoda refuses at first, calling him too impatient, and agrees only when Obi-Wan presses him.','His grounds for refusing are almost word for word what he said of Anakin twenty-three years earlier; the film runs the same standard against the same family twice.','The last Jedi master takes the last student.','3 ABY','published'),
('68000000-0000-4000-8007-000000000007','zh-CN','达戈巴的洞穴','卢克在洞中与幻象交手,斩下的头盔里是他自己的脸。','','影片提前把答案给了他,而他没有认出来。','雅汶战役后 3 年','published'),
('68000000-0000-4000-8007-000000000007','en','The cave on Dagobah','Luke fights a vision in the cave and finds his own face inside the severed helmet.','','The film hands him the answer early and he does not recognise it.','3 ABY','published'),
('68000000-0000-4000-8007-000000000008','zh-CN','云端之城的圈套','维达以汉与莱娅为饵,兰多在胁迫下配合布局。','','这次陷阱的目标不是同盟,是卢克一个人。','雅汶战役后 3 年','published'),
('68000000-0000-4000-8007-000000000008','en','The trap at Cloud City','Vader uses Han and Leia as bait, with Lando coerced into setting it.','','The trap is not aimed at the Alliance. It is aimed at one person.','3 ABY','published'),
('68000000-0000-4000-8007-000000000009','zh-CN','汉·索洛被冷冻','汉被封入碳凝块,交予波巴·费特带往贾巴处。','','','雅汶战役后 3 年','published'),
('68000000-0000-4000-8007-000000000009','en','Han Solo is frozen in carbonite','Han is sealed in carbonite and handed to Boba Fett for delivery to Jabba.','','','3 ABY','published'),
('68000000-0000-4000-8007-000000000010','zh-CN','卢克中断训练','卢克预见朋友受难,不顾尤达与欧比旺的劝阻离开达戈巴。','两位老师都告诉他这是陷阱,他仍然去了——影片让他重复了他父亲的错误,却在结局作出相反的选择。','同一个动作,两代人做出,结果不同。','雅汶战役后 3 年','published'),
('68000000-0000-4000-8007-000000000010','en','Luke leaves his training','Luke foresees his friends suffering and leaves Dagobah against both his teachers.','Both tell him it is a trap and he goes anyway; the film has him repeat his father’s mistake and then, at the end, make the opposite choice.','The same act, made by two generations, with different outcomes.','3 ABY','published'),
('68000000-0000-4000-8007-000000000011','zh-CN','维达告知卢克真相','决斗中卢克失去右手,维达告诉他自己就是他的父亲。','影片让这句话取代了杀招:维达要的不是杀死他,而是要他一起统治。卢克选择松手坠下。','欧比旺的隐瞒在此破产,绝地一方的正当性也随之动摇。','雅汶战役后 3 年','published'),
('68000000-0000-4000-8007-000000000011','en','Vader tells Luke the truth','Luke loses his right hand in the duel, and Vader tells him whose son he is.','The film puts that sentence where the killing blow would go: Vader does not want him dead, he wants him alongside. Luke lets go and falls.','Obi-Wan’s concealment collapses here, and the Jedi side’s claim to be straight with him collapses with it.','3 ABY','published'),
('68000000-0000-4000-8007-000000000012','zh-CN','兰多倒戈','兰多放走囚犯并协助救出卢克。','','','雅汶战役后 3 至 4 年','published'),
('68000000-0000-4000-8007-000000000012','en','Lando turns back','Lando frees the prisoners and helps get Luke out.','','','c. 3–4 ABY','published'),
-- era 08
('68000000-0000-4000-8008-000000000001','zh-CN','贾巴宫的营救','卢克一行分批潜入贾巴的宫殿,救出被冷冻的汉。','','卢克第一次以绝地身份行事,手段克制而有分寸。','雅汶战役后 4 年','published'),
('68000000-0000-4000-8008-000000000001','en','The rescue from Jabba’s palace','Luke’s group infiltrates Jabba’s palace in stages and recovers the frozen Han.','','Luke acts as a Jedi for the first time, and does it with restraint.','4 ABY','published'),
('68000000-0000-4000-8008-000000000002','zh-CN','贾巴之死','莱娅在驳船上勒死贾巴。','','','雅汶战役后 4 年','published'),
('68000000-0000-4000-8008-000000000002','en','The death of Jabba the Hutt','Leia kills Jabba aboard his barge.','','','4 ABY','published'),
('68000000-0000-4000-8008-000000000003','zh-CN','尤达在达戈巴离世','尤达确认维达即是卢克之父,随后离世。','','绝地武士团的最后一位大师去世,传承只剩卢克一人。','雅汶战役后 4 年','published'),
('68000000-0000-4000-8008-000000000003','en','Yoda dies on Dagobah','Yoda confirms that Vader is Luke’s father, and dies.','','The last master of the Jedi Order dies, and the succession is one person wide.','4 ABY','published'),
('68000000-0000-4000-8008-000000000004','zh-CN','欧比旺解释双胞胎','欧比旺的灵体承认隐瞒,并告知卢克他还有一个孪生妹妹。','影片让欧比旺为自己的措辞辩解,而卢克没有接受这套说法——师徒之间的裂痕没有被弥合。','血脉的另一半在此揭晓,而这也是皇帝日后用来威胁他的东西。','雅汶战役后 4 年','published'),
('68000000-0000-4000-8008-000000000004','en','Obi-Wan explains the twins','Obi-Wan’s spirit admits the concealment and tells Luke he has a twin sister.','The film lets Obi-Wan defend his phrasing and lets Luke decline to accept it; the fracture between them is not repaired.','The other half of the bloodline is revealed here, and it is what the Emperor later threatens him with.','4 ABY','published'),
('68000000-0000-4000-8008-000000000005','zh-CN','卢克告诉莱娅他们是兄妹','恩多登陆前,卢克向莱娅坦白身世,并前去投降。','影片让她说自己一直知道些什么——两人分开抚养二十三年,却在这一刻确认了同一件事。','家族的两半在最后一战之前合上。','雅汶战役后 4 年','published'),
('68000000-0000-4000-8008-000000000005','en','Luke tells Leia they are siblings','Before the Endor landing, Luke tells Leia what they are to each other, and then goes to surrender.','The film has her say she has always known something; twenty-three years apart, and they arrive at the same fact in the same minute.','The two halves of the family close before the last battle.','4 ABY','published'),
('68000000-0000-4000-8008-000000000006','zh-CN','舰队在苏卢斯特集结','同盟舰队在苏卢斯特集结,准备最后一战。','','','雅汶战役后 4 年','published'),
('68000000-0000-4000-8008-000000000006','en','The fleet gathers at Sullust','The Alliance fleet assembles at Sullust for the final operation.','','','4 ABY','published'),
('68000000-0000-4000-8008-000000000007','zh-CN','恩多地面战','义军小队在原住民协助下攻破护盾发生器。','','','雅汶战役后 4 年','published'),
('68000000-0000-4000-8008-000000000007','en','The ground battle on Endor','The rebel team, helped by the moon’s natives, takes the shield generator.','','','4 ABY','published'),
('68000000-0000-4000-8008-000000000008','zh-CN','卢克向父亲自首','卢克主动投降,并试图说服维达回头。','他放下武器走向父亲,理由是相信对方身上还有可以唤回的部分;影片让这份相信本身成为最后的武器。','绝地的胜利条件被重新定义为:不杀。','雅汶战役后 4 年','published'),
('68000000-0000-4000-8008-000000000008','en','Luke surrenders to his father','Luke gives himself up and tries to talk Vader back.','He puts down his weapon and walks to his father on the grounds that something in him can still be reached; the film makes that belief the final weapon.','The Jedi victory condition is redefined as: do not kill.','4 ABY','published'),
('68000000-0000-4000-8008-000000000009','zh-CN','王座厅决斗','皇帝以莱娅相激,卢克在盛怒中压制维达并斩其右手。','影片让卢克在赢的那一刻看见父亲断口处的机械——与自己右手同样的东西。','他看见自己正在变成什么,然后停下了。','雅汶战役后 4 年','published'),
('68000000-0000-4000-8008-000000000009','en','The throne room duel','The Emperor goads Luke with Leia, and in a rage Luke beats Vader down and takes his right hand.','The film lets Luke look at the machinery in his father’s severed wrist and recognise the same thing in his own.','He sees what he is turning into, and stops.','4 ABY','published'),
('68000000-0000-4000-8008-000000000010','zh-CN','卢克拒绝出手','卢克扔下光剑,拒绝杀死父亲,皇帝随即对他施以酷刑。','这是整部九部曲的转折:他既不投降也不动手,而是承担后果。','绝地的答案不是更强的力量,是不肯用它。','雅汶战役后 4 年','published'),
('68000000-0000-4000-8008-000000000010','en','Luke refuses to strike','Luke throws his weapon away and refuses to kill his father, and the Emperor turns on him.','This is the hinge of the whole saga: he neither surrenders nor strikes, and takes the consequence instead.','The Jedi answer is not greater power. It is declining to use it.','4 ABY','published'),
('68000000-0000-4000-8008-000000000011','zh-CN','阿纳金回头','维达在儿子将被杀死时出手,把皇帝掷入深井,自己伤重而死。','影片让他在临终时要求摘下面罩,用自己的眼睛看儿子一次——阿纳金·天行者是以这个身份死的。','救回他的不是力量,是有人始终不肯放手。','雅汶战役后 4 年','published'),
('68000000-0000-4000-8008-000000000011','en','Anakin turns back','With his son about to be killed, Vader takes hold of the Emperor and throws him down the shaft, and is mortally hurt doing it.','The film has him ask for the mask off so he can look at his son with his own eyes; it is as Anakin Skywalker that he dies.','What recovers him is not power. It is someone who would not let go.','4 ABY','published'),
('68000000-0000-4000-8008-000000000012','zh-CN','第二死星被摧毁','护盾解除后,兰多率舰队摧毁第二座战斗空间站,帝国瓦解。','','','雅汶战役后 4 至 5 年','published'),
('68000000-0000-4000-8008-000000000012','en','The second station is destroyed','With the shield down, Lando leads the strike that destroys the second battle station, and the Empire comes apart.','','','c. 4–5 ABY','published');

-- ============================================================
-- 3. EVENT LOCATIONS
-- ============================================================

INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id, l.id, w.role, w.position
FROM (VALUES
  ('luke-finds-leias-message','tatooine','primary',0),
  ('obi-wan-tells-luke-of-his-father','tatooine','primary',0),
  ('the-lars-farm-is-burned','tatooine','primary',0),
  ('hiring-the-falcon','tatooine','primary',0),
  ('alderaan-is-destroyed','alderaan','primary',0),
  ('alderaan-is-destroyed','death-star','origin',1),
  ('the-rescue-of-leia','death-star','primary',0),
  ('obi-wan-falls-to-vader','death-star','primary',0),
  ('the-plans-reach-yavin-4','yavin-4','primary',0),
  ('the-battle-of-yavin','yavin-4','primary',0),
  ('the-battle-of-yavin','death-star','front',1),
  ('the-trench-run','death-star','primary',0),
  ('tarkin-dies-with-the-station','death-star','primary',0),
  ('the-ceremony-on-yavin-4','yavin-4','primary',0),
  ('the-alliance-base-on-hoth','hoth','primary',0),
  ('obi-wan-appears-to-luke','hoth','primary',0),
  ('the-battle-of-hoth','hoth','primary',0),
  ('the-evacuation-of-echo-base','hoth','primary',0),
  ('luke-seeks-yoda-on-dagobah','dagobah','primary',0),
  ('yoda-takes-luke-as-a-student','dagobah','primary',0),
  ('the-cave-on-dagobah','dagobah','primary',0),
  ('the-trap-at-cloud-city','bespin','primary',0),
  ('han-solo-frozen-in-carbonite','bespin','primary',0),
  ('luke-leaves-his-training','dagobah','primary',0),
  ('vader-tells-luke-the-truth','bespin','primary',0),
  ('lando-turns-back','bespin','primary',0),
  ('the-rescue-from-jabbas-palace','tatooine','primary',0),
  ('jabba-the-hutt-dies','tatooine','primary',0),
  ('yoda-dies-on-dagobah','dagobah','primary',0),
  ('obi-wan-explains-the-twins','dagobah','primary',0),
  ('luke-tells-leia-they-are-siblings','endor','primary',0),
  ('the-fleet-gathers-at-sullust','sullust','primary',0),
  ('the-ground-battle-on-endor','endor','primary',0),
  ('luke-surrenders-to-his-father','endor','primary',0),
  ('the-throne-room-duel','death-star-ii','primary',0),
  ('luke-refuses-to-strike','death-star-ii','primary',0),
  ('anakin-turns-back','death-star-ii','primary',0),
  ('the-second-station-destroyed','death-star-ii','primary',0),
  ('the-second-station-destroyed','endor','front',1)
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
  ('luke-finds-leias-message','luke-skywalker','primary',0,true),
  ('luke-finds-leias-message','r2-d2','participant',1,false),
  ('luke-finds-leias-message','c-3po','participant',2,false),
  ('obi-wan-tells-luke-of-his-father','obi-wan-kenobi','primary',0,true),
  ('obi-wan-tells-luke-of-his-father','luke-skywalker','participant',1,false),
  ('the-lars-farm-is-burned','owen-lars','primary',0,true),
  ('the-lars-farm-is-burned','beru-whitesun-lars','participant',1,false),
  ('the-lars-farm-is-burned','luke-skywalker','participant',2,false),
  ('hiring-the-falcon','han-solo','primary',0,true),
  ('hiring-the-falcon','chewbacca','participant',1,false),
  ('hiring-the-falcon','luke-skywalker','participant',2,false),
  ('hiring-the-falcon','obi-wan-kenobi','participant',3,false),
  ('alderaan-is-destroyed','grand-moff-tarkin','primary',0,true),
  ('alderaan-is-destroyed','leia-organa','participant',1,false),
  ('alderaan-is-destroyed','anakin-skywalker','participant',2,false),
  ('the-rescue-of-leia','luke-skywalker','primary',0,true),
  ('the-rescue-of-leia','leia-organa','participant',1,false),
  ('the-rescue-of-leia','han-solo','participant',2,false),
  ('the-rescue-of-leia','chewbacca','participant',3,false),
  ('obi-wan-falls-to-vader','obi-wan-kenobi','primary',0,true),
  ('obi-wan-falls-to-vader','anakin-skywalker','participant',1,false),
  ('obi-wan-falls-to-vader','luke-skywalker','participant',2,false),
  ('the-plans-reach-yavin-4','leia-organa','primary',0,true),
  ('the-plans-reach-yavin-4','r2-d2','participant',1,false),
  ('the-battle-of-yavin','luke-skywalker','primary',0,true),
  ('the-battle-of-yavin','wedge-antilles','participant',1,false),
  ('the-battle-of-yavin','leia-organa','participant',2,false),
  ('the-trench-run','luke-skywalker','primary',0,true),
  ('the-trench-run','han-solo','participant',1,false),
  ('the-trench-run','anakin-skywalker','participant',2,false),
  ('the-trench-run','r2-d2','participant',3,false),
  ('tarkin-dies-with-the-station','grand-moff-tarkin','primary',0,true),
  ('the-ceremony-on-yavin-4','leia-organa','primary',0,true),
  ('the-ceremony-on-yavin-4','luke-skywalker','participant',1,false),
  ('the-ceremony-on-yavin-4','han-solo','participant',2,false),
  ('the-ceremony-on-yavin-4','chewbacca','participant',3,false),
  ('the-alliance-base-on-hoth','leia-organa','primary',0,true),
  ('the-alliance-base-on-hoth','han-solo','participant',1,false),
  ('obi-wan-appears-to-luke','obi-wan-kenobi','primary',0,true),
  ('obi-wan-appears-to-luke','luke-skywalker','participant',1,false),
  ('the-battle-of-hoth','anakin-skywalker','primary',0,true),
  ('the-battle-of-hoth','luke-skywalker','participant',1,false),
  ('the-battle-of-hoth','wedge-antilles','participant',2,false),
  ('the-evacuation-of-echo-base','leia-organa','primary',0,true),
  ('the-evacuation-of-echo-base','han-solo','participant',1,false),
  ('the-evacuation-of-echo-base','chewbacca','participant',2,false),
  ('the-evacuation-of-echo-base','c-3po','participant',3,false),
  ('luke-seeks-yoda-on-dagobah','luke-skywalker','primary',0,true),
  ('luke-seeks-yoda-on-dagobah','r2-d2','participant',1,false),
  ('yoda-takes-luke-as-a-student','yoda','primary',0,true),
  ('yoda-takes-luke-as-a-student','luke-skywalker','participant',1,false),
  ('yoda-takes-luke-as-a-student','obi-wan-kenobi','participant',2,false),
  ('the-cave-on-dagobah','luke-skywalker','primary',0,true),
  ('the-cave-on-dagobah','anakin-skywalker','participant',1,false),
  ('the-trap-at-cloud-city','anakin-skywalker','primary',0,true),
  ('the-trap-at-cloud-city','lando-calrissian','participant',1,false),
  ('the-trap-at-cloud-city','leia-organa','participant',2,false),
  ('the-trap-at-cloud-city','han-solo','participant',3,false),
  ('han-solo-frozen-in-carbonite','han-solo','primary',0,true),
  ('han-solo-frozen-in-carbonite','boba-fett','participant',1,false),
  ('han-solo-frozen-in-carbonite','leia-organa','participant',2,false),
  ('han-solo-frozen-in-carbonite','anakin-skywalker','participant',3,false),
  ('luke-leaves-his-training','luke-skywalker','primary',0,true),
  ('luke-leaves-his-training','yoda','participant',1,false),
  ('luke-leaves-his-training','obi-wan-kenobi','participant',2,false),
  ('vader-tells-luke-the-truth','anakin-skywalker','primary',0,true),
  ('vader-tells-luke-the-truth','luke-skywalker','participant',1,false),
  ('lando-turns-back','lando-calrissian','primary',0,true),
  ('lando-turns-back','leia-organa','participant',1,false),
  ('lando-turns-back','chewbacca','participant',2,false),
  ('lando-turns-back','luke-skywalker','participant',3,false),
  ('the-rescue-from-jabbas-palace','luke-skywalker','primary',0,true),
  ('the-rescue-from-jabbas-palace','leia-organa','participant',1,false),
  ('the-rescue-from-jabbas-palace','han-solo','participant',2,false),
  ('the-rescue-from-jabbas-palace','lando-calrissian','participant',3,false),
  ('the-rescue-from-jabbas-palace','jabba-the-hutt','participant',4,false),
  ('the-rescue-from-jabbas-palace','r2-d2','participant',5,false),
  ('jabba-the-hutt-dies','leia-organa','primary',0,true),
  ('jabba-the-hutt-dies','jabba-the-hutt','participant',1,false),
  ('jabba-the-hutt-dies','boba-fett','participant',2,false),
  ('yoda-dies-on-dagobah','yoda','primary',0,true),
  ('yoda-dies-on-dagobah','luke-skywalker','participant',1,false),
  ('obi-wan-explains-the-twins','obi-wan-kenobi','primary',0,true),
  ('obi-wan-explains-the-twins','luke-skywalker','participant',1,false),
  ('luke-tells-leia-they-are-siblings','luke-skywalker','primary',0,true),
  ('luke-tells-leia-they-are-siblings','leia-organa','participant',1,false),
  ('the-fleet-gathers-at-sullust','admiral-ackbar','primary',0,true),
  ('the-fleet-gathers-at-sullust','mon-mothma','participant',1,false),
  ('the-fleet-gathers-at-sullust','lando-calrissian','participant',2,false),
  ('the-ground-battle-on-endor','han-solo','primary',0,true),
  ('the-ground-battle-on-endor','leia-organa','participant',1,false),
  ('the-ground-battle-on-endor','chewbacca','participant',2,false),
  ('the-ground-battle-on-endor','wicket','participant',3,false),
  ('the-ground-battle-on-endor','c-3po','participant',4,false),
  ('luke-surrenders-to-his-father','luke-skywalker','primary',0,true),
  ('luke-surrenders-to-his-father','anakin-skywalker','participant',1,false),
  ('the-throne-room-duel','luke-skywalker','primary',0,true),
  ('the-throne-room-duel','anakin-skywalker','participant',1,false),
  ('the-throne-room-duel','sheev-palpatine','participant',2,false),
  ('luke-refuses-to-strike','luke-skywalker','primary',0,true),
  ('luke-refuses-to-strike','sheev-palpatine','participant',1,false),
  ('luke-refuses-to-strike','anakin-skywalker','participant',2,false),
  ('anakin-turns-back','anakin-skywalker','primary',0,true),
  ('anakin-turns-back','sheev-palpatine','participant',1,false),
  ('anakin-turns-back','luke-skywalker','participant',2,false),
  ('the-second-station-destroyed','lando-calrissian','primary',0,true),
  ('the-second-station-destroyed','admiral-ackbar','participant',1,false),
  ('the-second-station-destroyed','wedge-antilles','participant',2,false)
) AS w(event_slug, character_slug, role, participant_order, is_primary)
JOIN events e ON e.work_id='10000000-0000-4000-8000-000000000008' AND e.slug=w.event_slug
JOIN characters c ON c.work_id='10000000-0000-4000-8000-000000000008' AND c.slug=w.character_slug
ON CONFLICT DO NOTHING;

-- ============================================================
-- 5. EVENT SOURCES
-- ============================================================

INSERT INTO event_sources(event_id,source_id)
SELECT e.id, s.id FROM events e
JOIN sources s ON s.work_id='10000000-0000-4000-8000-000000000008' AND s.title='Episode IV: A New Hope (1977 film)'
WHERE e.id::text LIKE '68000000-0000-4000-8006%' ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id, s.id FROM events e
JOIN sources s ON s.work_id='10000000-0000-4000-8000-000000000008' AND s.title='Episode V: The Empire Strikes Back (1980 film)'
WHERE e.id::text LIKE '68000000-0000-4000-8007%' ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id, s.id FROM events e
JOIN sources s ON s.work_id='10000000-0000-4000-8000-000000000008' AND s.title='Episode VI: Return of the Jedi (1983 film)'
WHERE e.id::text LIKE '68000000-0000-4000-8008%' ON CONFLICT DO NOTHING;

-- ============================================================
-- 6. RELATIONS — the Skywalker spine and the Jedi succession
-- ============================================================

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT w.id::uuid, '10000000-0000-4000-8000-000000000008', f.id, t.id, w.relation_type, w.direction::relationship_direction, w.sentiment::relationship_sentiment, w.strength, w.status::relationship_status, NULL, NULL
FROM (VALUES
  ('78000000-0000-4000-8006-000000000001','luke-skywalker','han-solo','ally','bidirectional','positive',5,'active'),
  ('78000000-0000-4000-8006-000000000002','han-solo','leia-organa','romantic','bidirectional','positive',5,'active'),
  ('78000000-0000-4000-8006-000000000003','han-solo','chewbacca','ally','bidirectional','positive',5,'active'),
  ('78000000-0000-4000-8006-000000000004','luke-skywalker','r2-d2','ally','bidirectional','positive',5,'active'),
  ('78000000-0000-4000-8006-000000000005','grand-moff-tarkin','leia-organa','adversary','source_to_target','negative',5,'ended'),
  ('78000000-0000-4000-8006-000000000006','luke-skywalker','anakin-skywalker','adversary','bidirectional','mixed',5,'changed'),
  ('78000000-0000-4000-8007-000000000001','yoda','luke-skywalker','mentor','source_to_target','positive',5,'ended'),
  ('78000000-0000-4000-8007-000000000002','lando-calrissian','han-solo','ally','bidirectional','mixed',4,'changed'),
  ('78000000-0000-4000-8007-000000000003','boba-fett','han-solo','adversary','source_to_target','negative',4,'ended'),
  ('78000000-0000-4000-8007-000000000004','anakin-skywalker','lando-calrissian','liege','source_to_target','negative',3,'ended'),
  ('78000000-0000-4000-8008-000000000001','jabba-the-hutt','han-solo','adversary','source_to_target','negative',4,'ended'),
  ('78000000-0000-4000-8008-000000000002','sheev-palpatine','luke-skywalker','adversary','bidirectional','negative',5,'ended'),
  ('78000000-0000-4000-8008-000000000003','leia-organa','chewbacca','ally','bidirectional','positive',4,'active'),
  ('78000000-0000-4000-8008-000000000004','wicket','leia-organa','ally','bidirectional','positive',3,'ended')
) AS w(id, from_slug, to_slug, relation_type, direction, sentiment, strength, status)
JOIN characters f ON f.work_id='10000000-0000-4000-8000-000000000008' AND f.slug=w.from_slug
JOIN characters t ON t.work_id='10000000-0000-4000-8000-000000000008' AND t.slug=w.to_slug
ON CONFLICT DO NOTHING;

INSERT INTO relation_translations(relation_id,locale,label,summary,status) VALUES
('78000000-0000-4000-8006-000000000001','zh-CN','生死之交(卢克↔汉)','从一笔运费开始,到彼此挡枪。','published'),
('78000000-0000-4000-8006-000000000001','en','Sworn friends (Luke ↔ Han)','It starts as a fare and ends with each taking fire for the other.','published'),
('78000000-0000-4000-8006-000000000002','zh-CN','伴侣(汉↔莱娅)','走私者与公主;他们的儿子后来成了第一秩序的统帅。','published'),
('78000000-0000-4000-8006-000000000002','en','Partners (Han ↔ Leia)','A smuggler and a princess, whose son commands the First Order.','published'),
('78000000-0000-4000-8006-000000000003','zh-CN','搭档(汉↔丘巴卡)','千年隼的正副驾驶,誓约一直到最后。','published'),
('78000000-0000-4000-8006-000000000003','en','Pilot and co-pilot (Han ↔ Chewbacca)','The Falcon’s crew, and a debt kept to the end.','published'),
('78000000-0000-4000-8006-000000000004','zh-CN','搭档(卢克↔R2-D2)','从第一次起飞到最后一次;R2 见证了父与子两代。','published'),
('78000000-0000-4000-8006-000000000004','en','Pilot and astromech (Luke ↔ R2-D2)','From his first flight to his last; R2 sees both father and son through.','published'),
('78000000-0000-4000-8006-000000000005','zh-CN','审讯者与俘虏(塔金→莱娅)','为逼供而毁掉了她的母星。','published'),
('78000000-0000-4000-8006-000000000005','en','Interrogator and prisoner (Tarkin → Leia)','He destroys her homeworld to make her talk.','published'),
('78000000-0000-4000-8006-000000000006','zh-CN','父子对阵(卢克↔维达)','三次交手:第一次逃走,第二次断手,第三次谁也没有杀死谁。','published'),
('78000000-0000-4000-8006-000000000006','en','Father against son (Luke ↔ Vader)','Three meetings: he runs from the first, loses a hand in the second, and in the third neither kills the other.','published'),
('78000000-0000-4000-8007-000000000001','zh-CN','师徒(尤达→卢克)','绝地武士团最后的大师与最后的学生。','published'),
('78000000-0000-4000-8007-000000000001','en','Master and student (Yoda → Luke)','The last master of the order and its last student.','published'),
('78000000-0000-4000-8007-000000000002','zh-CN','旧友与出卖(兰多↔汉)','一次被胁迫的出卖,和此后一辈子的补偿。','published'),
('78000000-0000-4000-8007-000000000002','en','Old friends, betrayed (Lando ↔ Han)','One coerced betrayal, and a lifetime spent making it up.','published'),
('78000000-0000-4000-8007-000000000003','zh-CN','赏金猎人与赏金(波巴→汉)','父债子偿之外的一笔生意。','published'),
('78000000-0000-4000-8007-000000000003','en','Hunter and bounty (Boba → Han)','A piece of business, separate from the debt he inherited.','published'),
('78000000-0000-4000-8007-000000000004','zh-CN','胁迫(维达→兰多)','以整座城的性命作价,买一次合作。','published'),
('78000000-0000-4000-8007-000000000004','en','Coercion (Vader → Lando)','A whole city’s safety as the price of one act of cooperation.','published'),
('78000000-0000-4000-8008-000000000001','zh-CN','债主与欠债人(贾巴→汉)','把他挂在墙上示众的那笔账。','published'),
('78000000-0000-4000-8008-000000000001','en','Creditor and debtor (Jabba → Han)','The debt that puts him on a wall as an example.','published'),
('78000000-0000-4000-8008-000000000002','zh-CN','皇帝与最后的绝地(皇帝↔卢克)','他要的不是杀死卢克,是让卢克动手。','published'),
('78000000-0000-4000-8008-000000000002','en','Emperor and the last Jedi (Palpatine ↔ Luke)','What he wants is not Luke dead but Luke striking.','published'),
('78000000-0000-4000-8008-000000000003','zh-CN','战友(莱娅↔丘巴卡)','汉死后,他们是彼此仅存的旧人。','published'),
('78000000-0000-4000-8008-000000000003','en','Comrades (Leia ↔ Chewbacca)','After Han, they are what each other has left.','published'),
('78000000-0000-4000-8008-000000000004','zh-CN','向导与来客(维克特↔莱娅)','恩多地面战的胜负,系在一次本地人的接纳上。','published'),
('78000000-0000-4000-8008-000000000004','en','Guide and guest (Wicket ↔ Leia)','The ground battle turns on whether the locals take them in.','published')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 7. GROUP MEMBERSHIP
-- ============================================================

INSERT INTO character_group_members(group_id,character_id,membership_role)
SELECT g.id, c.id, w.membership_role
FROM (VALUES
  ('smugglers-and-outlaws','jabba-the-hutt','crime lord'),
  ('rebel-alliance','wicket','local ally at Endor'),
  ('jedi-order','anakin-skywalker','returned at the end')
) AS w(group_slug, character_slug, membership_role)
JOIN character_groups g ON g.work_id='10000000-0000-4000-8000-000000000008' AND g.slug=w.group_slug
JOIN characters c ON c.work_id='10000000-0000-4000-8000-000000000008' AND c.slug=w.character_slug
ON CONFLICT DO NOTHING;

COMMIT;
