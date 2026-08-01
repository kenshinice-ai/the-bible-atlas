BEGIN;

-- PostgreSQL's md5() is deterministic but its raw 128 bits are not
-- necessarily a RFC-4122 UUID (the web contract validates version/variant).
-- Normalize the deterministic digest once so every generated identity and
-- relation id remains stable and valid without adding another extension.
CREATE OR REPLACE FUNCTION pg_temp.stable_uuid(seed text) RETURNS uuid
LANGUAGE sql IMMUTABLE AS $fn$
  SELECT (substr(md5(seed),1,8)||'-'||substr(md5(seed),9,4)||'-4'||substr(md5(seed),14,3)||'-8'||substr(md5(seed),18,3)||'-'||substr(md5(seed),21))::uuid
$fn$;

-- Every art-history artist is also a person. This seed creates the canonical
-- character row and mirrors the existing artist event/place/source links into
-- the shared literary graph. The artist row remains the specialist record for
-- works, movements and catalogue metadata.
CREATE TEMP TABLE artist_identity_seed (
  slug text PRIMARY KEY,
  full_zh text NOT NULL,
  full_en text NOT NULL,
  titles_zh text[] NOT NULL DEFAULT '{}',
  titles_en text[] NOT NULL DEFAULT '{}',
  gender person_gender NOT NULL
) ON COMMIT DROP;

