# Handoff 决策补充 · 2026-08-04

本文件记录欧洲古典音乐史 Atlas 的 ECM-0 Blueprint 决策。它是规划与边界检查点，不代表 schema、数据、前端、乐谱或声音功能已经实现。

## 1. 当前工作线

- profile：`european-classical-music-history`
- work slug：`european-classical-music-history`
- 站名：`欧洲古典音乐史 Atlas / European Classical Music History Atlas`
- 默认语言：`zh-CN`，保留 `en`
- 地图：真实地理
- 部署：未来使用独立静态构建，不并入现有四站

Blueprint：

- `blueprint/european-classical-music-history/EUROPEAN_CLASSICAL_MUSIC_HISTORY_ATLAS_BLUEPRINT.md`
- `blueprint/european-classical-music-history/IMPLEMENTATION_CHECKLIST.md`

## 2. 已冻结的产品结构

- 主入口固定为人物、曲目、乐器、事件、关系。
- 四个联动视图为地图、时间轴、人物关系图和乐谱片段分析。
- 全局关系图只显示人物；选择曲目后使用局部作品星图连接作曲家、词作者、首演者、指挥、机构、出版者、风格和乐器。
- 7 个主展示章节：中世纪、文艺复兴、巴洛克、古典主义、浪漫主义、现代主义与战争、战后与当代。
- 主 chapter 使用非重叠策展区间；跨期风格由多对多 style 关系表达。

## 3. Foundation 配额

- 48 位 canonical 人物；
- 72 部 compositions；
- 20 个风格/乐派/主要体裁；
- 24 类乐器；
- 16 个机构/乐团；
- 24 个地点；
- 96 个事件；
- 80 条人物关系；
- 8 条路线；
- 28 个乐谱片段；
- 28 个自产合成声音片段，与乐谱一一对应。

这些数字是 Foundation 门禁，不授权在策展清单冻结前批量生成内容。

## 4. 人物与关系纪律

- 具名历史人物只建立一个 `characters` canonical 节点。
- 音乐专业资料通过 `music_person_profiles.character_id` 映射。
- 人物可以同时具有 composer、performer、conductor、theorist、librettist、patron、publisher、instrument_maker、educator、critic 等角色。
- 乐团、教堂、宫廷、歌剧院、音乐学院和出版社不伪装成人物。
- 每位作曲家至少一部曲目；其他人物至少有作品、事件、机构或关系上下文。
- 80 条人物关系必须有方向、具体双语 label/summary、来源和可选的作品/事件/机构上下文。
- 音乐史必须建立真实 group 数据，不新增“无 group 所以强制 all”的 profile 特判。

## 5. 乐器纪律

- 用户层使用弦乐、木管、铜管、打击、键盘、拨弦与早期、人声、机械与电子分类。
- 研究层保留 Hornbostel–Sachs code 和 MIMO preferred term。
- 乐器演变支持分支、共存、地区差异和复兴，禁止写成单一直线替代史。
- Foundation 不提供仿真乐器试听；音乐片段使用统一中性自产合成音，避免误称真实历史音色。

## 6. 乐谱与声音拍板

用户已明确：先做代表性片段和自产合成声音，未来再考虑完整版本。

冻结方案：

- MEI 为 canonical 乐谱格式；
- MusicXML 只作导入/交换；
- Verovio 在构建阶段生成 SVG；
- Foundation 恰好 28 个片段，每段 2–8 小节；
- 每段声音 8–30 秒，与屏幕乐谱来自同一 canonical note data；
- 使用无第三方采样的中性程序化合成音；
- 不使用商业录音、来源不明 SoundFont、采样包或模仿具体演奏家的声音；
- 固定免责声明：学习用自产合成音，不代表历史演奏、真实乐器音色或权威速度；
- 不制作完整乐章、完整总谱或连续可替代正式乐谱的片段；
- 1945 年后作品默认只做元数据和事件，没有明确许可不制作乐谱或声音片段；
- 每段必须有来源、权利状态、MEI/SVG/audio checksum 和 generation manifest。

## 7. ECM-1 Schema / API / 资产评审结果

ECM-1 评审已完成，详细设计见：

- `blueprint/european-classical-music-history/ECM_1_SCHEMA_API_ASSET_DESIGN.md`

已冻结：

