" Init Plug
source ~/.config/nvim/config/plug.vim

" NeoVim general settings
luafile ~/.config/nvim/config/general.lua
source ~/.config/nvim/config/autoLoad.vim
source ~/.config/nvim/config/setFiletype.vim
source ~/.config/nvim/config/vimEnter.vim
source ~/.config/nvim/config/formatters.vim
source ~/.config/nvim/config/theme.vim


" Coc
source ~/.config/nvim/config/plugged/coc/coc.vim

" Plug configs
" Source all .vim files
for f in split(glob('~/.config/nvim/config/plugged/*.vim'), '\n')
    exe 'source' f
endfor
" Source all .lua files
for f in split(glob('~/.config/nvim/config/plugged/*.lua'), '\n')
    exe 'luafile' f
endfor

" Other NeoVim settings
source ~/.config/nvim/config/mappings.lua
