# Performance Characteristics

> Last updated: 2026-09-10

Measured metrics for the ESP32-S3 Groq Speech-to-Text firmware.

## Latency Breakdown

| Stage | Typical Duration | Notes |
|---|---|---|
| Button press to recording start | < 1 ms | I2S runs continuously; button only gates sending |
| TLS handshake (idle pre-warm) | ~1000 ms | Done in background; not part of per-utterance latency |
| Audio capture (2 s utterance) | 2000 ms | User-determined |
| Audio upload streaming | ~300 ms | 16 kHz 16-bit mono, chunked |
| Groq API processing | ~500–700 ms | whisper-large-v3-turbo |
| HTTP response download | ~50 ms | Response is short text |
| **Total user-perceived latency** | **~800 ms – 1.2 s** | From button release to transcript |

## Memory Usage

| Component | Memory | Notes |
|---|---|---|
| I2S DMA buffers | ~4 KB | 2 × 1024-byte buffers |
| Audio sample buffer | 1 KB | 1024-byte working buffer |
| WAV header | 44 B | Static |
| TLS connection | ~20 KB | WiFiClientSecure |
| HTTP chunked buffers | ~512 B | sendChunk / readLine |
| Arduino framework overhead | ~30–50 KB | Depends on features enabled |
| **Total active RAM** | **~60–80 KB** | Well within ESP32-S3's 512 KB SRAM |

## Flash Usage

| Section | Size |
|---|---|
| Sketch | ~350 KB |
| Required for compilation | 8 MB flash minimum recommended |

## Accuracy Metrics

| Metric | Value | Notes |
|---|---|---|
| Input sample rate | 16 kHz | Matches Whisper's training data |
| Audio bit depth | 16-bit | After I2S 32→16 transform |
| Channels | 1 (mono) | INMP441 L/R tied to GND |
| High-pass filter | 120 Hz, 2-pole | -26 dB headroom gain |
| Digital gain | ×8 | Applied after filtering |
| Silence threshold | 300 (peak) | Below = clip rejected |

## Groq API Characteristics

| Property | Value |
|---|---|
| Model | `whisper-large-v3-turbo` |
| Endpoint | `api.groq.com/openai/v1/audio/transcriptions` |
| Protocol | HTTPS / TLS 1.3 |
| Response format | `text` (plain string) |
| Free tier | Yes, with rate limits |

---

[← Back to docs index](README.md)
