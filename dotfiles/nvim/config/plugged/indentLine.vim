let g:indentLine_fileTypeExclude = ["help", "terminal", "dashboard"]
let g:indentLine_enabled = 1
let g:indentLine_char = '│'
au BufRead,BufEnter,BufNewFile * IndentLinesReset
