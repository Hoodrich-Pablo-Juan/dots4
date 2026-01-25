{ config, pkgs, zen-browser, ... }:

{
  home.packages = with pkgs; [
    alacritty
    wofi
    waybar
    swaybg
    hyprsunset
    grim
    slurp
    wf-recorder
    wl-clipboard
    brightnessctl
    pavucontrol
    hyprpicker
    nerd-fonts.jetbrains-mono
    htop
    btop
    nautilus
    networkmanagerapplet
    beeper
    localsend
    waydroid

    # ✅ Zen Browser (Twilight build only)
    zen-browser.packages.${pkgs.system}.twilight
  ];

  fonts.fontconfig.enable = true;

  # Scripts for Hyprland & Waydroid
  home.file.".config/hypr/scripts/wf-toggle-recorder.sh" = {
    executable = true;
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
  };

  home.file.".config/hypr/scripts/waydroid-setup.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      if [ ! -d "$HOME/.local/share/waydroid" ]; then
        waydroid init -s GAPPS -f
      fi

      waydroid session start &
      sleep 5
      waydroid show-full-ui
    '';
  };

  home.file.".config/wallpapers/.keep".text = "";
}
