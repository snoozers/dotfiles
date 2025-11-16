# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Powerlevel10k Instant Prompt (即時プロンプト)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# .zshrc の読み込みを高速化するため、zsh起動時にキャッシュされたプロンプトを
# 先に表示します。このブロックより上に記述すべきは、コンソール入力を
# 必要とする初期化コードのみです。(例: パスワード入力、[y/n]確認)
#
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
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
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 環境変数 (Environment Variables)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# grep のカラー設定
export GREP_COLOR='0;34'
export GREP_OPTIONS='--color=auto'

# ls のカラー設定 (macOS/BSD)
export LSCOLORS=ExxxxxxxCxxxxxxxxxxxxx

# PATH 設定
# ※ .zshrc_local でマシン固有のPATHを追加することを推奨
# 例: Homebrew で入れた avr-gcc@8
export PATH="/usr/local/opt/avr-gcc@8/bin:$PATH"

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
function delete-all-branch() {
  echo "マージ済みのローカルブランチ(master/develop/mainを除く)を全て削除しますか？(y/N): "
  # read -q は zsh 固有 (キー入力を待ち、Enter不要)
  if read -q; then
    echo # 改行
    git branch --merged | egrep -v '\*|develop|master|main' | xargs git branch -d
    echo "削除しました"
  else
    echo # 改行
    echo "キャンセルしました"
  fi
}

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
function peco-select-history() {
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
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}

# peco で選択したディレクトリに cd する関数
function peco-cdr() {
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