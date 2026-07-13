#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

message="${1:-Update Codex exports}"

git add -A README.md .gitignore codex scripts

if git diff --cached --quiet; then
  echo "No Codex export changes to commit."
else
  git commit -m "$message"
fi

git push
