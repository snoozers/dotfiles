# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Powerlevel10k Instant Prompt (即時プロンプト)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# .zshrc の読み込みを高速化するため、zsh起動時にキャッシュされたプロンプトを
# 先に表示します。このブロックより上に記述すべきは、コンソール入力を
# 必要とする初期化コードのみです。(例: パスワード入力、[y/n]確認)
#
if [ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Oh My Zsh (OMZ) の設定
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# OMZ のインストールパス
export ZSH="$HOME/.oh-my-zsh"

# OMZ のテーマ設定 (Powerlevel10k を使用)
ZSH_THEME="powerlevel10k/powerlevel10k"

# OMZ のプラグイン設定
plugins=(
  git                     # git コマンドのエイリアスや補完
  zsh-autosuggestions     # コマンド履歴に基づく入力候補の表示
  zsh-syntax-highlighting # コマンドラインの構文ハイライト
)

# OMZ の初期化
# ※ この行より下で $ZSH を使う設定や OMZ プラグインに依存する設定を記述
source $ZSH/oh-my-zsh.sh

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Powerlevel10k の設定読み込み
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# p10k の設定ファイル (~/.p10k.zsh) を読み込みます。
# 設定をカスタマイズしたい場合は `p10k configure` を実行するか、
# ~/.p10k.zsh を直接編集してください。
#
[ ! -f ~/.p10k.zsh ] || source ~/.p10k.zsh

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 環境変数 (Environment Variables)
# 基本的には.zshprofileに記述する。
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# エイリアス (Aliases) & 関数 (Functions)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Docker
alias dc='docker-compose'

# Git (基本)
alias push='git push'
alias pull='git pull'
alias st='git stash'
alias ch='git checkout'
alias chp='git cherry-pick'

# Git (peco連携): ブランチを peco で選択して checkout
alias sw='git checkout `git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'

# Git (関数): コード変更履歴 (特定の文字列) を検索
# Usage: gs <search_string> [file_path]
alias gs='(){git log -p -S $1 $2}'

# Git (関数): マージ済みのローカルブランチを一括削除
alias gdb='delete-all-branch'
delete-all-branch() {
  # リモートの最新状態を取得
  echo "📡 リモートの最新状態を取得中..."
  git fetch --prune --quiet

  # 削除対象のブランチを収集
  local branches_to_delete=$(
    {
      git branch --merged main 2>/dev/null
      git branch --merged master 2>/dev/null
      git branch --merged develop 2>/dev/null
    } | egrep -v '\*|develop|master|main' | sort -u
  )

  # 削除対象がない場合
  if [ -z "$branches_to_delete" ]; then
    echo "✅ 削除可能なマージ済みブランチはありません"
    return 0
  fi

  # 削除対象を表示
  echo "\n🗑️  削除対象のブランチ:"
  echo "$branches_to_delete" | sed 's/^/  • /'

  # 確認
  echo -n "\n❓ これらのブランチを削除しますか？ (y/N): "
  if read -q; then
    echo # 改行
    echo "\n🔄 ブランチを削除中..."

    # ブランチを1つずつ削除（進行状況を表示）
    local count=0
    local total=$(echo "$branches_to_delete" | wc -l | tr -d ' ')

    echo "$branches_to_delete" | while read branch; do
      if [ -n "$branch" ]; then
        count=$((count + 1))
        git branch -d "$branch" 2>/dev/null
        echo "  [$count/$total] ✓ $branch"
      fi
    done

    echo "\n✨ 完了！ $total 個のブランチを削除しました"
  else
    echo # 改行
    echo "❌ キャンセルしました"
  fi
}

# macOS固有: trash-cliを使った安全なrm
case "$OSTYPE" in
  darwin*)
    has() {
      which "$1" >/dev/null 2>&1
      return $?
    }
    if has trash; then
      alias rm='(){trash $*}'
    fi
    ;;
esac

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Zsh オプション (setopt)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# cd 時に自動で pushd を行い、ディレクトリスタックに積む
setopt auto_pushd

# ディレクトリスタックに重複するディレクトリを積まない
setopt pushd_ignore_dups

# コマンドの打ち間違いを訂正 (correct)
setopt correct
SPROMPT="correct: %F{red}%R%f -> %F{green}%r%f ? [Yes/No/Abort/Edit] => "

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ディレクトリ履歴 (cdr - Recent Directories)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# cdr コマンドを有効化し、ログアウト後もディレクトリ履歴を保持します。
# 'cdr [Tab]' で履歴リストを表示できます。
#
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs

# cdr コマンドで履歴にないディレクトリにも移動可能にする
zstyle ":chpwd:*" recent-dirs-default true

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# peco 連携 (インタラクティブ・フィルタリング)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ------------------------------------------------------------
# [Ctrl + R]: コマンド履歴 (history) を peco で検索
# ------------------------------------------------------------
peco-select-history() {
  # 履歴を peco に渡し、選択したコマンドを $BUFFER (入力行) にセット
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER # カーソルを末尾に移動
  zle clear-screen # 画面をクリア (pecoの表示を消す)
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# ------------------------------------------------------------
# [Ctrl + U]: ディレクトリ履歴 (cdr) を peco で検索して cd
# ------------------------------------------------------------
# peco で cdr の履歴を取得する内部関数
peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}

# peco で選択したディレクトリに cd する関数
peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line # コマンド (cd $destination) を実行
  else
    zle reset-prompt # キャンセルされた場合はプロンプトを再描画
  fi
}
zle -N peco-cdr
bindkey '^u' peco-cdr

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# マシン固有設定の読み込み (.zshrc_local)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# この .zshrc ファイルは dotfiles で管理することを想定しています。
# APIキーや会社PC特有のプロキシ設定など、マシン固有の機密情報は
# .zshrc_local (dotfiles 管理外) に記述し、ここで読み込みます。
#
[ -f $ZDOTDIR/.zshrc_local ] && . $ZDOTDIR/.zshrc_local
