#!/bin/bash
currentDir=$PWD
cd ~/.config/
dirs=("i3" "picom" "polybar" "rofi")

for item in ${dirs[@]}; do
    rm ./$item
    ln -s $currentDir/$item/ ./$item
done

pamac install --no-confirm \
ttf-font-awesome \
xidlehook \
xss-lock \
ttf-material-icons-git \
pa-applet \
ttf-roboto \
picom-ibhagwan-git \
polybar \
scrot \
i3lock \
rofi \
alttab-git \
i3-gnome-flashback \
pa-applet \
gnome-applets \
network-manager-applet \
rofi-emoji \
xsel

# To override i3-gnome-flashbacks i3
pamac install i3-gaps