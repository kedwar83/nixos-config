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
          # Communication
          nicotine-plus
          signal-desktop-beta
          mullvad-vpn

          # Development
          gcc-unwrapped
          gcc
          gnumake
          binutils
          glibc
          glibc.dev
          python3
          python3Packages.pip
          python3Packages.virtualenv
          alejandra
          vscodium
          gh

          # File Management
          git
          git-remote-gcrypt
          stow

          # Graphics
          gimp-with-plugins

          # Internet
          inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
          brave

          # Multimedia
          strawberry-qt6
          mpv

          # Productivity
          joplin-desktop
          qbittorrent

          # System
          libnotify
          input-remapper
          darkman
          libgcc
          neovim

          # Utilities
          ollama
          steam
          kdePackages.kdeplasma-addons
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
