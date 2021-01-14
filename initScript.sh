#!/usr/bin/env bash

## ZSH
read -p "Do you wish to switch to ZSH? [y/n] " change_to_bash_var
if [[ $change_to_bash_var = y ]]
then
    sudo chsh --shell=/bin/zsh $USER
    pamac install zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting
    rm ~/.zshrc
    ln ./assets/.zshrc ~/.zshrc
    
    read -p "Copy this 'Defaults pwfeedback', paste it to the top of the file. Understood? [y/n] " visudo_var
    if [[ $visudo_var = y ]] ; then
        sudo visudo
    fi
fi
echo ""
##

## Applications
read -p "Do you wish to install all apps? [y/n] " install_app_var
if [[ $install_app_var = y ]]
then
    pamac install github-desktop-bin visual-studio-code-bin google-chrome android-studio nautilus-copy-path android-messages-desktop-bin dotnet-sdk neovim jq dart

    sudo pacman -Syy --needed discord auto-cpufreq jdk-openjdk jdk11-openjdk jdk8-openjdk jre-openjdk jre-openjdk-headless jre11-openjdk jre11-openjdk-headless jre8-openjdk jre8-openjdk-headless nodejs npm bash-completion
    
    sudo flatpak install Spotify
    
    sudo snap install flutter --classic
    
    read -p "Do you wish to install all apps? [y/n] " install_app_var
    if [[ $install_app_var = y ]]; then
        echo ""
    fi
    systemctl start auto-cpufreq
    systemctl enable auto-cpufreq
fi
echo ""
##

## Neovim
read -p "Do you wish to link vim config files? [y/n] " vim_var
if [[ $vim_var = y ]]; then
    currentDir=$PWD
    cd ~/.config/
    rm -rf nvim 

    ln -s $currentDir/nvim nvim
    cd $currentDir/.. 

    sh -c 'curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' 
    nvim -es -u ~/.config/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"
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
    cd ..
    rm -rf ./adementary-theme
fi
echo ""
##

## Chrome Dark Mode
read -p  "Do you wish to add Chrome Dark? [y/n] " chrome_dark_var
if [[ $chrome_dark_var = y ]]
then
    #sudo cp ./google-chrome.desktop /usr/share/applications/
    # find1="google-chrome-stable"
    # replace1="google-chrome-stable --enable-features=WebUIDarkMode --force-dark-mode"
    # sudo sed -i "s|$find1|$replace1|g" /usr/share/applications/google-chrome.desktop
    cp ./assets/chromium-flags.conf ~/.config/
fi
echo ""
##

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
echo ""
echo "Done! 😊"
