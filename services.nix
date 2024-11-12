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

  # Define systemd-specific services
  systemd = {
    # Autoloader service to run at startup and after waking from sleep
    services.input-remapper-autoload = {
      enable = true;
      description = "Input Remapper Configuration Autoloader";
      after = ["input-remapper.service" "plasma-workspace.target" "suspend.target" "hibernate.target"];
      requires = ["input-remapper.service"];
      serviceConfig = {
        Type = "oneshot"; # Runs once per trigger
        User = username;
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 2"; # Delay to ensure all dependencies are ready
        ExecStart = "${pkgs.input-remapper}/bin/input-remapper-control --command autoload";
        RemainAfterExit = "yes";
      };
      # Triggers on session startup, suspend, and hibernate wake-up
      wantedBy = ["graphical-session.target" "suspend.target" "hibernate.target"];
    };

    # Define user-level services
    user.services.mpris-proxy = {
      description = "Mpris proxy";
      after = ["network.target" "sound.target"];
      wantedBy = ["default.target"];
      serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    };
  };
}
