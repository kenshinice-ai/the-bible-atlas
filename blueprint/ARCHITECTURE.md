# 图集平台架构:从《圣经舆图》抽象出的可复用引擎

> 本文是「重新生成架构文件」的核心。目标读者:下一个会话/团队,任务是指定一对(或一部)作品,按图索骥实例化一个新图集(例:《三国志》+《三国演义》→「三国舆图」)。
> 配套文件:[WORK_TEMPLATE.md](WORK_TEMPLATE.md)(泛化种子规范)、[PIPELINE.md](PIPELINE.md)(内容生产代理编排)、[EXAMPLE_THREE_KINGDOMS.md](EXAMPLE_THREE_KINGDOMS.md)(三国实例速写)。
> 所有结论基于本仓库真实代码;引用格式为 `文件路径:行号/常量名`。

## 目录

1. [心智模型:引擎 vs 作品参数](#1-心智模型引擎-vs-作品参数)
2. [平台不变量(引擎,动也不能动)](#2-平台不变量引擎动也不能动)
3. [每作品参数层(逐文件、行级耦合点清单)](#3-每作品参数层逐文件行级耦合点清单)
4. [实例化一个新图集的完整清单](#4-实例化一个新图集的完整清单)
5. [史+演义双作品对照模式设计](#5-史演义双作品对照模式设计)
6. [已知约束与风险](#6-已知约束与风险)

---

## 1. 心智模型:引擎 vs 作品参数

本项目实质上是**一台"作品无关"的时空图集引擎**,上面套着一层**圣经专属的品牌/内容皮肤**:

- **引擎**(不因换作品而改动):PostgreSQL schema、双语翻译回退、时代→群体→个人缩放层级推导、地图/时间轴/关系图三视图单一派生、静态烘焙发布链。数据模型里没有任何一个表、枚举或索引是圣经专属的——`works.category` 有 `historical_document`/`historical_fiction`,`event_reality` 有 `verified_historical`/`fictional_with_historical_context`/`contested`,`work_chronologies` 支持 `historical`/`narrative` 双年表——这些正是「史/演义对照」的现成地基。
- **作品参数**(每换一部作品都要重做):`works` 行与主题色三元组、`chapters`(时代)与 `character_groups`(群体)划分、全部种子内容、品牌文案(title/tagline/题词/index.html)、以及一个前端锁定开关(现为 `BIBLE_ONLY`)。

判断某处代码"能不能动"的一条经验法则:**凡是以 slug/UUID/中文文案出现"圣经/the-bible/经文"字样的,都是参数层;凡是以枚举、表结构、派生函数出现的,都是引擎层。**

## 2. 平台不变量(引擎,动也不能动)

### 2.1 数据 schema(`db/migrations/`)

三个迁移文件构成完整模型,新图集**原样复用,不加迁移**:

- `db/migrations/001_initial.sql` — 基础实体:`works` / `characters` / `locations`(PostGIS `geography(Point,4326)`,或 `canvas_x/canvas_y` 虚构画布)/ `events` / `character_relations` / `routes` / `sources`,以及每个实体对应的 `*_translations` 表(`locale_code` 枚举 = `zh-CN` | `en`)。
- `db/migrations/002_v3_1_complex_atlas.sql` — 复杂度层:`work_category`、`event_reality`(7 值,含 `verified_historical`/`fictional_with_historical_context`/`contested`)、`event_time_type`/`confidence_level`(宽年代区间 + 置信度)、`person_reality_type`、`chronology_kind`(`historical`/`narrative`/`fictional` 双年表)、`work_chronologies`、`chapters`、`media_assets`、`seed_history`。**works 行携带主题色三元组** `theme_color/theme_color_dark/theme_color_light`(CHECK 十六进制格式)。
- `db/migrations/003_v4_hierarchy.sql` — 缩放层级:`chapters` 加 `era_start_year/era_end_year/accent_color` + `chapter_translations`;新建 `character_groups`(`group_type` 枚举:family/dynasty/circle/tribe/institution/other)+ `character_group_translations` + `character_group_members`;`source_translations`。

注意一处历史遗留 CHECK:`001_initial.sql:25` 的 `CHECK (map_layer = 'real' OR slug = 'the-hobbit')`——**新增虚构地图层作品必须先改这条约束**;三国等真实地理作品不受影响。

### 2.2 双语翻译回退(API 层)

`apps/api/src/app.ts` 的所有查询遵循同一回退策略(`app.ts:48` 自述:`requested published translation, then the work default locale; never silently substitute`):请求 locale → 作品 `default_locale`,且**只取 `status='published'` 的行**。由此产生一条铁律(已付出代价,见 `db/seeds/024_relation_translation_backfill.sql`):**任何实体没有已发布翻译就等于不存在**——关系缺 `relation_translations` 时,272 条关系里有 170 条曾在界面上消失。前端 `apps/web/src/i18n.ts` 的 `ENUMS` 表 + `missingLabels()` 测试钩子保证任何数据库枚举值都有双语标签,新作品**不需要**改这一层(除非引入新的 `icon_variant` 自由文本值,见 §3.2)。

### 2.3 层级推导与三视图联动(前端引擎)

- `apps/web/src/state.ts` — `ZoomLevel = "era" | "group" | "major" | "all"`(`state.ts:15`);URL 状态序列化(`parseAtlasState`/`serializeAtlasState`);`resolveRange()` 从作品自身 chronology + 事件年代推导时间轴范围(**没有任何写死的年代轴**,`state.ts:160` 注释明确了这一点)。
- `apps/web/src/hierarchy.ts` — 唯一的可见性推导层:`visibleEvents/visibleCharacters/visibleLocations/visibleRelations` 一次派生喂给地图、时间轴、列表、关系图四个面板;`buildGraph()` 把关系网按层级折叠(era 层聚合 + 时代顺序脊线、group 层聚合、major 按 `importance >= 4` 过滤、all 全量);`colorForCharacter/colorForEvent` 按时代 `accent_color` 着色。**全部由 `chapters`/`character_groups`/`importance` 数据驱动,零作品硬编码。**
- 三视图组件(`apps/web/src/components/AtlasMap.tsx`、`TimelineRibbon.tsx`、`RelationGraph.tsx`、`EntityList.tsx`、`EntityDrawer.tsx`)只消费上述派生结果,无作品耦合。

### 2.4 静态烘焙发布链

`apps/api/src/bake-static.ts`(把 `/api/works` + `/api/works/:slug/atlas?detail=full` 双语烘焙成 `apps/web/public/data/*.json`)→ `apps/web/src/api.ts` 的 `STATIC_DATA` 开关(`VITE_DATA_MODE=static` 时读 `/data/atlas.{slug}.{locale}.json`)→ `deploy/deploy-static.sh` 四步一键(健康检查→烘焙→静态构建→产物断言)。机制不变,只有 3 个作品 slug 常量要换(见 §3.5)。

### 2.5 种子装载机制

`apps/api/src/db-cli.ts`:`migrate|seed|bootstrap`;种子按文件名顺序执行、以 `seed_history` 表登记幂等。新图集沿用同一 CLI,不改代码。

## 3. 每作品参数层(逐文件、行级耦合点清单)

### 3.1 数据层参数(纯 SQL,零代码改动)

| 参数 | 现值(圣经) | 定义处 |
|---|---|---|
| `works` 行 | `10000000-0000-4000-8000-000000000005` / `the-bible` / `mythic_epic` / `documented_record` / chronology −2100…62 / 主题色 `#c9972e` 三元组 | `db/seeds/002_bible_v3_1.sql:3-8` |
| `launch_rank`(首位作品) | the-bible = 1 | `db/seeds/008_bible_first_rank.sql` |
| 13 个时代(chapters) | slug/sequence/era 年代/`accent_color` + 双语 `chapter_translations` | `db/seeds/003_bible_v4_structure.sql`;色板重调 `025_bible_era_accent_retune.sql` |
| 19 个群体(character_groups) | slug/group_type/`accent_color` + 双语翻译 | `db/seeds/005_bible_v4_people.sql:303-322` |
| `work_chronologies` | historical −2100…100 | `003_bible_v4_structure.sql:120` |
| 全部内容种子 | 010–027 | 规范见 [WORK_TEMPLATE.md](WORK_TEMPLATE.md) |

### 3.2 品牌文案:`apps/web/src/i18n.ts`

- `UI.title`(`i18n.ts:110`)= `["圣经舆图", "The Bible Atlas"]`;`UI.tagline`(`:111`)= `["从起初,直到地极", …]` — **必换**。
- 圣化措辞 key(换作品时改回中性或换成新作品口吻):`significance: ["经文意义", "Significance in Scripture"]`(`:172`)、`literarySignificance: ["经文脉络", "Scriptural context"]`(`:173`)、`epigraphSourceSuffix: ["(和合本)", "(KJV)"]`(`:208`)、`scriptureNote`(`:209`,版本声明)、`dataNote`(`:207`,"悉以经文记载为本")、`searchEverything: ["寻访人物…"]`(`:128`)、`fitAll: ["回看全境", "Fit the whole land"]`(`:136`)。
- `ENUMS` 中 `icon_variant` 自由文本标签(`:21-24`:族长/先知/士师/门徒/宣教士…)与 `religious: ["敬拜与立约", "Worship & covenant"]`(`:29`)、`religious_site: ["圣所", "Sanctuary"]`(`:43`)是圣经味的;新作品新增 icon_variant(如 军师/太守)时**必须**在 ENUMS 加双语对,否则 `missingLabels()` 测试(`apps/web/src/i18n.test` 相关断言)会拦截。

### 3.3 题词:`apps/web/src/epigraphs.ts`(整文件即参数)

结构与 `App.tsx` 的消费方式是引擎;**引文内容整体替换**:
- `ERA_EPIGRAPHS`:**以 chapter slug 为 key**,每时代一条 `{zh, zhRef, en, enRef}`——新作品必须与新 chapters 的 slug 一一对应(`App.tsx:245`:`ERA_EPIGRAPHS[explore.chapter] ?? WELCOME_EPIGRAPH`,查不到会静默回退到欢迎题词,不报错——这是一个容易漏检的坑)。
- `WELCOME_EPIGRAPH` / `LOADING_EPIGRAPHS`(×3,骨架屏轮换)/ `FOOTER_EPIGRAPH`。
- 版权纪律写在文件头注释:只用公有领域文本(和合本 1919 / KJV),节选注明 `(节选)/(excerpt)`。三国替代方案见 [EXAMPLE_THREE_KINGDOMS.md](EXAMPLE_THREE_KINGDOMS.md) §题词。

### 3.4 入口页与视觉令牌

- `apps/web/index.html`:`<title>`、`meta description`、`og:title/og:description`、`theme-color #0B1120`(全文 9 行,全是品牌)。
- `apps/web/src/styles.css` `:root` 令牌(前 60 行):`--bg #0B1120`(深夜靛蓝)、`--accent #F5C15D`(烛光金)、`--accent-strong/--accent-deep`、`--font-display`(衬线栈)。**结构性令牌(radius/gap/speed/文本对比度阶梯)是引擎;色相是参数。**是否换色:时代/群体色来自数据库 `accent_color`,页面基调色来自这里——两者要一起设计(圣经的教训:9/13 个时代色对比度不达标,重调记录在 `db/seeds/025` 与 `docs/design/sacred-rebrand-plan.md` 4.3 节;新色板一开始就按 ≥4.5:1 对 `--panel #0F172A` 设计)。

### 3.5 作品锁定与发布链常量(共 5 处代码点)

| 位置 | 现状 | 泛化动作 |
|---|---|---|
| `apps/web/src/state.ts:47-48` | `export const BIBLE_ONLY = true;` `const BIBLE_SLUG = "the-bible";` | 换成 `WORK_PROFILE`(见 §5.3) |
| `apps/web/src/state.ts:81-84` | `BIBLE_ONLY` 强制 `mode="single"`、works 归一为 `[BIBLE_SLUG]` | 由 profile 归一逻辑替代 |
| `apps/web/src/App.tsx:196` / `:211` | `!BIBLE_ONLY &&` 隐藏 `WorkControlCenter` 与 compare-bar(多作品代码**完整保留**) | 按 profile.kind 分支 |
| `apps/web/src/components/GlobalSearch.tsx:64` | `BIBLE_ONLY ? items.filter(kind !== "work") : items` | 锁定态过滤作品类结果 |
| `apps/api/src/bake-static.ts:25` | `const workSlugs = ["the-bible"] as const;` | 改为新作品 slug 数组(双作品 = 两个 slug,烘焙 4+2 个 JSON) |
| `deploy/deploy-static.sh:39` / `:48` | 断言 `atlas.the-bible.en.json`;`--project-name bible-atlas` | 换 slug 与托管项目名 |

另:`db/seeds/008` 式的 `launch_rank` 调整决定作品目录排序;`package.json` 包名 `@literary-atlas/*`、数据库名 `literary_atlas` 是中性历史命名,可不动(HANDOFF 已定为 P2)。

## 4. 实例化一个新图集的完整清单

以下步骤化清单从零到上线;单作品跳过带 ★ 的步骤,双作品(史+演义)全做。约定 `<slug>` 为新作品 slug。

1. **建库与迁移**:新建数据库(或复用 `literary_atlas`),`npm run db:migrate`(执行 `db/migrations/001–003`)。若作品需要虚构地图层,先处理 `001_initial.sql:25` 的 hobbit CHECK。
2. **works 行**(模仿 `002_bible_v3_1.sql:3-8`):id 取 `10000000-0000-4000-8000-0000000000NN`(NN 顺延,现已用 01–05),写 slug/author_name/`content_mode`(史→`documented_record`,演义→`literary_narrative`)/`map_layer='real'`/`category`(史→`historical_document`,演义→`historical_fiction`)/`chronology_start_year/end_year`/主题色三元组/`mode_reason`;+ `work_translations` 双语各一行(status='published')。★双作品各建一行。
3. **launch_rank**(模仿 `008`):先 `+100` 挪位再赋 1/2,新作品(对)置顶。
4. **work_chronologies**:每作品至少一条 `kind='historical', is_default=true`;★演义可另加 `kind='narrative'`(回目顺序)。
5. **chapters(时代)**(模仿 `003_bible_v4_structure.sql`):8–15 个,含 sequence、`era_start_year/era_end_year`、`accent_color`(先跑对比度校验)、双语 `chapter_translations`。★双作品**各自建 chapters**(chapters 有 work_id;两组时代年份对齐以便共享时间轴,slug 可相同)。
6. **character_groups(群体)**(模仿 `005:303-322`):15–25 个,group_type + accent_color + 双语翻译。划分方法论见 [WORK_TEMPLATE.md](WORK_TEMPLATE.md) §时代与群体划分。
7. **sources**:每卷/每部原始文本一条(evidence_grade='primary', source_type='primary_text')+ `source_translations` 双语;另加年代表述政策、地理表述政策两条(模仿 `003:95-96`)。
8. **锚点实体种子**(≈圣经的 `004–007`):首批 50–80 人物、40–60 地点、80–120 事件、核心关系,把骨架跑通,再进入批量生产。
9. **批量内容生产**:按 [PIPELINE.md](PIPELINE.md) 的代理编排剧本执行(时代并行生成→装载→全局重排→关系精修→审计)。种子规则一律遵守 [WORK_TEMPLATE.md](WORK_TEMPLATE.md)。
10. **品牌层替换**(§3.2–3.4 逐项):
    a. `i18n.ts`:`UI.title`/`UI.tagline`/`epigraphSourceSuffix`/`scriptureNote`/`dataNote`/`significance` 等圣化 key;新增 icon_variant 的 ENUMS 双语对。
    b. `epigraphs.ts`:按新 chapters slug 重写 `ERA_EPIGRAPHS` + 欢迎/加载/页脚题词(只用公有领域原文,标注出处)。
    c. `index.html`:title/description/og/theme-color。
    d. `styles.css`:决定是否换 `--bg/--accent` 色相(结构令牌不动);与数据库时代色板一次性做对比度验证。
11. **作品锁定泛化**:把 `state.ts` 的 `BIBLE_ONLY/BIBLE_SLUG` 改造为 `WORK_PROFILE`(§5.3),同步 `App.tsx:196/211`、`GlobalSearch.tsx:64`、`state.test.ts` 的归正断言。
12. **发布链常量**:`bake-static.ts:25` workSlugs、`deploy-static.sh:39/48` 断言与项目名。
13. **验证与上线**:`npm run typecheck && npm run test`(注意 `missingLabels` 与 state 测试);本地起 API 后 `bash deploy/deploy-static.sh` → 浏览器实测(三视图数量与库一致、双语切换、深链接归正)→ `--publish cf`。
14. **文档**:更新 `docs/HANDOFF.md`(项目纪律:每次变更后立即更新并随变更提交)。

## 5. 史+演义双作品对照模式设计

这是新图集相对圣经版的**关键差异化**。结论先行:**引擎已支持 80%,剩下 20% 是把 `BIBLE_ONLY` 泛化为 `WORK_PROFILE` + 内容层的对照约定。**

### 5.1 现成机制(代码完整保留,仅被 BIBLE_ONLY 隐藏)

- **多作品模式**:`state.ts` 的 `mode: "single" | "multi"`(URL `?mode=multi&works=a,b&active=a`,上限 `MAX_SELECTED_WORKS = 5`);`App.tsx` 逐作品加载 atlas(`Promise.all(explore.works.map(load))`),compare-bar(`App.tsx:211-220`)切换主作品;`validateWorkSelection` 只拦截混层(real+fictional)——志/演义同为 `real`,可叠加。
- **共享地图层**:多作品时地图叠加全部所选作品的地点/路线(`UI.multiHint`:「地图叠加已选作品;人物、事件、关系与叙事顺序跟随主作品」)。
- **共享年代轴**:`resolveRange()`(`state.ts:160-176`)对**所有已加载 atlas** 的 chronology 与事件年代取并集——两作品都标 184–280,时间轴自动共轴。
- **reality 标注体系**:`event_reality` 7 值 + `confidence` 在事件卡片/抽屉可见,这正是「同一战役,两种口吻」的呈现载体。

### 5.2 同一事件在两作品中的对照约定(内容层,零 schema 改动)

`events` 的唯一约束是 `UNIQUE(work_id, slug)`(`001_initial.sql:81`),因此**两作品对同一史事使用同一 slug** 作为隐式对照键:

- 《三国志》work:`battle-of-red-cliffs`,`reality='verified_historical'`,`confidence='high'`,时间 208,summary 依志文简记(「公与刘备败曹公于赤壁」式的克制笔法),source=《三国志·吴主传/周瑜传》。
- 《三国演义》work:同 slug `battle-of-red-cliffs`,`reality='fictional_with_historical_context'`,铺陈草船借箭/借东风/连环计;**纯虚构衍生情节单独立事件**:`straw-boat-arrows`(草船借箭,`fictional_narrative`——史源实为建安十八年濡须之战孙权事,移花接木)、`borrowing-the-east-wind`(`legendary_or_mythic`)。
- 呈现效果:multi 模式下时间轴同一年份出现两枚事件点,各带自己作品的时代色与 reality 徽章;用户切换主作品即切换叙事口吻。演义独有情节在志侧自然缺席,本身就是信息。
- 升级路径(P2,可选):加 `event_counterparts(work_a_event_id, work_b_event_id, divergence_note)` 连接表 + 抽屉里「在另一部中」跳转。第一版**不需要**——slug 约定已够用,且不动 schema。

各时代 chapters 两作品**平行建**(slug 相同、era 年代对齐、accent_color 同色相不同明度,如志=灰调/演义=饱和调),时代筛选与题词机制即可各自成立。

### 5.3 解除 BIBLE_ONLY:`WORK_PROFILE` 参数化方案

用一个配置对象替换 `state.ts:47-48` 的布尔常量,三档覆盖所有产品形态:

```ts
// apps/web/src/profile.ts(新文件;state.ts / App.tsx / GlobalSearch.tsx / bake-static.ts 共用其常量)
export type WorkProfile =
  | { kind: "locked-single"; slug: string }                       // 现在的圣经舆图
  | { kind: "locked-pair"; slugs: [string, string]; defaultActive: string } // 三国舆图:志+演义
  | { kind: "open" };                                            // 原多作品自由模式

export const WORK_PROFILE: WorkProfile =
  { kind: "locked-pair", slugs: ["records-of-the-three-kingdoms", "romance-of-the-three-kingdoms"], defaultActive: "romance-of-the-three-kingdoms" };
```

改造点(与 §3.5 表一一对应):

- `parseAtlasState`(`state.ts:74-112`):`locked-single` 保持现行为(归一为单作品);`locked-pair` 归一为 `mode="multi"`、`works=profile.slugs`,URL 只允许 `active` 在二者间切换(深链接里其他作品静默归正——沿用 BIBLE_ONLY 的「静默归正而非报错」哲学);`open` 走原始解析。
- `App.tsx:196`:`WorkControlCenter` 仅 `kind === "open"` 时渲染;`App.tsx:211` compare-bar 在 `atlases.length > 1` 时照常渲染——**locked-pair 恰好复用它作为「史/演义」切换器**(建议只改文案:`UI.primary` 由「主作品」改为「视角」)。
- `GlobalSearch.tsx:64`:`kind !== "open"` 时过滤作品类搜索结果。
- `bake-static.ts:25`:`workSlugs` 从同一 profile 概念取值(api 与 web 不共享包,可复制常量并在 deploy 脚本断言两个 atlas JSON 都存在)。
- 测试:`state.test.ts` 现有的 BIBLE_ONLY 归正断言改为按 profile 三档参数化。

回滚成本与圣经版相同:profile 换回 `locked-single` 即回到单作品形态,多作品代码路径全程保留。

## 6. 已知约束与风险

1. **locale 枚举只有 zh-CN/en**(`001_initial.sql:5`):新图集仍是中英双语。三国的英文内容生产量与中文相当,不可省略(API 回退策略要求每实体至少一种已发布翻译,而 `missingLabels`/UI 全部按双语设计)。
2. **题词静默回退**:`ERA_EPIGRAPHS` key 与 chapter slug 不匹配时不报错(§3.3)。替换品牌层后必须逐时代点选验证。
3. **关系翻译铁律**:见 §2.2 与 [WORK_TEMPLATE.md](WORK_TEMPLATE.md);这是本项目返工代价最大的一课。
4. **fictional 层 CHECK**:`001_initial.sql:25` 硬编码 the-hobbit(§2.1)。
5. **对比度**:时代/群体 `accent_color` 入库前先验对比度(圣经 13 色曾有 9 色不达标,重调成本 = 一个种子文件 + 全站回归)。
6. **launch_rank UNIQUE**:调整排序必须先 `+100` 挪位(`008` 的两步法)。