INSERT INTO artist_identity_seed(slug,full_zh,full_en,titles_zh,titles_en,gender) VALUES
('phidias','菲狄亚斯（Pheidias）','Pheidias of Athens','{}','{}','male'),
('giotto','乔托·迪·邦多内','Giotto di Bondone','{}','{}','male'),
('leonardo-da-vinci','列奥纳多·迪·瑟·皮耶罗·达·芬奇','Leonardo di ser Piero da Vinci','{}','{}','male'),
('rembrandt','伦勃朗·哈尔曼松·范·莱因','Rembrandt Harmenszoon van Rijn','{}','{}','male'),
('van-gogh','文森特·威廉·梵高','Vincent Willem van Gogh','{}','{}','male'),
('polykleitos','波留克列托斯（阿尔戈斯）','Polykleitos of Argos','{}','{}','male'),
('duccio','杜乔·迪·博宁塞尼亚','Duccio di Buoninsegna','{}','{}','male'),
('masaccio','马萨乔·迪·塞尔·乔瓦尼·迪·西蒙内','Tommaso di ser Giovanni di Simone (Masaccio)','{}','{}','male'),
('titian','提香·韦切利奥','Tiziano Vecellio',ARRAY['金马刺骑士','帕拉丁伯爵'],ARRAY['Knight of the Golden Spur','Count Palatine'],'male'),
('caravaggio','米开朗基罗·梅里西·达·卡拉瓦乔','Michelangelo Merisi da Caravaggio','{}','{}','male'),
('velazquez','迭戈·罗德里格斯·德·席尔瓦·委拉斯开兹','Diego Rodríguez de Silva y Velázquez',ARRAY['圣地亚哥骑士团骑士'],ARRAY['Knight of the Order of Santiago'],'male'),
('jacques-louis-david','雅克-路易·大卫','Jacques-Louis David','{}','{}','male'),
('j-m-w-turner','约瑟夫·马洛德·威廉·透纳','Joseph Mallord William Turner','{}','{}','male'),
('claude-monet','奥斯卡-克洛德·莫奈','Oscar-Claude Monet','{}','{}','male'),
('pablo-picasso','巴勃罗·鲁伊斯·毕加索','Pablo Ruiz Picasso','{}','{}','male'),
('wassily-kandinsky','瓦西里·瓦西里耶维奇·康定斯基','Wassily Wassilyevich Kandinsky','{}','{}','male'),
('cimabue','契马布埃（琴尼·迪·佩波）','Cimabue (Cenni di Pepo)','{}','{}','male'),
('jan-van-eyck','扬·范·艾克','Jan van Eyck','{}','{}','male'),
('rogier-van-der-weyden','罗希尔·范·德尔·魏登','Rogier van der Weyden','{}','{}','male'),
('hieronymus-bosch','希罗尼穆斯·博斯（希罗尼穆斯·范·阿肯）','Hieronymus Bosch (Jheronimus van Aken)','{}','{}','male'),
('sandro-botticelli','桑德罗·波提切利（亚历山德罗·迪·马里亚诺·迪·万尼·菲利佩皮）','Sandro Botticelli (Alessandro di Mariano di Vanni Filipepi)','{}','{}','male'),
('michelangelo','米开朗基罗·迪·洛多维科·博纳罗蒂·西莫尼','Michelangelo di Lodovico Buonarroti Simoni','{}','{}','male'),
('raphael','拉斐尔·桑齐奥·达·乌尔比诺','Raffaello Sanzio da Urbino','{}','{}','male'),
('albrecht-durer','阿尔布雷希特·丢勒','Albrecht Dürer','{}','{}','male'),
('giorgione','乔尔乔内·达·卡斯特尔弗兰科（乔治奥·巴巴雷利）','Giorgio Barbarelli da Castelfranco (Giorgione)','{}','{}','male'),
('tintoretto','雅各布·罗布斯蒂（丁托列托）','Jacopo Robusti (Tintoretto)','{}','{}','male'),
('peter-paul-rubens','彼得·保罗·鲁本斯','Peter Paul Rubens',ARRAY['英格兰骑士','西班牙骑士'],ARRAY['Knight of England','Knight of Spain'],'male'),
('artemisia-gentileschi','阿尔泰米西娅·洛米·真蒂莱斯基','Artemisia Lomi Gentileschi','{}','{}','female'),
('johannes-vermeer','约翰内斯·维米尔','Johannes Vermeer','{}','{}','male'),
('nicolas-poussin','尼古拉·普桑','Nicolas Poussin','{}','{}','male'),
('francisco-goya','弗朗西斯科·何塞·德·戈雅·卢西恩特斯','Francisco José de Goya y Lucientes','{}','{}','male'),
('antonio-canova','安东尼奥·卡诺瓦','Antonio Canova',ARRAY['伊斯基亚侯爵'],ARRAY['Marquis of Ischia'],'male'),
('caspar-david-friedrich','卡斯帕·大卫·弗里德里希','Caspar David Friedrich','{}','{}','male'),
('eugene-delacroix','费迪南·维克多·欧仁·德拉克罗瓦','Ferdinand-Victor-Eugène Delacroix','{}','{}','male'),
('gustave-courbet','让·德西雷·古斯塔夫·库尔贝','Jean Désiré Gustave Courbet','{}','{}','male'),
('edouard-manet','爱德华·马奈','Édouard Manet','{}','{}','male'),
('pierre-auguste-renoir','皮埃尔-奥古斯特·雷诺阿','Pierre-Auguste Renoir','{}','{}','male'),
('edgar-degas','埃德加·德加（伊莱尔-日耳曼-埃德加·德加）','Edgar Degas (Hilaire-Germain-Edgar De Gas)','{}','{}','male'),
('paul-cezanne','保罗·塞尚','Paul Cézanne','{}','{}','male'),
('georges-seurat','乔治-皮埃尔·修拉','Georges-Pierre Seurat','{}','{}','male'),
('paul-gauguin','欧仁·亨利·保罗·高更','Eugène Henri Paul Gauguin','{}','{}','male'),
('henri-de-toulouse-lautrec','亨利·马里·雷蒙·德·图卢兹-洛特列克-蒙法','Henri Marie Raymond de Toulouse-Lautrec-Monfa',ARRAY['图卢兹-洛特列克伯爵（礼貌性称谓）'],ARRAY['Courtesy title of Count of Toulouse-Lautrec'],'male'),
('henri-matisse','亨利·埃米尔·伯努瓦·马蒂斯','Henri Émile Benoît Matisse','{}','{}','male'),
('georges-braque','乔治·布拉克','Georges Braque','{}','{}','male'),
('umberto-boccioni','翁贝托·博乔尼','Umberto Boccioni','{}','{}','male'),
('paul-klee','保罗·克利','Paul Klee','{}','{}','male'),
('franz-marc','弗朗茨·莫里茨·威廉·马尔克','Franz Moritz Wilhelm Marc','{}','{}','male'),
('piet-mondrian','彼得·科内利斯·蒙德里安','Pieter Cornelis Mondriaan','{}','{}','male');

