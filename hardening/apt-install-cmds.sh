#!/bin/sh

apt-get update -y
apt-get upgrade -y

apt-get install -qy aptitude

aptitude -y full-upgrade

apt-get install -qy intel-microcode

apt-get install -qy vim
apt-get install -qy net-tools
apt-get install -qy kate

apt-get install -qy xterm foot

apt-get install -qy docker.io

apt-get install -qy build-essential
apt-get install -qy debhelper
apt-get install -qy pbuilder
apt-get install -qy devscripts

apt-get install -qy gimp
apt-get install -qy opensc
apt-get install -qy vlc

# disable ubuntu-fan (net) service
systemctl disable ubuntu-fan.service
