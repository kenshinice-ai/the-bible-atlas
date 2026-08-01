# Handoff 决策补充 · 2026-08-01

这是对 `docs/HANDOFF.md` 的只读审计后补充，作为当前执行边界记录。

## 已确认

- 每个名著或主题图集使用独立 profile、独立网站/静态构建。
- 当前三个内容线为圣经、三国舆图、银河原力舆图；三者现有数据暂不修改、不重排、不重新策展。
- Galactic Force Atlas 已从 `claude/handoff-implementation-checklist-ac9224` 合并到 `master`，保留独立 profile 与独立发布链。
- 后续数据事实以 HANDOFF 系列文档为准。数据库与静态烘焙产物可能因历史配额或部分时间 seed 未装载而不完全匹配，不以补齐数据为理由改动现有三条内容线。

## 当前工作线：欧洲美术史 Atlas Foundation（R1/R2/R4/R5/R6）

截至本次阶段性执行（Git 检查点 `0b68b91`），欧洲美术史已从框架进入可运行 Foundation：新增专用 schema、双语 seed、独立 profile、API 查询、搜索、艺术家/作品/流派浏览与静态烘焙。当前临时验证库计数为 **16 艺术家 / 5 作品 / 5 流派 / 5 艺术史事件 / 3 机构**；MVP 扩容目标（48 艺术家 / 96 作品）属于后续 R3，不在本次 R1/R2/R4/R5/R6 完成声明内。

- 迁移：`008_european_art_lifecycle.sql`（艺术家、作品、流派、机构、历史地名、艺术家/作品事件产物链接、关系与约束）及 `009_seed_history_cleanup.sql`（清理旧 seed_history 兼容触发器）。
- Seed：`049` 骨架校正、`050` 艺术家/作品/机构扩容、`051` 作品生命周期事件；均按编号顺序、幂等执行，双语 published 翻译与来源闭环。
- 独立站：profile `european-art-history`，默认 `zh-CN`，静态构建只烘焙该 work；支持 `artists`、`artworks`、`movements` 页签、搜索和实体深链接。
- 时代口径：覆盖古典至 1945；现代地位/称谓保存在翻译字段，不改写历史事件的时代语言；真实地点使用 PostGIS，未给《霍比特人》式虚构地点伪造经纬度。
- 已验证：`npm run typecheck`、`npm test`、`npm run build`、全量 migration+seed bootstrap（重复执行幂等）、API atlas/search/detail、静态数据隔离。

- 框架：[EUROPEAN_ART_HISTORY_ATLAS_BLUEPRINT.md](../blueprint/european-art-history/EUROPEAN_ART_HISTORY_ATLAS_BLUEPRINT.md)
- 清单：[IMPLEMENTATION_CHECKLIST.md](../blueprint/european-art-history/IMPLEMENTATION_CHECKLIST.md)

## 保护边界

- 不修改圣经 seed、三国 seed、银河原力 seed。
- 不重烘焙三个现有站点。
- 圣经、三国、银河原力的 seed、profile、静态数据均未修改；不重烘焙三个现有站点。
- 后续 R3 扩容前必须继续遵循“先锁清单、再写时间 seed、每条作品/事件/来源闭环、重复插入有防护”的纪律。
