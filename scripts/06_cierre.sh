#!/usr/bin/env bash
# =============================================================================
# 06_cierre.sh
# Cierra la sesion ADB y recuerda los pasos manuales de cierre en el dispositivo.
# Uso: ./scripts/06_cierre.sh <ID_CASO>
# =============================================================================
set -euo pipefail

CASO="${1:-CASO-2026-001}"

echo "=== Cierre del caso: $CASO ==="
echo

echo "Se procede a verificar la integridad final de la evidencia..."
./scripts/05_generar_hashes.sh "$CASO" --verificar || {
  echo "[ADVERTENCIA] La verificacion de integridad fallo o no pudo completarse."
  echo "  Esta discrepancia debe documentarse antes de cerrar el caso."
}

echo
echo "Cerrando el servidor ADB..."
adb kill-server
echo "-> Sesion ADB finalizada: $(date '+%Y-%m-%d %H:%M:%S %Z')"

echo
echo "Pasos manuales pendientes en el dispositivo (pueden variar segun el"
echo "fabricante y la version de Android; ver README.md):"
echo "  1) Ajustes -> Sistema -> Opciones de desarrollador -> Desactivar 'Depuracion USB'."
echo "  2) (Opcional) Desactivar por completo las Opciones de desarrollador."
echo "  3) La hora de estas acciones debe registrarse en el acta de recoleccion."
echo
echo "Con esto queda cerrada la fase tecnica del taller."
echo "El siguiente paso es redactar el informe pericial: plantillas/informe-pericial.md"
