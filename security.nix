{
  config,
  pkgs,
  ...
}: let
  username = "keganre";
  nixosSyncScript = pkgs.writeShellScriptBin "nixos-sync" (builtins.readFile ./scripts/nixos-sync.sh);
  dotfilesSyncScript = pkgs.writeShellScriptBin "dotfiles-sync" (builtins.readFile ./scripts/dotfiles-sync.sh);
  serviceMonitorScript = pkgs.writeShellScriptBin "service-monitor" (builtins.readFile ./scripts/service-monitor.sh);
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
          {
            command = "${dotfilesSyncScript}/bin/dotfiles-sync";
            options = ["PASSWD"];
          }
          {
            command = "${serviceMonitorScript}/bin/service-monitor";
            options = ["NOPASSWD"];
          }
          {
            command = "${pkgs.input-remapper}/bin/input-remapper-control";
            options = ["NOPASSWD"];
          }
          {
            command = "${pkgs.input-remapper}/bin/input-remapper-service";
            options = ["NOPASSWD"];
          }
          {
            command = "${pkgs.input-remapper}/bin/input-remapper-reader-service";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
