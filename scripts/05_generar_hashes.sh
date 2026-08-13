#!/usr/bin/env bash
# =============================================================================
# 05_generar_hashes.sh
# Calcula y opcionalmente verifica hashes SHA-256 de la evidencia adquirida.
#
# La ruta base de la evidencia puede sobrescribirse con la variable de
# entorno TALLER_EVIDENCE_DIR (por defecto: /tmp/taller_forense_movil).
#
# Uso:
#   Generar:   ./scripts/05_generar_hashes.sh <ID_CASO>
#   Verificar: ./scripts/05_generar_hashes.sh <ID_CASO> --verificar
# =============================================================================
set -euo pipefail

CASO="${1:-CASO-2026-001}"
MODO="${2:-}"
EVIDENCE_BASE="${TALLER_EVIDENCE_DIR:-/tmp/taller_forense_movil}"
DEST="${EVIDENCE_BASE}/${CASO}"
HASHFILE="$DEST/hashes_adquisicion.sha256"

if command -v sha256sum >/dev/null 2>&1; then
  SHA_CMD="sha256sum"
elif command -v shasum >/dev/null 2>&1; then
  SHA_CMD="shasum -a 256"
else
  echo "[ERROR] No se encontraron sha256sum ni shasum en este sistema."
  echo "En Windows debe usarse certutil -hashfile (ver docs/03-adquisicion-forense.md)."
  exit 1
fi

if [ "$MODO" == "--verificar" ]; then
  echo "=== Verificacion de integridad de la evidencia - Caso: $CASO ==="
  echo "Carpeta de evidencia: $DEST"
  if [ ! -f "$HASHFILE" ]; then
    echo "[ERROR] No existe $HASHFILE. Los hashes deben generarse primero (sin --verificar)."
    exit 1
  fi
  if [ "$SHA_CMD" == "sha256sum" ]; then
    sha256sum -c "$HASHFILE"
  else
    shasum -a 256 -c "$HASHFILE"
  fi
  echo
  echo "Si todas las lineas muestran 'OK', la integridad de la evidencia esta intacta."
else
  echo "=== Generacion de hashes SHA-256 de la evidencia - Caso: $CASO ==="
  echo "Carpeta de evidencia: $DEST"
  echo "Inicio: $(date '+%Y-%m-%d %H:%M:%S %Z')"
  find "$DEST" -type f ! -name "hashes_adquisicion.sha256" -exec $SHA_CMD {} \; > "$HASHFILE"
  echo "-> $HASHFILE generado con $(wc -l < "$HASHFILE") archivos."
  echo "Fin: $(date '+%Y-%m-%d %H:%M:%S %Z')"
  echo
  echo "El contenido de $HASHFILE debe copiarse en la plantilla de cadena de"
  echo "custodia. Para verificar la integridad mas adelante:"
  echo "  ./scripts/05_generar_hashes.sh $CASO --verificar"
fi
