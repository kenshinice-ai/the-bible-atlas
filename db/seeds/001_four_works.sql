BEGIN;

INSERT INTO works(id,slug,author_name,publication_year,content_mode,map_layer,default_locale,launch_rank,mode_reason) VALUES
('10000000-0000-4000-8000-000000000001','a-tale-of-two-cities','Charles Dickens',1859,'literary_narrative','real','en',1,'A fictional narrative set against the French Revolution.'),
('10000000-0000-4000-8000-000000000002','the-diary-of-a-young-girl','Anne Frank',1947,'documented_record','real','en',2,'A diary documenting lived experience in wartime Amsterdam.'),
('10000000-0000-4000-8000-000000000003','the-alchemist','Paulo Coelho',1988,'literary_narrative','real','en',3,'A fictional journey through identifiable real-world regions.'),
('10000000-0000-4000-8000-000000000004','the-hobbit','J. R. R. Tolkien',1937,'literary_narrative','fictional','en',4,'A fully fictional geography rendered on an independent canvas.');

INSERT INTO work_translations(work_id,locale,title,summary,status) VALUES
('10000000-0000-4000-8000-000000000001','zh-CN','双城记','伦敦与巴黎之间，个人选择与法国大革命交织的文学叙事。','published'),
('10000000-0000-4000-8000-000000000001','en','A Tale of Two Cities','A literary narrative of personal choices across London and Paris during the French Revolution.','published'),
('10000000-0000-4000-8000-000000000002','zh-CN','安妮日记','一位少女在战时阿姆斯特丹藏匿生活中的日记记录。','published'),
('10000000-0000-4000-8000-000000000002','en','The Diary of a Young Girl','A young diarist’s documented experience while in hiding in wartime Amsterdam.','published'),
('10000000-0000-4000-8000-000000000003','zh-CN','牧羊少年奇幻之旅','牧羊少年从安达卢西亚出发，穿越北非追寻梦想。','published'),
('10000000-0000-4000-8000-000000000003','en','The Alchemist','A shepherd travels from Andalusia through North Africa in pursuit of a dream.','published'),
('10000000-0000-4000-8000-000000000004','zh-CN','霍比特人','比尔博在中土世界踏上前往孤山的冒险。','published'),
('10000000-0000-4000-8000-000000000004','en','The Hobbit','Bilbo sets out across Middle-earth on an adventure toward the Lonely Mountain.','published');

INSERT INTO characters(id,work_id,slug,sort_order) VALUES
('20000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000001','charles-darnay',1),
('20000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000001','sydney-carton',2),
('20000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000001','lucie-manette',3),
('20000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000001','doctor-manette',4),
('20000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000001','madame-defarge',5),
('20000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000001','monsieur-defarge',6),
('20000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000001','jarvis-lorry',7),
('20000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000001','miss-pross',8),
('20000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000002','anne-frank',1),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000002','otto-frank',2),
('20000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000003','santiago',1),
('20000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000003','the-alchemist',2),
('20000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000004','bilbo-baggins',1),
('20000000-0000-4000-8000-000000000014','10000000-0000-4000-8000-000000000004','gandalf',2),
('20000000-0000-4000-8000-000000000015','10000000-0000-4000-8000-000000000004','thorin-oakenshield',3);

