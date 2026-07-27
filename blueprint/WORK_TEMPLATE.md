# 作品种子模板:与作品无关的种子生产规范

> 本文把 `db/seeds/bible-seed-spec.md`(圣经实战规范)抽象为**任何新作品都适用**的规则。生产编排见 [PIPELINE.md](PIPELINE.md);引擎/参数边界见 [ARCHITECTURE.md](ARCHITECTURE.md);三国实例见 [EXAMPLE_THREE_KINGDOMS.md](EXAMPLE_THREE_KINGDOMS.md)。
> 圣经的对应实例:结构模板 `db/seeds/010_bible_full_01_primeval.sql`,密度模板 `015/016`,精修模板 `026`。

## 1. UUID 命名空间分配

全库 UUID 是手写的 v4 形式常量,靠**前缀分区**避免撞车。已占用与分配规则:

### 1.1 作品编号 W

`works.id = 10000000-0000-4000-8000-0000000000NN`。已用 NN=01–05(双城记/安妮日记/牧羊少年/霍比特人/圣经)。**新作品从 06 起顺延**;史+演义一对占两个号(如 06=志、07=演义)。

### 1.2 实体类型前缀 + 作品位 X

圣经扩充采用 `TX000000-0000-4000-80KK-############`(12 位十进制序号),其中 **T=实体类型、X=作品位、KK=时代两位编号**:

| 实体 | T | 圣经(X=3) | 建议:作品 06 用 X=6,作品 07 用 X=7 |
|---|---|---|---|
| characters | 4 | `43000000-…` | `46…` / `47…` |
| locations | 3 | `33000000-…` | `36…` / `37…` |
| events | 6 | `63000000-…` | `66…` / `67…` |
| character_relations | 7 | `73000000-…` | `76…` / `77…` |
| chapters | 82 固定段 | `82000000-0000-4000-8000-0000000000NN` | 顺延新号段 `83…`/`84…`(或沿用 82 段续号,但须先查库避让) |
| character_groups | a2 固定段 | `a2000000-…` | `a6…` / `a7…` |
| sources | 52 固定段 | `52000000-…` | `56…` / `57…` |

规则总结:**给每个新作品挑一个未用的十六进制作品位 X,全套实体前缀跟着走**;时代内序号永远从 1 起且带 KK 分区,不同代理绝不可能生成相同 UUID。分配后把本表复制进新作品的 seed-spec,作为所有生成代理的公共契约。

### 1.3 KK 时代命名空间

- KK = 时代两位编号(01–13…),等于该时代 chapter 的 sequence。
- 事件 `sequence` 区间:`K*1000+1 … K*1000+999`,**步长 2** 编号(留奇偶空隙便于后插)。
- `characters.sort_order` 与 `locations.sort_order`:各自从 `K*100` 起递增(两表独立计数)。
- 全部时代装载完后跑一次**全局重排**(模板 `db/seeds/023_bible_global_sequence_rebands.sql`:按「时代 sequence + 时代内现序」ROW_NUMBER 重排,幂等,可反复跑)。

## 2. 种子文件结构(每时代一个文件)

命名 `0NN_<work>_full_KK_<era-slug>.sql`,`BEGIN; … COMMIT;` 包裹,节序固定(照抄 010):

1. CHARACTERS(+ character_translations)
2. LOCATIONS(+ location_translations)
3. EVENTS(新事件 INSERT,JOIN chapters ON slug+work_id)
4. 已有事件重排(UPDATE sequence 进本时代区间)
5. EVENT TRANSLATIONS
6. EVENT-LOCATIONS
7. EVENT-CHARACTERS
8. EVENT-SOURCES
9. CHARACTER RELATIONS(+ **relation_translations,见 §4**)
10. GROUP MEMBERSHIP

### 冲突免疫

- `ON CONFLICT DO NOTHING` **必加**:characters、character_translations、locations、location_translations、character_relations、relation_translations、character_group_members、event_characters、event_locations、event_sources。
- **不加**:events、event_translations——事件 slug 撞车说明重复创建了已有事件,必须让它报错并改掉。

