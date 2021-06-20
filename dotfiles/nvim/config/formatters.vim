function CustomFormatter()
    if (&ft == 'vala')
        :call Uncrustify('VALA')
    elseif (match([ 'sh', 'zsh', 'bash' ], &ft) == 0)
        :Shfmt -i 4
    else
        echo "No formatter for"&ft
    endif
endfunction
