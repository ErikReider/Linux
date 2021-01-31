#/bin/bash

IFS=$'\n'

games=()
found=false
for D in ~/.steam/root $(egrep '^[^"]*"[0-9]+"' ~/.steam/root/steamapps/libraryfolders.vdf | cut -d\" -f4); do 
    for F in "$D"/steamapps/appmanifest_*.acf; do 
        name="$(grep '"name"' "$F" | cut -d\" -f4)"
        id="$(grep '"appid"' "$F" | cut -d\" -f4)"
        if [[ "$1" != "" ]] && [[ ${name^} == *"${1^}"* ]]; then
            echo $id $name
            found=true
            continue
        fi
        games+=("$id $name")
    done
done

if [[ $found == true ]]; then
    exit 0
fi

games=($(sort -g <<<"${games[*]}"))

for game in ${games[@]}; do echo $game; done
