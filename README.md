# agents-md

[![GitHub repo](https://img.shields.io/badge/GitHub-chirag127%2Fagents--md-181717?logo=github)](https://github.com/chirag127/agents-md)
[![Info site](https://img.shields.io/badge/Info%20site-GitHub%20Pages-0969da)](https://chirag127.github.io/agents-md/)
[![Public](https://img.shields.io/badge/visibility-public-brightgreen)](https://github.com/chirag127/agents-md)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](./LICENSE)

**Canonical `AGENTS.md` for [@chirag127](https://github.com/chirag127)** — the single source of truth for personal rules across every AI coding agent (Claude Code, Codex CLI, Gemini CLI, Cursor, Cline, Continue, Windsurf, Copilot, Aider, Junie, …).

## What this repo is for

Most AI coding agents read a per-tool instruction file: `~/.claude/CLAUDE.md` for Claude Code, `~/.codex/AGENTS.md` for Codex, `~/.cursor/rules/*.mdc` for Cursor, `.github/copilot-instructions.md` for Copilot, and so on. Maintaining ten copies of the same content by hand is a recipe for drift.

This repo solves that with a **stub-mode architecture**:

- **One canonical file** (`AGENTS.md` at the root of this repo) holds every rule that should apply across all my AI agents.
- **Ten per-agent stubs** (`per-agent/<name>.md`) are small files that point at the canonical file and add only that agent's specific quirks.
- The companion skill [`chirag127/skill-agents-md-sync`](https://github.com/chirag127/skill-agents-md-sync) reads this repo and writes each stub into the matching home-directory location every time `AGENTS.md` changes.

> 🆕 **Read this first if you're an AI agent entering this repo:** the canonical `AGENTS.md` is **part of the system prompt** for every coding agent on the user's machines. Treat it as authoritative.

## Layout

```
agents-md/
├── AGENTS.md              ← THE canonical content; edit this
├── per-agent/             ← per-agent stubs (pointer + quirks each)
│   ├── claude.md          → ~/.claude/CLAUDE.md
│   ├── codex.md           → ~/.codex/AGENTS.md
│   ├── gemini.md          → ~/.gemini/GEMINI.md
│   ├── cursor.md          → ~/.cursor/rules/00-agents.mdc
│   ├── cline.md           → ~/.cline/global-rules.md
│   ├── windsurf.md        → ~/.codeium/windsurf/memories/global_rules.md
│   ├── continue.md        → ~/.continue/global-rules.md
│   ├── aider.md           → ~/CONVENTIONS.md
│   ├── junie.md           → ~/.junie/guidelines.md
│   ├── copilot.md         → <repo>/.github/copilot-instructions.md (project only)
│   ├── github-pages-workflow.md  ← reusable GH Pages workflow + CLI template
│   └── README.md          ← describes the per-agent stub contract
├── README.md              ← you are here
└── LICENSE
```

This is a **content-only repo**. No scripts, no submodules, no CI workflows — those live in the umbrella [`chirag127/setup`](https://github.com/chirag127/setup).

> **Standards referenced:** rules in `AGENTS.md` follow the
> [Open Knowledge Format (OKF) v0.1](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
> for durable knowledge bundles, and mandate a
> [GitHub Pages info site](https://chirag127.github.io/agents-md/) for every new repo.
> OKF was introduced by Google Cloud on [2026-06-13](https://cloud.google.com/blog/products/data-analytics/introducing-the-open-knowledge-format).

## Usage — for the user

```bash
# 1. Edit the canonical file (or any per-agent stub).
$EDITOR AGENTS.md
# or:  $EDITOR per-agent/claude.md

# 2. Fan changes out to every agent's home-dir file.
node /c/D/skill-agents-md-sync/scripts/sync-agents.mjs
# or via npx (no clone needed):
npx skills run chirag127/skill-agents-md-sync

# 3. Commit + push.
git add -A && git commit -m "feat(rules): <one-liner>"
git push
```

Idempotent. Every other machine picks up the change with `git pull && bash bootstrap.sh` from the umbrella.

## Usage — for an AI agent reading these rules

The canonical `AGENTS.md` itself contains the working contract: how to update rules (propose-then-confirm), how to handle git pushes, how to choose tech defaults (latest + free-first), and the list of known per-agent quirks. **Read it.** This README explains the system; `AGENTS.md` is the system.

## Adding a new agent

1. Create `per-agent/<name>.md` following the existing 6-line pattern (one-line pointer + 2-3 quirk bullets).
2. Add the target path to `globalTargets()` (and/or `projectTargets()`) in `chirag127/skill-agents-md-sync/scripts/sync-agents.mjs`.
3. Open a PR in this repo and a matching PR in `skill-agents-md-sync`.

## Sister repos

| Repo | What it does |
|---|---|
| [`chirag127/setup`](https://github.com/chirag127/setup) | Public umbrella. Vendors this repo as a submodule, runs the bootstrap. |
| [`chirag127/skill-agents-md-sync`](https://github.com/chirag127/skill-agents-md-sync) | The skill that reads this repo and writes the per-agent files. |
| [`chirag127/skill-claude-code-mcq-notes`](https://github.com/chirag127/skill-claude-code-mcq-notes) | Skill capturing Claude Code AskUserQuestion bugs (referenced from `per-agent/claude.md`). |
| [`chirag127/secrets`](https://github.com/chirag127/secrets) | Private; API keys / `.env` files only. Never referenced from this repo's content. |

## License

MIT for the structure and per-agent stubs. The personal preferences inside `AGENTS.md` are not generally applicable; copy the structure, not the preferences.
