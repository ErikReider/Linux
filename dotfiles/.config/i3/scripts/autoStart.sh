#!/bin/bash

IFS=$'\n'

blackList=("create-template")

for file in $(ls $HOME/.config/autostart/); do
    found=false
    for item in ${blackList[@]}; do
        if [[ $file == *"$item"* ]]; then found=true; fi
    done
    if [ $found == false ]; then
        while IFS= read -r line; do
            if [[ $line == "Exec="* || $line == "exec="* ]]; then
                name=`basename ${line/#Exec=/} | cut -d ' ' -f1`
                pgrep -x $name >/dev/null || exec $name &
                disown
            fi
        done <"$HOME/.config/autostart/$file"
    fi
done
