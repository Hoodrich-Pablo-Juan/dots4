{ config, pkgs, zen-browser, claude-desktop, ... }:

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
    
    # Claude Desktop with FHS for MCP support
    claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs
    
    # MCP tooling
    nodejs_22  # For npx MCP servers
    uv         # For uvx Python MCP servers
  ];
}
