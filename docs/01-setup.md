# Step 1: Arduino IDE & Board Setup

This guide walks through installing the Arduino IDE, adding the ESP32 board package, and configuring the correct board settings.

## Prerequisites

- A computer running Windows, macOS, or Linux
- USB-C or Micro-USB cable (depending on your ESP32-S3 board) for power and programming
- Internet connection (for board installation and API access)

## 1. Install the Arduino IDE

Download and install the Arduino IDE from the [official website](https://www.arduino.cc/en/software).

> Arduino IDE 2.x is recommended. The classic 1.8.x is also supported.

## 2. Add the ESP32 Board Package

The ESP32-S3 is not supported out of the box. You need to add the Espressif board index URL.

1. Open Arduino IDE.
2. Go to **File → Preferences**.
3. In the **Additional Boards Manager URLs** field, add:
   ```
   https://espressif.github.io/arduino-esp32/package_esp32_index.json
   ```
4. Click **OK** to save.

   > If you already have another board URL in this field, separate multiple URLs with a comma.

## 3. Install the ESP32 Board Package

1. Go to **Tools → Board → Boards Manager**.
2. Search for `esp32`.
3. Find **esp32 by Espressif Systems**.
4. Install **version 3.3.11**.

   > **Version matters.** Earlier 2.x cores do not include `ESP_I2S.h`, which this firmware requires. Attempting to build with a 2.x core will fail with:
   > ```
   > fatal error: ESP_I2S.h: No such file or directory
   > ```

## 4. Select Your Board

1. Go to **Tools → Board**.
2. Select **ESP32S3 Dev Module**.

## 5. Configure Board Settings

Open the **Tools** menu and verify these settings:

| Setting | Value | Notes |
|---|---|---|
| **Board** | ESP32S3 Dev Module | |
| **PSRAM** | **Disabled** | With PSRAM enabled, the I2S driver allocates its channel object in PSRAM, which the GDMA engine cannot access. This causes `I2S INIT FAILED`. |
| **USB CDC On Boot** | **Disabled** | Use this if your board has a CP2102 or CH340 USB-to-UART bridge (most common). |
| **USB CDC On Boot** | **Enabled** | Use this if your board uses the ESP32-S3 native USB port. |
| **Flash Mode** | QIO | |
| **Flash Frequency** | 80 MHz | |
| **Partition Scheme** | Default | |
| **Core** | USB-OTG | |
| **CPU Frequency** | 240 MHz | |

> **Wrong USB CDC setting** = blank Serial Monitor. If the Serial Monitor shows nothing after upload, toggle this setting and re-upload.

## 6. Verify the Installation

1. Open any example sketch: **File → Examples → 01.Basics → Blink**.
2. Select your board's **port** from **Tools → Port** (it appears as "ESP32-S3 Dev Module").
3. Click the **Upload** button.

If the upload succeeds, the built-in LED on your board should blink. The IDE is ready for the speech-to-text firmware.

---

## Next Steps

- [Wire the INMP441 microphone → 02-wiring.md](02-wiring.md)
- [Configure your credentials → 03-configuration.md](03-configuration.md)
