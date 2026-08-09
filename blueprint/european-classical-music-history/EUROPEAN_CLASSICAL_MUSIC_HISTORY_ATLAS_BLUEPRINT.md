# 欧洲古典音乐史 Atlas Blueprint

日期：2026-08-04  
状态：ECM-0 Blueprint 与 ECM-1 设计评审完成；等待 Gate 2 Foundation 策展清单  
目标 profile：`european-classical-music-history`

## 1. 产品定位

「欧洲古典音乐史 Atlas」是一套以时间、人物网络、城市机构、乐器和音乐文本为核心的双语知识图谱。它不是唱片库、完整总谱库或作曲家百科，而是让用户沿着以下问题探索：

1. 作曲家、演奏家、指挥家、理论家、赞助人与机构如何连接；
2. 一部作品何时创作、首演、出版、修订和传播；
3. 乐器、编制、体裁与风格如何随时期和地区变化；
4. 代表性节奏、织体和主题如何在短乐谱片段中体现；
5. 地图、时间轴、人物关系图和乐谱分析如何共享同一选中实体。

第一版只制作有代表性的短乐谱与自产合成声音片段。**不收录完整乐章、完整总谱或完整录音**；完整版本留待未来重新评审。

## 2. 独立站边界

| 项目 | 冻结决定 |
|---|---|
| profile id | `european-classical-music-history` |
| work slug | `european-classical-music-history` |
| work category | 新增 `music_history` |
| 中文站名 | 欧洲古典音乐史 Atlas |
| 英文站名 | European Classical Music History Atlas |
| 默认语言 | `zh-CN`，保留 `en` |
| 地图层 | `real` |
| 模式 | `single` |
| 静态发布 | 独立构建；项目名暂定 `european-classical-music-history-atlas` |
| 与现有站点关系 | 复用引擎，不复用品牌、默认内容、seed 或静态数据 |

保护边界：

- 不修改圣经、三国、银河原力、欧洲美术史四个现有 profile 的内容 seed；
- 不重烘焙、不重排、不重新策展四个现有站点；
- 不直接使用美术史 `artists / artworks` 表承载音乐内容；
- 不通过连续增加 `PROFILE.id === ...` 特判实现音乐入口，应改为 profile capability 驱动；
- Blueprint、schema 评审和策展配额必须先于批量内容生成。

## 3. Foundation 时期

第一版使用 7 个非重叠主展示章节。边界是策展和列表归属规则，不宣称风格在某一年整齐开始或结束；跨期现象由 style 多对多关系表达。

| # | slug | 中文 | English | 主展示范围 |
|---:|---|---|---|---:|
| 1 | `medieval-music` | 中世纪音乐 | Medieval Music | 500–1399 |
| 2 | `renaissance-music` | 文艺复兴音乐 | Renaissance Music | 1400–1599 |
| 3 | `baroque-music` | 巴洛克音乐 | Baroque Music | 1600–1749 |
| 4 | `classical-period` | 古典主义时期 | Classical Period | 1750–1819 |
| 5 | `romantic-period` | 浪漫主义时期 | Romantic Period | 1820–1899 |
| 6 | `modernism-and-war` | 现代主义与战争 | Modernism and War | 1900–1944 |
| 7 | `postwar-and-contemporary` | 战后与当代 | Postwar and Contemporary | 1945–2026 |

纪律：

- 人物只有一个主 chapter，但可以关联多个角色、风格、机构和地区；
- 作品按主要创作完成年代归入一个主 chapter；
- 首演、出版、修订、复兴演出和传播通过事件表达，不复制作品；
- 风格和体裁允许跨 chapter，必须保留起止范围和来源；
- 1945 年后的版权期作品可进入元数据与事件时间线，但没有明确许可时不得制作乐谱或声音片段。

## 4. Foundation 冻结规模

| 实体 | 配额 |
|---|---:|
| chapters | 7 |
| canonical 人物 | 48 |
| compositions | 72 |
| styles / schools / principal forms | 20 |
| instruments | 24 |
| institutions / ensembles | 16 |
| locations | 24 |
| events | 96 |
| canonical person relations | 80 |
| routes | 8 |
| score fragments | 28 |
| 自产合成声音片段 | 28，与 score fragment 一一对应 |

