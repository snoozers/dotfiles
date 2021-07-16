set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" 導入したいプラグインを以下に列挙
" Plugin '[Github Author]/[Github repo]' の形式で記入
" :PluginInstallでインストール

call vundle#end()
filetype plugin indent on

" 以下カスタム設定
syntax on

" 行番号表示
set number

" 行中移動をしたいので
noremap j gj
noremap k gk
