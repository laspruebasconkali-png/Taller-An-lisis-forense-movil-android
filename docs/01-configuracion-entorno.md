# 01. Configuración del entorno

**Objetivo:** dejar la estación forense del analista lista para comunicarse de
forma confiable con el dispositivo evidencia, sin alterar su contenido.

> ⚠️ **Nota de compatibilidad:** los nombres de menú, rutas y comandos de
> este módulo corresponden a Android en versiones recientes (referencia:
> Android 12-15) y a la versión vigente de Android Platform Tools al momento
> de escribir este taller. Estos pueden variar según el fabricante del
> dispositivo, la capa de personalización instalada y la versión de ADB
> utilizada; se recomienda contrastar con la documentación oficial antes de
> ejecutar cada paso.

## 1.1 Preparación de la estación forense

Antes de iniciar cualquier interacción con el dispositivo, deben realizarse
las siguientes verificaciones:

1. Registrar en el acta de recolección la hora de inicio, el examinador y el
   caso asociado (ver [`plantillas/acta-recoleccion.md`](../plantillas/acta-recoleccion.md)).
2. Crear la carpeta de caso dentro del directorio temporal del sistema, por
   ejemplo: `/tmp/taller_forense_movil/CASO-2026-001/` (Linux/macOS) o
   `%TEMP%\taller_forense_movil\CASO-2026-001\` (Windows). Esta carpeta se
   usa como convención de trabajo precisamente para evitar rutas ancladas al
   perfil del usuario o al equipo específico del analista (ver
   [`README.md`](../README.md#ubicación-de-la-evidencia-durante-la-práctica));
   la ruta puede variar según el sistema operativo o la red del laboratorio,
   por lo que la ruta efectivamente usada debe quedar registrada en el acta
   de recolección.
3. Verificar que el equipo del analista **no tenga sincronización automática**
   con servicios en la nube que pudieran interactuar con el dispositivo (por
   ejemplo, Android Studio con *device mirroring*, o software OEM de respaldo).

## 1.2 Instalación de ADB (Android Debug Bridge)

ADB es la herramienta oficial de Google que permite la comunicación entre un
computador y un dispositivo Android a través de un protocolo cliente-servidor
(cliente ADB en el PC ↔ demonio `adbd` en el dispositivo).

**Procedimiento:**

1. Descargar *Android SDK Platform-Tools* desde el sitio oficial:
   <https://developer.android.com/tools/releases/platform-tools>
2. Descomprimir el paquete:
   - Windows: `C:\adb\`
   - Linux/macOS: `~/adb/`
3. Abrir una terminal en esa ruta.
4. Verificar la instalación:

```bash
adb version
```

Salida esperada (ejemplo):

```
Android Debug Bridge version 1.0.41
Version 34.0.5-...
```

> **Buena práctica forense:** registrar en el informe la versión exacta de
> ADB utilizada; es parte de la trazabilidad metodológica y permite que el
> proceso sea repetible por otro perito.

## 1.3 Instalación de drivers USB (solo Windows)

En Linux y macOS normalmente no se requieren drivers adicionales. En Windows:

1. Instalar el driver USB del fabricante del dispositivo (Google, Samsung,
   Xiaomi, etc.) o el driver genérico *Google USB Driver* desde el SDK Manager.
2. Verificar en el Administrador de dispositivos que el móvil aparezca sin
   símbolo de advertencia al conectarlo.

## 1.4 Activación de la depuración USB en el dispositivo

1. Ir a **Ajustes → Acerca del teléfono**.
2. Pulsar 7 veces sobre **Número de compilación** hasta que aparezca el
   mensaje "Ya eres desarrollador".
3. Ir a **Ajustes → Sistema → Opciones de desarrollador**.
4. Activar **Depuración USB**.

> ⚠️ Esta acción **modifica el estado del dispositivo** (activa una opción de
> configuración). Debe documentarse explícitamente en el acta de recolección
> como una intervención necesaria y justificada, incluyendo hora exacta,
> ya que rompe estrictamente el principio de "cero alteraciones" — el objetivo
> forense es *minimizar y documentar*, no lograr una intervención nula
> siempre que exista depuración USB deshabilitada de fábrica.

## 1.5 Conexión física y aislamiento de red

1. Activar **modo avión** en el dispositivo *antes* de conectar el cable USB.
2. Conectar el dispositivo al computador con un cable USB de datos (no solo de carga).
3. En el dispositivo aparecerá un diálogo "¿Permitir depuración USB desde este
   computador?" → marcar **"Siempre permitir desde este computador"** y aceptar.
   Documentar la huella (*fingerprint* RSA) que se muestra en el diálogo.

## 1.6 Verificación de conexión

```bash
adb devices
```

Salida esperada:

```
List of devices attached
R58N123ABCD    device
```

Interpretación de los posibles estados:

| Estado mostrado | Significado |
|---|---|
| `device` | Conexión exitosa y autorizada |
| `unauthorized` | Falta aceptar el diálogo de autorización en el dispositivo |
| `offline` | Problema de comunicación; debe reconectarse el cable o reiniciarse `adb` |
| *(vacío)* | Drivers no instalados o depuración USB deshabilitada |

Si el estado es `unauthorized` u `offline`, ejecutar:

```bash
adb kill-server
adb start-server
adb devices
```

---
**Checklist del módulo**
- [ ] ADB instalado y `adb version` ejecutado y documentado.
- [ ] Depuración USB activada y hora registrada en el acta de recolección.
- [ ] Modo avión activado antes de conectar el cable.
- [ ] `adb devices` muestra el dispositivo en estado `device`.
- [ ] Huella RSA del diálogo de autorización documentada.

**Script de apoyo:** [`scripts/01_setup_entorno.sh`](../scripts/01_setup_entorno.sh) y
[`scripts/02_verificar_conexion.sh`](../scripts/02_verificar_conexion.sh)

**Anterior:** [`00-marco-conceptual.md`](00-marco-conceptual.md) · **Siguiente:** [`02-adquisicion-informacion.md`](02-adquisicion-informacion.md)
