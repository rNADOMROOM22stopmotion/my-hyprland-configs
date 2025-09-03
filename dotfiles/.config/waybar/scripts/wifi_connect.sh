#!/bin/bash

echo "Scanning for Wi-Fi networks..."
iwctl station wlan0 scan
iwctl station wlan0 get-networks

read -p "Enter SSID: " ssid
read -s -p "Enter password: " password
echo ""

if iwctl --passphrase "$password" station wlan0 connect "$ssid"; then
    echo "Connected to $ssid successfully!"
    exit 0   # closes the script (and the terminal if it was spawned just for this)
else
    echo "❌ Failed to connect to $ssid."
    read -p "Press Enter to close..."
    exit 1
fi
