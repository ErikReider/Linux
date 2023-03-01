#!/bin/bash

export common=(
"chromium"
"jq"
"discord"
"kitty"
"vlc"
"file-roller"
"neofetch"
"distrobox"
"gparted"
)
export fedora=(
"sushi"
"adw-gtk3"
"java-1.8.0-openjdk"
"java-11-openjdk"
"java-latest-openjdk"
"intel-clear-sans-fonts"
"liberation-fonts"
"liberation-mono-fonts"
"liberation-sans-fonts"
"liberation-serif-fonts"
)
export arch=(
"sushi"
"pamixer"
"nautilus-copy-path"
"adw-gtk-theme"
"jdk8-openjdk"
"jre8-openjdk"
"jdk11-openjdk"
"jre11-openjdk"
"jdk-openjdk"
"jre-openjdk"
"ttf-clear-sans"
)

# TODO: Install native rpm instead...
# "ch.protonmail.protonmail-bridge"
export flatpak=(
"com.spotify.Client"
"com.getmailspring.Mailspring"
"io.github.shiftey.Desktop"
"org.mozilla.firefox"
"io.github.trigg.discover_overlay"
"com.github.tchx84.Flatseal"
"org.onlyoffice.desktopeditors"
"com.belmoussaoui.Decoder"
"com.getpostman.Postman"
"com.github.alecaddd.sequeler"
"com.github.huluti.Curtail"
"com.github.maoschanz.drawing"
"com.github.PintaProject.Pinta"
"com.github.rafostar.Clapper"
"com.obsproject.Studio"
"fr.romainvigier.MetadataCleaner"
"io.bassi.Amberol"
"io.github.seadve.Mousai"
"org.freedesktop.Piper"
"org.gimp.GIMP"
"org.gnome.Boxes"
"org.gnome.Builder"
"org.gnome.Connections"
"org.gnome.design.Contrast"
"org.gnome.design.IconLibrary"
"org.gnome.design.Lorem"
"org.gnome.design.SymbolicPreview"
"org.gnome.Devhelp"
"org.gnome.dfeet"
"org.gnome.Epiphany"
"org.gnome.SoundRecorder"
"ca.desrt.dconf-editor"
)
export flatpak_beta=(
"com.discordapp.DiscordCanary"
)

export fedoraRemove=(
"firefox"
"fedora-bookmarks"
"libreoffice"
"libreoffice-*"
)
