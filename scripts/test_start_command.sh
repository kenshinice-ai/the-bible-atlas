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

ATLAS_DRY_OUTPUT=$(bash scripts/start_local.sh --dry-run --no-open)
[[ "$ATLAS_DRY_OUTPUT" == *"1/3"* ]] || { echo "dry-run missed environment step" >&2; exit 1; }
[[ "$ATLAS_DRY_OUTPUT" == *"2/3"* ]] || { echo "dry-run missed startup step" >&2; exit 1; }
[[ "$ATLAS_DRY_OUTPUT" == *"DOCKER_BUILDKIT=0"* ]] || { echo "dry-run missed Unicode path build compatibility" >&2; exit 1; }
[[ "$ATLAS_DRY_OUTPUT" == *"http://localhost:8080"* ]] || { echo "dry-run missed access URL" >&2; exit 1; }
[[ ! -f .env ]] || [[ -s .env ]]

printf 'One-click command syntax, help and dry-run: PASS\n'
