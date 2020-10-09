#!/bin/bash

if [[ $1 == "-i" ]]; then
    pamac install \
    i3-gaps \
    ttf-font-awesome \
    xss-lock \
    pa-applet \
    ttf-roboto \
    polybar \
    scrot \
    i3lock \
    rofi \
    pa-applet \
    gnome-applets \
    network-manager-applet \
    xsel \
    blueberry \
    bluez-utils \
    playerctl \
    redshift \
    appimagelauncher \
    libappimage \
    nitrogen \
    lxappearance \
    dunst \
    arandr

    # AUR
    pamac install \
    polkit-gnome-gtk2 \
    alttab-git \
    picom-ibhagwan-git \
    rofi-emoji \
    gnome-terminal-transparency \
    ttf-material-icons-git \
    xidlehook

    # i3-gnome-flashback \
    
    # To override i3-gnome-flashbacks i3
    # pamac install i3-gaps
    
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