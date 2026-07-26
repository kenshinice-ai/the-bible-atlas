BEGIN;

-- =========================================================================
-- 021_bible_full_12_acts.sql
-- Chapter K=12 slug='acts' (Acts 1-12, the early church in Jerusalem,
-- Judea, Samaria, and Antioch, c. 30-46 CE).
-- Adds 9 characters, 18 new events, 8 relations, and reorders the six
-- pre-existing acts events into the 12001-12999 sequence band.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('43000000-0000-4000-8012-000000000001','10000000-0000-4000-8000-000000000005','matthias',1200,'male','adult','supporting','unknown',NULL,NULL,'disciple',2),
('43000000-0000-4000-8012-000000000002','10000000-0000-4000-8000-000000000005','ananias-of-jerusalem',1201,'male','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8012-000000000003','10000000-0000-4000-8000-000000000005','sapphira',1202,'female','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8012-000000000004','10000000-0000-4000-8000-000000000005','gamaliel',1203,'male','elder','supporting','historical',NULL,NULL,'teacher',2),
('43000000-0000-4000-8012-000000000005','10000000-0000-4000-8000-000000000005','philip-the-evangelist',1204,'male','adult','supporting','unknown',NULL,NULL,'missionary',3),
('43000000-0000-4000-8012-000000000006','10000000-0000-4000-8000-000000000005','ethiopian-eunuch',1205,'male','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8012-000000000007','10000000-0000-4000-8000-000000000005','ananias-of-damascus',1206,'male','adult','supporting','unknown',NULL,NULL,'disciple',2),
('43000000-0000-4000-8012-000000000008','10000000-0000-4000-8000-000000000005','tabitha',1207,'female','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8012-000000000009','10000000-0000-4000-8000-000000000005','herod-agrippa-i',1208,'male','adult','antagonist','historical',-10,44,'king',3)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('matthias','zh-CN','马提亚','被抽签选出、递补犹大空缺的使徒。',ARRAY[]::text[],'从耶稣受洗到升天期间一直跟随的门徒之一，经祷告与抽签被立为第十二位使徒。','与十一使徒一同作复活的见证。'),
('matthias','en','Matthias','The apostle chosen by lot to fill the place left by Judas.',ARRAY[]::text[],'A follower of Jesus from the baptism of John until the ascension, he is appointed the twelfth apostle after prayer and the casting of lots.','To stand with the eleven as a witness of the resurrection.'),
('ananias-of-jerusalem','zh-CN','亚拿尼亚（耶路撒冷）','变卖田产却私留价银、在彼得面前仆倒而死的信徒。',ARRAY[]::text[],'与妻子撒非喇同谋，把田产价银私自留下几分，却谎称全数奉献，被彼得指出欺哄圣灵后仆倒断气。','既想得慷慨之名，又舍不得全部财物。'),
('ananias-of-jerusalem','en','Ananias (of Jerusalem)','A believer who kept back part of the price of his land and fell dead before Peter.',ARRAY[]::text[],'Conspiring with his wife Sapphira, he withholds part of the proceeds of a sale while claiming to give all, and falls dead when Peter exposes the lie.','To gain a reputation for generosity without giving up everything.'),
('sapphira','zh-CN','撒非喇','亚拿尼亚的妻子，附和丈夫的谎言，同样仆倒而死。',ARRAY[]::text[],'在丈夫死后约三小时进来，仍坚称价银如数交出，随即仆倒在彼得脚前断气。','与丈夫同守隐瞒价银的约定。'),
('sapphira','en','Sapphira','Ananias’s wife, who repeated her husband’s lie and likewise fell dead.',ARRAY[]::text[],'Coming in about three hours after her husband’s death, she maintains that the full price was given, and falls dead at Peter’s feet.','To keep the agreement she had made with her husband.'),
('gamaliel','zh-CN','迦玛列','公会中受众人敬重的律法教师，主张宽待使徒。',ARRAY[]::text[],'法利赛人中的名师，在公会审问使徒时进言：若这事出于人必要败坏，若出于神就无法败坏。','谨慎行事，免得与神为敌。'),
('gamaliel','en','Gamaliel','A teacher of the law honored in the council, who urged restraint toward the apostles.',ARRAY[]::text[],'A respected Pharisee who counsels the Sanhedrin that if the movement is of human origin it will fail, but if it is of God it cannot be overthrown.','Caution, lest the council be found opposing God.'),
('philip-the-evangelist','zh-CN','腓利（传福音的）','七执事之一，把福音传到撒玛利亚并为埃提阿伯太监施洗。',ARRAY[]::text[],'被选出管理供给的七人之一，逼迫兴起后下撒玛利亚城传道行神迹，又在旷野路上向太监讲解以赛亚书并为他施洗。','把福音传到耶路撒冷以外的人群。'),
('philip-the-evangelist','en','Philip the Evangelist','One of the seven, who carried the message to Samaria and baptized the Ethiopian eunuch.',ARRAY[]::text[],'Chosen among the seven to serve tables, he preaches and works signs in Samaria after the persecution, then explains Isaiah to the eunuch on the desert road and baptizes him.','To carry the message beyond Jerusalem.'),
('ethiopian-eunuch','zh-CN','埃提阿伯太监','埃提阿伯女王干大基的银库总管，在旷野路上受洗。',ARRAY[]::text[],'上耶路撒冷礼拜后回程，坐在车上诵读以赛亚书，经腓利讲解后在路旁的水里受了洗，欢欢喜喜地走路。','明白所诵读的经文并寻求敬拜。'),
('ethiopian-eunuch','en','The Ethiopian eunuch','The treasurer of Candace, queen of the Ethiopians, baptized on the desert road.',ARRAY[]::text[],'Returning from worship in Jerusalem, he reads Isaiah in his chariot; after Philip explains the passage he is baptized in water beside the road and goes on his way rejoicing.','To understand the scripture he was reading and to worship.'),
('ananias-of-damascus','zh-CN','亚拿尼亚（大马士革）','大马士革的门徒，奉异象指示为扫罗按手使他复明。',ARRAY[]::text[],'在异象中蒙指示往直街去找扫罗，虽知扫罗曾残害圣徒，仍称他为弟兄，为他按手使他复明并施洗。','顺从异象中的差遣，接纳昔日的逼迫者。'),
('ananias-of-damascus','en','Ananias (of Damascus)','A disciple in Damascus sent by a vision to lay hands on Saul and restore his sight.',ARRAY[]::text[],'Directed in a vision to the street called Straight, he greets the former persecutor as “Brother Saul,” lays hands on him so that his sight returns, and baptizes him.','Obedience to the vision, and welcome for a former persecutor.'),
('tabitha','zh-CN','大比大（多加）','约帕的女门徒，广行善事，死后被彼得使她复活。',ARRAY[]::text[],'希腊名多加，素来多行善事、周济穷人，患病而死后，彼得在楼上祷告，吩咐她起来，她便睁眼坐起。','以针线与善行周济寡妇和穷人。'),
('tabitha','en','Tabitha (Dorcas)','A disciple at Joppa full of good works, raised to life by Peter.',ARRAY[]::text[],'Known in Greek as Dorcas, she is devoted to good works and charity; after she falls ill and dies, Peter prays in the upper room, tells her to rise, and she opens her eyes and sits up.','To clothe and care for the widows and the poor.'),
('herod-agrippa-i','zh-CN','希律亚基帕一世','杀害使徒雅各、囚禁彼得的犹太王，在凯撒利亚暴毙。',ARRAY[]::text[],'大希律之孙，为讨犹太人喜悦而用刀杀了约翰的哥哥雅各，又捉拿彼得下监；后在凯撒利亚受众人称颂为神，不归荣耀给神，被虫咬而死。','讨百姓喜悦以巩固王位。'),
('herod-agrippa-i','en','Herod Agrippa I','The king of Judea who killed the apostle James, imprisoned Peter, and died suddenly at Caesarea.',ARRAY[]::text[],'A grandson of Herod the Great, he kills James the brother of John to please the people and arrests Peter; later at Caesarea, acclaimed as a god and giving no glory to God, he is struck down and dies.','To please the people and secure his throne.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. LOCATIONS -- no new locations; this era reuses jerusalem,
--    samaria-sebaste, gaza, damascus, joppa, caesarea-maritima,
--    antioch-orontes (all created by earlier seeds).
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- 3. EVENTS (new) -- range dating within 30-46 CE, chapter 'acts'
-- -------------------------------------------------------------------------
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('63000000-0000-4000-8012-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'unknown'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'matthias-chosen-by-lot',12001,'reported_historical','religious','range',30,33,'low','acts'),
(2,'peter-preaches-at-pentecost',12005,'reported_historical','religious','range',30,33,'low','acts'),
(3,'believers-hold-all-things-common',12007,'reported_historical','social','range',30,34,'low','acts'),
(4,'lame-man-healed-at-beautiful-gate',12009,'legendary_or_mythic','religious','range',30,34,'low','acts'),
(5,'peter-and-john-before-the-sanhedrin',12011,'reported_historical','trial','range',30,34,'low','acts'),
(6,'ananias-and-sapphira-fall-dead',12013,'legendary_or_mythic','death','range',31,35,'low','acts'),
(7,'gamaliel-counsels-caution',12015,'reported_historical','political','range',31,35,'low','acts'),
(8,'seven-chosen-to-serve',12017,'reported_historical','religious','range',32,36,'low','acts'),
(9,'persecution-scatters-the-church',12021,'reported_historical','migration','range',33,36,'low','acts'),
(10,'philip-preaches-in-samaria',12023,'reported_historical','religious','range',33,38,'low','acts'),
(11,'philip-and-the-ethiopian-eunuch',12025,'legendary_or_mythic','meeting','range',33,38,'low','acts'),
(12,'saul-regains-sight-and-is-baptized',12029,'legendary_or_mythic','religious','range',33,36,'low','acts'),
(13,'saul-escapes-in-a-basket',12031,'reported_historical','escape','range',35,38,'low','acts'),
(14,'barnabas-introduces-saul',12033,'reported_historical','meeting','range',35,39,'low','acts'),
(15,'tabitha-raised-at-joppa',12035,'legendary_or_mythic','religious','range',36,42,'low','acts'),
(16,'disciples-first-called-christians',12043,'reported_historical','social','range',42,46,'medium','acts'),
(17,'peter-imprisoned-and-freed-by-angel',12045,'legendary_or_mythic','escape','range',42,44,'low','acts'),
(18,'death-of-herod-agrippa',12047,'verified_historical','death','range',43,44,'high','acts')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,conf,chapter_slug)
JOIN chapters ch ON ch.slug=v.chapter_slug AND ch.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 4. Reorder existing acts events into the 12001-12999 band
-- -------------------------------------------------------------------------
UPDATE events e SET sequence=v.seq FROM (VALUES
  ('pentecost-in-jerusalem',12003),
  ('stephen-is-killed',12019),
  ('paul-conversion-damascus',12027),
  ('peters-vision-at-joppa',12037),
  ('peter-and-cornelius-at-caesarea',12039),
  ('barnabas-brings-paul-to-antioch',12041)
) AS v(slug,seq) WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug=v.slug;

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tlabel FROM events e JOIN (VALUES
('matthias-chosen-by-lot','zh-CN','抽签补选马提亚','门徒祷告后抽签，选出马提亚递补犹大留下的使徒空缺。','彼得在约一百二十名门徒中提议补选见证人，众人举出两人，祷告后抽签抽出马提亚。','使十二使徒的数目在五旬节之前恢复完整。','约公元 30–33 年'),
('matthias-chosen-by-lot','en','Matthias chosen by lot','After prayer the disciples cast lots and choose Matthias to fill Judas’s place.','Before about one hundred twenty disciples, Peter proposes a replacement witness; two men are put forward, and after prayer the lot falls on Matthias.','Restores the number of the twelve before Pentecost.','c. 30–33 CE'),
('peter-preaches-at-pentecost','zh-CN','彼得讲道，三千人受洗','五旬节圣灵降临后，彼得向众人讲道，当天约添了三千人受洗。','彼得引用约珥书与诗篇，见证耶稣复活；众人觉得扎心，问“我们当怎样行”，领受话语的人便受了洗。','耶路撒冷教会由此成形，是使徒行传叙事的第一次大增长。','约公元 30–33 年'),
('peter-preaches-at-pentecost','en','Peter preaches and three thousand are baptized','After the Spirit comes at Pentecost, Peter addresses the crowd and about three thousand are baptized that day.','Citing Joel and the Psalms, Peter bears witness to the resurrection; the hearers are cut to the heart, ask “What shall we do?”, and those who receive the word are baptized.','The Jerusalem church takes shape in the narrative’s first great increase.','c. 30–33 CE'),
('believers-hold-all-things-common','zh-CN','信徒凡物公用','初期信徒恒心遵守使徒的教训，彼此交接，凡物公用。','许多人变卖田产家业，照各人所需分给各人，天天同心合意在殿里聚会、在家中擘饼。','描绘早期教会共同生活的经典图景。','约公元 30–34 年'),
('believers-hold-all-things-common','en','The believers hold all things in common','The first believers devote themselves to the apostles’ teaching and share all they have.','Many sell possessions and distribute to each as any has need, meeting daily in the temple and breaking bread from house to house.','The classic picture of the early community’s shared life.','c. 30–34 CE'),
('lame-man-healed-at-beautiful-gate','zh-CN','美门口的瘸腿人得医治','彼得与约翰在圣殿美门口，使生来瘸腿的人起来行走。','彼得说“金银我都没有，只把我所有的给你”，那人就跳起来站着行走，与他们同进圣殿，众人满心希奇。','使徒行传记载的第一件使徒神迹，引出所罗门廊讲道与被捕。','约公元 30–34 年'),
('lame-man-healed-at-beautiful-gate','en','The lame man healed at the Beautiful Gate','At the temple’s Beautiful Gate, Peter and John make a man lame from birth stand and walk.','Peter says, “Silver and gold have I none, but what I have I give you”; the man leaps up, walks, and enters the temple with them as the people marvel.','The first apostolic sign in Acts, leading to the portico sermon and the arrest.','c. 30–34 CE'),
('peter-and-john-before-the-sanhedrin','zh-CN','彼得约翰被捕与公会警告','彼得与约翰因传讲复活被捉拿，公会禁止他们奉耶稣的名讲论。','官长见二人原是没有学问的小民而希奇；二人答“听从你们不听从神，是合理不合理”，公会恐吓一番后释放了他们。','确立了叙事中“顺从神不顺从人”的基调。','约公元 30–34 年'),
('peter-and-john-before-the-sanhedrin','en','Peter and John before the Sanhedrin','Arrested for preaching the resurrection, Peter and John are ordered not to speak in Jesus’s name.','The rulers marvel that the two are uneducated, common men; they answer, “Judge whether it is right to listen to you rather than to God,” and are threatened and released.','Sets the narrative’s keynote of obeying God rather than men.','c. 30–34 CE'),
('ananias-and-sapphira-fall-dead','zh-CN','亚拿尼亚与撒非喇仆倒而死','夫妇二人私留田价却谎称全数奉献，先后在彼得面前仆倒断气。','彼得指出他们不是欺哄人，是欺哄圣灵；三小时后撒非喇进来仍坚持谎言，也仆倒在彼得脚前，全教会都甚惧怕。','以严厉的笔调标示共同体内诚实的界线。','约公元 31–35 年'),
('ananias-and-sapphira-fall-dead','en','Ananias and Sapphira fall dead','A couple keep back part of the price of their land while claiming to give all, and each falls dead before Peter.','Peter declares they have lied not to men but to the Spirit; three hours later Sapphira repeats the lie and falls at his feet, and great fear comes upon the church.','Marks, in stark terms, the boundary of honesty within the community.','c. 31–35 CE'),
('gamaliel-counsels-caution','zh-CN','迦玛列进言','使徒再次受审时，教法师迦玛列劝公会任凭他们，免得攻击神。','他举丢大与加利利的犹大为例：出于人的终必败坏，出于神的无法败坏。公会采纳其言，打了使徒便释放了。','为使徒赢得喘息之机，也留下著名的审慎格言。','约公元 31–35 年'),
('gamaliel-counsels-caution','en','Gamaliel counsels caution','When the apostles are tried again, the teacher Gamaliel urges the council to leave them alone lest it fight against God.','Citing Theudas and Judas the Galilean, he argues that what is of human origin fails, but what is of God cannot be overthrown; the council flogs the apostles and releases them.','Wins the apostles a reprieve and leaves a famous maxim of restraint.','c. 31–35 CE'),
('seven-chosen-to-serve','zh-CN','拣选七位执事','为平息供给上的怨言，门徒选出司提反、腓利等七人管理饭食。','说希腊话的门徒埋怨寡妇在供给上被忽略，十二使徒召集众人，选出七位有好名声、被圣灵充满的人，按手立他们。','教会的第一次职分分工，司提反与腓利由此登场。','约公元 32–36 年'),
('seven-chosen-to-serve','en','Seven chosen to serve','To settle a complaint over the daily distribution, the disciples choose Stephen, Philip, and five others to serve tables.','The Hellenists complain that their widows are neglected; the twelve gather the community, and seven men of good repute, full of the Spirit, are chosen and commissioned with laying on of hands.','The church’s first division of ministry, introducing Stephen and Philip.','c. 32–36 CE'),
('persecution-scatters-the-church','zh-CN','大逼迫使门徒四散','司提反殉道后，耶路撒冷的教会大遭逼迫，门徒分散到犹太和撒玛利亚各处。','扫罗残害教会，进各人的家拉着男女下在监里；四散的门徒却往各处去传道。','逼迫反而把福音推出耶路撒冷，是叙事地理扩展的转折点。','约公元 33–36 年'),
('persecution-scatters-the-church','en','Persecution scatters the church','After Stephen’s death a great persecution scatters the disciples through Judea and Samaria.','Saul ravages the church, entering house after house and dragging off men and women to prison; yet those scattered go about preaching the word.','The persecution pushes the message beyond Jerusalem, a turning point in the narrative’s geography.','c. 33–36 CE'),
('philip-preaches-in-samaria','zh-CN','腓利在撒玛利亚传道','腓利下撒玛利亚城宣讲基督，行神迹，城里大有欢喜。','污鬼被赶出，瘫痪的、瘸腿的得医治，众人受洗；彼得与约翰随后下来为他们按手，使他们受圣灵。','福音第一次越过犹太与撒玛利亚之间的隔阂。','约公元 33–38 年'),
('philip-preaches-in-samaria','en','Philip preaches in Samaria','Philip goes down to a city of Samaria, proclaims the Messiah, and works signs, bringing great joy.','Unclean spirits are cast out and the paralyzed and lame are healed; many are baptized, and Peter and John later come down and lay hands on them to receive the Spirit.','The message crosses for the first time the divide between Judea and Samaria.','c. 33–38 CE'),
('philip-and-the-ethiopian-eunuch','zh-CN','旷野路上遇埃提阿伯太监','腓利奉指示走往迦萨的旷野路，为诵读以赛亚书的太监讲解并施洗。','太监正读“他像羊被牵到宰杀之地”，问这话是指着谁说的；腓利从这经上起讲耶稣，到了有水的地方太监便受了洗。','福音临到远方外邦人的经典场景。','约公元 33–38 年'),
('philip-and-the-ethiopian-eunuch','en','Philip and the Ethiopian eunuch on the desert road','Sent to the desert road toward Gaza, Philip explains Isaiah to the eunuch and baptizes him.','The eunuch is reading “like a sheep led to the slaughter” and asks of whom the prophet speaks; beginning with that scripture Philip tells him of Jesus, and at water beside the road the eunuch is baptized.','A classic scene of the message reaching a distant Gentile.','c. 33–38 CE'),
('saul-regains-sight-and-is-baptized','zh-CN','亚拿尼亚按手，扫罗复明受洗','大马士革的门徒亚拿尼亚为扫罗按手，他眼上的鳞片脱落，就复明受洗。','扫罗三日不能看见，也不吃不喝；亚拿尼亚奉异象指示前来，称他“扫罗弟兄”，他随即起来受洗，与门徒同住。','逼迫者转变为传道者的关键一幕。','约公元 33–36 年'),
('saul-regains-sight-and-is-baptized','en','Saul regains his sight and is baptized','Ananias of Damascus lays hands on Saul; something like scales falls from his eyes, and he is baptized.','Blind for three days, neither eating nor drinking, Saul is greeted as “Brother Saul” by Ananias, sent in a vision; his sight returns at once and he rises and is baptized.','The decisive scene in the persecutor’s turn to preacher.','c. 33–36 CE'),
('saul-escapes-in-a-basket','zh-CN','筐子缒城逃走','犹太人昼夜守门要杀扫罗，门徒夜间用筐子把他从城墙上缒下去。','扫罗在大马士革放胆传道，驳倒众人，招来杀身之谋；他的门徒趁夜将他缒出城外，他便逃往耶路撒冷。','扫罗漫长逃亡与宣教生涯中第一次死里逃生。','约公元 35–38 年'),
('saul-escapes-in-a-basket','en','Saul escapes in a basket','With the gates watched day and night by those seeking his life, Saul is lowered from the Damascus wall in a basket.','His bold preaching in Damascus confounds his hearers and provokes a plot; his disciples let him down through the wall by night, and he makes for Jerusalem.','The first narrow escape in Saul’s long career of flight and mission.','c. 35–38 CE'),
('barnabas-introduces-saul','zh-CN','巴拿巴引荐扫罗','耶路撒冷的门徒惧怕扫罗，巴拿巴接待他，领他去见使徒。','门徒不信扫罗是门徒，巴拿巴述说他路上怎样看见主、在大马士革怎样放胆传道，扫罗遂与门徒出入来往。','巴拿巴的担保使扫罗被教会接纳，为日后同工埋下伏笔。','约公元 35–39 年'),
('barnabas-introduces-saul','en','Barnabas introduces Saul','When the Jerusalem disciples fear Saul, Barnabas takes him and brings him to the apostles.','The disciples do not believe Saul is one of them; Barnabas recounts how he saw the Lord on the road and preached boldly at Damascus, and Saul then moves freely among them.','Barnabas’s vouching wins Saul the church’s welcome, foreshadowing their later partnership.','c. 35–39 CE'),
('tabitha-raised-at-joppa','zh-CN','大比大在约帕复活','彼得在约帕为病死的女门徒大比大祷告，吩咐她起来，她就复活。','寡妇们拿着多加所做的衣裳哭着围立；彼得跪下祷告，说“大比大，起来”，她睁眼见彼得便坐了起来，此事传遍约帕。','使徒行传中彼得所行最著名的神迹之一。','约公元 36–42 年'),
('tabitha-raised-at-joppa','en','Tabitha raised at Joppa','At Joppa Peter prays over the dead disciple Tabitha, tells her to rise, and she lives.','Widows stand weeping with the garments Dorcas made; Peter kneels, prays, and says “Tabitha, arise”; she opens her eyes, sees him, and sits up, and the news spreads through Joppa.','One of the most famous of Peter’s signs in Acts.','c. 36–42 CE'),
('disciples-first-called-christians','zh-CN','门徒在安提阿始称基督徒','巴拿巴与扫罗在安提阿教导多人，门徒在此第一次被称为基督徒。','二人在安提阿教会同工一年，教训了许多人；“基督徒”这一称呼从这座外邦大城开始流传。','标志一个可辨识的新群体在帝国视野中出现。','约公元 42–46 年'),
('disciples-first-called-christians','en','The disciples first called Christians','As Barnabas and Saul teach many in Antioch, the disciples are there first called Christians.','For a year the two work together in the Antioch church and teach a great many people; the name “Christian” begins in this great Gentile city.','Marks the emergence of a recognizable new community in the empire’s eyes.','c. 42–46 CE'),
('peter-imprisoned-and-freed-by-angel','zh-CN','彼得下监，天使救出','希律亚基帕捉拿彼得下监，天使夜间领他出了监门。','教会为彼得切切祷告；铁链脱落，监门自开，彼得来到门徒聚集祷告的屋子叩门，众人惊喜不已。','逼迫高峰中的著名获救场景，与希律的结局形成对照。','约公元 42–44 年'),
('peter-imprisoned-and-freed-by-angel','en','Peter imprisoned and freed by an angel','Herod Agrippa imprisons Peter, and by night an angel leads him out through the prison gates.','While the church prays earnestly, the chains fall from Peter’s hands and the iron gate opens of itself; he knocks at the house where the disciples are praying, to their astonished joy.','A famous deliverance at the height of the persecution, set against Herod’s own end.','c. 42–44 CE'),
('death-of-herod-agrippa','zh-CN','希律亚基帕在凯撒利亚暴毙','希律在凯撒利亚受众人呼为神，不归荣耀给神，随即暴病而死。','他穿朝服坐在位上讲论，百姓喊“这是神的声音，不是人的声音”；他被虫所咬，气就绝了。约瑟夫的记载与此大体呼应。','叙事以逼迫者的骤逝作结，“神的道日见兴旺，越发广传”。','约公元 43–44 年'),
('death-of-herod-agrippa','en','Death of Herod Agrippa at Caesarea','Acclaimed as a god at Caesarea and giving no glory to God, Herod is struck down and dies.','Seated in royal robes and delivering an oration, he hears the people cry “The voice of a god, and not of a man”; he is eaten by worms and dies. Josephus’s account broadly corroborates the scene.','The narrative closes the persecution with the persecutor’s sudden end, while “the word of God grew and multiplied.”','c. 43–44 CE')
) AS v(slug,locale,title,summary,detail,sig,tlabel) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS (all reused locations)
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('matthias-chosen-by-lot','jerusalem'),
('peter-preaches-at-pentecost','jerusalem'),
('believers-hold-all-things-common','jerusalem'),
('lame-man-healed-at-beautiful-gate','jerusalem'),
('peter-and-john-before-the-sanhedrin','jerusalem'),
('ananias-and-sapphira-fall-dead','jerusalem'),
('gamaliel-counsels-caution','jerusalem'),
('seven-chosen-to-serve','jerusalem'),
('persecution-scatters-the-church','jerusalem'),
('philip-preaches-in-samaria','samaria-sebaste'),
('philip-and-the-ethiopian-eunuch','gaza'),
('saul-regains-sight-and-is-baptized','damascus'),
('saul-escapes-in-a-basket','damascus'),
('barnabas-introduces-saul','jerusalem'),
('tabitha-raised-at-joppa','joppa'),
('disciples-first-called-christians','antioch-orontes'),
('peter-imprisoned-and-freed-by-angel','jerusalem'),
('death-of-herod-agrippa','caesarea-maritima')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS
--    (caiaphas / annas belong to era 11 'gospels'; when testing this file
--    alone those rows are silently dropped -- expected.)
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('matthias-chosen-by-lot','matthias',0),('matthias-chosen-by-lot','peter',1),
('peter-preaches-at-pentecost','peter',0),('peter-preaches-at-pentecost','john-son-of-zebedee',1),
('believers-hold-all-things-common','peter',0),('believers-hold-all-things-common','barnabas',1),
('lame-man-healed-at-beautiful-gate','peter',0),('lame-man-healed-at-beautiful-gate','john-son-of-zebedee',1),
('peter-and-john-before-the-sanhedrin','peter',0),('peter-and-john-before-the-sanhedrin','john-son-of-zebedee',1),('peter-and-john-before-the-sanhedrin','caiaphas',2),('peter-and-john-before-the-sanhedrin','annas',3),
('ananias-and-sapphira-fall-dead','ananias-of-jerusalem',0),('ananias-and-sapphira-fall-dead','sapphira',1),('ananias-and-sapphira-fall-dead','peter',2),
('gamaliel-counsels-caution','gamaliel',0),('gamaliel-counsels-caution','peter',1),
('seven-chosen-to-serve','stephen',0),('seven-chosen-to-serve','philip-the-evangelist',1),('seven-chosen-to-serve','peter',2),
('persecution-scatters-the-church','paul',0),('persecution-scatters-the-church','philip-the-evangelist',1),
('philip-preaches-in-samaria','philip-the-evangelist',0),('philip-preaches-in-samaria','peter',1),('philip-preaches-in-samaria','john-son-of-zebedee',2),
('philip-and-the-ethiopian-eunuch','philip-the-evangelist',0),('philip-and-the-ethiopian-eunuch','ethiopian-eunuch',1),
('saul-regains-sight-and-is-baptized','paul',0),('saul-regains-sight-and-is-baptized','ananias-of-damascus',1),
('saul-escapes-in-a-basket','paul',0),
('barnabas-introduces-saul','barnabas',0),('barnabas-introduces-saul','paul',1),('barnabas-introduces-saul','peter',2),
('tabitha-raised-at-joppa','tabitha',0),('tabitha-raised-at-joppa','peter',1),
('disciples-first-called-christians','barnabas',0),('disciples-first-called-christians','paul',1),
('peter-imprisoned-and-freed-by-angel','peter',0),('peter-imprisoned-and-freed-by-angel','herod-agrippa-i',1),
('death-of-herod-agrippa','herod-agrippa-i',0)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES (all new events map to Acts of the Apostles)
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Acts of the Apostles'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.id::text LIKE '63000000-0000-4000-8012%'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS
-- -------------------------------------------------------------------------
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('73000000-0000-4000-8012-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'ananias-of-jerusalem','sapphira','spouse','bidirectional','mixed',3,'ended',NULL,'ananias-and-sapphira-fall-dead'),
(2,'peter','matthias','ally','bidirectional','positive',2,'active','matthias-chosen-by-lot',NULL),
(3,'gamaliel','paul','mentor','source_to_target','neutral',3,'changed',NULL,NULL),
(4,'ananias-of-damascus','paul','mentor','source_to_target','positive',3,'ended','saul-regains-sight-and-is-baptized',NULL),
(5,'philip-the-evangelist','ethiopian-eunuch','mentor','source_to_target','positive',3,'ended','philip-and-the-ethiopian-eunuch',NULL),
(6,'peter','tabitha','other','source_to_target','positive',2,'ended','tabitha-raised-at-joppa',NULL),
(7,'herod-agrippa-i','peter','adversary','source_to_target','negative',3,'ended','peter-imprisoned-and-freed-by-angel','death-of-herod-agrippa'),
(8,'herod-the-great','herod-agrippa-i','family','source_to_target','neutral',2,'unknown',NULL,NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000005'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 10. GROUP MEMBERSHIP (existing groups galilean-disciples, roman-authorities)
-- -------------------------------------------------------------------------
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g JOIN (VALUES
('galilean-disciples','matthias'),('galilean-disciples','philip-the-evangelist'),
('galilean-disciples','tabitha'),('galilean-disciples','ananias-of-damascus'),
('roman-authorities','herod-agrippa-i')
) AS v(gslug,cslug)
ON g.slug=v.gslug JOIN characters c ON c.slug=v.cslug AND c.work_id=g.work_id
WHERE g.work_id='10000000-0000-4000-8000-000000000005' ON CONFLICT DO NOTHING;

COMMIT;
