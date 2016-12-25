#!/bin/bash

echo == setup crons  ==

sudo apt install imagemagick

if ! sudo grep -q DISPLAY /var/spool/cron/crontabs/pi;
then
    echo "= Amend screen capture"
    sudo sh -c 'echo "*/5 * * * * /home/pi/pampi-gps-cli/app/get-screen.sh" >> /var/spool/cron/crontabs/pi'
fi

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

sudo service cron reload

echo == update wsh ==

cd /home/pi/wsh
sudo chown -R pi:pi node_modules
npm install log4node
git remote add bot ssh://visionr@dev2-bg.plan-vision.com:2299/home/visionr/wsh/
for i in $(pgrep -f monitor); do kill $i; echo stopped $i; done 
git pull bot HEAD
rm /home/pi/wsh/js/external*.js
