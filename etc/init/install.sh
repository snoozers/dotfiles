#!/bin/zsh

source $DOTFILES_DIR/bin/func.sh

start() {
    e_process_waiting "$1"
}

finish() {
    if [ $? -eq 0 ]; then
        e_process_done "$1"
    else
        e_process_fail "$1"
    fi
}

# インストール
start '[git] vimのプラグインマネージャ'
if [ ! -d ${HOME}/.vim/bundle ]; then git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim > /dev/null; else true; fi
finish '[git] vimのプラグインマネージャ'

start '[vundle] vimプラグインインストール'
if has "vim"; then vim +PluginInstall +qall > /dev/null 2>&1; else true; fi
finish '[vundle] vimプラグインインストール'

start '[brew] 削除コマンドで削除したファイル・フォルダをゴミ箱へ'
if ! brew list --formula | grep trash > /dev/null 2>&1; then brew install trash > /dev/null; else true; fi
finish '[brew] 削除コマンドで削除したファイル・フォルダをゴミ箱へ'

start '[brew] peco'
if ! brew list --formula | grep peco > /dev/null 2>&1; then brew install peco > /dev/null; else true; fi
finish '[brew] peco'

start '[brew] コンソール上で動くgitブラウザ'
if ! brew list --formula | grep tig > /dev/null 2>&1; then brew install tig > /dev/null; else true; fi
finish '[brew] コンソール上で動くgitブラウザ'

start '[brew] docker'
if ! brew list --formula | grep docker > /dev/null 2>&1; then brew install docker > /dev/null; else true; fi
finish '[brew] docker'

start '[brew] docker-compose'
if ! brew list --formula | grep docker-compose > /dev/null 2>&1; then brew install docker-compose > /dev/null; else true; fi
finish '[brew] docker-compose'

start '[brew cask] chrome'
if ! brew list --cask | grep google-chrome > /dev/null 2>&1; then brew install --cask google-chrome > /dev/null; else true; fi
finish '[brew cask] chrome'

start '[brew cask] vscode'
if ! brew list --cask | grep visual-studio-code > /dev/null 2>&1; then brew install --cask visual-studio-code > /dev/null; else true; fi
finish '[brew cask] vscode'

start '[brew cask] slack'
if ! brew list --cask | grep slack > /dev/null 2>&1; then brew install --cask slack > /dev/null; else true; fi
finish '[brew cask] slack'

start '[brew cask] iterm2'
if ! brew list --cask | grep iterm2 > /dev/null 2>&1; then brew install --cask iterm2 > /dev/null; else true; fi
finish '[brew cask] iterm2'

start '[brew cask] dbeaver-community'
if ! brew list --cask | grep dbeaver-community > /dev/null 2>&1; then brew install --cask dbeaver-community > /dev/null; else true; fi
finish '[brew cask] dbeaver-community'

start '[brew cask] stoplight-studio'
if ! brew list --cask | grep stoplight-studio > /dev/null 2>&1; then brew install --cask stoplight-studio > /dev/null; else true; fi
finish '[brew cask] stoplight-studio'

start '[brew cask] postman'
if ! brew list --cask | grep postman > /dev/null 2>&1; then brew install --cask postman > /dev/null; else true; fi
finish '[brew cask] postman'
