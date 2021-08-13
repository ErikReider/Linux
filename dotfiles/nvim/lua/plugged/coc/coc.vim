source ~/.config/nvim/lua/plugged/coc/coc-general.vim
let g:coc_global_extensions = []

" Source all .vim files
for f in split(glob('~/.config/nvim/lua/plugged/coc/configs/*.vim'), '\n')
    exe 'source' f
endfor

" coc-highlight: Highlight extension for coc.nvim
" https://www.npmjs.com/package/coc-highlight
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-highlight")

" coc-style-helper: Write styles easier in JSX, provide a powerful auxiliary development functions in style files like CSS, SASS
" https://github.com/PLDaily/coc-style-helper
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-style-helper")

" coc-snippets: Snippets extension for coc.nvim
" https://www.npmjs.com/package/coc-snippets
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-snippets")

" coc-pairs: Auto pair extension for coc.nvim
" https://github.com/neoclide/coc-pairs
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-pairs")

" coc-tsserver: tsserver extension for coc.nvim
" https://github.com/neoclide/coc-tsserver
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-tsserver")

" coc-terminal: Toggle terminal with coc.nvim
" https://www.npmjs.com/package/coc-terminal
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-terminal")

" coc-eslint: Eslint extension for coc.nvim
" https://github.com/neoclide/coc-eslint
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-eslint")

" coc-prettier: prettier extension for coc.nvim
" https://www.npmjs.com/package/coc-prettier
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-prettier")

" coc-json: Json extension for coc.nvim
" https://www.npmjs.com/package/coc-json
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-json")

" coc-spell-checker: Spelling checker for " source code
" https://github.com/iamcco/coc-spell-checker
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-spell-checker")

" coc-cspell-dicts: Imports the Ext spell checking dictionary for coc-spell-checker
" https://github.com/iamcco/coc-cspell-dicts
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-cspell-dicts")

" coc-markdownlint: Markdownlint extension for coc.nvim
" https://github.com/fannheyward/coc-markdownlint
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-markdownlint")

" coc-flutter: flutter support for (Neo)vim
" https://www.npmjs.com/package/coc-flutter
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-flutter")

" coc-pyright: Pyright extension for coc.nvim, static type checker for Python
" https://github.com/fannheyward/coc-pyright
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-pyright")

" coc-pydocstring: doq (python docstring generator) extension for coc.nvim
" https://github.com/yaegassy/coc-pydocstring
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-pydocstring")

" coc-css: Css extension for coc
" https://www.npmjs.com/package/coc-css
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-css")

" coc-omnisharp: OmniSharp integration, supports C# and VisualBasic.
" https://github.com/yatli/coc-omnisharp
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-omnisharp")

" coc-html: Html extension for coc
" https://github.com/neoclide/coc-html
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-html")

" coc-emmet: emmet extension for coc
" https://www.npmjs.com/package/coc-emmet
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-emmet")

" coc-xml: XML extension for coc.nvim
" https://github.com/fannheyward/coc-xml
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-xml")

" coc-svg: svg plugin for coc.nvim
" https://github.com/iamcco/coc-svg
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-svg")

" coc-lit-html: lit-html extension for coc.nvim
" https://github.com/fannheyward/coc-lit-html
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-lit-html")

" coc-jsref: coc.nvim plugin for JavaScript refactoring
" https://github.com/slonoed/jsref
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-jsref")

" coc-htmlhint: Integrates the HTMLHint static analysis tool into coc.nvim
" https://github.com/yaegassy/coc-htmlhint
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-htmlhint")

" coc-html-css-support: HTML id and class attribute completion for coc.nvim
" https://github.com/yaegassy/coc-html-css-support
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-html-css-support")

" coc-gitignore: gitignore extension for coc.nvim
" https://github.com/iamcco/coc-gitignore
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-gitignore")

" coc-clang-format-style-options: coc.nvim extension, helps you write `.clang-format` more easily.
" https://www.npmjs.com/package/coc-clang-format-style-options
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-clang-format-style-options")

" coc-bootstrap-classname: Autocomplete bootstrap classname
" https://www.npmjs.com/package/coc-bootstrap-classname
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-bootstrap-classname")

" coc-cssmodules: css modules autocompletion and go to definition coc.nvim plugin
" https://github.com/antonk52/coc-cssmodules
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-cssmodules")

" coc-marketplace: coc.nvim extensions marketplace
" https://github.com/fannheyward/coc-marketplace
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-marketplace")

" coc-yank: Yank extension for coc.nvim
" https://github.com/neoclide/coc-yank
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-yank")

" coc-yaml: yaml extension for coc.nvim
" https://www.npmjs.com/package/coc-yaml
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-yaml")

" coc-vimlsp: vim language server extension for coc.nvim
" https://github.com/iamcco/coc-vim
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-vimlsp")

" coc-react-refactor: React refactor extension for coc.nvim
" https://www.npmjs.com/package/coc-react-refactor
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-react-refactor")

" coc-styled-components: Styled component for coc.nvim as a tsserver plugin
" https://www.npmjs.com/package/coc-styled-components
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-styled-components")

" coc-clangd: clangd extension for coc.nvim
" https://github.com/clangd/coc-clangd
let g:coc_global_extensions = add(g:coc_global_extensions, "coc-clangd")

