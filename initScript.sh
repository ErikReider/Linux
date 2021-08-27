#!/usr/bin/env bash

currentDir=$(dirname $(readlink -f $0))
cd $currentDir

## Flatpak theme override
read -p "Do you wish to enable flatpatk theme override? [y/n] " flatpakTheme
if [[ $flatpakTheme = y ]]; then
    flatpak install flathub --system org.gtk.Gtk3theme.Adwaita-dark
    flatpak install flathub --user org.gtk.Gtk3theme.Adwaita-dark
    sudo flatpak override --filesystem=~/.themes
fi
echo ""
##

## Needed Config Files
read -p "Do you wish to symlink needed config files? [y/n] " symlink_etc_var
if [[ $symlink_etc_var = y ]]; then
    # .pam_environment
    cd $HOME
    sudo ln -s $currentDir/dotfiles/.pam_environment

    cd $currentDir/dotfiles
    sudo chown root ./etc/*
    cd $currentDir
fi
echo ""
##

## Applications
read -p "Do you wish to install all apps? [y/n] " install_app_var
if [[ $install_app_var = y ]]; then

    sudo pacman -S git

    # Install yay
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd $currrentDir

    # Package managers
    sudo yay --needed -S pikaur python-pip flatpak yarn nodejs-lts-fermium npm

    # Applications
    yay --needed -S pamixer firefox chromium nautilus-copy-path jq mailspring noisetorch-git hack-font-ligature-nerd-font-git discord alacritty

    read -p "Do you wish to install java? [y/n]" install_java
    if [[ $install_java = y ]]; then
        yay --needed -S jre-openjdk jre-openjdk-headless jdk-openjdk jdk8-openjdk jre11-openjdk jre11-openjdk-headless jre8-openjdk jre8-openjdk-headless
    fi

    sudo flatpak install Spotify
fi
echo ""
##

## Dev Tools
read -p "Do you wish to install dev tools? [y/n] " install_dev_tools
if [[ $install_dev_tools = y ]]; then
    yay --needed -S visual-studio-code-bin the_silver_searcher bat ripgrep fzf git lazygit

    yay --needed -S dotnet-sdk dart typescript vala python python2 gcc clang meson cmake libsass sassc eslint
fi
echo ""
##

## ZSH
read -p "Do you wish to switch to ZSH? [y/n] " change_to_bash_var
if [[ $change_to_bash_var = y ]]; then
    yay --needed -S zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting
    sudo chsh --shell=/bin/zsh $USER

    cd $HOME
    # Remove provided configs and themes
    rm -rf zsh .zshrc

    ln -s $currentDir/dotfiles/zsh/.zshrc .zshrc
    ln -s $currentDir/dotfiles/zsh .

    mkdir zsh/plugins
    cd zsh/plugins
    ln -s /usr/share/zsh/plugins/* .

    cd $currentDir

    # Set password feedback
    read -p "Copy this 'Defaults pwfeedback', paste it to the top of the file. Understood? [y/n] " visudo_var
    if [[ $visudo_var = y ]]; then
        export EDITOR=/usr/bin/nvim
        sudo visudo
    fi
fi
echo ""
##

## Neovim
read -p "Do you wish to link vim config files? [y/n] " vim_var
if [[ $vim_var = y ]]; then
    yay --needed -S scdoc
    yay --needed -S ccls vala-language-server-git efm-langserver vint lua-format ueberzug digestif lua-language-server bash-language-server uncrustify shfmt prettier pyright omnisharp-roslyn lolcat

    pip install cpplint neovim
    sudo npm install -g neovim

    read -p "Do you wish to install latex packages?" install_latex
    if [[ $install_latex = y ]]; then
        yay --needed -S scdoc
        yay --needed -S texlive-bibtexextra texlive-gantt texlive-pictures texlive-core texlive-fontsextra texlive-latexextra texlive-science biber
    fi

    cd ~/.config/
    rm -rf nvim

    ln -s $currentDir/dotfiles/nvim nvim
    cd $currentDir

    sh -c 'curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    nvim -es -u ~/.config/nvim/init.lua -i NONE -c "PlugInstall" -c "qa"
fi
echo ""
##

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
echo ""
echo "Done! 😊"
