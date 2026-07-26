#!/usr/bin/env bash
# =============================================================
# 圣经舆图 The Bible Atlas — VPS 一键部署脚本(幂等,可重复执行)
#
# 首次部署与更新部署都执行同一条命令:
#   bash deploy/deploy.sh
#
# 可用环境变量:
#   ATLAS_PROXY_PROFILE  caddy(默认,容器内 Caddy 自动 HTTPS)| none(自备主机 nginx)
#   ATLAS_BRANCH         要部署的 git 分支(默认:当前分支,ff-only 拉取)
#   ATLAS_SKIP_PULL      设为 1 跳过 git pull(例如手动 rsync 上传的代码)
#
# 流程:依赖检查 → 拉代码 → .env 安全检查 → 构建镜像 → 启动
#       (migrate 容器自动跑迁移+种子,幂等)→ 健康检查
# =============================================================
set -euo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PROXY_PROFILE="${ATLAS_PROXY_PROFILE:-caddy}"
HEALTH_URL="${ATLAS_HEALTH_URL:-http://127.0.0.1:4000/health}"

log()  { printf '\n\033[1;34m[deploy]\033[0m %s\n' "$*"; }
fail() { printf '\n\033[1;31m[deploy] 错误:\033[0m %s\n' "$*" >&2; exit 1; }

compose() {
  local profile_args=()
  [ "$PROXY_PROFILE" != "none" ] && profile_args=(--profile "$PROXY_PROFILE")
  docker compose -f docker-compose.yml -f deploy/docker-compose.prod.yml "${profile_args[@]}" "$@"
}

# ---------- 1. 依赖检查 ----------
command -v docker >/dev/null 2>&1 || fail "未安装 docker(参见 docs/DEPLOYMENT.md 服务器准备一节)"
docker compose version >/dev/null 2>&1 || fail "缺少 docker compose 插件(需要 v2.24+,支持 !override 语法)"
command -v curl >/dev/null 2>&1 || fail "未安装 curl"

# ---------- 2. 拉取最新代码(幂等;非 git 目录或 ATLAS_SKIP_PULL=1 时跳过) ----------
if [ "${ATLAS_SKIP_PULL:-0}" != "1" ] && [ -d .git ]; then
  if [ -n "$(git status --porcelain)" ]; then
    log "工作区有未提交改动,跳过 git pull(如需强制更新请先处理改动)"
  else
    log "拉取最新代码(ff-only)"
    git fetch --prune
    if [ -n "${ATLAS_BRANCH:-}" ]; then
      git checkout "$ATLAS_BRANCH"
      git pull --ff-only origin "$ATLAS_BRANCH"
    else
      git pull --ff-only || log "当前分支无法快进合并,继续用本地代码部署"
    fi
  fi
fi

# ---------- 3. .env 生产安全检查 ----------
if [ ! -f .env ]; then
  cp .env.example .env
  fail "首次部署:已从 .env.example 生成 .env,请编辑其中的生产配置(POSTGRES_PASSWORD/SITE_ADDRESS/CORS_ORIGIN/VITE_API_URL)后重新执行本脚本"
fi
grep -Eq '^POSTGRES_PASSWORD=.+' .env || fail ".env 缺少 POSTGRES_PASSWORD(生产必须显式设置强密码)"
grep -Eq '^POSTGRES_PASSWORD=atlas_local_only\b' .env && fail ".env 仍是默认密码 atlas_local_only,生产禁止使用;请改为强随机密码(例:openssl rand -base64 24)"
if [ "$PROXY_PROFILE" = "caddy" ] && ! grep -Eq '^SITE_ADDRESS=.+' .env; then
  log "警告:.env 未设置 SITE_ADDRESS,Caddy 将只在 localhost 上用自签证书服务(演练模式)"
fi
grep -Eq '^VITE_API_URL=https?://localhost' .env && \
  log "警告:VITE_API_URL 仍指向 localhost。同源反代部署应设置为空(VITE_API_URL=),否则页面会请求访问者自己的电脑"

# ---------- 4. 构建镜像 ----------
# migrate 与 api 共用 literary-atlas-api 镜像(build 定义挂在 migrate 上)
log "构建镜像(api + web)"
compose build --pull migrate web

# ---------- 5. 启动(migrate 自动执行迁移+种子,均幂等) ----------
log "启动服务栈(反代模式:${PROXY_PROFILE})"
compose up -d --remove-orphans

# ---------- 6. 健康检查 ----------
log "等待 API 通过健康检查:${HEALTH_URL}"
for _ in $(seq 1 60); do
  if curl -fsS "$HEALTH_URL" >/dev/null 2>&1; then
    log "API 健康检查通过"
    compose ps
    log "部署完成。数据接口自检:curl -fsS '${HEALTH_URL%/health}/api/works?locale=zh-CN' | head -c 200"
    exit 0
  fi
  sleep 2
done

compose ps || true
docker compose -f docker-compose.yml -f deploy/docker-compose.prod.yml logs --tail 50 api migrate || true
fail "API 在 120 秒内未通过健康检查,请查看上方日志"
