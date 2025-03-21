#!/bin/bash

for file in $HOME/.config/autostart/*.desktop; do
    if ! grep -q "Hidden=true" "$file"; then
        gtk-launch `basename $file` &
    fi
done
