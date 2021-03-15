#!/bin/bash

sens=$(sensors -j)
printVar=""

# Tdie=`grep Tdie <<< "$sens" | awk '{print $2}' | cut -d "+" -f2`
# if [[ $Tdie ]]; then
#     printVar="$printVar""Tdie: $Tdie  "
# fi

intelCPU=`grep "Package id 0:" <<< "$sens" | awk '{print $4}' | cut -d "+" -f2`
if [[ $intelCPU ]]; then
    printVar="$printVar""$intelCPU  "
fi

edge=`grep edge <<< "$sens" | awk '{print $2}' | cut -d "+" -f2`
if [[ $edge ]]; then
    printVar="$printVar""$edge  "
fi

junction=`grep junction <<< "$sens" | awk '{print $2}' | cut -d "+" -f2`
if [[ $junction ]]; then
    printVar="$printVar""$junction  "
fi

GPUFan=`grep fan1 <<< "$sens" | awk '{print $2}' | cut -d "+" -f2`
if [[ $junction ]]; then
    printVar="$printVar"$GPUFan"RPM  "
fi

echo "$printVar"
