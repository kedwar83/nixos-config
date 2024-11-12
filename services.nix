{
  config,
  pkgs,
  lib,
  ...
}: let
  username = "keganre";
in {
  services = {
    input-remapper.enable = true;
    avahi.enable = true;
    geoclue2.enable = true;
    blueman.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = username;
      };
      defaultSession = "plasmax11";
    };
    xserver = {
      enable = true;
      displayManager.lightdm.enable = true; # LightDM config should only be here
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    ollama.enable = true;
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    resolved = {
      enable = true;
      dnssec = "true";
      domains = ["~."];
      fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
      dnsovertls = "true";
    };
  };

  systemd = {
    # Define a user service for the mpris-proxy
    user.services.mpris-proxy = {
      description = "Mpris proxy";
      after = ["network.target" "sound.target"];
      wantedBy = ["default.target"];
      serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    };

    # Define system-wide services
    services = {
      # Primary input-remapper service
      input-remapper = {
        enable = true;
        description = "Input Remapper Main Service";
        serviceConfig = {
          Type = "dbus";
          BusName = "com.github.sezanzeb.input-remapper";
          ExecStart = "${pkgs.input-remapper}/bin/input-remapper-service";
          Restart = "always";
          RestartSec = "1s";
        };
        wantedBy = ["multi-user.target"];
      };

      # Autoloader for input-remapper configuration
      input-remapper-autoload = {
        enable = true;
        description = "Input Remapper Configuration Autoloader";
        after = ["input-remapper.service" "plasma-workspace.target"];
        requires = ["input-remapper.service"];
        serviceConfig = {
          Type = "oneshot"; # Type set to "oneshot" for a single-run service
          User = username;
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
          ExecStart = "${pkgs.input-remapper}/bin/input-remapper-control --command autoload";
          RemainAfterExit = "yes"; # Keep the service active after running
        };
        wantedBy = ["graphical-session.target"];
      };
    };
  };
}
