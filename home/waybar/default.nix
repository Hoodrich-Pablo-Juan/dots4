{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 5;
        margin-bottom = -11;
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
          on-click = "nm-connection-editor";
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
      /* Waybar Style Configuration - Minimalist Grayscale Theme */

      * {
          font-family: 'Inter', 'FiraCode Nerd Font', 'Roboto', 'Open Sans', sans-serif;
          font-size: 13px;
          font-weight: 300;
          border: none;
          box-shadow: none;
          text-shadow: none;
      }

      window#waybar {
          background-color: transparent;
      }

      /* --- Base styling for VISIBLE pills --- */
      #clock,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #custom-expand,
      #custom-cycle_wall,
      #custom-ss,
      #custom-dynamic_pill,
      #custom-weather,
      #mpd,
      #uptime,
      #pulseaudio,
      #custom-countdown {
          padding: 0 10px;
          border-radius: 15px;
          background: #ffffff;
          color: #374151;
          margin-top: 10px;
          margin-bottom: 10px;
          margin-right: 10px;
          font-weight: 300;
          border: none;
          box-shadow: none;
      }

      /* --- INVISIBLE PILLS FOR CONNECTIVITY ICONS --- */
      #network, #custom-bluetooth {
          background: transparent;
          padding: 0 5px;
          margin-top: 10px;
          margin-bottom: 10px;
          margin-right: 0px;
      }

      /* --- UPDATED ICON COLORS --- */
      #network.wifi, #network.ethernet, #custom-bluetooth.connected, #custom-bluetooth.on {
          color: #111827;
      }
      #network.disconnected, #custom-bluetooth.off {
          color: #4b5563;
      }

      #custom-dynamic_pill label { color: #111827; }
      #custom-dynamic_pill.paused label { color: #4b5563; }
      #workspaces button label { color: #374151; }
      #workspaces button.active label { color: #ffffff; }

      #workspaces {
          background-color: transparent;
          margin-top: 10px;
          margin-bottom: 10px;
          margin-right: 10px;
          margin-left: 25px;
      }

      #workspaces button {
          background-color: #ffffff;
          border-radius: 15px;
          margin-right: 10px;
          padding: 10px;
          padding-top: 4px;
          padding-bottom: 2px;
          transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.68);
      }

      #workspaces button.active {
          padding-right: 20px;
          padding-left: 20px;
          padding-bottom: 3px;
          background: linear-gradient(45deg, #111827 0%, #1f2937 20%, #374151 40%, #4b5563 60%, #374151 80%, #111827 100%);
          background-size: 400% 400%;
          color: #ffffff;
          animation: gradient_f 20s ease-in-out infinite;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
      }

      @keyframes gradient_f {
          0% { background-position: 0% 200%; }
          50% { background-position: 200% 0%; }
          100% { background-position: 400% 200%; }
      }

      #pulseaudio { 
          background-color: #e5e7eb; 
          color: #1f2937; 
      }

      #custom-countdown { 
          background-color: #d1d5db; 
          color: #1f2937; 
      }

      #clock {
          background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 50%, #f3f4f6 100%);
          background-size: 200% 200%;
          animation: gradient 10s ease infinite;
          margin-right: 25px;
          color: #111827;
          font-size: 14px;
          padding: 5px 21px 5px 20px;
      }

      @keyframes gradient {
          0% { background-position: 0% 50%; }
          50% { background-position: 100% 50%; }
          100% { background-position: 0% 50%; }
      }

      #tray { 
          background-color: #f3f4f6; 
          padding: 5px 10px; 
      }
    '';
  };
}
