BEGIN;

-- v4 Bible expansion, part 1: era structure (chapters) and citation sources.
-- Chronology stays deliberately coarse: every era carries scholarly-range bounds
-- rather than adjudicated dates, matching docs/DATA_SOURCE_POLICY_v3.1.md.

-- Make room for the new eras. Unique(work_id, sequence) forces a two-step shuffle.
UPDATE chapters SET sequence = sequence + 100 WHERE work_id='10000000-0000-4000-8000-000000000005';

UPDATE chapters SET sequence = v.seq, era_start_year = v.start_year, era_end_year = v.end_year, accent_color = v.accent
FROM (VALUES
  ('patriarchs',2,-2100,-1700,'#c9972e'),
  ('exodus-and-sinai',3,-1300,-1200,'#b8863a'),
  ('united-monarchy',6,-1030,-930,'#b5544a'),
  ('prophetic-narrative',8,-800,-680,'#8c4a63'),
  ('gospels',11,-6,33,'#46618a'),
  ('acts',12,30,62,'#3d7286')
) AS v(slug,seq,start_year,end_year,accent)
WHERE chapters.work_id='10000000-0000-4000-8000-000000000005' AND chapters.slug=v.slug;

INSERT INTO chapters(id,work_id,slug,sequence,reference_label,era_start_year,era_end_year,accent_color) VALUES
('82000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000005','primeval',1,'Genesis 1–11',NULL,NULL,'#7a6a52'),
('82000000-0000-4000-8000-000000000004','10000000-0000-4000-8000-000000000005','wilderness-and-conquest',4,'Numbers–Joshua',-1250,-1150,'#a8763f'),
('82000000-0000-4000-8000-000000000005','10000000-0000-4000-8000-000000000005','judges',5,'Judges–Ruth',-1150,-1030,'#9c6a44'),
('82000000-0000-4000-8000-000000000007','10000000-0000-4000-8000-000000000005','divided-kingdoms',7,'1 Kings 12 – 2 Kings 17',-930,-722,'#a04a52'),
('82000000-0000-4000-8000-000000000009','10000000-0000-4000-8000-000000000005','judah-and-exile',9,'2 Kings 18–25; Jeremiah; Daniel',-701,-539,'#6f4a70'),
('82000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000005','return-and-restoration',10,'Ezra–Nehemiah; Esther',-539,-430,'#58507e'),
('82000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000005','pauline-mission',13,'Acts 13–28',46,62,'#3a8177');

INSERT INTO chapter_translations(chapter_id,locale,title,summary,status)
SELECT c.id,v.locale::locale_code,v.title,v.summary,'published' FROM chapters c JOIN (VALUES
('primeval','zh-CN','起源叙事','创世、洪水与列族分散的叙事段落。此段不放置在历史年代轴上，只保留叙事顺序。'),
('primeval','en','Primeval narrative','Creation, flood, and the dispersal of peoples. This era carries no historical-year placement and is ordered narratively only.'),
('patriarchs','zh-CN','族长时代','亚伯拉罕家族从美索不达米亚迁往迦南，直到雅各一家进入埃及。'),
('patriarchs','en','Patriarchal era','The household of Abraham moves from Mesopotamia to Canaan, ending with Jacob’s family entering Egypt.'),
('exodus-and-sinai','zh-CN','出埃及与西奈','离开埃及、渡海、在西奈接受律法与盟约的叙事段落。'),
('exodus-and-sinai','en','Exodus and Sinai','Departure from Egypt, the sea crossing, and the law and covenant narratives at Sinai.'),
('wilderness-and-conquest','zh-CN','旷野与进入迦南','旷野漂流、加低斯事件与约书亚带领进入迦南的叙事。'),
('wilderness-and-conquest','en','Wilderness and entry','Wilderness wandering, the Kadesh episodes, and the entry into Canaan under Joshua.'),
('judges','zh-CN','士师时代','地方性领袖轮替、与邻族冲突以及路得叙事所处的过渡时期。'),
('judges','en','Era of the judges','Rotating local leaders, conflicts with neighbouring peoples, and the setting of the Ruth narrative.'),
('united-monarchy','zh-CN','联合王国','扫罗、大卫与所罗门时期，耶路撒冷成为政治与宗教中心。'),
('united-monarchy','en','United monarchy','Saul, David, and Solomon; Jerusalem becomes the political and religious centre.'),
('divided-kingdoms','zh-CN','分裂王国','北国以色列与南国犹大并立，直到撒玛利亚陷落。'),
('divided-kingdoms','en','Divided kingdoms','Israel in the north and Judah in the south stand in parallel until the fall of Samaria.'),
('prophetic-narrative','zh-CN','先知叙事','约拿、阿摩司、何西阿与以赛亚等先知文本中的叙事事件。'),
('prophetic-narrative','en','Prophetic narratives','Narrative episodes drawn from Jonah, Amos, Hosea, and Isaiah.'),
('judah-and-exile','zh-CN','犹大与被掳','亚述压境、耶路撒冷陷落、圣殿被毁与巴比伦被掳时期。'),
('judah-and-exile','en','Judah and exile','Assyrian pressure, the fall of Jerusalem, the destruction of the temple, and the Babylonian exile.'),
('return-and-restoration','zh-CN','归回与重建','波斯时期的归回、圣殿与城墙重建，以及以斯帖叙事。'),
('return-and-restoration','en','Return and restoration','The Persian-period return, the rebuilding of temple and wall, and the Esther narrative.'),
('gospels','zh-CN','福音书','诞生、加利利传道、耶路撒冷最后一周与复活叙事。'),
('gospels','en','Gospels','Birth, Galilean ministry, the final week in Jerusalem, and the resurrection narratives.'),
('acts','zh-CN','使徒行传（早期）','五旬节之后耶路撒冷与犹太地的早期群体扩展。'),
('acts','en','Acts (early)','Expansion of the early community in Jerusalem and Judea after Pentecost.'),
('pauline-mission','zh-CN','保罗宣教行程','三次宣教旅程与最终前往罗马的航程。'),
('pauline-mission','en','Pauline mission','Three missionary journeys and the final voyage to Rome.')
) AS v(slug,locale,title,summary) ON c.slug=v.slug AND c.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT (chapter_id,locale) DO UPDATE SET title=EXCLUDED.title, summary=EXCLUDED.summary, status='published';

