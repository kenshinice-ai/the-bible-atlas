BEGIN;

-- =========================================================================
-- 015_bible_full_06_united-monarchy.sql
-- Chapter K=06 slug='united-monarchy' (Samuel–Kings), era -1030..-930
-- Adds 13 characters, 6 locations, 16 new events, relations, and reorders
-- the fifteen pre-existing united-monarchy events into the 6001-6999 band.
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,icon_variant,importance) VALUES
('43000000-0000-4000-8006-000000000001','10000000-0000-4000-8000-000000000005','michal',600,'female','adult','supporting','unknown',NULL,NULL,'person',3),
('43000000-0000-4000-8006-000000000002','10000000-0000-4000-8000-000000000005','abner',601,'male','adult','supporting','unknown',NULL,NULL,'soldier',3),
('43000000-0000-4000-8006-000000000003','10000000-0000-4000-8000-000000000005','ish-bosheth',602,'male','adult','supporting','unknown',NULL,NULL,'king',2),
('43000000-0000-4000-8006-000000000004','10000000-0000-4000-8000-000000000005','uriah',603,'male','adult','supporting','unknown',NULL,NULL,'soldier',2),
('43000000-0000-4000-8006-000000000005','10000000-0000-4000-8000-000000000005','amnon',604,'male','youth','antagonist','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8006-000000000006','10000000-0000-4000-8000-000000000005','tamar-daughter-of-david',605,'female','youth','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8006-000000000007','10000000-0000-4000-8000-000000000005','ahithophel',606,'male','elder','antagonist','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8006-000000000008','10000000-0000-4000-8000-000000000005','adonijah',607,'male','adult','antagonist','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8006-000000000009','10000000-0000-4000-8000-000000000005','zadok',608,'male','adult','supporting','unknown',NULL,NULL,'priest',3),
('43000000-0000-4000-8006-000000000010','10000000-0000-4000-8000-000000000005','abiathar',609,'male','adult','supporting','unknown',NULL,NULL,'priest',2),
('43000000-0000-4000-8006-000000000011','10000000-0000-4000-8000-000000000005','mephibosheth',610,'male','adult','supporting','unknown',NULL,NULL,'person',2),
('43000000-0000-4000-8006-000000000012','10000000-0000-4000-8000-000000000005','hiram-of-tyre',611,'male','adult','supporting','historical',NULL,NULL,'king',2),
('43000000-0000-4000-8006-000000000013','10000000-0000-4000-8000-000000000005','queen-of-sheba',612,'female','adult','supporting','unknown',NULL,NULL,'queen',3)
ON CONFLICT DO NOTHING;

