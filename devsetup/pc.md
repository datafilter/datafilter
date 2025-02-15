# Yearly* pc setup

## Install a minimal distro

* Download [Fedora Network Installer](https://alt.fedoraproject.org/)
* Choose minimum install, nothing else.
<details>
<summary>Why Fedora</summary>
  
A distro is a dekstop environment (window manager & lots of pre-installed bloat) and a package manager.

I don't want the desktop software, so the choice of distro comes down to which package manager:

I suspect that the incentive to test and keep packages secure are stronger when company reputation is at risk, ie, to prevent or minimize the loss of trust, ie money.

From the popular company backed distro's, fedora is more stable than ubuntu, especially on new releases.
</details>

## Install just enough to surf & do basics

> Take note, install via LAN as WiFi might not work initially (possibly NetworkManager(/-wifi) package)

```
sudo dnf install @base-x gnome-shell firefox nautilus gnome-system-monitor gnome-disk-utility gnome-software gedit ptyxis cronie --setopt=install_weak_deps=False
```
<details>
<summary>Package details</summary>

Base UI
* **@base-x**: Minimal X11 environment (UI)
* **gnome-shell**: GNOME desktop interface (Window manager)

Surf
* **firefox**: Web browser

Tools
* **nautilus**: File manager
* **gnome-disk-utility**: Disk management
* **gedit**: Text editor, mouse & copy+paste
* **ptyxi**: Terminal emulator
* **cronie**: Schedule cron jobs

Curiosity
* **gnome-software**: Software management app
* **gnome-system-monitor**: System resource monitor
</details>

## Virtual machine support 

Also install optional dependencies, so without `--setopt=install_weak_deps=False`

```
sudo dnf install @virtualization virt-manager
```



## Enable services

Boot into desktop, start virtual machine manger, start cron, start auto-updates
```
sudo systemctl set-default graphical.target
sudo systemctl enable libvirtd 
sudo systemctl enable crond
sudo systemctl enable dnf5-automatic.timer
```

## Auto-updates

### Option1: dn5 automatic (WIP)

> Work in progress, run `man dnf5-automatic` to replace echo instead & test if config works.

```
sudo dnf5 install dnf5-plugin-automatic
echo '
[commands]
apply_updates = yes
' | sudo tee -a /etc/dnf/automatic.conf
sudo systemctl enable dnf5-automatic.timer
```

### Option2: cron
```
TBD - 
```

## Update & Reboot
```
sudo dnf autoremove
sudo dnf --refresh upgrade
reboot
```
---

## End Result:
```
dnf list --installed | wc -l
```
`1078` which is around 30~50% smaller than a default install. Less packages = less updates & theoretically more secure.

<!--
#############################################
## TBD
#############################################

enable  automatic updates
sudo sed -i 's/^apply_updates = .*/apply_updates = yes/' /etc/dnf/automatic.conf
sudo sed -i 's/^reboot = .*/reboot = when-needed/' /etc/dnf/automatic.conf
   
###install vm(s) & start vm(s) on machine startup
####sudo virsh autostart debian12

####create frequent auto-update script 
#### dnf [update stuff and clean stuff] && (dnf needs-restarting && (send email that restart happened) && restart)
####crontab -e
```
#!/bin/bash

# Log current time
date +"%Y-%m-%d %H:%M:%S" > /etc/update-cron.log

# Update the system
echo "Updating the system..." >> /etc/update-cron.log
dnf upgrade --refresh -y >> /etc/update-cron.log

# Remove unused packages
echo "Removing unused packages..." >> /etc/update-cron.log
dnf autoremove -y >> /etc/update-cron.log

# Check if a reboot is needed
if dnf needs-restarting -r; then
    echo "Rebooting the system..." >> /etc/update-cron.log
    reboot >> /etc/update-cron.log
else
    echo "No reboot required." >> /etc/update-cron.log
fi
```
sudo chmod +x /usr/local/bin/update-script.sh
sudo vi /etc/systemd/system/update-script.service
```
[Unit]
Description=Run update script

[Service]
Type=oneshot
ExecStart=/usr/local/bin/update-script.sh
```
sudo vi /etc/systemd/system/update-script.timer
```
[Unit]
Description=Run update script daily at midnight

[Timer]
OnCalendar=*-*-* 00:00:00
Persistent=true

[Install]
WantedBy=timers.target
```
sudo systemctl enable update-script.timer

## dnf changes:
needs restarting is part of dnf5
automatic install is only 1 timer now:
https://dnf5.readthedocs.io/en/latest/dnf5_plugins/automatic.8.html#automatic-plugin-ref-label
edit and enable it as per  https://dnf5.readthedocs.io/en/latest/dnf5_plugins/automatic.8.html#run-dnf5-automatic-service
modify etc/dnf/automatic.conf --installupdates --timer and so on.
systemctl enable --now dnf5-automatic.timer

# add keyboard shortcut for super+menu and ctrl+alt+t (needs-restarting is part of yum-utils)
sh -c "dnf needs-restarting -r && systemctl suspend || (notify-send -u critical -t 0 'shutdown in 5 minutes...' 'to cancel run shutdown -c' && shutdown +5)" 

# fyi how to check installed packages
dnf rq --deplist nautilus
dnf info gnome-system-monitor

-->

