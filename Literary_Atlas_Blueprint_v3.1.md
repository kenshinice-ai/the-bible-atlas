# 世界文学名著时空地图 Blueprint v3.1

状态：实现版  
日期：2026-07-22  
主复杂样本：《圣经》  
兼容基线：Blueprint v3.0 与既有实体 slug/API 路径

## 1. 产品目标

把文学阅读转化为可筛选、可定位、可追溯、可分享的时空探索。用户先选择一至五部同层作品，再以主作品深入人物、事件、地点、路线、关系和来源。减少默认画面密度的同时，让单部作品可以持续增加内容深度。

v3.1 以《圣经》测试最困难的模型：跨千年时间、BCE、日期争议、多人多地、多阶段关系、路线、现实地点与事件真实性分离。能正确表达这类复杂性后，普通小说不需要特殊数据结构。

非目标：3D 地球、用户账号、评论、自动生成内容、无许可抓图、动态历史边界和跨作品推断关系。

## 2. 技术架构

```text
Browser / deep link
  -> React 19 + strict TypeScript + Zod
     -> Work Control Center
     -> Leaflet real map | SVG fictional canvas
     -> BCE/CE timeline | relation graph | entity drawer
  -> Express 5 + strict TypeScript + Zod input validation
     -> aggregate catalog/atlas/search read models
  -> PostgreSQL 16 + PostGIS 3.4
     -> forward migrations + versioned bilingual seeds
```

Docker Compose 服务为 `db → migrate → api → web`。`migrate` 只运行未登记的版本，失败会阻止 API 启动。前端对 API 响应再次用 Zod 验证，避免不完整数据静默进入界面。

## 3. 统一 Explore State

权威状态字段：

- `locale`: `zh-CN | en`
- `mode`: `single | multi`
- `works`: 最多 5 个 slug
- `active`: 当前主作品 slug
- `tab`: people/events/locations/routes/relationships
- `entity`: `kind:workSlug:entitySlugOrId`
- `timeline`: `history | narrative`
- `from`, `to`: 历史范围，负数为 BCE
- `until`: 叙事顺序截止点
- `layers`: places/routes/landmarks

状态始终可序列化到 URL。浏览器 back/forward、刷新和语言切换恢复相同探索上下文。旧版 `selected=work:location` 链接继续解析。

## 4. 数据库 schema

核心实体表与翻译表严格分离：

| 实体 | 主表 | 翻译表/链接 |
|---|---|---|
| 作品 | `works` | `work_translations`, `work_chronologies` |
| 人物 | `characters` | `character_translations`, `character_locations`, `character_sources` |
| 事件 | `events` | `event_translations`, `event_characters`, `event_locations`, `event_sources` |
| 地点 | `locations` | `location_translations` |
| 路线 | `routes` | `route_translations`, `route_waypoints` |
| 关系 | `character_relations` | `relation_translations`, `relation_sources` |
| 来源/媒体 | `sources`, `media_assets` | `media_links` |
| 结构 | `chapters` | event chapter FK |

关键约束：稳定 work-scoped slug；关系两端不同；人物/事件年份非 0 且范围有序；real 地点必须有 PostGIS point；fictional 地点必须有 0–100 canvas 坐标；location accuracy 与 layer 一致；zoom 2–18；主题色为六位 hex；媒体必须有来源、许可、作者、URL、归属和双语 alt。

迁移策略：`001_initial.sql` 保留 v3.0；`002_v3_1_complex_atlas.sql` 前向扩展并回填旧行。旧虚构地点先回填 `fictional` accuracy，再添加约束，支持已有数据卷升级。

## 5. i18n 与 fallback

支持 `zh-CN` 和 `en`。可见实体的翻译状态为 `draft | reviewed | published`。

唯一读取 fallback：

1. 请求 locale 的 published 行；
2. 作品 default locale 的 published 行；
3. 两者都没有则明确报错/缺失，不显示草稿，不跨任意语言猜测。

每个本地化实体返回 `resolvedLocale`、`fallbackUsed` 和 `translationStatus`。搜索只在指定 locale 的 published 文本、别名与详情中执行；无效 locale 返回 HTTP 400。

## 6. 时间、现实性与置信度

历史年份使用 signed integer：负数 BCE、正数 CE、禁止 0。`time_type` 为 exact/approximate/range/relative/fictional_calendar/unknown；`calendar_system` 独立记录。人类可读的双语 `time_label` 保留争议表达。

事件现实性和证据置信度是两条独立轴。圣经事件可标为 reported historical、legendary or mythic、contested 等，同时以 high/medium/low 表示当前条目的定位/年代把握。前端不得把地图坐标、时间轴位置或“历史模式”渲染成事实认证。

## 7. 现实与虚构地图分层

现实层：《圣经》《双城记》《安妮日记》《牧羊少年奇幻之旅》。  
虚构层：《霍比特人》。

单次选择必须同层。地图仅拉取和渲染选中作品；每部作品有稳定主题色。现实地图支持 typed marker、popup、preferred zoom、fly-to、fit-all、路线与图层开关；虚构画布使用作品内部 0–100 坐标，不调用现实瓦片或伪造经纬度。

选择事件、人物、路线或关系时，以首个明确链接地点作为地图焦点。用户主动拖拽不会被同一次选择反复抢回；`prefers-reduced-motion` 时取消飞行动画。

## 8. API

