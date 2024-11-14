{ config, pkgs, lib, ... }:

{
  service-monitor = {
    description = "Timer for service monitoring";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "04:00:00";
      Persistent = true;
      RandomizedDelaySec = "30min";
    };
  };
}
