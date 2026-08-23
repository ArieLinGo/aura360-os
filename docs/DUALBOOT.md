# Aura 360 OS â€” Dual boot con Windows

GuÃ­a para mantener **Windows + Aura 360 OS** en el mismo equipo. Basada en la
[guÃ­a oficial de dual-boot de Bazzite](https://docs.bazzite.gg/General/Installation_Guide/dual_boot_setup_guide/).

## Vista general
1. Preparar Windows (BitLocker, Fast Startup, encoger particiÃ³n)
2. Instalar **Bazzite** en el espacio libre (su instalador maneja el dual-boot)
3. Rebase a **Aura 360 OS**

## Paso 1 â€” Preparar Windows

### 1a. Suspender/desactivar BitLocker
BitLocker cifra el disco y **impide redimensionar la particiÃ³n** de forma segura.
- Windows: **ConfiguraciÃ³n â†’ Privacidad y seguridad â†’ Cifrado de dispositivo**
  â†’ desactivar, o desde `Panel de control â†’ Cifrado de unidad BitLocker`
  â†’ **Suspender la protecciÃ³n**.
- Espera a que termine de descifrar si lo desactivas del todo.

### 1b. Desactivar "Inicio rÃ¡pido" (Fast Startup)
El inicio rÃ¡pido deja NTFS en hibernaciÃ³n y puede ocultar la particiÃ³n de Windows
al gestor de arranque de Linux.
- **Panel de control â†’ Opciones de energÃ­a â†’ Elegir el comportamiento de los
  botones â†’ Cambiar la configuraciÃ³n no disponible â†’ desmarcar "Activar inicio rÃ¡pido"**.

### 1c. Encoger la particiÃ³n de Windows
- **AdministraciÃ³n de discos** (Win+R â†’ `diskmgmt.msc`) â†’ clic derecho en `C:` â†’
  **Reducir volumen** â†’ deja libre al menos **100â€“150 GB** para Linux
  (mÃ¡s si vas a editar video: recomiendo 200 GB+).

### 1d. (Opcional) Desactivar Secure Boot
Bazzite/Aura 360 OS **soportan Secure Boot**, asÃ­ que normalmente NO hace falta
desactivarlo. Si el instalador no arranca, desactÃ­valo en la BIOS/UEFI.

## Paso 2 â€” Instalar Bazzite en dual-boot

1. Descarga la ISO de Bazzite: https://download.bazzite.gg
2. GrÃ¡bala en un USB (con **Rufus** o **Balena Etcher**).
3. Arranca desde el USB (F12/F2/Esc segÃºn tu placa) y elige **arrancar el USB (UEFI)**.
4. En el instalador, elige **instalaciÃ³n manual / particionado avanzado**:
   - Selecciona el **espacio libre** que dejaste.
   - Crea ahÃ­ la instalaciÃ³n (el instalador monta `/`, `/boot/efi` compartida con Windows, etc.).
   - El gestor de arranque detectarÃ¡ Windows automÃ¡ticamente.
5. Completa la instalaciÃ³n y reinicia.

> âš ï¸ **Haz copia de seguridad de Windows antes.** Un error de particionado puede
> borrar datos. Si puedes, usa un disco separado para Linux (aÃºn mÃ¡s seguro).

## Paso 3 â€” Rebase a Aura 360 OS

En Bazzite ya instalado:

```bash
# Variante NVIDIA
rpm-ostree rebase ostree-unverified-registry:ghcr.io/arielingo/aura360-os:latest
# Variante AMD/Intel
rpm-ostree rebase ostree-unverified-registry:ghcr.io/arielingo/aura360-os-open:latest
systemctl reboot
```

## Paso 4 â€” Elegir sistema al arrancar
Al encender, el gestor de arranque (systemd-boot o GRUB de Bazzite) muestra un
menÃº con **Bazzite/Aura 360 OS** y **Windows Boot Manager**. Elige el que quieras.

## Notas importantes
- **No cambies entre variantes KDE/GNOME por rebase** (rompe la instalaciÃ³n).
- Si Windows no aparece en el menÃº: `sudo bootctl status` o reinstala el gestor
  de arranque (o `os-prober` si usas GRUB).
- Los archivos entre sistemas: Windows no lee ext4/btrfs por defecto; Linux sÃ­
  puede leer NTFS (con `ntfs3`), pero para compartir archivos entre ambos usa una
  particiÃ³n **exFAT** o **NTFS** dedicada.
