# Guía Paso a Paso: ESP32-S3 Groq Speech-to-Text con Arduino CLI

> Última actualización: 2026-09-10

Esta guía explica cómo configurar el entorno, compilar y subir el firmware de reconocimiento de voz a texto utilizando **Arduino CLI** en lugar de PlatformIO.

---

## Requisitos

### Hardware

| Componente | Notas |
|---|---|
| ESP32-S3 Dev Board | Cualquier ESP32-S3 con al menos 8 MB de flash (se probó con modelos de 16 MB) |
| Micrófono INMP441 | Micrófono digital I2S de 24 bits |
| Protoboard y cables | Para la prototipación |
| Cable USB | Cable de datos (no solo carga) |

### Software

- Windows, macOS o Linux
- Arduino CLI (versión 1.0.0 o superior recomendada)
- Git (opcional, para clonar el repositorio)

### Servicios

- Cuenta gratuita en [Groq Console](https://console.groq.com)
- API key de Groq (comienza con `gsk_`)

---

## Paso 1: Instalar Arduino CLI

### Windows

1. Descarga el instalador desde https://arduino.github.io/arduino-cli/install/powershell/
2. Abre PowerShell como administrador y ejecuta:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   iwr -useb https://raw.githubusercontent.com/arduino/arduino-cli/master/install/install.ps1 | iex
   ```
3. Agrega Arduino CLI al PATH (la instalación lo hace automáticamente en la mayoría de los casos).

### macOS

1. Instala Homebrew si no lo tienes: https://brew.sh/
2. Ejecuta:
   ```bash
   brew install arduino-cli
   ```

### Linux (Ubuntu/Debian)

1. Descarga e instala:
   ```bash
   curl -sSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install/install.sh | sh
   sudo mv bin/arduino-cli /usr/local/bin/
   ```

2. Verifica la instalación:
   ```bash
   arduino-cli version
   ```

---

## Paso 2: Configurar el paquete de placas ESP32

### 2.1. Configurar la URL del paquete ESP32

Ejecuta el siguiente comando para configurar la URL del índice de placas ESP32:

```bash
arduino-cli config set board_manager.additional_urls https://espressif.github.io/arduino-esp32/package_esp32_index.json
```

### 2.2. Actualizar el índice de núcleos

```bash
arduino-cli core update-index
```

### 2.3. Instalar el núcleo ESP32 versión 3.3.11

> **Importante:** Esta versión incluye `ESP_I2S.h`, que el firmware requiere. Versiones 2.x no funcionarán.

```bash
arduino-cli core install esp32:esp32@3.3.11
```

Verifica la instalación:
```bash
arduino-cli core list
```

Deberías ver algo como:
```
ID          Version   Last path              Installed
esp32:esp32 3.3.11    ~/Arduino15/...         yes
```

---

## Paso 3: Clonar el repositorio

```bash
git clone https://github.com/lookymlive/ESP32-Groq-Speech-to-Text.git
cd ESP32-Groq-Speech-to-Text
```

---

## Paso 4: Configurar credenciales

### 4.1. Editar `Code/secrets.h`

Abre `Code/secrets.h` en tu editor de texto favorito:

```cpp
#pragma once

#define WIFI_SSID       "TU_SSID_WIFI"
#define WIFI_PASSWORD   "TU_CONTRASEÑA_WIFI"
#define GROQ_API_KEY    "gsk_TU_API_KEY_DE_GROQ"
```

### 4.2. Obtener tu API Key

1. Ve a [console.groq.com](https://console.groq.com)
2. Inicia sesión o crea una cuenta gratuita
3. Navega a **API Keys**
4. Haz clic en **Create API Key**
5. Copia la clave y reemplaza `"gsk_xxxxxxxxxxx"` en `secrets.h`

> **Nota de seguridad:** `secrets.h` contiene credenciales personales. Si publicas tu fork, asegúrate de agregarlo a `.gitignore`.

---

## Paso 5: Cableado del INMP441 al ESP32-S3

| Pin INMP441 | Pin ESP32-S3 |
|---|---|
| VDD | 3V3 |
| GND | GND |
| L/R | GND (selector de canal izquierdo) |
| SD  | GPIO 4 |
| SCK | GPIO 5 |
| WS  | GPIO 6 |

> El botón BOOT del ESP32-S3 está conectado a GPIO 0 y se usa como disparador de grabación (activo LOW).

---

## Paso 6: Configurar la placa en Arduino CLI

Verifica que Arduino CLI reconozca el ESP32-S3:

```bash
arduino-cli board listall esp32s3
```

---

## Paso 7: Compilar el firmware

```bash
arduino-cli compile --fqbn esp32:esp32:esp32s3 Code/Code.ino
```

Si todo está configurado correctamente, deberías ver:
```
Sketch uses 1234567 bytes (47%) of program storage space.
Global variables use 56789 bytes (21%) of dynamic memory.
```

---

## Paso 8: Subir el firmware al ESP32-S3

### 8.1. Conecta tu ESP32-S3 a USB

Usa un cable de datos (no solo carga).

### 8.2. Identifica el puerto serial

```bash
arduino-cli board list
```

Deberías ver algo como:
```
Port         Type       Board Name  FQBN
/dev/ttyUSB0 Serial Port ESP32-S3 Dev Module esp32:esp32:esp32s3
```

En Windows: `COM3`, `COM4`, etc.
En macOS/Linux: `/dev/ttyUSB0` o `/dev/cu.usbserial-*`

### 8.3. Sube el firmware

```bash
arduino-cli compile --fqbn esp32:esp32:esp32s3 Code/Code.ino --upload --port <TU_PUERTO>
```

Ejemplo en Windows:
```bash
arduino-cli compile --fqbn esp32:esp32:esp32s3 Code/Code.ino --upload --port COM3
```

Ejemplo en Linux/macOS:
```bash
arduino-cli compile --fqbn esp32:esp32:esp32s3 Code/Code.ino --upload --port /dev/ttyUSB0
```

Si no entra en modo flasheo automáticamente, presiona y mantén el botón BOOT mientras se sube.

---

## Paso 9: Usar el monitor serial

```bash
arduino-cli monitor -p <TU_PUERTO> -b 115200
```

Ejemplo:
```bash
arduino-cli monitor -p /dev/ttyUSB0 -b 115200
```

### Salida esperada en el monitor serial

```
SpeechToText - Groq Whisper
v1.0.0 (Sep  9 2026)

[wifi] conectando a TU_SSID_WIFI...
[wifi] 192.168.1.10  rssi -52
Hold BOOT and talk, release when done.
```

### Cómo usar el firmware

1. Abre el monitor serial a **115200 baudios**.
2. Presiona y mantén el **botón BOOT** en tu ESP32-S3.
3. Habla claramente durante al menos 0.3 segundos.
4. Suelta el botón BOOT.
5. El firmware enviará el audio a Groq y mostrará la transcripción:

```
[rec] listening...
[rec] 49152 bytes, 2.4 s, peak 4281
[stt] 712 ms
-------------------------------------------
You said: hello world
-------------------------------------------
```

---

## Paso 10: Usar el Makefile (opcional)

Un `Makefile` está incluido para simplificar los comandos comunes:

```bash
make help    # Muestra todos los targets
make build   # Compila el firmware
make flash   # Compila y sube al ESP32
make monitor # Abre el monitor serial
make clean   # Limpia artefactos de compilación
make format  # Formatea el código con clang-format
make version # Imprime la versión del firmware
```

---

## Solución de problemas comunes

### `ESP_I2S.h: No such file or directory`

- Asegúrate de haber instalado el núcleo ESP32 **versión 3.3.11** (no 2.x).
- Verifica con `arduino-cli core list`.

### `[mic] I2S INIT FAILED`

- **PSRAM debe estar deshabilitado.** El firmware no usa PSRAM y no se puede cambiar por comandos; esto se asegura en el código.

### `A fatal error occurred: Failed to connect`

- Presiona y mantén el botón BOOT mientras se sube el firmware.

### Puerto no aparece / `Could not find port`

- Usa un **cable de datos** (no solo carga).
- Instala drivers CP2102 o CH340 si tu placa los usa.
- Verifica con `arduino-cli board list`.

### `HTTP 429`

- Límite de Groq gratuito excedido. Espera algunos minutos e intenta de nuevo.

### `HTTP 401`

- Verifica que la API key en `secrets.h` comience con `gsk_` y sea correcta.

### Monitor serial en blanco

- Abre el monitor serial **después** de que la subida termine y la placa se reinicie.
- Asegúrate de estar a **115200 baudios**.

---

## Estructura del proyecto

```
ESP32-Groq-Speech-to-Text/
├── Code/
│   ├── Code.ino        # Firmware principal
│   ├── secrets.h       # Credenciales (editar antes de usar)
│   └── version.h       # Metadatos de versión
├── docs/
│   └── 01-setup.md through 08-faq.md  # Documentación detallada
├── .github/workflows/build.yml  # CI
├── Makefile            # Atajos de desarrollo
├── platformio.ini      # Configuración PlatformIO (experimental)
└── README.md
```

---

## Limpieza: eliminar el entorno PlatformIO (opcional)

Si ya no usas PlatformIO, puedes eliminar las dependencias:

```bash
pip uninstall platformio
```

El `platformio.ini` se conserva como documentación histórica, pero el firmware se construye oficialmente con Arduino CLI.

---

## Enlaces útiles

- [Documentación de Arduino CLI](https://arduino.github.io/arduino-cli/)
- [Paquetes de placas ESP32](https://espressif.github.io/arduino-esp32/package_esp32_index.json)
- [Consola de Groq](https://console.groq.com)
- [INMP441 - Datos técnicos](https://www.invensense.com/products/microphones/inmp441/)