人物配额不是“48 位作曲家”：

- 作曲家进入 production 前至少关联一部 composition；
- 演奏家、指挥家、理论家、词作者、赞助人、出版者和乐器制作者只有在主干叙事中不可替代时才进入；
- 非作曲家至少关联一部作品、一个事件、一个机构或一条有来源的关系；
- 乐团、教堂、宫廷、歌剧院、音乐学院和出版社不伪装成 canonical 人物；
- 禁止新增只有姓名、没有上下文作用的占位人物。

## 5. 信息架构与布局

### 5.1 五个主要入口

1. 人物；
2. 曲目；
3. 乐器；
4. 事件；
5. 关系。

时期、风格、体裁、地点、机构、乐团和路线通过筛选、全局搜索、地图和详情抽屉进入，不占用移动端主导航。

### 5.2 四视图联动

共享 `ExploreState` 继续控制语言、时期、时间范围、查询、选中实体和深链接：

1. 地图；
2. 时间轴；
3. 人物关系图；
4. 乐谱片段分析。

四个视图必须从同一个 typed selection 派生，不建立互相冲突的组件局部选择状态。

### 5.3 桌面布局

```text
┌──────────────────────────────────────────────────────────┐
│ 品牌 / 搜索 / 语言 / 时期筛选                            │
├──────────────────────────────────────────────────────────┤
│ 7 个时期色带                                             │
├──────────────┬───────────────────────────┬───────────────┤
│ 实体列表      │ 地图 / 关系网 / 乐谱分析台 │ 详情抽屉      │
│ 角色与风格筛选│                           │ 来源与交叉链接 │
├──────────────┴───────────────────────────┴───────────────┤
│ 时间轴 + 代表性节奏/织体特征带                           │
└──────────────────────────────────────────────────────────┘
```

移动端：

- 主导航不超过五项；
- 乐谱按小节分页或受控横向滚动，禁止页面级横向溢出；
- 关系图默认只看直接关系，并提供可排序关系表；
- 详情抽屉改为底部全屏面板；
- 不依赖 hover 显示分析、播放或来源；
- 播放、关闭和乐谱标注目标满足 44px 触控要求。

## 6. 人物与关系网络

### 6.1 Canonical 身份

每个具名历史人物只建立一个 `characters` 节点。音乐专业字段通过 `music_person_profiles.character_id` 映射，不创建互不连通的“人物”和“音乐家”双节点。

一个人可以拥有多个角色：

```text
composer, performer, conductor, theorist, librettist,
patron, publisher, instrument_maker, educator, critic
```

`primary_role` 只用于默认排序与图标；完整角色保存在 `music_person_roles`。

### 6.2 全局人物关系图

Foundation 关系类型：

```text
mentorship
influence
collaboration
patronage
employment
premiere_participation
performer_interpreter
family
institutional_peer
aesthetic_opposition
reception_advocacy
```

每条关系必须有方向、强度、状态、起止事件、双语 published label/summary、来源，以及可选的作品/事件/机构上下文。禁止只写无说明的泛型 “influenced”。

新增 `relation_contexts`：

```text
relation_id
composition_id nullable
event_id nullable
institution_id nullable
context_role
source_id
```

### 6.3 曲目作品星图

全局图只显示人物。选择 composition 后，局部作品星图可以连接：

- 作曲家；
- 词作者或剧作家；
- 题献对象；
- 首演演奏者与指挥；
- 首演机构；
- 出版者；
- 风格与体裁；
- 主要乐器。

全局图回答“人物如何连接”，作品星图回答“这部作品由谁、在哪里、通过什么力量形成和传播”。

### 6.4 图层级

音乐史必须提供真实 group 数据，以复用 `era → group → major → all`：

```text
school, court, circle, conservatory, ensemble,
national_tradition, city_network
```

不得新增“音乐史无 group，所以强制 all”的 profile 特判。

## 7. 曲目与专业实体

`compositions` 是持续存在的作品实体，创作、首演、出版、修订、改编和复兴是事件。

核心字段：

```text
id, work_id, slug
primary_composer_profile_id
chapter_id
composition_start_year, composition_end_year
composition_time_type, confidence
catalogue_number
genre, form
key_signature
approx_duration_seconds
text_language
work_status
sort_order
```

