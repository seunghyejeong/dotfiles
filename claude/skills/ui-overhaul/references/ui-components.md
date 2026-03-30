# ui-components.html — 레퍼런스

> 실제 파일: `ui-components.html` (읽기 전용, 수정 금지)
> 역할: 공통 UI 컴포넌트 마크업 및 클래스 기준
> ⚠️ 새 컴포넌트 작업 전 반드시 이 파일에서 기존 정의 확인

---

## 컴포넌트 목록 (전체)

| # | 컴포넌트 | 핵심 클래스 |
|---|---------|------------|
| 1 | Buttons | `.btn`, `.btn-primary`, `.btn-secondary`, `.btn-danger`, `.btn-ghost` |
| 2 | Badges | `.badge`, `.badge-crit`, `.badge-high`, `.badge-med`, `.badge-low`, `.badge-acc` |
| 3 | Alerts | `.alert`, `.alert-info`, `.alert-warning`, `.alert-danger`, `.alert-success` |
| 4 | Toast Notifications | `.toast-container`, `.toast` |
| 5 | Modal Dialog | `.modal-scrim`, `.modal`, `.modal-header`, `.modal-body`, `.modal-footer` |
| 6 | Form Inputs | `.form-input`, `.form-group`, `.form-label`, `.form-hint` (error 상태: `.error`) |
| 7 | Cards | `.card`, `.card-header`, `.card-body`, `.card-footer` |
| 8 | Data Table | `.data-table`, `.th-sort`, `.row-suspicious` |
| 9 | Tabs | `.tabs`, `.tab-item`, `.tab-content` |
| 10 | Board / Post List | `.board-list`, `.board-item` |
| 11 | Post Detail | `.post-detail`, `.post-meta`, `.post-body` |
| 12 | Dropdown Menu | `.dropdown`, `.dropdown-menu`, `.dropdown-item` |
| 13 | Tags / Chips | `.tag`, `.chip` |
| 14 | Timeline | `.timeline`, `.timeline-item`, `.timeline-dot`, `.timeline-line` |
| 15 | Pagination | `.pagination`, `.page-btn` |
| 16 | Progress Bars | `.progress-bar`, `.progress-bar-fill` |
| 17 | Skeleton Loading | `.skeleton` (shimmer 애니메이션) |
| 18 | Empty State | `.empty-state` |
| 19 | Avatar Group | `.avatar-group`, `.avatar` |
| 20 | KPI Strip | `.kpi-strip`, `.kpi-item` |
| 21 | Panel | `.panel`, `.phead`, `.pbody` |
| 22 | Filter Bar | `.filter-bar`, `.filter-search`, `.filter-input`, `.filter-select` |
| 23 | Status Tags | `.status-tag`, `.status-active`, `.status-inactive`, `.status-progress` |
| 24 | CVE Summary Grid | `.cve-grid`, `.cve-item` (crit/high/med/low 배리언트) |
| 25 | Scan Status | `.scan-status`, `.scan-progress` |
| 26 | Donut Chart (CSS) | `.donut-chart` (CSS conic-gradient 방식) |
| 27 | Horizontal Bar Chart | `.hbar-chart`, `.hbar-row` |
| 28 | Page Header + Controls | `.page-header`, `.page-header-left`, `.page-header-right` |
| 29 | Sidebar Navigation V3.0 | `.sidebar`, `.sidebar-item`, `.sidebar-group-label` |

---

## 주요 컴포넌트 상세

### Buttons
```html
<button class="btn btn-primary">기본</button>
<button class="btn btn-secondary">보조</button>
<button class="btn btn-danger">삭제/위험</button>
<button class="btn btn-ghost">고스트</button>
```
- 모든 버튼 `min-height: 40px` 준수
- active: `transform: scale(0.96)`

### Badges
```html
<span class="badge badge-crit">Critical</span>
<span class="badge badge-high">High</span>
<span class="badge badge-med">Medium</span>
<span class="badge badge-low">Low</span>
<span class="badge badge-acc">Info</span>
```
severity 색상: crit `#ff3858`, high `#ffa21e`, med `#18b0ff`, low `#00dc7e`

