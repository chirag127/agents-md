# agents-md

Single source of truth for [@chirag127](https://github.com/chirag127)'s global rules
across every AI coding agent (Claude Code, Codex, Gemini, Cursor, Cline, etc.).

The canonical file is **[`AGENTS.md`](./AGENTS.md)**. Every per-agent instruction
file (`CLAUDE.md`, `GEMINI.md`, `.codex/AGENTS.md`, `.cursor/rules/00-agents.mdc`, …)
is generated from it by the [`skill-agents-md-sync`][sync] skill, loaded on demand
via [`npx skills`][skills].

[sync]: https://github.com/chirag127/skill-agents-md-sync
[skills]: https://github.com/vercel-labs/skills

## What's in this repo

```
agents-md/
├── AGENTS.md             ← edit this, never the per-agent files
├── README.md             ← you are here
├── bootstrap/
│   ├── bootstrap.sh      ← new-laptop bootstrap (Linux/macOS/Git Bash)
│   └── bootstrap.ps1     ← new-laptop bootstrap (Windows PowerShell)
└── .github/
    └── workflows/
        └── periodic-sync.yml   ← hourly cron (placeholder; see notes)
```

## How it works

- **You edit:** `AGENTS.md` in this repo.
- **You run:** the sync skill (`npx skills run chirag127/skill-agents-md-sync`) on
  any machine where you want the local per-agent files refreshed.
- **You push:** `git push` to publish your changes to other machines.
- **Other machines pull** via `git pull` (or via the periodic GitHub Actions
  workflow — see "Sync model" below).

## New laptop / lost laptop recovery

```bash
gh repo clone chirag127/agents-md ~/src/agents-md
cd ~/src/agents-md
bash bootstrap/bootstrap.sh       # Linux / macOS / Git Bash on Windows
# Windows PowerShell users:
# pwsh bootstrap/bootstrap.ps1
```

The bootstrap script:

1. Verifies prerequisites (`git`, `node`, `npx`, `gh`).
2. Installs every skill listed in `AGENTS.md`'s "Skill repos" table via
   `npx skills add chirag127/<repo> -g -a '*'`.
3. Runs the `agents-md-sync` skill once to symlink (or copy, where symlinks aren't
   permitted) `AGENTS.md` into every detected agent's instruction-file path.
4. Verifies the result and prints a status summary.

Re-running it is safe (idempotent).

## Sync model

**Direction:** bidirectional, hourly. **Push side:** you commit + push from the
machine where you're editing. **Pull side:** the periodic-sync workflow in
`.github/workflows/periodic-sync.yml` runs hourly on cron (and is also runnable
via `workflow_dispatch`); it does nothing destructive — it just exists as a
heartbeat / hook point for future automation.

For per-machine auto-pull, the recommendation is **not** Windows Task Scheduler
(too fragile, surprise commits) — instead, the local sync skill checks the
remote on each invocation and pulls if needed. So syncing happens whenever you
start a Claude Code / Codex / Gemini session and the skill loads.

## License

MIT — but the *content* of `AGENTS.md` is personal preferences; copy the
structure, not my preferences.
