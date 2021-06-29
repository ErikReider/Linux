command! -bang -nargs=? -complete=dir GFilesPWD call fzf#run(fzf#wrap({
      \'source': "git ls-files ".<q-args>,
      \'options': ['--preview', '~/.config/nvim/plugged/fzf.vim/bin/preview.sh {}']
      \}))
function OpenFiles()
  if expand('%') =~ 'NERD_tree' | wincmd w | endif
  if len(system('git rev-parse'))
    :Files
  else
    :GFilesPWD --exclude-standard --others --cached
  endif
endfunction
nnoremap <silent> <C-f> :call OpenFiles() <CR>

nnoremap <silent> <expr> <A-S-f> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Rg\<CR>"
nnoremap <silent> <expr> <A-S-d> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":BLines\<CR>"
nnoremap <silent> <expr> <A-S-w> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Windows\<CR>"
nnoremap <silent> <expr> <A-S-b> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Buffers\<CR>"
nnoremap <silent> <expr> <A-S-h> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":History\<CR>"
nnoremap <silent> <expr> <A-S-m> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Maps\<CR>"

let g:ackprg = 'ag --nogroup --nocolor --column'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-i': 'split',
  \ 'ctrl-s': 'vsplit' }
