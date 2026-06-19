# GitHub Copilot rules — Chirag Singhal

> **Read [`~/AGENTS.md`](file://~/AGENTS.md) first** — that file holds the shared rules across every coding agent. This file adds Copilot-specific rules on top: model defaults, known bugs and workarounds, edit-mode preferences, and the skills / MCP servers installed for this agent.

## Model defaults — which models to use

- **Completions (inline ghost text):** the proprietary Copilot completion model — not user-selectable. Keep it on; do not pay for a heavier model just for completions, the latency penalty is not worth it.
- **Copilot Chat / Edits / Agent mode:** prefer **Claude Sonnet 4.5** for code edits and refactors, **GPT-5** for ad-hoc reasoning and planning, **Claude Opus 4.5** only for hard multi-file design work where the per-message premium-request cost is justified.
- **Free tier first.** Stick to the included models and the monthly premium-request quota. If a task wants Opus, do one focused turn — do not loop with Opus on autopilot.
- **No model fallback to GPT-3.5 / older Claude.** If a model is unavailable, stop and ask, do not silently downgrade.

## Known bugs / quirks / workarounds

- **Project-scope only.** No global `~/.github/copilot-instructions.md` — every repo needs its own `.github/copilot-instructions.md`. The 6-line stub committed by `skill-agents-md-sync` points at `~/AGENTS.md`; do not inline the canonical rules into the repo file.
- **Per-path rules** live in `.github/instructions/*.instructions.md` with YAML frontmatter `applyTo: "<glob>"`. One file per path-pattern; Copilot merges them with the root file.
- **Completion bias is proximity-weighted.** The comment immediately above a function, and the file's top-of-file docstring, dominate suggestions. Keep them accurate — stale top-comments produce stale completions.
- **Chat context window is small** vs. Claude Code / Cursor. Open the exact files you want considered; do not rely on workspace-wide retrieval to find the right file.
- **`#codebase` / `@workspace` retrieval is fuzzy** and often misses the right symbol. Prefer `#file:` and `#selection:` references over `@workspace` for surgical edits.
- **Windows + ASR:** Copilot itself runs in-process in VS Code, so the Defender ASR rule blocking unsigned npm postinstall binaries does not bite Copilot directly — but any `npm install` Copilot proposes still does. Prefer `pnpm` and pre-built binaries.
- **Public-code filter:** keep "Suggestions matching public code" set to **Block** in settings — avoids accidental GPL paste-through.

## Edit-mode and tool preferences

- **Default mode: Ask / Edits**, not **Agent**. Agent mode burns premium requests fast and tends to over-edit; use it only for explicit multi-file refactors where a plan is already agreed.
- **Inline completions on**, but accept with `Tab` deliberately — do not auto-accept on whitespace.
- **Edits mode** for any change spanning more than ~10 lines, so the diff is reviewable before apply.
- **Terminal Chat** (`Ctrl+I` in terminal) is fine for one-shot bash one-liners; do not let it run destructive commands without confirmation — same hard-to-reverse-action rule as in `~/AGENTS.md`.
- **Conventional commits** when Copilot drafts commit messages — review the generated message, do not blind-accept.

## Skills + MCP servers

Copilot in VS Code supports MCP servers via `.vscode/mcp.json` (workspace) or user `mcp.json`. Keep the set minimal — every server adds context-window pressure.

- **GitHub MCP** (built-in via Copilot) — issues, PRs, repo search. Already wired.
- **Context7** — `npx -y @upstash/context7-mcp` — up-to-date library docs, avoids hallucinated APIs.
- **Playwright MCP** — `npx -y @playwright/mcp@latest` — browser automation, only enable per-workspace when needed.
- No global "skills" system like Claude Code; reusable rules go in `.github/instructions/*.instructions.md` per repo, or in `chirag127/setup` for cross-repo snippets. The full 36-skill global inventory is in `per-agent/claude.md`.
- **OKF knowledge bundles:** per `~/AGENTS.md`, durable repo knowledge (schemas, runbooks, metrics, decisions) is captured as `knowledge/` OKF v0.1 bundles. Reference `#file:knowledge/index.md` in Copilot Chat to pull in context before architecture or refactor tasks.

## Where this file lives

Canonical source: `C:\D\agents-md\per-agent\copilot.md`. Synced to each repo's `.github/copilot-instructions.md` (as a 6-line stub) by `skill-agents-md-sync`. Do not hand-edit the per-repo copy — edit the source here and re-run the sync.
