{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    
    policies = {
      ExtensionSettings = {
        # LeechBlock NG
        "leechblockng@proginosko.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/leechblock-ng/latest.xpi";
          installation_mode = "force_installed";
        };
        # Vimium C
        "vimium-c@gdh1995.cn" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
          installation_mode = "force_installed";
        };
        # Stylus for userCSS
        "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/styl-us/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      
      # Additional policies
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisplayBookmarksToolbar = "never";
      SearchBar = "unified";
    };

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      
      settings = {
        # Privacy & Security
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        
        # UI preferences
        "browser.uiCustomization.state" = builtins.toJSON {
          placements = {
            widget-overflow-fixed-list = [];
            nav-bar = [
              "back-button"
              "forward-button"
              "urlbar-container"
              "downloads-button"
            ];
            toolbar-menubar = [ "menubar-items" ];
            TabsToolbar = [ "tabbrowser-tabs" "new-tab-button" "alltabs-button" ];
            PersonalToolbar = [ "personal-bookmarks" ];
          };
        };
        
        # New tab page
        "browser.newtabpage.enabled" = false;
        "browser.startup.page" = 3; # Restore previous session
        
        # Smooth scrolling
        "general.smoothScroll" = true;
      };

      userChrome = ''
        /* Parfait theme will be applied here */
        /* The userChrome.css from Parfait should be pasted here */
        /* Visit: https://github.com/reizumii/parfait/blob/main/chrome/userChrome.css */
      '';

      userContent = ''
        /* Parfait theme userContent */
        /* The userContent.css from Parfait should be pasted here */
        /* Visit: https://github.com/reizumii/parfait/blob/main/chrome/userContent.css */
      '';
    };
  };

  # Download Parfait theme files
  home.file.".mozilla/firefox/default/chrome/userChrome.css".source = 
    pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/reizumii/parfait/main/chrome/userChrome.css";
      sha256 = "0000000000000000000000000000000000000000000000000000"; # You'll need to update this
    };

  home.file.".mozilla/firefox/default/chrome/userContent.css".source = 
    pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/reizumii/parfait/main/chrome/userContent.css";
      sha256 = "0000000000000000000000000000000000000000000000000000"; # You'll need to update this
    };
}
