# Font System Configuration
{ config, pkgs, ... }:

{
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
    # Vietnamese fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  # Font management
  environment.systemPackages = with pkgs; [
    font-manager
  ];
}
