# bootstrap.ps1 — new-laptop / fresh-clone setup for chirag127/agents-md
#
# Run from a clone of chirag127/agents-md after `gh repo clone`.
# Idempotent — safe to re-run.

$ErrorActionPreference = 'Stop'

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$AgentsMd = Join-Path $RepoRoot 'AGENTS.md'

Write-Host "==> agents-md bootstrap starting in $RepoRoot"

# ---- 1. Prerequisites -----------------------------------------------------
foreach ($cmd in 'git', 'node', 'npx', 'gh') {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Error "'$cmd' not found on PATH"
        exit 1
    }
}

# ---- 1b. Initialise submodules if cloned without --recurse-submodules ----
if (Test-Path (Join-Path $RepoRoot '.gitmodules')) {
    Write-Host "==> Ensuring submodules under vendor/ are populated"
    git -C $RepoRoot submodule update --init --recursive
}

# ---- 2. Install referenced skills -----------------------------------------
$skillRepos = Select-String -Path $AgentsMd -Pattern 'chirag127/skill-[a-z0-9-]+' `
    -AllMatches |
    ForEach-Object { $_.Matches.Value } |
    Sort-Object -Unique

if (-not $skillRepos) {
    Write-Host "==> No chirag127/skill-* repos referenced in AGENTS.md yet — skipping skill install"
} else {
    Write-Host "==> Installing referenced skills via npx skills:"
    $skillRepos | ForEach-Object { Write-Host "    - $_" }
    foreach ($repo in $skillRepos) {
        Write-Host "    -> npx skills add $repo -g -a '*' -y"
        try { npx skills add $repo -g -a '*' -y }
        catch { Write-Warning "skipping $repo (install failed; non-fatal)" }
    }
}

# ---- 3. Fan AGENTS.md out to per-agent instruction files ------------------
$candidate = Join-Path $env:USERPROFILE '.claude\skills\skill-agents-md-sync'
if (Test-Path $candidate) {
    $syncScript = Get-ChildItem -Path $candidate -Recurse -Filter 'sync-agents.mjs' `
        -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($syncScript) {
        Write-Host "==> Fanning AGENTS.md out via the sync skill"
        $env:AGENTS_MD_PATH = $AgentsMd
        node $syncScript.FullName
    } else {
        Write-Warning "sync-agents.mjs not found — skip"
    }
} else {
    Write-Host "==> skill-agents-md-sync not installed locally — skipping fan-out"
}

Write-Host "==> agents-md bootstrap complete."
Write-Host "    Edit $AgentsMd, commit, push to share across machines."
