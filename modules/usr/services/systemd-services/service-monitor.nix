# modules/usr/services/systemd-services/service-monitor.nix
{ config, pkgs, lib, hostParams, ... }:

let
  username = hostParams.username;

  # Define the service monitor script here
  serviceMonitorScript = pkgs.writeScript "service-monitor.sh" (builtins.readFile ../../bin/service-monitor.sh);
in
{
  "service-monitor" = {
    description = "Monitor critical services for failures";
    path = with pkgs; [
      bash
      systemd
      libnotify
      sudo
      coreutils
      gnugrep
      procps
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${serviceMonitorScript}";
      User = username;
      Group = "users";
    };
    after = ["nixos-upgrade.service" "dotfiles-sync.service"];
  };
}
