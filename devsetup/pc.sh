#!/bin/bash

# To install, run:
# sudo /bin/bash -c "$(curl -fsSL https://github.com/datafilter/datafilter/raw/main/devsetup/pc.sh)"

# Install just enough to surf & do basics
dnf install -y @base-x gnome-shell firefox nautilus gnome-system-monitor gnome-disk-utility gnome-software gedit ptyxis --setopt=install_weak_deps=False

# Boot into desktop
systemctl set-default graphical.target

# Virtual machine support
dnf install -y @virtualization virt-manager
systemctl enable libvirtd 

# Daily security updates
dnf install -y dnf5-plugin-automatic
tee /etc/dnf/automatic.conf << EOF
[commands]
apply_updates = yes
download_updates = yes
upgrade_type = security
reboot = when-needed
EOF
systemctl enable dnf5-automatic.timer

# Weekly normal updates
dnf install -y cronie
systemctl enable crond
(crontab -l 2>/dev/null; echo "0 2 * * 0 dnf --refresh upgrade -y && dnf autoremove -y && dnf needs-restarting && [ \$? -eq 1 ] && reboot") | crontab 

# Update and reboot
dnf autoremove -y
dnf --refresh upgrade -y
reboot
