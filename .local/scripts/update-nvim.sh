#!/bin/bash

set -e

REPO_URL="https://github.com/neovim/neovim.git"
BUILD_DIR="$HOME/bin/neovim-build"

echo "Cloning Neovim stable branch..."
git clone --depth 1 --branch stable "$REPO_URL" "$BUILD_DIR"

cd "$BUILD_DIR"

echo "Building Neovim..."
make CMAKE_BUILD_TYPE=Release

echo "Installing Neovim (sudo may ask for your password)..."
sudo make install

echo "Cleaning up..."
cd /
rm -rf "$BUILD_DIR"

echo "Neovim updated to latest stable version!"