-- Keep the concise catalogue name as an alias, while making the complete name
-- and any documented rank/honorific explicit and searchable.
UPDATE artist_translations t
SET full_name=CASE WHEN t.locale='zh-CN' THEN d.full_zh ELSE d.full_en END,
    aliases=CASE WHEN t.name=CASE WHEN t.locale='zh-CN' THEN d.full_zh ELSE d.full_en END THEN '{}' ELSE ARRAY[t.name] END,
    formal_titles=CASE WHEN t.locale='zh-CN' THEN d.titles_zh ELSE d.titles_en END
FROM artist_identity_seed d JOIN artists a ON a.slug=d.slug AND a.work_id='10000000-0000-4000-8000-000000000009'
WHERE t.artist_id=a.id;

-- A deterministic UUID from the artist UUID makes the mapping idempotent and
-- avoids reserving a second hand-maintained numeric range for people.
INSERT INTO characters(id,work_id,slug,sort_order,gender,age_stage,role_type,reality_type,birth_year,death_year,birth_place_id,death_place_id,icon_variant,importance)
SELECT pg_temp.stable_uuid('artist-person:'||a.id::text),a.work_id,a.slug,a.sort_order,d.gender,'adult','historical','historical',a.birth_year,a.death_year,a.birth_location_id,a.death_location_id,'artist',a.importance
FROM artists a JOIN artist_identity_seed d ON d.slug=a.slug
WHERE a.work_id='10000000-0000-4000-8000-000000000009'
ON CONFLICT(work_id,slug) DO UPDATE SET gender=EXCLUDED.gender,role_type=EXCLUDED.role_type,reality_type=EXCLUDED.reality_type,birth_year=EXCLUDED.birth_year,death_year=EXCLUDED.death_year,birth_place_id=EXCLUDED.birth_place_id,death_place_id=EXCLUDED.death_place_id,icon_variant=EXCLUDED.icon_variant,importance=EXCLUDED.importance;

UPDATE artists a SET character_id=c.id
FROM characters c
WHERE a.work_id=c.work_id AND a.slug=c.slug AND a.work_id='10000000-0000-4000-8000-000000000009';

INSERT INTO character_translations(character_id,locale,name,summary,aliases,detail,motivation,status)
SELECT a.character_id,at.locale,at.full_name,at.summary,at.aliases,
       CASE WHEN at.locale='zh-CN' THEN '艺术家专用资料已与人物实体合并；艺术作品、事件、地点与关系沿用同一人物链。' ELSE 'The artist record is unified with the person entity; artworks, events, places and relations use the same person chain.' END,
       CASE WHEN at.locale='zh-CN' THEN concat_ws('；',at.modern_status,array_to_string(at.period_titles,'、')) ELSE concat_ws('; ',at.modern_status,array_to_string(at.period_titles,'; ')) END,
       at.status
FROM artists a JOIN artist_translations at ON at.artist_id=a.id
WHERE a.work_id='10000000-0000-4000-8000-000000000009' AND a.character_id IS NOT NULL
ON CONFLICT(character_id,locale) DO UPDATE SET name=EXCLUDED.name,summary=EXCLUDED.summary,aliases=EXCLUDED.aliases,detail=EXCLUDED.detail,motivation=EXCLUDED.motivation,status=EXCLUDED.status;

