{
  config,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "America/New_York";
  system = {
    autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = ["--update-input" "nixpkgs" "-L"];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };
    stateVersion = "24.05";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  environment = {
    systemPackages = with pkgs; [
    ];
  };
}
