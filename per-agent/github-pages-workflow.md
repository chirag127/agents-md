# GitHub Pages info-site reference

Full workflow template and CLI commands for the **GitHub Pages info-site** rule in `~/AGENTS.md`.

---

## What this file is

Every new `chirag127/*` repo gets a lightweight info site that is **always separate** from
the repo's own content (even if the repo itself is a website). This file holds the reusable
template so `AGENTS.md` stays concise.

---

## README requirements for every new repo

Every new repo's `README.md` must include **both** of these links near the top:

```markdown
[![GitHub repo](https://img.shields.io/badge/GitHub-chirag127%2F<repo>-181717?logo=github)](https://github.com/chirag127/<repo>)
[![Info site](https://img.shields.io/badge/Info%20site-GitHub%20Pages-0969da)](https://chirag127.github.io/<repo>/)
```

Replace `<repo>` with the actual repo name. The info-site badge links to the Pages URL
(`https://chirag127.github.io/<repo>/`). These two links are the minimum — add more as
needed (npm badge, license, CI status, etc.).

---

## GitHub Actions workflow

Commit as `.github/workflows/pages.yml` **and** `.github/scripts/readme_to_html.py` in the new repo.

**`.github/workflows/pages.yml`:**

```yaml
name: Deploy info site to GitHub Pages
on:
  push:
    branches: [main]
  workflow_dispatch:
permissions:
  contents: write
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Convert README to HTML
        run: |
          pip install markdown2 pygments
          python .github/scripts/readme_to_html.py
      - name: Deploy to gh-pages
        uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: .
          publish_branch: gh-pages
          exclude_assets: '.github,*.md,*.yml,*.yaml,*.toml,*.json,*.lock,src,tests'
```

**`.github/scripts/readme_to_html.py`** (replace `chirag127/REPO` with actual values):

```python
"""Convert README.md to a styled index.html for the GitHub Pages info site."""
import markdown2, pathlib, textwrap

REPO = "chirag127/REPO"  # e.g. "chirag127/agents-md"
PAGES_URL = f"https://chirag127.github.io/{REPO.split('/')[1]}/"

md   = pathlib.Path("README.md").read_text(encoding="utf-8")
body = markdown2.markdown(md, extras=["fenced-code-blocks","tables","header-ids","strike"])
title = md.splitlines()[0].lstrip("# ").strip()

html = textwrap.dedent(f"""\
<!doctype html><html lang="en"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>{title}</title>
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.5.1/github-markdown-light.min.css">
<style>
  body {{ max-width: 860px; margin: 40px auto; padding: 0 20px; }}
  .repo-links {{ margin-bottom: 1.5rem; display: flex; gap: 0.75rem; flex-wrap: wrap; }}
  .repo-links a {{ text-decoration: none; color: #0969da; }}
</style>
</head><body class="markdown-body">
<div class="repo-links">
  <a href="https://github.com/{REPO}">&#128279; GitHub repo</a>
  <a href="https://github.com/{REPO}/blob/main/README.md">&#128196; README source</a>
  <a href="{PAGES_URL}">&#127760; Info site</a>
</div>
{{body}}
</body></html>
""").replace("{body}", body)

pathlib.Path("index.html").write_text(html, encoding="utf-8")
print("index.html written.")
```

---

## Enable Pages via CLI

Run once after the first workflow push lands on `gh-pages`:

```bash
OWNER=chirag127
REPO=<repo-name>

# Try POST first (creates); fall back to PUT (updates)
gh api "repos/${OWNER}/${REPO}/pages" \
  --method POST \
  -f 'source[branch]=gh-pages' \
  -f 'source[path]=/' \
  2>/dev/null || \
gh api "repos/${OWNER}/${REPO}/pages" \
  --method PUT \
  -f 'source[branch]=gh-pages' \
  -f 'source[path]=/'

# Set the homepage in the repo About section
gh repo edit "${OWNER}/${REPO}" \
  --homepage "https://${OWNER}.github.io/${REPO}/"
```

---

## Checklist — new repo Pages setup

- [ ] `.github/workflows/pages.yml` committed (workflow above)
- [ ] First push triggered the workflow and `gh-pages` branch exists
- [ ] Pages enabled via `gh api` (POST or PUT)
- [ ] `gh repo edit --homepage` set to `https://chirag127.github.io/<repo>/`
- [ ] README has both badges: GitHub repo + info-site link
- [ ] Info-site URL confirmed live at `https://chirag127.github.io/<repo>/`
