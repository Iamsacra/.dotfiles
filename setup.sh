#!/bin/bash

set -e
set -u

# Get the real user running the script (even under sudo)
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")

echo "Installing all required packages (including zsh, exa, ranger)..."
sudo apt update
sudo apt install -y \
  sway sway-backgrounds swaylock swayidle light swaybg swayimg greetd waybar \
  network-manager alacritty wofi fonts-font-awesome pipewire wireplumber \
  pipewire-audio-client-libraries libspa-0.2-bluetooth pavucontrol \
  lxqt-policykit lxappearance qt5ct udisks2 gvfs gvfs-backends xwayland \
  mousepad grim slurp swappy mako-notifier libnotify-bin wl-clipboard xarchiver \
  zsh exa ranger

echo "Removing unnecessary packages..."
sudo apt purge -y qlipper foot
sudo apt autoremove -y

echo "Creating config directories..."
mkdir -p "$REAL_HOME/.config/sway" "$REAL_HOME/.config/waybar" "$REAL_HOME/.config/wofi"
chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME/.config"

echo "Adding backports and installing tuigreet..."
echo "deb http://deb.debian.org/debian bookworm-backports main" | \
  sudo tee /etc/apt/sources.list.d/backports.list
sudo apt update
sudo apt install -t bookworm-backports -y tuigreet

echo "Enabling greetd login manager..."
sudo systemctl enable greetd

echo "Writing greetd config for user '$REAL_USER'..."
cat <<EOF | sudo tee /etc/greetd/config.toml > /dev/null
[terminal]
vt = 7

[default_session]
command = "tuigreet --cmd sway"
user = "$REAL_USER"
EOF

echo "Disabling PulseAudio and enabling PipeWire..."
sudo -u "$REAL_USER" systemctl --user --now disable pulseaudio.service pulseaudio.socket || true
sudo -u "$REAL_USER" systemctl --user --now enable pipewire pipewire-pulse wireplumber

# Ask user where to store the dotfiles
echo
read -rp "Enter the directory where you want to store your dotfiles (e.g. ~/Documents/bin): " DOTFILES_DIR_INPUT

# Resolve to absolute path
DOTFILES_PARENT_DIR=$(realpath -m "$DOTFILES_DIR_INPUT")
DOTFILES_DIR="$DOTFILES_PARENT_DIR/.dotfiles"

# Create the directory
mkdir -p "$DOTFILES_DIR"
chown -R "$REAL_USER":"$REAL_USER" "$DOTFILES_PARENT_DIR"

# Path where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy the folders and file
echo "Copying dotfiles to: $DOTFILES_DIR"
cp -r "$SCRIPT_DIR/.config" "$DOTFILES_DIR/"
cp -r "$SCRIPT_DIR/.local" "$DOTFILES_DIR/"
cp "$SCRIPT_DIR/.zsh" "$DOTFILES_DIR/"

chown -R "$REAL_USER":"$REAL_USER" "$DOTFILES_DIR"

# Change shell to zsh if not already set
CURRENT_SHELL=$(getent passwd "$REAL_USER" | cut -d: -f7)
if [ "$CURRENT_SHELL" != "/bin/zsh" ]; then
  echo "Changing default shell for $REAL_USER to zsh..."
  sudo chsh -s /bin/zsh "$REAL_USER"
else
  echo "Default shell is already zsh for $REAL_USER"
fi

echo "Setup complete. Dotfiles copied to: $DOTFILES_DIR"
