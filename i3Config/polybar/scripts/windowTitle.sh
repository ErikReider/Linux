#!/bin/bash
echo $(ps -e | grep $(xdotool getwindowpid $(xdotool getwindowfocus)) | grep -v grep | awk '{print $4}')