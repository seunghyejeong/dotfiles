# F5 새로고침 / initial_sync 검증

> WITHREX 버그의 **과반수가 이 경계면**에서 발생한다.
> F5 새로고침 = WS 재연결 → initial_sync 수신 → 프론트엔드 상태 복원.

## 테스트 절차

```
1. 스캔 시작 (API)
2. WS로 완료 이벤트 대기 (vuln_scan_done 등)
3. WS 연결 끊기
4. 새 WS 연결 → initial_sync 캡처 (= F5 시뮬레이션)
5. initial_sync 필드별 검증
```

## initial_sync 필수 검증 항목

### 상태 플래그
- [ ] `is_scanning: false` (완료 시)
- [ ] `vuln_scan_completed: true` (vuln 완료 시)
- [ ] `vuln_running: false` (vuln 완료 시)

### Progress
- [ ] `progress.overall: 100` (완전 완료 시)
- [ ] `stages.vuln.done == stages.vuln.total`
- [ ] `subjobs[].progress.phases[vuln].finished == true`

### Config 복원
- [ ] `config.scan_mode`: 올바른 모드값
- [ ] `config.enable_vuln_scan`: 스캔 시 설정한 값
- [ ] `config.impact_mode`: null이면 프론트에서 기본값 적용 필요
- [ ] `config.elapsed_sec`: 총 소요시간

### 데이터 복원
- [ ] `realtime_results`: IP 결과 배열 (빈 배열 아님)
- [ ] `logs`: 로그 문자열 배열 (vuln 시작/완료 포함)
- [ ] `subjobs`: 상태/진행률 포함

### 경계면 변환 확인
- [ ] Backend alias(`standard`/`half`) → Frontend canonical(`top1k`/`top5k`) 매핑
- [ ] Backend dict 로그 → `state.logs` string 변환
- [ ] Backend phase `finished` → Frontend stage-cell class 변환