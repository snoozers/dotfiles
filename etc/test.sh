#!/bin/zsh

source $HOME/.zshrc

if has "brew"; then
    e_success "homebrew"
else
    e_error "homebrew"
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

if has "docker"; then
    e_success "docker"
else
    e_error "docker"
fi

if has "jq"; then
    e_success "jq"
else
    e_error "jq"
fi

if has "tig"; then
    e_success "tig"
else
    e_error "tig"
fi

if has "bat"; then
    e_success "bat"
else
    e_error "bat"
fi
