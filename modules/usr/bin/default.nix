{ config, pkgs, lib, ... }:

let
  mkScript = name: text: pkgs.writeShellScriptBin name text;

  scripts = {
    dotfilesSyncScript = mkScript "dotfiles-sync" ''
      ${builtins.readFile ./dotfiles-sync.sh}
    '';

    serviceMonitorScript = mkScript "service-monitor" ''
      ${builtins.readFile ./service-monitor.sh}
    '';
  };
in {
  _module.args = scripts;
}
