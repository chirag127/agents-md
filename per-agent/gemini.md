# Gemini CLI rules — Chirag Singhal

> **Canonical rules:** see [`~/AGENTS.md`](file://~/AGENTS.md) (or [github.com/chirag127/agents-md](https://github.com/chirag127/agents-md)).
> Edit only the canonical file; this stub is generated and overwritten on every sync.

## Gemini CLI-specific quirks

- **Default model:** Gemini 2.5 Pro for reasoning, Flash for cheap iteration. Don't use deprecated 1.5/2.0 IDs.
- **Free tier:** Generous on AI Studio (free for personal use). Prefer it over paid Vertex unless I've explicitly authorised.
- **Tool calling:** Gemini's tool-call schema differs from Claude/Codex — when porting prompts, don't assume identical JSON shapes.
