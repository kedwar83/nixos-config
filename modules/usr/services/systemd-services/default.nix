# modules/usr/services/systemd-services/default.nix
{ config, pkgs, lib, hostParams, ... }:
let
  # Import individual service files
  dotfilesSyncService = import ./dotfiles-sync.nix { inherit config pkgs lib hostParams; };
  inputRemapperService = import ./input-remapper-autoload.nix { inherit config pkgs lib hostParams; };
  serviceMonitorService = import ./service-monitor.nix { inherit config pkgs lib hostParams; };
in
  # Merge all services
  lib.mkMerge [
    dotfilesSyncService
    inputRemapperService
    serviceMonitorService
  ]
