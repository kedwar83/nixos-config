{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  hostname = "nixos";
  username = "keganre";
in {
  imports = [
    ../hardware-configuration.nix
    ../boot.nix
    ./networking.nix
    ./services.nix
    ./system.nix
    ./security.nix
    ./users.nix
    ./hardware.nix
    ./scripts/default.nix
    ./home-manager.nix
  ];

  time.timeZone = "America/New_York";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  system.stateVersion = "24.05";
}
