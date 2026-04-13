#!/bin/bash
# Python 프로젝트에서만 동작
[ -f pyproject.toml ] || exit 0
command -v ruff >/dev/null 2>&1 || exit 0

OUTPUT=$(ruff check . --fix 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
  exit 0
fi

echo "❌ Lint 실패:"
echo "$OUTPUT" | grep -E "\.(py):[0-9]+" | head -20
exit 1
