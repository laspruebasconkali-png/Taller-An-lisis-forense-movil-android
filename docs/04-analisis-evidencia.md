# 04. Análisis de la evidencia extraída

> ⚠️ **Nota de compatibilidad:** la estructura interna de las bases de datos
> de cada app (por ejemplo, `msgstore.db` de WhatsApp) cambia entre versiones
> de la aplicación y puede estar cifrada; los campos EXIF disponibles también
> varían según el modelo del dispositivo y la app de cámara utilizada. Los
> nombres de tabla y consultas SQL de este módulo son ilustrativos y deben
> validarse contra el esquema real de la base de datos analizada.

**Objetivo:** analizar los datos adquiridos en el módulo anterior para
identificar artefactos forenses relevantes: comunicaciones, ubicaciones,
multimedia y actividad del sistema. **A partir de aquí se trabaja siempre
sobre la copia de evidencia, nunca sobre el dispositivo original.**

## 4.1 Panorama de artefactos comunes en Android

| Artefacto | Ubicación típica (referencial) | Formato |
|---|---|---|
| Contactos, llamadas, SMS | `/data/data/com.android.providers.contacts/databases/contacts2.db` | SQLite |
| WhatsApp (mensajes) | `/data/data/com.whatsapp/databases/msgstore.db` | SQLite (cifrado en versiones recientes) |
| Fotos/videos | `/sdcard/DCIM/`, `/sdcard/Pictures/` | JPEG/PNG/MP4 con metadatos EXIF |
| Ubicación (caché) | `/data/data/com.google.android.gms/...` | SQLite / Protobuf |
| Descargas | `/sdcard/Download/` | Variable |
| Logs del sistema | `bugreport.zip`, `logcat` | Texto plano |
| Apps de terceros | `/data/data/<paquete>/` | Variable (requiere root para acceso directo) |

> ⚠️ Muchas rutas bajo `/data/data/` **no son accesibles sin root** mediante
> `adb pull` estándar por el sandboxing de Android. En este taller, el análisis
> se enfoca en lo adquirido lógicamente en `/sdcard/` y en los reportes
> generados (`bugreport`, `logcat`, `getprop`). Se documentan las rutas
> anteriores con fines de referencia conceptual para el estudiante.

## 4.2 Análisis de bases de datos SQLite

Herramienta recomendada: **DB Browser for SQLite** (interfaz gráfica) o el
cliente `sqlite3` por línea de comandos.

```bash
sqlite3 /tmp/taller_forense_movil/CASO-2026-001/imagen_logica/contactos/contacts2.db
sqlite> .tables
sqlite> .schema calls
sqlite> SELECT number, date, duration, type FROM calls ORDER BY date DESC LIMIT 20;
```

Buenas prácticas al analizar SQLite en contexto forense:

- Debe trabajarse siempre sobre una **copia** de la base de datos, nunca sobre
  el archivo original de la evidencia.
- También deben revisarse los archivos `-wal` y `-shm` asociados (Write-Ahead
  Logging), que pueden contener transacciones no confirmadas con información
  adicional.
- Debe registrarse la consulta SQL exacta utilizada en el informe (repetibilidad).
- Los timestamps (frecuentemente en formato Unix epoch en milisegundos) deben
  convertirse a fecha/hora legible, documentando la zona horaria utilizada.

```bash
# Ejemplo de conversión de epoch (ms) a fecha legible en Linux/macOS
date -d @$(( 1700000000000 / 1000 ))
```

## 4.3 Análisis de metadatos multimedia (EXIF)

Herramienta recomendada: **ExifTool**.

```bash
exiftool /tmp/taller_forense_movil/CASO-2026-001/imagen_logica/DCIM/IMG_20260101_120000.jpg
```

Campos relevantes para el análisis forense:

| Campo EXIF | Relevancia forense |
|---|---|
| `DateTimeOriginal` | Fecha/hora de captura (puede diferir de la fecha del sistema de archivos) |
| `GPSLatitude` / `GPSLongitude` | Geolocalización de la captura |
| `Make` / `Model` | Dispositivo/cámara que generó el archivo (verificación de origen) |
| `Software` | Software de edición usado (indicio de manipulación) |

Para extraer metadatos de todo un directorio y exportarlos como evidencia:

```bash
exiftool -r -csv /tmp/taller_forense_movil/CASO-2026-001/imagen_logica/DCIM/ \
  > /tmp/taller_forense_movil/CASO-2026-001/metadatos_dcim.csv
```

> Ausencia de datos GPS no implica ausencia de ubicación real: puede deberse
> a permisos de ubicación desactivados en la app de cámara al momento de la
> captura. Esto debe documentarse como una limitación del hallazgo, no como
> una conclusión.

## 4.4 Reconstrucción de línea de tiempo (timeline)

Para construir una cronología de eventos deben combinarse las siguientes fuentes:

1. Timestamps de archivos (`ctime`/`mtime` del sistema de archivos adquirido).
2. `DateTimeOriginal` de metadatos EXIF.
3. Marcas de tiempo extraídas de bases de datos SQLite (llamadas, mensajes).
4. Eventos de `logcat`/`bugreport` (encendidos, conexiones de red, instalación de apps).

Se recomienda consolidar todo en una hoja de cálculo con columnas:
`fecha/hora (UTC y local) | fuente | tipo de evento | descripción | hash del artefacto de origen`.

## 4.5 Herramientas complementarias (nivel avanzado, opcional)

| Herramienta | Uso |
|---|---|
| [Autopsy](https://www.autopsy.com/) | Plataforma forense de código abierto; permite indexar y correlacionar la imagen lógica adquirida |
| [ALEAPP](https://github.com/abrignoni/ALEAPP) | Parser automatizado de artefactos Android (logs, bases de datos, caché de apps) |
| [MVT – Mobile Verification Toolkit](https://github.com/mvt-project/mvt) | Detección de indicadores de compromiso (spyware) en respaldos/extracciones Android e iOS |
| Cellebrite UFED / Magnet AXIOM | Herramientas comerciales de adquisición y análisis forense móvil de nivel profesional (mencionadas con fines de contexto de la industria) |

## 4.6 Registro de hallazgos

Cada hallazgo relevante debe documentarse con esta estructura mínima (ver
plantilla de informe pericial):

```
Hallazgo #N
- Artefacto de origen: (ruta / archivo / tabla)
- Hash del archivo de origen: (SHA-256)
- Descripción del hallazgo:
- Fecha/hora del evento (y zona horaria):
- Herramienta y comando/consulta utilizados:
- Captura de pantalla / evidencia adjunta:
```

---
**Checklist del módulo**
- [ ] Al menos una base de datos SQLite analizada con consultas documentadas.
- [ ] Metadatos EXIF extraídos de la evidencia multimedia disponible.
- [ ] Timeline consolidado con al menos 2 fuentes distintas de timestamps.
- [ ] Cada hallazgo documentado con artefacto de origen, hash y método.

**Anterior:** [`03-adquisicion-forense.md`](03-adquisicion-forense.md) · **Siguiente:** [`05-buenas-practicas-legal.md`](05-buenas-practicas-legal.md)
