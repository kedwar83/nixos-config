# hosts/desktop.nix
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
    ./boot.nix
    ./hardware-configuration.nix
    ../../../modules/sys/config/users/kegan.nix
  ];

  # Pass hostParams to all imported modules
  _module.args = {
    inherit hostParams;
  };

  # Remove the local hostname and username declarations since they're now coming from hostParams
  system.stateVersion = "24.05";
}
