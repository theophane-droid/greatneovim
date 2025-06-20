#!/bin/bash

total=8

echo "[1/$total] Installing dependencies"
sudo apt install -y build-essential cmake ninja-build gettext libtool libtool-bin pkg-config unzip curl git xclip ripgrep >/dev/null 2>&1

echo "[2/$total] Cloning Neovim"
git clone --depth 1 --branch stable https://github.com/neovim/neovim >/dev/null 2>&1
cd neovim
cd ..

echo "[3/$total] Building Neovim"
make CMAKE_BUILD_TYPE=RelWithDebInfo -j"$(nproc)" >/dev/null 2>&1
sudo make install >/dev/null 2>&1

echo "[4/$total] Creating config"
mkdir -p ~/.config/nvim/plugin
cp ./init.lua ~/.config/nvim/ # 2>/dev/null

echo "[5/$total] Downloading packer"
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim >/dev/null 2>&1

read -rp "[6/$total] Create alias 'vim' -> 'nvim'? (y/n) " ans
if [[ $ans =~ ^[Yy]$ ]]; then
    echo "alias vim='nvim'" >> ~/.bashrc
    echo "[6/$total] Alias added to ~/.bashrc"
else
    echo "[6/$total] Alias skipped"
fi

echo "[7/$total] Running PackerSync"
nvim +PackerSync

echo "[8/$total] Done!"


