# Graphics System Configuration
{ config, pkgs, ... }:

{
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

  # Backlight control
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
    ];
  };

  # Brightness control package
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