`composition_translations`：

```text
title
alternate_titles[]
summary
description
status
```

`composition_contributors` 支持：

```text
composer, co_composer, librettist, arranger,
orchestrator, editor, translator, dedicatee
```

现代编辑者只有在版本来源或权利说明需要时才记录，不能被写成原作共同创作者。

`music_styles.style_kind`：

```text
historical_style, school, national_tradition,
genre, form, technique
```

主 chapter 负责主要时间归属，style 负责跨期解释。

## 8. 乐器体系

### 8.1 双层分类

用户层：

```text
strings
woodwinds
brass
percussion
keyboards
plucked_and_early
voice
mechanical_and_electronic
```

研究字段：

- Hornbostel–Sachs code；
- MIMO preferred term；
- 历史别名与多语言名称；
- 发声方式；
- 音域与移调；
- 主要使用时期；
- 乐团或室内乐角色；
- 制作中心与重要制作者；
- 代表人物、作品和机构。

参考：

- MIMO Vocabulary：`https://vocabulary.mimo-international.com/`
- MIMO / Hornbostel–Sachs：`https://mimo-international.com/MIMO/doc/IFCM/`

### 8.2 演变纪律

`instrument_variants` 记录历史形态，`instrument_variant_relations` 表达：

```text
developed_from
regional_variant_of
coexisted_with
revived_as
construction_influence
```

乐器历史必须支持分支、共存、地区差异和复兴，禁止写成单一直线替代史。

Foundation 乐器页不提供“仿真音色试听”。音乐片段统一使用中性自产合成音，避免把简化合成误称为历史真实音色。

## 9. 乐谱片段方案

### 9.1 固定范围

Foundation 恰好制作 28 个代表性片段：

- 每段 2–8 小节；
- 每段声音 8–30 秒；
- 每段只表达一个主要教学目的；
- 同一作品首轮最多 2 个片段；
- 不制作完整乐章、完整作品或可替代正式乐谱的连续片段；
- 1945 年后作品默认不制作片段，除非权利明确通过。

教学目的可以是节奏型、主题动机、低音型、模仿进入、织体变化、特殊节拍、配器/音区关系或终止。时期特征必须写成“代表性示例”，不能把一个时期概括成唯一固定节奏。

### 9.2 编码与渲染

冻结路线：

1. MEI 为 canonical 内部格式；
2. MusicXML 作为导入/交换格式；
3. Verovio 在构建阶段生成 SVG；
4. 乐谱保留稳定 `xml:id`，供分析标注定位；
5. 静态站优先加载预生成 SVG；
6. 产物记录生成器版本和 checksum。

参考：

- MusicXML 4.0：`https://www.w3.org/2021/06/musicxml40/`
- MEI Guidelines：`https://music-encoding.org/guidelines/`
- Verovio：`https://www.verovio.org/`

### 9.3 数据结构

`score_fragments`：

```text
id, work_id, composition_id, slug
start_measure, end_measure
notation_kind
mei_asset_path
svg_asset_path
midi_asset_path nullable
audio_asset_path
duration_seconds
tempo_bpm
tempo_basis
rights_status
source_id
mei_checksum_sha256
svg_checksum_sha256
audio_checksum_sha256
generator_version
synthesis_profile
sort_order
```

另设：

```text
score_fragment_translations
score_annotations
score_annotation_translations
score_generation_manifests
```

标注通过稳定 MEI `xml:id` 或明确小节/拍位连接，不以屏幕像素坐标作为 canonical 定位。

### 9.4 乐谱 UI

作品详情顺序：

1. 片段标题与教学目的；
2. SVG 乐谱；
3. 播放/暂停、回到开头和速度控制；
4. “原谱 / 分析标注”切换；
5. 双语说明；
6. 来源、权利、编码与合成声明。

要求：

- 不自动播放；
- 不以颜色单独表达声部；
- 当前播放位置同时使用游标、描边或文本状态；
- 支持键盘控制；
- `prefers-reduced-motion` 时取消连续滚动跟随；
- 手机端按小节分页并保持音符可读。

## 10. 自产合成声音方案

