# ui-components-markup.md — 실제 마크업 예시

> ⚠️ CSS 클래스명만으로 구조를 추측하지 말 것. 반드시 이 파일을 읽고 마크업 구조를 그대로 따른다.
> 원본: `ui-components.html` 

---

## Buttons

```html
<!-- 기본 변형 -->
<button class="btn btn-primary">
  <svg>...</svg>
  Primary
</button>
<button class="btn btn-brand">Brand CTA</button>
<button class="btn btn-secondary">Secondary</button>
<button class="btn btn-ghost">Ghost</button>
<button class="btn btn-danger">Danger</button>
<button class="btn btn-primary" disabled>Disabled</button>

<!-- 크기 -->
<button class="btn btn-primary btn-sm">Small</button>
<button class="btn btn-primary">Default</button>
<button class="btn btn-primary btn-lg">Large</button>

<!-- 아이콘 전용 버튼 -->
<button class="btn btn-icon btn-secondary" aria-label="Settings" data-tooltip="Settings">
  <svg>...</svg>
</button>
```

---

## Badges

```html
<!-- 아이콘 포함 -->
<span class="badge badge-blue">
  <svg>...</svg>
  Info
</span>
<span class="badge badge-teal">Success</span>
<span class="badge badge-amber">Warning</span>
<span class="badge badge-red">Critical</span>
<span class="badge badge-purple">v4.2.1</span>
<span class="badge badge-brand">NEW</span>

<!-- 채운 배지 (숫자/상태) -->
<span class="badge badge-filled-red">3</span>
<span class="badge badge-filled-blue">12</span>
<span class="badge badge-filled-teal">OK</span>
<span class="badge badge-filled-amber">PENDING</span>
```

---

## Alerts

```html
<div class="alert alert-info">
  <svg>...</svg>
  <div class="alert-body">
    <div class="alert-title">제목</div>
    <div class="alert-text">내용</div>
  </div>
  <button class="alert-close" aria-label="Close"><svg>...</svg></button>
</div>

<!-- 변형: alert-success / alert-warning / alert-error -->
```

---

## Modal

```html
<!-- 트리거 -->
<button class="btn btn-secondary" onclick="openModal('modal-id')">Open</button>

<!-- 모달 본체 (body 끝에 위치) -->
<div class="modal-scrim" id="modal-id" hidden
     onclick="if(event.target===this)closeModal('modal-id')">
  <div class="modal">
    <div class="modal-header">
      <h3 class="modal-title">제목</h3>
      <button class="modal-close" onclick="closeModal('modal-id')" aria-label="Close modal">
        <svg>...</svg>
      </button>
    </div>
    <div class="modal-body">
      <!-- form-group 등 -->
    </div>
    <div class="modal-footer">
      <button class="btn btn-ghost" onclick="closeModal('modal-id')">취소</button>
      <button class="btn btn-primary">확인</button>
    </div>
  </div>
</div>
```

---

## Form Inputs

```html
<div class="form-group">
  <label class="form-label" for="id">레이블</label>
  <input class="form-input" type="text" id="id" placeholder="...">
  <div class="form-hint">힌트 텍스트</div>
</div>

<!-- 에러 상태 -->
<div class="form-group">
  <label class="form-label" for="id-err">IP Address</label>
  <input class="form-input error" type="text" id="id-err" value="999.999.999.999">
  <div class="form-hint error">Invalid IPv4 address format.</div>
</div>

<!-- Select -->
<div class="form-group">
  <label class="form-label" for="sel">Severity</label>
  <select class="form-input" id="sel">
    <option>Critical</option>
    <option>High</option>
  </select>
</div>

<!-- Textarea -->
<div class="form-group">
  <label class="form-label" for="ta">Description</label>
  <textarea class="form-input" id="ta" rows="3" placeholder="..."></textarea>
</div>

<!-- Checkbox / Radio -->
<label class="form-check"><input type="checkbox" checked> 레이블</label>
<label class="form-check"><input type="radio" name="g"> 레이블</label>

<!-- Toggle -->
<label class="toggle">
  <input type="checkbox" checked>
  <span class="toggle-track"></span>
  Auto-update
</label>
```

---

## Cards

