#!/bin/bash

vpn_iface=$(ip -o -4 addr show | awk '{print $2}' | grep -E '^(tun|wg|ht-tun)' | head -n1)

if [ -n "$vpn_iface" ]; then
    ip_addr=$(ip -4 addr show "$vpn_iface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    echo "󰈀  $ip_addr"
else
    main_iface=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $5; exit}')
    ip_addr=$(ip -4 addr show "$main_iface" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    echo "󰈀  ${ip_addr:-sin conexión}"
fi
