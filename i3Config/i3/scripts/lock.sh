#!/bin/sh

rm /tmp/.i3_lock.png
tmpfile=/tmp/.i3_lock.png

scrot "$tmpfile"
convert "$tmpfile" -scale 2.5% -resize 4000% "$tmpfile"
i3lock -i "$tmpfile" -t --ignore-empty-password --show-failed-attempts --nofork -p default
sleep 10 * 60
xset dpms force off