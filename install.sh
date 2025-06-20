#!/bin/bash

echo "[+] Let's install neovim ! It could take few minutes to build"

echo "[+] Installing dependencies"
sudo apt install -y build-essential cmake ninja-build gettext \
     libtool libtool-bin pkg-config unzip curl git xclip ripgrep 

echo "[+] Cloning neovim"
git clone --depth 1 --branch stable https://github.com/neovim/neovim
cd neovim

echo "[+] Building neovim ( please be patient )"
make CMAKE_BUILD_TYPE=RelWithDebInfo -j"$(nproc)"
sudo make install

echo "[+] Creating config"
mkdir -p ~/.config/nvim/plugin
cp ~/init.lua ~/.config/nvim/


echo "[+] Downloading packer"
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

echo "[+] Done ! Please run nvim then :PackerSync"


