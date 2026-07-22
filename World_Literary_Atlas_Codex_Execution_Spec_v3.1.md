# 世界文学名著时空地图 Demo 升级执行说明 v3.1

> 面向 Codex 的可执行开发任务  
> 当前状态：首个本地 Demo 已运行，整体完成度约 30%  
> 当前访问地址：`http://10.0.0.49:8080/`  
> 本轮目标：在不推翻现有结构的前提下，把当前 Demo 升级为一个可交互、可扩展、可验证的世界文学时空地图 MVP。

---

## 0. 总体目标

请先完整审计现有代码、目录结构、数据结构、页面逻辑、地图实现、时间轴实现、多语言实现和状态管理方式，再开始修改。

本轮升级必须满足以下核心目标：

1. 城市、事件、人物、地点、路线之间形成完整交互闭环。
2. 地图、时间轴、人物关系图三大视图可以互相联动。
3. 支持最多 5 部作品对照展示。
4. 支持中英文原生数据结构，不采用前端临时翻译。
5. 现实历史、历史背景小说、纯虚构作品采用不同视觉编码。
6. 保留现有 Demo 中已经可用的功能，避免大规模重写。
7. 优先稳定性、信息层级、可维护性，不追求一次性加入过多动画。

---

# 1. 现状判断

从当前界面可以看出，现有 Demo 已经具备以下基础：

- 顶部作品多选；
- 中英文切换；
- 当前作品标签；
- 作品简介卡片；
- Leaflet 地图；
- 事件列表；
- 人物、事件、地点、路线标签页；
- 简单叙事进度条；
- 来源展示；
- 现实与虚构的基础分类；
- 多作品叠加的初步能力。

当前主要问题：

- 地图和右侧内容联动较弱；
- 城市点击后没有明确的镜头反馈；
- 人物没有视觉身份；
- 时间轴只是作品内部序号，不是历史时间轴；
- 地图缺少文学地标、历史建筑和地点类型表达；
- 作品选择器信息密度不够，筛选逻辑较弱；
- 人物、事件、地点描述偏短；
- 缺少人物关系图；
- 多作品叠加后，视觉冲突和筛选逻辑需要更明确；
- 数据模型可能还不足以支撑后续 25 部作品。

---

# 2. 本轮开发原则

## 2.1 不推翻现有 Demo

优先采用增量改造：

- 保留现有框架；
- 保留现有路由；
- 保留现有数据库；
- 保留现有 Leaflet 逻辑；
- 保留现有中英文切换机制；
- 保留当前视觉风格；
- 只在必要时重构组件。

如发现当前结构存在明显阻碍，请先记录到：

`docs/ARCHITECTURE_AUDIT_v3.1.md`

再进行最小范围重构。

## 2.2 数据优先

所有新增功能必须先补足数据结构，再实现界面。

禁止：

- 在组件中硬编码人物、事件、关系；
- 依赖中文标题作为唯一键；
- 用数组下标代表事件顺序；
- 用前端逻辑推断作品类型；
- 把英文内容临时机器翻译成中文。

## 2.3 渐进增强

本轮不要求一次性完成大型 3D 地球、全景建筑、复杂 WebGL。

优先完成：

1. 稳定的数据结构；
2. 地图交互；
3. 时间轴；
4. 人物卡片；
5. 人物关系图；
6. 多作品筛选；
7. UI 打磨。

---

# 3. 功能一：点击城市后自动缩放和居中

## 3.1 交互目标

当用户点击以下任意元素时：

- 地图城市点；
- 右侧事件；
- 地点列表；
- 人物当前所在地点；
- 路线节点；
- 时间轴事件；

地图必须自动：

1. 平滑移动到目标位置；
2. 自动调整缩放级别；
3. 高亮对应地点；
4. 打开地点弹窗；
5. 同步高亮右侧对应内容；
6. 保持当前作品筛选状态。

## 3.2 地图行为建议

不同地点类型采用不同缩放级别：

| 地点类型 | 建议缩放 |
|---|---:|
| 国家 | 5 |
| 区域 / 省 | 7 |
| 城市 | 10 |
| 街区 | 13 |
| 建筑 / 精确地点 | 15 |
| 虚构世界区域 | 6–10，按地图比例配置 |