INSERT INTO character_translations(character_id,locale,name,summary,status)
SELECT c.id, v.locale::locale_code, v.name, v.summary, 'published' FROM characters c JOIN (VALUES
('charles-darnay','zh-CN','查尔斯·达尔内','放弃贵族特权、往返英法两地的人物。'),('charles-darnay','en','Charles Darnay','A man who rejects inherited privilege and moves between France and England.'),
('sydney-carton','zh-CN','西德尼·卡顿','才华被消磨的律师助手，最终作出关键选择。'),('sydney-carton','en','Sydney Carton','A disillusioned legal assistant whose final choice changes the story.'),
('lucie-manette','zh-CN','露西·马内特','连接马内特家庭与伦敦、巴黎两地的人物。'),('lucie-manette','en','Lucie Manette','The emotional link between the Manette family and both cities.'),
('doctor-manette','zh-CN','马内特医生','从巴士底狱获释、努力重建生活的医生。'),('doctor-manette','en','Doctor Manette','A physician rebuilding his life after imprisonment in the Bastille.'),
('madame-defarge','zh-CN','德法日太太','以编织记录仇敌、推动革命报复的人物。'),('madame-defarge','en','Madame Defarge','A revolutionary who encodes targets in her knitting.'),
('monsieur-defarge','zh-CN','德法日先生','巴黎酒馆主人和革命者。'),('monsieur-defarge','en','Monsieur Defarge','A Paris wine-shop keeper and revolutionary.'),
('jarvis-lorry','zh-CN','贾维斯·劳里','台尔森银行职员和马内特一家的朋友。'),('jarvis-lorry','en','Jarvis Lorry','A Tellson’s Bank clerk and steadfast friend of the Manettes.'),
('miss-pross','zh-CN','普洛丝小姐','忠诚保护露西的家庭成员。'),('miss-pross','en','Miss Pross','Lucie’s fiercely loyal protector.'),
('anne-frank','zh-CN','安妮·弗兰克','记录藏匿生活的少女。'),('anne-frank','en','Anne Frank','The young diarist documenting life in hiding.'),
('otto-frank','zh-CN','奥托·弗兰克','安妮的父亲。'),('otto-frank','en','Otto Frank','Anne’s father.'),
('santiago','zh-CN','圣地亚哥','追寻梦中宝藏的牧羊少年。'),('santiago','en','Santiago','A shepherd pursuing the treasure from his dream.'),
('the-alchemist','zh-CN','炼金术士','引导圣地亚哥穿越沙漠的导师。'),('the-alchemist','en','The Alchemist','A mentor who guides Santiago across the desert.'),
('bilbo-baggins','zh-CN','比尔博·巴金斯','离开袋底洞踏上冒险的霍比特人。'),('bilbo-baggins','en','Bilbo Baggins','A hobbit who leaves Bag End for an unexpected adventure.'),
('gandalf','zh-CN','甘道夫','促成远征的巫师。'),('gandalf','en','Gandalf','The wizard who sets the quest in motion.'),
('thorin-oakenshield','zh-CN','索林·橡木盾','试图收复孤山家园的矮人首领。'),('thorin-oakenshield','en','Thorin Oakenshield','The dwarf leader seeking to reclaim the Lonely Mountain.')
) AS v(slug,locale,name,summary) ON v.slug=c.slug;

INSERT INTO locations(id,work_id,slug,layer,geom,canvas_x,canvas_y,sort_order,location_type,coordinate_accuracy,preferred_zoom) VALUES
('30000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000001','london','real',ST_GeogFromText('POINT(-0.1276 51.5072)'),NULL,NULL,1,'city','city_centroid',10),
('30000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000001','dover','real',ST_GeogFromText('POINT(1.3134 51.1279)'),NULL,NULL,2,'port','city_centroid',11),
('30000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000001','paris','real',ST_GeogFromText('POINT(2.3522 48.8566)'),NULL,NULL,3,'city','city_centroid',10),
('30000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000001','saint-antoine','real',ST_GeogFromText('POINT(2.3780 48.8530)'),NULL,NULL,4,'district','approximate',13),
('30000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000001','bastille','real',ST_GeogFromText('POINT(2.3690 48.8530)'),NULL,NULL,5,'prison','approximate',15),
('30000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000001','conciergerie','real',ST_GeogFromText('POINT(2.3450 48.8560)'),NULL,NULL,6,'prison','exact',15),
('30000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000002','secret-annex','real',ST_GeogFromText('POINT(4.8840 52.3752)'),NULL,NULL,1,'residence','exact',15),
('30000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000002','westerbork','real',ST_GeogFromText('POINT(6.6083 52.8500)'),NULL,NULL,2,'landmark','exact',14),
('30000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000003','andalusia','real',ST_GeogFromText('POINT(-5.9845 37.3891)'),NULL,NULL,1,'region','approximate',7),
('30000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000003','tangier','real',ST_GeogFromText('POINT(-5.8340 35.7595)'),NULL,NULL,2,'port','city_centroid',11),
('30000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000003','pyramids','real',ST_GeogFromText('POINT(31.1342 29.9792)'),NULL,NULL,3,'landmark','exact',14),
('30000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000004','bag-end','fictional',NULL,12,68,1,'fictional_place','fictional',9),
('30000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000004','rivendell','fictional',NULL,38,43,2,'fictional_place','fictional',8),
('30000000-0000-4000-8000-000000000014','10000000-0000-4000-8000-000000000004','misty-mountains','fictional',NULL,57,36,3,'fictional_place','fictional',7),
('30000000-0000-4000-8000-000000000015','10000000-0000-4000-8000-000000000004','lonely-mountain','fictional',NULL,88,24,4,'fictional_place','fictional',9);

