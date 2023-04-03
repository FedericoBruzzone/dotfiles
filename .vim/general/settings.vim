" set clipboard^=unnamedplus
" set clipboard^=unnamed
set guicursor=
":set paste

:set colorcolumn=80

"set statusline=%t 
" set statusline=0 
" set guitablabel=0

:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set expandtab
:set smarttab
:set softtabstop=4

:set mouse=a
:set go+=a

:set encoding=UTF-8

" :set showtabline=2

""""""""""""""""""""

:set backspace=indent,eol,start

:set splitbelow
:set splitright

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
"nnoremap <C-UP> <c-w>+
"nnoremap <C-DOWN> <c-w>-
nnoremap <S-LEFT> <c-w><
nnoremap <S-RIGHT> <c-w>>

" Enable folding
:set foldmethod=indent
:set foldlevel=99
" Enable folding with the spacebar
nnoremap <space> za

" CTRL-down/up skips a paragraph and word
:nmap <C-UP> {
:nmap <C-DOWN> }
":nmap <C-RIGHT> :normal! w<CR>
":nmap <C-LEFT> :normal! b<CR>

:imap <C-DOWN> <Esc>}
:imap <C-UP> <Esc>{

""""""""""""""""""""

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Highlight cursor line underneath the cursor vertically.
set cursorcolumn

" Do not save backup files.
set nobackup

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
"set showmode
set noshowmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000



inoremap jj <esc>
nnoremap <space> :

" Move line/lines
nmap <C-j> mz:m+<cr>`z
nmap <C-k> mz:m-2<cr>`z
vmap <C-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <C-k> :m'<-2<cr>`>my`<mzgv`yo`z

vmap <C-c> y

" Map Ctrl-Backspace to delete the previous word in insert mode.
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>
