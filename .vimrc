" Automatic run of 'source' on .vimrc after editing
autocmd! bufwritepost .vimrc source %

" Get rid of trailing whitespace at end of lines
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/

" Color scheme stuff **********************************************************
set t_Co=256
colo wombat256mod
""""""""""""""""""
"colo lucius
"LuciusWhiteHighContrast
""""""""""""""""""
" End color scheme stuff ******************************************************

" A useful statusline
set statusline=%{fugitive#statusline()}  " Git status line from Fugitive
set statusline+=\ %n  " Buffer number
set statusline+=\ %{&ff}%y  " FileFormat[FileType]
set statusline+=\ \|
set statusline+=\ %<%F%m  " TruncatedFilePath[ModifiedFlag]
set statusline+=\ \|
set statusline+=\ Line:\ %l/%L:%c  " CurLineNumber/TotalLines:CurColumn
set statusline+=\ \|
set statusline+=\ 0x%04B  " Unicode value of character under the cursor.

set laststatus=2

set showtabline=3   " Show tabs at the top, even if only one is open

" Syntax highlighting and selective filetype-based plugin activation **********
filetype on
filetype plugin on
syntax enable

au BufNewFile,BufRead .bash* setl ft=sh
" End syntax highlighting *****************************************************

" Folding (for code sections, functions, etc.) ********************************
"Note:  zR to unfold all folds
"       zM to fold all folds
"       za to toggle the fold currently at your cursor
"set foldmethod=indent
" End folding *****************************************************************

"set cursorline     " Highlight cursor's line
" Allow backspace to delete line-breaks, automatically inserted indentation,
"  and the place where the insert started.
set backspace=indent,eol,start
set lazyredraw      " Redraw only when we need to (e.g. not during macros)
set nocompatible    " Make vim more intuitive
set number          " Show line numbers
set ruler           " Show the line number on the bottom bar
set showcmd         " Show the command you're currently typing on the bar

" Search stuff ****************************************************************
set hlsearch        " Highlight your search results
set incsearch       " Have vim search as you type
" After searching, you're guaranteed to have this many lines above and below
"  the cursor, to sort of vertically center the result
set scrolloff=6
" Searches will be case insentitive if the search is all lowercase characters
"  and case sensitive otherwise.
set smartcase
" Searches will always be case insensitive
"set ignorecase  " set [no]ic

" End search stuff ************************************************************

" Indentaton *****************************************************************
set autoindent      " Keep indentation level when starting next line
set colorcolumn=80  " Hightlight column 80 by default
au BufNewFile,BufRead *.java setlocal colorcolumn=100  " Set at 100 for Java files
" Make tabs equivalent to X num of spaces -- HARD TAB MUST BE ELIMINATED! :P
set expandtab       " Expand tabs to spaces
set shiftround      " Insert only enough spaces to get to the current
                    "  indentation level
set smartindent     " For c-like files, automatically makes extra indentation
                    "  level sometimes
set smarttab        " When you hit tab, align with the current indentation
                    "  level in that area
set softtabstop=2   " If expandtab is on, this is how many spaces a tab is
set shiftwidth=2    " number of spaces inserted for indentation
set tabstop=2       " Tab spacing of 2 for real tabs
" End indentaton *************************************************************

" Auto-complete stuff ********************************************************
set completeopt+=menuone
set confirm
set wildmenu
" End auto-complete stuff ****************************************************

" Plugin-specific commands **************************************************
" Run Pathogen plugin
execute pathogen#infect()
" For DelimitMate plugin
let delimitMate_expand_cr = 1
" YouCompleteMe debugging options
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
" For Syntastic plugin
"  Option 1: Disable on write; requires you to explicitly check the style.
"    Good for when checking takes multiple seconds (for large files), which
"    can be pretty annoying.
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes':   [],'passive_filetypes': [] }
"  Option 2: Disable by default on write+quit (check-on-write is still done).
"let g:syntastic_check_on_wq = 0
" End plugin-specific section ***********************************************

" Enable mouse
set mouse=a

" Allow for copy/paste into and out of external clipboard (use with browser, etc.)
set clipboard=unnamed
set bs=2            " Backspace over everything in insert mode

" For Python files, turn off smartindent
au! FileType python setl nosmartindent

" Up and down are more logical with g..
nnoremap <silent> k gk
nnoremap <silent> j gj
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja

" Lots of random stuff that was here when I took my friend's .vimrc long ago...
"let mapleader = ","
"noremap <C-U> <C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>
"noremap <C-D> <C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E>
"map <C-I> <C-A>
" Make ctrl + s behave as save, GUI-style
"map <C-S> :w<CR>
"imap <C-S> <ESC>:w<CR>

" Make keys below behave correctly when a pop-up menu is visible
inoremap <expr><silent> <S-Tab> pumvisible() ? "\<C-y>" : "<C-R>=Savecursor()<CR><C-X><C-O><C-P><Down><C-R>=Restorecursor()<CR>"
inoremap <expr> <Tab>           pumvisible() ? "\<C-y>" : "\<Tab>"
inoremap <expr> <CR>            pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>          pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>            pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>        pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

"map <C-Q> :q<CR>
"imap <C-Q> <Esc>:q<CR>
"map <silent> <leader>h :nohl<CR>
"map <silent> <leader>e :Texplore %:p:h<CR>
"nmap <silent> <leader>v :tabedit $MYVIMRC<CR>
"nmap <silent> <leader>s :source $MYVIMRC<CR>

"map <F9> :edit<CR>
"imap <F9> <Esc>:edit<CR>i
"map <F5> :make<CR>
"imap <F5> <Esc>:make<CR>

cab e tabe
runtime macros/matchit.vim

" Note that the ! in front of 'function' redefines the function
"  if it already exists - like when you're editing your vimrc :)
function! Savecursor()
  let g:savedcursorline = line(".")
  let g:savedcursorcol = col(".")
  return ""
endf

function! Restorecursor()
  call cursor(g:savedcursorline, g:savedcursorcol)
  return ""
endf

function! PadWithAsterisks()
  s/\v^.*$/\= submatch(0) . " " . repeat("*", 75 - len(submatch(0)))
endf

map <F8> :call PadWithAsterisks()<CR>
imap <F8> <Esc>:call PadWithAsterisks()<CR>i

" Pure sadness - disable the arrow keys to make yourself use hjkl
"map <UP> <nop>
"map <DOWN> <nop>
"map <RIGHT> <nop>
"map <LEFT> <nop>
"imap <UP> <nop>
"imap <DOWN> <nop>
"imap <RIGHT> <nop>
"imap <LEFT> <nop>

" Fixing tmux's wonky behavior with keybindings
if $TERM =~ '^screen'
  map <Esc>OH <Home>
  map! <Esc>OH <Home>
  map <Esc>OF <End>
  map! <Esc>OF <End>
  " tmux will send xterm-style keys when xterm-keys is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" Optional confidential stuff, to be stored in another file
let vimrc_extra=expand("~/.vimrc-confidential")
if filereadable(vimrc_extra)
  execute "source" . vimrc_extra
endif
