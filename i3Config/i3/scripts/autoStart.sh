#!/bin/bash

for file in `ls $HOME/.config/autostart/`; do
    while IFS= read -r line; do
        if [[ "$line" == "Exec"* || "$line" == "exec"* ]]; then
            exec ${line/#Exec=} &
        fi
    done < "$HOME/.config/autostart/$file"
done
