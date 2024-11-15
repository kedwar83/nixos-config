{
  config,
  pkgs,
  lib,
  inputs,
  hostParams,
  ...
}: let
  username = hostParams.username;
  scripts = pkgs.callPackage ../../modules/usr/services/default.nix {
    inherit config pkgs lib hostParams;
  };
in {
  home-manager.users.${username} = {...}: {
    home = {
      username = username;
      homeDirectory = "/home/${username}";
      stateVersion = "24.05";
      packages = import ../../modules/usr/config/packages.nix {
        inherit pkgs config hostParams;
      };
    };

    programs = import ../../modules/usr/config/programs.nix {
      inherit config pkgs;
    };

    imports = [
      ../../modules/usr/services/services/default.nix
    ];
  };

  home-manager.backupFileExtension = "backup";
}
