#!/bin/bash

if [[ $1 == "-i" ]]; then
    pamac install --no-upgrade \
        wl-clipboard \
        wdisplays \
        xdg-desktop-portal-wlr \
        grim \
        slurp \
        swayidle \
        wallutils \
        kanshi \
        grim \
        slurp \
        swappy \
        otf-font-awesome \
        i3-gaps \
        ttf-font-awesome \
        xss-lock \
        pa-applet \
        ttf-roboto \
        polybar \
        scrot \
        i3lock \
        brightnessctl \
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
        arandr \
        autorandr \
        kitty \
        clipit

    pamac install pod2man

    # AUR
    pamac install --no-upgrade \
        dunst-git \
        swaylock-effects \
        rofi-lbonn-wayland-git \
        wlsunset \
        autotiling-git \
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
