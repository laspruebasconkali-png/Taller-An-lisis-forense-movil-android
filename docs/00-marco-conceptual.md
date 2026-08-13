# 00. Marco conceptual

> ⚠️ **Nota de compatibilidad:** los conceptos de este módulo son estables,
> pero los ejemplos de herramientas y procedimientos citados a lo largo del
> taller pueden variar según la versión del sistema operativo del
> dispositivo y del analista, así como según la versión de cada herramienta
> utilizada (ver [`README.md`](../README.md)).

## 1. ¿Qué es el análisis forense de dispositivos móviles?

Es la aplicación de metodologías científicas y forenses para identificar,
recolectar, adquirir, preservar, analizar y presentar evidencia digital
contenida en un dispositivo móvil, de forma que dicha evidencia sea admisible
y defendible ante una instancia disciplinaria, administrativa o judicial.

A diferencia del forense de computadores tradicional, el forense móvil enfrenta
retos particulares:

- **Volatilidad y conectividad constante**: el dispositivo puede recibir señales
  (llamadas, mensajes, comandos remotos de borrado) que alteran la evidencia.
- **Cifrado por defecto**: desde Android 6.0 el cifrado de almacenamiento es
  obligatorio; desde Android 10 se usa File-Based Encryption (FBE).
- **Fragmentación**: múltiples fabricantes, versiones de Android y capas de
  personalización (One UI, MIUI, ColorOS, etc.).
- **Acceso restringido sin privilegios elevados**: sin *root* solo se puede
  acceder al almacenamiento accesible por el usuario (adquisición lógica),
  no a la partición completa del sistema (adquisición física).

## 2. Niveles de adquisición forense móvil

| Nivel | Descripción | Acceso requerido | Herramientas típicas |
|---|---|---|---|
| **Manual** | Fotografiar/registrar directamente la interfaz del dispositivo | Ninguno especial | Cámara, formularios |
| **Lógica** | Copia de archivos y datos accesibles vía el sistema de archivos expuesto (API de Android/ADB) | Depuración USB habilitada | `adb pull`, `adb backup` |
| **Sistema de archivos (File System)** | Extracción de la estructura completa de archivos del sistema, incluidas bases de datos de apps | Root o exploits de adquisición (p. ej. servicios OEM) | Herramientas forenses comerciales, MTK/Qualcomm bypass |
| **Física (bit-a-bit)** | Copia binaria completa de la memoria NAND | Root, bootloader desbloqueado, o técnicas de hardware | `dd`, JTAG, chip-off |
| **Chip-off / JTAG** | Extracción directa del chip de memoria | Intervención física invasiva del dispositivo | Laboratorio especializado |

> Este taller se enfoca en el nivel **lógico**, el más común y el que no
> requiere privilegios elevados ni intervención invasiva, adecuado para un
> primer acercamiento técnico a nivel de maestría. Se documentan también,
> a nivel conceptual, los niveles superiores para contextualizar sus límites.

## 3. Principios forenses aplicables (ISO/IEC 27037)

1. **Minimización de la intervención**: cualquier acción sobre el dispositivo
   debe ser mínima, justificada y documentada.
2. **Auditabilidad y repetibilidad**: otro perito, siguiendo los mismos pasos,
   debe poder llegar a los mismos resultados.
3. **Preservación de la integridad**: uso de hashes criptográficos (SHA-256)
   antes y después de cada manipulación de la evidencia.
4. **Cadena de custodia**: registro ininterrumpido de quién, cuándo, dónde y
   por qué tuvo acceso a la evidencia.
5. **Competencia del examinador**: quien adquiere y analiza debe estar
   capacitado y debe documentar su idoneidad.

## 4. Flujo forense general

```
Identificación → Recolección → Adquisición → Preservación → Análisis → Presentación
```

En este taller cada fase se traduce en un módulo:

| Fase ISO/IEC 27037 | Módulo del taller |
|---|---|
| Identificación / Recolección | `01-configuracion-entorno.md`, `02-adquisicion-informacion.md` |
| Adquisición / Preservación | `03-adquisicion-forense.md` |
| Análisis | `04-analisis-evidencia.md` |
| Presentación | `06-cierre-reporte.md` |

## 5. Aislamiento de red (Faraday)

Antes de iniciar cualquier adquisición, el dispositivo debe aislarse de redes
móviles y Wi-Fi para evitar:

- Borrado remoto (Android Device Manager / Find My Device).
- Sincronización que altere datos (nuevos mensajes, ubicaciones, notificaciones).
- Comandos remotos de terceros.

Opciones, de mayor a menor rigurosidad:

1. **Bolsa de Faraday** (ideal en un caso judicial real).
2. **Modo avión** + desactivación manual de Wi-Fi/Bluetooth (aceptable en
   entorno académico controlado, documentando la limitación).
3. Extracción de la SIM (si es procedente y no compromete la evidencia).

> En este taller, por tratarse de un dispositivo de prueba propio, es
> suficiente con activar el **modo avión** antes de conectar el cable USB,
> documentando la hora exacta en el acta de recolección.

---
**Checklist del módulo**
- [ ] Comprendo los niveles de adquisición forense y por qué este taller usa el nivel lógico.
- [ ] Puedo explicar los 5 principios forenses aplicados (ISO/IEC 27037).
- [ ] Sé por qué se debe aislar el dispositivo de la red antes de adquirirlo.

**Siguiente módulo:** [`01-configuracion-entorno.md`](01-configuracion-entorno.md)
