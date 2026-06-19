# per-agent/

Per-agent rules for every coding agent in [@chirag127](https://github.com/chirag127)'s setup. Each file is a **substantive** 4-5 KB rules document (not a stub) covering:

- **Model defaults** — which models to use and when (defaults, hard-reasoning escalation, cheap/batch tier).
- **Known bugs / quirks / workarounds** — terminal rendering issues, sandbox quirks, format gotchas, OS-level blocks.
- **Edit-mode and tool preferences** — Composer vs Chat vs Inline, plan vs act, edit-format, surgical-vs-rewrite preferences.
- **Skills + MCP servers** — what's installed, install commands, where the config lives.

Each per-agent file starts with a pointer to `~/AGENTS.md` (the canonical shared rules) and adds **only** what's specific to that agent on top. Read `~/AGENTS.md` first; this directory is the agent-specific layer.

## Layout

| File here | Sync target | Format notes |
|---|---|---|
| `claude.md` | `~/.claude/CLAUDE.md` | plain markdown |
| `codex.md` | `~/.codex/AGENTS.md` | plain markdown |
| `gemini.md` | `~/.gemini/GEMINI.md` | plain markdown |
| `cursor.md` | `~/.cursor/rules/00-agents.mdc` | needs YAML frontmatter (`alwaysApply: true`) — already included |
| `cline.md` | `~/.cline/global-rules.md` | plain markdown |
| `windsurf.md` | `~/.codeium/windsurf/memories/global_rules.md` | plain markdown |
| `continue.md` | `~/.continue/global-rules.md` | plain markdown |
| `aider.md` | `~/CONVENTIONS.md` | plain markdown (referenced from `~/.aider.conf.yml` via `read:`) |
| `junie.md` | (project-only — `<repo>/.junie/guidelines.md`) | plain markdown |
| `copilot.md` | (project-only — `<repo>/.github/copilot-instructions.md`) | plain markdown |

The sync is performed by [`chirag127/skill-agents-md-sync`](https://github.com/chirag127/skill-agents-md-sync).

## Editing

**Edit the source files in this directory.** The synced copies in your home directory are overwritten on every sync (logon, every 30 min, every new terminal — see `chirag127/setup`). Hand-edits to `~/.claude/CLAUDE.md` etc. are lost.

When you change a per-agent file:

```bash
cd C:/D/agents-md
$EDITOR per-agent/<name>.md
git add -A && git commit -m "feat(<name>): <one-liner>"
git push
# Other machines pick it up via auto-sync (Scheduled Task pulls every 30 min).
```

## Adding a new agent

1. Create `per-agent/<name>.md` following the existing structure (heading + AGENTS.md pointer + 4 substantive sections + "Where this file lives").
2. Add the new target's path to `globalTargets()` (and/or `projectTargets()`) in [`chirag127/skill-agents-md-sync/scripts/sync-agents.mjs`](https://github.com/chirag127/skill-agents-md-sync/blob/main/scripts/sync-agents.mjs).
3. Open a PR (or push directly) to both repos.

## Why per-agent files are substantive (not stubs)

The earlier design had per-agent files as 6-line pointer stubs. That was deliberately reversed in favor of substantive per-agent files because:

- Each agent has its own model defaults, sandbox quirks, MCP config locations, and tool-call schema. Forcing those into one shared `AGENTS.md` made it noisy and unhelpful.
- Per-agent files are now first-class working documents — useful even if you never read `~/AGENTS.md`.
- The shared `AGENTS.md` got smaller and clearer (about-me, free-first, fork-minimal, self-update, README rules, generic tech defaults).

See `~/AGENTS.md` "Decisions log" for the full reasoning.
