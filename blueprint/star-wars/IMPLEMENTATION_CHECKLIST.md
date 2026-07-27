# 银河舆图 Galaxy Atlas:实现清单(M0 → M3)

> 依据 [SAGA_BLUEPRINT.md](SAGA_BLUEPRINT.md) / [IP_AND_NAMING.md](IP_AND_NAMING.md) / [ESTIMATE_AND_PIPELINE.md](ESTIMATE_AND_PIPELINE.md),**逐条对照当前代码库核验后**重写。
> 蓝图写于三国上线之前,其中若干前提已经变了(见 §0)。本文是实施时的唯一执行依据;三份蓝图仍是内容与 IP 规格的依据。
> 核验基线:worktree `handoff-implementation-checklist-ac9224`,commit `2ef6a25`,本地库 PostgreSQL 18.4。

---

## 0. 与蓝图的差异修正(先读)

实施前必须知道的 7 处偏差,按影响排序。

| # | 蓝图说法 | 实际情况(已核验) | 后果 |
|---|---|---|---|
| 1 | §1.2 / §6-1:新增迁移 `004` DROP `works` 的 hobbit CHECK,「本实例唯一的 schema 改动」 | **该约束早已被删除**——`db/migrations/002_v3_1_complex_atlas.sql:21` 就是 `ALTER TABLE works DROP CONSTRAINT IF EXISTS works_check;`;线上库 `pg_constraint` 查无此约束 | 这项工作**不存在**,删掉;阶段 0 的「迁移先于一切种子」前提随之取消 |
| 2 | §4.2 / §5.3:新增 `planet`/`moon`/`space_station` 只是「在 i18n.ts ENUMS 加双语对」 | `location_type` 是 **Postgres ENUM**(`002_v3_1_complex_atlas.sql:12`),**且** `apps/web/src/types.ts:8` 的 `LocationTypeSchema` 是严格 zod 枚举 | 这才是真正的 schema 改动。只加 i18n 不改 zod ⇒ atlas 响应解析失败 ⇒ **整站白屏**,不是优雅降级。见 §A-2 决策 |
| 3 | §5.3:「漏加 ENUMS 即 `missingLabels()` 测试红灯」 | `missingLabels()` 已导出但**没有任何测试引用它**(`i18n.ts:8` 的注释与事实不符) | 词条漏加会静默显示成生英文,无人拦截。补测试列入本次范围(§B-9) |
| 4 | §2.2:`formatYear` 有 **4** 个绕过 timeLabel 的调用点 | 实际 **6** 个:`App.tsx:239`、`App.tsx:284`、`TimelineRibbon.tsx:160`、**`TimelineRibbon.tsx:197`**(刻度气泡)、**`TimelineRibbon.tsx:204`**(时间轴刻度文字)、`EntityDrawer.tsx:90` | 漏掉的两处都在时间轴上常驻可见,会显示「公元前 22 年」 |
| 5 | §6-2:新建 `apps/web/src/profile.ts`,`WORK_PROFILE = { kind:"locked-single", slug, yearLabels }` | `profile.ts` **已存在**且形状不同:`{ id, works[], active, mode, defaultLocale, title, tagline, theme }`,由 `VITE_WORK_PROFILE` 构建期选档;bible / three-kingdoms 两档在跑 | 工作量下降:改为「加一档 + 给接口加可选 `yearLabels`」,不是新建机制 |
| 6 | §6-4:`epigraphs.ts` 按新 slug **重写** 12 条题词 | `epigraphs.ts` 已是 profile 化注册表(`SETS`/`SOURCE_NOTES`,:224–234) | 改为**新增 GALAXY 一组**,不动既有两档 |
| 7 | §6-5:`index.html` 改 title/og/描述 | `index.html` 是**全静态硬编码圣经文案**;只有 `document.title` 在运行时被 `App.tsx:54` 覆盖。`vite.config.ts` 无 HTML 变换插件 | 三国线上站至今带着圣经的 meta description / og(既有缺陷)。对银河舆图这是**阻断项**——IP 免责声明的落点①就是 meta description。需要新增 per-profile HTML 机制(§B-8) |

| 8 | §4.2 标题写「36 点」、正文写「(37 行含两座死星)」 | 该表实际有 **39 行** | 已按 39 落库;凡引用「37 点」的段落一律以 39 为准 |

