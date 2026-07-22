#!/usr/bin/env bash
set -Eeuo pipefail

ATLAS_PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ATLAS_DRY_RUN=0
ATLAS_OPEN_BROWSER=1
ATLAS_SKIP_INSTALL=0
ATLAS_COMPOSE=()

usage() {
  sed -n '2,33p' "$0" | sed -n 's/^# //p'
}

# 世界文学名著时空地图一键启动器
#
# 用法：
#   ./Start-Literary-Atlas.command
#   bash scripts/start_local.sh [选项]
#
# 选项：
#   --dry-run       只显示将执行的步骤，不安装或启动任何内容
#   --no-open       启动成功后不自动打开浏览器
#   --skip-install  缺少依赖时直接报错，不自动安装
#   --help          显示帮助
#
# 启动内容：
#   Web: http://localhost:8080
#   API: http://localhost:4000
#   DB:  localhost:5432

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

for argument in "$@"; do
  case "$argument" in
    --dry-run) ATLAS_DRY_RUN=1 ;;
    --no-open) ATLAS_OPEN_BROWSER=0 ;;
    --skip-install) ATLAS_SKIP_INSTALL=1 ;;
    --help|-h) usage; exit 0 ;;
    *) fail "未知参数：$argument（使用 --help 查看帮助）" ;;
  esac
done

cd "$ATLAS_PROJECT_ROOT"

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then return; fi
  [[ "$(uname -s)" == "Darwin" ]] || fail "自动安装依赖目前仅支持 macOS；请先安装 Docker Engine 与 Compose。"
  [[ "$ATLAS_SKIP_INSTALL" -eq 0 ]] || fail "未找到 Homebrew，且已指定 --skip-install。"
  log "环境" "未找到 Homebrew，将使用官方安装器安装。"
  if [[ "$ATLAS_DRY_RUN" -eq 1 ]]; then
    printf '[dry-run] 安装 Homebrew：https://brew.sh\n'
    return
  fi
  printf '安装程序可能请求 macOS 管理员密码；输入时终端不会显示字符。\n'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || \
    fail "Homebrew 安装失败。请检查上方错误，或从 https://brew.sh 手动安装后重试。"
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  command -v brew >/dev/null 2>&1 || fail "Homebrew 安装完成，但当前终端仍找不到 brew。请重新打开 Terminal 后再运行。"
}

docker_desktop_installed() {
  [[ -d /Applications/Docker.app || -d "$HOME/Applications/Docker.app" ]]
}

configure_docker_desktop_path() {
  # Homebrew may copy Docker.app successfully before an administrator-owned
  # /usr/local/bin prevents its helper symlinks from being created. Docker's
  # own Resources/bin directory remains authoritative and contains both the
  # CLI and credential helper needed for authenticated image pulls.
  local docker_app
  for docker_app in /Applications/Docker.app "$HOME/Applications/Docker.app"; do
    if [[ -x "$docker_app/Contents/Resources/bin/docker-credential-desktop" ]]; then
      export PATH="$docker_app/Contents/Resources/bin:$PATH"
      return
    fi
  done
}

install_docker_desktop_if_needed() {
  if docker_desktop_installed; then return; fi
  [[ "$(uname -s)" == "Darwin" ]] || fail "未检测到可用 Docker 服务。请安装并启动 Docker Engine。"
  [[ "$ATLAS_SKIP_INSTALL" -eq 0 ]] || fail "未找到 Docker Desktop，且已指定 --skip-install。"
  ensure_homebrew
  log "环境" "未找到 Docker Desktop，将安装必须的 Docker Desktop。"
  if [[ "$ATLAS_DRY_RUN" -eq 1 ]]; then
    run brew install --cask docker
    return
  fi
  printf '安装 Docker Desktop 可能请求 macOS 管理员密码；输入时终端不会显示字符。\n'
  brew install --cask docker || \
    fail "Docker Desktop 安装失败。请在可输入管理员密码的终端重新运行，或手动安装后重试。"
}

