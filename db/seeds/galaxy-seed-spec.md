# 银河原力舆图 · 时代种子共享规范(041–052)

你要为《银河原力舆图 The Galactic Force Atlas》生成一个时代的 SQL 种子文件。

- 种子目录:`<项目目录>/db/seeds/`
- 数据库(只读参考 + 回滚自测):`postgresql://llmacbookpro@localhost:5432/literary_atlas`
- **骨架模板:先完整阅读 `db/seeds/040_galaxy_structure.sql`**(work / 12 时代 / 13 群体 / 39 地点 / 24 锚点人物 / 3 条航线都已在其中),再参考 `db/seeds/010_bible_full_01_primeval.sql` 的事件写法。
- work_id:`10000000-0000-4000-8000-000000000008`(slug `skywalker-saga`)
- 蓝图:[blueprint/star-wars/SAGA_BLUEPRINT.md](../../blueprint/star-wars/SAGA_BLUEPRINT.md);**IP 边界是硬前提,先读 §7**。

## 1. 文件结构

`BEGIN;` … 1.CHARACTERS → 2.LOCATIONS(见 §5,通常为空)→ 3.EVENTS → 4.EVENT TRANSLATIONS → 5.EVENT-LOCATIONS → 6.EVENT-CHARACTERS → 7.EVENT-SOURCES → 8.CHARACTER RELATIONS(+ relation_translations)→ 9.GROUP MEMBERSHIP … `COMMIT;`

## 2. ID 与编号约定(KK = 你的时代两位编号,01–12)

| 实体 | 前缀 |
|---|---|
| characters | `48000000-0000-4000-80KK-` + 12 位序号 |
| locations | `38000000-0000-4000-80KK-` |
| events | `68000000-0000-4000-80KK-` |
| character_relations | `78000000-0000-4000-80KK-` |

骨架期已占用的是 `-8000-` 段(chapters `88…`、groups `a8…`、sources `58…`、routes `b8…`、chronology `91000000-0000-4000-8000-000000000006`),不要写入这些表。

- 事件 sequence 区间:`K*1000+1` 到 `K*1000+999`,按叙事顺序以步长 2 从 `K*1000+1` 开始。
- characters.sort_order / locations.sort_order:各自从 `K*100` 起递增(骨架期锚点人物已占 1–24)。

## 3. 三条硬约束(违反即返工,已有前车之鉴)

1. **每条 character_relations 必须同时写 `relation_translations`(zh-CN + en,`status='published'`)。**
   圣经 010–022 漏了这一步,API 因缺少已发布 label 过滤掉 272 条关系中的 170 条,只能靠补丁种子 024 回填。标签要具体到双语角色对(`师徒(魁刚→欧比旺)` / `Master and apprentice (Qui-Gon → Obi-Wan)`),不要写 `mentor` 这类泛型词。
2. **所有翻译表与成员表的 INSERT 一律加 `ON CONFLICT DO NOTHING`。**
   三国 037/038 都建了司马师,人物表靠 ON CONFLICT 跳过,翻译表却撞主键炸了整个文件。需要防护的表:characters、character_translations、locations、location_translations、character_relations、relation_translations、character_group_members、event_characters、event_locations、event_sources。
   events 与 event_translations **不加**——事件 slug 撞车说明重复造了已有事件,必须改 slug。
3. **禁止新建行星。** 39 座天体是封闭清单(§5)。

## 4. 纪年:BBY/ABY ↔ 带符号年份

- **BBY n → −n,ABY n → +n**;原点是雅汶战役。
- **没有 0 年**(库有 CHECK 拦截):`0 BBY`(战役当年、战役前)→ `−1`;`0 ABY`(战役当年、战役后)→ `+1`。`time_label` 照写 `0 BBY`。
- events:`time_type='fictional_calendar'`、`calendar_system='fictional'`,`historical_start_year/end_year` 填映射后的带符号整数,且必须落在你的时代区间内(§6)。
- **`event_translations.time_label` 必填双语**:`雅汶战役前 22 年` / `22 BBY`;区间写 `雅汶战役前 22–19 年` / `c. 22–19 BBY`。
  时间轴表头、时代 chip、人物生卒年这三处**绕过 time_label 直接格式化年份**,靠前端 profile 的 yearLabels 渲染成 BBY/ABY;time_label 管的是事件卡片与抽屉。两条路都必须对。
