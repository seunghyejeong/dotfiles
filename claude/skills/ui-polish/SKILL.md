---
name: ui-polish
description: >
  Consolidated UI/UX engineering principles and quality gate for building and reviewing frontend code.
  Use this skill whenever you are building, writing, or reviewing any frontend code — HTML, CSS, JS, or React components, pages, layouts, or UI artifacts.
  Also invoke when refactoring existing UI code, auditing for accessibility or performance issues, or before delivering any frontend output to the user.
  This skill must trigger even for small UI tasks like "make this button look better" or "fix the spacing" — apply the checklist before shipping anything visual.
  Sourced from: make-interfaces-feel-better, emil-design-eng, ui-ux-pro-max, web-design-guidelines, frontend-design.
---

# UI Polish - Frontend Quality Gate

---

## 출력 형식 — 반드시 이 형식으로 제안할 것

> ⛔ "코드 정리", "클린업", "마이너 수정" 수준으로 끝내면 안 됨.
> 반드시 시각적으로 눈에 띄는 개선을 포함할 것.

### 리뷰/개선 시 출력 형식

```
## 문제점
| 항목 | 현재 | 문제 |
|------|------|------|
| ... | ... | ... |

## 개선안
각 항목마다 구체적인 코드로 제시. 추상적 설명 금지.

## 다크모드 색상
--변수명: {값}  /* 용도 */

## 라이트모드 색상
--변수명: {값}  /* 용도 */

## 적용한 레퍼런스
- ui-components.html: {사용한 컴포넌트명}
- withadmin_ui.html: {참고한 패턴}
```

### 업그레이드 의무 항목 (매 작업마다 반드시 포함)

단순 코드 정리로 끝내지 말고 아래 중 최소 2개 이상 실제로 적용:
- 애니메이션/트랜지션 추가 또는 개선
- 다크/라이트 모드 색상 값 구체적으로 정의
- 타이포그래피 개선 (tabular-nums, text-wrap 등)
- 섀도우 시스템 적용
- 인터랙션 피드백 개선 (hover, active, focus)
- 빈 상태/로딩 상태 추가

---

## Quick Checklist (Must-Pass Before Delivery)

Run through every item. Fix before shipping.

### Surfaces & Layout
- [ ] Nested rounded elements use concentric radius (`outer = inner + padding`)
- [ ] Icons are optically centered (icon-side padding = text-side - 2px)
- [ ] Cards use layered `box-shadow` (3 layers, transparent) instead of hard borders for depth
- [ ] Dividers/separators use borders (not shadows)
- [ ] Images/avatars have `outline: 1px solid rgba(…, 0.1); outline-offset: -1px`
- [ ] Interactive elements have min 44x44px hit area (extend via `::after` pseudo if needed)
- [ ] No overlapping hit areas between adjacent interactive elements

### Typography
- [ ] `-webkit-font-smoothing: antialiased` on `html`
- [ ] `font-variant-numeric: tabular-nums` on all dynamic numbers (counters, tables, prices, timers)
- [ ] `text-wrap: balance` on headings (<=6 lines)
- [ ] `text-wrap: pretty` on body paragraphs
- [ ] Font scale is consistent (e.g., 11/12/13/16/20/28)
- [ ] Line-height 1.5 for body text
- [ ] Max 65-75 characters per line for readability

### Colors & Theming
- [ ] All colors via CSS custom properties (no hardcoded hex in components)
- [ ] Dark/light themes tested independently for contrast
- [ ] Primary text contrast >= 4.5:1 (WCAG AA)
- [ ] `color-scheme: dark` on `<html>` when dark mode active
- [ ] Status colors include icon/text, not color alone
- [ ] Brand/accent color used sparingly, not on everything

### Color Contrast Verification (색상 변경 시 필수)

> 느낌으로 판단 금지. 반드시 수치로 검증.

색상을 변경하거나 새로 정의할 때 아래 프로세스를 실행한다:

