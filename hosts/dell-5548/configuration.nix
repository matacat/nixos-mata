# Dell Inspiron 5548 Configuration
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/system/audio.nix
    ../../modules/system/fonts.nix
    ../../modules/system/graphics.nix
    ../../modules/system/power.nix
    ../../modules/system/bluetooth.nix
  ];

  # Host-specific settings
  networking.hostName = "dell-nixos";
  
  # Kernel parameters for Dell Inspiron 5548
  boot.kernelParams = [ 
    "quiet" 
    "splash" 
    "acpi_backlight=vendor"  # Fix backlight control
    "i915.enable_psr=0"      # Fix screen flickering if any
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  # User account
  users.users.mata = {
    isNormalUser = true;
    description = "Dell User";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
  };

  # Essential system packages
  environment.systemPackages = with pkgs; [
    vim
    ghostty
    wget
    curl
    git
    tree
    htop
    neofetch
    gcc
    gnumake
    wl-clipboard
    wlr-randr
    pavucontrol
    networkmanagerapplet
    btop
    unzip
    zip
    nano
    lshw
    lscpu
    brightnessctl
    font-manager
  ];

  # Network
  networking.networkmanager.enable = true;
  
  # Services
  services.openssh.enable = true;
  services.printing.enable = true;
  
  # CUPS printing
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

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

  # System version
  system.stateVersion = "23.11";
}
