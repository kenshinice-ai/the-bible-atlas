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

1. **策略调整**:全圣经扩充由「13 个时代一次性全量」改为「小步走」——每个时代只保留最著名事件(15–25 个),先跑通测试,内容以后再补齐。
2. **6 个时代种子已生成并装载**:
   - 第一批(commit `d9bd0d5`):`010` primeval(50 事件)、`013` wilderness-and-conquest(33)、`017` prophetic-narrative(23)、`021` acts(24);另有 `023_bible_global_sequence_rebands.sql` 把所有圣经事件重排进 `K*1000` 时代区间(对未扩充时代也生效,幂等安全)
   - 第二批(小步走):`011` patriarchs(时代共 40 事件,新增 21)、`012` exodus-and-sinai(共 26,新增 16;并回填了 013 装载时因 `eleazar-son-of-aaron` 缺失被丢弃的参与者记录)
   - 第三批(2026-07-27):`014` judges 已装载并登记 `seed_history`(时代共 29 事件,sequence 5001–5057;孤儿检查零行)
   - 第四批(2026-07-27):`015` united-monarchy(时代共 31 事件,新增 16;新增 13 人物/6 地点)、`016` divided-kingdoms(共 28,新增 18;新增 15 人物/4 地点)已装载并登记,孤儿检查零行
   - 当前库内:**191 人物 / 347 事件 / 109 地点**,13 个时代 sequence 全部单调、无重复;浏览器已验证渲染正常(第三/四批装载后未重验)
   - 手动装载的种子已登记 `seed_history`
3. **UI 修复**(commit `08ff5b5`),浏览器已验证:
   - 标题层衬线字体(`--font-display`,离线系统栈)
   - 选中路线/人物轨迹的流动虚线方向动画(修复了 Leaflet className 不更新的隐性 bug)
   - 时间轴「年代不详」chips 超过 12 个自动折叠
4. **UI 评估结论**(记入远期规划):不做 3D;phase 2 可考虑可选的地球仪模式。
5. `.claude/launch.json` 已加 `api` 条目(bash 包 `DATABASE_URL` 启动 tsx)。
6. **种子完整性审计**(2026-07-26):`db/seeds/` 下 13 个文件全部完整,无半成品——`001–007` 为 v4 基础数据(均以 `COMMIT;` 收尾),`008` 是刻意不带事务包装的 8 行 `launch_rank` 调整,`010/013/017/021/023` 均通过回滚自测后装载;`seed_history` 与磁盘文件一一对应。编号空缺(`009` 与下列 9 个)不是残留半成品,而是尚未生成的文件;被中止的生成代理没有留下任何残缺文件。

## 正在进行

1. ~~架构维护~~ 已完成(commit `a14c130` / `2cb3349`):一键启动脚本改为本地栈(前置检查/自动建库/端口冲突/PID 幂等)、`.env.example` 集中配置、`docs/DEPLOYMENT.md` 部署指南、README 快速启动更新;依赖体检 `npm audit` 0 漏洞,过期项均为跨大版本仅记录未升级
2. 种子扩充已于 2026-07-27 **恢复**:
   - `014` judges、`015` united-monarchy、`016` divided-kingdoms 已装载并登记(见「最近完成」)
   - 剩余 4 个时代种子(`018` judah-and-exile / `019` return-and-restoration / `020` gospels / `022` pauline-mission)生成代理正在并行运行(用户要求全部同时执行);完成后按编号顺序装载(保证跨时代人物引用不丢行)、验证、提交
   - `019` 已生成并通过回滚自测(新增 11 人物/16 事件,时代共 23 事件,seq 10001–10045,无跨时代依赖),**已入 git 但尚未装载、`seed_history` 无记录**;等 `018` 装载后再按序装载
   - 共享规范文档已固化进仓库:`db/seeds/bible-seed-spec.md`(原件在旧会话 scratchpad,已复制),包含 UUID 前缀、sequence 区间、时间标注规范、跨时代人物归属规则;注意其中自测命令里的 SCRATCH 路径属于旧会话,使用时替换为当前可写临时目录
   - 如需重新生成,可参考 `010/013/017/021` 作为模板

种子文件统一遵循共享规范:
- UUID 前缀:`人物 43` / `地点 33` / `事件 63` / `关系 73` + `000000-0000-4000-80KK-`(KK 为时代编号,与 `010/013/017/021` 实际用法一致)
- 事件 sequence 区间:`K*1000+1` 至 `K*1000+999`
- 双语翻译(中/英)
- 宽年代范围标注
- 来源引用

## 下一步

1. 生成并装载剩余 7 个时代种子(小规模,每时代 15–25 个最著名事件;每批 2 个,装载验证后提交)
2. 真实数据量下的三视图压测与参数微调(当前 UI 优先级)
3. 媒体资产扩充(`media_assets` 表当前为 0 条记录)
4. 其他四部作品(圣经之外)的数据扩充

远期规划:
- 不做 3D;phase 2 可考虑可选的地球仪模式

## 本地运行方法

本地 Postgres 已存在 `literary_atlas` 库(启用 PostGIS)。

**启动 API:**
```bash
cd apps/api && DATABASE_URL="postgresql://llmacbookpro@localhost:5432/literary_atlas" API_PORT=4000 npx tsx src/index.ts
```
(也可通过 `.claude/launch.json` 的 `api` 条目启动。)

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

更新时间:2026-07-27
本文档由代理在每个阶段完成后自动更新。
