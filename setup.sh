#!/bin/bash

set -e
set -u

# DISCLAIMER
echo "WARNING: This script will install a window manager and a display manager (lightdm) on your system."
echo "It can overwrite or break existing configurations."
read -rp "Do you wish to proceed? [y/N] " PROCEED
if [[ "$PROCEED" != "y" && "$PROCEED" != "Y" ]]; then
  echo "Cancelled."
  exit 1
fi

# Get the real user running the script (even under sudo)
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")

# Install packages
echo "Installing required packages (including zsh, exa, ranger, lightdm)..."
sudo apt update
sudo apt install -y \
  sway sway-backgrounds swaylock swayidle light swaybg swayimg waybar \
  network-manager alacritty wofi fonts-font-awesome pipewire wireplumber \
  pipewire-audio-client-libraries libspa-0.2-bluetooth pavucontrol \
  lxqt-policykit lxappearance qt5ct udisks2 gvfs gvfs-backends xwayland \
  mousepad grim slurp mako-notifier libnotify-bin wl-clipboard xarchiver \
  zsh exa ranger pcmanfm lightdm lightdm-gtk-greeter

# Remove unneeded packages
echo "Removing unnecessary packages..."
sudo apt purge -y qlipper foot thunar
sudo apt autoremove -y

# Enable LightDM
echo "Enabling LightDM display manager..."
sudo systemctl enable lightdm

# Find the script location (assumed to be the dotfiles directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create symlinks for .config
echo "Linking .config files..."
mkdir -p "$REAL_HOME/.config"
for item in "$SCRIPT_DIR/.config/"*; do
  name=$(basename "$item")
  ln -sf "$item" "$REAL_HOME/.config/$name"
done

# Create symlinks for .local/bin
echo "Linking .local/bin files..."
mkdir -p "$REAL_HOME/.local/bin"
for item in "$SCRIPT_DIR/.local/bin/"*; do
  name=$(basename "$item")
  ln -sf "$item" "$REAL_HOME/.local/bin/$name"
done

# Symlink .zshenv to home
echo "Linking .zshenv to home directory..."
ln -sf "$SCRIPT_DIR/.zshenv" "$REAL_HOME/.zshenv"

# Fix ownership
chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.config" "$REAL_HOME/.local" "$REAL_HOME/.zshenv"

# Change shell to zsh if not already set
CURRENT_SHELL=$(getent passwd "$REAL_USER" | cut -d: -f7)
if [ "$CURRENT_SHELL" != "/bin/zsh" ]; then
  echo "Changing default shell for $REAL_USER to zsh..."
  sudo chsh -s /bin/zsh "$REAL_USER"
else
  echo "Default shell is already zsh for $REAL_USER"
fi

echo "Setup complete. Dotfiles linked from: $SCRIPT_DIR"

# Ask for reboot
echo
read -rp "Do you want to reboot now? [y/N] " REBOOT
if [[ "$REBOOT" == "y" || "$REBOOT" == "Y" ]]; then
  echo "Rebooting..."
  sudo reboot
else
  echo "You can reboot later with 'sudo reboot'."
fi