INSERT INTO location_translations(location_id,locale,name,summary,status)
SELECT l.id,v.locale::locale_code,v.name,v.summary,'published' FROM locations l JOIN (VALUES
('london','zh-CN','伦敦','马内特一家生活与审判发生的城市。'),('london','en','London','Home to the Manettes and the English trial.'),('dover','zh-CN','多佛','英法海峡旅程的英国节点。'),('dover','en','Dover','The English Channel gateway.'),('paris','zh-CN','巴黎','革命情节集中的城市。'),('paris','en','Paris','The center of the revolutionary plot.'),('saint-antoine','zh-CN','圣安东尼区','德法日酒馆所在的革命街区。'),('saint-antoine','en','Saint Antoine','The revolutionary district around the Defarges’ wine shop.'),('bastille','zh-CN','巴士底狱','马内特医生被囚禁之处。'),('bastille','en','The Bastille','The prison where Doctor Manette was held.'),('conciergerie','zh-CN','巴黎古监狱','革命法庭与关押相关地点。'),('conciergerie','en','Conciergerie','A prison and tribunal setting during the Revolution.'),
('secret-annex','zh-CN','秘密后屋','弗兰克一家在阿姆斯特丹的藏匿处。'),('secret-annex','en','Secret Annex','The Amsterdam hiding place of the Frank family.'),('westerbork','zh-CN','韦斯特博克','被捕后转运所经的集中营。'),('westerbork','en','Westerbork','The transit camp reached after the arrest.'),
('andalusia','zh-CN','安达卢西亚','圣地亚哥旅程的起点。'),('andalusia','en','Andalusia','The beginning of Santiago’s journey.'),('tangier','zh-CN','丹吉尔','跨入北非后的重要节点。'),('tangier','en','Tangier','A pivotal stop after crossing into North Africa.'),('pyramids','zh-CN','吉萨金字塔','追寻宝藏的目标地点。'),('pyramids','en','Pyramids of Giza','The destination of the treasure quest.'),
('bag-end','zh-CN','袋底洞','比尔博的家。'),('bag-end','en','Bag End','Bilbo’s home.'),('rivendell','zh-CN','瑞文戴尔','远征队获得帮助的精灵居所。'),('rivendell','en','Rivendell','An Elven refuge where the company receives help.'),('misty-mountains','zh-CN','迷雾山脉','危险的山地通道。'),('misty-mountains','en','Misty Mountains','A dangerous mountain crossing.'),('lonely-mountain','zh-CN','孤山','远征目的地。'),('lonely-mountain','en','Lonely Mountain','The destination of the quest.')
) AS v(slug,locale,name,summary) ON v.slug=l.slug;

