# GitHub Copilot rules — Chirag Singhal

> **Canonical rules:** see [`~/AGENTS.md`](file://~/AGENTS.md) (or [github.com/chirag127/agents-md](https://github.com/chirag127/agents-md)).
> Edit only the canonical file; this stub is generated and overwritten on every sync.

## Copilot-specific quirks

- **`.github/copilot-instructions.md`** is the project-scope file; Copilot in VS Code / JetBrains reads it.
- **Per-path rules:** use `.github/instructions/*.instructions.md` with frontmatter `applyTo:` glob.
- **Code completion bias:** Copilot weighs proximity heavily — so the comment immediately above a function affects its completion. Use that.
