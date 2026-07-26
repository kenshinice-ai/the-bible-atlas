# 神圣品牌重塑实施方案(Sacred Rebrand Plan)

评审人:liturgical-design-director(圣公会牧师 × 设计总监)
日期:2026-07-27
范围:本项目已决定只服务于圣经。本文档给出可直接照做的实施方案——命名、经文融入、界面文案、视觉令牌、Bible-only 化与优先级。**本文档只是方案,未改动任何代码。**

评审依据(已通读):`docs/HANDOFF.md`、`apps/web/index.html`、`apps/web/src/i18n.ts`、`apps/web/src/styles.css`、`apps/web/src/App.tsx`、`apps/web/src/components/` 全部七个组件;数据库 `chapters` 表 13 个圣经时代(work `the-bible`,launch_rank 1)。

总原则(贯穿全文):

- **牧者之眼**:一切经文引用只用公有领域译本——中文**和合本(1919)**、英文 **KJV**;以「经文记载」的中立口吻呈现,不做信仰断言;称谓地名遵和合本惯例。
- **设计师之眼**:神圣感来自秩序、光与留白,不来自贴图与花纹;现有暗色系统是**演进对象而非推翻对象**;对比度 ≥ 4.5:1、触控 ≥ 44px、`prefers-reduced-motion` 三条红线不动。

---

## 一、命名

### 牧者之眼

产品的本质是「按时代、人物、地土展开经文记载」。名称须庄重、准确、不僭越:不可暗示本品是圣经本身的权威解读(避免「正解」「真道」类字眼),也不宜用营销化的「全景大揭秘」语体。中文传统里,「舆图」是古典的地图总称(《皇舆全览图》),「通鉴」承《资治通鉴》的编年通览传统——两者都自带典籍的重量,与和合本的语感相配。

### 设计师之眼

名称要能直接坐进现有的衬线 `--font-display` 标题层,中英并置时字形均衡;英文名要可检索、可读、不与现有知名产品混淆;副标题承担功能说明,主名承担气质。

### 三个候选

| # | 中文 | 英文 | 意涵与风险 |
|---|------|------|-----------|
| A | **圣经舆图** | **The Bible Atlas** | 「舆图」古雅、直指产品形态(地图集);英文朴素诚实、可检索。风险:英文名较常见,靠副标题区分。 |
| B | 圣经通鉴 | The Bible Chronicle | 「通鉴」有"全方面通览"意涵,承编年史传统,最贴「全方面解读」;但产品核心是空间地图,「鉴」不含地图义,英文 Chronicle 也偏时间轴。 |
| C | 圣言时空 | The Word in Time and Place | 「圣言」庄重,「时空」现代;但「圣言」(Logos)在神学上特指基督/道,用作产品名有僭越之嫌,牧者之眼持保留意见。 |

### 最终推荐:A《圣经舆图 · The Bible Atlas》

理由:(1) 名实相符——产品第一形态是地图,舆图二字既古典又准确;(2) 中立——不做解读权威的暗示,只说"这是一卷图";(3) 中英对仗工整,`--font-display` 下「圣经舆图」四字宋体极稳;(4) C 案的神学风险与 B 案的形态错位都可避免。

### 副标题 / Tagline

主 tagline(品牌层,庄重、有经文回声但不是引文):

> **中文:从起初,直到地极**
> **英文:From the Beginning to the Ends of the Earth**

——首尾呼应创世记 1:1(起初)与使徒行传 1:8(直到地极),恰是本库 13 个时代的实际跨度;不加引号、不标章节,属品牌语而非经文引用,故不构成断章。

功能副标题(界面 eyebrow 层,说明交互):

> 中文:按时代、群体与人物,逐层展开经文的时空
> 英文:The Scriptures unfolded — era by era, group by group, person by person

---

## 二、经文融入方案(核心)

### 牧者之眼

选节三条标准:(1) 最能概括该时代的属灵主题;(2) 语言最典雅(和合本原文本身就是标准);(3) 尽量出自该时代对应的书卷(chapters 表的 `reference_label`),使「时代题词」与「时代经卷」互证。凡节选必注「节选」;引文一律带书卷章节与译本名;呈现口吻是「经文记载」,不是布道。**空状态与错误态不放经文**——经文不可作失败提示的装饰,这是底线(详见第三节)。

