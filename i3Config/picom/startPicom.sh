#!/bin/bash
if ps -A | grep picom; then
    killall -q picom
fi

picom --config ~/.config/picom/picom.conf &