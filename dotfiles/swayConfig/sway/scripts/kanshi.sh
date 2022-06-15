if $(pgrep -x kitty >/dev/null); then
    kanshictl reload
else
    kanshi
fi
