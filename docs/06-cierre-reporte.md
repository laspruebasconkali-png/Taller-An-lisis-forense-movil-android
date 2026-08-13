# 06. Cierre del caso e informe pericial

> ⚠️ **Nota de compatibilidad:** los pasos para desactivar la depuración USB
> pueden variar en nombre y ubicación de menú según el fabricante y la
> versión de Android del dispositivo (ver [`README.md`](../README.md)).

## 6.1 Cierre técnico de la sesión

Una vez concluida la adquisición y el análisis, se debe cerrar la sesión de
forma ordenada:

### Cerrar la conexión ADB

```bash
adb kill-server
```

Finaliza el servidor ADB local, cerrando la comunicación con el dispositivo.

### Desactivar la depuración USB en el dispositivo

1. Ir a **Ajustes → Sistema → Opciones de desarrollador**.
2. Desactivar **Depuración USB**.
3. (Opcional, según política del caso) Desactivar **Opciones de desarrollador**
   por completo.

> Esta acción debe documentarse con hora exacta en la bitácora: reduce la
> superficie de acceso no autorizado posterior al dispositivo, cerrando el
> ciclo de "mínima intervención justificada" abierto en el módulo 01.

### Verificación final de integridad

Antes de dar por cerrado el caso, debe recalcularse el hash de la carpeta
completa de evidencia y confirmarse que coincide con el registrado en la
cadena de custodia (ver
[`03-adquisicion-forense.md`](03-adquisicion-forense.md#34-verificación-de-integridad-al-finalizar)).

```bash
sha256sum -c /tmp/taller_forense_movil/CASO-2026-001/hashes_adquisicion.sha256
```

## 6.2 Elaboración del informe pericial

Debe usarse la plantilla [`plantillas/informe-pericial.md`](../plantillas/informe-pericial.md)
como base. Un informe pericial técnico defendible debe incluir, como mínimo:

1. **Identificación del caso**: número de caso, fecha, examinador(es), objeto del peritaje.
2. **Descripción del dispositivo**: marca, modelo, IMEI/serial, versión de Android, estado físico.
3. **Metodología**: herramientas (con versión), procedimiento paso a paso, referencia a los estándares aplicados (ISO/IEC 27037, NIST SP 800-101).
4. **Cadena de custodia**: resumen o anexo del documento completo.
5. **Hallazgos**: cada uno con artefacto de origen, hash, timestamp y evidencia adjunta (según formato de `04-analisis-evidencia.md`).
6. **Limitaciones del análisis**: qué no se pudo adquirir/analizar y por qué (p. ej. cifrado, ausencia de root, apps con `allowBackup=false`).
7. **Conclusiones**: respuestas objetivas a las preguntas periciales planteadas, sin opiniones subjetivas.
8. **Anexos**: capturas de pantalla, listados completos, archivos de hash, acta de recolección.

## 6.3 Principios de redacción del informe

- **Objetividad**: describir hechos verificables, evitar juicios de valor o conclusiones no soportadas por la evidencia.
- **Trazabilidad**: cada afirmación debe poder rastrearse hasta un artefacto concreto con su hash.
- **Claridad para no técnicos**: el informe puede ser leído por un juez, fiscal o directivo sin formación técnica profunda; usar anexos técnicos para el detalle.
- **Reproducibilidad**: cualquier perito calificado debe poder repetir el procedimiento y llegar a conclusiones equivalentes.

## 6.4 Entregables finales del taller

Para la entrega académica de este taller deben compilarse los siguientes entregables:

```
entrega/
├── informe-pericial.pdf (o .md)
├── cadena-custodia.pdf (o .md)
├── acta-recoleccion.pdf (o .md)
├── hashes_adquisicion.sha256
└── anexos/
    ├── capturas_pantalla/
    ├── apps.txt
    ├── log.txt
    └── metadatos_dcim.csv
```

> No debe incluirse la evidencia cruda completa (imágenes personales,
> bases de datos con datos reales de terceros) en la entrega académica ni en
> el repositorio de GitHub; deben usarse datos de un dispositivo de pruebas
> propio y, si se requiere, deben anonimizarse o sustituirse por datos
> sintéticos para los ejemplos.

---
**Checklist final del taller**
- [ ] Sesión ADB cerrada (`adb kill-server`).
- [ ] Depuración USB desactivada en el dispositivo.
- [ ] Integridad de la evidencia verificada por última vez.
- [ ] Informe pericial redactado y completo.
- [ ] Cadena de custodia y acta de recolección adjuntas.
- [ ] Entregables organizados según la estructura de `entrega/`.

**Anterior:** [`05-buenas-practicas-legal.md`](05-buenas-practicas-legal.md) · **Volver al índice:** [`README.md`](../README.md)
