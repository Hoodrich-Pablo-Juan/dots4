{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = "DP-1,3440x1440@120,0x0,1";
      
      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$browser" = "firefox";
      "$menu" = "wofi --show drun";

      exec-once = [
        "waybar"
        "swaybg -i ~/.config/wallpapers/default.jpg -m fill"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "colemak_dh";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(ffffffee)";
        "col.inactive_border" = "rgba(595959aa)";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
        };
      };

      # Colemak-DH navigation
      bind = [
        "$mod, T, exec, $terminal"
        "$mod, Return, exec, $terminal"
        "$mod, F, exec, $browser"
        "$mod, A, exec, $menu"
        "$mod, Q, killactive"
        "$mod, W, togglefloating"
        "ALT, Space, fullscreen"
        
        # Focus (NEIO = arrow keys on Colemak-DH)
        "$mod, N, movefocus, l"
        "$mod, E, movefocus, d"
        "$mod, I, movefocus, u"
        "$mod, O, movefocus, r"
        
        # Move windows
        "$mod SHIFT, N, movewindow, l"
        "$mod SHIFT, E, movewindow, d"
        "$mod SHIFT, I, movewindow, u"
        "$mod SHIFT, O, movewindow, r"
        
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
        
        # Screenshots
        "$mod, P, exec, grimblast copy area"
        ", Print, exec, grimblast copy screen"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
