#!/usr/bin/env bash
set -e

ACTUAL_USER=${SUDO_USER:-$USER}
NIXOS_CONFIG_DIR="/home/$ACTUAL_USER/.nixos-config"
CURRENT_USER=$(id -un $ACTUAL_USER)
SETUP_FLAG="/home/$ACTUAL_USER/.system_setup_complete"
GIT_REPO_URL="git@github.com:kedwar83/.nixos-config.git"
USER_EMAIL="keganedwards@proton.me"
SSH_KEY_FILE="/home/$ACTUAL_USER/.ssh/id_ed25519"
NIXOS_ETC_DIR="/etc/nixos"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

echo "Running as user: $CURRENT_USER"
echo "NixOS config directory: $NIXOS_CONFIG_DIR"
echo "Git repository URL: $GIT_REPO_URL"

# Setup git config as the regular user
if [ ! -d "$NIXOS_CONFIG_DIR/.git" ]; then
    echo 'Initializing a new git repository in $NIXOS_CONFIG_DIR...'
    sudo -u $ACTUAL_USER git init "$NIXOS_CONFIG_DIR"
fi

if [ -z "$(sudo -u $ACTUAL_USER git config --global user.email)" ]; then
    echo 'Setting git email...'
    sudo -u $ACTUAL_USER git config --global user.email "$USER_EMAIL"
fi

if ! sudo -u $ACTUAL_USER git config --global --get safe.directory | grep -q "^$NIXOS_CONFIG_DIR$"; then
    echo "Adding $NIXOS_CONFIG_DIR as a safe directory..."
    sudo -u $ACTUAL_USER git config --global --add safe.directory "$NIXOS_CONFIG_DIR"
fi

# Check if SSH key exists, and generate one if not
if [ ! -f "$SSH_KEY_FILE" ]; then
    echo "No SSH key found, generating a new one for $USER_EMAIL..."
    sudo -u $ACTUAL_USER ssh-keygen -t ed25519 -f "$SSH_KEY_FILE" -C "$USER_EMAIL" -N ""
    echo "Please add the following SSH key to your GitHub account:"
    sudo -u $ACTUAL_USER cat "$SSH_KEY_FILE.pub"
    read -p "Press Enter after you've added the key to GitHub to continue..."
fi

if ! sudo -u $ACTUAL_USER git -C "$NIXOS_CONFIG_DIR" remote get-url origin &> /dev/null; then
    echo 'No remote repository found. Adding origin remote...'
    sudo -u $ACTUAL_USER git -C "$NIXOS_CONFIG_DIR" remote add origin "$GIT_REPO_URL"
else
    echo 'Remote repository already configured.'
fi

generate_luks_config() {
    local boot_config_file="$NIXOS_ETC_DIR/boot.nix"
    local temp_file=$(mktemp)
    local boot_device=$(findmnt -n -o SOURCE /boot | grep -o '/dev/nvme[0-9]n[0-9]')
    local luks_uuids=($(blkid | grep "TYPE=\"crypto_LUKS\"" | grep -o "UUID=\"[^\"]*\"" | cut -d'"' -f2))

    # Create the boot.nix file that contains boot-related configuration
    cat > "$boot_config_file" << EOL
{ config, pkgs, ... }:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "${boot_device}";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices = {
EOL

    # Add LUKS device information for each UUID
    for uuid in "${luks_uuids[@]}"; do
        cat >> "$boot_config_file" << EOL
    "luks-${uuid}" = {
      device = "/dev/disk/by-uuid/${uuid}";
      keyFile = "/boot/crypto_keyfile.bin";
    };
EOL
    done

    cat >> "$boot_config_file" << EOL
  };

  boot.secrets = {
    "/boot/crypto_keyfile.bin" = null;
  };
}
EOL

    echo "LUKS and boot configuration successfully written to $boot_config_file."
}


# In the first-time setup section
if [ ! -f "$SETUP_FLAG" ]; then
    echo "First-time setup detected..."

    echo "Generating LUKS configuration..."
    generate_luks_config

    echo "Cloning NixOS configuration repository..."
    # Clone the Git repository into the NIXOS_CONFIG_DIR
    sudo -u $ACTUAL_USER git clone git@github.com:kedwar83/.nixos-config.git "$NIXOS_CONFIG_DIR"

    echo "Creating symlinks for NixOS configuration..."
    sudo bash -c "
    cd \"$NIXOS_CONFIG_DIR\"
    find . -mindepth 1 | while read -r file; do
        target=\"$NIXOS_ETC_DIR/\$file\"
        if [ -d \"\$file\" ]; then
            # If it's a directory, create a symlink to the directory
            mkdir -p \"\$target\"
            ln -s \"\$PWD/\$file\" \"\$target\"
        else
            # If it's a file, create a symlink to the file
            ln -s \"\$PWD/\$file\" \"\$NIXOS_ETC_DIR/\$file\"
        fi
    done
    "

    echo "NixOS Rebuilding..."
    sudo bash -c "cd \"$NIXOS_ETC_DIR\""
    nixos-rebuild switch

    echo "Running dotfiles sync as user..."
    sudo -u $ACTUAL_USER dotfiles-sync

    touch "$SETUP_FLAG"
else
    echo "Regular sync detected..."

    # Formatting Nix files with Alejandra
    echo 'Formatting Nix files with Alejandra...'
    alejandra "$NIXOS_CONFIG_DIR"

    # Adding changes to git
    sudo -u $ACTUAL_USER git -C "$NIXOS_CONFIG_DIR" add .

    # Check for changes in the repository
    if ! sudo -u $ACTUAL_USER git -C "$NIXOS_CONFIG_DIR" diff --quiet || ! sudo -u $ACTUAL_USER git -C "$NIXOS_CONFIG_DIR" diff --cached --quiet; then
        echo 'Changes detected, proceeding with rebuild and commit...'

        # NixOS rebuilding
        echo 'NixOS Rebuilding...'
        sudo bash -c "cd \"$NIXOS_ETC_DIR\""
        nixos-rebuild switch &> /tmp/nixos-switch.log || (cat /tmp/nixos-switch.log | grep --color error && exit 1)

        # Get the current NixOS generation again
        current=$(nixos-rebuild list-generations | grep current)

        # Commit changes
        sudo -u $ACTUAL_USER git -C "$NIXOS_CONFIG_DIR" commit -m "$current"

        # Fetch origin and check out the main branch
        sudo -u $ACTUAL_USER git -C "$NIXOS_CONFIG_DIR" fetch origin
        if ! sudo -u $ACTUAL_USER git -C "$NIXOS_CONFIG_DIR" rev-parse --verify main; then
            echo 'Branch main does not exist. Creating it...'
            sudo -u $ACTUAL_USER git -C "$NIXOS_CONFIG_DIR" checkout -b main
        else
            echo 'Checking out main branch...'
            sudo -u $ACTUAL_USER git -C "$NIXOS_CONFIG_DIR" checkout main
        fi

        # Push changes to origin
        sudo -u $ACTUAL_USER git -C "$NIXOS_CONFIG_DIR" push origin main

        # Notify user
        sudo -u $ACTUAL_USER DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u $ACTUAL_USER)/bus" notify-send "NixOS Rebuilt OK!" --icon=software-update-available
    else
        sudo -u $ACTUAL_USER DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u $ACTUAL_USER)/bus" notify-send "No changes detected, skipping rebuild and commit." --icon=software-update-available
    fi
fi