```html
<!-- severity 상단 테두리 카드 -->
<div class="card card-severity-critical">
  <div class="card-label">Critical</div>
  <div class="card-value" style="color:var(--brand)">7</div>
</div>
<!-- 변형: card-severity-high / card-severity-medium / card-severity-low -->

<!-- 기본 카드 -->
<div class="card">
  내용
</div>

<!-- 패딩 없는 카드 (테이블 래퍼) -->
<div class="card" style="padding:0; overflow:auto">
  <table class="data-table">...</table>
</div>
```

---

## Data Table

```html
<div class="card" style="padding:0; overflow:auto">
  <table class="data-table">
    <thead>
      <tr>
        <th>CVE ID</th>
        <th>Severity</th>
        <th>Asset</th>
        <th>Status</th>
        <th>Detected</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td class="mono-cell">CVE-2026-1847</td>
        <td><span class="badge badge-filled-red">CRITICAL</span></td>
        <td>web-prod-03</td>
        <td><span class="badge badge-red">Open</span></td>
        <td class="mono-cell">2026-03-27</td>
      </tr>
    </tbody>
  </table>
</div>
```

---

## Tabs

```html
<div class="tab-bar" role="tablist">
  <button class="tab-item active" role="tab" aria-selected="true">
    <svg>...</svg>
    Overview
  </button>
  <button class="tab-item" role="tab" aria-selected="false">
    Vulnerabilities
  </button>
</div>
```

---

## Board / Post List

```html
<div class="card" style="padding:0">
  <div class="post-list">
    <div class="post-item">
      <span class="post-category notice">Notice</span>
      <div class="post-body">
        <div class="post-title-text">제목</div>
        <div class="post-meta">
          <span class="post-meta-item">작성자</span>
          <span class="post-meta-item">2026-03-28</span>
        </div>
      </div>
      <div class="post-stats">
        <span class="post-stat">
          <svg>...</svg>
          342
        </span>
        <span class="post-stat">
          <svg>...</svg>
          12
        </span>
      </div>
    </div>
  </div>
</div>
<!-- post-category 변형: notice / general / question -->
```

---

## Post Detail

```html
<div class="card">
  <div class="post-detail">
    <div class="post-detail-header">
      <div style="display:flex;align-items:center;gap:8px;margin-bottom:10px">
        <span class="post-category notice">Notice</span>
      </div>
      <h2 class="post-detail-title">제목</h2>
      <div class="post-detail-meta">
        <div class="post-detail-author">
          <div class="post-avatar">A</div>
          <span>Admin</span>
        </div>
        <span>2026-03-28 09:15</span>
        <span>조회수</span>
      </div>
    </div>
    <div class="post-detail-body">
      <p>본문 내용</p>
    </div>
    <div class="post-detail-actions">
      <button class="btn btn-ghost btn-sm">Share</button>
      <button class="btn btn-ghost btn-sm">Bookmark</button>
    </div>
    <!-- 댓글 -->
    <div class="comment-section">
      <div class="comment-title">Comments (3)</div>
      <div class="comment-item">
        <div class="post-avatar">JK</div>
        <div class="comment-body">
          <div class="comment-author">J. Kim <span>2026-03-28 10:32</span></div>
          <div class="comment-text">댓글 내용</div>
        </div>
      </div>
    </div>
  </div>
</div>
```

---

## Dropdown Menu

```html
<div class="dropdown" id="dropdown-id">
  <button class="btn btn-secondary" onclick="this.parentElement.classList.toggle('open')">
    Actions
    <svg>...</svg>
  </button>
  <div class="dropdown-menu">
    <button class="dropdown-item">
      <svg>...</svg>
      Edit
    </button>
    <button class="dropdown-item">Duplicate</button>
    <div class="dropdown-divider"></div>
    <button class="dropdown-item danger">
      <svg>...</svg>
      Delete
    </button>
  </div>
</div>
```

---

## Tags / Chips

```html
<!-- 기본 태그 -->
<span class="tag">
  <svg>...</svg>
  linux
</span>

<!-- 제거 버튼 있는 태그 -->
<span class="tag">
  network
  <button class="tag-remove" aria-label="Remove tag">
    <svg>...</svg>
  </button>
</span>
```