INSERT INTO events(id,work_id,slug,start_date,end_date,sequence,reality) VALUES
('40000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000001','manette-recalled',NULL,NULL,1,'fictional_with_historical_context'),
('40000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000001','darnay-trial',NULL,NULL,2,'fictional_narrative'),
('40000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000001','bastille-falls','1789-07-14','1789-07-14',3,'fictional_with_historical_context'),
('40000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000001','darnay-returns',NULL,NULL,4,'fictional_narrative'),
('40000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000001','prison-exchange',NULL,NULL,5,'fictional_narrative'),
('40000000-0000-4000-8000-000000000006','10000000-0000-4000-8000-000000000001','escape-to-london',NULL,NULL,6,'fictional_narrative'),
('40000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000002','annex-entry','1942-07-06','1942-07-06',1,'verified_historical'),
('40000000-0000-4000-8000-000000000008','10000000-0000-4000-8000-000000000002','annex-arrest','1944-08-04','1944-08-04',2,'verified_historical'),
('40000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000003','dream-and-departure',NULL,NULL,1,'fictional_narrative'),
('40000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000003','reaches-pyramids',NULL,NULL,2,'fictional_narrative'),
('40000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000004','unexpected-party',NULL,NULL,1,'fictional_narrative'),
('40000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000004','arrival-at-mountain',NULL,NULL,2,'fictional_narrative');

INSERT INTO event_translations(event_id,locale,title,summary,status)
SELECT e.id,v.locale::locale_code,v.title,v.summary,'published' FROM events e JOIN (VALUES
('manette-recalled','zh-CN','马内特医生重见天日','劳里与露西前往巴黎接回获释的马内特医生。'),('manette-recalled','en','Doctor Manette Recalled to Life','Lorry and Lucie travel to Paris to recover Doctor Manette.'),('darnay-trial','zh-CN','达尔内在伦敦受审','达尔内被控叛国并在伦敦受审。'),('darnay-trial','en','Darnay Tried in London','Darnay faces a treason trial in London.'),('bastille-falls','zh-CN','攻占巴士底狱','小说人物参与发生于真实历史背景中的巴士底狱事件。'),('bastille-falls','en','The Bastille Falls','Fictional characters take part in the historical storming of the Bastille.'),('darnay-returns','zh-CN','达尔内返回巴黎','达尔内为帮助旧仆返回革命中的法国。'),('darnay-returns','en','Darnay Returns to Paris','Darnay returns to revolutionary France to aid a former servant.'),('prison-exchange','zh-CN','狱中身份交换','卡顿在监狱中与达尔内交换身份。'),('prison-exchange','en','The Prison Exchange','Carton changes places with Darnay in prison.'),('escape-to-london','zh-CN','逃离巴黎','马内特一家沿英法通道返回伦敦。'),('escape-to-london','en','Escape from Paris','The Manette party follows the Channel route back toward London.'),
('annex-entry','zh-CN','进入秘密后屋','弗兰克一家进入藏匿处。'),('annex-entry','en','Entering the Secret Annex','The Frank family enters hiding.'),('annex-arrest','zh-CN','藏匿者被捕','秘密后屋中的藏匿者被捕。'),('annex-arrest','en','Arrest at the Annex','The people in hiding are arrested.'),
('dream-and-departure','zh-CN','梦与出发','圣地亚哥从安达卢西亚启程。'),('dream-and-departure','en','Dream and Departure','Santiago leaves Andalusia.'),('reaches-pyramids','zh-CN','抵达金字塔','旅程到达吉萨金字塔。'),('reaches-pyramids','en','Reaching the Pyramids','The journey reaches the Pyramids of Giza.'),
('unexpected-party','zh-CN','意外聚会','矮人和甘道夫来到袋底洞。'),('unexpected-party','en','An Unexpected Party','The dwarves and Gandalf arrive at Bag End.'),('arrival-at-mountain','zh-CN','抵达孤山','远征队到达孤山。'),('arrival-at-mountain','en','Arrival at the Lonely Mountain','The company reaches the Lonely Mountain.')
) AS v(slug,locale,title,summary) ON v.slug=e.slug;

