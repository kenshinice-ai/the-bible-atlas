#!/usr/bin/env bash
set -Eeuo pipefail

# 圣经舆图 The Bible Atlas 停止脚本：
# 1. 按 release/logs/*.pid 结束本地 API / Web 进程（含子进程）；
# 2. 兜底清理仍占用 API/Web 端口的本用户 node 进程；
# 3. 如旧 Docker 栈仍在运行，一并 docker compose down（数据库卷保留）。
# 本机 Homebrew PostgreSQL 不会被停止。

ATLAS_PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ATLAS_PROJECT_ROOT"

ATLAS_PRESET_API_PORT=${API_PORT-}
ATLAS_PRESET_WEB_PORT=${WEB_PORT-}
if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi
if [[ -n "$ATLAS_PRESET_API_PORT" ]]; then API_PORT=$ATLAS_PRESET_API_PORT; fi
if [[ -n "$ATLAS_PRESET_WEB_PORT" ]]; then WEB_PORT=$ATLAS_PRESET_WEB_PORT; fi
ATLAS_API_PORT=${API_PORT:-4000}
ATLAS_WEB_PORT=${WEB_PORT:-5173}
ATLAS_LOG_DIR="$ATLAS_PROJECT_ROOT/release/logs"

kill_tree() {
  # 结束进程及其全部后代（先 TERM，2 秒后仍存活则 KILL）。
  local pid=$1 child
  for child in $(pgrep -P "$pid" 2>/dev/null || true); do
    kill_tree "$child"
  done
  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null || true
    for _ in 1 2 3 4; do
      kill -0 "$pid" 2>/dev/null || return 0
      sleep 0.5
    done
    kill -9 "$pid" 2>/dev/null || true
  fi
}

stop_from_pidfile() {
  local file=$1 label=$2 pid
  [[ -f "$file" ]] || { printf '%s：无 PID 文件，跳过\n' "$label"; return 0; }
  pid=$(cat "$file" 2>/dev/null || true)
  if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
    kill_tree "$pid"
    printf '%s：已停止（PID %s）\n' "$label" "$pid"
  else
    printf '%s：进程已不在运行\n' "$label"
  fi
  rm -f "$file"
}

stop_port_leftovers() {
  # 兜底：清理仍监听指定端口的本用户 node/vite/tsx 残留进程。
  local port=$1 label=$2 pid command_name
  for pid in $(lsof -nP -t -iTCP:"$port" -sTCP:LISTEN 2>/dev/null || true); do
    command_name=$(ps -o comm= -p "$pid" 2>/dev/null || true)
    case "$command_name" in
      *node*|*tsx*|*vite*)
        kill_tree "$pid"
        printf '%s：清理了残留进程（PID %s，%s）\n' "$label" "$pid" "$command_name"
        ;;
      *)
        printf '%s：端口 %s 被非本项目进程占用（PID %s，%s），未动它\n' "$label" "$port" "$pid" "$command_name"
        ;;
    esac
  done
}

stop_from_pidfile "$ATLAS_LOG_DIR/web.pid" "Web"
stop_from_pidfile "$ATLAS_LOG_DIR/api.pid" "API"
stop_port_leftovers "$ATLAS_WEB_PORT" "Web"
stop_port_leftovers "$ATLAS_API_PORT" "API"

if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if [[ -n "$(docker compose ps -q 2>/dev/null)" ]]; then
    printf 'Docker：检测到旧 Docker 栈仍在运行，执行 docker compose down…\n'
    docker compose down
  fi
fi

printf '\n圣经舆图 The Bible Atlas 已停止。本机 PostgreSQL 与数据均保留。\n'
printf '重新启动：双击 Start-Bible-Atlas.command\n'
