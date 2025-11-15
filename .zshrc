# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/dotfiles/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/dotfiles/.zprezto/init.zsh"
fi

# Customize to your needs...

# エイリアス
alias dc='docker-compose'
alias sw='git checkout `git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'
## コード変更履歴検索
alias gs='(){git log -p -S $1 $2}'
alias push='git push'
alias pull='git pull'
alias st='git stash'
alias ch='git checkout'
alias chp='git cherry-pick'
alias gdb='delete-all-branch'
function delete-all-branch() {
  echo "マージ済みのローカルブランチ(master/develop/mainを除く)を全て削除しますか？(y/N): "
  if read -sq; then
    git branch --merged | egrep -v '\*|develop|master|main' | xargs git branch -d
    echo 削除しました
  else
    echo キャンセルしました
  fi
}

# 環境変数設定
export GREP_COLOR='0;34'
export GREP_OPTIONS='--color=auto'
export LSCOLORS=ExxxxxxxCxxxxxxxxxxxxx

# cdでpushdする。
setopt auto_pushd

# pushdで同じディレクトリを重複してpushしない。
setopt pushd_ignore_dups

# cdrコマンドを有効 ログアウトしても有効なディレクトリ履歴
# cdr タブでリストを表示
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs

# cdrコマンドで履歴にないディレクトリにも移動可能に
zstyle ":chpwd:*" recent-dirs-default true

# 過去に実行したコマンドを選択。ctrl-rにバインド
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# 過去に移動したことのあるディレクトリを取得
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}

# 過去に移動したことのあるディレクトリを選択。ctrl-uにバインド
function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^u' peco-cdr

# コマンドの打ち間違いを指摘してくれる
setopt correct
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [Yes/No/Abort/Edit] => "

# マシン固有の設定を読み込み
[ -f $ZDOTDIR/.zshrc_local ] && . $ZDOTDIR/.zshrc_local

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="/usr/local/opt/avr-gcc@8/bin:$PATH"
