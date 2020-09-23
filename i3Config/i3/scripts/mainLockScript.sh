# Disable defaults
# https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling
# https://www.linuxquestions.org/questions/arch-29/screen-goes-blank-after-ten-minutes-in-lxde-how-to-change-this-769000/
xset s off -dpms
# Killall these prev processes
killall -9 xss-lock
killall -9 xidlehook
# Wait until the processes have been shut down
while pgrep -u $UID -x xss-lock >/dev/null; do sleep 1; done
while pgrep -u $UID -x xidlehook >/dev/null; do sleep 1; done
# xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
# screen before suspend. Use loginctl lock-session to lock your screen.
xss-lock --transfer-sleep-lock -- ~/.config/i3/scripts/lock.sh &
# Activate the idle listener with it's callbacks
xidlehook --not-when-fullscreen --not-when-audio \
  --timer 900 \
    './dimAllDisplays.sh -d' \
    './dimAllDisplays.sh' \
  --timer 10 \
    'loginctl lock-session; ./dimAllDisplays.sh' \
    '' \
  --timer 30 \
    'xset dpms force off' \
    '' &