INSERT INTO character_translations(character_id,locale,name,summary,status,aliases,detail,motivation)
SELECT c.id,v.locale::locale_code,v.name,v.summary,'published',v.aliases,v.detail,v.motivation FROM characters c JOIN (VALUES
('michal','zh-CN','米甲','扫罗的小女儿,大卫的第一位妻子。',ARRAY[]::text[],'因爱大卫而被扫罗许配给他,曾在夜里用绳子把大卫从窗户缒下,救他脱离父亲差来的使者;后被扫罗改嫁帕铁,又被接回大卫身边;约柜进城时她见大卫在民前踊跃跳舞,心里轻视他,终身无子。','起初出于对大卫的爱情,后陷于两家争斗的夹缝之中。'),
('michal','en','Michal','Saul’s younger daughter and David’s first wife.',ARRAY[]::text[],'Given to David because she loved him, she once let him down through a window by night to escape her father’s messengers; Saul later gave her to Palti, and David reclaimed her. When the ark entered the city she despised David for dancing before the people, and she remained childless.','Love for David at first, then a life caught between two rival houses.'),
('abner','zh-CN','押尼珥','扫罗的元帅,后拥立伊施波设,归附大卫时在希伯仑被约押刺杀。',ARRAY[]::text[],'扫罗的堂兄弟,长期统领扫罗的军队;扫罗死后在玛哈念立伊施波设为王,与大卫家常年争战;因妃嫔利斯巴之事与伊施波设反目,转而联络以色列众长老归附大卫,却在希伯仑城门被约押暗杀,为亚撒黑之死报仇。','先求保全扫罗家的权柄,后图促成全以色列归于大卫。'),
('abner','en','Abner','Saul’s army commander, who set up Ish-bosheth and was murdered by Joab at Hebron while defecting to David.',ARRAY[]::text[],'Saul’s kinsman and longtime commander, he made Ish-bosheth king at Mahanaim after Saul’s death and warred with the house of David; after a quarrel over the concubine Rizpah he negotiated to bring all Israel over to David, but Joab killed him in the gate of Hebron in revenge for Asahel.','First to preserve the power of Saul’s house, then to deliver Israel to David.'),
('ish-bosheth','zh-CN','伊施波设','扫罗之子,被押尼珥立于玛哈念作以色列王,后遭刺杀。',ARRAY['伊施巴力']::text[],'扫罗阵亡后由押尼珥拥立,在玛哈念作以色列王约二年,与犹大家的大卫相争;押尼珥离去后势力衰微,午睡时被两个军长刺杀,首级被送到希伯仑,大卫下令处死凶手。','维系父家摇摇欲坠的王位。'),
('ish-bosheth','en','Ish-bosheth','Saul’s son, made king of Israel at Mahanaim by Abner and later assassinated.',ARRAY['Ishbaal']::text[],'Set up by Abner after Saul fell, he reigned about two years at Mahanaim against David’s house of Judah; weakened after Abner’s departure, he was murdered in his midday rest by two of his captains, whose deed David punished with death.','To hold together his father’s crumbling throne.'),
('uriah','zh-CN','乌利亚','赫人乌利亚,拔示巴的丈夫,大卫的勇士,被设计死于阵前。',ARRAY['赫人乌利亚']::text[],'名列大卫勇士册的赫人;围攻拉巴期间被召回耶路撒冷,却因约柜与战友尚在田野安营而不肯回家安睡;他亲手带着写有自己死令的书信回到军中,约押将他派往战事最险之处,他就阵亡了。','与约柜和同袍共进退的军人本分。'),
('uriah','en','Uriah','Uriah the Hittite, Bathsheba’s husband and one of David’s mighty men, contrived to die in battle.',ARRAY['Uriah the Hittite']::text[],'A Hittite listed among David’s mighty men; recalled to Jerusalem during the siege of Rabbah, he refused the comforts of home while the ark and his comrades camped in the open field. He carried back the letter ordering his own death, and Joab placed him where the fighting was fiercest.','A soldier’s loyalty to the ark and to his comrades in the field.'),
('amnon','zh-CN','暗嫩','大卫的长子,玷辱异母妹妹他玛,后被押沙龙所杀。',ARRAY[]::text[],'大卫在希伯仑所生的长子;听从约拿达的诡计装病,骗他玛前来伺候而玷辱她,事后反生厌恶将她赶出;两年后在剪羊毛的筵席上被押沙龙的仆人击杀。','放纵情欲,不顾骨肉与国法。'),
('amnon','en','Amnon','David’s firstborn, who violated his half-sister Tamar and was later killed by Absalom.',ARRAY[]::text[],'David’s eldest son, born at Hebron; following Jonadab’s scheme he feigned illness, lured Tamar to attend him, violated her, and then turned on her with loathing. Two years later Absalom’s servants struck him down at a sheep-shearing feast.','Unchecked desire, heedless of kinship and law.'),
('tamar-daughter-of-david','zh-CN','他玛(大卫之女)','大卫的女儿,押沙龙的同母妹妹,遭暗嫩玷辱。',ARRAY[]::text[],'容貌美丽的王女,奉父命去照料装病的暗嫩,反遭玷辱与驱逐;她把灰尘撒在头上,撕裂彩衣哀哭而去,此后凄凉地住在哥哥押沙龙家中。','求哥哥不要行这在以色列中不当行的丑事。'),
('tamar-daughter-of-david','en','Tamar (daughter of David)','David’s daughter and Absalom’s full sister, violated by Amnon.',ARRAY[]::text[],'A beautiful royal daughter sent by her father to tend the supposedly ill Amnon, she was violated and then cast out; she put ashes on her head, tore her ornamented robe, and went away crying, living desolate afterward in her brother Absalom’s house.','She pleaded that such a thing ought not to be done in Israel.'),
('ahithophel','zh-CN','亚希多弗','大卫的谋士,转投押沙龙,计谋被废后自缢身亡。',ARRAY[]::text[],'基罗人,所出的主意在当时如同神的谕旨;押沙龙叛乱时应召入伙,献策趁夜追击大卫;及至见自己的计谋被户筛的言语破坏,便回本城安排家事,自缢而死,葬在父亲的坟墓里。','以自己的谋略押注新主,求保全声名与地位。'),
('ahithophel','en','Ahithophel','David’s counselor who joined Absalom and hanged himself when his counsel was set aside.',ARRAY[]::text[],'A Gilonite whose advice was esteemed like the oracle of God; summoned into Absalom’s revolt, he urged an immediate night pursuit of David. When he saw his counsel defeated by Hushai’s words, he went home to his city, set his house in order, and hanged himself.','He staked his renowned counsel on a new master.'),
('adonijah','zh-CN','亚多尼雅','大卫之子,在大卫年迈时自立为王,争位失败后终被处死。',ARRAY[]::text[],'哈及所生的王子,容貌俊美;趁父亲年迈,为自己预备车马与五十人奔走,在隐罗结献祭称王,得约押与亚比亚他相助;所罗门在基训受膏后其党羽四散,他抱住祭坛角求赦;后因求娶亚比煞再触忌讳,被所罗门处死。','趁父王衰老抢先夺取王位。'),
('adonijah','en','Adonijah','David’s son who set himself up as king in David’s old age and was finally put to death.',ARRAY[]::text[],'A handsome prince borne by Haggith, he prepared chariots, horsemen, and fifty runners, and had himself proclaimed king at En-rogel with the help of Joab and Abiathar; when Solomon was anointed at Gihon his followers scattered and he clung to the horns of the altar. His later request for Abishag cost him his life.','To seize the throne before his aged father’s death.'),
('zadok','zh-CN','撒督','大卫与所罗门时代的祭司,在基训膏立所罗门为王。',ARRAY[]::text[],'亚伦后裔中的祭司;押沙龙叛乱时忠于大卫,奉命抬约柜回耶路撒冷并留城通报消息;亚多尼雅争位时未从其党,与先知拿单一同在基训膏立所罗门;其后裔长期执掌圣殿祭司职任。','持守祭司职分,忠于受膏的王。'),
('zadok','en','Zadok','Priest in the days of David and Solomon, who anointed Solomon king at Gihon.',ARRAY[]::text[],'A priest of Aaron’s line, loyal to David through Absalom’s revolt, when he was sent back into Jerusalem with the ark to send word from the city; standing apart from Adonijah’s faction, he anointed Solomon at Gihon with Nathan the prophet, and his descendants long held the temple priesthood.','Faithfulness to his priestly office and to the anointed king.'),
('abiathar','zh-CN','亚比亚他','挪伯祭司家的幸存者,随大卫多年,后因附从亚多尼雅被革职。',ARRAY[]::text[],'祭司亚希米勒之子,挪伯祭司被屠时唯一逃脱者,带着以弗得投奔逃亡中的大卫,长年随行求问;晚年却附从亚多尼雅争位,所罗门念他抬过约柜、与大卫同受苦难而不杀他,将他逐回亚拿突,革除祭司职任。','早年与大卫共患难,晚年错押了继位人。'),
('abiathar','en','Abiathar','Survivor of the priests of Nob who served David for years, deposed for siding with Adonijah.',ARRAY[]::text[],'Son of Ahimelech, the one priest to escape the slaughter at Nob, he fled to David with the ephod and inquired for him through the fugitive years; in old age he backed Adonijah’s bid, and Solomon, sparing his life for having borne the ark and shared David’s afflictions, banished him to Anathoth and removed him from the priesthood.','He shared David’s hardships, yet backed the wrong successor at the end.'),
('mephibosheth','zh-CN','米非波设','约拿单之子,双腿残疾,蒙大卫恩待同席吃饭。',ARRAY['米力巴力']::text[],'五岁时乳母闻基利波败讯抱他逃跑,跌落致双腿残疾;大卫为约拿单的缘故寻访扫罗家的余人,将扫罗的田地都归还他,命洗巴为他耕种,让他常与王同席吃饭,如王的儿子一般。','在倾覆的家族之后寻得安身之地。'),
('mephibosheth','en','Mephibosheth','Jonathan’s son, lame in both feet, shown kindness at David’s table.',ARRAY['Merib-baal']::text[],'Dropped by his nurse as she fled at the news of Gilboa when he was five, he was left lame in both feet; seeking out Saul’s survivors for Jonathan’s sake, David restored to him all Saul’s land, set Ziba to farm it, and gave him a constant place at the king’s table like one of the king’s sons.','A place of safety after the fall of his father’s house.'),
('hiram-of-tyre','zh-CN','希兰(推罗王)','推罗王,大卫与所罗门的盟友,为建殿供应香柏木与工匠。',ARRAY['希兰一世']::text[],'与大卫素来相好,曾运香柏木并派工匠为大卫建造宫室;所罗门登基后与他立约,由推罗供应香柏木、松木与巧匠,以色列则以麦子和清油偿付;后来两国还合组船队往俄斐运金。','借结盟与贸易共享两国之利。'),
('hiram-of-tyre','en','Hiram (king of Tyre)','King of Tyre, ally of David and Solomon, supplier of cedar and craftsmen for the temple.',ARRAY['Hiram I']::text[],'A longtime friend of David, for whom he sent cedar and craftsmen to build a palace; he made a treaty with Solomon, floating cedar and cypress down by sea in rafts and lending skilled workmen in exchange for wheat and oil, and later joined Solomon in a fleet that sailed for the gold of Ophir.','Mutual gain through alliance and trade.'),
('queen-of-sheba','zh-CN','示巴女王','自南方远道而来、用难题考验所罗门智慧的女王。',ARRAY[]::text[],'听闻所罗门因耶和华之名所得的名声,率驼队满载香料、宝石与许多金子来到耶路撒冷,用难解的话试问所罗门;见他一一答明,又见其宫室饮食与臣仆班次,便诧异得神不守舍,承认所听见的还不及所见的一半。','亲自验证远方传闻中的智慧。'),
('queen-of-sheba','en','Queen of Sheba','The queen from the south who came to test Solomon’s wisdom with hard questions.',ARRAY[]::text[],'Hearing of Solomon’s fame connected with the name of the Lord, she came to Jerusalem with camels bearing spices, precious stones, and much gold, and tried him with riddles; when he answered them all and she saw his house, his table, and the order of his servants, there was no more spirit in her, and she confessed the half had not been told.','To verify for herself the wisdom reported from afar.')
) AS v(slug,locale,name,summary,aliases,detail,motivation) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 2. LOCATIONS (reuse hebron, jerusalem, ramah, bethlehem, mount-gilboa,
--    valley-of-elah; 6 new)
-- -------------------------------------------------------------------------
INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom,modern_country_code,is_inferred,still_exists) VALUES
('33000000-0000-4000-8006-000000000001','10000000-0000-4000-8000-000000000005','endor','real',ST_GeogFromText('POINT(35.3830 32.6320)'),NULL,NULL,600,'city','approximate',9,'IL',false,false),
('33000000-0000-4000-8006-000000000002','10000000-0000-4000-8000-000000000005','gibeah-of-saul','real',ST_GeogFromText('POINT(35.2310 31.8240)'),NULL,NULL,601,'city','approximate',9,'IL',false,false),
('33000000-0000-4000-8006-000000000003','10000000-0000-4000-8000-000000000005','ziklag-reference','real',ST_GeogFromText('POINT(34.8670 31.3800)'),NULL,NULL,602,'city','inferred',8,'IL',true,false),
('33000000-0000-4000-8006-000000000004','10000000-0000-4000-8000-000000000005','mahanaim-reference','real',ST_GeogFromText('POINT(35.6690 32.1970)'),NULL,NULL,603,'city','inferred',8,'JO',true,false),
('33000000-0000-4000-8006-000000000005','10000000-0000-4000-8000-000000000005','rabbah-of-ammon','real',ST_GeogFromText('POINT(35.9340 31.9540)'),NULL,NULL,604,'city','city_centroid',9,'JO',false,true),
('33000000-0000-4000-8006-000000000006','10000000-0000-4000-8000-000000000005','tyre','real',ST_GeogFromText('POINT(35.1970 33.2700)'),NULL,NULL,605,'city','city_centroid',9,'LB',false,true)
ON CONFLICT DO NOTHING;

