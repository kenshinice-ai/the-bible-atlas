BEGIN;

-- v4 Bible expansion, part 5: 88 further relationships, taking the work to 103.
-- Lifecycle events (start_event_id / end_event_id) are set wherever the text
-- marks a clear beginning or end, so the graph can be scrubbed along narrative
-- time instead of showing every edge at once. A handful of low-strength
-- genealogical edges deliberately span eras: they are what makes the collapsed
-- era-level view a connected graph rather than six separate clusters.

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('72000000-0000-4000-8000-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'abraham','lot','family','bidirectional','mixed',3,'active',NULL,NULL),
(2,'abraham','hagar','other','source_to_target','mixed',2,'ended',NULL,'hagar-and-ishmael-in-the-wilderness'),
(3,'hagar','ishmael','family','bidirectional','positive',5,'active',NULL,NULL),
(4,'abraham','ishmael','family','bidirectional','mixed',3,'changed',NULL,'hagar-and-ishmael-in-the-wilderness'),
(5,'sarah','hagar','other','bidirectional','negative',4,'ended',NULL,'hagar-and-ishmael-in-the-wilderness'),
(6,'isaac','rebekah','spouse','bidirectional','positive',4,'active','rebekah-brought-from-harran',NULL),
(7,'rebekah','jacob','family','bidirectional','positive',5,'active',NULL,NULL),
(8,'rebekah','esau','family','bidirectional','mixed',2,'active',NULL,NULL),
(9,'isaac','esau','family','bidirectional','positive',3,'changed',NULL,'jacob-takes-the-blessing'),
(10,'isaac','jacob','family','bidirectional','mixed',3,'active',NULL,NULL),
(11,'jacob','esau','sibling','bidirectional','mixed',4,'changed','jacob-takes-the-blessing','jacob-and-esau-reconcile'),
(12,'jacob','rachel','spouse','bidirectional','positive',5,'ended','jacob-marries-leah-and-rachel','rachel-buried-near-bethlehem'),
(13,'jacob','leah','spouse','bidirectional','mixed',3,'active','jacob-marries-leah-and-rachel',NULL),
(14,'rachel','leah','sibling','bidirectional','negative',3,'active',NULL,NULL),
(15,'jacob','joseph-son-of-jacob','family','bidirectional','positive',5,'active',NULL,NULL),
(16,'rachel','joseph-son-of-jacob','family','bidirectional','positive',5,'active',NULL,NULL),
(17,'joseph-son-of-jacob','benjamin','sibling','bidirectional','positive',4,'active',NULL,NULL),
(18,'joseph-son-of-jacob','judah-son-of-jacob','sibling','bidirectional','mixed',3,'changed','joseph-sold-into-egypt','brothers-reunite-in-egypt'),
(19,'leah','judah-son-of-jacob','family','bidirectional','positive',4,'active',NULL,NULL),
(20,'rachel','benjamin','family','bidirectional','positive',4,'ended',NULL,'rachel-buried-near-bethlehem'),
(21,'moses','miriam','sibling','bidirectional','positive',4,'active',NULL,NULL),
(22,'aaron','miriam','sibling','bidirectional','positive',4,'active',NULL,NULL),
(23,'moses','jethro','family','bidirectional','positive',3,'active','moses-flees-to-midian',NULL),
(24,'moses','pharaoh-of-the-exodus','adversary','bidirectional','negative',5,'ended','confrontation-with-pharaoh','crossing-of-the-sea'),
(25,'aaron','pharaoh-of-the-exodus','adversary','source_to_target','negative',3,'ended','confrontation-with-pharaoh','crossing-of-the-sea'),
(26,'moses','joshua','mentor','source_to_target','positive',5,'ended',NULL,'moses-views-canaan-from-nebo'),
(27,'moses','caleb','ally','bidirectional','positive',2,'active','scouts-sent-from-kadesh',NULL),
(28,'joshua','caleb','ally','bidirectional','positive',4,'active','scouts-sent-from-kadesh',NULL),
(29,'joshua','rahab','ally','bidirectional','positive',3,'active','scouts-sheltered-by-rahab',NULL),
(30,'deborah','barak','ally','bidirectional','positive',4,'active','deborah-and-barak-muster-at-tabor',NULL),
(31,'samson','delilah','romantic','bidirectional','negative',4,'ended','samson-and-delilah','samson-at-gaza'),
(32,'ruth','boaz','spouse','bidirectional','positive',5,'active','ruth-and-boaz-at-the-threshing-floor',NULL),
(33,'samuel','saul','mentor','source_to_target','mixed',4,'ended','samuel-anoints-saul','saul-rejected-at-ramah'),
(34,'samuel','david','mentor','source_to_target','positive',4,'active','samuel-anoints-david-at-bethlehem',NULL),
(35,'boaz','david','family','source_to_target','neutral',2,'active',NULL,NULL),
(36,'ruth','david','family','source_to_target','neutral',2,'active',NULL,NULL),
(37,'saul','david','adversary','source_to_target','negative',5,'ended','david-a-fugitive-in-the-south','saul-and-jonathan-die-on-gilboa'),
(38,'saul','jonathan','family','bidirectional','mixed',4,'ended',NULL,'saul-and-jonathan-die-on-gilboa'),
(39,'jonathan','david','ally','bidirectional','positive',5,'ended','jonathan-and-david-make-a-covenant','saul-and-jonathan-die-on-gilboa'),
(40,'david','goliath','adversary','bidirectional','negative',4,'ended',NULL,'david-and-goliath-in-the-valley-of-elah'),
(41,'david','abigail','spouse','bidirectional','positive',3,'active','abigail-intercedes',NULL),
(42,'david','bathsheba','spouse','bidirectional','mixed',4,'active','bathsheba-and-nathans-rebuke',NULL),
(43,'nathan','david','mentor','source_to_target','mixed',3,'active','bathsheba-and-nathans-rebuke',NULL),
(44,'david','joab','ally','bidirectional','mixed',4,'active',NULL,NULL),
(45,'david','absalom','family','bidirectional','negative',5,'ended','absaloms-revolt','death-of-absalom'),
(46,'joab','absalom','adversary','source_to_target','negative',4,'ended','absaloms-revolt','death-of-absalom'),
(47,'bathsheba','solomon','family','bidirectional','positive',5,'active',NULL,NULL),
(48,'david','solomon','family','bidirectional','positive',5,'ended',NULL,'solomon-succeeds-david'),
(49,'solomon','rehoboam','family','bidirectional','positive',3,'active',NULL,NULL),
(50,'rehoboam','jeroboam','adversary','bidirectional','negative',4,'active','kingdom-divides',NULL),
(51,'solomon','jeroboam','adversary','source_to_target','negative',2,'ended',NULL,'kingdom-divides'),
(52,'ahab','jezebel','spouse','bidirectional','positive',4,'active','ahab-and-jezebel-marry',NULL),
(53,'elijah','ahab','adversary','bidirectional','negative',5,'active','contest-on-mount-carmel',NULL),
(54,'elijah','jezebel','adversary','bidirectional','negative',5,'active','contest-on-mount-carmel',NULL),
(55,'elijah','elisha','mentor','source_to_target','positive',5,'ended',NULL,'elijah-passes-the-mantle'),
(56,'ahab','elisha','adversary','bidirectional','negative',2,'active',NULL,NULL),
(57,'isaiah','hezekiah','ally','bidirectional','positive',4,'active','isaiah-counsels-hezekiah',NULL),
(58,'jeremiah','nebuchadnezzar','adversary','source_to_target','negative',3,'active','jerusalem-falls',NULL),
(59,'nebuchadnezzar','daniel','other','bidirectional','mixed',4,'active','daniel-in-the-babylonian-court',NULL),
(60,'jeremiah','ezekiel','ally','bidirectional','neutral',1,'active',NULL,NULL),
(61,'daniel','ezekiel','ally','bidirectional','neutral',1,'active',NULL,NULL),
(62,'esther','mordecai','family','bidirectional','positive',5,'active',NULL,NULL),
(63,'mary','joseph-of-nazareth','spouse','bidirectional','positive',5,'active','annunciation-at-nazareth',NULL),
(64,'joseph-of-nazareth','jesus','family','bidirectional','positive',5,'active',NULL,NULL),
(65,'jesus','john-the-baptist','family','bidirectional','positive',4,'ended','baptism-at-the-jordan',NULL),
(66,'jesus','andrew','mentor','source_to_target','positive',3,'active','calling-of-the-first-disciples',NULL),
(67,'jesus','john-son-of-zebedee','mentor','source_to_target','positive',4,'active','calling-of-the-first-disciples',NULL),
(68,'jesus','mary-magdalene','mentor','source_to_target','positive',4,'active',NULL,NULL),
(69,'jesus','judas-iscariot','mentor','source_to_target','negative',4,'ended',NULL,'arrest-on-the-mount-of-olives'),
(70,'peter','andrew','sibling','bidirectional','positive',4,'active',NULL,NULL),
(71,'peter','john-son-of-zebedee','ally','bidirectional','positive',4,'active',NULL,NULL),
(72,'jesus','martha','ally','bidirectional','positive',3,'active','raising-of-lazarus',NULL),
(73,'jesus','lazarus','ally','bidirectional','positive',3,'active','raising-of-lazarus',NULL),
(74,'martha','lazarus','sibling','bidirectional','positive',4,'active',NULL,NULL),
(75,'jesus','pontius-pilate','adversary','target_to_source','negative',4,'ended','trial-before-pilate','crucifixion-in-jerusalem'),
(76,'herod-the-great','jesus','adversary','source_to_target','negative',3,'ended','flight-to-egypt','return-to-nazareth'),
(77,'peter','cornelius','ally','bidirectional','positive',3,'active','peter-and-cornelius-at-caesarea',NULL),
(78,'paul','stephen','adversary','source_to_target','negative',3,'ended',NULL,'stephen-is-killed'),
(79,'paul','barnabas','ally','bidirectional','positive',5,'changed','barnabas-brings-paul-to-antioch',NULL),
(80,'paul','silas','ally','bidirectional','positive',4,'active','crossing-into-macedonia',NULL),
(81,'paul','timothy','mentor','source_to_target','positive',5,'active','long-stay-at-corinth',NULL),
(82,'paul','luke','ally','bidirectional','positive',4,'active','crossing-into-macedonia',NULL),
(83,'paul','lydia','ally','bidirectional','positive',3,'active','lydia-hosts-at-philippi',NULL),
(84,'paul','peter','ally','bidirectional','mixed',3,'active','jerusalem-council',NULL),
(85,'silas','timothy','ally','bidirectional','positive',2,'active',NULL,NULL),
(86,'noah','abraham','family','source_to_target','neutral',1,'active',NULL,NULL),
(87,'abraham','jacob','family','source_to_target','neutral',2,'active',NULL,NULL),
(88,'jacob','moses','family','source_to_target','neutral',1,'active',NULL,NULL),
(89,'david','jesus','family','source_to_target','neutral',2,'active',NULL,NULL),
(90,'ruth','jesus','family','source_to_target','neutral',1,'active',NULL,NULL)
) AS v(n,from_slug,to_slug,rtype,dir,sentiment,strength,rstatus,start_slug,end_slug)
JOIN characters fc ON fc.slug=v.from_slug AND fc.work_id='10000000-0000-4000-8000-000000000005'
JOIN characters tc ON tc.slug=v.to_slug AND tc.work_id=fc.work_id
LEFT JOIN events se ON se.slug=v.start_slug AND se.work_id=fc.work_id
LEFT JOIN events ee ON ee.slug=v.end_slug AND ee.work_id=fc.work_id
ON CONFLICT DO NOTHING;

