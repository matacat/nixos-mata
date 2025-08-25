# Hyprland Desktop Environment
{ config, pkgs, inputs, ... }:

{
  # Enable experimental features for Hyprland
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Hyprland WM
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = false; # Dell 5548 chỉ có Intel Graphics
  };

  # XDG Desktop Portal
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # Display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Waybar for status bar
  programs.waybar = {
    enable = true;
  };

  # Essential Wayland packages
  environment.systemPackages = with pkgs; [
    waybar
    wofi           # Application launcher
    mako           # Notification daemon
    grim           # Screenshot utility
    slurp          # Region selection for screenshots
    wf-recorder    # Screen recording
    swayidle       # Idle management daemon
    swaylock       # Screen lock
  ];
}
