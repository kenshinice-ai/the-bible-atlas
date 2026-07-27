# IP 与命名:银河舆图的版权/商标边界(硬前提)

> 本文件是 Star Wars 实例与圣经(公有领域文本)、三国(公有领域文本)的**根本差异**:内容与商标均为 Disney/Lucasfilm 的在保护期资产,且权利方以积极维权著称。本文的每条边界都优先于 [SAGA_BLUEPRINT.md](SAGA_BLUEPRINT.md) 的内容设计;IP 审读阶段(替代圣经的神职审计)见 [ESTIMATE_AND_PIPELINE.md](ESTIMATE_AND_PIPELINE.md) §3。
> 本文为工程决策依据,不构成法律意见;若项目走向公开运营,应过一次真人法律审阅。

## 1. 命名:不能用「Star Wars Atlas / 星球大战舆图」作产品名

### 1.1 风险分析

- **「Star Wars」「星球大战」是注册商标**(Lucasfilm Ltd.,覆盖娱乐与出版类别)。把商标放进产品名(尤其打头)构成「商标性使用」,易被认定造成来源混淆——用户会以为是官方产品。这与圣经(「圣经」非商标)和三国(古籍名)完全不同。
- **指称性合理使用(nominative fair use)允许的是「提及」而非「冠名」**:说明文字里写「本站为《星球大战》系列的非官方参考」是允许的;产品名叫「Star Wars Atlas」不是。
- 主要角色名/专名(Darth Vader、Jedi 等)亦有商标注册,同理:可在**内容数据**中作事实性指称,不可进入产品名、logo、域名。
- 域名同理:不注册含 starwars 字样的域名。

### 1.2 命名建议

- **产品名(推荐)**:中文「银河舆图」,英文「Galaxy Atlas」,副题采用指称性说明:「银河舆图——天行者九部曲非官方检索图集 / Galaxy Atlas: an unofficial reference to the Skywalker saga」。「舆图」延续平台家族命名(圣经舆图/三国舆图);「Skywalker saga」在副题里属于描述性指称原作对象,置于「unofficial reference to」之后,是指称性使用的标准姿势。
- 备选:「原力纪年图集 / The Galactic Chronicle Atlas」(完全不含专名,最保守)。
- work slug `skywalker-saga`、内部包名、数据库常量:描述性小写,不含 star-wars 字样(见 [SAGA_BLUEPRINT.md](SAGA_BLUEPRINT.md) §1.1)。
- **不做**:仿官方字体的 logo(Star Wars 标志字体本身是受保护的商标外观)、开场爬行字幕式排版(强关联的商业外观)、Aurebesh 装饰性使用。

### 1.3 免责声明(必须,双语,两处落点)

落点:① `apps/web/index.html` 的 meta description 尾句;② 页脚常驻(`apps/web/src/i18n.ts` 的 `UI.dataNote`/`scriptureNote` 位改写为本声明,页脚每页可见)。文案:

> **中**:本站为非官方、非商业的粉丝参考项目,与 Lucasfilm Ltd.、The Walt Disney Company 及其关联方均无隶属、授权或背书关系。Star Wars 及相关名称、标志为其各自权利人的商标;本站仅以事实性方式指称原作内容,全部条目文字为本站原创转述。
>
> **EN**: This is an unofficial, non-commercial fan reference project. It is not affiliated with, sponsored, or endorsed by Lucasfilm Ltd., The Walt Disney Company, or their affiliates. Star Wars and all related names and marks are trademarks of their respective owners; they appear here only as factual references, and all entry text is original writing by this project.

## 2. 内容边界:事实可用,表达不可抄

版权保护**表达**不保护**事实**。Wookieepedia 式的事实性参考(某角色在某年于某星球做了某事、某行星位于外环)可以作为研究输入;但落库文字必须遵守:

1. **全部 summary/detail/significance/motivation 为原创转述**。禁止从影片字幕、官方小说、官方百科、Wookieepedia 条目复制成句文字(Wookieepedia 文本本身是 CC BY-SA,混入会造成传染性许可问题,同样不可抄)。写法口吻沿用 [../WORK_TEMPLATE.md](../WORK_TEMPLATE.md) §3 的中性叙事:「影片叙述…/The film depicts…」。
2. **情节摘要保持「检索粒度」而非「复述粒度」**:每事件 summary 1–2 句、detail 一段以内,做的是索引与因果定位,不重构可替代观影体验的连续叙事(过细的逐场景复述有衍生作品风险,also 违背产品定位)。
3. **反抄袭红线(IP 审读的机检项)**:任何 ≥8 个连续单词与影片台词或官方文案一致,即视为引用,必须走 §3 的引用规则或改写。
4. **零官方美术素材**:不用剧照、海报、官方地图、官方 logo、角色剪影;画布视觉全部为本项目原创 SVG(星环/散点,见 [SAGA_BLUEPRINT.md](SAGA_BLUEPRINT.md) §4.3);行星坐标为原创示意值,仅取公开事实性区位描述,不摹绘《Essential Atlas》等官方地图的图面表达。
5. **非商业定位**:不投放广告、不收费、不接受打赏;README 与页脚声明非商业性质。这不是护身符(非商业不等于合理使用),但显著降低被主张损害的敞口,也是粉丝社区惯例的底线。
6. `sources` 表条目写作事实性出处指称(如 title=`Episode IV: A New Hope (1977 film)`,citation 注明「事实性指称,本站不复制其内容」),`evidence_grade='primary'`。

