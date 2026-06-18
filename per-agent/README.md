# per-agent/

Agent-specific stub files. Each is a 6-line stub that:

1. Points at the canonical `~/AGENTS.md` for full rules.
2. Lists agent-specific quirks (rendering bugs, format requirements, free-tier shortcuts).

The [`skill-agents-md-sync`](https://github.com/chirag127/skill-agents-md-sync) skill reads these stubs and copies each one into the matching home-directory location:

| File here | Copied to |
|---|---|
| `claude.md` | `~/.claude/CLAUDE.md` |
| `codex.md` | `~/.codex/AGENTS.md` |
| `gemini.md` | `~/.gemini/GEMINI.md` |
| `cursor.md` | `~/.cursor/rules/00-agents.mdc` |
| `cline.md` | `~/.cline/global-rules.md` |
| `copilot.md` | (project-only — see `.github/copilot-instructions.md` per repo) |
| `windsurf.md` | `~/.codeium/windsurf/memories/global_rules.md` |
| `continue.md` | `~/.continue/global-rules.md` |
| `aider.md` | `~/CONVENTIONS.md` (referenced from `~/.aider.conf.yml`) |
| `junie.md` | (project-only — see `.junie/guidelines.md` per repo) |

The full canonical AGENTS.md content lands at `~/AGENTS.md` only. Everything else is small and agent-specific.

## Adding a new agent

1. Create `<agent>.md` here following the existing 6-line pattern.
2. Add the target path to `FILE_TARGETS` in `chirag127/skill-agents-md-sync/scripts/sync-agents.mjs`.
3. Open a PR (or commit + push from your fork).