INSERT INTO event_characters(event_id,character_id,role,participant_order,is_primary)
SELECT ae.event_id,a.character_id,ae.role,0,true
FROM artist_event_links ae JOIN artists a ON a.id=ae.artist_id
WHERE a.character_id IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO character_locations(character_id,location_id,is_primary)
SELECT a.character_id,al.location_id,bool_or(al.role='birth')
FROM artist_locations al JOIN artists a ON a.id=al.artist_id
WHERE a.character_id IS NOT NULL
GROUP BY a.character_id,al.location_id
ON CONFLICT(character_id,location_id) DO UPDATE SET is_primary=character_locations.is_primary OR EXCLUDED.is_primary;

INSERT INTO character_sources(character_id,source_id)
SELECT a.character_id,asrc.source_id FROM artist_sources asrc JOIN artists a ON a.id=asrc.artist_id WHERE a.character_id IS NOT NULL
ON CONFLICT DO NOTHING;

-- Curated people-level relations reuse the existing graph contract. The
-- specialist artist_relations table remains the art-domain source, while the
-- mirrored character_relations rows make these links visible everywhere else.
CREATE TEMP TABLE artist_relation_seed (
  from_slug text NOT NULL, to_slug text NOT NULL, relation_type text NOT NULL,
  direction relationship_direction NOT NULL, sentiment relationship_sentiment NOT NULL,
  strength integer NOT NULL, status relationship_status NOT NULL,
  label_zh text NOT NULL, label_en text NOT NULL, summary_zh text NOT NULL, summary_en text NOT NULL,
  PRIMARY KEY(from_slug,to_slug,relation_type)
) ON COMMIT DROP;
INSERT INTO artist_relation_seed VALUES
('cimabue','giotto','mentor', 'source_to_target','positive',4,'ended','传统师承','Traditional mentorship','传统艺术史叙述将乔托置于契马布埃的师承与工坊网络中，具体程度仍需按来源理解。','Traditional art-historical accounts place Giotto within Cimabue’s workshop and mentorship network; the exact degree remains source-sensitive.'),
('leonardo-da-vinci','michelangelo','rival', 'bidirectional','mixed',4,'ended','同时代竞争','Contemporary rivalry','两位佛罗伦萨艺术家在公共委托与艺术观念上形成著名的同时代竞争关系。','The two Florentine artists became associated with a famous rivalry over public commissions and artistic priorities.'),
('leonardo-da-vinci','raphael','influence', 'source_to_target','positive',4,'active','构图影响','Compositional influence','拉斐尔吸收列奥纳多关于构图、人物关系与心理姿态的研究。','Raphael absorbed Leonardo’s studies of composition, figure relationships and psychological gesture.'),
('michelangelo','raphael','rival', 'bidirectional','mixed',3,'ended','罗马艺术竞争','Roman artistic rivalry','两人在罗马的委托体系中被后世并置为盛期文艺复兴的竞争性范式。','Later histories place the two within Rome’s commission system as contrasting High Renaissance exemplars.'),
('giorgione','titian','influence', 'source_to_target','positive',4,'ended','威尼斯画派传承','Venetian school succession','提香承接乔尔乔内的诗性风景与色彩传统，并发展出自己的绘画语言。','Titian carried forward Giorgione’s poetic landscape and colour tradition while developing an independent language.'),
('titian','tintoretto','influence', 'source_to_target','positive',3,'active','威尼斯画派影响','Venetian school influence','丁托列托在威尼斯传统中回应提香的色彩与大尺幅绘画。','Tintoretto responded to Titian’s colour and large-scale painting within the Venetian tradition.'),
('caravaggio','artemisia-gentileschi','influence', 'source_to_target','positive',3,'active','明暗法影响','Chiaroscuro influence','真蒂莱斯基的作品承接了卡拉瓦乔式强烈明暗与现实人物塑造的视觉资源。','Gentileschi’s work carries forward Caravaggesque chiaroscuro and the use of observed figures.'),
('peter-paul-rubens','velazquez','influence', 'source_to_target','positive',3,'active','宫廷绘画交流','Court painting exchange','鲁本斯的国际宫廷网络与绘画语言进入委拉斯开兹所处的西班牙宫廷语境。','Rubens’s international court network and painterly language entered the Spanish court context of Velázquez.'),
('francisco-goya','edouard-manet','influence', 'source_to_target','positive',3,'active','现代绘画先声','Precursor to modern painting','戈雅的战争、社会批判与非理想化人物形象成为马奈及现代绘画可回应的先例。','Goya’s war imagery, social critique and non-idealised figures offered precedents for Manet and modern painting.'),
('j-m-w-turner','claude-monet','influence', 'source_to_target','positive',3,'active','光色影响','Light and colour influence','透纳关于光、空气与运动的风景画实验为莫奈的光色研究提供远期参照。','Turner’s experiments with light, atmosphere and motion offered a long-range reference for Monet’s colour studies.'),
('edouard-manet','claude-monet','network', 'bidirectional','positive',3,'ended','现代画家网络','Modern painters’ network','马奈与莫奈共同处于巴黎现代画家、沙龙与印象派展览网络中。','Manet and Monet shared Paris’s network of modern painters, salons and Impressionist exhibitions.'),
('edouard-manet','pierre-auguste-renoir','network', 'bidirectional','positive',3,'ended','印象派网络','Impressionist network','马奈与雷诺阿在巴黎现代绘画网络中被共同讨论并相互参照。','Manet and Renoir were discussed together and served as mutual reference points within Paris’s modern painting network.'),
('paul-cezanne','paul-gauguin','influence', 'source_to_target','positive',3,'active','后印象派影响','Post-Impressionist influence','塞尚对结构、色面与观察的研究成为高更发展个人绘画语言的重要参照。','Cézanne’s work with structure, planes and observation was an important reference for Gauguin’s independent language.'),
('paul-gauguin','van-gogh','collaboration', 'bidirectional','mixed',4,'ended','阿尔勒共同创作','Arles collaboration','高更与梵高在阿尔勒短期共同生活与创作，关系既有合作也有紧张。','Gauguin and Van Gogh lived and worked together briefly in Arles, combining collaboration with tension.'),
('claude-monet','georges-seurat','influence', 'source_to_target','positive',3,'active','色彩研究影响','Colour-study influence','修拉在印象派色彩观察的基础上发展点彩式的新印象主义方法。','Seurat developed a Neo-Impressionist method from the colour observations of Impressionism.'),
('pablo-picasso','georges-braque','collaboration', 'bidirectional','positive',5,'ended','立体主义共同创制','Co-creation of Cubism','毕加索与布拉克通过持续对话与共同实验创制立体主义的关键语法。','Picasso and Braque developed Cubism’s key grammar through sustained dialogue and shared experiments.'),
('franz-marc','paul-klee','network', 'bidirectional','positive',3,'ended','蓝骑士网络','Blue Rider network','马尔克与克利在蓝骑士及德国先锋艺术网络中形成重要的同代联系。','Marc and Klee were connected through the Blue Rider and wider German avant-garde networks.'),
('wassily-kandinsky','paul-klee','colleague', 'bidirectional','positive',4,'ended','包豪斯同事','Bauhaus colleagues','康定斯基与克利在包豪斯任教，形成关于抽象、色彩与教学的同事关系。','Kandinsky and Klee taught at the Bauhaus, sharing a collegial context around abstraction, colour and pedagogy.');