另记:`db/seeds/` 已到 `039`,**新种子从 `040` 起**;`db/migrations/` 已到 `003`,新迁移用 `004`。`works.launch_rank` 1–7 已占,作品位 X=8 与 `10000000-0000-4000-8000-000000000008` 确认未使用。
`launch_rank` 未按蓝图做「两步法置顶」而是直接取 8:排名只影响合并作品列表的顺序,而每个图集现在都是自己的 locked profile 构建,重排线上数据换不来任何东西(三国上线时也没重排)。

---

## A. 决策(已拍板,2026-07-27)

| # | 决策 | 结论 |
|---|---|---|
| A-1 | 产品名 | **「银河原力舆图 / The Galactic Force Atlas」**。profile id `galaxy`、work slug `skywalker-saga`、CF 项目名 `galactic-force-atlas`(均不含商标词)。副题「天行者九部曲非官方检索图集 / An unofficial reference to the Skywalker saga」承担指称性说明 |
| A-2 | 行星的 `location_type` | **A 案**:迁移新增 `planet`/`moon`/`space_station`。理由是为后续更多虚构作品复用,故三个值取通用词而非本作品专名 |
| A-3 | 两条 ≤15 词台词短引用 | **保留**(FOOTER 6 词 · 第四部;hoth-and-exile 5 词 · 第五部),`epigraphs.ts` 文件头登记配额供 IP 审读核对 |
| A-4 | 默认语言 | `en` |
| A-5 | 三国站 meta 缺陷 | **顺带修**,并把「数据隔离」做成机制(§B-8) |

---

## B. 代码项 —— **已全部实施(2026-07-27)**

按依赖顺序排列。**B-1 → B-4 必须先于任何种子装载**(枚举值要先存在)。
实施后的实测差异与追加发现记在每项末尾的「实测」行;§0 的 7 处偏差已按修正后的写法落地。

### B-1 迁移 `db/migrations/004_location_type_galaxy.sql`(新)— 仅 A-2 选 A 案时
```sql
ALTER TYPE location_type ADD VALUE IF NOT EXISTS 'planet';
ALTER TYPE location_type ADD VALUE IF NOT EXISTS 'moon';
ALTER TYPE location_type ADD VALUE IF NOT EXISTS 'space_station';
```
- PG 18 允许在事务块内 `ADD VALUE`,但**新值不能在同一事务内使用**。迁移执行器 `db-cli.ts:31` 用单条 `pool.query(整文件)`(隐式事务),所以:**枚举值加在迁移文件里,使用它的种子必须是另一个文件**——本清单天然满足(迁移 004 / 种子 040)。
- 不要合并进种子文件。

### B-2 `apps/web/src/types.ts:8` — `LocationTypeSchema` 补三值
与 B-1 同批提交。**漏改 = 全站白屏**(zod 严格枚举,atlas 响应整体 parse 失败)。

### B-3 `apps/web/src/i18n.ts:13` ENUMS — 补 10 个词条
- location_type:`planet: ["行星","Planet"]`、`moon: ["卫星","Moon"]`、`space_station: ["空间站","Space station"]`
- icon_variant(自由文本字段,不需迁移):`jedi`、`sith`、`droid`、`pilot`、`senator`、`smuggler`、`bounty_hunter`
- `ruler` / `soldier` / `queen` 沿用现有。

### B-4 `apps/web/src/state.ts:149` `zoomForLocation` — 补三个默认值(可选)
虚构画布不走 Leaflet 缩放,纯粹为一致性;缺省会落到 `?? 10`,无害。

### B-5 `apps/web/src/profile.ts` — 加 `galaxy` 档 + `yearLabels` 字段
```ts
// WorkProfile 接口新增
yearLabels?: { negative: readonly [string, string]; positive: readonly [string, string] };

galaxy: {
  id: "galaxy",
  works: ["skywalker-saga"],
  active: "skywalker-saga",
  mode: "single",
  defaultLocale: "en",
  title: ["银河舆图", "Galaxy Atlas"],          // 待 A-1
  tagline: [...],                                // 副题需含 "unofficial reference"(IP §1.2)
  theme: "galaxy",
  yearLabels: { negative: ["雅汶战役前 {n} 年", "{n} BBY"], positive: ["雅汶战役后 {n} 年", "{n} ABY"] },
}
```
顺带检查 `state.ts:55` 的 `BIBLE_ONLY` 派生标志与 `GlobalSearch.tsx:64` 的作品类结果过滤——galaxy 是单作品档,行为应与 bible 一致,现有 `PROFILE.id === "bible"` 判断需改为按 `mode === "single"` 判定,否则银河档会漏出作品类搜索结果。

