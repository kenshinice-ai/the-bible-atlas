# Bible Atlas 艺术与音乐升级规划（A/B/C/D）· 2026-08-18

- 文档状态：`batch_one_implemented`（用户 2026-08-18 批准 A/B/C/D 四条轨全做；本轮批次已实现并验证）
- 证据层级：`local_candidate` —— 未部署。实现进度与证据边界以 [HANDOFF.md](HANDOFF.md) 与 [HANDOFF_DECISIONS_2026-08-18.md](HANDOFF_DECISIONS_2026-08-18.md) 为准
- 已落地：43 人物徽章 + 13 时代徽章、25 张多雷版画（希伯来圣经批次）、59 条经文引用、41 条逐字核验引文、13 条音乐接受链接、1 张确定性总览母图
- 未落地：新约多雷批次（14 张，已定稿并通过权利探测，因 Wikimedia 限流仅抓完 6 张，seed 未生成）
- 前置：[BIBLE_VISUAL_PILOT_2026-08-09.md](BIBLE_VISUAL_PILOT_2026-08-09.md)（媒体权利契约）、[EVOLUTION_DIRECTIONS.md](EVOLUTION_DIRECTIONS.md) 1.3 / 2.3

## 0. 一句话

把欧洲美术史与欧洲音乐史两条既有内容线积累的**三套工程方法**——公版图像权利管线、确定性乐谱→音频管线、程序化 SVG 母图生成——反向应用到圣经域，给 224 位人物一套符号身份，给关键经文一套可核引用与泥金呈现，并把已有的圣经题材音乐片段接进人物与事件抽屉。

## 1. 为什么走符号，而不是走肖像

圣经人物没有同时代肖像。任何"头像"都只能是三类之一：

1. **后世艺术描绘**（多雷版画、文艺复兴油画）——是接受史证据，不是人物证据；
2. **现代插画/生成图像**——既无来源又无权利链，与本项目 `documented_record` 定位冲突；
3. **符号身份**（纹章、象征物、字母花押）——不宣称"他长这样"，只宣称"传统用这个符号指认他"。

本项目选 **3 为主、1 为辅**：符号徽章做全站身份标识（列表、关系图、地图、抽屉一致），公版艺术描绘作为抽屉里独立的"艺术中的他/她"接受史区块，永远带 `illustrative` 语义标注。

这条选择同时规避了圣像争议：对上帝、耶稣的具象描绘在犹太教与部分新教传统中是敏感问题；纹章化处理让产品在这个问题上保持中立而不是替读者做神学判断。

参照系是欧洲纹章学（heraldry）与中世纪圣徒象征物（attributes）传统：彼得配钥匙、保罗配剑与书卷、约翰配鹰，这套视觉语法在欧洲美术史内部已被使用一千年，读者不需要额外学习成本。

## 2. 四条轨

### A. 人物视觉身份

| 编号 | 内容 | 量级 | 状态 |
|---|---|---|---|
| A1 | 程序化 SVG 纹章徽章：策展符号库 + 全量程序回退 | M | 本轮实现 |
| A2 | 公版艺术描绘分批扩容（多雷版画为主） | 每批 S | 希伯来圣经 25 张已上线；新约 14 张待续跑；受难系列单独批次 |
| A3 | 徽章与画作在 UI 中的分工收口 | S | 本轮实现 |

**A1 数据契约**：`character_emblems(character_id, symbol_key, ring_key, ground_key, ...)` + `character_emblem_translations(symbol_meaning, attribution_note)`。`symbol_key` 是策展决定（谁配什么象征物），前端 `Emblem.tsx` 按 key 确定性绘制。没有策展记录的人物走**程序回退**：以 slug 为种子的 mulberry32 PRNG 决定环纹与底纹，时代色来自 `chapters.accent_color`，保证同 slug 永远同图。

**A1 符号库**（43 位）遵循传统象征物，每条都在 `symbol_meaning` 里写明依据经文或传统出处；不发明新符号。

