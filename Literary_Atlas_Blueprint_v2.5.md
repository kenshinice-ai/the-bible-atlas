# 世界文学名著时空地图 Blueprint v2.5

**版本：** v2.5 — Build-Ready Launch Corpus Edition  
**目标：** 锁定双模式显示、首批 25 部作品、核心人物范围、数据库新增字段、视觉规范与开工边界。  
**基础架构：** React + TypeScript + CesiumJS + GSAP + PostgreSQL + PostGIS + 编辑审核后台。

---

# 1. v2.5 核心决策

## 1.1 两种作品显示模式

系统从数据库、API、地图渲染、时间轴、事件卡片和路线层面，严格区分以下两类内容。

### A. 史实文献模式 `DOCUMENTED_RECORD`

适用于：

- 正史、编年史、纪实文献；
- 日记、回忆录、旅行实录；
- 以记录真实人物与真实事件为主要目的的作品；
- 例如《史记》《安妮日记》《马可·波罗游记》等。

判定原则：作品的主要叙述目标是记录或见证现实世界，而不是创造文学虚构情节。

### B. 文学叙事模式 `LITERARY_NARRATIVE`

适用于：

- 小说；
- 历史小说；
- 架空历史；
- 神话、寓言、童话、奇幻；
- 魔幻现实主义；
- 侦探、科幻、冒险等文学叙事。

即使作品引用了真实战争、城市或历史人物，只要主要情节是文学创作，仍归入此模式。

例如：

- 《双城记》背景是真实法国大革命，但属于文学叙事；
- 《战争与和平》包含拿破仑和真实战争，但属于文学叙事；
- 《史记》以史实记录为目标，属于史实文献。

---

# 2. 双模式视觉系统

不能只依赖颜色。两类内容必须同时使用颜色、形状、线型、边框、纹理与动效区别。

| 项目 | 史实文献模式 | 文学叙事模式 |
|---|---|---|
| 主色 | 琥珀金 / 青铜 | 靛蓝 / 紫罗兰 |
| 点位图形 | 实心菱形或印章 | 空心圆环或星形 |
| 事件光晕 | 稳定双环 | 柔和脉冲与墨雾 |
| 路线 | 实线 | 虚线或渐变线 |
| 区域 | 斜线纹理 | 点状或星尘纹理 |
| 卡片边框 | 双线档案框 | 单线发光框 |
| 标签前缀 | 史实记录 | 文学叙事 |
| 时间轴节点 | 方形刻度 | 圆形刻度 |
| 进入动效 | 档案展开 / 印章落下 | 墨迹扩散 / 书页浮现 |

推荐 Token：

```css
:root {
  --mode-record-primary: #c79a54;
  --mode-record-secondary: #6f8f8b;
  --mode-record-surface: rgba(49, 38, 24, 0.92);

  --mode-fiction-primary: #8f7bd7;
  --mode-fiction-secondary: #5687b8;
  --mode-fiction-surface: rgba(26, 24, 49, 0.92);
}
```

色觉无障碍要求：

- 图标形状必须不同；
- 路线线型必须不同；
- 卡片必须显示文字徽章；
- 图例必须始终可打开；
- 高对比模式不得丢失分类信息。

---

# 3. 数据库新增分类字段

## 3.1 作品层

```sql
CREATE TYPE content_reality_mode AS ENUM (
  'documented_record',
  'literary_narrative'
);

ALTER TABLE works
ADD COLUMN content_mode content_reality_mode NOT NULL
DEFAULT 'literary_narrative';

ALTER TABLE works
ADD COLUMN mode_reason text;

ALTER TABLE works
ADD COLUMN sales_estimate_low bigint;

ALTER TABLE works
ADD COLUMN sales_estimate_high bigint;

ALTER TABLE works
ADD COLUMN sales_evidence_grade text;

ALTER TABLE works
ADD COLUMN launch_rank integer;
```

## 3.2 事件层

作品模式与单个事件真实性不能混为一谈。

