{ config, pkgs, ... }:

{
  # Wofi configuration
  home.file.".config/wofi/config".text = ''
    show=drun
    allow_images=false
    insensitive=true
    no_actions=true
    dmenu-parse_action=false
  '';

  home.file.".config/wofi/style.css".text = ''
    * {
        font-family: "Monaco", "SF Pro Display", "Inter", sans-serif;
        font-size: 14px;
        color: #333333;
    }

    window {
        background-color: rgba(204, 204, 204, 0.78);
        border-radius: 12px;
        padding: 16px;
        border: 1px solid rgba(71, 71, 71, 0.35);
    }

    #input {
        margin: 8px;
        padding: 6px 10px;
        border-radius: 8px;
        font-size: 14px;
        color: #333333;
        background-color: rgba(255, 255, 255, 0.6);
        border: 1px solid rgba(71, 71, 71, 0.35);
        box-shadow: none;
        outline: none;
        caret-color: #333333;
    }

    #input:focus {
        border: 1px solid rgba(71, 71, 71, 0.55);
        background-color: rgba(255, 255, 255, 0.75);
        box-shadow: none;
        outline: none;
    }

    #entry {
        padding: 6px 10px;
        border-radius: 6px;
        background-color: transparent;
        color: #333333;
    }

    #entry:selected {
        background-color: rgba(71, 71, 71, 0.15);
        color: #111111;
    }

    #entry image:first-child {
        opacity: 0;
        min-width: 0;
        min-height: 0;
        margin: 0;
        padding: 0;
    }
  '';
}
