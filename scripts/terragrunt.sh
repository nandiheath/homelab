#!/bin/bash
set -euo pipefail

## Wrapper for terragrunt
## Make sure you setup your AWS profile before running the script

usage() {
  cat <<EOM
Usage: $(basename "$0") [module|all] [actions]

EOM
  exit 1
}

[ "$#" -lt 2 ] && { usage; }

# find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;

module=$1

working_dir="./infrastructure/homelab"
args=("")

if [[ $module != "all" ]]; then
  working_dir+="/$module"
else
  args+=("run-all")
fi

set -x
./bin/terragrunt ${args[@]} ${@:2} --terragrunt-working-dir "$working_dir"

