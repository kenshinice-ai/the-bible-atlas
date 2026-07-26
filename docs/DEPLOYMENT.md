# 部署与本地运行指南

适用版本:v4《圣经舆图 · The Bible Atlas》(Bible-first)。更新时间:2026-07-27。

本文分两大部分:**第一部分 本地开发**(第一~四节,macOS 本地栈与 Docker 旧栈)、**第二部分 生产部署**(第五节起,VPS Docker 全栈上线方案与备选路线)。

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

---

# 第二部分 生产部署

## 五、方案总览

| 方案 | 形态 | 成本 | 适用 | 状态 |
| --- | --- | --- | --- | --- |
| **A. VPS Docker 全栈(推荐)** | 一台 VPS + Docker Compose(db/api/web/Caddy),`deploy/deploy.sh` 一键部署 | 约 $4–6/月(1–2GB 内存 VPS) | 正式上线首选,完整保留全文检索与 API | 工件齐备,已实测 |
| B. PaaS(Render / Fly.io) | api 容器 + 托管 Postgres(启用 PostGIS)+ 静态站点托管 | 免费档可起步,数据库常需付费档 | 不想管服务器;注意冷启动与 PostGIS 支持 | 仅提示,见 6.9 |
| C. 静态化(**已实现,推荐**) | 数据 bake 成静态 JSON,托管 Cloudflare Pages / GitHub Pages,零服务器 | $0 | 数据只读且更新频率低时的终极形态 | 操作见第九节 |

架构要点(方案 A):浏览器只访问 `https://站点域名`,由反向代理(Caddy 或主机 nginx)分流——`/api/*` 与 `/health` 转发 api 容器(4000),其余走 web 容器(nginx 静态文件)。**前后端同源**,因此生产构建把 `VITE_API_URL` 置空、前端用相对路径请求;`CORS_ORIGIN` 同时收紧为站点域名做纵深防御。数据库 5432 不对公网发布,api/web 端口只绑定 127.0.0.1。

部署工件一览(均在 `deploy/`):

| 文件 | 作用 |
| --- | --- |
| `deploy/docker-compose.prod.yml` | 生产覆盖:restart 策略、端口收紧(db 不发布、api/web 仅回环)、healthcheck、日志轮转、Caddy 服务(profile) |
| `deploy/Caddyfile` | Caddy 反代配置:自动 HTTPS、gzip/zstd、带 hash 静态资源 immutable 长缓存 |
| `deploy/nginx.conf` | 与 Caddyfile 等价的主机 nginx 配置(配 certbot 用,二选一) |
| `deploy/deploy.sh` | 一键部署脚本:依赖检查 → 拉代码 → .env 安全检查(拒绝默认密码)→ 构建 → 启动(自动迁移+种子)→ 健康检查;幂等,首次与更新同一命令 |

## 六、方案 A:VPS Docker 全栈部署(推荐)

### 6.1 服务器要求

- 任意 Linux VPS(Ubuntu 22.04+ / Debian 12+ 均可),**1 vCPU + 1GB 内存起步**(PostGIS 镜像较大,构建期建议 2GB 或加 swap),磁盘 ≥ 15GB;
- 安装 Docker Engine + Compose 插件(**Compose 需 v2.24+**,覆盖文件用了 `!override` 语法):

  ```bash
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker $USER   # 重新登录生效
  ```

- 防火墙只放行 22(SSH)、80、443;**不要**放行 4000/5432/8080(生产覆盖文件已保证它们不对公网监听,防火墙是第二道保险)。

### 6.2 DNS

在域名服务商添加 A 记录指向服务器 IP(如 `atlas.example.com → 203.0.113.10`)。使用 Caddy 时无须手动申请证书——首次有外网请求到达时自动向 Let's Encrypt 签发并续期;要求 DNS 已生效且 80/443 可达。

### 6.3 .env 生产配置清单(必做)

`cp .env.example .env` 后,按模板底部「生产部署」一节取消注释并填写四项:

