#!/bin/bash

set -e

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Claude Code 設定セットアップスクリプト
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DOTFILES_DIR="${ZDOTDIR:-$HOME}/dotfiles"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_SRC="$DOTFILES_DIR/claude"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🤖 Claude Code 設定セットアップ"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 1. ~/.claude/ ディレクトリの作成
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [[ -d "$CLAUDE_DIR" ]]; then
    echo "✅ ~/.claude/ ディレクトリは既に存在します"
else
    echo "📁 ~/.claude/ ディレクトリを作成中..."
    mkdir -p "$CLAUDE_DIR"
    echo "✅ ~/.claude/ ディレクトリを作成しました"
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 2. シンボリックリンクの作成
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "🔗 シンボリックリンクを作成中..."

# settings.json
if [[ -L "$CLAUDE_DIR/settings.json" ]]; then
    echo "✅ settings.json は既にシンボリックリンクです"
else
    if [[ -f "$CLAUDE_DIR/settings.json" ]]; then
        BACKUP="$CLAUDE_DIR/settings.json.backup.$(date +%Y%m%d%H%M%S)"
        echo "📋 既存の settings.json をバックアップ: $BACKUP"
        mv "$CLAUDE_DIR/settings.json" "$BACKUP"
    fi
    ln -snfv "$CLAUDE_SRC/settings.json" "$CLAUDE_DIR/settings.json"
fi

# statusline-command.sh
if [[ -L "$CLAUDE_DIR/statusline-command.sh" ]]; then
    echo "✅ statusline-command.sh は既にシンボリックリンクです"
else
    if [[ -f "$CLAUDE_DIR/statusline-command.sh" ]]; then
        BACKUP="$CLAUDE_DIR/statusline-command.sh.backup.$(date +%Y%m%d%H%M%S)"
        echo "📋 既存の statusline-command.sh をバックアップ: $BACKUP"
        mv "$CLAUDE_DIR/statusline-command.sh" "$BACKUP"
    fi
    ln -snfv "$CLAUDE_SRC/statusline-command.sh" "$CLAUDE_DIR/statusline-command.sh"
fi

# skills/ ディレクトリ
if [[ -L "$CLAUDE_DIR/skills" ]]; then
    echo "✅ skills/ は既にシンボリックリンクです"
else
    if [[ -d "$CLAUDE_DIR/skills" ]]; then
        BACKUP="$CLAUDE_DIR/skills.backup.$(date +%Y%m%d%H%M%S)"
        echo "📋 既存の skills/ をバックアップ: $BACKUP"
        mv "$CLAUDE_DIR/skills" "$BACKUP"
    fi
    ln -snfv "$CLAUDE_SRC/skills" "$CLAUDE_DIR/skills"
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 3. 実行権限の付与
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

chmod +x "$CLAUDE_SRC/statusline-command.sh"
echo "✅ statusline-command.sh に実行権限を付与しました"

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 4. 完了メッセージ
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Claude Code 設定のセットアップ完了！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
