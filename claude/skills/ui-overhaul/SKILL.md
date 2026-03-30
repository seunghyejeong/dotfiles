---
name: ui-overhaul
description: >
  UI 전면 개편 작업 시 사용하는 스킬. 백엔드/기능 코드는 절대 건드리지 않고 프론트엔드 레이어만 수정.
  state.md, checklist.md, bug.md로 작업 상태를 추적하며 컨텍스트가 끊겨도 재개 가능.
  "UI 개편", "화면 바꾸기", "프론트 갈아엎기", "디자인 전면 수정", "껍데기만 교체", "프론트엔드 리뉴얼" 키워드에 반드시 사용.
---

# UI Overhaul Skill

---

## 0. 세션 시작 — 즉시 실행

```
1. .claude/ui-overhaul/state.md 확인
   - 있으면 → 읽고 이어가기
   - 없으면 → 지금 바로 초기화 (섹션 1)
2. Read .claude/ui-overhaul/checklist.md
3. Read .claude/ui-overhaul/bug.md
4. state.md 활성 세션 등록 (섹션 0-1)
5. 에이전트 자동 플로우 실행 (섹션 3)
```

### 0-1. 활성 세션 등록

state.md `## 활성 세션` 업데이트:
```
- 에이전트: {작업명}
- 시작: {시간}
- 담당 파일: {목록}
```
다른 활성 세션과 파일 겹치면 즉시 중단 후 사용자에게 보고.
세션 종료 시 해당 항목 제거.

---

## 1. 초기화 — state.md 없을 때만

```bash
mkdir -p .claude/ui-overhaul
```

Write `.claude/ui-overhaul/state.md`:
```markdown
# UI Overhaul — State
## 마지막 업데이트
## 활성 세션
(없음)
## 현재 단계
초기화 완료
## 완료된 파일
## 작업 중인 파일
## 다음 할 일
## 결정사항
- 공유 파일 (planner만 수정): variables.css
```

Write `.claude/ui-overhaul/checklist.md`:
```markdown
# UI Overhaul — Checklist
## 진행률: 0 / 0
```

Write `.claude/ui-overhaul/bug.md`:
```markdown
# UI Overhaul — Bug Log
## 미해결 (0건)
| ID | 발견일 | 파일 | 증상 | 재현 조건 | 우선순위 |
|----|--------|------|------|-----------|----------|
## 해결됨
| ID | 해결일 | 방법 |
```

완료 후: "초기화 완료. `/planner`로 시작합니다."

---

## 2. 핵심 원칙

**절대 금지:**
```
❌ API 엔드포인트, 요청/응답 구조 변경
❌ 비즈니스 로직, DB 쿼리, ORM 수정
❌ 인증/권한, 서버 라우팅 수정
❌ 환경변수, 설정 파일 수정
❌ variables.css — planner만 수정 가능
```

## 2. 핵심 원칙

**절대 금지:**
```
❌ API 엔드포인트, 요청/응답 구조 변경
❌ 비즈니스 로직, DB 쿼리, ORM 수정
❌ 인증/권한, 서버 라우팅 수정
❌ 환경변수, 설정 파일 수정
❌ variables.css — planner만 수정 가능
```

**허용:**
```
✅ JSX/HTML 마크업, CSS/Tailwind/SCSS
✅ UI 컴포넌트 (표현 레이어만)
✅ 애니메이션, 아이콘, 폰트
✅ 다크/라이트 모드 CSS 변수
```

### 프로젝트 기본값 (WITHREX / WITHVTM)

```
- 폰트: Pretendard (본문/헤딩) + IBM Plex Mono (숫자/코드)
- 로케일: 한국어 (ko)
- 모드: 다크모드 우선, 라이트모드 보조
- 아이콘: 인라인 SVG만. 이모지 절대 금지
- 브랜드 컬러 #FE6F47: Critical 표시, CTA 버튼, 활성 사이드바에만
  → 일반 텍스트, 배경, 장식 사용 금지
```

