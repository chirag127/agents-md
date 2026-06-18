# agents-md

Single source of truth for [@chirag127](https://github.com/chirag127)'s global rules
across every AI coding agent (Claude Code, Codex, Gemini, Cursor, Cline, etc.).

The canonical file is **[`AGENTS.md`](./AGENTS.md)**. Per-agent instruction files
(`CLAUDE.md`, `GEMINI.md`, `.codex/AGENTS.md`, `.cursor/rules/00-agents.mdc`, …) are
generated from it by the [`skill-agents-md-sync`][sync] skill, loaded on demand via
[`npx skills`][skills].

> 🆘 **For new-laptop / lost-laptop recovery, this is not the repo to clone.**
> Clone **[chirag127/setup](https://github.com/chirag127/setup)** instead — that
> repo is the umbrella that pulls this one (and every other personal repo) in
> as submodules and runs the full install + bootstrap.

[sync]: https://github.com/chirag127/skill-agents-md-sync
[skills]: https://github.com/vercel-labs/skills

## What's in this repo

```
agents-md/
├── AGENTS.md             ← edit this; never the per-agent files
├── README.md             ← you are here
└── LICENSE
```

This is a **content-only repo**: no scripts, no submodules, no workflows. The umbrella [`chirag127/setup`](https://github.com/chirag127/setup) vendors this repo as a submodule and runs all the install/sync logic from there.

## How it works

- **You edit:** `AGENTS.md` in this repo.
- **You run:** the sync skill (`npx skills run chirag127/skill-agents-md-sync`)
  on any machine where you want the local per-agent files refreshed.
- **You push:** `git push` to publish changes.
- **Other machines pull** via `git pull` (typically as part of the
  [`chirag127/setup`](https://github.com/chirag127/setup) umbrella's submodule update).

## License

MIT — but the *content* of `AGENTS.md` is personal preferences; copy the
structure, not my preferences.
