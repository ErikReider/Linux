#!/usr/bin/bash

distroName=$(cat </etc/os-release | grep "^ID" | awk -F= '{print $2}')

currentDir="$(dirname "$(readlink -f "$0")")"
cd "$currentDir"

## Flatpak theme override
read -rp "Do you wish to enable flatpatk theme override? [y/n] " flatpakTheme
if [[ $flatpakTheme == y ]]; then
    flatpak install flathub --system org.gtk.Gtk3theme.Adwaita-dark
    flatpak install flathub --user org.gtk.Gtk3theme.Adwaita-dark
    sudo flatpak override --filesystem=~/.themes
    sudo flatpak override --filesystem=~/themes
    sudo flatpak override --filesystem=~/.local/share/themes
    sudo flatpak override --filesystem=/usr/share/themes
fi
echo ""
##

## Fedora tweaks
if [[ $distroName == "fedora" ]]; then
    read -rp "Do you wish to tweak Fedora (enable 3rd-party repos, install codecs, firmware, etc...)? [y/n] " tweakFedora
    if [[ $tweakFedora == y ]]; then
        # Enable rpmfusion
        sudo rpm -Uvh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm
        sudo rpm -Uvh http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
        # Add flathub as flatpak repo
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        # Add flathub beta as flatpak repo
        flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
        # Reinstall flatpaks with flathub repo
        sudo flatpak install --reinstall flathub "$(flatpak list --app-runtime=org.fedoraproject.Platform --columns=application | tail -n +1)"
        # Remove fedora flatpak repo
        sudo flatpak remote-delete fedora
        sudo flatpak remote-delete fedora-testing
        # Codecs
        sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base,ugly-\*,ugly} gstreamer1-plugin-openh264 gstreamer1-libav mozilla-openh264
        sudo dnf install lame\* --exclude=lame-devel
        sudo dnf install libva libva-utils libva-intel-driver libva-intel-hybrid-driver ffmpeg
        sudo dnf install gstreamer1-vaapi intel-media-driver
        sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
        sudo dnf groupupdate sound-and-video
        sudo dnf group upgrade --with-optional Multimedia
        sudo dnf config-manager --set-enabled fedora-cisco-openh264
        # Codecs in Mesa
        sudo dnf swap --enablerepo=rpmfusion-free-updates-testing mesa-va-drivers mesa-va-drivers-freeworld
        sudo dnf swap --enablerepo=rpmfusion-free-updates-testing mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
        # Enable thirdparty fedora repos
        sudo dnf install fedora-workstation-repositories
        # Update application data
        sudo dnf groupupdate core
        # Install extra drivers and libraries
        sudo dnf install rpmfusion-free-release-tainted
        sudo dnf install libdvdcss
        # Install extra firmware utilities:
        sudo dnf install rpmfusion-nonfree-release-tainted
        sudo dnf install \*-firmware
    fi
    echo ""
fi
##

## Needed Config Files
read -rp "Do you wish to symlink needed config files? [y/n] " symlink_etc_var
if [[ $symlink_etc_var == y ]]; then
    # /etc/sysctl.d/*
    [ -d "/etc/sysctl.d/" ] || sudo mkdir /etc/sysctl.d/
    cd /etc/sysctl.d/
    sudo cp -ir "$currentDir/system_dotfiles/etc/sysctl.d/"* .

    # /etc/dnf/dnf.conf
    if [ -f "/etc/dnf/dnf.conf" ]; then
        cd /etc/dnf/
        sudo cp -ib "$currentDir/system_dotfiles/etc/dnf/dnf.conf" .
    fi

    # Install stow
    echo "Making sure that GNU stow is installed"
    if [[ $distroName == "arch" ]]; then
        sudo pacman -S stow
    elif [[ $distroName == "fedora" ]]; then
        sudo dnf install stow
    fi

    # Home files
    stow -t "$HOME" "$currentDir/dotfiles" -R

    # ~/.local/share/applications/*
    if ! [ -d "$HOME/.local/share/applications/" ]; then
        mkdir "$HOME/.local/share/applications/"
    fi
    cd "$HOME/.local/share/applications/"
    ln -si "$currentDir/dotfiles/applications/"* .

    cd "$currentDir"
