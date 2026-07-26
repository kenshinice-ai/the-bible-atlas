#!/usr/bin/env bash
set -Eeuo pipefail

ATLAS_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ATLAS_ROOT"

bash -n scripts/start_local.sh
bash -n scripts/stop_local.sh
zsh -n Start-Literary-Atlas.command
zsh -n Stop-Literary-Atlas.command

ATLAS_HELP=$(bash scripts/start_local.sh --help)
[[ "$ATLAS_HELP" == *"--dry-run"* ]] || { echo "help output is incomplete" >&2; exit 1; }
[[ "$ATLAS_HELP" == *"--no-open"* ]] || { echo "help output is incomplete" >&2; exit 1; }

ATLAS_DRY_OUTPUT=$(bash scripts/start_local.sh --dry-run --no-open)
if [[ "$ATLAS_DRY_OUTPUT" == *"已在运行"* ]]; then
  # 服务正在运行时，dry-run 走幂等分支，只验证提示与网址。
  [[ "$ATLAS_DRY_OUTPUT" == *"localhost:5173"* ]] || { echo "idempotent branch missed web URL" >&2; exit 1; }
else
  [[ "$ATLAS_DRY_OUTPUT" == *"1/4"* ]] || { echo "dry-run missed environment step" >&2; exit 1; }
  [[ "$ATLAS_DRY_OUTPUT" == *"2/4"* ]] || { echo "dry-run missed database/deps step" >&2; exit 1; }
  [[ "$ATLAS_DRY_OUTPUT" == *"3/4"* ]] || { echo "dry-run missed startup step" >&2; exit 1; }
  [[ "$ATLAS_DRY_OUTPUT" == *"db:bootstrap"* ]] || { echo "dry-run missed db bootstrap" >&2; exit 1; }
  [[ "$ATLAS_DRY_OUTPUT" == *"localhost:5173"* ]] || { echo "dry-run missed web URL" >&2; exit 1; }
fi
[[ ! -f .env ]] || [[ -s .env ]]

printf 'One-click command syntax, help and dry-run: PASS\n'