### B-6 `apps/web/src/i18n.ts` `formatYear` 第三参
**实测改法优于清单原案**:第三参的默认值直接取 `PROFILE.yearLabels`,而不是让 6 个调用点各自传值。这样「漏传一处就悄悄显示公元前」这个失败模式在结构上消失了,6 个调用点(`App.tsx` ×2、`TimelineRibbon.tsx` ×3、`EntityDrawer.tsx` ×1)与 `formatEventTime` 的内部兜底全部零改动即正确。bible / three-kingdoms 无 yearLabels,行为逐字不变。

### B-7 `apps/web/src/epigraphs.ts` — 新增 GALAXY 一组
`GALAXY_ERA_EPIGRAPHS`(12 条,key 必须与 §3 时代 slug 逐字对应,静默回退是已知坑)+ `GALAXY_WELCOME` + `GALAXY_LOADING`×3 + `GALAXY_FOOTER`,登记进 `SETS`(:224);**IP 免责声明落点② 走 `SOURCE_NOTES`(:211)加 galaxy 条目**——比蓝图说的「改写 UI.scriptureNote」干净,且不污染另两档。文案照 IP §3 表;文件头注释登记短引用条数/词数/出处供 IP 审读核对。
`App.tsx:40/44` 的 `PROFILE.id === "bible"` 后缀判断已天然把 galaxy 排除,无需改动。

### B-8 per-profile HTML + 数据隔离(新机制)
新增 `apps/web/src/profile-meta.ts`(纯数据、零 import,供 Node 侧的 vite.config 读取)+ `vite.config.ts` 的 `transformIndexHtml` 插件,按 `VITE_WORK_PROFILE` 注入 `lang` / title / description / og / theme-color;`index.html` 改为占位符。银河档 description 尾句即 IP §1.3 免责声明(落点①)。

**实测追加发现两处同类泄漏**(均已修,属 A-5 的「数据隔离」范围):
1. `i18n.ts` 的 `dataNote` 是圣经措辞(「悉以经文记载为本 / following the scriptural record」)却**在三档页脚全部显示**——三国线上站至今如此。已按 SOURCE_NOTES 的模式新增 `DATA_NOTES` per-profile 表,bible 保持回退原文案,三国与银河各有自己的一句。
2. `state.ts` 的 `BIBLE_ONLY` 用于隐藏搜索里的作品类结果,银河档同为单作品却拿不到该行为。已泛化为 `SINGLE_WORK = PROFILE.mode === "single"`,bible 行为逐字不变、三国(multi)保留对照栏。

隔离由 `profile.test.ts` 守住:`PROFILE_META` / `SETS_BY_PROFILE` 的 key 集合必须与 `PROFILES` 完全一致,新增档漏配就红灯。

### B-9 测试(补历史缺口 + 新行为)
新建 `apps/web/src/profile.test.ts`,10 条断言;全套 36 测试通过(web 31 + api 5)。

**`missingLabels()` 断言测试补上后立刻抓到 4 个既有缺口**——`documented`、`text_explicit`(route certainty)、`liege`、`double`(relation type)四个值从未有中文标签,zh-CN 界面一直显示「documented」「text explicit」。这正是 §0-3 那条「文档声称有测试、实际没有」的代价,已补齐词条。

### B-10 `apps/web/src/styles.css` — `[data-profile="galaxy"]` 令牌 + 画布底
仿 `:root[data-profile="three-kingdoms"]`(:111–137)。`--accent` 走星芒金 `#C9B45A`(对 `--panel #0F172A` 实测 8.64:1),结构令牌不动。
另:`.fictional svg`(:569)现在是紫色径向渐变(霍比特人 demo 遗留),银河档需换深空底;`.mountains`(:570)见 B-11。

