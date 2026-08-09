# 欧洲古典音乐史 Atlas 实施清单

日期：2026-08-04
状态：Gate 0–6 实现完成；Gate 7 本地、打包与 production HTTP 门禁通过，公开浏览器 UI 验收受环境 URL policy 阻断
纪律：前一 Gate 未通过，不进入后一 Gate；每个 Gate 完成即更新 `docs/HANDOFF.md` 与当日决策记录。

## Gate 0：范围与 Blueprint

- [x] 冻结 profile：`european-classical-music-history`。
- [x] 冻结独立 work、默认语言、真实地图层和单站边界。
- [x] 冻结 7 个主展示时期。
- [x] 冻结 Foundation 配额：48 人物 / 72 曲目 / 24 乐器 / 96 事件 / 80 关系 / 28 乐谱与声音片段。
- [x] 冻结“全局人物关系图 + 单曲作品星图”。
- [x] 冻结 MEI canonical、MusicXML 导入、Verovio 构建时 SVG。
- [x] 冻结自产中性程序化合成声音：8–30 秒，与乐谱片段一一对应。
- [x] 明确完整总谱、完整乐章、商业录音、SoundFont/采样包不属于 Foundation。
- [x] 更新 HANDOFF 与 2026-08-04 决策记录。

## Gate 1：Schema 与 API 评审

- [x] 评审 `music_history` work category。
- [x] 评审 `music_person_profiles` 与 canonical `characters` 映射。
- [x] 评审人物多角色表。
- [x] 评审 compositions、styles、instruments、institutions 专业表。
- [x] 评审 composition/event/person 连接表。
- [x] 评审 `relation_contexts`。
- [x] 评审 score fragment、annotation、generation manifest。
- [x] 决定图片继续使用 `media_assets`，score/audio 使用独立专业表。
- [x] 冻结合成输出为 22050 Hz / 16-bit / mono PCM WAV，静态路径写入 ECM-1 设计。
- [x] 同步 API、Zod、entity 和 search 枚举草案。
- [x] 完成现有四 profile 的 schema 回归风险审查。
- [x] 评审结果写入 `ECM_1_SCHEMA_API_ASSET_DESIGN.md` 与 HANDOFF。

## Gate 2：策展清单

- [x] 冻结 48 位人物及其主角色、次角色、时期和来源。
- [x] 冻结 72 部曲目及创作、首演、出版和修订事件。
- [x] 冻结 20 个风格/乐派/主要体裁。
- [x] 冻结 24 类乐器及 MIMO/Hornbostel–Sachs 映射。
- [x] 冻结 16 个机构/乐团、24 个地点；8 条路线在 seed 生成阶段从地点序列确定。
- [x] 冻结 80 条人物关系，逐条指定人物对、类型、方向和强度。
- [x] 冻结 28 个乐谱片段，指定 composition 与教学 pattern。
- [x] 确认 1945 年后作品无未授权乐谱/声音片段。
- [x] 确认人物、作品、机构、关系和片段引用无孤儿。
- [x] 机器清单写入 `scripts/european_music_foundation_data.ts`。
- [x] 策展记录写入 `GATE2_FOUNDATION_CURATORIAL_LIST.md`。

## Gate 3：Skeleton

- [x] 新建 migration，编号不与现有文件冲突。
- [x] 新建 work/profile metadata。
- [x] 新建 7 chapters、chronology、sources 和双语翻译。
- [x] 新建首批地点、机构、人物、曲目、乐器和事件。
- [x] 建立真实 group 数据，不增加 profile 特判。
- [x] fresh migration + repeat migration 验证。
- [x] skeleton seed + repeat seed 验证。
- [x] 更新 HANDOFF，明确 Foundation 实现与验收状态。

## Gate 4：Foundation 内容

- [x] 48 canonical 人物全部映射。
- [x] 72 compositions 全部双语、带来源和事件链。
- [x] 20 styles、24 instruments、16 institutions 完整。
- [x] 96 events 有时间、地点/人物/曲目和来源闭环。
- [x] 80 relations 有具体双语 label/summary、方向和来源。
- [x] 8 routes 有真实地点与 certainty。
- [x] 所有翻译 published/fallback 门禁通过。
- [x] 所有孤儿、重复 slug、跨 work 引用和时间越界检查为 0。

## Gate 5：乐谱与自产声音

- [x] 建立 MEI 目录、命名与 stable `xml:id` 规范。
- [x] 建立 MusicXML→MEI 导入纪律。
- [x] 建立 Verovio 构建时 SVG 管线。
- [x] 建立 note events/MIDI→程序化合成管线。
- [x] 禁止第三方录音、来源不明 SoundFont 和采样包。
- [x] 28/28 MEI、SVG、声音和 manifest 生成。
- [x] 28/28 checksum 与数据库一致。
- [x] 每段 2–8 小节、8–30 秒。
- [x] 乐谱与声音来自同一 canonical note data。
- [x] rights pending/rejected 片段不进入 production。
- [x] 生成器重复执行无漂移或有明确可解释差异。

## Gate 6：前端

- [x] profile capability 驱动五个主要入口。
- [x] 人物、曲目、乐器、事件、关系列表与搜索。
- [x] Composition constellation。
- [x] Score fragment viewer。
- [x] Audio excerpt player。
- [x] Music feature ribbon。
- [x] 地图、时间轴、关系图、乐谱使用共享 selection。
- [x] 深链接恢复时期、时间范围、实体和片段。
- [x] 键盘、ARIA、表格替代和 reduced-motion。
- [ ] 390px 线上浏览器实测与无页面横向溢出：受本环境 Browser URL policy 阻断；production HTTP/JSON/资产已验证。

## Gate 7：验证与发布

- [x] `npm run typecheck`
- [x] `npm test`
- [x] `npm run build`
- [x] `npm run verify:postgis`
- [x] 音乐内容验证器
- [x] 乐谱/声音 checksum 与时长验证器
- [x] fresh database 全量 bootstrap
- [x] repeat bootstrap
- [x] 现有 profile 回归（10 works / health / API smoke）
- [x] 独立静态烘焙无其他 work 数据
- [x] production build 无 localhost
- [ ] 桌面与 390px 线上浏览器验收：受本环境 Browser URL policy 阻断
- [x] Cloudflare Pages production 发布
- [x] 记录 deployment、commit、数据计数和构建哈希
- [x] 更新 HANDOFF、决策记录与交付包
