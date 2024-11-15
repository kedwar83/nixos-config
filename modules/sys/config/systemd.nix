{
  config,
  pkgs,
  lib,
  hostParams,
  ...
}: {
  systemd.user = {
    services = pkgs.callPackage ../../usr/services/systemd/default.nix {inherit config pkgs lib hostParams;};
    timers = pkgs.callPackage ../../usr/timers/systemd/default.nix {inherit config pkgs lib hostParams;};
  };
}
