if [[ "$1" == "--init" ]]; then
    # Killall these prev processes
    killall -9 wob
    # Wait until the processes have been shut down
    while pgrep -u $UID -x wob >/dev/null; do sleep 1; done

    wob_cmd='wob -p 0 -M 0 -b 0 -H 34 --background-color #E6000000 --bar-color #CCFFFFFF'

    dirs=("/tmp/wob_volume_pipe" "/tmp/wob_backlight_pipe")
    for item in ${dirs[@]}; do
        rm $item
        mkfifo $item
        tail -f $item | $wob_cmd &
    done

    # Special case for keyboard brightness
    res=$(brightnessctl --device='*kbd_backlight' get 2>&1)
    item="/tmp/wob_keyboard_brightness_pipe"
    rm $item
    if [[ "$res" != *"not found"* ]]; then
        max=$(brightnessctl --device='*kbd_backlight' m)
        mkfifo $item
        tail -f $item | $wob_cmd -m $max &
    fi
    unset $res
    unset $item

    exit 0
fi

volume_inc=5
backlight_inc=10

# Set value
case $1 in
"volume")
    file="/tmp/wob_volume_pipe"
    is_mute=false
    case $2 in
    "raise")
        amixer -D pulse set Master on >/dev/null
        amixer -D pulse set Master "$volume_inc"%+ >/dev/null
        ;;
    "lower")
        amixer -D pulse set Master on >/dev/null
        amixer -D pulse set Master "$volume_inc"%- >/dev/null
        ;;
    "mute")
        amixer -D pulse set Master off >/dev/null
        is_mute=true
        ;;
    *)
        echo "not correct!"
        exit 1
        ;;
    esac
    value=$(pamixer --get-volume)
    ;;

"backlight")
    file="/tmp/wob_backlight_pipe"
    case $2 in
    "raise")
        inc=+"$backlight_inc"%
        ;;
    "lower")
        res=$(brightnessctl info | sed -En 's/.*\(([0-9]+)%\).*/\1/p' 2>&1)
        if [[ $res -eq 0 ]]; then
            inc=$+0%
        else
            inc="$backlight_inc"%-
        fi
        ;;
    *)
        echo "not correct!"
        exit 1
        ;;
    esac
    value=$(brightnessctl set $inc | sed -En 's/.*\(([0-9]+)%\).*/\1/p')
    unset $inc
    ;;

"keyboard")
    file="/tmp/wob_keyboard_brightness_pipe"
    value=$(brightnessctl --device='*kbd_backlight' get 2>&1)
    if [[ "$value" == *"not found"* ]]; then exit 0; fi
    ;;

*)
    echo "not correct!"
    exit 1
    ;;
esac

echo $value >$file
