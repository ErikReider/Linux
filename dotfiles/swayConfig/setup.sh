#!/bin/bash

if [[ $1 == "-i" ]]; then
    pamac install --no-upgrade \
        wl-clipboard \
        wdisplays \
        wf-recorder \
        xdg-desktop-portal-wlr \
        grim \
        slurp \
        swayidle \
        wallutils \
        wallutils \
        kanshi \
        grim \
        slurp \
        swappy \
        otf-font-awesome \
        ttf-font-awesome \
        pa-applet \
        ttf-roboto \
        brightnessctl \
        gnome-applets \
        network-manager-applet \
        blueberry \
        bluez-utils \
        playerctl \
        appimagelauncher \
        libappimage \
        lxappearance \
        kitty \
        pacdep \
        sway

    pamac install pod2man

    # AUR
    pamac install --no-upgrade \
        waybar-git \
        dunst-git \
        swaylock-effects \
        rofi-lbonn-wayland-git \
        wlsunset \
        i3lock-fancy-rapid-git \
        polkit-gnome-gtk2 \
        rofi-emoji \
        ttf-material-icons-git \
        ttf-weather-icons
    
    libtool --finish /usr/lib/rofi/
fi

pip install pulsectl autotiling

currentDir=$PWD
cd ~/.config/
dirs=("sway" "waybar" "mako" "../rofi" "../dunst" "../kitty")

for item in ${dirs[@]}; do
    name=$(basename $item)
    rm -r ./$name
    ln -s $currentDir/$item/ ./$name
done

# Kanshi
mkdir ~/.config/kanshi
echo "syntax is similar to 'man 5 sway-output'. Get outputs: 'swaymsg -t get_outputs'"
echo "add 'XDG_CURRENT_DESKTOP=sway' to /etc/environment"
