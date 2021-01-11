#!/bin/bash
IFS=$'\n'
settingsFilePaths=(
    ~/.config/i3/settings
    ~/.config/i3/touchpadWhitelist
)

for path in ${settingsFilePaths[@]}; do
    if [[ ! -f $(realpath $path) ]]; then
        cp $(dirname $path)"/."$(basename $path)"_template" "$path"
    fi
done

