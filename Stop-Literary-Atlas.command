#!/bin/zsh
set -e
ATLAS_COMMAND_ROOT=${0:A:h}
exec /bin/bash "$ATLAS_COMMAND_ROOT/scripts/stop_local.sh" "$@"

