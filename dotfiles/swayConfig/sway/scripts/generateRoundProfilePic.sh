profilePic=$(python ~/.config/sway/scripts/profilePicture.py)
# profilePic="$HOME/.config/sway/assets/profile_pic_default.svg"
picW=$(identify -format %w $profilePic)
picH=$(identify -format %h $profilePic)
picW2=$(echo $picW | awk '{print $1/2}')
picH2=$(echo $picH | awk '{print $1/2}')

tmpDir="/tmp/profile_pic_$USER.png"
rm $tmpDir

convert $profilePic \( +clone -threshold -1 -negate -fill white -draw "circle $picW2, $picH2 $picW2, 0" \) -alpha Off -compose copy_opacity -composite $tmpDir

echo $tmpDir
