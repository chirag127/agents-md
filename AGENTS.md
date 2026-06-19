# Global rules for AI coding agents — Chirag Singhal

This file is the **single source of truth for SHARED rules** across every coding agent on every machine I use. Edit it, commit, push.

> **Architecture:** AGENTS.md (this file) holds shared truths. Each per-agent file (`~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.cursor/rules/00-agents.mdc`, `~/.gemini/GEMINI.md`, `~/.cline/global-rules.md`, etc.) starts with "Read `~/AGENTS.md` first" and adds **agent-specific** rules on top: model defaults for that agent, known bugs and workarounds, edit-mode preferences, and the skills / MCP servers installed for it.
>
> Sources of all per-agent files: `chirag127/agents-md/per-agent/<name>.md`. The skill [`chirag127/skill-agents-md-sync`](https://github.com/chirag127/skill-agents-md-sync) writes them to their canonical home-dir paths.

[skill-sync]: https://github.com/chirag127/skill-agents-md-sync

---

## How you (the agent) update these rules — the self-improving rule

When the user expresses a preference, decision, correction, or constraint that is likely to
apply across **future sessions** (not just this turn), you should:

1. **Propose** a one-line addition to the appropriate file:
   - Global preference → propose appending to `~/AGENTS.md` (this file's checked-in copy).
   - Project-specific preference → propose appending to `<repo>/AGENTS.md`.
2. **Show** the exact line you'd write, with the section heading you'd put it under.
3. **Wait for confirmation** before writing. A "yes", "ok", "do it", or similar from the
   user is sufficient — don't ask again later in the session.
4. **Write** the line, run the sync (`node ~/src/skill-agents-md-sync/scripts/sync-agents.mjs`
   or via `npx skills run chirag127/skill-agents-md-sync`), and commit with a one-line
   conventional-commits message. **Do NOT push without separate authorisation.**

Do this proactively. If the user says "I always prefer X" or "never do Y" or "from now on
do Z", that's a rule worth pinning. Cosmetic preferences ("use this name for this var") are
not — only rules that span sessions.

A short bias toward writing: when in doubt, propose. The user can decline. Better to surface
than silently forget.

---

## Project context — always read the README first

When you enter a repo (or are asked about one) and don't already have context for it:

1. **Read `<repo>/README.md` first.** Every chirag127 repo's README explains what it does,
   how it fits into the wider system, and how to use it. If the README is missing or stale,
   say so — don't guess from the directory tree.
2. **Then read `<repo>/AGENTS.md`** for project-specific rules (it usually has a short
   "Project shortcuts" section).
3. **Then look at structure** — `package.json`, `pyproject.toml`, top-level dirs.
4. **Only then start coding.** No prior step is skippable.

Repos in this system that follow this contract: every public repo under
[`chirag127/*`](https://github.com/chirag127), especially:

- [`chirag127/setup`](https://github.com/chirag127/setup) — umbrella + bootstrap
- [`chirag127/agents-md`](https://github.com/chirag127/agents-md) — canonical AGENTS.md (this repo)
- [`chirag127/skill-agents-md-sync`](https://github.com/chirag127/skill-agents-md-sync) — fan-out skill
- [`chirag127/skill-claude-code-mcq-notes`](https://github.com/chirag127/skill-claude-code-mcq-notes) — MCQ-bug notes skill

## Always update the README

When you change a repo's behavior, structure, public API, install steps, or anything else
that contradicts what its `README.md` currently claims, **update the README in the same
commit as the change**. Stale READMEs are a bug. Specifically:

- New file in the repo's "What's in this repo" tree → update the tree.
- New flag / mode / command → update the usage section.
- Renamed file / removed feature → search for and rewrite every mention.
- New cross-repo dependency → update the "Sister repos" / "Modules" table.

When you propose to add or change a rule via the self-update rule above, include the
README update in the same proposal. Treat the README as part of the public contract,
not as documentation that lives separately.

---

## Persistent knowledge — Open Knowledge Format (OKF)

When a repo accumulates **durable, reusable knowledge** that an agent (or a future me)
will need to consult repeatedly — schemas, table/column definitions, runbooks, incident
playbooks, metric definitions, glossaries, join-path notes, deprecation notices, API
contracts, architecture decisions — capture it as a bundle of OKF-conformant markdown
files. This is the lingua franca for context that lives alongside code, introduced by
Google Cloud (Sam McVeety & Amir Hormati, 2026-06-13) and intentionally vendor-neutral.

**Where the bundle lives:** `<repo>/knowledge/` (default), or whatever the repo's
existing convention already is (`docs/`, `wiki/`, etc.) — don't fight existing layout.

**Shape of the bundle** (per OKF v0.1):

- **One concept per file.** A concept is anything you'd want to look up later: one
  table, one metric, one runbook, one API. The file path *is* the concept's identity.
- **Markdown body + YAML frontmatter.** The frontmatter carries the small set of
  structured fields agents query on; the body is freeform markdown.
- **Frontmatter fields** (per the v0.1 spec, only `type` is universally required;
  include the others when meaningful):
  - `type` — required. e.g. `BigQuery Table`, `Runbook`, `Metric`, `API`, `Decision`.
  - `title` — human-readable name.
  - `description` — one-line summary.
  - `resource` — canonical URL the concept refers to (console link, API endpoint, etc.).
  - `tags` — array of free-form tags.
  - `timestamp` — ISO-8601, last meaningful update.
- **Reserved filenames:** `index.md` (overview / progressive disclosure for a
  directory), `log.md` (chronological history of changes for a concept).
- **Cross-links are normal markdown links** to other concept files
  (`[customers](/tables/customers.md)`) — that turns the bundle into a graph.

**Example:**

```
knowledge/
├── index.md
├── tables/
│   ├── index.md
│   └── orders.md         # frontmatter: type, title, description, resource, tags, timestamp
└── runbooks/
    ├── index.md
    └── deploy-rollback.md
```

**This rule does NOT override "don't write report/summary `.md` files":** ephemeral
findings (one-off review summaries, ad-hoc analyses, "what does this do" answers)
still go inline in the chat. OKF is for the long-lived, queryable knowledge layer.
The test: *will I or another agent want to look this up again next week?* If yes →
OKF concept file. If no → inline.

**Consume opportunistically, produce when justified:** when entering a repo, check
`knowledge/` (or equivalent) before re-deriving facts. When a piece of durable
knowledge surfaces during work and isn't yet captured, propose a new concept file
under the self-update rule (same flow as adding a rule to AGENTS.md).

**Spec reference:**
- Spec: [`GoogleCloudPlatform/knowledge-catalog — okf/SPEC.md`](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
- Blog: [*Introducing the Open Knowledge Format* — Google Cloud, 2026-06-13](https://cloud.google.com/blog/products/data-analytics/introducing-the-open-knowledge-format)
- The reference enrichment agent, static HTML visualizer, and sample bundles (GA4 e-commerce, Stack Overflow, Bitcoin) are in the same repo under `okf/`.

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
- **Don't commit secrets.** Use `.env.example` + GitHub Actions Secrets + `.env.local` (gitignored).
  Real secrets live in [`chirag127/secrets`](https://github.com/chirag127/secrets) (private repo).
- **No `console.log` left in code.** Lint clean.
- **Conventional commits**, small commits, one concern per commit.
- **Don't run `git push` or open PRs without my say-so.**
- **Apply SOLID, DRY, and the rest of the standard software-engineering principles** without
  needing reminders — but don't over-engineer; match the scale of the change.
- **Ask multiple questions in one batch** via `AskUserQuestion` when possible (max 4 per call).
  Don't drip-feed single questions across turns when they could be batched.
- **Forks: keep the diff minimal.** When working in a fork of an upstream repo (anywhere with
  an `upstream` git remote, or a repo whose origin is `chirag127/<name>` while a sibling
  upstream exists), do NOT add new top-level files, restructure layout, or modify
  upstream-tracked files unless the change is itself the contribution being prepared for an
  upstream PR. Anything ancillary you'd want to add — personal skills, recommendations, custom
  scripts, project notes — belongs in a sibling repo or in [`chirag127/setup`](https://github.com/chirag127/setup),
  not in the fork. The test: `git pull upstream main` should never produce a merge conflict.
  When unsure whether a change qualifies as ancillary, propose moving it to a sibling repo
  before writing.
- **Every new repository gets a GitHub Pages info site — always separate from the repo's own
  content.** Even if the repo itself is a website or web app, it still needs a separate info
  site about the project. The two must never be conflated:
  - **Repo's own site** — whatever the project ships (app, library docs, tool UI).
  - **Info site** — a lightweight project page that explains what the repo is, how to use it,
    and links to both the GitHub repo and the live site (if any). This is the one this rule mandates.

  **Setup (do this for every new repo):**
  1. **Branch:** dedicated `gh-pages` branch (not `docs/` on `main`).
  2. **Content:** commit `.github/workflows/pages.yml` — a GH Actions workflow that converts
     `README.md` → styled `index.html` (via `markdown2` + `github-markdown-css`) on every
     push to `main`. No manual HTML authoring required.
  3. **Enable Pages:** run the `gh api` one-liner to set source to `gh-pages` branch root:
     ```bash
     gh api repos/{owner}/{repo}/pages --method POST \
       -f 'source[branch]=gh-pages' -f 'source[path]=/' 2>/dev/null || \
     gh api repos/{owner}/{repo}/pages --method PUT \
       -f 'source[branch]=gh-pages' -f 'source[path]=/'
     gh repo edit {owner}/{repo} --homepage "https://{owner}.github.io/{repo}/"
     ```
  4. **README links:** every new repo's `README.md` must include **both** a GitHub-repo badge
     and an info-site badge near the top. The info-site rendered page must itself link back to
     the GitHub repo URL and to the project's own website (if one exists separately).

  Full workflow YAML, `gh api` commands, badge templates, and a setup checklist:
  → **`per-agent/github-pages-workflow.md`** in this repo.

  **OKF spec + project links** (add to every repo that references OKF):
  - Spec: [`GoogleCloudPlatform/knowledge-catalog — okf/SPEC.md`](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
  - Blog: [*Introducing the Open Knowledge Format* (2026-06-13)](https://cloud.google.com/blog/products/data-analytics/introducing-the-open-knowledge-format)

  **Forks are exempt** — do not add Pages to a fork unless the change is being upstreamed.

---

## Tech defaults — latest, widely-recognised, free-first

When you're choosing tech for a new project or recommending a stack, default to the
**latest stable release** of each option below, and the **free tier** of every hosted
service. Surface alternatives only when there's a specific reason this default doesn't fit.

### Languages & runtimes
- **TypeScript** for any non-trivial JS work; plain JS only for one-file scripts.
- **Python 3.13+** with type hints for everything beyond a one-shot script.
- **Node.js LTS** (currently 24.x); never bleed-edge unstable.

### Tooling
- **Package manager:** `pnpm` (TS/JS, preferred) → `npm` (only when a tool requires it).
- **Python deps:** `uv` for everything — installs, virtual envs, `pyproject.toml` management.
- **Test runner:** `vitest` (TS/JS) → `pytest` (Python).
- **Lint/format:** `biome` (TS/JS, replaces ESLint+Prettier) → `ruff` (Python).
- **E2E:** Playwright with `chromium-desktop`, `chromium-mobile (Pixel 5)`, `webkit-mobile (iPhone 13)`.
- **Editors:** Claude Code (primary), Codex CLI, Gemini CLI, Cursor (occasional).

### Frontend
- **Framework:** Astro for content/marketing/blog → React 19 + Vite for app SPAs →
  Next.js only when SSR/RSC is genuinely needed.
- **CSS:** Tailwind CSS v4 (utility-first); shadcn/ui for component primitives.
- **State:** TanStack Query for server state; Zustand for client state. Avoid Redux.

### Backend / hosting (free-tier first, in priority order)
- **Static + edge functions:** Cloudflare Pages + Cloudflare Workers (free, 100k req/day).
- **Auth + DB:** Firebase Spark (free tier — Auth, Firestore, Storage).
- **SQL DB:** Supabase free tier → Turso free tier (libSQL/SQLite at the edge).
- **KV / cache:** Upstash Redis free tier.
- **Queues / background:** Cloudflare Queues (free) → Inngest free tier.
- **Object storage:** Cloudflare R2 free tier (10 GB) → Backblaze B2 (10 GB free).
- **Domain / DNS:** Cloudflare Registrar (at-cost) or free `.dev` / `.app` via GitHub Student Pack.
- **CI/CD:** GitHub Actions free minutes only — no paid runners.

### LLM / AI
- **Free LLM aggregator first:** chirag127/freellmapi or chirag127/OmniRoute. Only fall back to paid keys when the free tiers are exhausted for that turn. Each per-agent file (`per-agent/<name>.md`) names the specific default model and pricing-tier preference for that agent.

### Free-first policy (stronger form)
- Always check for free alternatives **before** recommending anything paid: free tiers,
  free open-source equivalents, GitHub Student Developer Pack benefits, MS / Google / AWS
  Educate, university SSO discounts, "free for individuals / OSS" plans.
- If only a paid option exists for what I asked, **say so up front**, propose the cheapest
  free workaround, and only quote prices after I confirm I'd consider paying.
- **Never silently introduce a paid dependency.**

### "Latest" enforcement
- Don't blindly trust your training data for version numbers, prices, or model IDs —
  **look them up** before recommending. The [`claude-api`](https://docs.anthropic.com)
  skill / docs are authoritative for Anthropic; npm / PyPI for everything else.
- When pinning, pin to the latest stable minor at time of writing, not whatever your
  training cutoff knew about.

---

## Known agent-tool quirks I want you to remember

Per-agent quirks (rendering bugs, sandbox issues, format requirements) live in each agent's own file under [`per-agent/`](./per-agent/) — not here. This section is intentionally short.

- **Defender Exploit Guard ASR** on this Windows machine blocks unsigned native exes downloaded by npm postinstall (rule `01443614-CD74-433A-B99E-2ECDC07BFC25`). `agent-browser` is permanently broken here for this reason. Use `playwright-cli` (signed binaries) or `use-my-browser` for browser automation. This is OS-policy, applies to every agent.

---

## Skill repos that extend these rules (load on demand)

These are **my personal skills**, one repo per skill (intentionally — easier to install,
update, and reuse individually). Install via `npx skills add chirag127/<repo-name> -g -a '*'`.

| Skill | Repo | What it covers |
|---|---|---|
| `agents-md-sync` | [`chirag127/skill-agents-md-sync`](https://github.com/chirag127/skill-agents-md-sync) | Stub-mode fan-out from this AGENTS.md to per-agent files. |
| `claude-code-mcq-notes` | [`chirag127/skill-claude-code-mcq-notes`](https://github.com/chirag127/skill-claude-code-mcq-notes) | Claude Code AskUserQuestion rendering bugs and workarounds. |

When I add a skill, **propose** appending a row to this table per the self-update rule above.

---

## Project shortcuts

(One-line escape hatches for specific repos — prefer `<repo>/AGENTS.md` for anything bigger.)

- **`chirag127/oriz`** — all-in-one site (finance tools, dev tools, blogs, utilities) at
  [oriz.in](https://oriz.in). Built for Google AdSense approval. See `<repo>/AGENTS.md`.
- **`chirag127/setup`** — public umbrella holding submodules + bootstrap; clone with
  `--recurse-submodules`. See `<repo>/README.md`.

---

## New-laptop / lost-laptop recovery

> 🆘 **One repo to remember:** [`github.com/chirag127/setup`](https://github.com/chirag127/setup)

That repo is the umbrella. Clone it, run `bootstrap.sh` (or `bootstrap.ps1`), it pulls every
submodule including this one, restores npm/winget/uv packages from `manifests/`, installs
each personal skill, and fans `AGENTS.md` out to every per-agent file.

---

## Decisions log

Pinned cross-session decisions (auto-grow this list per the self-update rule):

- **Architecture:** hybrid — small `AGENTS.md` + per-agent stubs (pointer + quirks, not copies).
- **Repos:** all personal repos under `chirag127`, public by default, one repo per concern.
  Private repo `chirag127/secrets` for API keys / `.env` files only.
- **Disk layout:** every chirag127 repo cloned flat at `C:\D\<repo>` AND vendored as a
  submodule under `C:\D\setup\vendor\<repo>` for the umbrella to use.
- **No symlinks for instruction files.** Per-agent files are tiny stubs, not copies, so the
  symlink-vs-copy debate is moot — every per-agent file's content is small and agent-specific.
- **Free hosting only.** Cloudflare Pages, GitHub Pages, Firebase Spark unless explicitly told otherwise.
- **AskUserQuestion: batch ≤4 questions per call. No more drip-feed.**
- **Forks must stay thin.** Personal additions go to sibling repos or `chirag127/setup`, never into a fork's working tree. Goal: zero merge conflicts on `git pull upstream main`. (Decided 2026-06-19 after I bloated `C:\D\skills` with a sync skill, recommendations, and bootstrap files that all belonged in `chirag127/agents-md` and `chirag127/setup`.)
- **AGENTS.md = shared rules only.** Per-agent rules (model defaults, known bugs, edit-mode prefs, skills/MCP inventory) live in `per-agent/<name>.md` — substantive 4-5 KB files, not stubs. Each per-agent file starts with "Read `~/AGENTS.md` first" then adds its own rules on top. (Decided 2026-06-19; reversed the earlier "AGENTS.md holds everything, per-agent files are tiny pointers" design.)
- **Open Knowledge Format (OKF) for durable knowledge.** When a repo grows knowledge worth re-consulting (schemas, runbooks, metrics, decisions), capture it as an OKF v0.1 bundle: one concept per markdown file with YAML frontmatter (`type` required; `title`/`description`/`resource`/`tags`/`timestamp` when meaningful), `index.md`/`log.md` reserved, cross-linked via normal markdown links. Ephemeral findings still go inline — OKF is for the queryable, long-lived layer. (Decided 2026-06-19, after Google Cloud's OKF v0.1 announcement on the same date; format is vendor-neutral and intended as a lingua franca across agents and catalogs.)
- **Every new repo gets a GitHub Pages info site — always separate.** Dedicated `gh-pages` branch (not `docs/` on `main`). Minimum: a GH Actions workflow that converts `README.md` → styled `index.html` on every push to `main` (markdown2 + github-markdown-css). Pages enabled via `gh api`. URL linked in About + README badge. Even if the repo itself is a website, the info site is separate. Forks exempt. (Decided 2026-06-19.)
