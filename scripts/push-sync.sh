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

if ! git push; then
  cat <<'EOF'

Push failed. This machine probably does not have command-line GitHub credentials yet.

Configure GitHub HTTPS credentials or switch the remote to SSH after adding an SSH key,
then rerun this script.
EOF
  exit 1
fi
