#!/bin/bash

set -e
set -u

# DISCLAIMER
echo "WARNING: This script will install a window manager and a display manager on your system."
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
echo "Installing required packages (including zsh, exa, ranger, sway)..."
sudo apt update
sudo apt install -y \
  sway sway-backgrounds swaylock swayidle light swaybg swayimg waybar \
  network-manager alacritty wofi fonts-font-awesome pipewire wireplumber \
  pipewire-audio-client-libraries libspa-0.2-bluetooth pavucontrol \
  lxqt-policykit lxappearance qt5ct udisks2 gvfs gvfs-backends xwayland \
  mousepad grim slurp mako-notifier libnotify-bin wl-clipboard xarchiver \
  zsh exa ranger

# Remove unneeded packages
echo "Removing unnecessary packages..."
sudo apt purge -y qlipper foot
sudo apt autoremove -y

# Add backports for gtkgreet and greetd
echo "Adding Debian bookworm-backports repository..."
echo "deb http://deb.debian.org/debian bookworm-backports main" | \
  sudo tee /etc/apt/sources.list.d/backports.list
sudo apt update

echo "Installing greetd and gtkgreet..."
sudo apt install -t bookworm-backports -y greetd gtkgreet

echo "Enabling greetd login manager..."
sudo systemctl enable greetd

# Write greetd config
echo "Writing greetd config for user '$REAL_USER'..."
sudo tee /etc/greetd/config.toml > /dev/null <<EOF
[terminal]
vt = 7

[default_session]
command = "gtkgreet --cmd sway"
user = "$REAL_USER"
EOF

# Create sway session entry (optional but useful for compatibility)
sudo tee /usr/share/wayland-sessions/sway.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Sway
Comment=An i3-compatible Wayland compositor
Exec=sway
Type=Application
DesktopNames=Sway
EOF

# Symlink .config files
echo "Linking .config files..."
mkdir -p "$REAL_HOME/.config"
for item in "$PWD/.config/"*; do
  name=$(basename "$item")
  ln -sf "$item" "$REAL_HOME/.config/$name"
done

# Symlink .local/bin files
echo "Linking .local/bin files..."
mkdir -p "$REAL_HOME/.local/bin"
for item in "$PWD/.local/bin/"*; do
  name=$(basename "$item")
  ln -sf "$item" "$REAL_HOME/.local/bin/$name"
done

# Symlink .zshenv
echo "Linking .zshenv to home directory..."
ln -sf "$PWD/.zshenv" "$REAL_HOME/.zshenv"

# Set correct permissions
chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.config" "$REAL_HOME/.local" "$REAL_HOME/.zshenv"

# Change default shell to zsh if not already set
CURRENT_SHELL=$(getent passwd "$REAL_USER" | cut -d: -f7)
if [ "$CURRENT_SHELL" != "/bin/zsh" ]; then
  echo "Changing default shell for $REAL_USER to zsh..."
  sudo chsh -s /bin/zsh "$REAL_USER"
else
  echo "Default shell is already zsh for $REAL_USER"
fi

echo "Setup complete. Dotfiles linked from repository and greetd configured with gtkgreet."

# Ask for reboot
echo
read -rp "Do you want to reboot now? [y/N] " REBOOT
if [[ "$REBOOT" == "y" || "$REBOOT" == "Y" ]]; then
  echo "Rebooting..."
  sudo reboot
else
  echo "You can reboot later with 'sudo reboot'."
fi

