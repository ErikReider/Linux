set number
syntax on

" Do smart autoindenting when starting a new line
set smartindent
" Copy indent from current line when starting a new line
set autoindent
" When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'
set smarttab

" Defaults for new files
set expandtab
set tabstop=4
set shiftwidth=4

" Split direction
set splitbelow
set splitright

" Use Treesitter method in its file
" Max nested folds
set foldnestmax=10
" Turn off auto folding on start
set nofoldenable
" set foldlevel=2

" Makes popup menu smaller
set pumheight=10

" treat dash separated words as a word text object"
set iskeyword+=-

" Support 256 colors
set t_Co=256

" Disable quote concealing in JSON files
let g:vim_json_conceal=0

" So that I can see `` in markdown files
set conceallevel=0

" This is recommended by coc
set nobackup
" This is recommended by coc
set nowritebackup

" Always show top tabline
set showtabline=2


filetype plugin on

set cursorline

set wildmenu

set showmatch

" When there is a previous search pattern, highlight all its matches
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

" Encoding
set encoding=UTF-8

set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
