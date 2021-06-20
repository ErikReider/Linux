autocmd FileType scss setl iskeyword+=@-@
au! BufRead,BufNewFile *.less set filetype=less
let g:less_autocompile=1
