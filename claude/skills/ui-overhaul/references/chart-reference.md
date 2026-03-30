# chart-reference.html — 레퍼런스

> 실제 파일: `chart-reference.html` (읽기 전용, 수정 금지)
> 역할: Chart.js 4.5 기반 차트 스타일 기준
> ⚠️ 차트 구현 시 반드시 아래 공통 설정 적용

---

## 1. 라이브러리

```html
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.5.1/dist/chart.umd.min.js"></script>
```

---

## 2. 색상 토큰

```js
const COLORS = {
  acc:   '#3b8fff',   // 기본 강조 (blue)
  crit:  '#ff3858',   // Critical
  high:  '#ffa21e',   // High
  med:   '#18b0ff',   // Medium
  low:   '#00dc7e',   // Low
  brand: '#ff5a10',   // Brand/긴급
  txt3:  '#6a7fa0',   // 축 레이블
  bd:    '#1a2844',   // 격자선/테두리
  s1:    '#0a0f1c',   // 툴팁 배경
};

// severity 배열 (항상 이 순서)
const SEV_COLORS = ['#ff3858', '#ffa21e', '#18b0ff', '#00dc7e'];
const SEV_BG     = ['rgba(255,56,88,.14)', 'rgba(255,162,30,.14)', 'rgba(24,176,255,.14)', 'rgba(0,220,126,.14)'];
```

---

## 3. 공통 설정 (모든 차트에 적용)

```js
// 기본값 설정
Chart.defaults.font.family = "'IBM Plex Sans', system-ui, sans-serif";
Chart.defaults.font.size = 11;
Chart.defaults.color = '#6a7fa0';      // --txt3
Chart.defaults.borderColor = '#1a2844'; // --bd

// 반응형 (필수)
options: { responsive: true, maintainAspectRatio: true }
```

### 툴팁 (통일 적용)
```js
plugins: {
  tooltip: {
    backgroundColor: '#0a0f1c',    // --s1
    titleColor: '#f2f6ff',         // --txt
    bodyColor: '#b0c2dc',          // --txt2
    borderColor: '#1a2844',        // --bd
    borderWidth: 1,
    cornerRadius: 6,
    padding: 10,
    titleFont: { weight: '600', size: 12 },
    bodyFont: { family: "'IBM Plex Mono', monospace", size: 11 },
    displayColors: true,
    boxPadding: 4,
  }
}
```

### 격자선
```js
grid: { color: '#1a2844', drawBorder: false }
```

### 축 눈금
```js
ticks: { color: '#6a7fa0', font: { size: 10, family: "'IBM Plex Mono', monospace" } }
```

### 범례
```js
legend: {
  labels: {
    color: '#b0c2dc',
    font: { size: 11 },
    boxWidth: 12, boxHeight: 12,
    borderRadius: 3,
    padding: 12,
    usePointStyle: true,
    pointStyle: 'rectRounded'
  }
}
```

---

## 4. 차트 타입별 기준

### Bar (수직)
```js
{
  type: 'bar',
  datasets: [{
    backgroundColor: COLORS.crit,  // or SEV_COLORS 배열
    borderRadius: 4,
    borderSkipped: false,
    barPercentage: 0.6,
  }],
  options: {
    scales: {
      x: { grid: { display: false }, ticks: tickStyle() },
      y: { grid: gridStyle(), ticks: tickStyle(), beginAtZero: true }
    }
  }
}
```

### Bar (수평)
```js
// indexAxis: 'y' 추가, x/y scale 반전
options: { indexAxis: 'y', ... }
```

### Bar (스택)
```js
scales: {
  x: { stacked: true, grid: { display: false } },
  y: { stacked: true, grid: gridStyle() }
}
// borderRadius: 최상단 세그먼트만 { topLeft: 4, topRight: 4 }
```

### Line (기본)
```js
datasets: [{
  borderColor: COLORS.acc,
  borderWidth: 2,
  pointRadius: 4,
  pointHoverRadius: 6,
  pointBackgroundColor: COLORS.acc,
  pointBorderColor: COLORS.s1,  // 점 테두리 = 배경색 (테두리 효과)
  pointBorderWidth: 2,
}]
```