### B-11 `apps/web/src/components/AtlasMap.tsx` FictionalCanvas 增强
蓝图 §4.3 的 ①②④ 已随 P0 完成,③⑤ 留 P1:
- **①装饰层参数化**:新增 `BACKDROPS` 按 work slug 取背景组件,霍比特人的山脉 path 归它自己所有,银河拿到自己的 `GalaxyBackdrop`。
- **②同心环带背景**:按 §4.1 半径表画 4 圈低对比同心圆 + 双语环带名 + 银心 + 90 颗确定性星点(用固定整数序列生成,不用随机源——会重排的星图读起来像渲染 bug)。
- **④标签防碰撞**:14 个候选位(上/下/左右/四角,外加一圈更远的),按「显著度 → 名字长度」排序贪心放置,把**所有散点也作为障碍**,越界视同碰撞,全部落空时取重叠面积最小的位而不是固定回退。
  实测:39 个标签从**十余处压字降到 0 处标签互压、0 处越界**,仅剩 1 个标签(Sullust)蹭到一个散点边缘——文字有描边,可读。
  两个实施要点:银河档标签字号降到 2.1px(39 个天体 vs 霍比特人的几个),**碰撞盒的字号常量必须与 CSS 同步改**;Latin 字宽系数用 `getComputedTextLength()` 校准过并向上取整(估窄会压字,估宽只会散开)。

### B-12 `deploy/deploy-static.sh:34-38` — 加 galaxy 分支
是**追加**不是替换(蓝图说的「换新」会打断 bible/three-kingdoms 两个在线站):
```bash
galaxy) WORKS="skywalker-saga"; CF_PROJECT="galaxy-atlas"; PROBE="atlas.skywalker-saga.en.json" ;;
```
CF 项目名不含商标词(IP §1.2)。`bake-static.ts` 无需改动——`--works` 已参数化(:25),脚本传入即可。

---

## C. 数据项(P0,单 work `skywalker-saga`)

规模目标(ESTIMATE §1):12 时代 / 13 群体 / ≈150 人物 / ≈45 地点 / ≈260 事件 / ≈300 关系 / 3–4 条航线。

规范已固化为 **[`db/seeds/galaxy-seed-spec.md`](../../db/seeds/galaxy-seed-spec.md)**(时代代理的唯一执行依据:ID 段、sequence 区间、BBY/ABY 与 0 年规则、time_label 模板、三条硬约束、封闭星表、IP 一页纸、自测门 SQL)。

| 阶段 | 文件 | 内容 | 代理数 |
|---|---|---|---|
| 0 骨架 | `db/seeds/040_galaxy_structure.sql` ✅ **已装载** | work 行 + chronology(`fictional`, −33…36)+ 12 chapters + 13 groups + 11 sources + **39 地点全量画布坐标** + 24 锚点人物 + 3 条骨干航线 | 1 |
| 1 时代 | `041`–`052` ⏸ **待执行** | 12 时代 ÷ 每批 4 = 3 批;每代理领 KK / sequence 区间(K*1000 步长 2)/ 人物归属名单 / **BBY-ABY 映射与 0 年规则** / time_label 双语模板 / IP 一页纸(IP §4) | 12 |
| 2 装载 | — | 逐个装载 + 孤儿检查 + 登记 `seed_history` | 主会话 |
| 3 重排 | `053` | 全局 sequence 重排,模板 `db/seeds/023` | 1 |
| 4 关系精修 | `054` | 泛型标签清零(「师徒(魁刚→欧比旺)」而非「师承」) | 1 |
| 5 视觉抽查 | — | 色板已预验,只跑幂等校验脚本兜底 | 0.5 |
| 6 详情补写 | 按缺口 | | — |
| 7 IP 审读 | `docs/IP_AUDIT.md` + 修正种子 | 见 §D-3 | 1 |
| 8 烘焙部署 | — | **审读修正落库后再烘焙**(圣经 027 教训) | 主会话 |

**写进 seed-spec 头部、每个内容代理必须收到的三条硬约束**:
1. **`relation_translations` 铁律**——圣经 010–022 就是漏了这个,导致 API 过滤掉 170/272 条关系,靠种子 024 补救。
2. **二次插入防护**——所有翻译表/成员表 `ON CONFLICT DO NOTHING`。三国 037/038 的司马师撞主键就是这么来的(HANDOFF 已把它列为「后续种子规范强制项」)。
3. **禁止新建行星**——37 点是封闭清单;新地点只能是行星表面场所,坐标继承母行星 ±1 偏移。防画布散点漂移。

