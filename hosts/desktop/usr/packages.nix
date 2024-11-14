{ pkgs, config, hostParams, ... }: {

packages = with pkgs; [
  # Communication
  nicotine-plus
  signal-desktop-beta
  mullvad-vpn

  # Development
  gcc-unwrapped
  gcc
  gnumake
  binutils
  glibc
  glibc.dev
  python3
  python3Packages.pip
  python3Packages.virtualenv
  alejandra
  vscodium
  gh

  # File Management
  git
  git-remote-gcrypt
  stow

  # Graphics
  gimp-with-plugins

  # Internet
  hostParams.inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
  brave

  # Multimedia
  strawberry-qt6
  mpv

  # Productivity
  joplin-desktop
  qbittorrent

  # System
  libnotify
  input-remapper
  darkman
  libgcc
  neovim

  # Utilities
  ollama
  steam
  kdePackages.kdeplasma-addons
   kdePackages.kate  # Text editor
      kdePackages.kclock
];
}
