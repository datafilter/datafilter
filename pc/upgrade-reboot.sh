#!/bin/bash
set -e

# NOTE sudo implied (called by script already invoked with sudo)
# so we don't need to add it to chmod, systemclt or curl

# Configuration
MY_URL="https://start.datafilter.xyz/pc"
FILES=("upgrade-reboot.service" "upgrade-reboot.timer")
TARGET_DIR="/etc/systemd/system"

echo "Installing Weekly Upgrade-Reboot Service..."

echo 1. Download the units
for FILE in "${FILES[@]}"; do
    curl -fsSL "$MY_URL/$FILE" -o "$TARGET_DIR/$FILE"
done

echo 2. Set permissions
chmod 644 $TARGET_DIR/upgrade-reboot.*

echo 3. Reload systemd and enable the timer
systemctl daemon-reload
systemctl enable --now upgrade-reboot.timer

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
