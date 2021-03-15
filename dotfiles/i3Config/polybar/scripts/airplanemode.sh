#!/bin/bash

function toggleAirplaneMode(){
    case $1 in
      "--block")
        rfkill block all;;
      *)
        rfkill unblock all;;
    esac
}

for var in $(rfkill -J | jq -r '.[""][].soft'); do
    if [ $var == "unblocked" ]; then
        if [ "$1" == "--toggle" ]; then
            toggleAirplaneMode --block
        fi
        echo %{F#66ffffff}✈%{F-}
        exit 0
    fi
done
if [ "$1" == "--toggle" ]; then
    toggleAirplaneMode
fi
echo %{F#ffffff}✈%{F-}

