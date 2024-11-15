{
  config,
  pkgs,
  lib,
  inputs,
  hostParams,
  ...
}: let
  username = hostParams.username;
  # Import all scripts
  scriptsModule = import ../../modules/usr/bin/default.nix {
    inherit config pkgs lib;
  };
in {
  home-manager.users.${username} = {...}: {
    # Basic home configuration
    home = {
      username = username;
      homeDirectory = "/home/${username}";
      stateVersion = "24.05";
      packages =
        import ../../modules/usr/config/packages.nix {
          inherit pkgs config hostParams;
        }
        ++ (lib.attrValues scriptsModule.scripts); # Add all scripts
    };

    # Import programs
    programs = import ../../modules/usr/config/programs.nix {
      inherit config pkgs;
    };

    # Other imports if needed
    imports = [
      ../../modules/usr/services/default.nix
    ];
  };

  home-manager.backupFileExtension = "backup";
}
