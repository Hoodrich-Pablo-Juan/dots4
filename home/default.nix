{ config, pkgs, zen-browser, firefox-addons, ... }:

{
  imports = [
    ./packages.nix
    ./firefox.nix
    ./hyprland.nix
    ./wofi.nix
    ./waybar
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

  programs.kitty.enable = true;
  programs.alacritty.enable = true;

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

  services.dunst.enable = true;

  # Wallpaper
  home.file.".config/wallpapers/wallpaper.jpg".source =
    ../wallpapers/eink.jpg;

  # ✅ Zen Browser is included only via home.packages
  # (remove any programs.zen-browser block)
}
