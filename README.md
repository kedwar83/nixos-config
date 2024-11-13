# NixOS Configuration

This repository contains my personal NixOS configuration using flakes, including system configurations, home-manager setup, and utility scripts for system maintenance and dotfiles synchronization.

## Repository Structure
```
nixos-config/
├── flake.nix                     # Main flake configuration
├── hosts/
│   └── desktop.nix               # Desktop-specific configuration
├── hardware/
│   ├── desktop-hardware.nix      # Hardware-specific settings for desktop
│   ├── *-hardware-configuration.nix  # Hardware configuration for each host
│   └── *-boot.nix               # LUKS/boot configuration for each host
├── modules/                      # Modular configuration files
│   ├── networking.nix           # Network settings
│   ├── services.nix             # System services configuration
│   ├── system.nix               # Core system settings
│   ├── security.nix             # Security-related configurations
│   ├── users.nix                # User management
│   ├── hardware.nix             # Shared hardware configurations
│   └── scripts/                 # Utility scripts
│       ├── default.nix          # Script definitions and packages
│       ├── system/              # General system scripts
│       │   ├── nixos-sync.sh    # NixOS configuration sync and rebuild
│       │   ├── service-monitor.sh   # System service monitoring
│       │   ├── dotfiles-sync.sh     # Dotfiles management
│       └── darkman/             # Dark/light mode scripts
│           ├── light-mode/      # Scripts for light mode
│           │   ├── kde-konsole-theme.sh  # Light mode Konsole theme
│           │   ├── kde-plasma.sh        # Light mode Plasma theme
│           ├── dark-mode/       # Scripts for dark mode
│               ├── kde-konsole-theme.sh  # Dark mode Konsole theme
│               ├── kde-plasma.sh        # Dark mode Plasma theme
└── home-manager.nix             # Home-manager configuration

```

## Utility Scripts

### NixOS Sync Script (nixos-sync.sh)
Located in `/etc/nixos/modules/scripts/`, this script handles:
- Initial system setup
- Git repository management
- LUKS configuration generation
- NixOS rebuilding with flakes
- Automated commits and pushes of configuration changes

Key features:
- First-time setup workflow with guided configuration
- Automatic hostname detection for rebuilds
- LUKS configuration management
- Integration with notification system

### Service Monitor Script (service-monitor.sh)
A utility script that:
- Monitors system service status
- Provides notifications for service failures
- Tracks service performance
- Logs service status changes

### Dotfiles Sync Script (dotfiles-sync.sh)
A script to manage dotfiles synchronization, featuring:
- Automatic backup and versioning of dotfiles
- Selective file synchronization
- Firefox profile management
- Integration with GNU Stow
- Git-based version control

Protected files and directories:
- Security-sensitive files (.ssh, .gnupg)
- Browser data
- Cache directories
- Game-related directories
- State files

## Setup Instructions

### First Time Setup

1. Clone this repository:
```bash
git clone https://github.com/kedwar83/nixos-config.git /etc/nixos
```

2. Run the setup script:
```bash
sudo /etc/nixos/modules/scripts/nixos-sync.sh
```

3. Follow the prompts to:
   - Configure your host-specific settings
   - Set up LUKS encryption
   - Initialize your system configuration

### Adding a New Host

1. Create a new host configuration file in `hosts/`
2. Add hardware-specific settings in `hardware/`
3. Update `flake.nix` to include the new host
4. Run the setup script to generate LUKS configuration and hardware settings

### System Services Monitoring

To start monitoring system services:
```bash
systemctl --user start service-monitor
```

The service monitor will:
- Watch critical system services
- Send desktop notifications for service events
- Maintain service status logs

### Maintaining Dotfiles

Run the dotfiles sync script to manage your configuration files:
```bash
~/.config/nixos/modules/scripts/dotfiles-sync.sh
```

## Usage

### Rebuilding the System

To rebuild your system with the latest configuration:
```bash
sudo /etc/nixos/modules/scripts/nixos-sync.sh
```

The script will:
1. Format Nix files with Alejandra
2. Check for changes
3. Rebuild if necessary
4. Commit and push changes
5. Notify you of the result

### Monitoring Services

The service monitor provides:
- Real-time service status monitoring
- Desktop notifications for service events
- Service restart attempts when appropriate
- Detailed logging of service behavior

### Synchronizing Dotfiles

The dotfiles sync script will:
1. Backup existing configurations
2. Sync new changes
3. Manage Firefox profiles
4. Handle version control
5. Provide detailed logs of operations

## Configuration

### Boot Configuration
The `modules/boot.nix` file contains:
- GRUB bootloader configuration
- LUKS encryption settings
- Boot parameters and kernel settings
- System initialization options

This is separate from the host-specific boot configurations in `hardware/*-boot.nix` which contain:
- Host-specific LUKS device configurations
- Hardware-specific boot parameters
- System-specific boot secrets

## Notes

- All sensitive files are excluded from synchronization
- System-specific configurations are maintained in separate host files
- Hardware configurations are automatically generated but can be manually adjusted
- The setup script maintains a flag file at `~/.system_setup_complete` to track initial setup

## Troubleshooting

- Check the failure log at `~/.dotfiles/failure_log.txt` for stow-related issues
- System rebuild logs are stored in `/tmp/nixos-switch.log`
- Service monitoring logs can be viewed with `journalctl --user -u service-monitor`
- Git-related issues can be resolved by reinitializing the repository using the setup script
