# 银河舆图(Star Wars 实例):核心蓝图

> 依 [../ARCHITECTURE.md](../ARCHITECTURE.md) §4 实例化清单起草;种子规范见 [../WORK_TEMPLATE.md](../WORK_TEMPLATE.md),编排见 [../PIPELINE.md](../PIPELINE.md),双作品先例见 [../EXAMPLE_THREE_KINGDOMS.md](../EXAMPLE_THREE_KINGDOMS.md)。
> 本 IP 的版权/命名约束是硬前提,**先读** [IP_AND_NAMING.md](IP_AND_NAMING.md);工作量与阶段见 [ESTIMATE_AND_PIPELINE.md](ESTIMATE_AND_PIPELINE.md)。
> 本文所有摘要/题词示例均为原创转述,不含影片台词(除 IP 文件中标注的 ≤15 词短引用方案)。

## 1. 作品建模决策:一个 work,而非三个

**推荐:Skywalker Saga 九部曲建为一个 work(`skywalker-saga`),episodes 折成时代(chapters);衍生作品各自独立成 work,P1 起叠加同一银河画布。**

论证(按平台真实约束,非口味):

1. **关系图是决定性理由**。`character_relations` 有 `work_id` 外键且 from/to 都必须是同 work 人物(`db/migrations/001_initial.sql` 的 `character_relations` 表)——跨 work 关系在 schema 上不存在。若按三部曲拆成三个 work,Anakin↔Obi-Wan(前传)、Vader↔Luke(正传)、Ben Solo↔Rey(后传)将被切进三个孤立关系网,而这条「天行者血脉」恰是九部曲的唯一主轴。圣经 13 时代单 work 的先例证明:**长弧叙事该用时代切,不该用 work 切**。
2. **时间轴共轴天然成立**。单 work 的 `resolveRange()`(`apps/web/src/state.ts:160`)直接从自身 chronology(−33…36)推导;三 work 方案要靠 multi 模式并集,却换不来任何对照价值——三部曲之间没有「同一事件两种口吻」(那是志/演义的场景),只有先后接续。
3. **compare 模式留给真正的对照**:衍生作品与正传是「同一银河、不同视角/时段」,这正是多作品叠加地图的设计初衷(`validateWorkSelection` 只拦 real+fictional 混层;衍生作品同为 `fictional` 层,可与正传叠加)。Rogue One 的 `scarif-data-heist` 与正传 `yavin-campaign` 时代在时间轴上 −1…1 年并列,就是天然的「正传一笔带过 / 外传全片铺陈」对照。
4. 反方案(三个 work 成三部曲)仅有的好处是「三部曲各有主题色三元组」——但时代 `accent_color` 已提供逐幕配色(§4),损失远大于收益。**否决。**

### 1.1 works 行(P0 仅此一行;P1/P2 衍生)

| 字段 | P0:`skywalker-saga` | 依据 |
|---|---|---|
| id / 作品位 X | `10000000-0000-4000-8000-000000000008`,X=8 | NN=01–07 已用(圣经 05、三国 06/07);实体前缀 `48…/38…/68…/78…`,chapters `88…`、groups `a8…`、sources `58…`(避让规则见 [../WORK_TEMPLATE.md](../WORK_TEMPLATE.md) §1) |
| slug | `skywalker-saga` | 描述性、不含商标词(见 [IP_AND_NAMING.md](IP_AND_NAMING.md) §1) |
| author_name | `George Lucas and successors(乔治·卢卡斯及后继创作者)` | 事实性署名,非官方背书 |
| content_mode | `literary_narrative` | 全虚构叙事 |
| category | `mythic_epic` | 太空歌剧=现代神话;`fantasy` 备选,但圣经已示范 `mythic_epic` 用于「英雄弧+世代传承」型文本 |
| map_layer | **`fictional`** | 触发 `AtlasMap.tsx:287` 的 FictionalCanvas 分支 |
| chronology_start/end_year | −33 … 36 | BBY/ABY 映射见 §2 |
| default_locale | `en` | 原作语言;沿用圣经决策 |
| launch_rank | 置顶(两步法:先 +100 挪位再赋 1,模板 `db/seeds/008_bible_first_rank.sql`) | |
| 主题色三元组 | `#C9B45A` / `#7A6420` / `#EBD9A0`(星芒金;对 `--panel #0F172A` 实测 8.64:1) | |
| mode_reason | 原创英文一句:銀河尺度的虚构史诗,需虚构画布与虚构纪年,事件级 reality 全部为虚构谱系 | |

