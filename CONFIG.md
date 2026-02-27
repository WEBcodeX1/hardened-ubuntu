# Configuration Parameters

All installation parameters are managed centrally in `config.sh`.

Configurable parameters:

- [NET_IF_NAME](#net_if_name)
- [NET_IF_MACADDRESS](#net_if_macaddress)
- [NET_IF_MTU](#net_if_mtu)
- [NET_WIFI_IF_NAME](#net_wifi_if_name)
- [NET_WIFI_AUTH_SSID](#net_wifi_auth_ssid)
- [NET_WIFI_AUTH_PASS](#net_wifi_auth_pass)
- [NET_NTP_STATIC_SERVER](#net_ntp_static_server)
- [GRUB_KERNEL_CMDLINE](#grub_kernel_cmdline)
- [NEXTDNS_ID](#nextdns_id)
- [NEXTDNS_STAMP](#nextdns_stamp)
- [KERNEL_DOMAIN_NAME](#kernel_domain_name)
- [USER_IDS](#user_ids)

---

## NET_IF_NAME

The kernel network interface name of the primary ethernet adapter.

Used by `setup-netplan.sh` to configure the netplan ethernet interface template (`02-net-if-config.yaml`).

> [!NOTE]
> The ethernet interface is managed globally by `networkd`. Both `NET_IF_MACADDRESS` and `NET_IF_MTU` are **mandatory** parameters.
>
> The `installer-step1` step **must** be run without any active network connectivity. If a network connection is present, `unattended-upgrades` will be triggered automatically, causing the installation to fail.
>
> Installation can only be performed via **ethernet**. WiFi is **not** supported during the installation process.

**Example:**

```sh
NET_IF_NAME="enp2s0"
```

---

## NET_IF_MACADDRESS

The MAC address of the primary ethernet adapter.

Used by `setup-netplan.sh` to bind the netplan ethernet interface to a specific physical adapter via the `match.macaddress` field, ensuring consistent interface assignment across reboots.

**Example:**

```sh
NET_IF_MACADDRESS="12:34:56:78:9a:9b"
```

---

## NET_IF_MTU

The Maximum Transmission Unit (MTU) in bytes for the primary ethernet interface.

Used by `setup-netplan.sh` to set the `mtu` field in the netplan ethernet interface template. Set to `1500` for standard Ethernet or a higher value (e.g. `9000`) when jumbo frames are supported by the network.

**Example:**

```sh
NET_IF_MTU="9000"
```

---

## NET_WIFI_IF_NAME

The kernel network interface name of the WiFi adapter.

When set, `setup-netplan.sh` deploys the WiFi netplan template (`03-net-wifi-config.yaml`), the NetworkManager DNS configuration, and the NetworkManager P2P disable configuration, and enables the `ccm`/`cmac` kernel modules required for WPA2 authentication. When left empty, all WiFi configuration steps are skipped.

> [!NOTE]
> This parameter is **optional**. If omitted, no WiFi configuration will be performed.
>
> WiFi interface management is handled by **NetworkManager**, not `networkd`.

**Example:**

```sh
NET_WIFI_IF_NAME="wlp0s20f3"
```

---

## NET_WIFI_AUTH_SSID

The SSID (network name) of the WiFi network to connect to.

Used by `setup-netplan.sh` to populate the `[NET_WIFI_AUTH_SSID]` placeholder in the WiFi netplan template.

**Example:**

```sh
NET_WIFI_AUTH_SSID="MyHomeNetwork"
```

---

## NET_WIFI_AUTH_PASS

The WPA2 passphrase for the WiFi network.

Used by `setup-netplan.sh` to populate the `[NET_WIFI_AUTH_PASS]` placeholder in the WiFi netplan template. The backslash character (`\`) is automatically escaped before substitution.

**Example:**

```sh
NET_WIFI_AUTH_PASS="MySecurePassphrase123"
```

---

## NET_NTP_STATIC_SERVER

The IP address of the static NTP server used by `chrony`.

Used when deploying `chrony.conf` to replace the `[NET_NTP_STATIC_SERVER]` placeholder. This should typically be a local network NTP server such as a router or dedicated time server.

> [!NOTE]
> This parameter is **optional**. If omitted, an adjusted `chrony` configuration without a static server entry can be used instead.

**Example:**

```sh
NET_NTP_STATIC_SERVER="192.168.1.1"
```

---

## GRUB_KERNEL_CMDLINE

Additional kernel command-line parameters appended to the GRUB `GRUB_CMDLINE_LINUX_DEFAULT` setting.

Used by `set-grub-kernel-cmdline.sh`. The value is appended after the default `quiet splash ipv6.disable=1` parameters. Typical use cases include IOMMU configuration, power management tuning, or graphics driver options.

> [!NOTE]
> This parameter **must** be set and should contain system-specific settings.
>
> The default value is optimized for an Intel CPU (Gen 9) with an integrated Intel i915 GPU. It disables DMAR (DMA remapping) and limits the Intel C-state to guarantee consistent performance.

**Example:**

```sh
GRUB_KERNEL_CMDLINE="intel_iommu=igfx_off iommu.strict=1 i915.enable_dc=0 i915.modeset=1 i915.enable_psr=0 intel_idle.max_cstate=1"
```

---

## NEXTDNS_ID

The NextDNS account identifier.

Used by `apt-preinstall-cmds.sh` to configure `dnscrypt-proxy` with the correct NextDNS resolver. The value replaces the `[NEXTDNS_ID]` placeholder in `dnscrypt-proxy.toml`, forming both the server name (`NextDNS-<ID>`) and the static resolver entry. Obtain this ID from your [NextDNS account](https://my.nextdns.io/).

> [!NOTE]
> The value must be the bare identifier **without** the `NextDNS-` prefix (e.g. `a1b2c3`, not `NextDNS-a1b2c3`).

**Example:**

```sh
NEXTDNS_ID="a1b2c3"
```

---

## NEXTDNS_STAMP

The SDNS stamp (Base64-encoded DNS-over-HTTPS URL) for the NextDNS resolver.

Used by `apt-preinstall-cmds.sh` to configure `dnscrypt-proxy` by replacing the `[NEXTDNS_STAMP]` placeholder in `dnscrypt-proxy.toml`. SDNS stamps encode the full resolver URL and associated metadata in a compact format. Generate the stamp for your NextDNS configuration at [dnscrypt.info/stamps](https://dnscrypt.info/stamps) or obtain it from the NextDNS dashboard.

> [!NOTE]
> The value must be the bare Base64 string **without** the `sdns://` prefix (e.g. `AgEAAAAA...`, not `sdns://AgEAAAAA...`).

**Example:**

```sh
NEXTDNS_STAMP="AgEAAAAAAAAAAAAOZG5zLm5leHRkbnMuaW8EL2RucwA"
```

---

## KERNEL_DOMAIN_NAME

The domain name assigned to the kernel via the `kernel.domainname` sysctl parameter.

Used by `set-sysctl.sh` when deploying `sysctl-10-domainname.conf`, replacing the `[KERNEL_DOMAIN_NAME]` placeholder. Set this to the DNS domain of the local network or organisation.

**Example:**

```sh
KERNEL_DOMAIN_NAME="home.lan"
```

---

## USER_IDS

A space-separated list of users the installer will process hardening for, performing per-user setup steps.

Used by `disable-services.sh` to iterate over each user and perform per-user setup steps: creating `~/autoinstall-scripts/`, setting up `~/.config/autostart/`, disabling the GNOME initial setup screen, copying autostart scripts, and running `prepare-user-autostart.sh` and `disable-user-services.sh` for each user.

> [!NOTE]
> All listed users must also be defined in `autoinstall.yaml`. If a user is listed here but not defined there, the installation will not complete 100% successfully.

**Example:**

```sh
USER_IDS="admin user1"
```
