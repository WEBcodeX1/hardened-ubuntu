#!/bin/sh

# get env vars
sys_users=`printenv USER_IDS`

# disable global snapd services
systemctl disable snapd.autoimport.service
systemctl disable snapd.service
systemctl disable snapd.socket
systemctl disable snapd.apparmor.service
systemctl disable snapd.seeded.service
systemctl disable snapd.recovery-chooser-trigger.service
systemctl disable snapd.system-shutdown.service
systemctl disable snapd.core-fixup.service
systemctl disable kdump-tools.service

# disable apport service
systemctl disable apport.service

# disable snapd repair timer
systemctl disable snapd.snap-repair.timer

# disable global timers
systemctl disable apt-daily-upgrade.timer
systemctl disable update-notifier-download.timer
systemctl disable update-notifier-motd.timer
systemctl disable apt-daily.timer

# disable dynamic snapd
for mount_id in `ls /etc/systemd/system/snap*`; do
    echo ${mount_id}
    systemctl disable `basename ${mount_id}`
done

# mask services
systemctl mask bolt.service
systemctl mask apt-daily.service
systemctl mask fwupd.service
systemctl mask fwupd-refresh.timer
systemctl mask ubuntu-advantage-desktop-daemon.service

# mask mounts
systemctl mask sys-kernel-debug.mount
systemctl mask sys-kernel-tracing.mount

# mask user snapd services
systemctl mask --user snap.prompting-client.daemon.service
systemctl mask --user snap.snapd-desktop-integration.snapd-desktop-integration.service
systemctl mask --user snap.firmware-updater.firmware-notifier.service
systemctl mask --user snapd.session-agent.service
systemctl mask --user snapd.session-agent.socket

# mask user snapd sockets
systemctl mask --user snapd.session-agent.socket

# mask user timers
systemctl mask --user snap.firmware-updater.firmware-notifier.timer

# mask user launchpad related
systemctl mask --user launchpadlib-cache-clean.service
systemctl mask --user launchpadlib-cache-clean.timer

# remove snapd desktop apps / icons
rm /var/lib/snapd/desktop/applications/*

# process user based disable scripts
for user_id in ${sys_users}; do
    mkdir -p /home/${user_id}/autoinstall-scripts
    chown ${user_id}:${user_id} /home/${user_id}/autoinstall-scripts
    cp -Ra ./disable-user-services.sh ./user-autostart.tpl /home/${user_id}/autoinstall-scripts/
    chown ${user_id}:${user_id} /home/${user_id}/autoinstall-scripts/*
    su -c "~/autoinstall-scripts/disable-user-services.sh" - ${user_id}
done
