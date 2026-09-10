# Speech-to-Text Service Comparison

> Last updated: 2026-09-10

A comparison of cloud speech-to-text services that could be used with the ESP32-S3 firmware.

## Feature Matrix

| Provider | API Latency | Free Tier | Language Support | Notes |
|---|---|---|---|---|
| **Groq** | ~0.5–1.0 s | Yes | 50+ languages | **Used by this project.** LPU-based inference is the fastest. |
| **OpenAI** | ~2–5 s | Yes (limited) | Many | Reliable but slower. Whisper models. |
| **Google Cloud STT** | ~1–3 s | Yes | Many | High accuracy but complex pricing. |
| **AWS Transcribe** | ~3–6 s | Yes (12 months) | Many | Part of AWS ecosystem. |
| **Azure Speech** | ~2–4 s | Yes | Many | Part of Azure ecosystem. |

## Why Groq?

| Criterion | Groq | Alternatives |
|---|---|---|
| **Speed** | ~500–700 ms typical | 2–6 s |
| **Free tier** | 450 API calls / day | Varies |
| **Setup complexity** | API key only | OAuth / IAM roles possible |
| **Pricing transparency** | $0 for free tier | More complex pricing models |
| **Streaming support** | Via chunked upload | Varies |

## How to Switch Providers

The firmware sends a standard multipart HTTP request to an OpenAI-compatible endpoint. To switch services:

1. **Change `GROQ_HOST`** in `Code/Code.ino`:
   ```cpp
   #define GROQ_HOST     "api.openai.com"
   #define STT_MODEL     "whisper-1"
   ```

2. **Update the API key** in `secrets.h`.

3. **Update the endpoint path** if different from `/openai/v1/audio/transcriptions`.

> The exact endpoint path and authentication method vary by provider. The current implementation uses Bearer token auth and the `/openai/v1/audio/transcriptions` path, which works for both Groq and OpenAI.

---

[← Back to docs index](README.md)