| 变量 | 生产值 | 说明 |
| --- | --- | --- |
| `POSTGRES_PASSWORD` | 强随机密码 | **必改**。`openssl rand -base64 24` 生成;`deploy.sh` 会拒绝默认值 `atlas_local_only` 启动 |
| `SITE_ADDRESS` | `atlas.example.com` | Caddy 站点地址,决定证书域名 |
| `CORS_ORIGIN` | `https://atlas.example.com` | API 只允许该来源跨域(多个用英文逗号分隔);不设则回退为 `*` |
| `VITE_API_URL` | (置空:`VITE_API_URL=`) | 同源反代下前端用相对路径 `/api/*`。**注意**:保留本地默认 `http://localhost:4000` 会让访问者浏览器去请求他自己的电脑 |

`.env` 已被 `.gitignore` 忽略,永远不要提交到仓库。

### 6.4 首次部署

```bash
ssh <server>
git clone <仓库地址> bible-atlas && cd bible-atlas
cp .env.example .env && vi .env      # 按 6.3 填写四项
bash deploy/deploy.sh                 # 构建 → 启动 → 自动迁移+种子 → 健康检查
```

脚本结束会打印 `compose ps`;浏览器访问 `https://atlas.example.com` 验证。手动自检:

```bash
curl -fsS http://127.0.0.1:4000/health
curl -fsS 'http://127.0.0.1:4000/api/works?locale=zh-CN' | head -c 200
curl -fsSI https://atlas.example.com/assets/ 2>/dev/null | grep -i cache-control   # 应见 immutable
```

### 6.5 更新部署

```bash
cd bible-atlas && bash deploy/deploy.sh
```

同一条命令:ff-only 拉取最新代码 → 重建镜像 → `up -d`(只重建有变化的容器)→ migrate 容器把**新增**的迁移/种子补齐(`schema_migrations`/`seed_history` 记录已应用版本,幂等)→ 健康检查。静态资源带内容 hash,发版后旧缓存自动失效。

### 6.6 数据备份(pg_dump cron)

本项目数据完全由仓库内种子生成(只读展示,无用户数据),数据库可随时从代码重建——备份主要为了**快速恢复**而非唯一数据源。仍建议每日一备:

```bash
mkdir -p ~/backups
crontab -e   # 加入(每日 03:00,保留 14 天):
0 3 * * * cd ~/bible-atlas && docker compose -f docker-compose.yml -f deploy/docker-compose.prod.yml exec -T db pg_dump -U atlas -d literary_atlas | gzip > ~/backups/atlas-$(date +\%F).sql.gz && ls -t ~/backups/atlas-*.sql.gz | tail -n +15 | xargs -r rm
```

恢复:`gunzip -c ~/backups/atlas-<日期>.sql.gz | docker compose -f docker-compose.yml -f deploy/docker-compose.prod.yml exec -T db psql -U atlas -d literary_atlas`(空库时);或直接删卷重建:`docker compose down && docker volume rm literary-atlas_atlas_pgdata && bash deploy/deploy.sh`。

### 6.7 回滚

```bash
cd bible-atlas
git log --oneline -5                 # 找到上一个可用提交/标签
git checkout <commit-or-tag>
ATLAS_SKIP_PULL=1 bash deploy/deploy.sh
```

说明:迁移/种子是前向追加式的,代码回滚后**数据库不会自动降级**;本项目 API 只读、旧代码通常兼容新库,若确实需要旧库结构,按 6.6 删卷重建即可(数据可全量从种子再生,代价只是几十秒 bootstrap)。回滚后记得 `git checkout master` 恢复分支再排查。

### 6.8 主机 nginx 变体(替代 Caddy)

服务器已有 nginx 时,不启用 caddy profile:

```bash
ATLAS_PROXY_PROFILE=none bash deploy/deploy.sh
sudo cp deploy/nginx.conf /etc/nginx/sites-available/bible-atlas.conf   # 替换其中域名
sudo ln -s /etc/nginx/sites-available/bible-atlas.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
sudo certbot --nginx -d atlas.example.com
```

api/web 容器只发布在 `127.0.0.1:4000` / `127.0.0.1:8080`,由主机 nginx 代理(`deploy/nginx.conf` 已含 gzip 与静态资源长缓存)。

### 6.9 方案 B:PaaS 提示(Render / Fly.io)

