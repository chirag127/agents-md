# Global rules for AI coding agents — Chirag Singhal

This file is the **single source of truth** for cross-agent rules on this machine.
Edit it, commit, push. Everything else (per-agent CLAUDE.md, GEMINI.md, .codex/AGENTS.md,
.cursor/rules/*.mdc, etc.) is generated from it by the [`skill-agents-md-sync`][sync]
skill, which is loaded on demand via the [`npx skills`][skills-cli] CLI.

This is the **hybrid** architecture: this file stays small. Anything bulky
(MCQ-bug notes, Awesome-CV résumé scaffolding, new-laptop bootstrap, etc.) lives
as its own skill repo and is loaded only when relevant — keeping the session
system-prompt context lean.

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
see `.github/workflows/` and `bootstrap/` in the repo.

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
- **No paid services unless I've said so.** Free-tier first.
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

## Known agent-tool quirks I want you to remember

- **Claude Code AskUserQuestion (MCQ) widget is buggy with multiple questions on Windows
  terminals.** The full investigation, citations, and workarounds live in the
  [`skill-claude-code-mcq-notes`][mcq] skill — load it when you're about to use
  `AskUserQuestion`. Quick rule until that skill loads: **ask one question per call**, never
  batch 2+ questions in a single `AskUserQuestion` payload. See open upstream issue
  [`anthropics/claude-code#19637`][cc-19637] (Windows TUI rendering regression since v2.1.3,
  still open as of 2026-06).
- **`AskUserQuestion` overlay can hide context.** Don't put decision-critical context in the
  assistant text immediately before the call — the picker overlays it (issues
  [#62493][cc-62493], [#67426][cc-67426], [#68082][cc-68082]).

[mcq]: https://github.com/chirag127/skill-claude-code-mcq-notes
[cc-19637]: https://github.com/anthropics/claude-code/issues/19637
[cc-62493]: https://github.com/anthropics/claude-code/issues/62493
[cc-67426]: https://github.com/anthropics/claude-code/issues/67426
[cc-68082]: https://github.com/anthropics/claude-code/issues/68082

---

## Skill repos that extend these rules (load on demand)

These are **my personal skills**, one repo per skill (intentionally — easier to install,
update, and reuse individually). Install via `npx skills add chirag127/<repo-name> -g -a '*'`.

| Skill | Repo | What it covers |
|---|---|---|
| `agents-md-sync` | [chirag127/skill-agents-md-sync](https://github.com/chirag127/skill-agents-md-sync) | Fan-out from this AGENTS.md to per-agent files (CLAUDE.md, GEMINI.md, .codex/AGENTS.md, .cursor/rules, etc.). |
| `claude-code-mcq-notes` | [chirag127/skill-claude-code-mcq-notes](https://github.com/chirag127/skill-claude-code-mcq-notes) | Claude Code `AskUserQuestion` rendering bugs and workarounds — full citations. |

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

- *(none yet — added as projects come online)*

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