应通过统一函数处理：

```ts
focusMapTarget({
  locationId,
  lat,
  lng,
  locationType,
  preferredZoom,
  source
})
```

建议使用：

```ts
map.flyTo([lat, lng], zoom, {
  animate: true,
  duration: 0.8
})
```

## 3.3 高亮机制

目标地点高亮 2–4 秒：

- marker 放大；
- 外圈脉冲；
- 颜色加亮；
- 自动打开 popup；
- 非目标 marker 轻微降低透明度。

地图点击和内容点击必须使用同一套选中状态：

```ts
selectedEntity = {
  type: 'event' | 'person' | 'location' | 'route',
  id: string,
  workId: string
}
```

## 3.4 防止过度跳动

增加以下保护：

- 连续点击同一地点时不重复 flyTo；
- 用户正在拖动地图时，不强制打断；
- 多作品对照时，点击作品标签只 fitBounds，不进入单点；
- 移动端减少动画时间；
- 提供“返回全部作品范围”按钮。

## 3.5 验收标准

- 点击任意事件，地图 1 秒内移动到对应地点；
- 地图弹窗、事件列表、时间轴同步；
- 点击同一事件不会反复闪烁；
- 多作品模式下不会清空已选作品；
- 城市、建筑、路线节点采用不同缩放级别。

---

# 4. 功能二：人物图标、身份与人物卡片

## 4.1 视觉表达

人物至少支持以下基础特征：

### 性别

- 男；
- 女；
- 未知；
- 非适用。

### 年龄阶段

- 儿童；
- 青年；
- 成年；
- 老年；
- 年龄不详。

### 角色类型

- 主角；
- 反派；
- 配角；
- 历史人物；
- 叙述者；
- 群体角色；
- 神话或超自然角色。

### 状态

- 存活；
- 死亡；
- 失踪；
- 虚构；
- 历史真实；
- 状态未知。

## 4.2 图标方案

第一阶段不要依赖真实人物肖像版权素材。

优先采用：

- 简洁人物轮廓；
- 性别和年龄差异；
- 角色类别小徽章；
- 圆形头像底色使用作品色；
- 历史人物加“史”或档案样式；
- 虚构人物加星形或羽毛笔样式；
- 已死亡人物可以降低饱和度，但不要使用过度负面的视觉。

建议使用：

- Lucide Icons；
- Heroicons；
- 自建 SVG；
- CSS avatar system。

禁止使用 Emoji 作为核心图标系统。

## 4.3 人物卡片结构

点击人物后显示侧边抽屉或浮层。

人物卡片至少包含：

```text
人物名称
英文名称
所属作品
身份标签
性别
年龄阶段
生卒年份或故事时间
人物简介
人物动机
重要关系
首次登场事件
最后出现事件
主要地点
关键事件
相关路线
来源
```

建议增加：

- “在地图中定位”；
- “查看关系图”；
- “查看完整时间线”；
- “仅显示该人物相关事件”。

## 4.4 数据结构建议

```ts
type Person = {
  id: string
  workId: string
  slug: string

  nameZh: string
  nameEn: string
  aliasesZh?: string[]
  aliasesEn?: string[]

  gender: 'male' | 'female' | 'unknown' | 'na'
  ageStage: 'child' | 'youth' | 'adult' | 'elder' | 'unknown'
  roleType:
    | 'protagonist'
    | 'antagonist'
    | 'supporting'
    | 'narrator'
    | 'historical'
    | 'collective'
    | 'supernatural'

  realityType:
    | 'historical'
    | 'fictional'
    | 'fictionalised_historical'
    | 'unknown'

  birthDate?: string
  deathDate?: string
  birthPlaceId?: string
  deathPlaceId?: string

  summaryZh: string
  summaryEn: string
  motivationZh?: string
  motivationEn?: string

  portraitAsset?: string
  iconVariant?: string

  sourceIds: string[]
}
```

## 4.5 验收标准

