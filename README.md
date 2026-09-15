# ESP32-S3 Groq Speech-to-Text

![CI](https://github.com/lookymlive/ESP32-Groq-Speech-to-Text/actions/workflows/build.yml/badge.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Version](https://img.shields.io/badge/version-1.0.0-blue)

Real-time speech-to-text on the ESP32-S3 using the [Groq](https://groq.com) Whisper API. Hold the BOOT button, speak, release — the transcript prints on the Serial Monitor in near real time.

The firmware captures audio from an INMP441 I2S microphone, applies a high-pass filter and digital gain to clean up the signal, then streams 16 kHz mono WAV data over a persistent TLS connection to Groq. Responses typically return in under a second because the connection is pre-warmed while idle.

---

## Features

- **Near real-time transcription** — audio is streamed as it is captured; no need to wait for a full buffer
- **Pre-warmed TLS connection** — the network connection is established while idle so button press latency is minimal
- **Signal conditioning** — cascaded high-pass filtering and digital gain compensate for the INMP441's DC offset and low-frequency rumble
- **Silence detection** — clips with no detectable signal are rejected locally before uploading
- **Chunked streaming** — uses HTTP `Transfer-Encoding: chunked` so the full audio never needs to fit in memory
- **No external libraries** — everything uses the ESP32 Arduino core and standard SDK components

---

## Hardware Required

| Component | Notes |
|---|---|
| ESP32-S3 Dev Board | Any ESP32-S3 with at least 8 MB flash; tested with 16 MB models |
| INMP441 I2S Microphone | 24-bit digital microphone module |
| Breadboard & jumper wires | For prototyping |

> The INMP441 is powered from 3.3 V (not 5 V). Its data pin is not 5 V tolerant.

### Wiring

| INMP441 Pin | ESP32-S3 Pin |
|---|---|
| VDD | 3V3 |
| GND | GND |
| L/R | GND (left channel) |
| SD | GPIO 4 |
| SCK | GPIO 5 |
| WS | GPIO 6 |

The BOOT button on the ESP32-S3 board is wired to GPIO 0 and is used as the record trigger (active LOW). No additional button is required.

---

## Software Requirements

- [Arduino IDE](https://www.arduino.cc/en/software) **or** [Arduino CLI](https://arduino.github.io/arduino-cli/) (see [Development](#development))
- **ESP32 boards package v3.3.11** — install via Boards Manager (`Tools → Board → Boards Manager`, search "esp32"). Earlier 2.x cores lack `ESP_I2S.h` and will not compile this firmware.
- A free [Groq Console](https://console.groq.com) account and API key

---

## Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/lookymlive/esp32-groq-speech-to-text.git
   cd esp32-groq-speech-to-text
   ```

2. **Get a Groq API key**
   - Sign up at [console.groq.com](https://console.groq.com)
   - Create an API key from the dashboard

3. **Configure Wi-Fi and API credentials**
   - Open `Code/secrets.h`
   - Fill in your Wi-Fi SSID, password, and Groq API key:
   ```cpp
   #define WIFI_SSID       "your_wifi_ssid"
   #define WIFI_PASSWORD   "your_wifi_password"
   #define GROQ_API_KEY    "gsk_your_key_here"
   ```

4. **Install the ESP32 board package**
   - In Arduino IDE: `File → Preferences`, add the board URL if not already present:
     ```
     https://espressif.github.io/arduino-esp32/package_esp32_index.json
     ```
   - `Tools → Board → Boards Manager → esp32` and install **v3.3.11**

5. **Select board settings**
   - **Board:** ESP32S3 Dev Module
   - **PSRAM:** Disabled — with PSRAM enabled, the I2S driver allocates its channel object in PSRAM where the GDMA engine cannot access it, causing `I2S INIT FAILED`
   - **USB CDC On Boot:** Disabled for boards with a CP2102/CH340 USB-UART bridge; Enabled for the S3 native USB port

6. **Wire the INMP441** to the ESP32-S3 as shown in the table above.

7. **Upload** the sketch (`Code/Code.ino`) to your board.

8. **Open the Serial Monitor** at 115200 baud. Hold the BOOT button and speak, then release. The transcript will appear:
   ```
   [wifi] 192.168.1.10  rssi -52
   Hold BOOT and talk, release when done.
   [rec] listening...
   [rec] 49152 bytes, 2.4 s, peak 4281
   [stt] 712 ms
   -------------------------------------------
   You said: hello world
   -------------------------------------------
   ```

---

## Development

Arduino CLI and a Makefile are provided for streamlined development.

### Using Arduino CLI

```bash
# Compile
arduino-cli compile --fqbn esp32:esp32:esp32s3 Code/Code.ino

# Flash to board
arduino-cli upload --fqbn esp32:esp32:esp32s3 Code/Code.ino --port <PORT>

# Open serial monitor
arduino-cli monitor -p <PORT> -b 115200
```

### Using the Makefile

```bash
make deps            # install Python dependencies
make build           # compile with Arduino CLI
make flash           # compile and upload
make monitor         # open serial monitor
make flash-monitor   # upload then open monitor
make format          # format source code (clang-format)
make clean           # remove build artifacts
make version         # print firmware version
```

### Managing Credentials

Edit `Code/secrets.h` with your Wi-Fi and Groq credentials. The file ships as a template with placeholder values.

See [docs/03-configuration.md](docs/03-configuration.md) for details.

---

## How It Works

The firmware sends audio to the Groq Whisper endpoint via a multipart HTTP request:

```
POST /openai/v1/audio/transcriptions
Host: api.groq.com
Authorization: Bearer <API_KEY>
Content-Type: multipart/form-data; boundary=<BOUNDARY>
Transfer-Encoding: chunked
```

Key design choices:

- **WAV header with unknown length** — a standard 44-byte RIFF/WAVE header is sent first, with the data-length fields set to `0xFFFFFFFF`. Groq accepts this, which allows the audio to be streamed rather than buffered entirely in memory.
- **Chunked request body** — each audio chunk is wrapped in an HTTP chunked-encoding frame (`HEX-length CRLF data CRLF`), so the total content length does not need to be known in advance.
- **Persistent connection** — `ensureLink()` opens the TLS socket while the device is idle, so the ~1 s handshake cost does not add to the per-utterance latency.
- **Signal validation** — if the peak sample magnitude is below `SILENCE_PEAK` (300), the recording is discarded locally to avoid wasting API calls on empty clips.

See [`docs/`](docs/) for detailed step-by-step guides.

---

## Project Structure

```
esp32-groq-speech-to-text/
├── Code/
│   ├── Code.ino        # Main firmware sketch
│   ├── secrets.h       # Wi-Fi and API credentials (edit before use)
│   └── version.h       # Firmware version metadata
├── docs/               # Step-by-step documentation
│   ├── README.md       # Documentation index
│   ├── 01-setup.md     # Arduino IDE & board package setup
│   ├── 02-wiring.md    # INMP441 ↔ ESP32-S3 wiring guide
│   ├── 03-configuration.md  # Credentials setup (secrets.h)
│   ├── 04-usage.md     # Upload and test
│   ├── 05-troubleshooting.md  # Common issues
│   ├── 06-api-reference.md   # Firmware function reference
│   ├── 07-architecture.md  # Data flow and design decisions
│   ├── 08-faq.md       # Frequently asked questions
│   └── bom.md          # Bill of materials with purchase links
├── .github/
│   └── workflows/
│       └── build.yml   # CI: validate build on every push/PR
├── .env.example        # Environment variables template
├── .gitattributes
├── .gitignore
├── CONTRIBUTING.md     # How to contribute
├── Makefile            # Development shortcuts (build, flash, monitor)
├── platformio.ini      # PlatformIO configuration (experimental; Arduino CLI recommended)
└── README.md
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development and contribution guidelines.

---

## Pricing & Limits

Groq's Speech-to-Text API is free to use within rate limits. Current limits and pricing are available on the [Groq Console](https://console.groq.com) and [Pricing page](https://groq.com/pricing).

---

## License

MIT
