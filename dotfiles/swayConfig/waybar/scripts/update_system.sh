#!/bin/bash

distroName=$(cat </etc/os-release | grep "^ID" | awk -F= '{print $2}')

if [[ $distroName == "arch" ]]; then
    if hash paru 2>/dev/null; then
        cmd="paru"
    elif hash yay 2>/dev/null; then
        cmd="yay"
    elif hash pikaur 2>/dev/null; then
        cmd="pikaur"
    elif hash pacman 2>/dev/null; then
        cmd="pacman"
    fi
    if [[ $cmd != "" ]]; then
        $cmd -Syu
    fi
elif [[ $distroName == "fedora" ]]; then
    sudo dnf upgrade --refresh
fi

if hash flatpak 2>/dev/null; then
    flatpak update
fi

if hash snap 2>/dev/null; then
    sudo snap refresh
fi
