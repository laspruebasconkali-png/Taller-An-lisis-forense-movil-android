# Carpeta de evidencia (marcador de posición)

Esta carpeta **no es el destino real de la evidencia** generada durante el
taller. Se mantiene únicamente como referencia de la estructura esperada por
caso; el contenido real de la práctica debe almacenarse fuera del
repositorio clonado, en una carpeta temporal del sistema, siguiendo la
convención descrita en el [`README.md`](../README.md#ubicación-de-la-evidencia-durante-la-práctica)
de la raíz del repositorio:

| Sistema operativo | Ruta por defecto |
|---|---|
| Linux / macOS | `/tmp/taller_forense_movil/<ID_CASO>/` |
| Windows | `%TEMP%\taller_forense_movil\<ID_CASO>\` |

Esta ruta se usa como buena práctica en lugar de una carpeta bajo el perfil
del usuario (`Escritorio`, `Documentos`, `Descargas`, etc.), ya que dichas
rutas exponen el nombre del usuario o del equipo y su ubicación exacta puede
variar según el sistema operativo, la red o la existencia de unidades
mapeadas. La ruta efectivamente utilizada en cada práctica debe registrarse
en el acta de recolección, no asumirse fija.

**Por diseño, el contenido de esta carpeta del repositorio está excluido del
control de versiones** (ver [`.gitignore`](../.gitignore) en la raíz).
Ninguna evidencia real, dato personal de terceros o información de un caso
real debe subirse a un repositorio de GitHub, público o privado, sin importar
en qué carpeta se coloque.

## Estructura sugerida por caso (aplica también a la carpeta temporal)

```
<ruta_temporal>/taller_forense_movil/
└── CASO-2026-001/
    ├── getprop_<timestamp>.txt
    ├── apps_<timestamp>.txt
    ├── log_<timestamp>.txt
    ├── sdcard_triage_<timestamp>/
    ├── imagen_logica/
    ├── backup_<timestamp>.ab
    └── hashes_adquisicion.sha256
```

Para el ejercicio académico debe usarse siempre un dispositivo de pruebas
propio y, si se requieren datos de ejemplo (contactos, mensajes), deben
utilizarse datos sintéticos o ficticios, nunca información real de terceros.
