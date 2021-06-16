#!/usr/bin/zsh

yay -Sy
yay -Qu
if updates_arch=$(yay -Qqu 2>/dev/null | wc -l); then
    yay -Su
fi
flatpak update
sudo snap refresh
