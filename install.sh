#!/usr/bin/env bash
set -euo pipefail

total=8

echo "[1/$total] Installing dependencies"
sudo apt update -qq
sudo apt install -y build-essential cmake ninja-build gettext \
  libtool libtool-bin pkg-config unzip curl git ripgrep \
  libx11-dev libxt-dev xclip wl-clipboard >/dev/null 2>&1

echo "[2/$total] Cloning Neovim"
[ -d "./neovim" ] && rm -rf "./neovim"
git clone --depth 1 --branch stable https://github.com/neovim/neovim
cd neovim

echo "[3/$total] Building Neovim (clipboard enabled)"
make CMAKE_BUILD_TYPE=RelWithDebInfo -j"$(nproc)"
sudo make install
cd ..

echo "[4/$total] Creating config"
mkdir -p ~/.config/nvim/plugin
cp ./init.lua ~/.config/nvim/ 2>/dev/null || true
rm -rf ~/.config/nvim/lua || true
cp -r ./lua ~/.config/nvim/ 2>/dev/null || true

echo "[5/$total] Installing packer"
PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [ -d "$PACKER_DIR" ]; then
  echo "[5/$total] Packer already installed, skipping"
else
  mkdir -p "$(dirname "$PACKER_DIR")"
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
fi

read -rp "[6/$total] Create alias 'vim' -> 'nvim'? (y/n) " ans
if [[ $ans =~ ^[Yy]$ ]]; then
  echo "alias vim='nvim'" >> ~/.bashrc
  echo "[6/$total] Alias added to ~/.bashrc"
else
  echo "[6/$total] Alias skipped"
fi

echo "[7/$total] Running PackerSync"
nvim --headless +PackerSync +qa

echo "\n/$total] Done! Vérifiez avec 'nvim --version | grep clipboard'."

