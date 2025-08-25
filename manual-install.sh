#!/usr/bin/env bash
# Manual NixOS Installation - Step by step
# Run each command manually if the main install script fails

echo "=== Manual NixOS Installation Steps ==="
echo "Run these commands one by one:"
echo

echo "# 1. Create user config directories"
echo "mkdir -p ~/.config/hypr ~/.config/waybar ~/Pictures"
echo

echo "# 2. Copy flake files"
echo "sudo cp flake.nix /etc/nixos/"
echo "sudo cp flake.lock /etc/nixos/ 2>/dev/null || true"
echo

echo "# 3. Copy modules and hosts"
echo "sudo rm -rf /etc/nixos/hosts /etc/nixos/modules 2>/dev/null || true"
echo "sudo cp -r hosts /etc/nixos/"
echo "sudo cp -r modules /etc/nixos/"
echo "sudo cp home.nix /etc/nixos/"
echo

echo "# 4. Generate hardware config (if needed)"
echo "sudo nixos-generate-config --show-hardware-config > /tmp/hw.nix"
echo "sudo mv /tmp/hw.nix /etc/nixos/hosts/dell-5548/hardware-configuration.nix"
echo

echo "# 5. Copy dotfiles"
echo "cp dotfiles/hyprland.conf ~/.config/hypr/"
echo "cp dotfiles/waybar-config.json ~/.config/waybar/config"
echo

echo "# 6. Set permissions"
echo "sudo chown -R root:root /etc/nixos"
echo "sudo chmod 755 /etc/nixos /etc/nixos/hosts /etc/nixos/modules"
echo "sudo chmod 755 /etc/nixos/hosts/dell-5548 /etc/nixos/modules/desktop /etc/nixos/modules/system"
echo "sudo chmod 644 /etc/nixos/*.nix /etc/nixos/hosts/dell-5548/*.nix"
echo "sudo chmod 644 /etc/nixos/modules/desktop/*.nix /etc/nixos/modules/system/*.nix"
echo

echo "# 7. Enable experimental features and update flake"
echo "export NIX_CONFIG='experimental-features = nix-command flakes'"
echo "sudo bash -c 'export NIX_CONFIG=\"experimental-features = nix-command flakes\" && cd /etc/nixos && nix flake update'"
echo

echo "# 8. Test build"
echo "sudo nixos-rebuild dry-build --flake /etc/nixos#dell-nixos"
echo

echo "# 9. Apply configuration"
echo "sudo nixos-rebuild switch --flake /etc/nixos#dell-nixos"
echo

echo "# 10. Reboot"
echo "sudo reboot"
echo

echo "=== Copy and paste these commands one by one ===="