**A2 权利**：完全复用 019/063 契约（`media_role` + `depiction_status` + Commons 文件页 + 原图 URL + 许可 URL + 双语 alt + retrieved_at + SHA-256），fail-closed 校验器逐批扩展。多雷《圣经画集》（1866）作者卒于 1883，全球公有领域，风格统一覆盖创世记到启示录，是最适合分批推进的单一来源。

**边界**：不把画作当历史肖像；不为上帝设徽章；不为无经文依据的人物发明象征物。

### B. 重要言论

| 编号 | 内容 | 量级 | 状态 |
|---|---|---|---|
| B1 | `event_scripture_refs`：事件↔经文（书/章/节，OSIS） | M | 本轮实现（首批） |
| B2 | `character_quotes`：人物代表性言论，双语，带 OSIS | M | 本轮实现（首批） |
| B3 | 泥金抄本风格 SVG 名言卡 | M | 本轮实现 |

**译本选择（重要）**：

- 中文：**和合本（CUV, 1919）** —— 公有领域。
- 英文：**World English Bible (WEB)** —— 明确置于公有领域。
- **不用 KJV**：KJV 在英国受永久性 Crown copyright（Letters Patent）约束，虽在美国等地为公版，但对一个面向全球的静态站点，WEB 是无争议选项。这是本轮相对 EVOLUTION_DIRECTIONS 1.3 的一处修正。

**文本纪律**：经文文本条目带 `text_status` 与 `text_sha256`。

- `editorially_entered`：由编辑录入，结构与译本已声明，但**尚未逐字比对公版文本**；
- `source_verified`：已比对，且记录 `verified_source_url`、`verified_at`、取回整节原文及其 SHA-256。

数据库 CHECK 强制：`source_verified` 必须同时具备 HTTPS 来源、时间戳、原文 checksum，**且展示引文必须是取回原文的连续子串**。API 只输出已核验条目，未核验的不进 payload。理由是：错引经文对一个以严谨为卖点的圣经产品是致命失误，而"看起来对"不构成证据。

实测结果（2026-08-18）：该规则在生成期抓出 14 处真实转写差异——弯引号、和合本异体字「裏/着/作」、编者夹注「除去〔或作：背負〕」、以及 WEB 把约翰福音 20:18 写成间接引语。订正后 41 条引文 × 2 语言全部通过，`editorially_entered` 在本批次中没有留下任何条目。

**不做**：不整本入库经文；不收录受版权保护的现代译本（新译本、ESV、NIV 等）；不做神学解释，只做出处标注。

### C. 音乐维度

| 编号 | 内容 | 量级 | 状态 |
|---|---|---|---|
| C1 | 既有音乐片段 ↔ 圣经实体交叉链接 | S | 本轮实现 |
| C2 | 圣经文本专属音乐片段扩容（诗篇调式、圣咏 incipit） | M | 排后 |
| C3 | 古代以色列声音推演 | L | 不做 |

**C1 数据契约**：`cross_work_links` —— 通用跨作品链接表，不是圣经专用。`(from_work_id, from_entity_kind, from_entity_id, to_work_id, to_entity_kind, to_entity_id, link_type)` + 双语 `note`。这是本轮唯一一处刻意做成通用契约的地方，因为"美术史↔圣经""音乐史↔圣经""山海经↔三国"都会需要它。

**C1 语义边界**：链接类型固定为 `musical_setting`（该作品为此经文/人物谱曲）与 `musical_reception`（该作品取材于此叙事）。音频永远是既有的**自产合成学习音**，不是历史演奏；播放免责声明沿用音乐域原文案。

**C1 首批锚点**（全部要求：作品有可播放片段 + 文本关联可查证）：

