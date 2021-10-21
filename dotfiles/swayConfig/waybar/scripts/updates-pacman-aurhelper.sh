#!/bin/sh

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
if [[ $cmd != "" ]]; then
    if ! updates_aur=$($cmd -Qum 2>/dev/null | wc -l); then
        updates_aur=0
    fi
fi

updates=$(("$updates_arch" + "$updates_aur"))

if [ "$updates" -gt 0 ]; then
    echo " #$updates "
else
    echo "  "
fi
