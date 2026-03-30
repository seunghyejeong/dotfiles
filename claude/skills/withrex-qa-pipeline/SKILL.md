---
name: withrex-qa-pipeline
description: >
  WITHREX 보안 스캐닝 제품의 QA 검증 파이프라인 스킬.
  네트워크 스캔, 취약점 탐지, 대시보드 UI, API, WebSocket, 인증 등 전체 기능을
  체계적으로 검증하는 워크플로우를 실행한다.

  다음 상황에서 즉시 사용해야 한다:
  - "테스트", "QA", "검증", "파이프라인", "체크", "추적", "개선" 언급 시
  - "스캔 테스트", "취약점 테스트", "UI 테스트" 요청 시
  - "버그 찾아", "동작 확인", "시나리오 검증" 요청 시
  - "체크리스트", "테스트 스크립트", "테스트 시나리오" 작성 요청 시
  - WITHREX의 어떤 기능이든 "확인해봐", "돌려봐", "검증해봐" 요청 시
  - 스캔모드, 취약점모드 관련 동작 확인 요청 시

  테스트 실행뿐 아니라 계획 수립, 버그 기록, 결과 정리까지 전체 QA 라이프사이클을 관리한다.
---

# WITHREX QA Pipeline

WITHREX 보안 스캐닝 제품의 체계적 QA 검증 파이프라인.

## 핵심 원칙

코드 분석으로 버그를 추정했더라도 **실 서버에서 실행해서 눈으로 확인할 때까지 "발견"이 아니다.** 코드 분석은 가설 수립이고, 실행이 검증이다. 마찬가지로 백엔드 데이터가 틀리면 프론트엔드 검증은 무의미하다 — 항상 Backend 먼저, Frontend 나중으로 진행한다.

1. **계획 먼저, 실행 나중** — plan을 세우고 시작한다
2. **기록은 실시간** — 발견 즉시 bug.md에 기록한다
3. **체크리스트 기반 진행** — 단계를 건너뛰지 않는다
4. **시나리오는 재사용 가능하게** — 테스트 스크립트로 남긴다
5. **Backend 먼저, Frontend 나중** — API/WS 응답 검증 후 렌더링 검증
6. **코드 분석 ≠ 검증** — 실행으로만 확인한다
7. **로그** — 신기능 추가 시 관련 로그를 남긴다

---

## 입력 단위 / 모드

| 입력 유형 | 예시 |
|----------|------|
| 단일 IP | `172.16.250.208` |
| 다중 IP | `172.16.250.208, 172.16.250.207` |
| 단일 대역 | `172.16.250.0/24` |
| 다중 대역 | `172.16.250.0/24, 192.168.140.0/24` |

| 모드 | 설명 |
|------|------|
| 스캔모드 | 포트, 서비스, OS 탐지 |
| 취약점모드 | CVE 매칭, exploit 검증 |

---

## 파이프라인 실행 절차

### Phase 0: 사전 확인

시작 전에 사용자에게 확인한다:
1. 사용할 agent (Playwright, Shell, API 직접 호출 등)
2. 테스트 대상 IP/대역
3. 스캔모드 / 취약점모드 / 둘 다

### Phase 1: 계획 수립

소스코드를 탐색하여 실제 시나리오를 도출하고 `.claude/plan/plan.md`에 기록한다.

탐색 순서 및 시나리오 도출 방법: `references/exploration_guide.md` 참조

탐색 완료 후 아래를 자체 점검한다:
- [ ] 모든 API 라우터/컨트롤러 파일 확인
- [ ] 모든 프론트엔드 라우트/페이지 확인
- [ ] WebSocket 이벤트 핸들러 전체 확인
- [ ] DB 모델/스키마 확인
- [ ] `tests/withrex_테스트_스크립트.md`와 대조하여 빠진 영역 없는지 확인
- [ ] 스캔모드/취약점모드 양쪽 커버 여부 확인

하나라도 미완이면 추가 탐색 후 계획을 보완한다.

### Phase 2: 체크리스트 생성

`.claude/checklist/checklist.md`에 단계별 체크리스트를 작성한다 (덮어쓰기).

```markdown
# QA Checklist - [날짜] [모드]

## Backend
- [ ] API 엔드포인트 응답 검증
- [ ] WebSocket 메시지 흐름 검증
- [ ] DB 데이터 정합성 검증

## Frontend
- [ ] 페이지 로딩 및 라우팅
- [ ] 실시간 데이터 업데이트
- [ ] 에러 상태 표시

## Integration
- [ ] E2E 스캔 → 결과 표시 흐름
- [ ] 모드 전환 시 동작
```

### Phase 3: 테스트 실행

