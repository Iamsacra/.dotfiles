#!/bin/bash

set -e
set -u

# === Intro & Warning ===
echo "WARNING: This script installs Sway and replaces your login manager with greetd + gtkgreet."
read -rp "Do you want to proceed? [y/N] " PROCEED
if [[ "$PROCEED" != "y" && "$PROCEED" != "Y" ]]; then
  echo "Cancelled."
  exit 1
fi

# === User Detection ===
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")

# === Install system packages ===
echo "Installing required packages..."
sudo apt update
sudo apt install -y \
  sway swaylock swayidle swaybg swayimg waybar wdisplays \
  network-manager alacritty wofi fonts-font-awesome pipewire wireplumber \
  pipewire-audio-client-libraries libspa-0.2-bluetooth pavucontrol \
  lxqt-policykit lxappearance qt5ct udisks2 gvfs gvfs-backends xwayland \
  mousepad grim slurp mako-notifier libnotify-bin wl-clipboard xarchiver \
  zsh exa ranger \
  greetd nm-connection-editor network-manager-applet

# === Remove old software ===
echo "Removing any old software"
sudo apt purge -y qlipper foot 
sudo apt autoremove -y

# === Ask whether to install tuigreet and greetdMore actions ===
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

# === Optional: create Wayland session file for compatibility ===
sudo tee /usr/share/wayland-sessions/sway.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Sway
Comment=An i3-compatible Wayland compositor
Exec=sway
Type=Application
DesktopNames=Sway
EOF

# === Enable greetd ===
sudo systemctl enable greetd

# === Link dotfiles ===
echo "Linking dotfiles from current directory..."

mkdir -p "$REAL_HOME/.config"
for item in "$PWD/.config/"*; do
  ln -sf "$item" "$REAL_HOME/.config/$(basename "$item")"
done

mkdir -p "$REAL_HOME/.local/bin"
for item in "$PWD/.local/bin/"*; do
  ln -sf "$item" "$REAL_HOME/.local/bin/$(basename "$item")"
done

ln -sf "$PWD/.zshenv" "$REAL_HOME/.zshenv"
chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.config" "$REAL_HOME/.local" "$REAL_HOME/.zshenv"

# === Set zsh as default shell and clone dependacies ===
CURRENT_SHELL=$(getent passwd "$REAL_USER" | cut -d: -f7)
if [ "$CURRENT_SHELL" != "/bin/zsh" ]; then
  echo "Changing default shell for $REAL_USER to zsh..."
  sudo chsh -s /bin/zsh "$REAL_USER"
fi

git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting
mv zsh-autosuggestions ~/.config/zsh
mv fast-syntax-highlighting ~/.config/zsh

echo "Setup complete. Sway will start from greetd via gtkgreet after reboot."

# === Ask to reboot ===
read -rp "Reboot now? [y/N] " REBOOT
if [[ "$REBOOT" == "y" || "$REBOOT" == "Y" ]]; then
  sudo reboot
else
  echo "You can reboot later using 'sudo reboot'"
fi

