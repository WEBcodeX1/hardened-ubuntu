#!/bin/sh

# make xdg autostart dir
mkdir -p ~/.config/autostart

# copy .desktop files to /tmp
cp /etc/xdg/autostart/geoclue-demo-agent.desktop /tmp/
cp /etc/xdg/autostart/im-launch.desktop /tmp/
cp /etc/xdg/autostart/orca-autostart.desktop /tmp/
cp /etc/xdg/autostart/org.gnome.Evolution-alarm-notify.desktop /tmp/
cp /etc/xdg/autostart/snap-userd-autostart.desktop /tmp/
cp /etc/xdg/autostart/spice-vdagent.desktop /tmp/
cp /etc/xdg/autostart/ubuntu-advantage-notification.desktop /tmp/
cp /etc/xdg/autostart/ubuntu-report-on-upgrade.desktop /tmp/
cp /etc/xdg/autostart/update-notifier.desktop /tmp/

# disable autostart
echo "Hidden=true" >> /tmp/geoclue-demo-agent.desktop
echo "Hidden=true" >> /tmp/im-launch.desktop
echo "Hidden=true" >> /tmp/orca-autostart.desktop
echo "Hidden=true" >> /tmp/org.gnome.Evolution-alarm-notify.desktop
echo "Hidden=true" >> /tmp/snap-userd-autostart.desktop
echo "Hidden=true" >> /tmp/spice-vdagent.desktop
echo "Hidden=true" >> /tmp/ubuntu-advantage-notification.desktop
echo "Hidden=true" >> /tmp/ubuntu-report-on-upgrade.desktop
echo "Hidden=true" >> /tmp/update-notifier.desktop

# install .desktop files
cp /tmp/geoclue-demo-agent.desktop ~/.config/autostart/
cp /tmp/im-launch.desktop ~/.config/autostart/
cp /tmp/orca-autostart.desktop ~/.config/autostart/
cp /tmp/org.gnome.Evolution-alarm-notify.desktop ~/.config/autostart/
cp /tmp/snap-userd-autostart.desktop ~/.config/autostart/
cp /tmp/spice-vdagent.desktop ~/.config/autostart/
cp /tmp/ubuntu-advantage-notification.desktop ~/.config/autostart/
cp /tmp/ubuntu-report-on-upgrade.desktop ~/.config/autostart/
cp /tmp/update-notifier.desktop ~/.config/autostart/

# disable gnome extensions
desktop_file="$HOME/.config/autostart/disable-gnome-extension-ding.desktop"
cp user-autostart.tpl ${desktop_file}
sed -i "s/\[GNOME_EXTENSION_CMD\]/gnome-extensions disable ding@rastersoft.com/g" ${desktop_file}
sed -i "s/\[GNOME_EXTENSION_ID\]/DING/g" ${desktop_file}

desktop_file="$HOME/.config/autostart/disable-gnome-extension-snapd.desktop"
cp user-autostart.tpl ${desktop_file}
sed -i "s/\[GNOME_EXTENSION_CMD\]/gnome-extensions disable snapd-prompting@canonical.com/g" ${desktop_file}
sed -i "s/\[GNOME_EXTENSION_ID\]/snapd prompting/g" ${desktop_file}
