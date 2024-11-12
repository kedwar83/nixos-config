{
  config,
  pkgs,
  lib,
  hostParams,
  ...
}: let
  username = hostParams.username;

  # Create executable script derivations
  mkScript = name: text: pkgs.writeShellScriptBin name text;

  # Define scripts with executable permissions
  dotfilesSyncScript = mkScript "dotfiles-sync" ''
    ${builtins.readFile ./dotfiles-sync.sh}
  '';

  nixosSyncScript = mkScript "nixos-sync" ''
    ${builtins.readFile ./nixos-sync.sh}
  '';

  serviceMonitorScript = mkScript "service-monitor" ''
    ${builtins.readFile ./service-monitor.sh}
  '';
in {
  systemd.services = {
    dotfiles-sync = {
      description = "Sync dotfiles to git repository";
      path = with pkgs; [
        bash
        git
        coreutils
        findutils
        libnotify
        rsync
        stow
        openssh
        util-linux
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${dotfilesSyncScript}/bin/dotfiles-sync";
        User = username;
        Group = "users";
        IOSchedulingClass = "idle";
        CPUSchedulingPolicy = "idle";
      };
      environment = {
        GIT_SSH_COMMAND = "ssh -i /home/${username}/.ssh/id_ed25519";
        HOME = "/home/${username}";
      };
      wants = ["dbus.socket"];
      after = ["dbus.socket"];
    };

    service-monitor = {
      description = "Monitor critical services for failures";
      path = with pkgs; [
        bash
        systemd
        libnotify
        sudo
        coreutils
        gnugrep
        procps
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${serviceMonitorScript}/bin/service-monitor";
        User = username;
        Group = "users";
      };
      after = ["nixos-upgrade.service" "dotfiles-sync.service"];
    };
  };

  systemd.timers = {
    dotfiles-sync = {
      description = "Timer for dotfiles sync service";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "04:00:00";
        Persistent = true;
        RandomizedDelaySec = "30min";
      };
    };

    service-monitor = {
      description = "Timer for service monitoring";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "04:00:00";
        Persistent = true;
        RandomizedDelaySec = "30min";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    dotfilesSyncScript
    nixosSyncScript
    serviceMonitorScript
  ];
}