---

## Timeline

```html
<div class="timeline">
  <div class="timeline-item">
    <div class="timeline-dot-wrap">
      <div class="timeline-dot" style="background:var(--red)"></div>
      <div class="timeline-line"></div>
    </div>
    <span class="timeline-time">14:32</span>
    <span class="timeline-msg">이벤트 내용</span>
  </div>
  <!-- 마지막 아이템: timeline-line 없음 -->
  <div class="timeline-item">
    <div class="timeline-dot-wrap">
      <div class="timeline-dot" style="background:var(--blue)"></div>
    </div>
    <span class="timeline-time">09:00</span>
    <span class="timeline-msg">마지막 이벤트</span>
  </div>
</div>
```
> ⚠️ `timeline-dot-wrap` 안에 `timeline-dot` + `timeline-line` 구조. 마지막 항목은 `timeline-line` 없음.

---

## Pagination

```html
<div class="pagination">
  <button class="page-btn" disabled aria-label="Previous page">
    <svg>...</svg>
  </button>
  <button class="page-btn active">1</button>
  <button class="page-btn">2</button>
  <button class="page-btn">3</button>
  <button class="page-btn" aria-label="Next page">
    <svg>...</svg>
  </button>
</div>
```

---

## Progress Bars

```html
<div style="display:flex;justify-content:space-between;font-size:12px;color:var(--text-2);margin-bottom:4px">
  <span>Scan progress</span>
  <span style="font-family:'IBM Plex Mono',monospace;font-variant-numeric:tabular-nums">78%</span>
</div>
<div class="progress-bar">
  <div class="progress-bar-fill" style="width:78%;background:var(--blue)"></div>
</div>
```

---

## Skeleton Loading

```html
<div class="card">
  <div style="display:flex;gap:12px;align-items:flex-start">
    <div class="skeleton skeleton-avatar"></div>
    <div style="flex:1">
      <div class="skeleton skeleton-heading"></div>
      <div class="skeleton skeleton-text"></div>
      <div class="skeleton skeleton-text"></div>
      <div class="skeleton skeleton-text" style="width:40%"></div>
    </div>
  </div>
</div>
```

---

## Empty State

```html
<div class="card">
  <div class="empty-state">
    <svg>...</svg>
    <div class="empty-state-title">No results found</div>
    <div class="empty-state-text">검색 조건을 조정하거나 스캔을 실행하세요.</div>
    <button class="btn btn-primary btn-sm">New Scan</button>
  </div>
</div>
```

---

## Avatar Group

```html
<div class="avatar-group">
  <div class="post-avatar" style="background:rgba(59,143,255,0.2);color:var(--blue)">JK</div>
  <div class="post-avatar" style="background:rgba(139,92,246,0.2);color:var(--purple)">SL</div>
  <div class="post-avatar">+3</div>
</div>
```

---

## KPI Strip

```html
<div class="kpi-strip">
  <div class="kpi-card">
    <div class="kpi-bar crit"></div>
    <div class="kpi-label">Critical</div>
    <div class="kpi-value" style="color:var(--brand)">7</div>
    <div class="kpi-sub">+2 vs last week</div>
  </div>
  <div class="kpi-card">
    <div class="kpi-bar high"></div>
    <div class="kpi-label">High</div>
    <div class="kpi-value" style="color:var(--amber)">23</div>
    <div class="kpi-sub">-5 vs last week</div>
  </div>
  <!-- kpi-bar 변형: crit / high / med / low / info -->
</div>
```

---

## Panel

```html
<div class="panel">
  <div class="phead">
    <div>
      <div class="phead-t">제목</div>
      <div class="phead-m">부제목/메타</div>
    </div>
    <div class="phead-actions">
      <button class="icon-btn" aria-label="Refresh" data-tooltip="Refresh"><svg>...</svg></button>
      <button class="icon-btn" aria-label="Download" data-tooltip="Export CSV"><svg>...</svg></button>
    </div>
  </div>
  <div class="pbody">
    <!-- 내용 (테이블 등) -->
  </div>
</div>
```

---

## Filter Bar