**衍生作品排期**(全部 `map_layer='fictional'`、坐标复制同一画布约定,行独立):P1 = `rogue-one`(与正传时代咬合最紧、体量最小,最适合首个 compare 试点)+ `the-clone-wars`(动画剧集,填 −23…−20 密度);P2 = `the-mandalorian`(5–12 ABY,填新共和国空窗)、`solo`、`andor`。每个占一个新 NN 与作品位 X(09/X=9、10/X=a…),坐标表(§5)按 work 复制行即可。

### 1.2 必改的一条 schema 约束(唯一例外)

`db/migrations/001_initial.sql:25`:`CHECK (map_layer = 'real' OR slug = 'the-hobbit')`。这是 [../ARCHITECTURE.md](../ARCHITECTURE.md) §6.4 早已点名的历史遗留。**新增迁移 `db/migrations/004_fictional_layer_open.sql`:DROP 该 CHECK**(它只是 demo 期护栏,`locations` 表自己的 layer/geom/canvas 互斥 CHECK 才是真约束,保留不动)。这是本实例唯一的 schema 改动。

## 2. 纪年方案:BBY/ABY ↔ 平台负数年份

### 2.1 数据层映射(零改动即可入库)

- **BBY n → −n,ABY n → +n**,雅汶战役(Ep IV 高潮)为原点。
- **无 0 年**:库有 CHECK(`events_historical_start_nonzero`、`chapters_era_start_nonzero`)。约定与「公元前 1 年/公元 1 年」同构:**0 BBY(战役前的当年)→ −1,0 ABY(战役后的当年)→ +1**。`time_label` 照写 `0 BBY`,不受影响。写进 seed-spec 作为全体代理契约。
- events:`time_type='fictional_calendar'`、`calendar_system='fictional'`(枚举现成,`002_v3_1_complex_atlas.sql:8-9`),`historical_start/end_year` 用映射后带符号年份——时间轴、era 筛选、`resolveRange()` 全部照常工作,因为引擎只认带符号整数。
- `work_chronologies`:一条 `kind='fictional', label='Galactic Standard (BBY/ABY)', start_year=-33, end_year=36, calendar_system='fictional', is_default=true`。P2 可另加 `kind='narrative'`(上映顺序 IV V VI I II III VII VIII IX,供 sequence 模式叙事)。

### 2.2 显示层:formatYear 的公元纪年耦合,两条路评估

`apps/web/src/i18n.ts:75` 的 `formatYear` 把负数硬渲染成「公元前 n 年 / n BCE」。

**路 A:仅靠 `events.time_label` 逐条覆盖(零代码)。** `formatEventTime`(`i18n.ts:87`)优先取 timeLabel,而 [../WORK_TEMPLATE.md](../WORK_TEMPLATE.md) §3 本来就强制每事件双语 time_label(`雅汶战役前 22 年`/`22 BBY`)——事件卡片、抽屉、时间轴条目全部正确。**但有 4 个残留调用点绕过 timeLabel 直呼 formatYear**,会显示「公元前 33 年」:
1. `apps/web/src/App.tsx:238` — 时代 chip 的年代区间(常驻可见);
2. `apps/web/src/App.tsx:283` — 时间筛选 chip;
3. `apps/web/src/components/TimelineRibbon.tsx:160` — 时间轴表头区间;
4. `apps/web/src/components/EntityDrawer.tsx:90` — 人物生卒年。

路 A 成本为零但这 4 处(尤其 1 和 3 常驻)必错,**不可接受为终态**。

