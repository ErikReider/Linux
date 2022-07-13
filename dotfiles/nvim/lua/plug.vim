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
" Code context
Plug 'nvim-treesitter/nvim-treesitter-context'
" Treesitter rainbow
Plug 'p00f/nvim-ts-rainbow'
" Treesitter auto close tags
Plug 'windwp/nvim-ts-autotag'
" Indent indicators
Plug 'lukas-reineke/indent-blankline.nvim'
" Start Screen
Plug 'glepnir/dashboard-nvim'
" To save write-protected files
Plug 'lambdalisue/suda.vim'
" Floating terminals
Plug 'numtostr/FTerm.nvim'
" .editorconfig support
Plug 'gpanders/editorconfig.nvim'

" nvim lsp
Plug 'neovim/nvim-lspconfig'
" A light-weight lsp plugin based on neovim built-in lsp with highly a performant UI.
Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
" A completion engine plugin for neovim written in Lua. 
Plug 'hrsh7th/nvim-cmp'
" nvim-cmp source for neovim builtin LSP client
Plug 'hrsh7th/cmp-nvim-lsp'
" nvim-cmp source for buffer words.
Plug 'hrsh7th/cmp-buffer'
" nvim-cmp source for filesystem paths.
Plug 'hrsh7th/cmp-path'
" luasnip completion source for nvim-cmp
Plug 'saadparwaiz1/cmp_luasnip'
" Snippet Engine for Neovim written in Lua.
Plug 'L3MON4D3/LuaSnip'
" Snippet Engine for Neovim written in Lua.
Plug 'rafamadriz/friendly-snippets'
" A super powerful autopair for Neovim
Plug 'windwp/nvim-autopairs'
" Shows function signature (parameters)
Plug 'ray-x/lsp_signature.nvim'
" Automatically creates missing LSP diagnostics highlight groups
Plug 'folke/lsp-colors.nvim'
" Vim plugin for automatically highlighting other uses of the word under the cursor.
Plug 'RRethy/vim-illuminate'
" See LSP server startup status
Plug 'j-hui/fidget.nvim'

" Auto tabwidth and style detection
Plug 'tpope/vim-sleuth'
" Color Scheme
Plug 'tomasiser/vim-code-dark'
Plug 'Mofiqul/vscode.nvim'
" NERDTree
" Plug 'scrooloose/nerdtree'
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'PhilRunninger/nerdtree-visual-selection'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
" Comments
Plug 'preservim/nerdcommenter'
" Add surrounding (), [], {}, etc...
Plug 'tpope/vim-surround'
" Changing tag name also changed matching tag
Plug 'AndrewRadev/tagalong.vim', {'for': ['html', 'xml', 'js', 'jsx', 'ts', 'tsx', 'heex'] }
" Searching
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
" Bottom line and tab line
Plug 'nvim-lualine/lualine.nvim'
" XML-like
" CSS color highlighter
Plug 'norcalli/nvim-colorizer.lua'
" Neovim lua functions
Plug 'nvim-lua/plenary.nvim'
" Plugin to persist and toggle multiple terminals during an editing session
Plug 'akinsho/nvim-toggleterm.lua'
" View package-info package information
Plug 'vuki656/package-info.nvim'
" Buffer title over split
Plug 'b0o/incline.nvim'
" Promise & Async in Lua 
Plug 'kevinhwang91/promise-async'
" Not UFO in the sky, but an ultra fold in Neovim (nicer folds)
Plug 'kevinhwang91/nvim-ufo'



"" Git
" Git in gutter
Plug 'lewis6991/gitsigns.nvim'
" Git commands in vim like`Git diff`
Plug 'tpope/vim-fugitive'
" GBrowse to open current file in browser
Plug 'tpope/vim-rhubarb'
" GV to open git log, gb to open in browser
Plug 'junegunn/gv.vim'



"" Syntax
" BSPWM sxhk syntax
Plug 'kovetskiy/sxhkd-vim'
" Dockerfile syntax
Plug 'ekalinin/Dockerfile.vim'
" i3 syntax highlighting
Plug 'mboughaba/i3config.vim'
" Sway syntax highlighting
Plug 'ajouellette/sway-vim-syntax'
" JSON comment syntax support
Plug 'kevinoid/vim-jsonc'
" C/C++ highlight
Plug 'jackguo380/vim-lsp-cxx-highlight', {'for': ['c', 'h', 'cpp', 'hpp']}
" Better JS, JSX  syntax
Plug 'MaxMEllon/vim-jsx-pretty', {'for': ['js','jsx']}
Plug 'othree/yajs.vim', {'for': ['js', 'jsx']}
" Better TS, TSX syntax
Plug 'ianks/vim-tsx', {'for': ['ts','tsx']}
Plug 'HerringtonDarkholme/yats.vim', {'for': ['ts', 'tsx']}
Plug 'leafgarland/typescript-vim', {'for': ['ts', 'tsx']}
" Vala
Plug 'arrufat/vala.vim', {'for': 'vala'}
" Python
Plug 'vim-python/python-syntax', {'for': 'py'}
" Dart / Flutter
Plug 'dart-lang/dart-vim-plugin', {'for': 'dart'}
" Pug
Plug 'digitaltoad/vim-pug', {'for': 'pug'}



"" File preview
" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
" HTML
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server', 'for': 'html'}
" Latex
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }



"" Other
" Vim commands for Flutter, including hot-reload-on-save and more.
Plug 'akinsho/flutter-tools.nvim', {'for': 'dart'}
" LESS autocompile
Plug 'plasticscafe/vim-less-autocompile', {'for': 'less'}

call plug#end()