历史小说中的某个事件可能对应真实历史背景，因此事件增加：

```sql
ALTER TABLE events
ADD COLUMN event_reality text NOT NULL DEFAULT 'fictional_narrative';
```

建议枚举：

```text
verified_historical
reported_historical
fictional_narrative
fictional_with_historical_context
legendary_or_mythic
symbolic_or_dream
contested
```

前台主模式仍按作品分类；事件真实性作为第二层徽章和筛选器。

---

# 4. 地图渲染规则

## 4.1 同城存在两种内容

当巴黎同时有《双城记》的文学事件与真实历史文献事件时：

```text
城市聚合点保持中性
→ 外圈显示史实文献比例
→ 内圈显示文学叙事比例
→ 点击后按两个 Tab 分组
```

城市面板：

```text
全部
史实文献
文学叙事
```

## 4.2 同一事件关联真实历史背景

文学事件卡片可显示：

```text
文学叙事：查尔斯·达尔内的经历
历史背景：法国大革命相关时期
```

两者不得合并成同一事实断言。

## 4.3 路线规则

- 史实路线：实线，显示证据来源；
- 文学明确路线：虚线，标注“文本明确”；
- 文学推测路线：点线，标注“推测”；
- 虚构世界路线：星尘或发光线；
- 不确定路线：带透明缓冲走廊。

---

# 5. 首批 25 部作品的选择口径

不存在一个完全精确、统一、可审计的“世界图书总销量榜”。早期作品、公共版权作品、多出版社版本及免费电子版通常缺乏完整销售记录。

v2.5 使用以下启动口径：

1. 以公开报道的全球单册估算销量为基础；
2. 排除宗教经典、政治宣传、工具书、教材与纯自助书；
3. 以文学叙事和具有明确人物、事件、地点的数据可视化价值为主；
4. 同一系列仅保留销量最高的代表卷，避免系列重复占位；
5. 销量以区间和证据等级存储，不把估算值当成精确事实；
6. 为验证史实文献模式，首批加入《安妮日记》作为校准作品；
7. 启动排名是内容工程优先级，不宣称为永久权威榜单。

销量资料参考应至少交叉核对：出版社、作者遗产机构、主流媒体、图书馆资料与可靠汇总来源。

---

# 6. 首批 25 部 Launch Corpus

