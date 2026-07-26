-- 027_clergy_audit_fixes.sql
-- 神职人员内容审计修正(见 docs/CLERGY_AUDIT.md)。
-- 范围:圣经作品(work 10000000-0000-4000-8000-000000000005)zh-CN 译文。
-- 原则:一切人名地名拼法向和合本(1919/新标点)惯例对齐;语体庄重克制。
-- 全部 UPDATE 幂等:replace() 重复执行无副作用,绝对赋值重复执行结果不变。

BEGIN;

-- ============================================================
-- 一、「凯撒」→「该撒」(和合本惯例)
-- 依据:和合本通篇作「该撒」(徒25:11「我要上告于该撒」)、
-- 「该撒利亚」(徒10:1)、「该撒利亚腓立比」(太16:13,无间隔号)。
-- 库中 caesarea-maritima 已作「该撒利亚」,以下各处为漏网的
-- 「凯撒」系拼法(和合本修订版用字),统一改回和合本用字。
-- 注意顺序:先处理带间隔号的「凯撒利亚·腓立比」,再泛替换「凯撒」。
-- ============================================================

-- 1a. 「凯撒利亚·腓立比」→「该撒利亚腓立比」(去间隔号,循和合本太16:13)
UPDATE location_translations t SET
  name    = replace(t.name,    '凯撒利亚·腓立比', '该撒利亚腓立比'),
  summary = replace(t.summary, '凯撒利亚·腓立比', '该撒利亚腓立比'),
  detail  = replace(t.detail,  '凯撒利亚·腓立比', '该撒利亚腓立比')
FROM locations l
WHERE l.id = t.location_id AND l.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND (t.name || t.summary || t.detail) LIKE '%凯撒利亚·腓立比%';

UPDATE event_translations t SET
  title   = replace(t.title,   '凯撒利亚·腓立比', '该撒利亚腓立比'),
  summary = replace(t.summary, '凯撒利亚·腓立比', '该撒利亚腓立比'),
  detail  = replace(t.detail,  '凯撒利亚·腓立比', '该撒利亚腓立比')
FROM events e
WHERE e.id = t.event_id AND e.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND (t.title || t.summary || t.detail) LIKE '%凯撒利亚·腓立比%';

-- 1b. 其余「凯撒」→「该撒」(同时覆盖「凯撒利亚」→「该撒利亚」;
--     「马凯鲁斯」不含「凯撒」二字连用,不受影响)
UPDATE character_translations t SET
  summary    = replace(t.summary,    '凯撒', '该撒'),
  detail     = replace(t.detail,     '凯撒', '该撒'),
  motivation = replace(t.motivation, '凯撒', '该撒')
FROM characters c
WHERE c.id = t.character_id AND c.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND (t.summary || t.detail || t.motivation) LIKE '%凯撒%';

UPDATE event_translations t SET
  title   = replace(t.title,   '凯撒', '该撒'),
  summary = replace(t.summary, '凯撒', '该撒'),
  detail  = replace(t.detail,  '凯撒', '该撒')
FROM events e
WHERE e.id = t.event_id AND e.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND (t.title || t.summary || t.detail) LIKE '%凯撒%';

UPDATE relation_translations t SET
  label   = replace(t.label,   '凯撒', '该撒'),
  summary = replace(t.summary, '凯撒', '该撒')
FROM character_relations r
WHERE r.id = t.relation_id AND r.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND (t.label || t.summary) LIKE '%凯撒%';

-- ============================================================
-- 二、「亚她利雅」→「亚他利雅」(和合本用字,王下11:1;
-- 「她」为和合本修订版改字,与本项目所据 1919 译本不符)
-- ============================================================
UPDATE character_translations t SET
  name    = replace(t.name,    '亚她利雅', '亚他利雅'),
  summary = replace(t.summary, '亚她利雅', '亚他利雅'),
  detail  = replace(t.detail,  '亚她利雅', '亚他利雅')
FROM characters c
WHERE c.id = t.character_id AND c.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND (t.name || t.summary || t.detail) LIKE '%亚她利雅%';

UPDATE event_translations t SET
  title   = replace(t.title,   '亚她利雅', '亚他利雅'),
  summary = replace(t.summary, '亚她利雅', '亚他利雅'),
  detail  = replace(t.detail,  '亚她利雅', '亚他利雅')
FROM events e
WHERE e.id = t.event_id AND e.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND (t.title || t.summary || t.detail) LIKE '%亚她利雅%';

