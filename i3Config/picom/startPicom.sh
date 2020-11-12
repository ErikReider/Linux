#!/bin/bash
if ps -A | grep picom; then
    killall -q picom
fi

picom --config $HOME/.config/picom/picom.conf --experimental-backends --log-file $HOME/picom.log