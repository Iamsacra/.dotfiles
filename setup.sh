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
  sway swaylock swayidle swaybg swayimg waybar \
  network-manager alacritty wofi fonts-font-awesome pipewire wireplumber \
  pipewire-audio-client-libraries libspa-0.2-bluetooth pavucontrol \
  lxqt-policykit lxappearance qt5ct udisks2 gvfs gvfs-backends xwayland \
  mousepad grim slurp mako-notifier libnotify-bin wl-clipboard xarchiver \
  zsh exa ranger \
  greetd \
  git ninja-build cmake gettext meson pkg-config \
  libgtk-3-dev libjson-c-dev gtk-layer-shell-doc

# === Remove old display managers ===
echo "Removing any old display managers..."
sudo apt purge -y lightdm
sudo apt autoremove -y

# === Build gtkgreet from source ===
echo "Cloning and building gtkgreet..."
git clone https://github.com/kennylevinsen/gtkgreet
cd gtkgreet
meson setup build
ninja -C build
sudo ninja -C build install
cd ..
rm -rf gtkgreet

# === Configure greetd ===
echo "Writing greetd configuration..."
sudo tee /etc/greetd/config.toml > /dev/null <<EOF
[terminal]
vt = 7

[default_session]
command = "gtkgreet --cmd sway"
user = "$REAL_USER"
EOF

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

# === Set zsh as default shell ===
CURRENT_SHELL=$(getent passwd "$REAL_USER" | cut -d: -f7)
if [ "$CURRENT_SHELL" != "/bin/zsh" ]; then
  echo "Changing default shell for $REAL_USER to zsh..."
  sudo chsh -s /bin/zsh "$REAL_USER"
fi

echo "Setup complete. Sway will start from greetd via gtkgreet after reboot."

# === Ask to reboot ===
read -rp "Reboot now? [y/N] " REBOOT
if [[ "$REBOOT" == "y" || "$REBOOT" == "Y" ]]; then
  sudo reboot
else
  echo "You can reboot later using 'sudo reboot'"
fi

