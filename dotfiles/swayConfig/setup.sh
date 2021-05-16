#!/bin/bash

if [[ $1 == "-i" ]]; then
    pamac install --no-upgrade \
        wob \
        wl-clipboard \
        gammastep \
        wdisplays \
        wf-recorder \
        grim \
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
        gnome-applets \
        network-manager-applet \
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
        pacdep \
        sway

    yay -S clipman aur/autotiling

    pamac install pod2man

    # AUR
    pamac install --no-upgrade \
        faba-icon-theme \
        waybar-git \
        xdg-desktop-portal-wlr-git \
        dunst-git \
        swaylock-effects \
        rofi-lbonn-wayland-git \
        i3lock-fancy-rapid-git \
        polkit-gnome-gtk2 \
        rofi-emoji \
        ttf-material-icons-git \
        ttf-weather-icons
    
    libtool --finish /usr/lib/rofi/
fi

pip install pulsectl

currentDir=$PWD
cd ~/.config/
dirs=("sway" "waybar" "../rofi" "../dunst" "../kitty" "gammastep" "../alacritty" "xdg-desktop-portal-wlr" "wlogout")

for item in ${dirs[@]}; do
    name=$(basename $item)
    rm -r ./$name
    ln -s $currentDir/$item/ ./$name
done

# Kanshi
mkdir ~/.config/kanshi
touch ~/.config/kanshi/config
echo "syntax is similar to 'man 5 sway-output'. Get outputs: 'swaymsg -t get_outputs'"
echo "add 'XDG_CURRENT_DESKTOP=sway' to /etc/environment"