**路 B:formatYear 加 per-work 纪年标签配置(推荐,P0 代码项,半天)。** 不动 schema:在 `WORK_PROFILE`(见 [../ARCHITECTURE.md](../ARCHITECTURE.md) §5.3 的 `apps/web/src/profile.ts` 方案)加一档:

```ts
yearLabels?: { negative: [string, string]; positive: [string, string] }
// 银河舆图:{ negative: ["雅汶战役前 {n} 年", "{n} BBY"], positive: ["雅汶战役后 {n} 年", "{n} ABY"] }
```

`formatYear(year, locale, labels?)` 有 labels 则套模板,无则走现行公元逻辑;4 个调用点传入 profile 值;`i18n.test` 补两条断言。烘焙链不受影响(静态 JSON 不含格式化文本)。**结论:路 B 做,路 A 的 time_label 纪律照样全量执行**(它本就是模板强制项,且是事件级细粒度表述如 `约 22–19 BBY` 的唯一载体)。

## 3. 时代划分(12 幕)与色相弧

色相弧叙事:**共和国金 → 战火橙 → 66 号令烬红 → 帝国灰蓝 → 义军橙红 → 雅汶烈金 → 霍斯冰蓝 → 恩多林绿 → 新共和国晨青 → 第一秩序猩红 → 灰绝地暮紫 → 原力平衡青金**。即「金色文明衰亡于暖色战火,冷色高压中义军以暖色反攻,战后转生机色,再度赤化,终于青金平衡」——冷暖交替本身就是原力明暗两面的拉锯。全表已用 `scratchpad` 脚本按 WCAG 对 `--panel #0F172A` 实测(见每行括号),**全部 ≥6.0:1**,超出平台 4.5:1 红线,避免重蹈圣经 `db/seeds/025` 返工。

| KK | slug | 时代 | 银河纪年 | 库年份 | hex(对比度) |
|---|---|---|---|---|---|
| 01 | naboo-crisis | 纳布危机 | 32 BBY | −33…−31 | `#D9BC66`(9.64) |
| 02 | clone-wars | 克隆人战争 | 22–19 BBY | −23…−19 | `#D89A55`(7.37) |
| 03 | order-66-and-imperial-rise | 66 号令与帝国崛起 | 19 BBY | −20…−19 | `#D4826B`(6.12) |
| 04 | dark-times | 黑暗时代 | 19–5 BBY | −19…−5 | `#8FA6C8`(7.19) |
| 05 | rebel-alliance-rising | 义军同盟集结 | 5–0 BBY | −5…−1 | `#D98E62`(6.80) |
| 06 | yavin-campaign | 雅汶战役 | 0 BBY–0 ABY | −1…1 | `#E0A548`(8.20) |
| 07 | hoth-and-exile | 霍斯与流亡 | 3 ABY | 2…4 | `#8FBEDC`(8.98) |
| 08 | endor-and-the-fall | 恩多与帝国覆灭 | 4 ABY | 4…5 | `#96BE78`(8.44) |
| 09 | new-republic | 新共和国 | 5–28 ABY | 5…28 | `#72BCAC`(8.08) |
| 10 | first-order-rising | 第一秩序崛起 | 28–34 ABY | 28…34 | `#D97B7B`(6.01) |
| 11 | last-jedi | 最后绝地 | 34 ABY | 34…35 | `#B99BD8`(7.43) |
| 12 | skywalker-reborn | 天行者陨落与重生 | 35 ABY | 35…36 | `#93C9B4`(9.57) |

