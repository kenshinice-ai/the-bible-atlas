BEGIN;

-- Bible visual pilot: one rights-audited local image for each of the three
-- first-class entity contexts. This is deliberately a pilot, not a claim that
-- every Bible entity has an image.
CREATE OR REPLACE FUNCTION pg_temp.stable_uuid(seed text) RETURNS uuid
LANGUAGE sql IMMUTABLE AS $fn$
  SELECT (substr(md5(seed),1,8)||'-'||substr(md5(seed),9,4)||'-4'||substr(md5(seed),14,3)||'-8'||substr(md5(seed),18,3)||'-'||substr(md5(seed),21))::uuid
$fn$;

-- Person: a public-domain nineteenth-century artistic depiction. It is
-- explicitly labelled as illustrative, not as a historical portrait.
INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type)
VALUES (
  pg_temp.stable_uuid('source:commons:bible:abraham-three-angels'),
  '10000000-0000-4000-8000-000000000005',
  'Wikimedia Commons: Abraham and the Three Angels',
  'https://commons.wikimedia.org/wiki/File:012.Abraham_and_the_Three_Angels.jpg',
  'Author: Gustave Doré; licence: Public domain; illustration file page: https://commons.wikimedia.org/wiki/File:012.Abraham_and_the_Three_Angels.jpg',
  'reference',
  'image'
)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,url=EXCLUDED.url,citation=EXCLUDED.citation,evidence_grade=EXCLUDED.evidence_grade,source_type=EXCLUDED.source_type;

INSERT INTO source_translations(source_id,locale,title,citation,status)
VALUES
  (pg_temp.stable_uuid('source:commons:bible:abraham-three-angels'),'zh-CN','Wikimedia Commons：亚伯拉罕与三位天使','作者：Gustave Doré；许可：Public domain；人物形象为艺术性诠释，不是历史肖像；图片文件页：https://commons.wikimedia.org/wiki/File:012.Abraham_and_the_Three_Angels.jpg','published'),
  (pg_temp.stable_uuid('source:commons:bible:abraham-three-angels'),'en','Wikimedia Commons: Abraham and the Three Angels','Author: Gustave Doré; licence: Public domain; the character image is an artistic depiction, not a historical portrait; file page: https://commons.wikimedia.org/wiki/File:012.Abraham_and_the_Three_Angels.jpg','published')
ON CONFLICT (source_id,locale) DO UPDATE SET title=EXCLUDED.title,citation=EXCLUDED.citation,status=EXCLUDED.status;

INSERT INTO character_sources(character_id,source_id)
SELECT c.id,pg_temp.stable_uuid('source:commons:bible:abraham-three-angels')
FROM characters c
WHERE c.work_id='10000000-0000-4000-8000-000000000005' AND c.slug='abraham'
ON CONFLICT DO NOTHING;

INSERT INTO media_assets(
  id,source_id,asset_source,asset_licence,asset_author,asset_url,attribution_text,
  alt_text_zh,alt_text_en,media_kind,usage_mode,license_status,license_url,
  source_page_url,original_url,retrieved_at,checksum_sha256,media_role,depiction_status
)
VALUES (
  pg_temp.stable_uuid('media:commons:bible:abraham-three-angels'),
  pg_temp.stable_uuid('source:commons:bible:abraham-three-angels'),
  'Wikimedia Commons','Public domain','Gustave Doré','/media/bible/abraham-three-angels.jpg',
  'Gustave Doré / Wikimedia Commons / Public domain',
  '亚伯拉罕与三位天使（古斯塔夫·多雷，《创世记》18:1–16）；人物形象示意，非历史肖像',
  'Abraham and the Three Angels (Gustave Doré, Genesis 18:1–16); illustrative depiction, not a historical portrait',
  'image','bundled','verified','https://creativecommons.org/publicdomain/mark/1.0/',
  'https://commons.wikimedia.org/wiki/File:012.Abraham_and_the_Three_Angels.jpg',
  'https://upload.wikimedia.org/wikipedia/commons/9/9b/012.Abraham_and_the_Three_Angels.jpg',
  '2026-08-09T00:00:00Z'::timestamptz,
  'd74dd373bb21dc1ec47388a9ecc3f1836d9222872a29e16b06502c69651e074c',
  'character_depiction','illustrative'
)
ON CONFLICT (id) DO UPDATE SET
  source_id=EXCLUDED.source_id,asset_source=EXCLUDED.asset_source,asset_licence=EXCLUDED.asset_licence,
  asset_author=EXCLUDED.asset_author,asset_url=EXCLUDED.asset_url,attribution_text=EXCLUDED.attribution_text,
  alt_text_zh=EXCLUDED.alt_text_zh,alt_text_en=EXCLUDED.alt_text_en,media_kind=EXCLUDED.media_kind,
  usage_mode=EXCLUDED.usage_mode,license_status=EXCLUDED.license_status,license_url=EXCLUDED.license_url,
  source_page_url=EXCLUDED.source_page_url,original_url=EXCLUDED.original_url,retrieved_at=EXCLUDED.retrieved_at,
  checksum_sha256=EXCLUDED.checksum_sha256,media_role=EXCLUDED.media_role,depiction_status=EXCLUDED.depiction_status;

