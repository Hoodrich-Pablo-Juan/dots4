{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar
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

  # Kitty terminal configuration with transparency
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.85";
      background_blur = 64;
      font_family = "JetBrainsMono Nerd Font";
      font_size = "11.0";
      
      # Light theme colors
      foreground = "#374151";
      background = "#f9fafb";
      selection_foreground = "#f9fafb";
      selection_background = "#374151";
      
      # Cursor colors
      cursor = "#374151";
      cursor_text_color = "#f9fafb";
      
      # Black
      color0 = "#6b7280";
      color8 = "#9ca3af";
      
      # Red
      color1 = "#dc2626";
      color9 = "#ef4444";
      
      # Green
      color2 = "#16a34a";
      color10 = "#22c55e";
      
      # Yellow
      color3 = "#ca8a04";
      color11 = "#eab308";
      
      # Blue
      color4 = "#2563eb";
      color12 = "#3b82f6";
      
      # Magenta
      color5 = "#9333ea";
      color13 = "#a855f7";
      
      # Cyan
      color6 = "#0891b2";
      color14 = "#06b6d4";
      
      # White
      color7 = "#d1d5db";
      color15 = "#e5e7eb";
      
      # Padding
      window_padding_width = 10;
      
      # Tab bar
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };
  };

  # Alacritty terminal configuration (backup)
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.85;
        blur = true;
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
          background = "#f9fafb";
          foreground = "#374151";
        };
      };
    };
  };

  # GTK configuration for light theme
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = false;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = false;
    };
  };

  # Qt configuration for light theme
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita";
  };

  # Cursor theme for Wayland
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
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
        frame_color = "#d1d5db";
        font = "JetBrainsMono Nerd Font 10";
      };
      urgency_low = {
        background = "#f9fafb";
        foreground = "#6b7280";
        timeout = 5;
      };
      urgency_normal = {
        background = "#f9fafb";
        foreground = "#374151";
        timeout = 10;
      };
      urgency_critical = {
        background = "#fef2f2";
        foreground = "#dc2626";
        timeout = 0;
      };
    };
  };

  # Download wallpaper automatically
  home.activation.downloadWallpaper = config.lib.dag.entryAfter ["writeBoundary"] ''
    WALLPAPER_DIR="$HOME/.config/wallpapers"
    WALLPAPER_FILE="$WALLPAPER_DIR/wallpaper.jpg"
    
    if [ ! -f "$WALLPAPER_FILE" ]; then
      $DRY_RUN_CMD mkdir -p "$WALLPAPER_DIR"
      $DRY_RUN_CMD ${pkgs.wget}/bin/wget -O "$WALLPAPER_FILE" \
        "https://gitlab.com/dotfiles_hypr/eink/-/raw/main/wallpapers/eink.jpg" || true
    fi
  '';
}