wait_for_docker() {
  if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then return; fi
  install_docker_desktop_if_needed
  if [[ "$ATLAS_DRY_RUN" -eq 1 ]]; then
    printf '[dry-run] 打开 Docker Desktop 并等待 Docker Engine 就绪\n'
    return
  fi
  log "环境" "正在启动 Docker Desktop，首次启动可能需要确认许可。"
  open -a Docker || fail "无法打开 Docker Desktop。请手动打开后重试。"
  local waited=0
  while (( waited < 180 )); do
    if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
      printf '\n'
      return
    fi
    printf '.'
    sleep 3
    waited=$((waited + 3))
  done
  printf '\n'
  fail "等待 Docker Engine 超时。请确认 Docker Desktop 已完成首次启动和许可，然后重新运行。"
}

detect_compose() {
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    ATLAS_COMPOSE=(docker compose)
  elif command -v docker-compose >/dev/null 2>&1; then
    ATLAS_COMPOSE=(docker-compose)
  elif [[ "$ATLAS_DRY_RUN" -eq 1 ]]; then
    ATLAS_COMPOSE=(docker compose)
  else
    fail "Docker 已运行，但没有找到 Docker Compose。请更新 Docker Desktop。"
  fi
}

wait_for_url() {
  local url=$1
  local label=$2
  local timeout_seconds=$3
  local waited=0
  while (( waited < timeout_seconds )); do
    if curl -fsS --max-time 3 "$url" >/dev/null 2>&1; then return; fi
    sleep 2
    waited=$((waited + 2))
  done
  "${ATLAS_COMPOSE[@]}" ps >&2 || true
  "${ATLAS_COMPOSE[@]}" logs --tail=80 >&2 || true
  fail "$label 在 ${timeout_seconds} 秒内没有就绪：$url"
}

log "1/3" "检查运行环境"
[[ "$(uname -s)" == "Darwin" ]] || log "提示" "当前不是 macOS，将跳过自动安装并使用现有 Docker 环境。"
command -v curl >/dev/null 2>&1 || fail "缺少 curl，无法执行健康检查。"
if command -v node >/dev/null 2>&1; then
  printf 'Node.js: %s（Docker 启动不依赖本机 Node）\n' "$(node --version)"
else
  printf 'Node.js: 未安装（Docker 会提供项目所需 Node.js）\n'
fi
configure_docker_desktop_path
wait_for_docker
detect_compose
if [[ "$ATLAS_DRY_RUN" -eq 0 ]]; then
  printf 'Docker: %s\n' "$(docker --version)"
  printf 'Compose: %s\n' "$("${ATLAS_COMPOSE[@]}" version --short 2>/dev/null || "${ATLAS_COMPOSE[@]}" version)"
fi

if [[ ! -f .env ]]; then
  log "配置" "创建本地 .env（不会覆盖已有配置）"
  run cp .env.example .env
else
  printf '.env: 已存在，保持不变\n'
fi

log "2/3" "构建并启动 PostgreSQL/PostGIS、API 与 Web"
run "${ATLAS_COMPOSE[@]}" config --quiet
# Compose v5 BuildKit/Bake can emit an invalid gRPC session header when the
# project lives in an iCloud path containing non-ASCII characters. The classic
# builder avoids that upstream path-encoding failure and produces the same
# Dockerfile-defined runtime images.
printf 'Docker 构建：启用 iCloud/中文路径兼容模式\n'
run env DOCKER_BUILDKIT=0 "${ATLAS_COMPOSE[@]}" up --detach --build --remove-orphans

if [[ "$ATLAS_DRY_RUN" -eq 0 ]]; then
  log "健康检查" "等待 API 与网页就绪"
  wait_for_url "http://localhost:4000/health" "API" 180
  wait_for_url "http://localhost:8080" "Web" 60
fi

log "3/3" "启动完成"
cat <<'INFO'

访问网址：
  世界文学地图  http://localhost:8080
  API 健康检查  http://localhost:4000/health

你可以：
  • 在中文和 English 之间切换，当前浏览状态会保留；
  • 单选作品，或最多选择三部同层作品进行地图对照；
  • 浏览人物、事件、地点、路线和时间轴；
  • 查看《双城记》的完整人物—事件—地点—路线闭环；
  • 在独立虚构画布中浏览《霍比特人》。

停止服务：双击 Stop-Literary-Atlas.command
终端停止：bash scripts/stop_local.sh
INFO

if [[ "$ATLAS_DRY_RUN" -eq 0 && "$ATLAS_OPEN_BROWSER" -eq 1 && "$(uname -s)" == "Darwin" ]]; then
  run open "http://localhost:8080"
fi
