# Aura 360 OS — Compatibilidad con programas de Windows y Adobe

Aura 360 OS incluye una estrategia de compatibilidad **en capas**, diseñada para
que ninguna capa pueda romper el sistema: todas corren aisladas del sistema base.

## 1. Bottles (preinstalado) — Windows con Wine aislado por contenedor
- Cada aplicación vive en su propio **bottle** (entorno Wine independiente):
  si uno se rompe, no afecta a los demás ni al sistema.
- Uso: abrir **Bottles** → "Create a new bottle" → perfil *Application* →
  instalar el `.exe` dentro.
- Ideal para: **Photoshop** (versiones 2021–2024 con tweaks de la comunidad),
  utilidades de Windows y aplicaciones de diseño antiguas.

## 2. Affinity (Photo / Designer / Publisher)
- Helper de Bazzite ya incluido: `ujust setup-affinity` (Wine preconfigurado).

## 3. CrossOver (opcional, comercial) — Wine pulido con soporte
- La opción más pulida para Photoshop, Affinity y Office.
- De pago, con soporte oficial de CodeWeavers: https://www.codeweavers.com/crossover

## 4. Máquina virtual con GPU passthrough — la solución definitiva para TODO Adobe
- El sistema ya trae **QEMU/KVM + virt-manager** (heredados de Bazzite DX, que
  incluye soporte de virtualización/VFIO).
- Ejecuta **Windows 10/11 completo en una VM** con tu GPU dedicada:
  **Premiere, After Effects e Illustrator funcionan al 100%**.
- La VM es desechable: si Windows se rompe, Linux ni se entera.

## 5. Juegos de Windows
- **Proton** viene heredado de Bazzite (Steam). Funciona de fábrica.

## Qué NO intentar con Wine
- **Premiere y After Effects no funcionan por Wine.** Para esos, usa la VM (sección 4).

## Por qué nada de esto rompe el sistema
- **Bottles y Flatpaks** corren en sandbox: no tocan el sistema base.
- **La VM** es un archivo de disco: aislada por diseño.
- **El sistema es inmutable con rollback**: cualquier problema se revierte con
  `rpm-ostree rollback` en un reinicio.
