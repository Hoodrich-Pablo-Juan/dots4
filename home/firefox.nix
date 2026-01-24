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
        
        # Enable userChrome.css
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        
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
    };
  };

  # Create a script to download Parfait theme
  home.file.".local/bin/install-parfait-theme.sh" = {
    text = ''
      #!/usr/bin/env bash
      
      FIREFOX_PROFILE="$HOME/.mozilla/firefox/default"
      CHROME_DIR="$FIREFOX_PROFILE/chrome"
      
      echo "Installing Parfait Firefox theme..."
      
      # Create chrome directory if it doesn't exist
      mkdir -p "$CHROME_DIR"
      
      # Download userChrome.css
      echo "Downloading userChrome.css..."
      curl -sL "https://raw.githubusercontent.com/reizumii/parfait/main/chrome/userChrome.css" \
        -o "$CHROME_DIR/userChrome.css"
      
      # Download userContent.css
      echo "Downloading userContent.css..."
      curl -sL "https://raw.githubusercontent.com/reizumii/parfait/main/chrome/userContent.css" \
        -o "$CHROME_DIR/userContent.css"
      
      echo "Parfait theme installed successfully!"
      echo "Please restart Firefox for changes to take effect."
      echo ""
      echo "Note: The theme is already enabled via about:config."
    '';
    executable = true;
  };
}
