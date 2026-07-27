BEGIN;

-- Era 01 · naboo-crisis (32 BBY, database years -33..-31)
--
-- Written per db/seeds/galaxy-seed-spec.md. All prose is this project's own;
-- the films are referenced, never quoted. Sequence band 1001-1999, step 2.

-- ============================================================
-- 1. CHARACTERS
-- ============================================================

INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('48000000-0000-4000-8001-000000000001','10000000-0000-4000-8000-000000000008','shmi-skywalker',101,'female','adult','supporting','fictional',-72,-22,'person',3),
('48000000-0000-4000-8001-000000000002','10000000-0000-4000-8000-000000000008','r2-d2',102,'na','adult','supporting','fictional',NULL,NULL,'droid',4),
('48000000-0000-4000-8001-000000000003','10000000-0000-4000-8000-000000000008','c-3po',103,'na','adult','supporting','fictional',-32,NULL,'droid',4),
('48000000-0000-4000-8001-000000000004','10000000-0000-4000-8000-000000000008','jar-jar-binks',104,'male','adult','supporting','fictional',NULL,NULL,'person',3),
('48000000-0000-4000-8001-000000000005','10000000-0000-4000-8000-000000000008','nute-gunray',105,'male','adult','antagonist','fictional',NULL,-19,'ruler',3),
('48000000-0000-4000-8001-000000000006','10000000-0000-4000-8000-000000000008','finis-valorum',106,'male','elder','supporting','fictional',NULL,NULL,'senator',3),
('48000000-0000-4000-8001-000000000007','10000000-0000-4000-8000-000000000008','watto',107,'male','adult','supporting','fictional',NULL,NULL,'person',2),
('48000000-0000-4000-8001-000000000008','10000000-0000-4000-8000-000000000008','captain-panaka',108,'male','adult','supporting','fictional',NULL,NULL,'soldier',2),
('48000000-0000-4000-8001-000000000009','10000000-0000-4000-8000-000000000008','boss-nass',109,'male','elder','supporting','fictional',NULL,NULL,'ruler',2),
('48000000-0000-4000-8001-000000000010','10000000-0000-4000-8000-000000000008','ki-adi-mundi',110,'male','adult','supporting','fictional',NULL,-19,'jedi',2)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,aliases,detail,motivation,status) VALUES
('48000000-0000-4000-8001-000000000001','zh-CN','施密·天行者','阿纳金的母亲,塔图因上的奴隶。','{}','影片没有给她自由,只让她把儿子送走;这次分别是阿纳金后来一切恐惧的源头。','让儿子过上比自己更好的日子。','published'),
('48000000-0000-4000-8001-000000000001','en','Shmi Skywalker','Anakin’s mother, a slave on Tatooine.','{}','The films never free her; they only let her send her son away, and that parting is the source of every fear he carries afterwards.','A better life for her son than her own.','published'),
('48000000-0000-4000-8001-000000000002','zh-CN','R2-D2','宇航技工机器人,九部曲中在场时间最长的角色之一。','{"阿图"}','从纳布王室飞船的船体修理,到最后一部,它始终在场——影片让它成为整段家族史的见证者。','完成交给它的任务,并留在同伴身边。','published'),
('48000000-0000-4000-8001-000000000002','en','R2-D2','An astromech droid, and one of the few characters present across all nine films.','{"Artoo"}','From repairing the Naboo royal ship’s hull to the final film, it is always there; the films use it as the witness to the whole family history.','To finish the job it was given, and stay with its people.','published'),
('48000000-0000-4000-8001-000000000003','zh-CN','C-3PO','礼仪与翻译机器人,阿纳金少年时在塔图因组装。','{"三比欧"}','','把规矩讲清楚,尽管没人听。','published'),
('48000000-0000-4000-8001-000000000003','en','C-3PO','A protocol and translation droid, assembled by a young Anakin on Tatooine.','{"Threepio"}','','To state the odds and the etiquette, whether or not anyone listens.','published'),
('48000000-0000-4000-8001-000000000004','zh-CN','加·加·宾克斯','被本族放逐的冈根人,后成为纳布派驻共和国的代表。','{}','影片让他从笑料变成议员,而正是他在议会提出的动议交出了共和国的紧急权力。','讨好所有人,不再被赶走。','published'),
('48000000-0000-4000-8001-000000000004','en','Jar Jar Binks','A Gungan exiled by his own people, later Naboo’s representative in the Republic.','{}','The films take him from comic relief to the senate floor, and it is his motion that hands over the Republic’s emergency powers.','To please everyone, and never be driven out again.','published'),
('48000000-0000-4000-8001-000000000005','zh-CN','努特·冈雷','贸易联盟总督,纳布封锁的执行者。','{}','','保住联盟的利润,并且不被追究。','published'),
('48000000-0000-4000-8001-000000000005','en','Nute Gunray','Viceroy of the Trade Federation and the man who executes the Naboo blockade.','{}','','To protect the Federation’s profits and answer for nothing.','published'),
('48000000-0000-4000-8001-000000000006','zh-CN','菲尼斯·瓦洛伦','纳布危机时的共和国最高议长,因议事拖沓被不信任动议罢免。','{}','','在一个已经瘫痪的程序里维持程序。','published'),
('48000000-0000-4000-8001-000000000006','en','Finis Valorum','Supreme Chancellor during the Naboo crisis, removed by a vote of no confidence over the senate’s paralysis.','{}','','To keep procedure going in a body where procedure has stopped working.','published'),
('48000000-0000-4000-8001-000000000007','zh-CN','瓦托','塔图因的零件商,阿纳金母子的奴隶主。','{}','','赌赢,并保住自己的货。','published'),
('48000000-0000-4000-8001-000000000007','en','Watto','A parts dealer on Tatooine who owns Anakin and his mother.','{}','','To win his bets and keep his stock.','published'),
('48000000-0000-4000-8001-000000000008','zh-CN','帕纳卡上尉','纳布王室卫队指挥官。','{}','','保护女王,哪怕女王自己不肯待在安全处。','published'),
('48000000-0000-4000-8001-000000000008','en','Captain Panaka','Commander of the Naboo royal security forces.','{}','','To protect the queen, including from her own refusal to stay safe.','published'),
('48000000-0000-4000-8001-000000000009','zh-CN','纳斯首领','冈根人的首领,起初拒绝与地面居民结盟。','{}','','让冈根人置身事外——直到置身事外不再可能。','published'),
('48000000-0000-4000-8001-000000000009','en','Boss Nass','Leader of the Gungans, who at first refuses any alliance with the surface people.','{}','','To keep the Gungans out of it, until staying out is no longer possible.','published'),
('48000000-0000-4000-8001-000000000010','zh-CN','奇·阿迪·穆迪','绝地委员会成员。','{}','','守住委员会的判断标准。','published'),
('48000000-0000-4000-8001-000000000010','en','Ki-Adi-Mundi','A member of the Jedi council.','{}','','To hold the council to its own standard of judgement.','published')
ON CONFLICT DO NOTHING;

