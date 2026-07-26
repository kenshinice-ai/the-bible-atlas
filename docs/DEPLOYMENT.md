# 部署与本地运行指南

适用版本:v4(Bible-first)。更新时间:2026-07-26。

## 一、本地一键启动(推荐,macOS)

在 Finder 双击项目根目录的 `Start-Literary-Atlas.command`,或在终端执行:

```bash
bash scripts/start_local.sh          # 正常启动
bash scripts/start_local.sh --dry-run --no-open   # 只看计划,不做任何改动
```

启动器会自动完成:

1. 检查 Node.js(>= 22)与 npm;
2. 检查本机 PostgreSQL 是否运行(未运行则尝试 `brew services start`);
3. 检查 `literary_atlas` 数据库,不存在则自动 `createdb` + `CREATE EXTENSION postgis` + 迁移与种子(幂等);
4. `node_modules` 缺失时自动 `npm install`;
5. 启动 API(端口 4000)与 Web(Vite,端口 5173),日志与 PID 写入 `release/logs/`;
6. 健康检查通过后自动打开浏览器 `http://localhost:5173`。

脚本幂等:重复双击不会重复起进程,已在运行时只会重新打开浏览器。

停止:双击 `Stop-Literary-Atlas.command` 或 `bash scripts/stop_local.sh`(按 PID 清理,含端口残留进程兜底;本机 PostgreSQL 和数据保留)。

环境变量集中在 `.env.example`(含说明);如需自定义,`cp .env.example .env` 后修改。

常用 npm 入口:

```bash
npm run dev:api      # 单独启动 API(tsx watch)
npm run dev:web      # 单独启动 Web(vite)
npm run typecheck    # 双工作区类型检查
npm test             # 双工作区测试
npm run db:bootstrap # 迁移 + 种子(幂等)
```

## 二、全新机器从零安装

### 方案 A:Homebrew 本地栈(推荐,与一键启动脚本配套)

```bash
# 1. 基础工具
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install node postgresql@18 postgis
brew services start postgresql@18

# 2. 获取项目并启动(其余全部由启动器自动完成)
cd 世界文学名著时空地图
bash scripts/start_local.sh
```

### 方案 B:Docker Compose 旧栈

无需本机 Node/Postgres,仅需 Docker Desktop:

```bash
cp .env.example .env
docker compose up --detach --build
# Web: http://localhost:8080  API: http://localhost:4000
docker compose down   # 停止(数据库卷保留)
```

注意:Docker 栈与本地栈都使用端口 4000/5432,**二选一运行**,切换前先停掉另一个。

## 三、常见故障排查表

| 症状 | 原因 | 处理 |
| --- | --- | --- |
| 启动器报「端口 4000 被占用」 | 旧 Docker 栈的 api 容器还在跑 | 按提示同意执行 `docker compose down`,或手动执行后重试 |
| 端口 4000 有响应但内容是旧数据 | 请求打到了 Docker 容器而非本地 API | `docker compose down` 后重启本地栈 |
| `pg_isready` 失败 / 连不上 5432 | 本机 Postgres 未启动,或 5432 被 Docker 的 PG 抢占 | `brew services restart postgresql@18`;若 Docker 占用则先 `docker compose down` |
| 报「数据库 literary_atlas 不存在」 | 全新机器未初始化 | 启动器会自动建库并 bootstrap;手动方式:`createdb literary_atlas && psql -d literary_atlas -c "CREATE EXTENSION postgis" && npm run db:bootstrap` |
| bootstrap 报 `type "geography" does not exist` | 未安装/未启用 PostGIS | `brew install postgis`,再 `psql -d literary_atlas -c "CREATE EXTENSION postgis"` |
| 端口 5173 被占用 | 残留 vite 进程或其他应用 | `bash scripts/stop_local.sh` 清理;仍占用则 `lsof -nP -iTCP:5173` 查看占用者 |
| 页面打开但地图无数据 | API 未就绪或种子未导入 | 查看 `release/logs/api.log`;`curl http://localhost:4000/health`;必要时 `npm run db:seed` |
| 双击 .command 无反应 | 脚本失去可执行权限 | `chmod +x Start-Literary-Atlas.command Stop-Literary-Atlas.command scripts/*.sh` |
| 想彻底重建演示数据库 | — | `dropdb literary_atlas` 后重新运行启动器(会自动建库+迁移+种子);Docker 栈则删除卷 `docker volume rm literary-atlas_atlas_pgdata` |

日志位置:`release/logs/api.log`、`release/logs/web.log`;PID 文件同目录。

## 四、验证命令

```bash
npm run test:start-command   # 启动/停止脚本语法、--help、--dry-run 检查
npm run typecheck && npm test
curl -fsS http://localhost:4000/health
curl -fsS 'http://localhost:4000/api/works?locale=zh-CN'
```