```html
<div class="filter-bar">
  <div class="filter-search">
    <svg>...</svg>
    <input class="filter-input" type="text" placeholder="Search CVE, IP, hostname...">
  </div>
  <select class="filter-select" aria-label="Severity filter">
    <option>All Severity</option>
    <option>Critical</option>
  </select>
  <button class="btn btn-primary btn-sm">
    <svg>...</svg>
    Search
  </button>
</div>
```

---

## Status Tags

```html
<span class="status-tag open">
  <svg>...</svg>
  Open
</span>
<span class="status-tag in-progress">In Progress</span>
<span class="status-tag resolved">Resolved</span>
<span class="status-tag pending">Pending</span>
<span class="status-tag closed">Closed</span>
```

---

## CVE Summary Grid

```html
<div class="cve-summary-grid">
  <div class="cve-summary-cell">
    <div class="cve-score-big" style="color:var(--brand)">9.8</div>
    <div class="cve-cell-label">CVSS Score</div>
  </div>
  <div class="cve-summary-cell">
    <div class="cve-score-big" style="color:var(--red)">7</div>
    <div class="cve-cell-label">Critical</div>
  </div>
  <div class="cve-summary-cell">
    <div class="cve-score-big" style="color:var(--amber)">23</div>
    <div class="cve-cell-label">High</div>
  </div>
</div>
```

---

## Scan Status

```html
<div class="scan-status">
  <div class="scan-status-dot running"></div>
  <div class="scan-status-label">Full Network Scan</div>
  <div class="scan-meta">192.168.0.0/16</div>
  <div class="scan-meta">47% (1,892/4,024)</div>
  <span class="badge badge-teal">RUNNING</span>
</div>
<!-- scan-status-dot 변형: running / idle / error -->
```

---

## Donut Chart (CSS)

```html
<div class="donut-chart" style="background: conic-gradient(
  var(--brand) 0deg 25deg,
  var(--amber) 25deg 108deg,
  var(--cyan) 108deg 228deg,
  var(--teal) 228deg 360deg
);">
  <div class="donut-chart-inner">
    <div class="donut-chart-value">264</div>
    <div class="donut-chart-label">Total CVE</div>
  </div>
</div>
```

---

## Horizontal Bar Chart (CSS)

```html
<div class="card">
  <div class="bar-row">
    <span class="bar-label">Ubuntu 22.04</span>
    <div class="bar-track">
      <div class="bar-fill" style="width:72%;background:var(--blue)"></div>
    </div>
    <span class="bar-count">482</span>
  </div>
  <div class="bar-row">
    <span class="bar-label">RHEL 9.3</span>
    <div class="bar-track">
      <div class="bar-fill" style="width:48%;background:var(--purple)"></div>
    </div>
    <span class="bar-count">321</span>
  </div>
</div>
```

---

## Page Header + Control Buttons

```html
<div style="display:flex;align-items:flex-start;justify-content:space-between;flex-wrap:wrap;gap:12px">
  <div>
    <h2 class="page-hd">Vulnerability Scan</h2>
    <div class="page-hd-sub">Manage scan schedules and review results</div>
  </div>
  <div class="ctrl-group">
    <button class="ctrl-btn">
      <svg>...</svg>
      Export
    </button>
    <button class="ctrl-btn danger">
      <svg>...</svg>
      Delete Selected
    </button>
    <button class="btn btn-primary btn-sm">
      <svg>...</svg>
      New Scan
    </button>
  </div>
</div>
```
> ⚠️ 페이지 헤더 제목은 `h2.page-hd`, 부제목은 `.page-hd-sub`. 액션 버튼 그룹은 `.ctrl-group` + `.ctrl-btn`.

---

## Sidebar Navigation (V3.0)

```html
<div class="v3-sidebar">
  <div class="sb-section">Main</div>
  <button class="sb-nav active">
    <svg>...</svg>
    Dashboard
  </button>
  <button class="sb-nav">
    <svg>...</svg>
    Vulnerabilities
  </button>
  <div class="sb-section">Reports</div>
  <button class="sb-nav">
    <svg>...</svg>
    Security Audit
  </button>
</div>
```
> ⚠️ `sb-nav` (not `sidebar-item`), `sb-section` (not `sidebar-group-label`) — V3.0 클래스명 주의.