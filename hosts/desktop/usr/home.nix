# /etc/nixos/hosts/desktop/usr/home.nix
{ config, pkgs, lib, inputs, hostParams, ... }: let
  username = hostParams.username;

  # Define dotfilesSyncScript and serviceMonitorScript as Nix derivations
  dotfilesSyncScript = pkgs.writeScript "dotfiles-sync.sh" (builtins.readFile ../../../modules/usr/bin/dotfiles-sync.sh);
  serviceMonitorScript = pkgs.writeScript "service-monitor.sh" (builtins.readFile ../../../modules/usr/bin/service-monitor.sh);
in {
  home-manager = {
    backupFileExtension = "backup";
    users.${username} = {
      home = {
        username = username;
        homeDirectory = "/home/${username}";
        stateVersion = "24.05";
         ./packages.nix
      }
      imports = [
        ({ config, pkgs, ... }: import ./programs.nix { inherit config pkgs hostParams; })

      ];
      services = {
        # Ollama and Mullvad VPN
        ollama.enable = true;
        mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
        };
      };
    };
  };

  # Import services with the updated script definitions
  systemd.services = import ../../../modules/usr/services/systemd-services/default.nix {
    inherit config pkgs lib hostParams dotfilesSyncScript serviceMonitorScript;
  };

  systemd.timers = import ../../../modules/usr/timers/systemd-timers/default.nix {
    inherit config pkgs lib hostParams;
  };
}
