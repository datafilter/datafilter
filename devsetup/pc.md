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

Boot into desktop, start virtual machine manger & cronjobs
```
sudo systemctl set-default graphical.target
sudo systemctl enable libvirtd 
sudo systemctl enable crond 
```

## Reboot
```
sudo dnf --refresh upgrade && reboot
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
   
###install vm(s) & start vm(s) on machine startup
####sudo virsh autostart debian12

####create frequent auto-update script 
#### dnf [update stuff and clean stuff] && (dnf needs-restarting && (send email that restart happened) && restart)
####crontab -e

## dnf changes:
needs restarting is part of dnf5
automatic install is only 1 timer now:
https://dnf5.readthedocs.io/en/latest/dnf5_plugins/automatic.8.html#automatic-plugin-ref-label
edit and enable it as per  https://dnf5.readthedocs.io/en/latest/dnf5_plugins/automatic.8.html#run-dnf5-automatic-service
modify etc/dnf/automatic.conf --installupdates --timer and so on.
systemctl enable --now dnf5-automatic.timer
-->

