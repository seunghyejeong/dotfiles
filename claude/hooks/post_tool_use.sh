#!/bin/bash
# Rex PostToolUse Hook
# 코드 수정 완료 후 Changelog 업데이트 리마인더

TOOL_NAME="$1"
EXIT_CODE="$2"

if [ "$EXIT_CODE" = "0" ]; then
  case "$TOOL_NAME" in
    Edit|Write|MultiEdit)
      INPUT="$3"
      if echo "$INPUT" | grep -qE "(src/engine|src/app/scan|pipeline|merge_collector|vuln_worker|service_detector|probe\.py|portscan\.py)"; then
        echo "✅ [ARCH HOOK] 수정 완료 — ARCHITECTURE.md Changelog 업데이트 필요"
        echo "   날짜 | 변경 내용 | 영향 모듈"
      fi
      ;;
  esac
fi

exit 0