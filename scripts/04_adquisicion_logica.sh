#!/usr/bin/env bash
# =============================================================================
# 04_adquisicion_logica.sh
# Realiza la adquisicion logica formal del almacenamiento accesible.
#
# La evidencia se guarda en una carpeta temporal del sistema; la ruta base
# puede sobrescribirse con la variable de entorno TALLER_EVIDENCE_DIR.
#
# Uso: ./scripts/04_adquisicion_logica.sh <ID_CASO>
# =============================================================================
set -euo pipefail

CASO="${1:-CASO-2026-001}"
EVIDENCE_BASE="${TALLER_EVIDENCE_DIR:-/tmp/taller_forense_movil}"
DEST="${EVIDENCE_BASE}/${CASO}/imagen_logica"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')

mkdir -p "$DEST"

echo "=== Adquisicion forense logica - Caso: $CASO ==="
echo "Carpeta de evidencia: $DEST"
echo "Inicio: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo

echo "Copiando /sdcard/ a $DEST ..."
adb pull /sdcard/ "$DEST/"

echo
echo "A continuacion se intenta 'adb backup' (puede no producir datos en"
echo "Android 12+ o si las apps declaran android:allowBackup=false; esto"
echo "constituye un hallazgo metodologico valido, no un error del examinador)."
adb backup -apk -shared -all -f "${EVIDENCE_BASE}/${CASO}/backup_${TIMESTAMP}.ab" || \
  echo "  -> adb backup no disponible o cancelado en el dispositivo."

echo
echo "Fin: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "El siguiente paso obligatorio es calcular los hashes de integridad:"
echo "  ./scripts/05_generar_hashes.sh $CASO"
