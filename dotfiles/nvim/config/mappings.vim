" Duplicate line
function Duplicate ()
  set clipboard=""
  :normal yyp
  set clipboard=unnamedplus
endfunction
nmap <C-d> :call Duplicate() <CR>

" Closes on escape if not a terminal window
function TerminalEscape ()
    if split(expand("%"), ':')[-1] != $SHELL | :q! | endif
endfunction
tmap <Esc> <C-\><C-n>:call TerminalEscape() <CR>

" Opens selected link in xdg default browser
" https://vim.fandom.com/wiki/Open_a_web-browser_with_the_URL_in_the_current_line
nnoremap <silent>gx :silent !xdg-open <C-R>=escape("<C-R><C-F>", "#?&;\|%")<CR><CR>
" nnoremap <silent> gx :execute 'silent! !xdg-open ' . shellescape(expand('<cWORD>'), 1)<cr>

" open init.vim on F4 (split if buffer is selected)
map <silent> <expr> <F3> expand('%') == '' ? ':e $MYVIMRC <cr>' : ':vsplit $MYVIMRC <cr>'
" Source on F5
map <F4> :checktime <CR> :so $MYVIMRC \| redraw! <CR> :CocRestart <CR>

" Use ESC to clear highlights
map <esc><esc> :nohl<CR>

" k/j and up/down will move virtual lines (lines that wrap)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
noremap <silent> <expr> <Down> (v:count == 0 ? 'g<Down>' : '<Down>')
noremap <silent> <expr> <Up> (v:count == 0 ? 'g<Up>' : '<Up>')
map <silent> <home> g<home>
map <silent> <End> g<End>

" Switch tabs
nnoremap <C-TAB> :tabn<CR>
nnoremap <C-S-TAB> :tabp<CR>

noremap <A-Up> :m-2 <CR>
noremap <A-Down> :m+ <CR>

" Move window with arrow keys (C-w)
nnoremap <silent> <C-S-Left> :wincmd h<CR>
nnoremap <silent> <C-S-Down> :wincmd j<CR>
nnoremap <silent> <C-S-Up> :wincmd k<CR>
nnoremap <silent> <C-S-Right> :wincmd l<CR>

nnoremap <M-S-Up> :resize -2<CR>
nnoremap <M-S-Down> :resize +2<CR>
nnoremap <M-S-Right> :vertical resize -2<CR>
nnoremap <M-S-Left> :vertical resize +2<CR>

" Better tabbing
vnoremap < <gv
vnoremap > >gv
map <silent> <A-Left> <<
map <silent> <A-Right> >>
