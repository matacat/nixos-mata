# This is your home-manager configuration file
# ~/.config/home-manager/home.nix
{ config, pkgs, ... }:

{
  home.username = "mata";
  home.homeDirectory = "/home/mata";
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # Web browsers
    firefox
    
    # File manager
    dolphin
    
    # Application launcher
    wofi
    
    # Screenshots
    grim
    slurp
    
    # Notifications
    mako
    
    # Status bar
    waybar
    
    # Wallpaper
    swaybg
    hyprpaper

    # Terminal
    ghostty

    # Development tools
    git
    vim
    nano
    tree
    htop
    neofetch
  ];

  # Hyprland Configuration
  xdg.configFile."hypr/hyprland.conf".text = ''
    ${builtins.readFile ./hyprland.conf}
  '';

  # Waybar Configuration
  xdg.configFile."waybar/config".text = ''
    {
      "layer": "top",
      "position": "top",
      "modules-left": ["hyprland/workspaces"],
      "modules-center": ["clock"],
      "modules-right": ["pulseaudio", "network", "battery"],
      "ipc": true,
      "height": 30,
      "spacing": 4,
      "margin-top": 3,
      "margin-bottom": 0,
      
      "hyprland/workspaces": {
        "format": "{icon}",
        "on-click": "activate"
      },
      
      "clock": {
        "format": "{:%H:%M}",
        "format-alt": "{:%Y-%m-%d}"
      },
      
      "pulseaudio": {
        "format": "{volume}% {icon}",
        "format-bluetooth": "{volume}% {icon}",
        "format-muted": "",
        "format-icons": {
            "headphone": "",
            "hands-free": "",
            "headset": "",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["", ""]
        }
      },
      
      "network": {
        "format-wifi": "{essid} ({signalStrength}%) ",
        "format-ethernet": "{ipaddr}/{cidr} ",
        "format-disconnected": "Disconnected ⚠"
      },
      
      "battery": {
        "format": "{capacity}% {icon}",
        "format-icons": ["", "", "", "", ""]
      }
    }
  '';

  # Git configuration
  programs.git = {
    enable = true;
    userName = "matacat";
    userEmail = "your.email@example.com";  # Thay đổi email của bạn ở đây
  };

  # Shell configuration
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
  };
}