INSERT INTO media_links(media_id,entity_kind,entity_id,sort_order)
SELECT pg_temp.stable_uuid('media:commons:bible:abraham-three-angels'),'character',c.id,0
FROM characters c
WHERE c.work_id='10000000-0000-4000-8000-000000000005' AND c.slug='abraham'
ON CONFLICT (media_id,entity_kind,entity_id) DO UPDATE SET sort_order=EXCLUDED.sort_order;

-- Event: a public-domain Doré scene, shown as an illustrative narrative
-- reference rather than a documentary image of an event.
INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type)
VALUES (
  pg_temp.stable_uuid('source:commons:bible:great-flood'),
  '10000000-0000-4000-8000-000000000005',
  'Wikimedia Commons: The Great Flood',
  'https://commons.wikimedia.org/wiki/File:007.The_Great_Flood.jpg',
  'Author: Gustave Doré; licence: Public domain; illustration file page: https://commons.wikimedia.org/wiki/File:007.The_Great_Flood.jpg',
  'reference',
  'image'
)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,url=EXCLUDED.url,citation=EXCLUDED.citation,evidence_grade=EXCLUDED.evidence_grade,source_type=EXCLUDED.source_type;

INSERT INTO source_translations(source_id,locale,title,citation,status)
VALUES
  (pg_temp.stable_uuid('source:commons:bible:great-flood'),'zh-CN','Wikimedia Commons：大洪水','作者：Gustave Doré；许可：Public domain；事件场景为艺术性诠释，不是现场记录；图片文件页：https://commons.wikimedia.org/wiki/File:007.The_Great_Flood.jpg','published'),
  (pg_temp.stable_uuid('source:commons:bible:great-flood'),'en','Wikimedia Commons: The Great Flood','Author: Gustave Doré; licence: Public domain; the event scene is an artistic depiction, not an eyewitness record; file page: https://commons.wikimedia.org/wiki/File:007.The_Great_Flood.jpg','published')
ON CONFLICT (source_id,locale) DO UPDATE SET title=EXCLUDED.title,citation=EXCLUDED.citation,status=EXCLUDED.status;

INSERT INTO event_sources(event_id,source_id)
SELECT e.id,pg_temp.stable_uuid('source:commons:bible:great-flood')
FROM events e
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug='flood-narrative-ends-at-ararat'
ON CONFLICT DO NOTHING;

INSERT INTO media_assets(
  id,source_id,asset_source,asset_licence,asset_author,asset_url,attribution_text,
  alt_text_zh,alt_text_en,media_kind,usage_mode,license_status,license_url,
  source_page_url,original_url,retrieved_at,checksum_sha256,media_role,depiction_status
)
VALUES (
  pg_temp.stable_uuid('media:commons:bible:great-flood'),
  pg_temp.stable_uuid('source:commons:bible:great-flood'),
  'Wikimedia Commons','Public domain','Gustave Doré','/media/bible/great-flood.jpg',
  'Gustave Doré / Wikimedia Commons / Public domain',
  '大洪水（古斯塔夫·多雷，《创世记》7:11–24）；事件场景示意，非现场记录',
  'The Great Flood (Gustave Doré, Genesis 7:11–24); illustrative event scene, not an eyewitness record',
  'image','bundled','verified','https://creativecommons.org/publicdomain/mark/1.0/',
  'https://commons.wikimedia.org/wiki/File:007.The_Great_Flood.jpg',
  'https://upload.wikimedia.org/wikipedia/commons/6/64/007.The_Great_Flood.jpg',
  '2026-08-09T00:00:00Z'::timestamptz,
  '26e9529764d6b1cff500fb9cae92dd4585a96d98e7ae4a999c51e0fc86ef0dd4',
  'event_scene','illustrative'
)
ON CONFLICT (id) DO UPDATE SET
  source_id=EXCLUDED.source_id,asset_source=EXCLUDED.asset_source,asset_licence=EXCLUDED.asset_licence,
  asset_author=EXCLUDED.asset_author,asset_url=EXCLUDED.asset_url,attribution_text=EXCLUDED.attribution_text,
  alt_text_zh=EXCLUDED.alt_text_zh,alt_text_en=EXCLUDED.alt_text_en,media_kind=EXCLUDED.media_kind,
  usage_mode=EXCLUDED.usage_mode,license_status=EXCLUDED.license_status,license_url=EXCLUDED.license_url,
  source_page_url=EXCLUDED.source_page_url,original_url=EXCLUDED.original_url,retrieved_at=EXCLUDED.retrieved_at,
  checksum_sha256=EXCLUDED.checksum_sha256,media_role=EXCLUDED.media_role,depiction_status=EXCLUDED.depiction_status;

INSERT INTO media_links(media_id,entity_kind,entity_id,sort_order)
SELECT pg_temp.stable_uuid('media:commons:bible:great-flood'),'event',e.id,0
FROM events e
WHERE e.work_id='10000000-0000-4000-8000-000000000005' AND e.slug='flood-narrative-ends-at-ararat'
ON CONFLICT (media_id,entity_kind,entity_id) DO UPDATE SET sort_order=EXCLUDED.sort_order;

