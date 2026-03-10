# ============================================================
# OpenClaw + Obsidian 자동 기록 시스템 - 자동 설치 스크립트
# Windows PowerShell용
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  OpenClaw + Obsidian 자동 기록 시스템" -ForegroundColor Cyan
Write-Host "  자동 설치 스크립트 시작" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# ── 1. 사용자 정보 수집 ──────────────────────────────────────
Write-Host "📝 기본 정보를 입력해주세요." -ForegroundColor Yellow
Write-Host ""

$userName = Read-Host "  이름 (예: 만성)"
$obsidianPath = Read-Host "  Obsidian 볼트 경로 (예: C:\Users\aibra\obsidian)"
$telegramToken = Read-Host "  텔레그램 봇 토큰 (BotFather에서 발급, 모르면 Enter 스킵)"

Write-Host ""
Write-Host "입력 내용 확인:" -ForegroundColor Green
Write-Host "  이름: $userName"
Write-Host "  Obsidian 경로: $obsidianPath"
Write-Host ""

$confirm = Read-Host "계속 진행할까요? (y/n)"
if ($confirm -ne "y") {
    Write-Host "설치를 취소했습니다." -ForegroundColor Red
    exit
}

# ── 2. Node.js 확인 ─────────────────────────────────────────
Write-Host ""
Write-Host "🔍 Node.js 확인 중..." -ForegroundColor Cyan

try {
    $nodeVersion = node --version 2>$null
    Write-Host "  ✅ Node.js 설치됨: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Node.js가 설치되지 않았습니다." -ForegroundColor Red
    Write-Host "  👉 https://nodejs.org 에서 LTS 버전을 설치 후 다시 실행하세요." -ForegroundColor Yellow
    exit 1
}

# ── 3. OpenClaw 설치 확인 ────────────────────────────────────
Write-Host ""
Write-Host "🔍 OpenClaw 확인 중..." -ForegroundColor Cyan

try {
    $oclawVersion = openclaw --version 2>$null
    Write-Host "  ✅ OpenClaw 설치됨: $oclawVersion" -ForegroundColor Green
} catch {
    Write-Host "  📦 OpenClaw 설치 중..." -ForegroundColor Yellow
    npm install -g openclaw
    Write-Host "  ✅ OpenClaw 설치 완료" -ForegroundColor Green
}

# ── 4. Obsidian 볼트 폴더 구조 생성 ─────────────────────────
Write-Host ""
Write-Host "📁 Obsidian 볼트 폴더 생성 중..." -ForegroundColor Cyan

$folders = @(
    "$obsidianPath\Guides",
    "$obsidianPath\TIL",
    "$obsidianPath\Projects",
    "$obsidianPath\Inbox",
    "$obsidianPath\MOC",
    "$obsidianPath\Templates",
    "$obsidianPath\memory"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Force -Path $folder | Out-Null
    Write-Host "  ✅ $folder" -ForegroundColor Green
}

# ── 5. Obsidian 초기 파일 복사 ───────────────────────────────
Write-Host ""
Write-Host "📋 Obsidian 초기 파일 복사 중..." -ForegroundColor Cyan

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$vaultSrc = Join-Path $scriptDir "obsidian-vault"

if (Test-Path $vaultSrc) {
    Copy-Item -Path "$vaultSrc\*" -Destination $obsidianPath -Recurse -Force
    Write-Host "  ✅ MOC, Templates 파일 복사 완료" -ForegroundColor Green
}

# ── 6. OpenClaw workspace 설정 ───────────────────────────────
Write-Host ""
Write-Host "⚙️ OpenClaw workspace 설정 중..." -ForegroundColor Cyan

$workspacePath = "$env:USERPROFILE\.openclaw\workspace"
New-Item -ItemType Directory -Force -Path $workspacePath | Out-Null

$workspaceSrc = Join-Path $scriptDir "workspace"

# 파일 복사 (기존 파일이 있으면 백업)
$workspaceFiles = @("AGENTS.md", "SOUL.md", "MEMORY.md", "USER.md", "HEARTBEAT.md")

foreach ($file in $workspaceFiles) {
    $srcFile = Join-Path $workspaceSrc $file
    $dstFile = Join-Path $workspacePath $file

    if (Test-Path $dstFile) {
        $backup = "$dstFile.backup"
        Copy-Item $dstFile $backup -Force
        Write-Host "  📦 기존 $file 백업: $backup" -ForegroundColor Yellow
    }

    if (Test-Path $srcFile) {
        $content = Get-Content $srcFile -Raw -Encoding UTF8
        $content = $content -replace '\{\{USER_NAME\}\}', $userName
        $content = $content -replace '\{\{OBSIDIAN_VAULT_PATH\}\}', $obsidianPath
        [System.IO.File]::WriteAllText($dstFile, $content, [System.Text.Encoding]::UTF8)
        Write-Host "  ✅ $file 설정 완료" -ForegroundColor Green
    }
}

# ── 7. 텔레그램 봇 설정 ─────────────────────────────────────
if ($telegramToken -ne "") {
    Write-Host ""
    Write-Host "🤖 텔레그램 봇 설정 중..." -ForegroundColor Cyan
    try {
        openclaw config set telegram.token $telegramToken
        Write-Host "  ✅ 텔레그램 봇 토큰 설정 완료" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠️ 텔레그램 설정 실패. 수동으로 설정하세요." -ForegroundColor Yellow
    }
}

# ── 8. memory 폴더 생성 ─────────────────────────────────────
$memoryPath = "$workspacePath\memory"
New-Item -ItemType Directory -Force -Path $memoryPath | Out-Null

# ── 완료 메시지 ──────────────────────────────────────────────
Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "  ✅ 설치 완료!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "📌 다음 단계:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1️⃣  Obsidian 앱 열기 → '$obsidianPath' 볼트 연결"
Write-Host "  2️⃣  텔레그램 봇 시작: openclaw gateway start"
Write-Host "  3️⃣  텔레그램에서 봇과 대화 시작!"
Write-Host ""

if ($telegramToken -eq "") {
    Write-Host "⚠️  텔레그램 봇 토큰이 설정되지 않았습니다." -ForegroundColor Yellow
    Write-Host "    → @BotFather 에서 /newbot 으로 봇 생성 후" -ForegroundColor Yellow
    Write-Host "    → openclaw config set telegram.token [토큰] 명령 실행" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "🔗 도움말:"
Write-Host "   공식 문서: https://docs.openclaw.ai"
Write-Host "   커뮤니티: https://discord.com/invite/clawd"
Write-Host ""
