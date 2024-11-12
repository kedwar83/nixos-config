# hosts/desktop.nix
{ config
, pkgs
, inputs
, lib
, hostParams
, ...
}: {
  imports = [
    ../modules/networking.nix
    ../modules/services.nix
    ../modules/system.nix
    ../modules/security.nix
    ../modules/users.nix
    ../modules/hardware.nix
    ../modules/scripts/default.nix
    ../home-manager.nix
  ];

  # Pass hostParams to all imported modules
  _module.args = {
    inherit hostParams;
  };

  # Remove the local hostname and username declarations since they're now coming from hostParams
  system.stateVersion = "24.05";
}
