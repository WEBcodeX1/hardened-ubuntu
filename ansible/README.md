# Ansible / Enterprise Support

This directory contains an Ansible role and playbook implementing the complete
Hardened Ubuntu 26.04 LTS workstation configuration as native,
idempotent Infrastructure-as-Code.

All logic from the original standalone bash scripts (preserved in the
repository's [`hardening/`](../hardening) sub-directory) has been translated
into native Ansible modules — no raw script execution is used, so task states
(`ok` / `changed`) are reported accurately and dry-run audits work as
expected.

## Directory Layout

```text
ansible/
├── ansible.cfg                     # local ansible configuration
├── site.yml                        # main playbook
├── inventory/
│   └── hosts.example               # example inventory
└── roles/
    └── hardened_ubuntu/
        ├── defaults/main.yml       # all configurable parameters
        ├── vars/main.yml           # internal constants
        ├── tasks/                  # native task implementations
        ├── handlers/main.yml       # netplan / grub / initramfs / services
        ├── templates/              # Jinja2 templates (netplan, dnscrypt, ...)
        ├── files/                  # static hardening configs
        └── meta/main.yml           # role metadata
```

## Requirements

- `ansible-core` >= 2.15 on the control node
- Ubuntu 26.04 LTS target hosts reachable via SSH with `become` (sudo)
  privileges
- Only `ansible.builtin` modules are used — no external collections required

## Quick Start

```bash
cd ansible

# create your inventory
cp inventory/hosts.example inventory/hosts
vim inventory/hosts

# review / override role defaults (see roles/hardened_ubuntu/defaults/main.yml)

# dry-run compliance audit
ansible-playbook site.yml --check --diff

# apply the full hardening configuration
ansible-playbook site.yml
```

> [!WARNING]
> A reboot is required after the initial run to apply kernel command line,
> initramfs and sysctl changes (equivalent to the reboots between the original
> installer steps).

## Configuration

All parameters previously defined in `hardening/config.sh` are exposed as role
variables in [`roles/hardened_ubuntu/defaults/main.yml`](roles/hardened_ubuntu/defaults/main.yml).
See [CONFIG.md](../CONFIG.md) for the detailed parameter descriptions.

| config.sh variable      | Ansible variable                   |
|-------------------------|------------------------------------|
| `MIRROR_ADDRESS`        | `hardening_mirror_address`         |
| `NET_IF_NAME`           | `hardening_net_if_name`            |
| `NET_IF_MACADDRESS`     | `hardening_net_if_macaddress`      |
| `NET_IF_MTU`            | `hardening_net_if_mtu`             |
| `NET_WIFI_IF_NAME`      | `hardening_net_wifi_if_name`       |
| `NET_WIFI_AUTH_SSID`    | `hardening_net_wifi_auth_ssid`     |
| `NET_WIFI_AUTH_PASS`    | `hardening_net_wifi_auth_pass`     |
| `NET_NTP_STATIC_SERVER` | `hardening_net_ntp_static_server`  |
| `GRUB_KERNEL_CMDLINE`   | `hardening_grub_kernel_cmdline`    |
| `NEXTDNS_ID`            | `hardening_nextdns_id`             |
| `NEXTDNS_STAMP`         | `hardening_nextdns_stamp`          |
| `KERNEL_DOMAIN_NAME`    | `hardening_kernel_domain_name`     |
| `USER_IDS`              | `hardening_users` (list)           |

Every feature area can additionally be toggled via
`hardening_manage_*` / `hardening_install_*` boolean variables, and the
package / service / unit lists are fully overridable.

> [!NOTE]
> Store secrets such as `hardening_net_wifi_auth_pass` in Ansible Vault:
> `ansible-vault encrypt_string 'Wifi-Password' --name hardening_net_wifi_auth_pass`

## Step Mapping (Tags)

The role mirrors the original 3-step installer workflow through tags, allowing
staged rollouts identical to the standalone scripts:

| Tag     | Original script      | Content                                                                 |
|---------|----------------------|-------------------------------------------------------------------------|
| `step1` | `installer-step1.sh` | mirrors, hosts, netplan, package removal, services, dbus, modules, limits, sysctl, grub |
| `step2` | `installer-step2.sh` | chrony, usbguard, dnscrypt-proxy / NextDNS, systemd-resolved, nsswitch   |
| `step3` | `installer-step3.sh` | debconf, workstation packages, non-snap Firefox ESR, custom security service, per-user hardening |

Fine-grained tags are available per area, e.g.:

```bash
# only (re-)apply the secure DNS configuration
ansible-playbook site.yml --tags dns

# only run the initial offline hardening
ansible-playbook site.yml --tags step1
```

## Idempotency & Check Mode

- All tasks are implemented with native Ansible modules
  (`apt`, `systemd_service`, `copy`, `template`, `file`, `lineinfile`,
  `replace`, `blockinfile`, `debconf`, `get_url`, `apt_repository`, `find`).
- Repeated runs converge to the same state; handlers (netplan apply,
  update-grub, update-initramfs, service restarts) only fire on actual
  changes.
- `ansible-playbook --check --diff` performs a non-destructive compliance
  audit.

## Relation to the Standalone Scripts

The original bash scripts in [`hardening/`](../hardening) remain fully
functional for standalone single-workstation installations (USB stick /
NetBoot autoinstall workflow, see the main [README](../README.md)). The
Ansible role is the recommended path for fleet deployments: provision minimal
Ubuntu systems via autoinstall, then manage all hardening centrally with this
role.
