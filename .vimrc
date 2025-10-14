" *****************************************************************************
" If found, we don't load our other vimrc files until the end of this file.
" However, some other logic in this file requires knowing whether the extra
" vimrc will be loaded, so we do these checks up-front.
let vimrc_extra_present = 0
let vimrc_extra=expand("~/.vimrc-work")
if filereadable(vimrc_extra)
  let vimrc_extra_present = 1

  let vimrc_extra_preload=expand("~/.vimrc-work-preload")
  if filereadable(vimrc_extra_preload)
    " Defines functions used in conditional plugin loading below.
    execute 'source' vimrc_extra_preload
  endif
endif

" *****************************************************************************

" *****************************************************************************
" KEEP VUNDLE SECTION AT THE TOP.
" Vundle configuration:
"
set nocompatible              " be iMproved, required
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

" @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
" NOTE: Keep Plugin commands between vundle#begin/end.
call vundle#begin()

" Let Vundle manage Vundle; required
Plugin 'VundleVim/Vundle.vim'
" This format (no scheme or host) assumes the plug is on GitHub:
Plugin 'tpope/vim-fugitive'
" Plugin for Go
""" Plugin 'fatih/vim-go'
" Plugin for fancy vim statusline
Plugin 'vim-airline/vim-airline'
" Plugin for syntax checking
Plugin 'vim-syntastic/syntastic'

" Conditional loads:
"
" Plugin for autocompletion. If our *extra* vimrc is present, we probably load
" YCM elsewhere; we want to avoid loading it twice.
if !(exists('*ShouldLoadOtherYcm') && ShouldLoadOtherYcm() == 1)
  Plugin 'valloric/youcompleteme'
endif

call vundle#end()            " required
" @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
filetype plugin indent on    " required
" *****************************************************************************

" *****************************************************************************
" autocmd expressions:
"
" Automatic run of 'source' on .vimrc after editing
augroup vimrc
  au!
  au bufwritepost .vimrc source %
augroup end

augroup general
  au!
  " Get rid of trailing whitespace at end of lines
  au ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
  au InsertLeave * match ExtraWhitespace /\s\+$/
augroup end

augroup filetypeMisc
  " When editing files that represent HTTP Requests, we don't want to append
  " a newline to the body portion of the request and mess up any hashing we
  " might be doing based on the body:
  " Turn off automatic newline-at-end-of-file insertion for .creq and .sts files.
  au BufNewFile,BufRead *.creq setl nofixendofline
  au BufNewFile,BufRead *.sts setl nofixendofline
augroup end

augroup filetypeGo
  au!
  " Set colorcolumn to match max line length
  " For 80-column wrap:
  "au FileType go setl colorcolumn=80,120 textwidth=80
  " For 100-column wrap:
  au FileType go setl colorcolumn=100,120 textwidth=100

  " Do not expand tabs to spaces; tabs show up as 4 characters wide:
  au FileType go setl noexpandtab shiftwidth=4 tabstop=4
augroup end

augroup filetypeJava
  au!
  au Filetype java setl colorcolumn=100
augroup end

augroup filetypePython
  au!
  " Expand tabs to X num of spaces
  au FileType python setl expandtab
  " For Python files, turn off smartindent
  au FileType python setl nosmartindent
  " If expandtab is on, this is how many spaces a tab is
  au FileType python setl softtabstop=2
  " number of spaces inserted for indentation
  au FileType python setl shiftwidth=2
  " Tab spacing of 2 for real tabs
  au FileType python setl tabstop=2
augroup end

augroup filetypeShell
  au!
  au BufRead,BufNewFile .bash*,.*_rc setl filetype=sh
augroup end
" *****************************************************************************

" *****************************************************************************
" Plugin-specific commands

" YouCompleteMe options
"
" Make the tab menu actually go away when you hit these keys (CR is not in the
" list by default, for some reason...)
let g:ycm_key_list_stop_completion = ['<C-y>', '<CR>']
"
" If 0, don't bring up the autocomplete window unless you hit <C-Space>
let g:ycm_auto_trigger = 1
" If ycm_auto_trigger is turned off, you can still bring up the autocomplete
" menu with <C-space>
let g:ycm_key_invoke_completion = '<C-Space>'
"
" Debugging options:
"let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'

" For Syntastic plugin
"  Option 1: Disable on write; requires you to explicitly check the style.
"    Good for when checking takes multiple seconds (for large files), which
"    can be pretty annoying.
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
"  Option 2: Disable by default on write+quit (keeping check-on-{write,open}).
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
" *****************************************************************************


" *****************************************************************************
" Color scheme stuff
"
" >>> WombatMod colorscheme:
set t_Co=256
colo wombat256mod

" >>> Lucius colorscheme:
"colo lucius
"LuciusWhiteHighContrast
" *****************************************************************************


" *****************************************************************************
" A useful statusline
"
set statusline=%{fugitive#statusline()}  " Git status line from Fugitive
set statusline+=\ %n  " Buffer number
set statusline+=\ %{&ff}%y  " FileFormat[FileType]
set statusline+=\ \|
set statusline+=\ %<%F%m  " TruncatedFilePath[ModifiedFlag]
set statusline+=\ \|
set statusline+=\ Line:\ %l/%L:%c  " CurLineNumber/TotalLines:CurColumn
set statusline+=\ \|
set statusline+=\ 0x%04B  " Unicode value of character under the cursor.
" *****************************************************************************


" *****************************************************************************
" Syntax highlighting and selective filetype-based plugin activation
"
filetype on
filetype plugin on
syntax enable

" *****************************************************************************


" *****************************************************************************
" Folding (for code sections, functions, etc.)
"
"Note:  zR to unfold all folds
"       zM to fold all folds
"       za to toggle the fold currently at your cursor
"set foldmethod=indent
" *****************************************************************************


" *****************************************************************************
" Search options
"
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
" *****************************************************************************


" *****************************************************************************
" Indentaton
"
set autoindent      " Keep indentation level when starting next line
set bs=2            " Backspace over everything in insert mode
" Allow for copy/paste into and out of external clipboard (use with browser, etc.)
set clipboard=unnamed
set colorcolumn=80  " Hightlight column 80 by default
set expandtab       " Expand tabs to X num of spaces
set mouse=a         " Enable mouse
set shiftround      " Insert only enough spaces to get to the current
                    "  indentation level
set smartindent     " For c-like files, automatically makes extra indentation
                    "  level sometimes
set smarttab        " When you hit tab, align with the current indentation
                    "  level in that area
set softtabstop=2   " If expandtab is on, this is how many spaces a tab is
set shiftwidth=2    " number of spaces inserted for indentation
set tabstop=2       " Tab spacing of 2 for real tabs
" *****************************************************************************


" *****************************************************************************
" Auto-complete stuff
"
" Show the autocomplete menu, even if there's only one possible item.
set completeopt+=menuone
" Don't open the preview window at the top when hovering over items in the
" autocomplete menu.
set completeopt-=preview
set confirm
set wildmenu
" *****************************************************************************


" *****************************************************************************
" Misc options:
"
" Allow backspace to delete line-breaks, automatically inserted indentation,
"  and the place where the insert started.
set backspace=indent,eol,start
"set cursorline     " Highlight cursor's line
set laststatus=2
set lazyredraw      " Redraw only when we need to (e.g. not during macros)
set nocompatible    " Make vim more intuitive
set number          " Show line numbers
set ruler           " Show the line number on the bottom bar
set showcmd         " Show the command you're currently typing on the bar
set showtabline=3   " Show tabs at the top, even if only one is open

runtime macros/matchit.vim
" *****************************************************************************


" *****************************************************************************
" Mapping/remapping expressions:
"
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

" Make <ctrl+backspace> and <ctrl+w> delete backward 1 word.
""" NOTE: <C-H> or <C-BS> is backspace, depending on the terminal/env/etc.
inoremap <C-BS> <C-\><C-o>dB
inoremap <C-H> <C-\><C-o>dB
inoremap <C-w> <C-\><C-o>dB
nnoremap <C-BS> dB
nnoremap <C-H> dB
nnoremap <C-w> dB

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

"map <F8> :call PadWithAsterisks()<CR>
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
" *****************************************************************************


" *****************************************************************************
" Function defintions:
"
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
" *****************************************************************************

" *****************************************************************************
" Optional work stuff; load if "$HOME/.vimrc-work" is found.
"
if vimrc_extra_present == 1
  execute 'source' vimrc_extra
endif
" *****************************************************************************

