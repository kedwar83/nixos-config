{
  config,
  pkgs,
  ...
}: let
  username = "hostParams.username";
  nixosSyncScript = pkgs.writeShellScriptBin "nixos-sync" (builtins.readFile ../bin/sys/nixos-sync.sh);
in {
  security = {
    rtkit.enable = true;
    pam.services.login.enableKwallet = true;

    sudo.extraRules = [
      {
        users = [username];
        commands = [
          {
            command = "${nixosSyncScript}/bin/nixos-sync";
            options = ["PASSWD"];
          }
        ];
      }
    ];
  };
}
