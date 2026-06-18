# Global rules for AI coding agents — Chirag Singhal

This file is the **single source of truth** for cross-agent rules on this machine.
Edit it, commit, push. Everything else (per-agent CLAUDE.md, GEMINI.md, .codex/AGENTS.md,
.cursor/rules/*.mdc, etc.) is generated from it by the [`skill-agents-md-sync`][sync]
skill, which is loaded on demand via the [`npx skills`][skills-cli] CLI.

This is the **hybrid** architecture: this file stays small. Anything bulky
(résumé scaffolding, new-laptop bootstrap, etc.) lives as its own skill repo and is
loaded only when relevant — keeping the session system-prompt context lean.

[sync]: https://github.com/chirag127/skill-agents-md-sync
[skills-cli]: https://github.com/vercel-labs/skills

---

## How to change a rule

Edit this file (or `<repo>/AGENTS.md` for a project-specific rule). Then either:

```bash
# Re-fan the global file out to every per-agent path:
npx skills run chirag127/skill-agents-md-sync

# Or, the manual fallback (no skill needed):
node ~/src/skill-agents-md-sync/scripts/sync-agents.mjs
```

A scheduled job pulls/pushes this repo on a schedule for cross-machine sync —
see the umbrella repo [`chirag127/setup`](https://github.com/chirag127/setup) for the
bootstrap scripts and CI workflows; this repo is content-only.

**Never hand-edit** any of the per-agent files (`CLAUDE.md`, `GEMINI.md`,
`.codex/AGENTS.md`, `.cursor/rules/*.mdc`, `.windsurfrules`, `.clinerules`,
`.continuerules`, `.junie/guidelines.md`, etc.) — the next sync overwrites them.

---

## About me

- **Name:** Chirag Singhal
- **GitHub:** [`chirag127`](https://github.com/chirag127)
- **Email:** `whyiswhen@gmail.com`
- **Location:** Bhubaneswar, Odisha, India
- **Role:** Software Engineer — full-stack, backend, distributed systems, AI agents.
- **Languages I work in (most→least):** Python, TypeScript / JavaScript, SQL, HTML / CSS.
- **OS:** Windows 11 (Git Bash via Claude Code).
- **Shell:** `bash` (Git Bash), not cmd / PowerShell — assume POSIX syntax in commands.

---

## How I want you to work

- **Match the surrounding code's style** — comment density, naming, idioms. Don't mix patterns.
- **Prefer editing existing files over creating new ones.** Don't scatter files when one would do.
- **Confirm before hard-to-reverse actions** — `git push --force`, `rm -rf`, deletes from cloud
  storage, sending data to external services, creating public GitHub repos — unless I've
  explicitly authorised that class of action in this turn.
- **Report failures plainly.** "Tests pass except X, Y" beats "✅ done" when X and Y are broken.
- **When you don't know, look it up.** Don't guess at API shapes, library versions, or pricing.
- **Strict TypeScript.** No `any` without a comment + TODO to remove it.
- **Free first, always.** I want everything free or free-tier — never paid, very rarely paid, and only when I've explicitly said so in the current turn. **Always check for free alternatives** before recommending anything that costs money: free tiers (Cloudflare, Firebase Spark, Vercel Hobby, Supabase free, Turso free, Upstash free, GitHub free, Render free), free open-source equivalents, **GitHub Student Developer Pack** benefits, **Microsoft / Google / AWS Educate** programs, university SSO discounts, and other "free for students / individuals / OSS" plans. If only a paid option exists for what I asked, **say so up front** and propose the cheapest free workaround before quoting prices. Never silently introduce a paid dependency.
- **Don't commit secrets.** Use `.env.example` + GitHub Actions Secrets + `.env.local` (gitignored).
- **No `console.log` left in code.** Lint clean.
- **Conventional commits**, small commits, one concern per commit.
- **Don't run `git push` or open PRs without my say-so.**
- **Apply SOLID, DRY, and the rest of the standard software-engineering principles** without
  needing reminders — but don't over-engineer; match the scale of the change.

---

## Tools and conventions

- **Package manager:** `pnpm` (preferred); `npm` only when a tool requires it; `uv` for Python.
- **Test runner:** `vitest` (TS/JS); `pytest` (Python).
- **Lint/format:** `biome` (TS/JS); `ruff` (Python).
- **E2E:** Playwright with `chromium-desktop`, `chromium-mobile (Pixel 5)`, `webkit-mobile (iPhone 13)`.
- **Editors I use:** Claude Code (primary), Codex CLI, Gemini CLI, Cursor (occasional).
- **Cloud / hosting baseline:** Cloudflare Pages + Cloudflare Workers + Firebase (Auth, Firestore)
  + Supabase + Turso + Upstash Redis. All free-tier unless I've said so.

---

## Skill repos that extend these rules (load on demand)

These are **my personal skills**, one repo per skill (intentionally — easier to install,
update, and reuse individually). Install via `npx skills add chirag127/<repo-name> -g -a '*'`.

| Skill | Repo | What it covers |
|---|---|---|
| `agents-md-sync` | [chirag127/skill-agents-md-sync](https://github.com/chirag127/skill-agents-md-sync) — also vendored at [`vendor/skill-agents-md-sync`](https://github.com/chirag127/agents-md/tree/main/vendor/skill-agents-md-sync) | Fan-out from this AGENTS.md to per-agent files (CLAUDE.md, GEMINI.md, .codex/AGENTS.md, .cursor/rules, etc.). |

When I add a skill, I'll add a row here. Bootstrap a fresh laptop with:

```bash
gh repo clone chirag127/agents-md ~/src/agents-md
cd ~/src/agents-md
bash bootstrap/bootstrap.sh        # Linux/macOS/Git Bash
# or
pwsh bootstrap/bootstrap.ps1       # Windows PowerShell
```

That script reads the table above, runs `npx skills add` for each repo, then symlinks
this `AGENTS.md` into every detected agent's instruction-file path.

---

## Project shortcuts

(One-line escape hatches for specific repos — prefer `<repo>/AGENTS.md` for anything bigger.)

- **`chirag127/oriz`** — all-in-one site (finance tools, dev tools, blogs, utilities) at
  [oriz.in](https://oriz.in). Built for Google AdSense approval. See `<repo>/AGENTS.md`.

---

## Windows Developer Mode (one-time)

The `agents-md-sync` skill prefers symlinks over copies (single source of truth, edits
to `~/AGENTS.md` reflect everywhere instantly). On Windows this needs **Developer Mode**.

To enable (one-time, no reboot needed):

```powershell
# Run as Administrator:
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
```

Or via UI: `Settings → System → For developers → Developer Mode → On`.

After enabling, re-run the sync to convert copies to symlinks:

```bash
node ~/src/skill-agents-md-sync/scripts/sync-agents.mjs
```

If Developer Mode is off, the sync still works — it falls back to file copies. Symlinks
are the optimisation, not a requirement.

---

## New-laptop / lost-laptop recovery

> 🆘 **One repo to remember:** [`github.com/chirag127/agents-md`](https://github.com/chirag127/agents-md)
>
> See [`RECOVERY.md`](https://github.com/chirag127/agents-md/blob/main/RECOVERY.md) for the panic-button instructions.

That repo is the **umbrella**: it pins every personal skill repo as a git submodule
under `vendor/`, so a single clone with `--recurse-submodules` brings down the entire
configuration (this AGENTS.md + every skill + the bootstrap). The flow:

```bash
# 1. Install prereqs manually (~2 min)
#    - Git for Windows  (includes Git Bash)   https://git-scm.com/download/win
#    - Node.js LTS                            https://nodejs.org
#    - GitHub CLI                             https://cli.github.com
#    - Claude Code                            https://code.claude.com

# 2. Sign in to GitHub
gh auth login

# 3. Clone (recursively!) and run the bootstrap
gh repo clone chirag127/agents-md ~/src/agents-md -- --recurse-submodules
cd ~/src/agents-md
bash bootstrap/bootstrap.sh        # Linux / macOS / Git Bash on Windows
# pwsh bootstrap/bootstrap.ps1     # Windows PowerShell alternative
```

The `--recurse-submodules` flag is critical — without it, `vendor/` shows up empty
and the bootstrap has nothing to fall back on if `npx skills add` ever fails for
network reasons.

The bootstrap reads the **Skill repos** table below, runs `npx skills add chirag127/<repo>`
for each row, then fans this `AGENTS.md` out to every detected agent's instruction file.
Idempotent — safe to re-run.

**What deliberately doesn't sync** (and why):

- Local secrets / API keys → those go in `.env.local` (gitignored) or GitHub Actions Secrets,
  never in a public repo.
- OS-level installations → covered by the prereqs step above.
- Per-machine `npx skills` state → recreated by the bootstrap.

**Full-machine snapshot is out of scope** for `agents-md`. If I ever want it, the free
options are OneDrive (5 GB, Windows-native) or Backblaze B2 + Restic (10 GB free tier).
Flag explicitly and I'll add a separate skill repo for it.

---

## Decisions log (this session)

These came up in conversations and are worth keeping pinned:

- **Architecture:** hybrid — tiny `AGENTS.md` + per-skill repos, install via `npx skills`.
- **Repos:** all under `chirag127`, public, one repo per skill.
- **Sync direction:** bidirectional — pull then push, hourly. Implementation: GitHub Actions
  cron in this repo (pull side) + manual `git push` from the active machine (push side).
  No Windows Task Scheduler entry — too fragile, too easy to spawn surprise commits.
- **Linking:** symlinks where the OS allows (Git Bash + Developer Mode on Windows); plain
  file copies otherwise. `npx skills` handles this automatically.
- **Free hosting only.** Cloudflare Pages, GitHub Pages, Firebase Spark.
