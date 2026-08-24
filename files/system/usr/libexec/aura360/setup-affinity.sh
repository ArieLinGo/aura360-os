#!/bin/bash
# Aura 360 OS - instala Affinity (suite Canva/Serif) en Linux.
# Usa la solucion probada de la comunidad AffinityOnLinux (ryzendew):
# AppImage con Wine parcheado (ElementalWarrior) + prefijo preconfigurado
# (.NET 4.8 real, WinMetadata, wintypes shim, WineFix).
# Fuente: https://github.com/ryzendew/AffinityOnLinux
set -e

APPIMAGE_URL="https://github.com/ryzendew/Linux-Affinity-Installer/releases/latest/download/Affinity-3-x86_64.AppImage"
APPIMAGE="Affinity-3-x86_64.AppImage"
DEST="$HOME/AffinityOnLinux"

echo "==> Descargando AffinityOnLinux (AppImage ~2 GB, incluye Wine parcheado)..."
curl -L --fail --retry 3 -o "$HOME/$APPIMAGE" "$APPIMAGE_URL"
chmod +x "$HOME/$APPIMAGE"

echo "==> Extrayendo el AppImage..."
cd "$HOME"
"./$APPIMAGE" --appimage-extract >/dev/null 2>&1
rm -f "$HOME/$APPIMAGE"

mkdir -p "$DEST"
mv squashfs-root/usr "$DEST/wine"
mv squashfs-root/wineprefix "$DEST/wineprefix"
rm -rf squashfs-root

cat > "$DEST/lanzar-affinity.sh" << EOF
#!/bin/bash
export WINEPREFIX="\$HOME/AffinityOnLinux/wineprefix"
export WINEDEBUG=-all
exec "\$HOME/AffinityOnLinux/wine/bin/wine" "C:\\\\Program Files\\\\Affinity\\\\Affinity.exe" "\$@"
EOF
chmod +x "$DEST/lanzar-affinity.sh"

mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/affinity.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Affinity
Comment=Affinity by Canva (via Wine - AffinityOnLinux)
Exec=$DEST/lanzar-affinity.sh
Icon=affinity
Categories=Graphics;2DGraphics;Photography;Publishing;
Terminal=false
EOF

echo ""
echo "======================================================"
echo "  Affinity instalado en ~/AffinityOnLinux"
echo "  Buscalo como 'Affinity' en el menu de aplicaciones,"
echo "  o ejecuta: $DEST/lanzar-affinity.sh"
echo "======================================================"
