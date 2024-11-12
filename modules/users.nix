{
  config,
  pkgs,
  hostParams,
  ...
}: let
  username = hostParams.username;
in {
  users.users.${username} = {
    isNormalUser = true;
    description = "Kegan Riley Edwards";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.kclock
    ];
  };

  programs = {
    kdeconnect.enable = true;
    steam.enable = true;
  };
}
