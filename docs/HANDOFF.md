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

-11. **银河原力舆图 The Galactic Force Atlas · M1 骨架上屏完成(2026-07-27)**:第三个图集,单 work `skywalker-saga`,profile id `galaxy`。**未部署**(等 M2 内容 + IP 审读)。
   - **实现清单**:`blueprint/star-wars/IMPLEMENTATION_CHECKLIST.md`——逐条核对代码库后写成,记录了蓝图的 8 处过时前提。其中两处最贵:①蓝图要求新建迁移删掉 `works` 的 hobbit CHECK,而 `002` 早就删了(工作不存在);②蓝图把新增 `location_type` 当成 i18n 小事,实际 `location_type` 是 **PG 枚举 + `types.ts` 严格 zod 枚举**,漏改 zod 会让整个 atlas 响应解析失败(白屏而非降级)
   - **用户拍板**:名称「银河原力舆图 / The Galactic Force Atlas」(不含商标词;CF 项目名 `galactic-force-atlas`);location_type 走新增枚举值方案(取通用词 planet/moon/space_station 以便后续更多虚构作品复用);两条 ≤15 词台词短引用保留;默认英文;顺带修三国的数据隔离缺陷
   - **代码**(12 项,全部完成):迁移 `004`(ALTER TYPE,**必须与用它的种子分文件**,同事务内新枚举值不可用)+ zod/ENUMS/zoomForLocation 同步;`profile.ts` 加 galaxy 档与 `yearLabels`;**`formatYear` 第三参默认取 `PROFILE.yearLabels`**——比清单原案(6 个调用点各自传值)更稳,漏传这个失败模式在结构上消失;`epigraphs.ts` 加 GALAXY 一组(题词配额登记在文件头供 IP 审读核对);`styles.css` 加 `[data-profile="galaxy"]` 令牌(全部对比度实测,最差 4.54:1);FictionalCanvas 重做(背景按 work 参数化、同心环带 + 确定性星场、14 候选位标签防碰撞);`deploy-static.sh` 加 galaxy 分支
   - **数据隔离(用户要求,顺带修了三国的历史缺陷)**:新增 `profile-meta.ts` + `vite.config.ts` 的 `transformIndexHtml`——此前 `index.html` 是硬编码圣经 meta,**三国线上站至今带着圣经的 description 与 og**;同类泄漏还有两处已修:`dataNote`(圣经措辞「悉以经文记载为本」在三档页脚全显示)、`BIBLE_ONLY`(泛化为 `SINGLE_WORK = mode === "single"`)。隔离由 `profile.test.ts` 守住(PROFILE_META / SETS_BY_PROFILE 的 key 集合必须与 PROFILES 一致)
   - **补上一个历史测试缺口**:`missingLabels()` 的注释声称「测试断言为空」,实际**没有任何测试引用它**。补测试后立刻抓到 4 个既有缺口——`documented`/`text_explicit`/`liege`/`double` 从无中文标签,zh-CN 界面一直显示生英文;已补齐
   - **数据**:规范 `db/seeds/galaxy-seed-spec.md`(时代代理的唯一依据);骨架种子 `040_galaxy_structure.sql` 已装载并登记——12 时代 / 13 群体 / 11 sources / **39 天体画布坐标** / 24 锚点人物 / 3 条航线,事件为 0(留给时代种子)
   - **门禁**:画布环带 SQL 门 0 行矛盾;结构与孤儿检查全绿;浏览器实测三档(bible / three-kingdoms / galaxy)中英双语,galaxy 39 个标签 0 处互压 0 处越界;typecheck 干净、36 测试通过、三档构建均成功
   - **M2 内容全量已完成(2026-07-27)**:种子 `041`–`047` 全部装载。当前库内 **55 人物 / 154 事件 / 45 地点 / 94 关系 / 3 航线**
     - 用户中途定的方向:**主线优先、控制篇幅**——重心在天行者家族与绝地这条脊线(94 条关系里 58 条属主线),配角与边缘事件只留 summary
     - 内容口径:忠于影片事实、措辞全部原创。用户要求「尽量使用原著内容」,而影片台词在版权期内,照抄正是唯一的真实风险,故按「事实照实、话自己说」执行
     - **致敬声明**已按用户要求加进 reference:`sources` 新增一条「致敬与非商业声明」,同一措辞进页脚 SOURCE_NOTE(无广告、不收费、不接受打赏、不替代观影)
     - `041` 补了 6 座天体(双胞胎出生地、赌城、最后一部的四座星球)——**先封清单、后核内容是个错误**,骨架表漏了它们;清单现固定为 45 座
     - **重排种子 048 与关系精修种子 049 都不需要**:sequence 在写入时即按 `K*1000` 分带(跨时代单调、无重复),关系在写入时即为具体双语标签(泛型为零)。圣经当年的 023/026 是补救,这次把纪律前移了
     - 装载踩坑:era 11 重复建了已存在于 era 07 的 `yoda→luke` 关系,唯一约束让人物行被 `ON CONFLICT` 跳过、其翻译行外键失败炸掉整个文件。**反复出现的关系是一行,跨越哪些时代由事件承载**——已写进规范
     - 门禁全绿:孤儿零行、纪年门零行、事件年份全落在各自时代区间、94/94 关系带双语标签(圣经当年 102/272)、零成员群组为零、画布环带 0 行矛盾
   - **上线卡在一步**:静态产物已就绪(烘焙 4 文件 0.57MB、构建 dist 1.3MB、断言通过),但 **CF Pages 项目 `galactic-force-atlas` 尚未创建**,该命令被权限拦截。用户执行 `npx wrangler pages project create galactic-force-atlas --production-branch main` 后,`bash deploy/deploy-static.sh --profile galaxy --publish cf` 即可发布
   - **IP 审读已完成(2026-07-27)**:报告 `docs/IP_AUDIT.md`,修正种子 `048_galaxy_ip_audit_fixes.sql` 已装载,**修正后已重新烘焙**(圣经 027 教训)
     - 五项机检四项一次通过:八连词比对 **0 命中**(对照 40 条最知名台词与官方开场文案;英文条目 10,548 词、8,114 个不重复八连词)、自我重复八连词 0(无套模板)、题词引用 2/3 条且 5–6 词均带出处、命名合规、素材合规(图片资产 0,仅原创 SVG favicon)、译名零变体
     - **唯一发现**:9 处中文用 `「」`,其中 3 处包住角色的话(「被维达害死了」「我可以教你」「心中有恐惧」)——违反自订红线,已改为间接引述;其余 6 处概念强调也一并去括号,理由是「条目文本零引号」是机器能永远返回零的检查。复检归零,扫描脚本固化为 `docs/sql/galaxy_quote_scan.sql`
     - **机检口径的诚实说明**:八连词比对是**定向抽查**,不是全剧本比对(离线拿不到完整语料)。真正的保证来自来源可追——全部条目文字为本会话逐条撰写,写法是「先确认影片事实,再用自己的话陈述」
     - **致敬与非商业**按用户要求提到最显眼处:meta description 首句、页脚常驻声明、citation 列表中的独立条目,三处齐备;项目无广告位、无支付集成、无捐赠入口
   - **仍需真人法律审阅的四项**(工程侧无法替代,见 `docs/IP_AUDIT.md` §8):`skywalker-saga` 作为 slug、两条短引用是否保留、中文通行译名的系统性使用、非商业+指称性使用的组合在目标发布地区是否成立

