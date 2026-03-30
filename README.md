# dotfiles

바미의 Claude Code 설정 모음.

## 구조

```
~/.dotfiles/
├── install.sh
├── README.md
└── claude/
    ├── agents/       ← planner, generator, evaluator
    ├── skills/       ← withrex-feature-dev, qa-pipeline 등
    └── hooks/        ← on-stop, on-notification, on-pre-compact
```

## 새 서버에서 설치

```bash
git clone https://github.com/{유저명}/dotfiles ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

## 업데이트

```bash
# 설정 수정 후
cd ~/.dotfiles
git add . && git commit -m "update"
git push

# 다른 서버에서
cd ~/.dotfiles && git pull
```

## 사용법

Claude Code에서 자연어로:

```
VNC 기본 패스워드 체크 기능 추가해줘
```

→ planner → (확인) → generator → evaluator 자동 실행
