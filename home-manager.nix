{
  config,
  pkgs,
  inputs,
  ...
}: let
  username = "keganre";
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
          "kde-plasma.sh" = ''
            #!/bin/sh
            lookandfeeltool -platform offscreen --apply "org.kde.breezedark.desktop"
          '';

          "kde-konsole-theme.sh" = ''
            #!/usr/bin/env bash
            PROFILE='Breath'
            for pid in $(pidof konsole); do
              qdbus "org.kde.konsole-$pid" "/Windows/1" setDefaultProfile "$PROFILE"
              for session in $(qdbus "org.kde.konsole-$pid" /Windows/1 sessionList); do
                qdbus "org.kde.konsole-$pid" "/Sessions/$session" setProfile "$PROFILE"
              done
            done
          '';
        };

        lightModeScripts = {
          "kde-plasma.sh" = ''
            #!/bin/sh
            lookandfeeltool -platform offscreen --apply "org.kde.breeze.desktop"
          '';

          "kde-konsole-theme.sh" = ''
            #!/usr/bin/env bash
            PROFILE='Breath-light'
            for pid in $(pidof konsole); do
              qdbus "org.kde.konsole-$pid" "/Windows/1" setDefaultProfile "$PROFILE"
              for session in $(qdbus "org.kde.konsole-$pid" /Windows/1 sessionList); do
                qdbus "org.kde.konsole-$pid" "/Sessions/$session" setProfile "$PROFILE"
              done
            done
          '';
        };
      };

      programs = {
        home-manager.enable = true;
        git.enable = true;
      };
    };
  };
}
