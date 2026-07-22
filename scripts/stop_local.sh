#!/usr/bin/env bash
set -Eeuo pipefail

ATLAS_PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ATLAS_PROJECT_ROOT"

if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  ATLAS_COMPOSE=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  ATLAS_COMPOSE=(docker-compose)
else
  printf '[错误] 未找到 Docker Compose。\n' >&2
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  printf '[错误] Docker Engine 未运行；服务可能已经停止。\n' >&2
  exit 1
fi

"${ATLAS_COMPOSE[@]}" down
printf '\n世界文学名著时空地图已停止。数据库卷已保留。\n'
printf '重新启动：双击 Start-Literary-Atlas.command\n'