### 设计师之眼

题词是排版事件,不是数据字段:统一以 blockquote 形式呈现,`--font-display` 衬线、1.02–1.08rem、`--text-dim` 色、上方或左侧一条 2px 圣金短线(`--accent-deep`),出处右对齐 `--muted` 小字。中文引文用「」全角引号,英文用正体加引号;不用斜体(中文无斜体传统,伪斜体是排版事故)。

### 13 个时代题词(era epigraphs)

数据落点:新建 `apps/web/src/epigraphs.ts`,以 chapter slug 为 key、`[zh, zhRef, en, enRef]` 为值(不动数据库,前端常量即可;P2 再考虑迁入 `chapters` 表)。

| 时代 slug | 和合本(1919) | KJV | 出处 |
|---|---|---|---|
| `primeval` | 起初,神创造天地。 | In the beginning God created the heaven and the earth. | 创世记 1:1 / Genesis 1:1 |
| `patriarchs` | 我必叫你成为大国。我必赐福给你,叫你的名为大;你也要叫别人得福。 | And I will make of thee a great nation, and I will bless thee, and make thy name great; and thou shalt be a blessing. | 创世记 12:2 / Genesis 12:2 |
| `exodus-and-sinai` | 我向埃及人所行的事,你们都看见了,且看见我如鹰将你们背在翅膀上,带来归我。 | Ye have seen what I did unto the Egyptians, and how I bare you on eagles' wings, and brought you unto myself. | 出埃及记 19:4 / Exodus 19:4 |
| `wilderness-and-conquest` | 你当刚强壮胆!不要惧怕,也不要惊惶;因为你无论往哪里去,耶和华你的神必与你同在。(节选) | Be strong and of a good courage; be not afraid, neither be thou dismayed: for the LORD thy God is with thee whithersoever thou goest. (excerpt) | 约书亚记 1:9 / Joshua 1:9 |
| `judges` | 那时,以色列中没有王,各人任意而行。 | In those days there was no king in Israel: every man did that which was right in his own eyes. | 士师记 21:25 / Judges 21:25 |
| `united-monarchy` | 你的家和你的国必在我面前永远坚立。你的国位也必坚定,直到永远。 | And thine house and thy kingdom shall be established for ever before thee: thy throne shall be established for ever. | 撒母耳记下 7:16 / 2 Samuel 7:16 |
| `divided-kingdoms` | 你们心持两意要到几时呢?若耶和华是神,就当顺从耶和华;若巴力是神,就当顺从巴力。(节选) | How long halt ye between two opinions? if the LORD be God, follow him: but if Baal, then follow him. (excerpt) | 列王纪上 18:21 / 1 Kings 18:21 |
| `prophetic-narrative` | 何况这尼尼微大城,其中不能分辨左手右手的有十二万多人,并有许多牲畜,我岂能不爱惜呢? | And should not I spare Nineveh, that great city, wherein are more than sixscore thousand persons that cannot discern between their right hand and their left hand; and also much cattle? | 约拿书 4:11 / Jonah 4:11 |
| `judah-and-exile` | 我们不致消灭,是出于耶和华诸般的慈爱;是因他的怜悯不致断绝。每早晨,这都是新的;你的诚实极其广大! | It is of the LORD's mercies that we are not consumed, because his compassions fail not. They are new every morning: great is thy faithfulness. | 耶利米哀歌 3:22–23 / Lamentations 3:22–23 |
| `return-and-restoration` | 当耶和华将那些被掳的带回锡安的时候,我们好像做梦的人。 | When the LORD turned again the captivity of Zion, we were like them that dream. | 诗篇 126:1 / Psalm 126:1(回归朝圣之诗,主题恰切,故破例取自诗篇) |
| `gospels` | 我报给你们大喜的信息,是关乎万民的;因今天在大卫的城里,为你们生了救主,就是主基督。(节选) | I bring you good tidings of great joy, which shall be to all people. For unto you is born this day in the city of David a Saviour, which is Christ the Lord. (excerpt) | 路加福音 2:10–11 / Luke 2:10–11(该时代经卷为马太—路加,故不取约翰福音) |
| `acts` | 但圣灵降临在你们身上,你们就必得着能力,并要在耶路撒冷、犹太全地,和撒玛利亚,直到地极,作我的见证。 | But ye shall receive power, after that the Holy Ghost is come upon you: and ye shall be witnesses unto me both in Jerusalem, and in all Judaea, and in Samaria, and unto the uttermost part of the earth. | 使徒行传 1:8 / Acts 1:8(对一张地图应用而言,这是全库最切题的一节) |
| `pauline-mission` | 那美好的仗我已经打过了,当跑的路我已经跑尽了,所信的道我已经守住了。 | I have fought a good fight, I have finished my course, I have kept the faith. | 提摩太后书 4:7 / 2 Timothy 4:7 |

