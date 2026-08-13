# 03. Adquisición forense (imagen lógica, hashing y cadena de custodia)

> ⚠️ **Nota de compatibilidad:** `adb backup` y algunos parámetros de `adb
> pull` pueden comportarse de forma distinta según la versión de Android
> (por ejemplo, `adb backup` está deprecado progresivamente desde Android
> 12), y los comandos de hashing difieren entre sistemas operativos (`certutil`
> en Windows, `sha256sum`/`shasum` en Linux/macOS). Deben verificarse las
> herramientas realmente instaladas antes de ejecutar cada comando.

**Objetivo:** obtener una copia forense del almacenamiento accesible del
dispositivo y garantizar su integridad mediante hashes criptográficos,
formalizando el traslado de custodia de la evidencia.

## 3.1 Imagen lógica

Una **imagen lógica** es una copia de los archivos y carpetas accesibles a
través del sistema de archivos expuesto por el sistema operativo (a diferencia
de una imagen física, que es una copia binaria bit-a-bit de toda la partición
de memoria, incluyendo espacio no asignado).

```bash
adb pull /sdcard/ /tmp/taller_forense_movil/CASO-2026-001/imagen_logica/
```

Para maximizar la cobertura de la adquisición lógica sin privilegios de root,
también se recomienda:

```bash
# Respaldo estructurado de apps y datos compartidos permitidos (deprecado en Android 12+,
# util en versiones anteriores o dispositivos legacy)
adb backup -apk -shared -all -f /tmp/taller_forense_movil/CASO-2026-001/backup.ab
```

> `adb backup` fue deprecado progresivamente desde Android 12 y muchas apps
> lo excluyen (`android:allowBackup="false"`). Si el comando no produjo datos
> por esta razón, debe documentarse en el informe — es un hallazgo
> metodológico válido, no un error del analista.

### 3.1.1 Nota sobre adquisición física (nivel avanzado, fuera del alcance práctico de este taller)

Para obtener una imagen física real se requiere generalmente acceso *root* o
un bootloader desbloqueado, lo cual:

- Puede requerir un **reinicio** del dispositivo (alterando la memoria volátil).
- Puede activar **borrado de datos de usuario** en algunos fabricantes al
  desbloquear el bootloader (por diseño, como medida antirrobo).
- Debe estar **explícitamente justificado y autorizado** en el caso, dado su
  impacto sobre la evidencia original.

Ejemplo conceptual (solo si el dispositivo ya cuenta con root y el
procedimiento está autorizado):

```bash
adb shell su -c "dd if=/dev/block/bootdevice/by-name/userdata of=/sdcard/userdata.img"
adb pull /sdcard/userdata.img /tmp/taller_forense_movil/CASO-2026-001/
```

> Este taller **no** requiere ni promueve el rooteo de dispositivos. Se
> documenta únicamente con fines de contextualización académica sobre los
> límites de la adquisición lógica.

## 3.2 Hash de integridad

El hash criptográfico es la "huella digital" del archivo. Debe calcularse
**inmediatamente después** de cada adquisición, y nuevamente en cualquier
punto donde se transfiera o copie la evidencia, comparando resultados.

**Windows (PowerShell):**

```powershell
certutil -hashfile "$env:TEMP\taller_forense_movil\CASO-2026-001\imagen_logica\archivo.jpg" SHA256
```

> Nota: en el Símbolo del sistema (`cmd.exe`) la variable equivalente se
> referencia como `%TEMP%` en lugar de `$env:TEMP`; la sintaxis debe
> ajustarse según el intérprete efectivamente utilizado.

**Linux/macOS:**

```bash
sha256sum /tmp/taller_forense_movil/CASO-2026-001/imagen_logica/archivo.jpg
```

Para calcular el hash de **toda la carpeta adquirida** de forma reproducible
(recomendado sobre hashear archivo por archivo):

```bash
# Linux/macOS
find /tmp/taller_forense_movil/CASO-2026-001/imagen_logica -type f -exec sha256sum {} \; \
  > /tmp/taller_forense_movil/CASO-2026-001/hashes_adquisicion.sha256

# Verificación posterior (debe devolver "OK" en cada línea)
sha256sum -c /tmp/taller_forense_movil/CASO-2026-001/hashes_adquisicion.sha256
```

```powershell
# Windows PowerShell
Get-ChildItem -Recurse "$env:TEMP\taller_forense_movil\CASO-2026-001\imagen_logica" | `
  Get-FileHash -Algorithm SHA256 | `
  Export-Csv "$env:TEMP\taller_forense_movil\CASO-2026-001\hashes_adquisicion.csv"
```

> **Por qué SHA-256 y no MD5/SHA-1:** MD5 y SHA-1 tienen colisiones conocidas
> y ya no se consideran criptográficamente robustos para uso pericial. SHA-256
> es el estándar recomendado actual (NIST, SWGDE) para cadena de custodia digital.

## 3.3 Cadena de custodia

Cada adquisición debe quedar registrada en la plantilla
[`plantillas/cadena-custodia.md`](../plantillas/cadena-custodia.md), incluyendo
como mínimo:

- Identificación del caso y del examinador.
- Descripción del dispositivo (marca, modelo, IMEI/serial).
- Hora de inicio y fin de la adquisición.
- Hash SHA-256 de la evidencia adquirida.
- Cada persona que tuvo acceso posterior a la evidencia, con fecha/hora y propósito.

## 3.4 Verificación de integridad al finalizar

Antes de cerrar la sesión de adquisición:

1. Recalcular el hash de la carpeta de evidencia.
2. Compararlo contra el hash documentado al momento de la adquisición.
3. Si coincide → documentar "integridad verificada" en la cadena de custodia.
4. Si **no** coincide → detener el proceso, documentar la discrepancia y
   escalar al responsable del caso; **no** continuar el análisis sobre esa copia.

---
**Checklist del módulo**
- [ ] Imagen lógica adquirida y almacenada en la carpeta del caso.
- [ ] Hash SHA-256 calculado inmediatamente después de la adquisición.
- [ ] Hash documentado en la cadena de custodia.
- [ ] Verificación de integridad posterior realizada y coincide con el hash original.
- [ ] Cadena de custodia diligenciada y firmada (digital o físicamente, según el caso).

**Script de apoyo:** [`scripts/04_adquisicion_logica.sh`](../scripts/04_adquisicion_logica.sh) y
[`scripts/05_generar_hashes.sh`](../scripts/05_generar_hashes.sh)

**Anterior:** [`02-adquisicion-informacion.md`](02-adquisicion-informacion.md) · **Siguiente:** [`04-analisis-evidencia.md`](04-analisis-evidencia.md)
