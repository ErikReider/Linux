#!/bin/bash
GLOBIGNORE="*"

function getActive {
    #sinks or sources
    li=(`pacmd list-$1 | grep -e 'index:'`)
    for((i=0; i<${#li[@]}; i++)); do
        if [[ "${li[i]}" == "*" ]]; then index=${li[${i}+2]}; fi
    done
    echo $index
}


function list {
    number=0
    lastIndex=""
    audioType="$1"
    if [[ "$1" == "input" ]]
    then
        type="sources"
    elif [[ "$1" == "output" ]]
    then
        type="sinks"
    fi
    for var in `pactl list $type short`
    do
        number=$((number+1))
        mod=$((number%7))
        if [ "$mod" == "1" ] || [ "$mod" == "2" ];
        then
            numberTwo=$((numberTwo+1))
            modTwo=$((numberTwo%2))
            if [ "${modTwo}" == "1" ]
            then
                lastIndex=$var
            else
                if [[ "$var" == *"$audioType"* ]];
                then
                    echo "Index ${lastIndex} - ${var}"
                fi
            fi
        fi
    done
}

# list
getActive "sources"