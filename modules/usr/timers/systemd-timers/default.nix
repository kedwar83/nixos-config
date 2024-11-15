{
  config,
  pkgs,
  lib,
  hostParams,
  ...
}: let
  # Import individual service files
  dotfilesSyncTimer = import ./dotfiles-sync.nix {inherit config pkgs lib hostParams;};
  serviceMonitorTimer = import ./service-monitor.nix {inherit config pkgs lib hostParams;};
in
  # Merge all timers
  lib.mkMerge [
    dotfilesSyncTimer
    serviceMonitorTimer
  ]
