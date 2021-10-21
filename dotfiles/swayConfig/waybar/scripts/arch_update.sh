#!/usr/bin/zsh

if hash paru 2>/dev/null; then
    cmd="paru"
elif hash yay 2>/dev/null; then
    cmd="yay"
elif hash pikaur 2>/dev/null; then
    cmd="yay"
elif hash pacman 2>/dev/null; then
    cmd="pacman"
fi
if [[ $cmd != "" ]]; then
    $cmd -Syu
fi

if hash flatpak 2>/dev/null; then
    flatpak update
fi

if hash snap 2>/dev/null; then
    sudo snap refresh
fi