- 时代↔影片锚点:01=Ep I;02=Ep II+Clone Wars 剧集期;03=Ep III;04=帝国巩固期(Solo/Obi-Wan/Rebels 素材的正传侧留白);05=Andor/Rogue One 前段的正传侧背景+义军成形;06=Rogue One 结尾+Ep IV;07=Ep V;08=Ep VI;09=战后与 Ben Solo 堕落背景(Mandalorian 时段);10=Ep VII;11=Ep VIII;12=Ep IX。
- 04/09 是「宽年代低密度」时代(圣经 divided-kingdoms 先例),事件走 `time_type='range'` 宽区间;衍生 work 上线后自动填厚这两段——这正是单 work + 衍生叠加方案的结构红利。
- 年代重叠(05 与 06 在 −1 咬合)符合圣经 gospels/acts 先例;`chapter_translations` 双语 title/summary 必填;每时代题词见 [IP_AND_NAMING.md](IP_AND_NAMING.md) §3(`ERA_EPIGRAPHS` 的 key 必须与上表 slug 逐一对应,静默回退坑见 [../ARCHITECTURE.md](../ARCHITECTURE.md) §6.2)。

## 4. 银河画布:fictional 0–100 坐标系

### 4.1 坐标系约定

参照公开资料通用的银河平面图习惯(北在上、银心居中偏北,已知区域集中在东半银河):**画布 x 向东递增、y 向南递增;银心置于 (50,38)**。同心结构以银心为圆心的近似环带(供代理落点自检,非硬约束):

| 环带 | 距银心 (50,38) 半径(画布单位) |
|---|---|
| 深核/核心世界 Core | 0–10 |
| 殖民地 Colonies / 内环 Inner Rim | 10–16 |
| 扩张区 Expansion / 中环 Mid Rim | 16–34 |
| 外环 Outer Rim | 34–50 |
| 外环之外(野蛮空间,南缘) | >50 |
| 未知区域 Unknown Regions | 银河西缘 x<22(方位规则优先于半径) |

下表坐标已按此半径表逐点验算(`sqrt((x-50)^2+(y-38)^2)` 落在所属环带区间);仅两座死星(机动空间站)与贾库(正典区位本就介于内环/西境之间)为白名单例外。

坐标为**原创示意值**:方位关系取自公开百科的事实性区位描述(某行星属某环带、在银河某象限),数值本身是本项目的示意化再表达,不摹绘任何官方地图作品(IP 依据见 [IP_AND_NAMING.md](IP_AND_NAMING.md) §2)。

### 4.2 行星坐标表(36 点,P0 全量)

`locations` 写法:`layer='fictional', geom=NULL, canvas_x/canvas_y` 如下(库 CHECK 强制 0–100,`001_initial.sql:62`);`location_type` 用新增值 `planet`/`space_station`/`moon`(需在 `apps/web/src/i18n.ts` ENUMS 加双语对,否则 `missingLabels()` 测试拦截——P0 代码项,同 §6)。

