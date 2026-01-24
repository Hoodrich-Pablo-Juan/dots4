{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Terminal
    alacritty
    
    # Browser (configured in firefox.nix)
    
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
    
    # Network management - Using NetworkManager instead of iwd
    networkmanagerapplet
    
    # Communication
    beeper
    
    # File sharing
    localsend
    
    # Android emulation
    waydroid
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
  
  # Waydroid initialization script
  home.file.".config/hypr/scripts/waydroid-setup.sh" = {
    text = ''
      #!/bin/bash
      
      # Initialize Waydroid with LineageOS if not already initialized
      if [ ! -d "$HOME/.local/share/waydroid" ]; then
          echo "Initializing Waydroid with LineageOS..."
          waydroid init -s GAPPS -f
      fi
      
      # Start Waydroid session
      waydroid session start &
      
      # Wait for Waydroid to be ready
      sleep 5
      
      # Show Waydroid
      waydroid show-full-ui
    '';
    executable = true;
  };
  
  # Create wallpapers directory with placeholder
  home.file.".config/wallpapers/.keep".text = "";
}
