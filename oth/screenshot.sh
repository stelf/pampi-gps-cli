#!/bin/bash

echo == setup recurring screenshot ==

sudo apt install imagemagick
sudo 'echo */5 * * * * DISPLAY=:0 import -window root /home/pi/current-screen.jpg -q 5 >> /var/spool/cron/crontabs/pi'

echo == update wsh ==

cd /home/pi/wsh
npm install log4node
git remote add bot ssh://visionr@dev2-bg.plan-vision.com:2299/wsh/
for i in $(pgrep -f monitor); do kill $i; echo stopped $i; done 
git pull bot HEAD
rm /home/pi/wsh/js/external*.js

