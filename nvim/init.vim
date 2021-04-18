"{{{ Plug

if empty(glob('~/.config/nvim/plugged'))
silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
autocmd VimEnter * PlugInstall --sync | source $MYVIMRC | call mkdp#util#install()
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
\| PlugInstall --sync | source $MYVIMRC | call mkdp#util#install()
\| endif

call plug#begin('~/.config/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
Plug 'preservim/nerdcommenter'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'tpope/vim-surround'
Plug 'AndrewRadev/tagalong.vim'

" Color Scheme
Plug 'tomasiser/vim-code-dark'

Plug 'vim-airline/vim-airline'

" i3
Plug 'mboughaba/i3config.vim'

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" Flutter
Plug 'dart-lang/dart-vim-plugin', {'for': 'dart'}
Plug 'thosakwe/vim-flutter', {'for': 'dart'}

" Plug 'frazrepo/vim-rainbow'
Plug 'luochen1990/rainbow'

" C/C++
Plug 'jackguo380/vim-lsp-cxx-highlight', {'for': ['c', 'h', 'cpp', 'hpp']}

" TS
Plug 'ianks/vim-tsx', {'for': ['ts','tsx']}
Plug 'HerringtonDarkholme/yats.vim', {'for': ['ts', 'tsx']}
Plug 'leafgarland/typescript-vim', {'for': ['ts', 'tsx']}
" JS
Plug 'MaxMEllon/vim-jsx-pretty', {'for': ['js','jsx']}
Plug 'othree/yajs.vim', {'for': ['js', 'jsx']}

" CSS
Plug 'ap/vim-css-color', {'for': ['css', 'less', 'scss', 'sass']}
" LESS
Plug 'plasticscafe/vim-less-autocompile', {'for': 'less'}

" HTML
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server', 'for': 'html'}
" Pug
Plug 'digitaltoad/vim-pug', {'for': 'pug'}

" XML-like
Plug 'gregsexton/MatchTag', {'for': ['html', 'xml', 'js', 'jsx', 'ts', 'tsx'] }
Plug 'alvan/vim-closetag'

" Latex
Plug 'astoff/digestif'
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

" Python
Plug 'vim-python/python-syntax', {'for': 'py'}

" JSON
Plug 'kevinoid/vim-jsonc'

" Vala
Plug 'arrufat/vala.vim', {'for': 'vala'}
Plug 'cofyc/vim-uncrustify', {'for': 'vala'}

" Shell script
Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }

call plug#end()
"}}}

"{{{ vim-closetag

let g:closetag_filenames = "*.html,*.js,*.jsx,*.ts,*.tsx,*.vue,*.xhml,*.xml"
let g:closetag_filetypes = 'html,xhtml,jsx,javascript,javascriptreact,tsx,typescript,typescriptreact'

let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

"}}}

"{{{ Tagalong

inoremap <silent> <c-c> <c-c>:call tagalong#Apply()<cr>

"}}}

"{{{ NERDCommenter
nmap <C-c> <plug>NERDCommenterToggle
vmap <C-c> <plug>NERDCommenterToggle
"}}}

"{{{ NERDTree
nmap <C-n> :NERDTreeToggle <CR>

let g:NERDTreeGitStatusWithFlags = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
"let g:NERDTreeGitStatusNodeColorization = 1
"let g:NERDTreeColorMapCustom = {
    "\ "Staged"    : "#0ee375",
    "\ "Modified"  : "#d9bf91",
    "\ "Renamed"   : "#51C9FC",
    "\ "Untracked" : "#FCE77C",
    "\ "Unmerged"  : "#FC51E6",
    "\ "Dirty"     : "#FFBD61",
    "\ "Clean"     : "#87939A",
    "\ "Ignored"   : "#808080"
    "\ }

let g:NERDSpaceDelims = 1
let g:NERDTreeIgnore = ['^node_modules$']

" sync open file with NERDTree
" " Check if NERDTree is open or active
" function! IsNERDTreeOpen()
  " return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
" endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
" function! SyncTree()
  " if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    " NERDTreeFind
    " wincmd p
  " endif
" endfunction

" Highlight currently open buffer in NERDTree
" autocmd BufEnter * call SyncTree()


"}}}

"{{{ Vim-GitGutter
" always show signcolumns
set signcolumn=yes
"}}}

"{{{ VimEnter
"Open NERDTree automatically if no files specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"autocmd VimEnter * wincmd l
"}}}

"{{{ vim-prettier
"let g:prettier#quickfix_enabled = 0
"let g:prettier#quickfix_auto_focus = 0
" prettier command for coc
"command! -nargs=0 Prettier :CocCommand prettier.formatFile
" run prettier on save
let g:prettier#autoformat = 0
"autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync
"}}}

"{{{ Markdown Preview
nmap <C-M-p> <Plug>MarkdownPreviewToggle

" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
" disable_filename: if disable filename header for preview page, default: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0
    \ }

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_markdown_css = ''

" use a custom highlight style must absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = ''

" use a custom port to start server or random for empty
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

" recognized filetypes
" these filetypes will have MarkdownPreview... commands
let g:mkdp_filetypes = ['markdown']
"}}}

"{{{ctrlp
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
"}}}

"{{{Coc Config
let g:coc_global_extensions = [
    \ 'coc-highlight',
    \ 'coc-snippets',
    \ 'coc-pairs',
    \ 'coc-tsserver',
    \ 'coc-eslint',
    \ 'coc-prettier',
    \ 'coc-json',
    \ 'coc-python',
    \ "coc-sh",
    \ "coc-markdownlint",
    \ "coc-flutter",
    \ "coc-css",
    \ "coc-html",
    \ "coc-emmet",
    \ "coc-xml",
    \ "coc-svg",
    \ "coc-react-refactor",
    \ "coc-styled-components",
    \ "coc-solargraph",
    \ "coc-clangd"]
" from readme
" if hidden is not set, TextEdit might fail.
set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> ög <Plug>(coc-diagnostic-prev)
nmap <silent> äg <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gs <Plug>(coc-definition)
nmap <silent> gd :call CocAction('jumpDefinition', 'tab drop')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd CursorHoldI * silent call CocActionAsync('showSignatureHelp')
nnoremap <silent> K :call CocAction('doHover')<CR>

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use `:Format` to format current buffer
" command! -nargs=0 Format :call CocAction('format')
" Format file on ctrl+alt+b
" map <C-M-b> :Format<CR>
map <expr><C-M-b> CocHasProvider("format") ? '<Plug>(coc-format)' : ':call CustomFormatter()<cr>'

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

"}}}

"{{{ Formatters

function CustomFormatter()
    if (&ft == 'vala')
        :call Uncrustify('VALA')
    elseif (&ft == 'sh')
        :Shfmt -i 4
    else
        echo "No formatter for"&ft
    endif
endfunction

"}}}

"{{{ Flutter

" call FlutterMenu()

"}}}

"{{{ C/C++

" c++ syntax highlighting
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

let g:syntastic_cpp_checkers = ['cpplint']
let g:syntastic_c_checkers = ['cpplint']
let g:syntastic_cpp_cpplint_exec = 'cpplint'
" The following two lines are optional. Configure it to your liking!
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"}}}

"{{{ Python

let g:python_highlight_all = 1

"}}}

"{{{ Typescript

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
au! BufRead,BufNewFile *.ts set filetype=typescript
" au! BufWritePost *.ts AsyncRun tsc "%"
au! BufWritePost *.ts make
" let g:ts_autocompile=1
autocmd FileType typescript :set makeprg=tsc

autocmd BufNewFile,BufRead *.ts,*.tsx set filetype=typescriptreact
autocmd BufNewFile,BufRead *.js,*.jsx set filetype=javascriptreact

"}}}

"{{{ CSS/LESS/SASS