### Line (부드러운 곡선)
```js
// tension: 0.4 추가
```

### Area Chart
```js
// fill: true, backgroundColor: 'rgba(59,143,255,.12)' 추가
tension: 0.35, fill: true
```

### Doughnut
```js
{
  type: 'doughnut',
  datasets: [{
    data: sevData,
    backgroundColor: SEV_COLORS,
    borderColor: COLORS.s1,  // 중요: 섹터 구분선
    borderWidth: 2,
    hoverOffset: 6,
  }],
  options: { cutout: '68%' }
}
```

### Half Doughnut (게이지)
```js
{
  type: 'doughnut',
  datasets: [{
    data: [score, 100 - score],
    backgroundColor: [COLORS.acc, COLORS.bd],
    borderWidth: 0,
    circumference: 180,
    rotation: 270,
  }],
  options: { cutout: '75%' }
}
// 중앙 텍스트는 afterDraw 플러그인으로
```

### Radar
```js
{
  type: 'radar',
  datasets: [{
    borderColor: COLORS.acc,
    backgroundColor: 'rgba(59,143,255,.12)',
    borderDash: [4, 4],  // 목표선에만
    pointBackgroundColor: COLORS.acc,
    pointBorderColor: COLORS.s1,
    pointBorderWidth: 2,
  }],
  options: {
    scales: {
      r: {
        beginAtZero: true, max: 100,
        ticks: { stepSize: 25, backdropColor: 'transparent' },
        grid: { color: COLORS.bd },
        angleLines: { color: COLORS.bd },
        pointLabels: { color: '#b0c2dc', font: { size: 11 } }
      }
    }
  }
}
```

### Scatter
```js
{
  type: 'scatter',
  datasets: [
    { label: 'Critical', data: [{x, y}, ...], backgroundColor: COLORS.crit, pointRadius: 5 },
    ...
  ],
  options: {
    scales: {
      x: { title: { display: true, text: 'CVSS Score', color: COLORS.txt3, font: { size: 10 } } },
      y: { title: { display: true, text: 'EPSS Score', ... } }
    }
  }
}
```

### Bubble
```js
{
  type: 'bubble',
  datasets: [{
    data: [{x, y, r}, ...],  // r = 버블 반지름
    backgroundColor: 'rgba(255,56,88,.45)',
    borderColor: COLORS.crit,
    borderWidth: 1,
  }]
}
```

### Mixed (Bar + Line 이중축)
```js
{
  type: 'bar',
  datasets: [
    { type: 'bar',  yAxisID: 'y',  order: 2, ... },
    { type: 'line', yAxisID: 'y1', order: 1, ... },
  ],
  options: {
    scales: {
      y:  { position: 'left',  title: { display: true, text: '건수' } },
      y1: { position: 'right', grid: { display: false },
            ticks: { callback: v => v + '%' }, min: 0, max: 120 }
    }
  }
}
```

---

## 5. 라이트 모드 대응

라이트 모드 토큰:
```js
// 라이트 모드 시 덮어씌울 값
txt3: '#506278', bd: '#bcc5d5', s1: '#ffffff',
acc: '#1a6dff', crit: '#d91530', high: '#c76a00',
med: '#0072b5', low: '#008a55', brand: '#d84a08'
```

테마 변경 시 모든 차트 `chart.update('none')` 호출 (애니메이션 없이 갱신).

---

## 6. 사용 규칙

1. **Chart.js 버전 고정**: `4.5.1` — 업그레이드 금지
2. **모든 차트**: `responsive: true, maintainAspectRatio: true` 필수
3. **점 테두리**: line/scatter 계열에서 `pointBorderColor`는 항상 배경색(s1)으로 → 점이 차트 배경에 붙어 보이는 효과
4. **툴팁**: 위 공통 tooltipStyle() 그대로 사용, 커스텀 금지
5. **severity 순서**: Critical → High → Medium → Low (항상 이 순서)
6. **격자선**: X축은 `grid: { display: false }`, Y축만 격자 표시
7. **범례 없는 단일 데이터셋**: `legend: { display: false }`