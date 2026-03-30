# withadmin_ui.html — 레퍼런스

> 실제 파일: `withadmin_ui.html` (읽기 전용, 수정 금지)
> 역할: 전체 어드민 UI의 레이아웃·구조·테마 기준

---

## 1. 테마 시스템

### CSS 변수 (`:root` = 다크모드 기본, `[data-theme="light"]` = 라이트모드)

```css
/* 배경 */
--bg: #050510
--bg-subtle: #0a0b1a
--glass: rgba(255,255,255,0.035)
--glass-elevated: rgba(255,255,255,0.06)
--glass-border: rgba(255,255,255,0.07)
--glass-border-hover: rgba(255,255,255,0.13)

/* 텍스트 */
--text-1: #eaedf3   /* 본문 */
--text-2: #7d8799   /* 서브 */
--text-3: #454d5e   /* 비활성/힌트 */

/* 시맨틱 컬러 */
--blue: #3b8fff
--teal: #00d4aa
--amber: #f0a030
--red: #ff4060
--purple: #8b5cf6
--cyan: #06b6d4
--brand: #ef5d19      /* ⚠️ Critical/brand 전용 */

/* 카드 그림자 */
--card-shadow-1: rgba(0,0,0,0.25)
--card-shadow-2: rgba(0,0,0,0.12)
--hairline: rgba(255,255,255,0.06)
```

### 폰트 스택

```
헤딩: 'Outfit', sans-serif (font-weight: 500–700)
본문: 'IBM Plex Sans', sans-serif (font-weight: 300–500)
숫자/코드: 'IBM Plex Mono', monospace (font-variant-numeric: tabular-nums)
```

---

## 2. 레이아웃 구조

```
┌─────────────────────────────────────────────────┐
│ brand-strip (2px, top, background: var(--brand)) │
├─────────────────────────────────────────────────┤
│ topbar (48px, fixed top:2px)                    │
│  로고 | divider | search | bell | user | theme  │
├────────────┬────────────────────────────────────┤
│ sidebar    │ main-content                        │
│ (56px      │  margin-left: 56px (기본)           │
│  → 220px   │  → 220px (sidebar.pinned 시)        │
│  on hover/ │  margin-top: 50px                   │
│  pinned)   │                                     │
└────────────┴────────────────────────────────────┘
```

### topbar
- height: 48px, fixed, `top: 2px`
- `backdrop-filter: blur(16px)`
- 검색창: width 280px, `placeholder="검색… (Ctrl+K)"`

### sidebar
- 기본 width: 56px → hover/pinned: 220px
- `transition: width 300ms cubic-bezier(.23,1,.32,1)`
- group-label, sidebar-item (active: border-left 3px brand), sidebar-badge
- pin 버튼: localStorage `vtm-sidebar-pinned`

### main-content
- `padding: 0 20px 24px`
- 반응형: ≤900px → `margin-left: 0`

---

## 3. 그리드 시스템

```css
.grid-4   /* 4열, gap: 12px */
.grid-3   /* 3열, gap: 12px */
.grid-2   /* 2열, gap: 12px */
.grid-full /* 전체 폭 */
```

반응형 브레이크포인트:
- ≤1100px: `.grid-4` → 2열
- ≤900px: `.grid-2` → 1열
- ≤700px: 모든 그리드 → 1열

---

## 4. 핵심 컴포넌트 치수

| 컴포넌트 | 높이 | 패딩 | 특이사항 |
|---------|------|------|---------|
| `.card` | auto | 16px | glass 배경, blur(16px), border-radius: 8px |
| `.tab-item` | min 40px | 8px 16px | border-bottom: 2px solid (active: var(--blue)) |
| `.topbar-search input` | 32px | 0 12px 0 32px | - |
| `.filter-input` | 36px | 0 12px 0 34px | - |
| `.filter-select` | 36px | 0 28px 0 10px | - |
| `.export-btn` | 36px (min 40px) | 0 14px | - |
| `.refresh-btn` | 40px × 40px | - | square |
| `.page-btn` | 28px | 0 6px | min-width: 28px |

---

## 5. 색상 사용 규칙

