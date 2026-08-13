#!/usr/bin/env bash
# =============================================================================
# 03_adquisicion_info.sh
# Adquisicion de informacion (triage): propiedades del sistema, apps, logs
# y copia preliminar de almacenamiento.
#
# La evidencia se guarda en una carpeta temporal del sistema (no en el
# perfil del usuario ni en este repositorio); la ruta base puede
# sobrescribirse con la variable de entorno TALLER_EVIDENCE_DIR.
#
# Uso: ./scripts/03_adquisicion_info.sh <ID_CASO>
#   Ejemplo: ./scripts/03_adquisicion_info.sh CASO-2026-001
# =============================================================================
set -euo pipefail

CASO="${1:-CASO-2026-001}"
EVIDENCE_BASE="${TALLER_EVIDENCE_DIR:-/tmp/taller_forense_movil}"
DEST="${EVIDENCE_BASE}/${CASO}"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')

mkdir -p "$DEST"

echo "=== Adquisicion de informacion (triage) - Caso: $CASO ==="
echo "Carpeta de evidencia: $DEST"
echo "Inicio: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo

echo "[1/4] Propiedades del sistema (getprop)..."
adb shell getprop > "$DEST/getprop_${TIMESTAMP}.txt"
echo "      -> $DEST/getprop_${TIMESTAMP}.txt"

echo "[2/4] Listado de aplicaciones instaladas..."
adb shell pm list packages -f > "$DEST/apps_${TIMESTAMP}.txt"
echo "      -> $DEST/apps_${TIMESTAMP}.txt"

echo "[3/4] Logs del sistema (logcat -d)..."
adb logcat -d > "$DEST/log_${TIMESTAMP}.txt"
echo "      -> $DEST/log_${TIMESTAMP}.txt"

echo "[4/4] Copia preliminar de /sdcard/ (puede tardar)..."
mkdir -p "$DEST/sdcard_triage_${TIMESTAMP}"
adb pull /sdcard/ "$DEST/sdcard_triage_${TIMESTAMP}/"

echo
echo "Fin: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "La hora de inicio/fin y los archivos generados deben registrarse en el"
echo "acta de recoleccion, incluyendo la ruta efectiva usada ($DEST)."
echo
echo "El siguiente paso es ejecutar: ./scripts/04_adquisicion_logica.sh $CASO"
