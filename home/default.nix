{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./packages.nix
  ];

  home.username = "bryllm";
  home.homeDirectory = "/home/bryllm";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    profileExtra = ''
      # Hyprland auto-start on TTY1
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
        exec Hyprland
      fi
    '';
  };
  
  # Alacritty terminal configuration
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
        padding = {
          x = 10;
          y = 10;
        };
      };
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        size = 11.0;
      };
      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
      };
    };
  };
  
  # Dunst notification daemon configuration
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "#333333";
        font = "JetBrainsMono Nerd Font 10";
      };
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 5;
      };
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
      };
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#f38ba8";
        timeout = 0;
      };
    };
  };
}