| 启动序号 | 作品 | 作者 | 公开估算销量 | 模式 | 首批核心人物数 | 地图价值 |
|---:|---|---|---:|---|---:|---|
| 1 | 《双城记》 | Charles Dickens | 2 亿以上 | 文学叙事 | 8 | 伦敦—巴黎双城、革命路线 |
| 2 | 《小王子》 | Antoine de Saint-Exupéry | 约 2 亿 | 文学叙事 | 8 | 多星球象征空间、撒哈拉 |
| 3 | 《牧羊少年奇幻之旅》 | Paulo Coelho | 约 1.5 亿 | 文学叙事 | 7 | 西班牙—北非—埃及路线 |
| 4 | 《哈利·波特与魔法石》 | J. K. Rowling | 约 1.2 亿 | 文学叙事 | 10 | 英国真实锚点与虚构世界 |
| 5 | 《无人生还》 | Agatha Christie | 约 1 亿 | 文学叙事 | 10 | 封闭岛屿、事件顺序清晰 |
| 6 | 《红楼梦》 | 曹雪芹 | 约 1 亿 | 文学叙事 | 10 | 大观园人物关系与空间层级 |
| 7 | 《霍比特人》 | J. R. R. Tolkien | 约 1 亿 | 文学叙事 | 10 | 完整虚构世界与冒险路线 |
| 8 | 《爱丽丝梦游仙境》 | Lewis Carroll | 约 1 亿 | 文学叙事 | 9 | 梦境空间与非线性地点 |
| 9 | 《她：冒险史》 | H. Rider Haggard | 约 8300 万 | 文学叙事 | 7 | 英国—非洲探险路线 |
| 10 | 《达·芬奇密码》 | Dan Brown | 约 8000 万 | 文学叙事 | 8 | 巴黎—伦敦—苏格兰追踪路线 |
| 11 | 《麦田里的守望者》 | J. D. Salinger | 约 6500 万 | 文学叙事 | 7 | 纽约城市漫游 |
| 12 | 《苏菲的世界》 | Jostein Gaarder | 约 6000 万 | 文学叙事 | 8 | 挪威现实与哲学叙事层 |
| 13 | 《廊桥遗梦》 | Robert James Waller | 约 6000 万 | 文学叙事 | 5 | 爱荷华州真实地点、时间集中 |
| 14 | 《百年孤独》 | Gabriel García Márquez | 约 5000 万 | 文学叙事 | 10 | 马孔多世代时间与虚构地理 |
| 15 | 《洛丽塔》 | Vladimir Nabokov | 约 5000 万 | 文学叙事 | 6 | 美国公路路线；需内容分级 |
| 16 | 《海蒂》 | Johanna Spyri | 约 5000 万 | 文学叙事 | 8 | 瑞士阿尔卑斯—法兰克福 |
| 17 | 《绿山墙的安妮》 | L. M. Montgomery | 约 5000 万 | 文学叙事 | 8 | 爱德华王子岛地点清晰 |
| 18 | 《黑骏马》 | Anna Sewell | 约 5000 万 | 文学叙事 | 8 | 英格兰多主人迁移路线 |
| 19 | 《玫瑰之名》 | Umberto Eco | 约 5000 万 | 文学叙事 | 8 | 中世纪修道院与调查路径 |
| 20 | 《鹰已降落》 | Jack Higgins | 约 5000 万 | 文学叙事 | 8 | 二战背景下的英德路线 |
| 21 | 《沃特希普荒原》 | Richard Adams | 约 5000 万 | 文学叙事 | 10 | 英格兰地貌与迁徙路线 |
| 22 | 《夏洛的网》 | E. B. White | 约 5000 万 | 文学叙事 | 8 | 农场—集市的小尺度空间 |
| 23 | 《彼得兔的故事》 | Beatrix Potter | 约 4500 万 | 文学叙事 | 6 | 湖区真实灵感与童话空间 |
| 24 | 《杀死一只知更鸟》 | Harper Lee | 约 4000 万 | 文学叙事 | 9 | 美国南方城镇、审判事件 |
| 25 | 《安妮日记》 | Anne Frank | 约 3500 万 | **史实文献** | 8 | 阿姆斯特丹真实地点与日记时间轴 |

说明：第 25 项承担史实文献模式的首轮验证。后续历史文献批次应加入《史记》《伯罗奔尼撒战争史》《马可·波罗游记》等，不与小说销量榜强行混排。

---

# 7. 每部作品首批核心人物

## 7.1 《双城记》— 8 人

- Charles Darnay
- Sydney Carton
- Lucie Manette
- Doctor Manette
- Madame Defarge
- Monsieur Defarge
- Jarvis Lorry
- Miss Pross

## 7.2 《小王子》— 8 人

- 小王子
- 飞行员
- 玫瑰
- 狐狸
- 蛇
- 国王
- 商人
- 点灯人

## 7.3 《牧羊少年奇幻之旅》— 7 人

- Santiago
- Melchizedek
- The Alchemist
- Fatima
- Englishman
- Crystal Merchant
- Tribal Chieftain

## 7.4 《哈利·波特与魔法石》— 10 人

- Harry Potter
- Hermione Granger
- Ron Weasley
- Albus Dumbledore
- Rubeus Hagrid
- Severus Snape
- Lord Voldemort
- Draco Malfoy
- Minerva McGonagall
- Quirinus Quirrell

## 7.5 《无人生还》— 10 人

- Justice Wargrave
- Vera Claythorne
- Philip Lombard
- Dr Armstrong
- William Blore
- Emily Brent
- General Macarthur
- Anthony Marston
- Thomas Rogers
- Ethel Rogers