**Step 1. 대비율 계산 스크립트 실행**

```python
def srgb_to_linear(c):
    c = c / 255.0
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4

def luminance(hex_color):
    hex_color = hex_color.lstrip('#')
    r, g, b = int(hex_color[0:2], 16), int(hex_color[2:4], 16), int(hex_color[4:6], 16)
    return 0.2126 * srgb_to_linear(r) + 0.7152 * srgb_to_linear(g) + 0.0722 * srgb_to_linear(b)

def contrast(c1, c2):
    l1, l2 = luminance(c1), luminance(c2)
    if l1 < l2: l1, l2 = l2, l1
    return (l1 + 0.05) / (l2 + 0.05)
```

**Step 2. 양쪽 모드, 양쪽 배경에서 모두 테스트**

모든 색상은 아래 4가지 배경 위에서 대비를 측정해야 한다:

| 배경 | 다크모드 | 라이트모드 |
|------|---------|-----------|
| 페이지 bg | `#050510` | `#eeeef2` |
| 카드 (glass-elevated) | `~#111122` | `~#f8f8fb` |

**Step 3. 통과 기준**

| 용도 | 최소 대비율 | WCAG 등급 |
|------|-----------|----------|
| 본문 텍스트 (text-1, text-2) | **4.5:1** | AA |
| 시맨틱 컬러 (blue, teal, amber, red 등) | **4.5:1** | AA |
| 힌트/비활성 텍스트 (text-3) | **3:1** | AA-large |
| 서피스 간 구분 (카드 vs 배경) | **1.1:1** | 가시적 구분 |

**Step 4. 후보 색상 탐색**

FAIL 시 색상을 어둡게(라이트모드) 또는 밝게(다크모드) 조정하되,
색조(hue)는 유지하면서 명도(lightness)만 변경. 후보 3개를 계산해서 가장 자연스러운 값 선택.

**Step 5. 출력 형식**

```
Color      다크/card  등급    라이트/card  등급    라이트/bg  등급
────────────────────────────────────────────────────────────
blue        5.82     AA       5.72       AA       5.24     AA
teal        9.76     AAA      5.39       AA       4.94     AA
...
```

### Animation
- [ ] NEVER use `transition: all` — list exact properties
- [ ] Easing: `ease-out` for entering, `ease-in` for exiting, `ease-in-out` for on-screen movement
- [ ] Custom curve: `cubic-bezier(.23, 1, .32, 1)` for UI interactions
- [ ] Duration: 100-160ms buttons, 150-250ms dropdowns, 200-400ms modals
- [ ] Exit animations shorter than enter (e.g., enter 300ms, exit 150ms)
- [ ] `prefers-reduced-motion: reduce` — zero all durations
- [ ] Stagger entrance: 50-80ms delay per item, opacity + translateY(8px) + blur(4px)
- [ ] `scale(0.96)` on `:active` for buttons (never below 0.95)
- [ ] Never animate from `scale(0)` — start from `scale(0.95)` + `opacity: 0`
- [ ] Popovers: `transform-origin` from trigger (not center). Modals: keep center
- [ ] Prefer CSS transitions over keyframes for interactive elements (interruptible)
- [ ] No animation on keyboard-initiated actions (Cmd+K, shortcuts)
- [ ] Only animate `transform`, `opacity`, `filter` (GPU-compositable)
- [ ] `will-change` only on transform/opacity/filter when first-frame stutter occurs

### Icon Transitions (exact values, do not deviate)
- Scale: `0.25` → `1`
- Opacity: `0` → `1`
- Blur: `4px` → `0px`
- If motion library: `{ type: "spring", duration: 0.3, bounce: 0 }`
- If CSS only: both icons in DOM, cross-fade with `cubic-bezier(0.2, 0, 0, 1)`

