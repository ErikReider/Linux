#!/bin/bash

IFS=$'\n'

blackList=("redshift" "create-template")

for file in $(ls $HOME/.config/autostart/); do
    found=false
    for item in ${blackList[@]}; do
        if [[ "$file" == *"$item"* ]]; then
            found=true
        fi
    done
    if [ $found == false ]; then
        while IFS= read -r line; do
            if [[ "$line" == "Exec"* || "$line" == "exec"* ]]; then
                exec ${line/#Exec=/} &
            fi
        done <"$HOME/.config/autostart/$file"
    fi
done
