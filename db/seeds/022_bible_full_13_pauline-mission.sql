BEGIN;

-- =========================================================================
-- 022_bible_full_13_pauline-mission.sql
-- Chapter K=13 slug='pauline-mission' (Acts 13-28, the missionary journeys,
-- trials, and voyage to Rome, c. 46-62 CE; patmos-vision, 81-96 CE, stays
-- at the end of the band per spec).
-- Adds 12 characters, 3 locations, 13 new events, 15 relations, and
-- reorders the thirteen pre-existing events into the 13001-13999 band.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('43000000-0000-4000-8013-000000000001','10000000-0000-4000-8000-000000000005','priscilla',1300,'female','adult','supporting','unknown',NULL,NULL,'missionary',3),
('43000000-0000-4000-8013-000000000002','10000000-0000-4000-8000-000000000005','aquila',1301,'male','adult','supporting','unknown',NULL,NULL,'missionary',3),
('43000000-0000-4000-8013-000000000003','10000000-0000-4000-8000-000000000005','apollos',1302,'male','adult','supporting','unknown',NULL,NULL,'teacher',2),
('43000000-0000-4000-8013-000000000004','10000000-0000-4000-8000-000000000005','gallio',1303,'male','adult','supporting','historical',NULL,65,'ruler',2),
('43000000-0000-4000-8013-000000000005','10000000-0000-4000-8000-000000000005','demetrius-the-silversmith',1304,'male','adult','antagonist','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8013-000000000006','10000000-0000-4000-8000-000000000005','eutychus',1305,'male','youth','supporting','unknown',NULL,NULL,'person',1),
('43000000-0000-4000-8013-000000000007','10000000-0000-4000-8000-000000000005','felix',1306,'male','adult','supporting','historical',NULL,NULL,'ruler',2),
('43000000-0000-4000-8013-000000000008','10000000-0000-4000-8000-000000000005','festus',1307,'male','adult','supporting','historical',NULL,62,'ruler',2),
('43000000-0000-4000-8013-000000000009','10000000-0000-4000-8000-000000000005','herod-agrippa-ii',1308,'male','adult','supporting','historical',27,NULL,'king',2),
('43000000-0000-4000-8013-000000000010','10000000-0000-4000-8000-000000000005','bernice',1309,'female','adult','supporting','historical',28,NULL,'queen',1),
('43000000-0000-4000-8013-000000000011','10000000-0000-4000-8000-000000000005','julius-the-centurion',1310,'male','adult','supporting','unknown',NULL,NULL,'soldier',2),
('43000000-0000-4000-8013-000000000012','10000000-0000-4000-8000-000000000005','publius',1311,'male','adult','supporting','unknown',NULL,NULL,'ruler',1)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('priscilla','zh-CN','百基拉','与丈夫亚居拉同工的女教师，在哥林多接待保罗。',ARRAY[]::text[],'因革老丢驱逐犹太人而离开罗马，与丈夫迁居哥林多，以制帐棚为业；后随保罗到以弗所，与丈夫一同将神的道给亚波罗讲解得更加详细。','以家与手艺扶持福音的同工。'),
('priscilla','en','Priscilla','A teacher and co-worker with her husband Aquila, who received Paul at Corinth.',ARRAY[]::text[],'Leaving Rome when Claudius expelled the Jews, she settles at Corinth as a tentmaker with her husband; later at Ephesus the couple take Apollos aside and explain the way of God to him more accurately.','To support the mission with her home and her craft.'),
('aquila','zh-CN','亚居拉','本都出生的犹太信徒，百基拉的丈夫，以制帐棚为业。',ARRAY[]::text[],'与妻子因革老丢的谕令离开罗马，在哥林多接待同业的保罗；夫妇后来在以弗所的家成为聚会之所，并一同指教亚波罗。','与妻子同心接待并扶持传道的人。'),
('aquila','en','Aquila','A Jewish believer from Pontus, Priscilla’s husband, a tentmaker by trade.',ARRAY[]::text[],'Leaving Rome under Claudius’s edict, he receives Paul, a fellow tentmaker, at Corinth; the couple’s house at Ephesus later hosts a congregation, and together they instruct Apollos.','To welcome and support the messengers of the word alongside his wife.'),
('apollos','zh-CN','亚波罗','亚历山大出生、最能讲解圣经的犹太辩士。',ARRAY[]::text[],'心里火热，却单晓得约翰的洗礼；在以弗所会堂放胆讲道，经百基拉与亚居拉指教后往亚该亚去，在众人面前有力地驳倒对手，引圣经证明耶稣是基督。','以圣经的雄辩证明耶稣是基督。'),
('apollos','en','Apollos','An eloquent Jew of Alexandria, mighty in the scriptures.',ARRAY[]::text[],'Fervent in spirit but knowing only the baptism of John, he speaks boldly in the Ephesus synagogue; after Priscilla and Aquila instruct him he crosses to Achaia, where he publicly refutes his opponents, showing from the scriptures that Jesus is the Messiah.','To demonstrate from the scriptures that Jesus is the Messiah.'),
('gallio','zh-CN','迦流','亚该亚方伯，拒绝受理控告保罗的案件。',ARRAY[]::text[],'哲学家塞内加的兄长；任亚该亚方伯时，犹太人同心攻击保罗，他以此乃言语、名目与律法之争为由把众人撵出公堂。德尔斐出土的铭文印证其任期，成为保罗年代学的基准点。','只理民事冤情，不问宗教争端。'),
('gallio','en','Gallio','The proconsul of Achaia who refused to hear the case against Paul.',ARRAY[]::text[],'An elder brother of the philosopher Seneca, he dismisses the charge as a dispute over words, names, and Jewish law, and drives the accusers from the tribunal. An inscription found at Delphi confirms his term of office, a fixed point of Pauline chronology.','To judge civil wrongs only, not religious disputes.'),
('demetrius-the-silversmith','zh-CN','底米丢（银匠）','以弗所制造亚底米银龛的银匠，煽动全城暴动。',ARRAY[]::text[],'见保罗传道使偶像生意受损，便召集同业，宣称大女神亚底米的威荣将被藐视，激起满城喊叫，拥进戏园。','保住行业的生计与亚底米崇拜的威荣。'),
('demetrius-the-silversmith','en','Demetrius the silversmith','An Ephesian maker of silver shrines of Artemis who stirred the city to riot.',ARRAY[]::text[],'Seeing his trade endangered by Paul’s preaching, he gathers the craftsmen and warns that the great goddess will be despised, until the whole city rushes shouting into the theater.','To protect his trade and the honor of Artemis.'),
('eutychus','zh-CN','犹推古','特罗亚的少年人，听道时从三层楼上坠下，被保罗救活。',ARRAY[]::text[],'保罗讲论直到半夜，他坐在窗台上沉沉入睡，从三层楼坠下，扶起来已经死了；保罗下去伏在他身上抱着他，说他的灵魂还在身上，少年就活了过来。','（叙事中未明言。）'),
('eutychus','en','Eutychus','A young man of Troas who fell from a third-story window during Paul’s sermon and was restored alive.',ARRAY[]::text[],'As Paul speaks on till midnight, the youth sinks into deep sleep on the window sill and falls from the third story; taken up dead, he is embraced by Paul, who declares that life is still in him, and he revives.','Unstated in the text.'),
('felix','zh-CN','腓力斯','审问保罗的犹太巡抚，把案件拖延了两年。',ARRAY[]::text[],'罗马巡抚，同犹太妻子土西拉听保罗讲论公义、节制与将来的审判，甚觉恐惧；又指望保罗送钱行贿，屡次叫他来谈论；离任时为讨犹太人的喜欢，仍把保罗留在监里。','既指望贿赂，又要讨犹太人的喜欢。'),
('felix','en','Felix','The Roman governor of Judea who heard Paul and left him in custody for two years.',ARRAY[]::text[],'With his Jewish wife Drusilla he listens as Paul reasons of righteousness, self-control, and the judgment to come, and is alarmed; hoping also for a bribe, he sends for Paul often, and on leaving office keeps him bound to please the Jews.','Hope of a bribe, and the favor of the Jews.'),
('festus','zh-CN','非斯都','接替腓力斯的巡抚，保罗在他面前上告于凯撒。',ARRAY[]::text[],'到任不久便在凯撒利亚重审保罗；保罗声明要站在凯撒的堂前受审，他与议会商量后定意把保罗解往罗马，并请亚基帕王同听此案。','秉公处理悬案，同时不失犹太人的情面。'),
('festus','en','Festus','The governor who succeeded Felix, before whom Paul appealed to Caesar.',ARRAY[]::text[],'Taking up the long-delayed case soon after arriving in the province, he retries Paul at Caesarea; when Paul declares his appeal to Caesar’s judgment seat, Festus resolves to send him to Rome and invites King Agrippa to hear him first.','To settle the case correctly without losing the goodwill of the Jews.'),
('herod-agrippa-ii','zh-CN','希律亚基帕二世','听保罗申辩的末代希律王。',ARRAY[]::text[],'亚基帕一世之子，与妹妹百尼基同来问非斯都的安，在大排场中听保罗述说蒙召的经历；他说保罗几乎要劝自己作基督徒，并断言此人若没有上告于凯撒，就可以释放了。','出于好奇与礼节听讼，作出审慎的判断。'),
('herod-agrippa-ii','en','Herod Agrippa II','The last Herodian king, who heard Paul’s defense.',ARRAY[]::text[],'Son of Agrippa I, he comes with his sister Bernice to greet Festus and hears Paul amid great pomp; he remarks that Paul would almost persuade him to become a Christian, and judges that the man might have been freed had he not appealed to Caesar.','Curiosity and courtesy toward the governor, with a cautious verdict.'),
('bernice','zh-CN','百尼基','亚基帕二世的妹妹，同席听保罗申辩。',ARRAY[]::text[],'希律家族的公主，与兄长大张威势进入公厅听讼；审后与众人退席，同意此人并没有犯该死该绑的罪。','随兄长出席听讼。'),
('bernice','en','Bernice','Sister of Agrippa II, present at Paul’s hearing.',ARRAY[]::text[],'A princess of the Herodian house, she enters the audience hall in great pomp beside her brother; withdrawing after the hearing, she concurs that the prisoner has done nothing deserving death or chains.','To attend the hearing at her brother’s side.'),
('julius-the-centurion','zh-CN','犹流（百夫长）','押送保罗往罗马的御营百夫长，一路宽待他。',ARRAY[]::text[],'属御营的百夫长，在西顿准保罗上岸探望朋友；风暴中渐渐听从保罗的劝告，船破时又拦阻兵丁杀囚犯，救了保罗的性命。','忠于押送之责，同时保全所押的囚犯。'),
('julius-the-centurion','en','Julius the centurion','The centurion of the Augustan cohort who escorted Paul to Rome and treated him kindly.',ARRAY[]::text[],'At Sidon he allows Paul ashore to visit his friends; in the storm he comes to trust Paul’s counsel, and at the wreck he stops the soldiers from killing the prisoners, saving Paul’s life.','To deliver his prisoners safely, and to spare Paul.'),
('publius','zh-CN','部百流','米利大岛的首领，接待船难的众人，其父得保罗医治。',ARRAY[]::text[],'岛上的首领，以田产款待保罗一行三日；他父亲患热病和痢疾躺着，保罗进去为他祷告按手，治好了他，岛上其余的病人也来得了医治。','以厚礼款待落难的客旅。'),
('publius','en','Publius','The chief man of Malta, who received the shipwrecked company and whose father was healed by Paul.',ARRAY[]::text[],'The leading man of the island, he entertains Paul’s party on his estate for three days; his father lies sick with fever and dysentery, and Paul prays, lays hands on him, and heals him, after which the island’s other sick also come and are cured.','Generous hospitality toward castaways.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. LOCATIONS (3 new: lystra, troas, miletus; philippi, corinth, ephesus,
--    caesarea-maritima, malta, rome are reused from earlier seeds)
-- -------------------------------------------------------------------------
INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('33000000-0000-4000-8013-000000000001','10000000-0000-4000-8000-000000000005','lystra','real',ST_GeogFromText('POINT(32.4539 37.5789)'),NULL,NULL,1300,'city','approximate',9,'TR',false,false),
('33000000-0000-4000-8013-000000000002','10000000-0000-4000-8000-000000000005','troas','real',ST_GeogFromText('POINT(26.1580 39.7519)'),NULL,NULL,1301,'port','approximate',9,'TR',false,false),
('33000000-0000-4000-8013-000000000003','10000000-0000-4000-8000-000000000005','miletus','real',ST_GeogFromText('POINT(27.2760 37.5303)'),NULL,NULL,1302,'port','approximate',9,'TR',false,false)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,status,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',ARRAY[]::text[],'','','','',v.region FROM locations l JOIN (VALUES
('lystra','zh-CN','路司得','吕高尼的城镇，保罗布道旅程的重要一站，也是提摩太的家乡。','吕高尼（小亚细亚）'),
('lystra','en','Lystra','A town of Lycaonia, a key stop on Paul’s journeys and the home of Timothy.','Lycaonia (Asia Minor)'),
('troas','zh-CN','特罗亚','爱琴海东岸的港口城，保罗在此见异象渡往马其顿，后又在此讲道直到半夜。','每西亚（小亚细亚）'),
('troas','en','Troas','A port on the Aegean coast where Paul saw the Macedonian vision and later preached until midnight.','Mysia (Asia Minor)'),
('miletus','zh-CN','米利都','以弗所以南的古老港城，保罗在此与以弗所的长老话别。','加利亚沿岸（小亚细亚）'),
('miletus','en','Miletus','An ancient harbor city south of Ephesus, where Paul took leave of the Ephesian elders.','Caria (Asia Minor)')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug AND l.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 3. EVENTS (new) -- range dating within 46-62 CE, chapter 'pauline-mission'
-- -------------------------------------------------------------------------
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('63000000-0000-4000-8013-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,v.ttype::event_time_type,'unknown'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'lame-man-healed-at-lystra',13003,'legendary_or_mythic','religious','range',46,48,'low','pauline-mission'),
(2,'paul-stoned-at-lystra',13005,'reported_historical','other','range',46,48,'low','pauline-mission'),
(3,'timothy-joins-at-lystra',13009,'reported_historical','meeting','range',48,51,'low','pauline-mission'),
(4,'earthquake-at-the-philippian-jail',13017,'legendary_or_mythic','religious','range',49,51,'low','pauline-mission'),
(5,'aquila-and-priscilla-receive-paul',13021,'reported_historical','meeting','range',50,52,'medium','pauline-mission'),
(6,'gallio-dismisses-the-case',13025,'verified_historical','trial','range',51,53,'high','pauline-mission'),
(7,'apollos-instructed-at-ephesus',13027,'reported_historical','meeting','range',52,54,'low','pauline-mission'),
(8,'riot-of-the-silversmiths-at-ephesus',13031,'reported_historical','political','range',54,57,'medium','pauline-mission'),
(9,'eutychus-falls-at-troas',13033,'legendary_or_mythic','religious','range',56,58,'low','pauline-mission'),
(10,'farewell-at-miletus',13035,'reported_historical','meeting','range',56,58,'low','pauline-mission'),
(11,'paul-before-festus-and-agrippa',13041,'reported_historical','trial','range',58,60,'medium','pauline-mission'),
(12,'viper-at-malta-and-publius-father-healed',13045,'legendary_or_mythic','religious','range',59,61,'low','pauline-mission'),
(13,'two-years-preaching-at-rome',13049,'reported_historical','religious','range',60,62,'medium','pauline-mission')
) AS v(n,slug,seq,reality,etype,ttype,y1,y2,conf,chapter_slug)
JOIN chapters ch ON ch.slug=v.chapter_slug AND ch.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 4. Reorder existing pauline-mission events into the 13001-13999 band
--    (patmos-vision, 81-96 CE, stays last per spec)
-- -------------------------------------------------------------------------
UPDATE events e SET sequence=v.seq FROM (VALUES
  ('first-journey-begins-at-cyprus',13001),
  ('jerusalem-council',13007),
  ('crossing-into-macedonia',13011),
  ('lydia-hosts-at-philippi',13013),
  ('paul-and-silas-detained-at-philippi',13015),
  ('debate-at-athens',13019),
  ('long-stay-at-corinth',13023),
  ('years-at-ephesus',13029),
  ('arrest-in-jerusalem',13037),
  ('hearing-at-caesarea',13039),
  ('shipwreck-at-malta',13043),
  ('paul-arrives-rome',13047),
  ('patmos-vision',13051)
) AS v(slug,seq) WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug=v.slug;

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tlabel FROM events e JOIN (VALUES
('lame-man-healed-at-lystra','zh-CN','路司得医治瘸腿人，二人被当作神明','保罗使生来瘸腿的人跳起来行走，众人以为神明降临，称巴拿巴为丢斯、保罗为希耳米。','那人生来两脚无力，保罗见他有信心，大声说“你起来，两脚站直”；吕高尼人用乡谈喊着说有神藉着人形降临，祭司牵着牛、拿着花圈要向二人献祭，二人撕裂衣裳，跳进众人中间拦住他们。','宣教叙事中的著名场景，展示外邦城镇对神迹的误读。','约公元 46–48 年'),
('lame-man-healed-at-lystra','en','The lame man healed at Lystra, and the two hailed as gods','Paul makes a man lame from birth leap up and walk, and the crowds hail Barnabas as Zeus and Paul as Hermes.','Seeing that the man has faith to be healed, Paul calls out for him to stand upright; the Lycaonians cry in their own tongue that the gods have come down in human form, and a priest brings oxen and garlands to sacrifice, until the two tear their garments and rush in to stop the crowd.','A famous scene of the mission narrative, showing a pagan town’s misreading of a wonder.','c. 46–48 CE'),
('paul-stoned-at-lystra','zh-CN','保罗在路司得被石击','从安提阿和以哥念来的犹太人挑唆众人，用石头打保罗，拖到城外，以为他已经死了。','门徒正围着他，他就起来走进城去；第二天同巴拿巴往特庇去，随后又回到路司得坚固门徒的心，说我们进入神的国必须经历许多艰难。','旅程中最险恶的一幕，与前一刻被尊为神明形成强烈对照。','约公元 46–48 年'),
('paul-stoned-at-lystra','en','Paul stoned at Lystra','Jews from Antioch and Iconium win over the crowd, stone Paul, and drag him out of the city, supposing him dead.','As the disciples gather around him he rises and walks back into the city; the next day he leaves with Barnabas for Derbe, and later returns to Lystra to strengthen the disciples, saying that through many hardships we must enter the kingdom of God.','The most violent moment of the journey, in stark contrast with the crowd’s worship moments before.','c. 46–48 CE'),
('timothy-joins-at-lystra','zh-CN','提摩太在路司得加入','第二次旅程经过路司得时，保罗带上在门徒中有好名声的提摩太同行。','提摩太是信主的犹太妇人之子，父亲是希腊人，为路司得和以哥念的弟兄所称赞；保罗要带他同去，因当地的犹太人都知道他父亲是希腊人，就给他行了割礼。','保罗最亲密的同工由此登场，新约中有两封书信以他为受书人。','约公元 48–51 年'),
('timothy-joins-at-lystra','en','Timothy joins at Lystra','Passing through Lystra on the second journey, Paul takes with him Timothy, a disciple well spoken of by the brothers.','Timothy is the son of a believing Jewish mother and a Greek father, commended by the brothers at Lystra and Iconium; because the Jews of those parts know his father is Greek, Paul has him circumcised before they set out.','Paul’s closest co-worker enters the narrative; two New Testament letters are addressed to him.','c. 48–51 CE'),
('earthquake-at-the-philippian-jail','zh-CN','腓立比狱中地震，禁卒归信','半夜保罗西拉祷告唱诗，忽然地大震动，监门全开，禁卒一家当夜受洗归信。','禁卒见监门全开，以为囚犯已经逃走，拔刀要自尽；保罗大声呼喊说不要伤害自己，我们都在这里；禁卒战战兢兢地问当怎样行才可以得救，当夜领二人到家里，为他们洗伤，全家受了洗，摆上饭食欢喜不已。','与被囚事件相承接，是使徒行传中最著名的归信场景之一。','约公元 49–51 年'),
('earthquake-at-the-philippian-jail','en','Earthquake at the Philippian jail and the jailer’s conversion','At midnight, as Paul and Silas pray and sing, a great earthquake opens the prison doors, and the jailer and his household are baptized that night.','Seeing the doors open and supposing the prisoners fled, the jailer draws his sword to kill himself; Paul cries out that they are all still there; trembling, the jailer asks what he must do to be saved, then takes the two into his house, washes their wounds, and is baptized with all his household, rejoicing over a meal.','Following directly on the imprisonment, one of the most famous conversion scenes in Acts.','c. 49–51 CE'),
('aquila-and-priscilla-receive-paul','zh-CN','亚居拉与百基拉接待保罗','保罗到哥林多，遇见同以制帐棚为业的亚居拉夫妇，便与他们同住做工。','夫妇因革老丢命犹太人都离开罗马而新近从义大利来；保罗与他们同住，一同做工，每逢安息日在会堂里辩论，劝化犹太人和希腊人。','由此结成新约叙事中最著名的同工家庭之一。','约公元 50–52 年'),
('aquila-and-priscilla-receive-paul','en','Aquila and Priscilla receive Paul','Arriving at Corinth, Paul meets Aquila and Priscilla, tentmakers like himself, and stays and works with them.','The couple have lately come from Italy because Claudius ordered all Jews to leave Rome; Paul lives and labors with them, arguing in the synagogue every sabbath and persuading Jews and Greeks.','The beginning of one of the most famous partnerships of the New Testament narrative.','c. 50–52 CE'),
('gallio-dismisses-the-case','zh-CN','迦流拒审保罗案','犹太人同心把保罗拉到亚该亚方伯迦流的公堂，迦流拒绝受理，把他们撵出公堂。','控方称保罗劝人不按着律法敬拜神；迦流说这既是关乎言语、名目和你们律法的争论，我不愿意审问这样的事；众人便揪住管会堂的所提尼，在堂前打他，这些事迦流都不管。','德尔斐出土的迦流铭文印证其任期，使此案成为保罗年代学的锚点。','约公元 51–53 年'),
('gallio-dismisses-the-case','en','Gallio dismisses the case','The Jews bring Paul with one accord before Gallio, proconsul of Achaia, who refuses to hear the matter and drives them from the tribunal.','The accusers charge that Paul persuades people to worship God contrary to the law; Gallio replies that since it is a question of words, names, and their own law, he will be no judge of such things; the crowd then seizes Sosthenes, the synagogue ruler, and beats him before the tribunal, and Gallio pays no heed.','The Delphi inscription attesting Gallio’s term makes this scene the anchor of Pauline chronology.','c. 51–53 CE'),
('apollos-instructed-at-ephesus','zh-CN','亚波罗在以弗所受教','最能讲解圣经的亚波罗在以弗所放胆讲道，百基拉夫妇将神的道给他讲解得更加详细。','他心里火热，将耶稣的事详细讲论教训人，只是单晓得约翰的洗礼；夫妇听见，就接他来指教；他想要往亚该亚去，弟兄们便写信请门徒接待他，他到了那里，多多帮助那蒙恩信主的人。','显示初代教会教导与荐信的网络如何运作。','约公元 52–54 年'),
('apollos-instructed-at-ephesus','en','Apollos instructed at Ephesus','Apollos, mighty in the scriptures, speaks boldly at Ephesus, and Priscilla and Aquila explain the way of God to him more accurately.','Fervent in spirit, he teaches accurately the things concerning Jesus, though he knows only the baptism of John; hearing him, the couple take him aside and instruct him; when he wishes to cross to Achaia, the brothers write urging the disciples to welcome him, and there he greatly helps those who have believed.','Shows how the early community’s network of teaching and commendation worked.','c. 52–54 CE'),
('riot-of-the-silversmiths-at-ephesus','zh-CN','以弗所银匠暴动','银匠底米丢煽动同业，满城拥进戏园，喊叫“大哉，以弗所人的亚底米”约有两小时。','众人拿住保罗的同伴该犹和亚里达古；保罗想要进去，门徒和几位首领都不许；城里的书记安抚众人说，这些事自有放告的日子和方伯可以彼此对告，便叫众人散去。','生动呈现福音与地方经济、崇拜的冲突，是以弗所岁月的高潮。','约公元 54–57 年'),
('riot-of-the-silversmiths-at-ephesus','en','Riot of the silversmiths at Ephesus','Demetrius the silversmith rouses his fellow craftsmen, and the city rushes into the theater, crying for about two hours, “Great is Artemis of the Ephesians.”','The crowd seizes Paul’s companions Gaius and Aristarchus; Paul wishes to go in, but the disciples and some officials of the province will not let him; at last the town clerk quiets the assembly, saying the courts and proconsuls are open for such charges, and dismisses the crowd.','A vivid clash between the message and a city’s trade and cult, the climax of the Ephesus years.','c. 54–57 CE'),
('eutychus-falls-at-troas','zh-CN','犹推古在特罗亚坠楼复苏','保罗讲论直到半夜，少年犹推古从三层楼的窗台坠下，扶起已死，保罗使他复活。','七日的第一日聚会擘饼，楼上有好些灯烛；犹推古沉沉入睡，从三层楼上掉下去；保罗下去伏在他身上，抱着他说你们不要发慌，他的灵魂还在身上；众人把童子活活地领来，得的安慰不小。','保罗行程中最富画面感的神迹场景之一。','约公元 56–58 年'),
('eutychus-falls-at-troas','en','Eutychus falls at Troas and is restored','As Paul speaks until midnight, the young man Eutychus falls from a third-story window and is taken up dead, and Paul restores him alive.','The believers gather to break bread on the first day of the week, with many lamps in the upper room; Eutychus sinks into deep sleep and falls; Paul goes down, throws himself on him, and embracing him says not to be alarmed, for his life is in him; the boy is brought home alive, to no small comfort.','One of the most vividly drawn wonder scenes of Paul’s travels.','c. 56–58 CE'),
('farewell-at-miletus','zh-CN','米利都别以弗所长老','保罗请以弗所教会的长老到米利都，嘱咐他们牧养群羊，众人痛哭着与他亲嘴送别。','他回顾三年之久流泪劝诫各人，声明自己被圣灵催迫往耶路撒冷去，不知道在那里要遇见什么事，只知捆锁与患难等待着他；又引主的话说施比受更为有福；众人为“以后不能再见我的面”那句话最是伤心，送他上了船。','使徒行传中最动人的告别辞，常被视为保罗的牧养遗嘱。','约公元 56–58 年'),
('farewell-at-miletus','en','Farewell to the Ephesian elders at Miletus','Paul summons the elders of the Ephesian church to Miletus, charges them to shepherd the flock, and they weep and kiss him farewell.','He recalls three years of admonishing each one with tears, declares that bound in the Spirit he goes to Jerusalem not knowing what will befall him there, except that chains and afflictions await; he quotes the Lord’s words that it is more blessed to give than to receive; they sorrow most over his saying that they will see his face no more, and bring him to the ship.','The most moving farewell speech in Acts, often read as Paul’s pastoral testament.','c. 56–58 CE'),
('paul-before-festus-and-agrippa','zh-CN','保罗在非斯都与亚基帕前申辩','保罗在凯撒利亚上告于凯撒，又在亚基帕王与百尼基面前述说蒙召的经历。','非斯都重审此案时，保罗声明自己站在凯撒的堂前，这就是应当受审的地方；亚基帕王大张威势前来听讼，听后说保罗几乎要劝自己作基督徒；退席后众人彼此谈论，认为这人并没有犯该死该绑的罪，若没有上告于凯撒，就可以释放了。','该撒利亚囚禁的终局，直接引出押往罗马的航程。','约公元 58–60 年'),
('paul-before-festus-and-agrippa','en','Paul before Festus and Agrippa','At Caesarea Paul appeals to Caesar, then recounts his calling before King Agrippa and Bernice.','When Festus reopens the case, Paul declares that he stands at Caesar’s judgment seat, where he ought to be tried; Agrippa comes in great pomp to hear him and afterward remarks that Paul would almost persuade him to become a Christian; withdrawing, the hearers agree the man has done nothing deserving death or chains, and might have been freed had he not appealed to Caesar.','The close of the Caesarean imprisonment, leading directly to the voyage to Rome.','c. 58–60 CE'),
('viper-at-malta-and-publius-father-healed','zh-CN','米利大的毒蛇与部百流之父得医治','保罗拾柴时被毒蛇咬住手却安然无恙，又医好岛上首领部百流的父亲。','土人看见那毒蛇悬在他手上，起先说他必是个凶手，虽从海里救上来，天理还不容他活着；见他把蛇甩在火里并无伤害，就转念说他是个神。部百流的父亲患热病和痢疾躺着，保罗进去祷告按手治好了他，岛上其余的病人也来得了医治。','船难叙事的温暖尾声，米利大由此进入基督教的传统记忆。','约公元 59–61 年'),
('viper-at-malta-and-publius-father-healed','en','The viper at Malta and the healing of Publius’s father','Gathering firewood, Paul is bitten by a viper yet unharmed, and he heals the father of Publius, the island’s chief man.','Seeing the creature hanging from his hand, the islanders first say he must be a murderer whom justice will not let live, though saved from the sea; when he shakes it into the fire unharmed, they change their minds and call him a god. The father of Publius lies sick with fever and dysentery, and Paul prays, lays hands on him, and heals him, after which the island’s other sick come and are cured.','A warm coda to the shipwreck narrative, drawing Malta into Christian tradition.','c. 59–61 CE'),
('two-years-preaching-at-rome','zh-CN','罗马软禁中传道两年','保罗在自己所租的房子里住了足足两年，放胆传讲神国的道，并没有人禁止。','他虽带着锁链，却可以会见来访的人；先请犹太人的首领来分诉，从早到晚引摩西的律法和先知的书证明耶稣的事；传统认为几卷狱中书信写于这一时期。使徒行传的叙事在此收束。','全书以福音毫无阻碍地传到帝国中心作结。','约公元 60–62 年'),
('two-years-preaching-at-rome','en','Two years of preaching under guard at Rome','Paul stays two whole years in his own rented house, proclaiming the kingdom of God with all boldness, and no one forbids him.','Though in chains, he receives all who come to him; he first calls the leaders of the Jews and from morning till evening argues about Jesus from the law of Moses and the prophets; tradition places several of the prison letters in this period. Here the narrative of Acts comes to rest.','The book closes with the message reaching the heart of the empire unhindered.','c. 60–62 CE')
) AS v(slug,locale,title,summary,detail,sig,tlabel) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS (lystra, troas, miletus new; others reused)
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('lame-man-healed-at-lystra','lystra'),
('paul-stoned-at-lystra','lystra'),
('timothy-joins-at-lystra','lystra'),
('earthquake-at-the-philippian-jail','philippi'),
('aquila-and-priscilla-receive-paul','corinth'),
('gallio-dismisses-the-case','corinth'),
('apollos-instructed-at-ephesus','ephesus'),
('riot-of-the-silversmiths-at-ephesus','ephesus'),
('eutychus-falls-at-troas','troas'),
('farewell-at-miletus','miletus'),
('paul-before-festus-and-agrippa','caesarea-maritima'),
('viper-at-malta-and-publius-father-healed','malta'),
('two-years-preaching-at-rome','rome')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS
--    (also attaches felix to the existing hearing-at-caesarea and
--    julius-the-centurion to the existing shipwreck-at-malta)
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('lame-man-healed-at-lystra','paul',0),('lame-man-healed-at-lystra','barnabas',1),
('paul-stoned-at-lystra','paul',0),('paul-stoned-at-lystra','barnabas',1),
('timothy-joins-at-lystra','timothy',0),('timothy-joins-at-lystra','paul',1),('timothy-joins-at-lystra','silas',2),
('earthquake-at-the-philippian-jail','paul',0),('earthquake-at-the-philippian-jail','silas',1),
('aquila-and-priscilla-receive-paul','aquila',0),('aquila-and-priscilla-receive-paul','priscilla',1),('aquila-and-priscilla-receive-paul','paul',2),
('gallio-dismisses-the-case','gallio',0),('gallio-dismisses-the-case','paul',1),
('apollos-instructed-at-ephesus','apollos',0),('apollos-instructed-at-ephesus','priscilla',1),('apollos-instructed-at-ephesus','aquila',2),
('riot-of-the-silversmiths-at-ephesus','demetrius-the-silversmith',0),('riot-of-the-silversmiths-at-ephesus','paul',1),
('eutychus-falls-at-troas','eutychus',0),('eutychus-falls-at-troas','paul',1),('eutychus-falls-at-troas','luke',2),
('farewell-at-miletus','paul',0),('farewell-at-miletus','luke',1),
('paul-before-festus-and-agrippa','paul',0),('paul-before-festus-and-agrippa','festus',1),('paul-before-festus-and-agrippa','herod-agrippa-ii',2),('paul-before-festus-and-agrippa','bernice',3),
('viper-at-malta-and-publius-father-healed','paul',0),('viper-at-malta-and-publius-father-healed','publius',1),('viper-at-malta-and-publius-father-healed','julius-the-centurion',2),('viper-at-malta-and-publius-father-healed','luke',3),
('two-years-preaching-at-rome','paul',0),('two-years-preaching-at-rome','luke',1),('two-years-preaching-at-rome','timothy',2),
('hearing-at-caesarea','felix',2),
('shipwreck-at-malta','julius-the-centurion',2)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES (all new events map to Acts of the Apostles)
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Acts of the Apostles'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.id::text LIKE '63000000-0000-4000-8013%'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS
-- -------------------------------------------------------------------------
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('73000000-0000-4000-8013-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'aquila','priscilla','spouse','bidirectional','positive',4,'active',NULL,NULL),
(2,'aquila','paul','ally','bidirectional','positive',3,'active','aquila-and-priscilla-receive-paul',NULL),
(3,'priscilla','paul','ally','bidirectional','positive',3,'active','aquila-and-priscilla-receive-paul',NULL),
(4,'priscilla','apollos','mentor','source_to_target','positive',3,'ended','apollos-instructed-at-ephesus',NULL),
(5,'aquila','apollos','mentor','source_to_target','positive',3,'ended','apollos-instructed-at-ephesus',NULL),
(6,'demetrius-the-silversmith','paul','adversary','source_to_target','negative',3,'ended','riot-of-the-silversmiths-at-ephesus',NULL),
(7,'gallio','paul','other','source_to_target','neutral',2,'ended','gallio-dismisses-the-case',NULL),
(8,'felix','paul','other','source_to_target','mixed',3,'ended','hearing-at-caesarea',NULL),
(9,'festus','paul','other','source_to_target','neutral',3,'ended','paul-before-festus-and-agrippa',NULL),
(10,'herod-agrippa-ii','bernice','sibling','bidirectional','neutral',2,'unknown',NULL,NULL),
(11,'herod-agrippa-ii','paul','other','source_to_target','neutral',2,'ended','paul-before-festus-and-agrippa',NULL),
(12,'julius-the-centurion','paul','ally','source_to_target','positive',3,'ended','shipwreck-at-malta',NULL),
(13,'publius','paul','ally','bidirectional','positive',2,'ended','viper-at-malta-and-publius-father-healed',NULL),
(14,'herod-agrippa-i','herod-agrippa-ii','family','source_to_target','neutral',2,'unknown',NULL,NULL),
(15,'paul','eutychus','other','source_to_target','positive',2,'ended','eutychus-falls-at-troas',NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000005'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 10. GROUP MEMBERSHIP (existing groups pauline-circle, roman-authorities,
--     opposing-powers)
-- -------------------------------------------------------------------------
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g JOIN (VALUES
('pauline-circle','priscilla'),('pauline-circle','aquila'),('pauline-circle','apollos'),
('roman-authorities','gallio'),('roman-authorities','felix'),('roman-authorities','festus'),
('roman-authorities','herod-agrippa-ii'),('roman-authorities','bernice'),
('roman-authorities','julius-the-centurion'),('roman-authorities','publius'),
('opposing-powers','demetrius-the-silversmith')
) AS v(gslug,cslug)
ON g.slug=v.gslug JOIN characters c ON c.slug=v.cslug AND c.work_id=g.work_id
WHERE g.work_id='10000000-0000-4000-8000-000000000005' ON CONFLICT DO NOTHING;

COMMIT;
