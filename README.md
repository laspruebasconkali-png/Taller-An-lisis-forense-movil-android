# Taller Práctico: Análisis Forense Digital en Dispositivos Móviles (Android)

**Maestría en Seguridad de la Información — Curso: Análisis Forense Digital**
**Nivel:** Técnico / Práctico
**Plataforma objetivo:** Android (arquitectura de referencia; notas de adaptación a iOS donde aplica)

> Este repositorio corresponde a una versión ampliada de un taller base de
> adquisición forense con ADB. El contenido fue extendido a un flujo forense
> completo: preparación → adquisición → preservación (hashing y cadena de
> custodia) → análisis de la evidencia extraída → reporte pericial, siguiendo
> los principios de ISO/IEC 27037:2012 (identificación, recolección,
> adquisición y preservación de evidencia digital) y el marco NIST SP 800-101.

> ⚠️ **Nota de compatibilidad:** los comandos, nombres de menú y rutas de
> archivos indicados en este taller corresponden a versiones de referencia de
> Android, ADB y de las herramientas mencionadas (ver sección de Requisitos).
> Estos pueden variar según la versión del sistema operativo del dispositivo,
> la capa de personalización del fabricante (One UI, MIUI, ColorOS, etc.), el
> sistema operativo del equipo del analista (Windows, Linux, macOS) y la
> versión instalada de cada herramienta. Antes de ejecutar un comando se
> recomienda verificar su sintaxis vigente en la documentación oficial
> correspondiente.

---

## Objetivos de aprendizaje

Al finalizar el taller, la persona participante estará en capacidad de:

1. Configurar una estación forense mínima para la adquisición de dispositivos Android vía ADB.
2. Aplicar el principio de mínima intervención y documentar cada acción realizada sobre el dispositivo evidencia.
3. Adquirir una imagen lógica del almacenamiento de un dispositivo y calcular hashes de integridad (SHA-256).
4. Diligenciar correctamente un acta de recolección y una cadena de custodia.
5. Analizar artefactos forenses comunes en Android: bases de datos SQLite, metadatos multimedia (EXIF), logs del sistema y geolocalización.
6. Redactar un informe pericial técnico con hallazgos, metodología y conclusiones.

---

## Estructura del repositorio

```
taller-forense-movil-android/
├── README.md                          # Este archivo (índice general)
├── LICENSE
├── .gitignore
├── docs/
│   ├── 00-marco-conceptual.md         # Fundamentos, ISO 27037, principios forenses
│   ├── 01-configuracion-entorno.md    # ADB, drivers, depuración USB, carpeta de trabajo
│   ├── 02-adquisicion-informacion.md  # Triage: getprop, apps, logs, almacenamiento
│   ├── 03-adquisicion-forense.md      # Imagen lógica/física, hashing, cadena de custodia
│   ├── 04-analisis-evidencia.md       # SQLite, EXIF, ubicaciones, timeline
│   ├── 05-buenas-practicas-legal.md   # Buenas prácticas y marco legal (Colombia)
│   └── 06-cierre-reporte.md           # Cierre del caso e informe pericial
├── scripts/
│   ├── 01_setup_entorno.sh
│   ├── 02_verificar_conexion.sh
│   ├── 03_adquisicion_info.sh
│   ├── 04_adquisicion_logica.sh
│   ├── 05_generar_hashes.sh
│   └── 06_cierre.sh
├── plantillas/
│   ├── acta-recoleccion.md
│   ├── cadena-custodia.md
│   └── informe-pericial.md
└── evidencia/
    └── README.md                      # Nota: la evidencia real NO debe almacenarse aquí (ver más abajo)
```

---

## Ubicación de la evidencia durante la práctica

Por buena práctica, la evidencia generada durante el ejercicio **no se
almacena dentro del repositorio clonado ni en carpetas del perfil de usuario**
(por ejemplo `Escritorio`, `Documentos`, `Descargas` o rutas equivalentes),
ya que estas ubicaciones exponen el nombre del usuario o del equipo, y
además su ruta exacta puede variar según el sistema operativo, la
configuración del equipo o si existen unidades de red mapeadas.

En su lugar, este taller usa como convención una carpeta dentro del
directorio temporal del sistema:

| Sistema operativo | Ruta recomendada | Variable de entorno |
|---|---|---|
| Linux / macOS | `/tmp/taller_forense_movil/<ID_CASO>` | `TALLER_EVIDENCE_DIR` (opcional, sobrescribe el valor por defecto) |
| Windows | `%TEMP%\taller_forense_movil\<ID_CASO>` (equivalente a `C:\Windows\Temp\...` si se ejecuta con una cuenta de servicio, o a una ruta definida por el laboratorio) | `TALLER_EVIDENCE_DIR` |

Consideraciones importantes:

- La ruta exacta de la carpeta temporal puede variar entre sistemas
  operativos, distribuciones, políticas de red o perfiles del equipo del
  analista; por ello, la ruta efectivamente utilizada debe registrarse en el
  acta de recolección y en la cadena de custodia (ver `plantillas/`), en
  lugar de asumirse fija o darse por sentada en el informe.
- Los directorios temporales pueden ser purgados automáticamente por el
  sistema operativo (por ejemplo, al reiniciar el equipo). Esta ubicación es
  válida únicamente durante la ejecución del ejercicio; los entregables
  finales (informe, cadena de custodia, hashes) deben trasladarse a un
  almacenamiento controlado y persistente antes del cierre del caso.
  Ver [`docs/06-cierre-reporte.md`](docs/06-cierre-reporte.md).
