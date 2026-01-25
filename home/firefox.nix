{ config, pkgs, firefox-addons, zen-browser, ... }:

{
  home.packages = [
    zen-browser.packages.${pkgs.system}.default
  ];

  programs.firefox = {
    enable = true;

    policies = {
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

      # ✅ declarative extension syntax
      extensions.packages = with firefox-addons.packages.${pkgs.system}; [
        leechblock-ng
        vimium-c
        stylus
      ];

      settings = {
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;

        "browser.newtabpage.enabled" = false;
        "browser.startup.page" = 3;
        "general.smoothScroll" = true;
      };
    };
  };
}