INSERT INTO event_locations(event_id,location_id) VALUES
('40000000-0000-4000-8000-000000000001','30000000-0000-4000-8000-000000000004'),('40000000-0000-4000-8000-000000000002','30000000-0000-4000-8000-000000000001'),('40000000-0000-4000-8000-000000000003','30000000-0000-4000-8000-000000000005'),('40000000-0000-4000-8000-000000000004','30000000-0000-4000-8000-000000000003'),('40000000-0000-4000-8000-000000000005','30000000-0000-4000-8000-000000000006'),('40000000-0000-4000-8000-000000000006','30000000-0000-4000-8000-000000000002'),('40000000-0000-4000-8000-000000000007','30000000-0000-4000-8000-000000000007'),('40000000-0000-4000-8000-000000000008','30000000-0000-4000-8000-000000000007'),('40000000-0000-4000-8000-000000000009','30000000-0000-4000-8000-000000000009'),('40000000-0000-4000-8000-000000000010','30000000-0000-4000-8000-000000000011'),('40000000-0000-4000-8000-000000000011','30000000-0000-4000-8000-000000000012'),('40000000-0000-4000-8000-000000000012','30000000-0000-4000-8000-000000000015');
INSERT INTO event_characters(event_id,character_id,role) VALUES
('40000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000004','subject'),('40000000-0000-4000-8000-000000000002','20000000-0000-4000-8000-000000000001','subject'),('40000000-0000-4000-8000-000000000003','20000000-0000-4000-8000-000000000005','participant'),('40000000-0000-4000-8000-000000000004','20000000-0000-4000-8000-000000000001','subject'),('40000000-0000-4000-8000-000000000005','20000000-0000-4000-8000-000000000002','agent'),('40000000-0000-4000-8000-000000000005','20000000-0000-4000-8000-000000000001','subject'),('40000000-0000-4000-8000-000000000007','20000000-0000-4000-8000-000000000009','diarist'),('40000000-0000-4000-8000-000000000009','20000000-0000-4000-8000-000000000011','traveller'),('40000000-0000-4000-8000-000000000011','20000000-0000-4000-8000-000000000013','host');
INSERT INTO event_characters(event_id,character_id,role) VALUES
('40000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000003','participant'),
('40000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000007','participant'),
('40000000-0000-4000-8000-000000000003','20000000-0000-4000-8000-000000000006','participant'),
('40000000-0000-4000-8000-000000000006','20000000-0000-4000-8000-000000000001','traveller'),
('40000000-0000-4000-8000-000000000006','20000000-0000-4000-8000-000000000003','traveller'),
('40000000-0000-4000-8000-000000000006','20000000-0000-4000-8000-000000000004','traveller'),
('40000000-0000-4000-8000-000000000006','20000000-0000-4000-8000-000000000007','traveller'),
('40000000-0000-4000-8000-000000000006','20000000-0000-4000-8000-000000000008','traveller');

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type) VALUES
('50000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000003','20000000-0000-4000-8000-000000000004','family'),
('50000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000002','20000000-0000-4000-8000-000000000001','double'),
('50000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000005','20000000-0000-4000-8000-000000000006','spouse');
INSERT INTO relation_translations(relation_id,locale,label,status) VALUES
('50000000-0000-4000-8000-000000000001','zh-CN','父女','published'),('50000000-0000-4000-8000-000000000001','en','father and daughter','published'),('50000000-0000-4000-8000-000000000002','zh-CN','外貌相似与命运对照','published'),('50000000-0000-4000-8000-000000000002','en','physical doubles and narrative foils','published'),('50000000-0000-4000-8000-000000000003','zh-CN','夫妻与革命同伴','published'),('50000000-0000-4000-8000-000000000003','en','spouses and revolutionary partners','published');

