{ config, pkgs, firefox-addons, ... }:

{
  # Install Zen Browser
  home.packages = [
    pkgs.zen-browser
  ];

  programs.firefox = {
    enable = true;

    policies = {
      # Privacy / hardening
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableAppUpdate = true;
      DisplayBookmarksToolbar = "never";

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

      # Declarative extensions
      extensions = with firefox-addons.packages.${pkgs.system}; [
        leechblock-ng
        vimium-c
        stylus
      ];

      settings = {
        # Privacy
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        # Allow userChrome.css if you ever want it later
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Telemetry = dead
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;

        # Startup / UX
        "browser.newtabpage.enabled" = false;
        "browser.startup.page" = 3;
        "general.smoothScroll" = true;
      };
    };
  };
}
