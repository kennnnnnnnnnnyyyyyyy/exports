# Codex Exports Sync

This private repository is the portable source of truth for Codex custom agents and personal skills.

Do not commit the whole `~/.codex` directory. It contains login state, logs, caches, SQLite databases, local app state, and machine-specific settings.

## Layout

```text
codex/
  agents/        # Custom Codex agents: one .toml file per agent
  skills/        # Personal skills: one folder per skill, each with SKILL.md
scripts/
  bootstrap-this-machine.sh
  link-skills.sh
  pull-sync.sh
  push-sync.sh
```

## First setup on a machine

```bash
git clone https://github.com/kennnnnnnnnnnyyyyyyy/exports.git ~/Documents/Codex/exports
bash ~/Documents/Codex/exports/scripts/bootstrap-this-machine.sh
```

The bootstrap script links:

- `~/.codex/agents` -> `codex/agents`
- each skill in `codex/skills/*/SKILL.md` -> `~/.codex/skills/<skill-name>`

It does not replace `~/.codex/config.toml`, `auth.json`, system skills, plugin caches, or any local database.

## Pull changes from another machine

```bash
bash ~/Documents/Codex/exports/scripts/pull-sync.sh
```

Restart Codex or start a new task after pulling new agents or skills.

## Push changes from this machine

```bash
bash ~/Documents/Codex/exports/scripts/push-sync.sh "Update Codex agents"
```

## Import existing setup from another machine

On the other machine, clone this repo, then copy portable files into it:

```bash
mkdir -p ~/Documents/Codex/exports/codex/agents
cp ~/.codex/agents/*.toml ~/Documents/Codex/exports/codex/agents/ 2>/dev/null || true
```

For personal skills, copy only your own skill folders that contain `SKILL.md`:

```bash
mkdir -p ~/Documents/Codex/exports/codex/skills
cp -R ~/.codex/skills/my-skill ~/Documents/Codex/exports/codex/skills/
```

Avoid copying `.system`, plugin caches, login files, SQLite files, or machine-specific config.
