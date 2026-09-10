# Glossary

> Last updated: 2026-09-10

| Term | Definition |
|---|---|
| **API key** | Authentication credential for the Groq API. Always starts with `gsk_`. |
| **Chunked transfer encoding** | HTTP transfer mode where data is sent in chunks of known size, eliminating the need to know the total content length in advance. Used by this firmware to stream audio. |
| **DC offset** | A constant voltage offset in the microphone output that shifts the signal away from zero. The INMP441 has significant DC offset that must be filtered. |
| **GPIO** | General-purpose input/output pin on the ESP32-S3. |
| **Groq** | Cloud AI platform using custom LPUs (Language Processing Units) for fast inference. |
| **High-pass filter (HPF)** | A digital filter that removes frequencies below a cutoff, used here to eliminate DC offset and low-frequency rumble. |
| **I2S** | Integrated Interchip Sound bus — a protocol for digital audio transfer between integrated circuits. The INMP441 communicates via I2S. |
| **L/R pin** | On the INMP441, selects left (GND) or right (VDD) audio channel. |
| **MIC_GAIN** | Digital amplification factor (×8) applied to the filtered audio signal. |
| **PCM** | Pulse-code modulation — the digital representation of analog audio as a stream of sample values. |
| **PSRAM** | Pseudo-static RAM, additional external memory. Must be disabled for I2S to work on ESP32-S3. |
| **Pre-warm** | Strategy of opening a network connection during idle time to reduce latency on the next request. |
| **Rumble** | Low-frequency mechanical noise from the microphone or environment, typically below 120 Hz. |
| **SAMPLE_RATE** | The audio sampling frequency: 16,000 samples per second (16 kHz), which is Whisper's native rate. |
| **Silence peak** | Threshold (300) below which a recording is considered silent and discarded. |
| **TLS handshake** | The cryptographic negotiation that establishes a secure HTTPS connection. Takes ~1 second to Groq's servers. |
| **WAV header** | 44-byte metadata block at the start of a WAV audio file, containing format, rate, and size information. |
| **Whisper** | Open AI model for automatic speech recognition. `whisper-large-v3-turbo` is used via the Groq API. |

---

[← Back to docs index](README.md)