-- Place: a public-domain photograph of the Western Wall in Jerusalem. It is
-- documentary about the present site, not evidence that every biblical scene
-- happened at the photographed viewpoint.
INSERT INTO sources(id,work_id,title,url,citation,evidence_grade,source_type)
VALUES (
  pg_temp.stable_uuid('source:commons:bible:jerusalem-western-wall'),
  '10000000-0000-4000-8000-000000000005',
  'Wikimedia Commons: Jerusalem Western Wall',
  'https://commons.wikimedia.org/wiki/File:Jerusalem_Western_Wall_BW_1.JPG',
  'Author: Berthold Werner; licence: Public domain; photograph file page: https://commons.wikimedia.org/wiki/File:Jerusalem_Western_Wall_BW_1.JPG',
  'reference',
  'image'
)
ON CONFLICT (id) DO UPDATE SET title=EXCLUDED.title,url=EXCLUDED.url,citation=EXCLUDED.citation,evidence_grade=EXCLUDED.evidence_grade,source_type=EXCLUDED.source_type;

INSERT INTO source_translations(source_id,locale,title,citation,status)
VALUES
  (pg_temp.stable_uuid('source:commons:bible:jerusalem-western-wall'),'zh-CN','Wikimedia Commons：耶路撒冷西墙','作者：Berthold Werner；许可：Public domain；这是现代地点照片，不是经文事件的现场证据；图片文件页：https://commons.wikimedia.org/wiki/File:Jerusalem_Western_Wall_BW_1.JPG','published'),
  (pg_temp.stable_uuid('source:commons:bible:jerusalem-western-wall'),'en','Wikimedia Commons: Jerusalem Western Wall','Author: Berthold Werner; licence: Public domain; this is a present-day site photograph, not eyewitness evidence for a scriptural event; file page: https://commons.wikimedia.org/wiki/File:Jerusalem_Western_Wall_BW_1.JPG','published')
ON CONFLICT (source_id,locale) DO UPDATE SET title=EXCLUDED.title,citation=EXCLUDED.citation,status=EXCLUDED.status;

INSERT INTO media_assets(
  id,source_id,asset_source,asset_licence,asset_author,asset_url,attribution_text,
  alt_text_zh,alt_text_en,media_kind,usage_mode,license_status,license_url,
  source_page_url,original_url,retrieved_at,checksum_sha256,media_role,depiction_status
)
VALUES (
  pg_temp.stable_uuid('media:commons:bible:jerusalem-western-wall'),
  pg_temp.stable_uuid('source:commons:bible:jerusalem-western-wall'),
  'Wikimedia Commons','Public domain','Berthold Werner','/media/bible/jerusalem-western-wall.jpg',
  'Berthold Werner / Wikimedia Commons / Public domain',
  '耶路撒冷西墙（Berthold Werner，2008）；现代地点照片，不等同于古代场景',
  'Western Wall in Jerusalem (Berthold Werner, 2008); present-day site photograph, not an ancient scene',
  'image','bundled','verified','https://creativecommons.org/publicdomain/mark/1.0/',
  'https://commons.wikimedia.org/wiki/File:Jerusalem_Western_Wall_BW_1.JPG',
  'https://upload.wikimedia.org/wikipedia/commons/c/cd/Jerusalem_Western_Wall_BW_1.JPG',
  '2026-08-09T00:00:00Z'::timestamptz,
  '2c2df9fe51ddbe2846e17bc06782ed4327dce8d5c199a60c8bef4ff81c839f30',
  'place_view','documentary'
)
ON CONFLICT (id) DO UPDATE SET
  source_id=EXCLUDED.source_id,asset_source=EXCLUDED.asset_source,asset_licence=EXCLUDED.asset_licence,
  asset_author=EXCLUDED.asset_author,asset_url=EXCLUDED.asset_url,attribution_text=EXCLUDED.attribution_text,
  alt_text_zh=EXCLUDED.alt_text_zh,alt_text_en=EXCLUDED.alt_text_en,media_kind=EXCLUDED.media_kind,
  usage_mode=EXCLUDED.usage_mode,license_status=EXCLUDED.license_status,license_url=EXCLUDED.license_url,
  source_page_url=EXCLUDED.source_page_url,original_url=EXCLUDED.original_url,retrieved_at=EXCLUDED.retrieved_at,
  checksum_sha256=EXCLUDED.checksum_sha256,media_role=EXCLUDED.media_role,depiction_status=EXCLUDED.depiction_status;

INSERT INTO media_links(media_id,entity_kind,entity_id,sort_order)
SELECT pg_temp.stable_uuid('media:commons:bible:jerusalem-western-wall'),'location',l.id,0
FROM locations l
WHERE l.work_id='10000000-0000-4000-8000-000000000005' AND l.slug='jerusalem'
ON CONFLICT (media_id,entity_kind,entity_id) DO UPDATE SET sort_order=EXCLUDED.sort_order;

COMMIT;