-10. **三国舆图完整项目上线(2026-07-27)**:生产地址 **https://three-kingdoms-atlas.pages.dev**(CF 项目 three-kingdoms-atlas)。
   - 数据(seeds 031–039,全部装载):志 75 人物/92 事件/54 地点/93 关系 + 演义 78/127/55/96;13 时代双 work 同 slug 对照(赤壁志行瘟疫退军简记 vs 演义借东风铺陈);桃园结义/空城计/玉泉显圣等演义独有事件按 reality 分级;五项孤儿检查零行
   - 装载踩坑记录:037 与 038 都建了司马师,038 靠人物 ON CONFLICT 跳过但翻译撞主键——修复=038 全部翻译/成员表补 ON CONFLICT DO NOTHING(七处);**后续种子规范应把「二次插入防护」列为强制**
   - 前端:WORK_PROFILE 机制(profile.ts;bible/three-kingdoms 两档),三国档默认中文、锁定志+演义对、保留主作品切换栏;玄墨朱金主题([data-profile] 令牌,对比度验算);题词档案化(临江仙/曹操诗/演义回目);题词版本后缀(和合本/KJV)改为 bible 档专属
   - 品牌:全站页底统一署名「A PARADISE PRODUCTION · 天域文创出品」+ 星火 P favicon(SVG 路径绘制)
   - 已知余项(P1):三国 routes 为 0(北伐/伐吴路线待补);演义 hero 年代显示 164–301(个别背景事件超 184–280 区间,待收敛);FictionalCanvas 增强(Star Wars 前置)
   - **Star Wars Atlas 蓝图完成**:`blueprint/star-wars/`(SAGA_BLUEPRINT/IP_AND_NAMING/ESTIMATE_AND_PIPELINE)——单 work 决策、BBY/ABY 纪年双轨、39 点银河画布、去商标化命名「Galaxy Atlas」+ 题词 12 原创 2 短引、IP 合规为结构性风险(M0 需真人法律审阅)

