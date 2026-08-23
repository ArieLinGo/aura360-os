# Aura 360 OS

Distro Linux **inmutable** para creativos: diseÃ±o grÃ¡fico, video, audio y cÃ³digo.
Construida con **BlueBuild** sobre **Bazzite DX (NVIDIA)**. Hereda su kernel de gaming,
drivers, cÃ³decs y stack de desarrollo, y aÃ±ade la capa de audio profesional
(patrÃ³n de caracal) + suite creativa (especificaciÃ³n de Ubuntu Studio).

> Estado: **v0.2 â€” scaffold BlueBuild listo.** La imagen se compila automÃ¡ticamente
> con GitHub Actions al hacer push de este repo y se publica en
> `ghcr.io/<tu-usuario>/aura360-os`.

## QuÃ© hereda de la base (`bazzite-dx-nvidia:stable`)
- Kernel OGC (gaming/fsync) + drivers NVIDIA + HDR/VRR + codecs HW
- OBS Studio con VkCapture
- Distrobox preinstalado
- VS Code, Docker CE, QEMU/KVM, ROCm, perf tools (stack Bazzite DX)

## QuÃ© aÃ±ade Aura 360 OS
| Capa | Contenido | MÃ³dulo BlueBuild |
|---|---|---|
| Audio pro | grupos `@audio`/`@realtime` (rtprio 95) + governor CPU `performance` | `files` + `systemd` + `dnf` |
| Creativo | Krita, GIMP, Inkscape, Blender, Kdenlive, Ardour, Audacity, Darktable, RawTherapee, Scribus | `default-flatpaks` |

DaVinci Resolve y Affinity se instalan con los helpers `ujust` de Bazzite
(`install-resolve` / `setup-affinity`).

## Estructura
```
recipes/recipe.yml                      # receta BlueBuild (fuente de verdad)
files/system/etc/security/limits.d/     # lÃ­mites realtime
files/system/usr/lib/sysusers.d/        # grupo "realtime"
files/systemd/system/                   # aura-performance.service
.github/workflows/build.yml             # CI (blue-build/github-action)
```

## CÃ³mo construir
1. Crea un repo en GitHub y sube esta carpeta.
2. GitHub Actions compila y publica `ghcr.io/<tu-usuario>/aura360-os:latest`.

## CÃ³mo instalar (rebase)
```bash
# Variante NVIDIA (base bazzite-dx-nvidia)
rpm-ostree rebase ostree-unverified-registry:ghcr.io/<tu-usuario>/aura360-os:latest
# Variante AMD/Intel (base bazzite-dx, sin drivers NVIDIA)
rpm-ostree rebase ostree-unverified-registry:ghcr.io/<tu-usuario>/aura360-os-open:latest
systemctl reboot
```

> La imagen es **sin firmar** en v0.2 (firma cosign opcional; ver `signing` module).

## CrÃ©ditos y bases
- Bazzite / Bazzite DX â€” https://github.com/ublue-os/bazzite Â· https://github.com/ublue-os/bazzite-dx
- caracal (patrÃ³n de audio) â€” https://github.com/caracal-dev/caracal
- BlueBuild template â€” https://github.com/blue-build/template

Licencia: Apache-2.0
