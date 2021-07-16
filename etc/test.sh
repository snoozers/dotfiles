#!/bin/zsh

source $HOME/.zshrc

if has "brew"; then
    e_success "homebrew"
else
    e_error "homebrew"
fi

if has "composer"; then
    e_success "composer"
else
    e_error "composer"
fi

if has "zsh"; then
    e_success "zsh"
else
    e_error "zsh"
fi

if has "git"; then
    e_success "git"
else
    e_error "git"
fi

if has "peco"; then
    e_success "peco"
else
    e_error "peco"
fi

if has "app"; then
    e_success "app"
else
    e_error "app"
fi

if has "memo"; then
    e_success "memo"
else
    e_error "memo"
fi

if has "vim"; then
    e_success "vim"
else
    e_error "vim"
fi

if has "trash"; then
    e_success "trash"
else
    e_error "trash"
fi
