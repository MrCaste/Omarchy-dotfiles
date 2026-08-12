#!/bin/bash
# Muestra en waybar la IP activa del dispositivo.
# Si hay una interfaz VPN (tun*/wg*) levantada, muestra esa IP.
# Si no, muestra la IP de la interfaz que usas para salir a internet.

vpn_iface=$(ip -o -4 addr show | awk '{print $2}' | grep -E '^(tun|wg|ht-tun)' | head -n1)

if [ -n "$vpn_iface" ]; then
    ip_addr=$(ip -4 addr show "$vpn_iface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    icon="󰖂 "
    text="${icon} ${ip_addr}"
    tooltip="VPN activa (${vpn_iface})\nIP: ${ip_addr}"
    class="vpn"
else
    main_iface=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $5; exit}')
    ip_addr=$(ip -4 addr show "$main_iface" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    icon="󰈀 "
    text="${icon} ${ip_addr:-sin conexión}"
    tooltip="Interfaz: ${main_iface:-ninguna}"
    class="local"
fi

# Escapamos comillas por si acaso y devolvemos JSON para waybar
printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' "$text" "$tooltip" "$class"