### Accessibility
- [ ] Icon-only buttons have `aria-label`
- [ ] Decorative icons have `aria-hidden="true"`
- [ ] Form inputs have `<label>` or `aria-label`
- [ ] Use `<button>` for actions, `<a>` for navigation (no `<div onClick>`)
- [ ] Visible `:focus-visible` ring on all interactive elements (never bare `outline: none`)
- [ ] Heading hierarchy: sequential h1-h6, no level skip
- [ ] `touch-action: manipulation` (prevents 300ms tap delay)
- [ ] Correct `type` on inputs (`email`, `tel`, `url`, `number`)

### Performance
- [ ] `<img>` has explicit `width` and `height` (prevents CLS)
- [ ] Below-fold images: `loading="lazy"`
- [ ] Large lists (50+ items): virtualize
- [ ] No `will-change: all`
- [ ] Font loading: `font-display: swap`
- [ ] Critical fonts preloaded

### Dark Mode Specifics
- [ ] `<meta name="theme-color">` matches page background
- [ ] Native `<select>`: explicit `background-color` and `color`
- [ ] Scrollbar styled for dark mode
- [ ] Modal scrim: 40-60% black opacity for legibility

### No-Go (Anti-Patterns to Flag)
- `transition: all`
- `user-scalable=no` or `maximum-scale=1`
- `outline: none` without focus replacement
- `<div>` with click handler instead of `<button>`
- Images without dimensions
- Emojis as icons (use SVG always)
- Inline `onClick` navigation without `<a>`
- `ease-in` on UI entrance (feels sluggish)
- Same border-radius on parent and child
- `scale(0)` entry animation
- Hardcoded date/number formats (use `Intl`)

---

## Shadow System Reference

### Light Mode (3-layer)
```css
--shadow-border:
  0 0 0 1px rgba(0,0,0,0.06),
  0 1px 2px -1px rgba(0,0,0,0.06),
  0 2px 4px 0 rgba(0,0,0,0.04);
```

### Dark Mode (1-layer ring)
```css
--shadow-border: 0 0 0 1px rgba(255,255,255,0.08);
```

---

## Animation Decision Framework

Before animating anything, ask:

| Frequency | Decision |
|-----------|----------|
| 100+/day (shortcuts, toggles) | No animation |
| Tens/day (hovers, list nav) | Minimal or remove |
| Occasional (modals, drawers) | Standard animation |
| Rare (onboarding, celebrations) | Can add delight |

---

## Easing Curves

```css
--ease-out:    cubic-bezier(0.23, 1, 0.32, 1);    /* UI interactions */
--ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);   /* On-screen movement */
--ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);    /* iOS-like drawer */
--ease-icon:   cubic-bezier(0.2, 0, 0, 1);        /* Icon cross-fade */
```

---

## Review Output Format

When asked to **review** existing code (e.g. "check this", "review this component", "audit this UI"), output a markdown table:

| Before | After | Why |
|--------|-------|-----|
| `transition: all 300ms` | `transition: transform 200ms ease-out` | Specify exact properties |
| `border-radius: 12px` on both parent and child | Parent: `20px`, Child: `12px` (gap 8px) | Concentric radius rule |

---

## Project-Specific Defaults (WITHREX / WITHVTM)

- **Accent color:** `#FE6F47` — brand, CTA hover, Critical severity only. Never overuse.
- **No emojis in UI** — always inline SVG icons
- **Locale:** Korean (`ko`)
- **Mode:** 다크/라이트 모드 동등하게 구현. 둘 다 중점적으로 색 배치할 것.
  - 다크: 깊고 차분한 배경, 눈 안 피로한 톤
  - 라이트: 눈부시지 않은 오프화이트/웜그레이 계열. 순백(`#ffffff`)·형광빛 금지
  - 두 모드 모두 완성도 동일하게. "라이트는 나중에" 금지
  - 작업 시 반드시 두 모드 색상 값을 동시에 정의할 것
- **Font stack:** Pretendard (body/headings) + IBM Plex Mono (data/code)