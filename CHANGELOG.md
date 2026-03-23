# Changelog

All notable changes to the Hardened Ubuntu project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.3

### Added

#### ISO Generation Script

- Addded ISO generation script `scripts/mkiso.sh` and documentation.

## v0.2

### Added

#### WiFi Support
- WiFi interface configuration variables (`NET_WIFI_IF_NAME`, `NET_WIFI_AUTH_SSID`, `NET_WIFI_AUTH_PASS`) in `config.sh`
- Conditional WiFi netplan setup in `setup-netplan.sh` based on `NET_WIFI_IF_NAME`
- Special character escaping for WiFi passphrase in `setup-netplan.sh`
- `wifi-networkmanager-dns.conf`: NetworkManager DNS configuration forcing all DNS queries through dnscrypt-proxy
- `renderer: NetworkManager` set at WiFi interface level in `03-net-wifi-config.yaml`
- `wifi-networkmanager-p2p.conf`: NetworkManager configuration to disable WiFi P2P (Wi-Fi Direct) device
- `ccm` and `cmac` kernel modules added to `/etc/modules-load.d/wifi.conf` for loading at boot, required for WiFi authentication

#### NTP / Chrony Configuration
- `chrony.conf`: New NTP client configuration file with static server support, command channel bound to IPv4 localhost only, leap second processing disabled
- `NET_NTP_STATIC_SERVER` configuration parameter in `config.sh` for specifying the static NTP server IP address
- `chrony` package installed during `installer-step2.sh` via `apt-preinstall-cmds.sh`
- Chrony configuration applied conditionally only when `NET_NTP_STATIC_SERVER` is set in `config.sh`

#### GRUB / Kernel Configuration
- `GRUB_KERNEL_CMDLINE` configuration parameter in `config.sh` for customizable kernel command line parameters
- `set-grub-kernel-cmdline.sh` updated to apply kernel command line from `GRUB_KERNEL_CMDLINE` config variable

#### Automated Installation
- `autoinstall/autoinstall.yaml` updated with multi-user support (`admin` and `user1` accounts in `user-data`)
- `late-commands` added to copy hardening scripts to `/target/opt/hardening/` and remove `gnome-initial-setup`
- `runcmd` added to execute `installer-step1.sh` automatically after first boot
- `gnome-initial-setup` package removed via `late-commands` during unattended installation

#### Network Configuration
- `netplan-dns-override-part.yaml`: New YAML fragment providing `dhcp4-overrides: use-dns: no` and `nameservers: addresses: [127.0.0.1]`, appended to the ethernet netplan configuration at the end of `installer-step2.sh`

#### Documentation
- `CONFIG.md`: New documentation file describing all configuration parameters found in `config.sh` in detail, with one subsection per parameter including example values

#### User Service Management
- `prepare-user-autostart.sh`: New script handling XDG autostart configuration (split from `disable-user-services.sh`)
  - Disables autostart for geoclue, im-launch, orca, GNOME Evolution alarm, SNAP, spice-vdagent, ubuntu-advantage, ubuntu-report, update-notifier
  - Disables GNOME extensions: ding and snapd-prompting
- `user-disable-services.desktop`: New GNOME autostart desktop entry to run `disable-user-services.sh` on user login
- GNOME initial setup welcome screen disabled per user during installation
- Automatic creation of `~/.config/autostart` directory per user during installation
- Disabled GNOME donation reminder via gsettings

#### Network Hardening
- DHCPv6 explicitly disabled (`dhcp6: no`) in ethernet netplan template
- YAML `version: 2` field moved to correct position in netplan templates

#### Application Security
- Disabled WebAssembly (WASM) in Firefox (`javascript.options.wasm`, `devtools.debugger.features.wasm`)
- Disabled WebRTC media navigator in Firefox (`media.navigator.enabled`) to prevent camera/microphone enumeration and IP leakage
- Disabled captive portal service in Firefox (`network.captive-portal-service.enabled`) to prevent automatic connections to untrusted network endpoints
- Firefox `remote.prefs.recommended` disabled to prevent remote servers from overriding local configuration

### Changed

#### Service Management
- `disable-user-services.sh` refactored: XDG autostart logic moved to new `prepare-user-autostart.sh`; now focused on masking systemd user-level services
- Sleep, suspend, and hibernation masked at both system level (`disable-services.sh`) and user level (`disable-user-services.sh`)
- `systemd-hibernate-clear.service` and `systemd-hibernate-resume.service` additionally masked at both system and user level for complete hibernation prevention
- Systemd user-level snap and GNOME settings daemon services masked in `disable-user-services.sh`
- `disable-services.sh` now runs `prepare-user-autostart.sh` and `disable-user-services.sh` separately per user
- USBGuard GNOME desktop integration enabled via `gsettings` in user sessions (`usb-protection`, `usb-protection-level`)
- `user-disable-services.desktop` Exec line updated to use absolute user-specific path with `[USER_ID]` placeholder, replaced at installation time

