#!/bin/bash
sudo chsh --shell=/bin/bash $USER

sudo pamac install github-desktop-bin visual-studio-code-bin discord google-chrome elementary-icon-theme sound-theme-elementary 

##Shell Theme
sudo pacman -Syy sassc bc inkscape optipng
git clone https://github.com/hrdwrrsk/adementary-theme.git
cd ./adementary-theme/
./parse-sass.sh
mkdir ~/.themes
./install.sh -d ~/.themes
##

sudo flatpak install Spotify 

sudo snap install flutter 

sudo cp ./dark-google-chrome.desktop /usr/share/applications/

#Extension Sync
#git clone https://github.com/oae/gnome-shell-extensions-sync.git
#cd ./gnome-shell-extensions-sync
#yarn install
#yarn build
#ln -s "$PWD/dist" "$HOME/.local/share/gnome-shell/extensions/extensions-sync@elhan.io"

echo "Do you wish to show Extension Credentials? [y/n]"
read input_variable
if [[ $input_variable = y ]]
then
	echo "Github Gist ID: ***REMOVED***"
	echo "Github User Token: ***REMOVED***"
fi

echo "Done! 😊"