- **api**:按 `apps/api/Dockerfile` 部署为 Web Service;环境变量 `DATABASE_URL`、`CORS_ORIGIN=<前端域名>`;release/启动前命令跑 `node dist/db-cli.js bootstrap`(镜像内已含 `db/`,`ATLAS_PROJECT_ROOT=/app`);
- **数据库**:托管 Postgres 需支持 PostGIS——Render Postgres、Fly Postgres、Neon、Supabase 均可 `CREATE EXTENSION postgis`;
- **web**:`npm run build -w @literary-atlas/web` 后把 `apps/web/dist` 交给静态托管(Render Static Site / Cloudflare Pages),构建时设 `VITE_API_URL=https://<api 域名>`(跨源部署,CORS_ORIGIN 必须包含前端域名);
- 注意免费档冷启动(首个请求慢数秒)与连接数限制(api 连接池 max=10)。

## 七、健康检查与监控建议

- **健康端点**:`GET /health` 会真实执行 `SELECT 1`,同时覆盖 API 进程与数据库连通性;生产覆盖文件已为 api/web 配置容器级 healthcheck,`restart: unless-stopped` 负责自愈;
- **外部拨测(强烈建议)**:UptimeRobot / Better Stack 免费档,监控 `https://站点域名/health`(经反代,顺带验证 TLS 与反代链路),间隔 1–5 分钟,告警到邮箱;
- **日志**:`docker compose -f docker-compose.yml -f deploy/docker-compose.prod.yml logs -f api`;json-file 已配 10MB×3 轮转,不会撑爆磁盘;
- **磁盘**:每月一次 `docker system df` 与 `docker image prune -f`(旧构建层);
- **证书**:Caddy 自动续期,无需干预;主机 nginx 变体靠 certbot 的 systemd timer,可 `sudo certbot renew --dry-run` 验证。

## 八、生产常见故障排查

| 症状 | 原因 | 处理 |
| --- | --- | --- |
| `deploy.sh` 报「仍是默认密码」 | `.env` 未改 `POSTGRES_PASSWORD` | 按 6.3 生成强密码后重跑;若库已用旧密码初始化过,需删卷重建(6.6) |
| 改了 `POSTGRES_PASSWORD` 后 api 连不上库 | Postgres 密码只在**首次初始化数据卷**时生效 | `docker compose down && docker volume rm literary-atlas_atlas_pgdata && bash deploy/deploy.sh` |
| 浏览器请求 `localhost:4000` 被拒 | 生产构建时 `VITE_API_URL` 没置空 | `.env` 写 `VITE_API_URL=`(等号后留空)后重跑 deploy.sh(会重建 web 镜像) |
| HTTPS 打不开 / 证书错误 | DNS 未生效、80/443 被防火墙拦、`SITE_ADDRESS` 填错 | `dig atlas.example.com` 验证解析;放行 80/443;查 `... logs caddy` |
| 页面能开但接口 4xx CORS 错 | `CORS_ORIGIN` 与实际访问域名不一致(协议/子域必须完全相同) | 改 `.env` 后 `docker compose ... up -d api` 重建 api 容器 |
| migrate 容器退出码非 0 | 某个迁移/种子 SQL 失败 | `docker compose ... logs migrate` 看失败文件;修复后重跑 deploy.sh(已应用的会跳过) |
| 首次部署健康检查超时 | 低配机器上 PostGIS 首次初始化 + 全量种子较慢 | `docker compose ... logs -f migrate` 观察进度;完成后 api 会自动启动 |
| 更新后页面还是旧的 | 浏览器缓存了 index.html | 反代已对 index.html 发 `no-cache`,强刷一次;若自建 CDN 需对 `/`、`/index.html` 关闭缓存 |

## 九、方案 C:静态化路线(已实现)

**一条命令产出完全自包含的静态站点**(前置:本地栈在运行,见第一部分快速启动):

```bash
bash deploy/deploy-static.sh                # 烘焙 + 构建 → apps/web/dist(约 2.3MB)
bash deploy/deploy-static.sh --publish cf   # 可选:wrangler 直发 Cloudflare Pages
```

