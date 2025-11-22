" ========================================
" キーマップ設定
" ========================================

" リーダーキーを設定
let mapleader = " "

" カーソル移動
noremap j gj
noremap k gk

" ウィンドウ移動
nnoremap <leader>a <C-w>h
nnoremap <leader>s <C-w>j
nnoremap <leader>d <C-w>k
nnoremap <leader>f <C-w>l

" 上書き保存
nnoremap <Leader>c :w<CR>

" ウィンドウ閉じる（保存はしない）
nnoremap <Leader>w :q<CR>

" ========================================
" プラグイン管理設定
" ========================================

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" 導入したいプラグインを以下に列挙
" Plugin '[Github Author]/[Github repo]' の形式で記入
" :PluginInstallでインストール

" === 基本プラグイン ===
" ファイルエクスプローラー
Plugin 'preservim/nerdtree'

" === Git統合プラグイン ===
" Git統合ツール
Plugin 'tpope/vim-fugitive'

" Git差分表示
Plugin 'airblade/vim-gitgutter'

" === UI/UX強化プラグイン ===
" カラースキーム: Solarized Dark
Plugin 'lifepillar/vim-solarized8'

" ステータスライン強化
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" ファイルタイプアイコン表示
Plugin 'ryanoasis/vim-devicons'

" 多言語シンタックスハイライト
Plugin 'sheerun/vim-polyglot'

" インデントレベル可視化
Plugin 'preservim/vim-indent-guides'

call vundle#end()
filetype plugin indent on

" ========================================
" 基本設定
" ========================================

" === シンタックスハイライト有効化 ===
syntax on

" === 行番号表示 ===
set number

" === 不可視文字の表示 ===
set list
set listchars=tab:»\ ,trail:·,extends:→,precedes:←,nbsp:␣
" tab: タブ文字を »  で表示
" trail: 行末スペースを · で表示
" extends/precedes: 画面外に続く行を矢印で表示
" nbsp: 非改行スペースを ␣ で表示

" === 全角スペースの可視化 ===
function! ZenkakuSpace()
  highlight ZenkakuSpace ctermbg=Red guibg=#dc322f
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme       * call ZenkakuSpace()
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
  augroup END
  call ZenkakuSpace()
endif

" === カラースキーム設定 ===
set termguicolors          " True-colorサポート
set background=dark

" カラースキームが存在する場合のみ適用
silent! colorscheme solarized8

" === カーソルとカラー設定 ===
" 現在行の強調を有効化
set cursorline

" プラグインインストール後に有効化
if exists('g:colors_name')
  " 通常行番号の色
  highlight LineNr guifg=#586e75 ctermfg=7
  " 現在行の行番号の色
  highlight CursorLineNr guifg=#00FFFF ctermfg=14
endif

" === vim-airline設定 ===
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1

" === NERDTree設定 ===
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=0            " フォルダアイコン表示
let NERDTreeDirArrows=1            " 矢印でフォルダ表示
let NERDTreeAutoDeleteBuffer=1     " ファイル削除時にバッファも削除

" Vim起動時に自動的にNERDTreeを表示
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" ========================================
" Git統合設定
" ========================================

" === vim-gitgutter設定 ===
let g:gitgutter_sign_added='+'
let g:gitgutter_sign_modified='~'
let g:gitgutter_sign_removed='-'

" プラグインインストール後に有効化
if exists('g:colors_name')
  highlight GitGutterAdd guifg=#859900
  highlight GitGutterChange guifg=#b58900
  highlight GitGutterDelete guifg=#dc322f
endif

" ========================================
" UI/UX強化設定
" ========================================

" === vim-indent-guides設定 ===
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_auto_colors=0

" プラグインインストール後に有効化
if exists('g:colors_name')
  highlight IndentGuidesOdd  guibg=#073642
  highlight IndentGuidesEven guibg=#002b36
endif