-- Additional primary-text citations. Titles are canonical book identifiers and
-- carry bilingual translations so no English leaks into the zh-CN citation list.
INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type) VALUES
('52000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000005','Numbers',NULL,'Numbers 13–21','primary','primary_text'),
('52000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000005','Deuteronomy',NULL,'Deuteronomy 32–34','primary','primary_text'),
('52000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000005','Joshua',NULL,'Joshua 1–24','primary','primary_text'),
('52000000-0000-4000-8000-000000000014','10000000-0000-4000-8000-000000000005','Judges',NULL,'Judges 4–16','primary','primary_text'),
('52000000-0000-4000-8000-000000000015','10000000-0000-4000-8000-000000000005','Ruth',NULL,'Ruth 1–4','primary','primary_text'),
('52000000-0000-4000-8000-000000000016','10000000-0000-4000-8000-000000000005','Chronicles',NULL,'1–2 Chronicles','primary','primary_text'),
('52000000-0000-4000-8000-000000000017','10000000-0000-4000-8000-000000000005','Ezra',NULL,'Ezra 1–10','primary','primary_text'),
('52000000-0000-4000-8000-000000000018','10000000-0000-4000-8000-000000000005','Nehemiah',NULL,'Nehemiah 1–13','primary','primary_text'),
('52000000-0000-4000-8000-000000000019','10000000-0000-4000-8000-000000000005','Esther',NULL,'Esther 1–10','primary','primary_text'),
('52000000-0000-4000-8000-000000000020','10000000-0000-4000-8000-000000000005','Isaiah',NULL,'Isaiah 6; 36–39','primary','primary_text'),
('52000000-0000-4000-8000-000000000021','10000000-0000-4000-8000-000000000005','Jeremiah',NULL,'Jeremiah 1; 38–43','primary','primary_text'),
('52000000-0000-4000-8000-000000000022','10000000-0000-4000-8000-000000000005','Ezekiel',NULL,'Ezekiel 1–3','primary','primary_text'),
('52000000-0000-4000-8000-000000000023','10000000-0000-4000-8000-000000000005','Daniel',NULL,'Daniel 1–6','primary','primary_text'),
('52000000-0000-4000-8000-000000000024','10000000-0000-4000-8000-000000000005','Amos',NULL,'Amos 1–9','primary','primary_text'),
('52000000-0000-4000-8000-000000000025','10000000-0000-4000-8000-000000000005','Hosea',NULL,'Hosea 1–3','primary','primary_text'),
('52000000-0000-4000-8000-000000000026','10000000-0000-4000-8000-000000000005','Gospel according to Mark',NULL,'Mark 1–16','primary','primary_text'),
('52000000-0000-4000-8000-000000000027','10000000-0000-4000-8000-000000000005','Gospel according to John',NULL,'John 1–21','primary','primary_text'),
('52000000-0000-4000-8000-000000000028','10000000-0000-4000-8000-000000000005','Letter to the Romans',NULL,'Romans 1; 15–16','primary','primary_text'),
('52000000-0000-4000-8000-000000000029','10000000-0000-4000-8000-000000000005','Letters to the Corinthians',NULL,'1–2 Corinthians','primary','primary_text'),
('52000000-0000-4000-8000-000000000030','10000000-0000-4000-8000-000000000005','Revelation',NULL,'Revelation 1–3','primary','primary_text');

