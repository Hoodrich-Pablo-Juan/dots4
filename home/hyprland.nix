{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = "DP-1,3440x1440@120,0x0,1";
      
      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$fileManager" = "nautilus";
      "$browser" = "firefox";
      "$menu" = "wofi --show drun --prompt \"\" --location center --width 600";

      exec-once = [
        "waybar"
        "swaybg -i ~/.config/wallpapers/eink.jpg -m fill"
        "hyprsunset -t 3400"  # Warm color temperature filter (3400K)
        "brightnessctl set 10%"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "nm-applet --indicator"
        "dunst"
        "blueman-applet"
      ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "GDK_BACKEND,wayland"
        "QT_QPA_PLATFORM,wayland"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      input = {
        kb_layout = "us";
        kb_variant = "colemak_dh";
        numlock_by_default = true;
        mouse_refocus = false;
        accel_profile = "flat";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      gestures = {
        workspace_swipe_invert = true;
        workspace_swipe_distance = 700;
        workspace_swipe_use_r = true;
        workspace_swipe_cancel_ratio = "0.3";
      };

      general = {
        gaps_in = 8;
        gaps_out = 28;  # Increased gap between waybar and windows
        border_size = 1;
        "col.active_border" = "rgba(333333cc)";
        "col.inactive_border" = "rgba(33333377)";
        resize_on_border = true;
        layout = "dwindle";
      };

      decoration = {
        rounding = 22;
        active_opacity = "1.0";
        inactive_opacity = "0.92";
        blur = {
          enabled = true;
          size = 20;
          passes = 4;
          new_optimizations = true;
          ignore_opacity = false;
          vibrancy = "0.2";
          special = true;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
        };
      };

      animations = {
        enabled = true;
        bezier = "ease, 0.15, 0.9, 0.1, 1.0";
        animation = [
          "windows, 1, 6, ease"
          "windowsOut, 1, 5, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      # Window Management
      bind = [
        "$mod, Q, killactive"
        "Alt, F4, killactive"
        "$mod, Delete, exit"
        "$mod, W, togglefloating"
        "$mod, G, togglegroup"
        "Alt, Space, fullscreen"
        "$mod, J, togglesplit"
        
        # Focus (Colemak DH - NEIO = arrow keys)
        "$mod, N, movefocus, l"
        "$mod, E, movefocus, d"
        "$mod, I, movefocus, u"
        "$mod, O, movefocus, r"
        "$mod, Left, movefocus, l"
        "$mod, Right, movefocus, r"
        "$mod, Up, movefocus, u"
        "$mod, Down, movefocus, d"
        "Alt, Tab, cyclenext"
        
        # Move windows
        "$mod SHIFT, N, movewindow, l"
        "$mod SHIFT, E, movewindow, d"
        "$mod SHIFT, I, movewindow, u"
        "$mod SHIFT, O, movewindow, r"
        "$mod SHIFT, Left, movewindow, l"
        "$mod SHIFT, Right, movewindow, r"
        "$mod SHIFT, Up, movewindow, u"
        "$mod SHIFT, Down, movewindow, d"
        
        # Applications
        "$mod, T, exec, $terminal"
        "$mod, Return, exec, $terminal"
        "$mod, E, exec, $fileManager"
        "$mod, F, exec, $browser"
        "$mod, V, exec, pavucontrol"
        "$mod, A, exec, $menu"
        "Control Shift, Escape, exec, $terminal -e htop"
        
        # Screenshots & Recording
        "$mod SHIFT, P, exec, hyprpicker -a"
        "$mod, P, exec, grim -g \"$(slurp)\" - | wl-copy"
        ", Print, exec, grim - | wl-copy"
        "$mod Control, P, exec, ~/.config/hypr/scripts/wf-toggle-recorder.sh"
        
        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        
        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        
        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      # Resize windows
      binde = [
        "$mod Control, Right, resizeactive, 30 0"
        "$mod Control, Left, resizeactive, -30 0"
        "$mod Control, Up, resizeactive, 0 -30"
        "$mod Control, Down, resizeactive, 0 30"
      ];

      # Hardware Controls - Audio
      bindl = [
        ", F10, exec, pamixer -t"
        ", XF86AudioMute, exec, pamixer -t"
      ];

      bindle = [
        ", F11, exec, pamixer -d 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", F12, exec, pamixer -i 5"
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Window rules
      windowrulev2 = [
        "float, class:^(pavucontrol)$"
        "float, class:^(blueman-manager)$"
        "float, class:^(nm-connection-editor)$"
        "float, title:^(Open File)$"
        "float, title:^(Save File)$"
      ];
    };
  };
}
