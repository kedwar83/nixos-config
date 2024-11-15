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
        # Ollama and Mullvad VPN
        ollama.enable = true;
        mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
        };



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

    # Systemd-resolved DNS configuration
    resolved = {
      enable = true;
      dnssec = "true";
      domains = ["~."];
      fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
      dnsovertls = "true";
    };
  };
}