INSERT INTO routes(id,work_id,slug,layer,certainty,sort_order) VALUES
('60000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000001','london-paris-return','real','text_explicit',1),
('60000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000002','annex-to-westerbork','real','documented',1),
('60000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000003','andalusia-to-pyramids','real','text_explicit',1),
('60000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000004','quest-to-erebor','fictional','text_explicit',1);
INSERT INTO route_translations(route_id,locale,name,summary,status) VALUES
('60000000-0000-4000-8000-000000000001','zh-CN','伦敦—巴黎往返线','串联伦敦、多佛与巴黎的文学明确路线。','published'),('60000000-0000-4000-8000-000000000001','en','London–Paris Return','A text-explicit route linking London, Dover and Paris.','published'),('60000000-0000-4000-8000-000000000002','zh-CN','秘密后屋—韦斯特博克','被捕后的史实转运路线。','published'),('60000000-0000-4000-8000-000000000002','en','Annex to Westerbork','The documented transfer route after the arrest.','published'),('60000000-0000-4000-8000-000000000003','zh-CN','安达卢西亚—金字塔','穿越西班牙与北非的文学旅程。','published'),('60000000-0000-4000-8000-000000000003','en','Andalusia to the Pyramids','A literary journey across Spain and North Africa.','published'),('60000000-0000-4000-8000-000000000004','zh-CN','孤山远征','在虚构画布上从袋底洞通往孤山。','published'),('60000000-0000-4000-8000-000000000004','en','Quest to Erebor','A fictional-canvas route from Bag End to the Lonely Mountain.','published');
INSERT INTO route_waypoints(route_id,location_id,position,event_id) VALUES
('60000000-0000-4000-8000-000000000001','30000000-0000-4000-8000-000000000001',0,'40000000-0000-4000-8000-000000000002'),('60000000-0000-4000-8000-000000000001','30000000-0000-4000-8000-000000000002',1,NULL),('60000000-0000-4000-8000-000000000001','30000000-0000-4000-8000-000000000003',2,'40000000-0000-4000-8000-000000000004'),('60000000-0000-4000-8000-000000000002','30000000-0000-4000-8000-000000000007',0,'40000000-0000-4000-8000-000000000008'),('60000000-0000-4000-8000-000000000002','30000000-0000-4000-8000-000000000008',1,NULL),('60000000-0000-4000-8000-000000000003','30000000-0000-4000-8000-000000000009',0,'40000000-0000-4000-8000-000000000009'),('60000000-0000-4000-8000-000000000003','30000000-0000-4000-8000-000000000010',1,NULL),('60000000-0000-4000-8000-000000000003','30000000-0000-4000-8000-000000000011',2,'40000000-0000-4000-8000-000000000010'),('60000000-0000-4000-8000-000000000004','30000000-0000-4000-8000-000000000012',0,'40000000-0000-4000-8000-000000000011'),('60000000-0000-4000-8000-000000000004','30000000-0000-4000-8000-000000000013',1,NULL),('60000000-0000-4000-8000-000000000004','30000000-0000-4000-8000-000000000014',2,NULL),('60000000-0000-4000-8000-000000000004','30000000-0000-4000-8000-000000000015',3,'40000000-0000-4000-8000-000000000012');

INSERT INTO sources(id,work_id,title,url,citation,evidence_grade) VALUES
('70000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000001','A Tale of Two Cities',NULL,'Dickens, Charles. A Tale of Two Cities. 1859. Event summaries are original, non-quoting descriptions.','primary'),
('70000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000001','Encyclopaedia Britannica: French Revolution','https://www.britannica.com/event/French-Revolution','Historical context reference for the French Revolution and Bastille.','reference');
INSERT INTO event_sources(event_id,source_id)
SELECT e.id,'70000000-0000-4000-8000-000000000001' FROM events e WHERE e.work_id='10000000-0000-4000-8000-000000000001';
INSERT INTO event_sources(event_id,source_id) VALUES ('40000000-0000-4000-8000-000000000003','70000000-0000-4000-8000-000000000002');

INSERT INTO seed_history(version) VALUES ('001_four_works') ON CONFLICT DO NOTHING;
COMMIT;
