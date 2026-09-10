# Quick Reference

> Last updated: 2026-09-10

A one-page cheat sheet for the most common operations.

## Wiring Quick Reference

| INMP441 Pin | ESP32-S3 Pin |
|---|---|
| VDD | 3V3 |
| GND | GND |
| L/R | GND |
| SD | GPIO 4 |
| SCK | GPIO 5 |
| WS | GPIO 6 |

**BOOT button = GPIO 0** (record trigger, active LOW)

## Board Settings (Arduino IDE)

| Setting | Value |
|---|---|
| Board | ESP32S3 Dev Module |
| PSRAM | **Disabled** |
| USB CDC On Boot | Disabled (bridge) / Enabled (native USB) |
| Flash Mode | QIO |
| Flash Frequency | 80 MHz |
| CPU Frequency | 240 MHz |
| Partition Scheme | Default |

## Credentials

Edit `Code/secrets.h`:

```cpp
#define WIFI_SSID       "your_wifi"
#define WIFI_PASSWORD   "your_pass"
#define GROQ_API_KEY    "gsk_..."
```

Or use `.env.local` (PlatformIO):
```bash
cp .env.example .env.local
```

## Development Commands

### PlatformIO

```bash
pio run                     # build
pio run -t upload           # flash
pio run -t monitor          # serial monitor
pio run -t upload -t monitor # flash + monitor
```

### Makefile

```bash
make build
make flash
make monitor
make flash-monitor
make clean
make format
make version
```

### VS Code

- `Ctrl+Shift+B` → PlatformIO Build (default)
- `Ctrl+Shift+B` → PlatformIO Upload
- `Ctrl+Shift+B` → PlatformIO Monitor

## Serial Monitor Guide

| Output | Meaning |
|---|---|
| `[mic] started` | I2S microphone initialized |
| `[mic] I2S INIT FAILED` | PSRAM enabled — disable it |
| `[wifi] 192.168.x.x rssi -YY` | Connected, signal strength |
| `[rec] listening...` | Recording started |
| `[rec] N bytes, X.X s, peak N` | Recording finished |
| `[rec] no signal` | Check mic wiring (VDD=3V3, L/R=GND) |
| `[stt] N ms` | Groq API round-trip time |
| `HTTP 429` | Rate limited — wait and retry |
| `HTTP 401` | Invalid API key |
| `You said: ...` | Transcription result |

## Key Limits

| Parameter | Value |
|---|---|
| Max recording | 15 seconds |
| Min recording | 300 ms |
| Sample rate | 16 kHz |
| Audio format | 16-bit PCM mono |
| Max clip size | ~480 KB |
| Groq model | whisper-large-v3-turbo |

---

[← Back to docs index](README.md)