### 实体复用与跨时代归属(防 slug 撞名的核心制度)

- **禁止重新创建已存在实体**;引用一律通过 slug JOIN(JOIN 失配会**静默丢行**,所以必须配 §5 孤儿检查)。
- 每个人物/地点由**唯一归属时代**创建(在任务提示里发给各代理的负责名单);其他时代只可引用:① 骨架期已有实体;② 自己新建的;③ **编号更小**时代创建的(装载顺序在前)。绝不引用编号更大时代的实体。
- 群体只在骨架期建;时代种子只往 `character_group_members` 加成员。

## 3. 翻译强制项(每一条都是上线可见性问题)

| 实体 | 必填双语字段(zh-CN + en 各一行,status='published') |
|---|---|
| character_translations | name / summary / detail / motivation(aliases 可空数组) |
| location_translations | name / summary / historical_region_name(其余文本列可空字符串) |
| event_translations | title / summary / detail / significance / **time_label** |
| chapter_translations | title / summary |
| character_group_translations | name / summary |
| source_translations | title / citation |
| **relation_translations** | **label / summary —— 见下** |

### relation_translations 教训(最高优先级)

API 只返回带已发布 label 翻译的关系(`apps/api/src/app.ts` 关系查询按 `t.label IS NOT NULL OR f.label IS NOT NULL` 过滤)。圣经扩充初期漏写,导致 **272 条关系中 170 条在界面上不可见**,事后靠 `024_relation_translation_backfill.sql` 按 relation_type 回填泛型标签、再用 `026_relation_labels_refine.sql` 把 183 条泛型标签逐条精修为具体角色对。**新作品规则:每条 relation 在同一种子文件里同时写 zh-CN + en 两行具体标签(「父子/君臣/都督与谋士」而非「亲属/同盟」),不依赖任何回填。** SQL 写法照抄 `bible-seed-spec.md` §关系一节(VALUES 表 + 按 from/to slug + relation_type 三键 JOIN)。

### 文本纪律

- 英文散文里的所有格撇号用弯引号 `’`(避免 SQL 转义);直引号必须写 `''`。
- 摘要口吻:中性叙事(圣经用「经文记载/叙事描述」;史书用「志载/传称」;演义用「小说叙写」),不做真伪裁定——真伪交给 `reality`/`confidence` 字段。

## 4. 时间与真实性标注

- 事件 `time_type='range'`,`historical_start_year/end_year` 给宽年代区间(BCE 为负、**无 0 年**,库有 CHECK);区间必须落在时代 era 区间内并随叙事大体单调。区间宽度随史料精度收窄(圣经:族长 100–200 年 → 新约 2–10 年;三国可到 1–2 年甚至精确月,`time_type='exact'` + `calendar_system='julian'`)。
- `event_translations.time_label` 必填:`约公元前 2100–1900 年`/`c. 2100–1900 BCE`;公元后 `约公元 208 年`/`c. 208 CE`。
- reality/confidence 惯例(枚举全集见 `bible-seed-spec.md` §枚举值,勿造新值):
  - 正史明载、可交叉印证:`verified_historical` + `high/medium`
  - 一般文献叙事:`reported_historical` + `low/medium`
  - 演义类作品中依托史事的铺陈:`fictional_with_historical_context`
  - 纯虚构情节/人物:`fictional_narrative`;神异/梦兆:`legendary_or_mythic` 或 `symbolic_or_dream`
  - 学界争议:`contested` + `low`
- 人物 `reality_type`:正史有传者 `historical`;演义 work 中的同名人物用 `fictionalised_historical`;纯虚构(如貂蝉)`fictional`。
- 每个新事件必须有:双语翻译、≥1 个 event_location(role 'primary', position 0)、≥1 个 event_character(第一个 role 'primary'/is_primary)、≥1 个 event_source。
- 新地点:真实经纬度 `ST_GeogFromText('POINT(经度 纬度)')` + location_type/coordinate_accuracy/preferred_zoom/modern_country_code/is_inferred/still_exists;layer 'real' 时 canvas_x/y 必为 NULL(库有 CHECK)。