### 다크/라이트 모드 규칙

```
- 모든 색상 CSS 변수만. 하드코딩 금지
- 다크모드 먼저 구현 후 라이트모드 오버라이드
- 라이트모드: 순백(#ffffff)/형광빛 금지
  → 배경 #f2f3f8 계열, 텍스트 소프트 다크(#0a0c18 계열)
- color-scheme: dark/light html에 명시
- 다크모드 스크롤바 별도 스타일링
- 모달 스크림: 검정 40-60% 불투명도
```

### UI 품질 규칙 (ui-polish 핵심)

```
- transition: all 절대 금지 → 속성 명시 (transform, opacity, filter만)
- 버튼 :active → scale(0.96), 절대 0.95 아래 금지
- 애니메이션 진입: ease-out / 퇴장: ease-in
- UI 인터랙션 커브: cubic-bezier(.23, 1, .32, 1)
- prefers-reduced-motion: reduce → 모든 duration 0
- 아이콘 전용 버튼: aria-label 필수
- 장식 아이콘: aria-hidden="true" 필수
- 인터랙티브 요소 최소 44x44px 히트 영역
- font-variant-numeric: tabular-nums → 모든 숫자/테이블
- text-wrap: balance → 헤딩 / pretty → 본문
- 카드 깊이: box-shadow 3레이어 (하드 border 금지)
- 중첩 둥근 요소: 바깥 radius = 안쪽 + padding (concentric)
```

### 공통 컴포넌트 우선 원칙

```
1. ui-components.html에서 해당 컴포넌트 존재 여부 확인
2. 있으면 → 그 마크업 구조 그대로 사용
3. 없으면 → withadmin_ui.html 패턴 참고
4. 임의로 새 컴포넌트 만들지 않기
```

---

## 3. 에이전트 플로우 — 자동 실행

사용자가 작업 지시 시 아래 순서 자동 실행. 각 단계 후 확인. "다 해줘" 시 확인 없이 진행.

### Step 1. /planner
- 코드베이스 탐색 → 작업 파일/컴포넌트 파악
- checklist.md 작성, state.md 업데이트
- 사용자 확인

### Step 2. /ui-polish

> ⛔ 아래 읽기 완료 전 마크업/코드 작성 절대 금지

작업할 컴포넌트에 맞는 레퍼런스를 지금 읽는다:
```
# 1. 공통 컴포넌트 확인 (최우선)
grep -n "{컴포넌트명}" ui-components.html → 해당 섹션 Read
→ 있으면 그 구조 그대로. 없으면 다음으로

# 2. 레이아웃/CSS 변수
withadmin_ui.html → :root 변수 섹션 Read

# 3. 차트 작업 시에만
references/chart-reference.md Read

# 4. 디자인 감각
Glob: .claude/skills/**/SKILL.md → Read 전부 (ui-overhaul, ui-polish 제외)
```
읽기 완료 후 → 마크업/스타일 결정 → 사용자 확인

### Step 3. /deep-executor
- ui-polish 결과물 받아서 구현
- 백엔드 보호 원칙 적용
- checklist.md, state.md 업데이트

---

## 4. 버그

발견 즉시 bug.md 추가:
```
| BUG-{n} | {날짜} | {파일} | {증상} | {재현 조건} | P1/P2/P3 |
```
- P1: 화면 깨짐/사용 불가
- P2: 레이아웃 틀어짐
- P3: 미세 polish

---

## 5. 완료 기준

```
✅ checklist.md 전체 체크
✅ bug.md P1/P2 미해결 0건
✅ 다크모드 육안 확인
✅ 라이트모드 육안 확인 (눈부심/형광빛 없는지)
✅ 브랜드 컬러 강조 외 사용 없음
✅ 하드코딩 색상 0개
✅ 백엔드 기능 회귀 없음
```