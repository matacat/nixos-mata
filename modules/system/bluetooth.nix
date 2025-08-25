# Bluetooth Configuration
{ config, pkgs, ... }:

{
  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Bluetooth management tools
  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
  ];
}