INSERT INTO artist_relations(id,work_id,from_artist_id,to_artist_id,relation_type,strength)
SELECT pg_temp.stable_uuid('artist-relation:'||r.from_slug||':'||r.to_slug||':'||r.relation_type),'10000000-0000-4000-8000-000000000009',f.id,t.id,r.relation_type,r.strength
FROM artist_relation_seed r JOIN artists f ON f.slug=r.from_slug AND f.work_id='10000000-0000-4000-8000-000000000009' JOIN artists t ON t.slug=r.to_slug AND t.work_id=f.work_id
ON CONFLICT(work_id,from_artist_id,to_artist_id,relation_type) DO UPDATE SET strength=EXCLUDED.strength;

INSERT INTO artist_relation_translations(relation_id,locale,label,summary,status)
SELECT ar.id,'zh-CN'::locale_code,r.label_zh,r.summary_zh,'published'::translation_status FROM artist_relation_seed r JOIN artists f ON f.slug=r.from_slug AND f.work_id='10000000-0000-4000-8000-000000000009' JOIN artists t ON t.slug=r.to_slug AND t.work_id=f.work_id JOIN artist_relations ar ON ar.from_artist_id=f.id AND ar.to_artist_id=t.id AND ar.relation_type=r.relation_type
UNION ALL
SELECT ar.id,'en'::locale_code,r.label_en,r.summary_en,'published'::translation_status FROM artist_relation_seed r JOIN artists f ON f.slug=r.from_slug AND f.work_id='10000000-0000-4000-8000-000000000009' JOIN artists t ON t.slug=r.to_slug AND t.work_id=f.work_id JOIN artist_relations ar ON ar.from_artist_id=f.id AND ar.to_artist_id=t.id AND ar.relation_type=r.relation_type
ON CONFLICT(relation_id,locale) DO UPDATE SET label=EXCLUDED.label,summary=EXCLUDED.summary,status=EXCLUDED.status;

