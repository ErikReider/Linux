while read line; do
    count_data=$(echo $line | jq .count)
    dnd=$(echo $line | jq .dnd)
    text=""
    if [[ $dnd == true ]]; then
        text=""
    fi
    if ((count_data > 0)); then count="noti"; else count="none"; fi
    echo '{"text":"'$text'","tooltip":"","alt":"'$count'","class":"'$count'"}'
done </dev/stdin
