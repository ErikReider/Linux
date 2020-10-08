#!/bin/bash

if [[ $1 == "-i" ]]; then
    pamac install \
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
    pa-applet \
    gnome-applets \
    network-manager-applet \
    rofi-emoji \
    xsel \
    gnome-terminal-transparency \
    blueberry \
    bluez-utils \
    playerctl \
    redshift \
    appimagelauncher \
    libappimage \
    nitrogen \
    lxappearance \
    dunst
    # i3-gnome-flashback \
    
    # To override i3-gnome-flashbacks i3
    pamac install i3-gaps
    
    libtool --finish /usr/lib/rofi/
fi

currentDir=$PWD
cd ~/.config/
dirs=("i3" "picom" "polybar" "rofi" "dunst")

for item in ${dirs[@]}; do
    rm ./$item
    ln -s $currentDir/$item/ ./$item
done

systemctl --user enable redshift-gtk.service