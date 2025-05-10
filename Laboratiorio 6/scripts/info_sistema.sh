#!/bin/bash
echo "=== Información del Sistema ==="
echo "Usuario: $USER"
echo "Hostname: $(hostname)"
echo "Fecha: $(date)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo "=== Espacio en disco ==="
df -h | grep "/dev/"
