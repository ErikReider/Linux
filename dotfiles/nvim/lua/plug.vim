if empty(glob('~/.config/nvim/plugged'))
silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
autocmd VimEnter * PlugInstall --sync | source $MYVIMRC | call mkdp#util#install()
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
\| PlugInstall --sync | source $MYVIMRC | call mkdp#util#install()
\| endif

call plug#begin('~/.config/nvim/plugged')

"" Essential plugins
" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate all'}
" Treesitter rainbow
Plug 'p00f/nvim-ts-rainbow'
" Indent indicators
Plug 'Yggdroot/indentLine'
" Start Screen
Plug 'glepnir/dashboard-nvim'
" To save write-protected files
Plug 'lambdalisue/suda.vim'
" Coc LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Auto tabwidth and style detection
Plug 'tpope/vim-sleuth'
" Color Scheme
Plug 'tomasiser/vim-code-dark'
" NERDTree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'PhilRunninger/nerdtree-visual-selection'
Plug 'ryanoasis/vim-devicons'
" Git in gutter
Plug 'airblade/vim-gitgutter'
" Comments
Plug 'preservim/nerdcommenter'
" Add surrounding (), [], {}, etc...
Plug 'tpope/vim-surround'
" Changing tag name also changed matching tag
Plug 'AndrewRadev/tagalong.vim'
" Searching
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Bottom line and buffer line
Plug 'vim-airline/vim-airline'
" XML-like
Plug 'gregsexton/MatchTag', {'for': ['html', 'xml', 'js', 'jsx', 'ts', 'tsx'] }
Plug 'alvan/vim-closetag'
" CSS color highlighter
Plug 'ap/vim-css-color', {'for': ['css', 'less', 'scss', 'sass']}
" Formatter.nvim
Plug 'mhartington/formatter.nvim'



"" Formatters
" Prettier (html, css, js, etc...)
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
" Vala uncrustify formatter
Plug 'cofyc/vim-uncrustify', {'for': 'vala'}
" Lua formatter
Plug 'andrejlevkovitch/vim-lua-format', {'for': 'lua'}



"" Syntax
" i3 syntax highlighting
Plug 'mboughaba/i3config.vim'
" Vala
Plug 'arrufat/vala.vim', {'for': 'vala'}
" Pug
Plug 'digitaltoad/vim-pug', {'for': 'pug'}



" Completion sources
" Lua nvim source
Plug 'rafcamlet/coc-nvim-lua'



"" File preview
" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
" HTML
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server', 'for': 'html'}
" Latex
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }



"" Other
" Vim commands for Flutter, including hot-reload-on-save and more.
Plug 'thosakwe/vim-flutter', {'for': 'dart'}
" LESS autocompile
Plug 'plasticscafe/vim-less-autocompile', {'for': 'less'}

call plug#end()
