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
2. **13 个时代种子全部生成并装载完毕(2026-07-27 圣经小步走扩充完成)**:
   - 第一批(commit `d9bd0d5`):`010` primeval(50 事件)、`013` wilderness-and-conquest(33)、`017` prophetic-narrative(23)、`021` acts(24);另有 `023_bible_global_sequence_rebands.sql` 把所有圣经事件重排进 `K*1000` 时代区间(对未扩充时代也生效,幂等安全)
   - 第二批(小步走):`011` patriarchs(时代共 40 事件,新增 21)、`012` exodus-and-sinai(共 26,新增 16;并回填了 013 装载时因 `eleazar-son-of-aaron` 缺失被丢弃的参与者记录)
   - 第三批(2026-07-27):`014` judges 已装载并登记 `seed_history`(时代共 29 事件,sequence 5001–5057;孤儿检查零行)
   - 第四批(2026-07-27):`015` united-monarchy(时代共 31 事件,新增 16)、`016` divided-kingdoms(共 28,新增 18)已装载并登记,孤儿检查零行
   - 第五批(2026-07-27,4 代理并行生成、按编号顺序装载):`018` judah-and-exile(共 28,新增 15)、`019` return-and-restoration(共 23,新增 16)、`020` gospels(共 33,新增 15)、`022` pauline-mission(共 26,新增 13;patmos-vision 保持 81–96 年置于区间末尾)
   - 当前库内:**239 人物 / 406 事件 / 116 地点 / 275 关系**,13 个时代 sequence 全部单调、无重复、区间不越界;全库圣经事件孤儿检查零行(其余 9 行孤儿全部属于其他四部作品的 v1 老数据,与圣经无关)
   - 注:浏览器渲染在第三~五批装载后尚未重验(下一步 UI 压测时一并做)
   - 手动装载的种子已登记 `seed_history`
3. **UI 修复**(commit `08ff5b5`),浏览器已验证:
   - 标题层衬线字体(`--font-display`,离线系统栈)
   - 选中路线/人物轨迹的流动虚线方向动画(修复了 Leaflet className 不更新的隐性 bug)
   - 时间轴「年代不详」chips 超过 12 个自动折叠
4. **UI 评估结论**(记入远期规划):不做 3D;phase 2 可考虑可选的地球仪模式。
5. `.claude/launch.json` 已加 `api` 条目(bash 包 `DATABASE_URL` 启动 tsx)。
6. **种子完整性审计**(2026-07-26):`db/seeds/` 下 13 个文件全部完整,无半成品——`001–007` 为 v4 基础数据(均以 `COMMIT;` 收尾),`008` 是刻意不带事务包装的 8 行 `launch_rank` 调整,`010/013/017/021/023` 均通过回滚自测后装载;`seed_history` 与磁盘文件一一对应。编号空缺(`009` 与下列 9 个)不是残留半成品,而是尚未生成的文件;被中止的生成代理没有留下任何残缺文件。

## 正在进行

-6. **上线三部曲(2026-07-27,进行中)**:目标 = ① 神职人员标准内容审计 ② 双语默认英文 ③ 完整部署方案。
   - ② 已完成并浏览器验证:默认 locale 改为 en(state.ts,`?lang=zh-CN`/`?locale=zh-CN` 仍可直达中文),index.html lang="en",新增默认语言测试
   - ① 审计代理进行中:epigraphs 逐字对照和合本1919/KJV、i18n 称谓、库内翻译抽样 → docs/CLERGY_AUDIT.md + 027 修正种子
   - ③ 部署代理进行中:验证生产构建/镜像、CORS 收敛、deploy/(compose.prod + Caddyfile/nginx + deploy.sh)、DEPLOYMENT.md 生产篇(VPS Docker 推荐 + PaaS + 静态化远期)

-5. **关系页签分行布局 + 关系标签精修(2026-07-27,浏览器已验证)**:
   - 布局:关系页签激活时 `.workspace.graph-wide` 切换为纵向堆叠——地图缩为 380px 全宽一行,关系图独占其下全宽一行(画布约 1390×600),其他页签保持地图+侧栏并排;新增 MapResizeController(ResizeObserver → invalidateSize)解决容器尺寸切换后 Leaflet 失measure;画布尺寸剧变时若用户未持有镜头则自动重取景(220ms)
   - 数据:seed 026 已装载——183 条泛型关系标签全部精修为具体双语角色对(父子/婆媳/王与先知/弑主的臣仆…)+ 经文口吻摘要,另修 3 条 en 泛型;两种语言泛型标签清零
   - 备选方案已评估未采用:全屏浮层图(割裂上下文)、常驻大图(挤压其他页签)、旁路 mini-map(复杂度不值)

