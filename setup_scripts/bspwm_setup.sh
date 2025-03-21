#!/bin/bash

if [[ $1 == "-i" ]]; then
    sudo rm -rf ~/.cache/yay/wlroots-git
    yay --needed -S \
        wmname \
        lsb-release \
        dbus-python \
        rofi-lbonn-wayland-git \
        polkit-kde-agent \
        rofi-emoji \
        ttf-material-icons-git \
        ttf-weather-icons \
        xss-lock \
        xrandr-notify \
        wlogout \
        pipewire-media-session \
        otf-font-awesome \
        ttf-font-awesome \
        ttf-roboto \
        brightnessctl \
        bluez-utils \
        bluez \
        playerctl \
        appimagelauncher \
        libappimage \
        lxappearance \
        alacritty \
        kitty \
        geoclue \
        geocode-glib \
        pacdep \
        gnome-keyring

    libtool --finish /usr/lib/rofi/
fi

pip install pulsectl

currentDir=$PWD
cd ~/.config/
dirs=("bspwm" "sxhkd")

for item in ${dirs[@]}; do
    name=$(basename $item)
    rm -r ./$name
    ln -s $currentDir/$item ./$name
done