#### Network Hardening
- DNS DHCP override (`dhcp4-overrides: use-dns: no`) and local nameserver configuration moved from `02-net-if-config.yaml` to `netplan-dns-override-part.yaml`, appended to the ethernet netplan at the end of `installer-step2.sh` to ensure dnscrypt-proxy is available before the configuration is applied
- NetworkManager DNS configuration file `/etc/NetworkManager/conf.d/90-dns.conf` permissions set to `root:root 600`
- NetworkManager P2P configuration file `/etc/NetworkManager/conf.d/91-wifi-p2p.conf` permissions set to `root:root 600`

#### Application Security
- All Firefox preferences in `firefox-global.js` locked to prevent user override: all `pref()` calls updated to use the `locked` flag
- Firefox global configuration file `firefox-global.js` permissions set to `644` in `install-non-snapd-firefox.sh`

#### Configuration
- `config.sh` supports multiple space-separated user IDs in `USER_IDS`
- `GRUB_KERNEL_CMDLINE` added to `config.sh` for customizable kernel command line parameters
- `NET_NTP_STATIC_SERVER` added to `config.sh` for static NTP server IP address
- Improved variable quoting throughout `config.sh`

#### Installer
- `installer-step1.sh`: `systemctl daemon-reload` added at end to apply systemd configuration changes
- `installer-step2.sh`: appends `netplan-dns-override-part.yaml` to ethernet netplan configuration to ensure DNS DHCP override is applied after dnscrypt-proxy installation

## v0.1

### Added

#### Core Security Features
- All DNS traffic routed through `dnscrypt-proxy` using DNS-over-HTTPS (DoH), encrypting DNS queries end-to-end to prevent interception and spoofing
- `NextDNS` integrated with configurable SDNS stamps, providing encrypted DNS filtering with customizable security policies
- Strict IOMMU hardening configured to prevent DMA-based attacks from malicious or compromised hardware devices
- `USBGuard` deployed to enforce USB device access control policies, blocking unauthorized USB devices from accessing the system
- Multicast capabilities disabled system-wide including mDNS resolution, eliminating local network service discovery attack surface
- Kernel debugging features disabled to prevent information disclosure through kernel debug interfaces
- Core dumps disabled system-wide to prevent sensitive process memory content from being written to disk
- Unnecessary kernel modules blacklisted (Intel ME, Thunderbolt, etc.) to prevent unauthorized hardware access and reduce attack surface
- `IPv6` protocol disabled across the entire system, reducing the network attack surface to IPv4 only

#### Network Configuration
- `netplan`-based network management deployed as a replacement for `NetworkManager`, providing declarative static network configuration
- Network interfaces bound to MAC addresses with static IP configuration, ensuring consistent interface assignment and preventing unauthorized reconfiguration
- Configurable MTU settings applied per network interface, allowing optimization for specific network environments
- `systemd-resolved` integrated with `dnscrypt-proxy` to route all DNS queries through encrypted DNS-over-HTTPS, ensuring no plaintext DNS leakage
- All Ubuntu APT mirror URLs enforced to use HTTPS, preventing package download interception and tampering attacks
- Static `NextDNS` host entries configured to enable bootstrap DNS resolution before `dnscrypt-proxy` becomes fully operational

#### System Hardening
- Comprehensive `sysctl` parameter hardening applied covering kernel domain name configuration, network security parameters, kernel hardening options, and core dump prevention
- Global system limits configured via `/etc/security/limits.conf` to restrict per-user resource usage and prevent local denial-of-service attacks
- `GRUB` kernel command line hardened with security-focused boot parameters including IOMMU enforcement and kernel lockdown options
- Custom `systemd` security service deployed to enforce multicast restrictions and kernel module blacklisting at runtime after each system boot

#### Package Management
- `SNAP` package management system and `snapd` daemon completely removed from the system, eliminating the sandboxed application runtime and its associated network communication
- `firefox-esr` installed directly from the Mozilla APT repository as a non-SNAP native package, replacing the default SNAP-based Firefox installation
- Telemetry services `ubuntu-report` and `ubuntu-insights` automatically removed during installation to prevent user data collection and transmission
- Unnecessary packages removed including `avahi`, `bluez`, and `NetworkManager` to reduce the system attack surface and eliminate unused network-facing services
- Automated unattended upgrades disabled to prevent unexpected system modifications during operation that could interfere with the hardened configuration
- Automated UEFI firmware updates disabled to prevent uncontrolled firmware changes that could undermine system integrity

#### Service Management
- Comprehensive `systemd` service disabling implemented covering Ubuntu FAN networking (VXLAN, UDP tunneling), telemetry and reporting services, Bluetooth services, `avahi`/mDNS services, and `apport` crash reporting
- `dbus` service configuration hardened to restrict inter-process communication capabilities and reduce the exposed system bus attack surface
- User-level service management configured via XDG autostart to disable unnecessary services automatically on each user session start

#### Application Security
- Global hardened `Firefox` configuration deployed via `policies.json`, applying privacy and security settings system-wide for all users without requiring per-user configuration
- Device access permissions disabled in `Firefox` including camera, microphone, and geolocation access, protecting user privacy against unauthorized sensor access
- Media autoplay disabled in `Firefox` to prevent automatic execution of potentially malicious or unwanted media content on page load
- Network proxy settings disabled in `Firefox` to enforce direct connections, preventing proxy-based traffic interception
- Captive portal detection disabled in `Firefox` to prevent automatic connections to untrusted network endpoints on captive network join

