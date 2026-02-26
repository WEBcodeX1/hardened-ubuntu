# Changelog

All notable changes to the Hardened Ubuntu project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.2

### Added

#### WiFi Support
- WiFi interface configuration variables (`NET_WIFI_IF_NAME`, `NET_WIFI_AUTH_SSID`, `NET_WIFI_AUTH_PASS`) in `config.sh`
- Conditional WiFi netplan setup in `setup-netplan.sh` based on `NET_WIFI_IF_NAME`
- Special character escaping for WiFi passphrase in `setup-netplan.sh`
- `wifi-networkmanager-dns.conf`: NetworkManager DNS configuration forcing all DNS queries through dnscrypt-proxy
- `renderer: NetworkManager` set at WiFi interface level in `03-net-wifi-config.yaml`

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
- `dhcp4-overrides: use-dns: no` added to ethernet netplan template to prevent DHCP DNS override
- Nameserver forced to `127.0.0.1` (dnscrypt-proxy) in ethernet netplan template
- YAML `version: 2` field moved to correct position in netplan templates

#### Application Security
- Disabled WebAssembly (WASM) in Firefox (`javascript.options.wasm`, `devtools.debugger.features.wasm`)

### Changed

#### Service Management
- `disable-user-services.sh` refactored: XDG autostart logic moved to new `prepare-user-autostart.sh`; now focused on masking systemd user-level services
- Sleep, suspend, and hibernation masked at both system level (`disable-services.sh`) and user level (`disable-user-services.sh`)
- Systemd user-level snap and GNOME settings daemon services masked in `disable-user-services.sh`
- `disable-services.sh` now runs `prepare-user-autostart.sh` and `disable-user-services.sh` separately per user

#### Configuration
- `config.sh` supports multiple space-separated user IDs in `USER_IDS`
- Improved variable quoting throughout `config.sh`

## v0.1

### Added

#### Core Security Features
- Complete DNS traffic encryption using DNS-over-HTTPS (DoH) via `dnscrypt-proxy`
- `NextDNS` integration with configurable SDNS stamps
- Strict IOMMU hardening configuration
- `USBGuard` for USB attack protection
- Disabled multicast capabilities including DNS resolution
- Disabled kernel debugging features
- Disabled core dumps system-wide
- Blacklisted unnecessary kernel modules (Intel ME, Thunderbolt, etc.)
- `IPv6` protocol disabled across the system

#### Network Configuration
- `netplan`-based network management replacing `NetworkManager`
- Static network interface configuration with MAC address binding
- Configurable MTU settings
- `systemd-resolved` integration with `dnscrypt-proxy`
- HTTPS-enforced Ubuntu mirror URLs
- Static `NextDNS` host entries for bootstrap DNS resolution

#### System Hardening
- Comprehensive `sysctl` parameter hardening:
  - Kernel domain name configuration
  - Network security parameters
  - Kernel hardening options
  - Core dump prevention
- Global system limits configuration
- `GRUB` kernel command line hardening
- Custom `systemd` security service for multicast and kernel module restrictions

#### Package Management
- Complete `SNAP` and `snapd` removal
- `firefox-esr` installation from Mozilla repository (non-SNAP)
- Automated removal of telemetry services (`ubuntu-report`, `ubuntu-insights`)
- Removal of unnecessary packages (`avahi`, `bluez`, `NetworkManager`, etc.)
- Disabled automated unattended upgrades
- Disabled automated UEFI firmware updates

#### Service Management
- Comprehensive `systemd` service disabling:
  - Ubuntu FAN networking (VXLAN, UDP tunneling)
  - Telemetry and reporting services
  - Bluetooth services
  - `avahi`/mDNS services
  - `apport` crash reporting
- `dbus` service hardening
- User-level service management with XDG autostart configuration

#### Application Security
- Global hardened `Firefox` configuration
- Disabled device access permissions in `Firefox`
- Disabled media autoplay
- Disabled network proxy settings
- Disabled captive portal detection

#### Installation Scripts
- `installer-step1.sh`: Initial system hardening (no network required)
  - Mirror URL patching to HTTPS
  - Static `NextDNS` configuration
  - `netplan` setup
  - Package removal
  - Service disabling
  - Kernel module blacklisting
  - System limits and `sysctl` configuration
  - `GRUB` configuration
- `installer-step2.sh`: Security components installation (network required)
  - System package updates
  - `USBGuard` installation
  - `dnscrypt-proxy` installation
  - `libnss-resolve` for CLI DNS resolution
  - DNS-over-HTTPS configuration
- `installer-step3.sh`: Package installation and user configuration
  - Essential packages (`aptitude`, `intel-microcode`, `vim`, `kate`, `xterm`, `foot`)
  - Development tools (`docker.io`, `build-essential`, `debhelper`, `pbuilder`, `devscripts`)
  - Applications (GIMP, OpenSC, VLC)
  - `firefox-esr` setup
  - `SNAP` removal
  - Custom `systemd` security enablement

#### Automated Installation
- Ubuntu autoinstall configuration template
- Automated USB installation support
- Custom ISO generation scripts with `xorriso`
- Late-command automation support
- Post-installation hardening workflows

#### Configuration Management
- Centralized configuration file (`config.sh`)
- Network interface parameters
- `NextDNS` configuration
- Kernel domain name settings
- User ID management
- Template-based configuration processing:
  - `dnscrypt-proxy` configuration templates
  - `netplan` YAML templates
  - `sysctl` configuration templates
  - XDG autostart templates

#### Documentation
- Comprehensive `README.md` with:
  - Abstract and security rationale
  - Ubuntu 25.10 key features overview
  - Security concerns in default Ubuntu
  - Hardened Ubuntu security features
  - Preserved components documentation
  - Prerequisites and requirements
  - `NextDNS` configuration guide
  - Step-by-step installation instructions
  - DNS verification procedures
  - Automated USB installation guide
  - Table of Contents for easy navigation
  - Code examples with proper syntax highlighting
  - Markdown alerts (warnings, tips, notes)
  - Proper academic style and grammar
- autoinstall `README` with `netplan` examples
- Debconf selections for automated package configuration

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