## 7.6 《红楼梦》— 10 人

- 贾宝玉
- 林黛玉
- 薛宝钗
- 王熙凤
- 贾母
- 贾政
- 贾元春
- 史湘云
- 晴雯
- 袭人

## 7.7 《霍比特人》— 10 人

- Bilbo Baggins
- Gandalf
- Thorin Oakenshield
- Smaug
- Gollum
- Bard
- Elrond
- Balin
- Beorn
- The Great Goblin

## 7.8 《爱丽丝梦游仙境》— 9 人

- Alice
- White Rabbit
- Cheshire Cat
- Queen of Hearts
- Mad Hatter
- March Hare
- Caterpillar
- Duchess
- King of Hearts

## 7.9 《她：冒险史》— 7 人

- Horace Holly
- Leo Vincey
- Ayesha
- Job
- Billali
- Ustane
- Amenartas

## 7.10 《达·芬奇密码》— 8 人

- Robert Langdon
- Sophie Neveu
- Leigh Teabing
- Jacques Saunière
- Silas
- Bezu Fache
- Bishop Aringarosa
- Rémy Legaludec

## 7.11 《麦田里的守望者》— 7 人

- Holden Caulfield
- Phoebe Caulfield
- Allie Caulfield
- D. B. Caulfield
- Mr Antolini
- Sally Hayes
- Jane Gallagher

## 7.12 《苏菲的世界》— 8 人

- Sophie Amundsen
- Alberto Knox
- Hilde Møller Knag
- Albert Knag
- Sophie's Mother
- Joanna
- Hermes
- The Major

## 7.13 《廊桥遗梦》— 5 人

- Francesca Johnson
- Robert Kincaid
- Richard Johnson
- Michael Johnson
- Carolyn Johnson

## 7.14 《百年孤独》— 10 人

- José Arcadio Buendía
- Úrsula Iguarán
- Colonel Aureliano Buendía
- Amaranta
- José Arcadio
- Rebeca
- Remedios the Beauty
- Aureliano Segundo
- Fernanda del Carpio
- Melquíades

## 7.15 《洛丽塔》— 6 人

- Humbert Humbert
- Dolores Haze
- Charlotte Haze
- Clare Quilty
- Annabel Leigh
- Rita

内容要求：默认无剧透与未成年人保护展示；不得浪漫化操控、侵害或犯罪行为。

## 7.16 《海蒂》— 8 人

- Heidi
- Grandfather
- Clara Sesemann
- Peter
- Peter's Grandmother
- Rottenmeier
- Mr Sesemann
- Clara's Grandmother

## 7.17 《绿山墙的安妮》— 8 人

- Anne Shirley
- Marilla Cuthbert
- Matthew Cuthbert
- Gilbert Blythe
- Diana Barry
- Rachel Lynde
- Miss Stacy
- Ruby Gillis

## 7.18 《黑骏马》— 8 人

- Black Beauty
- Ginger
- Merrylegs
- John Manly
- Joe Green
- Squire Gordon
- Jerry Barker
- Nicholas Skinner

## 7.19 《玫瑰之名》— 8 人

- William of Baskerville
- Adso of Melk
- Jorge of Burgos
- Bernardo Gui
- Abbot Abo
- Salvatore
- Remigio of Varagine
- Severinus

## 7.20 《鹰已降落》— 8 人

- Kurt Steiner
- Liam Devlin
- Colonel Radl
- Heinrich Himmler
- Joanna Grey
- Father Verecker
- Molly Prior
- Winston Churchill

真实历史人物必须额外标注：`historical_person = true`，但其小说行为不得自动当作史实。

## 7.21 《沃特希普荒原》— 10 人

- Hazel
- Fiver
- Bigwig
- Blackberry
- Dandelion
- Silver
- Holly
- General Woundwort
- Hyzenthlay
- Kehaar

## 7.22 《夏洛的网》— 8 人

- Wilbur
- Charlotte
- Fern Arable
- Templeton
- Homer Zuckerman
- Avery Arable
- Dr Dorian
- Goose

