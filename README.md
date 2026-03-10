# 🤖 OpenClaw + Obsidian 자동 기록 시스템

> **AI와 대화하면 → Obsidian에 자동 저장된다**
> 따로 정리할 필요 없이, 모든 지식이 자동으로 쌓입니다.

---

## 🎯 이게 뭔가요?

평소에 이런 경험 있으신가요?

- AI와 대화하면서 유용한 내용을 배웠는데 나중에 찾을 수가 없다
- Obsidian에 정리하고 싶은데 매번 복붙이 귀찮다
- "이거 기억해" 했는데 다음날 AI가 다 잊어버렸다

**이 시스템이 그 문제를 해결합니다.**

```
텔레그램에서 AI와 대화
        ↓
AI가 중요한 내용 자동 판단
        ↓
Obsidian 볼트에 마크다운 파일로 저장
        ↓
텔레그램으로 브리핑: "📒 Obsidian 저장: Guides/파일명.md"
```

실제로는 이렇게 됩니다:

```
나:  https://github.com/어떤/라이브러리 이거 분석해줘
AI:  (분석 후 자동 저장)
     📒 Obsidian 저장: Guides/라이브러리명 가이드.md

나:  오늘 배운 거 정리해줘
AI:  (정리 후 자동 저장)
     📒 Obsidian 저장: TIL/2026-03-10 오늘 배운 것.md
```

---

## 🧩 구성 요소 (이것만 알면 됨)

| 도구 | 역할 | 비유 |
|------|------|------|
| **OpenClaw** | AI 에이전트 실행기 | 직원을 고용하는 플랫폼 |
| **Obsidian** | 마크다운 노트 앱 | 서랍 잘 정리된 책상 |
| **Telegram** | AI와 대화하는 채널 | AI에게 말 거는 앱 |
| **HEARTBEAT.md** | AI 행동 규칙서 | AI에게 주는 업무 지침서 |

---

## ⚡ 빠른 시작 (3단계)

