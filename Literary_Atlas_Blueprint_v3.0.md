# 世界文学名著时空地图 Blueprint v3.0

**版本：** 3.0.0  
**状态：** Build baseline  
**产品目标：** 用可验证、可翻译、可深链接的结构化数据，把文学作品中的人物、事件、地点、路线和时间关系放在同一浏览体验中。

## 1. 产品边界与原则

- 首发只覆盖《双城记》《安妮日记》《牧羊少年奇幻之旅》《霍比特人》。四部都有双语可浏览数据，内容深度优先《双城记》。
- 文学文本只存原创摘要、结构化事件与引用信息，不保存大段原文。
- 现实地理与虚构世界是两个空间系统。虚构地点不得填写伪造经纬度。
- 所有网络输入都经过运行时验证；错误用稳定错误码明确返回。
- 翻译缺失不能无声替换。API 必须返回 `resolvedLocale` 和 `fallbackUsed`。
- 作品分类与单个事件的真实性分开表达，避免把文学叙述宣称为历史事实。

## 2. 系统架构

```text
Browser / React 19 + strict TypeScript
  ├─ URL state: locale, mode, works, active, tab, selected, until
  ├─ RealMap: Leaflet + OpenStreetMap tiles
  └─ FictionalCanvas: isolated SVG coordinate system
                 │ JSON / Zod validation
Node.js 22 + Express 5 + strict TypeScript
  ├─ locale and fallback policy
  ├─ atlas aggregation
  ├─ bilingual search
  └─ explicit structured errors
                 │ parameterized SQL
PostgreSQL 16 + PostGIS 3.4
  ├─ entity tables
  ├─ translation tables
  ├─ geography(Point, 4326)
  ├─ fictional canvas coordinates
  └─ trigram bilingual search indexes
```

Monorepo 使用 npm workspaces。`apps/web` 和 `apps/api` 各自独立构建；数据库迁移和 seed 是可审阅 SQL。Docker Compose 提供 DB、API、Web 一键环境。

## 3. 数据库 schema

### 3.1 枚举

| 枚举 | 值 |
|---|---|
| `locale_code` | `zh-CN`, `en` |
| `translation_status` | `draft`, `reviewed`, `published` |
| `content_mode` | `documented_record`, `literary_narrative` |
| `world_layer` | `real`, `fictional` |
| `route_certainty` | `documented`, `text_explicit`, `inferred` |
| `event_reality` | verified/reported historical、fictional narrative/context、legendary、symbolic、contested |

### 3.2 实体与翻译分离

| 实体表 | 翻译表 | 关键约束 |
|---|---|---|
| `works` | `work_translations` | slug 唯一；模式、地图层、默认语言必填 |
| `characters` | `character_translations` | `(work_id, slug)` 唯一 |
| `locations` | `location_translations` | 现实点只能有 PostGIS 坐标；虚构点只能有 0–100 画布坐标 |
| `events` | `event_translations` | 顺序必填；结束日期不得早于开始日期 |
| `character_relations` | `relation_translations` | 关系两端不能相同 |
| `routes` | `route_translations` | 路线层与确定性必填 |

连接表：`event_characters`、`event_locations`、`route_waypoints`、`event_sources`。来源表 `sources` 使用 `primary/scholarly/reference` 证据等级。

### 3.3 空间不变量

```text
real location      => geom required; canvas_x/y must be null
fictional location => geom must be null; canvas_x/y each in [0, 100]
the-hobbit         => work.map_layer = fictional
other launch works => work.map_layer = real
```

这一约束由数据库 `CHECK` 强制执行，而非仅依赖 UI 约定。

## 4. i18n 契约

1. 支持列表固定由 `GET /api/locales` 返回，首版为 `zh-CN`、`en`。
2. 所有可见作品、人物、地点、事件、路线和关系文字位于翻译表。
3. 内容发布只读取 `status = published`。
4. 读取顺序：请求语言的 published 翻译 → 作品默认语言的 published 翻译。
5. 响应携带 `requestedLocale`、`resolvedLocale`、`fallbackUsed`；若两者都不存在，该实体不进入公开结果，内容后台应报告缺口。
6. 不接受未知 locale；返回 `400 INVALID_REQUEST`，不猜测语言。
7. 切换语言只改变 `locale`，保留 work、tab、selected、until。

## 5. API v1

| Method | Endpoint | 用途 |
|---|---|---|
| GET | `/health` | DB 存活与版本 |
| GET | `/api/locales` | 语言和 fallback 策略 |
| GET | `/api/works?locale=` | 作品选择器 |
| GET | `/api/works/:slug/atlas?locale=` | 单作品完整浏览图谱 |
| GET | `/api/search?q=&locale=` | 当前语言的作品、人物、事件、地点搜索 |

成功响应都是 JSON。错误统一为：

```json
{"error":{"code":"INVALID_REQUEST","message":"Request validation failed","details":[]}}
```