---

## D. 门禁与验收

### D-1 画布坐标校对门 ✅ **已通过(2026-07-27)**
- SQL 自检:39 座天体的 `sqrt((canvas_x-50)^2+(canvas_y-38)^2)` 与其 `historical_region_name` 声明的环带逐一比对,**0 行矛盾**;白名单(两座死星、卡米诺、贾库)在各自 summary 里已写明越带理由。
- 结构自检:12/13/11/39/24/3 计数正确;翻译、成员、航点孤儿检查全部 0 行;零成员群组 0 个。
- 人工视检(`VITE_WORK_PROFILE=galaxy`,浏览器实测):环带归属正确、塔图因东南 / 恩多西 / 未知区域贴西缘、Core 点聚在中心;标签 0 处互压、0 处越界。中英双语画布均已核。

### D-2 纪年标签覆盖门(阶段 2 每次装载后,零容忍)
ESTIMATE §3.2 的三条 SQL 必须全部 0 行:time_label 非空且不含「公元 / BCE / CE」;`historical_start_year` 符号与 BBY/ABY 方向一致;锚点人物抽屉生卒年逐一目验(EntityDrawer 直呼 `formatYear`,靠 B-5/B-6 的 yearLabels 修)。

### D-3 IP 审读门(阶段 7,替代圣经的神职审计)
新建审读代理定义(`.claude/agents/` 下,仿 `liturgical-design-director.md` 换域重写:娱乐法务 × 粉丝百科编辑)。检单:
1. 原创性机检:全库 summary/detail 跑 ≥8 连续词重合(抽样 + 关键事件全查);
2. 引用清点:≤3 条、每条 ≤15 词、出处齐全,`epigraphs.ts` 头部登记与正文一致;库内 event 文本无引号包裹台词;
3. 命名合规:产品名 / 域名 / CF 项目名不含商标词;双语免责声明两处落点在位(B-7、B-8);
4. 素材合规:构建产物 grep 无外链官方图片、无剧照;SVG 装饰为原创;
5. 译名一致性:大陆通行译名表,全库统一(对应圣经的「该撒利亚拼法」审计);
6. 产出 `docs/IP_AUDIT.md` + 修正种子;**落库后必须重烘焙**。
> IP 合规是本实例唯一的结构性风险。M0 出口应包含一次真人法律审阅(蓝图已点名),工程侧无法替代。

### D-4 常规回归
`npm run typecheck`、`npm run test`(bible/three-kingdoms 两档现有断言不得回归)、`npm run build`、`npm audit`。

---

## E. 里程碑与出口条件

| 里程碑 | 内容 | 出口条件 |
|---|---|---|
| **M0 定稿** ✅ | §A 五项拍板 + 本清单确认 | 已完成。**唯一未了项:IP 真人法律审阅仍需安排**——工程侧无法替代 |
| **M1 骨架上屏** ✅ | B-1…B-12 + 种子 040 + D-1 | 已完成。12 时代空壳 + 39 星点 + 24 锚点在三视图可浏览;BBY/ABY 在全部调用点正确(hero「53 BBY – 56 ABY」、时间轴刻度、中文「雅汶战役前 53 年」);bible/three-kingdoms 两站浏览器实测零回归;typecheck 干净、36 测试通过、三档构建均成功 |
| **M2 内容全量** ⏸ | 种子 041–052 + 053 重排 + 054 关系精修(3 批并行) | 审计 SQL 全绿;D-2 纪年门通过;关系泛型标签清零 |
| **M3 上线** | D-3 IP 审读 + 重烘焙 + `--publish cf` | `docs/IP_AUDIT.md` 关闭;免责声明双落点线上可见;`galaxy-atlas` CF 项目上线 |
| P1 | `rogue-one` + `the-clone-wars` 两个衍生 work;profile 转多作品;FictionalCanvas 缩放平移 + 航线光带 | compare 模式下正传/外传同画布叠加可用 |

全程纪律不变:每阶段完成即更新 `docs/HANDOFF.md` 并随变更提交;修正一律新开种子编号;不动已装载文件。
