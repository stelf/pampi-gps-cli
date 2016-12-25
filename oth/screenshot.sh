#!/bin/bash

echo == setup recurring screenshot ==

sudo apt install imagemagick
sudo sh -c 'echo "*/5 * * * * DISPLAY=:0 import -window root /home/pi/current-screen.jpg -q 5" >> /var/spool/cron/crontabs/pi'

if ! grep -q LC_ALL /etc/default/locale;
then
    echo "= Amend locale"
    sudo sh -c 'echo LC_ALL="en_GB.utf8" >> /etc/default/locale'
fi

if ! sudo grep -q 1230 /var/spool/cron/crontabs/root;
then
    echo "= Amend cron"
    sudo sh -c 'echo "0 1 * * * /sbin/reboot" >> /var/spool/cron/crontabs/root'
    sudo sh -c 'echo "0 6 * * * /sbin/reboot" >> /var/spool/cron/crontabs/root'
    sudo sh -c 'echo "0 1230 * * * /sbin/reboot" >> /var/spool/cron/crontabs/root'
    sudo sh -c 'echo "0 18 * * * /sbin/reboot" >> /var/spool/cron/crontabs/root'
fi

echo == update wsh ==

cd /home/pi/wsh
npm install log4node
git remote add bot ssh://visionr@dev2-bg.plan-vision.com:2299/wsh/
for i in $(pgrep -f monitor); do kill $i; echo stopped $i; done 
git pull bot HEAD
rm /home/pi/wsh/js/external*.js
    