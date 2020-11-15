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
    arandr \
    kitty

    # AUR
    pamac install \
    polkit-gnome-gtk2 \
    alttab-git \
    picom-ibhagwan-git \
    rofi-emoji \
    gnome-terminal-transparency \
    ttf-material-icons-git \
    xidlehook
    
    libtool --finish /usr/lib/rofi/
fi

currentDir=$PWD
cd ~/.config/
dirs=("i3" "picom" "polybar" "rofi" "dunst" "kitty", "redshift")

for item in ${dirs[@]}; do
    rm -r ./$item
    ln -s $currentDir/$item/ ./$item
done

systemctl --user disable redshift-gtk.service