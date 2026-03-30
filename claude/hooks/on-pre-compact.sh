#!/bin/bash
# .claude/hooks/on-pre-compact.sh
# 컨텍스트 압축(compact) 전에 실행됨

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
STATE_FILE="$PROJECT_ROOT/.claude/state.md"

if [ -f "$STATE_FILE" ]; then
    # 현재 상태를 stdout으로 출력 → compact 후에도 transcript에 남음
    echo "=== 파이프라인 상태 백업 (compact 전) ==="
    cat "$STATE_FILE"
    echo "=== 백업 끝 ==="

    notify-send "📦 Claude Code" "컨텍스트 압축 중 - 상태 백업 완료" --urgency=low 2>/dev/null
fi