autocmd FileType scss setl iskeyword+=@-@
au! BufRead,BufNewFile *.less set filetype=less
let g:less_autocompile=1

"}}}

"{{{ HTML
au! BufRead,BufNewFile *.html set filetype=html
au BufEnter,BufReadPost *.html set syntax=html


let g:bracey_server_path = "http://localhost"
let g:bracey_refresh_on_save = 1

"}}}

" {{{ Vala

let vala_comment_strings = 1
let vala_space_errors = 1
let vala_minlines = 120

" }}}

"{{{ LaTeX

let g:tex_flavor = "latex"
let g:livepreview_cursorhold_recompile = 0

"}}}

"{{{ Rainbow Brackets

" au FileType c,cpp,ts,js,cs,dart,json,sh call rainbow#load()
let g:rainbow_active = 1
let g:rainbow_conf = {
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\	'guis': [''],
\	'cterms': [''],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'markdown': {
\			'parentheses_options': 'containedin=markdownCode contained',
\		},
\		'lisp': {
\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\		},
\		'haskell': {
\			'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/\v\{\ze[^-]/ end=/}/ fold'],
\		},
\		'vim': {
\			'parentheses_options': 'containedin=vimFuncBody',
\		},
\		'perl': {
\			'syn_name_prefix': 'perlBlockFoldRainbow',
\		},
\		'stylus': {
\			'parentheses': ['start=/{/ end=/}/ fold contains=@colorableGroup'],
\		},
\		'css': 0,
\	}
\}

"}}}

"{{{ General map
" Duplicate line
nmap <C-d> yyp
" Open terminal
map å :split term://zsh<CR>
" reload file on ctrl+r
map <F5> :checktime <CR> :CocRestart <CR>
" Use ESC to exit insert mode in :term
tnoremap <Esc> <C-\><C-n>
" Use ESC to clear highlights
map <esc><esc> :nohl<CR>
" open init.vim on ,
map , :vsplit $MYVIMRC <CR>
" apply init.vim changes
map . :source $MYVIMRC <CR>
" k/j and up/down will move virtual lines (lines that wrap)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
noremap <silent> <expr> <Down> (v:count == 0 ? 'g<Down>' : '<Down>')
noremap <silent> <expr> <Up> (v:count == 0 ? 'g<Up>' : '<Up>')
map <silent> <home> g<home>
map <silent> <End> g<End>

" Switch tabs
nnoremap <silent> <A-Left> :tabp<CR>
nnoremap <silent> <A-Right> :tabn<CR>

noremap <A-Up> :m-2 <CR>
noremap <A-Down> :m+ <CR>
"}}}

"{{{ General
set number
syntax on
set shiftwidth=4
set smartindent
set autoindent
set smarttab
set cindent
" set softtabstop=4
" set tabstop=4
set splitbelow
set splitright
set foldmethod=marker
filetype plugin on
set cursorline
set wildmenu
set showmatch
set hlsearch
" Reloads open file on external modification
setlocal autoread
" always uses spaces instead of tab characters
set expandtab
" Yank to clipboard
set clipboard=unnamedplus
" Select with mouse
set mouse=a

set encoding=UTF-8

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"}}}

"Theme Settings{{{
" let g:codedark_conservative = 1
colorscheme codedark
let g:airline_theme='codedark'
" Set menu colors to match theme
" hi Pmenu ctermbg=darkgray guibg=#363738 guifg=white ctermfg=188
" hi PmenuSel ctermbg=180 guibg=#e5c07b guifg=black ctermfg=236

" Shows space and tab as characters
set list
set showbreak=↪\ 
set listchars=space:·,tab:⟶\ ,nbsp:␣,trail:·,extends:⟩,precedes:⟨
hi SpecialKey ctermfg=darkgray guifg=darkgray
hi NonText ctermfg=darkgray guifg=darkgray
hi Whitespace ctermfg=darkgray guifg=darkgray
hi CocHighlightText ctermbg=darkgray guibg=darkgray ctermfg=white guifg=white
"}}}
