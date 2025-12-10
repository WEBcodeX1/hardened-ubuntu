# Autoinstall Remarks

This `README.md` provides some useful tips for enhancing the autoinstall process.

## 1. User Based Configuration

The following must be added to `autoinstall.yaml` (root node) to provide system user
based settings.

```yaml
user-data:
    users:
      - name: user1
        groups: sudo, users, admin
      - name: user2
        groups: users
    late-commands:
      - usermod -a -G docker user2
```

## 2. Network Configuration / Netplan

In multi NIC setup environments it is also advisable to configure the netplan networking
inside `autoinstall.yaml`.

### 2.1 Single Interface Configuration

For a single network interface with DHCP:

```yaml
network:
  ethernets:
    eth0:
      dhcp4: yes
  version: 2
```

### 2.2 Multiple Interface Configuration

For environments with multiple network interfaces, you can configure them individually:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      match:
        macaddress: "52:54:00:12:34:56"
      set-name: eth0
      dhcp4: yes
      dhcp6: no
      mtu: 1500
    eth1:
      match:
        macaddress: "52:54:00:12:34:57"
      set-name: eth1
      addresses:
        - 192.168.1.10/24
      routes:
        - to: 192.168.1.0/24
          via: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
    eth2:
      match:
        macaddress: "52:54:00:12:34:58"
      set-name: eth2
      addresses:
        - 10.0.0.10/24
      dhcp4: no
```

This configuration demonstrates:
- **eth0**: DHCP configuration with custom MTU
- **eth1**: Static IP with custom routes and DNS servers
- **eth2**: Static IP without DHCP

## 3. Useful Tips

### 3.1 Password Hash Generation

To generate a password hash for the `identity.password` field, use:

```bash
mkpasswd --method=yescrypt
```

This will prompt you for a password and generate a yescrypt hash compatible with modern Ubuntu systems.

### 3.2 Testing Autoinstall Configuration

Before deploying, validate your `autoinstall.yaml` syntax:

```bash
# Check YAML syntax
yamllint autoinstall.yaml

# Or use Python to validate
python3 -c "import yaml; yaml.safe_load(open('autoinstall.yaml'))"
```

### 3.3 MAC Address Discovery

To find MAC addresses for your network interfaces before installation:

```bash
ip link show
```

Or from a running system:

```bash
ip addr | grep ether
```

### 3.4 Debugging Autoinstall

If the autoinstall process fails:

1. Press **Ctrl+Alt+F2** during installation to access a debug shell
2. Check logs in `/var/log/installer/`
3. Review the autoinstall configuration: `cat /autoinstall.yaml`
4. Verify network connectivity: `ping -c 3 8.8.8.8`

### 3.5 Late Commands Best Practices

Use `late-commands` for post-installation tasks:

```yaml
late-commands:
  - curtin in-target --target=/target -- apt-get update
  - curtin in-target --target=/target -- apt-get upgrade -y
  - curtin in-target --target=/target -- systemctl enable ssh
  - echo "Installation completed at $(date)" > /target/var/log/autoinstall-completion.log
```

### 3.6 Network Interface Naming

To ensure consistent network interface naming:

1. Use MAC address matching with `match.macaddress`
2. Specify the desired name with `set-name`
3. This prevents interface names from changing between reboots

### 3.7 Storage Configuration

For custom storage layouts, refer to Ubuntu's autoinstall documentation. The default `direct` layout is suitable for most single-disk installations. For complex setups (RAID, LVM, encryption), consider using the `lvm` or custom storage configuration.

## 4. Additional Resources

- [Ubuntu Autoinstall Documentation](https://ubuntu.com/server/docs/install/autoinstall)
- [Netplan Configuration Reference](https://netplan.io/reference)
- [Cloud-init Documentation](https://cloudinit.readthedocs.io/)
