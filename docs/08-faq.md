# Frequently Asked Questions

> Last updated: 2026-09-10

## General

### Is this project free to use?

Yes. Groq's Speech-to-Text API is free within rate limits. See the [Groq Pricing page](https://groq.com/pricing) for details.

### What chip architectures are supported?

This firmware is written for the **ESP32-S3** with the **Espressif Arduino core v3.3.11+**. It uses the `ESP_I2S.h` driver, which is not available on ESP32-S2, ESP32-C3, or older ESP32-S3 cores (v2.x).

### Why not use the Google Speech-to-Text or OpenAI API?

Groq's LPU-based inference returns results in under a second, which makes the experience feel near real-time. Other cloud STT providers typically add 2–5 seconds of latency.

---

## Setup

### Can I use Arduino CLI instead of the Arduino IDE?

Yes. The firmware can be built with Arduino CLI as well. Install Arduino CLI, add the ESP32 board package, and run:

```bash
arduino-cli core install esp32:esp32
arduino-cli compile --fqbn esp32:esp32:esp32s3 Code/Code.ino --upload
```

See [docs/01-setup.md](01-setup.md) for the full setup guide.

### Do I need to install any external libraries?

No. All required components (`WiFi.h`, `WiFiClientSecure.h`, `ESP_I2S.h`) ship with the ESP32 board package. No external Arduino libraries are needed.

### Why is my PSRAM setting important?

With PSRAM **enabled**, the I2S driver allocates its channel object in PSRAM. The ESP32's GDMA engine cannot access PSRAM, causing `I2S INIT FAILED`. **Disable PSRAM** in the Tools menu.

---

## Audio Quality

### My transcription is inaccurate or garbled. What should I check?

1. **VDD on 3V3** — connecting the INMP441 to 5 V can damage it.
2. **L/R pin to GND** — this selects the left channel. If floating, you may get no signal.
3. **Wiring** — verify SD→GPIO4, SCK→GPIO5, WS→GPIO6.
4. **Speak clearly** — the firmware has a 300 ms minimum recording threshold. Hold the button long enough.
5. **Sample rate** — the WAV header says 16 kHz. Don't change `SAMPLE_RATE` without also changing the code.

### The transcript says "Thank you." when I didn't say anything.

This is expected. Whisper generates polite default transcripts for silent audio rather than returning an error. The firmware includes `SILENCE_PEAK` detection to catch this — if your signal is below the threshold, check your wiring. See [docs/05-troubleshooting.md](05-troubleshooting.md).

### Can I adjust the recording length?

Yes. Edit `MAX_SECONDS` in `Code/Code.ino`. The default is 15 seconds.

---

## Network & API

### How do I get a Groq API key?

1. Sign up at [console.groq.com](https://console.groq.com).
2. Go to **API Keys**.
3. Click **Create API Key**.
4. Paste it into `Code/secrets.h` as `GROQ_API_KEY`.

### What model does this use?

`whisper-large-v3-turbo` — Groq's fastest transcription model. It returns results in ~0.5–1 second.

### What happens if I hit rate limits?

You will see `[stt] HTTP 429 (rate limited, wait for the reset)`. Your free tier resets periodically. Check your usage limits on the [Groq Console](https://console.groq.com).

### Does this work offline?

No. The audio is streamed to Groq's cloud API for processing. There is no on-device speech recognition.

---

## Development

### Can I use an INMP443 or SPH0415 instead of INMP441?

The firmware is calibrated for the INMP441's pinout and timing. Other I2S mics may work with pin reassignment, but audio quality is not guaranteed.

### Can I change the GPIO pins?

Yes. Update `PIN_MIC_SD`, `PIN_MIC_SCK`, `PIN_MIC_WS`, and `PIN_BUTTON` in `Code/Code.ino`. Note that the BOOT button is tied to GPIO 0; if you change `PIN_BUTTON`, you'll need an external button.

### Where are my credentials stored?

In `Code/secrets.h`. This file is **not** the place for production secrets. If you fork this repo, add `Code/secrets.h` to `.gitignore` and distribute `secrets.h.example` instead.

### Can I use VS Code instead of the Arduino IDE?

Yes. Install the Arduino extension for VS Code and open this folder. See [docs/vscode-setup.md](vscode-setup.md) for detailed setup.

### How do I use the Makefile?

The Makefile wraps common Arduino CLI commands. Run `make help` to see all targets:

```bash
make build         # compile
make flash         # upload to board
make monitor       # serial monitor
make flash-monitor # upload then monitor
make clean         # remove build artifacts
make format        # format source (clang-format)
make version       # print firmware version
```

### How do I check the firmware version?

The firmware version is printed on startup:
```
SpeechToText - Groq Whisper
v1.0.0 (Sep  9 2026)
```

You can also check it without hardware:
```bash
make version
```

### Does CI build the firmware?

A GitHub Actions workflow (`.github/workflows/build.yml`) compiles the firmware using Arduino CLI on every push and pull request to `main`. Check the **Actions** tab on GitHub for build status.

---

[Return to docs index](README.md)
