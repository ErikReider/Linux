sudo cp ./powertopAutoTune.service /etc/systemd/system/
sudo cp ./powertune.sh /usr/bin/
sudo systemctl enable powertopAutoTune.service
sudo systemctl start powertopAutoTune.service
