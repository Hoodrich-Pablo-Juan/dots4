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
        modules-center = [ "clock" ];
        modules-right = [ 
          "network" 
          "custom/bluetooth" 
          "pulseaudio"
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
          on-click = "iwgtk";
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
      #pulseaudio {
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

      /* --- INVISIBLE PILLS FOR CONNECTIVITY ICONS AND CLOCK --- */
      #network, #custom-bluetooth, #clock {
          background: transparent;
          padding: 0 5px;
          margin-top: 10px;
          margin-bottom: 10px;
          margin-right: 0px;
      }

      /* Clock specific styling */
      #clock {
          color: #111827;
          font-size: 14px;
          padding: 0 10px;
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
          margin-right: 25px;
      }

      #tray { 
          background-color: #f3f4f6; 
          padding: 5px 10px; 
      }
    '';
  };
}
