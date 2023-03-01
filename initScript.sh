#!/usr/bin/bash

distroName=$(cat < /etc/os-release | grep "^ID" | awk -F= '{print $2}')

currentDir=$(dirname $(readlink -f "$0"))
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
if [[ "$distroName" == "fedora" ]]; then
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
        sudo flatpak install --reinstall flathub $(flatpak list --app-runtime=org.fedoraproject.Platform --columns=application | tail -n +1 )
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
    # .pam_environment
    cd "$HOME"
    ln -si "$currentDir/dotfiles/.pam_environment" .

    # ~/.config/environment.d/*
    if ! [ -d "$HOME/.config/environment.d/" ]; then
        mkdir "$HOME/.config/environment.d/"
    fi
    cd "$HOME/.config/environment.d/"
    ln -si "$currentDir/dotfiles/environment.d/"* .

    # /etc/sysctl.d/*
    [ -d "/etc/sysctl.d/" ] || sudo mkdir /etc/sysctl.d/
    cd /etc/sysctl.d/
    sudo cp -ir "$currentDir/dotfiles/etc/sysctl.d/"* .

    # /etc/dnf/dnf.conf
    if [ -f "/etc/dnf/dnf.conf" ]; then
        cd /etc/dnf/
        sudo cp -ib "$currentDir/dotfiles/etc/dnf/dnf.conf" .
    fi

    # ~/.config/MangoHud/*
    [ -d "$HOME/.config/MangoHud" ] || mkdir "$HOME/.config/MangoHud"
    cd "$HOME/.config/MangoHud"
    ln -si "$currentDir/dotfiles/MangoHud/"* .

    cd "$currentDir"
fi
echo ""
##

## Package managers
read -rp "Do you wish to install all package managers? [y/n] " install_pkg_var
if [[ $install_pkg_var == y ]]; then
    source ./packages/packages-pkg_managers.sh

    if [[ "$distroName" == "arch" ]]; then
        # Install yay
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        cd "$currentDir"

        yay -S --needed "${common[@]}" "${arch[@]}"
    elif [[ "$distroName" == "fedora" ]]; then
        sudo dnf groupinstall "Development Tools"
        sudo dnf install "${common[@]}" "${fedora[@]}"

        # Install LURE (Linux User REpository)
        ./scripts/install_lure.sh
    fi

    lure ar -n "self-repo" -u "https://github.com/ErikReider/lure-repo.git"

    # Install Brew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
echo ""
##

## Applications
read -rp "Do you wish to install all Applications? [y/n] " install_app_var
if [[ $install_app_var == y ]]; then
    source ./packages/packages-all_apps.sh

    if [[ "$distroName" == "arch" ]]; then
        yay -S --needed "${common[@]}" "${arch[@]}"
    elif [[ "$distroName" == "fedora" ]]; then
        # VSCode
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

        sudo dnf copr enable nickavem/adw-gtk3

        dnf check-update

        sudo dnf install "${common[@]}" "${fedora[@]}"
    fi

    if [ ${#fedoraRemove[@]} -gt 0 ]; then
        sudo dnf remove "${fedoraRemove[@]}"
    fi

    # Install Nerd Font patched Fira Code fonts
    cd /tmp && git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
    cd nerd-fonts
    git pull
    git sparse-checkout add patched-fonts/FiraCode
    ./install.sh --remove
    ./install.sh
    cd "$currentDir"

    flatpak install Spotify mailspring io.github.shiftey.Desktop ch.protonmail.protonmail-bridge
fi
echo ""
##

## Dev Tools
read -rp "Do you wish to install dev tools? [y/n] " install_dev_tools
if [[ $install_dev_tools == y ]]; then
    source ./packages/packages-dev_tools.sh

    if [[ "$distroName" == "arch" ]]; then
        yay -S --needed "${common[@]}" "${arch[@]}"
    elif [[ "$distroName" == "fedora" ]]; then
        sudo dnf copr enable atim/lazygit -y
        sudo dnf copr enable atim/lazydocker -y
        sudo dnf copr enable agriffis/neovim-nightly
        sudo dnf copr enable rubemlrm/act-cli
        sudo dnf groupinstall "Development Tools"
        sudo dnf groupinstall "RPM Development Tools"
        sudo dnf install "${common[@]}" "${fedora[@]}"
    fi

    # install deno
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
    source ./packages/packages-zsh.sh

    if [[ "$distroName" == "arch" ]]; then
        yay -S --needed "${common[@]}" "${arch[@]}"
    elif [[ "$distroName" == "fedora" ]]; then
        sudo dnf install "${common[@]}" "${fedora[@]}"
    fi

    sudo chsh --shell=/bin/zsh "$USER"

    cd "$HOME"
    # Remove provided configs and themes
    rm -rf zsh .zshrc

    ln -s "$currentDir"/dotfiles/zsh/.zshrc .zshrc
    ln -s "$currentDir"/dotfiles/zsh/.zprofile .zprofile
    ln -s "$currentDir"/dotfiles/zsh .

    # Set password feedback
    read -rp "Copy this 'Defaults pwfeedback', paste it to the top of the file. Understood? [y/n] " visudo_var
    if [[ $visudo_var == y ]]; then
        export EDITOR=/usr/bin/nvim
        sudo visudo
    fi
fi
echo ""
##

## Neovim
read -rp "Do you wish to link NeoVim config files? [y/n] " vim_var
if [[ $vim_var == y ]]; then
    cd "$currentDir"
    source ./packages/packages-nvim.sh
    source ./packages/packages-nvim.sh

    if [[ "$distroName" == "arch" ]]; then
        pip install neovim
        yay -S --needed "${common[@]}" "${arch[@]}"
    elif [[ "$distroName" == "fedora" ]]; then
        sudo dnf install "${common[@]}" "${fedora[@]}"
    fi

    # Formatters
    sudo npm i -g --save-dev --save-exact prettier @prettier/plugin-xml

    sudo npm install -g neovim

    brew install dart-sdk

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

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
echo ""
echo "Done! 😊"
