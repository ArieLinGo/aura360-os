# Aura 360 OS — convenience recipes

# Apply the macOS-style LIGHT theme (WhiteSur)
aura360-theme-light:
    #!/usr/bin/bash
    plasma-apply-lookandfeel --apply com.github.vinceliuice.WhiteSur

# Apply the macOS-style DARK theme (WhiteSur-dark)
aura360-theme-dark:
    #!/usr/bin/bash
    plasma-apply-lookandfeel --apply com.github.vinceliuice.WhiteSur-dark

# Install Affinity (MSIX from ~/Descargas) with Wine in user space
aura360-setup-affinity:
    #!/usr/bin/bash
    /usr/libexec/aura360/setup-affinity.sh

# Verify pro-audio setup (groups + realtime limits)
aura360-check-audio:
    #!/usr/bin/bash
    echo "Grupos: $(id -nG)"
    echo "Limites realtime: rtprio=$(ulimit -r) memlock=$(ulimit -l)"
    echo "Governor: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
