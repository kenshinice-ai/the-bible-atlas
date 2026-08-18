# 《红楼梦 Atlas》规划文档中心

- 项目名：**红楼梦 Atlas · Dream of the Red Chamber Atlas**
- 项目代号：`red-chamber`
- 作品 slug 候选：`dream-of-the-red-chamber`
- 当前阶段：`Phase 0 / Gate 0`
- 文档状态：`draft`
- 建立日期：`2026-08-15`
- 实施状态：**仅规划；尚未修改 schema、seed、API、profile、UI 或部署**

## 1. 一句话方向

《红楼梦 Atlas》不是把《红楼梦》再做成一张地理地图，而是把 Atlas Core 改造成一个可随章回推进的**人物关系阅读器**：用户可以围绕某个人物查看关系圈、比较两个人之间的路径、播放关系的形成与破裂，并回到具体章回、场景与证据。

第一期工程采用**约 20 位核心人物 + 约 15 位上下文人物**。这是内容策展范围，不是数据库或关系图的总量上限。

## 2. 核心取舍

1. **关系图是主舞台，地图降为辅助场景图。**
2. **章回时间是第一时间轴，公元纪年不进入主体验。**
3. **不只画“谁与谁有关”，而要表达关系为何形成、何时变化、由谁掌握权力。**
4. **20 位人物是首版焦点，不是数据库上限，也不等同于“金陵十二钗”名单。**
5. **默认使用人物中心视图，完整网络只作为高级模式。**
6. **关系不能只用 positive / negative / neutral 概括。**
7. **内容工程明确分为两个阶段：第一阶段前八十回，第二阶段后四十回。**
8. **先在现有 monorepo 内新增一方 profile，不复制第二套应用。**

## 3. 与现有 Atlas 的关系

### 直接复用

- React + strict TypeScript；
- `WorkProfile`、构建 profile 与静态 bake；
- 统一 Explore State、深链接、双语 fallback；
- Canvas + `d3-force` + `d3-zoom` 关系图；
- 时代/群体/核心/全部的 LOD 思路；
- drawer shell、搜索、列表、时间轴、媒体权利与来源链；
- 键盘焦点、reduced motion、邻接表替代视图；
- PostgreSQL、版本化 migrations/seeds 和验证器模式。

### 需要改进

- 从“地图 + 侧栏”改为“关系舞台 + 阅读工作区”；
- 从单一 `sentiment + strength` 改为多维关系与阶段；
- 从人物首次所属时代着色改为可切换的家族、空间、社会身份和关系维度；
- 从一条关系一条边改为“关系摘要 + 阶段 + 证据 + 互动事件”；
- 从地图飞行联动改为章回播放、人物焦点与关系路径联动；
- 从通用 drawer 改为适合人物、关系、场景和章回的分栏证据阅读器。

## 4. 文档索引

| 顺序 | 文件 | 作用 |
|---:|---|---|
| 1 | [RED_CHAMBER_BLUEPRINT.md](RED_CHAMBER_BLUEPRINT.md) | 总体产品蓝图、目标、信息架构和成功标准 |
| 2 | [PRODUCT_SCOPE_AND_TRADEOFFS.md](PRODUCT_SCOPE_AND_TRADEOFFS.md) | 地图与关系、约 20+15 人范围、MVP 与非目标取舍 |
| 3 | [CORE_CAST_AND_COVERAGE.md](CORE_CAST_AND_COVERAGE.md) | 第一期核心与上下文人物、前八十回覆盖策略 |
| 4 | [RELATIONSHIP_MODEL.md](RELATIONSHIP_MODEL.md) | 关系语义、维度、阶段、证据和聚合规则 |
| 5 | [INTERACTION_AND_INFORMATION_ARCHITECTURE.md](INTERACTION_AND_INFORMATION_ARCHITECTURE.md) | 页面结构、关系玩法、时间播放和移动端行为 |
| 6 | [VISUAL_DESIGN_SYSTEM.md](VISUAL_DESIGN_SYSTEM.md) | 配色、排版、关系编码、组件和无障碍 |
| 7 | [CHARACTER_VISUAL_ASSET_POLICY.md](CHARACTER_VISUAL_ASSET_POLICY.md) | 全人物头像、全身图、容貌、首饰、妆容与服饰规范 |
| 8 | [CORPUS_AND_EDITORIAL_POLICY.md](CORPUS_AND_EDITORIAL_POLICY.md) | 底本、章回、引文、翻译和版本差异政策 |
| 9 | [DATA_MODEL_AND_API.md](DATA_MODEL_AND_API.md) | 候选 schema、API、静态产物和兼容策略 |
| 10 | [ATLAS_REUSE_AND_ARCHITECTURE.md](ATLAS_REUSE_AND_ARCHITECTURE.md) | 复用边界、profile 方案和需要抽象的 Core 能力 |
| 11 | [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md) | Gate、阶段、任务顺序、估算和交付物 |
| 12 | [TEST_AND_ACCEPTANCE_PLAN.md](TEST_AND_ACCEPTANCE_PLAN.md) | 数据、交互、性能、视觉和发布验收 |
| 13 | [RISK_REGISTER.md](RISK_REGISTER.md) | 学术、内容、产品、性能和权利风险 |
| 14 | [DECISION_LOG.md](DECISION_LOG.md) | 当前已提出的关键决策与待批准事项 |

## 5. Gate 0 纪律

Gate 0 通过前：

- 不新增《红楼梦》生产 profile；
- 不写正式 migration 或 seed；
- 不生成大批人物关系；
- 不改 production；
- 不把候选人物表或章回划分称为“完整《红楼梦》数据”；
- 不覆盖当前工作区中已有 Bible visual pilot 与《山海经》文档变更。

Gate 0 通过条件见 [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md)。

## 6. 已确认的三个基础决定

1. 已确定项目名为“红楼梦 Atlas”。
2. 已确定第一期采用约 20 位核心人物 + 约 15 位上下文人物。
3. 已确定第一阶段处理前八十回，第二阶段处理后四十回。

## 7. 已确认的产品与视觉决定

1. 默认使用人物焦点图，完整网络作为高级模式。
2. 采用“绛雪夜读”暗色主题。
3. 先完成 8 人小型交互原型，再进入前八十回正式数据工程。
4. 所有正式人物均制作原创虚构头像与全身图，并重点审核容貌、首饰、妆容和服饰。
