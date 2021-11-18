" Latex
let g:tex_flavor = "latex"

" Typescript / Javascript
" autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
" autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
" au! BufRead,BufNewFile *.ts set filetype=typescript
" au! BufWritePost *.ts AsyncRun tsc "%"
" autocmd! BufWritePost *.ts make

" React
autocmd BufNewFile,BufRead *.ts,*.tsx set filetype=typescriptreact
autocmd BufNewFile,BufRead *.js,*.jsx set filetype=javascriptreact

" Json files support comments
autocmd BufNewFile,BufRead *.json set filetype=jsonc
