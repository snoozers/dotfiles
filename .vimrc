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
nnoremap <C-c> :w<CR>
" 開いているファイルを閉じる（変更がある場合は確認）
nnoremap <C-w> :call SmartClose()<CR>
" 全てのファイルを閉じてVimを終了（変更がある場合は確認）
nnoremap <C-q> :call SmartCloseAll()<CR>

" ファイル検索
nnoremap <C-p> :Files<CR>
" バッファ一覧から検索
nnoremap <C-b> :Buffers<CR>
" 最近使ったファイルから検索
nnoremap <C-r> :FZFMru<CR>

" テキスト検索
nnoremap <C-f> :Rg<CR>

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

" === fzf ===
" fzf
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
" fzf vim統合
Plugin 'junegunn/fzf.vim'

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

" === カラーパレット定数 (Solarized Dark) ===
" 背景色系
let s:base03  = '#002b36'  " 最も暗い背景 (ダークブルーグレー)
let s:base02  = '#073642'  " 暗い背景 (ダークシアングレー)

" テキスト色系
let s:base01  = '#586e75'  " 補助テキスト (グレー)
let s:base0   = '#839496'  " 通常テキスト (明るいグレー)

" アクセントカラー
let s:red     = '#dc322f'  " 赤 (エラー、警告用)
let s:green   = '#859900'  " 緑 (成功、追加用)
let s:yellow  = '#b58900'  " 黄色 (警告、変更用)
let s:blue    = '#268bd2'  " 青 (情報、リンク用)
let s:cyan    = '#00ffff'  " シアン (カーソル、強調用)

" ripgrep用RGB値 (--colors用)
let s:rg_blue   = '38,139,210'   " 青 (パス表示用)
let s:rg_yellow = '181,137,0'    " 黄色 (行番号用)
let s:rg_gray   = '88,110,117'   " グレー (列番号・マッチ用)

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
  execute 'highlight ZenkakuSpace ctermbg=Red guibg=' . s:red
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
  execute 'highlight LineNr guifg=' . s:base01 . ' ctermfg=7'
  " 現在行の行番号の色
  execute 'highlight CursorLineNr guifg=' . s:cyan . ' ctermfg=14'
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
  execute 'highlight GitGutterAdd guifg=' . s:green
  execute 'highlight GitGutterChange guifg=' . s:yellow
  execute 'highlight GitGutterDelete guifg=' . s:red
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
  execute 'highlight IndentGuidesOdd  guibg=' . s:base02
  execute 'highlight IndentGuidesEven guibg=' . s:base03
endif

" ========================================
" バッファ管理
" ========================================

" 変更があるバッファを保存せずに隠せるようにする
set hidden

" バッファを処理する共通関数
" 戻り値: 1=保存して閉じる, 2=保存せずに閉じる, 0=キャンセル,
function! ProcessBuffer()
  if &modified
    let filename = expand('%:t')
    let filename = empty(filename) ? '[No Name]' : filename
    let choice = confirm(filename . 'に変更があります。', "w. 保存して閉じる\nq. 保存せずに閉じる\nc. キャンセル", 'wqc', 3)
    if choice == 1
      try
        write
        return 1
      catch
        echohl ErrorMsg
        echo 'エラー: ファイルを保存できませんでした'
        echohl None
        return 0
      endtry
    elseif choice == 2
      return 2
    else
      return 0
    endif
  endif
  return 1
endfunction

" 現在のファイルを閉じる（変更がある場合は確認）
function! SmartClose()
  " NERDTreeウィンドウの場合はquitがエラーになるので何もしない
  if &filetype == 'nerdtree'
    echohl WarningMsg
    echo '警告: ファイルエクスプローラーは閉じることができません'
    echohl None
    return
  endif

  let result = ProcessBuffer()
  if result == 1
    quit
  elseif result == 2
    quit!
  endif
endfunction

" 全てのファイルを閉じてVimを終了（変更がある場合は確認）
function! SmartCloseAll()
  " 全てのバッファを処理
  for bufnr in range(1, bufnr('$'))
    " 有効なバッファかつNERDTree以外のみ処理
    if !buflisted(bufnr) || getbufvar(bufnr, '&filetype') == 'nerdtree'
      continue
    endif

    " バッファに移動
    execute 'buffer' bufnr

    " バッファを処理
    let result = ProcessBuffer()
    if result == 0
      " キャンセルされた場合は処理を中断
      return
    endif
  endfor

  " 全てのバッファが処理された場合、Vimを終了
  quitall!
endfunction

" ========================================
" fzf設定
" ========================================

