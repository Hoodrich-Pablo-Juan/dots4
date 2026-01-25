{ config, pkgs, zen-browser, firefox-addons, ... }:

{
  # Import modular configs
  imports = [
    ./packages.nix
    ./firefox.nix
    ./hyprland.nix
    ./wofi.nix
    ./waybar
  ];

  # User info
  home.username = "bryllm";
  home.homeDirectory = "/home/bryllm";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  # -------------------------------
  # Bash
  # -------------------------------
  programs.bash = {
    enable = true;
    profileExtra = ''
      # Hyprland auto-start on TTY1
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
        exec Hyprland
      fi
    '';
  };

  # -------------------------------
  # Terminals
  # -------------------------------
  programs.kitty.enable = true;
  programs.alacritty.enable = true;

  # -------------------------------
  # GTK / QT
  # -------------------------------
  gtk = {
    enable = true;
    theme.name = "Adwaita";
    theme.package = pkgs.gnome-themes-extra;
    iconTheme.name = "Adwaita";
    iconTheme.package = pkgs.adwaita-icon-theme;
    cursorTheme.name = "Bibata-Modern-Classic";
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.size = 24;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = false;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = false;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita";
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # -------------------------------
  # Notifications
  # -------------------------------
  services.dunst.enable = true;

  # -------------------------------
  # Wallpaper
  # -------------------------------
  home.file.".config/wallpapers/wallpaper.jpg".source =
    ../wallpapers/eink.jpg;

  # -------------------------------
  # Firefox / Zen Browser
  # -------------------------------
  programs.firefox.enable = true;

  # If you want Zen Browser instead of Firefox, enable it here:
  programs.zen-browser = {
    enable = true;
    package = zen-browser.packages.${pkgs.system}.twilight;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      extensions = with firefox-addons.packages.${pkgs.system}; [
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
}
