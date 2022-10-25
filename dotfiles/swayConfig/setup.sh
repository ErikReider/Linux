#!/bin/bash

path=$(dirname $(realpath "${BASH_SOURCE:-$0}"))
cd "$path"
currentDir=$PWD

distroName=$(cat </etc/os-release | grep "^ID" | awk -F= '{print $2}')

RED='\033[31;1m'
GREEN='\033[32;1m'
CYAN='\033[36;1m'
NOCOLOR='\033[0m'

install_lure_packages() {
    local package_dir="$currentDir"/lure_packages
    local failed=0
    local installed=0
    for file in "$package_dir"/*; do
        if [ ! -d "$file" ]; then
            fileName=$(basename "$file")
            printf "${CYAN}Starting to build Package: $fileName\n${NOCOLOR}"

            source "$file"
            relativePath=$(realpath --relative-to="$path" "$file")
            lure build -s "$relativePath" || {
                printf "${RED}Failed to build package: $fileName!...\n\n${NOCOLOR}"
                failed=$((failed + 1))
                continue
            }

            pkgPath="$HOME/.cache/lure/pkgs/$name/$name-$version-$release.$(uname -p)"
            if [[ $distroName == "arch" ]]; then
                pkgPath="$pkgPath.pkg.tar.zst"
                pkgCommand="sudo pacman -U --noconfirm  $pkgPath"
            elif [[ $distroName == "fedora" ]]; then
                pkgPath="$pkgPath.rpm"
                pkgCommand="sudo dnf install --assumeyes $pkgPath"
            fi

            if [ ! -f "$pkgPath" ]; then
                printf "${RED}Failed to locate built package: $fileName, $(basename $pkgPath)!...\n\n${NOCOLOR}"
                failed=$((failed + 1))
                continue
            fi
            printf "${GREEN}Installing package...\n${NOCOLOR}"
            $pkgCommand || {
                printf "${RED}Failed to install package: $fileName!...\n\n${NOCOLOR}"
                failed=$((failed + 1))
                continue
            }

            printf "${GREEN}Finished building Package: $fileName\n\n${NOCOLOR}"
            installed=$((installed + 1))
        fi
    done
    if [[ $failed -gt 0 ]]; then
        printf "${RED}Failed to build %s packages!... Successfully installed %s packages.\n${NOCOLOR}" "$failed" "$installed"
    else
        printf "${GREEN}Successfully built all packages!\n${NOCOLOR}"
    fi
}

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

        install_lure_packages
    fi
fi

pip install pulsectl

cd ~/.config/
dirs=("sway" "swaylock" "wayfire/wayfire.ini" "waybar" "../rofi" "../dunst" "../kitty" "gammastep" "../alacritty" "xdg-desktop-portal-wlr" "wlogout" "swaync")

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