### 站点级经文

| 用途 | 和合本 | KJV | 出处 | 落点 |
|---|---|---|---|---|
| 欢迎(hero 区,未选时代时) | 求你开我的眼睛,使我看出你律法中的奇妙。 | Open thou mine eyes, that I may behold wondrous things out of thy law. | 诗篇 119:18 / Psalm 119:18 | `App.tsx` hero 内 blockquote |
| 加载中 1 | 你的话是我脚前的灯,是我路上的光。 | Thy word is a lamp unto my feet, and a light unto my path. | 诗篇 119:105 / Psalm 119:105 | `App.tsx` Skeleton |
| 加载中 2 | 你的言语一解开就发出亮光。(节选) | The entrance of thy words giveth light. (excerpt) | 诗篇 119:130 / Psalm 119:130 | 同上,轮换 |
| 加载中 3 | 我的心哪,你当默默无声,专等候神。(节选) | My soul, wait thou only upon God. (excerpt) | 诗篇 62:5 / Psalm 62:5 | 同上,轮换(等候之诗,最配加载态) |
| 全站页脚 | 草必枯干,花必凋残,惟有我们神的话必永远立定。 | The grass withereth, the flower fadeth: but the word of our God shall stand for ever. | 以赛亚书 40:8 / Isaiah 40:8 | `App.tsx` footer 顶部 |

呈现格式(两种语言各自完整,不混排):

```
「起初,神创造天地。」
                         ——创世记 1:1(和合本)

"In the beginning God created the heaven and the earth."
                         — Genesis 1:1 (KJV)
```

交互位置:选中某时代(era-rail 或时间轴 era band)后,题词出现在 hero 与 filter-bar 之间(或并入 filter-bar 上方一行),随时代切换淡入(180ms,`prefers-reduced-motion` 下无动画);未选时代时 hero 显示欢迎节(诗 119:18)。

---

## 三、界面文案圣化清单(`apps/web/src/i18n.ts`)

### 牧者之眼

原则:**功能文案保持功能,气质文案提升气质**。错误、限额、校验类文案不圣化(「加载失败」就该是加载失败);描述性、栏目性文案向和合本语感靠拢;凡涉及称谓,以和合本为准(王、先知、祭司、士师、门徒、族长)。「文学意义」一词在 Bible-only 语境下确不得体——圣经于本品是经文与历史地理的对象,不是"文学名著"之一。

### 设计师之眼

逐 key 改,不新增 key 结构;改动后跑现有 `missingLabels()` 测试即可回归。以下为**需改动的全部 key**(未列出的保持原样):

#### `UI` 表

