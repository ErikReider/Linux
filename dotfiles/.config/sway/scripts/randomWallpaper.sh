#!/bin/sh

# exit on error
set -e

# set $SWAYSOCK if it's not set (for systemd or cron)
if [ -z "$SWAYSOCK" ]; then
  export SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -x sway).sock
fi

wlpath=${WALLPAPER_PATH:-"$HOME/.cache/wallpaper"}
output=${WALLPAPER_OUTPUT:-"*"}
url="https://source.unsplash.com/1920x1080/?city,night,ocean,space,fire,hell"

# Checks if gotten wallpaper within 1 hour
if [[ -f $HOME/.cache/wallpaper ]]; then
    time=$(date +%s)
    create=$(stat -c %Y $HOME/.cache/wallpaper)
fi
if [[ ! -f $HOME/.cache/wallpaper ]] || [[ "$1" == "--click" ]] || [[ $((($time - $create) / 60)) -ge 60 ]]; then
    curl -L "$url" -s > $wlpath
fi

killall swaybg || true

swaymsg "output $output bg $wlpath fill"
