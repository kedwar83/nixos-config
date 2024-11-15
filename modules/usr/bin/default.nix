{
  config,
  pkgs,
  lib,
  ...
}: let
  mkScript = name: text: pkgs.writeShellScriptBin name text;
in {
  scripts = {
    dotfilesSync = mkScript "dotfiles-sync" ''
      ${builtins.readFile ./dotfiles-sync.sh}
    '';

    serviceMonitor = mkScript "service-monitor" ''
      ${builtins.readFile ./service-monitor.sh}
    '';

    darkModeKdePlasma = mkScript "dark-mode-kde-plasma" ''
      ${builtins.readFile ./darkman/dark-mode/kde-plasma.sh}
    '';

    lightModeKdePlasma = mkScript "light-mode-kde-plasma" ''
      ${builtins.readFile ./darkman/light-mode/kde-plasma.sh}
    '';

    darkModeKonsoleTheme = mkScript "dark-mode-konsole-theme" ''
      ${builtins.readFile ./darkman/dark-mode/kde-konsole-theme.sh}
    '';

    lightModeKonsoleTheme = mkScript "light-mode-konsole-theme" ''
      ${builtins.readFile ./darkman/light-mode/kde-konsole-theme.sh}
    '';
  };
}