稳定错误码：`INVALID_REQUEST`、`WORK_NOT_FOUND`、`NOT_FOUND`、`INTERNAL_ERROR`。数据库访问必须使用参数化 SQL。搜索首版在指定 locale 的已发布翻译中执行，使用 trigram 索引；不跨语言暗中扩展结果。

## 6. 页面、组件与状态

单页 Atlas 工作区由以下区域构成：

- 顶部：产品标题、支持单选/有限多选的世界名著选择器、中文/English 切换。
- 作品摘要：内容模式徽章、摘要、复制深链接。
- 主视图：地图或虚构画布；点击地点展示详情卡。
- 浏览侧栏：人物、事件、地点、路线四个标签页。
- 时间轴：按事件 sequence 过滤当前可见事件。
- 来源区：展示来源标题、URL 与证据等级。

作品选择规则：

- 单选模式只加载一部作品。
- 对照多选最多选择 3 部，只加载和渲染所选作品。
- 同一次多选必须属于同一地图层；现实与虚构作品不能叠放，违反时显示明确错误。
- 多选地图用作品色区分点和路线；用户指定一个“当前作品”，人物、事件、时间轴和来源跟随当前作品，避免把不同作品的叙事顺序错误合并。
- 这一过滤结构允许单部作品后续扩充更多人物、地点和事件，而不会把全库内容一次塞进地图。

URL 是可分享状态的唯一来源：

```text
?locale=zh-CN&mode=multi&works=a-tale-of-two-cities,the-alchemist&active=a-tale-of-two-cities&tab=events&selected=a-tale-of-two-cities:paris&until=4
```

初次载入从 URL 恢复状态；交互通过 `history.replaceState` 更新 URL。语言切换不得重新初始化其余字段。

## 7. 现实地图与虚构画布分层

### 7.1 现实地图

适用：《双城记》《安妮日记》《牧羊少年奇幻之旅》。地点存 `geography(Point,4326)`；路线由地点序列生成。史实路线使用实线，文学明确路线使用虚线；界面同时显示作品模式与事件真实性。

### 7.2 虚构画布

适用：《霍比特人》。地点只存归一化 `canvas_x/y`。客户端用独立 SVG 坐标系绘制路线、地点和示意地貌，并明确显示“虚构画布坐标，不映射现实经纬度”。不得把中土地点放进地球地图或调用地理编码服务。

### 7.3 后续扩展

未来虚构作品可增加 `fictional_worlds` 和版本化底图，但仍不能复用 PostGIS 现实坐标字段。混合世界作品需要显式 `hybrid` 产品决策和两个视图，不能把两个系统合并成一张伪地理图。

## 8. Seed 范围

| 作品 | 层 | 首版数据 | 深度 |
|---|---|---|---|
| 《双城记》 | 现实 | 8 人物、6 地点、6 事件、关系、英法路线、主要与历史背景来源 | 完整闭环 |
| 《安妮日记》 | 现实 | 2 人物、2 地点、2 有日期事件、史实路线 | 基础浏览 |
| 《牧羊少年奇幻之旅》 | 现实 | 2 人物、3 地点、2 事件、跨区域路线 | 基础浏览 |
| 《霍比特人》 | 虚构 | 3 人物、4 虚构地点、2 事件、孤山远征路线 | 基础浏览 |

所有上述名称和摘要都提供 `zh-CN` 与 `en` published 翻译。摘要为原创短述，不复制文学原文。完整内容深度在本版本指端到端结构闭合，不宣称穷尽作品全部情节。

## 9. 《双城记》端到端闭环

验收路径：

1. 打开默认作品《双城记》。
2. 浏览 8 位人物及人物关系。
3. 时间轴从事件 1 滑到 6，事件列表相应过滤。
4. 点击地点后地图高亮并显示地点摘要。
5. 路线标签展示伦敦 → 多佛 → 巴黎及其 `text_explicit` 状态。
6. 查看来源，区分小说主要来源与法国大革命背景来源。
7. 加入另一部现实作品后，地图只叠加两部已选作品，人物与时间轴仍跟随当前作品。
8. 尝试加入《霍比特人》时收到地图层冲突提示。
9. 切换 en，作品集合、当前作品与选中状态保持。
10. 复制 URL，在新窗口恢复模式、作品集合、当前作品、语言、标签、地点和时间筛选。

## 10. Sprint 计划

| Sprint | 目标 | 退出条件 |
|---|---|---|
| 0 | Git、monorepo、Compose、设计决策 | 基线提交；Compose 配置可解析 |
| 1 | PostGIS schema、迁移、i18n | 迁移成功；空间约束负例失败 |
| 2 | 四部作品 seed | 双语完整性查询通过；霍比特人无 geom |
| 3 | API 与搜索 | 类型检查、API smoke、错误负例通过 |
| 4 | 双层地图与基础 UI | 桌面/移动主流程、语言状态保留通过 |
| 5 | 双城记闭环 | 深链接与时间筛选验收通过 |
| 6 | 文档、构建、打包 | production build、ZIP、SHA-256 完成 |

