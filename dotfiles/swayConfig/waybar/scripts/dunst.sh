state=$(dunstctl is-paused)
count=$(dunstctl count waiting)
if [[ $count == 0 ]]; then
    unset count;
else
    count=" #$count"
fi
echo '{"text":"'$count'","tooltip":"","alt":"'$state'","class":"'$state'"}'