INSERT INTO location_translations(location_id,locale,name,summary,status,aliases,detail,literary_significance,historical_background,modern_status,historical_region_name)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published',ARRAY[]::text[],'','','','',v.region FROM locations l JOIN (VALUES
('endor','zh-CN','隐多珥','摩利冈北麓的村落,扫罗在基利波战前夜访交鬼妇人之处。','耶斯列谷'),
('endor','en','Endor','A village on the northern slope of the hill of Moreh, where Saul visited the medium on the eve of Gilboa.','Jezreel Valley'),
('gibeah-of-saul','zh-CN','基比亚(扫罗的基比亚)','便雅悯地的山城,扫罗作王时的驻地,一般认作富勒丘遗址。','便雅悯'),
('gibeah-of-saul','en','Gibeah of Saul','A hill town in Benjamin, Saul’s royal seat, commonly identified with Tell el-Ful.','Benjamin'),
('ziklag-reference','zh-CN','洗革拉(推定位置)','非利士王亚吉赐给大卫的南地城镇,确切位置有争议。','南地(尼革夫)'),
('ziklag-reference','en','Ziklag (traditional site)','The Negev town granted to David by Achish of Gath; its exact site is debated.','Negev'),
('mahanaim-reference','zh-CN','玛哈念(推定位置)','约旦河东基列地的城,伊施波设的都城,大卫避押沙龙时也曾驻此。','基列'),
('mahanaim-reference','en','Mahanaim (traditional site)','A city of Gilead east of the Jordan, Ish-bosheth’s capital and David’s refuge during Absalom’s revolt.','Gilead'),
('rabbah-of-ammon','zh-CN','拉巴(亚扪)','亚扪人的都城,约押围攻之地,即今约旦安曼。','亚扪'),
('rabbah-of-ammon','en','Rabbah of Ammon','The Ammonite capital besieged by Joab, on the site of modern Amman.','Ammon'),
('tyre','zh-CN','推罗','腓尼基的海港王城,希兰王由此为大卫与所罗门输送木料与工匠。','腓尼基'),
('tyre','en','Tyre','The Phoenician island-port from which King Hiram sent timber and craftsmen to David and Solomon.','Phoenicia')
) AS v(slug,locale,name,summary,region) ON l.slug=v.slug AND l.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 3. EVENTS (new) -- range dates within era -1030..-930, chapter
--    'united-monarchy'
-- -------------------------------------------------------------------------
INSERT INTO events(id,work_id,slug,sequence,reality,event_type,time_type,calendar_system,historical_start_year,historical_end_year,confidence,chapter_id)
SELECT ('63000000-0000-4000-8006-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',v.slug,v.seq,
       v.reality::event_reality,v.etype::literary_event_type,'range'::event_time_type,'unknown'::calendar_system,
       v.y1,v.y2,v.conf::confidence_level,ch.id
FROM (VALUES
(1,'david-marries-michal',6011,'reported_historical','marriage',-1025,-995,'low'),
(2,'david-at-ziklag',6017,'reported_historical','migration',-1020,-990,'low'),
(3,'saul-consults-the-medium-at-endor',6019,'legendary_or_mythic','religious',-1015,-985,'low'),
(4,'david-anointed-king-at-hebron',6023,'reported_historical','political',-1010,-980,'medium'),
(5,'ish-bosheth-reigns-at-mahanaim',6025,'reported_historical','political',-1010,-980,'low'),
(6,'abner-defects-and-is-killed',6027,'reported_historical','death',-1005,-975,'low'),
(7,'ark-brought-to-jerusalem',6033,'reported_historical','religious',-1000,-960,'medium'),
(8,'mephibosheth-at-davids-table',6035,'reported_historical','social',-995,-960,'low'),
(9,'uriah-sent-to-his-death',6037,'reported_historical','betrayal',-990,-955,'low'),
(10,'amnon-and-tamar',6041,'reported_historical','betrayal',-985,-950,'low'),
(11,'ahithophels-counsel-rejected',6045,'reported_historical','political',-980,-945,'low'),
(12,'adonijahs-bid-for-the-throne',6049,'reported_historical','political',-975,-940,'low'),
(13,'solomon-judges-between-two-women',6053,'reported_historical','trial',-970,-935,'low'),
(14,'hiram-supplies-the-temple-project',6055,'reported_historical','political',-970,-935,'low'),
(15,'dedication-of-the-temple',6059,'reported_historical','religious',-965,-930,'medium'),
(16,'queen-of-sheba-visits-jerusalem',6061,'reported_historical','meeting',-960,-930,'low')
) AS v(n,slug,seq,reality,etype,y1,y2,conf)
JOIN chapters ch ON ch.slug='united-monarchy' AND ch.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 4. Reorder existing united-monarchy events into the 6001-6999 band
-- -------------------------------------------------------------------------
UPDATE events e SET sequence=v.seq FROM (VALUES
  ('samuel-anoints-saul',6001),
  ('saul-rejected-at-ramah',6003),
  ('samuel-anoints-david-at-bethlehem',6005),
  ('david-and-goliath-in-the-valley-of-elah',6007),
  ('jonathan-and-david-make-a-covenant',6009),
  ('david-a-fugitive-in-the-south',6013),
  ('abigail-intercedes',6015),
  ('saul-and-jonathan-die-on-gilboa',6021),
  ('david-becomes-king',6029),
  ('jerusalem-royal-capital',6031),
  ('bathsheba-and-nathans-rebuke',6039),
  ('absaloms-revolt',6043),
  ('death-of-absalom',6047),
  ('solomon-succeeds-david',6051),
  ('first-temple-built',6057)
) AS v(slug,seq) WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug=v.slug;

-- -------------------------------------------------------------------------
-- 5. EVENT TRANSLATIONS
-- -------------------------------------------------------------------------
INSERT INTO event_translations(event_id,locale,title,summary,status,detail,significance,time_label)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published',v.detail,v.sig,v.tl FROM events e JOIN (VALUES
('david-marries-michal','zh-CN','大卫娶米甲','扫罗以一百非利士人的阳皮为聘礼,把爱大卫的小女儿米甲嫁给他。','扫罗本想借非利士人的手除掉大卫,大卫却带回双倍的聘礼;米甲爱大卫,后来还在夜里用绳子把他从窗户缒下,救他逃脱扫罗差来守宅的使者。','这段婚姻把大卫系入王室,也成为扫罗家与大卫家纠葛的开端。','约公元前 1025–995 年'),
('david-marries-michal','en','David marries Michal','Saul gives his younger daughter Michal, who loves David, for a bride-price of a hundred Philistine foreskins.','Saul hoped the Philistines would kill David, but he returned with double the price; Michal loved David, and later let him down through a window by night to escape the messengers Saul had set to watch his house.','The marriage binds David into the royal house and begins the entanglement of the two houses.','c. 1025–995 BCE'),
('david-at-ziklag','zh-CN','大卫居洗革拉','逃亡的大卫投奔迦特王亚吉,受赐南地的洗革拉为居所。','大卫率六百人依附亚吉,住洗革拉一年零四个月,从那里出击南方诸族;亚玛力人趁众人随军外出焚掠洗革拉、掳走妇孺,大卫追击夺回所失的一切,并把掠物分送犹大诸城的长老。','洗革拉岁月让大卫在犹大南部积累了人望,为他日后在希伯仑受膏铺路。','约公元前 1020–990 年'),
('david-at-ziklag','en','David at Ziklag','The fugitive David takes service with Achish of Gath and receives the Negev town of Ziklag.','With six hundred men David lived at Ziklag a year and four months, raiding southward from there; while the men were away the Amalekites burned Ziklag and carried off the women and children, and David pursued, recovered everything, and shared the spoil with the elders of the towns of Judah.','The Ziklag years win David standing in southern Judah, preparing his anointing at Hebron.','c. 1020–990 BCE'),
('saul-consults-the-medium-at-endor','zh-CN','扫罗夜访隐多珥的交鬼妇人','大战前夕,改装的扫罗求隐多珥的妇人招上撒母耳来。','非利士大军压境,扫罗求问耶和华却得不到回答,便改换衣装夜访交鬼的妇人;招上来的撒母耳宣告国已归与大卫,明日扫罗与众子必与他同在;扫罗惊恐仆倒,浑身无力。','为基利波之败与扫罗之死投下浓重的阴影。','约公元前 1015–985 年'),
('saul-consults-the-medium-at-endor','en','Saul consults the medium at Endor','On the eve of battle a disguised Saul asks the woman of Endor to bring up Samuel.','With the Philistine host encamped and the Lord giving him no answer, Saul goes by night in disguise to a medium; the Samuel who is brought up declares the kingdom given to David and that Saul and his sons will be with him on the morrow, and Saul falls full length, drained of strength.','Casts its long shadow over the defeat at Gilboa and Saul’s death.','c. 1015–985 BCE'),
('david-anointed-king-at-hebron','zh-CN','大卫在希伯仑受膏作犹大王','扫罗死后,犹大人在希伯仑膏大卫作犹大家的王。','大卫求问耶和华后携众上希伯仑,犹大人前来膏他作王;他在希伯仑作犹大王七年零六个月,并遣使厚待安葬扫罗的基列雅比人。','大卫王权的第一步,南北两家分立的局面由此形成。','约公元前 1010–980 年'),
('david-anointed-king-at-hebron','en','David anointed king at Hebron','After Saul’s death the men of Judah anoint David king over the house of Judah at Hebron.','Having inquired of the Lord, David goes up to Hebron with his men, and Judah anoints him king; he reigns there seven years and six months, and sends thanks to the men of Jabesh-gilead who buried Saul.','The first step of David’s kingship, opening the split between north and south.','c. 1010–980 BCE'),
('ish-bosheth-reigns-at-mahanaim','zh-CN','伊施波设在玛哈念作王','押尼珥将扫罗之子伊施波设立于河东的玛哈念,作以色列的王。','押尼珥拥立伊施波设统辖基列与以色列众支派,与犹大家常年争战;基遍池旁的比武酿成恶战,押尼珥杀死追赶他的亚撒黑,埋下与约押的仇怨。','扫罗家与大卫家的拉锯,是统一王国成形前最后的内战。','约公元前 1010–980 年'),
('ish-bosheth-reigns-at-mahanaim','en','Ish-bosheth reigns at Mahanaim','Abner sets up Saul’s son Ish-bosheth as king of Israel at Mahanaim beyond the Jordan.','Abner makes him king over Gilead and the tribes of Israel, and long war follows with the house of Judah; the contest by the pool of Gibeon turns deadly, and Abner kills the pursuing Asahel, sowing his feud with Joab.','The tug-of-war between the two houses is the last civil war before the united kingdom takes shape.','c. 1010–980 BCE'),
('abner-defects-and-is-killed','zh-CN','押尼珥归附大卫及其被杀','押尼珥转而联络大卫,却在希伯仑城门被约押刺杀。','押尼珥因利斯巴之事与伊施波设反目,遣使见大卫,又劝以色列众长老归顺;大卫设宴送他平安离去,约押却把他骗回,在城门的瓮洞里刺透他的肚腹,为兄弟亚撒黑报仇;大卫哀哭说“以色列中一个作元帅的大丈夫今日倒毙了”。','扫罗家最后的支柱倒下,全以色列归大卫的路就此打开。','约公元前 1005–975 年'),
('abner-defects-and-is-killed','en','Abner defects and is killed','Abner turns to David, only to be murdered by Joab in the gate of Hebron.','Estranged from Ish-bosheth over Rizpah, Abner treats with David and urges the elders of Israel to submit; David feasts him and sends him away in peace, but Joab calls him back and stabs him in the gateway to avenge Asahel, and David laments that a prince and a great man has fallen in Israel.','With the last pillar of Saul’s house gone, the way opens for all Israel to come to David.','c. 1005–975 BCE'),
('ark-brought-to-jerusalem','zh-CN','约柜运入耶路撒冷','大卫将神的约柜从基列耶琳迎入大卫城,在城中欢庆献祭。','首次起运时乌撒因扶柜被击杀,约柜停在俄别以东家三个月;大卫再度迎柜,穿着细麻布以弗得在耶和华面前极力跳舞,吹角欢呼;米甲从窗户看见,心里轻视他,大卫却说他甘愿为此更加卑微。','约柜进城使耶路撒冷从此兼为王都与圣所之城。','约公元前 1000–960 年'),
('ark-brought-to-jerusalem','en','The ark brought to Jerusalem','David brings the ark of God from Kiriath-jearim into the city of David with rejoicing and sacrifice.','On the first attempt Uzzah is struck down for steadying the ark, which rests three months in the house of Obed-edom; David then brings it up, dancing before the Lord with all his might in a linen ephod amid shouts and trumpets, while Michal watches from a window and despises him.','The ark’s entry makes Jerusalem at once royal capital and city of the sanctuary.','c. 1000–960 BCE'),
('mephibosheth-at-davids-table','zh-CN','米非波设与王同席','大卫为约拿单的缘故恩待扫罗的孙子米非波设。','大卫查问扫罗家还有何人,得知约拿单尚有一个双腿残疾的儿子;他将扫罗的田地尽都归还,命洗巴一家为他耕种,并让米非波设如王子一般常与王同席吃饭。','在两家世仇的叙事中,这是一段以恩慈守约的插曲。','约公元前 995–960 年'),
('mephibosheth-at-davids-table','en','Mephibosheth at David’s table','For Jonathan’s sake David shows kindness to Saul’s grandson Mephibosheth.','Asking whether any of Saul’s house remains, David learns of Jonathan’s son, lame in both feet; he restores all Saul’s land, sets Ziba’s household to farm it, and gives Mephibosheth a constant place at the king’s table like one of the king’s sons.','Amid the feud of the two houses, an interlude of covenant kindness kept.','c. 995–960 BCE'),
('uriah-sent-to-his-death','zh-CN','乌利亚被送死','大卫写信给约押,把乌利亚派到阵势险处,使他战死拉巴城下。','大卫召乌利亚回京想遮掩拔示巴怀孕之事,乌利亚却不肯回家安睡;大卫便让他亲手带信给约押,信中吩咐把他派在阵势极险之处,然后众人退后;乌利亚就在拉巴城下阵亡,大卫娶了拔示巴。','这封书信成为大卫王朝叙事的道德转折点,引出拿单的责备。','约公元前 990–955 年'),
('uriah-sent-to-his-death','en','Uriah sent to his death','David writes to Joab to set Uriah in the fiercest fighting before Rabbah, and he falls.','Recalled to cover Bathsheba’s pregnancy, Uriah will not go down to his house; David then has him carry his own death warrant to Joab, ordering him placed where the battle is hardest and abandoned; Uriah falls before Rabbah, and David takes Bathsheba as wife.','The letter is the moral turning point of the Davidic narrative, and brings on Nathan’s rebuke.','c. 990–955 BCE'),
('amnon-and-tamar','zh-CN','暗嫩玷辱他玛','大卫的长子暗嫩装病骗妹妹他玛前来,将她玷辱又赶出门外。','暗嫩听从约拿达的诡计装病,求王打发他玛来做饼伺候,遂强行玷辱她,事后恨恶更甚于先前的爱,叫仆人把她赶出;他玛撕裂彩衣、把灰撒在头上哀哭离去,住在押沙龙家中;两年后押沙龙在剪羊毛的筵席上杀了暗嫩。','这桩家变点燃押沙龙的仇恨,成为王室内乱的引信。','约公元前 985–950 年'),
('amnon-and-tamar','en','Amnon and Tamar','David’s firstborn Amnon feigns illness to lure his sister Tamar, violates her, and casts her out.','Following Jonadab’s scheme, Amnon has the king send Tamar to cook for him, forces her, and then hates her more than he had loved her, ordering her thrown out; she tears her robe, puts ashes on her head, and lives desolate in Absalom’s house; two years later Absalom has Amnon killed at his sheep-shearing feast.','The outrage kindles Absalom’s hatred and lights the fuse of the palace revolt.','c. 985–950 BCE'),
('ahithophels-counsel-rejected','zh-CN','亚希多弗之谋被废','押沙龙弃亚希多弗的急袭之策而从户筛的缓兵之计,亚希多弗自缢。','亚希多弗献策当夜率一万二千人追击疲乏的大卫,单击杀王一人;户筛却劝押沙龙聚集全以色列再战;耶和华定意破坏亚希多弗的良谋,降祸与押沙龙;亚希多弗见计不从,备驴回本城,安排好家事便自缢而死。','谋士之死预告叛乱的败局,也成为经文中命运急转的名场面。','约公元前 980–945 年'),
('ahithophels-counsel-rejected','en','Ahithophel’s counsel rejected','Absalom sets aside Ahithophel’s plan for an immediate strike in favor of Hushai’s delay, and Ahithophel hangs himself.','Ahithophel asks for twelve thousand men to fall that night on the weary David and kill the king alone; Hushai counsels gathering all Israel first, for the Lord had ordained to defeat Ahithophel’s good counsel and bring evil on Absalom; seeing his advice refused, Ahithophel saddles his donkey, goes home, sets his house in order, and hangs himself.','The counselor’s death foretells the revolt’s ruin, in one of the narrative’s sharpest turns of fortune.','c. 980–945 BCE'),
('adonijahs-bid-for-the-throne','zh-CN','亚多尼雅谋取王位','大卫年迈时,王子亚多尼雅在隐罗结自立为王。','亚多尼雅为自己预备车马与五十人奔走,在隐罗结的磐石旁献祭设筵,约押与祭司亚比亚他附从他,却不请拿单、撒督与所罗门;拿单与拔示巴入宫提醒大卫所起的誓,大卫遂命撒督与拿单在基训膏所罗门;号角一响,亚多尼雅的众客四散,他抱住祭坛的角求所罗门起誓不杀他。','王位继承的明争摆上台面,直接引出所罗门受膏登基。','约公元前 975–940 年'),
('adonijahs-bid-for-the-throne','en','Adonijah’s bid for the throne','As David grows old, the prince Adonijah has himself proclaimed king at En-rogel.','Adonijah prepares chariots, horsemen, and fifty runners, and sacrifices by the stone at En-rogel with Joab and Abiathar the priest, inviting neither Nathan, Zadok, nor Solomon; Nathan and Bathsheba remind David of his oath, and at his order Zadok and Nathan anoint Solomon at Gihon; at the trumpet blast Adonijah’s guests scatter, and he clings to the horns of the altar until Solomon swears to spare him.','The open contest for the succession leads straight into Solomon’s anointing and accession.','c. 975–940 BCE'),
('solomon-judges-between-two-women','zh-CN','所罗门断二妇争子案','两个妇人争夺一个活孩子,所罗门以刀剑试出真母亲。','两个同住的妇人各生一子,一子夜里死去,二人都称活着的是自己的;所罗门吩咐拿刀来把活孩子劈成两半各分一半,亲母心疼如焚,宁愿把孩子让给对方;王便断定她是真母亲,把孩子判归于她。','以色列众人听见都敬畏王,见他心里有神的智慧能以断案。','约公元前 970–935 年'),
('solomon-judges-between-two-women','en','Solomon judges between two women','Two women claim one living child, and Solomon’s sword test reveals the true mother.','Two women of one house each bear a son, and when one child dies in the night both claim the living boy; Solomon calls for a sword to divide the child in two, and the true mother, her heart burning for her son, begs that he be given alive to the other; the king then awards her the child.','All Israel hears of the judgment and stands in awe, seeing the wisdom of God in the king.','c. 970–935 BCE'),
('hiram-supplies-the-temple-project','zh-CN','希兰供应建殿工程','推罗王希兰与所罗门立约,供应香柏木、松木与巧匠。','希兰素爱大卫,闻所罗门接续作王便遣使祝贺;两王立约,推罗人从黎巴嫩砍伐香柏木与松木,扎成筏子浮海运到指定之地,所罗门则每年以麦子和清油偿付,两国工匠一同凿石备料。','这纸盟约使建殿工程得以起动,也见证了以色列与腓尼基的太平邦交。','约公元前 970–935 年'),
('hiram-supplies-the-temple-project','en','Hiram supplies the temple project','Hiram king of Tyre makes a treaty with Solomon, supplying cedar, cypress, and skilled workmen.','Hiram, always a friend of David, sends envoys when Solomon becomes king; by treaty the Tyrians fell cedar and cypress in Lebanon and float them by sea in rafts to the appointed place, while Solomon pays yearly in wheat and oil, and the two peoples’ craftsmen dress the stone together.','The pact sets the temple works in motion and marks the peace between Israel and Phoenicia.','c. 970–935 BCE'),
('dedication-of-the-temple','zh-CN','圣殿奉献礼','约柜抬入内殿,云彩充满耶和华的殿,所罗门献上奉献之祷。','以色列众长老聚集,祭司将约柜抬进至圣所基路伯翅膀之下,柜内惟有两块法版;祭司出来时,云彩充满殿宇,以致不能站立供职;所罗门在坛前铺开双手祷告,又与全会众献祭设宴十四日。','圣殿由此启用,成为此后数百年叙事的中心舞台。','约公元前 965–930 年'),
('dedication-of-the-temple','en','Dedication of the temple','The ark is borne into the inner sanctuary, the cloud fills the house, and Solomon offers the prayer of dedication.','The elders of Israel assemble and the priests carry the ark beneath the wings of the cherubim, nothing in it but the two tablets; as the priests withdraw, the cloud fills the house of the Lord so that they cannot stand to minister; Solomon spreads out his hands before the altar in prayer, and king and people keep the feast with sacrifices for fourteen days.','The temple enters service, the central stage of the narrative for centuries to come.','c. 965–930 BCE'),
('queen-of-sheba-visits-jerusalem','zh-CN','示巴女王到访耶路撒冷','示巴女王率驼队远来,以难题试验所罗门的智慧。','女王带着极多的香料、宝石与金子来到耶路撒冷,把心里所有的难题都问所罗门,王一一答明;她又见宫室的饮食、群臣的班次与上殿的台阶,便诧异得神不守舍,承认所听的传闻还不及亲见的一半,与王互赠厚礼而归。','这次来访把所罗门的名声推向叙事的顶点,也长久流传于后世的传说。','约公元前 960–930 年'),
('queen-of-sheba-visits-jerusalem','en','The queen of Sheba visits Jerusalem','The queen of Sheba comes with a great caravan to test Solomon with hard questions.','She arrives with camels bearing spices, precious stones, and much gold, and puts to Solomon all that is in her heart; he answers every question, and when she sees his table, the seating of his officials, and his ascent to the house of the Lord, there is no more spirit in her; confessing that the half had not been told her, she exchanges rich gifts with the king and returns to her land.','The visit crowns Solomon’s fame in the narrative and echoes long afterward in legend.','c. 960–930 BCE')
) AS v(slug,locale,title,summary,detail,sig,tl) ON e.slug=v.slug AND e.work_id='10000000-0000-4000-8000-000000000005';

