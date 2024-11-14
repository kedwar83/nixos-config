{ pkgs, config, ... }: {
  programs = {

    home-manager.enable = true;
    git.enable = true;
    kdeconnect.enable = true;
    steam.enable = true;
  };

}