-4. **关系图缩放/居中逻辑重构(2026-07-27,浏览器已验证)**:废除固定层级倍率(TIER_SCALE),改为**自适应取景**:每层进入即按节点包围盒 fit 居中(224 人与 19 群体都一屏尽收);滚轮层级切换改为相对取景基线的倍率阈值(>1.9× 下钻、<0.5× 上卷,下钻原地保留视口、上卷动画回全景);点击时代/群体节点下钻时以该节点为中心取景(与子节点扇形展开呼应);外部选中人物(列表/搜索/抽屉)时若节点在视口边缘 18% 内自动平移居中;布局沉降结束且无手势介入时轻取景一次(240ms);全部视口动画 280ms ease-out、手势即取消、reduced-motion 跳变;程序性变换统一走 d3 behaviour.transform 保持内部状态一致。scaleExtent 放宽到 [0.12, 8]。

-3. **P1 时代色重调已执行(2026-07-27,seed 025 已装载,浏览器已验证)**:方案 4.3 的 13 色全部落库(保留尘土→金赭→赤红→紫→天青→橄榄绿叙事弧,只提明度;全部 ≥4.75:1 对 #1C1917 标签字、≥4.5:1 对 #0F172A 底)。时代轨道/地图标记/时间轴时代带即时生效。并行中:关系精修代理(把 183 条泛型标签升级为具体双语标签+摘要,产出 seed 026)。

-2. **动效与地图渲染打磨(2026-07-27,浏览器已验证)**:
   - 地图:半级缩放(zoomSnap/Delta 0.5 + wheelPxPerZoomLevel 90)让滚轮/捏合更细腻;标记与聚合入场用 marker-in 缩放动画 + 26ms 级联交错(封顶 10 个);标记名标签常驻 DOM,低缩放下悬停即显(labeled 类控制常显);弹窗/tooltip 浮现动画;题词随时代切换重放 rise-in(keyed);列表切页整体 fade-in;时代轨道选中项自动 scrollIntoView(平滑,reduced-motion 降级)
   - 关系图:层级切换空间连续性——新节点从父层级(人物←群体←时代)最后位置扇形展开,不再从原点跳入;悬停节点画烛光光环;画布散点色统一为靛蓝令牌
   - **数据修复(seed 024,已装载)**:发现 010–022 扩充种子的关系没有 relation_translations,API 因缺已发布 label 过滤掉 170/272 条关系;024 按 relation_type 回填基线双语标签(WHERE NOT EXISTS 幂等,不碰既有精修行)。浏览器确认:关系图 224 节点 · 272 连线全量;后续内容批次可用更具体的标签覆盖(直接 UPDATE 或删除基线行再插)
   - 教训已记:后续扩充种子必须包含 relation_translations(规范文件 db/seeds/bible-seed-spec.md 待补该节)

-1. **P0 神圣品牌重塑已执行(2026-07-27,三代理并行完成,静态验证通过)**:
   - 命名落地:《圣经舆图 · The Bible Atlas》/「从起初,直到地极」——`i18n.ts` 共 20 key 圣化(含 ENUMS 称谓:王/勇士/圣所/敬拜与立约等)+ 新增 `epigraphSourceSuffix`/`scriptureNote`;`index.html` 标题/描述/og/theme-color #0B1120
   - 视觉令牌靛蓝化:`styles.css` 89 行(4.1 核心令牌 + 4.2 散点值 + 页底烛光渐变 + `.epigraph` 组件样式;金色统一为 --accent 三级制)
   - 经文题词:新建 `epigraphs.ts`(13 时代题词 + 欢迎诗 119:18 + 加载轮换 ×3 + 页脚赛 40:8,和合本 1919/KJV 逐字录入);`App.tsx` 集成(选中时代显示题词、未选显示欢迎节、骨架屏 4s 轮换、页脚版本声明)
   - Bible-only 前端锁定:`state.ts` BIBLE_ONLY 常量,旧深链接静默归正;WorkControlCenter/compare-bar 条件隐藏(代码保留);搜索过滤作品类结果;`state.test.ts` 同步改为断言归正行为
   - 静态验证:typecheck 0 错误、25/25 测试通过
   - **浏览器实测已通过(2026-07-27,commit 1d630ff/1abfa4f 后)**:标题/品牌/主视觉(--bg #0B1120、--accent #F5C15D、羊皮纸正文)生效;欢迎题词(诗 119:18)与时代题词切换(选族长时代→创 12:2)正常;作品切换器与对照栏已隐藏;旧多作品深链接(双城记+霍比特人)静默归正为圣经单部;搜索无作品类结果;页脚赛 40:8 + 版本声明就位;「年代不详」50 条 chips 自动折叠正常。注意:Browser 预览面板的 launch.json 发现路径仍指旧目录名,用 preview_start {url} 方式可绕过
   - 一键启动链路体检已完成并实测全通:唯一因目录改名失效的是 DEPLOYMENT.md 里硬编码的 `cd 世界文学名著时空地图`(已修);其余脚本均相对定位不受影响;`Start/Stop-Literary-Atlas.command` → `Start/Stop-Bible-Atlas.command`(git mv);6 文件 18 处旧品牌文案清零;真实起停验证:API health ok、web 200、stop 后 PID/端口全清;DEPLOYMENT.md 顶部重写「快速启动」(文件清单 + 三种启动方式);数据库名/npm 包名/Docker 项目名属历史遗留命名,保持不变(P2 再议)

0. **重大方向调整(2026-07-27,用户决定)**:项目**只服务于圣经**,进行品牌重塑 + 神圣内容融入 + UI/UX 完善
   - 已新增可复用代理定义 `.claude/agents/liturgical-design-director.md`(神职人员 × UI/UX 设计总监双重人格,用于圣经内容呈现与神圣氛围设计的评审)
   - 实施方案已完成并提交:**`docs/design/sacred-rebrand-plan.md`**(commit `d18975a`)——命名、13 时代经文题词(和合本 1919 + KJV,均公有领域)、文案圣化清单、靛蓝+圣金令牌表(全组合实测对比度)、Bible-only 前端锁定、P0-P2 优先级
   - **用户已拍板(2026-07-27)**:① 新名称定为**《圣经舆图 · The Bible Atlas》**,tagline「从起初,直到地极 / From the Beginning to the Ends of the Earth」;② 实施范围定为**P0 八项全部照方案执行**(P1 另行再定)
   - **执行时机待用户决定**——用户要考虑何时执行,在明确指示前**不要动手改代码**;届时按方案第六节 P0 清单逐项实施(i18n 命名与文案 → index.html → styles.css 令牌 → epigraphs.ts → App.tsx 题词/页脚/加载 → Bible-only 锁定 → 浏览器验证 → HANDOFF)
   - 设计方向(ui-ux-pro-max 检索结论):Editorial/手抄本式排版、深夜靛蓝底 + 圣金点缀、保持离线系统字体栈、演进现有暗色系统而非推翻
   - 附带发现:现有 13 时代 accent_color 有 9 个对比度不达标(最差 2.56:1),重调表与幂等 SQL 已在方案 4.3 节(P1)
   - 浏览器已验证:第三~五批种子装载后渲染正常(圣经 224 人物/394 事件/101 地点/13 时代 chips 与库一致)

1. ~~架构维护~~ 已完成(commit `a14c130` / `2cb3349`):一键启动脚本改为本地栈(前置检查/自动建库/端口冲突/PID 幂等)、`.env.example` 集中配置、`docs/DEPLOYMENT.md` 部署指南、README 快速启动更新;依赖体检 `npm audit` 0 漏洞,过期项均为跨大版本仅记录未升级
2. ~~种子扩充~~ **已全部完成**(2026-07-27):13 个时代种子(`010`–`022`;`009` 为历史编号空缺,未使用)全部装载并登记 `seed_history`,与磁盘文件一一对应
   - 共享规范文档已固化进仓库:`db/seeds/bible-seed-spec.md`(包含 UUID 前缀、sequence 区间、时间标注规范、跨时代人物归属规则);后续补充内容(每时代事件继续加密度)可直接复用该规范 + `010/015/016` 作模板
   - 注意规范中自测命令里的 SCRATCH 路径属于旧会话,使用时替换为当前可写临时目录

种子文件统一遵循共享规范:
- UUID 前缀:`人物 43` / `地点 33` / `事件 63` / `关系 73` + `000000-0000-4000-80KK-`(KK 为时代编号,与 `010/013/017/021` 实际用法一致)
- 事件 sequence 区间:`K*1000+1` 至 `K*1000+999`
- 双语翻译(中/英)
- 宽年代范围标注
- 来源引用

## 下一步

1. 真实数据量下的三视图压测与参数微调(当前 UI 优先级;顺带重验第三~五批装载后的浏览器渲染)
2. 媒体资产扩充(`media_assets` 表当前为 0 条记录)
3. 其他四部作品(圣经之外)的数据扩充

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
