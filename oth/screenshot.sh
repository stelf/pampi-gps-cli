#!/bin/bash

echo == setup recurring screenshot ==

sudo apt install imagemagick
sudo sh -c 'echo "*/5 * * * * DISPLAY=:0 import -window root /home/pi/current-screen.jpg -q 5" >> /var/spool/cron/crontabs/pi'

sudo sh -c 'echo LC_ALL="en_GB.utf8" >> /etc/default/locale'

echo == update wsh ==

cd /home/pi/wsh
npm install log4node
git remote add bot ssh://visionr@dev2-bg.plan-vision.com:2299/wsh/
for i in $(pgrep -f monitor); do kill $i; echo stopped $i; done 
git pull bot HEAD
rm /home/pi/wsh/js/external*.js