-9. **已上线 Cloudflare Pages(2026-07-27)**:生产地址 **https://bible-atlas-6h7.pages.dev**(项目名 bible-atlas,生产分支 main;wrangler OAuth 已在本机授权)。线上验证:HTTPS、默认英文、224/394/101/10/272 全量数据、零 /api 请求。更新发布:`bash deploy/deploy-static.sh --publish cf`(脚本已固定 --branch main,避免落到预览分支)。

-8. **已同步 GitHub(2026-07-27)**:远程 `https://github.com/kenshinice-ai/the-bible-atlas`(public,默认分支 main);本地 master 跟踪 origin/main。远程原有的 stub 初始提交用 `-s ours` 合并吸收(未强推)。后续发布:`git push` 即同步;静态站发布可走 `deploy/deploy-static.sh --publish cf` 或 GitHub Pages/Actions。

-7. **方案 C 全静态化已实现并验证(2026-07-27)**:`bake-static.ts` 烘焙 works + full atlas 双语 JSON(4 文件 1.56MB 原始)→ `VITE_DATA_MODE=static` 构建(api.ts 切 /data、抽屉 prose 取 full atlas 兜底、搜索改内存检索、--base=./ 相对路径)→ dist 约 2.3MB 完全自包含。`deploy/deploy-static.sh` 一键(含产物断言:无 localhost 残留),支持 --publish cf/netlify。浏览器实测:零 /api 请求、搜索 41 结果、抽屉 prose 完整。DEPLOYMENT.md 第九节改为「已实现」操作指南。**神职审计(027)已落库后重新烘焙**,静态数据即审计后数据。

-6.5. **神职标准内容审计完成(2026-07-27,seed 027 已装载)**:19/19 经文引文逐字通过(对照信望爱/维基文库 CUV 与 KJV,零改动);i18n 通过零改动;数据层 24 处修复(该撒利亚拼法 8 实体、流便/亚他利雅/米利大和合本拼法、语体与全角括号等);报告 `docs/CLERGY_AUDIT.md`(含待人工核对 4 项:现代地名主名策略、波斯君主主名、神版全角空格、KJV 句末标点;神学中立性三级建议:faith_narrative 枚举/显示文案/免责句)。**结论:整体可呈现给神职读者。**

-6. **上线三部曲(2026-07-27,进行中)**:目标 = ① 神职人员标准内容审计 ② 双语默认英文 ③ 完整部署方案。
   - ② 已完成并浏览器验证:默认 locale 改为 en(state.ts,`?lang=zh-CN`/`?locale=zh-CN` 仍可直达中文),index.html lang="en",新增默认语言测试
   - ① 审计代理进行中:epigraphs 逐字对照和合本1919/KJV、i18n 称谓、库内翻译抽样 → docs/CLERGY_AUDIT.md + 027 修正种子
   - ③ 部署方案已完成(2026-07-27,未提交):新建 `deploy/`(docker-compose.prod.yml 生产覆盖 + Caddyfile + nginx.conf + deploy.sh 一键脚本,均已验证语法/配置);API 增加 `CORS_ORIGIN` 环境变量(app.ts 一处,默认 `*` 保持兼容,已实测收紧生效);api Dockerfile 增加 `npm prune --omit=dev`;`.env.example` 增生产四项清单;DEPLOYMENT.md 新增第二部分生产篇(五~十节:方案总览 / VPS 逐步操作含备份回滚 / 监控 / 排查 / 静态化设计 / 安全清单)。实测:`npm run build` 通过(web dist:js 605.7KB→gzip 188.0KB,css 49.6KB→14.3KB);镜像 api 244MB / web 77MB;prod 覆盖栈冒烟通过(health/works/atlas/CORS);api 测试 5/5;npm audit 0 漏洞

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