### Form Inputs
```html
<div class="form-group">
  <label class="form-label" for="id">레이블</label>
  <input class="form-input" type="text" id="id" placeholder="...">
  <span class="form-hint">힌트 텍스트</span>
</div>

<!-- 에러 상태 -->
<input class="form-input error" ...>
```

### Modal
```html
<div class="modal-scrim" id="modal-id" hidden>
  <div class="modal">
    <div class="modal-header">제목</div>
    <div class="modal-body">내용</div>
    <div class="modal-footer">
      <button class="btn btn-secondary">취소</button>
      <button class="btn btn-primary">확인</button>
    </div>
  </div>
</div>
```
JS: `openModal('id')` / `closeModal('id')`

### Data Table
```html
<table class="data-table">
  <thead><tr><th>컬럼</th>...</tr></thead>
  <tbody>
    <tr><td class="mono">값</td>...</tr>
    <tr class="row-suspicious">...</tr>  <!-- 위험 행 하이라이트 -->
  </tbody>
</table>
<div class="table-footer">
  <span class="table-info mono">총 N건 중 1-25</span>
  <div class="pagination">...</div>
</div>
```

### CVE Summary Grid
```html
<div class="cve-grid">
  <div class="cve-item crit"><span class="val">12</span><span class="lbl">Critical</span></div>
  <div class="cve-item high"><span class="val">28</span><span class="lbl">High</span></div>
  <div class="cve-item med"><span class="val">45</span><span class="lbl">Medium</span></div>
  <div class="cve-item low"><span class="val">15</span><span class="lbl">Low</span></div>
</div>
```

### Status Tags
```html
<span class="status-tag status-active">활성</span>
<span class="status-tag status-inactive">비활성</span>
<span class="status-tag status-progress">진행중</span>
<span class="status-tag status-done">완료</span>
<span class="status-tag status-danger">위험</span>
```

### KPI Strip
```html
<div class="kpi-strip">
  <div class="kpi-item">
    <span class="kpi-val">1,247</span>
    <span class="kpi-lbl">총 자산</span>
  </div>
  ...
</div>
```

### Panel (카드 확장형)
```html
<div class="panel">
  <div class="phead">
    <span class="phead-t">제목</span>
    <span class="phead-m">메타정보</span>
  </div>
  <div class="pbody">내용</div>
</div>
```

### Scan Status
```html
<div class="scan-status">
  <span class="live-dot"></span>
  <div class="scan-info">
    <div class="scan-name">스캔명</div>
    <div class="scan-meta">대상: N · 시작: HH:MM</div>
  </div>
  <div class="scan-progress">
    <div class="progress-bar-wrap">
      <div class="progress-bar" style="width:62%"></div>
    </div>
    <span class="mono">62%</span>
  </div>
</div>
```

### Skeleton Loading
```html
<div class="skeleton" style="height:20px;width:60%"></div>
<div class="skeleton" style="height:14px;width:80%;margin-top:8px"></div>
```
shimmer 애니메이션 자동 적용 (`animation: shimmer 1.5s ease-in-out infinite`)

### Empty State
```html
<div class="empty-state">
  <svg><!-- 아이콘 --></svg>
  <p class="empty-title">데이터 없음</p>
  <p class="empty-desc">조건을 변경하거나 스캔을 실행하세요</p>
</div>
```

---

## 사용 규칙

1. **이 파일에 있는 컴포넌트는 반드시 이 클래스명 그대로 사용.** 임의로 새 클래스 만들지 말 것
2. **에러/경고 상태**: form-input에 `.error` 클래스 추가, 별도 CSS 금지
3. **버튼 변형**: `.btn-*` 외의 버튼 스타일 금지
4. **severity 색상**: badge/cve-item 외 곳에서 임의로 severity 색상 직접 지정 금지 — CSS 변수 사용
5. **모달**: `.modal-scrim` + hidden 패턴 유지. 다른 구현 방식(visibility, opacity) 금지