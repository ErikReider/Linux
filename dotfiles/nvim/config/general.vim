set number
syntax on
" set shiftwidth=4
set smartindent
set autoindent
set smarttab
" Defaults for new files
set expandtab
set tabstop=4
set shiftwidth=4
" Split direction
set splitbelow
set splitright

" Use Treesitter instead
" set foldmethod=indent
set foldnestmax=10
set nofoldenable
" set foldlevel=2

filetype plugin on
set cursorline
set wildmenu
set showmatch
set hlsearch
" Reloads open file on external modification
setlocal autoread
" always uses spaces instead of tab characters
" set expandtab
" Yank to clipboard
set clipboard=unnamedplus
" Select with mouse
set mouse=a
" Shows the 80 char line
set colorcolumn=80

set encoding=UTF-8

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
