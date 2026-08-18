# 《红楼梦 Atlas》测试与验收计划

- 状态：`draft`
- 日期：`2026-08-15`

## 1. 测试层级

1. schema / migration；
2. seed invariants；
3. API contract；
4. graph derivation；
5. interaction；
6. accessibility；
7. visual/responsive；
8. performance；
9. static parity；
10. regression。

## 2. 数据不变量

- 人物 slug 在 work 内唯一；
- canonical relation 两端不能相同；
- relation 两端属于同一 work；
- phase chapter range 合法；
- published phase 至少一条 evidence；
- evidence passage 与 edition/chapter 一致；
- 0–5 值合法，unknown 为 null；
- power/dependency 方向明确；
- interaction 至少 2 个参与者或有明确缺席对象；
- corpus layer 合法；
- core_80 与 continuation_40 不互相覆盖；
- published 中文人物、关系、phase 完整；
- 英文 fallback 明确；
- 未授权内容不进入 public path。

## 3. 单元测试

### 关系派生

- 当前章回前未形成的关系隐藏；
- 已结束关系按模式隐藏或降级；
- phase 切换正确；
- 五维方向不反转；
- lens 只突出相关维度；
- focus depth 1 不泄漏无关节点；
- compare 共同/独有集合正确；
- path mode 过滤 facet 正确；
- 群体聚合计数不重复。

### Explore State

- URL round trip；
- 非法人物/章回/lens 正常归一；
- continuation 默认关闭；
- locale 切换保留状态；
- back/forward 恢复 graph 与 drawer。

## 4. API 测试

正例：

- network index；
- focus；
- compare；
- path；
- character detail；
- relationship detail；
- chapter delta；
- zh-CN / en；
- core_80 / continuation_40。

负例：

- 未知 work 404；
- 未知人物 404；
- relation UUID 无效 400；
- chapter 0/121 400；
- 不支持 lens 400；
- 不允许的 corpus layer 400；
- unpublished translation 不泄漏；
- rights denied excerpt 不泄漏。

## 5. 关键浏览器旅程

### Journey A：人物焦点

1. 打开首页；
2. 搜索“林黛玉”；
3. 选择人物；
4. 显示 6–12 个核心关系；
5. 选中贾宝玉关系；
6. 打开 phase 与证据；
7. 复制深链接；
8. 刷新后恢复。

图像检查：

- 关系图头像与人物详情为同一张脸；
- 头像 32px、48px、72px 可辨；
- portrait 与 fullbody 的发式、首饰和主服装一致；
- 图片加载失败时人物名和关系仍完整可用。

### Journey B：比较

1. 选择林黛玉；
2. 进入 compare；
3. 选择薛宝钗；
4. 切换 power / care lens；
5. 共同人物和独有关系正确；
6. 移动端可退出 compare。

### Journey C：章回播放

1. 选择一段章回；
2. 播放；
3. 节点位置保持连续；
4. 新增/变化/结束关系正确；
5. 暂停后打开当前互动；
6. reduced motion 下无动画但有文字变化摘要。

### Journey D：关系表

1. 用键盘切到 table；
2. 排序；
3. 聚焦人物；
4. 打开关系；
5. 关闭 drawer；
6. focus 返回原行。

### Journey E：版本层

1. 默认只见 core_80；
2. 打开 continuation_40；
3. 明确显示版本徽标；
4. phase 分轨；
5. 关闭后状态恢复。

## 6. 可访问性

- 所有控件有名称；
- tab order 与视觉一致；
- 无键盘陷阱；
- skip link 可用；
- table 为图的等价替代；
- Canvas 不承载唯一文本；
- focus visible；
- 文本 ≥4.5:1；
- 关系图形 ≥3:1 且有冗余；
- drawer focus trap 和 restore 正确；
- live region 不在播放时每帧轰炸；
- reduced motion/data 可用；
- 200% zoom 无横向页面溢出。

## 7. 视觉与响应式

视口：

- 390×844；
- 768×1024；
- 1280×800；
- 1440×900；
- 1920×1080 抽检。

检查：

- 中英文长标签；
- 人物名不裁切；
- 关系 tooltip 不出界；
- 章回播放器不挡 drawer；
- full graph 有退出路径；
- 图例不遮节点；
- loading 无 CLS；
- 空状态不是错误色；
- continuation/disputed 状态可辨。

人物图像另需验证：

- 8 人原型的容貌彼此可辨；
- 年龄与身份合理；
- 无现代妆造、现代旗袍或影视演员相似性；
- 手部、发簪、耳饰、领口、腰带、衣袖、下摆和鞋履无明显生成错误；
- 丫鬟与主家人物的首饰和衣料等级合理；
- 长辈没有被不当年轻化；
- 无文字、水印、伪签名；
- 中英文 alt 与画面一致。

## 8. 性能预算候选

Phase 1（前八十回）：

- 首屏静态数据 gzip ≤ 500 KB；
- 首屏 JS 增量尽量 ≤ 150 KB gzip；
- network index parse ≤ 30ms 桌面、≤ 80ms 中档移动；
- focus 切换响应 ≤ 100ms；
- chapter step 派生 ≤ 50ms；
- graph animation 目标 60fps，最低不持续低于 45fps；
- drawer detail 首次显示 ≤ 300ms 本地/缓存；
- CLS < 0.1。

Phase 2（后四十回）合并进可选 continuation layer 后重新测量，不把候选预算写成已通过事实。

## 9. Static parity

比较动态与静态：

- 人物 ID/slug；
- relation/phase/evidence 数量；
- locale/fallback；
- focus network 抽样；
- compare 抽样；
- path 抽样；
- chapter delta；
- rights denied 内容；
- manifest checksum；
- stale extra files。

## 10. 回归

至少运行：

```text
npm run typecheck
npm test
npm run build
现有 Bible / Three Kingdoms / Galaxy / Art / Music profile tests
```

新增 profile 不得改变既有 tab、关系图 tier、主题 token、static bake 或 API 响应。

## 11. Release Gate

- Gate A：文档冻结；
- Gate B：fixture 技术试验；
- Gate C：隔离数据库；
- Gate D：本地动态 UI；
- Gate E：静态 artifact；
- Gate F：staging；
- Gate G：production，必须单独授权。
