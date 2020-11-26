" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Vim Prettier
Plug 'prettier/vim-prettier', {'do': 'yarn install', 'branch': 'release/0.x'}

" VSCode theme (find replacement!)
""Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'tomasiser/vim-code-dark'

" Intellisense for VIM
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" File browser (NERDTree)
Plug 'preservim/NERDTree'

" NERDTree syntax
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" NERDTree Git status icons
Plug 'Xuyuanp/nerdtree-git-plugin'

" Directory and file icons
Plug 'ryanoasis/vim-devicons'

" Commenting
Plug 'preservim/nerdcommenter'

" Syntax errors
Plug 'scrooloose/syntastic'

" Quick commenting
Plug 'Jaymon/vim-commentify'

call plug#end()

" Color Scheme
colorscheme codedark
set t_Co=256
set cursorline
let g:airline_theme='onehalfdark'


if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end

vnoremap 1 :<C-u>execute b:Comment_ON<CR>
vnoremap 2 :<C-u>execute b:Comment_OFF<CR>


set nocompatible
syntax on
set incsearch
set ruler
set number
set splitbelow
set splitright

set mouse=a
set tabstop=4
set autoindent
set expandtab
set softtabstop=4
set cursorline
set wildmenu
set showmatch
set hlsearch
set list
set showbreak=↪\ 
"set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set listchars=space:•\,tab:→\

filetype indent on
