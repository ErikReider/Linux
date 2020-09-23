function dim {
    if type "xrandr"; then
        for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
            xrandr --output "$m" --brightness $1
        done
    fi
}

[[ $1 == "--dim" || $1 == "-d" ]] && dim 0.1 || dim 1