## 5. 自测模板(写完必须做,直到零错误)

```bash
cd "<项目目录>/db/seeds"
sed 's/^COMMIT;$/ROLLBACK;/' 0NN_文件.sql > "$SCRATCH/test_NN.sql"   # SCRATCH=当前会话可写临时目录
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f "$SCRATCH/test_NN.sql"
```

孤儿检查(ROLLBACK 前插入,全部必须 0 行;`TX`/`KK` 换成本作品/本时代):

```sql
SELECT e.slug FROM events e WHERE e.id::text LIKE '6X000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM event_translations t WHERE t.event_id=e.id AND t.locale='en');
SELECT e.slug FROM events e WHERE e.id::text LIKE '6X000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM event_locations x WHERE x.event_id=e.id);
SELECT e.slug FROM events e WHERE e.id::text LIKE '6X000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM event_characters x WHERE x.event_id=e.id);
SELECT e.slug FROM events e WHERE e.id::text LIKE '6X000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM event_sources x WHERE x.event_id=e.id);
SELECT c.slug FROM characters c WHERE c.id::text LIKE '4X000000-0000-4000-80KK%' AND NOT EXISTS (SELECT 1 FROM character_translations t WHERE t.character_id=c.id AND t.locale='zh-CN');
-- 新增(圣经教训):关系必须带已发布双语标签
SELECT r.id FROM character_relations r WHERE r.id::text LIKE '7X000000-0000-4000-80KK%' AND (
  NOT EXISTS (SELECT 1 FROM relation_translations t WHERE t.relation_id=r.id AND t.locale='zh-CN' AND t.status='published') OR
  NOT EXISTS (SELECT 1 FROM relation_translations t WHERE t.relation_id=r.id AND t.locale='en'    AND t.status='published'));
```

预期缺失:测试时引用「编号更小时代」尚未入库的新实体,相关 JOIN 行会静默丢弃——属预期,但若某事件因此参与者为空,须补一个骨架期已有人物作 participant。

## 6. 时代与群体划分方法论

时代(chapters)与群体(character_groups)是缩放层级的两根支柱(`apps/web/src/hierarchy.ts` 的 era/group 层完全由它们驱动),划分质量直接决定图集可读性:

- **时代 = 叙事的幕**:8–15 个,按叙事重心而非机械年代切;每时代 15–40 个事件为宜(圣经现状:13 时代 / 406 事件);era 年代允许轻微重叠(圣经 gospels −6…33 与 acts 30…62 即有重叠)。每时代配一条题词、一个 accent_color(整体构成色相叙事弧,见 [EXAMPLE_THREE_KINGDOMS.md](EXAMPLE_THREE_KINGDOMS.md) 的三国色弧方案)。
- **群体 = 关系图的中间层**:15–25 个,类型用满 `family/dynasty/circle/institution/tribe`;每人至少归 1 组(group 层的节点 weight = 成员数,零成员组不显示);跨时代势力(如「汉室朝廷」)单独成组,别硬塞进某时代的家族。
- **锚点人物**:每作品 15–25 人 `importance>=4`(即 `major` 层的显示门槛,`hierarchy.ts:196` `floor = 4`),覆盖全部时代;其余人物 1–3 级。
- 三国示例(时代 13 幕 = 黄巾→董卓→群雄→官渡→赤壁→三分雏形→鼎立→北伐→兴势与废立→姜维时代→灭蜀→魏晋嬗代→晋并天下;群体 = 曹魏/蜀汉/孙吴/汉室/董卓集团/袁绍集团/荆州集团/司马氏/黄巾军/士族名士…)详见 [EXAMPLE_THREE_KINGDOMS.md](EXAMPLE_THREE_KINGDOMS.md)。

## 7. 交付标准(每个种子文件)

1. 文件落 `db/seeds/`,编号顺延、命名合规;
2. 回滚自测零错误、孤儿检查零行(预期缺失需列明);
3. 汇报:新增人物/地点/事件/关系数、测试结果、预期缺失清单;
4. 不改任何已有种子文件;不动 schema。