INSERT INTO source_translations(source_id,locale,title,citation,status)
SELECT s.id,v.locale::locale_code,v.localised,v.citation,'published' FROM sources s JOIN (VALUES
('Genesis','zh-CN','创世记','创世记 1–50'),('Genesis','en','Genesis','Genesis 1–50'),
('Exodus','zh-CN','出埃及记','出埃及记 1–24'),('Exodus','en','Exodus','Exodus 1–24'),
('Samuel','zh-CN','撒母耳记','撒母耳记上 8–31；撒母耳记下 1–24'),('Samuel','en','Samuel','1 Samuel 8–31; 2 Samuel 1–24'),
('Kings','zh-CN','列王纪','列王纪上 1–22；列王纪下 1–25'),('Kings','en','Kings','1 Kings 1–22; 2 Kings 1–25'),
('Jonah','zh-CN','约拿书','约拿书 1–4'),('Jonah','en','Jonah','Jonah 1–4'),
('Gospel according to Matthew','zh-CN','马太福音','马太福音 1–28'),('Gospel according to Matthew','en','Gospel according to Matthew','Matthew 1–28'),
('Gospel according to Luke','zh-CN','路加福音','路加福音 1–24'),('Gospel according to Luke','en','Gospel according to Luke','Luke 1–24'),
('Acts of the Apostles','zh-CN','使徒行传','使徒行传 1–28'),('Acts of the Apostles','en','Acts of the Apostles','Acts 1–28'),
('Biblical chronology policy','zh-CN','年代表述政策','示例年代采用宽泛的学术范围，不裁定相互竞争的年代体系。'),('Biblical chronology policy','en','Biblical chronology policy','Demonstration chronology uses broad scholarly ranges and does not adjudicate competing chronologies.'),
('Biblical geography policy','zh-CN','地理表述政策','现代坐标用于标识今日地点或惯用参照点；有争议的地点标记为推定或近似。'),('Biblical geography policy','en','Biblical geography policy','Modern coordinates identify present-day sites or conventional reference points; disputed sites are marked inferred or approximate.'),
('Numbers','zh-CN','民数记','民数记 13–21'),('Numbers','en','Numbers','Numbers 13–21'),
('Deuteronomy','zh-CN','申命记','申命记 32–34'),('Deuteronomy','en','Deuteronomy','Deuteronomy 32–34'),
('Joshua','zh-CN','约书亚记','约书亚记 1–24'),('Joshua','en','Joshua','Joshua 1–24'),
('Judges','zh-CN','士师记','士师记 4–16'),('Judges','en','Judges','Judges 4–16'),
('Ruth','zh-CN','路得记','路得记 1–4'),('Ruth','en','Ruth','Ruth 1–4'),
('Chronicles','zh-CN','历代志','历代志上下'),('Chronicles','en','Chronicles','1–2 Chronicles'),
('Ezra','zh-CN','以斯拉记','以斯拉记 1–10'),('Ezra','en','Ezra','Ezra 1–10'),
('Nehemiah','zh-CN','尼希米记','尼希米记 1–13'),('Nehemiah','en','Nehemiah','Nehemiah 1–13'),
('Esther','zh-CN','以斯帖记','以斯帖记 1–10'),('Esther','en','Esther','Esther 1–10'),
('Isaiah','zh-CN','以赛亚书','以赛亚书 6；36–39'),('Isaiah','en','Isaiah','Isaiah 6; 36–39'),
('Jeremiah','zh-CN','耶利米书','耶利米书 1；38–43'),('Jeremiah','en','Jeremiah','Jeremiah 1; 38–43'),
('Ezekiel','zh-CN','以西结书','以西结书 1–3'),('Ezekiel','en','Ezekiel','Ezekiel 1–3'),
('Daniel','zh-CN','但以理书','但以理书 1–6'),('Daniel','en','Daniel','Daniel 1–6'),
('Amos','zh-CN','阿摩司书','阿摩司书 1–9'),('Amos','en','Amos','Amos 1–9'),
('Hosea','zh-CN','何西阿书','何西阿书 1–3'),('Hosea','en','Hosea','Hosea 1–3'),
('Gospel according to Mark','zh-CN','马可福音','马可福音 1–16'),('Gospel according to Mark','en','Gospel according to Mark','Mark 1–16'),
('Gospel according to John','zh-CN','约翰福音','约翰福音 1–21'),('Gospel according to John','en','Gospel according to John','John 1–21'),
('Letter to the Romans','zh-CN','罗马书','罗马书 1；15–16'),('Letter to the Romans','en','Letter to the Romans','Romans 1; 15–16'),
('Letters to the Corinthians','zh-CN','哥林多前后书','哥林多前书、后书'),('Letters to the Corinthians','en','Letters to the Corinthians','1–2 Corinthians'),
('Revelation','zh-CN','启示录','启示录 1–3'),('Revelation','en','Revelation','Revelation 1–3')
) AS v(title,locale,localised,citation) ON s.title=v.title AND s.work_id='10000000-0000-4000-8000-000000000005'
ON CONFLICT (source_id,locale) DO UPDATE SET title=EXCLUDED.title, citation=EXCLUDED.citation, status='published';

UPDATE work_chronologies SET start_year=-2100, end_year=100 WHERE work_id='10000000-0000-4000-8000-000000000005' AND kind='historical';

COMMIT;