### 10.1 Foundation 边界

自产声音只帮助用户听见屏幕上同一段乐谱的节奏、旋律、对位或和声关系，不承担历史演奏复原。

冻结规则：

- 声音与 score fragment 一一对应；
- 使用中性程序化合成音，不使用商业录音；
- Foundation 不引入来源不明的 SoundFont、采样包或真实乐器录音；
- 不模仿具体演奏家、乐团或受保护录音；
- 不把默认速度描述为“历史正确速度”；
- 固定显示：“学习用自产合成音，不代表历史演奏、真实乐器音色或权威速度。”

### 10.2 确定性生成

```text
MEI canonical source
  → MIDI 或标准化 note events
  → 确定性程序化合成器
  → PCM master
  → Web 交付格式
  → checksum 与 generation manifest
```

Foundation 音色：

- 基础振荡器与有限谐波叠加；
- 固定 ADSR；
- 固定 velocity 映射；
- Foundation 使用单声道输出；声部只用中性谐波与音量包络区分，不模拟真实乐器或声像；
- 同一输入、生成器版本和 profile 必须得到可复现输出。

Manifest 至少记录：

```text
fragment_slug
mei_checksum
generator_commit_or_version
synthesis_profile
tempo_bpm
tempo_basis
sample_rate
output_format
duration_seconds
audio_checksum
generated_at
```

速度纪律：

- 原始来源明确给出速度时使用 `tempo_basis=source_marking`；
- 为教学选择速度时使用 `tempo_basis=editorial_learning`；
- 转调或删减声部必须公开；
- 乐谱与声音必须来自同一 canonical note data，禁止维护两份会漂移的内容。

### 10.3 未来完整版本

Foundation 不包括：

- 完整乐章、完整总谱；
- 商业录音或历史录音库；
- 写实乐器采样；
- 多指挥/多演奏版本比较；
- 自动和声分析；
- 自动生成乐谱摘要。

未来进入完整版本前必须另开范围、权利、存储、性能和产品评审，不能从“片段允许”推导为“完整版本默认允许”。

## 11. 权利、来源与真实性

乐谱和声音分别审核：

1. 底层音乐作品；
2. 所依据的版本；
3. 本项目制作的 MEI 转录；
4. SVG 排版；
5. MIDI / note events；
6. 自产合成声音；
7. 字体、音色、样本和生成工具。

Foundation 默认策略：

- 片段优先选择权利明确、适合自行转录的历史作品；
- 不复制现代商业版本的版面、指法、编辑记号、校勘说明或专有排版；
- MEI 由项目自行编码或从明确许可数据转换；
- 合成声音只使用项目自产程序化音色；
- 每段必须有来源、权利状态、转录说明、manifest 和 checksum；
- 没有明确许可的作品只保留元数据、事件和外部来源，不渲染乐谱、不播放声音；
- 摘要与分析不得复制现代教材、节目册或数据库长文；
- 归属、年代和版本差异必须显式记录 confidence。

## 12. 建议数据模型

共享复用：

```text
works, characters, locations, events, routes,
character_relations, chapters, character_groups,
sources, translations, seed_history
```

音乐专业新表：

```text
music_person_profiles
music_person_roles

compositions
composition_translations
composition_contributors

music_styles
music_style_translations
music_person_styles
composition_styles

instruments
instrument_translations
instrument_variants
instrument_variant_translations
instrument_variant_relations
music_person_instruments
composition_instruments

music_institutions
music_institution_translations
music_person_institutions
composition_institutions

music_person_event_links
composition_event_links
relation_contexts

score_fragments
score_fragment_translations
score_annotations
score_annotation_translations
score_generation_manifests
```

不在未完成回归评审时重命名或破坏已经发布的美术史 schema。

## 13. API 与前端

Atlas full 响应增加：

```text
musicPeople
compositions
musicStyles
instruments
musicInstitutions
scoreFragments
```

搜索类型增加：

```text
composition
music_style
instrument
music_institution
score_fragment
```

实体详情继续遵守请求语言 → profile 默认语言的 published fallback。

当前硬编码 tab、entity type 和 category 的位置必须同一变更同步扩展：