## 11. 验收标准

### 数据

- 初始迁移可在空 PostGIS 数据库一次成功执行。
- seed 可在迁移后一次成功执行；每个 seed 文件由事务包裹，错误明确回滚。
- 四部作品各有两种 published 作品翻译以及至少一个人物、事件、地点、路线。
- `the-hobbit` 所有地点 `geom IS NULL`；其他三部地点 `geom IS NOT NULL`。
- 《双城记》事件均至少关联地点和主要来源，核心路线有有序 waypoint。

### API

- `locale=fr` 返回 400；未知作品返回 404。
- `/api/works` 返回四部作品；atlas 响应通过 Zod 客户端 schema。
- 中文搜索可找到中文实体，英文搜索可找到英文实体。
- 服务端失败返回结构化错误，且记录真实异常，不返回空数组伪装成功。

### UI

- 作品、人物、事件、地点、路线均可浏览。
- 单选只显示一部；多选最多三部且地图只显示所选作品。
- 现实/虚构混选被明确拒绝，不自动隐藏或伪造坐标。
- 多选的侧栏与时间轴只展示用户指定的当前作品。
- 语言切换保持 mode/works/active/tab/selected/until。
- 时间轴筛选事件，地图点位与地点卡联动。
- 现实与虚构作品切换时使用不同渲染器。
- URL 可复制并恢复状态。
- 1440px 桌面与 390px 基础移动布局无水平溢出，控件有可访问名称。

### 工程与交付

- `npm run typecheck`、`npm test`、`npm run build` 全部通过。
- `docker compose config` 通过；可用 Docker 时完成 DB/API smoke。
- README 包含本地和 Docker 启动、测试、迁移、seed、API 示例。
- 源码 ZIP 排除 `.git`、`node_modules`、`.env`、数据库卷、日志和旧 ZIP，提供 SHA-256。

## 12. Codex 分阶段 Prompts

### Prompt 0 — 仓库与边界

> 检查当前工作树并建立安全 Git checkpoint。只搭建 npm workspace、React TypeScript、Node TypeScript、Docker Compose 和文档目录。保持 strict TypeScript，不实现业务。运行 Compose 配置检查并报告任何环境阻塞。

### Prompt 1 — Schema 与 i18n

> 按 Blueprint v3.0 实现 PostGIS migration。实体表与翻译表必须分离，支持 zh-CN/en 和 translation_status。现实地点与虚构画布坐标用数据库 CHECK 互斥。实现明确 fallback 元数据，不允许 silent fallback。验证迁移与负例约束。

### Prompt 2 — 四部作品 seed

> 为指定四部作品写事务化 SQL seed。所有可见字段提供 zh-CN/en published 翻译。《双城记》建立人物、事件、地点、关系、路线、waypoints、来源闭环；其他三部建立可浏览基础数据。《霍比特人》不得写现实经纬度。运行完整性查询。

### Prompt 3 — API

> 用 Express、pg、Zod 实现 locales、works、atlas、search API。所有输入运行时校验，SQL 参数化，错误结构化。响应公开 resolvedLocale/fallbackUsed。补充 locale、404、搜索和数据库故障测试，完成 typecheck。

### Prompt 4 — UI 与地图分层

> 构建 React 单页 Atlas。作品选择器支持单选与最多三部的同层多选，地图只渲染所选内容，多选时用当前作品限定人物、事件和时间轴。现实与虚构作品混选必须明确拒绝。提供双语切换、四类浏览、时间轴、地图联动。现实作品用 Leaflet；霍比特人用独立 SVG 虚构画布。把 locale/mode/works/active/tab/selected/until 写入 URL，语言切换保留其他状态。完成桌面和 390px 基础响应式检查。

### Prompt 5 — 双城记闭环

> 逐项执行作品→人物→事件→地点→路线→时间筛选→双语→深链接验收。发现失败即做最小修复并重新运行最近的检查。确认事件来源和历史背景不与文学事实混淆。

### Prompt 6 — Release close

> 运行类型检查、测试、迁移、seed、API smoke、关键浏览器交互与 production build。更新 README，列出受环境限制未运行的门禁。基于明确文件清单生成不含密钥与依赖的源码 ZIP 和 SHA-256；提交预期改动，不自动部署或推送。

## 13. 非目标与风险

- v3.0 不提供内容编辑后台、账号、协作审核和线上部署。
- OpenStreetMap 在线瓦片需要网络；离线环境不影响虚构画布，但现实底图可能无法显示。生产环境应选用有明确配额和归属要求的瓦片服务。
- Seed 是产品演示基线，不是文学研究全集。增加内容前必须维护来源、翻译状态和版权边界。
- 作品事件的精确虚构日期常不可确定；用 sequence 保证叙事排序，绝不伪造日期。

## 14. Definition of Done

本版本只有在代码、迁移、seed、API、UI、README、独立 Blueprint、生产构建和源码 ZIP 均存在，并且所有可运行验证通过或被明确标记为环境阻塞时，才可标记完成。