-- -------------------------------------------------------------------------
-- 6. EVENT-LOCATIONS (reuse hebron, jerusalem; new endor, gibeah-of-saul,
--    ziklag-reference, mahanaim-reference, rabbah-of-ammon, tyre)
-- -------------------------------------------------------------------------
INSERT INTO event_locations(event_id,location_id,role,position)
SELECT e.id,l.id,'primary',0 FROM events e JOIN (VALUES
('david-marries-michal','gibeah-of-saul'),
('david-at-ziklag','ziklag-reference'),
('saul-consults-the-medium-at-endor','endor'),
('david-anointed-king-at-hebron','hebron'),
('ish-bosheth-reigns-at-mahanaim','mahanaim-reference'),
('abner-defects-and-is-killed','hebron'),
('ark-brought-to-jerusalem','jerusalem'),
('mephibosheth-at-davids-table','jerusalem'),
('uriah-sent-to-his-death','rabbah-of-ammon'),
('amnon-and-tamar','jerusalem'),
('ahithophels-counsel-rejected','jerusalem'),
('adonijahs-bid-for-the-throne','jerusalem'),
('solomon-judges-between-two-women','jerusalem'),
('hiram-supplies-the-temple-project','tyre'),
('dedication-of-the-temple','jerusalem'),
('queen-of-sheba-visits-jerusalem','jerusalem')
) AS v(eslug,lslug) ON e.slug=v.eslug JOIN locations l ON l.slug=v.lslug AND l.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 7. EVENT-CHARACTERS
-- -------------------------------------------------------------------------
INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT e.id,c.id,CASE WHEN v.ord=0 THEN 'primary' ELSE 'participant' END,v.ord,v.ord=0 FROM events e JOIN (VALUES
('david-marries-michal','michal',0),('david-marries-michal','david',1),('david-marries-michal','saul',2),
('david-at-ziklag','david',0),('david-at-ziklag','abigail',1),
('saul-consults-the-medium-at-endor','saul',0),('saul-consults-the-medium-at-endor','samuel',1),
('david-anointed-king-at-hebron','david',0),
('ish-bosheth-reigns-at-mahanaim','ish-bosheth',0),('ish-bosheth-reigns-at-mahanaim','abner',1),('ish-bosheth-reigns-at-mahanaim','joab',2),
('abner-defects-and-is-killed','abner',0),('abner-defects-and-is-killed','joab',1),('abner-defects-and-is-killed','david',2),('abner-defects-and-is-killed','ish-bosheth',3),
('ark-brought-to-jerusalem','david',0),('ark-brought-to-jerusalem','michal',1),
('mephibosheth-at-davids-table','mephibosheth',0),('mephibosheth-at-davids-table','david',1),
('uriah-sent-to-his-death','uriah',0),('uriah-sent-to-his-death','david',1),('uriah-sent-to-his-death','joab',2),('uriah-sent-to-his-death','bathsheba',3),
('amnon-and-tamar','amnon',0),('amnon-and-tamar','tamar-daughter-of-david',1),('amnon-and-tamar','absalom',2),('amnon-and-tamar','david',3),
('ahithophels-counsel-rejected','ahithophel',0),('ahithophels-counsel-rejected','absalom',1),('ahithophels-counsel-rejected','david',2),
('adonijahs-bid-for-the-throne','adonijah',0),('adonijahs-bid-for-the-throne','david',1),('adonijahs-bid-for-the-throne','bathsheba',2),('adonijahs-bid-for-the-throne','nathan',3),('adonijahs-bid-for-the-throne','zadok',4),('adonijahs-bid-for-the-throne','abiathar',5),('adonijahs-bid-for-the-throne','joab',6),('adonijahs-bid-for-the-throne','solomon',7),
('solomon-judges-between-two-women','solomon',0),
('hiram-supplies-the-temple-project','hiram-of-tyre',0),('hiram-supplies-the-temple-project','solomon',1),
('dedication-of-the-temple','solomon',0),('dedication-of-the-temple','zadok',1),
('queen-of-sheba-visits-jerusalem','queen-of-sheba',0),('queen-of-sheba-visits-jerusalem','solomon',1)
) AS v(eslug,cslug,ord) ON e.slug=v.eslug JOIN characters c ON c.slug=v.cslug AND c.work_id=e.work_id
WHERE e.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 8. EVENT-SOURCES (Samuel for the Saul/David narratives, Kings for the
--    Solomon narratives)
-- -------------------------------------------------------------------------
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Samuel'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN (
'david-marries-michal','david-at-ziklag','saul-consults-the-medium-at-endor',
'david-anointed-king-at-hebron','ish-bosheth-reigns-at-mahanaim','abner-defects-and-is-killed',
'ark-brought-to-jerusalem','mephibosheth-at-davids-table','uriah-sent-to-his-death',
'amnon-and-tamar','ahithophels-counsel-rejected')
ON CONFLICT DO NOTHING;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,s.id FROM events e JOIN sources s ON s.work_id=e.work_id AND s.title='Kings'
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug IN (
'adonijahs-bid-for-the-throne','solomon-judges-between-two-women',
'hiram-supplies-the-temple-project','dedication-of-the-temple','queen-of-sheba-visits-jerusalem')
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 9. CHARACTER RELATIONS
-- -------------------------------------------------------------------------
INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status,start_event_id,end_event_id)
SELECT ('73000000-0000-4000-8006-'||lpad(v.n::text,12,'0'))::uuid,'10000000-0000-4000-8000-000000000005',
       fc.id,tc.id,v.rtype,v.dir::relationship_direction,v.sentiment::relationship_sentiment,v.strength,v.rstatus::relationship_status,se.id,ee.id