- 每部作品至少 5 个核心人物；
- 每个人物有中英文名称和简介；
- 性别、年龄、角色类型可视化；
- 点击人物可定位地图；
- 点击人物可打开关系图；
- 人物信息不在组件中硬编码。

---

# 5. 功能三：公元前至现代的完整历史时间轴

## 5.1 核心目标

现有 1–6 序号进度条应保留为“作品叙事进度”，但不能代替历史时间轴。

新增独立的“世界时间轴”组件：

- 横轴覆盖公元前至现代；
- 支持缩放；
- 支持拖动；
- 支持按作品过滤；
- 支持按事件类型过滤；
- 支持事件密度柱状图；
- 支持历史时间和叙事时间双模式。

## 5.2 时间范围

默认全局范围建议：

```text
公元前 3000 年 — 公元 2026 年
```

未来可以根据数据扩展。

时间轴应支持：

- BCE / CE；
- 年；
- 月；
- 日；
- 模糊年代；
- 年代范围；
- 故事时间不确定；
- 完全虚构纪年。

## 5.3 时间类型

每个事件必须有时间可信度：

```ts
timeType:
  | 'exact'
  | 'approximate'
  | 'range'
  | 'relative'
  | 'fictional_calendar'
  | 'unknown'
```

还需区分：

```ts
calendarSystem:
  | 'gregorian'
  | 'julian'
  | 'fictional'
  | 'unknown'
```

## 5.4 时间轴双层结构

### 第一层：事件密度柱状图

柱高表示当前时间区间的事件数量。

用户缩放后自动改变聚合粒度：

| 时间跨度 | 聚合粒度 |
|---|---|
| 1000 年以上 | 100 年 |
| 200–1000 年 | 20 年 |
| 50–200 年 | 5 年 |
| 10–50 年 | 1 年 |
| 1–10 年 | 月 |
| 小于 1 年 | 日 |

柱状图颜色：

- 每部作品对应一个主色；
- 多作品同区间可使用堆叠柱；
- 现实历史事件使用实心；
- 小说事件使用半透明；
- 完全虚构纪年使用纹理或虚线边框。

### 第二层：事件节点

时间轴下方展示事件点：

- 事件标题；
- 地点；
- 人物；
- 作品；
- 时间可信度；
- 现实 / 虚构状态。

## 5.5 作品叙事时间与世界历史时间

提供两个切换按钮：

```text
历史时间
叙事顺序
```

历史时间：

- 根据事件实际发生日期排列；
- 可跨作品比较。

叙事顺序：

- 根据小说章节或故事顺序排列；
- 对没有明确日期的作品仍然有效。

## 5.6 时间轴与地图联动

点击柱状图：

- 地图 fitBounds 到该时间段所有事件；
- 右侧事件列表过滤到该时间段；
- 显示该时段事件数量。

点击单个事件：

- 地图飞到目标地点；
- 打开事件详情；
- 高亮相关人物；
- 关系图可选中相关人物。

## 5.7 技术建议

优先评估：

- D3.js；
- Vis Timeline；
- Observable Plot；
- ECharts custom series。

推荐：

- 密度柱状图使用 D3 或 ECharts；
- 事件轨道可使用自定义 SVG；
- 数据量暂不大时不需要 Canvas。

## 5.8 验收标准

- 默认可显示 BCE 到现代；
- 时间轴可缩放、拖动；
- 柱高反映事件密度；
- 可以切换历史时间与叙事顺序；
- 点击时间轴能联动地图和事件列表；
- 模糊时间不会被错误显示为精确日期。

---

# 6. 功能四：地图渲染、文学地标与建筑

## 6.1 地点分类

地点至少支持：

```ts
locationType:
  | 'country'
  | 'region'
  | 'city'
  | 'district'
  | 'street'
  | 'building'
  | 'landmark'
  | 'prison'
  | 'station'
  | 'port'
  | 'battlefield'
  | 'residence'
  | 'school'
  | 'religious_site'
  | 'fictional_place'
  | 'route_node'
```

## 6.2 地标展示

第一阶段采用“地标卡片 + 图标”，不直接追求 3D 建筑。

