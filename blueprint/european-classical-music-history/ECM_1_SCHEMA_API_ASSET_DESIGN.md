# 欧洲古典音乐史 Atlas · ECM-1 Schema / API / Asset Design

日期：2026-08-04  
状态：ECM-1 评审完成；尚未创建 migration、seed 或实现代码

## 1. 评审结论

ECM-1 采用“共享历史引擎 + 音乐专业平行表”的方式：

- 继续复用 `works`、`characters`、`locations`、`events`、`routes`、`character_relations`、`chapters`、`character_groups`、`sources` 和双语翻译；
- 以 `characters` 作为具名人物唯一 canonical 身份；
- 不把音乐内容塞入美术史 `artists / artworks / movements / art_institutions`；
- 乐谱片段和自产音频不使用通用图片 `media_assets` 作为主要语义实体；
- 图片仍可使用 `media_assets`，通过新增 `linked_entity_kind` 连接 composition、instrument 和 music institution；
- 运行时 API 和静态 JSON 使用同一 Atlas contract；
- profile 页面入口由 capability 配置驱动，移除音乐实现所需的新增 profile 特判。

## 2. 现有代码审计

当前可复用的稳定能力：

- `/Users/llmacbookpro/Library/Mobile Documents/com~apple~CloudDocs/The Bible Atlas/apps/web/src/profile.ts` 已有独立 profile、work lock、默认语言和品牌配置；
- `/Users/llmacbookpro/Library/Mobile Documents/com~apple~CloudDocs/The Bible Atlas/apps/web/src/components/TimelineRibbon.tsx` 已支持历史时间、叙事时间和深链接；
- `/Users/llmacbookpro/Library/Mobile Documents/com~apple~CloudDocs/The Bible Atlas/apps/web/src/components/RelationGraph.tsx` 已支持人物节点、边类型、层级和可访问关系表；
- `/Users/llmacbookpro/Library/Mobile Documents/com~apple~CloudDocs/The Bible Atlas/apps/web/src/components/EntityDrawer.tsx` 已有共享实体选择和来源抽屉；
- `/Users/llmacbookpro/Library/Mobile Documents/com~apple~CloudDocs/The Bible Atlas/apps/api/src/bake-static.ts` 已有双语静态烘焙；
- `/Users/llmacbookpro/Library/Mobile Documents/com~apple~CloudDocs/The Bible Atlas/db/migrations/011_artwork_media_rights.sql` 已建立来源、许可、checksum 和外链不渲染的媒体审计思路。

当前必须在音乐实现前泛化的耦合点：

- `apps/web/src/state.ts` 中艺术史的 tab 与 zoom 特判；
- `apps/web/src/App.tsx` 中 `PROFILE.id === "european-art-history"` 分支；
- `apps/web/src/components/GlobalSearch.tsx` 中艺术家搜索过滤；
- `apps/web/src/types.ts` 中 `EntityTypeSchema`、`WorkCategorySchema`、Atlas response；
- `apps/api/src/app.ts` 中艺术史查询、搜索 union 和实体 detail 查询；
- `deploy/deploy-static.sh` 中 profile、work、probe 和 Cloudflare project 分支。

## 3. Migration 分层

下一阶段使用两个新 migration，避免核心音乐实体和乐谱资产在同一变更中难以回滚：

| Migration | 内容 |
|---|---|
| `013_european_classical_music.sql` | `music_history` category、音乐人物、曲目、风格、乐器、机构、连接表、relation context、音乐事件值 |
| `014_music_score_assets.sql` | score fragments、annotations、生成 manifest、乐谱/声音路径与校验约束 |

seed 编号不能因为 migration 使用 `013` 而复用同一编号；migration 与 seed 目录分别登记。音乐 seed 从 `057` 开始，避免改动已装载的 `001–056`。

## 4. 共享 schema 扩展

### 4.1 枚举值

`work_category` 增加：

```text
music_history
```

`literary_event_type` 保持历史类型名不动，增加音乐史事件值：

```text
composition
commission
premiere
performance
publication
revision
appointment
institution_founding
instrument_innovation
musical_debate
festival
recording
revival
```

`character_group_type` 增加：

```text
school
court
conservatory
ensemble
national_tradition
city_network
```

`source_type` 增加：

```text
score
instrument_catalog
```

`linked_entity_kind` 增加：

```text
composition
music_style
instrument
music_institution
score_fragment
```

