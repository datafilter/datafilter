#!/bin/bash

### Download the script
# curl -fsSL https://start.datafilter.xyz/pc/fedora.sh > fedora.sh ; chmod +x fedora.sh

### review and make changes. Eg. reboot instead of shutdown, keep remote access, etc.
# vi fedora.sh

### run the script
# sudo ./fedora.sh

# UI
dnf install -y @base-x 

# Window manager
dnf install -y gnome-shell # --setopt=install_weak_deps=False

# Browser
dnf install -y chromium

# System tools
dnf install -y nautilus gnome-disk-utility gedit ptyxis gnome-system-monitor gnome-software

# Boot into desktop
systemctl set-default graphical.target

# Virtual machine support
dnf install -y @virtualization virt-manager
systemctl enable libvirtd.service

# Daily security updates & full update then shutdown when restart is required
dnf install -y dnf5-plugin-automatic
tee /etc/dnf/automatic.conf << EOF
[commands]
apply_updates = yes
download_updates = yes
upgrade_type = security
reboot = when-needed
reboot_command = "dnf --refresh upgrade -y ; shutdown"
EOF
systemctl enable dnf5-automatic.timer

# Disable remote access
systemctl stop sshd.service
systemctl disable sshd.service

# Reboot
reboot
