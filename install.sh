#!/usr/bin/env bash
set -euo pipefail

total=9

echo "[1/$total] Installing dependencies"
sudo apt update -qq
sudo apt install -y build-essential cmake ninja-build gettext \
  libtool libtool-bin pkg-config unzip curl git ripgrep \
  libx11-dev libxt-dev xclip wl-clipboard openssl >/dev/null 2>&1

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
  for rc in ~/.bashrc ~/.zshrc; do
    [ -f "$rc" ] && grep -qxF "alias vim='nvim'" "$rc" || echo "alias vim='nvim'" >> "$rc"
  done
  echo "[6/$total] Alias added (bash/zsh)"
else
  echo "[6/$total] Alias skipped"
fi


echo "[7/$total] Adding tmux‑nobar helper function to bashrc/zshrc"
helper='
# --- nvim in detached tmux (no status bar) ---
nvim() {
  printf "set -g status off\n" > /tmp/tmux_nobar.conf
  sock="dev"
  dir="$(basename \"$PWD\")"
  session="${dir}_$(openssl rand -hex 3)"
  tmux -L "$sock" -f /tmp/tmux_nobar.conf new-session -A -s "$session" \
       bash -c "nvim \"$*\""
}
# --- end nvim helper ---
'

for rc in ~/.bashrc ~/.zshrc; do
  if [ -f "$rc" ]; then
    if ! grep -q "nvim() {" "$rc"; then
      printf "%s\n" "$helper" >> "$rc"
      echo "[7/$total] Helper added to $rc"
    else
      tmp_helper=$(mktemp)
      printf "%s\n" "$helper" > "$tmp_helper"
      sed -i "/# --- nvim in detached tmux/,/# --- end nvim helper/ {
        r $tmp_helper
        d
      }" "$rc"
      rm "$tmp_helper"
      echo "[7/$total] Helper updated in $rc"
    fi
  fi
done

echo "[8/$total] Running PackerSync"
nvim --headless +PackerSync +qa

echo "[9/$total] Done! Vérifiez avec 'nvim --version | grep clipboard'."
