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

## Requirements

- Active NextDNS account
- Secure SDNS stamp (available from NextDNS account dashboard)
- SDNS stamp configured in dnscrypt-proxy.toml template

## Infrastructure Configuration

To establish secure DNS infrastructure and prevent DNS-based attacks:

- Route all DNS traffic to NextDNS DoH servers
- Block unencrypted DNS queries to internal and external routers
- Verify DoH requests are directed to correct IP addresses
