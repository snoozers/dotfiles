#!/bin/bash

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
    # Homebrewの存在に関わらず、常に選択プロンプトを表示

    # 既存のパッケージマネージャーを検出
    HAS_BREW=false
    HAS_APT=false

    if command -v brew &> /dev/null; then
        HAS_BREW=true
    fi

    if command -v apt-get &> /dev/null; then
        HAS_APT=true
    fi

    # 選択プロンプトを表示（常に）
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔧 パッケージマネージャーの選択"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "外部ツール（fzf、ripgrep）のインストール方法を選択してください："
    echo ""
    echo "  1) apt-get を使用"
    echo "     - システム標準のパッケージマネージャー"
    echo "     - sudo権限が必要"
    echo "     - 高速にインストール可能"
    if [[ "$HAS_APT" == true ]]; then
        echo "     ✅ 利用可能"
    else
        echo "     ⚠️  利用不可"
    fi
    echo ""
    echo "  2) Homebrew を使用（推奨）"
    echo "     - macOSと同じパッケージマネージャー"
    echo "     - 最新版のツールを使用可能"
    echo "     - クロスプラットフォームで一貫性がある"
    if [[ "$HAS_BREW" == true ]]; then
        echo "     ✅ 既にインストール済み"
    else
        echo "     Homebrewのインストールが必要（数分かかります）"
    fi
    echo ""
    echo "  3) スキップ（後で手動インストール）"
    echo ""

    # ユーザー入力を受け取る
    read -p "選択してください (1/2/3): " choice
    echo ""

    case $choice in
        1)
            if [[ "$HAS_APT" == true ]]; then
                PACKAGE_MANAGER="apt"
                echo "✅ apt-get を使用します"
            else
                echo "❌ エラー: apt-get が見つかりません"
                echo "   別のパッケージマネージャーを選択してください。"
                exit 1
            fi
            ;;
        2)
            if [[ "$HAS_BREW" == true ]]; then
                PACKAGE_MANAGER="brew"
                echo "✅ 既存のHomebrew を使用します"
            else
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

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 3. zsh のインストール（必須）
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 zsh のインストール（必須）"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if command -v zsh &> /dev/null; then
    echo "✅ zsh は既にインストールされています"
    zsh --version

    # バージョンチェック（5.0以降を推奨）
    ZSH_VERSION_OUTPUT=$(zsh --version | grep -oE '[0-9]+\.[0-9]+' | head -n 1)
    ZSH_MAJOR_VERSION=$(echo "$ZSH_VERSION_OUTPUT" | cut -d. -f1)

    if [[ "$ZSH_MAJOR_VERSION" -lt 5 ]]; then
        echo "⚠️  警告: zsh のバージョンが古い可能性があります（推奨: 5.0以降）"
        echo "   現在のバージョン: $ZSH_VERSION_OUTPUT"
    fi
else
    echo "📦 zsh をインストール中..."

    if [[ "$PACKAGE_MANAGER" == "brew" ]]; then
        brew install zsh
    elif [[ "$PACKAGE_MANAGER" == "apt" ]]; then
        sudo apt-get update
        sudo apt-get install -y zsh
    fi

    if command -v zsh &> /dev/null; then
        echo "✅ zsh のインストール完了"
        zsh --version

        # デフォルトシェル変更の提案
        CURRENT_SHELL=$(basename "$SHELL")
        if [[ "$CURRENT_SHELL" != "zsh" ]]; then
            echo ""
            echo "💡 デフォルトシェルを zsh に変更する場合："
            echo "   $ chsh -s \$(which zsh)"
            echo ""
            echo "   変更後、一度ログアウトして再ログインすると zsh が有効になります。"
        fi
    else
        echo "❌ エラー: zsh のインストールに失敗しました"
        echo "   zshはこのdotfilesの前提条件です。"
        echo "   手動でインストールしてください。"
        exit 1
    fi
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 4. fzf のインストール（必須）
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
# 5. ripgrep のインストール（推奨）
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
# 6. 完了メッセージ
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ 外部ツールのセットアップ完了！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