| slug | 中文名 | 环带 | canvas_x | canvas_y |
|---|---|---|---|---|
| coruscant | 科洛桑 | Core | 52 | 38 |
| hosnian-prime | 霍斯尼安主星 | Core | 48 | 43 |
| alderaan | 奥德朗 | Core | 56 | 42 |
| kuat | 库阿特 | Core | 55 | 44 |
| chandrila | 钱德里拉 | Core | 51 | 34 |
| corellia | 科雷利亚 | Core | 53 | 46 |
| cato-neimoidia | 卡托内莫迪亚 | Colonies | 62 | 40 |
| jakku | 贾库 | 西境(内环边缘) | 30 | 33 |
| takodana | 塔科达纳 | Mid Rim 西 | 32 | 48 |
| ord-mantell | 奥德曼特尔 | Mid Rim 北 | 56 | 20 |
| mandalore | 曼达洛 | Outer Rim 北 | 80 | 18 |
| dantooine | 丹图因 | Outer Rim 北 | 44 | 4 |
| yavin-4 | 雅汶四号卫星 | Outer Rim 东北 | 78 | 16 |
| death-star | 死星(雅汶战场) | 机动·雅汶方位 | 80 | 19 |
| felucia | 费卢西亚 | Outer Rim 东北 | 83 | 22 |
| mon-cala | 蒙卡拉马里 | Outer Rim 东北 | 90 | 24 |
| dathomir | 达索米尔 | Outer Rim 北 | 76 | 14 |
| kashyyyk | 卡希克 | Mid Rim 东 | 70 | 38 |
| nal-hutta | 纳尔赫塔 | 赫特空间 | 84 | 52 |
| naboo | 纳布 | Mid Rim 南 | 64 | 66 |
| tatooine | 塔图因 | Outer Rim 东南 | 80 | 70 |
| geonosis | 吉奥诺西斯 | Outer Rim 东南 | 82 | 73 |
| ryloth | 赖洛思 | Outer Rim 东南 | 79 | 76 |
| kamino | 卡米诺 | 外环之外·南 | 88 | 72 |
| jedha | 杰达 | Mid Rim 南 | 61 | 60 |
| scarif | 斯卡里夫 | Outer Rim 东南 | 76 | 79 |
| d-qar | 迪卡 | Outer Rim 南 | 67 | 75 |
| sullust | 苏卢斯特 | Outer Rim 西南 | 56 | 76 |
| hoth | 霍斯 | Outer Rim 南 | 47 | 80 |
| bespin | 贝斯平 | Outer Rim 南 | 45 | 78 |
| dagobah | 达戈巴 | Outer Rim 南 | 56 | 84 |
| mustafar | 穆斯塔法 | Outer Rim 南 | 52 | 86 |
| utapau | 乌塔帕 | Outer Rim 南 | 61 | 84 |
| endor | 恩多(圣所卫星) | Outer Rim 西 | 34 | 70 |
| death-star-ii | 第二死星(恩多轨道) | 机动·恩多方位 | 36 | 68 |
| crait | 克雷特 | Outer Rim 西 | 28 | 66 |
| starkiller-base | 弑星者基地(原伊拉姆) | Unknown Regions | 20 | 28 |
| ahch-to | 阿赫托 | Unknown Regions | 9 | 30 |
| exegol | 埃克西戈尔 | Unknown Regions | 7 | 45 |

(37 行含两座死星;死星按其决战方位定点并在 summary 注明「机动战斗空间站,坐标取决战方位」。)骨架期落库后必须过 [ESTIMATE_AND_PIPELINE.md](ESTIMATE_AND_PIPELINE.md) 的画布视检门。

### 4.3 FictionalCanvas 现状与 P1 增强清单

现状(`apps/web/src/components/AtlasMap.tsx:394-434`)是霍比特人 demo 级:**硬编码一条山脉装饰 path(`:399` `className="mountains"`,放到银河语境就是错的)+ 散点 + 简单 polyline 路线**,无缩放、无背景层、标签一律 `y=-4` 居中(37 点必然互相压字)。P1 代码项(engine 级改造,收益归所有 fictional 作品):

1. **去掉硬编码山脉**:装饰层按 work 参数化(最小实现:`work.slug` → 背景组件映射;银河=同心星环 + 稀疏星点噪声,SVG 原生绘制,不引外部素材)。
2. **同心环带背景**:§4.1 的半径表画 3–4 圈低对比同心圆 + 环带名标注(双语),即「地图」质感的最大单笔提升。
3. **routes 呈现为超空间航线**:`routes` 表现成机制(`layer='fictional'`,waypoints 连 canvas 点,`AtlasMap.tsx:404-413` 已渲染 polyline)。数据侧 P0 建 4 条骨干航线(科雷利亚大道 corellian-run:corellia→naboo→tatooine;赫特空间线 hutt-space-run:nal-hutta→tatooine;义军转移线 rebel-flight:yavin-4→hoth→endor,`certainty='text_explicit'`;千年隼科舍尔航程 kessel-corridor P1 随 solo)。代码侧把 `.quest` 样式升级为虚线光带 + certainty 区分。
4. **标签防碰撞**:近邻点(tatooine/geonosis、endor/death-star-ii)标签按象限偏移;最小实现为 location 加 label 方位约定(数据侧 sort_order 奇偶即可 hack,正解是 P1 布局函数)。
5. **缩放/平移**:viewBox 变换(wheel+drag),对齐 RealMap 的交互预期;选中点 `preferredZoom` 语义映射为 viewBox 聚焦。