## 7.23 《彼得兔的故事》— 6 人

- Peter Rabbit
- Mrs Rabbit
- Mr McGregor
- Flopsy
- Mopsy
- Cotton-tail

## 7.24 《杀死一只知更鸟》— 9 人

- Scout Finch
- Atticus Finch
- Jem Finch
- Tom Robinson
- Boo Radley
- Calpurnia
- Dill Harris
- Mayella Ewell
- Bob Ewell

## 7.25 《安妮日记》— 8 人

- Anne Frank
- Otto Frank
- Edith Frank
- Margot Frank
- Peter van Pels
- Hermann van Pels
- Auguste van Pels
- Fritz Pfeffer

史实文献人物要求：

- 使用真实身份与姓名；
- 不生成虚构心理活动；
- 事件必须绑定日记日期或可靠历史来源；
- 对集中营、迫害与死亡信息使用尊重且克制的呈现方式。

---

# 8. 每部作品首批内容配额

每部作品首轮录入：

| 数据类型 | 最低 | 推荐上限 |
|---|---:|---:|
| 核心人物 | 5 | 10 |
| 重大事件 | 12 | 30 |
| 主要地点 | 5 | 20 |
| 路线 | 1 | 8 |
| 人物关系 | 8 | 40 |
| 来源断言 | 30 | 150 |
| 图片或图标 | 1 | 8 |
| 城市聚合摘要 | 1 | 按城市生成 |

25 部作品的首轮目标：

```text
约 200 位核心人物
约 450–600 个重大事件
约 250–350 个地点
约 60–100 条路线
约 1,500–3,000 条来源断言
```

---

# 9. 人物筛选原则

人物进入首批核心名单必须满足至少两项：

1. 推动主要情节；
2. 参与多个重大事件；
3. 具有明确地点移动；
4. 代表核心主题；
5. 与多名人物形成关键关系；
6. 对作品结局或结构有决定性影响；
7. 是读者最常识别的代表人物。

不得为了凑够 10 人加入边缘人物。

---

# 10. 事件筛选原则

每部作品只录入“能够改变人物状态、地点状态或故事方向”的事件。

事件至少满足一项：

- 人物首次出现或关键相遇；
- 到达或离开重要地点；
- 关系变化；
- 战争、审判、死亡、婚姻、背叛、发现等转折；
- 旅程节点；
- 作品著名场景；
- 结局节点；
- 史实文献中的明确记录。

不得把每个章节都机械转成事件。

---

# 11. 切换逻辑

## 11.1 全局模式切换

顶部提供：

```text
全部 | 史实文献 | 文学叙事
```

切换时：

```text
保持当前时间
保持当前镜头
保持当前城市
清除不兼容的作品选择
重新请求数据
更新图例
更新点位和路线样式
更新城市聚合计数
```

## 11.2 城市内切换

城市面板内切换不得改变镜头，只更新：

- 作品列表；
- 人物列表；
- 事件列表；
- 路线；
- 时间密度。

## 11.3 作品切换

文学叙事作品可以进入：

- 现实地球锚点；
- 虚构世界层；
- 混合层。

史实文献作品只能使用：

- 现实地球；
- 历史边界或历史地图层；
- 不得进入虚构空间层。

---

# 12. 数据来源与证据等级

销量与文学事件必须分开评级。

## 12.1 销量证据等级

```text
A：出版社、作者遗产机构、审计数据或多个权威来源一致
B：主流媒体引用出版社或行业资料
C：多个可靠汇总来源大致一致
D：广泛流传但缺少可审计原始资料
```

## 12.2 文学事件证据等级

```text
A：参考版本原文明确记载
B：权威注释或学术研究支持
C：根据文本上下文合理推断
D：存在争议，仅作为候选
```

只有 A–C 可公开；D 默认只在后台显示。

---

# 13. 首批数据获取流程

