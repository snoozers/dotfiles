#!/bin/zsh

set -e

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 外部ツールセットアップスクリプト
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 外部ツールセットアップ"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 1. OS検出
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

OS_TYPE=$(uname -s)
echo "🖥️  検出されたOS: $OS_TYPE"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 2. パッケージマネージャーの検出・選択
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PACKAGE_MANAGER=""

if [[ "$OS_TYPE" == "Darwin" ]]; then
    # macOS の場合
    if command -v brew &> /dev/null; then
        PACKAGE_MANAGER="brew"
        echo "✅ Homebrew が見つかりました"
    else
        echo "⚠️  警告: Homebrew がインストールされていません"
        echo ""
        echo "Homebrewのインストール方法："
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        echo ""
        echo "外部ツールを手動でインストールするか、Homebrewをインストール後に"
        echo "このスクリプトを再実行してください。"
        echo ""
        exit 1
    fi
else
    # Linux の場合
    if command -v brew &> /dev/null; then
        PACKAGE_MANAGER="brew"
        echo "✅ Homebrew が見つかりました"
    else
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "🔧 パッケージマネージャーの選択"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "外部ツール（fzf、ripgrep）のインストール方法を選択してください："
        echo ""
        echo "  1) apt-get を使用（推奨・高速）"
        echo "     - システム標準のパッケージマネージャー"
        echo "     - sudo権限が必要"
        echo ""
        echo "  2) Homebrew を使用"
        echo "     - macOSと同じパッケージマネージャー"
        echo "     - 最新版のツールを使用可能"
        echo "     - Homebrewのインストールが必要（時間がかかります）"
        echo ""
        echo "  3) スキップ（後で手動インストール）"
        echo ""

        # ユーザー入力を受け取る
        read "choice?選択してください (1/2/3): "
        echo ""

        case $choice in
            1)
                if command -v apt-get &> /dev/null; then
                    PACKAGE_MANAGER="apt"
                    echo "✅ apt-get を使用します"
                else
                    echo "❌ エラー: apt-get が見つかりません"
                    echo "   別のパッケージマネージャーを選択するか、手動でインストールしてください。"
                    exit 1
                fi
                ;;
            2)
                echo "📦 Homebrew をインストール中..."
                echo "   （インストールには数分かかる場合があります）"
                echo ""
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

                # Homebrewのパスを設定
                if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
                    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
                elif [[ -d "$HOME/.linuxbrew" ]]; then
                    eval "$($HOME/.linuxbrew/bin/brew shellenv)"
                fi

                if command -v brew &> /dev/null; then
                    PACKAGE_MANAGER="brew"
                    echo "✅ Homebrew のインストール完了"
                else
                    echo "❌ エラー: Homebrewのインストールに失敗しました"
                    exit 1
                fi
                ;;
            3)
                echo "⏭️  外部ツールのインストールをスキップします"
                echo ""
                echo "📝 手動でインストールする場合："
                echo "   README.md のトラブルシューティングセクションを参照してください"
                echo ""
                exit 0
                ;;
            *)
                echo "❌ エラー: 無効な選択です"
                exit 1
                ;;
        esac
    fi
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 3. fzf のインストール（必須）
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 fzf のインストール（必須）"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if command -v fzf &> /dev/null; then
    echo "✅ fzf は既にインストールされています"
    fzf --version
else
    echo "📦 fzf をインストール中..."

    if [[ "$PACKAGE_MANAGER" == "brew" ]]; then
        brew install fzf
    elif [[ "$PACKAGE_MANAGER" == "apt" ]]; then
        sudo apt-get update
        sudo apt-get install -y fzf
    fi

    if command -v fzf &> /dev/null; then
        echo "✅ fzf のインストール完了"
        fzf --version
    else
        echo "❌ エラー: fzf のインストールに失敗しました"
        echo "   fzfはVim環境で必須のツールです。"
        echo "   手動でインストールしてください: https://github.com/junegunn/fzf"
        exit 1
    fi
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 4. ripgrep のインストール（推奨）
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 ripgrep のインストール（推奨）"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if command -v rg &> /dev/null; then
    echo "✅ ripgrep は既にインストールされています"
    rg --version | head -n 1
else
    echo "📦 ripgrep をインストール中..."

    if [[ "$PACKAGE_MANAGER" == "brew" ]]; then
        brew install ripgrep
    elif [[ "$PACKAGE_MANAGER" == "apt" ]]; then
        sudo apt-get install -y ripgrep
    fi

    if command -v rg &> /dev/null; then
        echo "✅ ripgrep のインストール完了"
        rg --version | head -n 1
    else
        echo "⚠️  警告: ripgrep のインストールに失敗しました"
        echo "   ripgrepは推奨ツールですが、なくても動作します。"
        echo "   手動でインストールする場合: https://github.com/BurntSushi/ripgrep"
    fi
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 5. 完了メッセージ
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ 外部ツールのセットアップ完了！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
