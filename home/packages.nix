{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Terminal
    alacritty
    
    # Browser
    firefox
    
    # Launcher
    wofi
    
    # Bar & wallpaper
    waybar
    swaybg
    
    # Screenshots
    grimblast
    
    # Utilities
    wl-clipboard
    brightnessctl
    pavucontrol
    
    # Fonts
    nerd-fonts.jetbrains-mono
  ];
  
  fonts.fontconfig.enable = true;
}
