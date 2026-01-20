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
    hyprsunset

    # Screenshots & recording
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

    # Wi-Fi GUI
    iwgtk

    # Messaging / sharing
    beeper
    localsend
  ];

  fonts.fontconfig.enable = true;

  home.file.".config/hypr/scripts/wf-toggle-recorder.sh" = {
    text = ''
      #!/bin/bash
      if pgrep -x "wf-recorder" > /dev/null; then
          pkill -INT wf-recorder
          notify-send "Screen Recording" "Stopped."
      else
          mkdir -p "$HOME/Videos/Recordings"
          wf-recorder -f "$HOME/Videos/Recordings/rec_$(date +%Y%m%d_%H%M%S).mp4" &
          notify-send "Screen Recording" "Started."
      fi
    '';
    executable = true;
  };

  home.file.".config/wallpapers/.keep".text = "";
}
