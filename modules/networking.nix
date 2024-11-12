{ config
, pkgs
, hostParams
, ...
}: {
  networking = {
    hostName = hostParams.hostname;
    networkmanager.enable = true;
    nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
  };
}
