#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_home="${CODEX_HOME:-"$HOME/.codex"}"
timestamp="$(date +%Y%m%d%H%M%S)"

backup_path() {
  local path="$1"
  if [ -e "$path" ] || [ -L "$path" ]; then
    local backup="${path}.backup.${timestamp}"
    mv "$path" "$backup"
    echo "Backed up $path -> $backup"
  fi
}

link_path() {
  local target="$1"
  local link="$2"

  mkdir -p "$(dirname "$link")"

  if [ -L "$link" ]; then
    local current
    current="$(readlink "$link")"
    if [ "$current" = "$target" ]; then
      echo "Already linked: $link -> $target"
      return
    fi
  fi

  backup_path "$link"
  ln -s "$target" "$link"
  echo "Linked: $link -> $target"
}

mkdir -p "$codex_home"
mkdir -p "$repo_root/codex/agents" "$repo_root/codex/skills"

link_path "$repo_root/codex/agents" "$codex_home/agents"

"$repo_root/scripts/link-skills.sh"

cat <<EOF

Codex sync is ready on this machine.

Repository: $repo_root
Codex home: $codex_home

Notes:
- Custom agents are synced through $repo_root/codex/agents.
- Personal skills are synced through $repo_root/codex/skills and linked individually.
- config.toml, auth.json, caches, logs, databases, and system skills stay local.
- Restart Codex or start a new task after adding agents or skills.
EOF
