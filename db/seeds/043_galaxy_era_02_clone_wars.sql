BEGIN;

-- Era 02 · clone-wars (22-19 BBY, database years -23..-19)
--
-- Covers Episode II and the war years the animated series fills in. Sequence
-- band 2001-2999, step 2. Prose is this project's own throughout.

-- ============================================================
-- 1. CHARACTERS
-- ============================================================

INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('48000000-0000-4000-8002-000000000001','10000000-0000-4000-8000-000000000008','zam-wesell',201,'female','adult','antagonist','fictional',NULL,-23,'bounty_hunter',2),
('48000000-0000-4000-8002-000000000002','10000000-0000-4000-8000-000000000008','cliegg-lars',202,'male','elder','supporting','fictional',NULL,-22,'person',2),
('48000000-0000-4000-8002-000000000003','10000000-0000-4000-8000-000000000008','owen-lars',203,'male','adult','supporting','fictional',-38,-1,'person',3),
('48000000-0000-4000-8002-000000000004','10000000-0000-4000-8000-000000000008','beru-whitesun-lars',204,'female','adult','supporting','fictional',-38,-1,'person',3),
('48000000-0000-4000-8002-000000000005','10000000-0000-4000-8000-000000000008','poggle-the-lesser',205,'male','adult','antagonist','fictional',NULL,-19,'ruler',2),
('48000000-0000-4000-8002-000000000006','10000000-0000-4000-8000-000000000008','commander-cody',206,'male','adult','supporting','fictional',-33,NULL,'soldier',3),
('48000000-0000-4000-8002-000000000007','10000000-0000-4000-8000-000000000008','captain-rex',207,'male','adult','supporting','fictional',-33,NULL,'soldier',3),
('48000000-0000-4000-8002-000000000008','10000000-0000-4000-8000-000000000008','lama-su',208,'male','adult','supporting','fictional',NULL,NULL,'ruler',2)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,aliases,detail,motivation,status) VALUES
('48000000-0000-4000-8002-000000000001','zh-CN','赞·韦塞尔','变形人赏金猎人,受雇刺杀帕德梅。','{}','她在供出雇主的瞬间被灭口——影片用这一枪告诉观众,线索是被有人主动掐断的。','拿钱办事。','published'),
('48000000-0000-4000-8002-000000000001','en','Zam Wesell','A shape-shifting bounty hunter hired to kill Padmé.','{}','She is silenced in the instant she would have named her employer; the film uses that dart to show the trail is being cut deliberately.','The contract, and the fee.','published'),
('48000000-0000-4000-8002-000000000002','zh-CN','克里格·拉尔斯','塔图因的农场主,施密的丈夫。','{}','','把妻子从沙民手里带回来——他没能做到。','published'),
('48000000-0000-4000-8002-000000000002','en','Cliegg Lars','A Tatooine moisture farmer and Shmi’s husband.','{}','','To bring his wife back from the Tusken camp. He does not manage it.','published'),
('48000000-0000-4000-8002-000000000003','zh-CN','欧文·拉尔斯','塔图因农场主,阿纳金的继兄;日后抚养卢克长大。','{}','影片让他从头到尾拒绝冒险,而正是这种拒绝把卢克安全地藏了十九年。','守住农场,别惹麻烦。','published'),
('48000000-0000-4000-8002-000000000003','en','Owen Lars','A Tatooine farmer and Anakin’s stepbrother, who will raise Luke.','{}','The films have him refuse adventure at every turn, and that refusal is what keeps Luke hidden for nineteen years.','Keep the farm. Stay out of it.','published'),
('48000000-0000-4000-8002-000000000004','zh-CN','贝露·惠特森·拉尔斯','欧文的妻子,卢克的养母。','{}','','给孩子一个不必打仗的童年。','published'),
('48000000-0000-4000-8002-000000000004','en','Beru Whitesun Lars','Owen’s wife and Luke’s foster mother.','{}','','To give the boy a childhood that is not a war.','published'),
('48000000-0000-4000-8002-000000000005','zh-CN','波格·尊者','吉奥诺西斯的执政官,机器人军工的承造者。','{}','','把订单交出去,并保住自己的位置。','published'),
('48000000-0000-4000-8002-000000000005','en','Poggle the Lesser','Archduke of Geonosis, whose foundries build the droid army.','{}','','Deliver the order and keep his seat.','published'),
('48000000-0000-4000-8002-000000000006','zh-CN','科迪指挥官','克隆人军官,长期与欧比旺搭档。','{}','影片让这段战友情持续三年,然后用一道命令一次性废掉——这正是 66 号令的残忍之处。','执行命令。','published'),
('48000000-0000-4000-8002-000000000006','en','Commander Cody','A clone officer who serves alongside Obi-Wan for most of the war.','{}','The films build three years of trust and then spend it in a single order; that is what makes Order 66 cruel rather than merely fatal.','To carry out orders.','published'),
('48000000-0000-4000-8002-000000000007','zh-CN','雷克斯上尉','克隆人军官,阿纳金部队的指挥官。','{}','','对身边的人负责,而不只是对命令负责。','published'),
('48000000-0000-4000-8002-000000000007','en','Captain Rex','A clone officer commanding under Anakin.','{}','','Answerable to the people beside him, not only to the order.','published'),
('48000000-0000-4000-8002-000000000008','zh-CN','拉玛·苏','卡米诺的总理,克隆人生产的主事者。','{}','','按合同交付,不问订货人是谁。','published'),
('48000000-0000-4000-8002-000000000008','en','Lama Su','Prime Minister of Kamino, who oversees the production of the clones.','{}','','Deliver on the contract without asking who signed it.','published')
ON CONFLICT DO NOTHING;

