{ config, pkgs, lib, ... }:

{
  dotfiles-sync = {
    description = "Timer for dotfiles sync service";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "04:00:00";
      Persistent = true;
      RandomizedDelaySec = "30min";
    };
  };
}
