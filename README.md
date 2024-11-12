nixos-config/
├── flake.nix
├── hosts/
│   └── desktop.nix               # Desktop-specific configuration
├── hardware/
│   └── desktop-hardware.nix      # Hardware-specific settings for desktop
├── modules/                      # Directory for modular files
│   ├── boot.nix
│   ├── networking.nix
│   ├── services.nix
│   ├── system.nix
│   ├── security.nix
│   ├── users.nix
│   ├── hardware.nix            
│   └── scripts/default.nix
└── home-manager.nix              



# NixOS Configuration Flake

This repository contains the NixOS configuration files and supporting scripts for my personal NixOS setup. Please review the [Security Considerations](#security-considerations) section before using these scripts.

## Overview

The main components of this configuration are:

1. `configuration.nix`: The central NixOS configuration file.
2. `flake.nix`: The Nix Flake definition, which manages dependencies and outputs.
3. `scripts/`:
   - `dotfiles-sync`: A script to sync dotfiles with a Git repository.
   - `nixos-sync`: A script to manage the NixOS configuration and perform system rebuilds.
   - `service-monitor`: A script to monitor critical system services and send desktop notifications on failures.

## Installation and Setup

1. **Clone the Repository**: Clone this repository to your local machine.

   ```
   git clone git@github.com:kedwar83/.nixos-config.git
   ```

2. **First-Time Setup**: Run the `nixos-sync` script as root to perform the initial setup:

   ```
   sudo ./scripts/nixos-sync
   ```

   This script will:
   - Generate the LUKS configuration in `configuration.nix`.
   - Copy the NixOS configuration files to `/etc/nixos`.
   - Rebuild the NixOS system.
   - Run the `dotfiles-sync` script to set up the user's dotfiles.

3. **Subsequent Syncs**: After the initial setup, you can run the `nixos-sync` script to keep your NixOS configuration up-to-date:

   ```
   sudo ./scripts/nixos-sync
   ```

   This script will:
   - Sync the NixOS configuration files from `/etc/nixos` to the local Git repository.
   - Format the Nix files using Alejandra.
   - Rebuild the NixOS system.
   - Commit and push the changes to the Git repository.

4. **Dotfiles Sync**: The `dotfiles-sync` script is responsible for syncing your user's dotfiles with a Git repository. It is automatically run during the initial setup and can be run manually as needed:

   ```
   dotfiles-sync
   ```

   This script will:
   - Initialize a Git repository in `~/.dotfiles` if it doesn't exist.
   - Copy your dotfiles from your home directory to the repository.
   - Stow the dotfiles into your home directory.
   - Commit and push any changes to the Git repository.

## Scripts Overview

### `dotfiles-sync`

This script is responsible for syncing your user's dotfiles with a Git repository. It is automatically run during the initial NixOS setup and can be run manually as needed.

### `nixos-sync`

This script is the main entry point for managing your NixOS configuration. It performs the following tasks:

1. Ensures the Git repository for the NixOS configuration is set up correctly.
2. Formats the Nix files in the configuration directory using Alejandra.
3. Copies the NixOS configuration files from `/etc/nixos` to the local Git repository.
4. Checks for any changes in the repository, and if found, rebuilds the NixOS system and commits the changes to the repository.

### `service-monitor`

This script monitors the status of critical system services and sends desktop notifications if any of them fail. It currently checks the following services:

1. The NixOS auto-upgrade service.
2. The `dotfiles-sync` service.

If any of these services encounter errors, the script will send a notification to the active display users.

## Security Considerations

Before implementing these scripts, please be aware of the following security considerations:

1. The scripts contain hardcoded paths and repository URLs that should be modified for your specific setup.
2. The `nixos-sync` script requires root privileges and should be used with caution.
3. SSH keys and credentials should be properly secured and isolated.
4. Review and test all scripts in a controlled environment before deployment.
5. Consider implementing additional access controls and security measures based on your specific needs.

## Customization

You can customize this NixOS configuration by modifying the `configuration.nix` file and the scripts in the `scripts/` directory. If you have any questions or need assistance, feel free to reach out.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
