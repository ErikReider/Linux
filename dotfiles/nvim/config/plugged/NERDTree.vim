nmap <C-n> :NERDTreeToggle <CR>
nmap <C-m> :NERDTreeFind <CR>

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
