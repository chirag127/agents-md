---
description: Cursor user-global rules (synced from ~/AGENTS.md)
alwaysApply: true
---

# Cursor rules — Chirag Singhal

> **Canonical rules:** see [`~/AGENTS.md`](file://~/AGENTS.md) (or [github.com/chirag127/agents-md](https://github.com/chirag127/agents-md)).
> Edit only the canonical file; this stub is generated and overwritten on every sync.

## Cursor-specific quirks

- **`.cursor/rules/*.mdc` format:** requires the YAML frontmatter above (`alwaysApply: true`) to be globally applied. Per-path rules use `globs:` instead.
- **Legacy `.cursorrules`:** still honoured but deprecated; the `.cursor/rules/` directory is the modern path.
- **AGENTS.md fallback:** Cursor reads `AGENTS.md` natively as a fallback when no `.cursor/rules/` is present, so this file is belt-and-braces.
