## Chrome Dark Mode
read -p  "Do you wish to backup Chrome flags file? [Y/n] " chrome_flags_var
if [[ $chrome_flags_var = y ]]; then
    cp ~/.config/chromium-flags.conf ./assets/
    echo ""
fi
##

## Bash
read -p "Do you wish to backup BASH configs? [Y/n] " bash_backup_var
if [[ $bash_backup_var = y ]]
then
    mv ./assets/.bashrc ./assets/.bashrc.bak
    cp ~/.bashrc ./assets/.bashrc
fi
echo ""
##