FROM (VALUES
(1,'david','michal','spouse','bidirectional','mixed',3,'changed','david-marries-michal',NULL),
(2,'saul','michal','family','source_to_target','mixed',3,'unknown',NULL,NULL),
(3,'saul','ish-bosheth','family','source_to_target','positive',3,'ended',NULL,NULL),
(4,'abner','ish-bosheth','ally','bidirectional','mixed',4,'ended',NULL,'abner-defects-and-is-killed'),
(5,'joab','abner','adversary','bidirectional','negative',4,'ended',NULL,'abner-defects-and-is-killed'),
(6,'david','uriah','other','source_to_target','negative',3,'ended',NULL,'uriah-sent-to-his-death'),
(7,'uriah','bathsheba','spouse','bidirectional','positive',3,'ended',NULL,'uriah-sent-to-his-death'),
(8,'david','amnon','family','source_to_target','mixed',3,'ended',NULL,NULL),
(9,'david','tamar-daughter-of-david','family','source_to_target','positive',2,'unknown',NULL,NULL),
(10,'amnon','tamar-daughter-of-david','sibling','bidirectional','negative',4,'changed',NULL,'amnon-and-tamar'),
(11,'absalom','tamar-daughter-of-david','sibling','bidirectional','positive',3,'unknown',NULL,NULL),
(12,'absalom','amnon','sibling','bidirectional','negative',4,'ended','amnon-and-tamar',NULL),
(13,'ahithophel','david','ally','bidirectional','mixed',3,'changed',NULL,'ahithophels-counsel-rejected'),
(14,'ahithophel','absalom','ally','bidirectional','mixed',4,'ended',NULL,'ahithophels-counsel-rejected'),
(15,'jonathan','mephibosheth','family','source_to_target','positive',3,'ended',NULL,NULL),
(16,'david','mephibosheth','ally','source_to_target','positive',3,'active','mephibosheth-at-davids-table',NULL),
(17,'david','adonijah','family','source_to_target','mixed',3,'unknown',NULL,NULL),
(18,'adonijah','solomon','adversary','bidirectional','negative',4,'ended','adonijahs-bid-for-the-throne',NULL),
(19,'zadok','solomon','ally','source_to_target','positive',4,'active','adonijahs-bid-for-the-throne',NULL),
(20,'abiathar','adonijah','ally','source_to_target','mixed',3,'ended','adonijahs-bid-for-the-throne',NULL),
(21,'hiram-of-tyre','david','ally','bidirectional','positive',3,'ended',NULL,NULL),
(22,'hiram-of-tyre','solomon','ally','bidirectional','positive',4,'active','hiram-supplies-the-temple-project',NULL),
(23,'queen-of-sheba','solomon','other','source_to_target','positive',2,'ended','queen-of-sheba-visits-jerusalem',NULL)
) AS v(n,fslug,tslug,rtype,dir,sentiment,strength,rstatus,seslug,eeslug)
JOIN characters fc ON fc.slug=v.fslug AND fc.work_id='10000000-0000-4000-8000-000000000005'
JOIN characters tc ON tc.slug=v.tslug AND tc.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events se ON se.slug=v.seslug AND se.work_id='10000000-0000-4000-8000-000000000005'
LEFT JOIN events ee ON ee.slug=v.eeslug AND ee.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT DO NOTHING;

-- -------------------------------------------------------------------------
-- 10. GROUP MEMBERSHIP (existing groups house-of-saul, house-of-david)
-- -------------------------------------------------------------------------
INSERT INTO character_group_members(group_id,character_id)
SELECT g.id,c.id FROM character_groups g JOIN (VALUES
('house-of-saul','michal'),('house-of-saul','abner'),('house-of-saul','ish-bosheth'),('house-of-saul','mephibosheth'),
('house-of-david','michal'),('house-of-david','amnon'),('house-of-david','tamar-daughter-of-david'),('house-of-david','adonijah')
) AS v(gslug,cslug)
ON g.slug=v.gslug JOIN characters c ON c.slug=v.cslug AND c.work_id=g.work_id
WHERE g.work_id='10000000-0000-4000-8000-000000000005' ON CONFLICT DO NOTHING;

COMMIT;
