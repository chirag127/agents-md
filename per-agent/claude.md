# Claude Code rules — Chirag Singhal

> **Read [`~/AGENTS.md`](file://~/AGENTS.md) first** — that file holds the shared rules across every coding agent. This file adds Claude Code-specific rules on top: model defaults, known bugs and workarounds, edit-mode preferences, and the skills / MCP servers installed for this agent.

## Model defaults — which models to use

- **Default routing:** Sonnet 4.6 (`claude-sonnet-4-6`) for routine edits, refactors, README writing, and most repo work. It's the right cost/quality point for ~90% of what I do.
- **Hard reasoning:** switch to Opus 4.8 (`claude-opus-4-8`) via `/model opus` for: multi-file architectural changes, debugging non-obvious failures, security reviews, anything where a wrong answer wastes >15 min. Also use Opus when the task crosses 3+ unfamiliar files.
- **Cheap / batch:** Haiku 4.5 (`claude-haiku-4-5-20251001`) via `/fast` for: trivial edits, file renames, mechanical search-and-replace, log triage, "what does this file do" reads. Don't use Haiku for code generation in TypeScript with strict types — it skips edge cases.
- **Effort knob:** `/effort high` before running `deep-research`, `code-review`, `security-review`, or any verify-then-fix loop. `/effort low` is fine for stub generation and copy-paste tasks.
- **Never** answer Anthropic-API or model-pricing questions from memory — invoke the `claude-api` skill first.

## Known bugs / quirks / workarounds

- **AskUserQuestion (MCQ) widget** renders imperfectly on Windows Git Bash TUIs when option labels are long or the assistant text immediately before the call carries decision-critical context (the picker overlays it). Keep ≤4 questions per call (SDK-enforced), short option labels, and put the question stem inside the widget — not in the prose above. Full notes and reproductions: [`chirag127/skill-claude-code-mcq-notes`](https://github.com/chirag127/skill-claude-code-mcq-notes).
- **AskUserQuestion options must be ranked.** Option 1 = Recommended (suffix `(Recommended)`); Option 2 = second-best fallback (suffix `(2nd choice)`); Options 3-4 = other viable shapes. Never ship four equally-weighted options. If you can't pick a recommendation, you're not ready to ask — research first. (Mirrors the global rule in `~/AGENTS.md`; restated here so per-agent reviewers see it.)
- **AskUserQuestion: learn from the answers.** Especially when the user picks the 2nd choice or overrides the Recommended option — propose the underlying *taste* as a candidate rule in the same turn. Their override patterns over time = a higher-resolution preference profile than any explicit rule. (Mirrors `~/AGENTS.md`.)
- **Defender Exploit Guard ASR** on this machine blocks unsigned native exes downloaded by npm postinstall. `agent-browser` and similar Chromium-bundling packages fail to install with a silent EPERM. Workaround: use the `playwright-cli` skill (Playwright's binaries are signed) or the `use-my-browser` skill to drive my live browser session.
- **CWD resets between Bash calls in subagent threads** — always pass absolute paths to bash commands; never rely on a previous `cd`.
- **Compound `cd && ...` commands** can trigger an extra permission prompt in this harness — prefer absolute paths over `cd` chains.
- **`grep`/`rg`/`cat`/`head`/`sed` via Bash** are slower and noisier than the dedicated Grep/Read tools — reach for those first.

## Edit-mode and tool preferences

- **Edit > Write.** Prefer `Edit` for surgical changes; only `Write` when creating a new file or fully replacing one I've already Read. This matches the AGENTS.md "edit existing files over creating new ones" rule.
- **Read before Edit, always** — the harness enforces this, but also it prevents stale-match failures.
- **Batch independent tool calls** in one assistant turn (parallel function calls) — don't serialise reads.
- **TaskCreate** for any task with 3+ steps; mark `in_progress` before starting and `completed` only when actually done (no partial credit).
- **Don't write report/summary `.md` files** as a deliverable — return findings inline. Only write markdown when the user asked for a checked-in doc.
- **Conventional commits, no push without say-so** (per AGENTS.md). Use `gh` for GitHub ops, not the web UI.

## Skills + MCP servers

Skills live in `~/.claude/skills/` (user-global) and `<repo>/.claude/skills/` (project-scoped). Install via:

```bash
npx skills add chirag127/skill-<name> -g -a claude-code
```

All globally installed skills are wired to Claude Code and live in `~/.claude/skills/`. Full inventory (36 skills):

| Skill | Purpose |
|---|---|
| `article-extractor` | Extract clean article content from URLs |
| `develop-userscripts` | Build and manage userscripts |
| `firebase-ai-logic-basics` | Firebase AI Logic / Gemini API integration |
| `firebase-app-hosting-basics` | Firebase App Hosting setup |
| `firebase-auth-basics` | Firebase Authentication |
| `firebase-basics` | Core Firebase setup |
| `firebase-crashlytics` | Crashlytics integration |
| `firebase-data-connect` | Firebase Data Connect |
| `firebase-firestore` | Firestore queries + security rules |
| `firebase-hosting-basics` | Firebase Hosting deploys |
| `firebase-remote-config-basics` | Remote Config |
| `firebase-security-rules-auditor` | Audit Firestore/Storage rules |
| `frontend-design` | UI/UX component design patterns |
| `github-actions-docs` | GitHub Actions reference |
| `karpathy-guidelines` | Andrej Karpathy's agent/LLM wiki guidelines |
| `learn-this` | Deep-learn any topic |
| `openclaw-secure-linux-cloud` | Secure Linux cloud setup |
| `opensource-guide-coach` | Open-source contribution guidance |
| `playwright-cli` | Browser automation via Playwright (signed binaries — use over agent-browser on this machine) |
| `readme-i18n` | Translate README to multiple languages |
| `running-claude-code-via-litellm-copilot` | Run Claude Code through LiteLLM/Copilot proxy |
| `scrum-sage` | Scrum/agile facilitation |
| `secure-linux-web-hosting` | Secure Linux web server setup |
| `session-log` | Log session summaries |
| `ship-learn-next` | Ship + learn Next.js projects |
| `skills-cli` | Manage the skills CLI itself |
| `smithery-ai-cli` | Smithery AI CLI usage |
| `tzst` | Timezone + scheduling helper |
| `unblock-action` | Unblock stuck GitHub Actions |
| `use-my-browser` | Drive the user's live browser session (for auth-walled / localhost pages) |
| `web-design-reviewer` | Review web design for UX/accessibility |
| `webapp-testing` | Full web app testing workflows |
| `xcode-project-setup` | Xcode project scaffolding |
| `xdrop` | File drop / transfer utility |
| `xget` | Fast file fetch utility |
| `youtube-transcript` | Extract YouTube transcripts |

Additional skills installed from `chirag127/*` (invoked via `/skill-name` or the Skill tool): `agents-md-sync`, `claude-code-mcq-notes`, `code-review`, `security-review`, `verify`, `simplify`, `deep-research`, `update-config`, `fewer-permission-prompts`, `claude-api`, `run`, `loop`, `init`, `review`, `security-review`, `keybindings-help`.

Project-scoped skills get added inside the repo via `npx skills add <source> -a claude-code` without `-g`.

**OKF knowledge bundles:** when a repo grows durable knowledge worth re-consulting (schemas, runbooks, metric definitions, architecture decisions), capture it as `knowledge/` OKF bundle per the `~/AGENTS.md` rule. Check `knowledge/` before re-deriving facts; propose new concept files under the self-update rule when useful knowledge surfaces.

MCP servers are configured in `~/.claude.json` (and per-project `.mcp.json`). Sync the toolbox via `mcp__toolbox__*` — don't hand-edit the JSON if a CLI command exists. When a tool I need isn't in the flat list, call `mcp__toolbox__search_toolbox` before assuming it's missing.

## Where this file lives

- **Source of truth:** `C:\D\agents-md\per-agent\claude.md` (this file).
- **Deployed copy:** `~/.claude/CLAUDE.md` — generated by [`skill-agents-md-sync`](https://github.com/chirag127/skill-agents-md-sync). **Do not hand-edit the deployed copy**; edit the source above and re-run the sync.