UPDATE characters SET birth_place_id=(SELECT id FROM locations WHERE work_id='10000000-0000-4000-8000-000000000008' AND slug='naboo') WHERE id='48000000-0000-4000-8001-000000000004';
UPDATE characters SET death_place_id=(SELECT id FROM locations WHERE work_id='10000000-0000-4000-8000-000000000008' AND slug='tatooine') WHERE id='48000000-0000-4000-8001-000000000001';

-- ============================================================
-- 2. EVENTS
-- ============================================================

INSERT INTO events(id,work_id,slug,start_date,end_date,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,start_month,start_day,confidence,chapter_id) VALUES
('68000000-0000-4000-8001-000000000001','10000000-0000-4000-8000-000000000008','trade-federation-blockades-naboo',NULL,NULL,1001,'fictional_narrative','political','fictional_calendar','fictional',-33,-33,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000002','10000000-0000-4000-8000-000000000008','jedi-envoys-sent-to-negotiate',NULL,NULL,1003,'fictional_narrative','meeting','fictional_calendar','fictional',-33,-33,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000003','10000000-0000-4000-8000-000000000008','invasion-of-naboo',NULL,NULL,1005,'fictional_narrative','battle','fictional_calendar','fictional',-33,-33,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000004','10000000-0000-4000-8000-000000000008','jedi-reach-the-gungan-city',NULL,NULL,1007,'fictional_narrative','meeting','fictional_calendar','fictional',-33,-33,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000005','10000000-0000-4000-8000-000000000008','queen-amidala-escapes-the-blockade',NULL,NULL,1009,'fictional_narrative','escape','fictional_calendar','fictional',-33,-33,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000006','10000000-0000-4000-8000-000000000008','forced-landing-on-tatooine',NULL,NULL,1011,'fictional_narrative','journey','fictional_calendar','fictional',-33,-33,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000007','10000000-0000-4000-8000-000000000008','qui-gon-meets-anakin',NULL,NULL,1013,'fictional_narrative','meeting','fictional_calendar','fictional',-33,-33,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000008','10000000-0000-4000-8000-000000000008','the-boonta-eve-race',NULL,NULL,1015,'fictional_narrative','trial','fictional_calendar','fictional',-33,-33,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000009','10000000-0000-4000-8000-000000000008','anakin-leaves-his-mother',NULL,NULL,1017,'fictional_narrative','migration','fictional_calendar','fictional',-33,-33,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000010','10000000-0000-4000-8000-000000000008','first-duel-with-the-sith-assassin',NULL,NULL,1019,'fictional_narrative','battle','fictional_calendar','fictional',-33,-33,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000011','10000000-0000-4000-8000-000000000008','the-senate-fails-naboo',NULL,NULL,1021,'fictional_narrative','political','fictional_calendar','fictional',-33,-33,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000012','10000000-0000-4000-8000-000000000008','vote-of-no-confidence-in-valorum',NULL,NULL,1023,'fictional_narrative','political','fictional_calendar','fictional',-33,-33,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000013','10000000-0000-4000-8000-000000000008','the-council-tests-anakin',NULL,NULL,1025,'fictional_narrative','trial','fictional_calendar','fictional',-33,-33,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000014','10000000-0000-4000-8000-000000000008','amidala-returns-to-naboo',NULL,NULL,1027,'fictional_narrative','journey','fictional_calendar','fictional',-33,-33,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000015','10000000-0000-4000-8000-000000000008','alliance-with-the-gungans',NULL,NULL,1029,'fictional_narrative','political','fictional_calendar','fictional',-33,-32,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000016','10000000-0000-4000-8000-000000000008','the-grassy-plains-diversion',NULL,NULL,1031,'fictional_narrative','battle','fictional_calendar','fictional',-33,-32,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000017','10000000-0000-4000-8000-000000000008','the-orbital-control-ship-destroyed',NULL,NULL,1033,'fictional_narrative','battle','fictional_calendar','fictional',-33,-32,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000018','10000000-0000-4000-8000-000000000008','duel-of-the-generators',NULL,NULL,1035,'fictional_narrative','battle','fictional_calendar','fictional',-33,-32,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000019','10000000-0000-4000-8000-000000000008','qui-gon-jinn-dies',NULL,NULL,1037,'fictional_narrative','death','fictional_calendar','fictional',-33,-32,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000020','10000000-0000-4000-8000-000000000008','obi-wan-takes-anakin-as-apprentice',NULL,NULL,1039,'fictional_narrative','political','fictional_calendar','fictional',-32,-32,NULL,NULL,'high','88000000-0000-4000-8001-000000000001'),
('68000000-0000-4000-8001-000000000021','10000000-0000-4000-8000-000000000008','palpatine-elected-chancellor',NULL,NULL,1041,'fictional_narrative','political','fictional_calendar','fictional',-32,-31,NULL,NULL,'high','88000000-0000-4000-8001-000000000001');

INSERT INTO event_translations(event_id,locale,title,summary,detail,significance,time_label,status) VALUES
('68000000-0000-4000-8001-000000000001','zh-CN','贸易联盟封锁纳布','贸易联盟以税制争议为由,用舰队封锁了纳布的所有航道。','影片把这场封锁拍成一次商业纠纷,而后续揭示它是被人有意安排的:争端本身就是目的。','共和国衰亡的第一步不是战争,而是一次没人愿意处理的行政争议。','雅汶战役前 33 年','published'),
('68000000-0000-4000-8001-000000000001','en','The Trade Federation blockades Naboo','The Trade Federation seals every route to Naboo with its fleet, citing a dispute over taxation.','The film presents this as a commercial quarrel; what follows reveals it was arranged, and that the quarrel itself was the point.','The Republic’s decline begins not with a war but with an administrative dispute no one will handle.','33 BBY','published'),
('68000000-0000-4000-8001-000000000002','zh-CN','绝地作为使者被派往谈判','最高议长秘密派出两名绝地登舰,要求联盟坐下来谈。','魁刚与欧比旺以使者身份登上旗舰,联盟的回应是关门放毒气——谈判从一开始就不存在。','共和国还能派出使者,却已经不能保证使者的安全。','雅汶战役前 33 年','published'),
('68000000-0000-4000-8001-000000000002','en','Jedi envoys are sent to negotiate','The Chancellor quietly sends two Jedi aboard the blockade flagship to force the Federation to talk.','Qui-Gon and Obi-Wan board as envoys; the Federation answers by sealing the room and flooding it. There was never going to be a negotiation.','The Republic can still send envoys, but can no longer guarantee their safety.','33 BBY','published'),
('68000000-0000-4000-8001-000000000003','zh-CN','纳布遭到入侵','联盟的机器人军队登陆,占领首都,俘获女王与政府。','影片让占领来得极快且几乎不流血——这是一次要在议会追认之前完成的既成事实。','武力先行、程序追认,这一手法此后被反复使用。','雅汶战役前 33 年','published'),
('68000000-0000-4000-8001-000000000003','en','The invasion of Naboo','The Federation’s droid army lands, takes the capital, and captures the queen and her government.','The film makes the occupation fast and nearly bloodless: a fait accompli meant to be finished before the senate can rule on it.','Force first, ratification afterwards — a method that will be used again and again.','33 BBY','published'),
('68000000-0000-4000-8001-000000000004','zh-CN','绝地抵达冈根人的水下城','逃亡中的绝地进入冈根人的城市,并带走了被放逐的加·加·宾克斯。','影片在此第一次点明纳布的两个族群互不往来,这一裂痕将在结尾成为胜负关键。','两个族群的隔阂被提前摆上台面,以便日后被弥合。','雅汶战役前 33 年','published'),
('68000000-0000-4000-8001-000000000004','en','The Jedi reach the Gungan city','Fleeing the invasion, the Jedi enter the underwater Gungan city and leave with an exile, Jar Jar Binks.','The film establishes here that Naboo’s two peoples do not deal with each other — a rift that decides the outcome in the final act.','The division is put on the table early so that closing it can matter later.','33 BBY','published'),
('68000000-0000-4000-8001-000000000005','zh-CN','阿米达拉女王突破封锁','绝地救出女王,飞船强行冲过封锁,却在途中受损。','R2-D2 在船体外完成修理,使飞船得以脱离——影片用这一笔把一台机器人放进了主线。','逃出去的代价是偏航,而偏航把阿纳金带进了故事。','雅汶战役前 33 年','published'),
('68000000-0000-4000-8001-000000000005','en','Queen Amidala escapes the blockade','The Jedi free the queen and her ship runs the blockade, taking damage on the way out.','R2-D2 completes the repair on the hull under fire, which is how a droid enters the main line of the story.','Escaping costs them their course, and the wrong course is what brings Anakin into the story.','33 BBY','published'),
('68000000-0000-4000-8001-000000000006','zh-CN','迫降塔图因','受损的飞船无法直航科洛桑,被迫降落在共和国管不到的塔图因。','影片特意点明这里在共和国法权之外——奴隶制在此合法,而阿纳金母子就是奴隶。','共和国的边界被具体化为一个它管不到的地方。','雅汶战役前 33 年','published'),
('68000000-0000-4000-8001-000000000006','en','Forced landing on Tatooine','Too damaged to reach Coruscant, the ship puts down on Tatooine, outside Republic jurisdiction.','The film is explicit that Republic law does not reach here: slavery is legal, and Anakin and his mother are slaves.','The Republic’s limits are made concrete as a place it does not govern.','33 BBY','published'),
('68000000-0000-4000-8001-000000000007','zh-CN','魁刚遇见阿纳金','为筹措零件,魁刚一行进入瓦托的店铺,遇到九岁的阿纳金·天行者。','魁刚认定这个孩子身上有异常的原力潜质,并开始盘算如何把他带走。','整部前传的因果链从这次偶遇开始。','雅汶战役前 33 年','published'),
('68000000-0000-4000-8001-000000000007','en','Qui-Gon meets Anakin','Looking for parts, Qui-Gon’s group walks into Watto’s shop and meets nine-year-old Anakin Skywalker.','Qui-Gon concludes the boy carries an unusual potential in the Force and begins working out how to take him along.','The causal chain of the whole prequel arc starts with this chance meeting.','33 BBY','published'),
('68000000-0000-4000-8001-000000000008','zh-CN','布恩塔前夜大赛','魁刚拿飞船零件与阿纳金的自由跟瓦托对赌一场飞梭赛,阿纳金取胜。','影片让一个孩子在一场赌局里赢得自己的自由,却赢不到母亲的。','自由是被赌来的,而且只够一个人——这个缺口日后长成了执念。','雅汶战役前 33 年','published'),
('68000000-0000-4000-8001-000000000008','en','The Boonta Eve race','Qui-Gon wagers with Watto on a podrace, with the parts and Anakin’s freedom at stake, and Anakin wins.','The film has a child win his own freedom in a bet — and only his own; his mother’s is not part of it.','Freedom is won by gambling and covers one person. That gap grows into an obsession.','33 BBY','published'),
('68000000-0000-4000-8001-000000000009','zh-CN','阿纳金与母亲分别','阿纳金随绝地离开塔图因,施密留在瓦托手下。','影片把这次告别拍得没有回旋余地:他被告知不要回头。','此后阿纳金的每一次失控,都能追回到这个没能带走的人。','雅汶战役前 33 年','published'),
('68000000-0000-4000-8001-000000000009','en','Anakin leaves his mother','Anakin departs Tatooine with the Jedi; Shmi stays behind, still owned.','The film gives the parting no way back: he is told not to look behind him.','Every later loss of control in Anakin traces to the person he could not bring.','33 BBY','published'),
('68000000-0000-4000-8001-000000000010','zh-CN','与西斯刺客的第一次交手','一名黑衣战士在塔图因沙漠追上魁刚,短暂交手后撤离。','绝地由此确认西斯并未绝迹——但委员会认为证据仍不充分。','千年未见的敌人重新出现,而制度的第一反应是不相信。','雅汶战役前 33 年','published'),
('68000000-0000-4000-8001-000000000010','en','First duel with the Sith assassin','A black-clad warrior catches Qui-Gon in the Tatooine desert, fights briefly, and withdraws.','The Jedi now have evidence the Sith did not die out, and the council decides the evidence is not enough.','An enemy unseen for a thousand years reappears, and the institution’s first response is disbelief.','33 BBY','published'),
('68000000-0000-4000-8001-000000000011','zh-CN','议会未能处理纳布案','女王在议会申诉,议事被程序问题拖入委员会调查。','影片让议会的失败极其具体:不是有人反对,而是没有人能让它动起来。','程序空转本身,就是有人正在利用的漏洞。','雅汶战役前 33 年','published'),
('68000000-0000-4000-8001-000000000011','en','The senate fails Naboo','The queen puts her case to the senate, where procedure diverts it into a committee of inquiry.','The film makes the failure specific: no one opposes her, and no one can make the body act.','The paralysis is not a side effect. It is the opening someone is using.','33 BBY','published'),
('68000000-0000-4000-8001-000000000012','zh-CN','对瓦洛伦的不信任动议','阿米达拉在议会提出不信任动议,瓦洛伦被罢免。','这一动议由她提出、由帕尔帕廷受益——影片让受害者亲手为加害者铺路。','权力的第一次转移出自受害者之手,这是整条堕落线的写法。','雅汶战役前 33 年','published'),
('68000000-0000-4000-8001-000000000012','en','The vote of no confidence in Valorum','Amidala moves no confidence on the senate floor and Valorum is removed.','She makes the motion; Palpatine is the one it benefits. The film has the victim clear the path herself.','The first transfer of power comes from the injured party’s own hand — the pattern the whole fall follows.','33 BBY','published'),
('68000000-0000-4000-8001-000000000013','zh-CN','委员会考核阿纳金','绝地委员会审视阿纳金,认定他心中有恐惧,拒绝收训。','尤达指出他挂念着母亲;委员会把这种牵挂视为危险,而不是需要照料的事。','制度看见了风险,却选择用拒绝来处理,这一处理方式本身埋下后果。','雅汶战役前 33 年','published'),
('68000000-0000-4000-8001-000000000013','en','The council tests Anakin','The Jedi council examines Anakin, finds fear in him, and refuses to train him.','Yoda names the attachment to his mother; the council treats that attachment as a danger rather than as something to be tended.','The institution sees the risk and answers it with refusal, and the refusal has consequences of its own.','33 BBY','published'),
('68000000-0000-4000-8001-000000000014','zh-CN','女王决定返回纳布','议会既无作为,女王决定自行返回,靠本土力量夺回首都。','影片让她放弃求助而选择行动,这是她此后一贯的做法。','纳布的解放不是共和国给的,是自己拿回来的。','雅汶战役前 33 年','published'),
('68000000-0000-4000-8001-000000000014','en','Amidala returns to Naboo','With the senate inert, the queen goes home to retake her capital with what she has.','The film has her stop asking and start acting, which is how she behaves from here on.','Naboo is not liberated by the Republic. It takes itself back.','33 BBY','published'),
('68000000-0000-4000-8001-000000000015','zh-CN','与冈根人结盟','女王向纳斯首领下跪求援,两个族群首次结盟。','影片用一个屈身的动作解决了整部片子铺垫的隔阂——她把自己放在对方之下。','这场胜利的前提是一次示弱,而不是一次施压。','雅汶战役前 33 至 32 年','published'),
('68000000-0000-4000-8001-000000000015','en','Alliance with the Gungans','The queen kneels before Boss Nass to ask for help, and the two peoples ally for the first time.','The film resolves the rift it spent an hour building with a single act of lowering herself.','The victory is bought by an admission of weakness, not by pressure.','c. 33–32 BBY','published'),
('68000000-0000-4000-8001-000000000016','zh-CN','草原上的牵制战','冈根军队在平原上正面吸引机器人大军,为夺回王宫争取时间。','这是一场明知会输的会战,目的只是让敌人的注意力离开首都。','分兵三路的战术布局,是本片结构上的骨架。','雅汶战役前 33 至 32 年','published'),
('68000000-0000-4000-8001-000000000016','en','The diversion on the grassy plains','The Gungan army meets the droid army in the open to pull it away from the capital.','It is a battle they expect to lose; its whole purpose is to move the enemy’s attention off the palace.','The three-pronged plan is the structural spine of the film’s final act.','c. 33–32 BBY','published'),
('68000000-0000-4000-8001-000000000017','zh-CN','轨道控制舰被摧毁','阿纳金误入一架战机,在轨道上击毁了指挥机器人军队的控制舰。','控制舰一毁,地面的机器人全部停机——影片把整场战役的胜负系在一个孩子的偶然上。','这次胜利让所有人确信他就是预言中的人,包括他自己。','雅汶战役前 33 至 32 年','published'),
('68000000-0000-4000-8001-000000000017','en','The orbital control ship is destroyed','Anakin, adrift in a fighter he did not mean to fly, destroys the ship coordinating the droid army.','With the control ship gone every droid on the ground stops, and the film hangs the whole battle on a child’s accident.','The win convinces everyone he is the one the prophecy meant — himself included.','c. 33–32 BBY','published'),
('68000000-0000-4000-8001-000000000018','zh-CN','发电机房的决斗','两名绝地与西斯刺客在王宫发电机组之间交手,力场门把三人隔开。','影片用反复开合的力场门把师徒分开,让师父独自面对——这是分开导致死亡的设计。','结构上,这是整部前传里第一次「来不及」。','雅汶战役前 33 至 32 年','published'),
('68000000-0000-4000-8001-000000000018','en','The duel among the generators','The two Jedi fight the Sith assassin through the palace generator complex, separated by cycling force gates.','The gates split master from apprentice and leave the master alone; the separation is what makes the death possible.','Structurally this is the first time in the prequel arc that someone arrives too late.','c. 33–32 BBY','published'),
('68000000-0000-4000-8001-000000000019','zh-CN','魁刚·金之死','魁刚在决斗中被刺穿,临终托付欧比旺训练阿纳金。','欧比旺随后击败对手,但托付已经落下——一个尚未出师的人接过了一个委员会不愿接的孩子。','阿纳金的教养从一开始就是仓促的、被临终之言逼出来的。','雅汶战役前 33 至 32 年','published'),
('68000000-0000-4000-8001-000000000019','en','The death of Qui-Gon Jinn','Qui-Gon is run through in the duel and, dying, asks Obi-Wan to train Anakin.','Obi-Wan defeats the assassin afterwards, but the charge has already been laid: a Jedi not yet a master takes on a boy the council did not want.','Anakin’s upbringing is rushed from the first day, forced by a dying request.','c. 33–32 BBY','published'),
('68000000-0000-4000-8001-000000000020','zh-CN','欧比旺收阿纳金为徒','委员会让步,允许欧比旺训练阿纳金。','尤达明确表示不同意,但同意了——影片让制度在自己判断为危险的事上妥协。','制度看清了风险仍然放行,后来的一切都在这一步之后。','雅汶战役前 32 年','published'),
('68000000-0000-4000-8001-000000000020','en','Obi-Wan takes Anakin as his apprentice','The council relents and allows Obi-Wan to train Anakin.','Yoda says plainly that he disagrees, and consents anyway; the institution compromises on the very thing it judged dangerous.','It saw the risk clearly and let it through. Everything after follows from that.','32 BBY','published'),
('68000000-0000-4000-8001-000000000021','zh-CN','帕尔帕廷当选最高议长','纳布议员帕尔帕廷借同情票当选共和国最高议长。','影片让他在片尾以慰问者的姿态站在孩子身边——制造危机、解决危机、收取酬劳,一次完成。','危机的策划者成为危机的受益者,这一循环此后重复了二十年。','雅汶战役前 32 至 31 年','published'),
('68000000-0000-4000-8001-000000000021','en','Palpatine is elected Chancellor','Senator Palpatine of Naboo is elected Supreme Chancellor on a wave of sympathy.','The film closes with him standing beside the boy as a well-wisher: manufacture the crisis, resolve the crisis, collect the reward, all in one motion.','The author of the crisis becomes its beneficiary — a cycle repeated for the next twenty years.','c. 32–31 BBY','published');

-- ============================================================
-- 3. EVENT LOCATIONS
-- ============================================================

INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id, l.id, w.role, w.position
FROM (VALUES
  ('trade-federation-blockades-naboo','naboo','primary',0),
  ('jedi-envoys-sent-to-negotiate','naboo','primary',0),
  ('jedi-envoys-sent-to-negotiate','coruscant','origin',1),
  ('invasion-of-naboo','naboo','primary',0),
  ('jedi-reach-the-gungan-city','naboo','primary',0),
  ('queen-amidala-escapes-the-blockade','naboo','primary',0),
  ('forced-landing-on-tatooine','tatooine','primary',0),
  ('qui-gon-meets-anakin','tatooine','primary',0),
  ('the-boonta-eve-race','tatooine','primary',0),
  ('anakin-leaves-his-mother','tatooine','primary',0),
  ('first-duel-with-the-sith-assassin','tatooine','primary',0),
  ('the-senate-fails-naboo','coruscant','primary',0),
  ('vote-of-no-confidence-in-valorum','coruscant','primary',0),
  ('the-council-tests-anakin','coruscant','primary',0),
  ('amidala-returns-to-naboo','naboo','primary',0),
  ('alliance-with-the-gungans','naboo','primary',0),
  ('the-grassy-plains-diversion','naboo','primary',0),
  ('the-orbital-control-ship-destroyed','naboo','primary',0),
  ('duel-of-the-generators','naboo','primary',0),
  ('qui-gon-jinn-dies','naboo','primary',0),
  ('obi-wan-takes-anakin-as-apprentice','naboo','primary',0),
  ('palpatine-elected-chancellor','coruscant','primary',0)
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
  ('trade-federation-blockades-naboo','nute-gunray','primary',0,true),
  ('trade-federation-blockades-naboo','sheev-palpatine','participant',1,false),
  ('jedi-envoys-sent-to-negotiate','qui-gon-jinn','primary',0,true),
  ('jedi-envoys-sent-to-negotiate','obi-wan-kenobi','participant',1,false),
  ('jedi-envoys-sent-to-negotiate','finis-valorum','participant',2,false),
  ('invasion-of-naboo','nute-gunray','primary',0,true),
  ('invasion-of-naboo','padme-amidala','participant',1,false),
  ('jedi-reach-the-gungan-city','jar-jar-binks','primary',0,true),
  ('jedi-reach-the-gungan-city','qui-gon-jinn','participant',1,false),
  ('jedi-reach-the-gungan-city','boss-nass','participant',2,false),
  ('queen-amidala-escapes-the-blockade','padme-amidala','primary',0,true),
  ('queen-amidala-escapes-the-blockade','r2-d2','participant',1,false),
  ('queen-amidala-escapes-the-blockade','captain-panaka','participant',2,false),
  ('forced-landing-on-tatooine','qui-gon-jinn','primary',0,true),
  ('forced-landing-on-tatooine','padme-amidala','participant',1,false),
  ('qui-gon-meets-anakin','anakin-skywalker','primary',0,true),
  ('qui-gon-meets-anakin','qui-gon-jinn','participant',1,false),
  ('qui-gon-meets-anakin','shmi-skywalker','participant',2,false),
  ('qui-gon-meets-anakin','watto','participant',3,false),
  ('qui-gon-meets-anakin','c-3po','participant',4,false),
  ('the-boonta-eve-race','anakin-skywalker','primary',0,true),
  ('the-boonta-eve-race','watto','participant',1,false),
  ('the-boonta-eve-race','qui-gon-jinn','participant',2,false),
  ('anakin-leaves-his-mother','anakin-skywalker','primary',0,true),
  ('anakin-leaves-his-mother','shmi-skywalker','participant',1,false),
  ('first-duel-with-the-sith-assassin','darth-maul','primary',0,true),
  ('first-duel-with-the-sith-assassin','qui-gon-jinn','participant',1,false),
  ('the-senate-fails-naboo','padme-amidala','primary',0,true),
  ('the-senate-fails-naboo','finis-valorum','participant',1,false),
  ('the-senate-fails-naboo','sheev-palpatine','participant',2,false),
  ('vote-of-no-confidence-in-valorum','padme-amidala','primary',0,true),
  ('vote-of-no-confidence-in-valorum','finis-valorum','participant',1,false),
  ('vote-of-no-confidence-in-valorum','sheev-palpatine','participant',2,false),
  ('the-council-tests-anakin','anakin-skywalker','primary',0,true),
  ('the-council-tests-anakin','yoda','participant',1,false),
  ('the-council-tests-anakin','mace-windu','participant',2,false),
  ('the-council-tests-anakin','ki-adi-mundi','participant',3,false),
  ('amidala-returns-to-naboo','padme-amidala','primary',0,true),
  ('amidala-returns-to-naboo','qui-gon-jinn','participant',1,false),
  ('alliance-with-the-gungans','padme-amidala','primary',0,true),
  ('alliance-with-the-gungans','boss-nass','participant',1,false),
  ('alliance-with-the-gungans','jar-jar-binks','participant',2,false),
  ('the-grassy-plains-diversion','jar-jar-binks','primary',0,true),
  ('the-grassy-plains-diversion','boss-nass','participant',1,false),
  ('the-orbital-control-ship-destroyed','anakin-skywalker','primary',0,true),
  ('the-orbital-control-ship-destroyed','r2-d2','participant',1,false),
  ('duel-of-the-generators','darth-maul','primary',0,true),
  ('duel-of-the-generators','qui-gon-jinn','participant',1,false),
  ('duel-of-the-generators','obi-wan-kenobi','participant',2,false),
  ('qui-gon-jinn-dies','qui-gon-jinn','primary',0,true),
  ('qui-gon-jinn-dies','obi-wan-kenobi','participant',1,false),
  ('qui-gon-jinn-dies','darth-maul','participant',2,false),
  ('obi-wan-takes-anakin-as-apprentice','obi-wan-kenobi','primary',0,true),
  ('obi-wan-takes-anakin-as-apprentice','anakin-skywalker','participant',1,false),
  ('obi-wan-takes-anakin-as-apprentice','yoda','participant',2,false),
  ('palpatine-elected-chancellor','sheev-palpatine','primary',0,true),
  ('palpatine-elected-chancellor','padme-amidala','participant',1,false)
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
JOIN sources s ON s.work_id='10000000-0000-4000-8000-000000000008' AND s.title='Episode I: The Phantom Menace (1999 film)'
WHERE e.id::text LIKE '68000000-0000-4000-8001%'
ON CONFLICT DO NOTHING;

-- ============================================================
-- 6. RELATIONS
-- ============================================================

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT w.id::uuid, '10000000-0000-4000-8000-000000000008', f.id, t.id, w.relation_type, w.direction::relationship_direction, w.sentiment::relationship_sentiment, w.strength, w.status::relationship_status, NULL, NULL
FROM (VALUES
  ('78000000-0000-4000-8001-000000000001','shmi-skywalker','anakin-skywalker','family','bidirectional','positive',5,'ended'),
  ('78000000-0000-4000-8001-000000000002','qui-gon-jinn','obi-wan-kenobi','mentor','source_to_target','positive',5,'ended'),
  ('78000000-0000-4000-8001-000000000003','qui-gon-jinn','anakin-skywalker','mentor','source_to_target','positive',4,'ended'),
  ('78000000-0000-4000-8001-000000000004','sheev-palpatine','darth-maul','mentor','source_to_target','negative',4,'ended'),
  ('78000000-0000-4000-8001-000000000005','darth-maul','qui-gon-jinn','adversary','bidirectional','negative',5,'ended'),
  ('78000000-0000-4000-8001-000000000006','nute-gunray','padme-amidala','adversary','bidirectional','negative',4,'ended'),
  ('78000000-0000-4000-8001-000000000007','sheev-palpatine','nute-gunray','liege','source_to_target','negative',3,'ended'),
  ('78000000-0000-4000-8001-000000000008','sheev-palpatine','finis-valorum','adversary','source_to_target','negative',4,'ended'),
  ('78000000-0000-4000-8001-000000000009','padme-amidala','jar-jar-binks','ally','bidirectional','positive',3,'active'),
  ('78000000-0000-4000-8001-000000000010','boss-nass','padme-amidala','ally','bidirectional','mixed',3,'active'),
  ('78000000-0000-4000-8001-000000000011','watto','shmi-skywalker','adversary','source_to_target','negative',3,'ended'),
  ('78000000-0000-4000-8001-000000000012','captain-panaka','padme-amidala','liege','source_to_target','positive',3,'ended'),
  ('78000000-0000-4000-8001-000000000013','r2-d2','c-3po','ally','bidirectional','positive',5,'active'),
  ('78000000-0000-4000-8001-000000000014','anakin-skywalker','c-3po','other','source_to_target','positive',3,'active'),
  ('78000000-0000-4000-8001-000000000015','anakin-skywalker','padme-amidala','other','bidirectional','positive',3,'changed'),
  ('78000000-0000-4000-8001-000000000016','ki-adi-mundi','anakin-skywalker','adversary','source_to_target','mixed',2,'ended')
) AS w(id, from_slug, to_slug, relation_type, direction, sentiment, strength, status)
JOIN characters f ON f.work_id='10000000-0000-4000-8000-000000000008' AND f.slug=w.from_slug
JOIN characters t ON t.work_id='10000000-0000-4000-8000-000000000008' AND t.slug=w.to_slug
ON CONFLICT DO NOTHING;

INSERT INTO relation_translations(relation_id,locale,label,summary,status) VALUES
('78000000-0000-4000-8001-000000000001','zh-CN','母子(施密→阿纳金)','留在塔图因的母亲与被带走的儿子;这段没能了结的牵挂贯穿他的一生。','published'),
('78000000-0000-4000-8001-000000000001','en','Mother and son (Shmi → Anakin)','A mother left behind on Tatooine and a son taken away; the unfinished attachment shapes the rest of his life.','published'),
('78000000-0000-4000-8001-000000000002','zh-CN','师徒(魁刚→欧比旺)','受训将满的学徒与不合委员会口味的师父。','published'),
('78000000-0000-4000-8001-000000000002','en','Master and apprentice (Qui-Gon → Obi-Wan)','An apprentice near the end of his training, under a master the council finds difficult.','published'),
('78000000-0000-4000-8001-000000000003','zh-CN','未及授业的师徒(魁刚→阿纳金)','魁刚认定他该受训,却在训练开始前就死了。','published'),
('78000000-0000-4000-8001-000000000003','en','A teaching never begun (Qui-Gon → Anakin)','Qui-Gon judged the boy should be trained and died before the training started.','published'),
('78000000-0000-4000-8001-000000000004','zh-CN','西斯师徒(西迪厄斯→摩尔)','用完即弃的第一个学徒。','published'),
('78000000-0000-4000-8001-000000000004','en','Sith master and apprentice (Sidious → Maul)','The first apprentice, and the first to be spent.','published'),
('78000000-0000-4000-8001-000000000005','zh-CN','刺客与目标(摩尔↔魁刚)','两次交手,第二次以魁刚之死告终。','published'),
('78000000-0000-4000-8001-000000000005','en','Assassin and target (Maul ↔ Qui-Gon)','They meet twice; the second meeting ends in Qui-Gon’s death.','published'),
('78000000-0000-4000-8001-000000000006','zh-CN','占领者与被占领者(冈雷↔阿米达拉)','下令入侵纳布的人与被他俘获的女王。','published'),
('78000000-0000-4000-8001-000000000006','en','Occupier and occupied (Gunray ↔ Amidala)','The man who ordered the invasion and the queen he took prisoner.','published'),
('78000000-0000-4000-8001-000000000007','zh-CN','幕后主使与替罪人(西迪厄斯→冈雷)','下达指令的人与将来要顶罪的人。','published'),
('78000000-0000-4000-8001-000000000007','en','Handler and fall guy (Sidious → Gunray)','The one who gives the orders and the one who will be left to answer for them.','published'),
('78000000-0000-4000-8001-000000000008','zh-CN','继任者与被罢免者(帕尔帕廷→瓦洛伦)','靠一场自己制造的危机取代了前任。','published'),
('78000000-0000-4000-8001-000000000008','en','Successor and unseated (Palpatine → Valorum)','He replaces his predecessor by means of a crisis he arranged.','published'),
('78000000-0000-4000-8001-000000000009','zh-CN','女王与被放逐者(阿米达拉↔加·加)','她收留了本族不要的人,后来把他送进了议会。','published'),
('78000000-0000-4000-8001-000000000009','en','Queen and exile (Amidala ↔ Jar Jar)','She takes in the man his own people cast out, and later sends him to the senate.','published'),
('78000000-0000-4000-8001-000000000010','zh-CN','两族首领(纳斯↔阿米达拉)','从互不往来到并肩作战,起于她的一次下跪。','published'),
('78000000-0000-4000-8001-000000000010','en','Two peoples’ leaders (Nass ↔ Amidala)','From refusing to deal with each other to fighting together, on the strength of her kneeling.','published'),
('78000000-0000-4000-8001-000000000011','zh-CN','奴隶主与奴隶(瓦托→施密)','赌输了男孩,留下了母亲。','published'),
('78000000-0000-4000-8001-000000000011','en','Owner and slave (Watto → Shmi)','He gambles away the boy and keeps the mother.','published'),
('78000000-0000-4000-8001-000000000012','zh-CN','卫队长与女王(帕纳卡→阿米达拉)','负责保护一个不肯待在安全处的君主。','published'),
('78000000-0000-4000-8001-000000000012','en','Guard captain and queen (Panaka → Amidala)','Charged with protecting a monarch who will not stay protected.','published'),
('78000000-0000-4000-8001-000000000013','zh-CN','搭档(R2-D2↔C-3PO)','贯穿九部曲的一对,谁也没能把对方甩掉。','published'),
('78000000-0000-4000-8001-000000000013','en','Partners (R2-D2 ↔ C-3PO)','The pair that runs through all nine films; neither ever manages to be rid of the other.','published'),
('78000000-0000-4000-8001-000000000014','zh-CN','制造者与造物(阿纳金→C-3PO)','少年时用废件组装的机器人,日后被他的女儿再次用上。','published'),
('78000000-0000-4000-8001-000000000014','en','Maker and made (Anakin → C-3PO)','A droid built from scrap by a boy, and put to use again by his daughter.','published'),
('78000000-0000-4000-8001-000000000015','zh-CN','初遇(阿纳金↔帕德梅)','九岁的男孩与年轻的女王;十年后重逢时性质彻底改变。','published'),
('78000000-0000-4000-8001-000000000015','en','First meeting (Anakin ↔ Padmé)','A boy of nine and a young queen; ten years later the nature of it has entirely changed.','published'),
('78000000-0000-4000-8001-000000000016','zh-CN','考核者与被拒者(穆迪→阿纳金)','委员会以「心中有恐惧」为由拒绝收训。','published'),
('78000000-0000-4000-8001-000000000016','en','Examiner and refused (Mundi → Anakin)','The council declines to train him on the grounds that there is fear in him.','published')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 7. GROUP MEMBERSHIP
-- ============================================================

INSERT INTO character_group_members(group_id,character_id,membership_role)
SELECT g.id, c.id, w.membership_role
FROM (VALUES
  ('jedi-order','ki-adi-mundi','council member'),
  ('galactic-republic','finis-valorum','supreme chancellor, removed'),
  ('galactic-republic','jar-jar-binks','representative for Naboo'),
  ('separatist-alliance','nute-gunray','Trade Federation viceroy'),
  ('naboo-royal-house','captain-panaka','captain of the royal guard'),
  ('naboo-royal-house','boss-nass','Gungan leader, allied'),
  ('naboo-royal-house','jar-jar-binks','Gungan representative'),
  ('house-of-skywalker','shmi-skywalker','mother of Anakin'),
  ('house-of-skywalker','r2-d2','constant companion'),
  ('house-of-skywalker','c-3po','built by Anakin'),
  ('smugglers-and-outlaws','watto','parts dealer and slave owner'),
  ('the-resistance','r2-d2','crew'),
  ('the-resistance','c-3po','crew'),
  ('rebel-alliance','r2-d2','crew'),
  ('rebel-alliance','c-3po','crew')
) AS w(group_slug, character_slug, membership_role)
JOIN character_groups g ON g.work_id='10000000-0000-4000-8000-000000000008' AND g.slug=w.group_slug
JOIN characters c ON c.work_id='10000000-0000-4000-8000-000000000008' AND c.slug=w.character_slug
ON CONFLICT DO NOTHING;

COMMIT;
