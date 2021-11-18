if [ x"$DESKTOP_SESSION" = x"sway" ]; then
    export QT_QPA_PLATFORMTHEME=qt5ct
    export QT_QPA_PLATFORM=wayland
    export QT_QPA_PLATFORM=xcb
    export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
fi
if [ x"$DESKTOP_SESSION" = x"i3" ]; then
    export QT_QPA_PLATFORMTHEME=qt5ct
    export QT_QPA_PLATFORM=xcb
fi
