# Audio System Configuration
{ config, pkgs, ... }:

{
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

  # Audio control packages
  environment.systemPackages = with pkgs; [
    pavucontrol
    alsa-utils
    pulseaudio  # For pactl command
  ];
}
