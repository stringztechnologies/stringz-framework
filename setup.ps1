Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  Stringz Workflow v2 — Level 5 Agent-First Engineering" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# ─── 1. Check prerequisites ──────────────────────────────

Write-Host "Checking prerequisites..." -ForegroundColor Yellow
Write-Host ""

$missing = 0

if (Get-Command "claude" -ErrorAction SilentlyContinue) {
    Write-Host "  ✅ Claude Code: installed" -ForegroundColor Green
} else {
    Write-Host "  ❌ Claude Code: not found" -ForegroundColor Red
    Write-Host "     Install: npm install -g @anthropic-ai/claude-code"
    $missing++
}

if (Get-Command "node" -ErrorAction SilentlyContinue) {
    $nodeVersion = node --version
    $nodeMajor = [int]($nodeVersion -replace 'v(\d+)\..*', '$1')
    if ($nodeMajor -ge 20) {
        Write-Host "  ✅ Node.js: $nodeVersion" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Node.js: $nodeVersion (need 20+)" -ForegroundColor Yellow
        Write-Host "     Upgrade: https://nodejs.org/"
        $missing++
    }
} else {
    Write-Host "  ❌ Node.js: not found" -ForegroundColor Red
    Write-Host "     Install: https://nodejs.org/"
    $missing++
}

if (Get-Command "git" -ErrorAction SilentlyContinue) {
    $gitVersion = (git --version) -replace 'git version ', ''
    Write-Host "  ✅ Git: $gitVersion" -ForegroundColor Green
} else {
    Write-Host "  ❌ Git: not found" -ForegroundColor Red
    Write-Host "     Install: https://git-scm.com/"
    $missing++
}

Write-Host ""
if ($missing -gt 0) {
    Write-Host "  $missing required tool(s) missing — install them before using the workflow." -ForegroundColor Red
    Write-Host ""
}

# ─── 2. Set up global STRINGZ.md ─────────────────────────

Write-Host "Setting up global context..." -ForegroundColor Yellow

$claudeDir = Join-Path $env:USERPROFILE ".claude"
if (!(Test-Path $claudeDir)) { New-Item -ItemType Directory -Path $claudeDir | Out-Null }

$stringzPath = Join-Path $claudeDir "STRINGZ.md"
if (Test-Path $stringzPath) {
    $overwrite = Read-Host "  ~/.claude/STRINGZ.md already exists. Overwrite with template? (y/N)"
    if ($overwrite -eq "y") {
        Copy-Item "templates\STRINGZ.md.template" $stringzPath -Force
        Write-Host "  ✅ STRINGZ.md overwritten with template" -ForegroundColor Green
    } else {
        Write-Host "  ⏭️  Keeping existing STRINGZ.md" -ForegroundColor Yellow
    }
} else {
    Copy-Item "templates\STRINGZ.md.template" $stringzPath
    Write-Host "  ✅ STRINGZ.md copied to ~/.claude/" -ForegroundColor Green
}
Write-Host "  📝 Edit $stringzPath and fill in YOUR values (name, company, stack)"
Write-Host ""

# ─── 3. Copy skills (Windows uses copy instead of symlinks) ──

Write-Host "Installing skills..." -ForegroundColor Yellow

$skillsDir = Join-Path $claudeDir "skills"
if (!(Test-Path $skillsDir)) { New-Item -ItemType Directory -Path $skillsDir | Out-Null }

$skillsLinked = 0
$skillsSkipped = 0

Get-ChildItem -Path "skills" -Directory | ForEach-Object {
    $target = Join-Path $skillsDir $_.Name
    if (Test-Path $target) {
        $skillsSkipped++
    } else {
        Copy-Item -Recurse $_.FullName $target
        $skillsLinked++
    }
}
Write-Host "  ✅ $skillsLinked skills installed ($skillsSkipped already existed)" -ForegroundColor Green
Write-Host ""

# ─── 4. Copy agents ──────────────────────────────────────

Write-Host "Installing agents..." -ForegroundColor Yellow

$agentsDir = Join-Path $claudeDir "agents"
if (!(Test-Path $agentsDir)) { New-Item -ItemType Directory -Path $agentsDir | Out-Null }

$agentsLinked = 0
$agentsSkipped = 0

Get-ChildItem -Path "agents" -Filter "*.md" | ForEach-Object {
    $target = Join-Path $agentsDir $_.Name
    if (Test-Path $target) {
        $agentsSkipped++
    } else {
        Copy-Item $_.FullName $target
        $agentsLinked++
    }
}
Write-Host "  ✅ $agentsLinked agents installed ($agentsSkipped already existed)" -ForegroundColor Green
Write-Host ""

# ─── 5. Summary ──────────────────────────────────────────

$totalSkills = (Get-ChildItem -Path "skills" -Directory).Count
$totalAgents = (Get-ChildItem -Path "agents" -Filter "*.md").Count

$version = "unknown"
$versionMatch = Select-String -Path "WORKFLOW.md" -Pattern "version: ([0-9.]+)" -ErrorAction SilentlyContinue
if ($versionMatch) { $version = $versionMatch.Matches[0].Groups[1].Value }

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  ✅ Setup complete!" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Framework version: $version"
Write-Host "  Installed:"
Write-Host "  - ~/.claude/STRINGZ.md (edit this with your personal details)"
Write-Host "  - $totalSkills skills installed to ~/.claude/skills/"
Write-Host "  - $totalAgents agents installed to ~/.claude/agents/"
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor Yellow
Write-Host "  1. Edit $stringzPath with your name, company, and stack"
Write-Host "  2. Install any missing prerequisites listed above"
Write-Host "  3. Open Claude Code in any project — the workflow activates automatically"
Write-Host ""
Write-Host "  Usage:"
Write-Host "  - New project:      mkdir my-project; cd my-project; claude"
Write-Host "  - Existing project: cd my-project; claude"
Write-Host "  - To update later:  git pull; .\setup.ps1"
Write-Host ""
