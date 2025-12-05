#!/bin/sh

# disable multicast on interfaces
ifconfig docker0 -multicast 2>/dev/null
ifconfig [NET_IF_NAME] -multicast

# prevent kernel module load
sysctl -w kernel.modules_disabled=1