- migration 分为 `013_european_classical_music.sql` 与 `014_music_score_assets.sql`；
- Foundation seed 从 `057` 开始，不修改或复用已装载的 `001–056`；
- 音乐人物使用 `music_person_profiles.character_id` 映射 canonical `characters`；
- 全局人物关系继续使用共享 `character_relations`，作品/事件/机构语境使用 `relation_contexts`；
- compositions、music styles、instruments、music institutions 使用平行专业表；
- 图片继续使用 `media_assets`；score/audio 使用独立 `score_fragments` 与 `score_generation_manifests`；
- Foundation 声音冻结为 22050 Hz、16-bit、mono PCM WAV；临时 MIDI/PCM 不入库；
- 标准静态资产路径冻结为 `/media/music/scores/`、`/media/music/timing/`、`/media/music/audio/` 和 `/media/music/manifests/`；
- Atlas/API 增加 `musicPeople`、`compositions`、`musicStyles`、`instruments`、`musicInstitutions`、`scoreFragments`；
- 音乐人物不新增独立搜索实体类型，搜索继续返回 canonical `character`；
- profile 入口、默认 tab、graph levels、专业能力和搜索隐藏项改由 capability 配置驱动，不再增加 music-specific profile id 分支。

ECM-1 评审明确的风险：

- 现有 `apps/api/src/app.ts` 查询集中在单文件，音乐层接入前必须拆出 shared/art/music loaders；
- `types.ts`、`i18n.ts`、`profile.test.ts` 和 API search union 必须同步扩展，否则会出现整包 Zod 解析失败或中文枚举漏标；
- 新表必须有 work-scope 约束，禁止跨 profile 外键连接；
- score fragment 的 `rights_status` 非 `verified` 时只能返回 metadata，不能提供播放路径；
- Foundation 不允许引入第三方 SoundFont、采样包或商业录音。

## 8. Schema 方向

共享复用人物、地点、事件、路线、关系、章节、群体、来源和翻译体系。音乐专业层新增：

- music person profile / roles；
- compositions / contributors；
- music styles；
- instruments / variants；
- music institutions；
- person/composition/event/context 连接；
- score fragments / annotations / generation manifests。

不直接复用美术史 `artists / artworks` 承载音乐内容，也不在未完成回归评审时重命名已经发布的美术史表。

## 9. 当前真实状态

ECM-0 与 ECM-1 文档阶段已完成：

- Blueprint 已创建；
- 实施清单已创建；
- ECM-1 schema/API/asset design 已创建；
- HANDOFF 已更新；
- profile、migration、seed、API、前端组件、MEI、SVG 和声音文件均尚未创建；
- 未运行数据库、构建、测试或发布门禁，因为本阶段没有实现代码；
- 未修改或重烘焙圣经、三国、银河原力和欧洲美术史四个现有 profile。

下一步进入 Gate 2 策展清单：先冻结 48 人物、72 曲目、20 风格、24 乐器、16 机构、80 关系和 28 个片段，再进入 `013/014` migration 与 skeleton；不得跳过清单直接写 seed。

## 10. Gate 2 策展冻结

Gate 2 已完成：

- 机器可读清单：`scripts/european_music_foundation_data.ts`
- 策展记录：`blueprint/european-classical-music-history/GATE2_FOUNDATION_CURATORIAL_LIST.md`

静态审计确认：

- 48 人物、72 曲目、20 风格、24 乐器、16 机构、24 地点、80 关系、28 片段；
- 72 部曲目的作曲家引用完整；
- 人物、作品、机构的地点引用完整；
- 80 条关系两端人物完整；
- 28 个片段的 composition 引用完整；
- 72 个 composition event + 24 个锚点人物事件 = 96 个事件；
- 片段只选择 Foundation 权利边界允许的历史作品，战后版权期作品不生成片段。

下一步进入 Gate 3：创建 `013/014` migration 和 `057` seed，并执行 fresh/repeat 验证。

## 11. 2026-08-09 实现、验证与 production 发布闭环

Gate 3–7 已完成并提交：

- migration：`013_european_classical_music.sql`、`014_music_score_assets.sql`、`015_music_score_asset_path_fix.sql`、`016_music_score_renderer_metadata.sql`；seed：`057`、`058`、`059`；
- API、Zod contract、profile capability、静态 bake、前端实体抽屉/列表/搜索和音乐主题已实现；
- 48/72/20/24/16/24/96/80/8/28 Foundation 计数、双语翻译、来源闭环、跨 work 约束和乐谱/声音 checksum 均通过；
- 全量 migration/seed 从零 bootstrap 后再次 bootstrap 均通过；现有 profile API smoke 返回 10 works，health contract 为 `4.0.0`；
- 实现提交为 `a70dbc8`。

生产发布冻结为 Cloudflare Pages 项目 `european-classical-music-history-atlas`、production branch `main`、deployment `1e29ca49-1689-48f9-9282-344b4a9fe648`。生产 JSON、28 组音乐资产、WAV content type 和逐项 SHA-256 已复验。

应用内浏览器视觉验收暂记为环境阻断：首次 production 导航遇到一次 522，curl 重试 HTTP 200；浏览器 URL policy 随后阻断 reload，故不宣称桌面/390px/console 已通过。解除 policy 后只需补验公开站的视觉布局、深链接、音频播放与横向溢出，不需要重新生成数据或重新部署。
