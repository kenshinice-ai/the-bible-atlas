#!/usr/bin/env bash
set -Eeuo pipefail

# 圣经舆图 The Bible Atlas 一键启动器（本地栈：Homebrew Postgres + tsx API + Vite Web）
#
# 用法：
#   ./Start-Bible-Atlas.command
#   bash scripts/start_local.sh [选项]
#
# 选项：
#   --dry-run   只显示将执行的步骤，不安装或启动任何内容
#   --no-open   启动成功后不自动打开浏览器
#   --help      显示帮助
#
# 启动内容：
#   Web: http://localhost:5173（Vite 开发服务器）
#   API: http://localhost:4000（Express + PostGIS）
#   DB:  localhost:5432（本机 Homebrew PostgreSQL）
#
# 日志与 PID 文件：release/logs/
# 停止服务：双击 Stop-Bible-Atlas.command 或 bash scripts/stop_local.sh

ATLAS_PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ATLAS_DRY_RUN=0
ATLAS_OPEN_BROWSER=1

usage() { sed -n '4,21p' "$0" | sed 's/^# \{0,1\}//'; }

log() { printf '\n[%s] %s\n' "$1" "$2"; }
fail() { printf '\n[错误] %s\n' "$1" >&2; exit 1; }

run() {
  if [[ "$ATLAS_DRY_RUN" -eq 1 ]]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

confirm() {
  # confirm "提示语"  → 0 表示同意。dry-run 或非交互终端时默认同意（只打印提示）。
  local prompt=$1 answer
  if [[ "$ATLAS_DRY_RUN" -eq 1 ]]; then printf '[dry-run] %s → 默认同意\n' "$prompt"; return 0; fi
  if [[ ! -t 0 ]]; then printf '%s（非交互模式，默认同意）\n' "$prompt"; return 0; fi
  read -r -p "$prompt [Y/n] " answer
  [[ -z "$answer" || "$answer" == [Yy]* ]]
}

for argument in "$@"; do
  case "$argument" in
    --dry-run) ATLAS_DRY_RUN=1 ;;
    --no-open) ATLAS_OPEN_BROWSER=0 ;;
    --help|-h) usage; exit 0 ;;
    *) fail "未知参数：$argument（使用 --help 查看帮助）" ;;
  esac
done

cd "$ATLAS_PROJECT_ROOT"

# ---------- 配置：读取 .env（缺失变量用默认值；已导出的环境变量优先） ----------
ATLAS_PRESET_API_PORT=${API_PORT-}
ATLAS_PRESET_WEB_PORT=${WEB_PORT-}
ATLAS_PRESET_DB_URL=${ATLAS_LOCAL_DATABASE_URL-}
ATLAS_PRESET_VITE_API_URL=${VITE_API_URL-}
if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
  printf '配置：已读取 .env\n'
else
  printf '配置：未找到 .env，使用默认值（可执行 cp .env.example .env 自定义）\n'
fi
if [[ -n "$ATLAS_PRESET_API_PORT" ]]; then API_PORT=$ATLAS_PRESET_API_PORT; fi
if [[ -n "$ATLAS_PRESET_WEB_PORT" ]]; then WEB_PORT=$ATLAS_PRESET_WEB_PORT; fi
if [[ -n "$ATLAS_PRESET_DB_URL" ]]; then ATLAS_LOCAL_DATABASE_URL=$ATLAS_PRESET_DB_URL; fi
if [[ -n "$ATLAS_PRESET_VITE_API_URL" ]]; then VITE_API_URL=$ATLAS_PRESET_VITE_API_URL; fi

