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
    hyprsunset  # Warm color temperature filter
    
    # Screenshots
    grim
    slurp
    wf-recorder
    
    # Utilities
    wl-clipboard
    brightnessctl
    pavucontrol
    hyprpicker
    
    # Fonts
    nerd-fonts.jetbrains-mono
    
    # System monitoring
    htop
    btop
    
    # File manager
    nautilus
    
    # Network management
    iwgtk  # GTK-based WiFi manager
    
    # Communication
    beeper
    
    # File sharing
    localsend
  ];
  
  fonts.fontconfig.enable = true;
  
  # Create script directory for Hyprland scripts
  home.file.".config/hypr/scripts/wf-toggle-recorder.sh" = {
    text = ''
      #!/bin/bash
      if pgrep -x "wf-recorder" > /dev/null; then
          pkill -INT wf-recorder
          notify-send "Screen Recording" "Stopped."
      else
          mkdir -p "$HOME/Videos/Recordings"
          wf-recorder -f "$HOME/Videos/Recordings/rec_$(date +%Y%m%d_%H%M%S).mp4" &
          notify-send "Screen Recording" "Started. Press Ctrl+P again to stop."
      fi
    '';
    executable = true;
  };
  
  # Create wallpapers directory with placeholder
  home.file.".config/wallpapers/.keep".text = "";
}
