# Formato de cadena de custodia de evidencia digital

## 1. Identificación de la evidencia

| Campo | Detalle |
|---|---|
| N.° de caso / expediente | |
| N.° consecutivo de evidencia | |
| Descripción de la evidencia | (ej. "Imagen lógica de almacenamiento, dispositivo Android, caso CASO-2026-001") |
| Contenedor / medio de almacenamiento de la copia | (ej. disco externo cifrado, serial XXXX) |
| Hash SHA-256 de la evidencia al momento de la adquisición | |
| Algoritmo y herramienta usada para el hash | (ej. `sha256sum`, `certutil -hashfile`) |

## 2. Registro de custodia (registro ininterrumpido)

*(Cada fila representa un cambio de custodio o un acceso a la evidencia.
No debe existir ningún periodo sin custodio identificado.)*

| N.° | Fecha | Hora | Entregado por | Recibido por | Propósito del acceso/traslado | Lugar | Hash verificado (Sí/No) |
|---|---|---|---|---|---|---|---|
| 1 | | | (Examinador que adquiere) | (Custodio inicial) | Adquisición inicial | | |
| 2 | | | | | | | |
| 3 | | | | | | | |

## 3. Verificaciones de integridad

| N.° | Fecha | Hora | Hash calculado | Coincide con hash original (Sí/No) | Responsable |
|---|---|---|---|---|---|
| 1 | | | | | |
| 2 | | | | | |

> Si algún hash **no coincide**, se debe suspender el uso de esa copia como
> evidencia, documentar la discrepancia en la sección de observaciones y
> notificar de inmediato al responsable del caso.

## 4. Condiciones de almacenamiento de la evidencia

| Campo | Detalle |
|---|---|
| Ubicación física/lógica del almacenamiento | |
| Medidas de protección (cifrado, acceso restringido, etc.) | |
| Responsable de la custodia permanente | |

## 5. Observaciones



## 6. Cierre de la cadena de custodia

| Campo | Detalle |
|---|---|
| Fecha de cierre | |
| Motivo de cierre (entrega a autoridad, fin del análisis, etc.) | |
| Responsable del cierre | |
| Firma | |
