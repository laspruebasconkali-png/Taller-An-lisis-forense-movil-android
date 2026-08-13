#!/usr/bin/env bash
# =============================================================================
# 02_verificar_conexion.sh
# Verifica la conexion ADB con el dispositivo evidencia.
# Uso: ./scripts/02_verificar_conexion.sh
# =============================================================================
set -euo pipefail

echo "=== Verificacion de conexion ADB ==="
echo
echo "Condiciones previas requeridas:"
echo "  1) El modo avion debe estar activado en el dispositivo antes de"
echo "     conectar el cable."
echo "  2) La depuracion USB debe estar activada (Opciones de desarrollador)."
echo "  3) Debe aceptarse en el dispositivo el dialogo 'Permitir depuracion USB'."
echo
echo "Nota: los nombres de menu pueden variar segun el fabricante y la"
echo "version de Android del dispositivo (ver README.md)."
echo

adb kill-server
adb start-server

echo
echo "Dispositivos detectados:"
adb devices -l

STATE=$(adb get-state 2>/dev/null || echo "desconectado")
echo
echo "Estado de conexion: $STATE"

if [ "$STATE" != "device" ]; then
  echo
  echo "[ADVERTENCIA] El dispositivo no esta en estado 'device'."
  echo "  - 'unauthorized' -> debe aceptarse el dialogo de autorizacion en el telefono."
  echo "  - 'offline'      -> debe reconectarse el cable USB y repetirse este script."
  echo "  - (vacio)        -> deben revisarse los drivers y la instalacion de ADB."
  exit 1
fi

echo
echo "Conexion exitosa. Debe registrarse en el acta de recoleccion:"
echo "  - Hora exacta de esta verificacion: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "  - Serial del dispositivo (columna izquierda arriba)"
echo
echo "El siguiente paso es ejecutar: ./scripts/03_adquisicion_info.sh"