INSERT INTO relation_translations(relation_id,locale,label,summary,status)
SELECT r.id,v.locale::locale_code,v.label,v.summary,'published'
FROM character_relations r
JOIN characters fc ON fc.id=r.from_character_id
JOIN characters tc ON tc.id=r.to_character_id
JOIN (VALUES
('abraham','lot','zh-CN','叔侄','同行迁徙后分开牧地。'),('abraham','lot','en','Uncle and nephew','They migrate together and then separate their pasture.'),
('abraham','hagar','zh-CN','家中关系','家族内部地位不对等的关系。'),('abraham','hagar','en','Household relation','An unequal relation inside the household.'),
('hagar','ishmael','zh-CN','母子','旷野叙事中的相依关系。'),('hagar','ishmael','en','Mother and son','A mutual-dependence relation in the wilderness narrative.'),
('abraham','ishmael','zh-CN','父子','被分离的父子关系。'),('abraham','ishmael','en','Father and son','A father-son relation that is separated.'),
('sarah','hagar','zh-CN','家中对立','围绕继承与地位的冲突。'),('sarah','hagar','en','Household rivalry','A conflict over standing and inheritance.'),
('isaac','rebekah','zh-CN','夫妻','由行程叙事促成的婚姻。'),('isaac','rebekah','en','Spouses','A marriage brought about by a journey narrative.'),
('rebekah','jacob','zh-CN','母子','在继承权叙事中结盟。'),('rebekah','jacob','en','Mother and son','Allied within the inheritance narrative.'),
('rebekah','esau','zh-CN','母子','偏爱结构中的另一端。'),('rebekah','esau','en','Mother and son','The other side of a structure of favouritism.'),
('isaac','esau','zh-CN','父子','被祝福转移打断的关系。'),('isaac','esau','en','Father and son','A relation interrupted by the transferred blessing.'),
('isaac','jacob','zh-CN','父子','以欺瞒取得祝福的一方。'),('isaac','jacob','en','Father and son','The side that gains the blessing by deception.'),
('jacob','esau','zh-CN','兄弟','由冲突转向和解的关系。'),('jacob','esau','en','Brothers','A relation that moves from conflict to reconciliation.'),
('jacob','rachel','zh-CN','夫妻','以长期劳动换取的婚约。'),('jacob','rachel','en','Spouses','A marriage secured through extended labour.'),
('jacob','leah','zh-CN','夫妻','在偏爱结构中处于不利一方。'),('jacob','leah','en','Spouses','The disfavoured side of the household structure.'),
('rachel','leah','zh-CN','姐妹','共处一个家庭的竞争关系。'),('rachel','leah','en','Sisters','A rivalry within one household.'),
('jacob','joseph-son-of-jacob','zh-CN','父子','偏爱引发兄弟冲突。'),('jacob','joseph-son-of-jacob','en','Father and son','Favouritism that triggers sibling conflict.'),
('rachel','joseph-son-of-jacob','zh-CN','母子','长期等待后所得之子。'),('rachel','joseph-son-of-jacob','en','Mother and son','A son born after long waiting.'),
('joseph-son-of-jacob','benjamin','zh-CN','兄弟','同母兄弟，重逢叙事的核心。'),('joseph-son-of-jacob','benjamin','en','Brothers','Full brothers at the centre of the reunion narrative.'),
('joseph-son-of-jacob','judah-son-of-jacob','zh-CN','兄弟','由出卖到担保的转变。'),('joseph-son-of-jacob','judah-son-of-jacob','en','Brothers','A shift from selling him to standing surety for another.'),
('leah','judah-son-of-jacob','zh-CN','母子','后来王室谱系的一环。'),('leah','judah-son-of-jacob','en','Mother and son','A link in the later royal genealogy.'),
('rachel','benjamin','zh-CN','母子','以生产结束的关系。'),('rachel','benjamin','en','Mother and son','A relation ended at his birth.'),
('moses','miriam','zh-CN','姐弟','旷野领导层中的两代表述。'),('moses','miriam','en','Siblings','Two voices within the wilderness leadership.'),
('aaron','miriam','zh-CN','兄妹','同属领导层的兄妹。'),('aaron','miriam','en','Siblings','Siblings within the same leadership group.'),
('moses','jethro','zh-CN','翁婿','提供治理建议的外部关系。'),('moses','jethro','en','Son-in-law and father-in-law','An outside relation that supplies governance advice.'),
('moses','pharaoh-of-the-exodus','zh-CN','对立','出埃及叙事的主要对抗关系。'),('moses','pharaoh-of-the-exodus','en','Adversaries','The principal opposition of the Exodus narrative.'),
('aaron','pharaoh-of-the-exodus','zh-CN','对立','交涉过程中的辅助角色。'),('aaron','pharaoh-of-the-exodus','en','Adversaries','A supporting role in the negotiations.'),
('moses','joshua','zh-CN','师承','领导职分的交接关系。'),('moses','joshua','en','Mentorship','The handover of leadership.'),
('moses','caleb','zh-CN','同盟','探子叙事中的少数意见方。'),('moses','caleb','en','Allies','The minority-assessment side of the scouting narrative.'),
('joshua','caleb','zh-CN','同盟','共同持少数意见的两人。'),('joshua','caleb','en','Allies','The two who hold the minority assessment together.'),
('joshua','rahab','zh-CN','同盟','外来者与本地人的互保。'),('joshua','rahab','en','Allies','Mutual protection between outsider and local.'),
('deborah','barak','zh-CN','同盟','裁决者与军事领袖的合作。'),('deborah','barak','en','Allies','A judge and a commander acting together.'),
('samson','delilah','zh-CN','情感与背叛','以背叛收束的关系。'),('samson','delilah','en','Romance and betrayal','A relation that ends in betrayal.'),
('ruth','boaz','zh-CN','夫妻','以赎回制度促成的婚姻。'),('ruth','boaz','en','Spouses','A marriage enabled by the redemption custom.'),
('samuel','saul','zh-CN','膏立与决裂','先知与第一位王的关系。'),('samuel','saul','en','Anointing and rupture','The relation between prophet and first king.'),
('samuel','david','zh-CN','膏立','王权转移的宗教背书。'),('samuel','david','en','Anointing','The religious endorsement of the transfer of kingship.'),
('boaz','david','zh-CN','家族先祖','谱系上的连接。'),('boaz','david','en','Ancestor','A genealogical connection.'),
('ruth','david','zh-CN','家族先祖','外族先祖进入王室谱系。'),('ruth','david','en','Ancestor','A foreign ancestor enters the royal genealogy.'),
('saul','david','zh-CN','追捕与逃亡','王权焦虑驱动的长期对立。'),('saul','david','en','Pursuit and flight','A long opposition driven by anxiety over the throne.'),
('saul','jonathan','zh-CN','父子','忠诚冲突中的父子。'),('saul','jonathan','en','Father and son','A father and son caught in a conflict of loyalties.'),
('jonathan','david','zh-CN','盟约之交','跨越家族对立的友谊。'),('jonathan','david','en','Covenant friendship','A friendship that crosses a family opposition.'),
('david','goliath','zh-CN','单挑对手','以个人对决决定群体结果。'),('david','goliath','en','Single combat','A collective outcome decided by single combat.'),
('david','abigail','zh-CN','夫妻','由一次交涉促成的婚姻。'),('david','abigail','en','Spouses','A marriage arising from a negotiation.'),
('david','bathsheba','zh-CN','夫妻','起点带有权力不对等的关系。'),('david','bathsheba','en','Spouses','A relation that begins in an asymmetry of power.'),
('nathan','david','zh-CN','进言','宫廷中的批评职能。'),('nathan','david','en','Counsel','A critical function inside the court.'),
('david','joab','zh-CN','君臣','依赖与不信任并存。'),('david','joab','en','King and commander','Dependence and distrust at once.'),
('david','absalom','zh-CN','父子对抗','家族冲突升级为叛乱。'),('david','absalom','en','Father and son in conflict','A household conflict that escalates into revolt.'),
('joab','absalom','zh-CN','对立','以军事手段终结叛乱。'),('joab','absalom','en','Adversaries','The revolt ended by force.'),
('bathsheba','solomon','zh-CN','母子','宫廷继承中的联合。'),('bathsheba','solomon','en','Mother and son','An alliance within the court succession.'),
('david','solomon','zh-CN','父子','王位继承关系。'),('david','solomon','en','Father and son','The succession to the throne.'),
('solomon','rehoboam','zh-CN','父子','政策延续与后果。'),('solomon','rehoboam','en','Father and son','Policy continuity and its consequence.'),
('rehoboam','jeroboam','zh-CN','分裂双方','王国分裂的两位君主。'),('rehoboam','jeroboam','en','Rival kings','The two kings of the division.'),
('solomon','jeroboam','zh-CN','君臣对立','分裂之前的紧张关系。'),('solomon','jeroboam','en','King and official','The tension preceding the division.'),
('ahab','jezebel','zh-CN','夫妻','外交联姻带来的政治宗教组合。'),('ahab','jezebel','en','Spouses','A diplomatic marriage forming a political and religious pair.'),
('elijah','ahab','zh-CN','先知与王','公开对抗关系。'),('elijah','ahab','en','Prophet and king','A relation of public confrontation.'),
('elijah','jezebel','zh-CN','对立','冲突中最尖锐的一对。'),('elijah','jezebel','en','Adversaries','The sharpest opposition in the conflict.'),
('elijah','elisha','zh-CN','师承','先知职分的交接。'),('elijah','elisha','en','Mentorship','The handover of the prophetic office.'),
('ahab','elisha','zh-CN','对立','延续到下一代的紧张关系。'),('ahab','elisha','en','Adversaries','A tension continuing into the next generation.'),
('isaiah','hezekiah','zh-CN','先知与王','危机中的合作关系。'),('isaiah','hezekiah','en','Prophet and king','A cooperative relation during crisis.'),
('jeremiah','nebuchadnezzar','zh-CN','对立','先知与征服者。'),('jeremiah','nebuchadnezzar','en','Adversaries','Prophet and conqueror.'),
('nebuchadnezzar','daniel','zh-CN','君主与朝臣','依赖与威胁并存的宫廷关系。'),('nebuchadnezzar','daniel','en','Ruler and courtier','A court relation of dependence and threat.'),
('jeremiah','ezekiel','zh-CN','同时代先知','分处两地的同期人物。'),('jeremiah','ezekiel','en','Contemporary prophets','Contemporaries in two different places.'),
('daniel','ezekiel','zh-CN','同时代人物','同处被掳群体。'),('daniel','ezekiel','en','Contemporaries','Both within the deported community.'),
('esther','mordecai','zh-CN','养父女','宫廷叙事中的联合行动。'),('esther','mordecai','en','Ward and guardian','Joint action within the court narrative.'),
('mary','joseph-of-nazareth','zh-CN','夫妻','诞生叙事中的家庭单元。'),('mary','joseph-of-nazareth','en','Spouses','The household unit of the birth narrative.'),
('joseph-of-nazareth','jesus','zh-CN','父子','承担谱系连接功能的关系。'),('joseph-of-nazareth','jesus','en','Father and son','The relation carrying the genealogical connection.'),
('jesus','john-the-baptist','zh-CN','亲属与先行者','洗礼叙事中的两个角色。'),('jesus','john-the-baptist','en','Kin and forerunner','Two roles within the baptism narrative.'),
('jesus','andrew','zh-CN','师徒','最早被呼召的门徒之一。'),('jesus','andrew','en','Teacher and disciple','One of the first disciples called.'),
('jesus','john-son-of-zebedee','zh-CN','师徒','核心门徒之一。'),('jesus','john-son-of-zebedee','en','Teacher and disciple','One of the inner group.'),
('jesus','mary-magdalene','zh-CN','师徒','复活叙事的首位见证者。'),('jesus','mary-magdalene','en','Teacher and disciple','The first witness in the resurrection account.'),
('jesus','judas-iscariot','zh-CN','师徒与背叛','以背叛收束的门徒关系。'),('jesus','judas-iscariot','en','Discipleship and betrayal','A disciple relation ending in betrayal.'),
('peter','andrew','zh-CN','兄弟','同为渔夫的兄弟。'),('peter','andrew','en','Brothers','Brothers who are both fishermen.'),
('peter','john-son-of-zebedee','zh-CN','同工','早期群体的核心搭档。'),('peter','john-son-of-zebedee','en','Colleagues','A core pairing in the early community.'),
('jesus','martha','zh-CN','友人','伯大尼家庭的接待关系。'),('jesus','martha','en','Friends','A hosting relation with the Bethany household.'),
('jesus','lazarus','zh-CN','友人','约翰福音转折事件的当事人。'),('jesus','lazarus','en','Friends','The subject of the Johannine turning point.'),
('martha','lazarus','zh-CN','姐弟','同一家庭单元。'),('martha','lazarus','en','Siblings','One household unit.'),
('jesus','pontius-pilate','zh-CN','受审与审判','宗教冲突进入司法程序。'),('jesus','pontius-pilate','en','Defendant and judge','A religious conflict entering judicial procedure.'),
('herod-the-great','jesus','zh-CN','威胁','诞生叙事中的政治威胁。'),('herod-the-great','jesus','en','Threat','The political threat in the birth narrative.'),
('peter','cornelius','zh-CN','同盟','群体边界扩展的关键一对。'),('peter','cornelius','en','Allies','The pair at the widening of the community boundary.'),
('paul','stephen','zh-CN','由对立而起','迫害者与被害者的关系。'),('paul','stephen','en','Opposition','The relation of persecutor and victim.'),
('paul','barnabas','zh-CN','同工','由担保开始、后有分歧的搭档。'),('paul','barnabas','en','Colleagues','A partnership that begins in sponsorship and later diverges.'),
('paul','silas','zh-CN','同工','第二次旅程的搭档。'),('paul','silas','en','Colleagues','Partners on the second journey.'),
('paul','timothy','zh-CN','师徒','跨代同工关系。'),('paul','timothy','en','Mentorship','A cross-generational working relation.'),
('paul','luke','zh-CN','同行','行程记述者与当事人。'),('paul','luke','en','Travelling companions','The chronicler and the subject of the itinerary.'),
('paul','lydia','zh-CN','接待关系','欧洲首个记名接待者。'),('paul','lydia','en','Host relation','The first named host in Europe.'),
('paul','peter','zh-CN','同工与分歧','群体规则上的合作与争论。'),('paul','peter','en','Colleagues and dispute','Cooperation and argument over the community’s rules.'),
('silas','timothy','zh-CN','同工','宣教队伍中的同行者。'),('silas','timothy','en','Colleagues','Fellow members of the mission party.'),
('noah','abraham','zh-CN','谱系连接','起源叙事与族长叙事之间的世系线。'),('noah','abraham','en','Genealogical link','The descent line joining the origin and patriarchal narratives.'),
('abraham','jacob','zh-CN','祖孙','三代族长叙事的跨代连接。'),('abraham','jacob','en','Grandfather and grandson','The cross-generation link of the three-patriarch narrative.'),
('jacob','moses','zh-CN','谱系连接','族长叙事与出埃及叙事之间的世系线。'),('jacob','moses','en','Genealogical link','The descent line joining the patriarchal and Exodus narratives.'),
('david','jesus','zh-CN','谱系连接','福音书引用的王室谱系。'),('david','jesus','en','Genealogical link','The royal genealogy cited by the Gospels.'),
('ruth','jesus','zh-CN','谱系连接','外族先祖出现在福音书谱系中。'),('ruth','jesus','en','Genealogical link','A foreign ancestor appearing in the Gospel genealogy.')
) AS v(from_slug,to_slug,locale,label,summary)
  ON fc.slug=v.from_slug AND tc.slug=v.to_slug
WHERE r.work_id='10000000-0000-4000-8000-000000000005' AND r.id::text LIKE '72000000%'
ON CONFLICT (relation_id,locale) DO NOTHING;

INSERT INTO relation_sources(relation_id,source_id)
SELECT r.id,s.id FROM character_relations r
JOIN characters fc ON fc.id=r.from_character_id
JOIN LATERAL (
  SELECT src.id FROM sources src
  JOIN character_sources cs ON cs.source_id=src.id AND cs.character_id=fc.id
  WHERE src.work_id=r.work_id ORDER BY src.title LIMIT 1
) s ON true
WHERE r.work_id='10000000-0000-4000-8000-000000000005' AND r.id::text LIKE '72000000%'
ON CONFLICT DO NOTHING;

COMMIT;
