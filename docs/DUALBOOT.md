# Aura 360 OS — Dual boot con Windows

Guía para mantener **Windows + Aura 360 OS** en el mismo equipo. Basada en la
[guía oficial de dual-boot de Bazzite](https://docs.bazzite.gg/General/Installation_Guide/dual_boot_setup_guide/).

## Vista general
1. Preparar Windows (BitLocker, Fast Startup, encoger partición)
2. Instalar **Bazzite** en el espacio libre (su instalador maneja el dual-boot)
3. Rebase a **Aura 360 OS**

## Paso 1 — Preparar Windows

### 1a. Suspender/desactivar BitLocker
BitLocker cifra el disco y **impide redimensionar la partición** de forma segura.
- Windows: **Configuración → Privacidad y seguridad → Cifrado de dispositivo**
  → desactivar, o desde `Panel de control → Cifrado de unidad BitLocker`
  → **Suspender la protección**.
- Espera a que termine de descifrar si lo desactivas del todo.

### 1b. Desactivar "Inicio rápido" (Fast Startup)
El inicio rápido deja NTFS en hibernación y puede ocultar la partición de Windows
al gestor de arranque de Linux.
- **Panel de control → Opciones de energía → Elegir el comportamiento de los
  botones → Cambiar la configuración no disponible → desmarcar "Activar inicio rápido"**.

### 1c. Encoger la partición de Windows
- **Administración de discos** (Win+R → `diskmgmt.msc`) → clic derecho en `C:` →
  **Reducir volumen** → deja libre al menos **100–150 GB** para Linux
  (más si vas a editar video: recomiendo 200 GB+).

### 1d. (Opcional) Desactivar Secure Boot
Bazzite/Aura 360 OS **soportan Secure Boot**, así que normalmente NO hace falta
desactivarlo. Si el instalador no arranca, desactívalo en la BIOS/UEFI.

## Paso 2 — Instalar Bazzite en dual-boot

1. Descarga la ISO de Bazzite: https://download.bazzite.gg
2. Grábala en un USB (con **Rufus** o **Balena Etcher**).
3. Arranca desde el USB (F12/F2/Esc según tu placa) y elige **arrancar el USB (UEFI)**.
4. En el instalador, elige **instalación manual / particionado avanzado**:
   - Selecciona el **espacio libre** que dejaste.
   - Crea ahí la instalación (el instalador monta `/`, `/boot/efi` compartida con Windows, etc.).
   - El gestor de arranque detectará Windows automáticamente.
5. Completa la instalación y reinicia.

> ⚠️ **Haz copia de seguridad de Windows antes.** Un error de particionado puede
> borrar datos. Si puedes, usa un disco separado para Linux (aún más seguro).

## Paso 3 — Rebase a Aura 360 OS

En Bazzite ya instalado:

```bash
# Variante NVIDIA
rpm-ostree rebase ostree-unverified-registry:ghcr.io/arielingo/aura360-os:latest
# Variante AMD/Intel
rpm-ostree rebase ostree-unverified-registry:ghcr.io/arielingo/aura360-os-open:latest
systemctl reboot
```

## Paso 4 — Elegir sistema al arrancar
Al encender, el gestor de arranque (systemd-boot o GRUB de Bazzite) muestra un
menú con **Bazzite/Aura 360 OS** y **Windows Boot Manager**. Elige el que quieras.

## Notas importantes
- **No cambies entre variantes KDE/GNOME por rebase** (rompe la instalación).
- Si Windows no aparece en el menú: `sudo bootctl status` o reinstala el gestor
  de arranque (o `os-prober` si usas GRUB).
- Los archivos entre sistemas: Windows no lee ext4/btrfs por defecto; Linux sí
  puede leer NTFS (con `ntfs3`), pero para compartir archivos entre ambos usa una
  partición **exFAT** o **NTFS** dedicada.