P0 验收底线:不做 1–5 也能上线(散点+航线可用),但 1、2、4 强烈建议随 P0 一起做——画布是本实例的第一视觉面。

## 5. 群体(13)与锚点人物(24)

### 5.1 character_groups(`a8…` 段,骨架期一次建全)

| slug | 名称 | group_type |
|---|---|---|
| jedi-order | 绝地武士团 | institution |
| sith-lineage | 西斯传承(贝恩法统) | institution |
| galactic-republic | 银河共和国 | institution |
| separatist-alliance | 分离主义联盟 | institution |
| clone-army | 克隆人大军 | institution |
| galactic-empire | 银河帝国 | institution |
| rebel-alliance | 义军同盟 | institution |
| house-of-skywalker | 天行者家族 | family |
| house-of-organa | 奥加纳家族 | family |
| naboo-royal-house | 纳布王室 | dynasty |
| smugglers-and-outlaws | 走私者与法外之徒 | circle |
| first-order | 第一秩序 | institution |
| the-resistance | 抵抗组织 | institution |

跨时代势力(jedi-order 横贯 01–12)独立成组不塞进时代,同 [../WORK_TEMPLATE.md](../WORK_TEMPLATE.md) §6「汉室朝廷」原则;每人至少 1 组(group 层零成员组不显示)。曼达洛人 `mandalorians`(tribe)留给 P2 的 the-mandalorian work,P0 的 Jango/Boba 归 smugglers-and-outlaws。

### 5.2 锚点人物(importance≥4;`reality_type` 全部 `fictional`,库默认值即对)

**别名建模是本节核心**:同一人的两个名号是**一个 character 行**,变身写进 `character_translations.aliases`(text[] 数组,圣经/示例种子现成用法)+ summary/detail 叙明转变;**绝不建两行**(两行会把 Vader↔Luke 与 Anakin↔Obi-Wan 拆成两个节点,关系图脊线断裂,还会诱发跨时代 slug 撞名)。搜索(`GlobalSearch`)按 name+aliases 命中,两个名字都可检索。

| slug | 名(zh / en) | aliases | importance | 主时代 | icon_variant |
|---|---|---|---|---|---|
| anakin-skywalker | 阿纳金·天行者 / Anakin Skywalker | 达斯·维达 / Darth Vader | 5 | 01–08 | jedi→sith(取 `sith`) |
| padme-amidala | 帕德梅·阿米达拉 / Padmé Amidala | 阿米达拉女王 / Queen Amidala | 5 | 01–03 | senator |
| obi-wan-kenobi | 欧比旺·克诺比 / Obi-Wan Kenobi | 本·克诺比 / Ben Kenobi | 5 | 01–06 | jedi |
| yoda | 尤达 / Yoda | — | 5 | 01–08 | jedi |
| sheev-palpatine | 希夫·帕尔帕廷 / Sheev Palpatine | 达斯·西迪厄斯;皇帝 / Darth Sidious; the Emperor | 5 | 01–08, 12 | sith |
| qui-gon-jinn | 魁刚·金 / Qui-Gon Jinn | — | 4 | 01 | jedi |
| mace-windu | 梅斯·温杜 / Mace Windu | — | 4 | 01–03 | jedi |
| darth-maul | 达斯·摩尔 / Darth Maul | 摩尔 / Maul | 4 | 01(衍生 04) | sith |
| count-dooku | 杜库伯爵 / Count Dooku | 达斯·泰拉纳斯 / Darth Tyranus | 4 | 02 | sith |
| general-grievous | 格里弗斯将军 / General Grievous | — | 4 | 02–03 | soldier |
| jango-fett | 詹戈·费特 / Jango Fett | — | 4 | 02 | bounty_hunter |
| ahsoka-tano | 阿索卡·塔诺 / Ahsoka Tano | — | 4 | 02(衍生主场) | jedi |
| bail-organa | 贝尔·奥加纳 / Bail Organa | — | 4 | 02–05 | senator |
| mon-mothma | 蒙·莫思马 / Mon Mothma | — | 4 | 05–09 | senator |
| grand-moff-tarkin | 塔金总督 / Grand Moff Tarkin | — | 4 | 05–06 | ruler |
| luke-skywalker | 卢克·天行者 / Luke Skywalker | — | 5 | 06–12 | jedi |
| leia-organa | 莱娅·奥加纳 / Leia Organa | 莱娅公主;奥加纳将军 / Princess Leia; General Organa | 5 | 06–12 | senator |
| han-solo | 汉·索洛 / Han Solo | — | 5 | 06–10 | smuggler |
| chewbacca | 丘巴卡 / Chewbacca | 丘伊 / Chewie | 4 | 06–12 | smuggler |
| lando-calrissian | 兰多·卡瑞辛 / Lando Calrissian | — | 4 | 07–08, 12 | smuggler |
| boba-fett | 波巴·费特 / Boba Fett | — | 4 | 07–08 | bounty_hunter |
| rey | 蕾伊 / Rey | 蕾伊·天行者 / Rey Skywalker | 5 | 10–12 | jedi |
| ben-solo | 本·索洛 / Ben Solo | 凯洛·伦 / Kylo Ren | 5 | 10–12 | sith |
| finn | 芬恩 / Finn | FN-2187 | 4 | 10–12 | soldier |