- No deben incluirse en la documentación del caso direcciones IP,
  identificadores de red específicos ni rutas que revelen el nombre de
  usuario o del equipo del analista; si se requiere referenciar el origen de
  red de una evidencia, debe hacerse mediante un identificador anonimizado
  documentado aparte, conforme a la política de manejo de datos del curso.

---

## Requisitos previos

| Componente | Detalle |
|---|---|
| Sistema operativo del analista | Windows 10/11, Linux o macOS (los comandos pueden variar levemente entre versiones) |
| Herramienta principal | [Android Platform Tools (ADB)](https://developer.android.com/tools/releases/platform-tools) |
| Dispositivo | Android físico o emulado, **propio o con autorización expresa**, con depuración USB habilitable |
| Utilidades de hashing | `certutil` (Windows) o `sha256sum`/`shasum` (Linux/macOS) |
| Análisis de evidencia | [DB Browser for SQLite](https://sqlitebrowser.org/), [ExifTool](https://exiftool.org/), [Autopsy](https://www.autopsy.com/) (opcional) |
| Análisis avanzado (opcional) | [ALEAPP](https://github.com/abrignoni/ALEAPP), [MVT - Mobile Verification Toolkit](https://github.com/mvt-project/mvt) |
| Cable | USB original o certificado (evitar cables solo de carga) |

> Las versiones exactas de estas herramientas deben registrarse en el
> informe pericial (ver `plantillas/informe-pericial.md`), dado que los
> comandos y su salida pueden diferir entre versiones.

> ⚠️ **Advertencia legal:** todo el taller debe ejecutarse sobre un
> dispositivo de prueba propio de la persona participante o expresamente
> autorizado por su propietario/custodio. La adquisición forense de un
> dispositivo de un tercero sin autorización (orden judicial, consentimiento
> informado o marco normativo aplicable) puede constituir un delito. Ver
> [`docs/05-buenas-practicas-legal.md`](docs/05-buenas-practicas-legal.md).

---

## Ruta de trabajo del taller

```
00. Marco conceptual
        │
        ▼
01. Configuración del entorno  ───────►  Verificación de conexión (adb devices)
        │
        ▼
02. Adquisición de información (triage)  ───►  getprop · apps · logcat · pull inicial
        │
        ▼
03. Adquisición forense  ────►  Imagen lógica · Hash SHA-256 · Cadena de custodia
        │
        ▼
04. Análisis de la evidencia  ───►  SQLite · EXIF · Ubicaciones · Timeline
        │
        ▼
05. Buenas prácticas y marco legal
        │
        ▼
06. Cierre del caso e informe pericial
```

Cada módulo en `docs/` contiene: objetivo, fundamento teórico breve, comandos
comentados, referencias a capturas de pantalla como evidencia complementaria
y un checklist de verificación al final.

---

## Cómo usar este repositorio

1. Clonar o descargar el repositorio.
2. Revisar los módulos de `docs/` en orden (00 a 06).
3. Ejecutar los scripts de `scripts/` en la fase correspondiente. Los scripts
   almacenan la evidencia en `/tmp/taller_forense_movil/` por defecto (ver
   sección "Ubicación de la evidencia durante la práctica"); la ruta puede
   ajustarse mediante la variable de entorno `TALLER_EVIDENCE_DIR` según el
   sistema operativo y las políticas del laboratorio.
4. Diligenciar las plantillas de `plantillas/` a medida que avanza el
   ejercicio, no al finalizar.
5. Verificar que ninguna evidencia real quede almacenada dentro del
   repositorio clonado (la carpeta `evidencia/` del repositorio es solo un
   marcador de posición documentado en `.gitignore`; nunca debe subirse
   evidencia real a GitHub).
6. Entregar como resultado final: informe pericial + cadena de custodia + hashes.

```bash
git clone <URL-del-repositorio>
cd taller-forense-movil-android
chmod +x scripts/*.sh

# Opcional: definir una ruta de evidencia distinta a la de por defecto
export TALLER_EVIDENCE_DIR="/tmp/taller_forense_movil"

./scripts/01_setup_entorno.sh
```

---

## Rúbrica sugerida de evaluación

| Criterio | Peso |
|---|---|
| Configuración correcta del entorno y evidencia de conexión (`adb devices`) | 10% |
| Adquisición lógica completa y verificable | 20% |
| Cálculo y verificación de hashes de integridad | 15% |
| Cadena de custodia y acta de recolección correctamente diligenciadas | 20% |
| Calidad del análisis de evidencia (SQLite/EXIF/ubicaciones) | 20% |
| Informe pericial: claridad, trazabilidad metodológica y conclusiones | 15% |

---

## Referencias

- ISO/IEC 27037:2012 — *Guidelines for identification, collection, acquisition and preservation of digital evidence*.
- NIST SP 800-101 Rev. 1 — *Guidelines on Mobile Device Forensics*.
- SWGDE — *Best Practices for Mobile Device Evidence Collection & Preservation*.
- Colombia — Ley 906 de 2004 (Código de Procedimiento Penal), Arts. 254-266 (cadena de custodia).
- Colombia — Ley 527 de 1999 (mensajes de datos y firmas digitales).
- Documentación oficial ADB: <https://developer.android.com/tools/adb>

---

*Material de uso educativo elaborado para el curso de Análisis Forense Digital de la Maestría en Seguridad de la Información. Ver [`LICENSE`](LICENSE).*
