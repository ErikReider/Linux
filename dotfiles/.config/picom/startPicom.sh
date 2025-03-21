#!/bin/bash
pgrep -x picom >/dev/null || picom --config $HOME/.config/picom/picom.conf --experimental-backends
