{ config, pkgs, lib, hostParams, ... }: {

systemd.user = {
services = pkgs.callPackage ../../usr/services/systemd-services/default.nix { inherit config pkgs lib hostParams; };
timers = pkgs.callPackage ../../usr/timers/systemd-timers/default.nix { inherit config pkgs lib hostParams; };
};
}
