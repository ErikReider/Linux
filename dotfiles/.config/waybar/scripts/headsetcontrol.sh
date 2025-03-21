#!/bin/bash

# Get headsetcontrol result and exit if invalid
headetResult=$(headsetcontrol -b 2>&1) || {
    echo ""
    exit 1
}

if [[ $headetResult != *"Unavailable"* ]]; then
    charge=$(echo $headetResult | awk '{print $NF}')
    if [[ $charge == "" ]]; then
        charge="100%"
    elif [[ $charge == "Charging" ]]; then
        charge=""
    fi
    echo " $charge"
else
    echo
fi