地点弹窗包括：

- 中英文地点名；
- 地点类型；
- 所属国家或虚构世界；
- 现实坐标；
- 文学意义；
- 相关人物；
- 相关事件；
- 历史背景；
- 当前建筑是否仍存在；
- 图片；
- 来源；
- “定位到此处”；
- “查看相关路线”。

## 6.3 地标图片

图片资源必须记录：

```ts
assetSource
assetLicence
assetAuthor
assetUrl
attributionText
```

优先使用：

- Wikimedia Commons；
- Unsplash；
- 公共领域历史图像；
- 自建插画；
- OpenStreetMap 相关公开数据。

不允许无来源抓取图片。

## 6.4 Marker 视觉系统

建议：

- 城市：圆点；
- 建筑：建筑图标；
- 监狱：栅栏图标；
- 港口：锚；
- 车站：列车；
- 战场：旗帜；
- 虚构地点：星图或魔法门；
- 现实历史地点：实线边框；
- 小说地点：半透明；
- 虚构地点：虚线外圈。

## 6.5 地图图层

新增地图图层控制：

```text
基础地图
现实地点
虚构地点
人物
事件
路线
文学地标
历史地标
现代地标
```

多作品时还需：

- 按作品开关；
- 按内容类型开关；
- 一键只看当前作品；
- 一键恢复全部。

## 6.6 地图背景

保留 OpenStreetMap，但预留切换：

- 浅色；
- 深色；
- 地形；
- 历史风格；
- 简化政治边界；
- 虚构世界地图。

注意地图 tile 的授权和 attribution。

## 6.7 验收标准

- 地点类型有明确图标；
- 地标弹窗信息完整；
- 地图图层可开关；
- 现实、历史背景、纯虚构地点视觉可区分；
- 地图 attribution 保留；
- 图片具备来源字段。

---

# 7. 功能五：右上角作品选择器升级

## 7.1 目标

把当前作品选择器升级为一个稳定、清晰、可扩展的“作品控制中心”。

最大对照数量：

```text
最多选择 5 部作品
```

## 7.2 选择器布局

建议结构：

```text
搜索框
分类筛选
已选作品
作品列表
底部操作区
```

### 搜索

支持：

- 中文名；
- 英文名；
- 作者；
- 国家；
- 年代；
- 类型；
- 现实 / 虚构。

### 分类筛选

- 全部；
- 真实历史文献；
- 历史背景小说；
- 现实主义小说；
- 完全虚构；
- 神话 / 史诗；
- 地区；
- 年代。

### 每部作品条目

显示：

- 中文名；
- 英文名；
- 作者；
- 时间范围；
- 作品类型；
- 现实 / 虚构标签；
- 作品颜色；
- 人物数；
- 事件数；
- 地点数。

## 7.3 已选作品

顶部使用 compact chips：

```text
双城记 ×
安妮日记 ×
牧羊少年奇幻之旅 ×
```

每个 chip：

- 使用作品颜色；
- 可单独移除；
- 可点击聚焦；
- 可设置主作品；
- 主作品边框更明显。

## 7.4 达到 5 部后的行为

当已选择 5 部：

- 其他复选框禁用；
- 显示明确提示；
- 不允许第 6 部静默替换；
- 用户必须先移除一部；
- 提示内容支持中英文。

## 7.5 单选和多选

保留两个模式：

```text
单部探索
多部对照
```

单部探索：

- 只允许 1 部；
- 适合人物关系图、完整叙事。

多部对照：

- 最多 5 部；
- 适合地图和历史时间轴比较。

切换模式时：

- 从多选切回单选，保留当前主作品；
- 不随机保留第一部；
- 显示一次性提示。

## 7.6 URL 状态

选择状态写入 URL：

```text
?works=a-tale-of-two-cities,anne-frank
&mode=compare
&lang=zh
```

便于：

- 深链接；
- 分享；
- 刷新恢复；
- 浏览器前进后退；
- 测试。

## 7.7 验收标准

- 最多可选 5 部；
- 搜索和分类可用；
- 已选作品清晰；
- 主作品可切换；
- 刷新页面后选择状态保留；
- 单选与多选切换不会丢失主作品；
- 选择器支持键盘操作。

