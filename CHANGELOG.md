# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- High-pass filter to remove DC offset and low-frequency rumble from INMP441
- Digital gain amplification after filtering
- Silence detection to reject empty recordings
- Pre-warmed TLS connection to reduce per-utterance latency
- HTTP chunked transfer encoding for streaming audio
- WAV header with unknown-length support for live streaming

### Changed
- Renamed credential constants from `SEED_*` to `WIFI_SSID`/`GROQ_API_KEY`

## [1.0.0] - 2026-09-09

### Added
- Initial ESP32-S3 + INMP441 + Groq Whisper integration
- Real-time speech-to-text via BOOT button trigger
- Support for Arduino IDE and PlatformIO
- Comprehensive documentation suite
- GitHub Actions CI workflow
- BOM with component purchase links
- Makefile for development automation
