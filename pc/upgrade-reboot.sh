#!/bin/bash
set -e

# Configuration
MY_URL="https://start.datafilter.xyz/pc"
FILES=("upgrade-reboot.service" "upgrade-reboot.timer")
TARGET_DIR="/etc/systemd/system"

echo "Installing Weekly Upgrade-Reboot Service..."

# 1. Download the units
for FILE in "${FILES[@]}"; do
    sudo curl -sL "$MY_URL/$FILE" -o "$TARGET_DIR/$FILE"
done

# 2. Set permissions
sudo chmod 644 $TARGET_DIR/upgrade-reboot.*

# 3. Reload systemd and enable the timer
sudo systemctl daemon-reload
sudo systemctl enable --now upgrade-reboot.timer

echo "-------------------------------------------------------"
echo "Success! Your system will now:"
echo "1. Run 'dnf upgrade' every Thursday at 3:00 AM (give or take an hour)."
echo "2. Autoremove unused packages."
echo "3. Reboot immediately after."
echo "-------------------------------------------------------"
echo ""
echo "To check the next scheduled run:"
echo "systemctl list-timers upgrade-reboot.timer"
echo ""
echo "To view the output of the last upgrade:"
echo "journalctl -u upgrade-reboot.service"
echo ""
echo "To monitor a running upgrade in real-time:"
echo "journalctl -u upgrade-reboot.service -f"
echo ""
echo "To trigger the upgrade and reboot immediately for testing:"
echo "sudo systemctl start upgrade-reboot.service"
echo ""
echo "To verify the specific timer configuration:"
echo "systemctl show upgrade-reboot.timer"
echo ""
echo "To stop and disable the automated schedule:"
echo "sudo systemctl disable --now upgrade-reboot.timer"
echo "-------------------------------------------------------"
