#!/usr/bin/env sh

# Dependencies:
# - swaymsg
# - jq
# - slurp
# - awk

# Get the sway tree and store the output
SWAY_TREE=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?)')

# Invoke slurp to let the user select a window
SELECTION=$(echo $SWAY_TREE | jq -r '.rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)

# Extract the X, Y, Width, and Height from the selection
X=$(echo $SELECTION | awk -F'[, x]' '{print $1}')
Y=$(echo $SELECTION | awk -F'[, x]' '{print $2}')
W=$(echo $SELECTION | awk -F'[, x]' '{print $3}')
H=$(echo $SELECTION | awk -F'[, x]' '{print $4}')

# Find the window matching the selection
echo $SWAY_TREE | jq -r --argjson x $X --argjson y $Y --argjson w $W --argjson h $H \
  '. | select(.rect.x == $x and .rect.y == $y and .rect.width == $w and .rect.height == $h)'
