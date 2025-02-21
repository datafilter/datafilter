#!/bin/bash

# To install, run:
# sudo /bin/bash -c "$(curl -fsSL https://github.com/datafilter/datafilter/raw/main/pc/setup.sh)"

# UI
dnf install -y @base-x 

# Window manager
dnf install -y gnome-shell --setopt=install_weak_deps=False

# Browser
dnf install -y firefox

# System tools
dnf install -y nautilus gnome-disk-utility gedit ptyxis gnome-system-monitor gnome-software

# Boot into desktop
systemctl set-default graphical.target

# Virtual machine support
dnf install -y @virtualization virt-manager
systemctl enable libvirtd.service

# Daily security updates & full update upon required restart
dnf install -y dnf5-plugin-automatic
tee /etc/dnf/automatic.conf << EOF
[commands]
apply_updates = yes
download_updates = yes
upgrade_type = security
reboot = when-needed
reboot_command = "dnf --refresh upgrade -y && shutdown -r +5 'Required reboot for updates'"
EOF
systemctl enable dnf5-automatic.timer

# Disable remote access
systemctl stop sshd.service
systemctl disable sshd.service

# Reboot
reboot
