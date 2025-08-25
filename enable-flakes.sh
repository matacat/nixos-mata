#!/usr/bin/env bash
# Quick script to enable Nix experimental features

echo "Enabling Nix experimental features (flakes)..."

# Check if already enabled
if grep -q "experimental-features" /etc/nix/nix.conf 2>/dev/null; then
    echo "Experimental features already enabled in /etc/nix/nix.conf"
else
    echo "Adding experimental features to /etc/nix/nix.conf..."
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
fi

# Also enable for current session
export NIX_CONFIG="experimental-features = nix-command flakes"

echo "✅ Experimental features enabled!"
echo "You can now run flake commands."
echo ""
echo "Next: Run ./install.sh to continue installation"
