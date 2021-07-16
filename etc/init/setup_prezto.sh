#!/bin/zsh

# prezto/.z** -> dotfiles/.z** のシンボリックリンク（実態はdotifiles/におきたいので）
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/dotfiles/.zprezto/runcoms/^README.md(.N); do
    ln -snfv "${ZDOTDIR:-$HOME}/dotfiles/.${rcfile:t}" "$rcfile"
done
