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
    eza
    tree

    # Browser (from flake input)
    zen-browser.packages.${pkgs.system}.default

    # Fonts
    (nerd-fonts.jetbrains-mono)
    
    # Claude Desktop
    claude-desktop
    
    # MCP tooling for Claude
    nodejs_22  # Claude MCP requires Node.js
    uv         # Python package manager for MCP servers
  ];
}