| key | 现值(zh / en) | 新值(zh / en) | 说明 |
|---|---|---|---|
| `title` | 世界文学名著时空地图 / World Literature Atlas | **圣经舆图 / The Bible Atlas** | 品牌主名 |
| `tagline` | 按时代、人物群与个人逐层展开 / Explore era by era… | **从起初,直到地极 / From the Beginning to the Ends of the Earth** | eyebrow 改为品牌 tagline;功能说明移入 hero 的 `multiHint` 位或省略 |
| `significance` | 意义 / Significance | **经文意义 / Significance in Scripture** | 事件抽屉栏目 |
| `literarySignificance` | 文学意义 / Literary significance | **经文脉络 / Scriptural context** | 地点抽屉栏目;"文学"一词退场 |
| `modernStatus` | 现代状态 / Present-day status | **今日现状 / Present day** | 更自然 |
| `sources` | 来源与数据说明 / Sources and data notes | **出处与数据说明 / Sources and data notes** | 「出处」兼容经文出处与学术来源 |
| `copy` | 复制深链接 / Copy deep link | **复制此景链接 / Copy link to this view** | 「深链接」是工程词 |
| `searchEverything` | 搜索人物、事件、地点… / Search people, events, places… | **寻访人物、事件与地点… / Search people, events, places…** | 「寻访」典雅而不做作;英文保持朴素 |
| `trajectory` | 人物轨迹 / Person trajectory | **人物行迹 / Person's journeys** | 「行迹」近和合本语感(「行路」「脚踪」) |
| `showTrajectory` | 显示所选人物轨迹 / Show the selected person's trajectory | **显示所选人物的行迹 / Show the selected person's journeys** | 同上 |
| `graphLevelGroup` | 人物群 / Groups | **群体 / Groups** | 与支派/群体 enum 一致 |
| `fitAll` | 回到全部范围 / Fit everything | **回看全境 / Fit the whole land** | 「全境」带地土感,不做作 |
| `aliases` | 别名 / Also called | **又名 / Also called** | 和合本惯用「又名」「又叫」 |
| `dataNote` | 模糊年代与推定地点会明确标记;摘要为原创结构化描述。 / … | **凡近似年代与推定地点均已明确标注;摘要为原创结构化描述,悉以经文记载为本。 / Uncertain dates and inferred places are explicitly marked; summaries are original structured descriptions following the scriptural record.** | 声明中立口吻 |
| `emptyList` | 当前筛选没有内容 / Nothing matches the current filter | 保持不变 | **牧者裁定:空态与错误态不配经文、不圣化**——经文不作失败提示的装饰 |
| `loading` / `error` / `retry` | — | 保持不变 | 同上;加载态的经文由 Skeleton 的题词区承担,`loading` 键本身仍是「载入中」 |

新增 key(供题词组件与页脚使用):

| 新 key | zh | en |
|---|---|---|
| `epigraphSourceSuffix` | (和合本) | (KJV) |
| `scriptureNote` | 经文引用:中文和合本(1919),英文 King James Version;均为公有领域译本。 | Scripture quotations: Chinese Union Version (1919) and King James Version, both in the public domain. |

(`scriptureNote` 置于 footer `dataNote` 之后——版本声明既是诚实,也是敬意。)

#### `ENUMS` 表(称谓核对,和合本惯例)

| key | 现值(zh) | 新值(zh) | 依据 |
|---|---|---|---|
| `king` | 君主 | **王** | 和合本通例「大卫王」「所罗门王」;en 保持 King |
| `missionary` | 宣教者 | **宣教士** | 通行译名;en 保持 Missionary |
| `soldier` | 军事人物 | **勇士** | 和合本「大能的勇士」(士 6:12);en 改 **Warrior** |
| `lawgiver` | 律法者 | **颁律法者** | 更准确(摩西);en 保持 Lawgiver |
| `religious_site` | 宗教场所 | **圣所** | 和合本「圣所」通指殿、坛、会幕;en 改 **Sanctuary** |
| `religious`(事件类型) | 宗教 | **敬拜与立约** | 圣经语境下事件多为献祭、立约、奉献;en 改 **Worship & covenant** |

维持不变但曾考虑过的:`judge` 士师(正确)、`patriarch` 族长(正确)、`prophet/priest/disciple`(正确)、`supernatural` 超自然(保持中立,不改「属天者」)、`fictional_narrative` 等 reality 标签(数据中立性标签,不因 Bible-only 而删,士师记里的寓言与异象仍需要它们)。

`formatYear` 的「公元前/公元」**保持不变**——牧者之眼承认「主前/主后」是教会出版传统,但产品持中立口吻,公元纪年是学术通例;P2 可评估做用户偏好开关,不进 P0。

