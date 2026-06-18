# agents-md — single source of truth for everything

**The one repo to bookmark. Lose your laptop, clone this, run the bootstrap, you're back.**

> 🆘 **In a hurry / new laptop?** → [`RECOVERY.md`](./RECOVERY.md)

This repo is the umbrella for [@chirag127](https://github.com/chirag127)'s personal
AI-coding-agent setup. It holds:

1. The canonical [`AGENTS.md`](./AGENTS.md) — global rules every agent reads.
2. Every personal skill, vendored as a **git submodule** under [`vendor/`](./vendor/) —
   so a single `git clone --recurse-submodules` brings the whole world down.
3. The [`bootstrap/`](./bootstrap/) scripts that wire everything onto a fresh machine.

Per-agent instruction files (`CLAUDE.md`, `GEMINI.md`, `.codex/AGENTS.md`,
`.cursor/rules/00-agents.mdc`, …) are generated from `AGENTS.md` by the
[`skill-agents-md-sync`](./vendor/skill-agents-md-sync) skill, which is itself a
submodule of this repo.

CLI used to fan skills out across all agents:
[vercel-labs/skills](https://github.com/vercel-labs/skills) (`npx skills`).

## What's in this repo

```
agents-md/
├── AGENTS.md                ← edit this; never the per-agent files
├── RECOVERY.md              ← read this first on a fresh laptop
├── README.md                ← you are here
├── bootstrap/
│   ├── bootstrap.sh         ← Linux / macOS / Git Bash
│   └── bootstrap.ps1        ← Windows PowerShell
├── vendor/                  ← every personal skill, as submodules
│   ├── skill-agents-md-sync/
│   └── skill-claude-code-mcq-notes/
└── .github/workflows/
    └── periodic-sync.yml    ← hourly heartbeat (hook point)
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
gh auth login
gh repo clone chirag127/agents-md ~/src/agents-md -- --recurse-submodules
cd ~/src/agents-md
bash bootstrap/bootstrap.sh       # Linux / macOS / Git Bash on Windows
# Windows PowerShell users:
# pwsh bootstrap/bootstrap.ps1
```

The `--recurse-submodules` flag is what makes this **the single repo to remember** —
without it, `vendor/` shows up empty.

The bootstrap script:

1. Verifies prerequisites (`git`, `node`, `npx`, `gh`).
2. Initialises any submodules that are still empty (`git submodule update --init --recursive`).
3. Installs every skill listed in `AGENTS.md`'s "Skill repos" table via
   `npx skills add chirag127/<repo> -g -a '*'` — falls back to the local submodule
   under `vendor/<repo>` if the public install ever fails.
4. Runs the `agents-md-sync` skill once to symlink (or copy, where symlinks aren't
   permitted) `AGENTS.md` into every detected agent's instruction-file path.
5. Verifies the result and prints a status summary.

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
