# Abstract

Transmitting DNS traffic unencrypted over the internet represents a significant security vulnerability. Additionally, modern operating systems and internet browsers have become increasingly bloated with unnecessary and potentially insecure components.

Historically, building Linux systems from source (such as Hardened Linux From Scratch) provided robust security. However, such approaches prove impractical for real-world enterprise or carrier-grade deployments due to the substantial effort required for stable, continuous updates and maintenance.

Experience has demonstrated that while established Linux distributions like Ubuntu offer numerous advantages, they also present significant security concerns and default configurations unsuitable for production environments without proper hardening.

This repository addresses these shortcomings by providing a comprehensive hardening solution for Ubuntu 25.10 workstation systems, enabling production-ready deployment within minutes.

## Ubuntu 25.10 Key Features

- XServer-less, 100% Wayland architecture (GNOME 49)
- Enhanced service dependency management and customization (systemd)
- Significantly improved YAML-based auto-installation
- Hardware-based hard drive encryption using TPM 2.0+ (experimental)

## Security Concerns in Default Ubuntu 25.10

Ubuntu 25.10 ships with several security-relevant features enabled by default that provide insufficient administrative control:

- Fully automated unattended upgrades
- Automated UEFI firmware updates
- Ubuntu FAN networking (VXLAN, UDP tunneling)
- Telemetry services (ubuntu-report, ubuntu-insights)
- SNAP package management system
- NetworkManager-controlled networking (non-netplan)
- HTTP-based mirror URLs (non-HTTPS)

**Warning:** Automated update processes combined with DNS poisoning attacks present severe security risks.

# Hardened Ubuntu 25.10 (Desktop)

This repository provides comprehensive hardening configurations for default Ubuntu 25.10 Desktop installations, specifically designed for software development and workstation environments.

The solution aims to achieve an optimal balance between usability and security.

## Security Features

- Complete DNS traffic encryption using DNS-over-HTTPS (DoH), including shell traffic
- Strict IOMMU hardening
- Netplan-based network management
- USB attack protection via USBGuard
- Disabled multicast capabilities (including DNS resolution)
- Disabled kernel debugging
- Disabled core dumps
- Blacklisted unnecessary kernel modules (e.g., Intel ME)
- Firefox ESR from native repository (non-SNAP)
- Complete SNAP and snapd removal
- Global hardened Firefox configuration
- Disabled automated unattended upgrades
- Hardened global sysctl parameters
- Disabled Thunderbolt
- Disabled Internet Protocol version 6 (IPv6)

## Preserved Components

- systemd
- CUPS (printing system)