fi
echo ""
##

## Package managers
read -rp "Do you wish to install all package managers? [y/n] " install_pkg_var
if [[ $install_pkg_var == y ]]; then
    cd "$currentDir"
    source "$currentDir/packages/packages-pkg_managers.sh"

    if [[ $distroName == "arch" ]]; then
        # Install yay
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        cd "$currentDir"

        yay -S --needed "${common[@]}" "${arch[@]}"
    elif [[ $distroName == "fedora" ]]; then
        sudo dnf groupinstall "Development Tools"
        sudo dnf install "${common[@]}" "${fedora[@]}"

        # Install LURE (Linux User REpository)
        "$currentDir/scripts/install_lure.sh"
    fi

    lure ar -n "self-repo" -u "https://github.com/ErikReider/lure-repo.git"
fi
echo ""
##

## Applications
read -rp "Do you wish to install all Applications? [y/n] " install_app_var
if [[ $install_app_var == y ]]; then
    cd "$currentDir"
    source "$currentDir/packages/packages-all_apps.sh"

    if [[ $distroName == "arch" ]]; then
        yay -S --needed "${common[@]}" "${arch[@]}"
    elif [[ $distroName == "fedora" ]]; then
        # VSCode
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

        # Copr repos
        sudo dnf copr enable principis/NoiseTorch -y
        sudo dnf copr enable alebastr/sway-extras -y
        sudo dnf copr enable erikreider/packages -y
        sudo dnf copr enable solopasha/hyprland -y
        sudo dnf copr enable swayfx/swayfx -y
        sudo dnf copr enable ublue-os/akmods -y

        # Add thirdparty Terra repo
        sudo dnf config-manager --add-repo https://terra.fyralabs.com/terra.repo

        dnf check-update

        sudo dnf install "${common[@]}" "${fedora[@]}"

        if [ ${#fedoraRemove[@]} -gt 0 ]; then
            sudo dnf remove "${fedoraRemove[@]}"
        fi

        # Setup MS fonts
        sudo dnf install curl cabextract xorg-x11-font-utils fontconfig
        sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
    fi

    sudo fc-cache -v

    # GTK Defaults
    gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
    gsettings set org.gnome.desktop.interface font-antialiasing "greyscale"
    gsettings set org.gnome.desktop.interface font-hinting "slight"
    gsettings set org.gnome.desktop.interface font-name "Clear Sans 11"
    gsettings set org.gnome.desktop.interface document-font-name "Clear Sans 11"
    gsettings set org.gnome.desktop.wm.preferences titlebar-font "Clear Sans Bold 11"
    gsettings set org.gnome.desktop.interface monospace-font-name "FiraCode Nerd Font weight=450 10"

    # Install Nerd Font patched Fira Code fonts
    cd /tmp
    git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
    cd nerd-fonts
    git pull
    git sparse-checkout add patched-fonts/FiraCode
    ./install.sh --remove
    ./install.sh
    cd "$currentDir"

    flatpak install "${flatpak[@]}"
    flatpak install "${flatpak_beta[@]}"
fi
echo ""
##

## Dev Tools
read -rp "Do you wish to install dev tools? [y/n] " install_dev_tools
if [[ $install_dev_tools == y ]]; then
    cd "$currentDir"
    source "$currentDir/packages/packages-dev_tools.sh"

    if [[ $distroName == "arch" ]]; then
        yay -S --needed "${common[@]}" "${arch[@]}"
    elif [[ $distroName == "fedora" ]]; then
        sudo dnf copr enable atim/lazygit -y
        sudo dnf copr enable atim/lazydocker -y
        # sudo dnf copr enable agriffis/neovim-nightly -y
        sudo dnf copr enable rubemlrm/act-cli -y
        sudo dnf groupinstall "Development Tools"
        sudo dnf groupinstall "RPM Development Tools"
        sudo dnf group install c-development
        sudo dnf install "${common[@]}" "${fedora[@]}"
    fi

    # Symlink GDB config file
    cd "$HOME/.config"
    ln -si "$currentDir/dotfiles/gdb" .

    # Install Flutter
    "$currentDir/scripts/install_flutter.sh"

    # Install deno
    curl -fsSL https://deno.land/x/install/install.sh | sh

    # Start docker daemon with system
    sudo systemctl enable --now docker
    # Add user to docker group
    sudo groupadd docker
    sudo usermod -aG docker "$USER"
fi
echo ""
##

## ZSH
read -rp "Do you wish to switch to ZSH? [y/n] " change_to_bash_var
if [[ $change_to_bash_var == y ]]; then
    cd "$currentDir"
    source "$currentDir/packages/packages-zsh.sh"

    if [[ $distroName == "arch" ]]; then
        yay -S --needed "${common[@]}" "${arch[@]}"
    elif [[ $distroName == "fedora" ]]; then
        sudo dnf install "${common[@]}" "${fedora[@]}"
    fi

    sudo chsh --shell=/bin/zsh "$USER"

    cd "$HOME"
    # Remove provided configs and themes
    rm -rf zsh .zshrc

    ln -s "$currentDir"/dotfiles/zsh/.zshrc .zshrc
    ln -s "$currentDir"/dotfiles/zsh/.zprofile .zprofile
    ln -s "$currentDir"/dotfiles/zsh .
fi
echo ""
##

## Neovim
read -rp "Do you wish to link NeoVim config files? [y/n] " vim_var
if [[ $vim_var == y ]]; then
    cd "$currentDir"
    source "$currentDir/packages/packages-nvim.sh"

    if [[ $distroName == "arch" ]]; then
        yay -S --needed "${common[@]}" "${arch[@]}"
    elif [[ $distroName == "fedora" ]]; then
        sudo dnf install "${common[@]}" "${fedora[@]}"
    fi

    # Formatters
    sudo npm i -g --save-dev --save-exact prettier @prettier/plugin-xml

    sudo npm install -g neovim

    pip3 install --user neovim
    # Install Evince PDF line following for LaTeX
    pip3 install --user https://github.com/efoerster/evince-synctex/archive/master.zip

    # brew install dart-sdk

    cd ~/.config/
    rm -rf nvim

    ln -s "$currentDir"/dotfiles/nvim nvim
    cd "$currentDir"

    # Install Vim Plug
    sh -c 'curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    nvim -es -u ~/.config/nvim/init.lua -i NONE -c "PlugInstall" -c "qa"
fi
echo ""
##

## Gaming
read -rp "Do you wish to install Gaming software? [y/n] " install_gaming_tools
if [[ $install_gaming_tools == y ]]; then
    source "$currentDir/packages/packages-gaming.sh"

    if [[ $distroName == "arch" ]]; then
        yay -S --needed "${common[@]}" "${arch[@]}"
    elif [[ $distroName == "fedora" ]]; then
        read -rp "Use mesa-git? [y/n] " use_mesa_git
        if [[ $use_mesa_git == y ]]; then
            sudo dnf copr enable xxmitsu/mesa-git -y
            sudo dnf update
            sudo dnf swap mesa-va-drivers-freeworld mesa-va-drivers
            sudo dnf swap mesa-vdpau-drivers-freeworld mesa-vdpau-drivers
        fi
        sudo dnf install "${common[@]}" "${fedora[@]}"
    fi

    flatpak install "${flatpak[@]}"
fi
echo ""
##

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
echo ""
echo "Done! 😊"
