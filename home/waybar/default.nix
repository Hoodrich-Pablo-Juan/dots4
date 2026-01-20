{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;
        spacing = 0;
        exclusive = false;
        output = "DP-1";
      
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "custom/countdown" ];
        modules-right = [ 
          "network" 
          "custom/bluetooth" 
          "pulseaudio"
          "clock" 
        ];
      
        "hyprland/workspaces" = {
          format = "{name}";
          active-only = false;
          show-empty = false;
          all-outputs = false;
          sort-by-number = true;
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
        };
      
        clock = {
          tooltip = false;
          format = "{:%a %e, %H:%M}";
        };
      
        network = {
          format = "";
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          on-click = "kitty --class impala -e impala";
        };
      
        "custom/bluetooth" = {
          format = "{}";
          return-type = "json";
          exec = ''
            if bluetoothctl show | grep -q 'Powered: yes'; then
              if bluetoothctl devices Connected | grep -q 'Device'; then
                echo '{"text": "", "class": "connected"}'
              else
                echo '{"text": "󰂯", "class": "on"}'
              fi
            else
              echo '{"text": "󰂲", "class": "off"}'
            fi
          '';
          on-click = "blueman-manager";
          interval = 5;
        };
      
        pulseaudio = {
          tooltip = false;
          scroll-step = 2;
          format = "{icon}  {volume}%";
          format-muted = "  {volume}%";
          format-icons = {
            default = [ "" "" ];
            headphones = "";
          };
          on-click = "pavucontrol";
        };
      
        "custom/countdown" = {
          return-type = "json";
          format = "{}";
          exec = ''
            now=$(date +%s)
            target=$(date -d '22:00' +%s)
            if [ "$now" -gt "$target" ]; then
              target=$(date -d 'tomorrow 22:00' +%s)
            fi
            remaining=$((target - now))
            hours=$((remaining / 3600))
            minutes=$(((remaining % 3600) / 60))
            printf '{"text": "󰔟 %dh %dm"}' "$hours" "$minutes"
          '';
          interval = 60;
          tooltip = false;
        };
      };
    };

    style = ''
      * {
        font-family: "SF Pro Text", "SF Pro Display", "Font Awesome 6 Free Solid", "Font Awesome 6 Free";
        font-size: 13px;
        font-weight: 400;
        color: #000000;
        background: transparent;
        min-height: 0;
      }

      window#waybar { background: transparent; }

      #workspaces, #group-status, #network, #custom-bluetooth, #pulseaudio, #clock, #custom-countdown {
        margin: 0;
        padding-top: 0;
        padding-bottom: 0;
      }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        font-size: 12px;
        color: #333333;
        background: transparent;
        border: none;
        padding: 0 6px;
        margin: 0 6px 0 0;
        border-radius: 0;
        box-shadow: none;
        min-height: 0;
      }

      #workspaces button.active {
        background: transparent;
        color: #333333;
        border-bottom: 2px solid #333333;
        padding-bottom: 0;
      }

      #network, #custom-bluetooth, #pulseaudio, #clock, #custom-countdown {
        background: transparent;
        color: #000000;
        padding: 0 4px;
        margin-right: 20px;
      }

      #clock {
        font-weight: 500;
        font-size: 13px;
      }

      #custom-countdown {
        font-size: 12px;
      }
    '';
  };
}{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;
        spacing = 0;
        exclusive = false;
        output = "DP-1";
      
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "custom/countdown" ];
        modules-right = [ 
          "network" 
          "custom/bluetooth" 
          "pulseaudio"
          "clock" 
        ];
        "hyprland/workspaces" = {
          format = "{icon}";
          format-active = " {icon} ";
          on-click = "activate";
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
          };
        };
      
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          interval = 60;
          format = "{:%H:%M}";
        };
      
        network = {
          format = "";
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          on-click = "kitty --class impala -e impala";
        };
      
        "custom/bluetooth" = {
          format = "{}";
          return-type = "json";
          exec = ''
            if bluetoothctl show | grep -q 'Powered: yes'; then
              if bluetoothctl devices Connected | grep -q 'Device'; then
                echo '{"text": "", "class": "connected"}'
              else
                echo '{"text": "󰂯", "class": "on"}'
              fi
            else
              echo '{"text": "󰂲", "class": "off"}'
            fi
          '';
          on-click = "blueman-manager";
          interval = 5;
        };
      
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
        };
      
        "custom/countdown" = {
          return-type = "json";
          format = "{}";
          exec = ''
            now=$(date +%s)
            target=$(date -d '22:00' +%s)
            if [ "$now" -gt "$target" ]; then
              target=$(date -d 'tomorrow 22:00' +%s)
            fi
            remaining=$((target - now))
            hours=$((remaining / 3600))
            minutes=$(((remaining % 3600) / 60))
            printf '{"text": "󰔟 %dh %dm"}' "$hours" "$minutes"
          '';
          interval = 60;
          tooltip = false;
        };
      };
    };

    style = ''
      * {
        font-family: "SF Pro Text", "SF Pro Display", "Font Awesome 6 Free Solid", "Font Awesome 6 Free";
        font-size: 13px;
        font-weight: 400;
        color: #000000;
        background: transparent;
        min-height: 0;
      }

      window#waybar { background: transparent; }

      #workspaces, #group-status, #network, #custom-bluetooth, #pulseaudio, #clock, #custom-countdown {
        margin: 0;
        padding-top: 0;
        padding-bottom: 0;
      }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        font-size: 12px;
        color: #333333;
        background: transparent;
        border: none;
        padding: 0 6px;
        margin: 0 6px 0 0;
        border-radius: 0;
        box-shadow: none;
        min-height: 0;
      }

      #workspaces button.active {
        background: transparent;
        color: #333333;
        border-bottom: 2px solid #333333;
        padding-bottom: 0;
      }

      #network, #custom-bluetooth, #pulseaudio, #clock, #custom-countdown {
        background: transparent;
        color: #000000;
        padding: 0 4px;
        margin-right: 20px;
      }

      #clock {
        font-weight: 500;
        font-size: 13px;
      }

      #custom-countdown {
        font-size: 12px;
      }
    '';
  };
}
