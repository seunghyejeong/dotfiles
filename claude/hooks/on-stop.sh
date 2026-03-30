#!/bin/bash
# .claude/hooks/on-stop.sh
# Claude Code가 응답을 완료할 때마다 실행됨

# 프로젝트 루트 기준으로 절대 경로 사용 (CWD 변경에 안전)
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
STATE_FILE="$PROJECT_ROOT/.claude/state.md"
CHECKLIST_FILE="$PROJECT_ROOT/.claude/checklist/checklist.md"
BUG_FILE="$PROJECT_ROOT/.claude/bug/bug.md"

# state.md 존재 여부 확인
if [ ! -f "$STATE_FILE" ]; then
    notify-send "🔧 Claude Code" "파이프라인 상태 파일 없음 - state.md 생성 필요" --urgency=critical 2>/dev/null
    exit 0
fi

# 현재 Phase 추출
CURRENT_PHASE=$(grep "현재 Phase" "$STATE_FILE" | head -1 | sed 's/.*: //')

# 체크리스트에서 진행률 계산
if [ -f "$CHECKLIST_FILE" ]; then
    TOTAL=$(grep -c "\- \[" "$CHECKLIST_FILE" 2>/dev/null || echo "0")
    DONE=$(grep -c "\- \[x\]" "$CHECKLIST_FILE" 2>/dev/null || echo "0")
    REMAINING=$((TOTAL - DONE))
else
    TOTAL=0
    DONE=0
    REMAINING=0
fi

# 버그 수 계산
if [ -f "$BUG_FILE" ]; then
    BUG_COUNT=$(grep -c "^## BUG-" "$BUG_FILE" 2>/dev/null || echo "0")
else
    BUG_COUNT=0
fi

# 알림 전송
notify-send "🔍 WITHREX QA" \
    "Phase: ${CURRENT_PHASE}\n진행: ${DONE}/${TOTAL} (남은 항목: ${REMAINING})\n버그: ${BUG_COUNT}건" \
    --urgency=normal 2>/dev/null

# stdout으로 상태를 출력하면 Claude의 다음 턴 transcript에 포함됨
echo "📍 파이프라인 상태 체크포인트"
echo "  현재: ${CURRENT_PHASE}"
echo "  진행률: ${DONE}/${TOTAL} (남은 항목: ${REMAINING}개)"
echo "  발견된 버그: ${BUG_COUNT}건"

if [ "$REMAINING" -eq 0 ] && [ "$TOTAL" -gt 0 ]; then
    echo "  ✅ 현재 체크리스트 모든 항목 완료 - 다음 Phase로 이동 가능"
fi