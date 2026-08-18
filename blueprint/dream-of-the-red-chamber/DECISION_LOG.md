# 《红楼梦 Atlas》决策日志

- 状态：`draft`
- 日期：`2026-08-15`
- 说明：本文件同时记录已批准与仍待批准的决策；状态以各条目为准。

## 状态

- `proposed`
- `accepted`
- `accepted-with-actions`
- `rejected`
- `superseded`

## RC-D001：关系优先，地图降级

- 状态：`proposed`
- 决策：首屏以关系图为主舞台；地图改为后续场景拓扑。
- 理由：《红楼梦》的差异化信息密度来自人物互动，不来自现实地理。
- 影响：新增 relationship workspace，不能直接套用现有 map-first App 布局。

## RC-D002：项目名采用“红楼梦 Atlas”

- 状态：`accepted`
- 日期：`2026-08-15`
- 决策：中文主名“红楼梦 Atlas”，英文名“Dream of the Red Chamber Atlas”。
- 理由：延续现有 Atlas 项目命名，并由产品结构而非改名来体现关系优先。

## RC-D003：第一期采用约 20 核心 + 约 15 上下文人物

- 状态：`accepted`
- 日期：`2026-08-15`
- 决策：Phase 1 使用约 20 位核心人物 + 约 15 位上下文人物；架构支持继续扩展。
- 理由：控制关系审校成本，同时验证多种社会结构。

## RC-D004：默认人物焦点图

- 状态：`accepted`
- 日期：`2026-08-15`
- 决策：默认 focus，compare/full/table/scene 为其他模式。
- 理由：降低认知负担并改善移动端。

## RC-D005：关系采用 facets + phases + evidence

- 状态：`proposed`
- 决策：保留现有 relation 作为摘要，新增多 facet、阶段、五维双向值和证据。
- 理由：单一 sentiment 不足。
- 前置动作：确定五维存储与 phase 重叠规则。

## RC-D006：不计算关系总分

- 状态：`proposed`
- 决策：affection/trust/power/dependency/conflict 不求和、不排名。
- 理由：避免伪精确和价值判断。

## RC-D007：前八十回与后四十回分为两个工程阶段

- 状态：`accepted`
- 日期：`2026-08-15`
- 决策：Phase 1 独立完成前八十回；Phase 2 独立完成后四十回。产品中 `continuation_40` 仍为显式开关和平行 phase。
- 理由：保留版本和作者问题，不静默统一。
- 前置动作：冻结底本与 corpus schema。

## RC-D008：在现有 monorepo 内建设

- 状态：`proposed`
- 决策：新增一方 profile，不新建独立仓库。
- 理由：复用 graph、state、drawer、i18n、static 和部署。
- 条件：必须抽象 workspace/timeline/relation adapter，避免散落硬编码。

## RC-D009：采用“绛雪夜读”暗色主题

- 状态：`accepted`
- 日期：`2026-08-15`
- 决策：默认暖黑漆色背景、绢白正文、胭脂朱 focus，拒绝高饱和粉色 romance palette。
- 理由：兼顾关系图、长时间阅读和主题完整性。
- 前置动作：组件级 contrast 与浏览器验证。

## RC-D010：Phase 1 不做全文阅读器

- 状态：`proposed`
- 决策：仅提供章回定位、短引文、原创摘要和来源。
- 理由：集中关系体验，降低底本和版权复杂度。

## RC-D011：Canvas 必须配关系表

- 状态：`proposed`
- 决策：关系表是等价功能，不是缩水 fallback。
- 理由：节点链接图基础无障碍较弱。

## RC-D012：生产部署单独授权

- 状态：`proposed`
- 决策：完成文档、代码或 static artifact 不等于允许 production。
- 理由：沿用现有项目证据和发布纪律。

## RC-D013：先做 8 人交互原型

- 状态：`accepted`
- 日期：`2026-08-15`
- 决策：正式导入前八十回数据前，先使用 8 人 fixture 完成人物焦点图、关系 lens、章回切换、人物详情和关系表原型。
- 首批人物：贾宝玉、林黛玉、薛宝钗、王熙凤、贾母、王夫人、袭人、晴雯。
- 理由：先冻结交互和视觉语言，避免大批数据进入后再反向修改结构。

## RC-D014：为所有正式人物制作原创虚构形象

- 状态：`accepted-with-actions`
- 日期：`2026-08-15`
- 决策：约 20 位核心人物与约 15 位上下文人物均制作原创虚构 portrait、fullbody、avatar 和 thumbnail。
- 质量重点：容貌辨识度、年龄、发式、首饰、妆容、服饰层级和材质。
- 解释等级：统一标为 `artistic_interpretation / illustrative`，不声称历史精确复原。
- 前置动作：先冻结 2 人 style bible，再完成 8 人原型图，之后分批扩至全部人物。
- 规范：[CHARACTER_VISUAL_ASSET_POLICY.md](CHARACTER_VISUAL_ASSET_POLICY.md)。

## 当前批准状态

已批准：

1. 正式项目名为“红楼梦 Atlas”；
2. 第一期采用约 20 核心 + 约 15 上下文人物；
3. 前八十回与后四十回分为两个工程阶段。
4. 默认使用人物焦点图；
5. 采用“绛雪夜读”主题；
6. 先做 8 人交互原型；
7. 为所有正式人物制作原创虚构头像与全身图。

仍待冻结的是具体实现、底本、图像 style bible 和逐人物视觉 brief，不再是上述产品方向。
