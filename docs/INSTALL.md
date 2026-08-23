# Aura 360 OS — Instalación y primer arranque

## Requisito previo
Tener **Bazzite** (o cualquier **Fedora Atomic**) instalado. Aura 360 OS es una
imagen inmutable que se aplica por *rebase* encima de esa base.

## 1. Rebase a Aura 360 OS

```bash
# Variante NVIDIA (recomendada para DaVinci Resolve)
rpm-ostree rebase ostree-unverified-registry:ghcr.io/arielingo/aura360-os:latest

# Variante AMD/Intel (sin drivers NVIDIA)
rpm-ostree rebase ostree-unverified-registry:ghcr.io/arielingo/aura360-os-open:latest

systemctl reboot
```

> La imagen va **sin firmar** en v0.2, por eso se usa `ostree-unverified-registry:`.

## 2. Qué pasa en el primer arranque (automático)
- Los **Flatpaks creativos** se instalan solos (módulo `default-flatpaks`):
  Krita, GIMP, Inkscape, Blender, Kdenlive, Ardour, Audacity, Darktable,
  RawTherapee, Scribus.
- La capa de **audio pro** ya está activa: grupos `@audio`/`@realtime`
  (rtprio 95), governor CPU `performance`, y el servicio `aura-performance.service`.

## 3. Verificaciones post-instalación

```bash
# 1) Ver los helpers disponibles (Resolve, Affinity, etc.)
ujust --list

# 2) Verificar límites realtime (debe devolver "rtprio 95" y "unlimited")
ulimit -r -l

# 3) Verificar que el governor está en performance
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```

## 4. DaVinci Resolve y Affinity (helpers de Bazzite)

```bash
# DaVinci Resolve (binario oficial en contenedor davincibox)
ujust install-resolve        # o: ujust install-davinci

# Affinity vía Wine
ujust setup-affinity
```

> Si el nombre exacto de un helper cambia, `ujust --list` te lo muestra.
> Referencia del contenedor: https://github.com/zelikos/davincibox

## 5. Actualizaciones
Aura 360 OS se actualiza **solo** (modelo atómico de Bazzite, heredado). Cada
actualización es reversible: `rpm-ostree rollback` te devuelve a la versión
anterior en un reinicio.
