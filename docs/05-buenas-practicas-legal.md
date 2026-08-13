# 05. Buenas prácticas y marco legal

> ⚠️ **Nota de compatibilidad:** el marco normativo citado corresponde a
> Colombia y a estándares internacionales vigentes al momento de elaborar
> este taller; su aplicabilidad depende de la jurisdicción y puede cambiar
> con el tiempo, por lo que debe verificarse la vigencia de cada norma antes
> de usarla como sustento en un caso real.

## 5.1 Buenas prácticas forenses (resumen operativo)

| Principio | Aplicación práctica en este taller |
|---|---|
| **No modificar datos del dispositivo** | Preferir comandos de solo lectura; documentar cualquier cambio inevitable (p. ej. activar depuración USB) |
| **Aislar el dispositivo de la red** | Modo avión antes de conectar el cable; idealmente bolsa de Faraday |
| **Documentar cada paso** | Bitácora cronológica con hora exacta de cada comando ejecutado |
| **Trabajar sobre copias** | El análisis (módulo 04) se hace siempre sobre la copia adquirida, nunca sobre el original |
| **Verificar integridad** | Hash SHA-256 antes/después de cada transferencia de la evidencia |
| **Preservar la cadena de custodia** | Registrar cada persona con acceso a la evidencia, con fecha, hora y propósito |
| **Repetibilidad metodológica** | Registrar versiones exactas de herramientas y comandos utilizados |
| **Doble verificación (four-eyes principle)** | Cuando sea posible, un segundo examinador revisa/replica los hallazgos críticos |

## 5.2 Marco legal de referencia

> **Aviso:** este apartado tiene fines exclusivamente académicos y no
> constituye asesoría legal. La aplicabilidad de cada norma depende de la
> jurisdicción, el tipo de caso (penal, laboral, civil, administrativo) y debe
> ser validada con un profesional del derecho competente en el caso concreto.

### Colombia

- **Ley 906 de 2004** (Código de Procedimiento Penal), artículos 254 a 266:
  regula el manejo de elementos materiales probatorios y evidencia física,
  incluida la cadena de custodia.
- **Ley 527 de 1999**: reconoce validez jurídica a los mensajes de datos y
  establece criterios de equivalencia funcional e integridad de la información
  electrónica.
- **Ley 1273 de 2009**: tipifica los delitos informáticos (acceso abusivo a
  sistema informático, interceptación de datos, entre otros) — relevante para
  entender los límites legales de la propia actividad forense si se realiza
  sin autorización.
- Manual de cadena de custodia de la Fiscalía General de la Nación: define
  los formatos y procedimientos oficiales de rotulado, embalaje y traslado de
  evidencia física y digital.

### Referencias internacionales

- **ISO/IEC 27037:2012** — identificación, recolección, adquisición y
  preservación de evidencia digital.
- **ISO/IEC 27042:2015** — análisis e interpretación de evidencia digital.
- **NIST SP 800-101 Rev.1** — guías de forense en dispositivos móviles.
- **SWGDE** (Scientific Working Group on Digital Evidence) — mejores prácticas
  específicas para evidencia móvil.

## 5.3 Consentimiento y autorización

Antes de adquirir cualquier dispositivo se debe contar con **una** de las
siguientes bases de legitimidad:

1. **Consentimiento informado y voluntario** del propietario del dispositivo
   (documentado por escrito).
2. **Orden o mandato judicial/administrativo** que autorice la adquisición.
3. **Dispositivo corporativo** bajo política de uso aceptable que autorice
   expresamente la inspección forense por parte del empleador (con las
   limitaciones de privacidad aplicables en la jurisdicción correspondiente).
4. Ser el **propietario legítimo** del dispositivo (como en este taller
   académico, donde se usa un dispositivo propio del estudiante).

## 5.4 Checklist de cierre de buenas prácticas

- [ ] Se documentó la base de legitimidad para acceder al dispositivo.
- [ ] No se realizaron modificaciones evitables sobre el dispositivo original.
- [ ] Toda modificación inevitable quedó documentada con justificación y hora.
- [ ] La evidencia se trabajó siempre sobre copias verificadas por hash.
- [ ] La cadena de custodia está completa y sin vacíos temporales.

**Anterior:** [`04-analisis-evidencia.md`](04-analisis-evidencia.md) · **Siguiente:** [`06-cierre-reporte.md`](06-cierre-reporte.md)
