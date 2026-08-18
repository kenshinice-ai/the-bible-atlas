# 《红楼梦 Atlas》数据模型与 API 候选

- 状态：`draft`
- 日期：`2026-08-15`
- 原则：优先增量扩展，不破坏现有 Atlas profile

## 1. 现有模型可复用部分

| 现有对象 | 复用方式 |
|---|---|
| `works` | 新增《红楼梦》work 与主题 token |
| `characters` | 人物身份、重要性、别名、简介 |
| `character_groups` | 多群体成员关系 |
| `chapters` | 章回或章回带；需重新定义 UI 语义 |
| `events` | 可作为较大叙事事件，但不承载全部互动 |
| `character_relations` | 作为兼容关系摘要 |
| `sources` | 底本、评论和研究来源 |
| `media_assets` | 合规人物画、版本影印、场景图 |
| static bake | 生成 profile 专属只读站点 |

## 2. 现有模型不足

1. 一条 relation 只有一个 sentiment；
2. 无多 facet；
3. lifecycle 只有 start/end event，没有多个阶段；
4. 二元 event 无法自然表达多人场景；
5. 没有 passage 与 quote range；
6. `chapter` 当前偏“时代”，需要支持真实章回序号；
7. 地点模型偏经纬度，缺叙事空间拓扑；
8. 无版本 branch。

## 3. 候选新增表

### 3.1 `text_editions`

```text
id, work_id, slug, title, corpus_layer, chapter_start, chapter_end,
source_url, rights_status, checksum, is_baseline, review_status
```

### 3.2 `text_passages`

```text
id, edition_id, chapter_number, reference, ordinal,
text_or_excerpt, normalized_text, source_locator,
segmentation_version, checksum, audit_status
```

公开 API 是否返回 `text_or_excerpt` 由权利策略决定。

### 3.3 `interaction_events`

```text
id, work_id, slug, chapter_number, passage_id,
interaction_type, title, summary, scene_location_id,
sequence_in_chapter, corpus_layer, attestation,
review_status, importance
```

### 3.4 `interaction_participants`

```text
interaction_id, character_id, participant_role,
is_present, is_target, agency_level, perspective_note
```

### 3.5 `relationship_facets`

```text
id, relation_id, facet_type, direction,
chapter_start, chapter_end, attestation,
summary, review_status
```

### 3.6 `relationship_phases`

```text
id, relation_id, corpus_layer, phase_type,
chapter_start, chapter_end,
affection_from_to, affection_to_from,
trust_from_to, trust_to_from,
power_from_to, power_to_from,
dependency_from_to, dependency_to_from,
conflict_from_to, conflict_to_from,
summary, rationale, review_status
```

约束：

- 值为 `0..5` 或 null；
- chapter start/end 合法；
- 同一 relation + corpus layer 的 phase 重叠需显式允许理由；
- published phase 至少有一条 evidence。

### 3.7 `relationship_evidence`

```text
id, relation_id, phase_id?, facet_id?, interaction_id?,
passage_id?, source_id?, quote_start?, quote_end?,
attestation, note, review_status
```

### 3.8 `scene_spaces`

可评估复用 `locations` 的 `fictional` layer，或新增：

```text
id, work_id, slug, parent_id, scene_kind,
topology_x, topology_y, evidence_note, review_status
```

坐标明确为布局坐标，不是历史经纬度。

## 4. 兼容视图

为继续复用当前 `AtlasRelation`：

- 每个 canonical relationship 同步一条 `character_relations`；
- `label` 取主关系标签；
- `strength` 取编辑重要性，不从五维自动求和；
- `sentiment` 只作为兼容显示，可统一为 `mixed/neutral`，新 profile 不以它作为主要编码；
- start/end 由首末 phase 派生；
- detail endpoint 返回完整 facets/phases/evidence。

## 5. API 候选

### 5.1 首屏索引

```http
GET /api/works/dream-of-the-red-chamber/network-index
  ?locale=zh-CN
  &corpus=core_80
```

返回人物 lite、群体、章回带、关系摘要、可用 lens、counts 和 artifact/version 信息。

### 5.2 焦点图

```http
GET /api/works/:slug/network
  ?focus=lin-daiyu
  &depth=1
  &chapterStart=1
  &chapterEnd=80
  &lens=all
```

### 5.3 比较

```http
GET /api/works/:slug/network/compare
  ?a=lin-daiyu
  &b=xue-baochai
  &chapterEnd=80
```

### 5.4 路径

```http
GET /api/works/:slug/network/path
  ?from=liu-laolao
  &to=lin-daiyu
  &mode=power
```

### 5.5 人物详情

```http
GET /api/works/:slug/characters/:characterSlug
```

返回人物、群体、关系摘要、关键互动、场景和来源。

### 5.6 关系详情

```http
GET /api/works/:slug/relationships/:relationId
  ?corpus=core_80,continuation_40
```

返回 facets、phases、双向维度、interaction events 和 evidence。

### 5.7 章回变化

```http
GET /api/works/:slug/chapters/:chapterNumber/relationship-delta
```

返回新增人物、新关系、阶段变化、结束关系、互动事件和场景变化。

## 6. 动态与静态

静态 artifact 候选：

```text
index.red-chamber.zh-CN.v1.json
characters/core.zh-CN.v1.json
relationships/partition-00.zh-CN.v1.json
chapters/001.zh-CN.v1.json
details/character/lin-daiyu.zh-CN.v1.json
details/relationship/<uuid>.zh-CN.v1.json
manifest.red-chamber.zh-CN.v1.json
```

Phase 1 前八十回数据不大时可先单文件；达到以下任一条件再分片：

- gzip 后 index > 800 KB；
- 关系详情总量 > 2 MB；
- 首屏 parse > 50ms；
- 移动端低档设备交互明显阻塞。

## 7. 索引

数据库索引候选：

```text
interaction_events(work_id, chapter_number, sequence_in_chapter)
interaction_participants(character_id, interaction_id)
relationship_phases(relation_id, corpus_layer, chapter_start, chapter_end)
relationship_facets(relation_id, facet_type)
relationship_evidence(relation_id, phase_id)
text_passages(edition_id, chapter_number, ordinal)
```

## 8. 数据验证

发布前自动检查：

- 关系两端人物属于同一 work；
- phase 章回范围合法；
- published phase 有 evidence；
- evidence passage 与章回一致；
- 五维值在范围内；
- continuation layer 不静默覆盖 core_80；
- 约 20 位核心人物与约 15 位上下文人物均有范围所需的 published 中文；
- 英文 fallback 明确；
- 动态与静态 counts parity；
- 未授权文本/图片不进入 public path。
- 每位已发布人物的 portrait/fullbody/avatar 指向同一 character identity；
- 人物图 `depiction_status=illustrative`、`interpretation_class=artistic_interpretation`；
- 图片 manifest、双语 alt、checksum 和版本指针完整；
- 不允许 actor/adaptation reference 进入发布元数据。

## 9. 待裁决

- 是否新建通用 corpus 表，供《山海经》等 profile 共用；
- `interaction_events` 是否与现有 `events` 建父子关联；
- 五维值用列、JSONB 还是子表；
- scene space 复用 `locations` 还是独立领域表；
- 路径查询由 PostgreSQL recursive CTE、应用层 graphology，还是静态预计算完成。
