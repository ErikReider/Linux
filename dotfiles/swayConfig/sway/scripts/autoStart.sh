#!/bin/bash

blackList=("gammastep" "redshift" "geary")
for file in $(ls $HOME/.config/autostart/); do
    found=false
    for item in ${blackList[@]}; do
        if [[ "$file" == *"$item"* ]]; then 
            found=true
            break
        fi
    done
    if [[ $found == false ]]; then 
        gtk-launch $file &
    fi
done
