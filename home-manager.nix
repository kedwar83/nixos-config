{
  config,
  pkgs,
  inputs,
  ...
}: let
  username = "keganre";
  darkModeKdePlasmaScript = "./modules/scripts/darkman/dark-mode/kde-plasma.sh";
  lightModeKdePlasmaScript = "./modules/scripts/darkman/light-mode/kde-plasma.sh";
  darkModeKonsoleThemeScript = "./modules/scripts/darkman/dark-mode/kde-konsole-theme.sh";
  lightModeKonsoleThemeScript = "./modules/scripts/darkman/light-mode/kde-konsole-theme.sh";
in {
  home-manager = {
    backupFileExtension = "backup";
    users.${username} = {pkgs, ...}: {
      home = {
        username = username;
        homeDirectory = "/home/${username}";
        stateVersion = "24.05";

        packages = with pkgs; [
          nicotine-plus
          git
          alejandra
          inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
          signal-desktop-beta
          kdePackages.kdeplasma-addons
          ollama
          strawberry-qt6
          steam
          gimp-with-plugins
          vscodium
          gh
          libnotify
          input-remapper
          darkman
          joplin-desktop
          mullvad-vpn
          qbittorrent
          stow
          mpv
          neovim
          libgcc
          brave
          git-remote-gcrypt
          gnupg
        ];
      };

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

      programs = {
        home-manager.enable = true;
        git.enable = true;
      };
    };
  };
}
