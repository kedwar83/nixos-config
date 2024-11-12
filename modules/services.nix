{
  config,
  pkgs,
  lib,
  hostParams, # Add this parameter
  ...
}: let
  username = hostParams.username;
in {
  services = {
    timesyncd.enable = true;
    input-remapper.enable = true;
    avahi.enable = true;
    blueman.enable = true;
    # Plasma desktop configuration
    desktopManager.plasma6.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = username;
      };
      defaultSession = "plasmax11";
    };

    # X server configuration
    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Printing and audio configuration
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Ollama and Mullvad VPN
    ollama.enable = true;
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };

    # Systemd-resolved DNS configuration
    resolved = {
      enable = true;
      dnssec = "true";
      domains = ["~."];
      fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
      dnsovertls = "true";
    };
  };

  systemd = {
    user.services = {
      input-remapper-autoload = {
        enable = true;
        description = "Input Remapper Configuration Autoloader";

        # Wait for the main input-remapper service and desktop session
        after = ["input-remapper.service" "graphical-session.target"];
        requires = ["graphical-session.target"];
        partOf = ["graphical-session.target"];

        serviceConfig = {
          Type = "oneshot";
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
          ExecStart = "${pkgs.input-remapper}/bin/input-remapper-control --command autoload";
          RemainAfterExit = "yes";
        };

        # Start with the graphical session
        wantedBy = ["graphical-session.target"];
      };
      mpris-proxy = {
        description = "Mpris proxy";
        after = ["network.target" "sound.target"];
        wantedBy = ["default.target"];
        serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      };
    };
  };
  # Ensure the user can access input devices
  users.users.${username}.extraGroups = ["input"];
}
