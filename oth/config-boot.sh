#!/bin/bash

if ! grep -q temp_limit /boot/config.txt;
then
  echo === IMPROVE SPEED ===
cat >> /boot/config.txt <<EOF
 gpu_mem=320
 arm_freq=1000
 sdram_freq=500
 core_freq=500
 over_voltage=2
 temp_limit=80 #Will throttle to default clock speed if hit.
EOF
fi

raspi-config
rpi-update