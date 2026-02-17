#!/bin/bash

### NOTE: Install with LAN. WiFi won't work with minimal install on boot before script is run.

### Download Fedora network installer image (Fedora Everything 43 x86_64)
# https://www.fedoraproject.org/misc/#everything

### Make a bootable external disk from an iso
# BEFORE plugging in the external disk, run:
# diskutil list
# plug in the external list and run diskutil list again to identify the new drive
# NOTE - the next operations ERASE the drive
# NOTE - if you pick the wrong one, you'll BRICK your machine.
# unmount it:
# diskutil unmountDisk /dev/disk4
# write the .iso to the disk. Take note of the "r" prefix after "of=.."
# we refer to /dev/disk4 above, but /dev/rdisk4 in the next command
# sudo dd if=/Users/your-username/Downloads/Fedora-Everything-netinst-x86_64-43-1.6.iso of=/dev/rdisk4 bs=4m status=progress
# It might appear to hang but after some time you'll see
#  1172107616 bytes (1170 MB, 1116 MiB) transferred 272.728s, 4294 kB/s
#  278+1 records in
#  278+1 records out
#  1172107616 bytes transferred in 272.919884 secs (4293171 bytes/sec)
# finally, run:
# diskutil eject /dev/disk4
# that'll print
# Disk /dev/disk4 ejected

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
dnf install -y ptyxis nautilus gnome-disk-utility gnome-text-editor gnome-system-monitor gnome-software

# Boot into desktop
systemctl set-default graphical.target

# Virtual machine support
dnf install -y @virtualization virt-manager
systemctl enable libvirtd.service
usermod -aG libvirt "$SUDO_USER"

# Weekly updates restart on Thursdays around 3am
curl -sfL https://start.datafilter.xyz/pc/upgrade-reboot.sh | bash

# Disable remote access
systemctl stop sshd.service
systemctl disable sshd.service

# Reboot
reboot
