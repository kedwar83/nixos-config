{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [
    (pkgs.writeScriptBin "nixos-sync" (builtins.readFile ./nixos-sync.sh))
  ];
}
