#!/bin/bash
# Rex Stop Hook
# 세션 종료 전 실행

# ARCHITECTURE.md Changelog 마지막 줄이 "최초 작성" 이면 업데이트 안 된 것
if [ -f "ARCHITECTURE.md" ]; then
  LAST=$(grep -A1 "Changelog" ARCHITECTURE.md | tail -1)
  if echo "$LAST" | grep -q "최초 작성\|최초"; then
    echo "📋 [ARCH HOOK] 이번 세션 변경사항을 ARCHITECTURE.md Changelog에 기록했는지 확인하세요"
  fi
fi

exit 0