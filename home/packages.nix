{ config, pkgs, ... }:

with pkgs;

# ✅ Only include packages you actually need
[
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
  exa
  tree

  # Browsers
  # Only zen-browser; do NOT include zen-twilight or zen-beta here
  zen-browser

  # Fonts
  nerd-fonts-complete
]
