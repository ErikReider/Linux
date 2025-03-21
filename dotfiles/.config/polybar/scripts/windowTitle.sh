#!/usr/bin/env bash
echo $(ps -e | grep $(xdotool getwindowpid $(xdotool getwindowfocus)) | grep -v grep | awk '{print $4}' | sed -e "s/\b\(.\)/\u\1/g")