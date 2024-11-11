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
    user.services.mpris-proxy = {
      description = "Mpris proxy";
      after = ["network.target" "sound.target"];
      wantedBy = ["default.target"];
      serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    };
    services = {
      StartInputRemapperDaemonAtLogin = {
        enable = true;
        description = "Start input-remapper daemon after login";
        after = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
        script = lib.getExe (pkgs.writeShellApplication {
          name = "start-input-mapper-daemon";
          runtimeInputs = with pkgs; [input-remapper procps];
          text = ''
            # Wait for user session - check every 0.5s instead of 1s for faster startup
            while ! pgrep -u ${username} "plasma"; do
              sleep 0.5
            done

            # Start services if not running
            if ! pgrep -u root "input-remapper-service" > /dev/null; then
              input-remapper-service &
            fi

            sleep 2 # Added small delay between services to prevent race conditions

            if ! pgrep -u root "input-remapper-reader" > /dev/null; then
              input-remapper-reader-service &
            fi

            # Wait for services to be fully started - reduced from 5s to 3s
            sleep 3

            # Apply configuration
            input-remapper-control --command stop-all
            sleep 1 # Added small delay between commands
            input-remapper-control --command autoload
          '';
        });
        wantedBy = ["multi-user.target"];
      };
      ReloadInputRemapperAfterSleep = {
        enable = true;
        description = "Reload input-remapper config after sleep";
        after = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];
        serviceConfig = {
          User = username;
          Type = "oneshot";
          RemainAfterExit = "yes";
        };
        script = lib.getExe (pkgs.writeShellApplication {
          name = "reload-input-mapper-config";
          runtimeInputs = with pkgs; [input-remapper ps gawk systemd];
          text = ''
            # Wait for input-remapper services to be ready - check every 0.5s
            while ! systemctl is-active input-remapper.service; do
              sleep 0.5
            done

            sleep 1 # Added small delay to ensure service is fully ready

            input-remapper-control --command stop-all
            sleep 0.5 # Added small delay between commands
            input-remapper-control --command autoload

            # Check for success
            if ! input-remapper-control --command is-active; then
              # Retry if failed
              sleep 1 # Reduced from 2s to 1s
              input-remapper-control --command stop-all
              sleep 0.5 # Added small delay between commands
              input-remapper-control --command autoload
            fi
          '';
        });
        wantedBy = ["suspend.target" "hibernate.target" "hybrid-sleep.target"];
      };
    };
  };
}
