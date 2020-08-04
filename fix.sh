#!/bin/bash

##Bash
echo "Do you wish to switch to BASH? [y/n]"
read change_to_bash_var
if [[ $change_to_bash_var = y ]]
then
	sudo chsh --shell=/bin/bash $USER
fi
echo ""
##

##Applications
echo "Do you wish to install all apps? [y/n]"
read install_app_var
if [[ $install_app_var = y ]]
then
	sudo pamac install github-desktop-bin visual-studio-code-bin discord google-chrome

	sudo flatpak install Spotify 

	sudo snap install flutter --classic
fi
echo ""
##

##Shell Theme
echo "Do you wish to install the Elementary theme? [y/n]"
read install_theme_var
if [[ $install_theme_var = y ]]
then
	sudo pamac install elementary-icon-theme sound-theme-elementary
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
echo "Do you wish to add Chrome Dark? [y/n]"
read chrome_dark_var
if [[ $chrome_dark_var = y ]]
then
	sudo cp ./dark-google-chrome.desktop /usr/share/applications/
fi
echo ""
##

#Extension Sync
#git clone https://github.com/oae/gnome-shell-extensions-sync.git
#cd ./gnome-shell-extensions-sync
#yarn install
#yarn build
#ln -s "$PWD/dist" "$HOME/.local/share/gnome-shell/extensions/extensions-sync@elhan.io"
##

## Extension Credentials
echo "Do you wish to show Extension Credentials? [y/n]"
read input_variable
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
