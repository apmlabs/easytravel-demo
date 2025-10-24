#!/bin/bash

# Setup easyTravel to start automatically after reboot

echo "Setting up easyTravel autostart..."

# Copy service file to systemd
sudo cp easytravel-autostart.service /etc/systemd/system/

# Reload systemd and enable service
sudo systemctl daemon-reload
sudo systemctl enable easytravel-autostart.service

# Start the service now
sudo systemctl start easytravel-autostart.service

echo "✅ easyTravel autostart configured!"
echo "Service status:"
sudo systemctl status easytravel-autostart.service --no-pager