**Note:** For systemd-free Linux distributions, consider Devuan (https://www.devuan.org/).

## Prerequisites

- Ubuntu 25.10 Desktop ISO image
- USB bootable installer (UNetbootin or Rufus)
- GPT-only mode enabled in Rufus for UEFI/Secure Boot configurations
- Optional: EFI partition encryption (Ubuntu 25.10 supports TPM 2.0)
- Local DHCP configuration with NTP option (DHCP option 42)

# Secure DNS Configuration with NextDNS

NextDNS represents a modern DNS security solution designed with privacy and security as primary considerations. It provides comprehensive DNS security with advanced filtering capabilities, including:

- Tracking site blocking
- Advertisement filtering
- Community-maintained security templates

The configuration prioritizes DNS-over-HTTPS (DoH) for all DNS queries.

**Additional Resources:**
- For detailed information about Hardened Ubuntu and NextDNS security configuration, see: https://www.der-it-pruefer.de/security/Hardened-Ubuntu-NextDNS-Security

## Requirements

- Active NextDNS account
- Secure SDNS stamp (available from NextDNS account dashboard)
- SDNS stamp configured in dnscrypt-proxy.toml template

## Infrastructure Configuration

To establish secure DNS infrastructure and prevent DNS-based attacks:

- Route all DNS traffic to NextDNS DoH servers
- Block unencrypted DNS queries to internal and external routers
- Verify DoH requests are directed to correct IP addresses

# Installation Instructions

This section provides step-by-step instructions for installing and configuring the hardened Ubuntu 25.10 system.

## Overview

The installation process consists of three main scripts that must be executed in sequence:

1. **installer-step1.sh** - Initial system hardening (no network required)
2. **System reboot** - Required to apply kernel and boot configurations
3. **installer-step2.sh** - Network-dependent security components (requires network)
4. **DNS verification** - Validate DNS-over-HTTPS functionality
5. **installer-step3.sh** - Final package installation and user configuration

## Step 0: Configure System Parameters

**IMPORTANT:** Before running any installer scripts, you must configure your system-specific parameters in `config.sh`.

Edit the configuration file with your environment settings:

```bash
# Edit config.sh with your system configuration
sudo vim config.sh
```

Configure the following parameters:

```bash
# Network interface configuration
export NET_IF_NAME=enp2s0              # Your network interface name (find with: ip link)
export NET_IF_MACADDRESS=12:34:56:78:9a:9b  # Your network interface MAC address
export NET_IF_MTU=9000                  # Maximum Transmission Unit (typically 1500 or 9000 for jumbo frames)

# NextDNS configuration (required for DNS-over-HTTPS)
export NEXTDNS_ID="abcdef"              # Your NextDNS configuration ID
export NEXTDNS_STAMP=""                 # Your NextDNS SDNS stamp (from NextDNS dashboard)

# Kernel configuration
export KERNEL_DOMAIN_NAME="domain.name" # Your domain name for kernel configuration

# System users
export USER_IDS="ubuntu"                # Space-separated list of user IDs to configure
```

**To find your network interface name:**
```bash
ip link show
```

**To find your network interface MAC address:**
```bash
ip link show <interface_name>
```

## Step 1: Initial System Hardening (No Network Required)

The first installer script performs the initial hardening configuration. This script **must be executed without network access** to prevent potential security issues during configuration.

**What it does:**
- Patches Ubuntu mirror URLs to use HTTPS
- Configures static NextDNS addresses in `/etc/hosts`
- Sets up netplan network configuration
- Removes unwanted packages (avahi, bluez, telemetry services, etc.)
- Disables insecure system and D-Bus services
- Blacklists unnecessary kernel modules
- Configures system limits and sysctl parameters
- Sets kernel command line parameters in GRUB

**Execute the script:**

```bash
# Clone or download the repository
git clone https://github.com/WEBcodeX1/hardened-ubuntu.git
cd hardened-ubuntu

# Make sure config.sh is properly configured (see Step 0)
# Run the first installer script as root
sudo ./installer-step1.sh
```

**After completion, reboot the system:**

```bash
sudo reboot
```

## Step 2: Install Security Components (Network Required)

After rebooting, the second installer script must be executed. This script **requires network access** and will install base security requirements.

**What it does:**
- Updates and upgrades system packages
- Installs USBGuard for USB attack protection
- Installs dnscrypt-proxy for DNS-over-HTTPS
- Installs libnss-resolve for command-line DNS resolution
- Configures systemd-resolved to use local dnscrypt-proxy
- Configures dnscrypt-proxy with your NextDNS settings
- Disables and masks the dnscrypt-proxy-resolvconf service

**Execute the script:**

```bash
cd hardened-ubuntu
sudo ./installer-step2.sh
```

## Step 3: Verify DNS-over-HTTPS Configuration

After installer-step2.sh completes, you **must verify** that DNS encryption is working correctly.

**Check dnscrypt-proxy service status:**

```bash
systemctl status dnscrypt-proxy
```

The service should be **active (running)** and show no errors.

**Verify DNS resolution is working:**

```bash
# Test DNS resolution
nslookup github.com

# Check that DNS queries are going through dnscrypt-proxy
sudo journalctl -u dnscrypt-proxy -n 50
```

If the service is not running or shows errors, troubleshoot before proceeding to Step 4.

## Step 4: Install Packages and User Configuration

The final installer script installs additional packages and applies user-based security settings.

**What it does:**
- Updates and upgrades all system packages
- Installs essential packages (aptitude, intel-microcode, vim, kate, xterm, foot)
- Installs development tools (docker.io, build-essential, debhelper, pbuilder, devscripts)
- Installs applications (GIMP, OpenSC, VLC)
- Installs Firefox ESR from Mozilla repository (non-SNAP version)
- Applies global hardened Firefox configuration
- Removes SNAP desktop applications and icons
- Enables custom systemd security service
- Disables ubuntu-fan network service

**Execute the script:**

```bash
cd hardened-ubuntu
sudo ./installer-step3.sh
```

## Installation Complete

After completing all steps, your Ubuntu 25.10 system is hardened and ready for use. The system includes:

- Encrypted DNS traffic via DNS-over-HTTPS
- Enhanced security configurations
- Hardened kernel parameters
- Removed telemetry and unnecessary services
- USB attack protection
- Firefox ESR with security-focused configuration

# Automated USB Installation

For automated deployments, you can integrate the hardening scripts into a USB installation medium using Ubuntu's autoinstall feature.

## Autoinstall Configuration

The repository includes a template autoinstall configuration at `/autoinstall/autoinstall.yaml`. This file can be customized and integrated into an Ubuntu 25.10 installation ISO.

### Configuration File Structure

```yaml
autoinstall:
  version: 1
  timezone: "Europe/Berlin"
  locale: "en_US.UTF-8"
  keyboard:
    layout: de
    variant: ""
    toggle: null
  identity:
    realname: 'User Name'
    username: userid
    password: '$y$j9T$u2.Sxog5EGXbH1sqVnrVD.$Qi76Enig/FpDS92jEhxsa6fLSZh4KwOMSEqfr8TH8L.'
    hostname: ubuntu
  storage:
    layout:
      name: direct
  kernel-crash-dumps:
    enabled: false
  shutdown: poweroff
```

### Customizing Autoinstall Configuration

1. **Edit the autoinstall.yaml file** with your specific settings:

```bash
vim autoinstall/autoinstall.yaml
```

2. **Customize the following parameters:**
   - `timezone`: Your timezone (e.g., "America/New_York", "Europe/London")
   - `locale`: Your system locale (e.g., "en_US.UTF-8", "de_DE.UTF-8")
   - `keyboard.layout`: Your keyboard layout (e.g., "us", "de", "fr")
   - `identity.realname`: User's full name
   - `identity.username`: System username
   - `identity.password`: Encrypted password (generate with: `mkpasswd -m yescrypt`)
   - `identity.hostname`: System hostname
   - `storage.layout`: Disk partitioning layout

3. **Generate encrypted password:**

```bash
# Install mkpasswd if not available
sudo apt-get install whois

# Generate encrypted password
mkpasswd -m yescrypt
```

### Creating Bootable USB Installation Medium

1. **Download Ubuntu 25.10 Desktop ISO** from the official Ubuntu website.

2. **Create the autoinstall ISO** by adding your customized autoinstall.yaml:

```bash
# Extract the ISO contents
mkdir -p /tmp/ubuntu-iso
sudo mount -o loop ubuntu-25.10-desktop-amd64.iso /tmp/ubuntu-iso
mkdir -p /tmp/ubuntu-custom
cp -rT /tmp/ubuntu-iso /tmp/ubuntu-custom

# Add autoinstall configuration
mkdir -p /tmp/ubuntu-custom/autoinstall
cp autoinstall/autoinstall.yaml /tmp/ubuntu-custom/autoinstall/

# Copy hardening scripts to the ISO
mkdir -p /tmp/ubuntu-custom/hardening

# Copy installer scripts
cp installer-step1.sh installer-step2.sh installer-step3.sh /tmp/ubuntu-custom/hardening/
cp config.sh /tmp/ubuntu-custom/hardening/

# Copy configuration scripts
cp apt-install-cmds.sh apt-preinstall-cmds.sh apt-remove-cmds.sh /tmp/ubuntu-custom/hardening/
cp disable-dbus-services.sh disable-services.sh disable-user-services.sh /tmp/ubuntu-custom/hardening/
cp enable-systemd-custom-security.sh install-non-snapd-firefox.sh /tmp/ubuntu-custom/hardening/
cp modules-blacklist.sh patch-hosts.sh patch-ubuntu-mirrors-https.sh /tmp/ubuntu-custom/hardening/
cp set-custom-security.sh set-grub-kernel-cmdline.sh set-limits.sh /tmp/ubuntu-custom/hardening/
cp set-sysctl.sh setup-netplan.sh /tmp/ubuntu-custom/hardening/

# Copy configuration files
cp limits.conf modules-blacklist.conf nsswitch.conf resolved.conf /tmp/ubuntu-custom/hardening/
cp dnscrypt-proxy.toml firefox-global.js hosts /tmp/ubuntu-custom/hardening/
cp sysctl-10-domainname.conf sysctl-10-net.conf sysctl-20-misc.conf /tmp/ubuntu-custom/hardening/
cp sysctl-55-kernel-hardening.conf sysctl-99-coredump.conf /tmp/ubuntu-custom/hardening/
cp systemd-custom-security.service /tmp/ubuntu-custom/hardening/

# Copy netplan templates
cp 01-networkd-all.yaml 02-net-if-config.yaml /tmp/ubuntu-custom/hardening/

# Create the custom ISO
sudo apt-get install xorriso isolinux
cd /tmp/ubuntu-custom
sudo xorriso -as mkisofs -r -V "Ubuntu 25.10 Hardened" \
  -o /tmp/ubuntu-25.10-hardened.iso \
  -b isolinux/isolinux.bin -c isolinux/boot.cat \
  -no-emul-boot -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot -e boot/grub/efi.img \
  -no-emul-boot -isohybrid-gpt-basdat .
```

3. **Write the ISO to USB** using tools like Rufus (Windows) or dd (Linux):

**Using Rufus (Windows):**
- Download Rufus from https://rufus.ie/
- Select your USB drive
- Select the custom ISO file
- **Important:** Set Partition scheme to "GPT" for UEFI/Secure Boot
- Click "Start"

**Using dd (Linux):**
```bash
# Find your USB device
lsblk

# Write the ISO to USB (replace sdX with your USB device)
sudo dd if=/tmp/ubuntu-25.10-hardened.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

### Post-Installation Hardening

After the automated installation completes:

1. **If using late-commands automation**, the hardening scripts are already in `/opt/hardening/`:

```bash
cd /opt/hardening
```

2. **If not using late-commands**, copy the hardening scripts from the USB or download from the repository:

```bash
# If scripts are on the ISO
sudo mount /dev/cdrom /mnt
cp -r /mnt/hardening ~/hardened-ubuntu
cd ~/hardened-ubuntu

# Or clone from repository
git clone https://github.com/WEBcodeX1/hardened-ubuntu.git
cd hardened-ubuntu
```

3. **Follow the manual installation steps** starting from Step 0 (configure config.sh) through Step 4 to apply all hardening configurations.

### Fully Automated Installation with Late Commands

For a fully automated installation, you can add late-commands to the autoinstall.yaml to run the hardening scripts automatically:

```yaml
autoinstall:
  version: 1
  # ... other configuration ...
  late-commands:
    # Copy hardening scripts from ISO to target system
    - curtin in-target -- mkdir -p /opt/hardening
    - curtin in-target -- cp -r /cdrom/hardening/* /opt/hardening/
    # Run first installer step
    - curtin in-target -- bash -c "cd /opt/hardening && ./installer-step1.sh"
    # Note: installer-step2.sh and installer-step3.sh require manual execution after reboot
```

**Important:** Due to the reboot requirement between installation steps and the need for DNS verification, it is recommended to run installer-step2.sh and installer-step3.sh manually after the initial automated installation and reboot. The hardening scripts will be available in `/opt/hardening/` on the installed system.
