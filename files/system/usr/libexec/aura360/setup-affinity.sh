#!/bin/bash
# Aura 360 OS - instala Affinity (paquete MSIX de Windows) con Wine en el
# espacio del usuario. Usa el runner Wine Soda (bottlesdevs/wine) + Wine Mono
# (runtime .NET Framework) + DXVK/VKD3D para aceleracion DirectX.
#
# Requisito: tener el instalador "Affinity x64.msix" en ~/Descargas o ~/Downloads.
set -e

WINE_VERSION="soda-11.0-5"
WINE_URL="https://github.com/bottlesdevs/wine/releases/download/${WINE_VERSION}/${WINE_VERSION}-x86_64.tar.xz"
MONO_VERSION="11.3.0"
MONO_URL="https://dl.winehq.org/wine/wine-mono/${MONO_VERSION}/wine-mono-${MONO_VERSION}-x86.msi"
DXVK_VERSION="3.0.2"
DXVK_URL="https://github.com/doitsujin/dxvk/releases/download/v${DXVK_VERSION}/dxvk-${DXVK_VERSION}.tar.gz"
VKD3D_VERSION="3.0.1"
VKD3D_URL="https://github.com/HansKristian-Work/vkd3d-proton/releases/download/v${VKD3D_VERSION}/vkd3d-proton-${VKD3D_VERSION}.tar.zst"

WINE_DIR="$HOME/wine-${WINE_VERSION}"
WINEPREFIX="$HOME/.wine-affinity"
APP_DIR="$HOME/Affinity-x64"
CACHE="$HOME/.cache/aura360"
BIN_DIR="$HOME/bin"

echo "==> Buscando el instalador MSIX de Affinity..."
MSIX=""
for d in "$HOME/Descargas" "$HOME/Downloads"; do
    MSIX=$(ls "$d"/Affinity*.msix 2>/dev/null | head -1)
    [ -n "$MSIX" ] && break
done
if [ -z "$MSIX" ]; then
    echo "ERROR: no se encontro 'Affinity*.msix' en ~/Descargas o ~/Downloads."
    exit 1
fi
echo "    MSIX encontrado: $MSIX"

mkdir -p "$CACHE" "$BIN_DIR"

if [ ! -x "$WINE_DIR/bin/wine" ]; then
    echo "==> Descargando Wine Soda ${WINE_VERSION} (~154 MB)..."
    curl -L --fail --retry 3 -o "$CACHE/wine.tar.xz" "$WINE_URL"
    mkdir -p "$WINE_DIR"
    tar xf "$CACHE/wine.tar.xz" -C "$WINE_DIR" --strip-components=1
fi

if [ ! -f "$CACHE/wine-mono.msi" ]; then
    echo "==> Descargando Wine Mono ${MONO_VERSION} (runtime .NET)..."
    curl -L --fail --retry 3 -o "$CACHE/wine-mono.msi" "$MONO_URL"
fi

if [ ! -d "$CACHE/dxvk-${DXVK_VERSION}" ]; then
    echo "==> Descargando DXVK ${DXVK_VERSION}..."
    curl -L --fail --retry 3 -o "$CACHE/dxvk.tar.gz" "$DXVK_URL"
    tar xzf "$CACHE/dxvk.tar.gz" -C "$CACHE"
fi
if [ ! -d "$CACHE/vkd3d-proton-${VKD3D_VERSION}" ]; then
    echo "==> Descargando VKD3D-Proton ${VKD3D_VERSION}..."
    curl -L --fail --retry 3 -o "$CACHE/vkd3d.tar.zst" "$VKD3D_URL"
    tar --zstd -xf "$CACHE/vkd3d.tar.zst" -C "$CACHE"
fi

export WINEPREFIX="$WINEPREFIX"

if [ ! -f "$WINEPREFIX/system.reg" ]; then
    echo "==> Creando el prefijo de Wine..."
    WINEDLLOVERRIDES="mscoree=d;mshtml=d" "$WINE_DIR/bin/wineboot" -i >/dev/null 2>&1 || true
    "$WINE_DIR/bin/wineserver" -w 2>/dev/null || true
fi

if [ ! -d "$WINEPREFIX/drive_c/windows/mono/mono-2.0" ]; then
    echo "==> Instalando Wine Mono..."
    WINEDLLOVERRIDES="mscoree=d;mshtml=d" "$WINE_DIR/bin/wine" msiexec /i "$CACHE/wine-mono.msi" /qn >/dev/null 2>&1 || true
    "$WINE_DIR/bin/wineserver" -w 2>/dev/null || true
fi

echo "==> Instalando DXVK + VKD3D (aceleracion DirectX)..."
cp "$CACHE"/dxvk-${DXVK_VERSION}/x64/*.dll "$WINEPREFIX/drive_c/windows/system32/"
cp "$CACHE"/dxvk-${DXVK_VERSION}/x32/*.dll "$WINEPREFIX/drive_c/windows/syswow64/"
cp "$CACHE"/vkd3d-proton-${VKD3D_VERSION}/x64/*.dll "$WINEPREFIX/drive_c/windows/system32/"

if [ ! -f "$APP_DIR/AppxManifest.xml" ]; then
    echo "==> Extrayendo el MSIX a ~/Affinity-x64 (puede tardar)..."
    mkdir -p "$APP_DIR"
    unzip -q -o "$MSIX" -d "$APP_DIR"
fi

cat > "$BIN_DIR/affinity" << EOF
#!/bin/bash
export WINEPREFIX="$WINEPREFIX"
export WINEDLLOVERRIDES="mscoree=b;mshtml=d;d3d12=n,b;d3d11=n,b;dxgi=n,b"
exec "$WINE_DIR/bin/wine" "$APP_DIR/App/Affinity.exe" "\$@"
EOF
chmod +x "$BIN_DIR/affinity"

mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/affinity.desktop" << EOF
[Desktop Entry]
Name=Affinity
Comment=Affinity suite (Windows, via Wine)
Exec=$BIN_DIR/affinity
Type=Application
Categories=Graphics;2DGraphics;Photography;
Icon=affinity
Terminal=false
EOF

echo ""
echo "======================================================"
echo "  Affinity instalado. Para iniciarlo:"
echo "    $BIN_DIR/affinity"
echo "  (o buscalo como 'Affinity' en el menu de aplicaciones)"
echo "======================================================"
