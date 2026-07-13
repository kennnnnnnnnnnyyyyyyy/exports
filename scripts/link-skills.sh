#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_home="${CODEX_HOME:-"$HOME/.codex"}"
skills_src="$repo_root/codex/skills"
skills_dst="$codex_home/skills"
timestamp="$(date +%Y%m%d%H%M%S)"

backup_path() {
  local path="$1"
  if [ -e "$path" ] || [ -L "$path" ]; then
    local backup="${path}.backup.${timestamp}"
    mv "$path" "$backup"
    echo "Backed up $path -> $backup"
  fi
}

mkdir -p "$skills_src" "$skills_dst"

found=0
for skill_dir in "$skills_src"/*; do
  [ -d "$skill_dir" ] || continue
  [ -f "$skill_dir/SKILL.md" ] || continue

  found=1
  skill_name="$(basename "$skill_dir")"
  link="$skills_dst/$skill_name"

  if [ -L "$link" ]; then
    current="$(readlink "$link")"
    if [ "$current" = "$skill_dir" ]; then
      echo "Already linked skill: $link -> $skill_dir"
      continue
    fi
  fi

  backup_path "$link"
  ln -s "$skill_dir" "$link"
  echo "Linked skill: $link -> $skill_dir"
done

if [ "$found" -eq 0 ]; then
  echo "No personal skills found in $skills_src yet."
fi
