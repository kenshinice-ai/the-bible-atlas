# 《红楼梦 Atlas》实施计划

- 状态：`draft`
- 日期：`2026-08-15`
- 当前只批准文档工作，不批准生产实施

## 1. 总体顺序

```text
Gate 0 规划冻结
  → Gate 1 关系体验技术试验
  → Phase 1 前八十回 + 约20核心/15上下文
  → Phase 2 后四十回独立工程
  → Phase 3 人物扩展、场景与课堂/分析
```

## 2. Gate 0：规划冻结

### 交付

- 本目录全部文档；
- 产品名与 profile 名；
- 约 20 位核心人物与约 15 位上下文人物范围；
- 底本候选与版本层；
- 关系 facet/phase/五维模型；
- 默认视觉 palette；
- Phase 1 前八十回分批审核顺序；
- 数据和测试契约；
- owner/reviewer。

### 通过条件

- 产品、内容、技术和视觉四方确认；
- `DECISION_LOG.md` 关键条目变为 accepted；
- 没有“先写 seed 再决定底本”的逆序；
- 不再存在地图是否首屏的争议；
- 英译和引文权利路径明确。

## 3. Gate 1：技术试验

目标：用假数据或极小受控样本证明交互，不追求内容规模。

### 任务

1. 新增 `red-chamber` profile shell；
2. 抽出 relationship workspace；
3. 复用 Canvas graph，加入 focus 模式；
4. 加入 compare 模式；
5. 加入 chapter slider；
6. 使用 8 人 / 12 关系 / 3 phases fixture；
7. 使用贾宝玉、林黛玉、薛宝钗、王熙凤、贾母、王夫人、袭人、晴雯；
8. 加入 relation table；
9. 实装“绛雪夜读”主题；
10. 完成 8 人 portrait、fullbody、avatar 和 thumbnail；
11. 验证 390px 和 1280px；
12. 不接正式 corpus。

### 验收

- 新 profile 不影响现有 profile；
- focus/compare/chapter 三个状态可写入 URL；
- reduced motion 可用；
- Canvas 和 table 选择结果一致；
- theme 对比度通过；
- 8 人图像在头像、详情和全身人物卡中身份一致；
- 所有图像均标注为原创虚构形象。

工作量候选：`3–5 天`。

## 4. Phase 1A：前八十回数据基础

### 任务

- 冻结底本；
- 建 corpus/passages migration；
- 建 interaction/facet/phase/evidence migration；
- seed 约 20 核心 + 约 15 上下文人物；
- seed 群体；
- 按视觉资产规范完成其余约 27 人的 portrait/fullbody/avatar/thumbnail；
- 为每个人物建立媒体 manifest、双语 alt 和 checksum；
- 建 deterministic ID 规范；
- 建关系与证据 verifier；
- 选定代表章回并逐段审核。

### 目标量

- 约 20 核心人物；
- 约 15 上下文人物；
- 5–8 群体；
- 80–120 canonical relationships；
- 120–180 interaction candidates；
- 60–100 published phases；
- 中文 published 100%；
- 英文人物/关系摘要达到最小可用。
- 第一期约 35 人均有通过审核的原创虚构人物图，或明确的高质量无图状态。

工作量候选：`1–2 周`，其中内容审校是主要成本。

## 5. Phase 1B：前八十回产品闭环

### 任务

- network index API；
- focus/compare/path API；
- relation detail；
- chapter delta；
- 人物轨道；
- 关系显微镜；
- 章回播放器；
- lens；
- relation table；
- search；
- static bake；
- release verifier。

### 验收旅程

1. 从贾宝玉到林黛玉关系证据；
2. 林黛玉与薛宝钗 compare；
3. 王熙凤 power lens；
4. 刘姥姥外部观察路径；
5. 袭人与晴雯的照护/冲突结构。

工作量候选：`1–2 周`。

## 6. Phase 2：后四十回独立工程

- 冻结后四十回底本与版本层；
- 单独导入 81–120 回 passages、interactions、phases 和 evidence；
- 复用第一阶段人物身份并补充必要新人物；
- 建立独立 coverage、验证器报告和发布门禁；
- UI 增加 continuation 开关和双阶段分轨；
- 验证后四十回数据不会覆盖前八十回判断。

工作量候选：`1–3 周`，取决于后四十回内容审核速度。

## 7. Phase 3：扩量、场景与高级能力

- 扩展至 50–100+ 人物；
- 场景 topology 与在场人物；
- 多路径查询和群体 hull；
- 第一批合规版本影印/人物画；
- 完整章回 coverage；
- 邻接矩阵；
- 中心性/社群分析；
- 关系变化摘要；
- 课堂 guided tour；
- 可打印人物关系卡；
- 自然语言查询已审核图数据；
- 多版本平行比较。

## 8. 实施优先级

| 优先级 | 项 | 原因 |
|---|---|---|
| P0 | 底本与版本层 | 所有证据的根 |
| P0 | relationship phase/evidence | 产品差异化核心 |
| P0 | focus graph + table | 主体验与无障碍 |
| P0 | chapter state | 关系变化的时间基础 |
| P0 | 8 人 style bible 与原型图 | 冻结人物视觉身份和 UI 裁切规则 |
| P1 | compare | 高价值、可传播 |
| P1 | power/care/conflict lens | 防止只剩爱情图 |
| P1 | static bake | 上线与分享基础 |
| P2 | scene topology | 有价值但不是首屏 |
| P2 | media | 内容增强，不应阻塞文本 |
| P3 | AI query | 必须建立在审核图谱后 |

## 9. 分支与提交建议

实施时使用：

```text
codex/red-chamber-gate1
codex/red-chamber-data
codex/red-chamber-phase1
```

提交边界：

1. docs；
2. profile shell；
3. schema/migration；
4. seed/verifier；
5. API；
6. web interaction；
7. static/release。

不要把大批内容 seed 与关系图重构放在同一不可审查提交中。

## 10. 停止条件

出现以下情况暂停实施：

- 底本权利不清；
- 关系标签无法定位证据；
- 版本层被静默合并；
- 新 profile 需要大量 `PROFILE.id` 分支；
- 约 35 人的第一期范围已出现明显性能问题；
- Canvas 成为唯一可访问关系入口；
- 英文内容来自未授权现代译本；
- 当前 dirty worktree 的其他项目变更可能被覆盖。
