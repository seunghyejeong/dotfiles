#!/bin/bash
# .claude/hooks/on-notification.sh
# Claude가 사용자 입력을 기다릴 때 실행됨

INPUT=$(cat)
NOTIFICATION_TYPE=$(echo "$INPUT" | jq -r '.type // "unknown"' 2>/dev/null)

case "$NOTIFICATION_TYPE" in
    "permission_prompt")
        notify-send "⚠️ Claude Code" "권한 승인 필요" --urgency=critical 2>/dev/null
        ;;
    "idle_prompt")
        notify-send "💤 Claude Code" "입력 대기 중 - 확인해주세요" --urgency=normal 2>/dev/null
        ;;
    *)
        notify-send "🔔 Claude Code" "확인이 필요합니다" --urgency=normal 2>/dev/null
        ;;
esac