实现构成:`apps/api/src/bake-static.ts` 把 works 与 the-bible 的 **detail=full** atlas(中英双语)烘焙到 `apps/web/public/data/`(gitignored,构建时随 Vite 进入 dist);前端 `VITE_DATA_MODE=static` 切换 `api.ts` 到 /data 静态路径、抽屉 prose 直接取 full atlas 字段、搜索改为内存图集子串检索(与服务端 ILIKE 行为一致);`--base=./` 相对路径使产物可托管在任意路径下(含 GitHub Pages 子路径)。产物冒烟断言:index.html 与 data 文件存在、assets 中无 localhost 残留。

数据更新流程:改种子 → `db-cli seed` → 重跑 `deploy-static.sh` → 重新发布。

托管选择:Cloudflare Pages(推荐,自动 HTTPS + 全球 CDN + `wrangler pages deploy`)、Netlify(`--publish netlify`)、GitHub Pages(把 dist 推到 gh-pages 分支或用 Actions)。SPA 仅用查询参数路由,无需 rewrite 规则。

以下为原设计记录(工作量评估与取舍分析,已按上述实现落地):

### 原设计(存档)

数据完全只读且更新频率低,理论上可去掉整个后端:

- **bake 内容**:`/api/locales`、`/api/works`(×2 locale)、`/api/works/<slug>/atlas?detail=full`(×5 作品 ×2 locale)。实测圣经全量 `detail=full` zh-CN 约 796KB(gzip 后 ~110KB),直接 bake `full` 即可**省掉全部 per-entity 详情端点**(否则圣经一部就是 224 人物 + 394 事件 + 101 地点 + 路线 ≈ 730×2 locale ≈ 1500 个小 JSON 文件,也可行但无必要);
- **bake 脚本**:起本地栈后用 Node 脚本枚举上述 URL,写入 `static-api/` 目录(保持与 API 相同路径结构,`?locale=` 变成路径后缀如 `atlas.zh-CN.json`),推送 Cloudflare Pages / GitHub Pages;
- **前端改造**(现阶段禁改 `apps/web/src/`,列为远期):`api.ts` 增加静态模式——按上述命名规则 fetch JSON;`getEntityDetail` 改为从 `detail=full` 的 atlas 里取字段(数据已在客户端,无需网络);
- **全文检索取舍**:`/api/search` 是唯一真正动态的端点(SQL ILIKE 跨 works/characters/events/locations,含 detail 长文)。两个选择:① 客户端检索——atlas `full` 数据全量在浏览器内存,用 minisearch/FlexSearch 建索引即可,支持度接近现状(约 1–2 天工作量);② 直接砍掉搜索(不推荐,搜索是核心导航);
- **工作量评估**:bake 脚本 0.5 天 + 前端 api 层静态模式 1 天 + 客户端检索 1–2 天 + CI(数据变更自动重 bake)0.5 天,合计约 **3–4 天**;
- **取舍**:零服务器成本、全球 CDN、天然抗流量;代价是失去服务端搜索、每次数据修订要重新 bake 发布、新增作品后包体线性增长(纯文本 JSON,gzip 后增长可控)。建议在数据基本定稿、访问量上来之后再走此路线。

## 十、安全清单(2026-07-27 复核)

- **secrets**:`.gitignore` 覆盖 `.env`(已验证 `git check-ignore`);git 追踪文件中无密钥/证书,仅 `.env.example` 模板(内含的 `atlas_local_only` 为本地演示默认值,生产由 `deploy.sh` 强制改密);
- **API 只读**:`apps/api/src/app.ts` 仅注册 GET 路由,无任何 POST/PUT/PATCH/DELETE,无用户系统与写入面;
- **CORS**:默认 `*` 仅限本地;生产经 `CORS_ORIGIN` 收紧(已实测:非许可 Origin 不返回 `Access-Control-Allow-Origin`);
- **依赖**:`npm audit` 全量与 `--omit=dev` 均 **0 漏洞**(express 5.2.1、pg 8.x、vite 7.3.6,2026-07-27);
- **网络暴露**:生产栈只有反代监听公网 80/443;db 完全不发布端口,api/web 仅绑 127.0.0.1;
- **输入面**:所有查询参数经 zod 校验(slug 白名单正则、搜索词长度限制),SQL 全部参数化。
