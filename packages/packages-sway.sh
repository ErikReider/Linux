#!/bin/bash

export common=(
    "wmname"
    "ibus"
    "polkit-gnome"
    "gnome-keyring"
    "xdg-desktop-portal"
    "kanshi"
    "gammastep"
    "wdisplays"
    "kitty"
    "qt5ct"
    "geocode-glib"
    "brightnessctl"
    "playerctl"
    "lxappearance"
    "wl-clipboard"
    "wf-recorder"
    "grim"
    "grimshot"
    "slurp"
    "wlogout"
    "swappy"
    "swayidle"
    "udiskie"
    "hyprlock"
    "poweralertd"
    "wayland-logout"
)

export arch=(
    "lsb-release"
    "dbus-python"
    "xdg-desktop-portal-wlr-git"
    "geoclue"
    "bluez"
    "bluez-utils"
    "ttf-roboto"
    "swaync-git"
    "rofi-lbonn-wayland-git"
    "ttf-weather-icons"
    "pacdep"
    "ttf-material-icons-git"
    "avizo"
    "swaytools"
    "wallutils"
    "otf-font-awesome"
    "ttf-font-awesome"
    "appimagelauncher"
    "libappimage"
    "xembed-sni-proxy-git"
)

export fedora=(
    "redhat-lsb-core"
    "dbus-python-devel"
    "python3-dbus"
    "xdg-desktop-portal-wlr"
    "geoclue2"
    "geoclue2-libs"
    "gammastep-indicator"
    "bluez"
    "bluez-tools"
    "qt5-qtconfiguration"
    "rofi-wayland"
    # Wallpapers
    "verne-backgrounds-extras-gnome"
    "verne-backgrounds-gnome"
    "schroedinger-cat-backgrounds-extras-gnome"
    "schroedinger-cat-backgrounds-gnome"
    "deepin-wallpapers"
    "adapta-backgrounds"

    # avizo
    # swaytools
    # wallutils
)

export lure=(
    "autotiling-git"
    # "font-awesome" # Due to issues in CSGO console font rendering. A fontconfig should probably fix?
    "rofi-emoji"
    "sway-audio-idle-inhibit-git"
    "swayfloatingswitcher-git"
    "swayfx-git"
    "swaync-git"
    "swaylock-effects-erikreider-git"
    "swayosd-git"
    "swayscratchpad-git"
    "swaysettings-git"
    "waybar-git"
)
