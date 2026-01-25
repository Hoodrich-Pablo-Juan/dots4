{ pkgs, ... }:

with pkgs;

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

  # Browser
  zen-browser

  # Fonts
  nerd-fonts-complete
]
