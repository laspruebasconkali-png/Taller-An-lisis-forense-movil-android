#!/usr/bin/env bash
# =============================================================================
# 01_setup_entorno.sh
# Verifica que las herramientas necesarias para el taller esten instaladas.
#
# Convencion de rutas: la evidencia se almacena en una carpeta temporal del
# sistema (no en el perfil del usuario ni dentro de este repositorio), ya
# que esa ruta puede variar segun el sistema operativo o la red utilizada.
# Puede sobrescribirse con la variable de entorno TALLER_EVIDENCE_DIR.
#
# Uso: ./scripts/01_setup_entorno.sh
# =============================================================================
set -euo pipefail

EVIDENCE_BASE="${TALLER_EVIDENCE_DIR:-/tmp/taller_forense_movil}"

echo "=== Taller Forense Movil - Verificacion de entorno ==="
echo

check_tool () {
  local tool="$1"
  local hint="$2"
  if command -v "$tool" >/dev/null 2>&1; then
    echo "[OK]   $tool encontrado: $($tool --version 2>&1 | head -n1 || true)"
  else
    echo "[FALTA] $tool no encontrado. $hint"
  fi
}

check_tool adb        "Debe instalarse Android Platform Tools: https://developer.android.com/tools/releases/platform-tools"
check_tool sha256sum  "En macOS se usa 'shasum -a 256'; en Windows se usa 'certutil -hashfile'."
check_tool sqlite3    "Debe instalarse sqlite3 (paquete 'sqlite3' en apt/brew) para analizar bases de datos."
check_tool exiftool   "Debe instalarse ExifTool: https://exiftool.org/"

echo
echo "Version de ADB detectada:"
adb version || echo "  -> ADB no disponible en el PATH"

echo
echo "Nota: los nombres de comando y su version pueden variar segun el"
echo "sistema operativo y la version instalada de cada herramienta; la"
echo "version exacta debe registrarse en el informe pericial."

echo
echo "Carpeta de evidencia configurada: $EVIDENCE_BASE"
echo "(No corresponde a una carpeta del perfil de usuario; su ruta exacta"
echo " puede variar segun el sistema operativo o la red del laboratorio y"
echo " debe quedar registrada en el acta de recoleccion.)"
mkdir -p "$EVIDENCE_BASE/CASO-2026-001"
echo "  -> $EVIDENCE_BASE/CASO-2026-001/ lista"

echo
echo "El siguiente paso es ejecutar: ./scripts/02_verificar_conexion.sh"
