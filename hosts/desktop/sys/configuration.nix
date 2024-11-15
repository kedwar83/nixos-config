{
  config,
  pkgs,
  inputs,
  lib,
  hostParams,
  ...
}: {
  imports = [
    ../../../modules/sys/config/default.nix
    ../../../modules/sys/bin/default.nix
    ./boot.nix
    ./hardware-configuration.nix
    ../../../modules/sys/config/users/kegan.nix
  ];
  _module.args = {
    inherit hostParams;
  };
  system.stateVersion = "24.05";
}
