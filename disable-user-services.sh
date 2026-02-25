#!/bin/sh

# mask systemd user based snap services
systemctl mask --user snap.firmware-updater.firmware-notifier.service
systemctl mask --user snap.firmware-updater.firmware-notifier.timer
systemctl mask --user snap.prompting-client.daemon.service
systemctl mask --user snap.snapd-desktop-integration.snapd-desktop-integration.service
systemctl mask --user snapd.session-agent.service
systemctl mask --user snapd.session-agent.socket

# mask systemd user based gnome settings daemon services
systemctl mask --user org.gnome.SettingsDaemon.MediaKeys.service
systemctl mask --user org.gnome.SettingsDaemon.MediaKeys.target
systemctl mask --user org.gnome.SettingsDaemon.Wwan.service
systemctl mask --user org.gnome.SettingsDaemon.Wwan.target
systemctl mask --user org.gnome.SettingsDaemon.Sharing.service
systemctl mask --user org.gnome.SettingsDaemon.Sharing.target

# mask sleep, suspend and hibernation
systemctl mask --user systemd-hibernate-clear.service
systemctl mask --user systemd-hibernate-resume.service
systemctl mask --user systemd-suspend-then-hibernate.service
systemctl mask --user sleep.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target

# disable gnome donation-reminder
gsettings set org.gnome.settings-daemon.plugins.housekeeping donation-reminder-enabled false

# enable usb-guard dbus integration / protection
gsettings set org.gnome.desktop.privacy usb-protection true
gsettings set org.gnome.desktop.privacy usb-protection-level 'always'