---

# 8. 功能六：人物、事件、地点内容扩充

## 8.1 信息深度原则

所有内容避免只有一句话。

每个核心对象应分为：

- 简短摘要；
- 完整详情；
- 关联对象；
- 来源；
- 可信度；
- 现实 / 虚构标签。

## 8.2 事件数据结构

```ts
type LiteraryEvent = {
  id: string
  workId: string
  chapterId?: string

  titleZh: string
  titleEn: string
  summaryZh: string
  summaryEn: string
  detailZh?: string
  detailEn?: string

  eventType:
    | 'birth'
    | 'death'
    | 'meeting'
    | 'journey'
    | 'battle'
    | 'trial'
    | 'imprisonment'
    | 'escape'
    | 'marriage'
    | 'betrayal'
    | 'discovery'
    | 'political'
    | 'social'
    | 'other'

  realityType:
    | 'historical'
    | 'fictional'
    | 'fictional_with_historical_context'
    | 'mixed'

  startDate?: string
  endDate?: string
  approximateYear?: number
  timeType: string
  narrativeOrder: number

  locationIds: string[]
  personIds: string[]
  routeId?: string

  significanceZh?: string
  significanceEn?: string

  sourceIds: string[]
  confidenceLevel: 'high' | 'medium' | 'low'
}
```

## 8.3 地点内容

地点至少包括：

- 文学意义；
- 历史背景；
- 当前现实状态；
- 相关人物；
- 相关事件；
- 首次出现章节；
- 坐标可信度；
- 是否为推定位置；
- 图片和来源。

## 8.4 内容层级

右侧列表：

- 只显示标题、摘要、日期、地点、来源数量。

详情抽屉：

- 显示完整说明和所有关系。

避免在主界面一次性塞入全部文字。

## 8.5 来源与可信度

每条事件至少绑定一个来源。

来源类型：

```ts
sourceType:
  | 'primary_text'
  | 'scholarly'
  | 'historical'
  | 'reference'
  | 'map'
  | 'image'
```

显示：

- primary；
- secondary；
- disputed；
- inferred；
- approximate。

## 8.6 验收标准

- 每个核心事件有中英文标题和摘要；
- 重要事件有详细说明；
- 人物、事件、地点可以互相跳转；
- 来源可展开；
- 不把推定内容显示成确定事实；
- 现实历史与文学虚构有明确标识。

---

# 9. 功能七：人物关系图

## 9.1 目标

新增独立“关系”标签页。

选择单部作品时：

- 展示该作品核心人物网络；
- 点击人物后形成发散式关系图；
- 显示人物关系、变化时间和相关事件。

多作品模式时：

- 默认不显示跨作品人物关系；
- 只显示当前主作品；
- 后续再考虑主题级跨作品比较。

## 9.2 关系类型

至少支持：

```ts
relationshipType:
  | 'family'
  | 'romantic'
  | 'friend'
  | 'enemy'
  | 'ally'
  | 'mentor'
  | 'student'
  | 'employer'
  | 'employee'
  | 'political'
  | 'legal'
  | 'captor'
  | 'prisoner'
  | 'rival'
  | 'acquaintance'
  | 'other'
```

还需支持方向：

```ts
direction:
  | 'bidirectional'
  | 'source_to_target'
  | 'target_to_source'
```

## 9.3 关系变化

关系不是静态值。

数据结构必须支持阶段：

```ts
type PersonRelationship = {
  id: string
  workId: string
  sourcePersonId: string
  targetPersonId: string

  relationshipType: string
  direction: string

  labelZh: string
  labelEn: string
  summaryZh: string
  summaryEn: string

  startEventId?: string
  endEventId?: string
  startDate?: string
  endDate?: string

  strength?: number
  sentiment?: 'positive' | 'negative' | 'mixed' | 'neutral'
  status?: 'active' | 'ended' | 'changed' | 'unknown'

  sourceIds: string[]
}
```

## 9.4 图形交互

建议采用：

- Cytoscape.js；
- React Flow；
- D3 force graph。

