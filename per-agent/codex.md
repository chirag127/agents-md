# Codex CLI rules — Chirag Singhal

> **Canonical rules:** see [`~/AGENTS.md`](file://~/AGENTS.md) (or [github.com/chirag127/agents-md](https://github.com/chirag127/agents-md)).
> Edit only the canonical file; this stub is generated and overwritten on every sync.

## Codex CLI-specific quirks

- **Reads `AGENTS.md` natively** (Codex was the original AGENTS.md driver). If `~/AGENTS.md` exists, Codex picks it up — this `~/.codex/AGENTS.md` is a small override layer on top.
- **Sandbox-by-default:** Codex CLI runs commands in a sandbox unless told otherwise. For Windows + Git Bash, allowlist `bash` and the typical dev tools in your Codex config to avoid friction.
- **Approval mode:** I run with explicit-approval for `git push` and `rm -rf` — see `~/AGENTS.md` "How I want you to work."
