"""Convert README.md to a styled index.html for the GitHub Pages info site."""
import markdown2
import pathlib
import textwrap

md = pathlib.Path("README.md").read_text(encoding="utf-8")
body = markdown2.markdown(
    md,
    extras=["fenced-code-blocks", "tables", "header-ids", "strike"],
)
title = md.splitlines()[0].lstrip("# ").strip()

html = textwrap.dedent(f"""\
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{title}</title>
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.5.1/github-markdown-light.min.css">
<style>
  body {{ max-width: 860px; margin: 40px auto; padding: 0 20px; }}
  .repo-links {{ margin-bottom: 1.5rem; display: flex; gap: 0.75rem; flex-wrap: wrap; }}
  .repo-links a {{ text-decoration: none; color: #0969da; }}
  .repo-links a:hover {{ text-decoration: underline; }}
</style>
</head>
<body class="markdown-body">
<div class="repo-links">
  <a href="https://github.com/chirag127/agents-md">&#128279; GitHub repo</a>
  <a href="https://github.com/chirag127/agents-md/blob/main/AGENTS.md">&#128196; AGENTS.md</a>
  <a href="https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md">&#128218; OKF spec</a>
</div>
{body}
</body>
</html>
""")

pathlib.Path("index.html").write_text(html, encoding="utf-8")
print("index.html written.")