### 사전 준비
- [ ] [Node.js LTS](https://nodejs.org) 설치
- [ ] [Obsidian](https://obsidian.md) 설치
- [ ] [Telegram](https://telegram.org) 앱 설치 + [@BotFather](https://t.me/BotFather)에서 봇 생성

### 텔레그램 봇 만들기 (처음 한 번만)

```
1. 텔레그램에서 @BotFather 검색
2. /newbot 입력
3. 봇 이름 입력 (예: 나의AI봇)
4. 봇 username 입력 (예: myai_bot)
5. 발급된 토큰 복사 (예: 1234567890:ABCdef...)
```

### 설치 실행

**Windows:**
```powershell
# 1. 이 레포 클론
git clone https://github.com/aiebrain/openclaw-obsidian-starter.git
cd openclaw-obsidian-starter

# 2. 설치 스크립트 실행
.\setup.ps1
```

**Mac / Linux:**
```bash
# 1. 이 레포 클론
git clone https://github.com/aiebrain/openclaw-obsidian-starter.git
cd openclaw-obsidian-starter

# 2. 설치 스크립트 실행
chmod +x setup.sh
./setup.sh
```

### 실행

```bash
openclaw gateway start
```

텔레그램에서 봇에게 메시지를 보내면 AI가 응답합니다! 🎉

---

## 📁 설치 후 생성되는 구조

### Obsidian 볼트

```
📂 obsidian/
├── 📂 Guides/        ← AI가 가이드 문서 자동 저장
│   └── 예시 가이드.md
├── 📂 TIL/           ← 오늘 배운 것 자동 저장
│   └── 2026-03-10 예시.md
├── 📂 Projects/      ← 프로젝트 관련 노트
├── 📂 Inbox/         ← 빠른 메모 (나중에 정리)
├── 📂 MOC/           ← 지식 지도 (자동 연결)
│   ├── AI 도구 모음.md
│   └── 프로젝트 허브맵.md
└── 📂 Templates/     ← 노트 형식 템플릿
    ├── 가이드 템플릿.md
    └── TIL 템플릿.md
```

### OpenClaw Workspace

```
📂 ~/.openclaw/workspace/
├── AGENTS.md       ← AI 행동 규칙
├── SOUL.md         ← AI 성격/톤
├── HEARTBEAT.md    ← 자동 기록 규칙 ⭐ (핵심)
├── MEMORY.md       ← AI 장기 기억
└── USER.md         ← 내 정보
```

---

## 💡 핵심 원리 - HEARTBEAT.md

이 시스템의 핵심은 `HEARTBEAT.md` 파일입니다.

AI는 이 파일을 읽고 **"어떤 내용을 어디에 저장할지"** 결정합니다.

```markdown
# HEARTBEAT.md 예시

## Obsidian 자동 저장 규칙
볼트 경로: C:\Users\나\obsidian

- 가이드성 내용 → Guides/
- 오늘 배운 것 → TIL/YYYY-MM-DD 제목.md
- URL 공유 시 → 자동 분석 후 Guides/ 저장
- 저장 후 브리핑: "📒 Obsidian 저장: 경로/파일명"
```

**규칙을 수정하면 AI 행동이 바뀝니다.** 원하는 대로 커스터마이징 가능합니다.

---

## 🗣️ 자주 쓰는 명령어

```
# 자동 저장 (요청 없이 AI가 판단해서 저장)
그냥 대화하세요. 중요한 내용은 자동으로 저장됩니다.

# 명시적 저장 요청
"이 내용 Obsidian에 저장해줘"
"오늘 배운 거 TIL로 정리해줘"
"이 링크 분석해서 가이드 만들어줘"

# 기억 요청
"이거 기억해줘"
"다음에도 이 방식으로 해줘"
```

---

## 🔧 커스터마이징

### 저장 경로 변경

`~/.openclaw/workspace/HEARTBEAT.md` 열어서 볼트 경로 수정:

```markdown
볼트 루트: C:\Users\[내 이름]\[내 볼트 폴더]
```

### 저장 규칙 추가

```markdown
## Obsidian 자동 저장 규칙
...
- 유튜브 링크 공유 시 → TIL/유튜브 스크립트로 저장
- 쇼핑 관련 내용 → Projects/쇼핑 리서치.md에 추가
```

### AI 성격 변경

`~/.openclaw/workspace/SOUL.md` 수정

---

## ❓ 자주 묻는 질문

**Q: Obsidian Sync가 없어도 되나요?**
A: 네. 로컬 파일로 저장합니다. 동기화가 필요하면 OneDrive, iCloud, 또는 Git으로 설정하세요.

**Q: 원하지 않는 내용이 저장될 수 있나요?**
A: HEARTBEAT.md의 저장 기준을 명확히 작성하면 됩니다. "중요하다고 판단되는 기술 내용만" 등으로 좁힐 수 있어요.

**Q: AI가 내 파일을 잘못 덮어쓰면 어떻게 하나요?**
A: setup.ps1이 기존 파일을 `.backup`으로 백업합니다. 볼트는 Git으로 버전관리하는 것을 추천합니다.

**Q: 텔레그램 말고 다른 채널로도 쓸 수 있나요?**
A: OpenClaw는 WhatsApp, Discord, Signal 등도 지원합니다. [공식 문서](https://docs.openclaw.ai) 참고.

**Q: OpenClaw가 24시간 켜져 있어야 하나요?**
A: 로컬 PC에서는 켜져 있을 때만 동작합니다. 항상 켜두려면 서버(VPS)나 라즈베리파이에 설치하세요.

---

## 🔗 관련 링크

| 링크 | 설명 |
|------|------|
| [OpenClaw GitHub](https://github.com/openclaw/openclaw) | OpenClaw 소스코드 |
| [OpenClaw 공식 문서](https://docs.openclaw.ai) | 설치, 설정, API 가이드 |
| [OpenClaw 커뮤니티 Discord](https://discord.com/invite/clawd) | 질문, 팁 공유 |
| [ClawHub](https://clawhub.com) | AI 에이전트 스킬 마켓플레이스 |
| [Obsidian](https://obsidian.md) | 마크다운 노트 앱 |
| [BotFather](https://t.me/BotFather) | 텔레그램 봇 생성 |

---

## 🏗️ 파일 구조

```
openclaw-obsidian-starter/
├── README.md                 ← 지금 보고 있는 파일
├── setup.ps1                 ← Windows 자동 설치 스크립트
├── setup.sh                  ← Mac/Linux 자동 설치 스크립트
├── workspace/                ← OpenClaw 설정 파일들
│   ├── AGENTS.md
│   ├── SOUL.md
│   ├── HEARTBEAT.md          ← 자동 기록 규칙 핵심
│   ├── MEMORY.md
│   └── USER.md
└── obsidian-vault/           ← Obsidian 초기 파일들
    ├── MOC/
    │   ├── AI 도구 모음.md
    │   └── 프로젝트 허브맵.md
    └── Templates/
        ├── 가이드 템플릿.md
        └── TIL 템플릿.md
```

---

Made with ❤️ by [AI 커머스 브레인](https://www.youtube.com/@aiebrain)
