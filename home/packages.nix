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

    # DON'T add zen-browser here - it's already added by the home manager module!
    # zen-browser.packages.${pkgs.system}.default  <-- REMOVE THIS LINE

    # Fonts
    (nerd-fonts.jetbrains-mono)
    
    # Claude Desktop with FHS for MCP support
    claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs
    
    # MCP tooling
    nodejs_22  # For npx MCP servers
    uv         # For uvx Python MCP servers
  ];
}
