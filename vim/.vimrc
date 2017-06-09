set nocompatible
" Files/Buffers {{{1
set lazyredraw
set ttyfast

set viminfo=
set nobackup
set noswapfile
set autoread

set encoding=utf-8

" Colors/Fonts {{{1
filetype plugin indent on
syntax enable

if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif
set background=light

set guifont=DejaVu\ Sans\ Mono:h14

" UI/Navigation {{{1
set display+=lastline
set number
set scrolloff=1
set sidescrolloff=5

" Statusline
set laststatus=2
set statusline=%<
set statusline+=%f                  " file name
set statusline+=\ %h%w%r%m          " flags
set statusline+=%=                  " divider
set statusline+=%y                  " filetype
set statusline+=\ [%{&fenc}:%{&ff}] " file format
set statusline+=\ [%3l,%2v:%P]      " ruler
set statusline+=\ [%n]              " buffer number

" Search
set incsearch
set ignorecase
set smartcase

" Command-line
set wildmenu
set wildmode=list:longest

" Folding
set foldmethod=marker

" Editing {{{1
set backspace=indent,eol,start
set nrformats-=octal

" Tabs
set noexpandtab
set autoindent
set smarttab
set tabstop=8
set softtabstop=4
set shiftwidth=4

" Wrapping
set textwidth=72
set nowrap

" Completion
set complete-=i

" Keybindings {{{1
set ttimeout
set ttimeoutlen=100
let mapleader = ","

inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

nnoremap <Backspace> i<Backspace>
nnoremap <CR> A<CR>
nnoremap <Space> i<Space>

" Emacs-style navigation
noremap <C-p> <Up>
noremap <C-n> <Down>
noremap <C-b> <Left>
noremap <C-f> <Right>
noremap <C-a> <Home>
noremap <C-e> <End>

noremap! <C-p> <Up>
noremap! <C-n> <Down>
noremap! <C-b> <Left>
noremap! <C-f> <Right>
noremap! <C-a> <Home>
noremap! <C-e> <End>

" Plugins {{{1
runtime! macros/matchit.vim

" Autocommands {{{1
augroup vimrc
  autocmd!
  autocmd Filetype csv,make,text set ts=8 sts=8 sw=8 noet
  autocmd Filetype haskell set ts=8 sts=2 sw=2 et
  autocmd Filetype java,javascript,scala set expandtab
  autocmd FileType python set tabstop=4 expandtab
  autocmd FileType clojure,vim,zsh set ts=2 sts=2 sw=2 et
  autocmd BufNewFile,BufRead *.nss set filetype=c
  autocmd BufNewFile,BufRead *.2da set filetype=csv
augroup END

" vim:set ft=vim et sw=2 fdm=marker:
