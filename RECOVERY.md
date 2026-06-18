# RECOVERY — read this first if you're on a new/lost laptop

This is the **single repository** to remember. Bookmark it:

> **https://github.com/chirag127/agents-md**

It is the umbrella for everything personal-development-related: AI agent rules,
all my custom skills (as git submodules), and the bootstrap that puts them onto
a fresh machine. Lose anything else — this repo brings it back.

---

## The four commands

After a fresh OS install, install the prerequisites manually (see below), then:

```bash
gh auth login
gh repo clone chirag127/agents-md ~/src/agents-md -- --recurse-submodules
cd ~/src/agents-md
bash bootstrap/bootstrap.sh        # or: pwsh bootstrap/bootstrap.ps1
```

That's it. The bootstrap does the rest.

## Prerequisites (≈2 min, manual)

- **Git** — https://git-scm.com/download/win
- **Node.js LTS** — https://nodejs.org
- **GitHub CLI** — https://cli.github.com
- **Claude Code** — https://code.claude.com (and/or Codex CLI, Gemini CLI, Cursor)

## What gets restored

| Lost item | Restored by |
|---|---|
| `~/AGENTS.md` (cross-agent rules) | this repo's `AGENTS.md` |
| `~/.claude/CLAUDE.md` and other per-agent files | the `agents-md-sync` skill (submodule), run by `bootstrap.sh` |
| Every personal skill I've published | submodules under `vendor/`, plus `npx skills add` calls in the bootstrap |
| MCQ-bug workarounds for Claude Code | the `claude-code-mcq-notes` skill (submodule) |
| Git config preferences | (not yet — see "Future" below) |

## What does NOT get restored — by design

- **Local secrets / API keys.** They live in `.env.local` (gitignored) per project,
  or in a password manager. Never in this public repo.
- **OS-level installs** (Node, gh, Claude Code). Listed above; install once.
- **Local files outside `~/src/agents-md`.** This is config sync, not a backup.
  For full-machine snapshots see "Future".

## Future additions (placeholder — none of these exist yet)

These would each become their own repo + submodule under `vendor/` once built:

- `chirag127/dotfiles` — `.bashrc`, `.gitconfig`, terminal preferences.
- `chirag127/skill-bootstrap-new-laptop` — interactive script that walks through
  prereq install (winget commands, browser sign-ins, etc.).
- Full-machine backup → free options: OneDrive (5 GB), Backblaze B2 + Restic (10 GB).
  Out of scope for this repo by design.

## Adding a new skill repo to the umbrella

When I publish a new skill at `chirag127/skill-<name>`:

```bash
cd ~/src/agents-md
git submodule add https://github.com/chirag127/skill-<name> vendor/skill-<name>
# Then add a row to the AGENTS.md "Skill repos" table.
git add -A && git commit -m "feat: vendor skill-<name>" && git push
```

The bootstrap reads the AGENTS.md table to decide which skills to `npx skills add`,
so adding the row is the actual wiring step. The submodule is the **archival copy**
that survives even if a skill repo gets renamed or deleted upstream.

## How the umbrella stays in sync

- **Submodules pin specific commits.** `git submodule update --remote --merge` from
  inside `agents-md` advances each submodule to its upstream `main`. Run this when
  you want the umbrella to reflect the latest versions.
- **Submodules are not auto-advanced.** The pinned commits are deterministic — the
  umbrella restores the exact versions it was last committed with, not whatever's
  on `main` today. That's intentional: you want recovery to be reproducible.
- The hourly GitHub Actions cron in `.github/workflows/periodic-sync.yml` is a
  heartbeat hook — does not currently auto-bump submodules. Flag if you want it to.
