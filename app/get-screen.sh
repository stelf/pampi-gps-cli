#!/bin/bash

DISPLAY=:0 import -window root /home/pi/current-screen.jpg
scp -P2299 /home/pi/current-screen.jpg pi-chan@dev2-bg.plan-vision.com:~/screens/`cat /etc/hostname`.jpg
