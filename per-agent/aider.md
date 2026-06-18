# Aider conventions — Chirag Singhal

> **Canonical rules:** see [`~/AGENTS.md`](file://~/AGENTS.md) (or [github.com/chirag127/agents-md](https://github.com/chirag127/agents-md)).
> Edit only the canonical file; this stub is generated and overwritten on every sync.

## Aider-specific quirks

- **`.aider.conf.yml`** must point Aider at this file via `read: [~/CONVENTIONS.md]` — Aider doesn't auto-load anything else by name.
- **Edit format:** Aider does whole-file diffs by default; for big files use `--edit-format=udiff` to save tokens.
- **Free-LLM hookup:** point Aider at `chirag127/freellmapi` or `chirag127/OmniRoute` rather than paying OpenAI/Anthropic directly.
