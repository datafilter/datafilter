#!/bin/bash

# To install, run:
# curl -s https://github.com/datafilter/datafilter/raw/main/devsetup/pc.sh | sudo sh

# Install just enough to surf & do basics
dnf install -y @base-x gnome-shell firefox nautilus gnome-system-monitor gnome-disk-utility gnome-software gedit ptyxis --setopt=install_weak_deps=False

# Boot into desktop
systemctl set-default graphical.target

# Virtual machine support
dnf install -y @virtualization virt-manager
systemctl enable libvirtd 

# Auto security updates
dnf install -y dnf5-plugin-automatic
tee /etc/dnf/automatic.conf << EOF
[commands]
apply_updates = yes
download_updates = yes
upgrade_type = security
reboot = when-needed
EOF
systemctl enable dnf5-automatic.timer

# Update and reboot
dnf autoremove -y
dnf --refresh upgrade -y
reboot