`score_fragment` 允许被媒体链接识别，但其主要 SVG、timing 和 audio 资产仍由 `score_fragments` 管理。

### 4.2 work 与 composite work-scope 约束

为新音乐表建立同 work 约束，不允许把一个 profile 的人物、曲目、机构或事件跨 work 连接：

- 为需要 composite foreign key 的现有共享表补 `(id, work_id)` unique constraint；
- 新表所有 join table 使用 `(entity_id, work_id)` 或显式 `work_id` foreign key；
- 每个新表至少有 `work_id`；
- slug 约束统一为 `^[a-z0-9-]+$`；
- 所有 seed UUID 使用新的音乐前缀，并在当期规范中冻结。

不修改已发布美术史表的既有字段语义；只添加新 enum 值与音乐专用表。

## 5. 音乐专业表

### 5.1 `music_person_profiles`

这是 canonical `characters` 的音乐专业侧资料，不是第二个人物节点。

```text
character_id uuid primary key
work_id uuid not null
primary_role text not null
chapter_id uuid
sort_order integer not null default 0
```

`primary_role` 的允许值：

```text
composer
performer
conductor
theorist
librettist
patron
publisher
instrument_maker
educator
critic
```

角色多值通过 `music_person_roles(character_id, work_id, role)` 保存。每个音乐人物必须已经存在于 `characters`，并且 `characters.work_id` 与 `music_person_profiles.work_id` 相同。

### 5.2 `compositions`

```text
id uuid primary key
work_id uuid not null
slug text not null
primary_composer_character_id uuid
chapter_id uuid
composition_start_year integer
composition_end_year integer
composition_time_type event_time_type not null default 'unknown'
confidence confidence_level not null default 'medium'
catalogue_number text not null default ''
genre text not null default ''
form text not null default ''
key_signature text not null default ''
approx_duration_seconds integer
text_language text not null default ''
work_status text not null default 'confirmed'
sort_order integer not null default 0
```

`work_status` 使用 check：

```text
confirmed
sketch
fragment
lost
arrangement
contested
unknown
```

允许 `primary_composer_character_id` 为空，以承载匿名、集体或归属有争议的作品；但此类作品必须有 confidence 和来源说明。

`composition_translations`：

```text
composition_id
locale
title
alternate_titles[]
summary
description
status
```

`summary` 用于列表和搜索；`description` 用于详情抽屉，遵守原创、短篇和不复制来源长文的纪律。

### 5.3 贡献者与作品关联

`composition_contributors`：

```text
composition_id
character_id
role
sort_order
```

角色包括：

```text
composer
co_composer
librettist
arranger
orchestrator
editor
translator
dedicatee
premiere_performer
premiere_conductor
```

作品与人物、事件、来源的连接：

```text
composition_sources
composition_event_links
music_person_event_links
```

`composition_event_links.role`：

```text
commissioned
sketched
composed
completed
premiered
published
revised
arranged
performed
revived
recorded
```

### 5.4 `music_styles`

```text
id uuid primary key
work_id uuid not null
slug text not null
style_kind text not null
chapter_id uuid
start_year integer
end_year integer
sort_order integer not null default 0
```

`style_kind`：

```text
historical_style
school
national_tradition
genre
form
technique
```

双语表为 `music_style_translations`。关联表：

```text
music_person_styles
composition_styles
music_style_sources
```

### 5.5 `instruments`

```text
id uuid primary key
work_id uuid not null
slug text not null
family text not null
hornbostel_sachs_code text not null default ''
mimo_term text not null default ''
parent_instrument_id uuid
start_year integer
end_year integer
transposition text not null default ''
range_low text not null default ''
range_high text not null default ''
construction_summary text not null default ''
sort_order integer not null default 0
```

`family` 使用 Blueprint 冻结的八个用户层值。历史别名、音域、移调和发声摘要进入 `instrument_translations` 或结构化字段，不把专业编号当成显示名称。

乐器变体既可使用 `parent_instrument_id`，也可通过：

```text
instrument_variant_relations
```

表达 `developed_from / regional_variant_of / coexisted_with / revived_as / construction_influence`。

连接表：

```text
music_person_instruments
composition_instruments
instrument_sources
```

### 5.6 `music_institutions`

不再复用 `art_institutions`。统一机构表：

```text
id uuid primary key
work_id uuid not null
slug text not null
location_id uuid not null
institution_type text not null
founded_year integer
closed_year integer
sort_order integer not null default 0
```

