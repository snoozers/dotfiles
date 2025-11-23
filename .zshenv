# スクリプトやサブシェルでも環境変数（PATHなど）を利用可能にする。
# ログインシェル以外の最初のシェルで .zprofile が存在する場合に読み込む。
# これにより、cron、SSH経由のコマンド実行、エディタからの実行などでも正しい環境変数が設定される。
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# zshの設定ファイルを配置するディレクトリ
export ZDOTDIR=$HOME
