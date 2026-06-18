#!/usr/bin/env bash
# bootstrap.sh — new-laptop / fresh-clone setup for chirag127/agents-md
#
# Run after `gh repo clone chirag127/agents-md ~/src/agents-md`.
# Idempotent — safe to re-run.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS_MD="$REPO_ROOT/AGENTS.md"

echo "==> agents-md bootstrap starting in $REPO_ROOT"

# ---- 1. Prerequisites ------------------------------------------------------

need() {
  command -v "$1" >/dev/null 2>&1 || { echo "ERROR: '$1' not found on PATH" >&2; exit 1; }
}
need git
need node
need npx
need gh

# ---- 1b. Initialise submodules if cloned without --recurse-submodules ----

if [[ -f "$REPO_ROOT/.gitmodules" ]]; then
  echo "==> Ensuring submodules under vendor/ are populated"
  git -C "$REPO_ROOT" submodule update --init --recursive
fi

# ---- 2. Install referenced skills ------------------------------------------
#
# AGENTS.md has a markdown table whose rows look like:
#   | <name> | [chirag127/<repo>](https://github.com/chirag127/<repo>) | ... |
# We extract the chirag127/<repo> slugs and feed them to `npx skills add`.

SKILL_REPOS=$(grep -oE 'chirag127/skill-[a-z0-9-]+' "$AGENTS_MD" | sort -u || true)

if [[ -z "$SKILL_REPOS" ]]; then
  echo "==> No chirag127/skill-* repos referenced in AGENTS.md yet — skipping skill install"
else
  echo "==> Installing referenced skills via npx skills:"
  echo "$SKILL_REPOS" | sed 's/^/    - /'
  while IFS= read -r repo; do
    [[ -z "$repo" ]] && continue
    echo "    -> npx skills add $repo -g -a '*' -y"
    npx skills add "$repo" -g -a '*' -y || {
      echo "    !! skipping $repo (install failed; non-fatal)" >&2
    }
  done <<< "$SKILL_REPOS"
fi

# ---- 3. Fan AGENTS.md out to per-agent instruction files ------------------

if [[ -d "$HOME/.claude/skills/skill-agents-md-sync" ]] || \
   [[ -d "$HOME/.config/agents/skills/skill-agents-md-sync" ]]; then
  echo "==> Fanning AGENTS.md out via the sync skill"
  # The skill itself ships a runnable script — locate it and run it.
  SYNC_SCRIPT=$(find "$HOME"/.claude/skills/skill-agents-md-sync \
                       "$HOME"/.config/agents/skills/skill-agents-md-sync \
                       2>/dev/null -name 'sync-agents.mjs' -print -quit || true)
  if [[ -n "$SYNC_SCRIPT" ]]; then
    AGENTS_MD_PATH="$AGENTS_MD" node "$SYNC_SCRIPT" || true
  else
    echo "    !! sync-agents.mjs not found — skip" >&2
  fi
else
  echo "==> skill-agents-md-sync not installed locally — skipping fan-out"
fi

echo "==> agents-md bootstrap complete."
echo "    Edit $AGENTS_MD, commit, push to share across machines."
