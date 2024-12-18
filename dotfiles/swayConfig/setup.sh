#!/bin/bash

path=$(dirname $(realpath "${BASH_SOURCE:-$0}"))
cd "$path"
currentDir=$PWD

distroName=$(cat </etc/os-release | grep "^ID" | awk -F= '{print $2}')

if [[ $1 == "-i" ]]; then
    source ./packages.sh

    if [[ $distroName == "arch" ]]; then
        yay -S --needed "${common[@]}" "${arch[@]}"

        libtool --finish /usr/lib/rofi/
    elif [[ $distroName == "fedora" ]]; then
        sudo dnf install "${common[@]}" "${fedora[@]}"

        # Install Weather Icons
        mkdir -p ~/.local/share/fonts
        rm -rf ~/.local/share/fonts/weathericons-regular-webfont.ttf
        cd ~/.local/share/fonts && curl -fLo "weathericons-regular-webfont.ttf" https://github.com/erikflowers/weather-icons/raw/HEAD/font/weathericons-regular-webfont.ttf
        fc-cache -f
        cd "$currentDir"

    fi

    # Install LURE packages
    lure install "${lure[@]}"
fi

pip install pulsectl

cd ~/.config/
dirs=("sway" "swaylock" "wayfire/wayfire.ini" "waybar" "../rofi" "../dunst" "../kitty" "gammastep" "../alacritty" "xdg-desktop-portal-wlr" "wlogout" "swaync" "../hypr")

for item in "${dirs[@]}"; do
    name=$(basename "$item")
    rm -r "./$name"
    ln -s "$currentDir/$item" "./$name"
done

# Kanshi
mkdir ~/.config/kanshi
touch ~/.config/kanshi/config
echo "Please edit kanshi config for optimal output auto switching!"
echo "Syntax is similar to 'man 5 sway-output'. Get outputs: 'swaymsg -t get_outputs'"
printf "\nPLEASE NOTE THAT PAM NEEDS TO BE CONFIGURED ON FINGERPRINT EQUIPT LAPTOPS FOR LOCKSCREEN TO NOT REQUIRE BOTH PASSWORD AND FINGERPRINT AUTH!"

echo "Please setup ibus to use default system keyboard language."
ibus-setup & disown