优先推荐 Cytoscape.js，适合关系网络、筛选和图布局。

交互：

- 点击节点：聚焦人物；
- 双击节点：打开人物详情；
- 点击边：打开关系详情；
- 时间滑块：查看某个时间点的关系状态；
- 事件筛选：只显示某个事件前后的关系；
- “回到全图”；
- “只看直接关系”；
- “显示二级关系”。

## 9.5 视觉规则

节点：

- 颜色 = 作品颜色；
- 形状或图标 = 性别 / 年龄；
- 外圈 = 现实 / 虚构；
- 大小 = 叙事重要性。

连线：

- 家庭：实线；
- 爱情：双线或心形标签；
- 敌对：红色虚线；
- 盟友：绿色；
- 师生：箭头；
- 关系变化：渐变或分段。

注意不要只依赖颜色，必须同时使用线型、图标或标签。

## 9.6 时间元素

关系图底部增加局部时间控制：

```text
故事开始 —— 当前事件 —— 故事结束
```

拖动时：

- 只显示当时存在的关系；
- 已结束关系可淡出；
- 新建立关系动画出现；
- 地图同步显示人物所在地点；
- 右侧显示当前阶段重大事件。

## 9.7 验收标准

- 每部作品至少有 5–10 个核心人物；
- 至少 10 条关系；
- 点击人物可展开直接关系；
- 点击边可查看关系说明；
- 时间变化可影响关系状态；
- 地图、时间轴、关系图共享选中人物。

---

# 10. 三大视图联动架构

## 10.1 统一状态

建立统一 Explore State：

```ts
type ExploreState = {
  language: 'zh' | 'en'
  mode: 'single' | 'compare'

  selectedWorkIds: string[]
  primaryWorkId?: string

  selectedEntity?: {
    type: 'work' | 'person' | 'event' | 'location' | 'route' | 'relationship'
    id: string
    workId?: string
  }

  selectedTimeRange?: {
    start?: string
    end?: string
  }

  activePanel:
    | 'people'
    | 'events'
    | 'locations'
    | 'routes'
    | 'relationships'

  mapViewport?: {
    lat: number
    lng: number
    zoom: number
  }
}
```

## 10.2 联动规则

### 地图点击事件

- 更新 selectedEntity；
- 右侧切换到事件标签；
- 时间轴定位；
- 人物关系图高亮参与人物。

### 时间轴点击事件

- 地图 flyTo；
- 右侧显示详情；
- 关系图高亮人物。

### 人物点击

- 地图定位主要地点；
- 时间轴只显示人物事件；
- 关系图以人物为中心。

### 地点点击

- 地图聚焦；
- 右侧显示地点；
- 时间轴只显示该地点事件；
- 人物列表显示曾到访人物。

## 10.3 防止循环触发

必须区分：

```ts
selectionSource:
  | 'map'
  | 'timeline'
  | 'list'
  | 'relationship'
  | 'url'
```

状态变化后不要重复触发来源组件自身的动画。

---

# 11. 页面布局优化建议

## 11.1 桌面端

建议布局：

```text
顶部：标题、语言、作品选择器
第二层：当前作品、作品简介、分享
主体左侧：地图
主体右侧：人物 / 事件 / 地点 / 路线 / 关系
地图下方：世界历史时间轴
底部：来源与数据说明
```

关系图可以两种方式：

- 右侧标签页内展示；
- 点击“展开”后全屏。

建议采用第二种，避免右侧区域过窄。

## 11.2 响应式

### 大屏

- 地图 70%；
- 右栏 30%。

### 笔记本

- 地图 65%；
- 右栏 35%。

### 平板

- 地图上；
- 详情下；
- 时间轴可横向拖动。

### 手机

- 地图全宽；
- 底部 sheet；
- 关系图全屏；
- 作品选择器全屏抽屉。

---

# 12. 无障碍和可用性

必须加入：

- 键盘操作；
- focus 状态；
- aria-label；
- 图标 tooltip；
- 不只依赖颜色；
- 中英文文本长度适配；
- 低动态模式；
- 高对比度检查；
- 地图和时间轴的替代文字摘要。

