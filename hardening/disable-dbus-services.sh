#!/bin/sh

# disable dbus services
mv /usr/share/dbus-1/services/com.feralinteractive.GameMode.service /usr/share/dbus-1/services/com.feralinteractive.GameMode.service.disabled 2>/dev/null
mv /usr/share/dbus-1/services/io.snapcraft.Launcher.service /usr/share/dbus-1/services/io.snapcraft.Launcher.service.disabled 2>/dev/null
mv /usr/share/dbus-1/services/io.snapcraft.SessionAgent.service /usr/share/dbus-1/services/io.snapcraft.SessionAgent.service.disabled 2>/dev/null
mv /usr/share/dbus-1/services/io.snapcraft.Settings.service /usr/share/dbus-1/services/io.snapcraft.Settings.service.disabled 2>/dev/null
mv /usr/share/dbus-1/services/org.freedesktop.portal.Tracker.service /usr/share/dbus-1/services/org.freedesktop.portal.Tracker.service.disabled 2>/dev/null
mv /usr/share/dbus-1/services/org.gnome.OnlineAccounts.service /usr/share/dbus-1/services/org.gnome.OnlineAccounts.service.disabled 2>/dev/null
mv /usr/share/dbus-1/services/org.gnome.Shell.Screencast.service /usr/share/dbus-1/services/org.gnome.Shell.Screencast.service.disabled 2>/dev/null
mv /usr/share/dbus-1/services/org.gtk.vfs.GPhoto2VolumeMonitor.service /usr/share/dbus-1/services/org.gtk.vfs.GPhoto2VolumeMonitor.service.disabled 2>/dev/null
mv /usr/share/dbus-1/services/org.gtk.vfs.GoaVolumeMonitor.service /usr/share/dbus-1/services/org.gtk.vfs.GoaVolumeMonitor.service.disabled 2>/dev/null
mv /usr/share/dbus-1/services/org.gtk.vfs.AfcVolumeMonitor.service /usr/share/dbus-1/services/org.gtk.vfs.AfcVolumeMonitor.service.disabled 2>/dev/null
