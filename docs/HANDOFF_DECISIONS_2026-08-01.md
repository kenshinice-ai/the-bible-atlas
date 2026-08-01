# Handoff 决策补充 · 2026-08-01

这是对 `docs/HANDOFF.md` 的只读审计后补充，作为当前执行边界记录。

## 已确认

- 每个名著或主题图集使用独立 profile、独立网站/静态构建。
- 当前三个内容线为圣经、三国舆图、银河原力舆图；三者现有数据暂不修改、不重排、不重新策展。
- Galactic Force Atlas 已从 `claude/handoff-implementation-checklist-ac9224` 合并到 `master`，保留独立 profile 与独立发布链。
- 后续数据事实以 HANDOFF 系列文档为准。数据库与静态烘焙产物可能因历史配额或部分时间 seed 未装载而不完全匹配，不以补齐数据为理由改动现有三条内容线。

## 当前工作线：欧洲美术史 Atlas R3（R1/R2/R3/R4/R5/R6）

截至本次阶段性执行（R3 Git 检查点见最终提交），欧洲美术史已完成从 Foundation 到内容 MVP：专用 schema、双语 seed、独立 profile、API 查询、搜索、艺术家/作品/流派浏览、时代筛选、地图联动、深链接与静态烘焙均已验证。临时验证库计数为 **48 艺术家 / 96 作品 / 16 流派 / 96 艺术史生命周期事件 / 24 地点 / 3 机构**。

- 迁移：`008_european_art_lifecycle.sql`（艺术家、作品、流派、机构、历史地名、艺术家/作品事件产物链接、关系与约束）及 `009_seed_history_cleanup.sql`（清理旧 seed_history 兼容触发器）。
- Seed：`049` 骨架校正、`050` 艺术家/作品/机构扩容、`051` 作品生命周期事件、`052` R3 艺术家/作品扩容；均按编号顺序、幂等执行，双语 published 翻译与来源闭环。`052` 新增艺术家 17–48、作品 6–96、对应生命周期事件、真实城市地点、流派和机构来源，并固定跨章作品的时间归属规则。
- 独立站：profile `european-art-history`，默认 `zh-CN`，静态构建只烘焙该 work；支持 `artists`、`artworks`、`movements` 页签、搜索和实体深链接。
- 时代口径：覆盖古典至 1945；现代地位/称谓保存在翻译字段，不改写历史事件的时代语言；真实地点使用 PostGIS，未给《霍比特人》式虚构地点伪造经纬度。
- 已验证：`npm run typecheck`、`npm test`、`npm run build`、全量 migration+seed bootstrap（重复执行幂等）、计数/双语/时间/孤儿审计、API atlas/search/detail、静态数据隔离；浏览器已验收中文、英文状态保留、艺术家详情、艺术品/流派页签、时代筛选、深链接与 390px 基础移动端布局。
- 生产发布：Cloudflare Pages 项目 `european-art-history-atlas` 已创建并发布 production `main`，地址 [european-art-history-atlas.pages.dev](https://european-art-history-atlas.pages.dev)，deployment `1e046d1f`；线上静态 JSON 审计为 48 艺术家 / 96 作品 / 16 流派 / 96 事件 / 24 地点。交付提交 `d23d91720dd6b6353967cf6e7fa6bf931eb71dae`。

- 框架：[EUROPEAN_ART_HISTORY_ATLAS_BLUEPRINT.md](../blueprint/european-art-history/EUROPEAN_ART_HISTORY_ATLAS_BLUEPRINT.md)
- 清单：[IMPLEMENTATION_CHECKLIST.md](../blueprint/european-art-history/IMPLEMENTATION_CHECKLIST.md)

## 保护边界

- 不修改圣经 seed、三国 seed、银河原力 seed。
- 不重烘焙三个现有站点。
- 圣经、三国、银河原力的 seed、profile、静态数据均未修改；不重烘焙三个现有站点。
- R3 已完成；后续增量仍必须遵循“先锁清单、再写时间 seed、每条作品/事件/来源闭环、重复插入有防护”的纪律。艺术史扩容不得回写圣经、三国或银河原力数据。
