# 项目交接文档(HANDOFF)

## 项目现状

v4 Bible-first 架构已落地并提交(commit `9b47ea0`):以「时代 → 人物群 → 个人」的缩放层级取代此前基于实体数量上限的展示方式。

技术栈:
- 前端:React 19 + Vite + Leaflet + d3-force
- 后端:Express + PostGIS API

`styles.css` 已全面重写为暗色设计系统,要求:
- 触控目标 ≥ 44px
- 对比度 ≥ 4.5:1
- 支持 `prefers-reduced-motion`
- 响应式适配 375–1440 宽度

## 最近完成

1. 删除 v3.1 遗留的死组件、修复类型错误,25 个测试全部通过。
2. 移除残留的渲染上限:搜索结果 40/60 → 全量/200,时间轴 4 → 6 泳道 + 自适应刻度。
3. 关系图:支持节点拖拽固定(双击释放)、点击连线打开关系详情、情感图例、重置视图、隐藏计数提示。
4. 事件抽屉:支持上/下一事件导航、子事件展示、相关路线;人物与地点抽屉中的相关事件可点击跳转。
5. 修复地图空白 bug:容器未完成布局时 `fitBounds` 会产生错误视口,已通过 `ResizeObserver` 延迟定位解决。
6. 圣经排入作品目录第一位(seed 008)。

## 正在进行

全圣经数据扩充,目标规模:约 306 位人物 / 约 1531 个事件。

按 13 个时代拆分,各由一个并行代理生成种子文件:

- primeval
- patriarchs
- exodus-and-sinai
- wilderness-and-conquest
- judges
- united-monarchy
- divided-kingdoms
- prophetic-narrative
- judah-and-exile
- return-and-restoration
- gospels
- acts
- pauline-mission

对应文件:`db/seeds/010–022_bible_full_*.sql`,统一遵循共享规范:
- UUID 前缀:`人物 43` / `事件 33` / `关系 63` / `其他 73` + `000000-0000-4000-80KK-`(KK 为时代编号)
- 事件 sequence 区间:`K*1000+1` 至 `K*1000+999`
- 双语翻译(中/英)
- 宽年代范围标注
- 来源引用

后续步骤:统一装载 → 全局 sequence 重排(023)→ 验证 → 提交。

## 下一步

1. 装载 13 个种子文件
2. 修复装载过程中的错误
3. 执行全局 sequence 重排
4. 浏览器端验证(注意性能:约 1500 个事件的 atlas lite 载荷预估 1.5–3MB)
5. 提交代码

远期规划:
- 媒体资产扩充(`media_assets` 表当前为 0 条记录)
- 其他四部作品(圣经之外)的数据扩充

## 本地运行方法

本地 Postgres 已存在 `literary_atlas` 库(启用 PostGIS)。

**启动 API:**
```bash
cd apps/api && DATABASE_URL="postgresql://llmacbookpro@localhost:5432/literary_atlas" API_PORT=4000 npx tsx src/index.ts
```

**启动 Web:**
```bash
cd apps/web && npx vite --port 5173
```

注意:端口 4000/5432 可能被旧 Docker 栈占用,遇到冲突执行 `docker compose down` 即可解决。

**执行种子导入:**
```bash
npx tsx src/db-cli.ts seed
```
(该命令幂等,导入记录保存在 `seed_history` 表中。)

---

更新时间:2026-07-26
本文档由代理在每个阶段完成后自动更新。
