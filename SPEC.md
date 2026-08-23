# Aura 360 OS â€” EspecificaciÃ³n (SPEC v0.2)

Distro Linux **inmutable** para creativos (diseÃ±o, video, audio, cÃ³digo),
construida con **BlueBuild** sobre **Bazzite DX (NVIDIA)**.

## Base (heredada de `bazzite-dx-nvidia:stable`)
- Kernel OGC (gaming/fsync) + drivers NVIDIA + HDR/VRR + codecs HW
- OBS Studio (VkCapture), Distrobox
- Dev stack: VS Code, Docker CE, QEMU/KVM, ROCm, perf tools (zsh, restic, rclone, bpftrace, sysprof)

## Capas Aura 360 (mÃ³dulos BlueBuild, verificado contra fuentes primarias)
| MÃ³dulo | AcciÃ³n |
|---|---|
| `files` | despliega `files/system/*` (lÃ­mites realtime + sysusers) al root `/` |
| `systemd` | habilita `aura-performance.service` (governor `performance`) |
| `dnf` | instala `kernel-tools` (cpupower) |
| `default-flatpaks` | suite creativa a nivel `system`: Krita, GIMP, Inkscape, Blender, Kdenlive, Ardour, Audacity, Darktable, RawTherapee, Scribus |

## EspecificaciÃ³n heredada de Ubuntu Studio (referencia)
- **GrÃ¡ficos**: GIMP, Inkscape, Krita, Blender, Scribus
- **FotografÃ­a**: Darktable, RawTherapee
- **Video**: Kdenlive, OBS (base), DaVinci Resolve (vÃ­a `ujust install-resolve` / davincibox)
- **Audio**: Ardour, Audacity (+ Qtractor, Hydrogen, Carla, QjackCtl opcionales vÃ­a caracal)

## Fuentes verificadas (fuente primaria)
- Formato `recipe.yml` + mÃ³dulos: `blue-build/template` (`recipes/recipe.yml`) y `blue-build/modules` (READMEs de `files`, `systemd`)
- Schema: `https://schema.blue-build.org/recipe-v1.json` Â· `module-list-v1.json`
- Base DX (contenido del stack): `ublue-os/bazzite-dx` (`build_files/20-install-apps.sh`)
- PatrÃ³n audio: `caracal-dev/caracal` (kernel OGC, rtprio 95, governor performance)
- Resolve en contenedor: `zelikos/davincibox`

## ConstrucciÃ³n e instalaciÃ³n
1. Push del repo â†’ GitHub Actions compila y publica en ghcr.io.
2. `rpm-ostree rebase ostree-unverified-registry:ghcr.io/<tu-usuario>/aura360-os:latest`
3. Reiniciar; los Flatpaks se instalan automÃ¡ticamente (default-flatpaks).

## Variantes
- `aura360-os` (NVIDIA): base `ghcr.io/ublue-os/bazzite-dx-nvidia:stable`
- `aura360-os-open` (AMD/Intel): base `ghcr.io/ublue-os/bazzite-dx:stable`

## Pendiente (prÃ³ximas iteraciones)
- Firma cosign (`signing` module + `SIGNING_SECRET`)
- Variante GNOME
- `ujust` propio (helper de setup) y validaciÃ³n de Flatpak IDs en el primer build real
