#!/bin/bash
# ============================================================
# OpenClaw + Obsidian 자동 기록 시스템 - 자동 설치 스크립트
# Mac / Linux용
# ============================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${CYAN}=========================================="
echo "  OpenClaw + Obsidian 자동 기록 시스템"
echo "  자동 설치 스크립트 시작"
echo -e "==========================================${NC}"
echo ""

# ── 1. 사용자 정보 수집 ──────────────────────────────────────
echo -e "${YELLOW}📝 기본 정보를 입력해주세요.${NC}"
echo ""

read -p "  이름 (예: 만성): " USER_NAME
read -p "  Obsidian 볼트 경로 (예: /Users/username/obsidian): " OBSIDIAN_PATH
read -p "  텔레그램 봇 토큰 (모르면 Enter 스킵): " TELEGRAM_TOKEN

echo ""
echo -e "${GREEN}입력 내용 확인:${NC}"
echo "  이름: $USER_NAME"
echo "  Obsidian 경로: $OBSIDIAN_PATH"
echo ""

read -p "계속 진행할까요? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
    echo "설치를 취소했습니다."
    exit 0
fi

# ── 2. Node.js 확인 ─────────────────────────────────────────
echo ""
echo -e "${CYAN}🔍 Node.js 확인 중...${NC}"

if command -v node &> /dev/null; then
    NODE_VER=$(node --version)
    echo -e "  ${GREEN}✅ Node.js 설치됨: $NODE_VER${NC}"
else
    echo -e "  ${RED}❌ Node.js가 설치되지 않았습니다.${NC}"
    echo -e "  ${YELLOW}👉 https://nodejs.org 에서 LTS 버전을 설치 후 다시 실행하세요.${NC}"
    exit 1
fi

# ── 3. OpenClaw 설치 ─────────────────────────────────────────
echo ""
echo -e "${CYAN}🔍 OpenClaw 확인 중...${NC}"

if command -v openclaw &> /dev/null; then
    OCLAW_VER=$(openclaw --version)
    echo -e "  ${GREEN}✅ OpenClaw 설치됨: $OCLAW_VER${NC}"
else
    echo -e "  ${YELLOW}📦 OpenClaw 설치 중...${NC}"
    npm install -g openclaw
    echo -e "  ${GREEN}✅ OpenClaw 설치 완료${NC}"
fi

# ── 4. Obsidian 볼트 폴더 생성 ──────────────────────────────
echo ""
echo -e "${CYAN}📁 Obsidian 볼트 폴더 생성 중...${NC}"

mkdir -p "$OBSIDIAN_PATH/Guides"
mkdir -p "$OBSIDIAN_PATH/TIL"
mkdir -p "$OBSIDIAN_PATH/Projects"
mkdir -p "$OBSIDIAN_PATH/Inbox"
mkdir -p "$OBSIDIAN_PATH/MOC"
mkdir -p "$OBSIDIAN_PATH/Templates"
mkdir -p "$OBSIDIAN_PATH/memory"

echo -e "  ${GREEN}✅ 폴더 구조 생성 완료${NC}"

# ── 5. Obsidian 초기 파일 복사 ──────────────────────────────
echo ""
echo -e "${CYAN}📋 Obsidian 초기 파일 복사 중...${NC}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_SRC="$SCRIPT_DIR/obsidian-vault"

if [ -d "$VAULT_SRC" ]; then
    cp -r "$VAULT_SRC/"* "$OBSIDIAN_PATH/"
    echo -e "  ${GREEN}✅ MOC, Templates 파일 복사 완료${NC}"
fi

# ── 6. OpenClaw workspace 설정 ──────────────────────────────
echo ""
echo -e "${CYAN}⚙️ OpenClaw workspace 설정 중...${NC}"

WORKSPACE_PATH="$HOME/.openclaw/workspace"
mkdir -p "$WORKSPACE_PATH/memory"

WORKSPACE_SRC="$SCRIPT_DIR/workspace"

for FILE in AGENTS.md SOUL.md MEMORY.md USER.md HEARTBEAT.md; do
    SRC="$WORKSPACE_SRC/$FILE"
    DST="$WORKSPACE_PATH/$FILE"

    if [ -f "$DST" ]; then
        cp "$DST" "$DST.backup"
        echo -e "  ${YELLOW}📦 기존 $FILE 백업됨${NC}"
    fi

    if [ -f "$SRC" ]; then
        sed -e "s|{{USER_NAME}}|$USER_NAME|g" \
            -e "s|{{OBSIDIAN_VAULT_PATH}}|$OBSIDIAN_PATH|g" \
            "$SRC" > "$DST"
        echo -e "  ${GREEN}✅ $FILE 설정 완료${NC}"
    fi
done

# ── 7. 텔레그램 봇 설정 ─────────────────────────────────────
if [ -n "$TELEGRAM_TOKEN" ]; then
    echo ""
    echo -e "${CYAN}🤖 텔레그램 봇 설정 중...${NC}"
    openclaw config set telegram.token "$TELEGRAM_TOKEN" && \
        echo -e "  ${GREEN}✅ 텔레그램 봇 토큰 설정 완료${NC}" || \
        echo -e "  ${YELLOW}⚠️ 텔레그램 설정 실패. 수동으로 설정하세요.${NC}"
fi

# ── 완료 메시지 ──────────────────────────────────────────────
echo ""
echo -e "${GREEN}=========================================="
echo "  ✅ 설치 완료!"
echo -e "==========================================${NC}"
echo ""
echo -e "${YELLOW}📌 다음 단계:${NC}"
echo ""
echo "  1️⃣  Obsidian 앱 열기 → '$OBSIDIAN_PATH' 볼트 연결"
echo "  2️⃣  텔레그램 봇 시작: openclaw gateway start"
echo "  3️⃣  텔레그램에서 봇과 대화 시작!"
echo ""

if [ -z "$TELEGRAM_TOKEN" ]; then
    echo -e "${YELLOW}⚠️  텔레그램 봇 토큰이 설정되지 않았습니다."
    echo "    → @BotFather 에서 /newbot 으로 봇 생성 후"
    echo -e "    → openclaw config set telegram.token [토큰] 명령 실행${NC}"
    echo ""
fi

echo "🔗 도움말:"
echo "   공식 문서: https://docs.openclaw.ai"
echo "   커뮤니티: https://discord.com/invite/clawd"
echo ""