| 圣经锚点 | 作品 | 依据 |
|---|---|---|
| 人物 david | Schütz《Psalmen Davids》(1619) | 大卫诗篇集 |
| 人物 mary | Josquin《Ave Maria… virgo serena》 | 路加福音 1:28 问安 |
| 人物 mary | Hildegard《O viridissima virga》 | 马利亚交替圣歌 |
| 人物 mary | Machaut《Messe de Nostre Dame》 | 圣母弥撒 |
| 事件 birth-of-jesus | Victoria《O magnum mysterium》 | 圣诞晨祷应答圣歌 |
| 事件 birth-of-jesus | Corelli 圣诞协奏曲 Op.6 No.8 | 题献"为圣诞夜而作" |
| 事件 birth-of-jesus | Léonin《Viderunt omnes》 | 圣诞日升阶经（诗篇 98:3） |
| 事件 birth-of-jesus | Pérotin《Viderunt omnes》 | 同上，四声部扩写 |
| 事件 jacobs-dream-at-bethel | Dufay《Nuper rosarum flores》 | 定旋律取自"Terribilis est locus iste"（创 28:17） |
| 事件 beheading-of-john-the-baptist | R. Strauss《Salome》 | 马太 14 / 马可 6 叙事的现代接受 |
| 事件 expulsion-from-eden | 《Le Jeu d'Adam》 | 亚当夏娃礼仪剧 |
| 事件 last-supper | Byrd《Ave verum corpus》 | 圣体文本 |
| 地点 jerusalem | Palestrina《Sicut cervus》 | 诗篇 42，可拉后裔（非大卫），渴慕神殿 |

Tallis《Spem in alium》取材《友第德传》13 章，属次经，当前圣经 profile 无对应实体，本轮不链接，记为已知缺口。

### D. 全域艺术表达

| 编号 | 内容 | 量级 | 状态 |
|---|---|---|---|
| D1 | 圣经世界程序化 SVG 总览母图 | M | 本轮实现 |
| D2 | 13 个时代徽章 | S | 本轮实现（并入 A1 符号体系） |

**D1** 复刻山海经 SJ-D011 方法：`scripts/generate_bible_overview.ts` 从 `locations` / `routes` / `chapters` 确定性渲染一张无文字的泥金地图母图，同库状态产出字节一致的 SVG，manifest 记录生成器版本与 checksum。母图不是地理精度声明，是氛围底图；真实定位仍由 Leaflet 图层负责。

## 3. 统一的工程纪律

四条轨共用既有约定，不新发明流程：

1. **fail-closed 权利门禁**：未核验的资产不渲染，退回外链。
2. **确定性生成 + checksum**：任何程序化资产都要能从数据重放出字节一致的结果。
3. **双语齐全**：任何面向用户的字符串都有 zh-CN 与 en 的 published 翻译，没有静默回退。
4. **本地候选与 production 分开记录**：本轮不部署即不宣称线上已有。
5. **UUID 分区与 sequence 区间**：沿用 HANDOFF 既有并行生成约定。

## 4. 验证计划

| 门禁 | 命令 |
|---|---|
| 新契约结构与权利 | `npm run verify:bible-art-music` |
| 既有媒体 checksum | `npm run verify:bible-visual-media` |
| 类型 | `npm run typecheck` |
| 测试 | `npm test` |
| 构建 | `npm run build` |
| 升级路径与 API 冒烟 | `npm run verify:postgis` |
| 浏览器 | 中英双语人物/事件/地点抽屉 + 390px 无横向溢出 + console error/warn = 0 |

## 5. 已知风险

| 风险 | 处置 |
|---|---|
| 经文录入错误 | `text_status` 双态 + 校验器强制证据；未升到 `source_verified` 不上线 |
| 符号选择被读作神学主张 | 每个符号写明传统出处；`attribution_note` 声明这是传统象征而非经文规定 |
| 圣像敏感 | 不为上帝设徽章；耶稣用基督符号（chi-rho / 羔羊）而非面容 |
| bundle 体积 | 主 JS 已 666 KB 超阈；徽章为纯代码矢量、无位图；多雷批次必须压缩并懒加载 |
| 音乐音频体积 | C1 不新增音频，复用音乐域既有 WAV |
| 次经缺口 | 记录为已知缺口，不为链接方便而伪造实体 |

## 6. 批次节奏

- 本轮（2026-08-18）：A1 全量 + A2 首批 + B1/B2 首批 + B3 + C1 全量 + D1 + D2，全部为**本地候选**。
- 下一轮：B 的 `source_verified` 升级 pass（人工逐条比对），A2 第二批，C2。
- 再下一轮：部署与 production 重烘焙。

---

更新时间：2026-08-18