ATLAS_DB_NAME=${POSTGRES_DB:-literary_atlas}
ATLAS_API_PORT=${API_PORT:-4000}
ATLAS_WEB_PORT=${WEB_PORT:-5173}
# 本地栈专用连接串：默认当前 macOS 用户免密连接本机库。
# 注意：不使用 .env 中面向 Docker 栈的 DATABASE_URL（其账号只存在于容器内）。
ATLAS_DB_URL=${ATLAS_LOCAL_DATABASE_URL:-postgresql://${USER}@localhost:5432/${ATLAS_DB_NAME}}
ATLAS_VITE_API_URL=${VITE_API_URL:-http://localhost:${ATLAS_API_PORT}}

ATLAS_LOG_DIR="$ATLAS_PROJECT_ROOT/release/logs"
ATLAS_API_PID_FILE="$ATLAS_LOG_DIR/api.pid"
ATLAS_WEB_PID_FILE="$ATLAS_LOG_DIR/web.pid"
ATLAS_API_LOG="$ATLAS_LOG_DIR/api.log"
ATLAS_WEB_LOG="$ATLAS_LOG_DIR/web.log"
ATLAS_WEB_URL="http://localhost:${ATLAS_WEB_PORT}"
ATLAS_API_HEALTH_URL="http://localhost:${ATLAS_API_PORT}/health"

mkdir -p "$ATLAS_LOG_DIR"

# ---------- 工具函数 ----------
pid_alive() { local pid=$1; [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; }

pidfile_running() {
  # pidfile_running <pid文件>  → 0 表示该 PID 仍存活
  local file=$1 pid
  [[ -f "$file" ]] || return 1
  pid=$(cat "$file" 2>/dev/null || true)
  if pid_alive "$pid"; then return 0; fi
  rm -f "$file"
  return 1
}

port_in_use() { lsof -nP -iTCP:"$1" -sTCP:LISTEN >/dev/null 2>&1; }

port_holder() { lsof -nP -iTCP:"$1" -sTCP:LISTEN 2>/dev/null | awk 'NR==2 {print $1 " (PID " $2 ")"}'; }

docker_stack_running() {
  command -v docker >/dev/null 2>&1 || return 1
  docker info >/dev/null 2>&1 || return 1
  [[ -n "$(docker compose ps -q 2>/dev/null)" ]]
}

wait_for_url() {
  local url=$1 label=$2 timeout_seconds=$3 logfile=$4 waited=0
  while (( waited < timeout_seconds )); do
    if curl -fsS --max-time 3 "$url" >/dev/null 2>&1; then return 0; fi
    sleep 2
    waited=$((waited + 2))
  done
  printf '\n[错误] %s 在 %s 秒内没有就绪：%s\n' "$label" "$timeout_seconds" "$url" >&2
  printf '最近日志（%s）：\n' "$logfile" >&2
  tail -40 "$logfile" >&2 || true
  printf '\n可执行 bash scripts/stop_local.sh 清理后重试。\n' >&2
  exit 1
}

# ---------- 幂等检查：已在运行则不重复启动 ----------
ATLAS_API_RUNNING=0
ATLAS_WEB_RUNNING=0
if pidfile_running "$ATLAS_API_PID_FILE"; then ATLAS_API_RUNNING=1; fi
if pidfile_running "$ATLAS_WEB_PID_FILE"; then ATLAS_WEB_RUNNING=1; fi
if [[ "$ATLAS_API_RUNNING" -eq 1 && "$ATLAS_WEB_RUNNING" -eq 1 ]]; then
  log "提示" "服务已在运行，无需重复启动。"
  printf '  Web  %s\n  API  %s\n' "$ATLAS_WEB_URL" "$ATLAS_API_HEALTH_URL"
  printf '如需重启：先双击 Stop-Bible-Atlas.command。\n'
  if [[ "$ATLAS_DRY_RUN" -eq 0 && "$ATLAS_OPEN_BROWSER" -eq 1 && "$(uname -s)" == "Darwin" ]]; then
    open "$ATLAS_WEB_URL"
  fi
  exit 0
fi

# ---------- 1/4 环境检查 ----------
log "1/4" "检查运行环境（Node.js / PostgreSQL）"

command -v curl >/dev/null 2>&1 || fail "缺少 curl，无法执行健康检查。"

if ! command -v node >/dev/null 2>&1; then
  fail "未找到 Node.js。请先安装（推荐 brew install node，需要 22 或更高版本）。"
fi
ATLAS_NODE_MAJOR=$(node -p 'process.versions.node.split(".")[0]')
if (( ATLAS_NODE_MAJOR < 22 )); then
  fail "Node.js 版本过低（当前 $(node --version)，需要 >= 22）。请升级：brew upgrade node"
fi
command -v npm >/dev/null 2>&1 || fail "未找到 npm。请重新安装 Node.js（brew install node）。"
printf 'Node.js: %s / npm: %s\n' "$(node --version)" "$(npm --version)"

for tool in psql createdb pg_isready; do
  command -v "$tool" >/dev/null 2>&1 || fail "未找到 $tool。请先安装 PostgreSQL：brew install postgresql@18 postgis && brew services start postgresql@18"
done

# 端口 5432：先看是否被旧 Docker 栈占用
if ! pg_isready -h localhost -p 5432 >/dev/null 2>&1; then
  if docker_stack_running; then
    log "提示" "检测到旧 Docker 栈正在运行，可能占用端口 4000/5432。"
    if confirm "是否执行 docker compose down 停止旧 Docker 栈？"; then
      run docker compose down
    else
      fail "端口被 Docker 栈占用，且未同意停止。请手动执行 docker compose down 后重试。"
    fi
  fi
fi

# 本机 Postgres 未运行则尝试通过 brew services 启动
if ! pg_isready -h localhost -p 5432 >/dev/null 2>&1; then
  ATLAS_PG_FORMULA=$(brew services list 2>/dev/null | awk '/^postgresql/ {print $1; exit}' || true)
  ATLAS_PG_FORMULA=${ATLAS_PG_FORMULA:-postgresql@18}
  log "数据库" "本机 PostgreSQL 未运行，尝试启动：brew services start $ATLAS_PG_FORMULA"
  run brew services start "$ATLAS_PG_FORMULA" || true
  if [[ "$ATLAS_DRY_RUN" -eq 0 ]]; then
    ATLAS_WAITED=0
    until pg_isready -h localhost -p 5432 >/dev/null 2>&1; do
      (( ATLAS_WAITED >= 30 )) && fail "PostgreSQL 启动超时。请手动执行 brew services restart $ATLAS_PG_FORMULA 并查看 brew services info $ATLAS_PG_FORMULA。"
      sleep 2; ATLAS_WAITED=$((ATLAS_WAITED + 2))
    done
  fi
fi
printf 'PostgreSQL: localhost:5432 已就绪\n'

# ---------- 2/4 数据库与依赖准备 ----------
log "2/4" "准备数据库（${ATLAS_DB_NAME}）与 npm 依赖"

if [[ "$ATLAS_DRY_RUN" -eq 1 ]]; then
  printf '[dry-run] 检查数据库 %s 是否存在，缺失则 createdb + CREATE EXTENSION postgis + bootstrap（迁移+种子）\n' "$ATLAS_DB_NAME"
else
  if ! psql -h localhost -p 5432 -d "$ATLAS_DB_NAME" -Atc "SELECT 1" >/dev/null 2>&1; then
    log "数据库" "未找到数据库 ${ATLAS_DB_NAME}，将自动创建并初始化（迁移 + 种子数据）。"
    createdb -h localhost -p 5432 "$ATLAS_DB_NAME" || fail "createdb 失败。请检查当前用户是否有建库权限（psql -l 查看现状）。"
  fi
  psql -h localhost -p 5432 -d "$ATLAS_DB_NAME" -qc "CREATE EXTENSION IF NOT EXISTS postgis" \
    || fail "无法启用 PostGIS 扩展。请确认已安装：brew install postgis"
fi

if [[ ! -x node_modules/.bin/tsx || ! -x node_modules/.bin/vite ]]; then
  log "依赖" "node_modules 缺失或不完整，执行 npm install（首次可能需要几分钟）。"
  run npm install
else
  printf 'npm 依赖：已就绪\n'
fi

if [[ "$ATLAS_DRY_RUN" -eq 1 ]]; then
  printf '[dry-run] env DATABASE_URL=%s npm run db:bootstrap（幂等：已应用的迁移/种子自动跳过）\n' "$ATLAS_DB_URL"
else
  log "数据库" "执行迁移与种子（幂等，已应用的自动跳过）"
  env DATABASE_URL="$ATLAS_DB_URL" npm run db:bootstrap \
    || fail "数据库初始化失败。请检查上方 SQL 错误；连接串为 $ATLAS_DB_URL"
fi

# ---------- 3/4 端口检查并启动服务 ----------
log "3/4" "启动 API（:${ATLAS_API_PORT}）与 Web（:${ATLAS_WEB_PORT}）"

if [[ "$ATLAS_API_RUNNING" -eq 0 && "$ATLAS_DRY_RUN" -eq 0 ]] && port_in_use "$ATLAS_API_PORT"; then
  if docker_stack_running; then
    log "提示" "端口 ${ATLAS_API_PORT} 被旧 Docker 栈占用。"
    if confirm "是否执行 docker compose down 释放端口？"; then
      run docker compose down
    fi
  fi
  if port_in_use "$ATLAS_API_PORT"; then
    fail "端口 ${ATLAS_API_PORT} 被占用：$(port_holder "$ATLAS_API_PORT")。请释放后重试。"
  fi
fi

if [[ "$ATLAS_WEB_RUNNING" -eq 0 && "$ATLAS_DRY_RUN" -eq 0 ]] && port_in_use "$ATLAS_WEB_PORT"; then
  fail "端口 ${ATLAS_WEB_PORT} 被占用：$(port_holder "$ATLAS_WEB_PORT")。若是残留的 vite 进程，可执行 bash scripts/stop_local.sh 清理。"
fi

if [[ "$ATLAS_API_RUNNING" -eq 1 ]]; then
  printf 'API：已在运行（PID %s），跳过启动\n' "$(cat "$ATLAS_API_PID_FILE")"
elif [[ "$ATLAS_DRY_RUN" -eq 1 ]]; then
  printf '[dry-run] 启动 API：DATABASE_URL=%s API_PORT=%s npx tsx src/index.ts（日志 %s）\n' "$ATLAS_DB_URL" "$ATLAS_API_PORT" "$ATLAS_API_LOG"
else
  (
    cd "$ATLAS_PROJECT_ROOT/apps/api"
    DATABASE_URL="$ATLAS_DB_URL" API_PORT="$ATLAS_API_PORT" \
      nohup npx tsx src/index.ts >"$ATLAS_API_LOG" 2>&1 &
    echo $! >"$ATLAS_API_PID_FILE"
  )
  printf 'API：已启动（PID %s，日志 %s）\n' "$(cat "$ATLAS_API_PID_FILE")" "$ATLAS_API_LOG"
fi

if [[ "$ATLAS_WEB_RUNNING" -eq 1 ]]; then
  printf 'Web：已在运行（PID %s），跳过启动\n' "$(cat "$ATLAS_WEB_PID_FILE")"
elif [[ "$ATLAS_DRY_RUN" -eq 1 ]]; then
  printf '[dry-run] 启动 Web：VITE_API_URL=%s npx vite --port %s --strictPort（日志 %s）\n' "$ATLAS_VITE_API_URL" "$ATLAS_WEB_PORT" "$ATLAS_WEB_LOG"
else
  (
    cd "$ATLAS_PROJECT_ROOT/apps/web"
    VITE_API_URL="$ATLAS_VITE_API_URL" \
      nohup npx vite --port "$ATLAS_WEB_PORT" --strictPort >"$ATLAS_WEB_LOG" 2>&1 &
    echo $! >"$ATLAS_WEB_PID_FILE"
  )
  printf 'Web：已启动（PID %s，日志 %s）\n' "$(cat "$ATLAS_WEB_PID_FILE")" "$ATLAS_WEB_LOG"
fi

if [[ "$ATLAS_DRY_RUN" -eq 0 ]]; then
  log "健康检查" "等待 API 与网页就绪"
  wait_for_url "$ATLAS_API_HEALTH_URL" "API" 60 "$ATLAS_API_LOG"
  wait_for_url "$ATLAS_WEB_URL" "Web" 60 "$ATLAS_WEB_LOG"
fi

# ---------- 4/4 完成 ----------
log "4/4" "启动完成"
cat <<INFO

访问网址：
  圣经舆图 The Bible Atlas  ${ATLAS_WEB_URL}
  API 健康检查              ${ATLAS_API_HEALTH_URL}

日志：release/logs/api.log、release/logs/web.log
停止服务：双击 Stop-Bible-Atlas.command，或 bash scripts/stop_local.sh
重复双击本启动器不会重复起进程（已运行时仅打开浏览器）。
INFO

if [[ "$ATLAS_DRY_RUN" -eq 0 && "$ATLAS_OPEN_BROWSER" -eq 1 && "$(uname -s)" == "Darwin" ]]; then
  run open "$ATLAS_WEB_URL"
fi
