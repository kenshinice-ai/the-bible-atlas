# 《红楼梦 Atlas》关系模型

- 状态：`draft`
- 日期：`2026-08-15`
- 目标：让关系成为有方向、有阶段、有证据的叙事对象

## 1. 关系建模原则

1. 关系不是单一情绪。
2. 关系可以同时属于多个类型。
3. 关系在不同章回会变化。
4. 关系常常不对称。
5. 亲密不等于权力平等。
6. 有血缘不等于有实际互动。
7. 每个发布判断必须可回到文本或来源。
8. 编辑推断与文本直接陈述必须分开。

## 2. 四层结构

### 2.1 Canonical relationship

表示两个人之间持续存在的关系容器，例如：

- 贾宝玉 ↔ 林黛玉；
- 王熙凤 → 平儿；
- 贾政 → 贾宝玉。

它保存稳定身份和全局摘要，不直接承担所有章回细节。

### 2.2 Relationship facets

同一关系可以同时拥有多个 facet：

| facet | 含义 | 方向示例 |
|---|---|---|
| kinship | 血缘或姻亲 | 常为双向，但称谓有方向 |
| romantic_affection | 爱慕或亲密情感 | 可不对称 |
| friendship | 友情与同辈交往 | 可双向 |
| marriage | 婚姻事实或制度安排 | 双向事实，权力未必对称 |
| household_authority | 家内命令与治理 | 上位者 → 下位者 |
| master_servant | 主仆制度 | 主人 → 仆役；照护可反向 |
| care | 照护、保护、安慰 | 可双向或单向 |
| mentorship | 教导、规训、学习 | 指导者 → 学习者 |
| economic_dependency | 经济资源或生存依赖 | 资源方 → 依赖方 |
| rivalry | 竞争 | 可双向 |
| conflict | 公开或隐性冲突 | 可双向或单向 |
| alliance | 合作与共同利益 | 可双向 |
| secrecy | 秘密共享、隐瞒或监视 | 方向必须说明 |
| symbolic_parallel | 叙事或主题对照 | 仅 editorial/scholarly 层 |

### 2.3 Relationship phase

一条关系按章回范围拆为阶段：

```text
emergence → closeness → strain → rupture → repair → transformed → ended
```

不是每条关系都必须经过全部状态。每个 phase 至少包含：

- `chapter_start`；
- `chapter_end`；
- `phase_type`；
- 双语摘要；
- 五维值；
- 至少一条 evidence；
- `attestation`；
- `review_status`。

### 2.4 Interaction event

表示一次具体互动：

- 会面；
- 对话；
- 赠予；
- 冲突；
- 照护；
- 惩戒；
- 传话；
- 隐瞒；
- 共同创作；
- 离别；
- 婚姻安排；
- 死亡造成的关系终止。

interaction event 可以关联 2..N 人，不能强制拆成多个失去语境的二元事件。

## 3. 五维关系值

每个 phase 可记录 0–5：

| 维度 | 0 | 5 |
|---|---|---|
| affection | 无可见亲近 | 极高亲密/爱慕/怜惜 |
| trust | 无信任或未知 | 高度托付与秘密共享 |
| power | 无明显支配 | 一方能直接决定另一方处境 |
| dependency | 几乎独立 | 生存、身份或情感高度依赖 |
| conflict | 无明显冲突 | 持续或决定性冲突 |

规则：

- 不计算“关系健康分”；
- 不把五维相加；
- 每个值须有简短 rationale；
- `power` 必须带方向；
- `dependency` 可双向分别记录；
- 未知使用 `null`，不使用 0 代替未知。

## 4. 方向与不对称

现有 `source_to_target` 不足以表达多维方向。候选结构：

```text
dimension_values:
  affection:
    from_to: 4
    to_from: 5
  power:
    from_to: 1
    to_from: 0
```

Phase 1 若为控制复杂度，可先在数据库中保存：

- `from_to_value`;
- `to_from_value`;
- `direction_note`;

UI 以双向小条或相对箭头显示，不把一个数涂在整条边上。

## 5. 证据等级

| attestation | 含义 |
|---|---|
| `text_direct` | 章回文本直接描述或明确行动支持 |
| `text_contextual` | 由连续场景和上下文支持 |
| `commentary` | 版本评语、批语或传统评论 |
| `scholarly_interpretation` | 现代研究论述 |
| `editorial_inference` | 本站为可视化所作的透明归纳 |
| `disputed` | 存在重要分歧，需并列 |

UI 默认显示 `text_direct` 和 `text_contextual`，其他层可打开。

## 6. 关系类型与视觉编码

颜色不直接绑定唯一关系类型，而绑定当前 lens：

- 默认：人物群体着色，边按主要 facet 线型；
- 情感 lens：affection 强度改变线宽；
- 权力 lens：箭头与 power 强度突出；
- 照护 lens：care 与 dependency 突出；
- 冲突 lens：conflict 边突出；
- 亲属 lens：kinship / marriage 采用树形或正交布局。

同一时刻最多突出一个 lens，避免五种颜色同时争抢注意力。

## 7. 聚合规则

### 群体层

群体间边显示：

- 关系数量；
- 参与人数；
- 主导 facet；
- 章回范围；
- 冲突/照护等可切换汇总。

不得把 20 条弱关系聚合成一条“强关系”而不说明数量。

### 焦点层

默认排序：

1. 当前章回活跃关系；
2. 与焦点人物的直接关系；
3. 编辑重要性；
4. 最近发生变化；
5. 强度。

### 完整层

- ≤100 节点使用 Canvas；
- 超过 100 节点仍先按群体/焦点过滤；
- 不允许默认渲染 500+ 节点；
- 完整层必须保留邻接表、搜索和筛选。

## 8. 路径查询

至少支持：

```text
shortest          最少边
kinship           仅亲属/婚姻
power             权力控制链
care              照护与依赖链
shared_events     共同互动事件
narrative         编辑标记的最有解释力路径
```

路径结果必须显示“为什么经过此人”，不能只高亮一条线。

## 9. 待裁决问题

- 五维值是否存 0–5，还是 low/medium/high；
- symbolic parallel 是否与人物关系分表；
- 同一人物对是否允许多个 canonical relationship；
- 关系阶段是否允许重叠；
- 后四十回是否新建 phase，还是建立平行版本 branch；
- 关系强度是否继续保留为兼容字段，还是由 UI 派生。
