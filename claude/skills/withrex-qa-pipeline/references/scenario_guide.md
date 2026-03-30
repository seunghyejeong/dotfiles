# 테스트 시나리오 가이드

## 시나리오 작성 형식

```markdown
### TC-[카테고리]-[번호]: [시나리오명]
- **전제조건**: 
- **모드**: 스캔모드 / 취약점모드 / 공통
- **입력**: 
- **실행단계**:
  1. ...
  2. ...
- **기대결과**: 
- **자동화 가능 여부**: Yes / No (사유)
- **우선순위**: P0 / P1 / P2 / P3
```

---

## 카테고리 코드

| 대분류 | 코드 | 영역 |
|--------|------|------|
| Backend | API | REST API |
| Backend | WS | WebSocket |
| Backend | DB | 데이터베이스 |
| Backend | AUTH | 인증/권한 |
| Backend | SCAN | 스캔 엔진 |
| Backend | VULN | 취약점 엔진 |
| Frontend | UI | 화면 표시 |
| Frontend | UX | 사용자 흐름 |
| Frontend | RT | 실시간 업데이트 |
| Frontend | ERR | 에러 처리 |
| Frontend | VIS | 시각적 검증 (수동) |
| Cross | SYNC | 상태 동기화 (initial_sync, F5 복원, Backend↔Frontend 경계면) |
| Integration | E2E | 엔드투엔드 |
| Integration | MODE | 모드 전환 |
| Integration | INPUT | 입력 처리 |
| Integration | PERF | 성능 |

탐색 과정에서 위 카테고리에 맞지 않는 영역이 발견되면 새 카테고리를 추가한다.

---

## 우선순위 기준

| 등급 | 의미 | 기준 |
|------|------|------|
| P0 | 블로커 | 핵심 기능 불가 (스캔 안됨, 결과 안보임) |
| P1 | 크리티컬 | 주요 기능 오동작 (잘못된 결과, 데이터 유실) |
| P2 | 메이저 | 기능은 되지만 불편 (UI 깨짐, 느린 응답) |
| P3 | 마이너 | 사소한 이슈 (오타, 미세 정렬) |