用户开启 reduced motion 时：

- 禁用强烈 flyTo；
- 禁用脉冲；
- 改为短距离平移或直接定位。

---

# 13. 数据库升级建议

请先审计现有数据库。

建议至少包含以下表：

```text
works
work_translations

persons
person_translations

events
event_translations

locations
location_translations

routes
route_nodes

person_event_links
event_location_links
person_location_links

person_relationships
relationship_translations

sources
source_links

media_assets

chapters
work_chronologies
```

## 13.1 多语言

推荐两种方式之一：

### 方案 A：翻译表

```text
works
work_translations
```

适合长期扩展多语言。

### 方案 B：同表双字段

```text
title_zh
title_en
```

适合当前只做中英文。

当前项目已经明确只要求中英文，但未来可能继续扩展，优先评估翻译表方案。

## 13.2 坐标可信度

地点增加：

```ts
coordinateAccuracy:
  | 'exact'
  | 'approximate'
  | 'city_centroid'
  | 'inferred'
  | 'fictional'
```

## 13.3 历史边界

不要立即实现历史国界系统，但需要预留：

```ts
historicalRegionNameZh
historicalRegionNameEn
modernCountryCode
```

---

# 14. 视觉系统升级

## 14.1 作品颜色

每部作品分配稳定颜色：

```ts
work.themeColor
work.themeColorDark
work.themeColorLight
```

同一作品在：

- 地图；
- 时间轴；
- 人物关系图；
- 标签；
- 事件边框；

必须使用相同颜色。

## 14.2 现实类型视觉编码

建议：

| 类型 | 表达 |
|---|---|
| 真实历史文献 | 实心、档案标签 |
| 历史背景小说 | 实线 + 半透明 |
| 现实主义小说 | 柔和实心 |
| 完全虚构 | 虚线、星形纹理 |
| 虚构世界地图 | 独立图层 |

## 14.3 事件状态

- 精确日期：实心点；
- 约略日期：空心点；
- 时间范围：横条；
- 推定事件：虚线；
- 有争议：警示图标。

---

# 15. 性能要求

本轮目标数据规模：

```text
5 部作品
每部 5–10 人
每部 10–30 事件
每部 10–30 地点
每部 5–20 关系
```

性能目标：

- 首屏加载小于 3 秒；
- 地图交互无明显卡顿；
- 时间轴缩放流畅；
- 关系图 100 节点以内流畅；
- 切换语言不重新请求全部页面；
- 只加载当前选择作品的数据；
- 图片延迟加载；
- 大组件按需加载。

---

# 16. 开发顺序

请严格按照以下阶段执行。

## Phase 1：代码和数据审计

输出：

- `docs/ARCHITECTURE_AUDIT_v3.1.md`
- `docs/DATA_MODEL_GAP_ANALYSIS_v3.1.md`

内容包括：

- 当前技术栈；
- 当前状态管理；
- 当前数据库；
- 地图组件；
- 时间轴组件；
- 多语言逻辑；
- 可复用组件；
- 风险；
- 建议修改范围。

## Phase 2：统一状态和 URL

完成：

- Explore State；
- URL 同步；
- 单选 / 多选；
- 最大 5 部；
- 主作品。

## Phase 3：地图交互

完成：

- flyTo；
- 自动缩放；
- marker 高亮；
- 列表联动；
- 地点类型图标；
- 图层控制。

## Phase 4：人物系统

完成：

- 人物图标；
- 人物卡片；
- 人物筛选；
- 地图定位；
- 人物数据补充。

## Phase 5：世界时间轴

完成：

- BCE 至现代；
- 密度柱状图；
- 历史 / 叙事切换；
- 地图联动。

## Phase 6：人物关系图

完成：

- 节点；
- 关系边；
- 关系详情；
- 时间控制；
- 地图联动。

## Phase 7：内容和来源

完成：

- 事件详情；
- 地点详情；
- 来源；
- 可信度；
- 图片 attribution。

## Phase 8：UI、响应式和测试

完成：

- 桌面；
- 平板；
- 手机；
- 键盘；
- reduced motion；
- 性能；
- 回归测试。

