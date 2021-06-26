" Navigate to CWD on nerdtree open
function OpenNerdTree()
  if exists("g:NERDTree") && g:NERDTree.IsOpen()
    :NERDTreeClose
  else
    :NERDTreeCWD
  endif
endfunction
nmap <C-n> :call OpenNerdTree() <CR>
nmap <C-m> :NERDTreeFind <CR>

let g:NERDTreeGitStatusWithFlags = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

let g:NERDTreeIgnore = ['^node_modules$']
