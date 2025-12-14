#!/bin/sh

# remove unwanted packages
apt-get remove -qy avahi-daemon
apt-get remove -qy bluez bluez-cups bluez-obexd
apt-get remove -qy ubuntu-insights
apt-get remove -qy ubuntu-report
apt-get remove -qy fwupd
apt-get remove -qy unattended-upgrades
apt-get remove -qy speech-dispatcher
apt-get remove -qy ufw
apt-get remove -qy whoopsie
apt-get remove -qy update-notifier

# cleanup
apt-get autoremove -y
