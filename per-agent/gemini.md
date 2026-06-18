# Gemini CLI rules — Chirag Singhal

> **Read [`~/AGENTS.md`](file://~/AGENTS.md) first** — that file holds the shared rules across every coding agent. This file adds Gemini CLI-specific rules on top: model defaults, known bugs and workarounds, edit-mode preferences, and the skills / MCP servers installed for this agent.

## Model defaults — which models to use

- **Reasoning / planning / multi-file refactors:** `gemini-2.5-pro`. Use for any task where I'd otherwise reach for Claude Opus or GPT-5.
- **Cheap iteration / quick edits / chat:** `gemini-2.5-flash`. The default for one-shot edits, file scaffolds, and "just answer the question" turns.
- **Sub-agent / batch fan-out:** `gemini-2.5-flash-lite` when running many parallel calls (translation, classification, summarization).
- **Do NOT use** the deprecated `gemini-1.5-pro`, `gemini-1.5-flash`, or `gemini-2.0-*` IDs — they're either retired or noticeably worse than 2.5 at the same price point. If you see them in a config file, propose updating to 2.5.
- **Free tier first.** AI Studio personal API keys (`GEMINI_API_KEY`) cover most of my usage; do not switch to Vertex AI / paid billing without explicit authorization.
- Prefer `--model gemini-2.5-pro` on the CLI rather than relying on whatever default the binary ships with — defaults drift between releases.

## Known bugs / quirks / workarounds

- **Tool-call JSON shape differs from Claude/Codex.** Gemini uses `functionCall` / `functionResponse` parts inside `contents[]`, not the Anthropic `tool_use` / `tool_result` block shape and not the OpenAI `tool_calls` array. When porting an MCP server or a prompt across agents, do not assume the schema is identical — translate explicitly.
- **No native parallel tool-calls in older client versions.** If `gemini` CLI is below the version that supports parallel function calls, sequence them manually rather than batching.
- **Windows + Git Bash path handling.** Gemini CLI sometimes mishandles `C:\...` paths in tool args; pass POSIX-style `/c/...` or forward-slash absolute paths when calling shell tools.
- **ASR blocks unsigned npm postinstalls.** Same Defender Exploit Guard issue as the other agents — if a global install fails silently mid-postinstall, run from an admin shell with the install dir temporarily ASR-excluded, then revert.
- **Context window is large but not free.** 1M-token context is real, but latency and cost both scale; prune aggressively rather than dumping whole repos.
- **`GEMINI.md` is the rules file** (not `AGENTS.md` and not `GEMINI.txt`). The CLI auto-loads it from `~/.gemini/GEMINI.md` and from a project-local `GEMINI.md` if present.

## Edit-mode and tool preferences

- Use Gemini CLI's built-in file edit / shell tools rather than asking me to paste diffs back. Prefer surgical edits over full-file rewrites.
- When running shell commands, assume Git Bash on Windows 11 — POSIX syntax, forward slashes, `$VAR` not `%VAR%`.
- Confirm before destructive shell ops (`rm -rf`, `git push --force`, anything that touches `chirag127/secrets`).
- Keep diffs small and commit per concern (Conventional Commits) — same as the global rule.
- For long-running tasks, prefer streaming responses; for structured output, request JSON mode explicitly rather than parsing prose.

## Skills + MCP servers

- **skill-agents-md-sync** — fan-out script that regenerates `~/.gemini/GEMINI.md` from `C:\D\agents-md`. Run via `node ~/src/skill-agents-md-sync/scripts/sync-agents.mjs` or `npx skills run chirag127/skill-agents-md-sync` after editing the canonical `AGENTS.md`.
- **MCP servers:** Gemini CLI supports MCP via its `mcpServers` config block in `~/.gemini/settings.json`. Install per server with the standard `npx -y @modelcontextprotocol/server-<name>` invocation; mirror whatever's in the Claude Code MCP config when reasonable so the two agents see the same tools.
- **No MCP server should require a paid API key by default** — free-first policy applies here too.

## Where this file lives

Canonical source: `C:\D\agents-md\per-agent\gemini.md`. Synced to `~/.gemini/GEMINI.md` by skill-agents-md-sync — do not hand-edit the synced copy; edit the source here and re-run the sync.
