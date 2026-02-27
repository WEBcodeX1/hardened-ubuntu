# Configuration Parameters

All installation parameters are managed centrally in `config.sh`. Source this file at the start of each installer script to make the parameters available as environment variables.

---

## NET_IF_NAME

The kernel network interface name of the primary ethernet adapter.

Used by `setup-netplan.sh` to configure the netplan ethernet interface template (`02-net-if-config.yaml`).

---

## NET_IF_MACADDRESS

The MAC address of the primary ethernet adapter.

Used by `setup-netplan.sh` to bind the netplan ethernet interface to a specific physical adapter via the `match.macaddress` field, ensuring consistent interface assignment across reboots.

---

## NET_IF_MTU

The Maximum Transmission Unit (MTU) in bytes for the primary ethernet interface.

Used by `setup-netplan.sh` to set the `mtu` field in the netplan ethernet interface template. Set to `1500` for standard Ethernet or a higher value (e.g. `9000`) when jumbo frames are supported by the network.

---

## NET_WIFI_IF_NAME

The kernel network interface name of the WiFi adapter.

When set, `setup-netplan.sh` deploys the WiFi netplan template (`03-net-wifi-config.yaml`), the NetworkManager DNS configuration, and the NetworkManager P2P disable configuration, and enables the `ccm`/`cmac` kernel modules required for WPA2 authentication. When left empty, all WiFi configuration steps are skipped.

---

## NET_WIFI_AUTH_SSID

The SSID (network name) of the WiFi network to connect to.

Used by `setup-netplan.sh` to populate the `[NET_WIFI_AUTH_SSID]` placeholder in the WiFi netplan template.

> **Warning:** Do not commit real credentials to version control. Use a local configuration file excluded from the repository, or set this value via environment variable.

---

## NET_WIFI_AUTH_PASS

The WPA2 passphrase for the WiFi network.

Used by `setup-netplan.sh` to populate the `[NET_WIFI_AUTH_PASS]` placeholder in the WiFi netplan template. The backslash character (`\`) is automatically escaped before substitution.

> **Warning:** Do not commit real credentials to version control. Use a local configuration file excluded from the repository, or set this value via environment variable.

---

## NET_NTP_STATIC_SERVER

The IP address of the static NTP server used by `chrony`.

Used when deploying `chrony.conf` to replace the `[NET_NTP_STATIC_SERVER]` placeholder. This should typically be a local network NTP server such as a router or dedicated time server.

---

## GRUB_KERNEL_CMDLINE

Additional kernel command-line parameters appended to the GRUB `GRUB_CMDLINE_LINUX_DEFAULT` setting.

Used by `set-grub-kernel-cmdline.sh`. The value is appended after the default `quiet splash ipv6.disable=1` parameters. Typical use cases include IOMMU configuration, power management tuning, or graphics driver options.

---

## NEXTDNS_ID

The NextDNS account identifier.

Used by `apt-preinstall-cmds.sh` to configure `dnscrypt-proxy` with the correct NextDNS resolver. The value replaces the `[NEXTDNS_ID]` placeholder in `dnscrypt-proxy.toml`, forming both the server name (`NextDNS-<ID>`) and the static resolver entry. Obtain this ID from your [NextDNS account](https://my.nextdns.io/).

---

## NEXTDNS_STAMP

The SDNS stamp (Base64-encoded DNS-over-HTTPS URL) for the NextDNS resolver.

Used by `apt-preinstall-cmds.sh` to configure `dnscrypt-proxy` by replacing the `[NEXTDNS_STAMP]` placeholder in `dnscrypt-proxy.toml`. SDNS stamps encode the full resolver URL and associated metadata in a compact format. Generate the stamp for your NextDNS configuration at [dnscrypt.info/stamps](https://dnscrypt.info/stamps) or obtain it from the NextDNS dashboard.

---

## KERNEL_DOMAIN_NAME

The domain name assigned to the kernel via the `kernel.domainname` sysctl parameter.

Used by `set-sysctl.sh` when deploying `sysctl-10-domainname.conf`, replacing the `[KERNEL_DOMAIN_NAME]` placeholder. Set this to the DNS domain of the local network or organisation.

---

## USER_IDS

A space-separated list of local user account names that exist on the system.

Used by `disable-services.sh` to iterate over each user and perform per-user setup steps: creating `~/autoinstall-scripts/`, setting up `~/.config/autostart/`, disabling the GNOME initial setup screen, copying autostart scripts, and running `prepare-user-autostart.sh` and `disable-user-services.sh` for each user. All listed users must already exist in the system (i.e. be defined in `autoinstall.yaml`).
