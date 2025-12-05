#!/bin/sh

# mask user snapd services
systemctl mask --user snap.prompting-client.daemon.service
systemctl mask --user snap.snapd-desktop-integration.snapd-desktop-integration.service
systemctl mask --user snapd.session-agent.socket

# mask user timers
systemctl mask --user snap.firmware-updater.firmware-notifier.timer

# make xdg autostart dir
mkdir ~/.config/autostart

# copy .desktop files
cp /etc/xdg/autostart/geoclue-demo-agent.desktop ~/.config/autostart/
cp /etc/xdg/autostart/im-launch.desktop ~/.config/autostart/
cp /etc/xdg/autostart/orca-autostart.desktop ~/.config/autostart/
cp /etc/xdg/autostart/org.gnome.Evolution-alarm-notify.desktop ~/.config/autostart/
cp /etc/xdg/autostart/snap-userd-autostart.desktop ~/.config/autostart/
cp /etc/xdg/autostart/spice-vdagent.desktop ~/.config/autostart/
cp /etc/xdg/autostart/ubuntu-advantage-notification.desktop ~/.config/autostart/
cp /etc/xdg/autostart/ubuntu-report-on-upgrade.desktop ~/.config/autostart/
cp /etc/xdg/autostart/update-notifier.desktop ~/.config/autostart/

# disable autostart
echo "Hidden=true" >> ~/.config/autostart/geoclue-demo-agent.desktop
echo "Hidden=true" >> ~/.config/autostart/im-launch.desktop
echo "Hidden=true" >> ~/.config/autostart/orca-autostart.desktop
echo "Hidden=true" >> ~/.config/autostart/org.gnome.Evolution-alarm-notify.desktop
echo "Hidden=true" >> ~/.config/autostart/snap-userd-autostart.desktop
echo "Hidden=true" >> ~/.config/autostart/spice-vdagent.desktop
echo "Hidden=true" >> ~/.config/autostart/ubuntu-advantage-notification.desktop
echo "Hidden=true" >> ~/.config/autostart/ubuntu-report-on-upgrade.desktop
echo "Hidden=true" >> ~/.config/autostart/update-notifier.desktop

# disable gnome extensions
gnome-extensions disable ding@rastersoft.com
gnome-extensions disable snapd-prompting@canonical.com