UPDATE relation_translations t SET
  label   = replace(t.label,   '亚她利雅', '亚他利雅'),
  summary = replace(t.summary, '亚她利雅', '亚他利雅')
FROM character_relations r
WHERE r.id = t.relation_id AND r.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND (t.label || t.summary) LIKE '%亚她利雅%';

-- ============================================================
-- 三、「吕便」→「流便」(和合本用字,创29:32;「吕便」为和合本
-- 修订版用字。库内已有三处作「流便支派」等,本次统一)
-- ============================================================
UPDATE character_translations t SET
  name    = replace(t.name,    '吕便', '流便'),
  summary = replace(t.summary, '吕便', '流便'),
  detail  = replace(t.detail,  '吕便', '流便')
FROM characters c
WHERE c.id = t.character_id AND c.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND (t.name || t.summary || t.detail) LIKE '%吕便%';

UPDATE event_translations t SET
  title   = replace(t.title,   '吕便', '流便'),
  summary = replace(t.summary, '吕便', '流便'),
  detail  = replace(t.detail,  '吕便', '流便')
FROM events e
WHERE e.id = t.event_id AND e.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND (t.title || t.summary || t.detail) LIKE '%吕便%';

UPDATE relation_translations t SET
  label   = replace(t.label,   '吕便', '流便'),
  summary = replace(t.summary, '吕便', '流便')
FROM character_relations r
WHERE r.id = t.relation_id AND r.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND (t.label || t.summary) LIKE '%吕便%';

-- ============================================================
-- 四、「希律·安提帕」→「希律安提帕」
-- 体例统一:库内「希律亚基帕一世/二世」「大希律」均不用间隔号。
-- ============================================================
UPDATE character_translations t SET
  name = replace(t.name, '希律·安提帕', '希律安提帕')
FROM characters c
WHERE c.id = t.character_id AND c.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND t.name LIKE '%希律·安提帕%';

-- ============================================================
-- 五、马耳他 → 米利大(和合本徒28:1「那岛名叫米利大」)
-- 库内自相矛盾:事件「米利大的毒蛇与部百流之父得医治」已用
-- 和合本地名,而地点名与船难事件用现代名「马耳他」。
-- 依审计基准(和合本惯例,同「该撒利亚」例)统一为「米利大」;
-- 现代名转入别名与 modern_status,检索不受影响。
-- ============================================================
UPDATE location_translations t SET
  name    = '米利大',
  aliases = ARRAY['马耳他']
FROM locations l
WHERE l.id = t.location_id AND l.work_id = '10000000-0000-4000-8000-000000000005'
  AND l.slug = 'malta' AND t.locale = 'zh-CN';

UPDATE event_translations t SET
  title   = replace(t.title,   '马耳他', '米利大'),
  summary = replace(t.summary, '马耳他', '米利大'),
  detail  = replace(t.detail,  '马耳他', '米利大')
FROM events e
WHERE e.id = t.event_id AND e.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND (t.title || t.summary || t.detail) LIKE '%马耳他%';

UPDATE route_translations t SET
  summary = replace(t.summary, '马耳他', '米利大')
FROM routes r
WHERE r.id = t.route_id AND r.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND t.summary LIKE '%马耳他%';

-- ============================================================
-- 六、半角括号 → 全角括号(zh-CN 名称字段体例统一;
-- 库内主流为全角,如「犹流（百夫长）」「各各他（传统地点）」)
-- ============================================================
UPDATE character_translations t SET
  name = replace(replace(t.name, '(', '（'), ')', '）')
FROM characters c
WHERE c.id = t.character_id AND c.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND t.name ~ '[()]';

UPDATE location_translations t SET
  name = replace(replace(t.name, '(', '（'), ')', '）')
FROM locations l
WHERE l.id = t.location_id AND l.work_id = '10000000-0000-4000-8000-000000000005'
  AND t.locale = 'zh-CN' AND t.name ~ '[()]';

-- ============================================================
-- 七、语体:「暴毙」过于俚俗轻慢,不合牧养语境;
-- 改为中性的「死于/…而死」表述(经文口吻,徒12:23)。
-- (绝对赋值置于「该撒」替换之后,内嵌最终拼法,幂等。)
-- ============================================================
UPDATE event_translations t SET
  title = '希律亚基帕死于该撒利亚'
FROM events e
WHERE e.id = t.event_id AND e.work_id = '10000000-0000-4000-8000-000000000005'
  AND e.slug = 'death-of-herod-agrippa' AND t.locale = 'zh-CN';

