# /etc/nixos/configuration.nix
# Configuration for Dell Inspiron 5548 (i5-5500U, 8GB RAM) with Hyprland
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Kernel parameters for Dell Inspiron 5548
  boot.kernelParams = [ 
    "quiet" 
    "splash" 
    "acpi_backlight=vendor"  # Fix backlight control
    "i915.enable_psr=0"      # Fix screen flickering if any
  ];

  # Enable experimental features for Hyprland
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Network
  networking.hostName = "dell-nixos";
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN.UTF-8";
    LC_IDENTIFICATION = "vi_VN.UTF-8";
    LC_MEASUREMENT = "vi_VN.UTF-8";
    LC_MONETARY = "vi_VN.UTF-8";
    LC_NAME = "vi_VN.UTF-8";
    LC_NUMERIC = "vi_VN.UTF-8";
    LC_PAPER = "vi_VN.UTF-8";
    LC_TELEPHONE = "vi_VN.UTF-8";
    LC_TIME = "vi_VN.UTF-8";
  };

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Graphics - Intel HD Graphics 5500
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # VAAPI driver for modern Intel GPUs
      vaapiIntel         # VAAPI driver for older Intel GPUs
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Hyprland WM
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = false; # Dell 5548 chỉ có Intel Graphics
    extraConfig = ''
      # Status bar (Waybar) configuration
      exec-once = waybar
      bind = SUPER, B, exec, pkill waybar || waybar # Toggle waybar

      # Waybar auto-hide
      windowrulev2 = animation fade,class:^(waybar)$
      windowrulev2 = float,class:^(waybar)$
      windowrulev2 = nofocus,class:^(waybar)$
      windowrulev2 = workspace special silent,class:^(waybar)$
    '';
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

  # User account
  users.users.mata = {  # Thay "user" bằng tên bạn muốn
    isNormalUser = true;
    description = "Dell User";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = with pkgs; [
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
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Essential tools
    vim
    ghostty
    wget
    curl
    git
    tree
    htop
    neofetch
    
    # Build tools
    gcc
    gnumake
    
    # Wayland tools
    wl-clipboard
    wlr-randr
    
    # Audio control
    pavucontrol
    
    # Network tools
    networkmanagerapplet
    
    # Waybar configuration
    (pkgs.writeTextFile {
      name = "waybar-config";
      destination = "/etc/xdg/waybar/config";
      text = ''
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
    })
    
    # System monitoring
    btop
    
    # Archive tools
    unzip
    zip
    
    # Text editor
    nano
    
    # System info
    lshw
    lscpu
    
    # Brightness control
    brightnessctl
    
    # Font management
    font-manager
  ];

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    font-awesome
  ];

  # Services
  services.openssh.enable = true;
  services.printing.enable = true;
  
  # CUPS printing
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  # Power management cho laptop
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;
      
      # Disable turbo boost on battery
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      
      # WiFi power saving
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
    };
  };

  # Backlight control
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
    ];
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Security
  security.sudo.wheelNeedsPassword = false;
  
  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # System version - DON'T CHANGE
  system.stateVersion = "23.11";
}