imgBase="$HOME/.config/sway/assets/"
img=""
volume_inc=5
backlight_inc=10

alpha="0.8"
bg="rgba(0, 0, 0, $alpha)"
fg="rgba(255, 255, 255, $alpha)"

# Set value
case $1 in
"volume")
    is_mute=$(pamixer --get-mute)
    case $2 in
    "raise")
        pamixer --unmute
        pamixer -i $volume_inc
        ;;
    "lower")
        pamixer --unmute
        pamixer -d $volume_inc
        ;;
    "mute")
        pamixer --toggle-mute
        is_mute=$(pamixer --get-mute)
        ;;
    *)
        echo "not correct!"
        exit 1
        ;;
    esac
    value=$(pamixer --get-volume)
    if [[ "$is_mute" == "true" ]] || ((value <= 0)); then
        img="${imgBase}volume_muted.svg"
    else
        if ((value <= 33)); then
            img="${imgBase}volume_low.svg"
        elif ((value <= 67)); then
            img="${imgBase}volume_medium.svg"
        else
            img="${imgBase}volume_high.svg"
        fi
    fi
    ;;

"backlight")
    case $2 in
    "raise")
        inc=+"$backlight_inc"%
        ;;
    "lower")
        res=$(brightnessctl info | sed -En 's/.*\(([0-9]+)%\).*/\1/p' 2>&1)
        if [[ $res -lt $backlight_inc ]]; then
            inc=+0%
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

    if ((value <= 33)); then
        img="${imgBase}brightness_low.svg"
    elif ((value <= 67)); then
        img="${imgBase}brightness_medium.svg"
    else
        img="${imgBase}brightness_high.svg"
    fi
    ;;

"keyboard")
    value=$(brightnessctl --device='*kbd_backlight' get 2>&1)
    if [[ "$value" == *"not found"* ]]; then exit 0; fi

    if ((value <= 33)); then
        img="${imgBase}brightness_low.svg"
    elif ((value <= 67)); then
        img="${imgBase}brightness_medium.svg"
    else
        img="${imgBase}brightness_high.svg"
    fi
    ;;

*)
    echo "not correct!"
    exit 1
    ;;
esac

value=$(echo "scale=2; $value / 100.0" | bc)

avizo-client --image-path="$img" --progress="$value" --background="$bg" --foreground="$fg" --time="0.5"
