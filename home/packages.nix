{ config, pkgs, zen-browser, ... }:

{
  home.packages = with pkgs; [
    # Terminal emulators
    kitty
    alacritty

    # Editors / tools
    vim
    neovim
    git
    curl
    wget
    htop
    ripgrep

    # Utilities
    fd
    bat
    micro
    eza  # exa has been renamed to eza
    tree

    # Browser (from flake input)
    zen-browser.packages.${pkgs.system}.default

    # Fonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
