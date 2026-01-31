{ config, pkgs, zen-browser, firefox-addons, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar
    ./packages.nix
    ./wofi.nix
    ./zen.nix
  ];

  home.username = "bryllm";
  home.homeDirectory = "/home/bryllm";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  # Zen browser with declarative extensions
  programs.zen-browser = {
    enable = true;
    
    # Policies at top level, not in profiles
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
    
    profiles.default = {
      id = 0;
      isDefault = true;
      
      # Extensions - vimium-c and ublock-origin
      extensions.packages = with firefox-addons.packages.${pkgs.system}; [
        vimium-c
        ublock-origin
      ];

      # Zen browser settings
      settings = {
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.newtabpage.enabled" = false;
        "browser.startup.page" = 3;
        "general.smoothScroll" = true;
      };
    };
  };

  # Firefox as backup browser
  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableAppUpdate = true;
      DisplayBookmarksToolbar = "never";

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      extensions.packages = with firefox-addons.packages.${pkgs.system}; [
        leechblock-ng
        vimium-c
        stylus
      ];

      settings = {
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "browser.newtabpage.enabled" = false;
        "browser.startup.page" = 3;
        "general.smoothScroll" = true;
      };
    };
  };

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
      background_opacity = "0.78";
      background_blur = 64;
      font_family = "JetBrainsMono Nerd Font";
      font_size = "11.0";
      
      window_padding_width = 16;
      
      # E-ink theme colors
      foreground = "#333333";
      background = "#CCCCCC";
      selection_foreground = "#CCCCCC";
      selection_background = "#333333";
      
      # Cursor colors
      cursor = "#333333";
      cursor_text_color = "#CCCCCC";
      
      # Black
      color0 = "#333333";
      color8 = "#474747";
      
      # Red
      color1 = "#474747";
      color9 = "#5A5A5A";
      
      # Green
      color2 = "#474747";
      color10 = "#5A5A5A";
      
      # Yellow
      color3 = "#474747";
      color11 = "#5A5A5A";
      
      # Blue
      color4 = "#474747";
      color12 = "#5A5A5A";
      
      # Magenta
      color5 = "#474747";
      color13 = "#5A5A5A";
      
      # Cyan
      color6 = "#474747";
      color14 = "#5A5A5A";
      
      # White
      color7 = "#AFAFAF";
      color15 = "#FFFFFF";
    };
  };

  # Alacritty terminal configuration (backup)
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.78;
        blur = true;
        padding = {
          x = 16;
          y = 16;
        };
        decorations = "Full";
      };
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };
        size = 12.0;
      };
      colors = {
        primary = {
          background = "0xCCCCCC";
          foreground = "0x333333";
        };
        normal = {
          black = "0x333333";
          red = "0x474747";
          green = "0x474747";
          yellow = "0x474747";
          blue = "0x474747";
          magenta = "0x474747";
          cyan = "0x474747";
          white = "0xAFAFAF";
        };
        bright = {
          black = "0x474747";
          red = "0x5A5A5A";
          green = "0x5A5A5A";
          yellow = "0x5A5A5A";
          blue = "0x5A5A5A";
          magenta = "0x5A5A5A";
          cyan = "0x5A5A5A";
          white = "0xFFFFFF";
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
        frame_color = "#CCCCCC";
        font = "JetBrainsMono Nerd Font 10";
      };
      urgency_low = {
        background = "#CCCCCC";
        foreground = "#474747";
        timeout = 5;
      };
      urgency_normal = {
        background = "#CCCCCC";
        foreground = "#333333";
        timeout = 10;
      };
      urgency_critical = {
        background = "#CCCCCC";
        foreground = "#000000";
        timeout = 0;
      };
    };
  };

  # Copy wallpaper from repo to home directory
  home.file.".config/wallpapers/wallpaper.jpg".source = ../wallpapers/eink.jpg;
}
