#!/bin/bash

## Bash
read -p "Do you wish to switch to BASH? [y/n] " change_to_bash_var
if [[ $change_to_bash_var = y ]]
then
    sudo chsh --shell=/bin/bash $USER
    cp ./.bashrc ~/.bashrc

    read -p "Copy this 'Defaults pwfeedback', paste it to the top of the file. Understodd? [y/n] "
    sudo visudo
fi
echo ""
##

## Applications
read -p "Do you wish to install all apps? [y/n] " install_app_var
if [[ $install_app_var = y ]]
then
    pamac install github-desktop-bin visual-studio-code-bin google-chrome android-studio nautilus-copy-path android-messages-desktop-bin
    
    sudo pacman -Syy discord auto-cpufreq jdk-openjdk jdk11-openjdk jdk8-openjdk jre-openjdk jre-openjdk-headless jre11-openjdk jre11-openjdk-headless jre8-openjdk jre8-openjdk-headless nodejs npm
    
    sudo flatpak install Spotify
    
    sudo snap install flutter --classic
    
    systemctl start auto-cpufreq
    systemctl enable auto-cpufreq
fi
echo ""
##

## Ulauncher
read -p "Do you wish to install Ulauncher? [y/n] " install_ulauncher_var
if [[ $install_ulauncher_var = y ]]
then
    pamac install ulauncher
    sed -i 's/<Primary>space/<alt>space/g' ~/.config/ulauncher/settings.json
fi
echo ""
##

## Shell Theme
read -p  "Do you wish to install the Elementary theme? [y/n] " install_theme_var
if [[ $install_theme_var = y ]]
then
    pamac install elementary-icon-theme sound-theme-elementary
    sudo pacman -Syy sassc bc inkscape optipng
    git clone https://github.com/hrdwrrsk/adementary-theme.git
    cd ./adementary-theme/
    ./parse-sass.sh
    mkdir ~/.themes
    ./install.sh -d ~/.themes
fi
echo ""
##

## Chrome Dark Mode
read -p  "Do you wish to add Chrome Dark? [y/n] " chrome_dark_var
if [[ $chrome_dark_var = y ]]
then
    sudo cp ./google-chrome.desktop /usr/share/applications/
fi
echo ""
##

# Extension Sync
#git clone https://github.com/oae/gnome-shell-extensions-sync.git
#cd ./gnome-shell-extensions-sync
#yarn install
#yarn build
#ln -s "$PWD/dist" "$HOME/.local/share/gnome-shell/extensions/extensions-sync@elhan.io"
##

## Extension Credentials
read -p  "Do you wish to show Extension Credentials? [y/n] " input_variable
if [[ $input_variable = y ]]
then
    echo "Github Gist ID: ***REMOVED***"
    echo "Github User Token: ***REMOVED***"
fi
echo ""
##

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
echo ""
echo "Done! 😊"
