{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # ============================================
  # BOOTLOADER
  # ============================================
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # ============================================
  # KERNEL
  # ============================================
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Android emulation support
  boot.kernelModules = [ "binder_linux" "ashmem_linux" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  # ============================================
  # SWAP
  # ============================================
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # ============================================
  # NETWORKING
  # ============================================
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.backend = "wpa_supplicant";
    };
    # Disable iwd to prevent conflicts
    wireless.iwd.enable = false;
    
    # Firewall configuration
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];  # SSH
    };
  };

  # ============================================
  # SSH SERVER
  # ============================================
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;  # Allow password login locally
      PermitRootLogin = "no";         # Don't allow root login for security
    };
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
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

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
  # DISPLAY & DESKTOP - HYPRLAND
  # ============================================
  services.xserver = {
    enable = true;
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
    extraPortals = [ 
      pkgs.xdg-desktop-portal-hyprland 
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # ============================================
  # WAYDROID (Android Emulation)
  # ============================================
  virtualisation.waydroid.enable = true;

  # ============================================
  # ENVIRONMENT VARIABLES (NVIDIA + Wayland)
  # ============================================
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
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

  # Enable dbus
  services.dbus.enable = true;

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
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "video" 
      "audio" 
      "input"
    ];
    shell = pkgs.bash;
    # Set initial password for SSH (change with `passwd` command after first login)
    initialPassword = "changeme";
  };

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
    pciutils
    usbutils

    # Hyprland ecosystem
    hyprland
    hyprpaper
    hyprpicker
    hyprsunset
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk

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
    impala

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

    # Cursor themes
    bibata-cursors
    
    # GTK themes for light mode
    adwaita-icon-theme
    gnome-themes-extra
    
    # GNOME Control Center for network settings
    gnome-control-center

    # Fonts
    jetbrains-mono
    font-awesome
    open-sans
    montserrat
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono

    # Build tools
    cmake
    meson
    ninja
    pkg-config
    gcc
    gnumake
    cpio

    # NVIDIA tools
    nvtopPackages.full
    mesa-demos
    vulkan-tools

    # Wayland support
    qt5.qtwayland
    qt6.qtwayland

    # Waydroid dependencies
    lxc

    # Communication
    beeper

    # File sharing
    localsend

    # Waydroid (Android emulation)
    waydroid
    
    # SSH
    openssh
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
  programs.bash.enableCompletion = true;

  # ============================================
  # MISC
  # ============================================
  nixpkgs.config.allowUnfree = true;

  # ============================================
  # SYSTEM STATE VERSION
  # ============================================
  system.stateVersion = "25.11";
}
