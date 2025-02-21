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
sudo dnf install @base-x gnome-shell firefox nautilus gnome-system-monitor gnome-disk-utility gnome-software gedit ptyxis --setopt=install_weak_deps=False
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

Boot into desktop & start virtual machine manger
```
sudo systemctl set-default graphical.target
sudo systemctl enable libvirtd 
```

## Auto-updates

### Daily security updates
```
sudo dnf install dnf5-plugin-automatic
sudo tee /etc/dnf/automatic.conf << EOF
[commands]
apply_updates = yes
download_updates = yes
upgrade_type = security
reboot = when-needed
EOF
sudo systemctl enable dnf5-automatic.timer
```

### Weekly normal updates
```
sudo dnf install cronie
sudo systemctl enable crond
```
schedule update every Sunday
```
sudo crontab -e
0 2 * * 0 dnf --refresh upgrade -y && dnf autoremove -y && dnf needs-restarting && [ $? -eq 1 ] && reboot
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

# install vm(s) & start vm(s) on machine startup
sudo virsh autostart debian12

# fyi how to check installed packages
dnf rq --deplist nautilus
dnf info gnome-system-monitor

# fyi how to check auto-updates happened
sudo dnf history list # sudo dnf history help
sudo journalctl -u dnf5-automatic.service
sudo journalctl -u crond
who -b
-->

