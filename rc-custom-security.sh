#!/bin/sh
### BEGIN INIT INFO
# Provides:          custom-security
# Required-Start:    $network $remote_fs
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Custom Security Settings
# Description:       Applies custom security hardening at boot (disables
#                    multicast on interfaces, locks kernel module loading).
### END INIT INFO

case "$1" in
    start)
        /usr/local/bin/set-custom-security.sh
        ;;
    stop|restart|reload|status)
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|reload|status}" >&2
        exit 1
        ;;
esac

exit 0