UPDATE character_translations t SET
  summary = '杀害使徒雅各、囚禁彼得的犹太王，后死于该撒利亚。'
FROM characters c
WHERE c.id = t.character_id AND c.work_id = '10000000-0000-4000-8000-000000000005'
  AND c.slug = 'herod-agrippa-i' AND t.locale = 'zh-CN';

-- ============================================================
-- 八、补充和合本地名/人名别名(检索友好;主名维持既有
-- 「现代名为主」的策展决定,是否改主名见审计报告「待人工核对」)
-- ============================================================
UPDATE location_translations t SET aliases = array_append(t.aliases, '居比路')
FROM locations l
WHERE l.id = t.location_id AND l.work_id = '10000000-0000-4000-8000-000000000005'
  AND l.slug = 'cyprus-salamis' AND t.locale = 'zh-CN'
  AND NOT ('居比路' = ANY(t.aliases));  -- 和合本徒13:4「居比路」

UPDATE character_translations t SET aliases = array_append(t.aliases, '古列')
FROM characters c
WHERE c.id = t.character_id AND c.work_id = '10000000-0000-4000-8000-000000000005'
  AND c.slug = 'cyrus' AND t.locale = 'zh-CN'
  AND NOT ('古列' = ANY(t.aliases));  -- 和合本拉1:1「古列」

UPDATE character_translations t SET aliases = array_append(t.aliases, '大利乌')
FROM characters c
WHERE c.id = t.character_id AND c.work_id = '10000000-0000-4000-8000-000000000005'
  AND c.slug = 'darius-the-mede' AND t.locale = 'zh-CN'
  AND NOT ('大利乌' = ANY(t.aliases));  -- 和合本但5:31「玛代人大利乌」

-- ============================================================
-- 自检(各项应返回 0)
-- ============================================================
SELECT count(*) AS remaining_kaisa
FROM character_translations t JOIN characters c ON c.id = t.character_id
WHERE c.work_id = '10000000-0000-4000-8000-000000000005' AND t.locale = 'zh-CN'
  AND (t.name || t.summary || t.detail || t.motivation) LIKE '%凯撒%';

SELECT count(*) AS remaining_kaisa_ev_loc_rel
FROM (
  SELECT t.title || t.summary || t.detail AS txt FROM event_translations t
    JOIN events e ON e.id = t.event_id
    WHERE e.work_id = '10000000-0000-4000-8000-000000000005' AND t.locale = 'zh-CN'
  UNION ALL
  SELECT t.name || t.summary || t.detail FROM location_translations t
    JOIN locations l ON l.id = t.location_id
    WHERE l.work_id = '10000000-0000-4000-8000-000000000005' AND t.locale = 'zh-CN'
  UNION ALL
  SELECT t.label || t.summary FROM relation_translations t
    JOIN character_relations r ON r.id = t.relation_id
    WHERE r.work_id = '10000000-0000-4000-8000-000000000005' AND t.locale = 'zh-CN'
) x WHERE x.txt LIKE '%凯撒%';

SELECT count(*) AS remaining_athaliah_ta
FROM (
  SELECT t.name || t.summary || t.detail AS txt FROM character_translations t
    JOIN characters c ON c.id = t.character_id
    WHERE c.work_id = '10000000-0000-4000-8000-000000000005' AND t.locale = 'zh-CN'
  UNION ALL
  SELECT t.title || t.summary || t.detail FROM event_translations t
    JOIN events e ON e.id = t.event_id
    WHERE e.work_id = '10000000-0000-4000-8000-000000000005' AND t.locale = 'zh-CN'
  UNION ALL
  SELECT t.label || t.summary FROM relation_translations t
    JOIN character_relations r ON r.id = t.relation_id
    WHERE r.work_id = '10000000-0000-4000-8000-000000000005' AND t.locale = 'zh-CN'
) x WHERE x.txt LIKE '%亚她利雅%' OR x.txt LIKE '%吕便%' OR x.txt LIKE '%暴毙%';

SELECT count(*) AS remaining_halfwidth_paren_names
FROM (
  SELECT t.name FROM character_translations t JOIN characters c ON c.id = t.character_id
    WHERE c.work_id = '10000000-0000-4000-8000-000000000005' AND t.locale = 'zh-CN'
  UNION ALL
  SELECT t.name FROM location_translations t JOIN locations l ON l.id = t.location_id
    WHERE l.work_id = '10000000-0000-4000-8000-000000000005' AND t.locale = 'zh-CN'
) x WHERE x.name ~ '[()]';

COMMIT;