" fzfがインストールされている場合のみ設定を有効化
if executable('fzf')
  " === NERDTreeから編集ウィンドウに移動する関数 ===
  function! s:moveFromNERDTree()
    " NERDTreeウィンドウを探す
    let nerdtree_win = -1
    for i in range(1, winnr('$'))
      if getbufvar(winbufnr(i), '&filetype') == 'nerdtree'
        let nerdtree_win = i
        break
      endif
    endfor

    " 現在のウィンドウがNERDTreeの場合、右のウィンドウに移動
    if winnr() == nerdtree_win && winnr('$') > 1
      wincmd l
    endif
  endfunction

  " === NERDTree以外のウィンドウでファイルを開く関数 ===
  function! s:openInEditor(file, ...)
    call s:moveFromNERDTree()

    " ファイルを開く
    execute 'edit' fnameescape(a:file)

    " オプション引数で行番号が指定されている場合は移動
    if a:0 > 0 && a:1 > 0
      execute a:1
      normal! zz
    endif
  endfunction

  " === Rg検索結果からファイルを開く関数 ===
  function! s:openRgResult(line)
    " ripgrepの出力形式: ファイル名:行番号:列番号:テキスト
    let parts = split(a:line, ':')
    if len(parts) < 2
      return
    endif

    let file = parts[0]
    let line_num = parts[1]

    " ファイルを開いて指定行に移動
    call s:openInEditor(file, line_num)
  endfunction

  " === fzf表示設定 ===
  " fzfウィンドウを下部に表示（高さ50%、角丸ボーダー付き）
  let g:fzf_layout = { 'down': '50%' }

  " Solarized Darkに合わせたカラースキーム
  let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Function'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Comment'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment']
    \ }

  " === プレビューウィンドウ設定 ===
  " プレビューを右側に表示（幅60%）、Ctrl+/でトグル
  let g:fzf_preview_window = ['right:60%:hidden', 'ctrl-/']

  " === プロジェクト内ファイル検索 ===
  command! -bang -nargs=? -complete=dir Files call fzf#run({
    \   'source': 'find '.(empty(<q-args>) ? '.' : <q-args>).' -type f -not -path "*/.git/*"',
    \   'sink': function('s:openInEditor'),
    \   'options': ['--info=inline', '--layout=reverse', '--border=rounded', '--preview', 'cat {}', '--preview-window', 'right:60%:+{1}/2'],
    \   'down': '50%'
    \ })

  " === プロジェクト内テキスト検索 ===
  " ripgrepは高速なgrep代替ツール（推奨）
  if executable('rg')
    " ripgrepを使った高速検索
    command! -bang -nargs=* Rg call fzf#run({
      \   'source': 'rg --column --line-number --no-heading --color=always --colors "path:fg:' . s:rg_blue . '" --colors "path:style:bold" --colors "line:fg:' . s:rg_yellow . '" --colors "column:fg:' . s:rg_gray . '" --colors "match:fg:' . s:rg_gray . '" --smart-case --hidden --no-ignore -- ' . shellescape(empty(<q-args>) ? '.' : <q-args>),
      \   'sink': function('s:openRgResult'),
      \   'options': ['--ansi', '--delimiter=:', '--nth=4..', '--layout=reverse', '--border=rounded', '--preview', 'cat {1}', '--preview-window', 'right:60%:+{2}/2'],
      \   'down': '50%'
      \ })
  else
    " ripgrepがない場合はgrepを使用（動作は遅い）
    command! -bang -nargs=* Rg call fzf#run({
      \   'source': 'grep -rn --color=always '.shellescape(empty(<q-args>) ? '.' : <q-args>).' .',
      \   'sink': function('s:openRgResult'),
      \   'options': ['--ansi', '--delimiter=:', '--nth=3..', '--layout=reverse', '--border=rounded', '--preview', 'cat {1}', '--preview-window', 'right:60%:+{2}/2'],
      \   'down': '50%'
      \ })
  endif

  " === fzfデフォルトオプション ===
  " デフォルトのfzfオプション
  let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info --border=rounded --margin=1 --padding=1'

  " === カスタムコマンド: MRU（最近使ったファイル）検索 ===
  command! FZFMru call fzf#run({
  \  'source':  v:oldfiles,
  \  'sink':    function('s:openInEditor'),
  \  'options': ['-m', '--prompt', 'Recent> ', '--preview-window', 'right:60%:hidden', '--preview', 'cat {}'],
  \  'down':    '50%'})

  " カラースキーム選択
  command! -bang Colors call fzf#vim#colors(
    \ {'options': ['--layout=reverse', '--border=rounded']}, <bang>0)
endif
