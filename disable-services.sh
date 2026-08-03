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

# mask sleep, suspend and hibernation
systemctl mask systemd-hibernate-clear.service
systemctl mask systemd-hibernate-resume.service
systemctl mask systemd-suspend-then-hibernate.service
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target

# remove snapd desktop apps / icons
rm /var/lib/snapd/desktop/applications/*

# process user based disable scripts
for user_id in ${sys_users}; do

    # process autoinstall scripts
    mkdir -p /home/${user_id}/autoinstall-scripts
    chown ${user_id}:${user_id} /home/${user_id}/autoinstall-scripts

    # make user config dir(s) if not exist
    mkdir -p /home/${user_id}/.config/autostart
    chown ${user_id}:${user_id} /home/${user_id}/.config
    chown ${user_id}:${user_id} /home/${user_id}/.config/autostart

    # disable gnome initial welcome screen
    touch /home/${user_id}/.config/gnome-initial-setup-done
    chown ${user_id}:${user_id} /home/${user_id}/.config/gnome-initial-setup-done

    # copy user based scripts / templates
    cp -Ra ./prepare-user-autostart.sh ./disable-user-services.sh ./user-autostart.tpl ./config.sh /home/${user_id}/autoinstall-scripts/
    chown ${user_id}:${user_id} /home/${user_id}/autoinstall-scripts/*

    # mask user-level snap/snapd services before first login by creating /dev/null symlinks
    # directly in ~/.config/systemd/user/ (equivalent to `systemctl --user mask`, but works
    # without an active user session / D-Bus bus)
    mkdir -p /home/${user_id}/.config/systemd/user/
    for svc in \
        snap.firmware-updater.firmware-notifier.service \
        snap.firmware-updater.firmware-notifier.timer \
        snap.prompting-client.daemon.service \
        snap.snapd-desktop-integration.snapd-desktop-integration.service \
        snapd.session-agent.service \
        snapd.session-agent.socket \
        launchpadlib-cache-clean.service \
        launchpadlib-cache-clean.timer; do
        ln -sf /dev/null "/home/${user_id}/.config/systemd/user/${svc}"
    done
    chown -R ${user_id}:${user_id} /home/${user_id}/.config/systemd

    # process (copy, set user_id) user disable services desktop file
    cp -Ra ./user-disable-services.desktop /home/${user_id}/.config/autostart/
    chown ${user_id}:${user_id} /home/${user_id}/.config/autostart/user-disable-services.desktop
    chmod 644 /home/${user_id}/.config/autostart/user-disable-services.desktop
    sed -i "s/\[USER_ID\]/${user_id}/g" /home/${user_id}/.config/autostart/user-disable-services.desktop

    # prepare user autostart
    su -c "~/autoinstall-scripts/prepare-user-autostart.sh" - ${user_id}

    # run disable user services (without active user session)
    su -c "~/autoinstall-scripts/disable-user-services.sh" - ${user_id}

    # run disable user services (again as root)
    ./disable-user-services.sh

done