#### Installation Scripts
- `installer-step1.sh`: Initial system hardening script designed to run without network access, performing APT mirror URL patching to HTTPS, static `NextDNS` host configuration, `netplan` network setup, unnecessary package removal, `systemd` service disabling, kernel module blacklisting, system resource limits and `sysctl` parameter configuration, and `GRUB` kernel command line hardening
- `installer-step2.sh`: Security components installation script requiring network access, performing system package updates, `USBGuard` installation and configuration, `dnscrypt-proxy` installation and DNS-over-HTTPS setup, and `libnss-resolve` installation for CLI DNS resolution through the encrypted resolver
- `installer-step3.sh`: Package installation and user configuration script installing essential packages (`aptitude`, `intel-microcode`, `vim`, `kate`, `xterm`, `foot`), development tools (`docker.io`, `build-essential`, `debhelper`, `pbuilder`, `devscripts`), applications (GIMP, OpenSC, VLC), configuring `firefox-esr` with hardened policies, completing `SNAP` removal, and enabling custom `systemd` security services

#### Automated Installation
- Ubuntu autoinstall configuration template provided to automate the initial Ubuntu installation process without manual intervention
- Automated USB installation support implemented to enable fully unattended system deployment from bootable USB media
- Custom ISO generation scripts created using `xorriso` to build bootable installation media with the autoinstall configuration embedded
- Late-command automation support added to execute hardening scripts automatically at the end of the Ubuntu installation process
- Post-installation hardening workflows configured to apply all security settings automatically after the base system installation completes

#### Configuration Management
- Centralized configuration file (`config.sh`) introduced to consolidate all installation parameters in a single location, simplifying per-site customization
- Network interface parameters managed centrally in `config.sh` including MAC address binding, static IP address, gateway, and MTU settings
- `NextDNS` configuration managed via `config.sh` including SDNS stamp URLs and static resolver host entries required for bootstrap DNS
- Kernel domain name settings configurable via `config.sh` to adapt the installation to specific organizational network environments
- User ID management configured in `config.sh` supporting multiple space-separated user IDs for consistent multi-user installation
- Template-based configuration processing implemented for `dnscrypt-proxy` configuration, `netplan` YAML network templates, `sysctl` parameter configuration, and XDG autostart desktop entry templates

#### Documentation
- Comprehensive `README.md` created covering the project abstract and security rationale, Ubuntu 25.10 key features overview, security concerns present in default Ubuntu, Hardened Ubuntu security features, preserved components documentation, prerequisites and system requirements, `NextDNS` configuration guide, step-by-step installation instructions, DNS verification procedures, automated USB installation guide, Table of Contents for easy navigation, code examples with proper syntax highlighting, Markdown alerts (warnings, tips, notes), and proper academic style and grammar throughout
- Autoinstall `README` created with `netplan` configuration examples to guide network setup during automated installation
- Debconf selections documented for automated package configuration, enabling fully unattended installation without interactive prompts

### Security

- All DNS traffic encrypted using DNS-over-HTTPS via `dnscrypt-proxy`, protecting against DNS spoofing and interception
- `USBGuard` deployed to enforce USB device access policies, mitigating USB-based hardware attacks
- Kernel parameters hardened via `sysctl` configuration: `ptrace` scope restricted, `kexec` disabled, address space randomization enforced
- Bluetooth, IPv6 stack, and multicast capabilities disabled system-wide, eliminating related attack vectors
- Core dump generation and kernel debugging interfaces disabled, preventing sensitive memory content disclosure
- Firefox browser hardened globally via `policies.json` with privacy-focused configuration defaults
- Telemetry and tracking services eliminated from the system, preventing user data collection

### Changed

- `NetworkManager` replaced with `netplan`-based static network configuration bound to MAC address
- Firefox transitioned from SNAP-based installation to native `firefox-esr` from the Mozilla APT repository
- All Ubuntu APT repository URLs enforced to use HTTPS, preventing package integrity attacks

### Removed

- `SNAP` package management system and `snapd` daemon removed from the system
- Telemetry services `ubuntu-report` and `ubuntu-insights` removed to prevent user data collection
- Automated unattended upgrades disabled to prevent unexpected system modifications
- Automated UEFI firmware updates disabled to prevent uncontrolled firmware changes
- `avahi` daemon and mDNS services removed, disabling local network service discovery
- Bluetooth support packages removed to eliminate wireless peripheral attack surface
- `NetworkManager` removed in favor of `netplan`-managed static network configuration
- IPv6 protocol support disabled across all network interfaces to reduce attack surface
- Multicast DNS resolution disabled to prevent local network information exposure
- Core dump generation disabled to prevent sensitive process memory disclosure
- Kernel debugging features disabled to prevent kernel space information leakage
- Unnecessary kernel modules (Intel ME, Thunderbolt, etc.) blacklisted to prevent unauthorized device access
- `update-notifier` package removed to eliminate automated update notification prompts
