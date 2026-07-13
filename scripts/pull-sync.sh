#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

git pull --ff-only
bash "$repo_root/scripts/bootstrap-this-machine.sh"
