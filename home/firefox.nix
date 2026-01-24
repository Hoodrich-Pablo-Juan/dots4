{ config, pkgs, zen-browser, firefox-addons, ... }:

{
  programs.zen-browser = {
    enable = true;
    
    policies = {
      # Disable telemetry and tracking
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisplayBookmarksToolbar = "never";
      DisableAppUpdate = true;
      
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
    
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      # Install extensions declaratively
      extensions = with firefox-addons.packages.${pkgs.system}; [
        leechblock-ng
        vimium-c
        stylus
      ];
      
      settings = {
        # Privacy & Security
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        
        # Enable userChrome.css
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        
        # Disable telemetry completely
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        
        # New tab page
        "browser.newtabpage.enabled" = false;
        "browser.startup.page" = 3; # Restore previous session
        
        # Smooth scrolling
        "general.smoothScroll" = true;
      };
      
      # Parfait theme - paste the CSS content from GitHub here
      userChrome = ''
        /* Parfait Theme for Zen Browser */
        /* Paste the full content from: */
        /* https://raw.githubusercontent.com/reizumii/parfait/main/chrome/userChrome.css */
      '';

      userContent = ''
        /* Parfait Theme userContent */
        /* Paste the full content from: */
        /* https://raw.githubusercontent.com/reizumii/parfait/main/chrome/userContent.css */
      '';
    };
  };
}
