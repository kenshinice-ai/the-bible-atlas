# 欧洲美术史 Atlas 实施清单

状态：R1/R2/R4/R5/R6 Foundation 已实现并完成本地验证；R3（规模化内容扩容）与独立生产发布仍 Planned。2026-08-01 阶段性交接以 `docs/HANDOFF_DECISIONS_2026-08-01.md` 为准。

## Gate 0：范围与保护边界

- [x] 确认独立 profile：`european-art-history`。
- [x] 确认默认语言、站点名称、tagline 和独立 Cloudflare Pages 项目名（静态脚本已接入）。
- [ ] 锁定 MVP 的 8 个时代与首批艺术家/流派/城市名单。
- [ ] 建立“现有内容冻结”检查：圣经、三国、银河原力 seed 与静态数据不得被本任务修改。
- [x] 建立 profile 回归矩阵：`bible`、`three-kingdoms`、`galaxy`、`european-art-history`。

## Gate 1：数据模型决策

- [x] 评审并落地 `artists`、`artworks`、`movements` 专用表。
- [x] 艺术家与 `characters` 分离，禁止无记录的语义复用。
- [ ] 明确创作地点、现藏地点、展出地点如何分别表达。
- [ ] 明确机构是 `locations` 扩展字段还是独立 `institutions` 表。
- [x] 落地艺术家关系、流派关系、作品关系及作品/艺术家事件产物链接。
- [x] 落地 bilingual translation/status/fallback 约束。
- [x] 使用编号迁移 `008`/`009`，并记录到 `schema_migrations`。

## Gate 2：策展清单

- [x] 8 个时代确定边界、双语标题、摘要和色板。
- [ ] 每个时代确定 3–5 个核心流派。
- [ ] 每个时代确定 3–8 位锚点艺术家。
- [x] Foundation 艺术家确定生卒、主要城市、流派、来源和重要度（16 位）。
- [ ] 每件首批作品确定创作年代、媒介、创作地、现藏地、来源和版权状态。
- [ ] 每个城市/机构确定坐标精度、历史名称和现代名称。
- [ ] 每条路线确定顺序、地点、事件锚点和来源。
- [ ] 争议年代、归属和现藏信息列入人工复核表。

## Gate 3：骨架实现

- [x] 新建 `works` 行和 profile metadata。
- [ ] 建立 chapters / movements / sources 骨架。
- [x] 建立第一批地点、锚点艺术家和核心作品。
- [ ] 建立默认 chronology 与历史/叙事两种时间显示规则。
- [x] 建立中英文 published 翻译。
- [x] 建立实体来源闭环与版权字段。
- [ ] 为 seed 分配独立 UUID 作品位和文件编号，不触碰现有编号。

## Gate 4：前端 profile

- [ ] 增加 `european-art-history` profile，不改变其他三个 profile 的默认行为。
- [ ] 增加独立 title、tagline、meta description、favicon/theme token。
- [ ] 将圣经专属题词、文案和数据声明隔离在 Bible profile。
- [x] 增加艺术家、作品、流派专用浏览入口。
- [ ] 复用地图、时间轴、关系图和详情抽屉，但检查所有标签的艺术史语义。
- [x] 接通跨实体搜索和深链接。

## Gate 5：API、seed 与验证

- [x] 增加 profile 对应的 atlas 读取和详情接口。
- [x] seed 文件按编号顺序、幂等、重复 bootstrap 测试。
- [ ] 每个可见实体有中英文 published 翻译。
- [ ] 每个事件至少关联人物/地点/来源。
- [ ] 每件作品至少关联艺术家/流派/来源。
- [ ] 每条关系有具体双语 label/summary。
- [ ] 真实地点使用 PostGIS，禁止虚构坐标混入。
- [ ] 跑来源、版权、孤儿关系、时间范围和坐标约束审计。

## Gate 6：独立发布

- [x] 静态烘焙只读取 `european-art-history` 数据。
- [x] 构建数据文件按 profile 隔离；现有三档数据未修改。
- [ ] 产物无 localhost API 残留。
- [ ] 独立站浏览器验收：中文/英文、地图、搜索、时代筛选、关系、时间轴、深链接。
- [ ] 独立 Cloudflare Pages 项目发布到 production `main`。
- [ ] 发布后记录 URL、commit、数据计数和构建哈希。

## Gate 7：交付文档

- [x] 更新 `docs/HANDOFF.md` 与阶段性决策 handoff，记录艺术史 profile 的真实状态。
- [ ] 增加数据来源政策、版权政策和人工复核清单。
- [ ] 增加独立站 README 与启动命令。
- [ ] 生成独立 Blueprint、源码 ZIP 和 SHA-256。
- [ ] 明确未完成内容，不能把框架状态写成“已上线”。

## 推荐 Sprint

| Sprint | 目标 | 产出 |
|---|---|---|
| EAH-0 | 范围、schema、版权和 profile 决策 | 评审记录 + 清单冻结 |
| EAH-1 | works/chapters/sources/地点骨架 | migration（如需要）+ skeleton seed |
| EAH-2 | 艺术家、流派、作品首批数据 | 双语首批 seed + 来源闭环 |
| EAH-3 | 独立 profile 与浏览器入口 | UI/API/深链接 |
| EAH-4 | 地图、关系、时间轴联动 | 三视图验收 |
| EAH-5 | 来源、版权、双语和性能审计 | 审计报告 + 修正 seed |
| EAH-6 | 静态发布 | 独立站、README、ZIP、Handoff |

## 当前明确不执行

- [ ] 不修改圣经数据。
- [ ] 不修改三国数据。
- [ ] 不修改银河原力数据。
- [ ] 不先扩容艺术史数据库。
- [ ] 不在 schema 评审完成前生成艺术史实体 seed。
