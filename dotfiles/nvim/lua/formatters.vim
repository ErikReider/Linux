function CustomFormatter()
    if (&ft == 'vala')
        :call Uncrustify('VALA')
    elseif (&ft == 'lua')
        :call LuaFormat()
    elseif (match([ 'sh', 'zsh', 'bash' ], &ft) == 1)
        :Shfmt -i 4
    else
        echo "No formatter for"&ft
    endif
endfunction
