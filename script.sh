#!/bin/bash

# Probing v4l2loopback
sudo modprobe v4l2loopback video_nr=4 'card_label=VirtualScreen'

# Select monitor you want to share
xrandr --listactivemonitors
read -p "Which monitor you want to share: " MON_NUMBER

# Change this if you want different FPS rate
FPS_RATE=30

# Parse necessary stuff
MON_PARSE=`xrandr --listactivemonitors | grep "$MON_NUMBER:" | cut -f4 -d' '`
MON_HEIGHT=`echo $MON_PARSE | cut -f2 -d'/' | cut -f2 -d'x'`
MON_WIDTH=`echo $MON_PARSE | cut -f1 -d'/'`
MON_X=`echo $MON_PARSE | cut -f2 -d'+'`
MON_Y=`echo $MON_PARSE | cut -f3 -d'+'`

# echo $MON_HEIGHT
# echo $MON_WIDTH
# echo $MON_X
# echo $MON_Y

# exit

ffmpeg -f x11grab -r $FPS_RATE -s "$MON_WIDTH"x"$MON_HEIGHT" -i $DISPLAY+"$MON_X","$MON_Y" -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video4