| 색상 | 변수 | 용도 |
|------|------|------|
| 🟠 오렌지 | `--brand: #ef5d19` | Critical, brand-strip, 활성 sidebar, 긴급 버튼 |
| 🔵 블루 | `--blue` | 활성 탭, 링크, 일반 강조, 진행 중 |
| 🟢 틸 | `--teal` | 정상, 낮음, 완료, live-dot |
| 🟡 앰버 | `--amber` | 경고, 높음 |
| 🔴 레드 | `--red` | 위험, 오류 |
| 🟣 퍼플 | `--purple` | 클라우드, OUT 트래픽, 신규 |
| 🩵 시안 | `--cyan` | 중간, 보조 강조 |

---

## 6. 카드 변형

```css
.card-severity-critical  /* border-top: 3px solid var(--brand) */
.card-severity-high      /* border-top: 3px solid var(--amber) */
.card-severity-medium    /* border-top: 3px solid var(--cyan) */
.card-severity-low       /* border-top: 3px solid var(--teal) */
```

카드 진입 애니메이션: `.animate-in` (cardIn keyframe, nth-child 딜레이 60ms씩)

---

## 7. 페이지 구조 패턴

### 대시보드 (dashboard-view)
```
dashboard-header-row1: tab-bar (좌측 정렬)
dashboard-header-row2: summary-strip + 우측 controls (live-clock, refresh-btn, export-btn)
tab-content (tab1~tab4)
```

### 일반 페이지 (general-page)
```
page-header: page-header-title + page-header-subtitle | page-header-right (버튼들)
filter-bar: filter-search + filter-select들
card (table-wrap): data-table + table-footer (페이지네이션)
```

---

## 8. 상태 배지 클래스

```css
.status-badge.danger    /* background: var(--brand) */
.status-badge.warning   /* background: var(--amber) */
.status-badge.normal    /* background: var(--teal) */

/* data-table 내 상태 */
.status-active    /* teal */
.status-inactive  /* text-2 */
.status-progress  /* blue */
.status-done      /* teal */
.status-danger    /* brand */
```

---

## 9. 미니 차트 컴포넌트 (CSS-only)

| 컴포넌트 | 클래스 | 용도 |
|---------|--------|------|
| 수직 바 스파크라인 | `.vchart`, `.vchart-bar` | CVE 트렌드 |
| 미니 바 (CPU 코어) | `.mini-bars`, `.mini-bar` | CPU 사용률 |
| 수평 바 | `.hbar-list`, `.hbar-row` | OS/Zone 분포 |
| 디스크 바 | `.disk-entry`, `.disk-bar` | 디스크 사용률 |
| 프로토콜 수직 바 | `.proto-bars`, `.proto-bar-col` | 프로토콜 분포 |
| SVG 게이지 | `.gauge-svg` (inline SVG) | 패치 현황 |
| 스파크라인 | `.sparkline-container` (inline SVG) | 네트워크 I/O |
| 스택 바 | `.stacked-bar`, `.stacked-segment` | Zone 분포 |
| 랭킹 바 | `.ranked-list`, `.ranked-item` | Top 취약 자산 |

---

## 10. 사이드바 메뉴 구조

```
모니터링: 시스템 모니터링, 네트워크 노출현황
자산관리: 자산 현황, 스캔 관리
보안분석: 취약점 현황, 스캔 탐지
컴플라이언스: 사이버보안 실태평가, 기관정보보안감사, 정보보안감사, 사이버 진단의 날
운영: 교육관리, 정보화사업 관리, 작업 관리
커뮤니티: 소통광장
관리: 보안관제, 환경설정
(하단) 마이페이지
```

---

## 11. 접근성 / UX 규칙

- 모든 interactive 요소: `min-width: 40px; min-height: 40px`
- focus: `outline: 2px solid var(--blue); outline-offset: 2px`
- 버튼 active: `transform: scale(0.96)`
- `prefers-reduced-motion`: 모든 애니메이션/트랜지션 비활성화
- 스크롤바: width 6px, thumb `rgba(255,255,255,0.08)`
- 출력 시 불필요한 UI 숨김: `.sidebar, .topbar, .brand-strip, .tab-bar` → `display:none`