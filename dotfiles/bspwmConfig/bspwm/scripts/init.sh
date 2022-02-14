#!/bin/bash
IFS=$'\n'
settingsFilePaths=(
    ~/.config/bspwm/settings
    ~/.config/bspwm/touchpadWhitelist
)

for path in ${settingsFilePaths[@]}; do
    if [[ ! -f $(realpath $path) ]]; then
        cp $(dirname $path)"/."$(basename $path)"_template" "$path"
    fi
done

