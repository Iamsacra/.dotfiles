#!/bin/bash

set -e
set -u

# DISCLAIMER
echo "WARNING: This script will install a window manager and a display manager (optional) on your system."
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
echo "Installing required packages (including zsh, exa, ranger)..."
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

# Create essential directories
echo "Creating config directories..."
mkdir -p "$REAL_HOME/.config/sway" "$REAL_HOME/.config/waybar" "$REAL_HOME/.config/wofi"
chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.config"

# Ask whether to install tuigreet and greetd
read -rp "Do you want to install tuigreet and greetd (display manager)? [y/N] " INSTALL_DM
if [[ "$INSTALL_DM" == "y" || "$INSTALL_DM" == "Y" ]]; then
  echo "Adding backports and installing tuigreet..."
  echo "deb http://deb.debian.org/debian bookworm-backports main" | \
    sudo tee /etc/apt/sources.list.d/backports.list
  sudo apt update
  sudo apt install -t bookworm-backports -y tuigreet greetd

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
else
  echo "Skipping tuigreet and greetd installation. You will need to start sway manually or install another display manager."
fi

# Ask where to store dotfiles
echo
while true; do
  read -rp "Enter the directory where you want to store your dotfiles (e.g. ~/Documents/bin): " DOTFILES_DIR_INPUT

  # Expand ~ to full path
  DOTFILES_PARENT_DIR=$(realpath -m "$DOTFILES_DIR_INPUT")
  DOTFILES_DIR="$DOTFILES_PARENT_DIR/.dotfiles"

  # Check that path is inside user's home
  if [[ "$DOTFILES_PARENT_DIR" != "$REAL_HOME"* ]]; then
    echo "The directory must be inside your home folder: $REAL_HOME"
    continue
  fi

  # Check write permissions (or if it needs to be created, check parent)
  if [[ -e "$DOTFILES_PARENT_DIR" && ! -w "$DOTFILES_PARENT_DIR" ]]; then
    echo "You do not have permission to write to $DOTFILES_PARENT_DIR"
    continue
  fi

  break
done

# Resolve path and prepare directory
DOTFILES_PARENT_DIR=$(realpath -m "$DOTFILES_DIR_INPUT")
DOTFILES_DIR="$DOTFILES_PARENT_DIR/.dotfiles"

mkdir -p "$DOTFILES_DIR"
chown -R "$REAL_USER:$REAL_USER" "$DOTFILES_PARENT_DIR"

# Find the script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy dotfiles to .dotfiles directory
echo "Copying dotfiles to: $DOTFILES_DIR"
cp -r "$SCRIPT_DIR/.config" "$DOTFILES_DIR/"
cp -r "$SCRIPT_DIR/.local" "$DOTFILES_DIR/"
cp "$SCRIPT_DIR/.zshenv" "$DOTFILES_DIR/"

chown -R "$REAL_USER:$REAL_USER" "$DOTFILES_DIR"

# Create symlinks for .config
echo "Linking .config files..."
mkdir -p "$REAL_HOME/.config"
for item in "$DOTFILES_DIR/.config/"*; do
  name=$(basename "$item")
  ln -sf "$item" "$REAL_HOME/.config/$name"
done

# Create symlinks for .local/bin
echo "Linking .local/bin files..."
mkdir -p "$REAL_HOME/.local/bin"
for item in "$DOTFILES_DIR/.local/bin/"*; do
  name=$(basename "$item")
  ln -sf "$item" "$REAL_HOME/.local/bin/$name"
done

# Symlink .zshenv to home
echo "Linking .zshenv to home directory..."
ln -sf "$DOTFILES_DIR/.zshenv" "$REAL_HOME/.zshenv"

chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.config" "$REAL_HOME/.local" "$REAL_HOME/.zshenv"

# Change shell to zsh if not already set
CURRENT_SHELL=$(getent passwd "$REAL_USER" | cut -d: -f7)
if [ "$CURRENT_SHELL" != "/bin/zsh" ]; then
  echo "Changing default shell for $REAL_USER to zsh..."
  sudo chsh -s /bin/zsh "$REAL_USER"
else
  echo "Default shell is already zsh for $REAL_USER"
fi

echo "Setup complete. Dotfiles copied to: $DOTFILES_DIR and symlinks created."

# Ask for reboot
echo
read -rp "Do you want to reboot now? [y/N] " REBOOT
if [[ "$REBOOT" == "y" || "$REBOOT" == "Y" ]]; then
  echo "Rebooting..."
  reboot
else
  echo "You can reboot later with 'sudo reboot'."
fi
