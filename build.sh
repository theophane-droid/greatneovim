#!/usr/bin/env bash
set -euo pipefail

APP=nvim
APPDIR="$PWD/AppDir"
NV_BUILD="$PWD/neovim"

rm -rf "$APPDIR" "$NV_BUILD"

git clone --depth 1 --branch stable https://github.com/neovim/neovim "$NV_BUILD"
make -C "$NV_BUILD" CMAKE_BUILD_TYPE=RelWithDebInfo \
                    CMAKE_INSTALL_PREFIX="$APPDIR/usr" -j"$(nproc)"
make -C "$NV_BUILD" install

echo "[2] Copy config"
mkdir -p "$APPDIR/usr/config/nvim"
cp init.lua "$APPDIR/usr/config/nvim/"
cp -r lua "$APPDIR/usr/config/nvim/"
cp -r plugin "$APPDIR/usr/config/nvim/"

echo "[3] Copy plugins"
PLUGIN_SRC="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site"
if [ -d "$PLUGIN_SRC" ]; then
  rsync -a "$PLUGIN_SRC/" "$APPDIR/usr/share/nvim/site/"
fi

echo "[4] Add AppRun"
cat > "$APPDIR/AppRun" <<'EOF'
#!/bin/bash
HERE="$(dirname "$(readlink -f "$0")")"
export VIMRUNTIME="$HERE/usr/share/nvim/runtime"
export XDG_CONFIG_HOME="$HERE/usr/config"
export XDG_DATA_HOME="$HERE/usr/share"
export PARSE_INSTALL_DIR="${XDG_DATA_HOME}/nvim/parsers"
exec "$HERE/usr/bin/nvim" "$@"
EOF
chmod +x "$APPDIR/AppRun"

echo "[5] Desktop entry & icon"
cat > "$APPDIR/$APP.desktop" <<EOF
[Desktop Entry]
Name=Neovim
Exec=$APP
Icon=$APP
Type=Application
Categories=Utility;TextEditor;
EOF

ICON_SRC="$NV_BUILD/runtime/nvim.png"
ICON_DST="$APPDIR/usr/share/icons/hicolor/256x256/apps"
mkdir -p "$ICON_DST"
cp "$ICON_SRC" "$ICON_DST/$APP.png"
cp "$ICON_SRC" "$APPDIR/$APP.png"

echo "[6] Build AppImage"
tool=appimagetool-x86_64.AppImage
[ -x "$tool" ] || {
  wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/$tool
  chmod +x "$tool"
}
./"$tool" "$APPDIR" "${APP}.AppImage"

echo "✅ AppImage generated: ${APP}.AppImage"
