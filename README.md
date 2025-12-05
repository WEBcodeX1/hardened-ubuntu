# Abstract

Currently sending DNS traffic unencrypted over the internet is a massive security concern.
Also Operating Systems and Internet Browsers are getting bloated more and more with unneeded
(sometimes probably highly insecure) stuff.

Far in the past, i was building (compiling) my linux machines by hand (Hardened Linux From Scratch),
i even built a small LHFS clone - Monolith Linux. This was rock-solid secure, but **not** really
adaptable to real world scenarios (enterprise / carrier-grade) requirements considering the
effort of stable, continoous updates / manpower.

Time showed that using a solid Linux Distribution (Ubuntu) has lots-of advantages, but also comes
with significant disadvantages / security relevant settings and should not be used in production
environments.

This setup fixes these disadvantages, hardens a current Ubuntu 25.10 workstation system and makes
it production-ready in minutes.

## New Ubuntu 25.10 Features

- XServer-less, 100% Wayland Architecture (Gnome 49)
- Much more manageable / customizable Service Dependencies (systemd)
- Greatly improved yaml based Auto-Installation
- Hardware based (TPM 2.0+) Harddrive Encryption (experimental)

## Disadvantages

Unfortunately Ubuntu 25.10 ships with some nasty, per default enabled, full-automated,
**not really controllable** stuff:

- Full-automated / Unattended Upgrades
- Automated (UEFI) Firmware Updates
- Ubuntu FAN-Networking (VXLAN, udp tunneling)
- Constantly dialing home (ubuntu-report, ubuntu-insights)
- SNAPd(ed) Software Packages
- NetworkManager Controlled Networking (non-netplan)
- Default mirror URLs are not http (not https)

Warning: Automated update processes in combination with poisoned DNS could be **very bad**!

# Hardened Ubuntu 25.10 (Desktop)

Our repository is intended to harden a default Ubuntu 25.10 Desktop installation
especially suitable for Software Developing / Workstation requirements.

It tries to give an optimal balance between usability and security,

## Features

- Encrypt (DOH) all DNS (including shell) traffic completely
- Harden IOMMU Settings (strict)
- Netplan enabled Network Management
- Install Usbguard (USB attacks)
- Disable Multicast Capabilities (including DNS resolving)
- Disable Kernel Debugging
- Disable Core Dumps
- Blacklist uneeeded Kernel Modules (e.g. Intel ME)
- Firefox-ESR from native Firefox repository (non-snap)
- Remove SNAP(d) completely
- Global Hardened Firefox Settings
- Remove automated Unattended Upgrades
- Harden global sysctl
- Disable Thunderbolt
- Disable Internet Protocol Version 6 (IPv6)

## Preserve

- Preserve systemd
- Preserve CUPS

Note: if you are searching for a systemd-less linux, try Devuan (http://).

## Prerequisites

- Current Ubuntu 25.10 Desktop iso
- Make USB bootable installer (unetbootin or Rufus)
- Enable "GPT only" mode in Rufus for a UEFI/Secure Boot setup
- Optional encrypt your EFI / partitions (Current Ubuntu is able to use TPM 2.0)
- Local DHCP setup should include NTP option (option )

# Secure DNS / NextDNS

NextDNS is the first really ... with very good DNS security in mind. Additionally
it filters out the following:

- Tracking Sites
- Advertisments (really working 100%)
- 

With some additional templates (community built)

Also the following ...

- Always prefer DNS over TLS (ANS)


## Requirements

- A working NextDNS account
- Get Secure sdns stamp (see account website)
- Put stamp inside dnscrypt-proxy.toml template (installer script)

dnscrypt-proxy and

## Infrastructure

To get a non-attackable (unencrypted DNS traffic) 

- Ensure **all** DNS traffic is routed to NextDNS DoH servers
- Ensure no unencrypted DNS will be sent to internal / external router(s)
- Ensure DoH requests go to the correct IP address(es)

## Infrastructure
