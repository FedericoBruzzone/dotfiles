" source ~/.vim/vim-plug/coc.vim

" call plug#begin('~/.vim/plugged')
"     Plug 'neoclide/coc.nvim', {'branch': 'release'}
" call plug#end()

set nocompatible

set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key


set display=truncate

set scrolloff=5


set incsearch


set nrformats-=octal

" Don't use Q for Ex mode, use it for formatting.  Except for Select mode.
" Revert with ":unmap Q".
map Q gq
sunmap Q


inoremap <C-U> <C-G>u<C-U>

set mouse=a

" Revert with ":syntax off".
syntax on

" ===== SET =====

set number            " show line numbers
set relativenumber    " show relative line numbers

set tabstop=2         " number of visual spaces per TAB
set softtabstop=2     " number of spaces in tab when editing
set shiftwidth=2      " number of spaces to use for autoindent
set expandtab         " tabs are spaces

set smartindent       " autoindent new lines
set autoindent        " autoindent new lines

set nowrap            " don't wrap lines

set hlsearch          " highlight search results
set incsearch         " incremental search

set colorcolumn=80    " highlight column 80

set nomodeline        " disable modeline

set splitbelow        " open new split below
set splitright        " open new split right
set termguicolors     " enable 24-bit color
colorscheme industry

" ===== REMAP =====
let g:mapleader = "\<Space>" " set leader key to space

nnoremap <leader>pv :Ex<CR>        " open file browser

xnoremap <leader>p "_dP            " paste over visual selection
nnoremap <leader>d "_d             " delete without yanking
vnoremap <leader>d "_d             " delete without yanking

nnoremap <leader>y "+y             " copy to system clipboard
nnoremap <leader>Y "+Y             " copy to system clipboard
vnoremap <leader>y "+y             " copy to system clipboard
vnoremap <leader>Y "+Y             " copy to system clipboard

vnoremap <S-j> :m '>+1<CR>gv=gv    " move line down
vnoremap <S-k> :m '<-2<CR>gv=gv    " move line up

nnoremap <leader>s :%s/\<<C-r>=expand('<cword>')<CR>\>//gI<Left><Left><Left>

nnoremap <ESC>u :nohlsearch<CR>    " clear search highlight

vnoremap <silent> < <gv
vnoremap <silent> > >gv

