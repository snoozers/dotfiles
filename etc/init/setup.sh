#!/bin/bash

DOT_PATH="$HOME/dotfiles"
SETUP_PATH="$DOT_PATH/etc/init"
GITHUB_URL="https://github.com/snoozers/dotfiles.git"

# githubの共通関数を使用できるように
source <(curl -L raw.github.com/snoozers/dotfiles/master/bin/func.sh)

install() {
    # zshをインストール
    brew install zsh

    # gitをインストール
    brew install git

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

        ln -snfv "$DOT_PATH/$f" "$HOME/$f"
    done

    zsh $SETUP_PATH/setup_prezto.sh

    # ログインシェルを変更
    chsh -s $(which zsh)

    # ロゴを出力
    logo
}

# mac, linux以外は未対応
if [ ! is_osx ] || [ ! is_linux ]; then
    die "mac, linux以外は未対応"
fi

# homebrewをインストール
if ! has "brew"; then
    # Mac
    if is_osx; then
        source <(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
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
        source <(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bashrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

        install
    fi
else
    install
fi
