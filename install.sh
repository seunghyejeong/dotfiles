#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_SRC="$DOTFILES_DIR/claude"
CLAUDE_DST="$HOME/.claude"

echo "🔧 dotfiles 설치 시작..."
echo "   소스: $CLAUDE_SRC"
echo "   대상: $CLAUDE_DST"
echo ""

link_item() {
  local src="$1"
  local dst="$2"
  local label="$3"

  if [ -L "$dst" ]; then
    echo "  이미 연결됨: $label"
  elif [ -e "$dst" ]; then
    echo "  백업: $label → $label.bak"
    mv "$dst" "$dst.bak"
    ln -s "$src" "$dst"
    echo "  ✅ 연결: $label"
  else
    ln -s "$src" "$dst"
    echo "  ✅ 연결: $label"
  fi
}

link_dir() {
  local src_dir="$1"
  local dst_dir="$2"
  local label="$3"

  if [ ! -d "$src_dir" ]; then
    echo "  ⚠️  $label 폴더 없음, 스킵"
    return
  fi

  mkdir -p "$dst_dir"

  for src in "$src_dir"/*/; do
    [ -d "$src" ] || continue
    name=$(basename "$src")
    link_item "$src" "$dst_dir/$name" "$label/$name"
  done

  for src in "$src_dir"/*; do
    [ -f "$src" ] || continue
    name=$(basename "$src")
    link_item "$src" "$dst_dir/$name" "$label/$name"
  done
}

mkdir -p "$CLAUDE_DST"
link_dir "$CLAUDE_SRC/agents" "$CLAUDE_DST/agents" "agents"
link_dir "$CLAUDE_SRC/skills" "$CLAUDE_DST/skills" "skills"
link_dir "$CLAUDE_SRC/hooks"  "$CLAUDE_DST/hooks"  "hooks"

# settings.json (hook 등록 포함) — 머신별 커스텀이 필요하면 백업 후 재링크됨
link_item "$DOTFILES_DIR/settings.json" "$CLAUDE_DST/settings.json" "settings.json"

echo ""
echo "✅ 설치 완료! Claude Code 재시작 후 /agents 로 확인하세요."