- `GET /health`
- `GET /api/locales`
- `GET /api/works?locale=`：作品元数据、另一语言标题、实体计数、地图层、主题色、年代范围
- `GET /api/works/:slug/atlas?locale=`：作品、人物、地点、事件、路线、关系、来源、年代线、媒体及链接
- `GET /api/search?locale=&q=`：指定语言的作品/实体搜索

输入由 Zod 验证。成功结构由 Web Zod contract 验证。错误统一 `{error:{code,message}}`，不把数据库错误伪装成空列表。

## 9. 页面与状态

单页工作区由以下区域组成：

1. 顶栏：产品名、locale、single/multi。
2. Work Control Center：搜索、分类、最多五部同层选择、主作品、计数和色彩。
3. 作品 Hero：摘要、年代/来源地、实体计数、复制深链。
4. 地图：地点/路线/地标图层、fit-all、共享选择。
5. 浏览器：人物、事件、地点、路线、关系五个 tab。
6. 世界时间轴：历史/叙事模式、密度、缩放和平移。
7. Entity Drawer：完整详情、置信度、来源和交叉导航。

桌面为地图+浏览器；窄屏纵向堆叠。原生控件、可见焦点、文字标签和 reduced-motion 是验收要求。

## 10. 圣经 seed 主样本

边界：代表性压力样本，不声称覆盖整部圣经或提供宗派权威年代。

- 13 人物：跨族长、出埃及、王国、先知和新约叙事。
- 14 事件：所有事件至少链接 1 人、1 地、1 来源。
- 12 现实地点：每项有类型、坐标精度、preferred zoom 和双语背景。
- 3 路线：waypoint 顺序唯一且连续。
- 15 关系：方向、情感、强度、状态和可选起止事件。
- 10 来源：经文段落标识与参考来源；不存大段文本。

其余四部保持可浏览双语底座；《双城记》继续保留既有完整实体闭环，作为现代历史小说回归样本。

## 11. Sprint 与交付门

### Sprint 1 — 现状与数据库

审计、差距分析、Git checkpoint、前向 migration、升级夹具。验收：fresh 与 v3.0 upgrade 均通过。

### Sprint 2 — 圣经数据与 API

事务 seed、双语覆盖、来源闭环、rich atlas contract。验收：13/14/12/3/15 计数与每事件闭环。

### Sprint 3 — Explore State 与地图

五部容量、同层约束、URL、typed selection、map focus/popups/layers/fit-all。验收：刷新/切语言/复制链接不丢状态。

### Sprint 4 — 时间轴、关系与详情

BCE/CE、历史/叙事、关系生命周期、实体 drawer 与交叉导航。验收：同一选择在列表、地图、时间轴、关系图和详情一致。

### Sprint 5 — QA 与发布

响应式/无障碍、类型、测试、PostGIS、Compose、浏览器、生产构建、文档、Git checkpoint、ZIP。验收：所有 release gate 通过且源码包不含依赖、数据库卷、密钥或 `.git`。

## 12. 最终验收标准

- 一键启动可检查/安装依赖、启动完整本地栈并输出网址。
- 五部作品均有双语基础数据；圣经为完整 v3.1 压力样本。
- 实体/翻译分离、状态和 fallback 可观察；双语搜索有效。
- 实/虚构地图绝不混层；Hobbit 无现实坐标。
- 最多五部状态模型有效；第六部被明确拒绝。
- 作品→人物→事件→地点→路线/关系→时间筛选→双语→深链形成闭环。
- BCE、近似、范围、现实性、置信度和坐标精度不被扁平化。
- 类型检查、单元/API、迁移、seed、PostGIS、启动器、生产构建和浏览器关键流全部通过。
- README、测试计划、来源政策、交互规范、Changelog、Blueprint 和源码 ZIP 齐全。

## 13. Codex 分阶段 prompts

### Prompt A — 数据扩展

“先读取 Blueprint v3.1 与 data policy。建立 Git checkpoint。只新增 forward migration 与 versioned seed；保持 slugs/API 兼容。为指定作品增加双语人物/事件/地点/路线/关系与来源，禁止精确化争议日期。运行 typecheck、SQL invariants 和 PostGIS verifier，失败即停止并报告。”

### Prompt B — API 扩展

“保持现有 endpoints，增量扩展 rich atlas contract。所有输入用 Zod，所有错误显式返回。增加两语言 contract tests、fallback 正负例和未知资源 404；不得用空数组吞掉 SQL 或翻译错误。”

### Prompt C — UI 功能

“使用统一 Explore State；任何新筛选必须可序列化 URL。新增组件前先证明不能复用现有组件。实体选择必须跨列表、地图、timeline、graph、drawer 共享。支持键盘、窄屏和 reduced-motion。运行 unit tests、typecheck、build 和浏览器关键流。”

### Prompt D — 发布关闭

“先审计工作区 diff 与 migrations。运行完整 release gates、已有数据卷 upgrade、fresh seed、API smoke、桌面/移动浏览器流程。修复后重复全部相关测试。更新 README/Blueprint/Changelog，提交 Git checkpoint，生成可复现 source ZIP 与 SHA-256，并报告任何明确不在范围内的事项。”

## 14. 关联文档

- `docs/ARCHITECTURE_AUDIT_v3.1.md`
- `docs/DATA_MODEL_GAP_ANALYSIS_v3.1.md`
- `docs/IMPLEMENTATION_PLAN_v3.1.md`
- `docs/DATA_SOURCE_POLICY_v3.1.md`
- `docs/UI_INTERACTION_SPEC_v3.1.md`
- `docs/TEST_PLAN_v3.1.md`
- `World_Literary_Atlas_Codex_Execution_Spec_v3.1.md`
