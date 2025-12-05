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

# mask mounts
systemctl mask sys-kernel-debug.mount
systemctl mask sys-kernel-tracing.mount

# remove snapd desktop apps / icons
rm /var/lib/snapd/desktop/applications/*

# process all configured system users
for user_id in ${sys_users}; do
    cp -Ra ./disable-user-services.sh /home/${user_id}/
    chown ${user_id}:${user_id} /home/${user_id}/disable-user-services.sh
    su -c "~/disable-user-services.sh" - ${user_id}
    rm /home/${user_id}/disable-user-services.sh
done
