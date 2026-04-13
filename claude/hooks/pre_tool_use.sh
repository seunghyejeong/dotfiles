#!/bin/bash
# Rex PreToolUse Hook
# Claude Code가 도구 실행 전 호출
# 용도: 코드 수정 도구 실행 시 ARCHITECTURE.md 참조 알림 출력

TOOL_NAME="$1"

# 코드 수정/실행 관련 도구일 때만 동작
case "$TOOL_NAME" in
  Edit|Write|MultiEdit|Bash)
    # 수정 대상 파일이 src/engine 또는 src/app/scan 이면 경고
    INPUT="$2"
    if echo "$INPUT" | grep -qE "(src/engine|src/app/scan|pipeline|merge_collector|vuln_worker|web_vuln_worker|service_detector|probe\.py|portscan\.py|ml_analysis\.py)"; then
      echo "⚠️  [ARCH HOOK] 핵심 엔진 파일 수정 감지"
      echo "   → ARCHITECTURE.md 섹션 3 (실행 경계) 확인했는지 점검"
      echo "   → 영향 범위 선언 후 수정할 것"
    fi
    ;;
esac

exit 0