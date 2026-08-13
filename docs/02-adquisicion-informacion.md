# 02. Adquisición de información (Triage)

> ⚠️ **Nota de compatibilidad:** las opciones exactas de `pm list packages`,
> `logcat` y `bugreport`, así como su salida, pueden variar entre versiones
> de Android y de Android Platform Tools (ver [`README.md`](../README.md)).

**Objetivo:** realizar un levantamiento inicial (*triage*) del dispositivo:
identificación del equipo, inventario de aplicaciones, logs recientes y una
primera copia del almacenamiento accesible.

> A partir de este punto, **todo comando ejecutado debe registrarse** con
> timestamp en la bitácora del caso (ver plantilla de acta de recolección).
> Los ejemplos de este módulo usan como convención la ruta
> `/tmp/taller_forense_movil/CASO-2026-001/` (ver
> [`01-configuracion-entorno.md`](01-configuracion-entorno.md#11-preparación-de-la-estación-forense));
> esta ruta debe ajustarse al identificador de caso real y al sistema
> operativo utilizado, y la ruta efectiva debe quedar registrada en el acta
> de recolección.

## 2.1 Información del dispositivo

```bash
adb shell getprop
```

Extrae las propiedades del sistema Android. Propiedades relevantes para el
informe pericial:

| Propiedad | Descripción |
|---|---|
| `ro.product.model` | Modelo comercial del dispositivo |
| `ro.product.manufacturer` | Fabricante |
| `ro.build.version.release` | Versión de Android |
| `ro.build.version.sdk` | Nivel de API |
| `ro.serialno` | Número de serie |
| `ro.build.fingerprint` | Huella única de la compilación (build) |
| `gsm.sim.operator.alpha` | Operador de la SIM (si aplica) |

Para guardar solo las propiedades relevantes como evidencia:

```bash
adb shell getprop > /tmp/taller_forense_movil/CASO-2026-001/getprop_dispositivo.txt
```

También es recomendable capturar el IMEI (requiere permisos; en versiones
recientes de Android puede no estar disponible sin apps privilegiadas):

```bash
adb shell dumpsys iphonesubinfo
```

## 2.2 Listado de aplicaciones instaladas

```bash
adb shell pm list packages
```

Variantes útiles:

```bash
# Solo apps de terceros (no del sistema)
adb shell pm list packages -3

# Incluir ruta del APK
adb shell pm list packages -f
```

Para guardarlo como evidencia:

```bash
adb shell pm list packages -f > /tmp/taller_forense_movil/CASO-2026-001/apps.txt
```

Este listado es clave para identificar aplicaciones de mensajería (WhatsApp,
Telegram, Signal), redes sociales, apps de ubicación o software potencialmente
malicioso (*spyware/stalkerware*) instalado en el dispositivo.

## 2.3 Extracción de logs del sistema

```bash
adb logcat -d > /tmp/taller_forense_movil/CASO-2026-001/log.txt
```

El flag `-d` (*dump*) vuelca el buffer actual y termina, en lugar de quedar
escuchando en tiempo real (lo cual alteraría el estado del dispositivo con
más eventos generados por el propio proceso de captura).

Para un reporte más completo del estado del sistema (batería, procesos,
conectividad, memoria):

```bash
adb bugreport /tmp/taller_forense_movil/CASO-2026-001/bugreport.zip
```

> `adb bugreport` genera un archivo `.zip` con decenas de logs del sistema.
> Es una de las fuentes más ricas de metadatos de uso, pero también una de
> las más pesadas; documentar el hash inmediatamente después de generarlo.

## 2.4 Copia preliminar de almacenamiento

```bash
adb pull /sdcard/ /tmp/taller_forense_movil/CASO-2026-001/sdcard_triage/
```

Copia archivos como imágenes, documentos, descargas y directorios de apps
almacenados en almacenamiento externo/compartido (`/sdcard`). Esta es una
copia de *triage* rápida; la adquisición forense formal con verificación de
integridad se realiza en el módulo siguiente.

## 2.5 Resumen de comandos del módulo

| Propósito | Comando |
|---|---|
| Propiedades del sistema | `adb shell getprop` |
| Apps instaladas (con ruta) | `adb shell pm list packages -f` |
| Logs del sistema | `adb logcat -d` |
| Reporte completo del sistema | `adb bugreport <archivo.zip>` |
| Copia preliminar de almacenamiento | `adb pull /sdcard/ <destino>` |

---
**Checklist del módulo**
- [ ] `getprop` capturado y guardado con nombre de archivo trazable al caso.
- [ ] Listado de apps guardado (`apps.txt`), incluyendo apps de terceros.
- [ ] Logs (`logcat`) y/o `bugreport` capturados.
- [ ] Copia preliminar de `/sdcard/` realizada.
- [ ] Todos los archivos generados están dentro de la carpeta temporal del caso (`/tmp/taller_forense_movil/<ID_CASO>/` o su equivalente en Windows), no dentro del repositorio ni en carpetas del perfil de usuario.

**Script de apoyo:** [`scripts/03_adquisicion_info.sh`](../scripts/03_adquisicion_info.sh)

**Anterior:** [`01-configuracion-entorno.md`](01-configuracion-entorno.md) · **Siguiente:** [`03-adquisicion-forense.md`](03-adquisicion-forense.md)
