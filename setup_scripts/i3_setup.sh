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
    brightnessctl \
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
    autorandr \
    kitty \
    clipit

    # AUR
    pamac install \
    i3lock-fancy-rapid-git \
    polkit-gnome-gtk2 \
    alttab-git \
    picom-git\
    rofi-emoji \
    gnome-terminal-transparency \
    ttf-material-icons-git \
    xidlehook \
    xob \
    touchegg \
    ttf-weather-icons
    
    libtool --finish /usr/lib/rofi/
fi

pip install pulsectl

currentDir=$PWD
cd ~/.config/
dirs=("i3" "picom" "polybar" "autorandr" "../rofi" "../dunst" "../kitty" "redshift" "xob" "touchegg" "../alacritty")

for item in ${dirs[@]}; do
    name=$(basename $item)
    rm -r ./$name
    ln -s $currentDir/$item/ ./$name
done

systemctl --user disable redshift-gtk.service