- 装载后必须过纪年门(§9 第 2 组 SQL),零容忍。

## 5. 地点:封闭清单,不得新增行星

骨架期已入库 39 座天体(35 planet / 3 moon:yavin-4、endor、jedha / 2 space_station:death-star、death-star-ii),坐标是全局资产。

- 你**只能引用**,不能新建行星。
- 确有必要时可新建**行星表面场所**(某座城市、某处神庙、某个基地),`location_type` 用 `city`/`building`/`landmark`/`battlefield` 等既有值,`layer='fictional'`、`geom=NULL`、`coordinate_accuracy='fictional'`、`preferred_zoom=8`,**canvas 坐标继承母行星 ±1 以内**,否则画布散点会漂移。
- 库 CHECK:`layer='fictional'` 时 `geom` 必须为 NULL 且 canvas_x/canvas_y 在 0–100;`coordinate_accuracy` 必须是 `fictional`。

## 6. 十二时代区间

| KK | slug | 银河纪年 | 库年份 |
|---|---|---|---|
| 01 | naboo-crisis | 32 BBY | −33…−31 |
| 02 | clone-wars | 22–19 BBY | −23…−19 |
| 03 | order-66-and-imperial-rise | 19 BBY | −20…−19 |
| 04 | dark-times | 19–5 BBY | −19…−5 |
| 05 | rebel-alliance-rising | 5–0 BBY | −5…−1 |
| 06 | yavin-campaign | 0 BBY–0 ABY | −1…1 |
| 07 | hoth-and-exile | 3 ABY | 2…4 |
| 08 | endor-and-the-fall | 4 ABY | 4…5 |
| 09 | new-republic | 5–28 ABY | 5…28 |
| 10 | first-order-rising | 28–34 ABY | 28…34 |
| 11 | last-jedi | 34 ABY | 34…35 |
| 12 | skywalker-reborn | 35 ABY | 35…36 |

- 04 与 09 是**宽年代低密度**时代(各 8–12 事件),留给衍生作品填厚;其余每时代 18–24 事件。
- 时代边界重叠(05 与 06 在 −1 咬合)是有意的,照写即可。
- 事件必须挂 `chapter_id`(按 slug JOIN chapters)。

## 7. IP 边界(一页纸,每条都是红线)

| 可以 | 不可以 |
|---|---|
| 事实性指称专名(科洛桑、达斯·维达) | 专名进产品名 / logo / 域名 |
| **原创转述**剧情,检索粒度 | 复制任何 ≥8 连续词的影片台词、官方小说、官方百科(含 Wookieepedia,其 CC BY-SA 会传染许可) |
| 中性叙事口吻:`影片叙述…` / `The film depicts…` | 引号包裹的台词出现在 event 文本里(题词位另有配额,已用满 2/3,你不得再加) |
| 原创示意坐标 | 摹绘官方地图、使用剧照 / 海报 / 官方 logo |

- **每事件 summary 1–2 句,detail 一段以内**:做索引与因果定位,不重构可替代观影体验的连续叙事。
- `sources` 已在骨架期建好(9 部影片各 1 条 + 纪年政策 + 画布政策),按 title JOIN 引用,不要新建。
- 阶段 7 的 IP 审读会对全库跑 ≥8 连续词重合机检,命中即打回改写。

## 8. 枚举值(只能用这些)

- event_type:birth, death, meeting, journey, battle, trial, imprisonment, escape, marriage, betrayal, discovery, political, social, religious, migration, other
- event_reality:本作品全部虚构,用 `fictional_narrative`;传说/异象/原力显现用 `legendary_or_mythic`;银河尺度的背景性变动可用 `fictional_with_historical_context`
- confidence:影片正面呈现的 `high`;银幕外交代或推断的 `medium`;仅有暗示的 `low`
- time_type:`fictional_calendar`(本作品统一);calendar_system:`fictional`
- gender:male, female, unknown, na;age_stage:child, youth, adult, elder, unknown
- role_type:protagonist, antagonist, supporting, narrator, historical, collective, supernatural
- reality_type(人物):**全部 `fictional`**
- icon_variant:jedi, sith, droid, pilot, senator, smuggler, bounty_hunter, ruler, soldier, queen, person
- location_type:planet, moon, space_station(骨架期已定)+ 表面场所可用 city, building, landmark, battlefield
- relation_type:family, spouse, sibling, ally, adversary, mentor, romantic, liege, other;direction:bidirectional, source_to_target, target_to_source;sentiment:positive, negative, mixed, neutral;status:active, ended, changed, unknown;strength 1–5;importance 1–5
- locale:zh-CN, en;所有 translations 的 `status` 一律 `'published'`

