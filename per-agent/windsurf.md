# Windsurf rules — Chirag Singhal

> **Read [`~/AGENTS.md`](file://~/AGENTS.md) first** — that file holds the shared rules across every coding agent. This file adds Windsurf-specific rules on top: model defaults, known bugs and workarounds, edit-mode preferences, and the skills / MCP servers installed for this agent.

## Model defaults — which models to use

- **Default model:** SWE-1 (Codeium's in-house model) for routine edits — it's free for individual users and tuned for Cascade. Use it for boilerplate, refactors, and tab-completion.
- **Hard tasks / multi-file refactors:** switch the Cascade model picker to **Claude Sonnet 4.5** (`claude-sonnet-4-5`) when reasoning matters. Anthropic Opus models burn credits fast on Windsurf — avoid unless the task genuinely needs it.
- **Cheap / bulk edits:** **GPT-4.1 mini** or **Gemini 2.5 Flash** when available in the picker.
- **Tab autocomplete** is always SWE-1-lite (free, unlimited) — don't change this.
- Free-first per `~/AGENTS.md`: don't burn premium credits on tasks SWE-1 can finish.

## Known bugs / quirks / workarounds

- **Windows + Git Bash path mangling:** Cascade sometimes rewrites `/c/D/...` to `C:\D\...` mid-command and breaks pipes. Wrap multi-step shells in a single `bash -c '...'` invocation.
- **ASR-blocked postinstalls:** Defender Exploit Guard blocks unsigned native binaries from npm postinstall. If a Cascade-run `pnpm install` fails silently on `esbuild`, `better-sqlite3`, or similar, run the install in an external Git Bash terminal where the ASR exclusion already covers `C:\D`.
- **`.windsurfrules` size cap (~6 KB):** project rules truncate without warning. Keep project rules thin and link out to `AGENTS.md` rather than inlining.
- **Cascade context loss on long sessions:** the planner forgets earlier steps after ~30 turns. Drop a summary into the chat or restart Cascade rather than fighting it.
- **MCP server reload:** edits to `~/.codeium/windsurf/mcp_config.json` need a full Windsurf restart, not just "Refresh" in the MCP panel.
- **Memories panel drift:** auto-captured memories sometimes contradict `global_rules.md`. Review and prune the Memories panel monthly; `global_rules.md` is authoritative.

## Edit-mode and tool preferences

- **Cascade Write mode** is the default for any change that touches more than one file. Cascade Chat is fine for read-only Q&A.
- **Always show the plan** before Cascade applies multi-file edits — review the diff list, don't auto-accept. The "Auto-execute commands" toggle stays **off** for anything outside `pnpm test`, `pnpm lint`, `pytest`, `git status`, `git diff`.
- **Prefer Cascade workflows** (`.windsurf/workflows/*.md`) for repeatable multi-step recipes — sync, deploy, scaffold. One workflow per task, checked into the repo.
- **Rules directory form** (`.windsurf/rules/*.md`) is preferred over the single `.windsurfrules` file for new repos — it scales and supports `trigger: glob` scoping.
- **Match surrounding style, edit existing files first** (per `~/AGENTS.md`) — Cascade has a tendency to scatter new helper files; reject those diffs.
- **Conventional-commits commit messages** only; never let Cascade `git push` without explicit approval in the same turn.

## Skills + MCP servers

Windsurf's MCP support reads `~/.codeium/windsurf/mcp_config.json`. Keep this list minimal — each server adds startup latency.

- **GitHub MCP** (`@modelcontextprotocol/server-github`) — for issue/PR triage from Cascade. Token from `chirag127/secrets`.
- **Filesystem MCP** scoped to `C:\D` only — never the whole drive.
- **Context7 MCP** (`@upstash/context7-mcp`) — fresh library docs; pairs well with the free-first stack defaults.
- **Playwright MCP** (`@playwright/mcp`) — browser automation for the e2e profile defined in `~/AGENTS.md`.
- Personal skills installed via `bunx skills add chirag127/<name>`: `skill-agents-md-sync`, `skill-claude-code-mcq-notes`. The sync skill keeps this file in lockstep with the canonical source.

## Where this file lives

Canonical disk path: `C:\D\agents-md\per-agent\windsurf.md` → copied to `~/.codeium/windsurf/memories/global_rules.md` by [`skill-agents-md-sync`](https://github.com/chirag127/skill-agents-md-sync). Do not hand-edit the deployed copy — edit the source above and re-run the sync.
