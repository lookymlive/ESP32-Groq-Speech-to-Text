# Project Roadmap

> Last updated: 2026-09-10

Planned improvements and future directions for the ESP32-S3 Groq Speech-to-Text project.

## Short Term (Next Release)

- [ ] **Multi-language support** — Allow configuring the `language` parameter passed to Whisper (currently hardcoded to `en`)
- [ ] **Configurable model** — Allow selecting between `whisper-large-v3-turbo`, `whisper-large-v3`, and `distil-whisper` via `secrets.h`
- [ ] **OTA updates** — Integrate ArduinoOTA for wireless firmware updates
- [ ] **Status LED** — Use a GPIO to drive an LED that indicates recording status
- [ ] **Audio feedback** — Optional tone on key events (recording start/stop)

## Medium Term

- [ ] **On-device VAD** — Implement a voice activity detector on the ESP32-S3 so recording auto-starts without a button press
- [ ] **ESP-IDF port** — Port the firmware to the native ESP-IDF for reduced overhead
- [ ] **Local STT option** — Add optional local recognition using TensorFlow Lite Micro as a fallback when cloud is unavailable
- [ ] **Bluetooth microphone support** — Stream audio from a BLE microphone

## Long Term

- [ ] **Wake word** — Always-listening wake word detection (e.g., "Hey ESP") before initiating cloud transcription
- [ ] **Text-to-speech response** — Add a speaker for spoken confirmations
- [ ] **Web UI** — Stream transcriptions to a local web dashboard
- [ ] **Edge Impulse pipeline** — Use Edge Impulse for audio preprocessing before upload

## Completed

- [x] Initial ESP32-S3 + INMP441 + Groq integration
- [x] High-pass filter for DC offset removal
- [x] Pre-warmed TLS connection
- [x] Chunked audio streaming
- [x] PlatformIO + Arduino IDE support
- [x] Comprehensive documentation suite
- [x] CI build validation
- [x] Makefile and VS Code development tools

---

[← Back to docs index](README.md)
