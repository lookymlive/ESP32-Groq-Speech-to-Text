# Step 5: Troubleshooting

Solutions to common problems.

## Table of Contents

- [Setup Issues](#setup-issues)
- [Upload Issues](#upload-issues)
- [Wi-Fi Issues](#wi-fi-issues)
- [Audio/Microphone Issues](#audiomic-issues)
- [Network/API Issues](#networkapi-issues)
- [No Output / Blank Serial Monitor](#no-output--blank-serial-monitor)

---

## Setup Issues

### `fatal error: ESP_I2S.h: No such file or directory`

Your ESP32 board package is too old (2.x). You need **v3.3.11** of the `esp32` board package by Espressif Systems.

1. Uninstall any 2.x `esp32` package in **Boards Manager**.
2. Install version **3.3.11** from the Boards Manager.
3. Re-select **ESP32S3 Dev Module** under **Tools → Board**.

### Wrong board selected

If you accidentally select "ESP32 Dev Module" (ESP32, not ESP32-S3), the build fails because the pin mapping and I2S driver differ.

**Fix:** Select **Tools → Board → ESP32S3 Dev Module**.

---

## Upload Issues

### `A fatal error occurred: Failed to connect`

The board did not enter flashing mode automatically.

**Fix:** Press and hold the **BOOT** button on your ESP32-S3, then click Upload. Release the button once flashing begins.

### `Could not find port available` / Port not listed

- Use a **data cable**, not a charge-only cable.
- Try a different USB port or cable.
- Check Device Manager (Windows) / `ls /dev/tty.*` (macOS) / `ls /dev/ttyACM*` (Linux) to see if the board is recognized.
- Install or update CP2102 or CH340 drivers if your board uses one of those bridge chips.

### `text section exceeds available space`

Your board has too little flash (e.g., 2 MB). This firmware requires at least **8 MB flash** and **8 MB PSRAM** is recommended (though PSRAM must be disabled in Tools for I2S to work).

---

## Wi-Fi Issues

### Stuck on `[wifi] connecting...`

- Double-check `WIFI_SSID` and `WIFI_PASSWORD` in `secrets.h` — they are **case-sensitive**.
- Ensure your network is 2.4 GHz (ESP32-S3 does not support 5 GHz).
- Move the board closer to the router.

### Wrong IP or weak signal

Look at the RSSI value printed after connection:
```
[wifi] 192.168.1.10  rssi -52
```
- RSSI above -70 is good. Below -80 may cause connection drops.
- If RSSI is poor, relocate the board or use a Wi-Fi extender.

---

## Audio/Mic Issues

### `[mic] I2S INIT FAILED`

This almost always means **PSRAM is enabled** in the Tools menu. The I2S driver allocates its channel object in PSRAM, but the GDMA engine cannot access PSRAM.

**Fix:** Go to **Tools → PSRAM → Disabled**, then re-upload.

### `no signal - check VDD on 3V3, L/R to GND, and the SD pin`

The firmware recorded audio but the peak amplitude was below `SILENCE_PEAK` (300), which means it could not detect a voice signal.

Check the following:

1. **VDD → 3V3** (not 5V). The INMP441 is a 3.3 V part; connecting it to 5 V can damage it.
2. **L/R → GND**. This selects the left channel. If left floating, the signal may be on an unselected channel.
3. **SD → GPIO 4, SCK → GPIO 5, WS → GPIO 6**. Verify with a multimeter that the wires match the pinout in [02-wiring.md](02-wiring.md).
4. **Wiring is secure**. Loose wires on a breadboard are the #1 cause of this.

### Poor recognition accuracy

- The INMP441's DC offset and sub-120 Hz rumble are filtered digitally, but if the analog signal is too weak, quality will suffer.
- Make sure VDD is a clean 3.3 V supply. Powering from a noisy USB port can degrade audio.
- Ensure the microphone is facing the speaker and not obstructed.

---

## Network/API Issues

### `[net] connect failed`

- The ESP32 could not reach `api.groq.com` on port 443.
- Check Wi-Fi connectivity (see Wi-Fi issues above).
- Some networks block outbound port 443 or use a deep-packet inspection proxy. Try a mobile hotspot.

### `[stt] HTTP 429`

Groq rate-limited the request. This is expected on the free tier.

- Wait for the rate limit window to reset.
- Check current limits on the [Groq Console](https://console.groq.com).

### `[stt] HTTP 401`

Invalid or missing API key.

- Verify the key in `secrets.h` starts with `gsk_`.
- Log in to [console.groq.com](https://console.groq.com) and confirm the key is active.
- If you recently created the key, ensure you copied it completely.

### `[stt] HTTP 400` or empty response

- This can happen if the WAV header or chunked encoding was malformed.
- Ensure you are using the unmodified `Code.ino` with the correct board package (3.3.11).
- Check that no one edited the `writeWavHeader` or `sendChunk` functions.

---

## No Output / Blank Serial Monitor

### Serial Monitor shows nothing

1. **Check USB CDC On Boot** in **Tools → USB CDC On Boot**:
   - **Disabled** — for boards with CP2102/CH340 USB-UART bridge (most common).
   - **Enabled** — for boards with the ESP32-S3 native USB port.
2. Ensure the correct baud rate (**115200**) is selected in the Serial Monitor.
3. After changing board settings, re-upload the sketch.
4. Open the Serial Monitor **after** uploading (don't open it before — open it after the upload completes and the board resets).

### Serial Monitor shows `setup()` output but no `[wifi]` line

The board is not connecting to Wi-Fi. Check your credentials in `secrets.h`.

---

## Still Stuck?

1. Review all steps in order: [01-setup.md](01-setup.md) → [02-wiring.md](02-wiring.md) → [03-configuration.md](03-configuration.md).
2. Check the [README.md](../README.md) for the quick start.
3. Open an issue on GitHub with:
   - Your exact board model
   - ESP32 board package version
   - Full Serial Monitor output
   - Your wiring verification

---

[Return to docs index → README.md](README.md)
