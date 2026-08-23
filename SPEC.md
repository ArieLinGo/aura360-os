# Aura 360 OS — Especificación (SPEC v0.2)

Distro Linux **inmutable** para creativos (diseño, video, audio, código),
construida con **BlueBuild** sobre **Bazzite DX (NVIDIA)**.

## Base (heredada de `bazzite-dx-nvidia:stable`)
- Kernel OGC (gaming/fsync) + drivers NVIDIA + HDR/VRR + codecs HW
- OBS Studio (VkCapture), Distrobox
- Dev stack: VS Code, Docker CE, QEMU/KVM, ROCm, perf tools (zsh, restic, rclone, bpftrace, sysprof)

## Capas Aura 360 (módulos BlueBuild, verificado contra fuentes primarias)
| Módulo | Acción |
|---|---|
| `files` | despliega `files/system/*` (límites realtime + sysusers) al root `/` |
| `systemd` | habilita `aura-performance.service` (governor `performance`) |
| `dnf` | instala `kernel-tools` (cpupower) |
| `default-flatpaks` | suite creativa a nivel `system`: Krita, GIMP, Inkscape, Blender, Kdenlive, Ardour, Audacity, Darktable, RawTherapee, Scribus |

## Especificación heredada de Ubuntu Studio (referencia)
- **Gráficos**: GIMP, Inkscape, Krita, Blender, Scribus
- **Fotografía**: Darktable, RawTherapee
- **Video**: Kdenlive, OBS (base), DaVinci Resolve (vía `ujust install-resolve` / davincibox)
- **Audio**: Ardour, Audacity (+ Qtractor, Hydrogen, Carla, QjackCtl opcionales vía caracal)

## Fuentes verificadas (fuente primaria)
- Formato `recipe.yml` + módulos: `blue-build/template` (`recipes/recipe.yml`) y `blue-build/modules` (READMEs de `files`, `systemd`)
- Schema: `https://schema.blue-build.org/recipe-v1.json` · `module-list-v1.json`
- Base DX (contenido del stack): `ublue-os/bazzite-dx` (`build_files/20-install-apps.sh`)
- Patrón audio: `caracal-dev/caracal` (kernel OGC, rtprio 95, governor performance)
- Resolve en contenedor: `zelikos/davincibox`

## Construcción e instalación
1. Push del repo → GitHub Actions compila y publica en ghcr.io.
2. `rpm-ostree rebase ostree-unverified-registry:ghcr.io/<tu-usuario>/aura360-os:latest`
3. Reiniciar; los Flatpaks se instalan automáticamente (default-flatpaks).

## Variantes
- `aura360-os` (NVIDIA): base `ghcr.io/ublue-os/bazzite-dx-nvidia:stable`
- `aura360-os-open` (AMD/Intel): base `ghcr.io/ublue-os/bazzite-dx:stable`

## Pendiente (próximas iteraciones)
- Firma cosign (`signing` module + `SIGNING_SECRET`)
- Variante GNOME
- `ujust` propio (helper de setup) y validación de Flatpak IDs en el primer build real