- `apps/web/src/types.ts`
- `apps/web/src/state.ts`
- `apps/web/src/App.tsx`
- `apps/web/src/components/EntityList.tsx`
- `apps/web/src/components/EntityDrawer.tsx`
- `apps/web/src/components/GlobalSearch.tsx`
- `apps/web/src/i18n.ts`

建议新增：

- `ScoreFragmentViewer.tsx`
- `CompositionConstellation.tsx`
- `InstrumentBrowser.tsx`
- `MusicFeatureRibbon.tsx`
- `AudioExcerptPlayer.tsx`

组件保持单一职责，不继续把所有专业逻辑堆入 `EntityDrawer.tsx`。

## 14. 视觉与可访问性

视觉方向：

- 延续暗色“夜间图集”环境；
- 乐谱使用象牙白或浅暖灰纸面；
- 深墨色音符；
- 黄铜金为选中与播放强调；
- 暗酒红为次级重点；
- chapter 使用独立时代色；
- 不把散乱音符、琴键或五线谱作为大面积装饰背景。

门禁：

- 普通文本对比度至少 4.5:1；
- 播放控件与图标有可访问名称；
- 关系图和作品星图必须有表格或列表替代；
- 乐谱 SVG 有标题、片段说明和文本分析；
- 不以颜色单独区分声部；
- 验收 375、390、768、1024、1440px；
- 无页面级横向滚动；
- 尊重 `prefers-reduced-motion`；
- 不自动播放，切换实体时停止旧片段。

## 15. Foundation 验收

数据：

- 48/48 人物有双语 published 翻译和来源；
- 每位作曲家至少一部曲目，其他人物至少一个上下文连接；
- 72/72 曲目有双语 summary/description、来源和事件链；
- 24/24 乐器有双层分类、双语名称和来源；
- 80/80 关系有具体双语 label/summary、方向和来源；
- 28/28 片段有 composition、来源、MEI、SVG、声音和 manifest；
- 28 个声音均为 8–30 秒，且与显示乐谱来自同一 note data；
- 权利 pending/rejected 片段不进入 production；
- 事件、地点、来源、翻译和关系孤儿为 0；
- fresh bootstrap 与 repeat bootstrap 通过。

工程：

- `npm run typecheck`
- `npm test`
- `npm run build`
- `npm run verify:postgis`
- 新增音乐数据与乐谱/声音验证器
- 静态烘焙只包含音乐史 work
- 产物无 localhost API
- 现有四 profile 回归通过

浏览器：

- 中英文切换；
- 五个主要入口；
- 地图、时间轴、人物关系图、作品星图和乐谱联动；
- 乐谱键盘操作与移动端分页；
- 28 个片段播放、暂停、结束和实体切换；
- 390px 无横向溢出；
- 关系图有可访问表格；
- console 无 error/warn；
- 深链接恢复时期、时间范围、实体和片段。

## 16. 实施顺序

| Sprint | 目标 | 产物 |
|---|---|---|
| ECM-0 | Blueprint、范围、声音与权利策略 | 本文件 + 清单 + HANDOFF |
| ECM-1 | schema 与 profile capability 评审 | migration 草案 + API contract |
| ECM-2 | 章节、来源、地点、机构与首批人物骨架 | skeleton seed |
| ECM-3 | 48 人物、72 曲目、20 风格、24 乐器 | 双语 Foundation seed |
| ECM-4 | 80 关系、96 事件、8 路线 | 关系/事件闭环 |
| ECM-5 | MEI→SVG→自产声音管线 | 28 片段 + manifest + verifier |
| ECM-6 | 音乐专业 UI 与四视图联动 | React 组件、深链接、响应式 |
| ECM-7 | 全量门禁、静态构建与独立发布 | 审计、production、HANDOFF |

## 17. 当前明确不执行

- 不在 schema 评审前创建 migration；
- 不在人物/曲目/乐器清单冻结前批量生成 seed；
- 不下载完整总谱；
- 不复制现代商业乐谱版面；
- 不下载或剪辑商业录音；
- 不引入来源不明的 SoundFont 或采样包；
- 不做完整乐章或完整作品播放；
- 不做自动音乐分析；
- 不修改或重烘焙四个现有 profile；
- 不把 Blueprint 阶段写成“功能已实现”。
