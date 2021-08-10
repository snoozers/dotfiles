#!/bin/bash

DOT_PATH="$HOME/dotfiles"
SETUP_PATH="$DOT_PATH/etc/init"
GITHUB_URL="https://github.com/snoozers/dotfiles.git"

# githubの共通関数を使用するため一時ファイルを作成して読み込む
curl -L raw.github.com/snoozers/dotfiles/master/bin/func.sh > $HOME/func_tmp.sh
chmod u+x $HOME/func_tmp.sh
source $HOME/func_tmp.sh
rm -f $HOME/func_tmp.sh

# mac, linux以外は未対応
if [ ! is_osx ] || [ ! is_linux ]; then
    die "mac, linux以外は未対応"
fi

install() {
    # zshをインストール
    if ! has "zsh"; then
        brew install zsh
    fi

    # gitをインストール
    if ! has "git"; then
        brew install git
    fi

    # pecoインストール
    if ! brew list --formula | grep peco > /dev/null 2>&1; then
        brew install peco > /dev/null
    fi

    # ditfilesをclone
    git clone --recursive "$GITHUB_URL" "$DOT_PATH"

    cd "$DOT_PATH"
    if [ $? -ne 0 ]; then
        die "not found: $DOT_PATH"
    fi

    # ~/.** -> dotfiles/.** のシンボリックリンク
    for f in .??*
    do
        [[ "$f" == ".git"* ]] && continue
        [[ "$f" == ".zshrc_local.example" ]] && cp $f ${HOME}/.zshrc_local && continue
        [[ "$f" == ".DS_Store" ]] && continue

        echo "$f"
        ln -snfv "$DOT_PATH/$f" "$HOME/$f"
    done

    zsh $SETUP_PATH/setup_prezto.sh

    # ログインシェルを変更
    chsh -s $(which zsh)

    logo
}

# homebrewをインストール
if ! has "brew"; then
    # Mac
    if is_osx; then
        DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential curl gettext m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev git
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh > $HOME/install_homebrew_tmp.sh
        chmod u+x $HOME/install_homebrew_tmp.sh
        source $HOME/install_homebrew_tmp.sh
        rm -f $HOME/install_homebrew_tmp.sh
        install

    # Debian系
    elif has "apt"; then
        # 管理者権限で実行
        su
        # sudoもインストールしておく
        if ! has "sudo"; then
            apt-get install sudo
        fi
        DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential curl gettext m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev git
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh > $HOME/install_homebrew_tmp.sh
        chmod u+x $HOME/install_homebrew_tmp.sh
        source $HOME/install_homebrew_tmp.sh
        rm -f $HOME/install_homebrew_tmp.sh
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bashrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        install
    fi
else
    install
fi