INSERT INTO character_relations(id,work_id,from_character_id,to_character_id,relation_type,direction,sentiment,strength,status)
SELECT pg_temp.stable_uuid('character-relation:'||r.from_slug||':'||r.to_slug||':'||r.relation_type),'10000000-0000-4000-8000-000000000009',f.character_id,t.character_id,r.relation_type,r.direction,r.sentiment,r.strength,r.status
FROM artist_relation_seed r JOIN artists f ON f.slug=r.from_slug AND f.work_id='10000000-0000-4000-8000-000000000009' JOIN artists t ON t.slug=r.to_slug AND t.work_id=f.work_id
WHERE f.character_id IS NOT NULL AND t.character_id IS NOT NULL
ON CONFLICT(work_id,from_character_id,to_character_id,relation_type) DO UPDATE SET direction=EXCLUDED.direction,sentiment=EXCLUDED.sentiment,strength=EXCLUDED.strength,status=EXCLUDED.status;

INSERT INTO relation_translations(relation_id,locale,label,summary,status)
SELECT cr.id,'zh-CN'::locale_code,r.label_zh,r.summary_zh,'published'::translation_status FROM artist_relation_seed r JOIN artists f ON f.slug=r.from_slug AND f.work_id='10000000-0000-4000-8000-000000000009' JOIN artists t ON t.slug=r.to_slug AND t.work_id=f.work_id JOIN character_relations cr ON cr.from_character_id=f.character_id AND cr.to_character_id=t.character_id AND cr.relation_type=r.relation_type
UNION ALL
SELECT cr.id,'en'::locale_code,r.label_en,r.summary_en,'published'::translation_status FROM artist_relation_seed r JOIN artists f ON f.slug=r.from_slug AND f.work_id='10000000-0000-4000-8000-000000000009' JOIN artists t ON t.slug=r.to_slug AND t.work_id=f.work_id JOIN character_relations cr ON cr.from_character_id=f.character_id AND cr.to_character_id=t.character_id AND cr.relation_type=r.relation_type
ON CONFLICT(relation_id,locale) DO UPDATE SET label=EXCLUDED.label,summary=EXCLUDED.summary,status=EXCLUDED.status;

INSERT INTO relation_sources(relation_id,source_id)
SELECT cr.id,'59000000-0000-4000-8000-000000000009' FROM character_relations cr
WHERE cr.work_id='10000000-0000-4000-8000-000000000009' AND cr.id IN (SELECT pg_temp.stable_uuid('character-relation:'||from_slug||':'||to_slug||':'||relation_type) FROM artist_relation_seed)
ON CONFLICT DO NOTHING;

INSERT INTO seed_history(version) VALUES ('053_european_art_people_unification') ON CONFLICT DO NOTHING;
COMMIT;
