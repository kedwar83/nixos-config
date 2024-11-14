{ config, pkgs, lib, hostParams, ... }:

let
  username = hostParams.username;
in {
  user-input-remapper-autoload = {
    enable = true;
    description = "Input Remapper Configuration Autoloader";
    after = [
      "input-remapper.service"
      "graphical-session.target"
      "sleep.target"
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
    ];
    requires = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5"; # Increased delay
      ExecStart = "${pkgs.input-remapper}/bin/input-remapper-control --command autoload";
      RemainAfterExit = "yes";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    wantedBy = [
      "graphical-session.target"
      "sleep.target"
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
    ];
  };
}