```text
建立 25 部作品记录
→ 确认参考版本与版权状态
→ 建立作者和版本
→ 建立 5–10 位核心人物
→ 按章节提取重大事件
→ 识别时间表达
→ 识别地点
→ 绑定人物与地点
→ 生成路线候选
→ 添加来源断言
→ 文学事实审核
→ 地理审核
→ 来源审核
→ 前台预览
→ 发布
```

AI 只能生成候选数据，不得自动发布。

---

# 14. 开工后的 Sprint 顺序

## Sprint 0 — Repository and Database

- Monorepo；
- PostgreSQL/PostGIS；
- migration；
- 双模式枚举；
- 作品、人物、事件、地点、路线、来源表；
- seed 框架；
- CI。

## Sprint 1 — Globe and Timeline

- Cesium 地球；
- 统一时间状态；
- 时间轴；
- 双模式图例；
- 点位和路线基础样式；
- 触摸和鼠标操作。

## Sprint 2 — Entity Interaction

- 点击城市；
- 点击时间；
- 点击作品；
- 点击人物；
- 点击事件；
- 点击路线；
- 返回栈与深链接。

## Sprint 3 — Launch Corpus Pipeline

- 导入 25 部作品；
- 导入人物；
- 事件编辑器；
- 地点编辑器；
- 来源断言；
- 审核状态。

## Sprint 4 — Story Playback

- 人物路线；
- 摄像机导演；
- 时间同步；
- 史实档案动效；
- 文学墨迹动效；
- 剧透控制。

## Sprint 5 — QA and Release

- 移动端；
- 性能；
- 无障碍；
- 数据一致性；
- 浏览器测试；
- staging；
- 首次公开发布。

---

# 15. v2.5 Definition of Ready

满足以下条件即可正式开工：

- [x] 已确定双模式；
- [x] 已确定视觉区别；
- [x] 已确定数据库字段；
- [x] 已确定首批 25 部作品；
- [x] 已限定每部 5–10 位人物；
- [x] 已确定事件与地点录入原则；
- [x] 已确定来源和审核等级；
- [x] 已确定 Sprint 顺序；
- [ ] 创建 SQL migration 文件；
- [ ] 创建 25 部作品 seed JSON；
- [ ] 创建人物 seed JSON；
- [ ] 创建首批 3 部作品的事件样板；
- [ ] 初始化代码仓库。

---

# 16. 第一轮实际开发建议

第一轮不要同时手工录入全部 25 部作品的完整事件。

先使用 3 部作品打通完整链路：

1. 《双城记》：真实历史背景下的文学叙事；
2. 《霍比特人》：完整虚构世界与路线；
3. 《安妮日记》：史实文献模式。

这三部作品可以同时验证：

- 现实城市；
- 历史背景；
- 虚构地图；
- 人物路线；
- 双模式视觉；
- 来源断言；
- 剧透与敏感内容；
- 城市和时间点击。

链路稳定后，再批量扩展至剩余 22 部。

---

# 17. 参考口径

首批销量排序采用公开全球销量估算作为启动依据。相关资料普遍承认早期作品和多出版社作品缺乏完整审计数据，因此系统必须保存销量区间、来源和证据等级，而不是只保存一个整数。

主要参考方向：

- Wikipedia: List of best-selling books（作为带引用的汇总索引，不作为唯一证据）
- 出版社与作者遗产机构发布的累计销量
- Reuters、BBC、Britannica 等主流来源
- Open Library 与 Wikidata 的书目和实体标识
- 原著、权威版本与学术研究作为事件事实来源

---

# 18. 最终开工基线

```text
双模式显示
+ 25 部启动作品
+ 每部 5–10 位核心人物
+ 450–600 个事件目标
+ PostgreSQL/PostGIS 正式数据库
+ 来源断言与审核流程
+ Cesium 3D 地球
+ React/TypeScript 统一状态
+ 可持续扩展的编辑后台
```

v2.5 的原则是：

> 史实必须像档案一样可信，文学必须像故事一样鲜活；两者可以在同一个地球上相遇，但绝不能被混为一谈。

