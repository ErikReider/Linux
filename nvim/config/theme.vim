" let g:codedark_conservative = 1
colorscheme codedark
let g:airline_theme='codedark'
" Set menu colors to match theme
" hi Pmenu ctermbg=darkgray guibg=#363738 guifg=white ctermfg=188
" hi PmenuSel ctermbg=180 guibg=#e5c07b guifg=black ctermfg=236

" Shows space and tab as characters
set showbreak="↪\ "
set list
set listchars=space:·,tab:⟶\ ,nbsp:␣,trail:·,extends:⟩,precedes:⟨
hi SpecialKey ctermfg=darkgray guifg=darkgray
hi NonText ctermfg=darkgray guifg=darkgray
hi Whitespace ctermfg=darkgray guifg=darkgray
hi CocHighlightText ctermbg=darkgray guibg=darkgray ctermfg=white guifg=white
