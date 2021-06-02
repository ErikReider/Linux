#!/usr/bin/env bash

## Flatpak theme override
read -p "Do you wish to enable flatpatk theme override? [y/n] " flatpakTheme
if [[ $flatpakTheme = y ]]; then
    flatpak install flathub --system org.gtk.Gtk3theme.Adwaita-dark
    flatpak install flathub --user org.gtk.Gtk3theme.Adwaita-dark
    sudo flatpak override --filesystem=~/.themes
fi
echo ""
##

## ZSH
read -p "Do you wish to switch to ZSH? [y/n] " change_to_bash_var
if [[ $change_to_bash_var = y ]]; then
    yay -S zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting
    sudo chsh --shell=/bin/zsh $USER

    currentDir=$PWD
    # Init ohmyzsh
    cd $HOME
    rm -rf .oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # Remove provided configs and themes
    rm -rf .oh-my-zsh/custom .oh-my-zsh-custom .zshrc

    ln -s $currentDir/zsh/.zshrc .zshrc
    ln -s $currentDir/zsh/.oh-my-zsh-custom .
    cd .oh-my-zsh-custom/plugins
    ln -s /usr/share/zsh/plugins/* .

    cd $currentDir/

    # Set password feedback
    read -p "Copy this 'Defaults pwfeedback', paste it to the top of the file. Understood? [y/n] " visudo_var
    if [[ $visudo_var = y ]]; then
        export EDITOR=/usr/bin/nvim
        sudo visudo
    fi
    source ~/.zshrc
fi
echo ""
##

## Applications
read -p "Do you wish to install all apps? [y/n] " install_app_var
if [[ $install_app_var = y ]]; then
    sudo pacman -S pacaur
    yay -S pamixer github-desktop-bin visual-studio-code-bin chromium nautilus-copy-path dotnet-sdk neovim jq dart mailspring noisetorch-git

    sudo pacman -Syy --needed discord jdk-openjdk jdk11-openjdk jdk8-openjdk jre-openjdk jre-openjdk-headless jre11-openjdk jre11-openjdk-headless jre8-openjdk jre8-openjdk-headless nodejs npm alacritty manjaro-bluetooth yarn

    sudo flatpak install Spotify

    pip install jedi

    sudo snap install flutter --classic
fi
echo ""
##

## Neovim
read -p "Do you wish to link vim config files? [y/n] " vim_var
if [[ $vim_var = y ]]; then
    yay -S ccls texlive-bibtexextra texlive-gantt texlive-pictures vala-language-server-git
    sudo pacman -Syyu --needed texlive-core texlive-fontsextra texlive-latexextra texlive-science biber bash-language-server uncrustify shfmt python2
    pip install cpplint neovim
    sudo npm install -g neovim

    # Install digestif for latex
    wget -P ~/.local/bin https://raw.githubusercontent.com/astoff/digestif/master/scripts/digestifi
    chmod +x ~/.local/bin/digestif

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

## Firefox Theme
read -p "Do you wish to install Firefox Gnome theme? [y/n] " install_theme_var
if [[ $install_theme_var = y ]]; then
    curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash
fi
echo ""
##

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
echo ""
echo "Done! 😊"
