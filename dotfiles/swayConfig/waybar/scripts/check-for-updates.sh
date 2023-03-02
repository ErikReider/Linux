#!/bin/bash

distroName=$(cat </etc/os-release | grep "^ID" | awk -F= '{print $2}')

if [[ $distroName == "arch" ]]; then
    if ! updates_arch=$(checkupdates 2>/dev/null | wc -l); then
        updates_arch=0
    fi

    if hash paru 2>/dev/null; then
        cmd="paru"
    elif hash yay 2>/dev/null; then
        cmd="yay"
    elif hash pikaur 2>/dev/null; then
        cmd="pikaur"
    elif hash pacman 2>/dev/null; then
        cmd="pacman"
    fi
    updates_aur=0
    if [ "$cmd" != "" ]; then
        if ! updates_aur=$($cmd -Qum 2>/dev/null | wc -l); then
            updates_aur=0
        fi
    fi

    updates=$(("$updates_arch" + "$updates_aur"))
elif [[ $distroName == "fedora" ]]; then
    updates=$(("$(dnf check-update -q --refresh 2>/dev/null | wc -l)" - 1))
    if [[ $updates -lt 1 ]]; then
        updates=0
    fi
fi

if [[ $updates -gt 0 ]]; then
    echo "#$updates"
else
    echo ""
fi
