# ESP32-S3 Groq Speech-to-Text

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

- [Arduino IDE](https://www.arduino.cc/en/software) (or [PlatformIO](https://platformio.org/))
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
│   └── secrets.h       # Wi-Fi and API credentials (edit before use)
├── docs/               # Step-by-step documentation
│   └── ...
├── .gitattributes
└── README.md
```

---

## Pricing & Limits

Groq's Speech-to-Text API is free to use within rate limits. Current limits and pricing are available on the [Groq Console](https://console.groq.com) and [Pricing page](https://groq.com/pricing).

---

## License

MIT
