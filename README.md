# 世界文学名著时空地图

一个 React + TypeScript、Node.js TypeScript、PostgreSQL + PostGIS 的双语文学地图原型。v3.0 覆盖四部作品，并以《双城记》完成端到端数据闭环。世界名著选择器支持单选和最多三部的对照多选，地图只渲染所选作品。

## 一键启动（macOS）

在 Finder 中双击：

```text
Start-Literary-Atlas.command
```

启动器会依次：

1. 检查 macOS、Homebrew、Docker Desktop、Docker Engine、Compose 和 curl；
2. 自动安装缺失的 Homebrew 或 Docker Desktop，启动 Docker Engine 并等待就绪；
3. 创建缺失的 `.env`，但绝不覆盖已有配置；
4. 构建并启动 PostGIS、API 和 Web，执行真实健康检查；
5. 输出访问网址、功能简介和停止方法，并打开 `http://localhost:8080`。

首次安装 Docker Desktop 时，macOS 可能要求确认许可。完成确认后启动器会继续等待；若超过三分钟仍未就绪，会明确报错并给出重试说明。

停止服务且保留数据库：

```text
Stop-Literary-Atlas.command
```

也可以在终端运行：

```bash
npm run start:local
npm run stop:local
```

仅检查启动计划，不安装或启动：

```bash
bash scripts/start_local.sh --dry-run --no-open
```

## 手动 Docker 启动

要求：Node.js 22+、npm 11+；完整环境另需 Docker Desktop。

```bash
cp .env.example .env
docker compose up --build
```

打开 `http://localhost:8080`。API 位于 `http://localhost:4000`，健康检查为 `GET /health`。首次创建数据库卷时，Postgres 会按文件名执行 `db/migrations` 和 `db/seeds`。

重置本地演示数据库会删除 Compose 数据卷，因此必须明确执行：

```bash
docker compose down
docker volume rm literary-atlas_atlas_pgdata
docker compose up --build
```

请先确认卷名；不要在有需要保留的数据时运行。

## 本地开发

先启动数据库，再运行 API 和 Web：

```bash
cp .env.example .env
docker compose up -d db
npm install
npm run dev
```

默认 Web 为 `http://localhost:5173`。本机运行 API 时从 `.env` 或 shell 提供 `DATABASE_URL` 和 `API_PORT`。项目不对缺失配置做静默默认。

已有空数据库可手动执行：

```bash
npm run db:migrate
npm run db:seed
```

Seed 不是幂等更新脚本；只应对新数据库执行一次。若重复执行，唯一约束会明确报错。

## 验证

```bash
npm run typecheck
npm test
npm run build
docker-compose config --quiet
npm run verify:postgis
npm run test:start-command
```

`verify:postgis` 会在 `/private/tmp` 创建隔离的 PostgreSQL/PostGIS 实例，执行原始 migration 和 seed，验证空间约束、四部作品完整性、双语搜索、实体级 fallback、历史日期与 API smoke，然后自动停止并删除临时实例。它要求本机已有与 PostgreSQL 匹配的 PostGIS 扩展。

Docker 环境启动后可 smoke test：

```bash
curl -fsS http://localhost:4000/health
curl -fsS 'http://localhost:4000/api/works?locale=zh-CN'
curl -fsS 'http://localhost:4000/api/works/a-tale-of-two-cities/atlas?locale=en'
curl -fsS 'http://localhost:4000/api/search?locale=zh-CN&q=巴黎'
```

负例：`locale=fr` 应返回 HTTP 400；未知作品应返回 HTTP 404。

## 目录

```text
apps/api       Express + pg + Zod API
apps/web       React + Leaflet + SVG fictional canvas
db/migrations  PostGIS schema
db/seeds       bilingual four-work seed
Literary_Atlas_Blueprint_v3.0.md
```

## 语言与 fallback

公开语言为 `zh-CN` 和 `en`。读取顺序是“请求语言的 published 翻译 → 作品默认语言的 published 翻译”。作品、人物、事件、地点、路线和关系都返回 `resolvedLocale`、`fallbackUsed` 与 `translationStatus`；不支持的 locale 直接报错。搜索只搜索用户明确请求的语言。

## 地图数据规则

- 《双城记》《安妮日记》《牧羊少年奇幻之旅》使用 PostGIS 现实点位。
- 《霍比特人》只使用 0–100 的虚构画布坐标，不写现实经纬度。
- 多选上限为三部且必须属于同一地图层；现实和虚构作品不能在一张图中混选。
- 多选时地图叠加所选作品，人物、事件、路线详情与时间轴跟随用户指定的当前作品。
- 文学事件摘要为原创结构化描述，不保存作品大段原文。

完整架构、schema、Sprint 和验收条件见 `Literary_Atlas_Blueprint_v3.0.md`。
