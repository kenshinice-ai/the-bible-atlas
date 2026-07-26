#!/usr/bin/env bash
set -Eeuo pipefail

# 圣经舆图 The Bible Atlas · 静态化部署(方案 C,零服务器)
#
# 产出一个完全自包含的静态站点(apps/web/dist),可托管到任何静态平台:
# Cloudflare Pages / Netlify / GitHub Pages / 任意对象存储 + CDN。
#
# 前置条件:本地 API + 数据库在运行(用于烘焙数据):
#   npm run start:local        # 或 docs/DEPLOYMENT.md 快速启动中的任一方式
#
# 用法:
#   bash deploy/deploy-static.sh              # 烘焙 + 构建,产出 dist
#   bash deploy/deploy-static.sh --publish cf # 构建后用 wrangler 发布 Cloudflare Pages
#   bash deploy/deploy-static.sh --publish netlify

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"

API_URL="${BAKE_API_URL:-http://localhost:4000}"
PUBLISH=""
[[ "${1:-}" == "--publish" ]] && PUBLISH="${2:-}"

echo "[1/4] 检查本地 API(烘焙数据源):$API_URL"
if ! curl -sf "$API_URL/health" > /dev/null; then
  echo "错误:API 未运行。先启动本地栈(npm run start:local),再重试。" >&2
  exit 1
fi

echo "[2/4] 烘焙静态数据(works + full atlas,双语)"
npm run bake:static -w @literary-atlas/api -- --api "$API_URL"

echo "[3/4] 静态模式构建(VITE_DATA_MODE=static,相对资源路径)"
VITE_DATA_MODE=static npm run build -w @literary-atlas/web -- --base=./

DIST="$ROOT/apps/web/dist"
echo "[4/4] 产物检查:$DIST"
test -f "$DIST/index.html"
test -f "$DIST"/data/atlas.the-bible.en.json
if grep -rl "localhost:4000" "$DIST/assets" > /dev/null 2>&1; then
  echo "错误:产物中残留 localhost API 地址,静态模式未生效。" >&2
  exit 1
fi
du -sh "$DIST"
echo "静态站点就绪。本地预览:npx vite preview --outDir apps/web/dist"

case "$PUBLISH" in
  cf)      npx wrangler pages deploy "$DIST" --project-name bible-atlas --branch main ;;
  netlify) npx netlify deploy --dir "$DIST" --prod ;;
  "")      echo "未指定 --publish;把 dist 上传到任意静态托管即可(见 docs/DEPLOYMENT.md 方案 C)。" ;;
  *)       echo "未知发布目标:$PUBLISH(支持 cf / netlify)" >&2; exit 1 ;;
esac
