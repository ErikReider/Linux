#!/bin/bash
number=0
lastIndex=""

for var in `pactl list sources short`
do
    number=$((number+1))
    mod=$((number%7))
    # echo $number $word    $mod
    if [ "$mod" -eq "1" ] || [ "$mod" -eq "2" ];
    then
        numberTwo=$((numberTwo+1))
        modTwo=$((numberTwo%2))
        if [ "${modTwo}" -eq "1" ]
        then
            lastIndex=$var
        else
            if [[ "$var" == *"input"* ]];
            then
                echo "index ${lastIndex} - ${var}"
            fi
        fi
    fi
done