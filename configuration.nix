# configuration.nix for bryllm
# NixOS 25.11 with Hyprland + NVIDIA 1650M + Intel iGPU
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ============================================
  # BOOT CONFIGURATION
  # ============================================
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    
    # NVIDIA kernel parameters
    kernelParams = [ 
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];
    
    # Blacklist nouveau to prevent conflicts
    blacklistedKernelModules = [ "nouveau" ];
    
    # Load NVIDIA modules early
    kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  };

  # ============================================
  # EXPERIMENTAL FEATURES
  # ============================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ============================================
  # NETWORKING
  # ============================================
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # ============================================
  # LOCALIZATION
  # ============================================
  time.timeZone = "Europe/Bucharest";
  
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  # ============================================
  # NVIDIA CONFIGURATION FOR GTX 1650M
  # ============================================
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia = {
    # Required for Wayland
    modesetting.enable = true;
    
    # Power management (important for laptops)
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    
    # Use open-source driver (supports 1650M/Turing+)
    open = true;
    
    # NVIDIA settings GUI
    nvidiaSettings = true;
    
    # Stable driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    # PRIME configuration for hybrid graphics (Intel + NVIDIA)
    prime = {
      # IMPORTANT: Get your actual bus IDs by running:
      # lspci | grep -E "VGA|3D"
      # Example output:
      #   00:02.0 VGA compatible controller: Intel
      #   01:00.0 3D controller: NVIDIA
      # Then convert to format below (remove dots, add colons)
      
      # Replace these with YOUR actual values from lspci!
      intelBusId = "PCI:0:2:0";    # Update this!
      nvidiaBusId = "PCI:1:0:0";   # Update this!
      
      # OFFLOAD mode: Use NVIDIA only when needed (better battery)
      # To run apps on NVIDIA: nvidia-offload <app-name>
      offload = {
        enable = true;
        enableOffloadCmd = true; # Creates nvidia-offload command
      };
      
      # Alternative: SYNC mode (always use both GPUs, better performance)
      # Uncomment next line and comment out the offload section above
      # sync.enable = true;
    };
  };

  # OpenGL/Graphics support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ============================================
  # AUDIO WITH PIPEWIRE
  # ============================================
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # ============================================
  # BLUETOOTH
  # ============================================
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # ============================================
  # DISPLAY & DESKTOP
  # ============================================
  # Keep GNOME as fallback (optional - you can disable if you only want Hyprland)
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    
    # Colemak DH layout
    xkb = {
      layout = "us";
      variant = "colemak_dh";
    };
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG Portal for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  # ============================================
  # ENVIRONMENT VARIABLES (NVIDIA + Wayland)
  # ============================================
  environment.sessionVariables = {
    # NVIDIA specific
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1"; # Fix for cursor issues
    
    # Wayland
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
    
    # Electron apps on Wayland
    NIXOS_OZONE_WL = "1";
  };

  # ============================================
  # POLKIT (for authentication)
  # ============================================
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # ============================================
  # PRINTING
  # ============================================
  services.printing.enable = true;

  # ============================================
  # USERS
  # ============================================
  users.users.bryllm = {
    isNormalUser = true;
    description = "bryllm";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.bash;
  };

  # Auto-login to TTY1 (optional - for Hyprland auto-start)
  # Uncomment to enable:
  # services.getty.autologinUser = "bryllm";

  # ============================================
  # SYSTEM PACKAGES
  # ============================================
  environment.systemPackages = with pkgs; [
    # System utilities
    vim
    wget
    git
    curl
    lz4
    killall
    file
    unzip
    pciutils  # For lspci
    usbutils  # For lsusb
    
    # Hyprland ecosystem
    hyprland
    hyprpaper
    hyprpicker
    xdg-desktop-portal-hyprland
    
    # Wayland tools
    waybar
    wofi
    swaybg
    grim
    slurp
    wf-recorder
    wl-clipboard
    
    # Terminals
    alacritty
    kitty
    
    # Editor
    helix
    
    # File manager
    nautilus
    
    # Media
    mpv
    
    # System monitors
    htop
    btop
    neofetch
    
    # Audio control
    pavucontrol
    
    # System tools
    brightnessctl
    pamixer
    playerctl
    polkit_gnome
    networkmanagerapplet
    
    # Notifications
    dunst
    libnotify
    
    # Fonts
    jetbrains-mono
    font-awesome
    open-sans
    montserrat
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    
    # Browser
    firefox
    
    # Build tools (for hyprpm and hy3 plugin)
    cmake
    meson
    ninja
    pkg-config
    gcc
    gnumake
    cpio
    
    # NVIDIA tools
    nvtopPackages.full  # GPU monitoring
    mesa-demos
    vulkan-tools
  ];

  # ============================================
  # FONTS
  # ============================================
  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    open-sans
    montserrat
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  # ============================================
  # PROGRAMS
  # ============================================
  programs.firefox.enable = true;
  programs.dconf.enable = true;

  # ============================================
  # MISC
  # ============================================
  nixpkgs.config.allowUnfree = true;

  # ============================================
  # SYSTEM STATE VERSION
  # ============================================
  system.stateVersion = "25.11";
}
