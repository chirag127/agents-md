# Claude Code rules — Chirag Singhal

> **Canonical rules:** see [`~/AGENTS.md`](file://~/AGENTS.md) (or [github.com/chirag127/agents-md](https://github.com/chirag127/agents-md)).
> Edit only the canonical file; this stub is generated and overwritten on every sync.

## Claude Code-specific quirks

- **AskUserQuestion (MCQ) widget:** can render imperfectly on Windows TUIs with long previews. Keep ≤4 questions per call (SDK-enforced), short option labels, no decision-critical context in the assistant text immediately before the call (the picker overlays it). Full notes: [`chirag127/skill-claude-code-mcq-notes`](https://github.com/chirag127/skill-claude-code-mcq-notes).
- **Defender Exploit Guard ASR** on this machine blocks unsigned native exes downloaded by npm postinstall — `agent-browser` is broken here. Use `@playwright/cli` for browser automation instead.
- **Skills location:** `~/.claude/skills/` (user) and `<repo>/.claude/skills/` (project). Install via `npx skills add chirag127/skill-<name> -g -a claude-code`.
