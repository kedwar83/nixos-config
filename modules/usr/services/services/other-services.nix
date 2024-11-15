{
  pkgs,
  config,
  ...
}: {
  services = {
    # Ollama and Mullvad VPN
    ollama.enable = true;
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
}
