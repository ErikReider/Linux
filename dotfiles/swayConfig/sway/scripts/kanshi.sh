if $(pgrep -x kanshi >/dev/null); then
    kanshictl reload
else
    kanshi
fi
