{ pkgs, zen-browser, ... }:

[
  # Terminal emulators
  pkgs.kitty
  pkgs.alacritty

  # Editors / tools
  pkgs.vim
  pkgs.neovim
  pkgs.git
  pkgs.curl
  pkgs.wget
  pkgs.htop
  pkgs.ripgrep

  # Utilities
  pkgs.fd
  pkgs.bat
  pkgs.exa
  pkgs.tree

  # Browser (from flake input)
  zen-browser

  # Fonts
  pkgs.nerd-fonts-complete
]
