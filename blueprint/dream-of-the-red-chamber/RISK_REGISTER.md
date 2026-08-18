# 《红楼梦 Atlas》风险登记

- 状态：`draft`
- 日期：`2026-08-15`

| ID | 风险 | 概率 | 影响 | 触发器 | 缓解 |
|---|---|---:|---:|---|---|
| RC-R01 | 产品被理解为爱情三角图 | 高 | 高 | 首屏只见宝黛钗、粉色主题 | 增加权力/照护/阶层 lens，刘姥姥与王熙凤旅程 |
| RC-R02 | 全网图过密 | 高 | 高 | 默认 50+ 节点、边标签常显 | focus 默认、LOD、table、标签按需 |
| RC-R03 | `sentiment` 过度简化 | 高 | 高 | 一条边只有正负 | facets + phases + 五维方向 |
| RC-R04 | 关系分数显得伪科学 | 中 | 高 | 用户把 0–5 当客观测量 | 显示 rationale/evidence，不合计，不排名 |
| RC-R05 | 底本与版本混乱 | 高 | 高 | 引文定位漂移、前后四十回混用 | 冻结 edition、checksum、corpus layer |
| RC-R06 | 英译侵权 | 中 | 高 | 直接抓现代译本 | 原创摘要、公版/许可资源、fail closed |
| RC-R07 | 现代整理本权利不清 | 中 | 高 | 打包标点/校注全文 | 短引、权利审计、外链 |
| RC-R08 | 影视形象替代原著 | 高 | 高 | 生成图接近演员、剧照或特定改编 | 原创 style bible、相似性审核、禁用改编参考 |
| RC-R09 | 女性人物被单一性格标签化 | 中 | 高 | 节点卡使用“善/恶/心机” | 身份、处境、行动、证据优先 |
| RC-R10 | 第一期约 35 人范围被误称完整 | 高 | 中 | 宣传只写“完整红楼人物图谱” | 明示核心/上下文范围与 coverage |
| RC-R11 | 章回播放导致布局跳动 | 高 | 中 | 每回重跑随机 force | 稳定 seed、位置缓存、delta 更新 |
| RC-R12 | Canvas 无障碍不足 | 高 | 高 | 只有图可操作 | DOM table/list 等价入口 |
| RC-R13 | 移动端不可用 | 中 | 高 | full graph 默认、控件拥挤 | focus 默认、sheet、compact rail |
| RC-R14 | 新 profile 继续堆硬编码 | 高 | 高 | 多处 `PROFILE.id` 分支 | workspace/timeline/relation adapters |
| RC-R15 | 关系编辑成本失控 | 高 | 高 | 每条边都需多阶段与证据 | 先约 20 核心 + 15 上下文，前后四十回分阶段 |
| RC-R16 | AI 生成关系幻觉 | 中 | 高 | 自动内容直接发布 | candidate-only、人工审核、证据门禁 |
| RC-R17 | 版本争议被产品定论化 | 中 | 高 | continuation 覆盖 core | 平行 layer、徽标、并列 phase |
| RC-R18 | 配色过度“古风” | 中 | 中 | 低对比纸纹、金字、小篆 | 编辑型布局、AA 对比、系统字体 |
| RC-R19 | 配色过度粉红 | 高 | 中 | romance palette | 绛雪夜读 palette，多语义色 |
| RC-R20 | 当前 dirty worktree 被误改 | 中 | 高 | 混合提交/回退 | 文档独立目录、实施另分支、先审状态 |
| RC-R21 | 内容计数替代质量 | 高 | 中 | 只宣传边数 | phases/evidence/coverage 分别报告 |
| RC-R22 | 场景图伪精确 | 中 | 中 | 平面布局被当史实 | 明示 topology/layout，来源与置信度 |
| RC-R23 | 多群体成员导致聚合重复 | 中 | 中 | 群体边计数膨胀 | primary group + explicit aggregation rule |
| RC-R24 | 播放时 URL/React 更新过频 | 中 | 中 | history 写入每帧 | chapter-step 更新、节流、批处理 |
| RC-R25 | 人物脸同质化 | 高 | 高 | 多人头像只有服装不同 | 逐人物 facial brief、8 人先验收、身份一致性表 |
| RC-R26 | 服饰与首饰等级混乱 | 中 | 高 | 丫鬟比主家更华贵、现代旗袍化 | 建立身份等级、材质和首饰清单 |
| RC-R27 | 图像生成畸形 | 高 | 中 | 手指、发簪、衣袖、鞋履错误 | portrait/fullbody 人工 QA，失败即返工 |
| RC-R28 | 人物过度年轻化或性化 | 中 | 高 | 长辈无年龄、年轻人物姿态不当 | 年龄适配与尊严原则，发布前专项审查 |
| RC-R29 | 约 140 个图像文件拖慢首屏 | 中 | 高 | 首屏预载全部 master | AVIF/WebP、响应式尺寸、lazy load、只预载焦点头像 |

## 高优先级阻断

以下风险未缓解前不得进入 production：

- RC-R03 关系简化；
- RC-R05 版本混乱；
- RC-R06 英译权利；
- RC-R12 Canvas 无障碍；
- RC-R14 硬编码架构；
- RC-R17 争议定论化。

## 风险评审频率

- Gate 0 结束时一次；
- 每个 migration 前一次；
- 内容批次导入前后各一次；
- static bake 前一次；
- production 授权前一次。
