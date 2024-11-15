# default.nix
{
  config,
  pkgs,
  lib,
  ...
}: let
  mkScript = name: text: pkgs.writeShellScriptBin name text;

  scripts = {
    dotfilesSyncScript = mkScript "dotfiles-sync" ''
      ${builtins.readFile ./dotfiles-sync.sh}
    '';

    serviceMonitorScript = mkScript "service-monitor" ''
      ${builtins.readFile ./service-monitor.sh}
    '';

    darkModeKdePlasmaScript = mkScript "dark-mode-kde-plasma" ''
      ${builtins.readFile ./darkman/dark-mode/kde-plasma.sh}
    '';

    lightModeKdePlasmaScript = mkScript "light-mode-kde-plasma" ''
      ${builtins.readFile ./darkman/light-mode/kde-plasma.sh}
    '';

    darkModeKonsoleThemeScript = mkScript "dark-mode-konsole-theme" ''
      ${builtins.readFile ./darkman/dark-mode/kde-konsole-theme.sh}
    '';

    lightModeKonsoleThemeScript = mkScript "light-mode-konsole-theme" ''
      ${builtins.readFile ./darkman/light-mode/kde-konsole-theme.sh}
    '';
  };
in
  scripts
