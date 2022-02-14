if [ x"$DESKTOP_SESSION" = x"sway" ]; then
    export QT_QPA_PLATFORMTHEME=qt5ct
    export QT_QPA_PLATFORM=wayland
    export QT_QPA_PLATFORM=xcb
    export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    export XDG_CURRENT_DESKTOP=sway
fi
if [ x"$DESKTOP_SESSION" = x"i3" ]; then
    export QT_QPA_PLATFORMTHEME=qt5ct
    export QT_QPA_PLATFORM=xcb
fi
if [ x"$DESKTOP_SESSION" = x"plasma" ]; then
   export KWIN_X11_REFRESH_RATE=170000
   export KWIN_X11_NO_SYNC_TO_VBLANK=1
   export KWIN_X11_FORCE_SOFTWARE_VSYNC=1
fi