另 importance=4 候补(超出 24 表,骨架期酌情):poe-dameron(pilot)、r2-d2 / c-3po(droid,importance 4——横贯 12 幕的唯一见证者,叙事价值高)、snoke(sith)。R2/3PO 建议入表替换法:若压 24 上限,降 mace-windu→3。

### 5.3 icon_variant 新增(P0 代码项,`apps/web/src/i18n.ts` ENUMS)

`jedi: ["绝地", "Jedi"]`、`sith: ["西斯", "Sith"]`、`droid: ["机器人", "Droid"]`、`pilot: ["飞行员", "Pilot"]`、`senator: ["议员", "Senator"]`、`smuggler: ["走私者", "Smuggler"]`、`bounty_hunter: ["赏金猎人", "Bounty hunter"]`;`planet: ["行星", "Planet"]`、`moon: ["卫星", "Moon"]`、`space_station: ["空间站", "Space station"]`(location_type)。`ruler/soldier/queen` 沿用。漏加即 `missingLabels()` 测试红灯。

## 6. P0 代码改动汇总(数据之外的全部)

| # | 位置 | 改动 |
|---|---|---|
| 1 | `db/migrations/004_fictional_layer_open.sql`(新) | DROP `works` 的 hobbit CHECK(§1.2) |
| 2 | `apps/web/src/profile.ts`(新)+ `state.ts:47-48` | `WORK_PROFILE = { kind: "locked-single", slug: "skywalker-saga", yearLabels: {…} }`(§2.2 路 B;locked-single 泛化本就是 [../ARCHITECTURE.md](../ARCHITECTURE.md) §5.3 计划项) |
| 3 | `apps/web/src/i18n.ts` | formatYear 第三参 + 4 调用点(§2.2);ENUMS 新增词条(§5.3);UI.title/tagline 等品牌 key(命名见 [IP_AND_NAMING.md](IP_AND_NAMING.md) §1) |
| 4 | `apps/web/src/epigraphs.ts` | 按 §3 slug 重写 12 条 ERA_EPIGRAPHS + 欢迎/加载/页脚(文案与版权规则见 [IP_AND_NAMING.md](IP_AND_NAMING.md) §3) |
| 5 | `apps/web/index.html` + `styles.css` | title/og/描述 + 免责声明落点(IP §1.3);`--accent` 换 `#C9B45A` 系,结构令牌不动 |
| 6 | `apps/web/src/components/AtlasMap.tsx` | FictionalCanvas 增强(§4.3;其中 1/2/4 建议随 P0) |
| 7 | `apps/api/src/bake-static.ts:25` + `deploy/deploy-static.sh:39/48` | workSlugs=`["skywalker-saga"]`;断言与托管项目名换新 |