UPDATE characters SET birth_place_id=(SELECT id FROM locations WHERE work_id='10000000-0000-4000-8000-000000000008' AND slug='kamino') WHERE id IN ('48000000-0000-4000-8002-000000000006','48000000-0000-4000-8002-000000000007');
UPDATE characters SET death_place_id=(SELECT id FROM locations WHERE work_id='10000000-0000-4000-8000-000000000008' AND slug='tatooine') WHERE id IN ('48000000-0000-4000-8002-000000000002','48000000-0000-4000-8002-000000000003','48000000-0000-4000-8002-000000000004');
UPDATE characters SET death_place_id=(SELECT id FROM locations WHERE work_id='10000000-0000-4000-8000-000000000008' AND slug='geonosis') WHERE id='48000000-0000-4000-8002-000000000005';

-- ============================================================
-- 2. EVENTS
-- ============================================================

INSERT INTO events(id,work_id,slug,start_date,end_date,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,start_month,start_day,confidence,chapter_id) VALUES
('68000000-0000-4000-8002-000000000001','10000000-0000-4000-8000-000000000008','the-separatist-crisis',NULL,NULL,2001,'fictional_narrative','political','fictional_calendar','fictional',-23,-23,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000002','10000000-0000-4000-8000-000000000008','assassination-attempt-on-amidala',NULL,NULL,2003,'fictional_narrative','betrayal','fictional_calendar','fictional',-23,-23,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000003','10000000-0000-4000-8000-000000000008','the-assassin-is-silenced',NULL,NULL,2005,'fictional_narrative','death','fictional_calendar','fictional',-23,-23,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000004','10000000-0000-4000-8000-000000000008','anakin-assigned-to-guard-padme',NULL,NULL,2007,'fictional_narrative','political','fictional_calendar','fictional',-23,-23,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000005','10000000-0000-4000-8000-000000000008','the-missing-archive-entry',NULL,NULL,2009,'fictional_narrative','discovery','fictional_calendar','fictional',-23,-23,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000006','10000000-0000-4000-8000-000000000008','the-clone-army-discovered',NULL,NULL,2011,'fictional_narrative','discovery','fictional_calendar','fictional',-23,-23,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000007','10000000-0000-4000-8000-000000000008','hiding-on-naboo',NULL,NULL,2013,'fictional_narrative','journey','fictional_calendar','fictional',-23,-23,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000008','10000000-0000-4000-8000-000000000008','anakin-dreams-of-his-mother',NULL,NULL,2015,'legendary_or_mythic','discovery','fictional_calendar','fictional',-23,-22,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000009','10000000-0000-4000-8000-000000000008','return-to-tatooine-for-shmi',NULL,NULL,2017,'fictional_narrative','journey','fictional_calendar','fictional',-22,-22,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000010','10000000-0000-4000-8000-000000000008','shmi-skywalker-dies',NULL,NULL,2019,'fictional_narrative','death','fictional_calendar','fictional',-22,-22,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000011','10000000-0000-4000-8000-000000000008','the-tusken-camp',NULL,NULL,2021,'fictional_narrative','battle','fictional_calendar','fictional',-22,-22,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000012','10000000-0000-4000-8000-000000000008','obi-wan-captured-on-geonosis',NULL,NULL,2023,'fictional_narrative','imprisonment','fictional_calendar','fictional',-22,-22,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000013','10000000-0000-4000-8000-000000000008','emergency-powers-granted',NULL,NULL,2025,'fictional_narrative','political','fictional_calendar','fictional',-22,-22,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000014','10000000-0000-4000-8000-000000000008','the-arena-on-geonosis',NULL,NULL,2027,'fictional_narrative','trial','fictional_calendar','fictional',-22,-22,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000015','10000000-0000-4000-8000-000000000008','jango-fett-killed',NULL,NULL,2029,'fictional_narrative','death','fictional_calendar','fictional',-22,-22,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000016','10000000-0000-4000-8000-000000000008','first-battle-of-geonosis',NULL,NULL,2031,'fictional_narrative','battle','fictional_calendar','fictional',-22,-22,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000017','10000000-0000-4000-8000-000000000008','dooku-duels-yoda',NULL,NULL,2033,'fictional_narrative','battle','fictional_calendar','fictional',-22,-22,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000018','10000000-0000-4000-8000-000000000008','anakin-and-padme-marry',NULL,NULL,2035,'fictional_narrative','marriage','fictional_calendar','fictional',-22,-22,NULL,NULL,'high','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000019','10000000-0000-4000-8000-000000000008','the-war-spreads',NULL,NULL,2037,'fictional_with_historical_context','battle','fictional_calendar','fictional',-22,-19,NULL,NULL,'medium','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000020','10000000-0000-4000-8000-000000000008','ahsoka-assigned-to-anakin',NULL,NULL,2039,'fictional_narrative','meeting','fictional_calendar','fictional',-22,-21,NULL,NULL,'medium','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000021','10000000-0000-4000-8000-000000000008','ahsoka-leaves-the-jedi-order',NULL,NULL,2041,'fictional_narrative','betrayal','fictional_calendar','fictional',-20,-20,NULL,NULL,'medium','88000000-0000-4000-8002-000000000001'),
('68000000-0000-4000-8002-000000000022','10000000-0000-4000-8000-000000000008','grievous-takes-command',NULL,NULL,2043,'fictional_narrative','political','fictional_calendar','fictional',-21,-19,NULL,NULL,'medium','88000000-0000-4000-8002-000000000001');

INSERT INTO event_translations(event_id,locale,title,summary,detail,significance,time_label,status) VALUES
('68000000-0000-4000-8002-000000000001','zh-CN','分离主义危机','数千个星系宣布脱离共和国,议会就是否组建军队争执不下。','影片让脱离的一方由前绝地领衔,而拥护共和国的一方正在讨论要不要武装自己——两边都被同一个人拿在手里。','战争尚未开打,双方的领导人已经属于同一条指挥链。','雅汶战役前 23 年','published'),
('68000000-0000-4000-8002-000000000001','en','The Separatist crisis','Thousands of systems announce their departure from the Republic, and the senate deadlocks over whether to raise an army.','The film gives the seceding side a former Jedi to lead it while the loyal side argues about arming itself; both are being held by the same hand.','Before the war starts, the leaders of both sides already answer to one chain of command.','23 BBY','published'),
('68000000-0000-4000-8002-000000000002','zh-CN','对阿米达拉的刺杀未遂','帕德梅返回科洛桑投票途中两度遇刺,替身身亡。','影片让刺杀发生在她准备投票反对建军的当口——恐惧本身就是推动议案的手段。','恐惧被制造出来,用以推动一项本来通不过的议案。','雅汶战役前 23 年','published'),
('68000000-0000-4000-8002-000000000002','en','The attempt on Amidala’s life','Padmé survives two attempts on her life on her way to vote in the senate; a decoy does not.','The film times the attacks to the vote she intends to cast against a standing army: the fear is itself the instrument.','Fear is manufactured to move a measure that could not otherwise pass.','23 BBY','published'),
('68000000-0000-4000-8002-000000000003','zh-CN','刺客被灭口','赞·韦塞尔在供出雇主之前被一枚飞镖击杀。','两名绝地追到她,而她在开口的瞬间中镖——线索被主动掐断,只留下那枚镖。','唯一的线索是凶器本身,追查这枚飞镖把欧比旺带到了卡米诺。','雅汶战役前 23 年','published'),
('68000000-0000-4000-8002-000000000003','en','The assassin is silenced','Zam Wesell is killed by a dart before she can name who hired her.','Two Jedi run her down and she is hit in the instant she begins to speak; the trail is cut on purpose, and only the weapon is left.','The one remaining lead is the murder weapon, and following that dart takes Obi-Wan to Kamino.','23 BBY','published'),
('68000000-0000-4000-8002-000000000004','zh-CN','阿纳金受命护送帕德梅','绝地委员会派阿纳金单独护送帕德梅回纳布避险。','影片把一个被禁止有牵挂的人,长时间单独放在他唯一牵挂的人身边——这是制度自己安排的。','禁令与安排相互矛盾,后果由个人承担。','雅汶战役前 23 年','published'),
('68000000-0000-4000-8002-000000000004','en','Anakin is assigned to guard Padmé','The council sends Anakin alone to escort Padmé back to Naboo and keep her out of reach.','The film puts a man forbidden attachment alone, for weeks, beside the one person he is attached to — and the institution arranges it.','The prohibition and the assignment contradict each other, and the individual carries the cost.','23 BBY','published'),
('68000000-0000-4000-8002-000000000005','zh-CN','档案库里被抹去的条目','绝地档案库中查不到卡米诺,而引力数据显示那里有一颗行星。','影片让欧比旺发现记录被人删过,而档案管理员坚称档案不会出错——机构对自身被渗透毫无察觉。','有人能改绝地的档案,这件事比档案里少了什么更严重。','雅汶战役前 23 年','published'),
('68000000-0000-4000-8002-000000000005','en','The erased archive entry','Kamino cannot be found in the Jedi archives, though the gravity readings say a planet is there.','Obi-Wan finds the record deleted while the archivist insists the archive cannot be wrong; the institution cannot see that it has been reached into.','That someone can edit the Jedi archive matters more than what was taken out of it.','23 BBY','published'),
('68000000-0000-4000-8002-000000000006','zh-CN','克隆人大军被发现','欧比旺在卡米诺发现一支已训练十年、为共和国订购的克隆人军队。','订购者是一名早已死去的绝地大师,而无人查证过这份订单——影片让这支军队等在那里,恰好等到需要它的那一天。','共和国即将「获得」一支它从未决定组建的军队。','雅汶战役前 23 年','published'),
('68000000-0000-4000-8002-000000000006','en','The clone army is discovered','On Kamino, Obi-Wan finds an army ten years in the growing, ordered for the Republic.','The order was placed by a Jedi master long dead and never verified by anyone; the film has the army waiting exactly until the day it is needed.','The Republic is about to acquire an army it never decided to raise.','23 BBY','published'),
('68000000-0000-4000-8002-000000000007','zh-CN','在纳布避险','阿纳金与帕德梅在纳布湖区躲避追杀,关系越过了他的戒律。','影片把这段安静的日子放在开战之前,好让后面的每一次失控都有一个具体的对象。','此后阿纳金要保护的不再是抽象的和平,而是一个人。','雅汶战役前 23 年','published'),
('68000000-0000-4000-8002-000000000007','en','Hiding on Naboo','Anakin and Padmé shelter in the Naboo lake country, and the distance his order requires does not hold.','The film places these quiet days before the war so that everything he later loses control over has a specific object.','From here on what Anakin defends is not an abstract peace but one person.','23 BBY','published'),
('68000000-0000-4000-8002-000000000008','zh-CN','阿纳金梦见母亲','阿纳金连夜梦见母亲受苦,决意返回塔图因。','影片让预感成真,从而确立了一条规则:他看见的未来会发生——这条规则日后被人拿来对付他。','梦是准的。这一点被记住了,也被利用了。','雅汶战役前 23 至 22 年','published'),
('68000000-0000-4000-8002-000000000008','en','Anakin dreams of his mother','Night after night Anakin dreams his mother is suffering, and resolves to go back to Tatooine.','The film lets the premonition be true, which establishes a rule — what he foresees happens — and that rule is later turned against him.','The dreams are accurate. It is noticed, and it is used.','c. 23–22 BBY','published'),
('68000000-0000-4000-8002-000000000009','zh-CN','为寻母返回塔图因','阿纳金带帕德梅回到塔图因,得知母亲已被沙民掳走一个月。','继父克里格在寻找中失去一条腿,已经放弃;阿纳金独自骑出去。','他回来晚了十年,又晚了一个月。','雅汶战役前 22 年','published'),
('68000000-0000-4000-8002-000000000009','en','Return to Tatooine for Shmi','Anakin brings Padmé to Tatooine and learns his mother was taken by Tusken raiders a month before.','His stepfather lost a leg searching and has given up; Anakin rides out alone.','He is ten years late, and then a further month late.','22 BBY','published'),
('68000000-0000-4000-8002-000000000010','zh-CN','施密·天行者之死','阿纳金找到母亲时她已濒死,在他怀中断气。','这是影片给他的第一次「预见到却救不了」——正是这一经历日后被用来许诺他可以救另一个人。','他此后的全部恐惧,都有了这个具体的形状。','雅汶战役前 22 年','published'),
('68000000-0000-4000-8002-000000000010','en','The death of Shmi Skywalker','Anakin finds his mother barely alive, and she dies in his arms.','This is the film’s first instance of foreseeing and failing to prevent, and it is the experience later used to promise him he can prevent the next one.','Every fear he carries afterwards now has this specific shape.','22 BBY','published'),
('68000000-0000-4000-8002-000000000011','zh-CN','沙民营地','阿纳金在盛怒中屠灭了整个沙民营地。','影片让他自己把这件事说出口,并把它藏起来——第一次越界没有任何后果,于是有了第二次。','越界没被追究,这本身就是纵容。','雅汶战役前 22 年','published'),
('68000000-0000-4000-8002-000000000011','en','The Tusken camp','In a rage, Anakin kills everyone in the raider camp.','The film has him say it aloud once and then bury it; the first line he crosses costs him nothing, which is why there is a second.','Crossing the line goes unexamined, and that is its own kind of permission.','22 BBY','published'),
('68000000-0000-4000-8002-000000000012','zh-CN','欧比旺在吉奥诺西斯被俘','欧比旺追踪詹戈至吉奥诺西斯,目睹分离主义会议,发出警报后被俘。','他传回的影像同时暴露了两件事:一支机器人军队,和一份把杜库与贸易联盟绑在一起的协议。','战争的证据是被一名侦察者用被俘换来的。','雅汶战役前 22 年','published'),
('68000000-0000-4000-8002-000000000012','en','Obi-Wan is captured on Geonosis','Tracking Jango to Geonosis, Obi-Wan sees the Separatist council meet, transmits a warning, and is taken.','What he sends back exposes two things at once: a droid army, and an agreement binding Dooku to the Trade Federation.','The evidence of the coming war is bought by a scout trading his own capture for it.','22 BBY','published'),
('68000000-0000-4000-8002-000000000013','zh-CN','紧急权力被授予','议会在加·加·宾克斯的动议下,把紧急权力交给最高议长。','提出动议的是纳布的代表——影片让被害最深的一方再次亲手交出制度的钥匙。','共和国不是被推翻的,是被投票交出去的。','雅汶战役前 22 年','published'),
('68000000-0000-4000-8002-000000000013','en','Emergency powers are granted','On a motion from Jar Jar Binks, the senate hands emergency powers to the Chancellor.','The motion comes from Naboo’s own representative; the film has the most injured party hand over the keys a second time.','The Republic is not overthrown. It is voted away.','22 BBY','published'),
('68000000-0000-4000-8002-000000000014','zh-CN','吉奥诺西斯的角斗场','欧比旺、阿纳金与帕德梅被判处死刑,在角斗场中被野兽围攻。','三人自行脱困之际,绝地部队从看台上现身——影片用一场公开处决开启了一场全面战争。','战争的第一枪是在一场处刑仪式上打响的。','雅汶战役前 22 年','published'),
('68000000-0000-4000-8002-000000000014','en','The arena on Geonosis','Obi-Wan, Anakin and Padmé are condemned and set against beasts in the execution arena.','They have nearly freed themselves when a Jedi force reveals itself in the stands; the film opens a galactic war inside a public execution.','The first shot of the war is fired at a ceremony of punishment.','22 BBY','published'),
('68000000-0000-4000-8002-000000000015','zh-CN','詹戈·费特之死','梅斯·温杜在角斗场斩杀詹戈·费特,其子波巴目睹全程。','影片让一个孩子在人群中看着父亲的头盔滚落——波巴此后一生的动机在这一刻定下。','一支军队的基因来源死了,而他的儿子记住了动手的人。','雅汶战役前 22 年','published'),
('68000000-0000-4000-8002-000000000015','en','The death of Jango Fett','Mace Windu kills Jango Fett in the arena while his son Boba watches.','The film puts a child in the crowd as his father’s helmet rolls free; everything Boba does afterwards is set here.','The genetic source of an army dies, and his son remembers who did it.','22 BBY','published'),
('68000000-0000-4000-8002-000000000016','zh-CN','第一次吉奥诺西斯战役','克隆人军队首次投入战场,分离主义军队败退。','影片让一支刚刚被发现的军队在同一天投入使用——所有人都接受了它,没有人再问它是谁订的。','克隆人战争由此得名,而战争双方都是同一个人备好的。','雅汶战役前 22 年','published'),
('68000000-0000-4000-8002-000000000016','en','The first battle of Geonosis','The clone army is committed for the first time and the Separatist forces are driven back.','An army discovered days earlier is fielded the same week; everyone accepts it and no one asks again who ordered it.','The Clone Wars take their name from here, and both sides of them were prepared by one man.','22 BBY','published'),
('68000000-0000-4000-8002-000000000017','zh-CN','杜库与尤达交手','杜库先后击败欧比旺与阿纳金,斩断阿纳金一臂,再与尤达交手后脱身。','影片在此给了阿纳金第一处不可逆的身体损伤,并把它留在画面里。','失去的手是一个标记:此后他每一次修补自己,都离人更远一点。','雅汶战役前 22 年','published'),
('68000000-0000-4000-8002-000000000017','en','Dooku duels Yoda','Dooku beats Obi-Wan, then Anakin — taking his arm — and escapes after crossing blades with Yoda.','The film gives Anakin his first irreversible bodily loss here and keeps it on screen.','The lost hand is a marker: each later repair to his body takes him a step further from being a person.','22 BBY','published'),
('68000000-0000-4000-8002-000000000018','zh-CN','阿纳金与帕德梅成婚','两人在纳布秘密成婚,只有两台机器人在场。','影片让这段婚姻从第一天起就必须隐瞒,而隐瞒正是日后可以被要挟的把柄。','需要保守的秘密,后来成了能被利用的杠杆。','雅汶战役前 22 年','published'),
('68000000-0000-4000-8002-000000000018','en','Anakin and Padmé marry','The two marry in secret on Naboo, with only two droids as witnesses.','The film makes the marriage a thing that must be hidden from its first day, and the hiding is what can later be used against him.','A secret that must be kept becomes a lever that can be pulled.','22 BBY','published'),
('68000000-0000-4000-8002-000000000019','zh-CN','战火蔓延全银河','三年间战线遍及各环带,绝地由维和者变为将军。','影片与剧集共同呈现这一转变:一个以调解为业的组织开始指挥军队,并逐渐用军队的标准思考。','绝地的身份改变,比他们的伤亡更致命。','雅汶战役前 22 至 19 年','published'),
('68000000-0000-4000-8002-000000000019','en','The war spreads across the galaxy','Over three years the fronts reach every region, and the Jedi become generals.','The films and series together show the shift: an order that existed to mediate begins commanding armies, and begins to think the way armies think.','What the Jedi become costs them more than what the war kills.','c. 22–19 BBY','published'),
('68000000-0000-4000-8002-000000000020','zh-CN','阿索卡被指派给阿纳金','绝地委员会把年轻的阿索卡·塔诺指给阿纳金作学徒。','这是委员会的一步棋:让一个不肯放手的人学会放手。影片让这步棋以最坏的方式生效。','阿纳金第一次成为师父,也第一次尝到被自己一方辜负的滋味。','雅汶战役前 22 至 21 年','published'),
('68000000-0000-4000-8002-000000000020','en','Ahsoka is assigned to Anakin','The council gives Anakin a young apprentice, Ahsoka Tano.','It is a deliberate move: teach a man who cannot let go how to let go. The films let the move work in the worst possible way.','Anakin becomes a master for the first time, and tastes for the first time being failed by his own side.','c. 22–21 BBY','published'),
('68000000-0000-4000-8002-000000000021','zh-CN','阿索卡离开绝地武士团','阿索卡被诬告后遭委员会开除,洗清嫌疑后拒绝回归。','影片让制度先抛弃她再请她回来,而她拒绝了——这是阿纳金第一次看见委员会可以对自己人做什么。','阿纳金对委员会的信任在此断裂,比 66 号令早了一年。','雅汶战役前 20 年','published'),
('68000000-0000-4000-8002-000000000021','en','Ahsoka leaves the Jedi Order','Falsely accused, Ahsoka is expelled by the council, cleared, and then refuses to come back.','The institution abandons her and then invites her back, and she declines; it is the first time Anakin sees what the council will do to its own.','Anakin’s trust in the council breaks here, a year before Order 66.','20 BBY','published'),
('68000000-0000-4000-8002-000000000022','zh-CN','格里弗斯接掌分离主义军队','格里弗斯将军成为分离主义军队最高统帅,战事进入最后阶段。','影片让他以猎杀绝地为个人爱好,从而给最后一年提供一个可见的敌人。','一个可见的敌人,掩护着看不见的那个。','雅汶战役前 21 至 19 年','published'),
('68000000-0000-4000-8002-000000000022','en','Grievous takes command','General Grievous becomes supreme commander of the Separatist armies as the war enters its final phase.','The films make hunting Jedi his personal habit, which gives the last year of the war a visible enemy.','A visible enemy provides cover for the one nobody is looking for.','c. 21–19 BBY','published');

-- ============================================================
-- 3. EVENT LOCATIONS
-- ============================================================

INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id, l.id, w.role, w.position
FROM (VALUES
  ('the-separatist-crisis','coruscant','primary',0),
  ('assassination-attempt-on-amidala','coruscant','primary',0),
  ('the-assassin-is-silenced','coruscant','primary',0),
  ('anakin-assigned-to-guard-padme','coruscant','primary',0),
  ('the-missing-archive-entry','coruscant','primary',0),
  ('the-clone-army-discovered','kamino','primary',0),
  ('hiding-on-naboo','naboo','primary',0),
  ('anakin-dreams-of-his-mother','naboo','primary',0),
  ('return-to-tatooine-for-shmi','tatooine','primary',0),
  ('shmi-skywalker-dies','tatooine','primary',0),
  ('the-tusken-camp','tatooine','primary',0),
  ('obi-wan-captured-on-geonosis','geonosis','primary',0),
  ('emergency-powers-granted','coruscant','primary',0),
  ('the-arena-on-geonosis','geonosis','primary',0),
  ('jango-fett-killed','geonosis','primary',0),
  ('first-battle-of-geonosis','geonosis','primary',0),
  ('dooku-duels-yoda','geonosis','primary',0),
  ('anakin-and-padme-marry','naboo','primary',0),
  ('the-war-spreads','coruscant','primary',0),
  ('the-war-spreads','felucia','front',1),
  ('the-war-spreads','ryloth','front',2),
  ('the-war-spreads','cato-neimoidia','front',3),
  ('ahsoka-assigned-to-anakin','coruscant','primary',0),
  ('ahsoka-leaves-the-jedi-order','coruscant','primary',0),
  ('grievous-takes-command','utapau','primary',0)
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
  ('the-separatist-crisis','count-dooku','primary',0,true),
  ('the-separatist-crisis','sheev-palpatine','participant',1,false),
  ('the-separatist-crisis','padme-amidala','participant',2,false),
  ('assassination-attempt-on-amidala','padme-amidala','primary',0,true),
  ('assassination-attempt-on-amidala','zam-wesell','participant',1,false),
  ('the-assassin-is-silenced','zam-wesell','primary',0,true),
  ('the-assassin-is-silenced','jango-fett','participant',1,false),
  ('the-assassin-is-silenced','obi-wan-kenobi','participant',2,false),
  ('the-assassin-is-silenced','anakin-skywalker','participant',3,false),
  ('anakin-assigned-to-guard-padme','anakin-skywalker','primary',0,true),
  ('anakin-assigned-to-guard-padme','padme-amidala','participant',1,false),
  ('anakin-assigned-to-guard-padme','mace-windu','participant',2,false),
  ('the-missing-archive-entry','obi-wan-kenobi','primary',0,true),
  ('the-missing-archive-entry','yoda','participant',1,false),
  ('the-clone-army-discovered','obi-wan-kenobi','primary',0,true),
  ('the-clone-army-discovered','lama-su','participant',1,false),
  ('the-clone-army-discovered','jango-fett','participant',2,false),
  ('the-clone-army-discovered','boba-fett','participant',3,false),
  ('hiding-on-naboo','anakin-skywalker','primary',0,true),
  ('hiding-on-naboo','padme-amidala','participant',1,false),
  ('anakin-dreams-of-his-mother','anakin-skywalker','primary',0,true),
  ('anakin-dreams-of-his-mother','shmi-skywalker','participant',1,false),
  ('return-to-tatooine-for-shmi','anakin-skywalker','primary',0,true),
  ('return-to-tatooine-for-shmi','cliegg-lars','participant',1,false),
  ('return-to-tatooine-for-shmi','owen-lars','participant',2,false),
  ('return-to-tatooine-for-shmi','beru-whitesun-lars','participant',3,false),
  ('return-to-tatooine-for-shmi','padme-amidala','participant',4,false),
  ('shmi-skywalker-dies','shmi-skywalker','primary',0,true),
  ('shmi-skywalker-dies','anakin-skywalker','participant',1,false),
  ('the-tusken-camp','anakin-skywalker','primary',0,true),
  ('obi-wan-captured-on-geonosis','obi-wan-kenobi','primary',0,true),
  ('obi-wan-captured-on-geonosis','count-dooku','participant',1,false),
  ('obi-wan-captured-on-geonosis','jango-fett','participant',2,false),
  ('obi-wan-captured-on-geonosis','nute-gunray','participant',3,false),
  ('obi-wan-captured-on-geonosis','poggle-the-lesser','participant',4,false),
  ('emergency-powers-granted','jar-jar-binks','primary',0,true),
  ('emergency-powers-granted','sheev-palpatine','participant',1,false),
  ('the-arena-on-geonosis','obi-wan-kenobi','primary',0,true),
  ('the-arena-on-geonosis','anakin-skywalker','participant',1,false),
  ('the-arena-on-geonosis','padme-amidala','participant',2,false),
  ('the-arena-on-geonosis','poggle-the-lesser','participant',3,false),
  ('jango-fett-killed','jango-fett','primary',0,true),
  ('jango-fett-killed','mace-windu','participant',1,false),
  ('jango-fett-killed','boba-fett','participant',2,false),
  ('first-battle-of-geonosis','yoda','primary',0,true),
  ('first-battle-of-geonosis','commander-cody','participant',1,false),
  ('first-battle-of-geonosis','captain-rex','participant',2,false),
  ('first-battle-of-geonosis','count-dooku','participant',3,false),
  ('dooku-duels-yoda','count-dooku','primary',0,true),
  ('dooku-duels-yoda','yoda','participant',1,false),
  ('dooku-duels-yoda','anakin-skywalker','participant',2,false),
  ('dooku-duels-yoda','obi-wan-kenobi','participant',3,false),
  ('anakin-and-padme-marry','anakin-skywalker','primary',0,true),
  ('anakin-and-padme-marry','padme-amidala','participant',1,false),
  ('anakin-and-padme-marry','r2-d2','participant',2,false),
  ('anakin-and-padme-marry','c-3po','participant',3,false),
  ('the-war-spreads','obi-wan-kenobi','primary',0,true),
  ('the-war-spreads','anakin-skywalker','participant',1,false),
  ('the-war-spreads','captain-rex','participant',2,false),
  ('the-war-spreads','commander-cody','participant',3,false),
  ('ahsoka-assigned-to-anakin','ahsoka-tano','primary',0,true),
  ('ahsoka-assigned-to-anakin','anakin-skywalker','participant',1,false),
  ('ahsoka-assigned-to-anakin','yoda','participant',2,false),
  ('ahsoka-leaves-the-jedi-order','ahsoka-tano','primary',0,true),
  ('ahsoka-leaves-the-jedi-order','anakin-skywalker','participant',1,false),
  ('ahsoka-leaves-the-jedi-order','mace-windu','participant',2,false),
  ('grievous-takes-command','general-grievous','primary',0,true),
  ('grievous-takes-command','count-dooku','participant',1,false)
) AS w(event_slug, character_slug, role, participant_order, is_primary)
JOIN events e ON e.work_id='10000000-0000-4000-8000-000000000008' AND e.slug=w.event_slug
JOIN characters c ON c.work_id='10000000-0000-4000-8000-000000000008' AND c.slug=w.character_slug
ON CONFLICT DO NOTHING;

-- ============================================================
-- 5. EVENT SOURCES
-- ============================================================

INSERT INTO event_sources(event_id,source_id)
SELECT e.id, s.id
FROM events e
JOIN sources s ON s.work_id='10000000-0000-4000-8000-000000000008' AND s.title='Episode II: Attack of the Clones (2002 film)'
WHERE e.id::text LIKE '68000000-0000-4000-8002%'
  AND e.slug NOT IN ('ahsoka-assigned-to-anakin','ahsoka-leaves-the-jedi-order','the-war-spreads','grievous-takes-command')
ON CONFLICT DO NOTHING;

-- The war years between the second and third films are carried by the series;
-- cited here against the film that opens and the film that closes them.
INSERT INTO event_sources(event_id,source_id)
SELECT e.id, s.id
FROM events e
JOIN sources s ON s.work_id='10000000-0000-4000-8000-000000000008' AND s.title='Episode III: Revenge of the Sith (2005 film)'
WHERE e.work_id='10000000-0000-4000-8000-000000000008'
  AND e.slug IN ('ahsoka-assigned-to-anakin','ahsoka-leaves-the-jedi-order','the-war-spreads','grievous-takes-command')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 6. RELATIONS
-- ============================================================

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT w.id::uuid, '10000000-0000-4000-8000-000000000008', f.id, t.id, w.relation_type, w.direction::relationship_direction, w.sentiment::relationship_sentiment, w.strength, w.status::relationship_status, NULL, NULL
FROM (VALUES
  ('78000000-0000-4000-8002-000000000001','anakin-skywalker','padme-amidala','spouse','bidirectional','positive',5,'ended'),
  ('78000000-0000-4000-8002-000000000002','anakin-skywalker','ahsoka-tano','mentor','source_to_target','positive',5,'changed'),
  ('78000000-0000-4000-8002-000000000003','obi-wan-kenobi','anakin-skywalker','mentor','source_to_target','mixed',5,'changed'),
  ('78000000-0000-4000-8002-000000000004','sheev-palpatine','count-dooku','mentor','source_to_target','negative',4,'ended'),
  ('78000000-0000-4000-8002-000000000005','count-dooku','yoda','adversary','bidirectional','mixed',4,'ended'),
  ('78000000-0000-4000-8002-000000000006','jango-fett','boba-fett','family','bidirectional','positive',5,'ended'),
  ('78000000-0000-4000-8002-000000000007','mace-windu','jango-fett','adversary','source_to_target','negative',4,'ended'),
  ('78000000-0000-4000-8002-000000000008','count-dooku','jango-fett','liege','source_to_target','neutral',3,'ended'),
  ('78000000-0000-4000-8002-000000000009','zam-wesell','jango-fett','ally','bidirectional','negative',2,'ended'),
  ('78000000-0000-4000-8002-000000000010','cliegg-lars','shmi-skywalker','spouse','bidirectional','positive',4,'ended'),
  ('78000000-0000-4000-8002-000000000011','cliegg-lars','owen-lars','family','bidirectional','positive',4,'ended'),
  ('78000000-0000-4000-8002-000000000012','owen-lars','beru-whitesun-lars','spouse','bidirectional','positive',5,'ended'),
  ('78000000-0000-4000-8002-000000000013','owen-lars','anakin-skywalker','family','bidirectional','mixed',2,'ended'),
  ('78000000-0000-4000-8002-000000000014','obi-wan-kenobi','commander-cody','ally','bidirectional','positive',4,'ended'),
  ('78000000-0000-4000-8002-000000000015','anakin-skywalker','captain-rex','ally','bidirectional','positive',4,'ended'),
  ('78000000-0000-4000-8002-000000000016','lama-su','jango-fett','other','source_to_target','neutral',2,'ended'),
  ('78000000-0000-4000-8002-000000000017','count-dooku','poggle-the-lesser','liege','source_to_target','neutral',3,'ended'),
  ('78000000-0000-4000-8002-000000000018','count-dooku','general-grievous','liege','source_to_target','neutral',4,'ended'),
  ('78000000-0000-4000-8002-000000000019','ahsoka-tano','captain-rex','ally','bidirectional','positive',5,'active')
) AS w(id, from_slug, to_slug, relation_type, direction, sentiment, strength, status)
JOIN characters f ON f.work_id='10000000-0000-4000-8000-000000000008' AND f.slug=w.from_slug
JOIN characters t ON t.work_id='10000000-0000-4000-8000-000000000008' AND t.slug=w.to_slug
ON CONFLICT DO NOTHING;

INSERT INTO relation_translations(relation_id,locale,label,summary,status) VALUES
('78000000-0000-4000-8002-000000000001','zh-CN','秘密夫妻(阿纳金↔帕德梅)','违反教规的婚姻,从成婚那天起就必须隐瞒。','published'),
('78000000-0000-4000-8002-000000000001','en','Secret spouses (Anakin ↔ Padmé)','A marriage against his order’s rule, hidden from the day it is made.','published'),
('78000000-0000-4000-8002-000000000002','zh-CN','师徒(阿纳金→阿索卡)','委员会指派的学徒;她的离开动摇了他对委员会的信任。','published'),
('78000000-0000-4000-8002-000000000002','en','Master and apprentice (Anakin → Ahsoka)','An apprentice assigned by the council, whose departure shakes his trust in it.','published'),
('78000000-0000-4000-8002-000000000003','zh-CN','师徒兼兄弟(欧比旺→阿纳金)','既是师父也是兄长,而两种身份都不足以把他留住。','published'),
('78000000-0000-4000-8002-000000000003','en','Master and brother (Obi-Wan → Anakin)','Master and elder brother at once, and neither is enough to keep him.','published'),
('78000000-0000-4000-8002-000000000004','zh-CN','西斯师徒(西迪厄斯→杜库)','第二个学徒,同样被计划好了下场。','published'),
('78000000-0000-4000-8002-000000000004','en','Sith master and apprentice (Sidious → Dooku)','The second apprentice, and his end is likewise already scheduled.','published'),
('78000000-0000-4000-8002-000000000005','zh-CN','旧日师徒反目(杜库↔尤达)','杜库曾受教于尤达,如今在战场上相对。','published'),
('78000000-0000-4000-8002-000000000005','en','Former student turned enemy (Dooku ↔ Yoda)','Dooku was trained by Yoda, and now they meet across a battlefield.','published'),
('78000000-0000-4000-8002-000000000006','zh-CN','父子(詹戈↔波巴)','基因上完全相同的父子;儿子亲眼看着父亲被杀。','published'),
('78000000-0000-4000-8002-000000000006','en','Father and son (Jango ↔ Boba)','Genetically identical father and son; the son watches the father killed.','published'),
('78000000-0000-4000-8002-000000000007','zh-CN','斩杀者与被斩者(温杜→詹戈)','角斗场上的一击,给一个孩子留下了终身的目标。','published'),
('78000000-0000-4000-8002-000000000007','en','Killer and killed (Windu → Jango)','One stroke in the arena, and a child is left with a lifelong aim.','published'),
('78000000-0000-4000-8002-000000000008','zh-CN','雇主与雇员(杜库→詹戈)','分离主义的钱与赏金猎人的手。','published'),
('78000000-0000-4000-8002-000000000008','en','Employer and hired gun (Dooku → Jango)','Separatist money and a bounty hunter’s hands.','published'),
('78000000-0000-4000-8002-000000000009','zh-CN','同行与灭口(赞↔詹戈)','转包的活计,以及不能留活口的规矩。','published'),
('78000000-0000-4000-8002-000000000009','en','Subcontractor, silenced (Zam ↔ Jango)','Work passed down the chain, and the rule that no one is left to talk.','published'),
('78000000-0000-4000-8002-000000000010','zh-CN','夫妻(克里格↔施密)','把她从奴籍中买出来的人,却没能把她救回来。','published'),
('78000000-0000-4000-8002-000000000010','en','Husband and wife (Cliegg ↔ Shmi)','The man who bought her out of slavery and could not bring her back.','published'),
('78000000-0000-4000-8002-000000000011','zh-CN','父子(克里格↔欧文)','把农场与谨慎一并交下去的父与子。','published'),
('78000000-0000-4000-8002-000000000011','en','Father and son (Cliegg ↔ Owen)','A farm and a habit of caution, handed down together.','published'),
('78000000-0000-4000-8002-000000000012','zh-CN','夫妻(欧文↔贝露)','把卢克当自己孩子养大的一对农人。','published'),
('78000000-0000-4000-8002-000000000012','en','Husband and wife (Owen ↔ Beru)','Two farmers who raise Luke as their own.','published'),
('78000000-0000-4000-8002-000000000013','zh-CN','继兄弟(欧文↔阿纳金)','只见过一面的亲属,日后代他养大了他的儿子。','published'),
('78000000-0000-4000-8002-000000000013','en','Stepbrothers (Owen ↔ Anakin)','Kin who meet once, and one of whom raises the other’s son.','published'),
('78000000-0000-4000-8002-000000000014','zh-CN','将领与副手(欧比旺↔科迪)','三年并肩,终结于一道无需解释的命令。','published'),
('78000000-0000-4000-8002-000000000014','en','General and second (Obi-Wan ↔ Cody)','Three years side by side, ended by an order that needs no explanation.','published'),
('78000000-0000-4000-8002-000000000015','zh-CN','将领与副手(阿纳金↔雷克斯)','战场上的信任,比双方所属的阵营都长久。','published'),
('78000000-0000-4000-8002-000000000015','en','General and second (Anakin ↔ Rex)','A trust formed in the field that outlasts the sides they fight for.','published'),
('78000000-0000-4000-8002-000000000016','zh-CN','订货方与样本(拉玛·苏→詹戈)','一份合同,一个基因来源,几百万副同样的面孔。','published'),
('78000000-0000-4000-8002-000000000016','en','Contractor and template (Lama Su → Jango)','One contract, one genetic source, and millions of the same face.','published'),
('78000000-0000-4000-8002-000000000017','zh-CN','统帅与承造者(杜库→波格)','下订单的人与开铸造厂的人。','published'),
('78000000-0000-4000-8002-000000000017','en','Head of state and foundry (Dooku → Poggle)','The one who places the order and the one who casts it.','published'),
('78000000-0000-4000-8002-000000000018','zh-CN','统帅与总司令(杜库→格里弗斯)','政治上的头目与战场上的头目。','published'),
('78000000-0000-4000-8002-000000000018','en','Head of state and commander (Dooku → Grievous)','The political head and the battlefield one.','published'),
('78000000-0000-4000-8002-000000000019','zh-CN','战友(阿索卡↔雷克斯)','跨越 66 号令仍然维持下来的一段并肩。','published'),
('78000000-0000-4000-8002-000000000019','en','Comrades (Ahsoka ↔ Rex)','A partnership that survives even Order 66.','published')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 7. GROUP MEMBERSHIP
-- ============================================================

INSERT INTO character_group_members(group_id,character_id,membership_role)
SELECT g.id, c.id, w.membership_role
FROM (VALUES
  ('clone-army','commander-cody','marshal commander'),
  ('clone-army','captain-rex','captain'),
  ('clone-army','lama-su','contractor'),
  ('galactic-empire','commander-cody','marshal commander after the order'),
  ('separatist-alliance','poggle-the-lesser','archduke of Geonosis'),
  ('separatist-alliance','general-grievous','supreme commander'),
  ('smugglers-and-outlaws','zam-wesell','bounty hunter'),
  ('house-of-skywalker','cliegg-lars','stepfather'),
  ('house-of-skywalker','owen-lars','stepbrother'),
  ('house-of-skywalker','beru-whitesun-lars','foster mother to Luke'),
  ('jedi-order','captain-rex','clone attached to the 501st')
) AS w(group_slug, character_slug, membership_role)
JOIN character_groups g ON g.work_id='10000000-0000-4000-8000-000000000008' AND g.slug=w.group_slug
JOIN characters c ON c.work_id='10000000-0000-4000-8000-000000000008' AND c.slug=w.character_slug
ON CONFLICT DO NOTHING;

COMMIT;
