#!/bin/bash

if [[ $1 == "-i" ]]; then

    yay -S \
        autotiling \
        sway-git \
        wlroots-git \
        wlsunset-git \
        faba-icon-theme \
        waybar-git \
        xdg-desktop-portal-wlr-git \
        swaylock-effects \
        rofi-lbonn-wayland-git \
        polkit-gnome \
        rofi-emoji \
        ttf-material-icons-git \
        ttf-weather-icons \
        avizo \
        swaync-git \
        swaysettings-git \
        caffeinated \
        xss-lock \
        wl-clipboard \
        gammastep \
        wdisplays \
        wf-recorder \
        grim \
        grimshot \
        slurp \
        swayidle \
        wallutils \
        wlogout \
        kanshi \
        grim \
        slurp \
        swappy \
        pipewire-media-session \
        otf-font-awesome \
        ttf-font-awesome \
        pa-applet \
        ttf-roboto \
        brightnessctl \
        blueberry \
        bluez-utils \
        playerctl \
        appimagelauncher \
        libappimage \
        lxappearance \
        alacritty \
        kitty \
        geoclue \
        geocode-glib \
        pacdep

    libtool --finish /usr/lib/rofi/
fi

pip install pulsectl

currentDir=$PWD
cd ~/.config/
dirs=("sway" "wayfire/wayfire.ini" "waybar" "../rofi" "../dunst" "../kitty" "gammastep" "../alacritty" "xdg-desktop-portal-wlr" "wlogout")

systemctl enable --now kanshi

for item in ${dirs[@]}; do
    name=$(basename $item)
    rm -r ./$name
    ln -s $currentDir/$item ./$name
done

# Kanshi
mkdir ~/.config/kanshi
touch ~/.config/kanshi/config
echo "syntax is similar to 'man 5 sway-output'. Get outputs: 'swaymsg -t get_outputs'"
echo "add 'XDG_CURRENT_DESKTOP=sway' to /etc/environment"
