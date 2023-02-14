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
" Syntax aware text-objects, select, move, swap, and peek support
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
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
" Neovim plugin to improve the default vim.ui interfaces
Plug 'stevearc/dressing.nvim'

" nvim lsp
Plug 'neovim/nvim-lspconfig'
" A completion engine plugin for neovim written in Lua. 
Plug 'hrsh7th/nvim-cmp'
" nvim-cmp comparator function for completion items that start with one or more underlines
Plug 'lukas-reineke/cmp-under-comparator'
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
" Partial implementation of LSP inlay hint.
Plug 'lvimuser/lsp-inlayhints.nvim'
" Shows function signature (parameters)
Plug 'ray-x/lsp_signature.nvim'
" Automatically creates missing LSP diagnostics highlight groups
Plug 'folke/lsp-colors.nvim'
" Vim plugin for automatically highlighting other uses of the word under the cursor.
Plug 'RRethy/vim-illuminate'
" See LSP server startup status
Plug 'j-hui/fidget.nvim'

" Lsp Installer
Plug 'williamboman/mason.nvim'
" Auto installs lsps
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'
" Auto installs DAP debuggers
Plug 'jay-babu/mason-nvim-dap.nvim'

" Auto tabwidth and style detection
Plug 'tpope/vim-sleuth'
" Color Scheme
Plug 'tomasiser/vim-code-dark'
Plug 'Mofiqul/vscode.nvim'
" Dims inactive windows
Plug 'sunjon/Shade.nvim'
" NERDTree
" Plug 'scrooloose/nerdtree'
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'PhilRunninger/nerdtree-visual-selection'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
" Comments
Plug 'terrortylor/nvim-comment'
" Add surrounding (), [], {}, etc...
Plug 'kylechui/nvim-surround'
" Changing tag name also changed matching tag
Plug 'AndrewRadev/tagalong.vim'
" Searching
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-telescope/telescope-dap.nvim'
" Bufferline
Plug 'romgrk/barbar.nvim'
" Delete Neovim buffers without losing window layout
Plug 'famiu/bufdelete.nvim'
" Status line
Plug 'nvim-lualine/lualine.nvim'
" XML-like
" Super powerful color picker / colorizer plugin
Plug 'uga-rosa/ccc.nvim'
" Neovim lua functions
Plug 'nvim-lua/plenary.nvim'
" View package-info package information
Plug 'vuki656/package-info.nvim'
" Buffer title over split
Plug 'b0o/incline.nvim'
" Promise & Async in Lua 
Plug 'kevinhwang91/promise-async'
" Not UFO in the sky, but an ultra fold in Neovim (nicer folds)
Plug 'kevinhwang91/nvim-ufo'
" Gain the power to move lines and blocks and auto-indent them!
Plug 'fedepujol/move.nvim'
" Peek lines just when you intend 
Plug 'nacro90/numb.nvim'
" Intelligently reopen files at your last edit position in Vim.
Plug 'ethanholz/nvim-lastplace'
" Easily jump between NeoVim windows.
Plug 's1n7ax/nvim-window-picker'
" Display a line as the colorcolumn
Plug 'xiyaowong/virtcolumn.nvim'
" Allows quickly switching between header and implementation files for C/C++ in Neovim.
Plug 'jakemason/ouroboros'
" Highlight, list and search todo comments in your projects
Plug 'folke/todo-comments.nvim'

" Hydra
Plug 'anuvyklack/hydra.nvim'
Plug 'mrjones2014/smart-splits.nvim'
Plug 'sindrets/winshift.nvim'


"" NVIM DAP
" Debug Adapter Protocol client implementation for Neovim
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'Weissle/persistent-breakpoints.nvim'


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
" Highlight Git conflicts
Plug 'rhysd/conflict-marker.vim'



"" File preview
" Markdown preview
Plug 'toppair/peek.nvim', { 'do': 'deno task --quiet build:fast' }
" HTML
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server', 'for': 'html'}
" Latex
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }



"" Other
" Vim commands for Flutter, including hot-reload-on-save and more.
Plug 'akinsho/flutter-tools.nvim', {'for': 'dart'}
" Tools for better development in rust using neovim's builtin lsp
Plug 'simrat39/rust-tools.nvim'
" LESS autocompile
Plug 'plasticscafe/vim-less-autocompile', {'for': 'less'}
" Sets commentstring for JS/TS files
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

call plug#end()
