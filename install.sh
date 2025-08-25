#!/bin/bash
# NixOS Installation Script for Dell Inspiron 5548

set -e

echo "=== NixOS Configuration Installation Script ==="
echo "This script will help you set up NixOS with Hyprland on Dell Inspiron 5548"
echo

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "Do not run this script as root!" 
   exit 1
fi

# Check if we're in NixOS
if ! command -v nixos-rebuild &> /dev/null; then
    echo "Error: This script must be run on NixOS"
    exit 1
fi

echo "1. Backing up existing configuration..."
if [ -f /etc/nixos/configuration.nix ]; then
    sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.backup
    echo "   Backed up to /etc/nixos/configuration.nix.backup"
fi

echo "2. Creating directories..."
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar
mkdir -p ~/Pictures

echo "3. Copying configuration files..."
# Copy flake files
sudo cp flake.nix /etc/nixos/
sudo cp flake.lock /etc/nixos/ 2>/dev/null || true

# Copy host configuration
sudo cp -r hosts /etc/nixos/
sudo cp -r modules /etc/nixos/
sudo cp home.nix /etc/nixos/

# Copy dotfiles
cp dotfiles/hyprland.conf ~/.config/hypr/
cp dotfiles/waybar-config.json ~/.config/waybar/config

# Generate hardware configuration if it doesn't exist
if [ ! -f /etc/nixos/hosts/dell-5548/hardware-configuration.nix ]; then
    echo "4. Generating hardware configuration..."
    sudo nixos-generate-config --show-hardware-config > /tmp/hardware-configuration.nix
    sudo mv /tmp/hardware-configuration.nix /etc/nixos/hosts/dell-5548/
else
    echo "4. Hardware configuration already exists, skipping..."
fi

echo "5. Setting permissions..."
sudo chown -R root:root /etc/nixos
sudo chmod -R 644 /etc/nixos
sudo chmod 755 /etc/nixos/hosts/dell-5548
sudo chmod 755 /etc/nixos/modules

echo "6. Updating flake lock..."
cd /etc/nixos
sudo nix flake update

echo "7. Testing configuration..."
sudo nixos-rebuild dry-build --flake /etc/nixos#dell-nixos

echo
echo "Configuration prepared successfully!"
echo
echo "Next steps:"
echo "1. Review the configuration in /etc/nixos/"
echo "2. Run: sudo nixos-rebuild switch --flake /etc/nixos#dell-nixos"
echo "3. Reboot your system"
echo "4. Log in and select Hyprland from the display manager"
echo
echo "Useful commands after installation:"
echo "- Update system: sudo nixos-rebuild switch --flake /etc/nixos#dell-nixos"
echo "- Update flake inputs: sudo nix flake update /etc/nixos"
echo "- Clean old generations: sudo nix-collect-garbage -d"
echo
echo "Keyboard shortcut: Alt+Shift to switch between US and Vietnamese layouts"
echo "Super+Q: Terminal, Super+R: App launcher, Super+E: File manager"
