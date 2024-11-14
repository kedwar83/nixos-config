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
    };
}
