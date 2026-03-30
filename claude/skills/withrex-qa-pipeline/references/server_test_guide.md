# 실 서버 테스트 가이드

> 코드 분석으로 버그를 추정했더라도 반드시 아래 절차로 실제 확인한다.
> 코드에 수정을 가했어도, 서버를 재시작하고 실제로 돌려서 눈으로 확인해야 "수정 완료"다.

## 서버 시작/재시작

```bash
systemctl restart withrex.service
```

## 인증 토큰 획득

```bash
TOKEN=$(curl -s http://127.0.0.1:9091/api/oauth/token \
  -H 'Content-Type: application/json' \
  -d '{"username":"admin","password":"admin123","grant_type":"password"}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")
```

## 스캔 시작 (API 직접 호출)

```bash
curl -s http://127.0.0.1:9091/api/scan/start \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"target_ip":"172.16.250.208","scan_mode":"standard","enable_vuln_scan":true}'
```

## WebSocket 모니터링

```python
import asyncio, json, websockets

async def monitor():
    uri = f'ws://127.0.0.1:9091/ws?token={TOKEN}'
    async with websockets.connect(uri) as ws:
        while True:
            msg = await asyncio.wait_for(ws.recv(), timeout=300)
            data = json.loads(msg)
            print(data)  # type별 필터링하여 핵심 이벤트만 출력

asyncio.run(monitor())
```

## 경계면 검증 순서

**Backend 먼저, Frontend 나중** 원칙의 구체적 절차:

```
Phase 3a: Backend 데이터 검증
├── API 응답 구조/값 확인
├── WS 이벤트 순서/페이로드 확인
├── initial_sync 필드별 확인
└── ✅ 백엔드 데이터 정상 확인 후 다음으로

Phase 3b: Frontend 렌더링 검증
├── initial_sync 데이터 → DOM 매핑 확인
├── 이벤트 핸들러 로직 확인 (코드 + Playwright)
├── F5 새로고침 후 UI 상태 확인
└── ★ 백엔드 데이터는 정상인데 UI가 틀리면 = 프론트엔드 버그

Phase 3c: 사용자 피드백 반영
└── "이건 안 됐어" → 즉시 3a/3b 반복
```

## 자동화 vs 수동 판단 기준

**자동화 (Claude CLI + Playwright/Shell)**:
- API 응답값 검증
- DB 데이터 존재/값 확인
- WebSocket 메시지 수신 확인
- DOM 요소 존재/텍스트 확인
- 폼 입력 → 제출 → 결과 흐름
- 스크린샷 캡처 (Visual Regression baseline)

**수동 확인 (사람이 봐야 함)**:
- 애니메이션/전환 효과 품질
- 색상/폰트/간격 디자인 의도 일치
- 직관성/사용성 판단
- 반응형 레이아웃 미세 조정
- 스크린샷 diff 리뷰