Bible-only 后**隐藏但暂不删除**的 key(见第五节):`single`、`multi`、`primary`、`limitReached`、`keepOne`、`mixedLayers`、`unknownWork`、`multiHint`、`workPicker`、`searchWorks`、`allCategories`、`kindWork`。

---

## 四、视觉令牌调整(`apps/web/src/styles.css`)

### 牧者之眼

现有暗色已有烛光金(`--accent`),方向正确;需要的是把底色从偏紫的夜色移向**深夜靛蓝**(圣所夜祷的天色),把紫罗兰的"文学奇幻感"收敛为靛蓝的"星夜秩序感",金色保持克制——金是点睛(焦点、选中、题词短线),不是铺陈。

### 设计师之眼

逐令牌给值。所有文字/背景组合的对比度已实测(WCAG 相对亮度法),标注于表;**全部 ≥ 4.5:1**(装饰性图形元素只需 ≥ 3:1,亦全部达标)。

#### 4.1 核心令牌表(`:root`,styles.css 第 8–60 行)

| 令牌 | 现值 | 新值 | 对比度(实测) |
|---|---|---|---|
| `--bg` | `#0d111b` | **`#0B1120`** | 页面底,深夜靛蓝(#0F172A 系加深一档,给 panel 留层次) |
| `--bg-raise` | `#141724` | **`#131C31`** | — |
| `--panel` | `#171a29` | **`#0F172A`** | 设计基准色本尊落在 panel 层 |
| `--panel-raise` | `#1e2133` | **`#182238`** | — |
| `--overlay` | `rgba(19,21,33,.94)` | **`rgba(11,17,32,.94)`** | — |
| `--line` | `#363150` | **`#2E3A55`** | 靛蓝化边线 |
| `--line-soft` | `#2a2740` | **`#24304A`** | — |
| `--text` | `#ece7f1` | **`#EDE9E0`** | 羊皮纸暖白;**14.74:1** on `--panel`,15.54:1 on `--bg` |
| `--text-dim` | `#c8c2d4` | **`#C7C9D3`** | **10.82:1** on `--panel`,9.60:1 on `--panel-raise` |
| `--muted` | `#a9a2b8` | **`#A6A9B8`** | **7.64:1** on `--panel`,6.79:1 on `--panel-raise` |
| `--faint` | `#8d86a0` | **`#8B8FA3`** | **5.57:1** on `--panel`,5.29:1 on `--bg-raise` |
| `--accent` | `#f3c969` | **`#F5C15D`** | 烛光金(焦点/选中);**10.77:1** on `--panel`,9.56:1 on `--panel-raise` |
| `--accent-strong`(新增) | — | **`#F59E0B`** | 圣金,地图簇/强调图形;**8.31:1** on `--panel` |
| `--accent-deep` | `#c9972e` | **`#D97706`** | 琥珀,题词短线/大号图形/圣经主题色;**5.60:1** on `--panel`(作正文文字仍达标,但约定只用于 ≥1rem 或图形) |
| `--violet` | `#8b74c9` | **`#7189CC`** | 第二色相由紫罗兰转靛青(图形用;5.23:1 on `--panel`) |
| `--violet-soft` | `#c5a9ff` | **`#A8B6E8`** | 链接色;**8.94:1** on `--panel`,8.50:1 on `--bg-raise` |
| `--positive` | `#5fbf9c` | 不变 | 7.61:1 on `--bg-raise` |
| `--negative` | `#e0656f` | 不变 | 5.06:1 on `--bg-raise` |
| `--mixed` | `#d9a55f` | 不变 | 7.67:1 on `--bg-raise` |
| `--neutral-rel` | `#8d879b` | **`#8B8FA3`** | 与 `--faint` 并轨 |
| `--font-display` / `--font-body` | 现值 | **不变** | 离线系统栈策略维持;Georgia→Songti 的中西文回退顺序正确 |

变量名 `--violet`/`--violet-soft` 语义已偏,若愿意付出全文件重命名成本,P1 时改为 `--indigo`/`--link`;P0 只改值不改名。

#### 4.2 状态与散点值(styles.css 中的硬编码,随令牌一并调)

| 位置 | 现值 | 新值 | 说明 |
|---|---|---|---|
| `body` 渐变(66–70 行) | `#262047` / `#1d2a3a` | **`#1C2646`** / **`#10233A`**,并可加第三层烛光:`radial-gradient(700px 300px at 50% 112%, rgba(217,119,6,0.07), transparent 60%)` | 页底一线极淡暖光,烛照隐喻;透明度 ≤0.07,反装饰原则内 |
| hover 边线(131/177 行等 `#4b4568`) | `#4b4568` | **`#47557A`** | 靛蓝化 |
| `::selection`(94 行) | `#5c4a88` | **`background:#D97706; color:#0B1120`** | 选中即受光;5.9:1 |
| 滚动条(95–97 行 `#453f60`) | `#453f60` | **`#3A4560`** | — |
| `.locale button.active` / `.mode button.active` / `.graph-tiers button.active` / `.timeline-modes button.active`(`#655296`/`#5c4a88`) | 紫底 | **`#2C3E66`**(靛蓝底,白字 9.2:1);或保持结构不动、仅由 `--violet` 带动 | 激活态从"紫"改"靛" |
| `.filter-bar`(288–303 行 `#4f4430`/`#221d15`) | 琥珀暗盒 | 边 **`#5A4A26`**、底 **`#221A0C`**、chip 文字 **`#F2DFB2`** | **13.08:1**;此栏本就是金系,微调即可 |
| `.era-label`(629 行) | `fill:#14101c` | **`fill:#1C1917`** | 暖墨色,配合下方新时代色全部 ≥4.5:1 |
| 焦点态(87–92 行) | `outline:3px solid var(--accent)` | 不变 | 金色焦点环即"光"的语言,10.77:1 |
| `.atlas-marker.selected`(439 行 `#ffd36d`)、`.timeline-node.selected`(640 行) | `#ffd36d` | **统一为 `var(--accent)` `#F5C15D`** | 消灭散点金 |

#### 4.3 时代 accent_color:是否改成「礼仪年色系」?

**牧者之眼:不建议照搬礼仪年色。** 礼仪年只有紫、白/金、绿、红、玫瑰五色,无法区分 13 个时代;且礼仪色属教会年历的神学框架,强加给一个持中立口吻的经文地图会构成隐性的宗派表态。现有 13 色本身已是一条有神学直觉的叙事弧:创世的尘土色 → 列祖至旷野的金赭 → 王国的赤红 → 被掳的紫 → 福音的天青 → 宣教的橄榄绿,**弧线应保留**。

**设计师之眼:但现值必须重调明度。** 实测现有 13 色中 9 个与时间轴 `.era-label` 深色字对比 <4.5:1(最差 `#58507e` 仅 2.56:1),在新靛蓝底上也普遍 <4.5:1。建议保持色相弧、统一提升明度,新值全部实测 ≥4.75:1(对 `#1C1917` 标签字)且 ≥4.5:1(对 `#0F172A` 底):

| sequence | slug | 现值 | **建议值** | 对标签字 | 对底色 |
|---|---|---|---|---|---|
| 1 | primeval | `#7a6a52` | **`#B5A588`** | 7.25 | 7.40 |
| 2 | patriarchs | `#c9972e` | **`#D9A441`** | 7.78 | 7.94 |
| 3 | exodus-and-sinai | `#b8863a` | **`#D18E3F`** | 6.37 | 6.51 |
| 4 | wilderness-and-conquest | `#a8763f` | **`#C67F45`** | 5.43 | 5.55 |
| 5 | judges | `#9c6a44` | **`#BE7350`** | 4.79 | 4.89 |
| 6 | united-monarchy | `#b5544a` | **`#CF6B67`** | 4.96 | 5.06 |
| 7 | divided-kingdoms | `#a04a52` | **`#CE7080`** | 5.21 | 5.32 |
| 8 | prophetic-narrative | `#8c4a63` | **`#BC7492`** | 5.04*(取 `#BE7695` 则 5.18)* | 5.14 |
| 9 | judah-and-exile | `#6f4a70` | **`#A277AC`** | 4.81 | 4.91 |
| 10 | return-and-restoration | `#58507e` | **`#8B7EC0`** | 4.87 | 4.97 |
| 11 | gospels | `#46618a` | **`#7189CC`** | 5.12 | 5.23 |
| 12 | acts | `#3d7286` | **`#5E9CC0`** | 5.82 | 5.94 |
| 13 | pauline-mission | `#3a8177` | **`#57AB9C`** | 6.42 | 6.55 |

落点:一条幂等 SQL(P1,建议入 `db/seeds/024_bible_era_accent_retune.sql` 并登记 `seed_history`):

```sql
UPDATE chapters SET accent_color = v.color
FROM (VALUES
  ('primeval','#B5A588'),('patriarchs','#D9A441'),('exodus-and-sinai','#D18E3F'),
  ('wilderness-and-conquest','#C67F45'),('judges','#BE7350'),('united-monarchy','#CF6B67'),
  ('divided-kingdoms','#CE7080'),('prophetic-narrative','#BC7492'),('judah-and-exile','#A277AC'),
  ('return-and-restoration','#8B7EC0'),('gospels','#7189CC'),('acts','#5E9CC0'),
  ('pauline-mission','#57AB9C')
) AS v(slug, color)
WHERE chapters.slug = v.slug
  AND chapters.work_id = '10000000-0000-4000-8000-000000000005';
```

#### 4.4 题词组件样式(新增,P0)

```css
.epigraph {
  margin: 4px 0 var(--gap-m); padding-left: 14px;
  border-left: 2px solid var(--accent-deep);
}
.epigraph blockquote {
  margin: 0; font-family: var(--font-display);
  font-size: 1.05rem; line-height: 1.7; color: var(--text-dim); /* 10.82:1 */
}
.epigraph cite {
  display: block; text-align: right; font-style: normal;
  color: var(--muted); font-size: 0.8rem; margin-top: 4px; /* 7.64:1 */
}
```

---

## 五、Bible-only 化

### 牧者之眼

其余四部作品与圣经并列陈列,恰是旧品牌「名著之一」的残留;既已定意专奉一经,界面上不应再出现"把圣经和《双城记》放进同一个购物车"的隐喻。但**不删数据、不删代码路径**——数据无罪,去留是产品决策,回退成本应保持为零。

### 设计师之眼(具体处置)

P0 采用**前端锁定**,不动 API 与数据库:

1. **`apps/web/src/state.ts`**:新增常量 `export const BIBLE_ONLY = true;` 与 `const BIBLE_SLUG = "the-bible";`。`parseAtlasState()` 在 BIBLE_ONLY 下强制 `works: [BIBLE_SLUG], active: BIBLE_SLUG, mode: "single"`(无视 URL 中的 `works` 参数——旧深链接静默归正,不报错;`unknownWork` 校验路径自然失活)。
2. **`apps/web/src/App.tsx`**:BIBLE_ONLY 下不渲染 `<WorkControlCenter>`(174–180 行)与 compare-bar(191–200 行);hero 的 `badge`(204 行,「历史文献」)保留——它是中立口吻的一部分。
3. **`apps/web/src/components/GlobalSearch.tsx`**:BIBLE_ONLY 下过滤 `kind === "work"` 的搜索结果(隐藏「作品」类结果与 `kindWork` chip)。
4. **`WorkControlCenter.tsx` 本体不改不删**,由 App 层决定是否渲染;i18n 相关 key 保留(第三节清单)。
5. **`apps/web/index.html`** 全量更新:

```html
<!doctype html><html lang="zh-CN"><head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1"/>
<meta name="description" content="圣经舆图——圣经的时空全景:十三个时代、二百余位人物、四百余件事件与一百余处地点,依经文记载绘于一图,中英双语。The Bible Atlas: a bilingual atlas of the Scriptures — every era, person, event and place, mapped in time and space."/>
<meta name="theme-color" content="#0B1120"/>
<meta property="og:title" content="圣经舆图 · The Bible Atlas"/>
<meta property="og:description" content="从起初,直到地极——圣经的时空全景。From the Beginning to the Ends of the Earth."/>
<title>圣经舆图 · The Bible Atlas</title>
</head><body><div id="root"></div><script type="module" src="/src/main.tsx"></script></body></html>
```

P1:API `GET /works` 支持 `launch_rank=1` 过滤或前端只请求 `the-bible`,减少无谓载荷。
P2:决定其余四部作品数据的归宿(归档 schema 或导出后移除);彼时再删多作品 UI 代码路径与 i18n key。

---

## 六、实施优先级

### P0(本次必做:命名 + 文案 + 令牌 + 经文题词 + Bible-only 锁定)

| # | 事项 | 涉及文件 |
|---|---|---|
| 1 | 品牌名与 tagline 落地(`title`/`tagline` key) | `apps/web/src/i18n.ts` |
| 2 | index.html 标题/描述/meta/og/theme-color | `apps/web/index.html` |
| 3 | 界面文案圣化(第三节 UI 表 + ENUMS 表全部改动;跑 `missingLabels` 回归) | `apps/web/src/i18n.ts`、`apps/web/src/i18n.test.ts`(如快照需更新) |
| 4 | 视觉令牌:4.1 核心表 + 4.2 散点值 + 4.4 题词样式 | `apps/web/src/styles.css` |
| 5 | 经文数据文件(13 时代题词 + 欢迎 + 加载 ×3 + 页脚,中英四元组) | 新建 `apps/web/src/epigraphs.ts` |
| 6 | 题词渲染:选中时代显示题词、未选显示欢迎节、footer 加以赛亚书 40:8 与 `scriptureNote`、Skeleton 加载轮换诗句 | `apps/web/src/App.tsx`(hero/filter-bar 之间、footer、Skeleton) |
| 7 | Bible-only 锁定(隐藏作品切换器、compare-bar、搜索的作品类结果) | `apps/web/src/state.ts`、`apps/web/src/App.tsx`、`apps/web/src/components/GlobalSearch.tsx` |
| 8 | HANDOFF 更新并随改动提交(项目纪律) | `docs/HANDOFF.md` |

### P1(近期)

| # | 事项 | 涉及文件 |
|---|---|---|
| 1 | 时代 accent_color 重调(4.3 表)+ `.era-label` 墨色 + 浏览器三视图重验 | 新建 `db/seeds/024_bible_era_accent_retune.sql`、`apps/web/src/styles.css` |
| 2 | `--violet` → `--indigo`/`--link` 变量重命名 | `apps/web/src/styles.css` 全文件 |
| 3 | works 请求收敛为仅 `the-bible` | `apps/web/src/api.ts` 或 `apps/api/src/`(routes) |
| 4 | 人名地名称谓全库核对脚本(与和合本对照:示剑、别是巴、该撒利亚等) | `db/` 下新审计脚本;`translations` 相关表 |
| 5 | 题词经文与 `chapters.reference_label` 一并入库(替代前端常量) | `chapters` 表迁移 + `apps/api` |

### P2(远期)

| # | 事项 | 涉及文件 |
|---|---|---|
| 1 | 「主前/主后 vs 公元前/公元」用户偏好开关 | `apps/web/src/i18n.ts`(`formatYear`)、`state.ts` |
| 2 | 其余四部作品数据归档决策;删除多作品代码路径与 i18n key | `apps/web/src/components/WorkControlCenter.tsx`、`state.ts`、`i18n.ts`、`db/` |
| 3 | 地图底图评估:更古典、无现代标注的暗色底图(仍须离线/自托管友好) | `apps/web/src/components/AtlasMap.tsx` |
| 4 | 媒体资产(`media_assets` 现为 0):圣地地貌、古卷插图——在"反贴图堆砌"原则下逐项评审 | `db/`、`EntityDrawer.tsx` |
| 5 | 可选地球仪模式(既有远期规划,配合新品牌再审) | — |

---

## 附:对比度实测方法

WCAG 2.x 相对亮度公式,脚本化计算(见评审过程);所有"新值"列出的组合均为实测值,非估算。文字类组合最低 4.79:1(judges 时代标签),普通正文组合均 ≥ 5.5:1,核心正文 ≥ 10:1。