## 9. 别名建模(本作品的特有规则)

同一人的两个名号是**一个 character 行**,变身写进 `character_translations.aliases`(text[])并在 summary/detail 里叙明转变;**绝不建两行**。两行会把「阿纳金↔欧比旺」与「维达↔卢克」拆成两个互不相连的节点,关系图的主脊线就断了。搜索按 name + aliases 命中,两个名字都查得到。骨架期已按此建好 24 位锚点人物,你只需引用。

## 10. 自测(写完必须做,直到零错误)

```bash
SCRATCH=<当前会话的可写临时目录>
cd "<项目目录>/db/seeds"
sed 's/^COMMIT;$/ROLLBACK;/' 04N_你的文件.sql > "$SCRATCH/test_KK.sql"
psql "postgresql://llmacbookpro@localhost:5432/literary_atlas" -v ON_ERROR_STOP=1 -f "$SCRATCH/test_KK.sql"
```

在 `ROLLBACK;` 之前插入下列检查(KK 换成你的编号),**全部必须 0 行**:

```sql
-- 第 1 组:孤儿检查(JOIN 静默丢行 = slug 拼错)
SELECT e.slug FROM events e WHERE e.id::text LIKE '68000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM event_translations t WHERE t.event_id=e.id AND t.locale='en');
SELECT e.slug FROM events e WHERE e.id::text LIKE '68000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM event_locations x WHERE x.event_id=e.id);
SELECT e.slug FROM events e WHERE e.id::text LIKE '68000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM event_characters x WHERE x.event_id=e.id);
SELECT e.slug FROM events e WHERE e.id::text LIKE '68000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM event_sources x WHERE x.event_id=e.id);
SELECT c.slug FROM characters c WHERE c.id::text LIKE '48000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM character_translations t WHERE t.character_id=c.id AND t.locale='zh-CN');
-- 关系必须有已发布的双语 label,否则 API 会整条过滤掉
SELECT r.id FROM character_relations r WHERE r.id::text LIKE '78000000-0000-4000-80KK%'
  AND (SELECT count(*) FROM relation_translations t WHERE t.relation_id=r.id AND t.status='published') < 2;

-- 第 2 组:纪年门(零容忍)
SELECT e.slug FROM events e JOIN event_translations t ON t.event_id=e.id
WHERE e.work_id='10000000-0000-4000-8000-000000000008'
  AND (t.time_label='' OR t.time_label LIKE '%公元%' OR t.time_label LIKE '%BCE%' OR t.time_label LIKE '%CE');
SELECT e.slug FROM events e JOIN event_translations t ON t.event_id=e.id AND t.locale='en'
WHERE e.work_id='10000000-0000-4000-8000-000000000008'
  AND ((e.historical_start_year<0 AND t.time_label NOT LIKE '%BBY%') OR (e.historical_start_year>0 AND t.time_label NOT LIKE '%ABY%'));
-- 事件年份必须落在自己时代的区间内
SELECT e.slug FROM events e JOIN chapters c ON c.id=e.chapter_id
WHERE e.id::text LIKE '68000000-0000-4000-80KK%'
  AND (e.historical_start_year < c.era_start_year OR COALESCE(e.historical_end_year,e.historical_start_year) > c.era_end_year);

-- 第 3 组:画布纪律
SELECT l.slug FROM locations l WHERE l.id::text LIKE '38000000-0000-4000-80KK%' AND l.location_type='planet';  -- 新建行星是违规
```

自测通过后**不要自行装载**,交回主会话按编号顺序装载并登记 `seed_history`。
