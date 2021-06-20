" Duplicate line
function Duplicate ()
  set clipboard=""
  :normal yyp
  set clipboard=unnamedplus
endfunction
nmap <C-d> :call Duplicate() <CR>
" Open terminal
map å :split term://zsh<CR>
" reload file on ctrl+r
map <F5> :checktime <CR> :CocRestart <CR>
" Use ESC to exit insert mode in :term
tnoremap <Esc> <C-\><C-n>
" Use ESC to clear highlights
map <esc><esc> :nohl<CR>
" open init.vim on ,
map , :vsplit $MYVIMRC <CR>
" apply init.vim changes
" map . :source $MYVIMRC <CR>
nnoremap . :so $MYVIMRC \| redraw!<CR>
" k/j and up/down will move virtual lines (lines that wrap)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
noremap <silent> <expr> <Down> (v:count == 0 ? 'g<Down>' : '<Down>')
noremap <silent> <expr> <Up> (v:count == 0 ? 'g<Up>' : '<Up>')
map <silent> <home> g<home>
map <silent> <End> g<End>

" Switch tabs
nnoremap <silent> <A-Left> :tabp<CR>
nnoremap <silent> <A-Right> :tabn<CR>

noremap <A-Up> :m-2 <CR>
noremap <A-Down> :m+ <CR>

" Move window with arrow keys
nnoremap <silent> <C-S-Left> :wincmd h<CR>
nnoremap <silent> <C-S-Down> :wincmd j<CR>
nnoremap <silent> <C-S-Up> :wincmd k<CR>
nnoremap <silent> <C-S-Right> :wincmd l<CR>
