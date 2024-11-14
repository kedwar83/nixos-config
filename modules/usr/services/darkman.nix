# /etc/nixos/modules/usr/services/darkman.nix
{ pkgs, hostParams, ... }:

let
  darkModeKdePlasmaScript = ../darkman/dark-mode/kde-plasma.sh;
  lightModeKdePlasmaScript = ../darkman/light-mode/kde-plasma.sh;
  darkModeKonsoleThemeScript = ../darkman/dark-mode/kde-konsole-theme.sh;
  lightModeKonsoleThemeScript = ../darkman/light-mode/kde-konsole-theme.sh;
in {
  services.darkman = {
    enable = true;
    settings = {
      lat = 35.99;
      lng = -78.90;
    };

darkModeScripts = {
      "kde-plasma.sh" = "${darkModeKdePlasmaScript}/bin/dark-mode-kde-plasma";
      "kde-konsole-theme.sh" = "${darkModeKonsoleThemeScript}/bin/dark-mode-konsole-theme";
    };
    lightModeScripts = {
      "kde-plasma.sh" = "${lightModeKdePlasmaScript}/bin/light-mode-kde-plasma";
      "kde-konsole-theme.sh" = "${lightModeKonsoleThemeScript}/bin/light-mode-konsole-theme";
    };
  };
}
