# 部署与本地运行指南

适用版本:v4《圣经舆图 · The Bible Atlas》(Bible-first)。更新时间:2026-07-27。

## 一、快速启动(推荐,macOS 本地栈)

启动链路涉及的全部文件:

| 文件 | 作用 |
| --- | --- |
| `Start-Bible-Atlas.command` | Finder 双击入口,转调 `scripts/start_local.sh` |
| `Stop-Bible-Atlas.command` | Finder 双击停止入口,转调 `scripts/stop_local.sh` |
| `scripts/start_local.sh` | 一键启动器:环境检查 → 建库/迁移/种子 → 起 API+Web → 健康检查 |
| `scripts/stop_local.sh` | 停止脚本:按 PID 清理(含子进程),端口残留兜底,旧 Docker 栈一并 down |
| `scripts/test_start_command.sh` | 启动链路自检(语法、--help、--dry-run),`npm run test:start-command` |
| `.env.example` | 环境变量模板(ATLAS_LOCAL_DATABASE_URL / API_PORT / WEB_PORT / VITE_API_URL 等) |
| `package.json` | `start:local` / `stop:local` 等 npm 入口 |
| `.claude/launch.json` | Claude Code 浏览器预览用的 api/web 启动配置 |
| `release/logs/` | 运行期日志(api.log、web.log)与 PID 文件(api.pid、web.pid) |

三种启动方式(任选其一):

1. **双击启动**:在 Finder 双击项目根目录的 `Start-Bible-Atlas.command`(结束后双击 `Stop-Bible-Atlas.command` 停止);
2. **npm 一条命令**:`npm run start:local`(不自动开浏览器;停止用 `npm run stop:local`);
3. **手动两条命令**(跳过一键脚本,适合调试):

   ```bash
   # 终端 1:API(端口 4000)
   cd apps/api && DATABASE_URL="postgresql://$USER@localhost:5432/literary_atlas" API_PORT=4000 npx tsx src/index.ts
   # 终端 2:Web(端口 5173)
   cd apps/web && VITE_API_URL=http://localhost:4000 npx vite --port 5173 --strictPort
   ```

也可在终端直接调启动器,支持只看计划的 dry-run:

```bash
bash scripts/start_local.sh          # 正常启动
bash scripts/start_local.sh --dry-run --no-open   # 只看计划,不做任何改动
```

启动器会自动完成:

1. 检查 Node.js(>= 22)与 npm;
2. 检查本机 PostgreSQL 是否运行(未运行则尝试 `brew services start`;若端口被旧 Docker 栈占用会提示一键 `docker compose down`);
3. 检查 `literary_atlas` 数据库,不存在则自动 `createdb` + `CREATE EXTENSION postgis` + 迁移与种子(幂等);
4. `node_modules` 缺失时自动 `npm install`;
5. 检测端口 4000/5173 冲突后启动 API 与 Web(Vite),日志与 PID 写入 `release/logs/`;
6. 健康检查(`/health` 与网页)通过后自动打开浏览器 `http://localhost:5173`。

脚本幂等:重复双击不会重复起进程,已在运行时只会重新打开浏览器。

停止:双击 `Stop-Bible-Atlas.command` 或 `bash scripts/stop_local.sh`(按 PID 清理,含端口残留进程兜底;本机 PostgreSQL 和数据保留)。

环境变量集中在 `.env.example`(含说明);如需自定义,`cp .env.example .env` 后修改。数据库名 `literary_atlas` 与 npm 包名 `@literary-atlas/*` 为历史遗留命名,暂不随品牌更名。

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
cd "The Bible Atlas"
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
| 双击 .command 无反应 | 脚本失去可执行权限 | `chmod +x Start-Bible-Atlas.command Stop-Bible-Atlas.command scripts/*.sh` |
| 想彻底重建演示数据库 | — | `dropdb literary_atlas` 后重新运行启动器(会自动建库+迁移+种子);Docker 栈则删除卷 `docker volume rm literary-atlas_atlas_pgdata` |

日志位置:`release/logs/api.log`、`release/logs/web.log`;PID 文件同目录。

## 四、验证命令

```bash
npm run test:start-command   # 启动/停止脚本语法、--help、--dry-run 检查
npm run typecheck && npm test
curl -fsS http://localhost:4000/health
curl -fsS 'http://localhost:4000/api/works?locale=zh-CN'
```
