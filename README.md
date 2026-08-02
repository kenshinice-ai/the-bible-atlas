# 圣经舆图 · The Bible Atlas

一个可本地一键启动的双语文学探索应用：React + strict TypeScript 前端、Node.js TypeScript API、PostgreSQL + PostGIS、Docker Compose、版本化 migrations 与 seeds。v3.1 以《圣经》作为复杂数据主样本，同时保留《双城记》《安妮日记》《牧羊少年奇幻之旅》和《霍比特人》。

## 最快启动（macOS）

在 Finder 双击 `Start-Bible-Atlas.command`，或在终端运行：

```bash
./Start-Bible-Atlas.command
```

启动器基于本机 Homebrew PostgreSQL（非 Docker），会：

1. 检查 Node.js（>= 22）、npm 与本机 PostgreSQL（未运行则尝试 `brew services start`）；
2. `literary_atlas` 库不存在时自动 `createdb` + `CREATE EXTENSION postgis` + 迁移与种子（幂等）；
3. `node_modules` 缺失时自动 `npm install`；
4. 检测端口冲突（旧 Docker 栈占用 4000/5432 时可一键 `docker compose down`）；
5. 启动 API（4000）与 Web（Vite 5173），日志与 PID 写入 `release/logs/`；
6. 健康检查通过后自动打开浏览器；重复双击不会重复起进程。

访问：

- Web：`http://localhost:5173`
- API：`http://localhost:4000`
- API 健康检查：`http://localhost:4000/health`
- PostgreSQL：`localhost:5432`

停止服务且保留数据库：双击 `Stop-Bible-Atlas.command`，或运行 `npm run stop:local`。从零安装与故障排查见 [部署指南](docs/DEPLOYMENT.md)。

只检查启动计划、不安装或启动：

```bash
bash scripts/start_local.sh --dry-run --no-open
```

## v3.1 能力

- 《圣经》双语复杂闭环：13 人物、14 事件、12 地点、3 路线、15 关系及来源链接。
- 世界名著控制中心：单选或最多五部同地图层作品对照；地图只请求和显示选中内容。
- 现实/虚构地图分层：四部现实地理作品使用 PostGIS；《霍比特人》使用独立虚构画布，不伪造经纬度。
- 统一 Explore State：语言、作品、主作品、标签页、实体、时间模式/范围、图层写入深链接。
- BCE–CE 历史时间轴与叙事顺序模式；支持密度、缩放、平移和事件联动。
- 人物身份卡、关系图、关系生命周期、地点类型/精度、事件现实性/置信度及来源详情。
- 中文/English 切换保留上下文；明确 published fallback 和双语搜索。
- 桌面及基础移动端、键盘焦点、减少动态效果适配。
- 欧洲美术史独立 profile：82 位 canonical 人物/艺术家、200 件作品、218 个事件、9 个章节；作品详情含双语简介，并带权利审计展示图或明确的外部来源页。

同层规则是硬约束：现实作品与虚构作品不能混在一张地图。当前目录中只有一部虚构作品，因此现实层最多可同时对照四部；系统容量仍为五，未来新增同层作品无需改状态模型。

## 手动 Docker 启动

```bash
cp .env.example .env
docker compose up --detach --build
```

Compose 的 `migrate` 服务会先执行尚未应用的 migrations/seeds，成功后才启动 API。已有 v3.0 数据卷会增量升级；不会依赖 Postgres init 目录重放。

重置演示数据库会删除本地数据，只有确认无需保留时才执行：

```bash
docker compose down
docker volume rm literary-atlas_atlas_pgdata
docker compose up --detach --build
```

## 本地开发

要求 Node.js 22+、npm 11+、PostgreSQL/PostGIS（或 Docker）。

```bash
cp .env.example .env
docker compose up -d db
npm install
npm run db:bootstrap
npm run dev
```

Vite 开发站点默认为 `http://localhost:5173`。缺失配置、无效 locale、未知实体与 SQL 错误都会显式返回，不做静默回退。

数据库命令：

```bash
npm run db:migrate
npm run db:seed
npm run db:bootstrap
```

Runner 通过 `schema_migrations` 和 `seed_history` 跳过已应用版本。Seed 文件仍按版本增量管理，不应手工重复灌入。

## 验证

```bash
npm run typecheck
npm test
npm run build
npm run verify:postgis
npm run test:start-command
docker compose config --quiet
```

欧洲美术史媒体门禁（需指向隔离或本地已 bootstrap 的 PostgreSQL）：

```bash
DATABASE_URL=postgresql:///literary_atlas_eah_r10_release_20260802 \
MEDIA_EXPECTED_ARTWORKS=200 \
MEDIA_MIN_BUNDLED=160 \
npm run verify:artwork-media
```

该检查会验证 200/200 作品媒体覆盖、Commons 许可证白名单、双语来源、SHA-256 文件完整性和无残留图片。R9/R10 扩充 Seed 可重复生成：

```bash
npm run generate:art-expansion
```

独立静态站发布：

```bash
BAKE_API_URL=http://localhost:4000 \
bash deploy/deploy-static.sh --profile european-art-history --publish cf
```

`verify:postgis` 在 `/private/tmp` 创建隔离实例，验证 v3.0→v3.1 升级、全新建库、五部作品、圣经闭环、PostGIS/虚构坐标约束、fallback、双语搜索和 API 负例，结束后清理临时实例。详细流程见 [测试计划](docs/TEST_PLAN_v3.1.md)。

API smoke：

```bash
curl -fsS http://localhost:4000/health
curl -fsS 'http://localhost:4000/api/works?locale=zh-CN'
curl -fsS 'http://localhost:4000/api/works/the-bible/atlas?locale=en'
curl -fsS 'http://localhost:4000/api/search?locale=zh-CN&q=耶路撒冷'
```

`locale=fr` 返回 400，未知作品返回 404。

## 语言、时间与地图规则

- 公开 locale：`zh-CN`、`en`。
- 读取顺序：请求语言 published → 作品默认语言 published。响应明确包含 `resolvedLocale`、`fallbackUsed`、`translationStatus`。
- 搜索只搜索明确请求的语言，不暗中跨语言混合。
- BCE 使用负整数、CE 使用正整数，不存在 year 0；近似/范围日期不伪装成 SQL 精确日期。
- 圣经地点在现实层但带 coordinate accuracy 和解释；坐标不是事件真实性证明。
- 文学与圣经内容只存原创摘要、结构化事件和短引用标识，不收录大段受版权保护文本。

## 结构与文档

```text
apps/api        Express + pg + Zod API
apps/web        React + Leaflet + SVG timeline/graph/fictional canvas
db/migrations   forward-only PostGIS schema
db/seeds        bilingual versioned sample data
docs            v3.1 audit, plan, source, interaction and test policies
release         generated delivery ZIP (not used at runtime)
```

架构、schema、API、页面状态、地图分层、seed、Sprint、验收标准和后续 Codex prompts 见 [Blueprint v3.1](Literary_Atlas_Blueprint_v3.1.md)。
