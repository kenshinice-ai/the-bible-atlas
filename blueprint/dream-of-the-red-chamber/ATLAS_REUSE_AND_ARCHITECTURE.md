# 《红楼梦 Atlas》复用与架构方案

- 状态：`draft`
- 日期：`2026-08-15`
- 基线：当前 monorepo 的 Bible / Three Kingdoms / Galaxy / Art / Music profiles

## 1. 总体决定

《红楼梦 Atlas》先作为现有 monorepo 的一方 profile 建设，而不是新建独立仓库。

候选配置：

```ts
{
  id: "red-chamber",
  works: ["dream-of-the-red-chamber"],
  active: "dream-of-the-red-chamber",
  mode: "single",
  defaultLocale: "zh-CN",
  title: ["红楼梦 Atlas", "Dream of the Red Chamber Atlas"],
  tagline: [
    "在章回流转中，看见情、礼、权与命运如何相互牵引",
    "Affection, ritual, power and fate across the chapters"
  ],
  theme: "red-chamber",
  specialization: "narrative-network",
  tabs: ["relations", "characters", "chapters", "scenes", "sources"],
  defaultTab: "relations",
  graphLevels: ["group", "major", "all"],
  defaultGraphLevel: "major"
}
```

当前 `specialization` 和 `ProfileTab` 是封闭联合，实施时需要扩展，不能把新语义硬塞进 `base`。

## 2. 可直接复用的模块

### Web

- `profile.ts` 和 `profile-meta.ts`；
- `RelationGraph.tsx` 的 Canvas、force、zoom、fit、drag；
- `hierarchy.ts` 的 graph aggregation 思路；
- Explore State URL 序列化；
- `EntityDrawer` shell；
- `GlobalSearch` 模式；
- i18n 与 published fallback；
- CSS custom properties；
- virtual list；
- relation adjacency table。

### API

- work/locale 解析；
- detail endpoint 模式；
- search；
- source/media publication gate；
- static bake；
- Zod response validation；
- migration/seed runner。

### Ops

- 本地启动；
- static Cloudflare Pages 发布模式；
- release artifact；
- verifier 与 handoff 纪律。

## 3. 不应直接复用的假设

1. `events` 是所有作品的默认主 tab；
2. 地图是 workspace 左侧主舞台；
3. `chapter` 等同于历史 era；
4. 人物按首次 era 着色；
5. relation sentiment 是主要视觉编码；
6. 人物详情包含生卒年与出生地；
7. 地点必须能飞到经纬度；
8. 图的四级必须固定为 era/group/major/all；
9. drawer 只有单一通用字段表；
10. `Atlas` full payload 是所有领域的最终形态。

## 4. 建议抽象的 Core 能力

### 4.1 Workspace descriptor

```ts
type WorkspaceKind =
  | "map"
  | "relationship"
  | "artwork"
  | "score";
```

每个 profile 声明 primary visualization、secondary visualization、bottom rail、default drawer 和 mobile fallback。

### 4.2 Timeline adapter

```ts
type TimelineAdapter =
  | { kind: "historical" }
  | { kind: "narrative-sequence"; unit: "event" }
  | { kind: "chapter"; total: number; bands: ChapterBand[] };
```

### 4.3 Relation semantics adapter

让 profile 定义：

- lens；
- edge style；
- node color strategy；
- detail sections；
- phase labels；
- compatibility sentiment；
- path modes。

避免在 `RelationGraph.tsx` 写大量 `if (PROFILE.id === "red-chamber")`。

### 4.4 Entity registry

该项目需要的新 kind：

- `character`
- `relationship`
- `interaction`
- `chapter`
- `scene`
- `source`

每个 kind 声明 schema、search、selection、drawer、static bake 和 count。

## 5. 推荐目录

```text
apps/web/src/domains/red-chamber/
  profile.ts
  relationship-adapter.ts
  chapter-player.tsx
  focus-network.tsx
  compare-network.tsx
  relation-reader.tsx
  scene-topology.tsx
  i18n.ts

apps/api/src/domains/red-chamber/
  schema.ts
  loader.ts
  network.ts
  path.ts
  detail.ts
  bake.ts

db/seeds/red-chamber/
  corpus/
  characters/
  relationships/
  interactions/
  translations/
```

## 6. 关系图复用策略

保留：

- Canvas；
- d3-force；
- fit transform；
- zoom/pan；
- 节点拖动；
- position persistence；
- hover/select；
- table fallback。

新增：

- ego network；
- compare layout；
- chapter phase transitions；
- directed multi-dimensional edge rendering；
- selected path；
- stable seeded positions；
- group hull 可选；
- keyboard-driven DOM relation list。

重构建议：

```text
RelationGraph shell
  ├─ graph model adapter
  ├─ layout strategy
  ├─ canvas renderer
  ├─ interaction controller
  └─ accessible relation table
```

不要复制 `RelationGraph.tsx` 成第二份大型组件。

## 7. 性能策略

- 20–100 人使用 Canvas；
- `buildGraph` 建立 Map 索引，避免重复 `find`；
- 章回播放只更新变化边，不重建所有对象；
- layout 使用稳定 seed；
- 重型 path/centrality 可放 Web Worker；
- 在实际 100 人 / 300 关系 / 1000 互动规模测量后再决定 graphology；
- 首屏只载入 lite index，关系/人物详情按需。

## 8. 数据边界

Core 负责：

- work、locale、identity、transport、selection、drawer shell、static、rights。

Red Chamber domain 负责：

- corpus layer；
- chapter/passages；
- interaction；
- relationship facets/phases；
- lens；
- path；
- scene topology；
- editorial evidence。

Core 不应理解“宝黛钗”“金陵十二钗”或前八十回。

## 9. 对现有项目的改进价值

如果按 adapter/registry 实现，该项目还能改善：

- Three Kingdoms 的正史/演义双层关系；
- Bible 的关系生命周期；
- Galaxy 的阵营/家族路径；
- Art/Music 的人物合作网络；
- 《山海经》的领域关系与文本证据。

因此它是一次“关系型 Atlas Core”升级，而不只是内容换皮。