## 3. 题词策略:原创为主,短引用 ≤15 词、仅 2 处

影片台词受版权保护;平台题词位(`apps/web/src/epigraphs.ts`:`WELCOME_EPIGRAPH`、`LOADING_EPIGRAPHS`×3、`FOOTER_EPIGRAPH`、`ERA_EPIGRAPHS`×12)在圣经/三国用公有领域原文,本实例改为**原创题词为主 + 极少量短引用**。规则:引用每条 ≤15 词、标注影片出处、全站总数 ≤3 条、只用于最高辨识度的锚点;其余全部原创(下表逐条给出,zhRef/enRef 标「本站题记 / house epigraph」)。

| 位置 | 方案 | 文案(zh / en) | 性质 |
|---|---|---|---|
| WELCOME | 原创 | 群星之间,原力长存。 / Among the stars, the Force endures. | 原创 |
| LOADING ×3 | 原创 | ①正在穿越超空间…… / Crossing hyperspace…;②航线计算中…… / Plotting the route…;③远方的星群正在亮起…… / Distant stars are waking… | 原创 |
| FOOTER | **短引用** | 「愿原力与你同在。」 / "May the Force be with you." —— Episode IV(1977) | 引用,6 词 |
| naboo-crisis | 原创 | 和平的表面之下,阴影已开始移动。 / Beneath the surface of peace, a shadow begins to move. | 原创 |
| clone-wars | 原创 | 以保卫共和国之名开始的战争,耗尽了共和国。 / A war fought to save the Republic slowly spent it. | 原创 |
| order-66-and-imperial-rise | 原创 | 一道命令传遍银河,万千灯火在同一夜熄灭。 / One order crossed the galaxy, and a thousand lights went out in a single night. | 原创 |
| dark-times | 原创 | 火种散落荒野,等待有人俯身拾起。 / Embers scattered in the wilderness, waiting to be gathered. | 原创 |
| rebel-alliance-rising | 原创 | 反抗,始于一次不肯低头。 / Rebellion begins with a single refusal to kneel. | 原创 |
| yavin-campaign | 原创 | 一艘小船,载着半个银河的希望。 / A small ship carried half the galaxy's hope. | 原创 |
| hoth-and-exile | **短引用** | 「不。我是你父亲。」 / "No. I am your father." —— Episode V(1980) | 引用,5 词 |
| endor-and-the-fall | 原创 | 森林的月亮,见证一个帝国的黄昏。 / A forest moon watched an empire's dusk. | 原创 |
| new-republic | 原创 | 战争结束了;银河开始学习和平。 / The war ended; the galaxy began to learn peace. | 原创 |
| first-order-rising | 原创 | 灰烬未冷,旧的秩序换上了新的面孔。 / From ashes not yet cold, the old order returned with a new face. | 原创 |
| last-jedi | 原创 | 传奇隐居海岛,火种却不肯熄灭。 / The legend hid on an island, but the spark refused to die. | 原创 |
| skywalker-reborn | 原创 | 名字可以继承,选择必须自己作出。 / A name can be inherited; the choice must be one's own. | 原创 |

- 引用条目在 `epigraphs.ts` 文件头注释登记(条数、词数、出处),供 IP 审读逐条核对;`UI.epigraphSourceSuffix`(`i18n.ts:208`)置空(引用出处已内嵌 ref,不再需要「(和合本)」式全局后缀)。
- 若审阅意见趋严,两条引用各有原创降级替换:FOOTER→「愿群星指引你的航程。/ May the stars keep your course.」;hoth-and-exile→「云端之城,一句真相重过一场败仗。/ In a city above the clouds, one truth outweighed a lost battle.」

## 4. 边界速查(给内容代理的一页纸)

| 可以 | 不可以 |
|---|---|
| 事实性指称专名(Coruscant、Darth Vader) | 专名进产品名/logo/域名 |
| 原创转述剧情(检索粒度) | 复制任何 ≥8 连续词的官方/百科文本 |
| 引用台词 ≤15 词 ×≤3 条,带出处 | 台词做题词主体、歌词式滚播 |
| 原创 SVG 星图、示意坐标 | 官方地图摹绘、剧照、logo 字体 |
| 「非官方粉丝参考」自我定位 + 双语免责声明 | 任何官方感包装、商业化 |
