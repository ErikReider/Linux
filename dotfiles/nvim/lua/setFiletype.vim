" HTML
au! BufRead,BufNewFile *.html set filetype=html
au BufEnter,BufReadPost *.html set syntax=html

" Latex
let g:tex_flavor = "latex"

" Typescript / Javascript
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
au! BufRead,BufNewFile *.ts set filetype=typescript
" au! BufWritePost *.ts AsyncRun tsc "%"
au! BufWritePost *.ts make
" let g:ts_autocompile=1
autocmd FileType typescript :set makeprg=tsc

" React
autocmd BufNewFile,BufRead *.ts,*.tsx set filetype=typescriptreact
autocmd BufNewFile,BufRead *.js,*.jsx set filetype=javascriptreact

" Json files support comments
autocmd BufNewFile,BufRead *.json set filetype=jsonc
