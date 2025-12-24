# Changelog

All notable changes to the Hardened Ubuntu project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.1

### Added

#### Core Security Features
- Complete DNS traffic encryption using DNS-over-HTTPS (DoH) via dnscrypt-proxy
- NextDNS integration with configurable SDNS stamps
- Strict IOMMU hardening configuration
- USBGuard for USB attack protection
- Disabled multicast capabilities including DNS resolution
- Disabled kernel debugging features
- Disabled core dumps system-wide
- Blacklisted unnecessary kernel modules (Intel ME, Thunderbolt, etc.)
- IPv6 protocol disabled across the system

#### Network Configuration
- Netplan-based network management replacing NetworkManager
- Static network interface configuration with MAC address binding
- Configurable MTU settings
- systemd-resolved integration with dnscrypt-proxy
- HTTPS-enforced Ubuntu mirror URLs
- Static NextDNS host entries for bootstrap DNS resolution

#### System Hardening
- Comprehensive sysctl parameter hardening:
  - Kernel domain name configuration
  - Network security parameters
  - Kernel hardening options
  - Core dump prevention
- Global system limits configuration
- GRUB kernel command line hardening
- Custom systemd security service for multicast and kernel module restrictions

#### Package Management
- Complete SNAP and snapd removal
- Firefox ESR installation from Mozilla repository (non-SNAP)
- Automated removal of telemetry services (ubuntu-report, ubuntu-insights)
- Removal of unnecessary packages (avahi, bluez, NetworkManager, etc.)
- Disabled automated unattended upgrades
- Disabled automated UEFI firmware updates

#### Service Management
- Comprehensive systemd service disabling:
  - Ubuntu FAN networking (VXLAN, UDP tunneling)
  - Telemetry and reporting services
  - Bluetooth services
  - Avahi/mDNS services
  - Apport crash reporting
- D-Bus service hardening
- User-level service management with XDG autostart configuration

#### Application Security
- Global hardened Firefox configuration
- Disabled device access permissions in Firefox
- Disabled media autoplay
- Disabled network proxy settings
- Disabled captive portal detection

#### Installation Scripts
- `installer-step1.sh`: Initial system hardening (no network required)
  - Mirror URL patching to HTTPS
  - Static NextDNS configuration
  - Netplan setup
  - Package removal
  - Service disabling
  - Kernel module blacklisting
  - System limits and sysctl configuration
  - GRUB configuration
- `installer-step2.sh`: Security components installation (network required)
  - System package updates
  - USBGuard installation
  - dnscrypt-proxy installation
  - libnss-resolve for CLI DNS resolution
  - DNS-over-HTTPS configuration
- `installer-step3.sh`: Package installation and user configuration
  - Essential packages (aptitude, intel-microcode, vim, kate, xterm, foot)
  - Development tools (docker.io, build-essential, debhelper, pbuilder, devscripts)
  - Applications (GIMP, OpenSC, VLC)
  - Firefox ESR setup
  - SNAP removal
  - Custom systemd security enablement

#### Automated Installation
- Ubuntu autoinstall configuration template
- Automated USB installation support
- Custom ISO generation scripts with xorriso
- Late-command automation support
- Post-installation hardening workflows

#### Configuration Management
- Centralized configuration file (`config.sh`)
- Network interface parameters
- NextDNS configuration
- Kernel domain name settings
- User ID management
- Template-based configuration processing:
  - dnscrypt-proxy configuration templates
  - Netplan YAML templates
  - sysctl configuration templates
  - XDG autostart templates

#### Documentation
- Comprehensive README.md with:
  - Abstract and security rationale
  - Ubuntu 25.10 key features overview
  - Security concerns in default Ubuntu
  - Hardened Ubuntu security features
  - Preserved components documentation
  - Prerequisites and requirements
  - NextDNS configuration guide
  - Step-by-step installation instructions
  - DNS verification procedures
  - Automated USB installation guide
  - Table of Contents for easy navigation
  - Code examples with proper syntax highlighting
  - Markdown alerts (warnings, tips, notes)
  - Proper academic style and grammar
- autoinstall README with netplan examples
- Debconf selections for automated package configuration

### Security
- Protected against DNS-based attacks through encrypted DNS
- Mitigated USB-based attacks through USBGuard
- Hardened kernel parameters against common exploits
- Disabled unnecessary attack surfaces (Bluetooth, IPv6, multicast)
- Prevented information disclosure through core dumps and debugging
- Secured Firefox browser with privacy-focused defaults
- Eliminated telemetry and tracking services

### Changed
- Replaced NetworkManager with netplan for network management
- Converted Firefox from SNAP to native ESR package
- Enforced HTTPS for all Ubuntu package repositories

### Removed
- SNAP package management system and snapd
- Telemetry services (ubuntu-report, ubuntu-insights)
- Automated unattended upgrades
- Automated UEFI firmware updates
- Avahi/mDNS services
- Bluetooth support
- NetworkManager
- IPv6 support
- Multicast DNS resolution
- Core dump generation
- Kernel debugging features
- Unnecessary kernel modules
- Update notifier package
