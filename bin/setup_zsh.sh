#!/bin/bash

set -e

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Oh My Zsh + Powerlevel10k セットアップスクリプト
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DOTFILES_DIR="${ZDOTDIR:-$HOME}/dotfiles"
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$OH_MY_ZSH_DIR/custom"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Oh My Zsh + Powerlevel10k セットアップ"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 1. Oh My Zsh のインストール
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [[ -d "$OH_MY_ZSH_DIR" ]]; then
    echo "✅ Oh My Zsh は既にインストールされています: $OH_MY_ZSH_DIR"
else
    echo "📦 Oh My Zsh をインストール中..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ Oh My Zsh のインストール完了"
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 2. Powerlevel10k のインストール
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"

if [[ -d "$P10K_DIR" ]]; then
    echo "✅ Powerlevel10k は既にインストールされています: $P10K_DIR"
else
    echo "📦 Powerlevel10k をインストール中..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    echo "✅ Powerlevel10k のインストール完了"
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 3. プラグインのインストール
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# zsh-autosuggestions
AUTOSUGGESTIONS_DIR="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
if [[ -d "$AUTOSUGGESTIONS_DIR" ]]; then
    echo "✅ zsh-autosuggestions は既にインストールされています"
else
    echo "📦 zsh-autosuggestions をインストール中..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
    echo "✅ zsh-autosuggestions のインストール完了"
fi

# zsh-syntax-highlighting
SYNTAX_HIGHLIGHTING_DIR="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
if [[ -d "$SYNTAX_HIGHLIGHTING_DIR" ]]; then
    echo "✅ zsh-syntax-highlighting は既にインストールされています"
else
    echo "📦 zsh-syntax-highlighting をインストール中..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAX_HIGHLIGHTING_DIR"
    echo "✅ zsh-syntax-highlighting のインストール完了"
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 4. シンボリックリンクの作成
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "🔗 シンボリックリンクを作成中..."

# .zshrcのバックアップ（Oh My Zshインストール時に作成される場合がある）
if [[ -f "$HOME/.zshrc" ]] && [[ ! -L "$HOME/.zshrc" ]]; then
    echo "📋 既存の .zshrc をバックアップ: ~/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
fi

# dotfiles からシンボリックリンクを作成
ln -snfv "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -snfv "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
ln -snfv "$DOTFILES_DIR/.zprofile" "$HOME/.zprofile"
ln -snfv "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
ln -snfv "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

echo "✅ シンボリックリンクの作成完了"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 5. マシン固有の設定ファイル (.zshrc_local) の作成
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [[ -f "$HOME/.zshrc_local" ]]; then
    echo "✅ .zshrc_local は既に存在します: ~/.zshrc_local"
else
    echo "📝 マシン固有の設定ファイルを作成中..."
    cp "$DOTFILES_DIR/.zshrc_local.example" "$HOME/.zshrc_local"
    echo "✅ .zshrc_local を作成しました: ~/.zshrc_local"
    echo "   💡 必要に応じて ~/.zshrc_local を編集してください"
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 6. 完了メッセージ
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ セットアップ完了！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 次のステップ："
echo "  1. シェルを再起動: exec zsh"
echo "  2. Powerlevel10k の設定を確認: p10k configure（必要に応じて）"
echo ""
echo "💡 ヒント："
echo "  - Oh My Zsh の更新: omz update"
echo "  - プラグインの更新: cd ~/.oh-my-zsh/custom/plugins/<plugin> && git pull"
echo ""