`institution_type`：

```text
court
church
opera_house
concert_hall
conservatory
ensemble
publisher
workshop
festival
archive
```

双语表为 `music_institution_translations`。连接表：

```text
music_person_institutions
composition_institutions
music_institution_sources
```

## 6. 人物关系上下文

共享 `character_relations` 继续作为唯一人物边表，不另建 `music_person_relations`。

新增 `relation_contexts`：

```text
id uuid primary key
work_id uuid not null
relation_id uuid not null
composition_id uuid
event_id uuid
institution_id uuid
context_role text not null
source_id uuid
```

约束：

- `relation_id` 必须属于同一 work；
- composition、event、institution 至少有一个非空；
- context 至少有一个 source；
- 同一关系可有多个上下文；
- 不把同一人物关系按时期重复插入；跨期生命周期由事件和 context 承载。

## 7. Score asset schema

### 7.1 独立于 `media_assets`

决定：**score/audio 不作为普通媒体 gallery 的主模型**。

原因：

- 乐谱片段有小节、拍位、MEI `xml:id` 和教学分析；
- 音频有合成生成器、时长、采样率和 timing map；
- 图片媒体的 `alt_text`、许可和外链行为不能表达乐谱资产的全部语义；
- 仍可使用 `media_assets` 为作品、乐器或机构提供权利审计图片。

### 7.2 `score_fragments`

```text
id uuid primary key
work_id uuid not null
composition_id uuid not null
slug text not null
start_measure integer not null
end_measure integer not null
notation_kind text not null
mei_asset_path text not null
svg_asset_path text not null
timing_asset_path text not null
audio_asset_path text not null
duration_seconds numeric(6,2) not null
tempo_bpm numeric(6,2)
tempo_basis text not null
rights_status text not null
source_id uuid not null
sort_order integer not null default 0
```

检查：

- `start_measure >= 1`；
- `end_measure >= start_measure`；
- production 片段长度 2–8 小节；
- `duration_seconds` 在 8–30 秒；
- 所有资产路径为 `/media/music/...`；
- `rights_status = 'verified'` 才能被生产 API 返回为可播放；
- 片段必须属于同 work 的 composition 和 source。

`notation_kind`：

```text
common
mensural
neume
mixed
```

`tempo_basis`：

```text
source_marking
editorial_learning
unknown
```

### 7.3 翻译与标注

`score_fragment_translations`：

```text
fragment_id
locale
title
summary
analysis_note
playback_disclaimer
status
```

`score_annotations`：

```text
id uuid primary key
fragment_id uuid not null
target_xml_id text
start_beat numeric
end_beat numeric
annotation_type text not null
sort_order integer not null default 0
```

`score_annotation_translations` 保存双语 label 与 explanation。

### 7.4 `score_generation_manifests`

```text
fragment_id uuid primary key
mei_checksum_sha256 text not null
svg_checksum_sha256 text not null
timing_checksum_sha256 text not null
audio_checksum_sha256 text not null
generator_version text not null
synthesis_profile text not null
sample_rate integer not null default 22050
channels smallint not null default 1
bit_depth smallint not null default 16
output_format text not null default 'wav'
generated_at timestamptz not null
manifest_path text not null
```

Foundation 音频交付格式冻结为：

- PCM WAV；
- 22050 Hz；
- 16-bit；
- mono；
- 无第三方采样；
- transient MIDI/PCM 中间文件不进入仓库；
- 最大 28 段合计约 40 MiB 预算；
- 页面使用原生 `<audio>`，按需加载，不自动播放。

单声道和中性音色是有意选择：它优先保证可复现、可审计和体积可控，不模拟真实历史演奏。

标准静态路径：

```text
apps/web/public/media/music/scores/{slug}.mei
apps/web/public/media/music/scores/{slug}.svg
apps/web/public/media/music/timing/{slug}.json
apps/web/public/media/music/audio/{slug}.wav
apps/web/public/media/music/manifests/{slug}.json
```

## 8. API contract

### 8.1 `/api/works`

保留现有字段，新增可选计数：

```text
compositionCount
musicStyleCount
instrumentCount
musicInstitutionCount
scoreFragmentCount
```

### 8.2 `/api/works/:slug/atlas?detail=full`

新增数组：

```text
musicPeople
compositions
musicStyles
instruments
musicInstitutions
scoreFragments
```