---

# 17. 测试要求

## 17.1 单元测试

至少覆盖：

- 最多选择 5 部；
- 切换单选模式；
- URL 解析；
- BCE 时间排序；
- 模糊日期；
- 地点缩放级别；
- 人物关系时间过滤；
- 中英文回退。

## 17.2 集成测试

至少覆盖：

1. 点击事件；
2. 地图飞到地点；
3. 时间轴高亮；
4. 右侧显示详情；
5. 关系图高亮人物。

## 17.3 E2E

建议使用 Playwright。

场景：

```text
打开页面
选择双城记
点击事件
验证地图移动
打开人物
查看关系图
切换英文
刷新页面
验证状态保留
增加到 5 部作品
尝试选择第 6 部
验证被阻止
```

## 17.4 数据验证

建立数据检查脚本：

- ID 唯一；
- 外键有效；
- 人物关联存在；
- 地点坐标合法；
- 中英文必填字段完整；
- 来源存在；
- 精确时间格式有效；
- narrativeOrder 不重复；
- 关系不自指；
- 路线节点顺序正确。

---

# 18. 第一批完整闭环要求

当前主作品优先完成《双城记》。

《双城记》必须达到：

- 5–10 个核心人物；
- 15–25 个事件；
- 10–20 个地点；
- 3–5 条路线；
- 15 条以上人物关系；
- 完整中英文；
- 来源；
- 地图；
- 时间轴；
- 人物关系图；
- 事件详情；
- 地点详情。

其他作品可以先达到较低深度：

- 《安妮日记》；
- 《牧羊少年奇幻之旅》；
- 《霍比特人》。

每部至少：

- 5 人；
- 8 事件；
- 6 地点；
- 8 关系。

---

# 19. 本轮不做

为了控制范围，本轮不要优先实现：

- 3D 地球；
- Cesium 全套；
- 实时多人协作；
- AI 自动生成剧情；
- 用户评论；
- 登录系统；
- 商业付费；
- 全文版权内容；
- 自动抓取未授权图片；
- 跨作品人物关系推理；
- 复杂历史国界动画；
- 真实人物照片识别；
- VR / AR。

---

# 20. 最终交付文件

完成后必须提供：

```text
README.md
docs/ARCHITECTURE_AUDIT_v3.1.md
docs/DATA_MODEL_GAP_ANALYSIS_v3.1.md
docs/IMPLEMENTATION_PLAN_v3.1.md
docs/TEST_PLAN_v3.1.md
docs/DATA_SOURCE_POLICY_v3.1.md
docs/UI_INTERACTION_SPEC_v3.1.md
```

同时更新：

```text
CHANGELOG.md
.env.example
database schema
seed data
migration scripts
```

---

# 21. Codex 执行要求

请按照以下方式执行：

1. 先读完整项目；
2. 不要直接重写；
3. 先提交审计文档；
4. 再修改数据模型；
5. 再修改 UI；
6. 每个阶段完成后运行测试；
7. 每个阶段记录变更；
8. 保持现有功能可运行；
9. 避免一次性大文件改动；
10. 对不确定之处写入 TODO，不要擅自编造文学事实。

每个阶段完成后输出：

```text
完成内容
修改文件
数据库变化
测试结果
已知问题
下一阶段
```

---

# 22. 最终验收标准

本轮完成后，用户应能完成以下完整流程：

1. 打开世界文学名著时空地图；
2. 选择 1–5 部作品；
3. 点击某个城市；
4. 地图自动缩放居中；
5. 查看城市相关事件、人物和地标；
6. 点击人物；
7. 查看人物卡片；
8. 在地图中定位人物；
9. 打开人物关系图；
10. 查看人物关系随故事时间变化；
11. 切换到完整历史时间轴；
12. 从公元前到现代查看事件密度；
13. 点击时间轴事件；
14. 地图和详情同步；
15. 切换中英文；
16. 刷新后状态保留；
17. 查看来源和可信度；
18. 分享当前深链接。

完成以上闭环后，才算 v3.1 MVP 升级完成。