체크리스트 항목을 순서대로 수행하고, 완료 시 `[x]`로 업데이트한다.
버그 발견 즉시 `.claude/bug/bug.md`에 추가 기록한다.

**실행 순서**: Backend(3a) → Frontend(3b) → 사용자 피드백 반영(3c)

실 서버 테스트 방법 (토큰 획득, 스캔 시작, WebSocket 모니터링):
`references/server_test_guide.md` 참조

**F5 새로고침 검증** (WITHREX 버그의 과반수가 이 경계면에서 발생):
`references/sync_verification.md` 참조

**중간 점검 규칙**:
- 카테고리 하나 완료 시 checklist.md를 다시 읽고 누락 항목 확인
- 대분류(Backend/Frontend/Integration) 전환 시 사용자에게 진행 상황 요약 보고
- 전체 완료 전 최종적으로 `[ ]` 항목이 없는지 확인

버그 기록 형식:
```markdown
## BUG-[번호]: [제목]
- **발견일시**: YYYY-MM-DD HH:MM
- **심각도**: Critical / Major / Minor
- **재현경로**: 
- **기대동작**: 
- **실제동작**: 
- **수정내역**: (수정한 경우)
- **검증상태**: 미검증 / 검증완료
```

### Phase 4: 수정 검증

`.claude/bug/bug.md`의 모든 수정 내역에 대해:
1. 수정 코드가 실제로 적용됐는지 확인 (`grep`)
2. **서버 재시작 후 실 테스트** — 코드 수정 ≠ 동작 수정
3. 사이드이펙트 없는지 확인
4. 검증상태 업데이트

### Phase 5: 결과 정리

`.claude/results/results.md`에 요약한다 (덮어쓰기):

```markdown
# QA Results Summary - [날짜]

## 실행 정보
- 모드: [스캔모드/취약점모드]
- 대상: [IP/대역]
- Agent: [사용한 agent]

## 결과 요약
- 총 테스트 항목: N개 / 통과: N개 / 실패: N개
- 발견된 버그: N개 (Critical: N, Major: N, Minor: N)

## 주요 발견사항
1. ...

## 미해결 이슈
1. ...
```

### Phase 6: 테스트 시나리오 기록

`tests/withrex_테스트_스크립트.md`에 시나리오를 추가/업데이트한다.
시나리오 형식 및 카테고리 코드: `references/scenario_guide.md` 참조

---

## 상태 추적

`.claude/state.md`를 매 Phase 전환, 매 카테고리 전환, 5개 항목마다 업데이트한다.

```markdown
# Pipeline State

## 현재 상태
- **현재 Phase**: Phase N
- **현재 카테고리**: Backend > API
- **현재 항목**: TC-API-005 응답코드 검증
- **마지막 업데이트**: YYYY-MM-DD HH:MM

## 진행률
- Phase 0 사전확인: ✅ / 🔄 / ⬜
- Phase 1 계획수립: ✅ / 🔄 / ⬜
- Phase 2 체크리스트: ✅ / 🔄 / ⬜
- Phase 3 테스트실행: 🔄 진행중 (12/34)
- Phase 4 수정검증: ⬜
- Phase 5 결과정리: ⬜
- Phase 6 시나리오기록: ⬜

## 컨텍스트 요약
- 모드: [스캔모드/취약점모드]
- 대상: [IP/대역]
- 발견된 버그: N건 (Critical N, Major N, Minor N)

## 다음 할 일
- [구체적인 다음 작업]
```

컨텍스트가 길어지거나 혼란이 생기면: `state.md` → `checklist.md` → `bug.md` 순으로 읽고 중단 지점부터 재개한다.

---

## 파일 관리

| 파일 | 경로 | 쓰기 방식 |
|------|------|-----------|
| 상태 추적 | `.claude/state.md` | 수시 업데이트 |
| 계획 | `.claude/plan/plan.md` | 덮어쓰기 |
| 체크리스트 | `.claude/checklist/checklist.md` | 덮어쓰기 |
| 버그 | `.claude/bug/bug.md` | 추가 기록 (파이프라인 시작 시 초기화) |
| 결과 | `.claude/results/results.md` | 덮어쓰기 |
| 테스트 스크립트 | `tests/withrex_테스트_스크립트.md` | 기존 유지 + 변경/추가 |

---

## References

- `references/exploration_guide.md` — 소스코드 탐색 순서 및 시나리오 도출 방법
- `references/server_test_guide.md` — 실 서버 테스트 방법 (curl, WebSocket 모니터링)
- `references/sync_verification.md` — F5 새로고침 / initial_sync 검증 체크리스트
- `references/scenario_guide.md` — 테스트 시나리오 형식 및 카테고리 코드