nnoremap <silent> <expr> <C-f> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<CR>"
nnoremap <silent> <expr> <A-S-f> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Rg\<CR>"
nnoremap <silent> <expr> <A-S-d> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":BLines\<CR>"
nnoremap <silent> <expr> <A-S-w> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Windows\<CR>"
nnoremap <silent> <expr> <A-S-h> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":History\<CR>"
nnoremap <silent> <expr> <A-S-m> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Maps\<CR>"

let g:ackprg = 'ag --nogroup --nocolor --column'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-i': 'split',
  \ 'ctrl-v': 'vsplit' }
