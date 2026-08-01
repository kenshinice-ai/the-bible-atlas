# Handoff 决策补充 · 2026-08-01

这是对 `docs/HANDOFF.md` 的只读审计后补充，作为当前执行边界记录。

## 已确认

- 每个名著或主题图集使用独立 profile、独立网站/静态构建。
- 当前三个内容线为圣经、三国舆图、银河原力舆图；三者现有数据暂不修改、不重排、不重新策展。
- Galactic Force Atlas 已从 `claude/handoff-implementation-checklist-ac9224` 合并到 `master`，保留独立 profile 与独立发布链。
- 后续数据事实以 HANDOFF 系列文档为准。数据库与静态烘焙产物可能因历史配额或部分时间 seed 未装载而不完全匹配，不以补齐数据为理由改动现有三条内容线。

## 下一条工作线

下一条新图集为“欧洲美术史 Atlas”。当前只做框架、范围、schema 决策门和实施清单，不写入艺术史数据库。

- 框架：[EUROPEAN_ART_HISTORY_ATLAS_BLUEPRINT.md](../blueprint/european-art-history/EUROPEAN_ART_HISTORY_ATLAS_BLUEPRINT.md)
- 清单：[IMPLEMENTATION_CHECKLIST.md](../blueprint/european-art-history/IMPLEMENTATION_CHECKLIST.md)

## 保护边界

- 不修改圣经 seed、三国 seed、银河原力 seed。
- 不重烘焙三个现有站点。
- 欧洲美术史在 schema 评审完成前不生成 migration、seed 或前端 profile。