`characters` 仍然是唯一人物列表；`musicPeople` 只返回专业扩展和与 canonical character 的 slug 连接，不重复姓名、摘要和第二套人物翻译。

`scoreFragments` 返回：

```text
id
slug
compositionSlug
chapterSlug
startMeasure
endMeasure
notationKind
svgAssetPath
timingAssetPath
audioAssetPath
durationSeconds
tempoBpm
tempoBasis
title
summary
analysisNote
playbackDisclaimer
rightsStatus
sourceTitles
```

如果 `rightsStatus !== 'verified'`，API 可以返回 metadata，但必须将 `audioAssetPath` 和播放能力置空。

### 8.3 Entity detail

`/api/works/:slug/entities/:kind/:entitySlug` 增加：

```text
composition
music_style
instrument
music_institution
score_fragment
```

score fragment detail 返回标注与 manifest 摘要；不把原始 MEI XML 嵌入 JSON。

### 8.4 Search

新增搜索类型：

```text
composition
music_style
instrument
music_institution
score_fragment
```

音乐人物不新增 `music_person` 搜索类型，继续返回 canonical `character`，避免同一个人出现两条搜索结果。

### 8.5 API 分层

现有 `apps/api/src/app.ts` 已变得过于集中。音乐接入前，查询应拆成：

```text
shared atlas loaders
art-history loaders
music-history loaders
entity detail loaders
search unions
```

按 `work.category` 只加载对应专业层，避免 Bible、三国和 Galaxy 构建每次查询空的艺术/音乐表。

## 9. Profile capability contract

`WorkProfile` 增加不依赖 `state.ts` 的配置：

```text
navigation.tabs
navigation.defaultTab
navigation.graphLevels
navigation.defaultGraphLevel
specialization
features.scoreFragments
features.audioExcerpts
features.compositionConstellation
search.hiddenKinds
```

音乐 profile：

```text
tabs:
  characters
  compositions
  instruments
  events
  relations

defaultTab: events
graphLevels:
  era
  group
  major
  all
defaultGraphLevel: group
specialization: music
scoreFragments: true
audioExcerpts: true
compositionConstellation: true
hiddenKinds:
  work when single-work
```

现有 profile 通过相同 contract 表达：

- Bible、Galaxy：基础人物/事件/地点/路线/关系；
- Three Kingdoms：双 work compare；
- European Art：人物/作品/流派/事件/地点/路线/关系，但 `artist` 搜索归一为 canonical character；
- Music：人物/曲目/乐器/事件/关系，专业机构和风格由搜索、筛选、详情进入。

`state.ts`、`App.tsx`、`GlobalSearch.tsx` 和 `EntityDrawer.tsx` 不再以音乐或艺术 profile id 直接判断入口。

## 10. Zod 与 enum 同步清单

必须同一实现变更同步更新：

```text
WorkCategorySchema
EntityTypeSchema
SearchResponseSchema
AtlasResponseSchema
EntityDetailSchema
Tab union
ENUMS bilingual labels
profile.test.ts DISPLAYED_ENUM_VALUES
```

新增显示值至少包含：

```text
music_history
composition
commission
premiere
performance
publication
revision
appointment
institution_founding
instrument_innovation
musical_debate
festival
recording
revival
school
court
conservatory
ensemble
national_tradition
city_network
score
instrument_catalog
common
mensural
neume
mixed
source_marking
editorial_learning
verified
pending
rejected
unknown
composer
performer
conductor
theorist
librettist
patron
publisher
instrument_maker
educator
critic
```

## 11. 回归与 Go/No-Go

ECM-1 评审通过条件：

- 新表均有明确 `work_id` 和跨 work 防护；
- 不修改现有艺术史专业表语义；
- score/audio 独立于图片 gallery，但可以复用来源与媒体审计思想；
- API 增量字段有明确 Zod contract；
- Music profile 不新增 `PROFILE.id` 特判；
- 现有四个 profile 的查询、搜索和静态烘焙路径有回归方案；
- Foundation seed 编号从 `057` 开始；
- 资产路径、WAV 参数、manifest 字段和验证器要求已冻结。

通过后只能先进入 Gate 2 策展清单。人物、曲目、风格、乐器、机构、关系和 28 个片段清单冻结后，才进入 Gate 3：

1. `013_european_classical_music.sql`；
2. `014_music_score_assets.sql`；
3. skeleton seed；
4. 不得跳过清单直接批量写 migration-dependent seed。
